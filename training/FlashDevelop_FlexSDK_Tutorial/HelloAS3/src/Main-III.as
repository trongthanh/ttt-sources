package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * Ghi chú: Bỏ "-III" ở tên file để biên dịch cho đúng
	 * @author Thanh Tran
	 */
	public class Main extends Sprite {
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//xuất ra ouput
			trace("init() is called");
			
			//tạo TextField mới
			var helloText: TextField = new TextField();
			//set giá trị text cho text field
			helloText.text = "Hello World";
			//đặt text field lên stage
			addChild(helloText);
		}
	}
	
}