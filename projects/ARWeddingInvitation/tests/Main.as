package {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.render.Renderer;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MovieMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.data.CubeMaterialsData;
	import away3d.primitives.Plane;
	import com.danzen.interfaces.ostrich.OstrichCamera;
	import com.danzen.interfaces.ostrich.OstrichCursor;
	import com.greensock.TweenLite;
	import com.pyco.view.components.CustomizedMotionTracker;
	import com.pyco.view.components.WeddingBox;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import away3d.cameras.*;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Thu.Hoang
	 */
	public class Main extends Sprite {
		////////////////////Ostrich Motion Tracking in Flash ////////////////////////
		/*public var box: WeddingBox = new WeddingBox();
		private var camera:OstrichCamera;
		private var cursor:OstrichCursor;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addChild(box);
			camera = new OstrichCamera();
			addChild(camera);
			camera.alpha = 0.2;
			camera.addEventListener(OstrichCamera.READY, readyHandler);
		}
		
		private function readyHandler(event: Event): void {
			cursor = new OstrichCursor(camera);
			addChild(cursor);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event: Event): void {
			box.x = cursor.x + WeddingBox.RADIUS;
			box.y = cursor.y + WeddingBox.RADIUS;
		}*/
		////////////////////END Ostrich Motion Tracking in Flash ////////////////////////
		
		////////////////////Away 3d Cube ////////////////////////////////////////////////
		/*private var viewPort: View3D;
		private var cube: Cube;
		
		[Embed(source = "/../assets/images/marble.jpg")]
		private var myTexture: Class;
		private var myBitmap: Bitmap = new myTexture();
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			createCube01();
			addEventListener(Event.ENTER_FRAME, renderThis);
		}
		
		private function renderThis(event: Event): void {
			viewPort.camera.rotationX = mouseX / 2;
			viewPort.camera.rotationY = mouseY / 2;
			cube.rotationX += 1;
			cube.rotationY += 1;
			cube.rotationZ += 1;
			viewPort.camera.moveTo(cube.x, cube.y, cube.z);
			viewPort.camera.moveBackward(500);
			viewPort.render();
		}
		
		public function createCube01(): void {
			viewPort = new View3D( { x: 100, y: 100 } );
			addChild(viewPort);
			
			cube = new Cube( { width: 150, height: 150, depth: 150, material: myMaterial } );
			viewPort.scene.addChild(cube);	
		}*/
		////////////////////End Away 3d Cube ////////////////////////////////////////////
		private var view: View3D;
		private var planeContainer: ObjectContainer3D;
		private var cube: Cube;
		private var planeList: Array = [];
		private var colorList: Array = [];
		private var count:int;
		private var isReady:Boolean;
		private var maskPlane: Plane;
		
		///Motion detection
		private var cam: Camera;
		private var vid: Video;
		private var motionTracker: CustomizedMotionTracker;
		private var output: Bitmap;
		private var target: Sprite;
		private var video: BitmapData;
		private var input: Bitmap;
		private var isSlide:Boolean;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// entry point
			video = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF);
			input = new Bitmap(video);
			input.scaleX = -1; // if flipInput = true
			input.x = stage.stageWidth;
			addChild(input);
			// Create a video
			vid = new Video(stage.stageWidth, stage.stageHeight);
			addChild(vid);
			
			init3D();
			doAnimation();
			addEventListener(Event.ENTER_FRAME, renderThis);
		}
		/*
		private function stageClickHandler(event: MouseEvent): void {
			if (!isSlide) {
				isSlide = true;
				rotate90();
			}
		}
		*/
		private function statusHandler(event: StatusEvent): void {
			//addEventListener(MouseEvent.CLICK, stageClickHandler);
			
			if (event.code == "Camera.Unmuted") {
				motionTracker = new CustomizedMotionTracker();
				//motionTracker.trackingArea = new Rectangle(200, 200, 400, 200);
				motionTracker.input = vid;
				motionTracker.flipInput = true;
				
				output = new Bitmap(motionTracker.trackingImage);
				output.alpha = 0.5;
				//output.x = motionTracker.trackingArea.x;
				//output.y = motionTracker.trackingArea.y;
				addChild(output);
				
				target = new Sprite();
				var g: Graphics = target.graphics;
				g.lineStyle(0, 0xFFFFFF);
				g.drawCircle(0, 0, 10);
				target.x = motionTracker.trackingArea.x + /*motionTracker.trackingArea.width*/600;
				target.y = motionTracker.y + motionTracker.trackingArea.y + motionTracker.trackingArea.height / 2;
				addChild(target);
				
				setTimeout(track, 1000);
			}
		}
		
		private function track(): void {
			target.x = motionTracker.trackingArea.x + /*motionTracker.trackingArea.width*/600;
			isReady = true;
		}
		
		private function renderThis(event: Event): void {
			/*if (mouseX == 0) return;
			var deltaMouseX: Number;
			var deltaMouseY: Number;
			deltaMouseX = mouseX - (stage.stageWidth / 2);
			deltaMouseY = mouseY - (stage.stageHeight / 2);
			view.camera.x = deltaMouseX;
			view.camera.y = 150 + deltaMouseY;
			view.camera.lookAt(cube.position);*/
			if (isReady) {
				/*cube.rotationX += 1;
				cube.rotationY += 1;
				cube.rotationZ += 1;
				
				cube.yaw(5);
				planeContainer.yaw(5);*/
				if (!isSlide) {
					// Tell the MotionTracker to update itself
					motionTracker.track();
					video.draw(motionTracker.input);
					if(motionTracker.hasMovement) target.x = motionTracker.trackingArea.x + motionTracker.x;
					if (target.x <= 300) {
						isSlide = true;
						isReady = false;
						rotate90();
					}
				}
			}
			view.render();
		}
		
		private function rotate90(): void {
			TweenLite.to(planeContainer, 0.5, { rotationY: planeContainer.rotationY + 90, onComplete: rotateCompleteHandler } );
		}
		
		private function rotateCompleteHandler(): void {
			isSlide = false;
			setTimeout(track, 500);
		}
		
		private function init3D(): void {
			view = new View3D( { width: stage.stageWidth, height: stage.stageHeight } );
			view.renderer = Renderer.INTERSECTING_OBJECTS;
			planeContainer = new ObjectContainer3D( { visible: false } );
			
			view.scene.addChild(planeContainer);
			
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			view.alpha = 0.5;
			addChild(view);
			var color: uint;
			for (var i: int = 0; i < 6; i++) {
				color = Math.random() * 0xFFFFFF;
				colorList.push(color);
			}
			
			cube = new Cube( { /*y: -100, */width: 200, height: 0, depth: 200 } );
			cube.cubeMaterials = new CubeMaterialsData( { back: colorList[0], front: colorList[1], right: colorList[3], left: colorList[2], top: colorList[5], bottom: colorList[4] } );
			view.scene.addChild(cube);
			
			var bound: Sprite = new Sprite();
			var g: Graphics = bound.graphics;
			var gType: String = GradientType.RADIAL;
			var matrix: Matrix = new Matrix();
			matrix.createGradientBox(1000, 1000, 0, 0, 0);
			
			var gColors: Array = [0x959595, 0xFFFFFF];
			var gAlphas: Array = [1, 1];
			var gRatio: Array = [0, 85];
			
			g.beginGradientFill(gType, gColors, gAlphas, gRatio, matrix);
			g.drawRect(0, 0, 1000, 1000);
			g.endFill();
			var mat: MovieMaterial = new MovieMaterial(bound);
			maskPlane = new Plane( { width: 1000, height: 1000/*, segmentsW: 20, segmentsH: 20*/, material: mat } );
			view.camera.y = 200;
			view.scene.addChild(maskPlane);
			
			var plane1: Plane = createColouredPlane("Plane1", 0, 0, 100, colorList[0]);
			planeContainer.addChild(plane1);
			planeList.push(plane1);
			
			var plane2: Plane = createColouredPlane("Plane2", 0, 0, -100, colorList[1]);
			planeContainer.addChild(plane2);
			planeList.push(plane2);
			
			var plane3: Plane = createColouredPlane("Plane3", 100, 0, 0, colorList[2], 0, 90);
			planeContainer.addChild(plane3);
			planeList.push(plane3);
				
			var plane4: Plane = createColouredPlane("Plane4", -100, 0, 0, colorList[3], 0, -90);
			planeContainer.addChild(plane4);
			planeList.push(plane4);
			
			var plane5: Plane = createColouredPlane("Plane5", 0, 100, 0, colorList[4], 90);
			planeContainer.addChild(plane5);
			planeList.push(plane5);
			
			var plane6: Plane = createColouredPlane("Plane6", 0, -100, 0, colorList[5], -90);
			planeContainer.addChild(plane6);
			planeList.push(plane6);
		}
		
		public function doAnimation(): void {
			TweenLite.to(cube, 2, { height: 200, onComplete: growCompleteHandler, onUpdate: updateHander } );
		}
		
		private function growCompleteHandler(): void {
			TweenLite.to(cube, 2, { y: 250, onComplete: completeHandler } );
		}
		
		private function updateHander(): void {
			cube.y = cube.height / 2;
		}
		
		private function completeHandler(): void {
			count = 0;
			planeContainer.y = cube.y;
			cube.visible = false;
			//maskPlane.visible = false;
			planeContainer.visible = true;
			var plane: Plane;
			for (var i: int = 0; i < planeList.length; i++) {
				plane = planeList[i];
				TweenLite.to(plane, 2, { x: 2 * plane.x, y: 2 * plane.y, z: 2 * plane.z, onComplete: planeAnimationCompleteHandler } );
			}
		}
		
		private function planeAnimationCompleteHandler(): void {
			count++;
			if (count >= planeList.length) {
				//isReady = true;
				// Init motion detection
				initTracking();
			}
		}
		
		private function initTracking(): void {
			// Create camera
			cam = Camera.getCamera();
			if (!cam) {
				trace("No webcam!!!");
				return;
			}
			cam.setMode(stage.stageWidth, stage.stageHeight, stage.frameRate);
			cam.addEventListener(StatusEvent.STATUS, statusHandler);
			
			vid.attachCamera(cam);
		}
		
		private function createColouredPlane(name: String, x: Number = 0, y: Number = 0, z: Number = 0, color: uint = 0xFFFFFF, rotX: Number = 0, rotY: Number = 0, rotZ: Number = 0): Plane {
			var plane: Plane = new Plane( { name: name, x: x, y: y, z: z, rotationX: rotX, rotationY: rotY, rotationZ: rotZ, width: 200, height: 200, material: new ColorMaterial(color/*, { alpha: 0 } */) } );
			plane.yUp = false;
			plane.bothsides = true;
			return plane;
		}
	}
	
}