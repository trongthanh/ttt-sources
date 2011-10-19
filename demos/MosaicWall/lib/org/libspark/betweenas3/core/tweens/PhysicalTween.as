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
	import org.libspark.betweenas3.core.ticker.ITicker;
	import org.libspark.betweenas3.core.updaters.IPhysicalUpdater;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class PhysicalTween extends AbstractTween implements IIPhysicalTween
	{
		public function PhysicalTween(ticker:ITicker)
		{
			super(ticker, 0);
		}
		
		protected var _updater:IPhysicalUpdater;
		
		/**
		 * @inheritDoc
		 */
		public function get updater():IPhysicalUpdater
		{
			return _updater;
		}
		
		/**
		 * @private
		 */
		public function set updater(value:IPhysicalUpdater):void
		{
			_updater = value;
			
			if (_updater != null) {
				_duration = _updater.duration;
			}
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
			_updater.update(time);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function newInstance():AbstractTween 
		{
			return new PhysicalTween(_ticker);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function copyFrom(source:AbstractTween):void 
		{
			super.copyFrom(source);
			
			var obj:PhysicalTween = source as PhysicalTween;
			
			_updater = obj._updater.clone() as IPhysicalUpdater;
		}
	}
}