package org.thanhtran.earth3d {
	import com.google.maps.LatLng;
	import com.google.maps.MapEvent;
	import com.google.maps.MapType;
	import com.pyco.utils.pv3d.SizeConverter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import gs.easing.Expo;
	import gs.TweenLite;
	import org.papervision3d.core.utils.Mouse3D;
	import org.papervision3d.core.utils.virtualmouse.VirtualMouse;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	import org.thanhtran.earth3d.events.Earth3DMouseEvent;
	import org.thanhtran.maps.Earth3DMap;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Main extends PaperBase {
		public static const STAGE_WIDTH: int = 600;
		public static const STAGE_HEIGHT: int = 400;
		
		public var zoomButton: MovieClip;
		
		protected var earth: Earth3D;
		protected var outputText:TextField;
		public var virtualMouse: VirtualMouse;
		protected var mouse3D: Mouse3D;
		protected var googleMap: Earth3DMap;
		
		protected var startX: Number;
		protected var startY: Number;
		protected var isRotating: Boolean = false;
		protected var isZooming: Boolean = false;
		protected var isZoomIn: Boolean = false;
		
		protected var zeroObject3D: DisplayObject3D = new DisplayObject3D();
		protected var positionTarget: DisplayObject3D = new DisplayObject3D();
		
		public function Main(): void {
			init(STAGE_WIDTH, STAGE_HEIGHT);
		}
		
		
		
		override protected function init3d(): void {
			super.init3d();
			
			current_camera.target = zeroObject3D;
			current_camera.x = 0;
			current_camera.y = 0;
			current_camera.z = - 1500;
			virtualMouse = current_viewport.interactiveSceneManager.virtualMouse;
			mouse3D = current_viewport.interactiveSceneManager.mouse3D;
			Mouse3D.enabled = true;
			//initEarth3D();
		}
		
		protected function initEarth3D(): void {
			
			earth = new Earth3D(virtualMouse);
			earth.addEventListener(Earth3DMouseEvent.EARTH_RELEASE, earthReleaseHandler);
			earth.addEventListener(Earth3DMouseEvent.EARTH_PRESS, earthPressHandler);
			
			current_scene.addChild(earth, "earth");
			renderScene();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseUpHandler);
		}
		
		private function stageMouseUpHandler(event: MouseEvent): void {
			
		}
		
		private function stageMouseDownHandler(event: MouseEvent): void {
			
		}
		
		private function earthPressHandler(event: Earth3DMouseEvent): void {
			//if (isZoomIn) {
				//startX = earth.lat;
				//startY = mouseY;
				//if (earth) {
					//startRotX = earth.rotationX;
					//startRotY = earth.rotationY;
				//}
				//isRotating = true;
			//}
		}
		
		private function earthReleaseHandler(event: Earth3DMouseEvent): void {
			trace("earth clicked");
			
			if (isZoomIn) {
				
				
			} else {
				isZooming = true;
				var lng: Number = event.mouseLng;
				var lat: Number = event.mouseLat;
				
				//trace("distance: " + distance);
				var camZ: Number = earth.getCameraZForZoom(current_camera, 7, lat);
				
				TweenLite.to(current_camera, 2, { z: camZ,
											  ease: Expo.easeOut,
											  onComplete: zoomCompleteHandler
											  });
				
				TweenLite.to(earth, 2, { centerLng: lng,
									 centerLat: lat,
									 ease: Expo.easeOut
									 });	
				isZoomIn = true;
				zoomButton.visible = true;
				
			}
			
		}
		
		protected function zoomCompleteHandler(): void {
			isZooming = false;
			if (isZoomIn) {
				googleMap.setCenter(new LatLng(earth.centerLat, earth.centerLng), 5);
				googleMap.visible = true;
				TweenLite.from(googleMap, 2, { alpha: 0 } );
			}
		}
		
		override protected function init2d(): void {
			super.init2d();
			
			googleMap = new Earth3DMap();
			//googleMap.x = -600;
			addChild(googleMap);
			googleMap.addEventListener(MapEvent.MAP_READY, googleMapReadyHandler);			
			
			outputText = new TextField();
			outputText.multiline = true;
			outputText.textColor = 0xFFFFFF;
			outputText.autoSize = TextFieldAutoSize.LEFT;
			outputText.selectable = false;
			outputText.width = 200;
			outputText.mouseEnabled = false;
			addChild(outputText);
			
			var crosshair: Crosshair = new Crosshair();
			crosshair.x = STAGE_WIDTH / 2;
			crosshair.y = STAGE_HEIGHT / 2;
			crosshair.mouseEnabled = false;
			addChild(crosshair);
			
			zoomButton = new MyButton();
			zoomButton.x = 500;
			zoomButton.y = 20;
			zoomButton.buttonMode = true;
			zoomButton.addEventListener(MouseEvent.CLICK, zoomButtonClickHandler);
			zoomButton.visible = false;
			addChild(zoomButton);
		}
		
		private function googleMapReadyHandler(event: MapEvent): void {
			trace("map ready");
			googleMap.setSize(new Point(STAGE_WIDTH, STAGE_HEIGHT));
			
			initEarth3D();
		}
		
		private function zoomButtonClickHandler(event: MouseEvent): void {
			zoomOut();
		}
		
		private function zoomOut():void {
			isZooming = true;
			var centerLatLng: LatLng = googleMap.getCenter();
			earth.centerLat = centerLatLng.lat();
			earth.centerLng = centerLatLng.lng();
			
			TweenLite.to(current_camera, 1, { z: -1500 ,
											  ease: Expo.easeOut,
											  onComplete: zoomCompleteHandler
											  });
			isZoomIn = false;
			zoomButton.visible = false;
			googleMap.visible = false;
		}
		
		override protected function processFrame(): void {
			super.processFrame();
			if (!earth) return;
			if (isZoomIn && !isZooming) {
				var centerLatLng: LatLng = googleMap.getCenter();
				outputText.text = Earth3D.formatLatStr(centerLatLng.lat()) + "\n" + Earth3D.formatLngStr(centerLatLng.lng());
			} else {
				outputText.text = Earth3D.formatLatStr(earth.centerLat) + "\n" + Earth3D.formatLngStr(earth.centerLng);
			}
			
			if (isRotating) {
				//outputText.text = Math.round(virtualMouse.x) + " - " + Math.round(virtualMouse.y) + "\n" +
								  //Math.round(earth.rotationX) + " - " + Math.round(earth.rotationY);
				renderScene();
			} else {
				//outputText.text = Math.round(virtualMouse.x) + " - " + Math.round(virtualMouse.y) + "\n" +
								  //"Lng: " + Math.round(earth.lng) + " - Lat: " + Math.round(earth.lat) + "\n" +
								  //Math.round(mouse3D.x) + " - " + Math.round(mouse3D.y) + " - " + Math.round(mouse3D.z) + "\n" + 
								  //"zeroObj rot: " + Math.round(zeroObject3D.rotationX) + " - " + Math.round(zeroObject3D.rotationY) + " - " + Math.round(zeroObject3D.rotationZ) + "\n" +
								  //"earth rot: " + Math.round(earth.rotationX) + " - " + Math.round(earth.rotationY) + " - " + Math.round(earth.rotationZ);
			}
			
			if (isZooming) {
				renderScene();
			}
		}
	}
}