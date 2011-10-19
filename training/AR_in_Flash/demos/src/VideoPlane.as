/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
package {
	import examples.PV3DARApp;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.VideoStreamMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.primitives.Plane;

	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * @author Thanh Tran
	 */
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	public class VideoPlane extends PV3DARApp {
		public static const FOLLOW_CAMERA: Boolean = false;
		
		private var _videoURL: String = "videos/girl_dancing_2.flv";
		private var _videoW: int = 312;
		private var _videoH: int = 234;
		private var _videoPlane: Plane;
		private var _markerPlane: Plane;
		private var _stream:NetStream;
		
		public function VideoPlane() {
			addEventListener(Event.INIT, _onInit);
			init('data/camera_para.dat', 'data/flarlogo.pat');
		}
		
		private function _onInit(e:Event):void {
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe.
			_markerPlane = new Plane(wmat, 80, 80); // 80mm x 80mm。
			_markerPlane.rotationX = 180;
			_markerNode.addChild(_markerPlane); // attach to _markerNode to follow the marker.
			
			
			//Set up a video to handle the FLV
			var videoFile:Video = new Video(_videoW, _videoH);
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			
			//Set up a video to handle the netStream connection
			_stream = new NetStream(nc);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_stream.client = this;
			videoFile.attachNetStream(_stream);
			_stream.play(_videoURL);
			
			//Instantiate the VideoStreamMaterial
			//VideoStreamMaterial = (video object, netStream connection, precise, transparent)
			var videoMat: VideoStreamMaterial = new VideoStreamMaterial(videoFile, _stream, true, true);
			videoMat.smooth = true;
			videoMat.doubleSided = true;
			
			_videoPlane = new Plane(videoMat, 160, 160, 1, 1);
			_videoPlane.rotationX = 90;
			if (FOLLOW_CAMERA) {
				_scene.addChild(_videoPlane);
			} else {
				_videoPlane.z = 60;
				_markerNode.addChild(_videoPlane);
			}
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void {
			if(FOLLOW_CAMERA) {
				_videoPlane.x = _markerNode.x;
				_videoPlane.y = _markerNode.y + 40;
				_videoPlane.z = _markerNode.z;
				_videoPlane.lookAt(_camera3d, new Number3D(0,1,0));
			}
		}

		private function netStatusHandler(event : NetStatusEvent) : void {
			//trace(event.info.code);
			switch(event.info.code){
				case "NetStream.Play.Stop":
					_stream.seek(0);
					_stream.play(_videoURL);
					break;
				default:
			}
			
		}

		//This function is called when metaData is dispatched
		public function onMetaData(infoObject:Object):void {
			trace(infoObject);
		}
		
		public function onXMPData(info: Object): void {
			trace(info); 
		}
	}
}
