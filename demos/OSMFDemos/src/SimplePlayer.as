package {
	import flash.display.Sprite;
	import flash.events.Event;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.URLResource;
	import org.osmf.utils.Version;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class SimplePlayer extends Sprite {
		
		public var playerSprite: MediaPlayerSprite;
		
		public function SimplePlayer():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace("OSMF " + Version.version);
			
			//trace(this.width, this.height);
			
			playerSprite = new MediaPlayerSprite();
			/*
			playerSprite.resource = new URLResource(STREAMING_MP4_PATH);
			/*/
			var resource:URLResource = new URLResource( Resources.STREAMING_MP4_PATH );
			playerSprite.media = new VideoElement( resource );
			//*/
			
			addChild(playerSprite);
		}
	}
}