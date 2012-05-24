/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.thanhtran.tet2010.controller {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * Simple Audio Player
	 * @author Thanh Tran
	 */
	public class SimpleAudioPlayer extends EventDispatcher {
		public var sound: Sound;
		public var channel: SoundChannel;
		private var st: SoundTransform;
		
		private var time: Number = 0;
		private var _volume: Number;
		
		public function SimpleAudioPlayer(sound: Sound) {
			this.sound = sound;
			st = new SoundTransform();
			_volume = st.volume;
			
		}
		
		public function play(): void {
			if (sound) {
				channel = sound.play(time, 1000);
				channel.soundTransform = st;
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
				
			}
			
		}
		
		public function pause(): void {
			time = channel.position;
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		
		public function stop(): void {
			time = 0;
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		
		
		private function soundCompleteHandler(event: Event): void {
			time = 0;
			dispatchEvent(event);
		}
		
		public function get volume(): Number { return _volume; }
		
		public function set volume(value: Number): void {
			_volume = value;
			st.volume = _volume;
			if (channel) channel.soundTransform = st;
		}
		
		
		
	}

}