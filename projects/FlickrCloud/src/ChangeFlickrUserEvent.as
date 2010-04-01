/**
* ...
* @author Trong Thanh
* @version 0.1
*/

package  {
	import com.adobe.webapis.flickr.User;
	import flash.events.Event;

	public class ChangeFlickrUserEvent extends Event {
		public static const CHANGE_USER: String = "changeFlickrUser";
		//
		public var newUser: User;
		
		public function ChangeFlickrUserEvent(type:String, newUser:User, bubbles:Boolean = false, cancelable:Boolean = false) {
			// Pass constructor parameters to the superclass constructor
			super(type, bubbles, cancelable);
		
			this.newUser = newUser;
		}
		
		// Every custom event class must override clone( )
		public override function clone( ):Event {
			return new ChangeFlickrUserEvent(type, newUser, bubbles, cancelable);
		}
		
		// Every custom event class must override toString( ). Note that
		// "eventPhase" is an instance variable relating to the event flow.
		public override function toString( ):String {
			return formatToString("ChangeFlickrUserEvent", "type", "newUser", "bubbles", "cancelable", "eventPhase");
		}
		
	}
	
}
