/**
* @author Thanh Tran
*/
package org.thanhtran.interactivewall {
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.core.proto.SceneObject3D;
	import org.papervision3d.core.view.IViewport3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	* ...
	*/
	public class Global extends Object {
		
		public function Global() {
			
		}
		
		public static var camera: CameraObject3D;
		public static var viewPort: IViewport3D;
		public static var scene3D: SceneObject3D;
		public static var wall3D: DisplayObject3D;
		
		
	}
	
}