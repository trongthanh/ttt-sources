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
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * Value object of a word
	 * @author Thanh Tran
	 */
	public class Word {
		public var fontFamily: String;
		public var fontSize: uint;
		public var weight: uint;
		public var text: String = "";
		public var fill: uint; //Color
		public var stroke: uint; //Color for now, use this stroke color only, may consider fill and stroke later
		public var title: String;
		public var url: String;
		
		public var sprite: Sprite;
		public var bounds: WordleRectangle = new WordleRectangle();
		private var isRotate: Boolean = false;

		public function Word(text: String, weight: uint) {
			this.text = text;
			this.weight = weight;
			if(this.weight<=0) throw new Error("bad weight "+weight);
		}
		
		/**
		 * Render the visual elements of this word
		 */
		public function render(allowRotate: Boolean): void {
			//
			var textFormat: TextFormat = new TextFormat(fontFamily, fontSize, stroke);
			var tf: TextField = new TextField();
			tf.embedFonts = true;
			tf.defaultTextFormat = textFormat;
			tf.autoSize = "left";
			tf.text = this.text;
			tf.selectable = false;
			
			var tx: Number = 0; //translate x;
			var ty: Number = 0; //translate y;
			
			if (allowRotate && Math.random() < 0.5) { // half chances of rotation
				this.isRotate = true;
				tf.rotation = 90;
				tf.x = tf.width / 2;
				tf.y = -tf.height / 2;
				tx = tf.x;
				ty = -tf.y;
			} else {
				this.isRotate = false;
				tf.x = -tf.width / 2;
				tf.y = -tf.height / 2;
				tx = -tf.x;
				ty = -tf.y;
			}
			
			var sprite: Sprite = new Sprite();
			sprite.addChild(tf);
			this.sprite = sprite;
			
			//get pixel perfect bounds
			var bm: BitmapData = new BitmapData(sprite.width, sprite.height, false);
			var matrix: Matrix = new Matrix();
			matrix.tx = tx;
			matrix.ty = ty;
			bm.draw(sprite, matrix);
			
			var textBounds: WordleRectangle = WordleRectangle.createFromRect(bm.getColorBoundsRect(0xFFFFFFFF, 0xFF000000 | this.stroke , true));
			/// Indeed make the 'tf' center the 'sprite'
			var xPos: Number = -textBounds.width / 2 - textBounds.x;
			var yPos: Number = -textBounds.height / 2 - textBounds.y;
			if (this.isRotate) {
				var left: Number = textBounds.x;
				var right: Number = tf.width - textBounds.x - textBounds.width;
				tf.x += (right - left) / 2;
			} else {
				tf.x = xPos;
			}
			tf.y = yPos;
			textBounds.x += xPos;
			textBounds.y += yPos;
			
			this.bounds = textBounds;
		}
		
		public function toString(): String {
			return text;
		}
	}

}