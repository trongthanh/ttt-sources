/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * All rights reserved.
 */
package tests {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class TestPixelPerfectCollision extends Sprite {
		[Embed(systemFont = 'Arial', 
			fontName = 'ArialRegular', 
			fontWeight='normal', 
			fontStyle = 'normal', 
			mimeType='application/x-font',
			unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		private static var ArialFont: Class;
		
		public var text1: TextField;
		public var text2: TextField;
		public var sprite1: Sprite;
		public var sprite2: Sprite;
		
		
		public function TestPixelPerfectCollision() {
			
			var textFormat: TextFormat = new TextFormat("ArialRegular", 50, 0x0000FF);
			text1 = new TextField();
			text1.embedFonts = true;
			text1.defaultTextFormat = textFormat;
			text1.autoSize = "left";
			text1.text = "Thanh";
			
			text1.x = - text1.width / 2;
			text1.y = - text1.height / 2;
			
			sprite1 = new Sprite();
			sprite1.addChild(text1);
			
			text2 = new TextField();
			text2.embedFonts = true;
			text2.defaultTextFormat = textFormat;
			text2.autoSize = "left";
			text2.text = "Thao";
			
			text2.x = - text2.width / 2;
			text2.y = - text2.height / 2;
			
			sprite2 = new Sprite();
			sprite2.addChild(text2);
			
			sprite1.x = 200;
			sprite1.y = 200;
			
			sprite2.x = 250;
			sprite2.y = 250;
			
			addChild(sprite1);
			addChild(sprite2);
			
			CollisionDetection.registerStage(stage);
			SkyCollisionDetection.registerRoot(stage);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void {
			sprite1.rotation += 1;
			sprite2.rotation -= 1;
			
			//var rect: Rectangle = CollisionDetection.checkForCollision(sprite1, sprite2);
			
			graphics.clear();
			if (/*rect*/ SkyCollisionDetection.bitmapHitTest(sprite1, sprite2)) {
				//trace( "rect : " + rect );
				//graphics.lineStyle(1, 0x000000,1);
				//graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				text1.textColor = 0xFF0000;
				text2.textColor = 0xFF0000;
			}  else {
				text1.textColor = 0x0000FF;
				text2.textColor = 0x0000FF;
			}
		}
		
	}

}