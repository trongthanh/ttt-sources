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
package org.libspark.betweenas3.core.tweens.groups
{
	import org.libspark.betweenas3.core.ticker.ITicker;
	import org.libspark.betweenas3.core.tweens.AbstractTween;
	import org.libspark.betweenas3.core.tweens.IITween;
	import org.libspark.betweenas3.core.tweens.IITweenGroup;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * 複数の ITween を同時に実行.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class ParallelTween extends AbstractTween implements IITweenGroup
	{
		public function ParallelTween(targets:Array, ticker:ITicker, position:Number)
		{
			super(ticker, position);
			
			var l:uint = targets.length;
			
			_duration = 0;
			
			if (l > 0) {
				_a = targets[0] as IITween;
				_duration = _a.duration > _duration ? _a.duration : _duration;
				if (l > 1) {
					_b = targets[1] as IITween;
					_duration = _b.duration > _duration ? _b.duration : _duration;
					if (l > 2) {
						_c = targets[2] as IITween;
						_duration = _c.duration > _duration ? _c.duration : _duration;
						if (l > 3) {
							_d = targets[3] as IITween;
							_duration = _d.duration > _duration ? _d.duration : _duration;
							if (l > 4) {
								_targets = new Array(l - 4);
								for (var i:uint = 4; i < l; ++i) {
									var t:IITween = targets[i] as IITween;
									_targets[i - 4] = t;
									_duration = t.duration > _duration ? t.duration : _duration;
								}
							}
						}
					}
				}
			}
		}
		
		private var _a:IITween;
		private var _b:IITween;
		private var _c:IITween;
		private var _d:IITween;
		private var _targets:Array;
		
		/**
		 * @inheritDoc
		 */
		public function contains(tween:ITween):Boolean
		{
			if (tween == null) {
				return false;
			}
			if (_a == tween) {
				return true;
			}
			if (_b == tween) {
				return true;
			}
			if (_c == tween) {
				return true;
			}
			if (_d == tween) {
				return true;
			}
			if (_targets != null) {
				return _targets.indexOf(tween as IITween) != -1;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getTweenAt(index:int):ITween
		{
			if (index < 0) {
				return null;
			}
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
			if (_targets != null) {
				if (index - 4 < _targets.length) {
					return _targets[index - 4];
				}
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getTweenIndex(tween:ITween):int
		{
			if (tween == null) {
				return -1;
			}
			if (_a == tween) {
				return 0;
			}
			if (_b == tween) {
				return 1;
			}
			if (_c == tween) {
				return 2;
			}
			if (_d == tween) {
				return 3;
			}
			if (_targets != null) {
				var i:int = _targets.indexOf(tween as IITween);
				if (i != -1) {
					return i + 4;
				}
			}
			return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function internalUpdate(time:Number):void 
		{
			if (_a != null) {
				_a.update(time);
				if (_b != null) {
					_b.update(time);
					if (_c != null) {
						_c.update(time);
						if (_d != null) {
							_d.update(time);
							if (_targets != null) {
								var targets:Array = _targets;
								var l:uint = targets.length;
								for (var i:uint = 0; i < l; ++i) {
									(targets[i] as IITween).update(time);
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
		override protected function newInstance():AbstractTween 
		{
			var targets:Array = [];
			if (_a != null) {
				targets.push(_a.clone());
			}
			if (_b != null) {
				targets.push(_b.clone());
			}
			if (_c != null) {
				targets.push(_c.clone());
			}
			if (_d != null) {
				targets.push(_d.clone());
			}
			if (_targets != null) {
				var t:Array = _targets;
				var l:uint = t.length;
				for (var i:uint = 0; i < l; ++i) {
					targets.push(t[i].clone());
				}
			}
			return new ParallelTween(targets, _ticker, 0);
		}
	}
}