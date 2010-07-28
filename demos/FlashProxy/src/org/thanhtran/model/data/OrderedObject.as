/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.thanhtran.model.data { 
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	/**
	 * A special object in which the order of properties when they are created is maintained for use with for...in and for each...in
	 * @author Thanh Tran
	 */
	public dynamic class OrderedObject extends Proxy {
		protected var props: Array;
		protected var values: Object;
		
		public function OrderedObject(propList: Array = null) {
			props = [];
			values = { };
			if (propList) parsePropertyList(propList);
		}
		
		override flash_proxy function setProperty(name:*, value:*): void {
			if (props.indexOf(String(name)) == -1) props.push(name);
			values[name] = value;
		}
		
		override flash_proxy function getProperty(name:*):* {
			return values[name];
		}
		
		/**
		 * It is strange but reasonable that Flash will pass 0 for the first index
		 * and then use the output (index + 1) to get the first property.
		 * this explain why, in nextName and nextValue, index must subtract 1 back
		 * @param	index
		 * @return
		 */
		override flash_proxy function nextNameIndex (index: int): int {
			if (index < props.length) {
				return index + 1;
			} else {
				return 0;
			}
		}		
		
		override flash_proxy function nextName(index: int): String {
			return props[index - 1];
		}
		
		override flash_proxy function nextValue(index: int): * {
			return values[props[index - 1]];
		}
		
		override flash_proxy function deleteProperty(name: *): Boolean {
			var index: int = props.indexOf(name);
			if (index == -1) {
				return false;
			} else {
				delete values[props[index]];
				props.splice(index, 1);
				return true;
			}
		}
		
		override flash_proxy function hasProperty(name:*): Boolean {
			return values.hasOwnProperty(name);
		}
		
		override flash_proxy function getDescendants(name:*): * {
			return values[name];
		}
		
		public function parsePropertyList(propList: Array): void {
			var len: uint = propList.length;
			var name: String;
			var value: *;
			for (var i:int = 0; i < len - 1; i += 2) {
				name = String(propList[i]);
				value = propList[i + 1];
				if (props.indexOf(name) == -1) props.push(name);
				values[name] = value;
			}
		}
		
		public function toString(): String {
			var len: int = props.length;
			var s: String = "{";
			
			for (var i: int = 0; i < len; i++) {
				s += props[i] + ": " + values[props[i]];
				if (i < len -1) s += ", ";
			}
			s += "}";
			return s;
		}
		
	}

}