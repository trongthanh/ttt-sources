/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * All rights reserved.
 */
package com.pyco.utils {
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class ArrayUtil {
		
		/**
		 * 
		 * @param	fromArr Vector to shuffle
		 * @return	the same Vector transferred in the argument
		 */
		public static function shuffleVector(fromArr: *): * {
			var l: uint = fromArr.length;
			var ranSeq: Array = Random.getRandomSequence(0, l - 1);
			var newArr: Array = []
			var i: int;
			for (i = 0; i < l; i++) {
				newArr[i] = fromArr[ranSeq[i]];
			}
			for (i = 0; i < l; i++) {
				fromArr[i] = newArr[i];
			}
			
			return fromArr;
		}
		
		/**
		 * Randomize an array<br/>
		 * From: http://snipplr.com/view/47052/randomize-an-array/
		 * @param	arr
		 * @return	the input array which was modified
		 */
		public static function shuffleArray(arr: Array): Array {
			for (var i:uint = 0; i < arr.length; i++) {
			   var rand:uint = int(Math.random() * arr.length);
			   arr.push( arr.splice( rand, 1 )[0] );
			}
			return arr;
		}
		
	}

}