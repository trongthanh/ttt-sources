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
package org.thanhtran.tet2010.view {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import org.thanhtran.tet2010.model.data.UserInfo;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class ThumbImage extends Sprite {
		public static const WIDTH: uint = 50;
		public static const HEIGHT: uint = 50;
		public static const NO_IMAGE: NoImage = new NoImage();
		
		public var bitmap: Bitmap;
		public var userInfo: UserInfo;
		public var success: Boolean;
		private var loader:Loader;
		private var timeOutId: uint;
		
		public function ThumbImage() {
			
		}
		
		public function load(user: UserInfo): void {
			userInfo = user;
			
			if (user.squarePic) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
				loader.load(new URLRequest(user.squarePic), new LoaderContext(true));
				timeOutId = setTimeout(loadTimeOutHandler, 3000);
			} else {
				loadErrorHandler();
			}
		}
		
		private function loadTimeOutHandler():void {
			trace("User thumb load time out: " + userInfo.squarePic);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loadErrorHandler();
		}
		
		private function createNoImage(): void {
			NO_IMAGE.nameText.width = WIDTH;
			NO_IMAGE.nameText.autoSize = "center";
			NO_IMAGE.nameText.wordWrap = true;
			NO_IMAGE.nameText.text = userInfo.name;
			NO_IMAGE.nameText.y = (HEIGHT - NO_IMAGE.nameText.height) / 2;
			var bitmapData: BitmapData = new BitmapData(WIDTH, HEIGHT, false);
			bitmapData.draw(NO_IMAGE);
			bitmap = new Bitmap(bitmapData);
			bitmap.x = - bitmap.width / 2;
			bitmap.y = - bitmap.height / 2;
			addChild(bitmap);
		}
		
		private function loadErrorHandler(event: IOErrorEvent = null): void {
			trace( "loadErrorHandler : " + userInfo.name, userInfo.squarePic);
			clearTimeout(timeOutId);
			createNoImage();
			success = false;
			dispatchEvent(new Event(Event.COMPLETE, false));
		}
		
		private function loadCompleteHandler(event: Event): void {
			var loaderInfo: LoaderInfo = event.currentTarget as LoaderInfo;

			bitmap = loaderInfo.content as Bitmap;
			if (bitmap) {
				success = true;
				bitmap.x = - bitmap.width / 2;
				bitmap.y = - bitmap.height / 2;
				addChild(bitmap);
			} else {
				createNoImage();
				success = false;
			}
			
			clearTimeout(timeOutId);
			dispatchEvent(new Event(Event.COMPLETE, false));
		}
		
	}

}