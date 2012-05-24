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
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * クラスレジストリ.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class ClassRegistry
	{
		private var _classes:Dictionary = new Dictionary();
		private var _subclasses:Dictionary = new Dictionary();
		
		public function registerClassWithTargetClassAndPropertyName(klass:Class, targetClass:Class, propertyName:String):void
		{
			if (_classes[targetClass] == undefined) {
				buildCacheFor(targetClass);
			}
			
			var classes:Dictionary = _classes;
			var oldClass:Class = classes[targetClass][propertyName] as Class;
			
			classes[targetClass][propertyName] = klass;
			
			// サブクラスへ新しい値を伝播
			
			var subclasses:Array = _subclasses[targetClass] as Array;
			if (subclasses != null) {
				var l:uint = subclasses.length;
				for (var i:uint = 0; i < l; ++i) {
					var subclass:Class = subclasses[i] as Class;
					if (classes[subclass][propertyName] == oldClass) {
						classes[subclass][propertyName] = klass;
					}
				}
			}
		}
		
		public function registerClassWithTargetClassAndPropertyNames(klass:Class, targetClass:Class, propertyNames:Array):void
		{
			var l:uint = propertyNames.length;
			for (var i:uint = 0; i < l; ++i) {
				registerClassWithTargetClassAndPropertyName(klass, targetClass, propertyNames[i]);
			}
		}
		
		public function getClassByTargetClassAndPropertyName(targetClass:Class, propertyName:String):Class
		{
			var properties:* = _classes[targetClass], c:*;
			if (properties != null) {
				if ((c = properties[propertyName]) != null) {
					return c as Class;
				}
				if ((c = properties['*']) != null) {
					return c as Class;
				}
			}
			else {
				buildCacheFor(targetClass);
				return getClassByTargetClassAndPropertyName(targetClass, propertyName);
			}
			
			return null;
		}
		
		private function buildCacheFor(targetClass:Class):void
		{
			var classes:Dictionary = _classes;
			var subclasses:Dictionary = _subclasses;
			var dict:Dictionary = new Dictionary();
			var tree:Array = getClassTree(targetClass);
			var l:uint = tree.length;
			var i:int = l;
			while (--i >= 0) {
				var c:Class = tree[i] as Class;
				var d:Dictionary = classes[c] as Dictionary;
				var p:String;
				if (d != null) {
					var newDict:Dictionary = new Dictionary();
					// 祖先からの継承
					if (dict != null) {
						for (p in dict) {
							newDict[p] = dict[p];
							// 祖先からこのクラスへ
							if (!(p in d)) {
								d[p] = dict[p];
							}
						}
					}
					// このクラスからの継承
					for (p in d) {
						newDict[p] = d[p];
					}
					dict = newDict;
				}
				else {
					var dictClone:Dictionary = new Dictionary();
					for (p in dict) {
						dictClone[p] = dict[p];
					}
					classes[c] = dictClone;
				}
				
				// このクラス (c) のサブクラスのリストを保存
				
				if (subclasses[c] != undefined) {
					var sub:Array = subclasses[c] as Array;
					for (var j:int = i - 1; j >= 0; --j) {
						var subC:Class = tree[j] as Class;
						if (sub.indexOf(subC) == -1) {
							sub.push(subC);
						}
					}
				}
				else {
					subclasses[c] = tree.slice(0, i);
				}
			}
		}
		
		private function getClassTree(klass:Class):Array
		{
			var tree:Array = [];
			var superClassName:String;
			var c:Class = klass;
			
			while (c != null) {
				tree.push(c);
				if ((superClassName = getQualifiedSuperclassName(c)) != null) {
					try {
						c = getDefinitionByName(superClassName) as Class;
					}
					catch (e:ReferenceError) {
						c = Object;
					}
				}
				else {
					c = null;
				}
			}
			
			return tree;
		}
	}
}