package org.thanhtran.earth3d.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Earth3DMouseEvent extends Event {
		
		public static const EARTH_RELEASE: String = "earthRelease";
		public static const EARTH_RELEASE_OUTSIDE: String = "earthReleaseOutside";
		public static const EARTH_PRESS: String = "eathPress";
		public static const EARTH_OVER: String = "earthOver";
		public static const EARTH_OUT: String = "earthOut";
		public static const EARTH_MOUSE_MOVE: String = "earthMouseMove";
		
		protected var _centerLat: Number;
		protected var _centerLng: Number;
		
		protected var _mouseLat: Number;
		protected var _mouseLng: Number;
		
		public function Earth3DMouseEvent(type: String, mouseLat: Number, mouseLng: Number, centerLat: Number, centerLng: Number, bubbles: Boolean=false, cancelable: Boolean=false) { 
			super(type, bubbles, cancelable);
			
			_mouseLat = mouseLat;
			_mouseLng = mouseLng;
			_centerLat = centerLat;
			_centerLng = centerLng;
		} 
		
		public override function clone(): Event { 
			return new Earth3DMouseEvent(type, _mouseLat, _mouseLng, _centerLat, _centerLng, bubbles, cancelable);
		} 
		
		
		public override function toString(): String { 
			return formatToString("Earth3DEvent", type, "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get centerLat(): Number { return _centerLat; }
		public function get centerLng(): Number { return _centerLng; }
		
		public function get mouseLat(): Number { return _mouseLat; }
		public function get mouseLng(): Number { return _mouseLng; }
		
	}
	
}