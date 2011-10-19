/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * All rights reserved.
 */
package tests {
	import com.pyco.framework.utils.Random;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class TestRandomColor extends Sprite {
		
		public function TestRandomColor() {
			
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void {
			var g: Graphics = this.graphics;
			//test dark color
			//g.beginFill(Random.getRandomColor(0, 255),1);
			//test bright color
			g.beginFill(Random.getRandomColor(0, 255),1);
			g.lineStyle(10, (128<<16|128<<8|128), 1);
			g.drawRect(200, 200, 200, 200);
		}
		
	}

}