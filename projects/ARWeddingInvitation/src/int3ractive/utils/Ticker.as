/**
 * Copyright 2010 Thanh Tran - trongthanh@gmail.com
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
package int3ractive.utils {
	import flash.display.Shape;
	import flash.events.Event;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * A single manager which centralizes all enter-frame handler
	 * @author Thanh Tran
	 */
	public class Ticker extends Shape {
		static private var _instance: Ticker = new Ticker();
		
		private var _tick: Signal;
		
		public function Ticker() {
			if (_instance) throw new Error("Ticker Singleton exception");
			_tick = new Signal();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
		}
		
		private function enterFrameHandler(event: Event = null): void {
			_tick.dispatch();
		}
		
		static public function get tick(): ISignal {
			return _instance._tick;
		}
		
	}

}