
package com.danzen.interfaces.ostrich{

	// OSTRICH INTRODUCTION  
	// Ostrich lets you follow video motion with a cursor
	// for instance, you can wave at a Webcam and make a cursor move to where you wave
	// this can be used as an interface to control elements of your application

	// FEATURES AND CONSIDERATIONS
	// you can specify a region in which to look for motion
	// you can specify multiple cursors - each with their own region
	// the OstrichButton class is provided to trigger over, out and hold events (no click)
	// the fastest way to find out if a button is activated is to make it a cursor region
	// then use the cursor start and stop to catch activity in that region
	// you can make your own clips follow the OstrichCursor

	// WORKINGS
	// OstrichCursor is optimized for a single person standing in the middle using hands
	// a rectangle is put around all motion and then a cursor is positioned as follows:
	// the y position of the cursor is set to ten pixels beneath the top of the motion rectangle
	// if rectangle is at the left of the camera it takes the left edge of rectangle for cursor x position
	// if rectangle is at right it takes the right edge of rectangle for cursor x position
	// if rectangle is in the center it takes the center of the rectangle for cursor x position
	// if rectangle is anywhere else it uses the proportion to figure cursor x location
	// you can adjust this by reworking the class

	// http://ostrichflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using Ostrich for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	// also be aware that Gesture Tek and perhaps others hold patents in these areas

	// INSTALLING CLASSES  
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder
	// put the provided com/danzen/ directory with its folders and files in the classes folder
	// the readme has more information if you need it

	// USING OSTRICH  
	// please make sure that the following director is in a folder in your class path:
	// com/danzen/interfaces/ostrich/
	// see the samples for how to use the Ostrich classes
	
	// OstrichCamera - sets up a Web cam for capturing motion
	// OstrichCursor - sets up a cursor that follows the motion in OstrichCamera
	// OstrichButton - sets up events for an invisible hotspot per OstrichCursor
	// OstrichBlobs - puts blobs on any motion
	
	// ******************
	// This class should only be called after an OstrichCamera.READY event fires
	


	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.BlurFilter;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	import flash.events.*;
	public class OstrichCamera extends Sprite {
		
	// CONSTRUCTOR  
	// OstrichCamera(theL:Number=0, theT:Number=0, theR:Number=640, theB:Number=480):void
	// this class captures the camera and stores it in a cam Video object
	// it flips the camera so you can match your motion like a mirror
	// you can use this class without adding it to the stage with addChild()
	// or you can add it and set the alpha or the visible as desired
	//  just use once and then all OstrichCursor objects can use it to capture motion
	//
	// PARAMETERS:
	// theL:Number - the left side x of the camera
	// theT:Number - the top side y of the camera
	// theR:Number - the right side x of the camera
	// theB:Number - the bottom side y of the camera

	// EVENTS 
	// OstrichCamera.READY - the camera is on and ready for motion capture 
	// OstrichCamera.NO_CAMERA - called if there is no camera to start
	
	// METHODS (in addition to constructor)
	// dispose():void
	// stops camera - then can remake with different size if desired

	// PROPERTIES  
	// camNum:Number - the cam num starting at 0 
	// camCheck:Boolean - a Boolean used as a safeguard by other Ostrich classes
	// left, right, top and bottom:Number - read only - what was sent in as object was created
	// but it extends a sprite so there is alpha, visible, etc.

	// CONSTANTS  
	// READY:String - static constant (OstrichCamera.READY) for camera ready event
	// NO_CAMERA:String - static constant (OstrichCamera.NO_CAMERA) for no camera at start
		
		
		public static const READY:String="ready";
		public static const NO_CAMERA:String="noCamera";

		// static constants and related
		private static var camTotal:Number=0;// keeps track of cursor numbers starting at 0
		private var myCamNum:Number;// used with getter method at botton of class to return cursorNum
		public var myLeft:Number;// position of the apparent camera window
		public var myTop:Number;
		public var myRight:Number;
		public var myBottom:Number;

		public var cam:Video;// the cam instance
		public var signal:Camera;// the camera signal

		public var camW:Number;// the unscaled width of the cam
		public var camH:Number;// the unscaled height of the cam
		public var cm:ColorMatrixFilter;// a color matrix
		public var bf:BlurFilter;// a blur filter
		public var camCheck:Boolean=false;// use the OstrichCursor.READY event instead!
		public var xScale:Number;// cam scale taken from scaleX of initial cam
		public var yScale:Number;// cam scale taken from scaleY of initial cam

		private var timerCheckStart:Timer;// timers to check the availability of the camera
		private var timerCheckStart2:Timer;
		private var myTimer:Timer; // delay for camera list check

		public function OstrichCamera(theL:Number=0, theT:Number=0, theR:Number=640, theB:Number=480) {
				
			if (camTotal==0) {
				trace("hi from OstrichCamera");
			}

			myCamNum=camTotal++;// which means camNum starts at 0
			cam = new Video();

			// capturing bitmap always ignores any transformations
			// so record original size of cam to start
			camW=cam.width;
			camH=cam.height;

			cam.x=theL;
			cam.y=theT;
			cam.width=theR-theL;
			cam.height=theB-theT;

			xScale=cam.scaleX;
			yScale=cam.scaleY;
			
			myTimer = new Timer(200, 1);
			myTimer.addEventListener(TimerEvent.TIMER, init);
			myTimer.start();						
		}
		
		private function init(e:TimerEvent): void {

			//signal=Camera.getCamera();

			if (Camera.names.length == 0) {
				dispatchEvent(new Event(OstrichCamera.NO_CAMERA));				
				return;
			}
			var macCamera:Number = -1;
			for (var i:uint=0; i<Camera.names.length; i++) {				
				if (Camera.getCamera(String(i)).name == "USB Video Class Video") {
					macCamera = i; 
					break;
				}
			}
			if (macCamera >= 0) {
				signal = Camera.getCamera(String(macCamera));
			} else {
				signal = Camera.getCamera();
			}

			cam.attachCamera(signal);
			addChild(cam);

			// provide cam rectangle (before flipping the cam) as properties (would only work to read)
			myLeft=cam.x;
			myTop=cam.y;
			myRight=left+cam.width;
			myBottom=top+cam.height;

			// flip the cam instance around to get a mirror effect
			cam.scaleX=- xScale;
			cam.x+=cam.width;


			// need to find out when camera is active and set small delay to avoid motion trigger at start
			// can't use status because it does not trigger when camera is automatically accepted
			// set a check every 200 ms to see if camera is accepted
			// once it is accepted, set a delay of 1000 ms until we start checking for motion with camCheck
			timerCheckStart=new Timer(200);
			timerCheckStart.addEventListener(TimerEvent.TIMER, startStopEvents);
			timerCheckStart.start();
			timerCheckStart2=new Timer(1000,1);
			timerCheckStart2.addEventListener(TimerEvent.TIMER, startStopEvents2);
			function startStopEvents(e:TimerEvent): void {
				if (! signal.muted) {
					timerCheckStart.stop();
					timerCheckStart2.start();
				}
			}
			function startStopEvents2(e:TimerEvent): void {
				camCheck=true;
				dispatchEvent(new Event(OstrichCamera.READY, true));
			}

			// set up some filters for better motion detection
			// we will apply these in the cursor classes

			// first we set up a color matrix filter to up the contrast of the image
			// to do this we boost each color channel then reduce overall brightness
			// we create a color matrix that will boost each color (multiplication)
			// and then drop the brightness of the channel (addition)
			var boost:Number=4;//3
			var brightness:Number=-50;//-60;
			var cmArray:Array = [
			boost,0,0,0,brightness,
			0,boost,0,0,brightness,
			0,0,boost,0,brightness,
			0,0,0,1,0
			];

			// create a new colorMatrixFilter so that we can apply our color matrix
			cm=new ColorMatrixFilter(cmArray);

			// set up a blur filter to help emphasize areas of change
			bf=new BlurFilter(16,16,2);

		}

		// these getter setter methods prevent the camNum from being set
		public function get camNum(): Number {
			return myCamNum;
		}
		public function set camNum(t: Number): void {
			trace("camNum is read only");
		}

		// these getter setter methods prevent the dimensions from being set
		public function get left(): Number {
			return myLeft;
		}
		public function set left(t: Number): void {
			trace("left is read only - dispose() and recreate class if changes are needed");
		}
		public function get right(): Number {
			return myRight;
		}
		public function set right(t: Number): void {
			trace("right is read only - dispose() and recreate class if changes are needed");
		}
		public function get top(): Number {
			return myTop;
		}
		public function set top(t: Number): void {
			trace("top is read only - dispose() and recreate class if changes are needed");
		}
		public function get bottom(): Number {
			return myBottom;
		}
		public function set bottom(t: Number): void {
			trace("bottom is read only - dispose() and recreate class if changes are needed");
		}

		public function dispose(): void {
			if (timerCheckStart) {
				timerCheckStart.stop();
			}
			if (timerCheckStart2) {
				timerCheckStart2.stop();
			}
			removeChild(cam);
		}
	}
}