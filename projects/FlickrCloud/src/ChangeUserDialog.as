/**
* ...
* @author Trong Thanh
* @version 0.1
*/

package  {
	import com.adobe.utils.StringUtil;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.User;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ChangeUserDialog extends MovieClip {
		//stage
		public var userName_tf: TextField;
		public var error_tf: TextField;
		public var go_btn: SimpleButton;
		public var close_btn: SimpleButton;
		//
		private var service: FlickrService;
		private var user: User;
		private const MY_API_KEY: String = "d4fe2442dcd10f3e420a41da80c21c9e";
		private const EMAIL_PATTERN: String = "^[a-zA-Z0-9_\\-\\.]+@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$";
		
		public function ChangeUserDialog() {
			service = new FlickrService(MY_API_KEY);
			service.addEventListener(FlickrResultEvent.PEOPLE_FIND_BY_USERNAME, findUserNameResult);
			service.addEventListener(FlickrResultEvent.PEOPLE_FIND_BY_EMAIL, findUserNameResult);
			
			go_btn.addEventListener(MouseEvent.CLICK, onFindClick);
			close_btn.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function onCloseClick(e: MouseEvent): void {
			this.hide();
		}
		
		private function onFindClick(e: MouseEvent): void {
			error_tf.text = "";
			var inputStr: String = userName_tf.text;
			if (StringUtil.trim(inputStr).length <= 0) {
				error_tf.text = "Please enter user name or email!";
				return;
			}
			var emailReg: RegExp = new RegExp(EMAIL_PATTERN);
			
			if (emailReg.test(inputStr)) {
				error_tf.text = "Searching for this Email...";
				service.people.findByEmail(inputStr);
			} else {
				error_tf.text = "Searching for this User Name...";
				service.people.findByUsername(inputStr);
			}
			
		}
		
		private function findUserNameResult(e: FlickrResultEvent): void {
			if (e.success) {
				user = e.data.user as User;
				error_tf.text = "User ID is: " + user.nsid + "\nGetting photo list...";
				this.dispatchEvent(new ChangeFlickrUserEvent(ChangeFlickrUserEvent.CHANGE_USER, user));
				this.hide();
			} else {
				error_tf.text = e.data.error.errorMessage /*+ " (Error Code: " + e.data.error.errorCode + ")"*/;
			}
			
		}
		
		
		public function show(): void {
			this.visible = true;
			error_tf.text = "";
			userName_tf.text = "";
		}
		
		public function hide(): void {
			this.visible = false;
		}
		
		
		
		
		
	}
	
}
