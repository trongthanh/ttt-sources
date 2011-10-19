package {
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Ghi chú: Bỏ "-V" ở tên file để biên dịch cho đúng
	 * @author Thanh Tran
	 */
	public class Main extends Sprite {
		[Embed(source = '../assets/images/hermione.jpg')]
		public var PhotoClass: Class;
		
		[Embed(source= '../assets/fonts/comic.TTF'
		,fontName    = 'Comic'  //tên của font dùng để đăng ký TextFormat
		,fontStyle   = 'normal' // normal|italic
		,fontWeight  = 'normal' // normal|bold
		,unicodeRange= 'U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E'
		//,embedAsCFF='false'
		)]
		public var ComicFontRegular: Class;
		
		
		[Embed(source= '../assets/fonts/comicbd.TTF'
		,fontName    = 'Comic'  //tên của font dùng để đăng ký TextFormat
		,fontStyle   = 'normal' // normal|italic
		,fontWeight  = 'bold' // normal|bold
		,unicodeRange= 'U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E'
		//,embedAsCFF='false'
		)]
		public var ComicFontBold: Class;
		
		public var nameText: TextField;
		public var roleText: TextField;
		public var photo: Bitmap;		
		
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
			
			//đăng ký font với hệ thống
			Font.registerFont(ComicFontRegular);
			Font.registerFont(ComicFontBold);
			
			var tf: TextFormat = new TextFormat("Comic", 20);
			
			//tạo TextField để hiển thị tên
			nameText = new TextField();
			//TextField tự động điều chỉnh kích thước vùng bao vừa với text
			nameText.autoSize = "left";
			//với defaultTextFormat, text mới gán sẽ được áp dụng format này
			nameText.defaultTextFormat = tf;
			//bật embedFont=true để sử dụng font nhúng
			nameText.embedFonts = true;
			//chỉ gán text sau khi đã gán defaultTextFormat
			nameText.text = "Emma Watson";
			//vị trí ban đầu của TextField
			nameText.x = stage.stageWidth;
			nameText.y = 20;
			
			//tạo TextField để hiển thị tên nhân vật
			roleText = new TextField();
			roleText.autoSize = "left";
			//với defaultTextFormat, text mới gán sẽ được áp dụng format này
			roleText.defaultTextFormat = tf;
			//bật embedFont=true để sử dụng font nhúng
			roleText.embedFonts = true;
			//sử dụng htmlText để tận dụng một số tag của HTML
			roleText.htmlText = "as <b>Hermione Granger</b>";
			roleText.x = stage.stageWidth;
			//roleText được đặt ngay phía dưới của nameText
			roleText.y = nameText.y + nameText.height;
			
			//khởi tạo ảnh
			photo = new PhotoClass();
			photo.x = 10;
			photo.y = 10;
			photo.alpha = 0;
			
			//đặt các đối tượng lên stage
			addChild(nameText);
			addChild(roleText);
			addChild(photo);
			
		}
		
		private function show(): void {
			//di chuyển các TextField ra phía ngoài, bên phải stage
			nameText.x = stage.stageWidth;
			roleText.x = stage.stageWidth;
			//ảnh bắt đầu trong suốt hoàn toàn
			photo.alpha = 0;
			//di chuyển nameText từ vị trí hiện tại đến tọa độ x=220 trong thời gian 0.7s
			TweenLite.to(nameText, 0.7, { x: 220 } );
			//di chuyển roleText từ vị trí hiện tại đến tọa độ x=220 trong thời gian 0.7s 
			//nhưng delay sau 0.4s
			TweenLite.to(roleText, 0.7, { x: 220, delay: 0.4 } );
			//chuyển alpha (độ trong suốt) của ảnh thành 1 trong thời gian 1s
			TweenLite.to(photo, 1, { alpha: 1} );
		}
	}
	
}