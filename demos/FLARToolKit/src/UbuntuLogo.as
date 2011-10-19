package {

	import org.papervision3d.materials.BitmapMaterial;
	import flash.display.Bitmap;
	import org.papervision3d.materials.BitmapAssetMaterial;
	import flash.events.Event;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.materials.WireframeMaterial;
	
	import org.papervision3d.objects.primitives.Plane;
	
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	
	public class UbuntuLogo extends PV3DARApp {
		[Embed(source="/../model/logo-Ubuntu.png")]
		private var _embeddedClass : Class;
		private var _bitmapClass: Class;
		private var _logo: Plane;
		private var _plane: Plane;
		
		public function UbuntuLogo() {
			addEventListener(Event.INIT, _onInit);
			_markerResolution = 4;
			
			init('Data/camera_para.dat', 'Data/L.pat');
		}
		
		private function _onInit(e:Event):void {
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ワイヤーフレームで。
			_plane = new Plane(wmat, 80, 80); // 80mm x 80mm。
			_plane.rotationX = 180;
			_markerNode.addChild(_plane); // attach to _markerNode to follow the marker. / _markerNode に addChild するとマーカーに追従する。
			
			var logoMat: BitmapMaterial = new BitmapMaterial(Bitmap(new _embeddedClass()).bitmapData);
			logoMat.doubleSided = true;
			
			_logo = new Plane(logoMat);
			_logo.scale = 0.1;
			_logo.z = 20; 
			_logo.rotationX = 90;
			_markerNode.addChild(_logo);
			
			addEventListener(Event.ENTER_FRAME, _update);
		}
		
		private function _update(e:Event):void {
			_logo.rotationZ += 5;
		}
	}
}
