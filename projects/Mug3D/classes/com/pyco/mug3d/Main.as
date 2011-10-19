package com.pyco.mug3d {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import gs.easing.Expo;
	import gs.TweenLite;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Cylinder;
	
	/**
	 * ...
	 * @author Thanh Tran, Thu Hoang
	 */
	public class Main extends PaperBase {
		//stage
		public var linkText: TextField;
		public var loadButton: SimpleButton;
		
		protected var stageWidth: int = 800;
		protected var stageHeight: int = 600;
		protected var speed: Number = -2;
		
		protected var cupDae: DAE;
		protected var cupLoaded: Boolean = false;
		
		protected var displayObj3d: DisplayObject3D;
		
		protected var designCylinder: Cylinder;
		protected var firstTime: Boolean = true;
		protected var zoomCamera: Number;
		
		protected var mouseDown: Boolean = false;
		protected var mouseStartX: Number;
		protected var startRotY: Number;
		
		public function Main() {
			init(stageWidth, stageHeight);
		}
		
		override protected function init2d(): void {
			super.init2d();
		}
		
		override protected function init3d(): void {
			super.init3d();
			this.current_camera.z = 500;
			this.zoomCamera = this.current_camera.zoom;
			loadModel();
		}
		
		override protected function initEvents(): void {
			super.initEvents();
			this.loadButton.addEventListener(MouseEvent.CLICK, loadButtonClickHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler(event: MouseEvent): void {
			mouseDown = false;
		}
		
		private function mouseDownHandler(event: MouseEvent): void {
			mouseDown = true;
			mouseStartX = mouseX;
			if (displayObj3d) startRotY = displayObj3d.rotationY;
		}
		
		private function mouseWheelHandler(e: MouseEvent): void {
			var deltaZ: Number = 0;
			var currentZ: Number = current_camera.z;
			if (e.delta > 0) // scroll up
			{
				/*
				if (this.current_camera.zoom + 2 < 1.2 * zoomCamera)
				{
					zoomTarget = this.current_camera.zoom + 2;
				}else
				{
					zoomTarget = 1.2 * zoomCamera;
				}
				*/
				if (current_camera.z >= 300) {
					deltaZ = 0.2 * currentZ * (-1) ;
				}
			}else // scroll down
			{
				/*
				if (this.current_camera.zoom - 2 > 1)
				{
					zoomTarget = this.current_camera.zoom - 2;
				}else
				{
					zoomTarget = 1;
				}
				*/
				if (current_camera.z <= 2000) {
					deltaZ = 0.2 * currentZ;
				}
			}
			TweenLite.to(this.current_camera, 0.5, {z: currentZ + deltaZ , ease: Expo.easeOut } );
		}
		
		private function loadButtonClickHandler(e: MouseEvent): void {
			var url: String = trimAll(this.linkText.text);
			if (url == "") {
				return;
			}
			loadDesignBitmap(url);
		}
		
		protected function cupColladaLoadHandler(event: FileLoadEvent): void {
			cupDae.z = -182;
			cupDae.y = -100;
			cupDae.x = 25;
			cupLoaded = true;
		}
		
		protected function loadDesignBitmap(url: String): void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, designLoadHandler);
			loader.load(new URLRequest(url));			
		}
		
		private function designLoadHandler(event: Event): void {
			var loaderInfo: LoaderInfo = event.target as LoaderInfo; 
			var bitmap: Bitmap = loaderInfo.content as Bitmap;
			
			//drawing
			//background
			var radius: Number = 120;
			var whiteAreaW: Number = 80;
			var whiteAreaH: Number = 25;
			var totalW: Number = Math.round(2 * Math.PI * radius);
			var bitmapW: Number = totalW - whiteAreaW;
			//var bitmapH: Number = Math.round(bitmapW * 945 / 2362);
			var bitmapH: Number = Math.round(bitmapW * 8 / 20);
			var totalH: Number = bitmapH + whiteAreaH;
			var bitmapDataBG: BitmapData = new BitmapData(totalW, totalH, false, 0xFFFFFF);
			var bitmapBG: Bitmap = new Bitmap(bitmapDataBG);
			
			//image
			bitmap.width = bitmapW;
			bitmap.height = bitmapH;
			bitmap.x = whiteAreaW;
			bitmap.y = whiteAreaH;
				
			var sprite: Sprite = new Sprite();
			sprite.addChild(bitmapBG);
			sprite.addChild(bitmap);
			
			var bitmapData: BitmapData = new BitmapData(totalW, totalH);
			bitmapData.draw(sprite);
			
			var bitmapMaterial: BitmapMaterial = new BitmapMaterial(bitmapData);
			bitmapMaterial.doubleSided = true;
			
			if (this.firstTime) {
				this.firstTime = false;
				this.designCylinder = new Cylinder(bitmapMaterial, radius, bitmapH /*totalH*/, 30, 10, -1, false, false);
				designCylinder.rotationY = 100;
				designCylinder.y = -20;
				this.displayObj3d.addChild(designCylinder);
				current_scene.addChild(this.displayObj3d);
			}else {
				//this.displayObj3d.removeChild(designCylinder);
				designCylinder.material = bitmapMaterial;
			}
			
		}
		 
		private function loadModel(): void {
			current_camera.target = DisplayObject3D.ZERO;
			
			cupDae = new DAE();
			var materialList: MaterialsList = new MaterialsList( {
				FrontColorNoCulling: new ColorMaterial(0x0000FF, 1),
				Material2noCulling: new ColorMaterial(0xFFFF00, 1),
				Material1noCulling: new ColorMaterial(0xEEEEEE, 1),
				ForegroundColor: new ColorMaterial(0x00FFFF, 1)				
			});
			
			
			cupDae.load("Mug1.dae", materialList);
			
			this.displayObj3d = new DisplayObject3D();
			this.displayObj3d.addChild(cupDae);
			
			cupDae.addEventListener(FileLoadEvent.LOAD_COMPLETE, cupColladaLoadHandler);
			
			loadDesignBitmap("design.jpg");
		}
		
		protected override function processFrame(): void {
			super.processFrame();
			if (mouseDown) {
				var deltaX: Number = mouseX - mouseStartX;
				var toRotY: Number = startRotY + (deltaX / stageWidth * 360);
				TweenLite.to(displayObj3d, 0.5, { rotationY: toRotY, ease: Expo.easeOut } );
			} else {
				this.displayObj3d.yaw(this.speed);
			}
			current_camera.y = -(((mouseY - (stageHeight / 2)) / stageHeight) * 250);
			renderScene();
		}
		
		private function trimAll(src: String): String
		{
			var start: Number = 0;
			while (src.charAt(start) == " ") {
				start++;
			}
			
			var end: Number = src.length - 1;
			while (src.charAt(end) == " ") {
				end--;
			}
			
			var des: String = src.slice(start, end + 1);
			return des;
		}
	}
	
}