/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * All rights reserved.
 */
package com.pyco.utils {
	/**
	 * ...
	 * @author Thanh Tran
	 * @contributor Thu Hoang
	 */
	public class TextUtil {
		
		public static function countWordOccurance(text: String): Array {
			// Remove punctuations, non-word characters...
			var pattern: RegExp = /[^A-Za-z0-9_\-\s]/g; //note: this case also remove Vietnamese unicode characters, improve later when needed			
			text = text.replace(pattern, "");
			var words: Array = text.split(" ");
			
			var wordsObject: Object = {};
			
			for each (var w: String in words) {
				if (wordsObject[w]) {
					wordsObject[w] ++;
				} else {
					wordsObject[w] = 1;
				}
			}
			
			//tranfer to array in order to sort
			var result: Array = [];
			for (var i: String in wordsObject) {
				var wordItem: Object = { text: i, count:wordsObject[i] };
				result.push(wordItem);
			}
			
			//bigger count stay at top
			result.sort(function (wordA: Object, wordB: Object): int {
				return wordB.count - wordA.count;
			});
			
			return result;
		}
		
		
		
	}

}