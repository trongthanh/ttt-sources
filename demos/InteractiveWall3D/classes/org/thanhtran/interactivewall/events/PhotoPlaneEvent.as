/**
* @author Thanh Tran
*/
package org.thanhtran.interactivewall.events {
	import flash.events.Event;
	
	/**
	* ...
	*/
	public class PhotoPlaneEvent extends Event {
		public static const START_VIEW: String = "startView";
		public static const STOP_VIEW: String = "stopView";
		public static const ANIMATION_STOP: String = "animationStop";
		
		
		public function PhotoPlaneEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new PhotoPlaneEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("PhotoPlaneEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}