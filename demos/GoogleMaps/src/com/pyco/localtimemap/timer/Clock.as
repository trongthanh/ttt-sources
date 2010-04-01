/*
 * Copyright (c) 2008 Pyramid Consulting - www.pyramid-consulting.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.pyco.localtimemap.timer {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * This class extends a Symbol class in assets_library.swc
	 * @author Thanh Tran
	 */
	public class Clock extends ClockUI {
		//stage
		//pulbic var minHand: Sprite;
		//public var hourHand: Sprite;
		
		//properties
		protected var hr: int = 0;
		protected var min: int = 0;
		protected var sec: int = 0;
		
		protected var timer: Timer;
		
		public function Clock() {
			init();
		}
		
		protected function init():void {
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerTickHandler);
		}
		
		protected function timerTickHandler(event: TimerEvent): void {
			updateTime();
		}
		
		protected function updateTime(): void {
			sec ++;
			if (sec > 59) {
				sec = 0;
				min ++;
			}
			if (min > 59) {
				min = 0;
				hr ++;
			}
			if (hr > 23) {
				hr = 0;
			}
			
			hourHand.rotation = 
		}
		
		/**
		 * Sets time for this clock
		 * @param	hour	0 - 23
		 * @param	minute	0 - 59
		 * @param	second	0 - 59
		 */
		public function setTime(hour: int, minute: int, second: int): void {
			hr = (hour >= 0 && hour <= 23)? hour : 0;
			min = (minute >= 0 && minute <= 59)? minute : 0;
			sec = (second >= 0 && second <= 59)? second : 0;
			updateTime();
			timer.start();
		}
		
		
	}
	
}