package  {
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.entities.Sprite3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(width="800",height="600",frameRate="60")]
	public class AwayMolehillDemo extends Sprite {
		public var light1: PointLight;
		public var light2: PointLight;
		public var view3D: View3D;
		public var cube: Cube;
		
		public function AwayMolehillDemo() {
			super();
			init();
		}
		
		private function init():void {
			view3D = new View3D();
			//IMPORTANT
			view3D.width = 800;
			view3D.height = 600;
			addChild(view3D);
			
			var mat: ColorMaterial = new ColorMaterial(0x0000FF, 0.7);
			cube = new Cube(mat, 100, 100, 100, 2, 2, 2);
			
			light1 = new PointLight();
			light1.x = -1000;
			light1.y = 1000;
			light1.z = -1000;
			light1.color = 0xffFFFF;
			
			light2 = new PointLight();
			light2.x = 1000;
			light2.y = -1000;
			light2.z = 1000;
			light2.color = 0xffFFFF;
			
			mat.lights = [light1, light2];
			
			view3D.scene.addChild(light1);
			view3D.scene.addChild(light2);
			view3D.scene.addChild(cube);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void {
			cube.rotationY += 1;
			cube.rotationX += 1;
			view3D.render();
		}
		
		
	}

}