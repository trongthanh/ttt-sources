package thanhtran.enterframetest {
	import com.pyco.utils.EnterFrameManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import thanhtran.utils.GeomUtil;
	import thanhtran.utils.TwoFrameManager;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class MovingBall extends Sprite {
		public var fromX: Number;
		public var fromY: Number;
		public var toX: Number;
		public var toY: Number;
		public var bounds: Rectangle;
		public var spanX: Number;
		public var spanY: Number;
		public var enterFrame: TwoFrameMovie;
		
		public function MovingBall(bounds: Rectangle, useSingleton: Boolean = true, useEvent: Boolean = true) {
			this.bounds = bounds;
			if (useSingleton) {
				trace("using singleton enter frame manager - event: " + useEvent);
				if (useEvent)
					EnterFrameManager.add(enterFrameHandler);
				else 
					TwoFrameManager.instance.enterFrame.add(enterFrameHandler);
			} else {
				trace("using multiple instances ");
				if(useEvent) {
					trace("use event handler");
					addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				} else {
					trace("use 2 frame movie");
					enterFrame = new TwoFrameMovie();
					enterFrame.addFrameScript(0, enterFrameHandler, 1, enterFrameHandler)
				}
			}
			//only move when add to stage
			fromX = toX = this.x;
			fromY = toY = this.y;
			
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawCircle(0, 0, 1);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function addToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			setRandomCourse();
		}
		
		private function removeFromStageHandler(event: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			
			
			
		}
		
		private function setRandomCourse(): void {
			fromX = (bounds.width - bounds.x) / 2; //from center
			fromY = (bounds.height - bounds.y) / 2;
			x = fromX;
			y = fromY;
				
			toX = Math.random() * (bounds.width - bounds.x);
			toY = Math.random() * (bounds.height - bounds.y);
				
			
			var time: Number = Math.random() * 1000 + 500;
			var frameRate: Number = (stage)?stage.frameRate:0;
			
			spanX = (toX - fromX) * frameRate / time;
			spanY = (toY - fromY) * frameRate / time;
		}
		
		public function enterFrameHandler(event: Event = null): void {
			this.x += spanX;
			this.y += spanY;
			if (Math.abs(toX - this.x) <= 5) setRandomCourse();
		}
		
	}

}