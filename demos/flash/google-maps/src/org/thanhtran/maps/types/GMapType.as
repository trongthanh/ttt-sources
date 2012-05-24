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
	import org.thanhtran.maps.overlays.GMapHybridTileLayer;
	import org.thanhtran.maps.overlays.GMapNormalTileLayer;
	
	/**
	* ...
	* @author Thanh Tran
	*/
	public class GMapType extends MapType implements IMapType {
		
		public function GMapType(tileLayers: Array = null, projection: IProjection = null, name: String = null, options: MapTypeOptions = null) {
			super(tileLayers, projection, name, options);
		}
		
		public static const NORMAP_MAP_TYPE: IMapType = new GMapType(getNormalMapLayers(), MapType.NORMAL_MAP_TYPE.getProjection(), "GMap Normal", getNormalMapOptions());
		
		public static const HYBRID_MAP_TYPE: IMapType = new GMapType(getHybridMapLayers(), MapType.HYBRID_MAP_TYPE.getProjection(), "GMap Hybrid", getHybridMapOptions());
		
		public static const DEFAULT_MAP_TYPES: Array = [NORMAP_MAP_TYPE, HYBRID_MAP_TYPE];
		
		
		
		public static function getNormalMapLayers(): Array {
			var layers: Array = []; //MapType.NORMAL_MAP_TYPE.getTileLayers();
			layers.push(new GMapNormalTileLayer());
			return layers;
		}
		
		public static function getHybridMapLayers(): Array {
			var layers: Array = MapType.SATELLITE_MAP_TYPE.getTileLayers();
			layers.push(new GMapHybridTileLayer());
			return layers;
		}
		
		
		public static function getNormalMapOptions(): MapTypeOptions {
			return new MapTypeOptions(
				{	shortName: "GMap Normal",
					urlArg: "s",
					tileSize: 256,
					textColor: Color.BLACK,
					linkColor: Color.DEFAULTLINK,
					errorMessage: "Tiles cannot be loaded",
					alt: new String("View normal street map"),
					radius: LatLng.EARTH_RADIUS,
					minResolution: 1,
					maxResolution: 18 
				});
			
		}
		
		public static function getHybridMapOptions(): MapTypeOptions {
			return new MapTypeOptions(
				{	shortName: "GMap Hybrid",
					urlArg: "h",
					tileSize: 256,
					textColor: Color.WHITE,
					linkColor: Color.DEFAULTLINK,
					errorMessage: "Tiles cannot be loaded",
					alt: new String("View hybrid street and satellite map"),
					radius: LatLng.EARTH_RADIUS,
					minResolution: 1,
					maxResolution: 17 
				});
		}
		
	}
	
}