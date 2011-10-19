package {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.VideoStreamMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.primitives.Plane;

	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	
	public class VideoPlane extends PV3DARApp {
		public static const FOLLOW_CAMERA: Boolean = false;
		
		private var _videoURL: String = "Data/home.flv";
		private var _videoW: int = 500;
		private var _videoH: int = 650;
		private var _videoPlane: Plane;
		private var _plane: Plane;
		private var _stream:NetStream;
		
		public function VideoPlane() {
			addEventListener(Event.INIT, _onInit);
			_markerResolution = 4;
			
			init('Data/camera_para.dat', 'Data/L.pat');
		}
		
		private function _onInit(e:Event):void {
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ワイヤーフレームで。
			_plane = new Plane(wmat, 80, 80); // 80mm x 80mm。
			_plane.rotationX = 180;
			_markerNode.addChild(_plane); // attach to _markerNode to follow the marker. / _markerNode に addChild するとマーカーに追従する。
			
			
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
			//VideoStreamMaterial = (video object, netStream connection, precise)
			var video: VideoStreamMaterial = new VideoStreamMaterial(videoFile, _stream,true, true);
			//To add a little clairity to the video (which is on a sphere) I set up the video to tile on the UV
			//video.tiled = true; 
			//video.maxU = 3; 
			//video.maxV = 3;
			//Apply the VideoStreamMaterial to your object
			video.smooth = true;
			video.doubleSided = true;
			
			_videoPlane = new Plane(video, 60, 80, 1, 1);
			//_videoPlane.lookAt(_camera3d);
			//_videoPlane.scale = 0.15;
			_videoPlane.rotationX = 90;
			if (FOLLOW_CAMERA) {
				_scene.addChild(_videoPlane);
			} else {
				_videoPlane.z = 40;
				_markerNode.addChild(_videoPlane);
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

		override protected function onEnterFrame(e : Event = null) : void {
			super.onEnterFrame(e);
			if(FOLLOW_CAMERA) {
				_videoPlane.x = _markerNode.x;
				_videoPlane.y = _markerNode.y + 40;
				_videoPlane.z = _markerNode.z;
				_videoPlane.lookAt(_camera3d, new Number3D(0,1,0));
			}
		}
	}
}
