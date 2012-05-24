/**
* @author Thanh Tran
*/
package org.thanhtran.interactivewall {
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.proto.GeometryObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.thanhtran.interactivewall.events.PhotoPlaneEvent;
	
	/**
	* ...
	*/
	public class PhotoPlane extends Plane {
		protected var bitmapMaterial: BitmapMaterial;
		protected var originalZ: Number;
		protected var originalX: Number;
		protected var originalY: Number;
		protected var firsTime: Boolean = true;
		protected var viewing: Boolean = false;
		protected var _mouseEnabled: Boolean = true;
		
		public var width: Number;
		public var height: Number;
		public var photoURL: String;
		
		public function PhotoPlane(photoURL: String = null, width:Number = 0, height:Number = 0, segmentsW:Number = 0, segmentsH:Number = 0) {
			super(null, width, height, segmentsW, segmentsH);
			this.width = width;
			this.height = height;
			this.photoURL = photoURL;
			useOwnContainer = true;
			if (photoURL) load(photoURL);
			initEvents();
		}
		
		protected function initEvents():void {
			addEventListener(InteractiveScene3DEvent.OBJECT_OVER, rollOverHandler);
			addEventListener(InteractiveScene3DEvent.OBJECT_OUT, rollOutHandler);
			addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, clickHandler);
		}
		
		private function clickHandler(event: InteractiveScene3DEvent): void {
			if (!_mouseEnabled) return;
			if (viewing) {
				moveBack();
				viewing = false;
				dispatchEvent(new PhotoPlaneEvent(PhotoPlaneEvent.STOP_VIEW));
			} else {
				Tweener.addTween(this,{ z: -800, x: (830 / 2) - 100, y: -((630 / 2) - 75),
										time: 0.5, transition: "linear", onComplete: animationCompleteHandler } );
				viewing = true;
				dispatchEvent(new PhotoPlaneEvent(PhotoPlaneEvent.START_VIEW));
			}
		}
		
		private function animationCompleteHandler():void {
			dispatchEvent(new PhotoPlaneEvent(PhotoPlaneEvent.ANIMATION_STOP));
		}
		
		private function rollOutHandler(event: InteractiveScene3DEvent): void {
			if (!viewing && _mouseEnabled) moveBack();
		}
		
		protected function moveBack(): void {
			Tweener.addTween(this, { z: originalZ, y: originalY, x: originalX, time: 0.2, transition: "linear" } );
		}
		
		private function rollOverHandler(event: InteractiveScene3DEvent): void {
			if (firsTime) {
				originalZ = z;
				originalX = x;
				originalY = y;
				firsTime = false;
			}
			if (!viewing && _mouseEnabled) {
				Tweener.addTween(this, { z: -150, time: 0.2, transition: "linear" } );
			}
		}
		
		public function load(photoURL: String): void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, photoLoadCompleteHandler);
			loader.load(new URLRequest(photoURL));
		}
		
		private function photoLoadCompleteHandler(event: Event): void {
			var loadedBitmap: Bitmap = (event.currentTarget as LoaderInfo).content as Bitmap;
			var bitmapData: BitmapData = loadedBitmap.bitmapData;
			
			bitmapMaterial = new BitmapMaterial(bitmapData);
			bitmapMaterial.doubleSided = true;
			bitmapMaterial.interactive = true;
			material = bitmapMaterial;
			dispatchEvent(event);
		}
		
		private function get realSize(): Rectangle {
			var projectedW: Number = width;
			var projectedH: Number = height;
			
			
			//Math.abs(camera.z - obj.z) / camera.focus == camera.zoom - 1; 
			
			return null;
			//var rect: Rectangle = new REc
			
		}
		
		public function get mouseEnabled(): Boolean { return _mouseEnabled; }
		
		public function set mouseEnabled(value: Boolean): void {
			_mouseEnabled = value;
		}
	}
	
}