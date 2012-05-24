/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.thanhtran.tet2010.view {
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * Grid that contains thumbs, it is treated like a progress bar
	 * @author Thanh Tran
	 */
	public class ThumbGrid extends Sprite {
		public static const COLS: int = 20;
		
		public var thumbsHolderLayer: Sprite;
		
		public var gridWidth: int;
		public var gridHeight: int;
		
		public var userList: Array;
		public var thumbList: Array;
		
		private var thumbX: int;
		private var thumbY: int;
		private var currentIndex: int;
		private var targetIndex: int; // the target thumb index to show up to
		private var len: int;
		private var loadedThumbs: int;
		private var playing: Boolean;
		
		public function ThumbGrid(userList: Array) {
			this.userList = userList;
			len = userList.length;
			
			thumbsHolderLayer = new Sprite();
			addChild(thumbsHolderLayer);
			
			gridWidth = ThumbImage.WIDTH * COLS;
			gridHeight = Math.ceil(len / COLS) * ThumbImage.HEIGHT;
			
			var xPos: int = - gridWidth / 2;
			var yPos: int = - gridHeight / 2;
			var g: Graphics = thumbsHolderLayer.graphics;
			g.lineStyle(1, 0x333333, 1);
			
			for (var i:int = 0; i < len; i++) {				
				drawThumbHolder(g, xPos, yPos, ThumbImage.WIDTH, ThumbImage.HEIGHT);
				xPos += ThumbImage.WIDTH;
				if (xPos > (gridWidth / 2 - ThumbImage.WIDTH)) {
					xPos = - gridWidth / 2;
					yPos += ThumbImage.HEIGHT;
				}
			}
			
			thumbX = - gridWidth / 2 + ThumbImage.WIDTH / 2;
			thumbY = - gridHeight / 2 + ThumbImage.HEIGHT / 2;
		}
		
		public function startLoad(): void {
			currentIndex = 0;
			targetIndex = 0;
			loadedThumbs = 0;
			thumbList = [];
			if (len) loadSingleThumb();
		}
		
		private function loadSingleThumb(): void {
			var thumb: ThumbImage = new ThumbImage();
			thumb.addEventListener(Event.COMPLETE, thumbLoadHandler);
			thumb.load(userList[loadedThumbs]);
		}
		
		private function thumbLoadHandler(event: Event): void {
			var thumb: ThumbImage = event.target as ThumbImage;
			thumb.x = thumbX;
			thumb.y = thumbY;
			thumbList[loadedThumbs] = thumb;
			//
			//showThumb(currentIndex);
			
			thumbX += ThumbImage.WIDTH;
			if (thumbX > (gridWidth - ThumbImage.WIDTH) / 2) {
				thumbX = - gridWidth / 2 + ThumbImage.WIDTH / 2;
				thumbY += ThumbImage.HEIGHT;
			}
			//trace( "currentIndex : " + currentIndex );
			loadedThumbs ++;
			if (loadedThumbs < len) {
				loadSingleThumb();
			}
			
			showThumb();
		}
		
		private function showThumb(): void {
			if (currentIndex < loadedThumbs && currentIndex <= targetIndex) {
				//trace( "currentIndex : " + currentIndex );
				var thumb: ThumbImage = thumbList[currentIndex];
				if (thumb) {
					this.addChild(thumb);
					playing = true;
					TweenLite.from(thumb, 0.5, {/*scaleX: 1.5, scaleY: 1.5,*/alpha: 0, onComplete: showThumbCompleteHandler } );
					currentIndex ++;
				}
			}
		}
		
		private function showThumbCompleteHandler():void {
			playing = false;
			if (currentIndex == len) {
				//load is totally completed
				TweenLite.to(this, 0.5, {onComplete: hideThumbs } ); //delay
			} else {
				showThumb();
			}
		}
		
		private function hideThumbs():void {
			removeChild(thumbsHolderLayer);
			var thumb: ThumbImage;
			for (var i:int = 0; i < len; i++) {
				thumb = thumbList[i];
				if (thumb) {
					TweenLite.to(thumb, 1.5, { x: 0, y: 0, scaleX: 0, scaleY: 0, 
										   ease: Back.easeIn, delay: Math.random() * 3, 
										   onStart: startFlyingHandler, onStartParams: [thumb]} );
				} else {
					trace("Warning: some thumb is null " + i);
				}
			}
			TweenLite.to(this, 5, {onComplete: completeHideThumb } ); //delay
		}
		
		private function completeHideThumb():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function startFlyingHandler(thumb: ThumbImage):void {
			this.setChildIndex(thumb, 0);
			
		}
		
		public function get percent(): int {
			return int(currentIndex / (len - 1)) * 100;
		}
		
		public function set percent(value: int): void {
			targetIndex = int((value / 100) * (len - 1));
			//trace( "targetIndex : " + targetIndex );
			showThumb();
		}
		
		/**
		 * Draw the frame of the thumb holder. Set lineStyle be for use.
		 * @param	g
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	l
		 */
		private function drawThumbHolder(g: Graphics, x: int, y: int, w: int, h: int, l: int = 5): void {
			//draw at top left 
			g.moveTo(x, y);
			g.lineTo(x, y + l);
			g.moveTo(x, y);
			g.lineTo(x + l, y);
			//draw at top right
			g.moveTo(x + w, y);
			g.lineTo(x + w, y + l);
			g.moveTo(x + w, y);
			g.lineTo(x + w - l, y);
			//draw at bottom right
			g.moveTo(x + w, y + h);
			g.lineTo(x + w - l, y + h);
			g.moveTo(x + w, y + h);
			g.lineTo(x + w, y + h - l);
			//draw at bottom left
			g.moveTo(x, y + h);
			g.lineTo(x + l, y + h);
			g.moveTo(x, y + h);
			g.lineTo(x, y + h - l);
		}
		
	}

}