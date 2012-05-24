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
	 * Bounce.easeOutIn.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class BounceEaseOutIn implements IEasing
	{
		/**
		 * @inheritDoc
		 */
		public function calculate(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d / 2) {
				if ((t = (t * 2) / d) < (1 / 2.75)) {
					return (c / 2) * (7.5625 * t * t) + b;
				}
				if (t < (2 / 2.75)) {
					return (c / 2) * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
				}
				if (t < (2.5 / 2.75)) {
					return (c / 2) * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
				}
				return (c / 2) * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
			}
			else {
				if ((t = (d - (t * 2 - d)) / d) < (1 / 2.75)) {
					return (c / 2) - ((c / 2) * (7.5625 * t * t)) + (b + c / 2);
				}
				if (t < (2 / 2.75)) {
					return (c / 2) - ((c / 2) * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) + (b + c / 2);
				}
				if (t < (2.5 / 2.75)) {
					return (c / 2) - ((c / 2) * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) + (b + c / 2);
				}
				return (c / 2) - ((c / 2) * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) + (b + c / 2);
			}
		}
	}
}