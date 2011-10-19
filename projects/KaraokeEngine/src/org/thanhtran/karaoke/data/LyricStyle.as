/**
 * Copyright 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.thanhtran.karaoke.data {

	/**
	 * @author Thanh Tran
	 */
	public class LyricStyle {
		public static const BASIC: String = "b";
		public static const MALE: String = "m";
		public static const FEMALE: Stirng = "f";
		
		public var color: uint = 0x8AD420; //for woman: FF37BF, for man: 00CCFF
		public var strokeColor: uint = 0xFFFFFF; // 0x000000;
		public var font: String;
		public var size: Number;
		public var embedFonts: Boolean = false;
		
	}
}
