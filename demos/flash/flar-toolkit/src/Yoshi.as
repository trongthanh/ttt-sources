package {

	import flash.events.Event;
	import org.papervision3d.objects.parsers.DAE;
	
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	
	/**
	 * @author thanh
	 */
	public class Yoshi extends PV3DARApp {
		public static var test: String;
		
		private var _pyramid:DAE;
		
		public function Yoshi() {
			addEventListener(Event.INIT, _onInit);
			init('Data/camera_para.dat', 'Data/flarlogo.pat');
		}
		
		public static function testfunction(): void {
			 
		}

		private function _onInit(e:Event):void {
			_pyramid = new DAE();
			_pyramid.load('model/Yoshi.dae');
			_pyramid.scale = 2;
			_pyramid.rotationX = 90;
			_markerNode.addChild(_pyramid);
			
			//addEventListener(Event.ENTER_FRAME, _update);thử gõ tiếng việt 
		}
		
		private function _update(e:Event):void {
			_pyramid.rotationZ -= 0.5
		}
	}
}
