package org.thanhtran.maps.types {
	import com.google.maps.Color;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IProjection;
	import com.google.maps.LatLng;
	import com.google.maps.MapType;
	import com.google.maps.MapTypeOptions;
	import org.thanhtran.maps.overlays.FocationHybridTileLayer;
	import org.thanhtran.maps.overlays.FocationNormalTileLayer;
	
	/**
	* ...
	* @author Thanh Tran
	*/
	public class FocationMapType extends MapType implements IMapType {
		
		public function FocationMapType(tileLayers: Array = null, projection: IProjection = null, name: String = null, options: MapTypeOptions = null) {
			super(tileLayers, projection, name, options);
		}
		
		public static const NORMAP_MAP_TYPE: IMapType = new FocationMapType(getNormalMapLayers(), MapType.NORMAL_MAP_TYPE.getProjection(), "Normal", getNormalMapOptions());
		
		public static const HYBRID_MAP_TYPE: IMapType = new FocationMapType(getHybridMapLayers(), MapType.HYBRID_MAP_TYPE.getProjection(), "Hybrid", getHybridMapOptions());
		
		public static const DEFAULT_MAP_TYPES: Array = [NORMAP_MAP_TYPE, HYBRID_MAP_TYPE];
		
		
		public static function getNormalMapLayers(): Array {
			var layers: Array = []; //MapType.NORMAL_MAP_TYPE.getTileLayers();
			layers.push(new FocationNormalTileLayer());
			return layers;
		}
		
		public static function getHybridMapLayers(): Array {
			var layers: Array = MapType.SATELLITE_MAP_TYPE.getTileLayers();
			layers.push(new FocationHybridTileLayer());
			return layers;
		}
		
		public static function getNormalMapOptions(): MapTypeOptions {
			return new MapTypeOptions(
				{	shortName: "Focation Normal",
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
				{	shortName: "Focation Hybrid",
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