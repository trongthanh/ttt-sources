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
package org.thanhtran.maps.types {
	import com.google.maps.Color;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IProjection;
	import com.google.maps.LatLng;
	import com.google.maps.MapType;
	import com.google.maps.MapTypeOptions;
	import org.thanhtran.maps.info.DaylightMapInfo;
	import org.thanhtran.maps.overlays.DaylightTileLayer;
	
	/**
	 * ...
	 * @author Thanh Tran - trongthanh@gmail.com
	 */
	public class DaylightMapType extends MapType {
		private static var _normalMapType: IMapType;
		private static var _satelliteMapType: IMapType;
		private static var _hybridMapType: IMapType;
		
		public function DaylightMapType(tileLayers: Array = null, projection: IProjection = null, name: String = null, options: MapTypeOptions = null) {
			super(tileLayers, projection, name, options);
		}
		
		public static function get NORMAL_MAP_TYPE(): IMapType { 
			if (!_normalMapType) _normalMapType = new DaylightMapType(getDaylightNormalMapLayers(), MapType.NORMAL_MAP_TYPE.getProjection(), "Daylight Normal", getDaylightNormalMapOptions());
			return _normalMapType;
		}
		
		public static function get SATELLITE_MAP_TYPE(): IMapType { 
			if (!_satelliteMapType) _satelliteMapType = new DaylightMapType(getDaylightSatelliteMapLayers(), MapType.SATELLITE_MAP_TYPE.getProjection(), "Daylight Satellite", getDaylightSatelliteMapOptions());
			return _satelliteMapType;
		}
		
		public static function get HYBRID_MAP_TYPE(): IMapType { 
			if (!_hybridMapType) _hybridMapType = new DaylightMapType(getDaylightHybridMapLayers(), MapType.HYBRID_MAP_TYPE.getProjection(), "Daylight Hybrid", getDaylightHybridMapOptions());
			return _hybridMapType;
		}
		
		public static function get DEFAULT_MAP_TYPES(): Array {
			return [NORMAL_MAP_TYPE, SATELLITE_MAP_TYPE, HYBRID_MAP_TYPE];
		}
		
		public static function getDaylightNormalMapLayers(): Array {
			var layers: Array = MapType.NORMAL_MAP_TYPE.getTileLayers();
			layers.push(new DaylightTileLayer(false));
			return layers;
		}
		
		public static function getDaylightSatelliteMapLayers(): Array {
			var layers: Array = MapType.SATELLITE_MAP_TYPE.getTileLayers();
			layers.push(new DaylightTileLayer(true));
			return layers;
		}
		
		public static function getDaylightHybridMapLayers(): Array {
			var layers: Array = MapType.HYBRID_MAP_TYPE.getTileLayers();
			//insert daylight layer before the labels layer
			layers.splice( -1, 0, new DaylightTileLayer(true));
			return layers;
		}
		
		public static function getDaylightNormalMapOptions(): MapTypeOptions {
			return new MapTypeOptions(
				{	shortName: "Daylight Normal",
					urlArg: "dl",
					tileSize: 256,
					textColor: Color.BLACK,
					linkColor: Color.DEFAULTLINK,
					errorMessage: "Tiles cannot be loaded",
					alt: new String("View Daylight Normal Map"),
					radius: LatLng.EARTH_RADIUS,
					minResolution: 1,
					maxResolution: 18
				});	
		}
		
		public static function getDaylightSatelliteMapOptions(): MapTypeOptions {
			return new MapTypeOptions(
				{	shortName: "Daylight Satellite",
					urlArg: "dl",
					tileSize: 256,
					textColor: Color.WHITE,
					linkColor: Color.DEFAULTLINK,
					errorMessage: "Tiles cannot be loaded",
					alt: new String("View Daylight Satellite Map"),
					radius: LatLng.EARTH_RADIUS,
					minResolution: 1,
					maxResolution: 18
				});	
		}
		
		public static function getDaylightHybridMapOptions(): MapTypeOptions {
			return new MapTypeOptions(
				{	shortName: "Daylight Hybrid",
					urlArg: "dl",
					tileSize: 256,
					textColor: Color.WHITE,
					linkColor: Color.DEFAULTLINK,
					errorMessage: "Tiles cannot be loaded",
					alt: new String("View Daylight Hybrid Map"),
					radius: LatLng.EARTH_RADIUS,
					minResolution: 1,
					maxResolution: 17
				});	
		}
		
	}
	
}