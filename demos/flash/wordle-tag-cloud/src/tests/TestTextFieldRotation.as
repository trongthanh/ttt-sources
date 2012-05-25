/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * All rights reserved.
 */
package tests {
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#FFFFFF', frameRate='31', width='550', height='400')]
	public class TestTextFieldRotation extends Sprite {
		[Embed(systemFont = 'Arial', 
			fontName = 'ArialRegular', 
			fontWeight='normal', 
			fontStyle = 'normal', 
			mimeType='application/x-font',
			unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		private static var ArialFont: Class;
		
		public var container: Sprite = new Sprite();
		
		public function TestTextFieldRotation() {
			
			var tf: TextField = new TextField();
			var format: TextFormat = new TextFormat("ArialRegular", 20, 0);
			
			tf.embedFonts = true;
			tf.defaultTextFormat = format;
			tf.autoSize = "left";
			tf.text = "Thanh";
			
			
			var sprite: Sprite = new Sprite();
			sprite.x = 200;
			sprite.y = 200;			
			
			var zeroPoint: Shape = new Shape();
			zeroPoint.graphics.beginFill(0xFF0000, 0.7);
			zeroPoint.graphics.drawCircle(0, 0, 2);
			
			tf.rotation = 90;
			tf.x = tf.width / 2;
			tf.y = -tf.height / 2;
			
			sprite.addChild(tf);
			sprite.addChild(zeroPoint);
			
			var bounds: Rectangle = sprite.getBounds(container);
			trace( "bounds : " + bounds );
			
			var rect: Shape = new Shape();
			rect.graphics.lineStyle(1, 0xFF0000, 0.7);
			rect.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			container.addChild(sprite);
			container.addChild(rect);
			
			container.x
			
		}
		
	}

}