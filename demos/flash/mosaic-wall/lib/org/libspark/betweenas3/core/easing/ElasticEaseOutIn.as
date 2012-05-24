/*
 * BetweenAS3
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 BeInteractive! (www.be-interactive.org) and
 *                    Spark project  (www.libspark.org)
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
 * 
 */
package org.libspark.betweenas3.core.easing
{
	/**
	 * Elastic.easeOutIn.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class ElasticEaseOutIn implements IEasing
	{
		/**
		 * 
		 * @param	a	Specifies the amplitude of the sine wave.
		 * @param	p	Specifies the period of the sine wave.
		 */
		public function ElasticEaseOutIn(a:Number = 0, p:Number = 0)
		{
			this.a = a;
			this.p = p;
		}
		
		public var a:Number;
		public var p:Number;
		
		/**
		 * @inheritDoc
		 */
		public function calculate(t:Number, b:Number, c:Number, d:Number):Number
		{
			var s:Number;
			
			c /= 2;
			
			if (t < d / 2) {
				if ((t *= 2) == 0) {
					return b;
				}
				if ((t /= d) == 1) {
					return b + c;
				}
				if (!p) {
					p = d * 0.3;
				}
				if (!a || a < Math.abs(c)) {
					a = c;
					s = p / 4;
				}
				else {
					s = p / (2 * Math.PI) * Math.asin(c / a);
				}
				return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
			}
			else {
				if ((t = t * 2 - d) == 0) {
					return (b + c);
				}
				if ((t /= d) == 1) {
					return (b + c) + c;
				}
				if (!p) {
					p = d * 0.3;
				}
				if (!a || a < Math.abs(c)) {
					a = c;
					s = p / 4;
				}
				else {
					s = p / (2 * Math.PI) * Math.asin(c / a);
				}
				return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + (b + c);
			}
		}
	}
}