package com.in2ideas.fireworks {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flare.core.Light3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Thanh Tran - thanh.tran@in2ideas.com
	 */
	public class FireworksLight extends Light3D {
		public static var lightList: Vector.<FireworksLight> = new Vector.<FireworksLight>();
		public static var lastLightIndex: int = 0;
		
		public function FireworksLight() {
			super(String("light" + lightList.length));
			
			//
			this.setParams(0x000000, 0, 0, 0);
			lightList.push(this);
		}
		
		public function flash(position: Vector3D, color: uint = 0xFFFFFF): void {
			this.setPosition(position.x, position.y, position.z);
			
			if(Main.isHardware) {
				this.setParams(color, 200, 1, 1);
				//new emitter may overwrite for new flash
				TweenLite.to(this, 80, { radius: 600, useFrames: true, onComplete: lightFlashCompleteHandler, ease: Linear.easeNone } );
			} else {
				this.setParams(color, 500, 1, 1);
				TweenLite.to(this, 40, { useFrames: true, onComplete: lightFlashCompleteHandler, ease: Linear.easeNone } );
			}
		}
		
		private function lightFlashCompleteHandler():void {
			this.setParams(0x000000, 0, 0, 0);
		}
		
		public static function getNextLight(): FireworksLight {
			if (FireworksLight.lastLightIndex > FireworksLight.lightList.length - 1) {
				FireworksLight.lastLightIndex = 0;
			}
			
			return FireworksLight.lightList[FireworksLight.lastLightIndex++];
		}
	}

}