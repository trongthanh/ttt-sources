/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import com.adobe.webapis.flickr.Photo;
	import flash.system.LoaderContext;
	import org.trongthanh.flickr.FlickrPhotoURL;
	import org.trongthanh.flickr.FlickrPhotoSize;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	
	public class PhotoItem extends MovieClip {
		//on-stage
		//public var progress_mc: MovieClip;
		public var wheel_mc: MovieClip;
		//
		private var photoLoader: Loader;
		private var _isLoaded: Boolean;
		public var isAdded: Boolean;
		private var photo: Photo;
		
		public function PhotoItem() {
			_isLoaded = false;
			isAdded = false;
		}
		
		private function loadPhoto(photoURL: String): void {
			photoLoader = new Loader();
			var contentLoader: LoaderInfo = photoLoader.contentLoaderInfo;
			//contentLoader.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			contentLoader.addEventListener(Event.COMPLETE, loadComplete);
			
			//IMPORTANT: using LoaderContext with checkPolicyFile set to true to avoid check for cross domain policy
			photoLoader.load(new URLRequest(photoURL), new LoaderContext(true));
			
		}
		
		public function setFlickrPhoto(photo: Photo) {
			this.photo = photo;
			loadPhoto(FlickrPhotoURL.getURLfromPhoto(photo, FlickrPhotoSize.SMALL_SQUARE));
		}
		/*
		private function loadProgress(e:ProgressEvent):void {
		var loaderInfo: LoaderInfo = LoaderInfo(e.target);
		
			var percent: int = Math.round(loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
			progress_mc.scaleY = percent;
		
		}
		*/
		private function loadComplete(e:Event):void {
			//progress_mc.visible = false;
			wheel_mc.visible = false
			_isLoaded = true;
			this.addChild(photoLoader);
		}
		
		public function get isLoaded (): Boolean {
			return _isLoaded;
		}
		
	}
	
}
