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
	import flash.geom.Rectangle;
	
	/**
	 * Extends the Rectangle class to support new getters
	 * @author Thanh Tran
	 */
	public class WordleRectangle extends Rectangle {
		
		public function WordleRectangle(x: Number = 0, y: Number = 0, width: Number = 0, height: Number = 0) {
			super(x, y, width, height);
		}
		
		/**
		 * Returns the X coordinate of the center point of the rectangle
		 * @return x coordinate of center
		 */
		public function get centerX(): Number {
			return x + width / 2;
		}
		
		/**
		 * Returns the Y coordinate of the center point of the rectangle
		 * @return y coordinate of center
		 */
		public function get centerY(): Number {
			return y + height / 2;
		}
		
		public static function createFromRect(rect: Rectangle): WordleRectangle {			
			return new WordleRectangle(rect.x, rect.y, rect.width, rect.height);
		}
		
	}

}