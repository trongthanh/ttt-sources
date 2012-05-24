package org.thanhtran.maps.types {
	import com.google.maps.Color;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IProjection;
	import com.google.maps.LatLng;
	import com.google.maps.MapType;
	import com.google.maps.MapTypeOptions;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Earth3DMapType extends MapType implements IMapType {
		
		public static const HYBRID_MAP_TYPE: IMapType = new Earth3DMapType(MapType.HYBRID_MAP_TYPE.getTileLayers(), MapType.HYBRID_MAP_TYPE.getProjection(), "Earth 3D Map Type", Earth3DMapType.getHybridMapOptions());
		
		public function Earth3DMapType(tileLayers: Array = null, projection: IProjection = null, name: String = null, options: MapTypeOptions = null) {
			super(tileLayers, projection, name, options);
			
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
					minResolution: 7,
					maxResolution: 17 
				});
		}
		
	}
	
}