/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * Licensed under MIT License:
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.pyco.tagcloud {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * From http://plindenbaum.blogspot.com/2010/10/playing-with-worldle-algorithm-tag.html
	 * Single loop Wordle
	 * 
	 * @author Thanh Tran - trongthanh@gmail.com
	 * @contributor Thu Hoang - tinygirl0702@gmail.com
	 */
	public class Wordle extends Sprite {
		
		private var biggestSize: uint = 100;
		private var smallestSize: uint = 20;
		private var words: Vector.<Word> = new Vector.<Word>();
		private var fontFamily: String = "ArialRegular";
		private var dRadius: Number = 10.0;
		private var dDeg: int = 10;
		private var pixelPerfect: Boolean = false;
		private var doSortType: int = -1;
		private var allowRotate: Boolean = true;

		public function Wordle() {
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
		}
		
		private function addToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			CollisionDetection.registerStage(stage);
			SkyCollisionDetection.registerRoot(this);
			SkyCollisionDetection.setAlphaTolerance(0);
		}

		public function doLayout(): void {
			if (this.words.length <= 0) { return;}
			
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
					//shuffle array:
					for (var k:uint = 0; k < words.length; k++) {
					   var rand:uint = int(Math.random() * words.length);
					   words.push( words.splice( rand, 1 )[0] );
					}
					break;
					
				}
			//trace( "words : " + words );
			var first: Word = this.words[0];
			var high: Number = - Number.MAX_VALUE;
			var low: Number = Number.MAX_VALUE;
			var w: Word;
			var wl: uint = words.length;
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
				addChild(w.sprite);
			}

			//first point
			var center: Point = new Point(0,0);

			for (i = 1; i < wl;++i) {
				var current: Word = this.words[i];
				//calculate current center
				center.x=0;
				center.y=0;
				var totalWeight: uint = 0.0;
				var prev: int;
				//below is almost 1-1 conversion from the Java class. I don't quite understand it for now.
				for (prev = 0; prev < i;++prev) {
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
					
					var startDeg: int = getRandomInt(0, 359);
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
						for(prev=0;prev< i;++prev) {
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
						if (prev == i) {
							current.bounds = candidateBounds;
							current.sprite.x = candidateBounds.centerX;
							current.sprite.y = candidateBounds.centerY;
							
							done=true;
							break;
						}
					}
					radius+=this.dRadius;
				}
			}
			
			//final touch AND/OR debug (if any)
			for (i = 0; i < wl; i++) {
				//w = words[i];
				//addChild(w.sprite);
				//debug bounds:
				//drawBound(w);
			}
		}
		
		private function drawBound(w: Word):void {
			var g: Graphics = this.graphics;
			g.lineStyle(1, w.stroke, 1);
			g.drawRect(w.bounds.x, w.bounds.y, w.bounds.width, w.bounds.height);
		}

		/**
		 * Create a list of random word (with random text) 
		 */
		public function generateRandomWords(maximum: uint = 100): void {
			for(var i: int = 0; i < maximum; ++i) {
				var n: int = getRandomInt(3,10);
				var text: String = getRandomString(n);
				
				var w: Word = new Word(text, getRandomInt(10, 100049));
				w.url = "http://www.google.com";
				w.stroke = getRandomColor(0,180);
				w.title = ""+i;

				if (Math.random() < 0.5) {
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
				w.stroke = getRandomColor(0,128);
				w.title = ""+i;

				if (Math.random() < 0.5) {
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
		
		//utility functions
		
		public function getRandomInt(min:int, max:int):int {
			return min + int(Math.random() * (max - min + 1));
		}
		
		public function getRandomColor(min: uint = 0, max: uint = 255): uint {			
			var r: uint = getRandomInt(min, max);
			var g: uint = getRandomInt(min, max);
			var b: uint = getRandomInt(min, max);
			
			return ((r << 16) | (g << 8) | b);
		}
		
		public function getRandomString(len: int):String {
			if (len == 0 || isNaN(len)) len = 8;
			var s:String = "";
			for (var i: int = 1; i <= len; i++) {
				var c:Number = getRandomInt(0, 2); //0: number, 1: upper case, 2: lower case
				switch (c) {
					case 0: s+= String.fromCharCode(getRandomInt(48, 57)); break;
					case 1: s+= String.fromCharCode(getRandomInt(65, 90)); break;
					case 2: s+= String.fromCharCode(getRandomInt(97, 122)); break;
				}
			}
			//trace("random String: " + s);
			return s;		
		}
		
		
	}

}