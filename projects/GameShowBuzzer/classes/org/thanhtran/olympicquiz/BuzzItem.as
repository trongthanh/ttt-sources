package org.thanhtran.olympicquiz {
	import flash.display.MovieClip;
	
	/**
	* ...
	* @author Thanh T. Tran
	*/
	public class BuzzItem extends MovieClip {
		//stage
		public var textWrapper_mc: MovieClip;
		
		//
		private var _label: String;
		
		public function BuzzItem() {
			_label = "";
		}
		
		public function buzz(): void {
			this.gotoAndPlay("buzz");
		}
		
		public function stopBuzz(): void {
			this.gotoAndStop("normal");
		}
		
		/***************** GETTER SETTER *************/
		
		public function get label():String { return _label; }
		
		public function set label(value:String):void {
			_label = value;
			textWrapper_mc.txt.text = _label;
		}
		
	}
	
}