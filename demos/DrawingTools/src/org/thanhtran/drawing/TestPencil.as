/**
 * Copyright 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.thanhtran.drawing {
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * A simple pencil drawing tool with smooth function
	 * @author thanh tran
	 */
	[SWF(backgroundColor='#FFFFFF', frameRate='31', width='800', height='600')]
	public class TestPencil extends Sprite {
		public var bg:Sprite;
		public var container: Sprite;
		public var smoothButton: PushButton;
		public var clearButton: PushButton;
		public var stepButton: NumericStepper;

		private var drawing: Boolean = false;
		private var lineArray: Array = [];
		private var colorArray: Array = [];
		private var currentPointArray: Array;
		private var currentIndex: int = 0;
		
		
		public function TestPencil() {
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function addToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			//draw graphics for this clip receive mouse event:
			bg = new Sprite();
			bg.graphics.beginFill(0xFFFFFF, 1);
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			addChild(bg);
			
			container = new Sprite();
			container.graphics.lineStyle(1, 0, 1);
			addChild(container);
			
			smoothButton = new PushButton();
			smoothButton.label = "Smooth Lines";
			smoothButton.addEventListener(MouseEvent.CLICK, smoothClickHandler);
			addChild(smoothButton);
			
			clearButton = new PushButton();
			clearButton.label = "Clear All";
			clearButton.addEventListener(MouseEvent.CLICK, clearClickHandler);
			clearButton.x = smoothButton.x + smoothButton.width + 10;
			addChild(clearButton);
			
			var skipText: TextField = new TextField();
			skipText.text = "Skipped points:";
			skipText.autoSize = "left";
			skipText.x = clearButton.x + clearButton.width + 10;
			addChild(skipText);
			
			stepButton = new NumericStepper();
			stepButton.value = 2;
			stepButton.min = 1;
			stepButton.max = 10;
			stepButton.x = skipText.x + skipText.width + 10;
			
			addChild(stepButton);
			
		}
		
		private function clearClickHandler(event: MouseEvent): void {
			container.graphics.clear();
			lineArray = [];
			colorArray = [];
			currentIndex = 0;
		}
		
		private function smoothClickHandler(event: MouseEvent): void {
			smoothLines();
		}
		
		/**
		 * part of this function is based on http://www.gskinner.com/blog/archives/2008/05/drawing_curved.html
		 */
		private function smoothLines():void {
			var g: Graphics = container.graphics;
			g.clear();
			var line: Array;
			var p1: Point;
			var p2: Point;
			var prevMidPoint: Point;
			var midPoint: Point;
			var skipPoints: int = stepButton.value; //default 2			
			
			for (var j: int = 0; j < lineArray.length; j++) {
				line = lineArray[j];
				g.lineStyle(1, colorArray[j], 1);
				//trace( "line : " + j + " - " + line );
				prevMidPoint = null;
				midPoint = null;
				for (var i: int = skipPoints; i < line.length; i++) {
					if (i % skipPoints == 0) {
						p1 = line[i - skipPoints];
						p2 = line[i];
						
						midPoint = new Point(p1.x + (p2.x - p1.x) / 2, p1.y + (p2.y - p1.y) / 2);
						
						// draw the curves:
						if (prevMidPoint) {
							g.moveTo(prevMidPoint.x,prevMidPoint.y);
							g.curveTo(p1.x, p1.y, midPoint.x, midPoint.y);
						} else {
							// draw start segment:
							g.moveTo(p1.x, p1.y);
							g.lineTo(midPoint.x,midPoint.y);
						}
						prevMidPoint = midPoint;
					} 
					//draw last stroke
					if (i == line.length - 1) {
						g.lineTo(line[i].x,line[i].y);
					}
				}
			}
		}
		
		private function enterFrameHandler(event: Event): void {
			if (drawing) {
				var x: Number = mouseX;
				var y: Number = mouseY;
				var g: Graphics = container.graphics;
				g.lineTo(x, y);
				currentPointArray[currentIndex] = new Point(x, y);
				currentIndex ++;
			}
		}
		
		private function mouseUpHandler(event: MouseEvent): void {
			stopDrawing();
		}
		
		private function stopDrawing():void {
			currentPointArray = null;
			drawing = false;
		}
		
		private function mouseDownHandler(event: MouseEvent): void {
			if (event.target == bg) {
				startDrawing();
			}
		}
		
		private function startDrawing():void {
			currentIndex = 0;
			currentPointArray = [];
			lineArray.push(currentPointArray);
			var color: uint = Math.random() * 0.5 * 0xFF << 16 | Math.random() * 0.5 * 0xFF << 8 | Math.random() * 0.5 * 0xFF;
			colorArray.push(color);
			container.graphics.moveTo(mouseX, mouseY);
			container.graphics.lineStyle(1, color, 1);
			
			drawing = true;
		}
	}

}