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
package org.thanhtran.maps {
	import com.google.maps.controls.ControlPosition;
	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.controls.PositionControl;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.extras.markermanager.MarkerManager;
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.interfaces.IMap;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.thanhtran.maps.events.GMapEvent;
	import org.thanhtran.maps.info.GMapInfo;
	import org.thanhtran.maps.info.VietnamInfo;
	import org.thanhtran.maps.types.DaylightMapType;
	import org.thanhtran.maps.types.FocationMapType;
	import org.thanhtran.maps.types.GMapType;
	
	/**
	* Currently using Google Map API v1.7
	* GMap Demo: detailed map of Vietnam
	* @author Thanh Tran
	*/
	public class GMap extends Map {
		public static const KEY_LOCALHOST: String = "ABQIAAAA3ppC0s640PIO9x7AW87DqRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQB41FQKRcFv8Ew4BvZ1eKoGBnQWA";
		public static const KEY_PRTHANHTRAN: String = "ABQIAAAA3ppC0s640PIO9x7AW87DqRRuMI1toEYSXeqxJdLU6FSiXe6wHRQN9O1_itBsTv3L4TzHUVGrokwfFw";
		public var positionControl: PositionControl;
		public var zoomControl: ZoomControl;
		public var mapTypeControl: MapTypeControl;
		public var flashMarker: Sprite;
		
		
		public function GMap() {
			super();
			//key = KEY_LOCALHOST;
			key = KEY_PRTHANHTRAN;
			
			positionControl = new PositionControl();
			zoomControl = new ZoomControl();
			mapTypeControl = new MapTypeControl();
			
			addControl(positionControl);
			addControl(zoomControl);
			addControl(mapTypeControl);
			
			addEventListener(MapEvent.MAP_READY, mapReadyHandler);
			addEventListener(MapEvent.MAP_PREINITIALIZE, mapPreinitializeHandler);
		}
		
		private function mapPreinitializeHandler(event: MapEvent): void {
			var map: Map = event.target as Map;
			map.setInitOptions(
				new MapOptions ({				
				// Set our initial map type.
				mapType: GMapType.HYBRID_MAP_TYPE,
				// Example of changing the order of the standard map types.
				mapTypes: [GMapType.NORMAP_MAP_TYPE, GMapType.HYBRID_MAP_TYPE, MapType.SATELLITE_MAP_TYPE],
				// Set our initial location.
				center: VietnamInfo.getHCMLatLng(),
				// Set our initial zoom level.
				zoom: 1,
				continuousZoom: true,
				crosshairs: true
			}));
		}
		
		private function mapReadyHandler(event: MapEvent): void {
			//trace("map ready, ver.:" + version);
			startMap();
		}
		
		protected function startMap(): void {
			testMaker();
			flashMarker = new Sprite();
			flashMarker.graphics.beginFill(0xFF0000, 0.7);
			flashMarker.graphics.drawCircle( -2, -2, 4);
			flashMarker.graphics.endFill();
			this.addChild(flashMarker);
			
		}
		
		protected function testMaker(): void {
			var markerOptions: MarkerOptions = 
			new MarkerOptions(
				{
					draggable: true,
					fillStyle: { color: 0xFF00FF },
					hasShadow: true
				}
			);
			var marker: Marker = new Marker(new LatLng(10.777071927010319, 106.6953992843628), markerOptions);
			marker.addEventListener(MapMouseEvent.DRAG_END, markerDragEndHandler);
			marker.addEventListener(MapMouseEvent.CLICK, markerClickHandler);
			//addOverlay(marker);
			
			var markerManager: MarkerManager = new MarkerManager(this, {});
			markerManager.addMarker(marker, 3,17);
			markerManager.refresh();
		}
		
		private function markerClickHandler(event: MapMouseEvent): void {
			var marker: Marker = event.target as Marker;
			var markerBounds:Rectangle = marker.foreground.getBounds(stage);
			var str: String = "LatLng: " + event.target.getLatLng() + "\n";
			str += "Bounds: " + markerBounds;
			marker.openInfoWindow(new InfoWindowOptions( { content: str } ));
			flashMarker.x = markerBounds.x + markerBounds.width / 2;
			flashMarker.y = markerBounds.y + markerBounds.height;
		}
		
		private function markerDragEndHandler(event: MapMouseEvent): void {
			trace("new LatLng: " + event.target.getLatLng());
			trace("marker.getDisplayObject() : " + event.target.getDisplayObject().x + "-" + event.target.getDisplayObject().y);
		}
		
		
	}
	
}