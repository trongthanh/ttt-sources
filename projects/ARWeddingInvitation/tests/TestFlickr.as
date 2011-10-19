package  {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(width="800", height="600", frameRate="30", backgroundColor="#000000")]
	public class TestFlickr extends Sprite {
		public var loader: Loader;
		
		public function TestFlickr() {
			graphics.beginFill(0xCCCCCC, 1);
			graphics.drawRect(0, 0, 800, 600);
			graphics.endFill();
			
			var urlRequest: URLRequest = new URLRequest('simpleviewer.swf?galleryURL=http://localhost/arinvitation/xml/gallery.xml');
			
			var loaderContext: LoaderContext = new LoaderContext(true, new ApplicationDomain(ApplicationDomain.currentDomain));
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(Event.INIT, contentInitHandler);
			loader.load(urlRequest,loaderContext);
			addChild(loader);
			
		}
		
		private function contentInitHandler(e:Event):void {
			trace("content init");
		}
		
		private function loadCompleteHandler(e:Event):void {
			trace("load complete");
		}
		
	}

}

/*
<object width="400" height="300"> <param name="flashvars" value="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F9803330%40N04%2Fshow%2F&page_show_back_url=%2Fphotos%2F9803330%40N04%2F&user_id=9803330@N04&jump_to="></param> <param name="movie" value="http://www.flickr.com/apps/slideshow/show.swf?v=71649"></param> <param name="allowFullScreen" value="true"></param><embed type="application/x-shockwave-flash" src="http://www.flickr.com/apps/slideshow/show.swf?v=71649" allowFullScreen="true" flashvars="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F9803330%40N04%2Fshow%2F&page_show_back_url=%2Fphotos%2F9803330%40N04%2F&user_id=9803330@N04&jump_to=" width="400" height="300"></embed></object>

http://www.flickr.com/apps/slideshow/show.swf?v=71649&offsite=true&lang=en-us&page_show_url=%2Fphotos%2F9803330%40N04%2Fshow%2F&page_show_back_url=%2Fphotos%2F9803330%40N04%2F&user_id=9803330@N04



<object width="400" height="300"> <param name="flashvars" value="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F9803330%40N04%2Fsets%2F72157600700625751%2Fshow%2F&page_show_back_url=%2Fphotos%2F9803330%40N04%2Fsets%2F72157600700625751%2F&set_id=72157600700625751&jump_to="></param> <param name="movie" value="http://www.flickr.com/apps/slideshow/show.swf?v=71649"></param> <param name="allowFullScreen" value="true"></param><embed type="application/x-shockwave-flash" src="http://www.flickr.com/apps/slideshow/show.swf?v=71649" allowFullScreen="true" flashvars="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F9803330%40N04%2Fsets%2F72157600700625751%2Fshow%2F&page_show_back_url=%2Fphotos%2F9803330%40N04%2Fsets%2F72157600700625751%2F&set_id=72157600700625751&jump_to=" width="400" height="300"></embed></object>

http://www.flickr.com/apps/slideshow/show.swf?v=71649&offsite=true&lang=en-us&page_show_url=%2Fphotos%2F9803330%40N04%2Fsets%2F72157600700625751%2Fshow%2F&page_show_back_url=%2Fphotos%2F9803330%40N04%2Fsets%2F72157600700625751%2F&set_id=72157600700625751
*/