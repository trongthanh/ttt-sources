/**
 * Copyright (c) 2010 trongthanh@gmail.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package {
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import org.thanhtran.tet2010.model.data.FriendListModel;
	import org.thanhtran.tet2010.model.DataLoader;
	import org.thanhtran.tet2010.view.ThumbGrid;
	import org.thanhtran.tet2010.view.ThumbImage;
	
	/**
	 * Part of the class is adapted from AppDocBase of PyCo Flash Framework
	 * 
	 * @author Thanh Tran, Tram Nguyen, Thu.Hoang
	 */
	public class AppDoc extends MovieClip {
		public static const DEFAULT_DATA_PATH: String = "xml/data.xml";
		
		public var main: DisplayObjectContainer;
		public var thumbsLayer: ThumbGrid;
		
		private var friendList: Array;
		private var numberOfFriends: int;
		private var dataLoader:DataLoader;
		
		public function AppDoc() {			
			stop(); //stop to prevent this movie clip enter frame 2 before it start loading progress
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			trace("progress start at: " + int(loaderInfo.bytesLoaded / loaderInfo.bytesTotal * 100));
			//initialize things up
			init();
		}
		
		private function stageResizeHandler(event: Event = null): void {
			if (thumbsLayer) {
				thumbsLayer.x = stage.stageWidth / 2;
				thumbsLayer.y = stage.stageHeight / 2;
			}
		}
		
		private function init(): void {
			// register required events
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loadData();
		}
		
		private function loadData():void {
			dataLoader = new DataLoader();
			dataLoader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			/*
			var xmlPath: String = loaderInfo.parameters["xmlPath"];
			if (!xmlPath) xmlPath = DEFAULT_DATA_PATH;
			dataLoader.load(xmlPath);
			*/
			dataLoader.parseData(FriendListModel.xml);
			
		}
		
		private function xmlLoadCompleteHandler(event: Event): void {
			if (dataLoader.success) {
				friendList = dataLoader.friendList;
				numberOfFriends = friendList.length;
				trace( "numberOfFriends : " + numberOfFriends );
				loadThumbs();
			} else {
				trace("Data load error: " + dataLoader.url);
			}
		}
		
		private function loadThumbs():void {
			thumbsLayer = new ThumbGrid(friendList);
			thumbsLayer.addEventListener(Event.COMPLETE, gridCompleteHandler);
			thumbsLayer.startLoad();
			
			stageResizeHandler();
			
			addChild(thumbsLayer);
		}
		
		private function gridCompleteHandler(event: Event): void {
			removeChild(thumbsLayer);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			main = new mainClass() as DisplayObjectContainer;
			addChildAt(main, 0);
			main["init"](thumbsLayer.thumbList);
		}
		
		/**
		 * This method is the handler of the loading progress event. It automaticaly calculate the percent and invoke updateProgress()
		 * @param	event
		 * @private
		 */
		protected function progressHandler(event: ProgressEvent = null): void {
			var min: Number = 0;
			var max: Number = 100;
			var percent: Number = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
			percent = min + (max - min) * percent;
			updateProgress(percent);
		}
		
		protected function updateProgress(percent: Number): void {
			//override to show preloader progress
			if (thumbsLayer) thumbsLayer.percent = percent;
		}
		
		/**
		 * This method is invoked recurrently to check current frame of this movie clip.
		 * @private
		 */
		protected function enterFrameHandler(event: Event): void {
			play();
			if (currentFrame == totalFrames) {
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				startup();
			}
		}
		
		protected function startup():void {
			stop(); //stop at frame 2
			progressHandler();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
	}

}