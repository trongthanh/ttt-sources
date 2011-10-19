/*
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package {
	import com.transmote.utils.time.FramerateDisplay;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.ascollada.utils.FPS;
	import int3ractive.arinvitation.faces.back.VenueMap;
	import int3ractive.DemoFLARToolkitAway3D;

	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Main extends Sprite {
		public var circle: Sprite;

		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//var demo: FLARManagerExample_Alternativa3D = new FLARManagerExample_Alternativa3D();
			//var demo: DemoFLARToolkitAway3D = new DemoFLARToolkitAway3D();
			var demo: VenueMap = new VenueMap(stage.stageWidth, stage.stageHeight);
			
			addChild(demo);
			
			var frameRateDisplay: FramerateDisplay = new FramerateDisplay();
			frameRateDisplay.mouseChildren = frameRateDisplay.mouseEnabled = false;
			addChild(frameRateDisplay);
			
		}
		
	}

}