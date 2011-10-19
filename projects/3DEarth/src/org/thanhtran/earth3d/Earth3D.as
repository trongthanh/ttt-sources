package org.thanhtran.earth3d {
	import com.pyco.utils.pv3d.SizeConverter;
	import flash.display.Bitmap;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.utils.virtualmouse.VirtualMouse;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	import org.thanhtran.earth3d.events.Earth3DMouseEvent;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Earth3D extends DisplayObject3D {
		
		[Embed(source='../../../../assets/images/map_zoom_1.jpg')]
		protected var EarthBitmap: Class;
		
		protected var earthSphere: Sphere;
		
		protected var radius: Number;
		
		protected var bitmapW: Number;
		protected var bitmapH: Number;
		
		protected var _centerLat: Number;
		protected var _centerLng: Number;
		
		protected var isRotating: Boolean;
		protected var isMouseDown: Boolean;
		
		protected var lngOffset: Number = - 100;
		
		/** needed to calculate Lat/Lng */
		public var virtualMouse: VirtualMouse;
		
		public function Earth3D(virtualMouse: VirtualMouse = null, earthBitmapMaterial: MaterialObject3D = null, radius:Number = 500) {
			this.virtualMouse = virtualMouse;
			this.radius = radius;
			
			if (!earthBitmapMaterial) {
				var earthBitmap: Bitmap = new EarthBitmap();
				earthBitmapMaterial = new BitmapMaterial(earthBitmap.bitmapData);
				earthBitmapMaterial.interactive = true;
				//testing:
				//earthBitmapMaterial.lineAlpha = 1;
				//earthBitmapMaterial.lineColor = 0x00FF00;
				//earthBitmapMaterial.lineThickness = 1;
				
			}
			
			earthSphere = new Sphere(earthBitmapMaterial, radius, 36, 18);
			//earthSphere.useOwnContainer = true;
			earthSphere.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, spherePressHandler);
			earthSphere.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, sphereReleaseHandler);
			//earthSphere.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE_OUTSIDE, sphereReleaseOutsideHandler);
			earthSphere.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, sphereOverHandler);
			earthSphere.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, sphereOutHandler);
			earthSphere.addEventListener(InteractiveScene3DEvent.OBJECT_MOVE, sphereMoveHandler);
			
			
			bitmapW = earthBitmapMaterial.bitmap.width;
			bitmapH = earthBitmapMaterial.bitmap.height;
			centerLat = 0;
			centerLng = 0;
			
			addChild(earthSphere, "earthSphere");
		}
		
		private function sphereMoveHandler(event: InteractiveScene3DEvent): void {
			dispatchEvent(new Earth3DMouseEvent(Earth3DMouseEvent.EARTH_MOUSE_MOVE, mouseLat, mouseLng, _centerLat, _centerLng));
		}
		
		private function sphereOutHandler(event: InteractiveScene3DEvent): void {
			dispatchEvent(new Earth3DMouseEvent(Earth3DMouseEvent.EARTH_OUT, NaN, NaN, _centerLat, _centerLng));
		}
		
		private function sphereOverHandler(event: InteractiveScene3DEvent): void {
			dispatchEvent(new Earth3DMouseEvent(Earth3DMouseEvent.EARTH_OVER, mouseLat, mouseLng, _centerLat, _centerLng));
		}
		
		private function spherePressHandler(event: InteractiveScene3DEvent): void {
			isMouseDown = true;
			dispatchEvent(new Earth3DMouseEvent(Earth3DMouseEvent.EARTH_PRESS, mouseLat, mouseLng, _centerLat, _centerLng));
			//trace("mouse down");
		}
		
		private function sphereReleaseHandler(event: InteractiveScene3DEvent): void {
			isMouseDown = false;
			dispatchEvent(new Earth3DMouseEvent(Earth3DMouseEvent.EARTH_RELEASE, mouseLat, mouseLng, _centerLat, _centerLng));
			//trace("mouse up");
		}
		
		public function get mouseLat(): Number {
			if (!virtualMouse) return NaN;
			else return fromYtoLat(virtualMouse.y);
		}
		
		public function get mouseLng(): Number {
			if (!virtualMouse) return NaN;
			else return fromXtoLng(virtualMouse.x);
		}
		
		protected function fromXtoLng(x: Number): Number {
			return ((360 / bitmapW) * x - 180);
		}
		
		protected function fromYtoLat(y: Number): Number {
			return (90 - (180 / bitmapH) * y);
		}
		
		public function setCenter(lat: Number, lng: Number, withEase: Boolean): void {
			
		}
		
		public function get centerLat(): Number { return _centerLat; }
		
		public function set centerLat(value: Number): void {
			_centerLat = value;
			this.rotationX = - _centerLat;
		}
		
		public function get centerLng(): Number { return _centerLng; }
		
		public function set centerLng(value: Number): void {
			//trace("_centerLng: " + _centerLng + " - value: " + value + " = " + (_centerLng - value));
			//var rot: Number = earthSphere.rotationY;
			//if (Math.abs(_centerLng - value) > 180) {
				//rot += 360;
				//trace("over 180");
				//earthSphere.rotationY += (180 - value - rot + lngOffset);
			//} else {
				//earthSphere.rotationY += (value - rot + lngOffset);
			//}
			
			earthSphere.rotationY = lngOffset + value;
			_centerLng = value;			
			
		}
		
		/**
		 * Gets the z coordinate of the camera where earth's tiles fit Google Map's tiles in size for a given zoom level <br/>
		 * Explanation:<br/>
		 * Number of Google Map tiles in one dimension is 2^zoom (for e.g.: zoom 5 -> 2^5 = 32 pieces).<br/>
		 * Therefore number of degrees covered by each tile is: GTileDegrees = 360 / 2^zoom.<br/>
		 * <br/>
		 * For the Earth, there are 36 segments -> each segment covers 10 degree.<br/>
		 * <br/>
		 * 1 GMap tiles (256px)	covers	360 / 2^zoom (degrees)			<br/>
		 * 1 Earth tiles (?px)	covers	10 (degrees)					<br/>
		 * => expected Earth tile size = 10 * 256 / (360 / 2^zoom);		<br/>
		 * <br/>
		 * With the help of my SizeConverter, I can get the distance from the camera to the sphere 
		 * where the earth surface appears with expected size in 2D.
		 * 
		 * @param	camera	current camera
		 * @param	zoom	zoom level (equivalent to Google Map zoom level)
		 * @param	lat		lattitude where the camera will zoom to
		 * @return	z coordinate
		 */
		public function getCameraZForZoom(camera: CameraObject3D, zoom: Number, lat: Number): Number {
			var tileBirthSize: Number = (2 * radius * Math.PI) / 36; //circumference divided by segmentW
			var expectedTileSize: Number = 256 * 10 / (360 / Math.pow(2, zoom));
			
			//correct Mercator Projection's distortion
			var latRad: Number = lat * Math.PI / 180;
			//the scale is proportional to the secant of the latitude (sec a = 1 / cos a
			var scale: Number = 1 / Math.cos(latRad);
			expectedTileSize *= scale;
			
			
			var distance: Number = SizeConverter.calculateCameraDistanceForSize(camera, tileBirthSize, expectedTileSize);
				distance += radius;
			
			var newZ: Number;
			
			if (camera.z > this.z) {
				newZ = this.z + distance;
			} else {
				newZ = this.z - distance;
			}
			
			return newZ;
		}
		
		//------------------- static methods ---------------------------
		
		public static function formatLatStr(lat: Number): String {			
			return getDegMinSec(lat, "N", "S");
		}
		
		public static function formatLngStr(lng: Number): String {
			return getDegMinSec(lng, "E", "W");
		}
		
		protected static function getDegMinSec(degree: Number, positiveSign: String, negativeSign: String): String {
			var deg: int = Math.floor(Math.abs(degree));
			var min: Number = (Math.abs(degree) - deg) * 60;
			var sec: int = Math.round((min - Math.floor(min)) * 60);
			min = Math.floor(min);
			
			var degStr: String = String(deg);
			degStr += (degree >= 0)? positiveSign : negativeSign;
			degStr += String(min) + "'" + String(sec) + "\"";
			return degStr;
		}
		
	}
	
}