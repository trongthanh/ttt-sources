package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.utils.Version;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class ContainerAndPlayer extends Sprite {
		
		public var container: MediaContainer;
		public var mediaPlayer: MediaPlayer;
		
		public function ContainerAndPlayer() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace("OSMF " + Version.version);
			
			var resource: URLResource = new URLResource(Resources.STREAMING_PATH);
			var loader: NetLoader = new NetLoader();
			var element: VideoElement = new VideoElement(resource, loader);
			
			mediaPlayer = new MediaPlayer(element);
			container = new MediaContainer();
			container.addMediaElement(element);
			
			addChild(container);
			
		}
		
	}

}