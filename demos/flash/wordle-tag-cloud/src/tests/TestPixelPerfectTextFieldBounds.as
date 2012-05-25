/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * All rights reserved.
 */
package tests {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Thanh Tran
	 * @modifier Thu Hoang
	 */
	[SWF(backgroundColor='#CCCCCC', frameRate='31', width='800', height='600')]
	public class TestPixelPerfectTextFieldBounds extends Sprite {
		[Embed(systemFont = 'Arial', 
			fontName = 'ArialRegular', 
			fontWeight='normal', 
			fontStyle = 'normal', 
			mimeType='application/x-font',
			unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		private static var ArialFont: Class;
		
		public var text: TextField;
		public var sprite: Sprite;
		
		/// Create 'centerPoint' object to make clear the registered point's position of 'sprite' object
		private var centerPoint: Sprite = new Sprite();
		
		public function TestPixelPerfectTextFieldBounds() {
			/// Initialize 'centerPoint' in blue-rectangle shape
			var g: Graphics = centerPoint.graphics;
			g.beginFill(0x0000FF);
			g.drawRect( -5, -5, 10, 10);
			g.endFill();
			
			text = new TextField();
			var textFormat: TextFormat = new TextFormat("ArialRegular", 50, 0xFF0000);
			var tf: TextField = new TextField();
			tf.embedFonts = true;
			tf.defaultTextFormat = textFormat;
			tf.autoSize = "left";
			tf.text = "ipsumg";
			
			tf.x = - tf.width / 2;
			tf.y = - tf.height / 2;
			
			sprite = new Sprite();
			sprite.addChild(centerPoint);
			sprite.addChild(tf);
			
			sprite.x = 300;
			sprite.y = 100;
			addChild(sprite);
			
			/// Draw the biggest bound of 'tf' or 'sprite' with blue color
			g = this.graphics;
			g.lineStyle(1, 0xFF0000);
			g.moveTo(sprite.x - sprite.width / 2, sprite.y - sprite.height / 2);
			g.lineTo(sprite.x + sprite.width / 2, sprite.y - sprite.height / 2);
			g.lineTo(sprite.x + sprite.width / 2, sprite.y + sprite.height / 2);
			g.lineTo(sprite.x - sprite.width / 2, sprite.y + sprite.height / 2);
			g.lineTo(sprite.x - sprite.width / 2, sprite.y - sprite.height / 2);
			
			var firstBounds: Rectangle = tf.getCharBoundaries(0);
			firstBounds.x += sprite.x + tf.x;
			firstBounds.y += sprite.y +tf.y;
			//drawBounds(firstBounds);
			
			var lastBounds: Rectangle = tf.getCharBoundaries(tf.length - 1);
			lastBounds.x += sprite.x + tf.x;
			lastBounds.y += sprite.y + tf.y;
			//drawBounds(lastBounds);
			
			var mergeBounds: Rectangle = new Rectangle();
			mergeBounds.left = Math.min(firstBounds.left, lastBounds.left);
			mergeBounds.top = Math.min(firstBounds.top, lastBounds.top);
			mergeBounds.right = Math.max(firstBounds.right, lastBounds.right);
			mergeBounds.bottom = Math.max(firstBounds.bottom, lastBounds.bottom);
			
			//drawBounds(mergeBounds, 0x00FF00);
			
			var bounds: Rectangle = tf.getBounds(this);
			//drawBounds(bounds, 0xFFFF00);
			
			var rect: Rectangle = tf.getRect(this);
			//drawBounds(rect, 0xFF0000);
			
			var bmp: BitmapData = new BitmapData(sprite.width, sprite.height, true);
			var matrix: Matrix = new Matrix();
			matrix.tx = -tf.x;
			matrix.ty = -tf.y;
			bmp.draw(sprite, matrix);
			var bm: Bitmap = new Bitmap(bmp);
			bm.y = 300;
			addChild(bm);
			
			var alphaBounds: Rectangle = bmp.getColorBoundsRect(0xFFFFFFFF, 0xFFFF0000, true);
			trace( "alphaBounds : " + alphaBounds );
			/// Indeed make the 'tf' center the 'sprite'
			tf.x = -alphaBounds.width / 2 - alphaBounds.x;
			tf.y = -alphaBounds.height / 2 - alphaBounds.y;
			
			alphaBounds.x += sprite.x + tf.x ;
			alphaBounds.y += sprite.y + tf.y;
			drawBounds(alphaBounds, 0x0000FF);
			
			
		}
		
		private function drawBounds(bounds: Rectangle, color: uint = 0x0000FF):void {
			var g: Graphics = this.graphics;
			g.lineStyle(1, color, 0.5);
			g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
		}
	}

}