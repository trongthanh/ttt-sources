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
	import flash.utils.Dictionary;
	import org.libspark.betweenas3.core.easing.IPhysicalEasing;
	/**
	 * IPhysicalUpdater の実装.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class PhysicalUpdater implements IPhysicalUpdater
	{
		protected var _target:Object = null;
		protected var _source:Dictionary = new Dictionary();
		protected var _destination:Dictionary = new Dictionary();
		protected var _relativeMap:Dictionary = new Dictionary();
		protected var _easing:IPhysicalEasing = null;
		protected var _duration:Dictionary = new Dictionary();
		protected var _maxDuration:Number = 0.0;
		protected var _isResolved:Boolean = false;
		
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
		public function get easing():IPhysicalEasing
		{
			return _easing;
		}
		
		/**
		 * @private
		 */
		public function set easing(value:IPhysicalEasing):void
		{
			_easing = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			if (!_isResolved) {
				resolveValues();
			}
			return _maxDuration;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			_source[propertyName] = value;
			_relativeMap['source.' + propertyName] = isRelative;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			_destination[propertyName] = value;
			_relativeMap['dest.' + propertyName] = isRelative;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObject(propertyName:String):Object
		{
			return _target[propertyName];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setObject(propertyName:String, value:Object):void
		{
			_target[propertyName] = value;
		}
		
		/**
		 * 各プロパティの開始値と終了値で未設定なものや、相対値指定なものについて、絶対値を算出します.
		 */
		protected function resolveValues():void
		{
			var key:String, target:Object = _target, source:Dictionary = _source, dest:Dictionary = _destination, rMap:Dictionary = _relativeMap, d:Dictionary = _duration, duration:Number, maxDuration:Number = 0.0;
			
			for (key in source) {
				if (dest[key] == undefined) {
					dest[key] = target[key];
				}
				if (rMap['source.' + key]) {
					source[key] += target[key];
				}
			}
			for (key in dest) {
				if (source[key] == undefined) {
					source[key] = target[key];
				}
				if (rMap['dest.' + key]) {
					dest[key] += target[key];
				}
				duration = _easing.getDuration(source[key], dest[key] - source[key]);
				d[key] = duration;
				if (maxDuration < duration) {
					maxDuration = duration;
				}
			}
			
			_maxDuration = maxDuration;
			
			_isResolved = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(time:Number):void
		{
			if (!_isResolved) {
				resolveValues();
			}
			
			var factor:Number;
			var t:Object = _target;
			var e:IPhysicalEasing = _easing;
			var dest:Dictionary = _destination;
			var src:Dictionary = _source;
			var s:Number;
			var d:Dictionary = _duration;
			var name:String;
			
			for (name in dest) {
				if (time >= d[name]) {
					t[name] = dest[name];
				}
				else {
					s = src[name];
					t[name] = e.calculate(time, s, dest[name] - s);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():IUpdater
		{
			var instance:PhysicalUpdater = newInstance();
			if (instance != null) {
				instance.copyFrom(this);
			}
			return instance;
		}
		
		/**
		 * .
		 * 
		 * @return
		 */
		protected function newInstance():PhysicalUpdater
		{
			return new PhysicalUpdater();
		}
		
		/**
		 * .
		 */
		protected function copyFrom(source:PhysicalUpdater):void
		{
			var obj:PhysicalUpdater = source as PhysicalUpdater;
			
			_target = obj._target;
			_easing = obj._easing;
			copyObject(_source, obj._source);
			copyObject(_destination, obj._destination);
			copyObject(_relativeMap, obj._relativeMap);
		}
		
		private function copyObject(to:Object, from:Object):void
		{
			for (var name:String in from) {
				to[name] = from[name];
			}
		}
	}
}