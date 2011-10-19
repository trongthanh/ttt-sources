/**
* @author Thanh Tran
*/
package com.pyco.utils.pv3d {
	import flash.geom.Rectangle;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	* This utility class helps get 2D sizes and coordinates from 3D objects.<p/>
	* Assumption: the camera is directly aligned on the z coordinate.<p/>
	* Applied to Papervision 3D 2.0 GreatWhite (beta 2 and later)
	* @version 0.3
	*/
	public class SizeConverter {
		
		public function SizeConverter() {
			throw new Error("Utility class. No instanciation.");
		}
		
		/**
		 * Gets the z coordinate of an object 3D where it is scaled 1:1 
		 * @param	camera	active camera
		 * @return	the z coordinate
		 */
		public static function calculateNoScaleZ(camera: CameraObject3D): Number {
			 var z: Number = (camera.zoom * camera.focus) - Math.abs(camera.z);
			 return z;
		}
		
		/**
		 * Gets the scale portion of an object 3D based on its z value
		 * @param	camera		active camera
		 * @param	z			z coordinate of the 3D object 
		 * @return	scale of the 3D object
		 */
		public static function calculateScale(camera: CameraObject3D, z: Number): Number {
			var noScaleZ: Number = calculateNoScaleZ(camera);
			var scale: Number = (noScaleZ - camera.z) / (z - camera.z);
			return scale;
		}
		
		/**
		 * Gets real sizes and coordinates of a plane in 2D (assumed the plane is facing camera directly).<br/>
		 * Be carefull: camera.viewport (Rectangle) will be used to calculate x, y coordinates; they are only calculated correctly if 
		 * the camera is already rendered at least once with the active viewport.
		 * @param	camera			active camera
		 * @param	object3D		3D object
		 * @param	birthWidth		width of the plane at birth 
		 * @param	birthHeight		height of the plane at birth
		 * @return	rectangle containing x, y, width, height of the plane in real 2D (relative to ???)
		 * TODO: check the x, y in more cases; confirm the scope of x, y with document's stage
		 * 
		 */
		public static function calculatePlane2DSize(camera: CameraObject3D, object3D: DisplayObject3D, birthWidth: Number, birthHeight: Number): Rectangle {
			if (isNaN(birthWidth)) {
				birthWidth = 0;
			} 
			if (isNaN(birthHeight)) {
				birthHeight = 0;
			} 
			var scale: Number = calculateScale(camera, object3D.z);
			var w: Number = scale * birthWidth;
			var h: Number = scale * birthHeight;
			var x: Number = object3D.screen.x + camera.viewport.width / 2;
			var y: Number = object3D.screen.y + camera.viewport.height / 2;
			var realSize: Rectangle = new Rectangle(x, y, w , h);
			return realSize;
		}
		
		/**
		 * Gets the z coordinate of a plane where it will have the 2D size you expected (assumed the plane face camera directly)
		 * @param	camera			active camera
		 * @param	birthSize		width or height at birth
		 * @param	expectedSize	expected width or heigth
		 * @return	z coordinate of the plane
		 */
		public static function calculatePlaneZForExpectedSize(camera: CameraObject3D, birthSize: Number, expectedSize: Number): Number {
			var scale: Number = expectedSize / birthSize;
			var noScaleZ: Number = calculateNoScaleZ(camera);
			var z: Number = (noScaleZ - camera.z) / scale + camera.z;
			
			return z;
		}
		
		/**
		 * Gets the depth distance from the camera to the 3D object where it has expected 2D size
		 * @param	camera			active camera
		 * @param	birthSize		width or height at birth
		 * @param	expectedSize	expected width or height
		 * @return	distance from the camera to 3D object (along Z coordinate)
		 */
		public static function calculateCameraDistanceForSize(camera: CameraObject3D, birthSize: Number, expectedSize: Number): Number {
			var expectedObjectZ: Number = calculatePlaneZForExpectedSize(camera, birthSize, expectedSize);
			return Math.abs(expectedObjectZ - camera.z);
		}
		
	}
	
}