package {

	import flash.events.Event;
	import org.papervision3d.objects.parsers.DAE;
	
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	
	public class Pyramid extends PV3DARApp {
		
		private var _pyramid:DAE;
		
		public function Pyramid() {
			addEventListener(Event.INIT, _onInit);
			_markerResolution = 4;
			//init('Data/camera_para.dat', 'Data/flarlogo.pat');			init('Data/camera_para.dat', 'Data/L.pat');
		}
		
		private function _onInit(e:Event):void {
			_pyramid = new DAE();
			_pyramid.load('model/pyramid_cheops.dae');
			_pyramid.scale = 0.5;
			_pyramid.rotationX = 90;
			_markerNode.addChild(_pyramid);
			
			//addEventListener(Event.ENTER_FRAME, _update);
		}
		
		private function _update(e:Event):void {
			_pyramid.rotationZ -= 0.5;
		}
	}
}
