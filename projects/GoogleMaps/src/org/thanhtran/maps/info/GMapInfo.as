/*
 * Copyright (c) 2008 Tran Trong Thanh - trongthanh@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.thanhtran.maps.info {
	import com.google.maps.Copyright;
	import com.google.maps.CopyrightCollection;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.interfaces.ICopyrightCollection
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	* This class provides information of Google provider
	* @author Thanh Tran - trongthanh@gmail.com
	*/
	public class GMapInfo extends EventDispatcher {
		public static const GMAP_GATEWAYS: Array = ["http://gt0.google.com/mt", "http://gt1.google.com/mt", "http://gt2.google.com/mt", "http://gt3.google.com/mt"];
		public static const MAPMAKER_URL: String = "http://www.google.com/mapmaker";
		private var _libVersion: String = "746";
		private var _isReady: Boolean = false;
		
		private static var _instance: GMapInfo = new GMapInfo();
		
		
		public function GMapInfo() {
			loadGMapVersion();
		}
		
		public static function get instance(): GMapInfo { return _instance; }
		
		public function get isReady(): Boolean { return _isReady; }
		public function get libVersion(): String { return _libVersion; }
		
		protected function loadGMapVersion(): void {
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, mapMakerLoadCompleteHandler);
			urlLoader.load(new URLRequest(MAPMAKER_URL));
		}
		
		private function mapMakerLoadCompleteHandler(event: Event): void {
			var urlLoader: URLLoader = (event.target as URLLoader);
			var reg: RegExp = /"gwm\.(\d{1,4})"/;
			var testString: String = String(urlLoader.data);
			_libVersion = testString.match(reg)[1].toString();
			_isReady = true;
			trace("GMap lib version: " + _libVersion);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Gets Copyright of Google Map
		 * @return
		 */
		public function getGMapCopyright(): Copyright {
			var copyright: Copyright = 
			new Copyright(
				"gmapmaker", 
				new LatLngBounds(new LatLng(-180, 90),
								 new LatLng(180, -90)),
				0, 
				"Google MapMaker",
				18 
				//true
			);
			return copyright;
		}

		public function getGMapCopyrightCollection(): ICopyrightCollection {
			var focationCopyCollection: CopyrightCollection = new CopyrightCollection();
			focationCopyCollection.addCopyright(getGMapCopyright());
			
			return focationCopyCollection;
		}
		
		public function getNormalTileURL(tilePosition: Point, zoom: Number): String {
			return getProcessedURL(tilePosition, zoom, "gwm")
		}
		
		public function getHybridTileURL(tilePosition: Point, zoom: Number): String {
			return getProcessedURL(tilePosition, zoom, "gwh")
		}
		
		protected function getProcessedURL(tilePosition: Point, zoom: Number, layer: String): String {
			//use multiple gateways to improve loading speed
			var numGateWays: int = GMAP_GATEWAYS.length;
			var tileX: int = tilePosition.x;
			var tileY: int = tilePosition.y;
			var altGateWay: int = (tileX + tileY) % numGateWays;
			//prevent error
			if (altGateWay < 0 || altGateWay >= numGateWays) altGateWay = 0;
			var newZoom: int = 18 - zoom;
			
			return GMAP_GATEWAYS[altGateWay] + "?n=404&v=" + layer + "." + libVersion + "&x=" + tileX + "&y=" + tileY + "&zoom=" + newZoom;
		}
		
	}
}
