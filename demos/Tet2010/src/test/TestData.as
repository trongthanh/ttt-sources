/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package test {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import org.thanhtran.tet2010.model.data.UserInfo;
	import org.thanhtran.tet2010.model.DataLoader;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#000000', frameRate='31', width='1024', height='768')]
	public class TestData extends MovieClip {
		public var dataLoader: DataLoader;
		
		public function TestData() {
			dataLoader = new DataLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoadCompleteHandler);
			dataLoader.load("xml/data.xml");
		}
		
		private function dataLoadCompleteHandler(event: Event): void {
			if (dataLoader.success) {
				var friendList: Array = dataLoader.friendList;
				var len: int = friendList.length;
				var xPos: int = 0;
				var yPos: int = 0;
				var loader: Loader;
				var friend: UserInfo;
				for (var i:int = 0; i < len; i++) {
					friend = friendList[i];
					if (friend && friend.squarePic) {
						loader = new Loader();
						loader.load(new URLRequest(friend.squarePic));
						loader.x = xPos;
						loader.y = yPos;
						addChild(loader);
						
						
					}
					xPos = (i % 20) * 50;
					yPos = int(i / 20) * 50;
				}
				
				
			}
		}
		
	}

}