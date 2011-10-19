package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import org.osmf.containers.MediaContainer;
	import org.osmf.display.ScaleMode;
	import org.osmf.elements.ImageElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.layout.LayoutMetadata;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.Version;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class ImageOverlay extends Sprite {
		
		public var container: MediaContainer;
		public var mediaPlayer: MediaPlayer;
		public var mediaFactory: DefaultMediaFactory;
		
		public function ImageOverlay() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace("OSMF " + Version.version);
			/*
			var resource: URLResource = new URLResource(LOCAL_SWF);
			/*/
			var resource: URLResource = new URLResource(STREAMING_MP4_PATH);
			//*/
			mediaFactory = new DefaultMediaFactory();
			
			var loader: NetLoader = new NetLoader();
			var element: MediaElement = mediaFactory.createMediaElement(resource);
			
			mediaPlayer = new MediaPlayer(element);
			container = new MediaContainer();
			container.addMediaElement(element);
			
			addChild(container);
			
			var imgURLResource: URLResource = new URLResource(IMAGE_PATH);
			var imageElement: ImageElement = new ImageElement(imgURLResource);
			var layoutData: LayoutMetadata = new LayoutMetadata();
			layoutData.right = 10;
			layoutData.bottom = 10;
			layoutData.scaleMode = ScaleMode.LETTERBOX;
			layoutData.width = 50;
			layoutData.height = 50;
			imageElement.metadata.addValue(LayoutMetadata.LAYOUT_NAMESPACE, layoutData);
			
			var imgLoadTrait: LoadTrait = imageElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
			imgLoadTrait.load();
			
			container.addMediaElement(imageElement);
		}
		
	}

}