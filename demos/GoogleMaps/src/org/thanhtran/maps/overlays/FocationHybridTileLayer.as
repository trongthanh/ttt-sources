package org.thanhtran.maps.overlays {

	import com.google.maps.CopyrightCollection;
	import com.google.maps.interfaces.ICopyrightCollection;
	import com.google.maps.interfaces.ITileLayer;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.TileLayerBase;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import org.thanhtran.maps.info.FocationMapInfo;
	
	
	public class FocationHybridTileLayer extends TileLayerBase implements ITileLayer {
		public static const MIN_RESOLUTION: Number = 0;
		public static const MAX_RESOLUTION: Number = 17;
		
		public function FocationHybridTileLayer(alpha: Number = 1) {
			super(FocationMapInfo.getFocationCopyrightCollection(), MIN_RESOLUTION, MAX_RESOLUTION, alpha);
		}
		
		override public function loadTile(tilePosition: Point, zoom: Number): DisplayObject {
			var loader: Loader = new Loader();
			var tileUrl: String = FocationMapInfo.getHybridTileURL(tilePosition, zoom);
			loader.load(new URLRequest(tileUrl));
			return loader;
		}
		
	}
}
