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
	import org.libspark.betweenas3.core.easing.BackEaseIn;
	import org.libspark.betweenas3.core.easing.BackEaseInOut;
	import org.libspark.betweenas3.core.easing.BackEaseOut;
	import org.libspark.betweenas3.core.easing.BackEaseOutIn;
	import org.libspark.betweenas3.core.easing.IEasing;
	
	/**
	 * Back.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class Back
	{
		public static const easeIn:IEasing = new BackEaseIn();
		public static const easeOut:IEasing = new BackEaseOut();
		public static const easeInOut:IEasing = new BackEaseInOut();
		public static const easeOutIn:IEasing = new BackEaseOutIn();
		
		/**
		 * 
		 * @param	s	Specifies the amount of overshoot, where the higher the value, the greater the overshoot.
		 * @return	An easing with passed parameter.
		 */
		public static function easeInWith(s:Number = 1.70158):IEasing
		{
			return new BackEaseIn(s);
		}
		
		/**
		 * 
		 * @param	s	Specifies the amount of overshoot, where the higher the value, the greater the overshoot.
		 * @return	An easing with passed parameter.
		 */
		public static function easeOutWith(s:Number = 1.70158):IEasing
		{
			return new BackEaseOut(s);
		}
		
		/**
		 * 
		 * @param	s	Specifies the amount of overshoot, where the higher the value, the greater the overshoot.
		 * @return	An easing with passed parameter.
		 */
		public static function easeInOutWith(s:Number = 1.70158):IEasing
		{
			return new BackEaseInOut(s);
		}
		
		/**
		 * 
		 * @param	s	Specifies the amount of overshoot, where the higher the value, the greater the overshoot.
		 * @return	An easing with passed parameter.
		 */
		public static function easeOutInWith(s:Number = 1.70158):IEasing
		{
			return new BackEaseOutIn(s);
		}
	}
}