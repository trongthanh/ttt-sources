package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Thanh Tran - thanh.tran@in2ideas.com
	 */
	public class Preloader extends MovieClip {
		public var loadingText: TextField;
		
		public function Preloader() {
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			loadingText = new TextField();
			loadingText.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF);
			loadingText.autoSize = "left";
			loadingText.text = "Loading... 0%";
			this.addChild(loadingText);
			if (stage) {
				loadingText.x = (stage.stageWidth - loadingText.width) / 2;
				loadingText.y = (stage.stageHeight - loadingText.height) / 2;
			}
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			// TODO update loader
			var percent: Number = int(e.bytesLoaded / e.bytesTotal * 100);
			loadingText.text = "Loading... " + percent + "%";
		}
		
		private function checkFrame(e:Event):void {
			if (currentFrame == totalFrames) {
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void {
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			if (contains(loadingText)) removeChild(loadingText);
			startup();
		}
		
		private function startup():void {
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}