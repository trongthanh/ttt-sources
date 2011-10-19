/*
 * Copyright (c) 2010 Tran Trong Thanh - trongthanh@gmail.com
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
package int3ractive.arinvitation.faces.back {

	import com.google.maps.controls.ControlPosition;
	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.controls.PositionControl;
	import com.google.maps.controls.ZoomControl;
	import flash.text.TextFormat;
	import int3ractive.arinvitation.config.GlobalConfig;
	//import com.google.maps.extras.markermanager.MarkerManager;
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
	
	/**
	* Currently using Google Map API v1.7
	* GMap Demo: detailed map of Vietnam
	* @author Thanh Tran
	*/
	public class VenueMap extends Map {
		public static const KEY_LOCALHOST: String = "ABQIAAAA3ppC0s640PIO9x7AW87DqRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQB41FQKRcFv8Ew4BvZ1eKoGBnQWA";
		public static const KEY_PRTHANHTRAN: String = "ABQIAAAA3ppC0s640PIO9x7AW87DqRRuMI1toEYSXeqxJdLU6FSiXe6wHRQN9O1_itBsTv3L4TzHUVGrokwfFw";
		
		protected var positionControl: PositionControl;
		protected var zoomControl: ZoomControl;
		protected var mapTypeControl: MapTypeControl;
		protected var flashMarker: Sprite;
		protected var infoWindowOptions: InfoWindowOptions;
		private var marker:Marker;
		
		
		public function VenueMap(w: uint = 300, h: uint = 300) {
			super();
			//key = KEY_LOCALHOST;
			key = KEY_PRTHANHTRAN;
			sensor = "false";
			
			width = w;
			height = h;
			
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
				mapType: MapType.NORMAL_MAP_TYPE
				// Example of changing the order of the standard map types.
				,mapTypes: [MapType.NORMAL_MAP_TYPE, MapType.HYBRID_MAP_TYPE]
				// Set our initial location.
				,center: VenueInfo.getInfo(VenueInfo.LOCATION, GlobalConfig.locale)
				// Set our initial zoom level.
				,zoom: 16
				,continuousZoom: true
				,crosshairs: false
			}));
			
			infoWindowOptions = new InfoWindowOptions(
			{
				title: VenueInfo.getInfo(VenueInfo.NAME, GlobalConfig.locale)
				,titleFormat: new TextFormat("_sans", 14, 0xFF0000, true)
				,content: VenueInfo.getInfo(VenueInfo.ADDRESS, GlobalConfig.locale)
				,width: 200
				,height: 100
			});
		}
		
		private function mapReadyHandler(event: MapEvent): void {
			//trace("map ready, ver.:" + version);
			startMap();
		}
		
		protected function startMap(): void {
			testMarker();
			//flashMarker = new Sprite();
			//flashMarker.graphics.beginFill(0xFF0000, 0.7);
			//flashMarker.graphics.drawCircle( -2, -2, 4);
			//flashMarker.graphics.endFill();
			//this.addChild(flashMarker);
			marker.openInfoWindow(infoWindowOptions);
			
		}
		
		protected function testMarker(): void {
			var markerOptions: MarkerOptions = 
			new MarkerOptions(
				{
					draggable: false //was true
					,fillStyle: { color: 0xFF00FF }
					,hasShadow: true
				}
			);
			marker = new Marker(LatLng(VenueInfo.getInfo(VenueInfo.LOCATION, GlobalConfig.locale)), markerOptions);
			marker.addEventListener(MapMouseEvent.DRAG_END, markerDragEndHandler);
			marker.addEventListener(MapMouseEvent.CLICK, markerClickHandler);
			addOverlay(marker);
			
/*			var markerManager: MarkerManager = new MarkerManager(this, {});
			markerManager.addMarker(marker, 3,17);
			markerManager.refresh();
*/		}
		
		private function markerClickHandler(event: MapMouseEvent): void {
			var marker: Marker = event.target as Marker;
			var markerBounds:Rectangle = marker.foreground.getBounds(stage);

			marker.openInfoWindow(infoWindowOptions);
			
			flashMarker.x = markerBounds.x + markerBounds.width / 2;
			flashMarker.y = markerBounds.y + markerBounds.height;
		}
		
		private function markerDragEndHandler(event: MapMouseEvent): void {
			trace("new LatLng: " + event.target.getLatLng());
			trace("marker.getDisplayObject() : " + event.target.getDisplayObject().x + "-" + event.target.getDisplayObject().y);
		}
		
		
	}

}