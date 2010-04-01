/**
* ...
* @author Trong Thanh
*/
package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class SoundProgressBar extends MovieClip {
		//stage
		public var loadBar_mc: MovieClip;
		public var playBar_mc: MovieClip;
		public var playHead_mc: MovieClip;
		
		//
		private var _loadProgress: Number;
		private var _playProgress: Number;
		private var isMouseDown: Boolean;
		
		private const X_MAX: Number = 200;
		//event IDs:
		public static const PLAY_BAR_VALUE_CHANGING: String = "PlayBarValueChanging";
		public static const PLAY_BAR_VALUE_SET: String = "PlayBarValueSet";
		
		
		public function SoundProgressBar() {
			_loadProgress = 0;
			_playProgress = 0;
			resetBars();
			
			this.addEventListener(MouseEvent.ROLL_OVER, onBarRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onBarRollOut);
			playHead_mc.addEventListener(MouseEvent.MOUSE_DOWN, onPlayheadMouseDown);
			playHead_mc.addEventListener(MouseEvent.MOUSE_UP, onPlayheadMouseUp);
			playHead_mc.addEventListener(MouseEvent.MOUSE_MOVE, onPlayheadMouseMove);
			
			
			playHead_mc.buttonMode = true;
		}
		
		private function onPlayheadMouseMove(e:MouseEvent):void {
			if (!isMouseDown) return;
			var x: Number = playHead_mc.x;
			_playProgress = x / X_MAX;
			updatePlayBarPosition();
			dispatchEvent(new Event(PLAY_BAR_VALUE_CHANGING));
		}
		
		private function onPlayheadMouseUp(e:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onPlayheadMouseUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onPlayheadMouseMove);
			if (e.target != playHead_mc) {
				trace("release outside");
				//release outside
				playHead_mc.visible = false;
			}
			isMouseDown = false;
			playHead_mc.stopDrag();
			//event
			dispatchEvent(new Event(PLAY_BAR_VALUE_SET));
		}
		
		private function onPlayheadMouseDown(e:MouseEvent):void {
			isMouseDown = true;
			playHead_mc.startDrag(false, new Rectangle(0, 0, loadBar_mc.width, 0));
			//detect mouse release outside
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onPlayheadMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onPlayheadMouseMove);
		}
		
		private function onBarRollOut(e:MouseEvent):void {
			if (!isMouseDown) playHead_mc.visible = false;
		}
		
		private function onBarRollOver(e:MouseEvent):void {
			playHead_mc.visible = true;
		}
		
		
		public function resetBars() {
			playHead_mc.visible = false;
			loadBar_mc.scaleX = 0;
			playBar_mc.scaleX = 0;
		}
		
		public function resetPlayBar() {
			playProgress = 0;
		}
		
		public function resetLoadBar() {
			loadProgress = 0;
		}
		
		/** load progress percent, 0-1 */
		public function get loadProgress():Number { return _loadProgress; }
		
		public function set loadProgress(value:Number):void {
			if (value > 1) value = 1;
			else if (value < 0) value = 0;
			_loadProgress = value;
			loadBar_mc.scaleX = _loadProgress;
		}
		
		/** play progress percent, 0-1 */
		public function get playProgress():Number { return _playProgress; }
		
		public function set playProgress(value:Number):void {
			if (value > 1) value = 1;
			else if (value < 0) value = 0;
			if (!isMouseDown) {
				_playProgress = value;
				updatePlayBarPosition();
			}
		}
		
		private function updatePlayBarPosition(): void {
			playBar_mc.scaleX = _playProgress;
			playHead_mc.x = _playProgress * X_MAX;
		}
		
		
	
	}
}