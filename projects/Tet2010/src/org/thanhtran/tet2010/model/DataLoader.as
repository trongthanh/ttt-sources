/**
 * Copyright (c) 2010 trongthanh@gmail.com
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
package org.thanhtran.tet2010.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.thanhtran.tet2010.model.data.UserInfo;
	
	[Event(name='complete', type='flash.events.Event')]
	
	/**
	 * data loader: load and parse data
	 * @author Thanh Tran
	 */
	public class DataLoader extends EventDispatcher {
		public var friendList: Array;
		public var success: Boolean;
		public var url: String;
		
		public function DataLoader() {
			
		}
		
		public function load(dataURL: String): void {
			url = dataURL;
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeHandler, false,0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false,0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false,0, true);
			urlLoader.load(new URLRequest(dataURL));
			
			success = false;
		}
		
		private function errorHandler(event: Event): void {
			trace("Cannot load data");
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function completeHandler(event: Event): void {
			var xml: XML;
			
			try {
				xml = new XML(URLLoader(event.currentTarget).data);
			} catch (e: Error) {
				trace("Data error: " + e.message);
				return;
			}
			parseData(xml);
		}
		
		public function parseData(xml: XML): void {
			
			friendList = [];
			var friends: XMLList = xml.user;
			var friendInfo: UserInfo;
			for each (var friend:XML in friends) {
				friendInfo = new UserInfo();
				friendInfo.name = friend.name;
				friendInfo.profileURL = friend.profile_url;
				friendInfo.pic = friend.pic;
				friendInfo.uid = friend.uid;
				friendInfo.squarePic = friend.pic_square;
				friendList.push(friendInfo);
			}
			success = true;
			friendList.sort(randomSort);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function randomSort(a: UserInfo, b: UserInfo):int {
			var ran: int = int(Math.random() * 3) - 1; //randomize -1, 0, 1
			return ran;
		}
		
	}

}