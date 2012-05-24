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
package org.libspark.betweenas3.easing
{
	import org.libspark.betweenas3.core.easing.IPhysicalEasing;
	import org.libspark.betweenas3.core.easing.PhysicalAccelerate;
	import org.libspark.betweenas3.core.easing.PhysicalExponential;
	import org.libspark.betweenas3.core.easing.PhysicalUniform;
	
	/**
	 * Physical.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class Physical
	{
		private static var _defaultFrameRate:Number = 30.0;
		
		/**
		 * 物理的なイージングで使用するデフォルトのフレームレートを設定します.
		 */
		public static function get defaultFrameRate():Number
		{
			return _defaultFrameRate;
		}
		
		/**
		 * @private
		 */
		public static function set defaultFrameRate(value:Number):void
		{
			_defaultFrameRate = value;
		}
		
		public static function uniform(velocity:Number = 10.0, frameRate:Number = NaN):IPhysicalEasing
		{
			return new PhysicalUniform(velocity, isNaN(frameRate) ? _defaultFrameRate : frameRate);
		}
		
		public static function accelerate(acceleration:Number = 1.0, initialVelocity:Number = 0.0, frameRate:Number = NaN):IPhysicalEasing
		{
			return new PhysicalAccelerate(initialVelocity, acceleration, isNaN(frameRate) ? _defaultFrameRate : frameRate);
		}
		
		public static function exponential(factor:Number = 0.2, threshold:Number = 0.0001, frameRate:Number = NaN):IPhysicalEasing
		{
			return new PhysicalExponential(factor, threshold, isNaN(frameRate) ? _defaultFrameRate : frameRate);
		}
	}
}