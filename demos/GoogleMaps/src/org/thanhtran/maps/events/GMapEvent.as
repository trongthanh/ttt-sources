package org.thanhtran.maps.events {
	import flash.events.Event;
	
	/**
	* ...
	* @author Thanh Tran
	*/
	public class GMapEvent extends Event {
		public static var GMAP_READY: String = "gmapReady";
		
		public function GMapEvent(type: String, bubbles: Boolean=false, cancelable: Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone(): Event { 
			return new GMapEvent(type, bubbles, cancelable);
		} 
		
		public override function toString(): String { 
			return formatToString("GMapEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}