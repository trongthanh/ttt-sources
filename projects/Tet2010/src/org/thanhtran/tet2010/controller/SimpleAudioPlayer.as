/**
 * Copyright (c) 2010 trongthanh@gmail.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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