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
	 * Physical.uniform
	 * 
	 * @author	yossy:beinteractive
	 */
	public class PhysicalUniform implements IPhysicalEasing
	{
		public function PhysicalUniform(v:Number, fps:Number)
		{
			_v = v;
			_fps = fps;
		}
		
		private var _v:Number;
		private var _fps:Number;
		
		/**
		 * @inheritDoc
		 */
		public function getDuration(b:Number, c:Number):Number
		{
			return (c / (c < 0 ? -_v : _v)) * (1.0 / _fps);
		}
		
		/**
		 * @inheritDoc
		 */
		public function calculate(t:Number, b:Number, c:Number):Number
		{
			return b + (c < 0 ? -_v : _v) * (t / (1.0 / _fps));
		}
	}
}