/**
 * Copyright 2010 trongthanh@gmail.com
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
package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.cove.ape.AbstractParticle;
	import org.cove.ape.APEngine;
	import org.cove.ape.CircleParticle;
	import org.cove.ape.Group;
	import org.cove.ape.RectangleParticle;
	import org.cove.ape.SpringConstraint;
	import org.cove.ape.VectorForce;
	/**
	 * A trial demo with APE engine
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#FFFFFF', frameRate='31', width='550', height='400')]
	public class Demo3APETwoD extends Sprite {
		public var nodeList: Array;
		public var lastNode: AbstractParticle;
		public var startPos: Point = new Point(275, 285);
		public var easing: Number = 0.05;
		public var currentAngle: Number = 0;
		public var targetAngle: Number = 0;
		
		public function Demo3APETwoD() {
			stage.frameRate = 60;
			addEventListener(Event.ENTER_FRAME, render);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);

			APEngine.init(1/4);
			APEngine.container = this;
			APEngine.addForce(new VectorForce(true, 0, 0.1));

			var defaultGroup:Group = new Group();
			defaultGroup.collideInternal = true;
			
			nodeList = [];
			var cp:CircleParticle;
			var spring: SpringConstraint;
			var i: int;
			var space: int = 20;
			var mass: Number = 0.01;
			for (i = 0; i < 11; i ++) {
				if (i == 0) {
					//first node is not movable
					cp = new CircleParticle(startPos.x + (i * space), startPos.y, 5, true, mass + (i * 0.1), 0);
					cp.setFill(0xFF0000, 1);
				} else if (i == 10) {
					cp = new CircleParticle(startPos.x + (i * space), startPos.y, 5, true, mass+ (i * 0.1),0);
					lastNode = cp;
				} else {
					cp = new CircleParticle(startPos.x + (i * space), startPos.y, 5, false, mass + (i * 0.1), 0);
					
				}
				
				nodeList[i] = cp;
				if ( i > 0) {
					spring = new SpringConstraint(nodeList[i - 1], nodeList[i], 1, false,0,0,true);
					defaultGroup.addConstraint(spring);
				}
				
				defaultGroup.addParticle(cp);
			}
			
			
			var rp:RectangleParticle = new RectangleParticle(275,300,500,20,0,true);
			defaultGroup.addParticle(rp);

			APEngine.addGroup(defaultGroup);
		}
		
		private function mouseMoveHandler(event: MouseEvent): void {
			var mx: Number = mouseX;
			//convert to scale 1
			var scale: Number = mouseX / stage.stageWidth;
			//calculate the angle
			targetAngle = (scale * 180) - 180;
		}

		private function render(event:Event):void {
			if (Math.abs(targetAngle - currentAngle) > 0.3) {
				var delta: Number = targetAngle - currentAngle;
				currentAngle += delta * easing;
			}
			//set position of the last node
			lastNode.px = lastNode.sprite.x = startPos.x + Math.cos(currentAngle * (Math.PI / 180)) * 200;
			lastNode.py = lastNode.sprite.y = startPos.y + Math.sin(currentAngle * (Math.PI / 180)) * 200;
			APEngine.step();
			APEngine.paint();
		}
	}
}