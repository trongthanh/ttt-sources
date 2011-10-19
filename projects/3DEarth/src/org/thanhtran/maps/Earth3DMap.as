package org.thanhtran.maps {
	import com.google.maps.Alpha;
	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.controls.PositionControl;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IZoomControl;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.google.maps.MapTypeOptions;
	import com.google.maps.styles.FillStyle;
	import flash.geom.Point;
	import org.thanhtran.maps.types.Earth3DMapType;
	
	/**
	* ...
	* @author Thanh Tran
	*/
	public class Earth3DMap extends Map {
		public static const KEY_LOCALHOST: String = "ABQIAAAA3ppC0s640PIO9x7AW87DqRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQB41FQKRcFv8Ew4BvZ1eKoGBnQWA";
		public static const KEY_PRTHANHTRAN: String = "ABQIAAAA3ppC0s640PIO9x7AW87DqRRuMI1toEYSXeqxJdLU6FSiXe6wHRQN9O1_itBsTv3L4TzHUVGrokwfFw";
		
		public function Earth3DMap() {
			super();
			//key = KEY_LOCALHOST;
			key = KEY_PRTHANHTRAN;
			
			addEventListener(MapEvent.MAP_READY, mapReadyHandler);
			addEventListener(MapEvent.MAP_PREINITIALIZE, mapPreinitializeHandler);
			visible = false;
			//alpha = 0.5;
			
		}
		
		private function mapPreinitializeHandler(event: MapEvent): void {
			var map:Map = event.target as Map;			
			var earth3DMap: IMapType = Earth3DMapType.HYBRID_MAP_TYPE;
			
			map.setInitOptions(
				new MapOptions({
					// Set our initial map type.
					mapType: earth3DMap,
					// Example of changing the order of the standard map types.
					mapTypes: [earth3DMap],
					continuousZoom: true,
					backgroundFillStyle: new FillStyle({alpha: 0, color:0xFFFFFF})
			}));
		}
		
		private function mapReadyHandler(event: MapEvent): void {
			trace("map ready, ver.:" + version);
			addControl(new ZoomControl());
			
			startMap();
		}
		
		protected function startMap(): void {
			//setCenter(new LatLng(0, 0), 1, MapType.SATELLITE_MAP_TYPE);
			
		}
	}
	
}