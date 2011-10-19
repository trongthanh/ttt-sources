package org.thanhtran.maps.info {
	import com.google.maps.Copyright;
	import com.google.maps.CopyrightCollection;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.interfaces.ICopyrightCollection
	import flash.geom.Point;

	/**
	* This class provides information of Focation.com provider
	* @author Thanh Tran - trongthanh@gmail.com
	*/
	public class FocationMapInfo extends Object {
		public static const FOCATION_GATEWAY: String = "http://www.focation.com/MapData/";
		
		public function FocationMapInfo() {
			
			
		}
		
		public static function getFocationCopyright(): Copyright {
			var focationCopyright: Copyright = 
			new Copyright(
				"focation", 
				VietnamInfo.getVNLatLngBounds(),
				0, 
				"Focation.com"
				//17, 
				//true
			);
			return focationCopyright;
		}

		public static function getFocationCopyrightCollection(): ICopyrightCollection {			
			var focationCopyCollection: CopyrightCollection = new CopyrightCollection();
			focationCopyCollection.addCopyright(getFocationCopyright());
			
			return focationCopyCollection;
		}
		
		public static function getNormalTileURL(tilePosition: Point, zoom: Number): String {
			return FOCATION_GATEWAY + "GM_z" + zoom + "_x" + tilePosition.x + "_y" + tilePosition.y;
		}
		
		public static function getHybridTileURL(tilePosition: Point, zoom: Number): String {
			return FOCATION_GATEWAY + "GH_z" + zoom + "_x" + tilePosition.x + "_y" + tilePosition.y;
		}
		
	}
}
