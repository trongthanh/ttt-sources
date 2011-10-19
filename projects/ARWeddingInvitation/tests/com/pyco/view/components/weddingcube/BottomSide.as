package com.pyco.view.components.weddingcube {
	import com.pyco.constant.CubeSideName;
	import com.pyco.view.components.YoutubePlayer;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.MovieMaterial;
	/**
	 * ...
	 * @author Thu.Hoang
	 */
	public class BottomSide extends BaseSide {
		[Embed(source = '/../assets/images/bottom_2.jpg')]
		public var BottomImage: Class;
		
		private var videoPlayer: YoutubePlayer = new YoutubePlayer();
		
		public function BottomSide(material: MaterialObject3D = null, width: Number = 0, height: Number = 0, segmentsW: Number = 0, segmentsH: Number = 0) {
			var bmp: Bitmap =  new BottomImage() as Bitmap;
			sideMaterial =  new BitmapMaterial(bmp.bitmapData);
			sideMaterial.interactive = true;
			sideMaterial.oneSide = false;
			
			super(sideMaterial, width, height, segmentsW, segmentsH);
			
			// Add video player to stage
			videoPlayer.x = 300;
			videoPlayer.y = 167;
			toggleVideoPlayer(false);
			WeddingInvitation.mainMovie.stage.addChild(videoPlayer);
			
			name = CubeSideName.BOTTOM;
		}
		
		override public function close(): void {
			toggleVideoPlayer(false);
			videoPlayer.reset();
			dispatchEvent(new Event(BaseSide.CLOSE_SIDE_COMPLETE));
		}
		
		override public function open(): void {
			toggleVideoPlayer(true);
			dispatchEvent(new Event(BaseSide.OPEN_SIDE_COMPLETE));
		}
		
		private function toggleVideoPlayer(value: Boolean): void {
			videoPlayer.visible = value;
			videoPlayer.mouseChildren = value;
			videoPlayer.mouseEnabled = value;
		}
		
	}

}