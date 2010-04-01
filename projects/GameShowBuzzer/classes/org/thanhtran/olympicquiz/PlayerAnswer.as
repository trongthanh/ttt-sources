package org.thanhtran.olympicquiz {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	* ...
	* @author Thanh T. Tran
	*/
	public class PlayerAnswer extends Sprite {
		//stage
		public var teamName_tf: TextField;
		public var status_mc: MovieClip;
		public var secondLeft_tf: TextField;
		public var answer_tf: TextField;
		public var clear_cbt: Button;
		public var send_cbt: Button;
		public var back_mc: MovieClip;
		
		//
		public var nc: NetConnection;
		public var so: SharedObject;
		public var ownTeam: String;
		private var isAnswered: Boolean;
		
		public function PlayerAnswer() {
			back_mc.addEventListener(MouseEvent.CLICK, onBackClick);
			clear_cbt.addEventListener(MouseEvent.CLICK, onClearClick);
			clear_cbt.buttonMode = true;
			send_cbt.addEventListener(MouseEvent.CLICK, onSendClick);
			send_cbt.buttonMode = true;
			answer_tf.selectable = true;
		}
		
		private function onSendClick(e:MouseEvent):void {
			if (isAnswered || answer_tf.text == "") return;
			var teamObj: Object = so.data[ownTeam];
			teamObj.answer = answer_tf.text;
			so.setProperty(ownTeam, teamObj);
			so.setDirty(ownTeam);
			
			isAnswered = true;
			setStatus(false);
		}
		
		private function onClearClick(e:MouseEvent):void {
			answer_tf.text = "";
		}
		
		public function hide(): void {
			this.visible = false;
		}
		
		private function onBackClick(e:MouseEvent):void {
			so.removeEventListener(SyncEvent.SYNC, onSharedObjectSync);
			
			hide();
		}
		
		public function init(nc: NetConnection, so: SharedObject, ownTeam: String): void {
			this.nc = nc;
			this.so = so;
			this.ownTeam = ownTeam;
			isAnswered = false;
			setStatus(false);
			initEvents();
			this.visible = true;
			
		}
		
		private function initEvents():void{
			so.addEventListener(SyncEvent.SYNC, onSharedObjectSync);
			
			getTeamName();
		}
		
		private function onSharedObjectSync(e:SyncEvent):void {
			getTime();
		}
		
		private function getTime(): void {
			var seconds: int = int(so.data["time"]);
			if (seconds > 0) {
				if (isAnswered == false) setStatus(true);
			} else {
				setStatus(false);
				isAnswered = false;
			}
			secondLeft_tf.text = seconds.toString();
		}
		
		private function getTeamName():void{
			teamName_tf.text = so.data[ownTeam].teamName;
		}
		
		private function setStatus(isAnswering: Boolean) {
			if (isAnswering) {
				status_mc.gotoAndStop("answering");
				answer_tf.type = TextFieldType.INPUT;
				send_cbt.enabled = true;
				clear_cbt.enabled = true;
			} else {
				status_mc.gotoAndStop("stopped");
				answer_tf.type = TextFieldType.DYNAMIC;
				send_cbt.enabled = false;
				clear_cbt.enabled = false;
			}
		}
		
	}
	
}