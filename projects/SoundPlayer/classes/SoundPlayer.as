/**
* A demonstration of common sound handling functions in AS3
* @author Trong Thanh
*/
package  {
	import flash.display.CapsStyle;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.media.ID3Info;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.text.TextField;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import SoundProgressBar;
	import SimpleSlider;
	
	public class SoundPlayer extends MovieClip {
		//stage
		public var songURL_tf: TextField;
		public var play_btn: SimpleButton;
		public var pause_btn: SimpleButton;
		public var stop_btn: SimpleButton;
		public var rw_btn: SimpleButton;
		public var ff_btn: SimpleButton;
		public var progressBar_mc: SoundProgressBar;
		public var bytesLoaded_tf: TextField;
		public var open_btn: SimpleButton;
		public var status_tf: TextField;
		public var volume_slider: SimpleSlider;
		public var pan_slider: SimpleSlider;
		public var panBothLeft_btn: SimpleButton;
		public var panBothRight_btn: SimpleButton;
		public var panNormal_btn: SimpleButton;
		public var ID3_tf: TextField;
		public var specSoundWave_btn: SimpleButton;
		public var specFrequency_btn: SimpleButton;
		
		//
		/** Sprite to draw the spectrum bars */
		private var specBars: Sprite;
		/** Sprite to draw volume bars */
		private var volBars: Sprite;
		/** store spectrum data */
		private var ba: ByteArray;
		private var s: Sound;
		private var isPlaying: Boolean;
		private var isPause: Boolean;
		private var isOpened: Boolean;
		/** a sound channel is needed to handdle stop, volume control... */
		private var channel: SoundChannel;
		/** a SoundTransform is needed to control the volume and panning of the SoundChannel or SoundMixer */
		private var st: SoundTransform;
		/** amount of milliseconds to rewind or fastforward */;
		private var moveStep: Number = 5000; 
		/** when the song is fully loaded, it becomes exact duration */
		private var estimatedDuration:Number;
		private var playTime: Number;
		private var isFrequency: Boolean;
		
		//testing
		protected var peakVal: Number = 0;
		
		
		public function SoundPlayer() {
			init();
		}
		
		private function init(): void {
			specBars = new Sprite();
			specBars.x = 20;
			specBars.y = 300;
			this.addChild(specBars);
			
			volBars = new Sprite();
			volBars.x = 20;
			volBars.y = 330;
			this.addChild(volBars);
			
			volume_slider.position = 1;
			volume_slider.addEventListener(SimpleSlider.SLIDER_VALUE_CHANGE, onVolumeChange);
			pan_slider.position = 0.5;
			pan_slider.addEventListener(SimpleSlider.SLIDER_VALUE_CHANGE, onPanChange);
			
			ba = new ByteArray();
			isPlaying = false;
			isOpened = false;
			isFrequency = true;
			
			st = new SoundTransform();
			pause_btn.visible = false;
			
			open_btn.addEventListener(MouseEvent.CLICK, onOpen);
			play_btn.addEventListener(MouseEvent.CLICK, onPlay);
			stop_btn.addEventListener(MouseEvent.CLICK, onStop);
			pause_btn.addEventListener(MouseEvent.CLICK, onPause);
			rw_btn.addEventListener(MouseEvent.CLICK, onRewind);
			ff_btn.addEventListener(MouseEvent.CLICK, onFastForward);
			panBothLeft_btn.addEventListener(MouseEvent.CLICK, onBothLeftRightPan);
			panBothRight_btn.addEventListener(MouseEvent.CLICK, onBothLeftRightPan);
			panNormal_btn.addEventListener(MouseEvent.CLICK, onBothLeftRightPan);
			specSoundWave_btn.addEventListener(MouseEvent.CLICK, onChangeSpectrumType);
			specFrequency_btn.addEventListener(MouseEvent.CLICK, onChangeSpectrumType);
			progressBar_mc.addEventListener(SoundProgressBar.PLAY_BAR_VALUE_SET, onProgressBarChange);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//default
			songURL_tf.text = "http://trongthanh.googlepages.com/song02.mp3";
		}
		
		private function onProgressBarChange(e: Event):void {
			channel.stop();
			playTime = progressBar_mc.playProgress * estimatedDuration;
			if (!isPause) {
				//continue playing, need to reassign
				channel = s.play(playTime);
				channel.soundTransform = st;
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);	
			}
		}
		
		private function onChangeSpectrumType(e:MouseEvent):void {
			if (e.target == specSoundWave_btn) {
				isFrequency = false;
			} else {
				isFrequency = true;
			}
		}
		
		private function onBothLeftRightPan(e:MouseEvent):void {
			if (e.target == panBothLeft_btn) {
				st.leftToLeft = 1;
				st.leftToRight = 1;
				st.rightToLeft = 0;
				st.rightToRight = 0;
			} else if (e.target == panBothRight_btn) {
				st.leftToLeft = 0;
				st.leftToRight = 0;
				st.rightToLeft = 1;
				st.rightToRight = 1;
			} else {
				st.leftToLeft = 1;
				st.leftToRight = 0;
				st.rightToLeft = 0;
				st.rightToRight = 1;
			}
			channel.soundTransform = st;
			//move the slider back to center
			pan_slider.position = 0.5;
		}
		
		private function onPanChange(e: Event):void {
			//pan vary from -1 (left) to 1 (right) so we need to convert from (0 - 1) scale
			var value: Number = pan_slider.position;
			value = (value - 0.5) / 0.5;
			st.pan = value;
			if (channel != null) channel.soundTransform = st;
			
		}
		
		private function onVolumeChange(e: Event):void {
			st.volume = volume_slider.position;
			if (channel != null) channel.soundTransform = st;
		}
		
		private function onEnterFrame(e:Event):void {
			if (isOpened) checkSoundStatus();
			if (isPlaying) processSpectrum();
		}
		
		private function onOpen(e: MouseEvent): void {
			trace("Open song");
			var url:String= songURL_tf.text;
			var request:URLRequest = new URLRequest(url);
			s = new Sound();
			s.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			s.addEventListener(Event.OPEN, startLoading);
			s.addEventListener(Event.ID3, id3Handler);
			//IMPORTANT: must turn on checkPolicyFile flag in the SoundLoaderContext for crossdomain ID3 and spectrum process
			s.load(request, new SoundLoaderContext(1000, true));
			
			if (isOpened) {
				isOpened = false;
				doStop();
			}
			
		}
		
		private function id3Handler(e:Event):void {
			ID3_tf.text = "";
			for (var name: String in s.id3) {
				ID3_tf.appendText(name + ": " + s.id3[name] + "\n");
			}
			
		}
		
		
		private function startLoading(e:Event):void {
			if (e.target == s) isOpened = true;
			
		}
		
		/**
		 * Check play and load status of current sound
		 */
		private function checkSoundStatus(): void {
			var s: Sound = this.s;
			var ch: SoundChannel = this.channel;
			
			var bytesLoaded: Number = s.bytesLoaded;
			var bytesTotal: Number = s.bytesTotal;
			var loadPercent: Number = bytesLoaded / bytesTotal;
			//length in millisecond of the loaded parts ONLY:
			var duration: Number = s.length;
			//estimate the full length of the song:
			estimatedDuration = duration * bytesTotal / bytesLoaded;
			if (loadPercent == 1) {
				bytesLoaded_tf.text = bytesTotal + "B";
			} else {
				bytesLoaded_tf.text = bytesLoaded + "B/" + bytesTotal + "B";
			}
			progressBar_mc.loadProgress = loadPercent;
			
			if (!isPlaying || isPause ) return; //avoid error
			playTime = ch.position;
			var playPercent: Number = playTime / estimatedDuration;
			if (playPercent >= 1) {
				trace("Stop");
				doStop();
			}
			//play time of the sound
			var mins:String = String(Math.floor(playTime/1000/60));
			var secs:String = String(Math.floor(playTime/1000)%60);
			if (secs.length < 2) {
				secs = "0" + secs;
			}
			
			//total time
			var totalMins:String = String(Math.floor(estimatedDuration/1000/60));
			var totalSecs:String = String(Math.floor(estimatedDuration/1000)%60);
			if (totalSecs.length < 2) {
				totalSecs = "0" + totalSecs;
			}
			
			status_tf.text = mins + ":" + secs + " / " + totalMins + ":" + totalSecs;
			progressBar_mc.playProgress = playPercent;
			
		}
		
		 
		
		private function onIOError(e:IOErrorEvent):void {
			if (e.target == s) bytesLoaded_tf.text = "Open Error";
		}
		 
		private function onPlay(e: MouseEvent): void {
			if (!isOpened) {
				bytesLoaded_tf.text = "Please open file";
				return;
			}
			if (isPlaying) {
				//continue playing, need to reassign
				channel = s.play(playTime);
				channel.soundTransform = st;
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);	
			} else {
				channel = s.play();
				channel.soundTransform = st;
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				isPlaying = true;
			}
			isPause = false;
			play_btn.visible = false;
			pause_btn.visible = true;

		}
		
		private function onFastForward(e:MouseEvent):void {
			if (!isOpened) {
				bytesLoaded_tf.text = "Please open file";
				return;
			}
			doFarstForward();
		}
		
		private function doFarstForward(): void {
			if ((playTime + moveStep) >= s.length) {
				playTime = s.length;
			} else {
				playTime = playTime + moveStep; 
			}
			channel.stop();
			if (isPause) {
				progressBar_mc.playProgress = playTime / estimatedDuration;
			} else {
				channel = s.play(playTime);	
				channel.soundTransform = st;
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
		}
		
		private function onRewind(e:MouseEvent):void {
			if (!isOpened) {
				bytesLoaded_tf.text = "Please open file";
				return;
			}
			doRewind();
		}
		
		private function doRewind(): void {
			if ((playTime - moveStep) <= 0) {
				playTime = 0
			} else {	
				playTime = playTime - moveStep;
			}
			channel.stop();
			if (isPause) {
				progressBar_mc.playProgress = playTime / estimatedDuration;
			} else {
				channel = s.play(playTime);			
				channel.soundTransform = st;
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
		}
		
		private function onPause(e:MouseEvent):void {
			doPause();
		}
		
		private function doPause(): void {
			playTime = channel.position;
			channel.stop();
			isPause = true;
			play_btn.visible = true;
			pause_btn.visible = false;
		}
		
		private function onStop(e:MouseEvent):void {
			if (!isOpened) {
				bytesLoaded_tf.text = "Please open file";
				return;
			}
			doStop();
		}
		
		private function doStop():void{
			channel.stop();
			isPlaying = false;
			play_btn.visible = true;
			pause_btn.visible = false;
			progressBar_mc.resetPlayBar();
			specBars.graphics.clear();
			volBars.graphics.clear();
		}
		
		
		private function soundCompleteHandler(e: Event):void {
			doStop();
		}
		
		private function processSpectrum() {
			SoundMixer.computeSpectrum(ba, isFrequency);
			var val : Number;
			var lVal: Number = 0;
			var rVal: Number = 0;
			
			specBars.graphics.clear();
			volBars.graphics.clear();
			
			
			for (var i: int = 0; i < 512; i ++) {
				val = ba.readFloat();
				drawSpecBar(i, val);
				
				if (i < 256) {
					lVal += val;
					/* testing
					if (peakVal < val) {
						peakVal = val;
					}
					*/
				} else {
					rVal += val;
				}
				
			}
			if (isFrequency) {
				drawVolumeBar(1, lVal);
				drawVolumeBar(2, rVal);
			}
			//testing only
			//songURL_tf.text = String(peakVal);
		}
		
		/**
		 * 
		 * @param	pos		position of the spectrum value within 0-512
		 * @param	specVal	spectrum value (-1 -> 1)
		 */
		private function drawSpecBar(pos: int, specVal: Number): void {
			//convert -1 < specVal < 1 to pixel height:
			var h: Number = - 100 * specVal;
			var c: Number = ((0xFF * ((pos%256) / 256)) << 16) | (0xFF << 8 );
			specBars.graphics.lineStyle(1,c,1);
			specBars.graphics.moveTo(pos, 0);
			specBars.graphics.lineTo(pos, h);
		}
		
		private function drawVolumeBar(pos: int, specSum: Number): void {
			var w: Number = 5 * specSum;
			volBars.graphics.lineStyle(10, 0x00FF00, 1, false, "normal", CapsStyle.NONE);
			volBars.graphics.moveTo(0, pos * 15);
			volBars.graphics.lineTo(w, pos * 15);
		}
		
	}
	
}