package  {
	import com.pyco.utils.Ticker;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#000000', frameRate='31', width='550', height='400')]
	public class TestTickManager extends Sprite {
		public var balls: Array;
		
		public function TestTickManager() {
			balls = [];
			var movingBall: Dot;
			for (var i:int = 0; i < 5000; i++) {
				movingBall = new Dot();
				Ticker.add(movingBall.enterFrameHandler);
				balls.push(movingBall);
				addChild(movingBall);
			}
			Ticker.add(null);
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			
			addChild(new Stats());
		}
		
		private function clickHandler(e:MouseEvent):void {
			//test remove all
			//Ticker.removeAll();
			
			//test pause and resume
			if (Ticker.running) {
				Ticker.pauseAll();
			} else {
				Ticker.resumeAll();
			}
			
		}
		
	}

}
import flash.display.Shape;
import flash.events.Event;
import flash.geom.Rectangle;

internal class Dot extends Shape {
	public var bounds: Rectangle;
	public var spanX: Number;
	public var spanY: Number;
	public var fromX: Number;
	public var fromY: Number;
	public var toX: Number;
	public var toY: Number;
	
	public function Dot() {
		graphics.beginFill(0xFFFFFF, 1);
		graphics.drawCircle(0, 0, 1);
		graphics.endFill();
		bounds = new Rectangle(0, 0, 550, 400);
		addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
	}
	
	private function addToStageHandler(e:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		setRandomCourse();
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