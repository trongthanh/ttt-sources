package org.thanhtran.maps {
	import com.google.maps.controls.ControlPosition;
	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.controls.PositionControl;
	import com.google.maps.controls.ZoomControl;
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.thanhtran.maps.events.GMapEvent;
	import org.thanhtran.maps.info.DaylightMapInfo;
	import org.thanhtran.maps.info.GMapInfo;
	import org.thanhtran.maps.info.VietnamInfo;
	import org.thanhtran.maps.types.DaylightMapType;
	import org.thanhtran.maps.types.FocationMapType;
	import org.thanhtran.maps.types.GMapType;
	
	/**
	* This has been test with Google Map API v1.7, v1.9, v1.16
	* Testing Daylight Map type daylightmap.com
	* @author Thanh Tran
	*/
	public class DaylightMap extends Map {
		public static const KEY_LOCALHOST: String = "ABQIAAAA3ppC0s640PIO9x7AW87DqRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQB41FQKRcFv8Ew4BvZ1eKoGBnQWA";
		public static const KEY_PRTHANHTRAN: String = "ABQIAAAA3ppC0s640PIO9x7AW87DqRRuMI1toEYSXeqxJdLU6FSiXe6wHRQN9O1_itBsTv3L4TzHUVGrokwfFw";
		public var positionControl: PositionControl;
		public var zoomControl: ZoomControl;
		public var mapTypeControl: MapTypeControl;
		
		[Embed(source='/../assets/images/icon_full_sun.gif')]
		public var SunIconClass: Class;
		
		public function DaylightMap() {
			super();
			key = KEY_LOCALHOST;
			//key = KEY_PRTHANHTRAN;
			
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
				mapType: DaylightMapType.SATELLITE_MAP_TYPE,
				// Example of changing the order of the standard map types.
				mapTypes: DaylightMapType.DEFAULT_MAP_TYPES,
				// Set our initial location.
				center: VietnamInfo.getHCMLatLng(),
				// Set our initial zoom level.
				zoom: 1,
				continuousZoom: true,
				crosshairs: true
			}));
		}
		
		private function mapReadyHandler(event: MapEvent): void {
			startMap();
		}
		
		protected function startMap(): void {
			showSunPosition();
		}
		
		private function showSunPosition():void{
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, dataLoadCompleteHandler);
			urlLoader.load(new URLRequest(DaylightMapInfo.POINTINFO_GATEWAY));
		}
		
		private function dataLoadCompleteHandler(event: Event): void {
			var urlLoader: URLLoader = event.currentTarget as URLLoader;
			var xml: XML = new XML(urlLoader.data);
			
			var sunLat: Number = Number(xml.solar_lat);
			var sunLng: Number = Number(xml.solar_lon);
			
			var markerOptions: MarkerOptions = 
			new MarkerOptions(
				{
					draggable: false
					//, fillStyle: { color: 0xFF00FF }
					, hasShadow: true
					, icon: new SunIconClass()
					, iconOffset: new Point(-16, -16)
				}
			);
			var marker: Marker = new Marker(new LatLng(sunLat, sunLng), markerOptions);
			marker.addEventListener(MapMouseEvent.CLICK, markerClickHandler);
			addOverlay(marker);
		}
		
		
		
		private function markerClickHandler(event: MapMouseEvent): void {
			var marker: Marker = event.target as Marker;
			marker.openInfoWindow(new InfoWindowOptions({content: "Sun position"}));
		}	
	}
}