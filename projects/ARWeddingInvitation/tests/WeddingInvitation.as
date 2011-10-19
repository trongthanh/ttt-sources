package {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.pyco.constant.CubeSideName;
	import com.pyco.view.components.weddingcube.WeddingCube;
	import examples.PV3DARApp;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	
	/**
	 * <p>Main entry to compile the application</p>
	 * @author Thu.Hoang
	 */
	public class WeddingInvitation extends PV3DARApp {
		public static var mainMovie: WeddingInvitation;
		
		private var cube: Cube;
		//private var colorList: Array = [];
		private var planeContainer: WeddingCube;
		private var isReady: Boolean = false;
		private var isGrow: Boolean = false;
		private var growTween: TweenLite;
		
		public function WeddingInvitation(): void {
			isRasterViewMode(false);
			mainMovie = this;
			// Initalize application with the path of camera calibration file and patter definition file.
			addEventListener(Event.INIT, initHandler);
			init("data/camera_para.dat", "data/wedding_logo.pat");
		}
		
		private function initHandler(event: Event): void {
			init3D();
			addEventListener(Event.ENTER_FRAME, renderThis);
		}
		
		private function stageClickHandler(event: MouseEvent): void {
			TweenLite.to(planeContainer, 1, { rotationY: planeContainer.rotationY + 90} );
		}
		
		private function renderThis(event: Event): void {
			if (isReady) {
				//cube.yaw(5);
				//planeContainer.yaw(5);
				if (planeContainer.bottom.container) {
					trace( "planeContainer.bottom.container.height : " + planeContainer.bottom.container.height );
					trace( "planeContainer.bottom.container.width : " + planeContainer.bottom.container.width );
				}
				
				_renderer.render();
			} else {
				if (!isGrow && _markerNode.visible) {
					isGrow = true;
					doAnimation();
				} else if (!_markerNode.visible) {
					isGrow = false;
					if(growTween) growTween.kill();
					cube.scaleY = 0;
					cube.z = 0;
				}
			}
		}
		
		private function doAnimation(): void {
			growTween = TweenLite.to(cube, 2, { scaleY: 1, onComplete: growCompleteHandler, onUpdate: updateHander, ease: Linear.easeNone } );
		}
		
		private function updateHander(): void {
			cube.z = cube.scaleY * CubeSideName.SIDE_SIZE / 2;
		}
		
		private function growCompleteHandler(): void {
			planeContainer.copyTransform(_markerNode.transform);
			planeContainer.moveForward(CubeSideName.SIDE_SIZE / 2);
			planeContainer.localRotationX = -90;
			planeContainer.localRotationY = -90;
			cube.visible = false;
			planeContainer.visible = true;
			stopDetect();
			isReady = true;
			
			TweenLite.to(planeContainer, 2, { x: 0, y: 0, z: 280, rotationX: 0, rotationY: 0, rotationZ: 0, localRotationX: 0, onComplete: completeHandler, ease: Linear.easeNone } );
		}
		
		private function completeHandler(): void {
			planeContainer.addEventListener(WeddingCube.INTRO_ANIMATION_COMPLETE, introAnimationCompleteHandler);
			planeContainer.doIntroAnimation();
		}
		
		private function introAnimationCompleteHandler(event: Event): void {
			planeContainer.removeEventListener(WeddingCube.INTRO_ANIMATION_COMPLETE, introAnimationCompleteHandler);
			//stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		private function init3D(): void {
			_viewport.interactive = true;
			
			// randome the color for all sides of cube
			/*var color: uint;
			for (var i: int = 0; i < 6; i++) {
				color = Math.random() * 0xFFFFFF;
				colorList.push(color);
			}
			
			colorList[0] = 0x0000FF; // front
			colorList[1] = 0x00FF00; // back
			colorList[2] = 0x00FFFF; // right
			colorList[3] = 0xFFFFFF; // left
			colorList[4] = 0x000000; // top
			colorList[5] = 0xFF0000; // bottom*/
			
			// Create container fomring 6 sides of one cube by 6 Planes first
			planeContainer = new WeddingCube(/*colorList*/);
			planeContainer.visible = false;
			_scene.addChild(planeContainer);
			
			// Then you can get each side from the above container to create a cube in marker node
			// Change the front and the back
			var matList: MaterialsList = new MaterialsList( { front: planeContainer.back.sideMaterial/*new ColorMaterial(colorList[1])*/, 
															back: planeContainer.front.sideMaterial/*new ColorMaterial(colorList[0])*/, 
															right: planeContainer.right.sideMaterial/*new ColorMaterial(colorList[2])*/, 
															left: planeContainer.left.sideMaterial/*new ColorMaterial(colorList[3])*/, 
															top: planeContainer.top.sideMaterial/*new ColorMaterial(colorList[4])*/, 
															bottom: planeContainer.bottom.sideMaterial/*new ColorMaterial(colorList[5])*/ } );
			cube = new Cube(matList, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, CubeSideName.SIDE_SIZE, 2, 2, 2);
			cube.rotationX = 90;
			cube.rotationZ = 90;
			cube.scaleY = 0;
			cube.z = 0;
			_markerNode.addChild(cube);
			
		}
		
	}

}