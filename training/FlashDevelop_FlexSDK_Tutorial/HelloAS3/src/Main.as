package {
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import symbols.HideButton;
	
	/**
	 * ...
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
		
		[Embed(source = '../fla/symbols.swf', symbol = 'symbols.ShowButton')]
		public var ShowButtonClass: Class;

		/*
		[Embed(source = '../fla/symbols.swf', symbol = 'symbols.HideButton')]
		public var HideButtonClass: Class;
		*/
		
		public var nameText: TextField;
		public var roleText: TextField;
		public var photo: Bitmap;
		public var showButton: SimpleButton;
		public var hideButton: HideButton;
		
		
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
			nameText.defaultTextFormat = tf;
			nameText.embedFonts = true;
			nameText.text = "Emma Watson";
			//vị trí ban đầu của TextField
			nameText.x = stage.stageWidth;
			nameText.y = 20;
			
			//tạo TextField để hiển thị tên nhân vật
			roleText = new TextField();
			roleText.autoSize = "left";
			roleText.defaultTextFormat = tf;
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
			
			//tạo nút ShowButon:
			showButton = new ShowButtonClass();
			showButton.x = stage.stageWidth - showButton.width - 10;
			showButton.y = stage.stageHeight - showButton.height - 20;
			showButton.addEventListener(MouseEvent.CLICK, showButtonClickHandler);
			
			//tạo nút HideButon:
			hideButton = new HideButton();
			hideButton.x = showButton.x - hideButton.width - 10;
			hideButton.y = stage.stageHeight - hideButton.height - 20;
			hideButton.addEventListener(MouseEvent.CLICK, hideButtonClickHandler);
			
			//đặt các đối tượng lên stage
			addChild(nameText);
			addChild(roleText);
			addChild(photo);
			addChild(showButton);
			//addChild(hideButton);
			
		}
		
		private function hideButtonClickHandler(e:MouseEvent):void {
			hide();
		}
		
		private function showButtonClickHandler(e:MouseEvent):void {
			show();
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
		
		private function hide(): void {
			//di chuyển các TextField về vị trí mặc định
			nameText.x = 220;
			roleText.x = 220;
			//alpha mặc định
			photo.alpha = 1;
			//di chuyển nameText từ vị trí hiện tại ra khỏi phía trái của stage trong thời gian 0.7s
			TweenLite.to(nameText, 0.7, { x: - nameText.width } );
			//di chuyển roleText từ vị trí hiện tại ra khỏi phía trái của stage trong thời gian 0.7s 
			//nhưng delay sau 0.2s
			TweenLite.to(roleText, 0.7, { x: - roleText.width, delay: 0.2 } );
			//chuyển alpha (độ trong suốt) của ảnh thành 0 trong thời gian 1s
			TweenLite.to(photo, 1, { alpha: 0} );
		}
		
	}
	
}