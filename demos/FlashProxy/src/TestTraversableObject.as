/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package  {
	import org.thanhtran.model.data.TraversableObject;
	/**
	 * a traversable object demo
	 * @author Thanh Tran
	 */
	public class TestTraversableObject extends TraversableObject {
		public var a: String = "1";
		public var b: String = "2";
		public var c: Number = 3;
		public var d: int = 4;
		public var e: uint = 5;
		
		
		public function TestTraversableObject() {
			propertyList = ["a", "b", "c", "d", "e"];
		}
		
	}

}