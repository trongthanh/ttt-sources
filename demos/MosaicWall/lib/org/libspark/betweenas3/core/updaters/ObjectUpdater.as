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
	import org.libspark.betweenas3.core.utils.ClassRegistry;
	
	/**
	 * 全てのオブジェクトを対象とした IUpdater の実装です.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class ObjectUpdater extends AbstractUpdater
	{
		public static function register(registry:ClassRegistry):void
		{
			registry.registerClassWithTargetClassAndPropertyName(ObjectUpdater, Object, '*');
		}
		
		protected var _target:Object = null;
		protected var _source:Dictionary = new Dictionary();
		protected var _destination:Dictionary = new Dictionary();
		protected var _relativeMap:Dictionary = new Dictionary();
		
		/**
		 * @inheritDoc
		 */
		override public function get target():Object
		{
			return _target;
		}
		
		/**
		 * @private
		 */
		override public function set target(value:Object):void
		{
			_target = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			_source[propertyName] = value;
			_relativeMap['source.' + propertyName] = isRelative;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			_destination[propertyName] = value;
			_relativeMap['dest.' + propertyName] = isRelative;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getObject(propertyName:String):Object
		{
			return _target[propertyName];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setObject(propertyName:String, value:Object):void
		{
			_target[propertyName] = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resolveValues():void
		{
			var key:String, target:Object = _target, source:Dictionary = _source, dest:Dictionary = _destination, rMap:Dictionary = _relativeMap;
			
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
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateObject(factor:Number):void 
		{
			var invert:Number = 1.0 - factor;
			var t:Object = _target;
			var d:Dictionary = _destination;
			var s:Dictionary = _source;
			var name:String;
			
			for (name in d) {
				t[name] = s[name] * invert + d[name] * factor;
			}
		}
		
		override protected function newInstance():AbstractUpdater 
		{
			return new ObjectUpdater();
		}
		
		override protected function copyFrom(source:AbstractUpdater):void 
		{
			super.copyFrom(source);
			
			var obj:ObjectUpdater = source as ObjectUpdater;
			
			_target = obj._target;
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