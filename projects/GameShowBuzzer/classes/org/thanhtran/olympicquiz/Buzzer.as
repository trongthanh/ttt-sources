package org.thanhtran.olympicquiz {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SyncEvent;
	import flash.media.SoundMixer;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	* ...
	* @author Thanh T. Tran
	*/
	public class Buzzer extends Sprite	{
		//stage
		public var team_1_tf: TextField;
		public var team_2_tf: TextField;
		public var team_3_tf: TextField;
		public var team_4_tf: TextField;
		public var team_5_tf: TextField;
		public var team_6_tf: TextField;
		public var team_1_mc: BuzzItem;
		public var team_2_mc: BuzzItem;
		public var team_3_mc: BuzzItem;
		public var team_4_mc: BuzzItem;
		public var team_5_mc: BuzzItem;
		public var team_6_mc: BuzzItem;
		public var back_mc: MovieClip;
		
		//
		public var nc: NetConnection;
		public var so: SharedObject;
		public var ownTeam: String;
		private var isBuzzing: Boolean;
		private var currentBuzzer: BuzzItem;
		
		public function Buzzer() {
			back_mc.addEventListener(MouseEvent.CLICK, onBackClick);
		}
		
		private function onBackClick(e:MouseEvent):void {
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onBuzzKeyDown);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, onBuzzKeyUp);
			so.removeEventListener(SyncEvent.SYNC, onSharedObjectSync);
			hide();
		}
		
		public function hide(): void {
			this.visible = false;
		}
		
		public function init(nc: NetConnection, so: SharedObject, ownTeam: String): void {
			this.nc = nc;
			this.so = so;
			
			if (ownTeam != null) {
				this.ownTeam = ownTeam;
				var teamNumber: uint = uint(ownTeam.substr( -1, 1));
				for (var i: uint = 1; i <= 6; i ++) {
					if (teamNumber == i) {
						this["team_" + i + "_tf"].textColor = 0xFF0000;
					} else {
						this["team_" + i + "_tf"].textColor = 0xFFFFFF;
					}
				}
			} else {
				this.ownTeam = "";
			}
			
			this.visible = true;
			initEvents();
		}
		
		private function initEvents():void{
			so.addEventListener(SyncEvent.SYNC, onSharedObjectSync);
			getTeamNames();
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onBuzzKeyDown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onBuzzKeyUp);
		}
		
		private function onBuzzKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.SPACE) {
				tryStopBuzz();
			}
		}
		
		private function onBuzzKeyDown(e:KeyboardEvent):void {
			if (isBuzzing) return;
			if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.SPACE) {
				tryBuzz();
			}
			
		}
		
		private function tryBuzz(): void {
			if (so.data.buzzer == null) {
				so.setProperty("buzzer", ownTeam);
			} else {
				if (isBuzzing) {
					return;
				} else {
					so.setProperty("buzzer", ownTeam);
				}
			}
		}
		
		private function tryStopBuzz(): void {
			if (so.data.buzzer == null) {
				return;
			} else {
				if (String(so.data.buzzer) == ownTeam) {
					so.setProperty("buzzer", "");
				}
			}
		}
		
		private function onSharedObjectSync(e:SyncEvent):void {
			getTeamNames();
			if (so.data.buzzer == null) {
				return;
			} else {
				if (String(so.data.buzzer) == "") {
					receiveBuzz("");
				} else {
					receiveBuzz(String(so.data.buzzer));
				}
			}
		}
		
		private function receiveBuzz(team: String): void {
			if (team == "") {
				if (currentBuzzer != null) {
					currentBuzzer.stopBuzz();
					currentBuzzer = null;
					isBuzzing = false;
					SoundMixer.stopAll();
				}
			} else {
				currentBuzzer = this[team + "_mc"];
				currentBuzzer.buzz();
				isBuzzing = true;
			}
		}
		
		private function getTeamNames(): void {
			for (var i: uint = 1; i <= 6; i ++) {
				if (!so.data["team_" + i] || !so.data["team_" + i].teamName) {
					trace("team_" + i + " not registered");
					this["team_" + i + "_mc"].label = "";
					continue;
				} else {
					if (this["team_" + i + "_mc"].label == "" && String(so.data["team_" + i].teamName) != "") {
						this["team_" + i + "_mc"].label = String(so.data["team_" + i].teamName);
					}
				}
			}
		}
		
		
		
	}
	
}