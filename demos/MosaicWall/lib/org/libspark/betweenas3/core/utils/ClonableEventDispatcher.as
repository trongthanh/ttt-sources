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
package org.libspark.betweenas3.core.utils
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class ClonableEventDispatcher extends EventDispatcher
	{
		public function ClonableEventDispatcher(target:IEventDispatcher = null)
		{
			super(target);
		}
		
		private var _listeners:Dictionary = new Dictionary();
		
		override public function addEventListener(type:String , listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			var data:ListenerData = new ListenerData();
			data.listener = listener;
			data.useCapture = useCapture;
			data.priority = priority;
			data.useWeakReference = useWeakReference;
			
			var listeners:Array = _listeners[type] as Array;
			if (listeners == null) {
				_listeners[type] = listeners = [];
			}
			listeners.push(data);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			
			var listeners:Array = _listeners[type] as Array;
			if (listeners != null) {
				var l:uint = listeners.length;
				for (var i:int = 0; i < l; ++i) {
					var data:ListenerData = listeners[i] as ListenerData;
					if (data.listener == listener && data.useCapture == useCapture) {
						listeners.splice(i, 1);
						--i;
						--l;
					}
				}
			}
		}
		
		public function copyFrom(source:ClonableEventDispatcher):void
		{
			var listeners:Dictionary = source._listeners;
			for (var type:String in listeners) {
				var list:Array = listeners[type] as Array;
				var l:uint = list.length;
				for (var i:uint = 0; i < l; ++i) {
					var data:ListenerData = list[i] as ListenerData;
					addEventListener(type, data.listener, data.useCapture, data.priority, data.useWeakReference);
				}
			}
		}
	}
}

internal class ListenerData
{
	public var listener:Function;
	public var useCapture:Boolean;
	public var priority:int
	public var useWeakReference:Boolean;
}