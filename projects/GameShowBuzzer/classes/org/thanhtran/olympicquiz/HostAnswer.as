package org.thanhtran.olympicquiz {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.SyncEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	* ...
	* @author Thanh T. Tran
	*/
	public class HostAnswer extends Sprite {
		//stage
		public var time_tf: TextField;
		public var start_cbt: Button;
		public var stop_cbt: Button;
		public var team_1_tf: TextField;
		public var team_2_tf: TextField;
		public var team_3_tf: TextField;
		public var team_4_tf: TextField;
		public var team_5_tf: TextField;
		public var team_6_tf: TextField;
		public var answer_1_tf: TextField;
		public var answer_2_tf: TextField;
		public var answer_3_tf: TextField;
		public var answer_4_tf: TextField;
		public var answer_5_tf: TextField;
		public var answer_6_tf: TextField;
		public var show_cbt: Button;
		public var back_mc: MovieClip;
		
		//
		public var nc: NetConnection;
		public var so: SharedObject;
		public var isAnswerShown: Boolean;
		public var timer: Timer;
		public var seconds: int;
		
		
		public function HostAnswer() {
			
			start_cbt.addEventListener(MouseEvent.CLICK, onStartClick);
			start_cbt.buttonMode = true;
			stop_cbt.addEventListener(MouseEvent.CLICK, onStopClick);
			stop_cbt.buttonMode = true;
			show_cbt.addEventListener(MouseEvent.CLICK, onShowClick);
			show_cbt.buttonMode = true;
			back_mc.addEventListener(MouseEvent.CLICK, onBackClick);
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimerTick);
		}
		
		public function hide(): void {
			this.visible = false;
		}
		
		private function onBackClick(e:MouseEvent):void {
			so.removeEventListener(SyncEvent.SYNC, onSharedObjectSync);
			timer.stop();
			hide();
		}
		
		private function onShowClick(e:MouseEvent):void {
			isAnswerShown = true;
			getAnswers();
		}
		
		private function onStopClick(e:MouseEvent):void {
			stopAnswering();
		}
		
		private function stopAnswering():void {
			timer.stop();
			time_tf.text = "0";
			so.setProperty("time", 0);
		}
		
		private function onStartClick(e:MouseEvent):void {
			startAnswering();
		}
		
		private function startAnswering(): void {
			isAnswerShown = false;
			var teamObj: Object;
			for (var i: uint = 1; i <= 6; i ++) {
				this["team_" + i + "_tf"].textColor = 0xFFFFFF;
				this["answer_" + i + "_tf"].text = "";
				if (so.data["team_" + i] != null) {
					teamObj = so.data["team_" + i];
					teamObj.answer = "";
					so.setProperty("team_" + i, teamObj);
					so.setDirty("team_" + i);
				}
			}
			seconds = int(time_tf.text);
			timer.start();
		}
		
		 
		
		private function onTimerTick(e:TimerEvent):void {
			if (seconds == 0) {
				stopAnswering();
				return;
			}
			time_tf.text = seconds.toString();
			so.setProperty("time", seconds);
			seconds --;
		}
		
		
		
		public function init(nc: NetConnection, so: SharedObject): void {
			this.nc = nc;
			this.so = so;
			isAnswerShown = false;
			
			initEvents();
			this.visible = true;
		}
		
		private function initEvents():void{
			so.addEventListener(SyncEvent.SYNC, onSharedObjectSync);
			
			
			getTeamNames();
		}
		
		private function onSharedObjectSync(e: SyncEvent):void {
			getAnswers();
			getTeamNames();
		}
		
		private function getAnswers(): void {
			for (var i: uint = 1; i <= 6; i ++) {
				if (!so.data["team_" + i] || !so.data["team_" + i].teamName ) {
					continue;
				} else {
					if (so.data["team_" + i].answer == null) continue; 
					var answer: String = String(so.data["team_" + i].answer);
					if (answer != "") {
						this["team_" + i + "_tf"].textColor = 0x00FF00;
						if (isAnswerShown) {
							this["answer_" + i + "_tf"].text = answer;
						}
					}
				}
			}
		}
		
		private function getTeamNames(): void {
			for (var i: uint = 1; i <= 6; i ++) {
				if (so.data["team_" + i] == null) {
					this["team_" + i + "_tf"].text = "";
					continue;
				} else {
					var teamName: String = String(so.data["team_" + i].teamName);
					this["team_" + i + "_tf"].text = teamName;
				}
			}
		}
	}
	
}