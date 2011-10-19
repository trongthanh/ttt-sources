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
package org.thanhtran.karaoke.utils {
	import org.thanhtran.karaoke.data.SongInfo;

	/**
	 * @author Thanh Tran
	 */
	public class TimedTextParser {
		public static var tt: Namespace = new Namespace("", "http://www.w3.org/ns/ttml");
		public static var tts: Namespace = new Namespace("tts", "http://www.w3.org/ns/ttml#styling");
		public static var ttm: Namespace = new Namespace("ttm", "http://www.w3.org/ns/ttml#metadata");
		
		default xml namespace = tt;
		
		public static function parseXML(xml: XML): SongInfo {
			
			return null;
		}
		
		/**
		 * <metadata>
			<ttm:title><![CDATA[Hạnh Phúc Bất Tận]]></ttm:title>
			<ttm:desc><![CDATA[Composed by: Nguyễn Đức Thuận<br/>Singers: Hồ Ngọc Hà ft. V.Music Band]]></ttm:desc>
			<ttm:copyright>Copyright (C) 2010 Thanh Tran - trongthanh@gmail.com</ttm:copyright>
			<audio>mp3/hanh_phuc_bat_tan.mp3</audio>
		</metadata>
		 * @param	head
		 * @param	songInfo
		 */
		public static function parseSongHead(head: XML, songInfo: SongInfo): void {
			songInfo.title = head.metadata.ttm::title[0];
			songInfo.description = head.metadata.ttm::desc[0];
			songInfo.copyright = head.metadata.ttm::copyright[0];
			songInfo.audio = head.metadata.audio;
		}
		
		public static function parseSongLyrics(body: XML, songInfo: SongInfo): void {
			
			
			
		}
	}
}
