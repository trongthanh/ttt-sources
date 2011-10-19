package com.pyco.view.components {
	import flash.display.Graphics;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thu.Hoang
	 */
	public class WeddingBox extends Sprite {
		public var container: Sprite = new Sprite();
		public static const RADIUS: Number = 10;
		public function WeddingBox() {
			var g: Graphics = container.graphics;
			g.beginFill(0xFF0000);
			g.drawCircle(0, 0, 10);
			g.endFill();
			addChild(container);
		}
	}
}