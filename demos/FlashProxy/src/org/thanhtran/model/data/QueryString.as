/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.thanhtran.model.data {
	
	/**
	 * Decode and store query string's variables as object properties.
	 * @author Thanh Tran
	 */
	public dynamic class QueryString extends OrderedObject {
		
		public function QueryString(source: String = "") {
			super();
			if (source) decode(source);
		}
		
		public function decode(source: String): void {
			if (!source) return;
			
			var pair: Array;
			var args: Array = source.split("&");
			var len: int = args.length;
			var name: String;
			
			for (var i: int = 0; i < len; i++) {
				pair = args[i].split("=");
				name = String(pair[0]);
				if (props.indexOf(name) == -1) props.push(name);
				values[name] = pair[1];
			}
		}
		
		override public function toString(): String {
			var len: int = props.length;
			var s: String = "";
			
			for (var i: int = 0; i < len; i++) {
				s += props[i] + "=" + values[props[i]];
				if (i < len -1) s += "&";
			}
			return s;
		}
		
		
	}

}