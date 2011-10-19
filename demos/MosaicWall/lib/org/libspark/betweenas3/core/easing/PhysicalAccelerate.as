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
	 * Physical.accelerate
	 * 
	 * @author	yossy:beinteractive
	 */
	public class PhysicalAccelerate implements IPhysicalEasing
	{
		public function PhysicalAccelerate(iv:Number, a:Number, fps:Number)
		{
			_iv = iv;
			_a = a;
			_fps = fps;
		}
		
		private var _iv:Number;
		private var _a:Number;
		private var _fps:Number;
		
		/**
		 * @inheritDoc
		 */
		public function getDuration(b:Number, c:Number):Number
		{
			var iv:Number = c < 0 ? -_iv : _iv;
			var a:Number = c < 0 ? -_a : _a;
			return ((-iv + Math.sqrt(iv * iv - 4 * (a / 2.0) * -c)) / (2 * (a / 2.0))) * (1.0 / _fps);
		}
		
		/**
		 * @inheritDoc
		 */
		public function calculate(t:Number, b:Number, c:Number):Number
		{
			var f:Number = c < 0 ? -1 : 1;
			var n:Number = t / (1.0 / _fps);
			return b + (f * _iv) * n + ((f * _a) * n) * n / 2.0;
		}
	}
}