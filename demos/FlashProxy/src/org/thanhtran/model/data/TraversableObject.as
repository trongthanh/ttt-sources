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
	 * This class is to enable traversing through declared properties (which is not possible with normal object)<br/>
	 * What developer should do is:<br/>
	 * 		+ Create a data class which extends this class<br/>
	 * 		+ In the extended class, list all properties that he wants to be iterated through using for..in OR for each ...in<br/>
	 * Warning:<br/> 
	 * 		+ Only list the public property in propertyList<br/>
	 * 		+ This object is not to mixed with declared and dynamic property<br/>
	 * 		+ Any attempt to add new dynamic property or list private property will cause exception<br/>
	 * 
	 * @example
	 * <listing>
	 * public class MyObject extends TraversableObject {
	 * 		public var a: String = "1";
	 * 		public var b: int = 2;
	 * 		public var c: Number = 3;
	 * 
	 * 		public function MyObject() {
	 * 			propertyList = ["a", "b", "c"];
	 * 		}
	 * }
	 * </listing>
	 * @author Thanh Tran
	 */
	public class TraversableObject extends Proxy {
		protected var propertyList: Array;
		
		override flash_proxy function nextNameIndex (index: int): int {
			if (propertyList && index < propertyList.length) {
				return index + 1;
			} else {
				return 0;
			}
		}		
		
		override flash_proxy function nextName(index: int): String {
			return propertyList[index - 1];
		}
		
		override flash_proxy function nextValue(index: int): * {
			return this[propertyList[index - 1]];
		}
		
	}

}