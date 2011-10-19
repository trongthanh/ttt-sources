package com.pyco.utils {
	
	/**
	 * ...
	 * @author kitty
	 */
	public class StringUtil {
		
		public function StringUtil() {
			
		}
		
		public static function removeSpace(input:String, remove:String):String
		{
			return StringUtil.replace(input, remove, "");
		}
		
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			//change to StringBuilder
			var sb:String = new String();
			var found:Boolean = false;

			var sLen:Number = input.length;
			var rLen:Number = replace.length;

			for (var i:Number = 0; i < sLen; i++)
			{
				if(input.charAt(i) == replace.charAt(0))
				{   
					found = true;
					for(var j:Number = 0; j < rLen; j++)
					{
						if(!(input.charAt(i + j) == replace.charAt(j)))
						{
							found = false;
							break;
						}
					}

					if(found)
					{
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			//TODO : if the string is not found, should we return the original
			//string?
			return sb;
		}
		
		public static function trimAll(src: String): String {
			var start: Number = 0;
			while (src.charAt(start) == " ") {
				start++;
			}
			
			var end: Number = src.length - 1;
			while (src.charAt(end) == " ") {
				end--;
			}
			
			var des: String = src.slice(start, end + 1);
			return des;
		}
		
		public static function convertSecondsToMinutes(seconds: Number): String {
			var secondsString:String = "";
			if (seconds == 0) {
				return "00:00";
			}

			//trace( "seconds=== : " + (seconds%60) );
			//trace( "minute=== : " + (seconds/60) );
			
			if (seconds%60 < 10) // checks to see if it needs a leading zero
			{
				secondsString = "0"+ Math.floor(seconds%60);
			}
			else
			{
				secondsString = "" + Math.floor(seconds%60);
				// the double quotes are needed so it takes it as a string instead of a num
			}
			var minute: Number = seconds / 60;
			var minutesString: String = "";
			if (minute < 10) // checks to see if it needs a leading zero
			{
				minutesString = "0"+ Math.floor(minute);
			}
			else
			{
				minutesString = "" + Math.floor(minute);
				// the double quotes are needed so it takes it as a string instead of a num
			}
			var time:String=minutesString+':'+ secondsString;

			return time;
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
		
	}
	
}