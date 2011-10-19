package org.thanhtran.interactivewall {
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	import com.pyco.utils.pv3d.SizeConverter;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.papervision3d.core.proto.GeometryObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.thanhtran.interactivewall.events.PhotoPlaneEvent;
	
	public class Main extends PaperBase {
		protected var stageWidth: int = 800;
		protected var stageHeight: int = 600;
		protected var numberOfPhotos: int = 16;
		protected var currentPhoto: int;
		protected var photoArray: Array;
		protected var photosPerRow: int = 4;
		protected var viewingPhoto: Boolean = false;
		protected var currentViewedPhoto: PhotoPlane;
		protected var numOfReadyPhotos: int = 0;
		
		protected var wall3D: DisplayObject3D;
		private var testRect:Sprite;
		
		public function Main():void {
			init(stageWidth, stageHeight);
		}
		
		override protected function init3d(): void {
			super.init3d();
			
			default_camera.target = new DisplayObject3D("zeroObj");
			default_camera.x = 0;
			default_camera.y = 0;
			//default_camera.fov = 60;
			
			//default_camera.z = - 1000; default
			default_camera.focus = 100;
			default_camera.zoom = 5;
			
			// 3dobj.z = (camera.zoom * camera.focus) - Math.abs(camera.z);
			// z = 5 * 100 - 1000;
			// z = - 500;
			
			trace("camZ: " + default_camera.z);
			trace("camZoom: " + default_camera.zoom);
			trace("camFOV: " + default_camera.fov);
			trace("camFocus: " + default_camera.focus);
			trace("cam viewPort" + default_camera.viewport);
			
			photoArray = [];
			loadPhotos();
		}
		
		protected function loadPhotos(): void {
			current_viewport.interactive = false;
			currentPhoto = 0;
			loadSinglePhoto(currentPhoto);
		}
		
		protected function loadSinglePhoto(photoNum: int): void {
			var photoPlane: PhotoPlane = new PhotoPlane("images/small/Hinh" + (photoNum + 1) + ".jpg", 200, 150, 2, 2);
			photoPlane.addEventListener(Event.COMPLETE, photoPlaneCompleteHandler);
			photoPlane.addEventListener(PhotoPlaneEvent.START_VIEW, photoStartViewHandler);
			photoPlane.addEventListener(PhotoPlaneEvent.STOP_VIEW, photoStopViewHandler);
			photoPlane.addEventListener(PhotoPlaneEvent.ANIMATION_STOP, photoStopAnimationHandler);
			photoArray.push(photoPlane);
		}
		
		private function photoStopAnimationHandler(event: PhotoPlaneEvent): void {
			currentViewedPhoto = event.currentTarget as PhotoPlane;
			//testing
			trace("plane scale: " + SizeConverter.calculateScale(current_camera, currentViewedPhoto.z));
			var realsize: Rectangle = SizeConverter.calculatePlane2DSize(current_camera, currentViewedPhoto, currentViewedPhoto.width, currentViewedPhoto.height);
			
			testRect = new Sprite();
			//testRect.mouseChildren = false;
			testRect.mouseEnabled = false;
			testRect.graphics.beginFill(0x0000FF, 0.5);
			testRect.graphics.lineStyle(1, 0xFFFF00, 1);
			testRect.graphics.drawRect(0, 0, realsize.width, realsize.height);
			testRect.graphics.endFill();
			testRect.x = realsize.x - realsize.width /2;
			testRect.y = realsize.y - realsize.height /2;
			this.addChild(testRect);
		}
		
		private function photoStopViewHandler(event: PhotoPlaneEvent): void {
			viewingPhoto = false;
			this.removeChild(testRect);
		}
		
		private function photoStartViewHandler(event: PhotoPlaneEvent): void {
			viewingPhoto = true;
		}
		
		private function photoPlaneCompleteHandler(event: Event): void {
			if (currentPhoto < numberOfPhotos) {
				currentPhoto ++;
				loadSinglePhoto(currentPhoto);
			} else {
				//all photo planes have been created:
				addPlanesIntoView();
			}
		}
		
		protected function addPlanesIntoView(): void {
			wall3D = new DisplayObject3D("wall3D");
			wall3D.x = - (830 / 2) + 100;
			wall3D.y = (630 / 2) - 75;
			wall3D.z = 0;
			default_scene.addChild(wall3D);
			Global.wall3D = wall3D;
			
			var photoPlane: PhotoPlane;
			for (var i:int = 0; i < numberOfPhotos; i++) {
				photoPlane = photoArray[i] as PhotoPlane;
				photoPlane.x = 400;
				photoPlane.y = 600;
				photoPlane.z = 800;
				photoPlane.rotationX = 180;
				photoPlane.alpha = 0;
				wall3D.addChild(photoPlane);
				//default_scene.addChild(photoPlane);
				Tweener.addTween(photoPlane, {  x: (i%photosPerRow)  * (200 + 10),
												y: - (Math.floor(i/photosPerRow) * (150 + 10)),
												z: (Math.floor(Math.random() * 5)) * 100,
												rotationX: 0,
												alpha: 1,
												time: 2,
												transition: Equations.easeOutExpo,
												delay: i * 0.1,
												onComplete: photoDisplayCompleteHandler,
												onCompleteParams: [photoPlane]
											 });
			}
		}
		
		private function photoDisplayCompleteHandler(photoPlane: PhotoPlane):void {
			numOfReadyPhotos ++;
			//trace("numOfReadyPhotos: " + numOfReadyPhotos);
			if (numOfReadyPhotos == numberOfPhotos) {
				current_viewport.interactive = true;
			}
		}
		
		
		
		override protected function processFrame(): void {
			super.processFrame();
			if (mouseX == 0) return;
			var deltaMouseX: Number;
			var deltaMouseY: Number
			if ( viewingPhoto) {
				deltaMouseX = 0;
				deltaMouseY = 0;
			} else {
				deltaMouseX = mouseX - (stageWidth / 2);
				deltaMouseY = mouseY - (stageHeight / 2);
			}
			
			Tweener.addTween(default_camera, {  x: deltaMouseX,
												y: - deltaMouseY,
												time: 1,
												transition: Equations.easeOutExpo
												});
		}
		
	}
}