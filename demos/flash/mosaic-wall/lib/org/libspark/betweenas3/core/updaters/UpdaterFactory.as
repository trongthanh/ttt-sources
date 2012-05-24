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
	import org.libspark.betweenas3.core.utils.ClassRegistry;
	
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class UpdaterFactory
	{
		public function UpdaterFactory(registry:ClassRegistry)
		{
			_registry = registry;
		}
		
		private var _registry:ClassRegistry;
		
		private var _poolIndex:uint = 0;
		private var _mapPool:Array = [];
		private var _listPool:Array = [];
		
		public function create(target:Object, dest:Object, source:Object):IUpdater
		{
			var map:Dictionary, updaters:Array, name:String, value:Object, isRelative:Boolean, parent:IUpdater, child:IUpdater, updater:IUpdater;
			
			if (_poolIndex > 0) {
				--_poolIndex;
				map = _mapPool[_poolIndex] as Dictionary;
				updaters = _listPool[_poolIndex] as Array;
			}
			else {
				map = new Dictionary();
				updaters = [];
			}
			
			if (source != null) {
				for (name in source) {
					if ((value = source[name]) is Number) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						getUpdaterFor(target, name, map, updaters).setSourceValue(name, Number(value), isRelative);
					}
					else {
						parent = getUpdaterFor(target, name, map, updaters);
						child = create(parent.getObject(name), dest != null ? dest[name] : null, value);
						updaters.push(new UpdaterLadder(parent, child, name));
					}
				}
			}
			if (dest != null) {
				for (name in dest) {
					if ((value = dest[name]) is Number) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						getUpdaterFor(target, name, map, updaters).setDestinationValue(name, Number(value), isRelative);
					}
					else {
						if (!(source != null && name in source)) {
							parent = getUpdaterFor(target, name, map, updaters);
							child = create(parent.getObject(name), value, source != null ? source[name] : null);
							updaters.push(new UpdaterLadder(parent, child, name));
						}
					}
				}
			}
			
			if (updaters.length == 1) {
				updater = updaters[0] as IUpdater;
			}
			else if (updaters.length > 1) {
				updater = new CompositeUpdater(target, updaters);
			}
			
			for (var p:* in map) {
				delete map[p];
			}
			updaters.length = 0;
			
			_mapPool[_poolIndex] = map;
			_listPool[_poolIndex] = updaters;
			++_poolIndex;
			
			return updater;
		}
		
		public function getUpdaterFor(target:Object, propertyName:String, map:Dictionary, list:Array):IUpdater
		{
			var updaterClass:Class = _registry.getClassByTargetClassAndPropertyName(target.constructor, propertyName);
			if (updaterClass != null) {
				var updater:IUpdater = map[updaterClass] as IUpdater;
				if (updater == null) {
					updater = new updaterClass();
					updater.target = target;
					map[updaterClass] = updater;
					if (list != null) {
						list.push(updater);
					}
				}
				return updater;
			}
			return null;
		}
		
		public function createBezier(target:Object, dest:Object, source:Object, controlPoint:Object):IUpdater
		{
			var map:Dictionary = new Dictionary(), updaters:Array = [], bezierUpdater:BezierUpdater = new BezierUpdater(), name:String, value:Object, isRelative:Boolean, cp:Array, l:uint, i:uint, child:IUpdater, updater:IUpdater;
			
			bezierUpdater.target = target;
			
			updaters.push(bezierUpdater);
			
			if (source != null) {
				for (name in source) {
					if ((value = source[name]) is Number) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						bezierUpdater.setSourceValue(name, Number(value), isRelative);
					}
					else {
						if (!map[name]) {
							child = createBezier(bezierUpdater.getObject(name), dest != null ? dest[name] : null, value, controlPoint != null ? controlPoint[name] : null);
							updaters.push(new UpdaterLadder(bezierUpdater, child, name));
							map[name] = true;
						}
					}
				}
			}
			if (dest != null) {
				for (name in dest) {
					if ((value = dest[name]) is Number) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						bezierUpdater.setDestinationValue(name, Number(value), isRelative);
					}
					else {
						if (!map[name]) {
							child = createBezier(bezierUpdater.getObject(name), null, source != null ? source[name] : null, controlPoint != null ? controlPoint[name] : null);
							updaters.push(new UpdaterLadder(bezierUpdater, child, name));
							map[name] = true;
						}
					}
				}
			}
			if (controlPoint != null) {
				for (name in controlPoint) {
					if ((value = controlPoint[name]) is Number) {
						value = [value];
					}
					if (value is Array) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						cp = value as Array;
						l = cp.length;
						for (i = 0; i < l; ++i) {
							bezierUpdater.addControlPoint(name, cp[i], isRelative);
						}
					}
					else {
						if (!map[name]) {
							child = createBezier(bezierUpdater.getObject(name), dest != null ? dest[name] : null, source != null ? source[name] : null, value);
							updaters.push(new UpdaterLadder(bezierUpdater, child, name));
							map[name] = true;
						}
					}
				}
			}
			
			if (updaters.length == 1) {
				updater = updaters[0] as IUpdater;
			}
			else if (updaters.length > 1) {
				updater = new CompositeUpdater(target, updaters);
			}
			
			return updater;
		}
		
		public function createPhysical(target:Object, dest:Object, source:Object, easing:IPhysicalEasing):IPhysicalUpdater
		{
			var map:Dictionary = new Dictionary(), updaters:Array = [], physicalUpdater:PhysicalUpdater = new PhysicalUpdater(), name:String, value:Object, isRelative:Boolean, child:IPhysicalUpdater, updater:IPhysicalUpdater;
			
			physicalUpdater.target = target;
			physicalUpdater.easing = easing;
			
			updaters.push(physicalUpdater);
			
			if (source != null) {
				for (name in source) {
					if ((value = source[name]) is Number) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						physicalUpdater.setSourceValue(name, Number(value), isRelative);
					}
					else {
						if (!map[name]) {
							child = createPhysical(physicalUpdater.getObject(name), dest != null ? dest[name] : null, value, easing);
							updaters.push(new PhysicalUpdaterLadder(physicalUpdater, child, name));
							map[name] = true;
						}
					}
				}
			}
			if (dest != null) {
				for (name in dest) {
					if ((value = dest[name]) is Number) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						physicalUpdater.setDestinationValue(name, Number(value), isRelative);
					}
					else {
						if (!map[name]) {
							child = createPhysical(physicalUpdater.getObject(name), null, source != null ? source[name] : null, easing);
							updaters.push(new PhysicalUpdaterLadder(physicalUpdater, child, name));
							map[name] = true;
						}
					}
				}
			}
			
			if (updaters.length == 1) {
				updater = updaters[0] as IPhysicalUpdater;
			}
			else if (updaters.length > 1) {
				updater = new CompositePhysicalUpdater(target, updaters);
			}
			
			return updater;
		}
	}
}