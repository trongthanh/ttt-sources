package thanhtran {
	import away3d.core.draw.IPrimitiveConsumer;
	import away3d.core.math.Number3D;
	import away3d.core.render.Renderer;
	import away3d.lights.DirectionalLight3D;
	import away3d.lights.PointLight3D;
	import away3d.loaders.utils.MaterialLibrary;
	import away3d.materials.BitmapFileMaterial;
	import away3d.materials.ShadingColorMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.data.CubeMaterialsData;
	import away3d.primitives.Plane;
	import int3ractive.flar.FLARTKAway3DBase;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class DemoFLARToolkitAway3D extends FLARTKAway3DBase {
		
		public function DemoFLARToolkitAway3D() {
			//customized parameters
			markerResolution = 4;
			markerPercentage = 50;
			markerPatternFile = 'data/L.pat';
			//hideMarkerNodeWhenRemoved = true;
			init();
		}
		
		override protected function createObject():void {
			super.createObject();
			//container.rotationX = 180;
			
			var wmat:WireframeMaterial = new WireframeMaterial(0x0000ff);
			
			
			var _plane:Plane = new Plane(); // 80mm x 80mm。
			_plane.width = 100;
			_plane.height = 100;
			//_plane.material = wmat;
			//_plane.ownCanvas = true;
			
			view3d.renderer = Renderer.INTERSECTING_OBJECTS;
			
			
			// ライトの設定。手前、上のほう。
			var light: DirectionalLight3D = new DirectionalLight3D();
			//light.x = 0;
			//light.y = 100;
			//light.z = -100;
			light.direction = new Number3D(-2, -1, 0);
			scene3d.addLight(light);
//			
//			// Cube
			var _cube:Cube = new Cube();
			//_cube.material = new WireColorMaterial(0xFF0000);
			//_cube.material = new ShadingColorMaterial(0xCC0000);
			var bitmapMat: BitmapFileMaterial = new BitmapFileMaterial("data/L_4x4.png");
			//bitmapMat.rotatio = - 1;
			_cube.material = bitmapMat;
			//_cube.cubeMaterials = new CubeMaterialsData({top: bitmapMat});
			_cube.width = 80;
			_cube.height = 80;
			_cube.depth = 80;
			_cube.y = -39;
			_cube.rotationY = 90;
			_cube.name = 'CUBE';
			_cube.bothsides = true;
			//_cube.ownCanvas = true;
			//_cube.renderer = IPrimitiveConsumer(Renderer.INTERSECTING_OBJECTS);
			
			var cube:Cube = new Cube( { width: 50, height: 50, depth: 50 } );
			cube.z = 300;
			scene3d.addChild(cube);
			
 			// _container に 追加
			this.container.addChild(_plane);
//			scene3d.addChild(_light);
			this.container.addChild(_cube);
		}
		
	}

}