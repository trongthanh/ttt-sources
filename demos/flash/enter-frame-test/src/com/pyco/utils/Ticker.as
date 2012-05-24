package com.pyco.utils {
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Singleton helper to centralize all handlers that need to be called every frame tick. <br/>
	 * Avoid creating multiple ENTER_FRAME event in every object.
	 * @author Thanh Tran
	 */
	public class Ticker extends Sprite {
		private static var _instance: Ticker = new Ticker();
		private static var _handlers: Array;
		private static var _len: int;
		private static var _running: Boolean;
		
		public function Ticker() {
			if (_instance) throw new Error("TickManager - Singleton Exception");
			_handlers = [];
			_running = true;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void {
			for (var i: int = 0; i < _len; i ++) {
				_handlers[i]();
			}
		}
		
		/**
		 * Adds a function to be called every frame tick
		 * @param	handler
		 */
		public static function add(handler: Function): void {
			if (handler == null) {
				trace("handler is null, skipping...");
				return;
			}
			if (_handlers.indexOf(handler) == -1) {
				//if this handler not added
				_handlers.push(handler);
				_len = _handlers.length;
			} else {
				trace("this handler is already added, skipping...");
			}
		}
		
		/**
		 * Removes a function from being called every frame tick
		 * @param	handler
		 */
		public static function remove(handler: Function): void {
			var idx: int = _handlers.indexOf(handler);
			if (idx >= 0) {
				_handlers.splice(idx, 1);
			} else {
				trace("this handler is not added, no removing");
			}
		}
		
		/**
		 * Removes all handlers
		 */
		public static function removeAll(): void {
			for (var i: int = 0; i < _len; i ++) {
				_handlers[i] = null;
			}
			_handlers = [];
			_len = 0;
		}
		
		/**
		 * Returns number of handlers
		 */
		public static function get numHandlers(): int {
			return _len;
		}
		
		/**
		 * Returns true if enter frame is running
		 */
		public static function get running():Boolean { return _running; }
		
		/**
		 * Pauses all enter frame handlers
		 */
		public static function pauseAll(): void {
			if (_instance.hasEventListener(Event.ENTER_FRAME)) {
				_running = false;
				_instance.removeEventListener(Event.ENTER_FRAME, _instance.enterFrameHandler);
			}
		}
		
		/**
		 * Resumes all enter frame handlers
		 */
		public static function resumeAll(): void {
			if (!_instance.hasEventListener(Event.ENTER_FRAME)) {
				_running = true;
				_instance.addEventListener(Event.ENTER_FRAME, _instance.enterFrameHandler);
			}
		}
		
	}

}