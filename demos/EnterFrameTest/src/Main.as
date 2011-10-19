package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import net.hires.debug.Stats;
	import thanhtran.enterframetest.MovingBall;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#000000', frameRate='31', width='550', height='400')]
	public class Main extends Sprite {
		private var arr:Array;
		private var bounds:Rectangle;
		private var textField: TextField;
		
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			var singleton: Boolean = true;
			var event: Boolean = true;
			//get from flashvars
			singleton = (loaderInfo.parameters["singleton"] == "true");
			event = (loaderInfo.parameters["event"] == "true");
			
			var movingBall: MovingBall;
			for (var i:int = 0; i < 5000; i++) {
				movingBall = new MovingBall(bounds, singleton, event);
				addChild(movingBall);
			}
			
			addChild(new Stats());
			
			textField = new TextField();
			textField.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF);
			textField.autoSize = "left";
			if(singleton)
				textField.text = "Singleton Manager";
			else 
				textField.text = "Multi Instances";
				
			if (event) 
				textField.appendText(" - Traditional Event");
			else 
				textField.appendText(" - Two-frame Movie");
				
			textField.x = stage.stageWidth - textField.width;
			addChild(textField);
			addEventListener(Event.ACTIVATE, activateHandler);
			addEventListener(Event.DEACTIVATE, deactiveHandler);
		}
		
		private function deactiveHandler(event: Event): void {
			stage.frameRate = 0;
		}
		
		private function activateHandler(event: Event): void {
			stage.frameRate = 30;
		}
	}
}