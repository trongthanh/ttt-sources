package com.int3ractive.utils {
	
	/**
	* Random generator
	* @author Thanh Tran
	* @version 0.2
	*/
	public class Random {
		
		public function Random() {
			
		}
		
		/**
		 * Creates a randomized integer in the range [min - max]
		 * @param	min	minimun number (inclusive)
		 * @param	max	maximum number (inclusive)
		 * @return	random integer between the given range
		 */
		public static function getRandomInt(min:int, max:int):int {
			return min + int(Math.random() * (max - min + 1));
		}
		
		/**
		 * Creates a randomized number in the range [min - max]
		 * @param	min	minimun number (inclusive)
		 * @param	max	maximum number (inclusive)
		 * @return	random number between the given range
		 */
		public static function getRandomNumber(min: Number, max: Number): Number {
			return min + Math.random() * (max - min);
		}
		
		/**
		 * Creates a randomized boolean
		 * @return
		 */
		public static function getRandomBoolean(): Boolean {
			return Math.random() >= 0.5;
		}
		
		/**
		 * Creates a random string with specified length
		 * @param	len	the length of the string
		 * @param	readSafe	if read safe is on, the string never contains I,l,0,O,o
		 * @return
		 */
		public static function getRandomString(len: int, readSafe: Boolean = false):String {
			if (len == 0 || isNaN(len)) len = 8;
			var s:String = "";
			for (var i: int = 1; i <= len; i++) {
				s += getRandomChar(readSafe);
			}
			//trace("random String: " + s);
			return s;		
		}
		
		/**
		 * Creates a random color value<br/>
		 * 0-255: dark color<br/>
		 * 255-383: neutral color<br/>
		 * 384-765: bright color
		 * @param	min	low color value
		 * @param	max	high color value
		 * @return
		 */
		public static function getRandomColor(min: uint = 0, max: uint = 765): uint {
			var rgbArr: Array = [];
			
			if (max > 765) max = 765;
			if (min > max) min = max;
			
			var safeMin: int = min - (255 * 2);
			var c: uint = getRandomInt(Math.max(0, safeMin), Math.min(255, max));
			rgbArr.push(c);
			//trace("min: " + min + ", max: " + max + ", safeMin: " + safeMin + ", range: " + (Math.max(0, safeMin)) + "-" + Math.min(255, max) + ", c: " + c);
			
			min -= c;
			max -= c;
			safeMin = min - (255 * 1);
			c = getRandomInt(Math.max(0, safeMin), Math.min(255, max));
			rgbArr.push(c);
			//trace("min: " + min + ", max: " + max + ", safeMin: " + safeMin + ", range: " + (Math.max(0, safeMin)) + "-" + Math.min(255, max) + ", c: " + c);
			
			min -= c;
			max -= c;
			safeMin = min - (255 * 0);
			c = getRandomInt(Math.max(0, safeMin), Math.min(255, max));
			rgbArr.push(c);
			//trace("min: " + min + ", max: " + max + ", safeMin: " + safeMin + ", range: " + (Math.max(0, safeMin)) + "-" + Math.min(255, max) + ", c: " + c);
			
			//shuffle array:
			for (var i:uint = 0; i < rgbArr.length; i++) {
			   var rand:uint = int(Math.random() * rgbArr.length);
			   rgbArr.push(rgbArr.splice( rand, 1 )[0] );
			}
			
			//trace("rgb: " + (rgbArr[0] + rgbArr[1] + rgbArr[2]));
			
			return ((rgbArr[0] << 16) | (rgbArr[1] << 8) | rgbArr[2]);
		}
		
		/**
		 * Create a random color which R, G, B ranging from min - max
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function getRandomColorSimple(min: uint = 0, max: uint = 255): uint {			
			var r: uint = getRandomInt(min, max);
			var g: uint = getRandomInt(min, max);
			var b: uint = getRandomInt(min, max);
			
			return ((r << 16) | (g << 8) | b);
		}
		
		/**
		 * Creates a random charater
		 * @return
		 */
		public static function getRandomChar(readSafe: Boolean = false):String {
			var r:String = "";
			var c:Number = getRandomInt(0, 2); //0: number, 1: upper case, 2: lower case
			switch (c) {
				case 0: r = String.fromCharCode(getRandomInt(48, 57)); break;
				case 1: r = String.fromCharCode(getRandomInt(65, 90)); break;
				case 2: r = String.fromCharCode(getRandomInt(97, 122)); break;
			}
			if(readSafe && (r == "I" || r == "l" || r == "o" || r == "O" || r == "0")) {
				r = getRandomChar(readSafe);
			}
			return r;
		}
		
		public static function getRandomIntExcept(min: Number, max: Number, exception: Array): Number {
			var r: Number;
			var isBad: Boolean = true;
			var c: Number = 0;
			
			//check if all exceptions match the range
			if (exception.length >= Math.abs(max - min) + 1) {
				return -1;
			}
			
			while (isBad) {
				r = Math.floor(Math.random() * (max - min + 1)) + min;
				isBad = false;
				c ++;
				if (c > 1000) return -1; //avoid infinitive loop
				for (var i: String in exception) {
					if (exception[i] == r) {
						isBad = true;
						break;
					}
				}
			}
			return r;
		}
		
		/**
		 * Gets a sequence in which order numbers are randomly arranged
		 * @param	min
		 * @param	max
		 * @return
		 * @deprecated It is recommended that you use ArrayUtil.shuffleArray()
		 */
		public static function getRandomSequence (min: int, max: int): Array {
			//NEW approach
			if (min > max) {
				var tmp:int = max;
				max = min;
				min = tmp;
			}
			//len
			var l: Number = Math.abs(max - min) + 1;
			//original sequence
			var o: Array = [];
			for (var i: uint = 0; i < l; i ++) {
				o[i] = min + i;
			}
			//return
			var r: Array = [];
			//child item
			var c: * ;
			while (true) {
				l = o.length;
				if (l > 0) {
					c = o.splice(getRandomInt(0,l - 1),1)[0];
					r.push(c);
				} else {
					break;
				}
			}
			return r;
		}
		
		/**
		 * OLD approach
		 * @param	min
		 * @param	max
		 * @return
		 * @deprecated
		 */
		public function getRandomSequence1 (min: int, max: int): Array {
			
			var l: Number = Math.abs(max - min) + 1;
			var n: Number;
			var e: Array = new Array();
			var r: Array = new Array();
			
			for (var i: Number = 0; i < l; i ++) {
				n = getRandomIntExcept(min, max, e);
				e.push(n);
				r[i] = n;
			}
			return r;
		}
		
	}
}