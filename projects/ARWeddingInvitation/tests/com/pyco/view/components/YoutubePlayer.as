package com.pyco.view.components {
	import com.pyco.utils.StringUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author chinh.nguyen
	 */
	public class YoutubePlayer extends MovieClip{
		private var loader							: Loader;
		private var player							: Object;
		private var youtubeApiLoader				: URLLoader;
		private var isQualityPopulated				: Boolean;
		private var isWidescreen					: Boolean;
		private var playButton						: SimpleButton;
		private var cueButton						: SimpleButton;
		private var pauseButton						: SimpleButton;
		private var controlbarUI					: ControlBarUI;
		private var _isPause						: Boolean = false;
		//private var parentScope					: DisplayObjectContainer;
		private var isLive							: Boolean = false;
		private var soundW							: Number;
		private var durationW						: Number;
		private var isDragVolume					: Boolean = false;	
		private var isDragSeekBar					: Boolean = false;	
		private var oldeVolumeValue					: Number = 50;
		private var isMute							: Boolean = false;
		private var isFirstPlaying					: Boolean = true;
	
	
		private var dragTimeOut						: uint;
		private var totalTime						: Number;
		
		private static const VIDEO_ID				: String = "-28l7sLr3rs"; // 0QRO3gKj3qw
		private static const YOUTUBE_API_PREFIX		: String = "http://gdata.youtube.com/feeds/api/videos/";
		private static const YOUTUBE_API_VERSION	: String = "2";
		private static const YOUTUBE_API_FORMAT		: String = "5";
		private static const WIDESCREEN_ASPECT_RATIO: String = "widescreen";
		private static const HEIGHT_CONTROLBAR		: Number = 22.55;
		private static const WIDTH_PLAYER			: Number = 426;
		private static const HEIGHT_PLAYER			: Number = 442;
		
		public function YoutubePlayer() {
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this communication.
			Security.allowDomain("www.youtube.com");
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.align = StageAlign.TOP_LEFT;
			initPlayer(); 
			initYouTubeApiLoader();
			initValues();
			initEvents();
		}
		
		private function resetValues(): void {
			_isPause = false;
			isDragVolume = false;	
			isDragSeekBar = false;	
			isFirstPlaying = true;
			controlbarUI.visible = false;
			isLive = true;
			controlbarUI.pauseBtn.visible = false;
			controlbarUI.toolTipMovie.visible = false;
			controlbarUI.progressBarMovie.loadedMovie.width = 0;
			//setVolume(oldeVolumeValue);
		}
		
		private function initValues():void {
			//add controlbar
			controlbarUI = new ControlBarUI();
			addChild(controlbarUI);
			
			//displayFullScreen(false);
			//parentScope = this.parent;
			//controlbarUI.endFullscreenBtn.visible = false;
			
			soundW = controlbarUI.volumeBarMovie.bgMovie.width - controlbarUI.volumeBarMovie.iconControlBtn.width;
			durationW = controlbarUI.progressBarMovie.bgMovie.width - controlbarUI.progressBarMovie.seekBarMovie.width;
			
			resetValues();
		}
		
		private function visibleProgressbar():void {
			controlbarUI.volumeBarMovie.alpha = 0;
			controlbarUI.progressBarMovie.alpha = 0;
			controlbarUI.timeBarMovie.alpha = 0;
			controlbarUI.soundIconBtn.alpha = 0;
			controlbarUI.toolTipMovie.alpha = 0;
		}
		
		private function initEvents():void {
			//-----play pause video
			controlbarUI.playBtn.addEventListener(MouseEvent.CLICK, pausePlayVideoHandler);
			controlbarUI.pauseBtn.addEventListener(MouseEvent.CLICK, pausePlayVideoHandler);
			//-----fullscreen handler
			//controlbarUI.fullScreenBtn.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			//controlbarUI.fullScreenBtn.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			//controlbarUI.fullScreenBtn.addEventListener(MouseEvent.CLICK, fullScreenBtnClickHandler);			
			//controlbarUI.endFullscreenBtn.addEventListener(MouseEvent.CLICK, endFullSrceenClickHandler);	
			//this.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenHandler);	
			//----volume handler
			controlbarUI.volumeBarMovie.iconControlBtn.addEventListener(MouseEvent.MOUSE_DOWN, iconControlVolumeMouseDown);
			controlbarUI.volumeBarMovie.iconControlBtn.addEventListener(MouseEvent.MOUSE_UP, stopDragVolume);
			controlbarUI.volumeBarMovie.addEventListener(MouseEvent.ROLL_OVER, volumeBarRollOverHandler);
			controlbarUI.volumeBarMovie.addEventListener(MouseEvent.MOUSE_OUT, visibleToolTipOfTime);
			controlbarUI.volumeBarMovie.addEventListener(MouseEvent.MOUSE_MOVE, volumeBarRollOverHandler);
			controlbarUI.volumeBarMovie.addEventListener(MouseEvent.CLICK, volumeBarClickHandler);
			controlbarUI.soundIconBtn.addEventListener(MouseEvent.CLICK, soundIconClickHandler);
			
			//----progress bar handler
			controlbarUI.progressBarMovie.addEventListener(MouseEvent.ROLL_OVER, controlBarMovieRollOverHandler);
			controlbarUI.progressBarMovie.addEventListener(MouseEvent.ROLL_OUT, visibleToolTipOfDur);
			controlbarUI.progressBarMovie.addEventListener(MouseEvent.MOUSE_MOVE, controlBarMovieRollOverHandler);
			controlbarUI.progressBarMovie.addEventListener(MouseEvent.CLICK, progressBarClickHandler);
			controlbarUI.progressBarMovie.seekBarMovie.addEventListener(MouseEvent.MOUSE_DOWN, seekBarMouseDownHandler);
			controlbarUI.progressBarMovie.seekBarMovie.addEventListener(MouseEvent.MOUSE_UP, stopDragSeekBar);
			controlbarUI.progressBarMovie.seekBarMovie.addEventListener(MouseEvent.MOUSE_UP, stopDragSeekBar);
			controlbarUI.progressBarMovie.buttonMode = true;

			
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}
		
		private function stopDragSeekBar(event: MouseEvent): void {

			if (isDragSeekBar) {
				controlbarUI.progressBarMovie.seekBarMovie.stopDrag();
				//durationW = controlbarUI.progressBarMovie.bgMovie.width - controlbarUI.progressBarMovie.seekBarMovie.width;
				//var v: Number = (controlbarUI.progressBarMovie.seekBarMovie.x) / durationW;
				var v: Number = getDurarionAtMousePos();
				seekVideo(v, true);
				dragTimeOut = setTimeout(updateDragStatus, 500);
			}
			
		}
		
		private function updateDragStatus(): void {
			clearTimeout(dragTimeOut);
			isDragSeekBar = false;
		}
		
		private function seekBarMouseDownHandler(event: MouseEvent): void {
			clearTimeout(dragTimeOut);
			isDragSeekBar = true;
			var target: Sprite = event.currentTarget as Sprite;
			var bound: Rectangle = new Rectangle(0, 0, controlbarUI.progressBarMovie.bgMovie.width - target.width, 0);
			target.startDrag(false, bound);
		}
		
		private function progressBarClickHandler(event: MouseEvent): void {
			var target: MovieClip = event.currentTarget as MovieClip;
			if(target == controlbarUI.progressBarMovie){
				var v: Number = getDurarionAtMousePos();
				if (isNaN(v)) return;
				seekVideo(v, true);		
			}
		}
		
		private function visibleToolTipOfDur(event: MouseEvent): void {
			if (!controlbarUI.progressBarMovie.hitTestPoint(stage.mouseX, stage.mouseY,true)) {
				controlbarUI.toolTipMovie.visible = false;
			}
		}
		
		private function handleCurTime():void {
			var curTime: Number = getPlayHeadTime();
			if (isNaN(curTime)) curTime = 0;
			totalTime = getTotalTime();
			controlbarUI.timeBarMovie.currentTimeText.text = StringUtil.convertSecondsToMinutes(curTime) ;
			controlbarUI.timeBarMovie.totalTimeText.text =  StringUtil.convertSecondsToMinutes(totalTime);
		}
		
		private function clearTime(): void {
			_isPause = false;
			controlbarUI.timeBarMovie.currentTimeText.text = StringUtil.convertSecondsToMinutes(0) ;
			controlbarUI.timeBarMovie.totalTimeText.text =  StringUtil.convertSecondsToMinutes(0);
		}
		
		private function volumeBarClickHandler(event: MouseEvent): void {
			var target: MovieClip = event.currentTarget as MovieClip;
			if(target == controlbarUI.volumeBarMovie){
				var v: Number = getVolumeAtMousePos();
				oldeVolumeValue = v;
				if (!isMute) setVolume(v);
				if (!isDragVolume) {
					var newX: Number = v * (soundW);
					if(newX != controlbarUI.volumeBarMovie.iconControlBtn.x){
						controlbarUI.volumeBarMovie.iconControlBtn.x = newX/ 100;
					}
				}
			}
		}
		
		private function controlBarMovieRollOverHandler(event: MouseEvent): void {
			var target: MovieClip = event.currentTarget as MovieClip;
			if (target == controlbarUI.progressBarMovie) {
				controlbarUI.toolTipMovie.visible = true;
				var v: Number = getDurarionAtMousePos();
				if (isNaN(v)) {
					v = 0;
				}
				controlbarUI.toolTipMovie.labelText.text = StringUtil.convertSecondsToMinutes(v);
				
				var p: Point = new Point(target.mouseX, target.mouseY);
				p = controlbarUI.progressBarMovie.localToGlobal(p);
				p = controlbarUI.globalToLocal(p);
				controlbarUI.toolTipMovie.x = p.x;
			}
		}
		
		private function visibleToolTipOfTime(event: MouseEvent): void {
			if (!controlbarUI.volumeBarMovie.hitTestPoint(stage.mouseX, stage.mouseY,true)) {
				controlbarUI.toolTipMovie.visible = false;
			}
		}
		
		private function getDurarionAtMousePos():Number {
			var v: Number = controlbarUI.progressBarMovie.mouseX - 4;
			if (v < 0) {
				v = 0;
			}
			v = Math.round((v / durationW) * totalTime);
			if (v > totalTime && !isNaN(totalTime)) {
				v = totalTime;
			}
			return v;
		}
		
		private function getVolumeAtMousePos():Number {
			var v: Number = controlbarUI.volumeBarMovie.mouseX - 4;
				
			if (v < 0) {
				v = 0;
			}
			v = Math.round((v / soundW) * 100);
			if (v > 100) {
				v = 100;
			}
			return v;
		}
		
		private function volumeBarRollOverHandler(event: MouseEvent): void {
			var target: MovieClip = controlbarUI.volumeBarMovie;
			controlbarUI.toolTipMovie.visible = true;
			var v: Number = getVolumeAtMousePos();
			controlbarUI.toolTipMovie.labelText.text = v;
			var p: Point = new Point(target.mouseX, target.mouseY);
			p = controlbarUI.volumeBarMovie.localToGlobal(p);
			p = controlbarUI.globalToLocal(p);
			controlbarUI.toolTipMovie.x = p.x;
		}
		
		private function soundIconClickHandler(event: MouseEvent): void {
			var target: MovieClip = event.currentTarget as MovieClip;
			if (isMute) {
				setVolume(oldeVolumeValue );
				target.gotoAndStop("s1");
			} else {
				oldeVolumeValue = getVolume();
				setVolume(0);
				target.gotoAndStop("s2");
			}
			isMute = !isMute;
		}
		
		private function enterFrameHandler(event: Event): void {
			var v: Number = (controlbarUI.volumeBarMovie.iconControlBtn.x) / soundW;
			oldeVolumeValue = v;
			if (!isMute) {
				setVolume(v*100);
			}
			seekTo(getPlayHeadTime());
			controlbarUI.timeBarMovie.currentTimeText.text = StringUtil.convertSecondsToMinutes(getPlayHeadTime()) ;
			byteLoaded(getVideoBytesLoaded());
		}
		
		private function byteLoaded(value: Number): void {
			if (isNaN(value)) return;
			var percent: Number = (value / getTotalBytes());
			var newW: Number = controlbarUI.progressBarMovie.bgMovie.width * percent;
			var seekPos: Number = controlbarUI.progressBarMovie.seekBarMovie.x - controlbarUI.progressBarMovie.loadedMovie.x;
			if(newW != controlbarUI.progressBarMovie.loadedMovie.width){
				controlbarUI.progressBarMovie.loadedMovie.width = newW;
			}
		}
		
		private function stageMouseUpHandler(event: MouseEvent): void {
			stopDragVolume(null);
			stopDragSeekBar(null);
		}
		
		private function stopDragVolume(e:MouseEvent): void {
			isDragVolume = false;
			controlbarUI.volumeBarMovie.iconControlBtn.stopDrag();
		}
		
		private function setVolume(value: Number): void {
			trace( "setVolume : " + value );
			//if (!isMute) {
				
				//var volume: Number = getVolume();
				//trace( "volume : " + volume );
				//if( volume != value){
					if (player) {
						player.setVolume(value);
					}
				//}
			//}
		}
		
		private function iconControlVolumeMouseDown(event: MouseEvent): void {
			isDragVolume = true;
			var target: Sprite = event.currentTarget as Sprite;
			var bound: Rectangle = new Rectangle(0, 0, controlbarUI.volumeBarMovie.bgMovie.width - target.width, 0);
			target.startDrag(false, bound);
		}
		
		private function rollOutHandler(event: MouseEvent): void {
			var target: MovieClip = event.currentTarget as MovieClip;
			target.gotoAndPlay("s2");
		}
		
		private function rollOverHandler(event: MouseEvent): void {
			var target: MovieClip = event.currentTarget as MovieClip;
			target.gotoAndPlay("s1");
		}
		
		/*private function fullScreenHandler(e:FullScreenEvent):void {
			displayFullScreen(e.fullScreen);
		}
		
		private function endFullSrceenClickHandler(e:MouseEvent):void {
			displayFullScreen(false);
		}
		
		private function fullScreenBtnClickHandler(e:MouseEvent):void {
			displayFullScreen(true);
		}*/
		
		private function pausePlayVideoHandler(event: MouseEvent): void {
			switch(event.currentTarget) {
				case controlbarUI.pauseBtn:
					player.pauseVideo();
					this.isPause = true;
				break;
				case controlbarUI.playBtn:
					player.playVideo();
					this.isPause = false;
			}
			visiblePlayButton(this._isPause);
		}
		
		private function visiblePlayButton(value: Boolean):void{
			controlbarUI.pauseBtn.visible = !value;
			controlbarUI.playBtn.visible = value;
		}
		
		private function initYouTubeApiLoader():void{
			youtubeApiLoader = new URLLoader();
			var request: URLRequest = new URLRequest(YOUTUBE_API_PREFIX + VIDEO_ID);

			youtubeApiLoader.addEventListener(IOErrorEvent.IO_ERROR, youtubeApiLoaderErrorHandler, false, 0, true);
			youtubeApiLoader.addEventListener(Event.COMPLETE, youtubeApiLoaderCompleteHandler, false, 0, true);
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.v = YOUTUBE_API_VERSION;
			urlVariables.format = YOUTUBE_API_FORMAT;
			request.data = urlVariables;

			try {
				youtubeApiLoader.load(request);
			} catch (error:SecurityError) {
				trace("A SecurityError occurred while loading", request.url);
			}
		}
		
		private function youtubeApiLoaderErrorHandler(e:IOErrorEvent):void {
			
		}
		
		private function youtubeApiLoaderCompleteHandler(e:Event):void {
			var atomData:String = youtubeApiLoader.data;
			  // Parse the YouTube API XML response and get the value of the
			  // aspectRatio element.
			  var atomXml:XML = new XML(atomData);
			  var aspectRatios:XMLList = atomXml..*::aspectRatio;

			  isWidescreen = aspectRatios.toString() == WIDESCREEN_ASPECT_RATIO;
			  isQualityPopulated = false;
		}
		
		private function initPlayer():void { 
			// This will hold the API player instance once it is initialized.
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit, false, 0, true);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}
		
		private function onLoaderInit(event:Event):void {
			addChildAt(loader, 0);
			loader.content.addEventListener("onReady", onPlayerReady, false, 0, true);
			loader.content.addEventListener("onError", onPlayerError, false, 0, true);
			loader.content.addEventListener("onStateChange", onPlayerStateChange, false, 0, true);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange, false, 0, true);
		}
 
		private function onPlayerReady(event:Event):void {
			// Event.data contains the event parameter, which is the Player API ID 
			trace("player ready:", Object(event).data);
		 
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			player = loader.content;
			setVolume(oldeVolumeValue);
			// Set appropriate player dimensions for your application
			player.setSize(WIDTH_PLAYER, HEIGHT_PLAYER);
			// play video by id
			player.cueVideoById(VIDEO_ID);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			// show controlbar
			controlbarUI.visible = true;
			controlbarUI.x = player.x;
			controlbarUI.y = player.y + player.height - HEIGHT_CONTROLBAR;
			//this.setChildIndex(controlbarUI, this.numChildren -1);
			visiblePlayButton(true);
		 }
		 
		 private function seekTo(value: Number): void {
			if (isNaN(value)) return;
			durationW = controlbarUI.progressBarMovie.bgMovie.width - controlbarUI.progressBarMovie.seekBarMovie.width;
			if (!isDragSeekBar) {
				var newX: Number = (value / totalTime) * (durationW);
				if(newX != controlbarUI.progressBarMovie.seekBarMovie.x){
					controlbarUI.progressBarMovie.seekBarMovie.x = newX;
				}
			}
			var newW: Number = controlbarUI.progressBarMovie.seekBarMovie.x + controlbarUI.progressBarMovie.seekBarMovie.width;
			if(newW != controlbarUI.progressBarMovie.maskMovie.width){
				controlbarUI.progressBarMovie.maskMovie.width = newW;
			}
		}

		private  function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}
 
		private function onPlayerStateChange(event:Event):void {
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(event).data);
			// unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5)
			trace("player state:", Object(event).data);
			if (isFirstPlaying && Object(event).data == 1) {
				isFirstPlaying = false;
				// Change the status of play/pause button
				_isPause = false;
				visiblePlayButton(_isPause);
			}
			handleCurTime();
			
		}
 
		private  function onVideoPlaybackQualityChange(event:Event):void {
			 // Event.data contains the event parameter, which is the new video quality
			 trace("video quality:", Object(event).data);
		}
		
		/*private function displayFullScreen(isFullScreen: Boolean): void {
			try {
				stage.displayState = isFullScreen?StageDisplayState.FULL_SCREEN:StageDisplayState.NORMAL;
				controlbarUI.fullScreenBtn.visible = !isFullScreen;
				controlbarUI.endFullscreenBtn.visible = isFullScreen;
				controlbarUI.x = isFullScreen? 0:0;
				
				if (isFullScreen) {
					this.stage.addChild(this);		
					setPlayerSize(this.stage.stageWidth, this.stage.stageHeight,true);
				}
				else {
					if (parentScope) {
						parentScope.addChild(this);
						this.setChildIndex(controlbarUI, this.numChildren - 1);
					}
					setPlayerSize(WIDTH_PLAYER, HEIGHT_PLAYER,false);
				}
			}
			catch (err:Error){
				
			}
		}*/
		
		public function get isPause():Boolean { return _isPause; }
		
		public function set isPause(value:Boolean):void {
			_isPause = value;
		}
		
		public function playVideo(): void {
			if (player) {
				player.playVideo();
			}
		}
		
		public function resumeVideo(): void {
			if (player) player.resume();
		}
		
		public function pauseVideo(value: Boolean = true):void {
			if (player) {
				player.pauseVideo();
			}
		}
		
		public function seekVideo(value: Number,allowSeekAhead: Boolean):void {
			if (player) {
				player.seekTo(value, allowSeekAhead);
				if (isNaN(value)) return;
				durationW = controlbarUI.progressBarMovie.bgMovie.width - controlbarUI.progressBarMovie.seekBarMovie.width;
				if (!isDragSeekBar) {
					var newX: Number = (value / totalTime) * (durationW);
					if(newX != controlbarUI.progressBarMovie.seekBarMovie.x){
						controlbarUI.progressBarMovie.seekBarMovie.x = newX;
					}
				}
				var newW: Number = controlbarUI.progressBarMovie.seekBarMovie.x + controlbarUI.progressBarMovie.seekBarMovie.width;
				if(newW != controlbarUI.progressBarMovie.maskMovie.width){
					controlbarUI.progressBarMovie.maskMovie.width = newW;
				}
			}
		}
		
		public function getTotalTime():Number {
			var time: Number = 0;
			if (player) {
				time = player.getDuration();
			}
			return time;
		}
		
		public function getPlayHeadTime(): Number {
			var time: Number = 0;
			if (player) {
				time = player.getCurrentTime();
			}
			return time;
		}
		
		public function getTotalBytes():Number {
			var time: Number = 0;
			if (player) {
				time = player.getVideoBytesTotal();
			}
			return time;
			
		}
		
		public function getVideoBytesLoaded():Number {
			var time: Number = 0;
			if (player) {
				time = player.getVideoBytesLoaded();
			}
			return time;
		}
		
		public function mute(value: Boolean = false):void {
			if (player) {
				if (value ) {
					player.mute();
				}else {
					player.unMute();
				}
			}
			
		}
		
		public function isMuted():Boolean {
			var value: Boolean = player.isMuted();
			return value;
		}
		
		public function getVolume(): Number {
			var value: Number = 0;
			if (player) {
				value = player.getVolume();
			}
			return value;
		}
		
		public function setPlayerSize(w: Number, h: Number, isFullScreen: Boolean):void {
			var space: Number = 7;
			controlbarUI.bgMovie.width = w;
			controlbarUI.y = h - controlbarUI.bgMovie.height;
			controlbarUI.endFullscreenBtn.x = w - space -controlbarUI.endFullscreenBtn.width;
			controlbarUI.volumeBarMovie.x = controlbarUI.endFullscreenBtn.x - space - controlbarUI.volumeBarMovie.width;
			controlbarUI.soundIconBtn.x = controlbarUI.volumeBarMovie.x - space - controlbarUI.soundIconBtn.width;
			controlbarUI.timeBarMovie.x = controlbarUI.soundIconBtn.x - space - controlbarUI.timeBarMovie.width;
			controlbarUI.progressBarMovie.bgMovie.width = w - 225;
			controlbarUI.progressBarMovie.maskMovie.width = controlbarUI.progressBarMovie.bgMovie.width;
			controlbarUI.progressBarMovie.durationMovie.width = controlbarUI.progressBarMovie.bgMovie.width;
			//set size for player
			player.setSize(w, h);
		}
		
		public function reset(): void {
			//seekVideo(0, true);
			//_isPause = true;
			//pauseVideo();
			//visiblePlayButton(_isPause);
			if (getChildByName(loader.name)) removeChild(loader);
			if (hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			pauseVideo();
			player = null;
			youtubeApiLoader = null;
			initPlayer(); 
			initYouTubeApiLoader();
			resetValues();
			
		}
		
	}
}