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
package org.libspark.betweenas3.core.tweens.decorators
{
	import org.libspark.betweenas3.core.tweens.AbstractTween;
	import org.libspark.betweenas3.core.tweens.IITween;
	import org.libspark.betweenas3.core.tweens.TweenDecorator;
	
	/**
	 * ITween の一部分だけ実行.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class SlicedTween extends TweenDecorator
	{
		public function SlicedTween(baseTween:IITween, begin:Number, end:Number)
		{
			super(baseTween, 0);
			
			_duration = end - begin;
			_begin = begin;
			_end = end;
		}
		
		private var _begin:Number;
		private var _end:Number;
		
		public function get begin():Number
		{
			return _begin;
		}
		
		public function get end():Number
		{
			return _end;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function internalUpdate(time:Number):void
		{
			if (time > 0) {
				if (time < _duration) {
					_baseTween.update(time + _begin);
				}
				else {
					_baseTween.update(_end);
				}
			}
			else {
				_baseTween.update(_begin);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function newInstance():AbstractTween 
		{
			return new SlicedTween(_baseTween.clone() as IITween, _begin, _end);
		}
	}
}