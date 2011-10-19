/*
 * Copyright (c) 2008 Tran Trong Thanh - trongthanh@gmail.com
 * Daylight data service (c) www.daylightmap.com
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
	import com.google.maps.interfaces.ICopyrightCollection;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	/**
	 * This class provide information of DaylightMap - daylightmap.com
	 * 
	 * @author Thanh Tran
	 */
	public class DaylightMapInfo extends EventDispatcher {
		public static const DAYLIGHT_GATEWAYS: Array = ["http://www.daylightmap.com/tiles/cache/"];
		public static const POINTINFO_GATEWAY: String = "http://www.daylightmap.com/point_info.php"; //http://www.daylightmap.com/point_info.php?nPointID=1&fLatitude=51.506325&fLongitude=-0.127144&dtmWhen=1231923180&nMapOffset=14
		//http://www.earthtools.org/webservices.htm#timezone
		private static var _instance: DaylightMapInfo = new DaylightMapInfo();
		
		public function DaylightMapInfo() {
			if (_instance) {
				throw new Error("Singleton Exception: DaylightMapInfo");
			}
		}
		
		static public function get instance(): DaylightMapInfo { return _instance; }
		
		/**
		 * Gets Copyright of Day Light Map
		 * @return
		 */
		public function getDaylightMapCopyright(): Copyright {
			var copyright: Copyright = 
			new Copyright(
				"daylightmap", 
				new LatLngBounds(new LatLng(-180, 90),
								 new LatLng(180, -90)),
				0, 
				"DaylightMap",
				18, 
				true
			);
			return copyright;
		}

		public function getDaylightMapCopyrightCollection(): ICopyrightCollection {
			var copyrightCollection: CopyrightCollection = new CopyrightCollection();
			copyrightCollection.addCopyright(getDaylightMapCopyright());
			
			return copyrightCollection;
		}
		
		public function getDaylightOverlayTileURL(tilePosition: Point, zoom: Number, withNightLights: Boolean = false): String {
			var now: Date = new Date();
			return getProcessedURL(tilePosition, zoom, now, withNightLights);
		}
		
		protected function getProcessedURL(tilePosition: Point, zoom: Number, time: Date, withNightLights: Boolean): String {
			//use multiple gateways to improve loading speed
			var numGateWays: int = DAYLIGHT_GATEWAYS.length;
			var tileX: int = tilePosition.x;
			var tileY: int = tilePosition.y;
			var altGateWay: int = (tileX + tileY) % numGateWays;
			//prevent error
			if (altGateWay < 0 || altGateWay >= numGateWays) altGateWay = 0;
			
			//get universal seconds, round it up to 10 minutes to reduce refresh:
			var secs: int = int(Math.round((time.getTime() / 1000) / 600) * 600);
			var lightOn: String = (withNightLights)? "n_" : "";
			
			return DAYLIGHT_GATEWAYS[altGateWay] + "tile_" + lightOn + zoom + "_" + tileX + "_" + tileY + "_" + secs + ".png";			
		}
		
	}
	
}