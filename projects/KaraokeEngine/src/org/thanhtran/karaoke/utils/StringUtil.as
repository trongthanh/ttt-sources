package org.thanhtran.karaoke.utils {
	
	/**
	 * @author Thu.Hoang, Thanh Tran
	 */
	public class StringUtil {
		
		/**
		 * Remove leading and trailing spaces
		 * @param	source	String needs to be removed leading and trailing spaces.
		 * @return
		 */
		public static function trim(source:String):String {
			if (!source) { 
				return ""; 
			}
			return source.replace(/^\s+|\s+$/g, '');
		}

		/**
		 * Remove leading spaces
		 * @param	source	String needs to be removed leading space.
		 * @return
		 */
		public static function trimLeft(source:String):String {
			if (!source) { 
				return ""; 
			}
			return source.replace(/^\s+/, '');
		}

		/**
		 * Remove trailing spaces
		 * @param	source	String needs to be removed trailing space.
		 * @return
		 */
		public static function trimRight(source:String):String {
			if (!source) { 
				return ""; 
			}
			return source.replace(/\s+$/, '');
		}
		
		/**
		 * Truncate source string and attach suffix after to form a new string fit in a specific length.
		 * @param	source		Original string.
		 * @param	length		The length storing enough some WORDS of source string and suffix.
		 * @param	suffix		The suffix added after truncating source string.
		 * @return
		 */
		public static function truncate(source:String, length:uint, suffix:String = "..."):String {
			if (source == null) { 
				return ""; 
			}
			length -= suffix.length;
			var trunc:String = source;
			if (trunc.length > length) {
				trunc = trunc.substr(0, length);
				if (/[^\s]/.test(source.charAt(length))) {
					trunc = trimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += suffix;
			}

			return trunc;
		}
		
		/**
		 * Change the first character of source string to uppercase.
		 * @param	s	Original string.
		 * @return
		 */
		public static function toProperCase(s: String): String {
			return s.replace(/(^| )[a-z]/mg, function (m: String, ... rest): String {
				return m.toUpperCase();
			});
		} 
		
		/**
		 * Replace all matched strings with a specific content.
		 * @param	src		Original string.
		 * @param	from	Pattern string needs to be replaced.
		 * @param	to		String is used to replace.
		 * @return
		 */
		public static function replace(src: String, from: String, to: String): String {
			var reg: RegExp = new RegExp(from, "g");
			return src.replace(reg, to);
		}
		
		public static function replace2(source: String, findingChar: String, replaceChar: String): String {
			return source.split(findingChar).join(replaceChar);
		}
		
		/**
		 * Parse a text which has prefix and/or suffix
		 * @param	s		the input text
		 * @param	prefix	prefix
		 * @param	suffix	suffix
		 * @return	an object whose properties contain 3 parts of the text: mainText, prefix and suffix.<br/>
		 * If both prefix and suffix are not found, return null.
		 */
		/*public static function parseTextWithAffixes(s: String, prefix: String = null, suffix: String = null ): Object {
			var regStr: String = "(?P<mainText>.+)";
			if (prefix) regStr = "^(?P<prefix>\\s*" + prefix + ")" + regStr;
			if (suffix) regStr = regStr + "(?P<suffix>" + suffix + "\\s*)$";
			var reg: RegExp = new RegExp(regStr);
			var result: Object = reg.exec(s);
			return result;
		}*/
		
		/**
		 * Remove CR from a pair of new line maker CRLF to avoid double new line
		 * @param	src	String needs to be removed CR from a pair of new line maker CRLF to avoid double new line.
		 * @return
		 */
		public static function trimNewLine(src: String): String {
			var newStr: String = replace(src, "\r\n", "\n");
			return newStr;
		}
	}

}