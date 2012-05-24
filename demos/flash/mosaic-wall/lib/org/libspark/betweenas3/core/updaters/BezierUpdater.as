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
	
	/**
	 * ベジェトゥイーンをするための IUpdater の実装です.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class BezierUpdater extends AbstractUpdater
	{
		protected var _target:Object = null;
		protected var _source:Dictionary = new Dictionary();
		protected var _destination:Dictionary = new Dictionary();
		protected var _controlPoint:Dictionary = new Dictionary();
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
		 * .
		 * 
		 * @param	propertyName
		 * @param	value
		 * @param	isRelative
		 */
		public function addControlPoint(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			var controlPoint:Array = _controlPoint[propertyName] as Array;
			if (controlPoint == null) {
				_controlPoint[propertyName] = controlPoint = [];
			}
			controlPoint.push(value);
			_relativeMap['cp.' + propertyName + '.' + controlPoint.length] = isRelative;
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
			var key:String, target:Object = _target, source:Dictionary = _source, dest:Dictionary = _destination, controlPoint:Dictionary = _controlPoint, cpVec:Array, l:uint, i:uint, rMap:Dictionary = _relativeMap;
			
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
			for (key in controlPoint) {
				cpVec = controlPoint[key] as Array;
				l = cpVec.length;
				for (i = 0; i < l; ++i) {
					if (rMap['cp.' + key + '.' + i]) {
						cpVec[i] += target[key];
					}
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
			var b:Number;
			var cp:Dictionary = _controlPoint;
			var cpVec:Array;
			var l:uint;
			var ip:uint, it:Number, p1:Number, p2:Number;
			var name:String;
			
			// Thank you, Tweener & Robert Penner!
			
			for (name in d) {
				
				b = s[name];
				
				if (factor != 1.0 && (cpVec = _controlPoint[name] as Array) != null) {
					if ((l = cpVec.length) == 1) {
						t[name] = b + factor * (2 * invert * (cpVec[0] - b) + factor * (d[name] - b));
					}
					else {
						ip = (factor * l) >> 0;
						it = (factor - (ip * (1 / l))) * l;
						if (ip == 0) {
							p1 = b;
							p2 = (cpVec[0] + cpVec[1]) / 2;
						}
						else if (ip == (l - 1)) {
							p1 = (cpVec[ip - 1] + cpVec[ip]) / 2;
							p2 = d[name];
						}
						else {
							p1 = (cpVec[ip - 1] + cpVec[ip]) / 2;
							p2 = (cpVec[ip] + cpVec[ip + 1]) / 2;
						}
						t[name] = p1 + it * (2 * (1 - it) * (cpVec[ip] - p1) + it * (p2 - p1));
					}
				}
				else {
					t[name] = b * invert + d[name] * factor;
				}
			}
		}
		
		override protected function newInstance():AbstractUpdater 
		{
			return new BezierUpdater();
		}
		
		override protected function copyFrom(source:AbstractUpdater):void 
		{
			super.copyFrom(source);
			
			var obj:BezierUpdater = source as BezierUpdater;
			
			_target = obj._target;
			copyObject(_source, obj._source);
			copyObject(_destination, obj._destination);
			copyObject(_controlPoint, obj._controlPoint);
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