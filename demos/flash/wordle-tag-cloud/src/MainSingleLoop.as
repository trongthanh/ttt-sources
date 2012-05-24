/**
 * Copyright (c) 2011 Pyramid Consulting www.pyramid-consulting.com
 * 
 * Licensed under MIT License:
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package {
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Style;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.pyco.tagcloud.Wordle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * This demo uses Wordle
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#FFFFFF', frameRate='31', width='1024', height='768')]
	public class MainSingleLoop extends Sprite {
		[Embed(systemFont = 'Arial', 
			fontName = 'ArialRegular', 
			fontWeight='normal', 
			fontStyle = 'normal', 
			mimeType='application/x-font',
			unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00C0-U+00C3,U+00C8-U+00CA,U+00CC-U+00CD,U+00D0,U+00D2-U+00D5,U+00D9-U+00DA,U+00DD,U+00E0-U+00E3,U+00E8-U+00EA,U+00EC-U+00ED,U+00F2-U+00F5,U+00F9-U+00FA,U+00FD,U+0102-U+0103,U+0110-U+0111,U+0128-U+0129,U+0168-U+0169,U+01A0-U+01B0,U+1EA0-U+1EF9')]
		private static var ArialFont: Class;
		
		public var wordle: Wordle;
		
		[Embed(systemFont = 'Times New Roman', 
			fontName = 'TimesRegular', 
			fontWeight='normal', 
			fontStyle = 'normal', 
			mimeType='application/x-font',
			unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00C0-U+00C3,U+00C8-U+00CA,U+00CC-U+00CD,U+00D0,U+00D2-U+00D5,U+00D9-U+00DA,U+00DD,U+00E0-U+00E3,U+00E8-U+00EA,U+00EC-U+00ED,U+00F2-U+00F5,U+00F9-U+00FA,U+00FD,U+0102-U+0103,U+0110-U+0111,U+0128-U+0129,U+0168-U+0169,U+01A0-U+01B0,U+1EA0-U+1EF9')]
		private static var TimesFont: Class;
		private var zeroPoint:Shape;
		private var window:Window;
		private var vbox:VBox;
		private var doLayoutButton:PushButton;
		private var radioButton10:RadioButton;
		private var radioButton20:RadioButton;
		private var radioButton50:RadioButton;
		private var radioButton100:RadioButton;
		private var radioButton200:RadioButton;
		private var maximumLabel:Label;
		private var runtimeLabel:Label;
		
		public function MainSingleLoop():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			
			wordle = new Wordle();
			wordle.x = stage.stageWidth / 2;
			wordle.y = stage.stageHeight / 2;
			//wordle.x = 200;
			//wordle.y = 200;
			//wordle.scaleX = wordle.scaleY = 0.2;
			addChild(wordle);
			
			zeroPoint = new Shape();
			zeroPoint.graphics.beginFill(0xFF0000, 0.7);
			zeroPoint.graphics.drawCircle(0, 0, 2);
			zeroPoint.x = wordle.x;
			zeroPoint.y = wordle.y;
			addChild(zeroPoint);
				
			createVisualComponents();
			//auto run first time:
			//doLayout();
		}
		
		private function createVisualComponents():void {
			Style.fontName = "ArialRegular";
			Style.fontSize = 12;
			
			window = new Window(stage, 0, 0, "Wordle Control");
			window.draggable = true;
			window.hasMinimizeButton = true;
			window.width = 200;
			window.height = 220;
			window.x = stage.stageWidth - window.width;
			
			vbox = new VBox(window, 0, 0);
			vbox.spacing = 2;
			
			maximumLabel = new Label(vbox);
			maximumLabel.text = "Number of words";
			
			var radioButtonGroup: HBox = new HBox(vbox);
			
			radioButton10 = new RadioButton(radioButtonGroup, 0, 0, "10", false);
			radioButton20 = new RadioButton(radioButtonGroup, 0, 0, "20", false);
			radioButton50 = new RadioButton(radioButtonGroup, 0, 0, "50", false);
			radioButton100 = new RadioButton(radioButtonGroup, 0, 0, "100", true);
			radioButton200 = new RadioButton(radioButtonGroup, 0, 0, "200", false);
			
			doLayoutButton = new PushButton(vbox, 0, 0, "Render", doLayout);
			
			runtimeLabel = new Label(vbox);
			
			
		}
		7
		private function doLayout(event: Event = null):void {			
			var maximum: uint = 100;
			if (radioButton10.selected) maximum = 10;
			else if (radioButton20.selected) maximum = 20;
			else if (radioButton50.selected) maximum = 50;
			else if (radioButton100.selected) maximum = 100;
			else if (radioButton200.selected) maximum = 200;
			
			trace( "maximum : " + maximum );
			//else if (radioButton400.selected) maximum: uint = 100;
			
			wordle.reset();
			wordle.generateRandomWords(maximum);
			
			var start: int = getTimer();
			wordle.doLayout();
			
			var runtime: int = getTimer() - start;
			trace("do layout in: " + (runtime) + "ms");
			runtimeLabel.text = "Last run time: " + runtime + "ms";
			
			//re-position wordle to make it visible on stage
			var wordleBounds: Rectangle = wordle.getBounds(this);
			wordle.x += (0 - wordleBounds.x);
			wordle.y += (0 - wordleBounds.y);
			zeroPoint.x = wordle.x;
			zeroPoint.y = wordle.y;
		}
		
	}
	
}