package {
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	/**
	 * TODO: convert to AIR to bypass crossdomain problem
	 * @author Thanh Tran
	 */
	public class Main extends Sprite {
		public var authorizeButton: PushButton;
		public var uploadButton: PushButton;
		public var label: Label;
		public var fileRef: FileReference;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			authorizeButton = new PushButton(this, 10, 10, "Authorize", authorizeHandler);
			
			uploadButton = new PushButton(this, 10, 30, "Browse and Upload", uploadClickHandler);
			label = new Label(this, 10, 50, "File:");
		}
		
		private function authorizeHandler(e: MouseEvent):void {
			var authorizeURL: String = "https://www.google.com/accounts/AuthSubRequest?scope=https%3A%2F%2Fpicasaweb.google.com%2Fdata%2F&session=1&secure=0&next=";
			//authorizeURL += escape("http://thanhtran-sources.googlecode.com/svn/trunk/demos/PicasaWebDataAPI/bin/index.html");
			authorizeURL += escape("http://localhost/picasa/index.html");
			
			navigateToURL(
			new URLRequest(authorizeURL), "_self");
		}
		
		private function uploadClickHandler(e:MouseEvent):void {
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, fileSelectHandler);
			fileRef.addEventListener(ProgressEvent.PROGRESS, uploadProgressHandler);
			fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteHandler);
			fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, uploadStatusHandler);
			fileRef.addEventListener(Event.COMPLETE, loadCompleteHandler);
			fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadErrorHandler);
			fileRef.browse();
			
			
		}
		
		private function uploadCompleteHandler(e:DataEvent):void {
			label.text = fileRef.name + " - upload completed";
		}
		
		private function uploadErrorHandler(e:SecurityErrorEvent):void {
			label.text = "Error: security error";
		}
		
		private function uploadStatusHandler(e:HTTPStatusEvent):void {
			label.text = "Error: " + e.status;
		}
		
		private function loadCompleteHandler(e: Event):void {
			trace("load local file complete");
			var request: URLRequest = new URLRequest("https://picasaweb.google.com/data/feed/api/user/trongthanh/albumid/GiangDien");
			request.requestHeaders = [];
			//fileRef.upload(request);
			request.contentType = "image/jpeg"; 
			request.requestHeaders.push(new URLRequestHeader('GData-Version','2.0')); 
			request.requestHeaders.push(new URLRequestHeader("Host","picasaweb.google.com")); 
			request.requestHeaders.push(new URLRequestHeader("Content-Length",fileRef.data.length.toString())); 
			request.requestHeaders.push(new URLRequestHeader('Slug','image.jpg')); 
			request.data = fileRef.data; 
			request.method = URLRequestMethod.POST; 
			var loader: URLLoader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, uploadCompleteHandler); 
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, uploadStatusHandler); 
			loader.load(request);
		}
		
		private function uploadProgressHandler(e:ProgressEvent):void {
			label.text = fileRef.name + " - " + e.bytesLoaded + "/" + fileRef.size;
		}
		
		private function fileSelectHandler(e:Event):void {
			trace("file selected & about to upload");
			label.text = fileRef.name + " - " + fileRef.size;
			
			//var request: URLRequest = new URLRequest("https://picasaweb.google.com/data/feed/api/user/trongthanh/albumid/GiangDien");
			//request.requestHeaders = [];
			
			fileRef.load();
		}
		
		
	}
	
}