package {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * Ghi chú: Bỏ "-IV" ở tên file để biên dịch cho đúng
	 * @author Thanh Tran
	 */
	public class Main extends Sprite {
		public var nameText: TextField;
		public var roleText: TextField;		
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//xuất ra ouput
			trace("init() is called");
			
			//tạo TextField mới
			//var helloText: TextField = new TextField();
			//set giá trị text cho text field
			//helloText.text = "Hello World";
			//đặt text field lên stage
			//addChild(helloText);

			//tạo TextField để hiển thị tên
			nameText = new TextField();
			//TextField tự động điều chỉnh kích thước vùng bao vừa với text
			nameText.autoSize = "left";
			nameText.text = "Emma Watson";
			//vị trí ban đầu của TextField ở bên ngoài stage về phía phải
			nameText.x = stage.stageWidth;
			nameText.y = 20;
			
			//tạo TextField để hiển thị tên nhân vật
			roleText = new TextField();
			roleText.autoSize = "left";
			//sử dụng htmlText để tận dụng một số tag của HTML
			roleText.htmlText = "as <b>Hermione Granger</b>";
			//vị trí ban đầu của TextField ở bên ngoài stage về phía phải
			roleText.x = stage.stageWidth;
			//roleText được đặt ngay phía dưới của nameText
			roleText.y = nameText.y + nameText.height;
			
			//đặt các đối tượng lên stage
			addChild(nameText);
			addChild(roleText);
			
			show();
		}
		
		private function show(): void {
			//di chuyển các TextField ra phía ngoài, bên phải stage
			nameText.x = stage.stageWidth;
			roleText.x = stage.stageWidth;
			//di chuyển nameText từ vị trí hiện tại đến tọa độ x=220 trong thời gian 0.7s
			TweenLite.to(nameText, 0.7, { x: 220 } );
			//di chuyển roleText từ vị trí hiện tại đến tọa độ x=220 trong thời gian 0.7s 
			//nhưng delay sau 0.4s
			TweenLite.to(roleText, 0.7, { x: 220, delay: 0.4 } );
		}
	}
	
}