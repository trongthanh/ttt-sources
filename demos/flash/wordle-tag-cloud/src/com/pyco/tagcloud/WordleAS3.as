/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * All rights reserved.
 */
package com.pyco.tagcloud {
	import com.pyco.utils.ArrayUtil;
	import com.pyco.utils.Random;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.ISignalOwner;
	import org.osflash.signals.Signal;
	/**
	 * From http://plindenbaum.blogspot.com/2010/10/playing-with-worldle-algorithm-tag.html
	 * Threaded (AS3 adapted) Wordle
	 * 
	 * @author Thanh Tran
	 * @contributor Thu Hoang
	 */
	public class WordleAS3 extends Sprite {
		
		private var biggestSize: uint = 100;
		private var smallestSize: uint = 20;
		private var words: Vector.<Word> = new Vector.<Word>();
		private var fontFamily: String = "ArialRegular";
		private var dRadius: Number = 10.0;
		private var dDeg: int = 10;
		private var pixelPerfect: Boolean = false;
		private var doSortType: int = -1;
		private var allowRotate: Boolean = true;
		
		//newly promoted classes
		private var center:Point;
		private var current:Word;
		private var wl:uint;
		private var startTime: uint;
		private var runTime: int;
		private var curIdx: int;
		private var first:Word;
		private var completeHandler: Function;
		private var progressHandler: Function;
		
		private var _layoutProgress: ISignalOwner;
		private var _layoutComplete: ISignalOwner;

		public function WordleAS3() {
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			_layoutProgress = new Signal(Word);
			_layoutComplete = new Signal(int);
			
		}
		
		private function addToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			CollisionDetection.registerStage(stage);
			SkyCollisionDetection.registerRoot(this);
			SkyCollisionDetection.setAlphaTolerance(0);
		}

		public function doLayout(): void {
			if (this.words.length <= 0) {
				_layoutComplete.dispatch(0);
				return;
			}
			
			startTime = getTimer();
			
			/** sort from biggest to lowest */
			switch(doSortType) {
				case 1:
					words.sort(function(w1: Word, w2: Word): int {
						return w2.weight - w1.weight;
					});
					
					break;
					
				case 2:
					words.sort(function(w1: Word, w2: Word): int {
						return w1.weight - w2.weight;
					});
					
					break;
				case 3:
					words.sort(function(w1: Word, w2: Word): int {
						//sort by alphabet
						if (w1.text.toLowerCase() < w2.text.toLowerCase()) { 
							return -1; 
						} else if (w1.text.toLowerCase() > w2.text.toLowerCase()) { 
							return 1; 
						} else { 
							return 0; 
						}
					});
					
					break;
				default:
					ArrayUtil.shuffleVector(words);
					break;
					
				}
			//trace( "words : " + words );
			first = this.words[0];
			var high: Number = - Number.MAX_VALUE;
			var low: Number = Number.MAX_VALUE;
			var w: Word;
			wl = words.length;
			var i: int;
			
			for (i = 0; i < wl; i++) {
				w = words[i];
				//check for highest & lowest weight to scatter the font size accordingly
				high = (high > w.weight)? high : w.weight;
				low= (low < w.weight)? low : w.weight;
			}
			
			//render and add words to display list
			for (i = 0; i < wl; i++) {
				w = words[i];
				var fontSize: int = (((w.weight - low) / (high - low)) * (this.biggestSize-this.smallestSize)) + this.smallestSize;
				w.fontSize = fontSize;
				w.render(allowRotate);
				//sprites must be added to stage first in order to check for pixel perfect collision
				w.sprite.visible = false;
				addChild(w.sprite);
				
			}

			//start position
			center = new Point(0, 0);
			curIdx = 0;
			
			layoutNextWord();
			addEventListener(Event.ENTER_FRAME, layoutNextWord);
			
		}
		
		private function layoutNextWord(e: Event = null): void {
			if (curIdx >= wl) {
				//finish layout
				removeEventListener(Event.ENTER_FRAME, layoutNextWord);
				
				//final touch AND/OR debug (if any)
				for (var i: int = 0; i < wl; i++) {
					//w = words[i];
					//addChild(w.sprite);
					//debug bounds:
					//drawBound(w);
				}
				
				runTime = getTimer() - startTime;
				trace("run time: " + runTime);
				
				_layoutComplete.dispatch(runTime);
				
				return;
			}
			
			current = this.words[curIdx];
			//calculate current center
			center.x=0;
			center.y=0;
			var totalWeight: uint = 0.0;
			var prev: int;
			//NOT UNDERSTAND
			for (prev = 0; prev < curIdx;++prev) {
				var wPrev: Word = this.words[prev];
				center.x += wPrev.bounds.centerX * wPrev.weight;
				center.y += wPrev.bounds.centerY * wPrev.weight;
				totalWeight+=wPrev.weight;
			}
			center.x /= (totalWeight);
			center.y /= (totalWeight);
			//trace( "center : " + center );
			
			var bounds: WordleRectangle = current.bounds;
			var done: Boolean = false;
			var radius: Number = 0.5 * Math.min(first.bounds.width, first.bounds.height);
			
			var loopPrevent: uint = 0;
			
			while (!done) {
				loopPrevent ++;
				if (loopPrevent > 100000) {
					trace("maximum loop reach");
					break;
				}
				
				var startDeg: int = Random.getRandomInt(0, 359);
				//loop over spiral
				var prev_x: int = -1;
				var prev_y: int = -1;
				
				for(var deg: int = startDeg; deg < startDeg + 360; deg+= dDeg) {
					var rad: Number= (deg/Math.PI)*180.0;
					var cx: int=(center.x+radius*Math.cos(rad));
					var cy: int=(center.y+radius*Math.sin(rad));
					
					if(prev_x==cx && prev_y==cy) continue;
					
					prev_x = cx;
					prev_y = cy;
					//trace( "cx,cy : " + cx,cy );
					//test:
					//graphics.beginFill(0xFF0000, 0.5);
					//graphics.drawCircle(cx, cy, 0.5);

					var candidateBounds: WordleRectangle = new WordleRectangle (	
						current.bounds.x + cx,
						current.bounds.y + cy,
						current.bounds.width,
						current.bounds.height
					)
					
					if (pixelPerfect)	{
						current.sprite.x = candidateBounds.centerX;
						current.sprite.y = candidateBounds.centerY;
					}
					//any collision ?
					prev=0;
					for(prev=0;prev< curIdx;++prev) {
						if (pixelPerfect) {
							if (CollisionDetection.checkForCollision(current.sprite, words[prev].sprite)) {
							//if (SkyCollisionDetection.bitmapHitTest(current.sprite, words[prev].sprite)) {
								//trace( "current.sprite : " + current.sprite.x, current.sprite.y );
								break;
							}
						} else {
							if (candidateBounds.intersects(words[prev].bounds)) {
								break;
							}
						}
					}
					//no collision: we're done
					if (prev == curIdx) {
						current.bounds = candidateBounds;
						current.sprite.x = candidateBounds.centerX;
						current.sprite.y = candidateBounds.centerY;
						current.sprite.visible = true;
						done=true;
						break;
					}
				}
				radius+=this.dRadius;
			}
			_layoutProgress.dispatch(current);
			curIdx++;
		}
		
		private function drawBound(w: Word):void {
			var g: Graphics = this.graphics;
			g.lineStyle(1, w.stroke, 1);
			g.drawRect(w.bounds.x, w.bounds.y, w.bounds.width, w.bounds.height);
		}

		/**
		 * Create a random word (with random text) and push it to words list
		 */
		private function random(): void {
			for(var i: int = 0; i < 100; ++i) {
				var n: int = Random.getRandomInt(3,10);
				var text: String = Random.getRandomString(n);
				
				var w: Word = new Word(text, Random.getRandomInt(10, 100049));
				w.url = "http://www.google.com";
				w.stroke = Random.getRandomColor(0,255);
				w.title = ""+i;

				if (Random.getRandomBoolean()) {
					w.fontFamily = "ArialRegular";
				} else {
					w.fontFamily = "TimesRegular";
				}
				
				words.push(w);
			}
			//trace(words);
		}
		
		public function setWords(arr: Array, maxium: uint = 100): void {
			
			for (var i: int = 0; i < maxium; ++i) {
				var wordObject: Object = arr[i];
				if (i > maxium || !wordObject) {
					trace( "words limit : " + i );
					break;
				}
				
				//trace( "wordObject : " + wordObject.text, wordObject.count );
				
				var w: Word = new Word(wordObject.text, wordObject.count);
				w.url = "http://www.google.com";
				w.stroke = Random.getRandomColor(0,255);
				w.title = ""+i;

				if (Random.getRandomBoolean()) {
					w.fontFamily = "ArialRegular";
				} else {
					w.fontFamily = "TimesRegular";
				}
				
				words.push(w);
			}
			
			
		}
		
		public function reset(): void {
			this.graphics.clear();
			while (this.numChildren > 0) {
				this.removeChild(this.getChildAt(0));
			}
			words = new Vector.<Word>();
		}
		
		public function get layoutProgress(): ISignal {
			return _layoutProgress;
		}
		
		public function get layoutComplete(): ISignal {
			return _layoutComplete;
		}
		
	}

}