package com.pyco.view.components.weddingcube {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.pyco.constant.CubeSideName;
	import com.pyco.view.components.weddingcube.BaseSide;
	import flash.events.Event;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	/**
	 * 6-side container forms the wedding cube
	 * @author Thu.Hoang
	 */
	[Event(name='introAnimationComplete', type='com.pyco.view.components.weddingcube.WeddingCube')]
	public class WeddingCube extends DisplayObject3D {
		//private var matList: Array;
		private var planeList: Array = [];
		private var count: uint;
		private var isReady: Boolean = false;
		private var isRotate: Boolean = false;
		private var currentPlane: BaseSide;
		private var targetPlane: BaseSide;
		
		public var back: BackSide;
		public var front: FrontSide;
		public var right: RightSide;
		public var left: LeftSide;
		public var bottom: BottomSide;
		public var top: TopSide;
		
		public static const INTRO_ANIMATION_COMPLETE: String = "introAnimationComplete";
		
		public function WeddingCube(/*matList: Array*/): void {
			//this.matList = matList;
			buildCube();
		}
		
		private function buildCube(): void {
			//front = createColouredPlane("front", 0, 0, -CubeSideName.SIDE_SIZE / 2, matList[0]); // front
			front = new FrontSide(null, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, 2, 2);
			front.currentAngle = 0;
			createSide(front, 0, 0, -CubeSideName.SIDE_SIZE / 2);
			
			//back = createColouredPlane("back", 0, 0, CubeSideName.SIDE_SIZE / 2, matList[1]); // back
			back = new BackSide(null, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, 2, 2);
			back.currentAngle = 180;
			createSide(back, 0, 0, CubeSideName.SIDE_SIZE / 2, 0, 180);
			
			//right = createColouredPlane("right", CubeSideName.SIDE_SIZE / 2, 0, 0, matList[2], 0, 90); // right
			right = new RightSide(null, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, 2, 2);
			right.currentAngle = 90;
			createSide(right, CubeSideName.SIDE_SIZE / 2, 0, 0, 0, 270);
			
			//left = createColouredPlane("left", -CubeSideName.SIDE_SIZE / 2, 0, 0, matList[3], 0, -90); // left
			left = new LeftSide(null, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, 2, 2);
			left.currentAngle = 270;
			createSide(left, -CubeSideName.SIDE_SIZE / 2, 0, 0, 0, -270);
			
			//top = createColouredPlane("top", 0, CubeSideName.SIDE_SIZE / 2, 0, matList[4], 90); // top
			top = new TopSide(null, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, 2, 2);
			createSide(top, 0, CubeSideName.SIDE_SIZE / 2, 0, 90);
			
			//bottom = createColouredPlane("bottom", 0, -CubeSideName.SIDE_SIZE / 2, 0, matList[5], -90); // bottom
			bottom = new BottomSide(null, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, 2, 2);
			createSide(bottom, 0, -CubeSideName.SIDE_SIZE / 2, 0, -90);
			
			currentPlane = front;
			targetPlane = front;
		}
		
		private function createSide(p: BaseSide, x: Number = 0, y: Number = 0, z: Number = 0, rotX: Number = 0, rotY: Number = 0, rotZ: Number = 0): void {
			p.x = x;
			p.y = y;
			p.z = z;
			p.rotationX = rotX;
			p.rotationY = rotY;
			p.rotationZ = rotZ;
			
			p.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, planeClickHandler);
			
			addChild(p);
			planeList.push(p);
		}
		
		private function planeClickHandler(event: InteractiveScene3DEvent): void {
			if (!isReady) return;
			var plane: BaseSide = event.currentTarget as BaseSide;
			goToSide(plane);
		}
		
		private function goToSide(plane: BaseSide): void {
			if (isRotate) return;
			if (plane == currentPlane) return;
			isRotate = true;
			targetPlane = plane;
			// close current side
			currentPlane.addEventListener(BaseSide.CLOSE_SIDE_COMPLETE, closeSideCompleteHandler);
			currentPlane.close();
		}
		
		private function closeSideCompleteHandler(event: Event): void {
			currentPlane.removeEventListener(BaseSide.CLOSE_SIDE_COMPLETE, closeSideCompleteHandler);
			
			if (targetPlane.name == CubeSideName.TOP || targetPlane.name == CubeSideName.BOTTOM) {
				if (currentPlane.name == CubeSideName.TOP || currentPlane.name == CubeSideName.BOTTOM) {
					TweenLite.to(this, 1, { rotationX: rotationX + 180, onComplete: rotateCompleteHandler } );
				} else {
					//TweenLite.to(this, 1, { rotationY: rotationY + getShortRotation(front.currentAngle - rotationY), onComplete: completeHorizontalHandler } ); // go to front side first
					if (targetPlane.name == CubeSideName.TOP) {
						TweenLite.to(this, 1, { rotationX: rotationX - 90, rotationY: rotationY + getShortRotation(front.currentAngle - rotationY), onComplete: rotateCompleteHandler } ); // from front side to top side
					} else { // targetPlane.name == CubeSideName.BOTTOM
						TweenLite.to(this, 1, { rotationX: rotationX + 90, rotationY: rotationY + getShortRotation(front.currentAngle - rotationY), onComplete: rotateCompleteHandler } ); // from front side to bottom side
					}
				}
			} else {
				if (currentPlane.name != CubeSideName.TOP && currentPlane.name != CubeSideName.BOTTOM) {
					TweenLite.to(this, 1, { rotationY: rotationY + getShortRotation(targetPlane.currentAngle - rotationY), onComplete: rotateCompleteHandler } );
				} else {
					//TweenLite.to(this, 1, { rotationX: 0, onComplete: rotateVerticalCompleteHandler } ); // go to normal
					TweenLite.to(this, 1, { rotationX: 0, rotationY: rotationY + getShortRotation(targetPlane.currentAngle - rotationY), onComplete: rotateCompleteHandler } );
				}
			}
		}
		
		/*private function rotateVerticalCompleteHandler(): void {
			TweenLite.to(this, 1, { rotationY: rotationY + getShortRotation(targetPlane.currentAngle - rotationY), onComplete: rotateCompleteHandler } );
		}
		
		private function completeHorizontalHandler(): void {
			if (targetPlane.name == CubeSideName.TOP) {
				TweenLite.to(this, 1, { rotationX: rotationX - 90, onComplete: rotateCompleteHandler } ); // from front side to top side
			} else { // targetPlane.name == CubeSideName.BOTTOM
				TweenLite.to(this, 1, { rotationX: rotationX + 90, onComplete: rotateCompleteHandler } ); // from front side to bottom side
			}
		}*/
		
		private function rotateCompleteHandler(): void {
			currentPlane = targetPlane;
			// open the current side
			currentPlane.open();
			isRotate = false;
		}
		
		/*private function createColouredPlane(name: String, x: Number = 0, y: Number = 0, z: Number = 0, color: uint = 0xFFFFFF, rotX: Number = 0, rotY: Number = 0, rotZ: Number = 0): Plane {
			var colorMat: ColorMaterial = new ColorMaterial(color); // interactive
			colorMat.oneSide = false;
			var p: Plane = new Plane(colorMat, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, 2, 2);
			p.name = name;
			p.x = x;
			p.y = y;
			p.z = z;
			p.rotationX = rotX;
			p.rotationY = rotY;
			p.rotationZ = rotZ;
			addChild(p);
			planeList.push(p);
			return p;
		}*/
		
		public function doIntroAnimation(): void {
			count = 0;
			var plane: Plane;
			for (var i: int = 0; i < planeList.length; i++) {
				plane = planeList[i];
				if (plane.name == CubeSideName.TOP || plane.name == CubeSideName.BOTTOM) {
					TweenLite.to(plane, 2, { x: 1.7 * plane.x, y: 1.7 * plane.y, z: 1.7 * plane.z, delay: 0.5, onComplete: planeAnimationCompleteHandler, ease: Linear.easeNone } );
				} else {
					TweenLite.to(plane, 2, { x: 2 * plane.x, y: 2 * plane.y, z: 2 * plane.z, delay: 0.5, onComplete: planeAnimationCompleteHandler, ease: Linear.easeNone } );
				}
			}
		}
		
		private function planeAnimationCompleteHandler(): void {
			count++;
			if (count >= planeList.length) {
				isReady = true;
				dispatchEvent(new Event(INTRO_ANIMATION_COMPLETE));
			}
		}
		
		private function getShortRotation(rot: Number):Number {
			rot %= 360;
			if (rot > 180) { rot -= 360; }
			else if (rot < -180) { rot += 360; }
			return rot;
		}
		
	}

}