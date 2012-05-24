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
package org.libspark.betweenas3.core.updaters
{
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class CompositeUpdater implements IUpdater
	{
		public function CompositeUpdater(target:Object, updaters:Array)
		{
			_target = target;
			
			var l:uint = updaters.length;
			
			if (l >= 1) {
				_a = updaters[0];
				if (l >= 2) {
					_b = updaters[1];
					if (l >= 3) {
						_c = updaters[2];
						if (l >= 4) {
							_d = updaters[3];
							if (l >= 5) {
								_updaters = new Array(l - 4);
								for (var i:uint = 4; i < l; ++i) {
									_updaters[i - 4] = updaters[i];
								}
							}
						}
					}
				}
			}
		}
		
		private var _target:Object = null;
		
		private var _a:IUpdater;
		private var _b:IUpdater;
		private var _c:IUpdater;
		private var _d:IUpdater;
		private var _updaters:Array;
		
		/**
		 * .
		 */
		public function getUpdaterAt(index:uint):IUpdater
		{
			if (index == 0) {
				return _a;
			}
			if (index == 1) {
				return _b;
			}
			if (index == 2) {
				return _c;
			}
			if (index == 3) {
				return _d;
			}
			return _updaters[index - 4];
		}
		
		/**
		 * @inheritDoc
		 */
		public function get target():Object
		{
			return _target;
		}
		
		/**
		 * @private
		 */
		public function set target(value:Object):void
		{
			_target = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObject(propertyName:String):Object
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setObject(propertyName:String, value:Object):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(factor:Number):void
		{
			if (_a != null) {
				_a.update(factor);
				if (_b != null) {
					_b.update(factor);
					if (_c != null) {
						_c.update(factor);
						if (_d != null) {
							_d.update(factor);
							if (_updaters != null) {
								var updaters:Array = _updaters;
								var l:uint = updaters.length;
								for (var i:uint = 0; i < l; ++i) {
									(updaters[i] as IUpdater).update(factor);
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():IUpdater
		{
			var updaters:Array = [];
			
			if (_a != null) {
				updaters.push(_a.clone());
				if (_b != null) {
					updaters.push(_b.clone());
					if (_c != null) {
						updaters.push(_c.clone());
						if (_d != null) {
							updaters.push(_d.clone());
							if (_updaters != null) {
								var u:Array = _updaters;
								var l:uint = u.length;
								for (var i:uint = 0; i < l; ++i) {
									updaters.push(u[i].clone());
								}
							}
						}
					}
				}
			}
			
			return new CompositeUpdater(_target, updaters);
		}
	}
}