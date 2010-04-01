/**
* ...
* @author Trong Thanh
*/

package  {
	import flash.display.MovieClip;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class SimpleSlider extends MovieClip {
		//stage 
		public var knob: MovieClip;
		
		
		/** from 0 to 1 */
		private var _position: Number;
		private var isMouseDown: Boolean;
		
		private const X_MIN: Number = 0;
		private const X_MAX: Number = 100;
		/** Custom event string ID */
		public static const SLIDER_VALUE_CHANGE: String = "SliderValueChange";
		
		
		public function SimpleSlider() {
			init();
		}
		
		private function init(): void {
			knob.buttonMode = true;
			knob.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			knob.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			knob.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			knob.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			knob.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			//knob.addEventListener(MouseEvent.
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			knob.gotoAndStop("_up");
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			knob.gotoAndStop("_over");
		}
		
		private function mouseMoveHandler(e:MouseEvent):void {
			if (!isMouseDown) return;
			var x: Number = knob.x;
			_position = x / X_MAX;
			dispatchEvent(new Event(SLIDER_VALUE_CHANGE));
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			knob.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			knob.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
			if (e.target != knob) {
				trace("release outside");
			}
			isMouseDown = false;
			knob.gotoAndStop("_over");
			knob.stopDrag();
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			isMouseDown = true;
			knob.gotoAndStop("_down");
			knob.startDrag(false, new Rectangle(0, 0, 100, 0));
			knob.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			knob.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
		}
		
		public function get position():Number { return _position; }
		
		public function set position(value:Number):void {
			if (value > 1) value = 1;
			else if (value < 0) value = 0;
			_position = value;
			setKnobPosition(_position);
		}
		
		private function setKnobPosition(pos: Number): void {
			knob.x = _position * X_MAX;
		}
		
	}
	
}