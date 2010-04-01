package org.thanhtran.olympicquiz {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
    import flash.net.NetConnection;
    import flash.events.NetStatusEvent;
	import flash.text.TextFieldType;
	
	/**
	* ...
	* @author Thanh T. Tran		ttt_conan@yaho.com
	*/
	public class Host extends MovieClip {
		//stage
		public var title_tf: TextField;
		public var label_tf: TextField;
		public var input_tf: TextField;
		public var signIn_cbt: Button;
		public var error_tf: TextField;
		
		public var buzzer_mc: Buzzer;
		public var answer_mc: HostAnswer;
		
		public var answerMode_btn: SimpleButton;
		public var buzzerMode_btn: SimpleButton;
		//
		public var nc:NetConnection;
		public var so: SharedObject;
		private var team: String;
		private var teamName: String;
		private var isTeamSet: Boolean;
		
		public function Host() {
			init();
			
		}
		
		private function init(): void {
			nc = new NetConnection();
            nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			signIn_cbt.addEventListener(MouseEvent.CLICK, onSignInClick);
			signIn_cbt.buttonMode = true;
			signIn_cbt.useHandCursor = true;
			
			buzzerMode_btn.addEventListener(MouseEvent.CLICK, onBuzzerModeClick);
			answerMode_btn.addEventListener(MouseEvent.CLICK, onAnswerModeClick);
			
			
			setupServerConnection();
			
			isTeamSet = false;
			buzzer_mc.hide();
			answer_mc.hide();
		}
		
		private function onAnswerModeClick(e:MouseEvent):void {
			answer_mc.init(nc, so);
		}
		
		private function onBuzzerModeClick(e:MouseEvent):void {
			buzzer_mc.init(nc, so, null);
		}
		
		private function onSignInClick(e:MouseEvent):void 
		{
			if (nc.connected == false) {
				nc.connect(input_tf.text);
			}
			
		}
		
		
		
		
              
        public function netStatusHandler(event:NetStatusEvent):void
        {
            trace("connected is: " + nc.connected );
			trace("event.info.level: " + event.info.level);
			trace("event.info.code: " + event.info.code);
			
            switch (event.info.code)
            {
                case "NetConnection.Connect.Success":
	                trace("Congratulations! you're connected");
					startHost();
	                break;
                case "NetConnection.Connect.Rejected":
	                trace ("Oops! the connection was rejected");
					error_tf.text = "Connection rejected";
	                // try to connect again
	                break;
	            case "NetConnection.Connect.InvalidApp":
	                trace("Please specify a different application name in the URI");
					error_tf.text = "Invalid Application. Connect failed";
	                // try to connect again
	                break;
	            case "NetConnection.Connect.Failed":
	                trace("The server may be down or unreachable");
					error_tf.text = "Connect failed";
	                // display a message for the user
	                break;
	            case "NetConnection.Connect.AppShutDown":
	                trace("The application is shutting down");
	                // this method disconnects all stream objects
	                nc.close();
	                break;
	            case "NetConnection.Connect.Closed":
	                trace("The connection was closed successfully - goodbye");
	                // display a reconnect button
	                break;
	        }
        } 
		
		private function setupServerConnection(): void {
			title_tf.text = "Server Connection";
			label_tf.text = "Server:";
			error_tf.text = "";
			input_tf.text = "rtmp://localhost/olympic";
			input_tf.type = TextFieldType.INPUT;
			signIn_cbt.label = "Sign In";
			answerMode_btn.visible = false;
			buzzerMode_btn.visible = false;
		}
		
		private function startHost(): void {
			//get SharedObject
			so = SharedObject.getRemote("GameShowSO", nc.uri, false);
			so.addEventListener(SyncEvent.SYNC, onSharedObjectSync);
			so.connect(nc);
			
			answerMode_btn.visible = true;
			buzzerMode_btn.visible = true;
			//prevent inputing
			input_tf.type = TextFieldType.DYNAMIC;
		}
		
		private function onSharedObjectSync(e:SyncEvent):void 
		{
			//testing
			/*
			for (var i: uint = 1; i <= 6; i ++) {
				if (so.data["team_" + i] != null) trace(so.data["team_" + i].teamName);
			}
			*/
		}

	}
	
}