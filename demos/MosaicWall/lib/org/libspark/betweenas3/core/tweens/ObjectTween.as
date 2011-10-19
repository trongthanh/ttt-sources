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
package org.libspark.betweenas3.core.tweens
{
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.core.ticker.ITicker;
	import org.libspark.betweenas3.core.updaters.IUpdater;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class ObjectTween extends AbstractTween implements IIObjectTween
	{
		public function ObjectTween(ticker:ITicker)
		{
			super(ticker, 0);
		}
		
		protected var _easing:IEasing;
		protected var _updater:IUpdater;
		
		/**
		 * @inheritDoc
		 */
		public function get time():Number
		{
			return _duration;
		}
		
		/**
		 * @private
		 */
		public function set time(value:Number):void
		{
			_duration = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get easing():IEasing
		{
			return _easing;
		}
		
		/**
		 * @private
		 */
		public function set easing(value:IEasing):void
		{
			_easing = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get updater():IUpdater
		{
			return _updater;
		}
		
		/**
		 * @private
		 */
		public function set updater(value:IUpdater):void
		{
			_updater = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get target():Object
		{
			return _updater != null ? _updater.target : null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function internalUpdate(time:Number):void 
		{
			var factor:Number = 0.0;
			
			if (time > 0.0) {
				if (time < _duration) {
					factor = _easing.calculate(time, 0.0, 1.0, _duration);
				}
				else {
					factor = 1.0;
				}
			}
			
			_updater.update(factor);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function newInstance():AbstractTween 
		{
			return new ObjectTween(_ticker);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function copyFrom(source:AbstractTween):void 
		{
			super.copyFrom(source);
			
			var obj:ObjectTween = source as ObjectTween;
			
			_easing = obj._easing;
			_updater = obj._updater.clone();
		}
	}
}