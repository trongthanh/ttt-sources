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
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import General.Input;
	
	/**
	 * A trial demo with Box2D engine (using Revolute Joint)
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#FFFFFF', frameRate='31', width='550', height='400')]
	public class Demo5BoxTwoDDistance extends Sprite {
		public var nodeList: Array;
		public var startPos: Point = new Point(275, 285);
		public var easing: Number = 0.05;
		public var currentAngle: Number = 0;
		public var targetAngle: Number = 0;
		
		public var world: b2World
		public var scale: Number = 30;
		
		private var mousePVec:b2Vec2 = new b2Vec2();
		private var mouseXWorldPhys: Number;
		private var mouseYWorldPhys: Number;
		private var mouseXWorld: Number;
		private var mouseYWorld: Number;
		private var mouseJoint: b2MouseJoint;
		private var lastNode: b2Body;
		
		public function Demo5BoxTwoDDistance () {
			stage.frameRate = 60;
			addEventListener(Event.ENTER_FRAME, render);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			var input: Input = new Input(this);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0,1);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			world = new b2World(gravity, doSleep);
			world.SetWarmStarting(true);
			// set debug draw
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(this);
			debugDraw.SetDrawScale(30.0);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			world.SetDebugDraw(debugDraw);
			world.DrawDebugData();
			
			//common vars
			var groundBody: b2Body;
			var body:b2Body;
			var bodyDef:b2BodyDef;
			var boxShape:b2PolygonShape;
			var circleShape:b2CircleShape;
			var fixtureDef:b2FixtureDef;
			var jointDef: b2DistanceJointDef;
			
			// Add ground body
			bodyDef = new b2BodyDef();
			bodyDef.position.Set(toPhysWorld(550 / 2), 12);
			//bodyDef.angle = 0.1;
			boxShape = new b2PolygonShape();
			boxShape.SetAsBox(toPhysWorld(550 / 2), toPhysWorld(10/ 2));
			fixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.friction = 0.3;
			fixtureDef.density = 0; // static bodies require zero density
			// Add sprite to body userData
			//var ground: Sprite = new Sprite();
			//ground.graphics.beginFill(0x999999, 1);
			//ground.graphics.drawRect(-275, -5, 550, 10);
			//addChild(ground);
			//bodyDef.userData = ground;
			groundBody = world.CreateBody(bodyDef);
			groundBody.CreateFixture(fixtureDef);
			
			
			circleShape = new b2CircleShape(toPhysWorld(5));
			fixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1.0;
			fixtureDef.friction = 0.5;
			fixtureDef.restitution = 0;
			//var circle: Sprite = new Sprite();
			//circle.graphics.lineStyle(1, 0, 1);
			//circle.graphics.drawCircle( 0, 0, 5);
			//addChild(circle);
			bodyDef = new b2BodyDef();
			//bodyDef.userData = circle;
			bodyDef.type = b2Body.b2_dynamicBody;
			
			//define joint
			jointDef = new b2DistanceJointDef();
			jointDef.collideConnected = true;
			
			nodeList = [];
			var space: Number = 20;
			var i: int;
			var prevBody:b2Body = groundBody;
			for (i = 0; i < 11; i ++) {
				
				if (i == 0) {
					//first node is not movable
					fixtureDef.density = 1;
					bodyDef.type = b2Body.b2_staticBody;
				} else if (i == 10) {
					//last node is not movable
					fixtureDef.density = 0;
					bodyDef.type = b2Body.b2_staticBody;
				} else {
					fixtureDef.density = 1;
					bodyDef.type = b2Body.b2_dynamicBody;
				}
				bodyDef.position.y = 10.8;
				bodyDef.position.x = toPhysWorld(550 /2 + i*space);
				
				body = world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
				
				nodeList[i] = body;
				if ( i > 0) {
					//define joint
					jointDef.Initialize(prevBody, body, new b2Vec2(toPhysWorld(550 / 2 + (i - 1) * space), 10.8),
														new b2Vec2(toPhysWorld(550 /2 + i*space), 10.8));
					//
					world.CreateJoint(jointDef);
				} else {
					jointDef.Initialize(prevBody, body, new b2Vec2(toPhysWorld(550 / 2 + i* space), 10.8),
														new b2Vec2(toPhysWorld(550 / 2 + i * space), 10.8));
					world.CreateJoint(jointDef);
				}
				
				
				prevBody = body;
			}
			lastNode = body;
			
			
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
				//nodeList[0].SetType(b2Body.b2_dynamicBody);
				var delta: Number = targetAngle - currentAngle;
				currentAngle += delta * easing;
			} else {
				//nodeList[0].SetType(b2Body.b2_staticBody);
			}
			
			lastNode.SetPosition(new b2Vec2(275 /scale + Math.cos(currentAngle * (Math.PI / 180)) * 6.7,
											10.8+ Math.sin(currentAngle * (Math.PI / 180)) * 6.7)
								);
			
			// Update mouse joint
			//updateMouseWorld()
			//mouseDestroy();
			//mouseDrag();
			
			world.Step(0.03, 10, 10);
			
			// Go through body list and update sprite positions/rotations
			/*for (var bb:b2Body = world.GetBodyList(); bb; bb = bb.GetNext()) {
				if (bb.GetUserData() is Sprite) {
					var sprite:Sprite = bb.GetUserData() as Sprite;
					sprite.x = bb.GetPosition().x * 30;
					sprite.y = bb.GetPosition().y * 30;
					sprite.rotation = bb.GetAngle() * (180/Math.PI);
				}
			}*/
			
			world.DrawDebugData();
			
			//Input.update();
		}
		
		public function toPhysWorld(stageValue: Number): Number {
			return stageValue / scale;
		}
		
		public function toStage(physValue: Number): Number {
			return physValue * scale;
		}
		
		
		//======================
		// Update mouseWorld
		//======================
		public function updateMouseWorld():void{
			mouseXWorldPhys = (Input.mouseX)/scale; 
			mouseYWorldPhys = (Input.mouseY)/scale; 
			
			mouseXWorld = (Input.mouseX); 
			mouseYWorld = (Input.mouseY); 
		}
		
		
		
		//======================
		// Mouse Drag 
		//======================
		public function mouseDrag():void{
			// mouse press
			if (Input.mouseDown && !mouseJoint){
				
				var body:b2Body = getBodyAtMouse();
				trace( "body : " + body );
				if (body)
				{
					
					var md:b2MouseJointDef = new b2MouseJointDef();
					md.bodyA = world.GetGroundBody();
					md.bodyB = body;
					md.target.Set(mouseXWorldPhys, mouseYWorldPhys);
					md.collideConnected = true;
					md.maxForce = 300.0 * body.GetMass();
					mouseJoint = world.CreateJoint(md) as b2MouseJoint;
					body.SetAwake(true);
				}
			}
			
			
			// mouse release
			if (!Input.mouseDown){
				if (mouseJoint)
				{
					world.DestroyJoint(mouseJoint);
					mouseJoint = null;
				}
			}
			
			
			// mouse move
			if (mouseJoint)
			{
				var p2:b2Vec2 = new b2Vec2(mouseXWorldPhys, mouseYWorldPhys);
				mouseJoint.SetTarget(p2);
			}
		}
		
		
		
		//======================
		// Mouse Destroy
		//======================
		public function mouseDestroy():void{
			// mouse press
			if (!Input.mouseDown && Input.isKeyPressed(68/*D*/)){
				
				var body:b2Body = getBodyAtMouse(true);
				
				if (body)
				{
					world.DestroyBody(body);
					return;
				}
			}
		}
		
		
		
		//======================
		// GetBodyAtMouse
		//======================
		
		public function getBodyAtMouse(includeStatic:Boolean = false):b2Body {
			// Make a small box.
			mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
			var body:b2Body = null;
			var fixture:b2Fixture;
			
			// Query the world for overlapping shapes.
			function GetBodyCallback(fixture:b2Fixture):Boolean
			{
				var shape:b2Shape = fixture.GetShape();
				if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
				{
					var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(), mousePVec);
					if (inside)
					{
						body = fixture.GetBody();
						return false;
					}
				}
				return true;
			}
			world.QueryAABB(GetBodyCallback, aabb);
			return body;
		}
	}
}