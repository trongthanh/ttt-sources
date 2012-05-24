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
	import org.libspark.betweenas3.core.easing.ElasticEaseIn;
	import org.libspark.betweenas3.core.easing.ElasticEaseInOut;
	import org.libspark.betweenas3.core.easing.ElasticEaseOut;
	import org.libspark.betweenas3.core.easing.ElasticEaseOutIn;
	import org.libspark.betweenas3.core.easing.IEasing;
	
	/**
	 * Elastic.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class Elastic
	{
		public static const easeIn:IEasing = new ElasticEaseIn();
		public static const easeOut:IEasing = new ElasticEaseOut();
		public static const easeInOut:IEasing = new ElasticEaseInOut();
		public static const easeOutIn:IEasing = new ElasticEaseOutIn();
		
		/**
		 * 
		 * @param	a	Specifies the amplitude of the sine wave.
		 * @param	p	Specifies the period of the sine wave.
		 * @return	An easing with passed parameters.
		 */
		public static function easeInWith(a:Number = 0, p:Number = 0):IEasing
		{
			return new ElasticEaseIn(a, p);
		}
		
		/**
		 * 
		 * @param	a	Specifies the amplitude of the sine wave.
		 * @param	p	Specifies the period of the sine wave.
		 * @return	An easing with passed parameters.
		 */
		public static function easeOutWith(a:Number = 0, p:Number = 0):IEasing
		{
			return new ElasticEaseOut(a, p);
		}
		
		/**
		 * 
		 * @param	a	Specifies the amplitude of the sine wave.
		 * @param	p	Specifies the period of the sine wave.
		 * @return	An easing with passed parameters.
		 */
		public static function easeInOutWith(a:Number = 0, p:Number = 0):IEasing
		{
			return new ElasticEaseInOut(a, p);
		}
		
		/**
		 * 
		 * @param	a	Specifies the amplitude of the sine wave.
		 * @param	p	Specifies the period of the sine wave.
		 * @return	An easing with passed parameters.
		 */
		public static function easeOutInWith(a:Number = 0, p:Number = 0):IEasing
		{
			return new ElasticEaseOutIn(a, p);
		}
	}
}