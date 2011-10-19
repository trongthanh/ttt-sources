
package com.danzen.interfaces.ostrich {
	
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
	import flash.events.*;
	import flash.utils.Timer;
	
	public class OstrichBlobs extends Sprite {
		
		// CONSTRUCTOR  
		// OstrichBlobs(theCam:OstrichCamera, theResponse:Number=4):void
		// 		OstrichBlobs puts blobs on any motion
	    // 		You can hide the blobs by not adding them to the stage
		// 		and then you can use their location to trigger interactivity with hitTestPoint(), etc.
		// 		or you can put your own Sprites or MovieClips where the blobs are
		//		a blob Sprite is made for each grid square the OstrichBlobs analyze
		//		if there is no motion in a square then the x of the blob is at -2000
		//		
		// 		PARAMETERS:
		//		theCam:OstrichCamera - the cam used for motion detection
		// 		theResponse:Number - from 1-10 default 4.  1 is fast but jumpy - 10 is slow and smooth
		
		// METHODS (in addition to constructor)
		// dispose():void - stops and removes cursor

		// PROPERTIES  
		// cam:OstrichCamera - the cam feed passed to the OstrichCursor object
		// response:Number - between 1-10 - cursor is checked each followInterval
		//					 but reported every response number of times
		//					 movement between reports is averaged to smoothen the motion
		// blobs:Array - an array of blob Sprites - so you can get x, y and width, etc.
						
		
		public var myCamera:OstrichCamera;
		public var myCursors:Array = [];	
		private var myGridMotion:Array = [];
		private var myGridLocation:Array = [];
		private var myCursorClips:Array = [];
		private var doneList:Array;
		private var blobList:Array;		
		private var readyCheck:Boolean = false;
		
		private var max:Number = 12;
		private var threshhold:Number = 3;
		private var startDelay:Number = 3; // seconds
		
		private var myResponse:Number;
		private var myTimer:Timer;
				
		public function OstrichBlobs(theCam:OstrichCamera, theResponse:Number=4) {
			
			trace ("hi from OstrichBlobs");
						
			myTimer = new Timer(startDelay*1000,1);
			myTimer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent) {readyCheck = true;});
			myTimer.start();
			
			myCamera = theCam;
			
			var temp:OstrichCursor;
			var tempSprite:Sprite;
			
			var gridW:Number = 640 / max;
			var gridH:Number = 480 / max;			
			
			for (var i:uint = 0; i<max; i++) {
				for (var j:uint = 0; j<max; j++) {					
					temp = new OstrichCursor(myCamera, i*gridW, j*gridH, (i+1)*gridW, (j+1)*gridH, theResponse);
					myCursors.push(temp); 					
					myGridMotion.push(0);
					myGridLocation.push([i*gridW+gridW/2, j*gridH+gridH/2]);
					temp.addEventListener(OstrichCursor.MOTION_START, onStart);
					temp.addEventListener(OstrichCursor.MOTION_STOP, onStop);
					
					tempSprite = new Sprite;
					tempSprite.graphics.beginFill(0xFF99CC, .6);
					tempSprite.graphics.drawCircle(0,0,100);
					tempSprite.x = -2000;
					addChild(tempSprite);
					myCursorClips.push(tempSprite);			
					
				}
			}			
			
		}
		
		private function onStart(e:Event) {
			myGridMotion[e.target.cursorNum] = 1;
			analyseGrid();
		}
		
		private function onStop(e:Event) {
			myGridMotion[e.target.cursorNum] = 0;
			analyseGrid();
		}				
		
		
		private function analyseGrid() {
			
			if (!readyCheck) {return;}
			
			//set the grid max to 6 and uncomment this to view this arrangement
			/*myGridMotion = [1,1,0,0,0,0,
							1,1,0,0,0,0,
							0,0,0,0,0,0,
							0,0,0,0,0,0,
							0,0,0,0,1,1,
							0,0,0,0,1,1];*/
			
			
			doneList = [];
			blobList = [];
			
			var gridW:Number = 640 / max;
			var gridH:Number = 480 / max;
			
			var num:Number;
			var m:uint;
			var n:uint;			
			
			function goR(n:Number) {
				var col:Number = n % max + 1;
				if (col+1 > max) {return -1;} else {return n+1;}
			}
			function goL(n:Number) {
				var col:Number = n % max + 1;
				if (col-1 < 1) {return -1;} else {return n-1;}
			}	
			function goB(n:Number) {
				var row:Number = Math.floor(n / max) + 1;				
				if (row+1 > max) {return -1;} else {return n+max;}
			}
			function goT(n:Number) {
				var row:Number = Math.floor(n / max) + 1;				
				if (row-1 < 1) {return -1;} else {return n-max;}
			}				
			function checkAround(n:Number) {
				var newNum:Number;
				var functionList:Array = [goR, goL, goB, goT];
				for (var r:uint=0; r<4; r++) {
					newNum = functionList[r](n);
					if (newNum != -1 && myGridMotion[newNum] == 1 && doneList.indexOf(newNum) == -1) {
						doneList.push(newNum)
						blobList[blobList.length-1].push(newNum);
						checkAround(newNum);
					}
				}
			}			
			
			for (var i:uint = 0; i<max; i++) {
				for (var j:uint = 0; j<max; j++) {
					num = i * max + j;					
					if (myGridMotion[num] == 1 && doneList.indexOf(num) == -1) {					
						blobList.push([num]);
						doneList.push(num);						
						checkAround(num);
					}				
				}				
			}
				
			
			var e:Number;
			var tX:Number;
			var tY:Number;
			var t:Number;
			var factor:Number = (640+480)/2/max;
			var blobCursors:Array = [];
			for (var b:uint=0; b<blobList.length; b++) {
				t = blobList[b].length;
				if (t < threshhold) {continue;}
				tX = tY = 0;
				for (e=0; e<t; e++) {
					tX += myGridLocation[blobList[b][e]][0];
					tY += myGridLocation[blobList[b][e]][1];
				}
				// x average, y average, radius average
				blobCursors.push([Math.round(tX / t), Math.round(tY / t), Math.sqrt(t)*factor/2]);
			}
			
			for (var q:uint=0; q<Math.pow(max,2); q++) {				
				myCursorClips[q].x = -2000;
			}
					
			var c:uint;			
			for (c=0; c<blobCursors.length; c++) {				
				myCursorClips[c].width = myCursorClips[c].height = blobCursors[c][2] * 2;
				myCursorClips[c].x = blobCursors[c][0];
				myCursorClips[c].y = blobCursors[c][1];
			}		
			
			
		}
		
		public function get response():Number {
			return myResponse;
		}
		
		public function set response(r:Number) {
			myResponse = Math.max(Math.min(10,r),1);
			for (var i:uint = 0; i<max*max; i++) {
				myCursors[i].response = myResponse; 					
			}		
		}
		
		public function get blobs():Array {
			return myCursorClips;
		}
		
		public function dispose() {
			for (var i:uint = 0; i<max*max; i++) {
				myCursors[i].removeEventListener(OstrichCursor.MOTION_START, onStart);
				myCursors[i].removeEventListener(OstrichCursor.MOTION_STOP, onStop);
				myCursors[i].dispose();				
				removeChild(myCursorClips[i]);
				delete myCursorClips[i];
			}
			for (i=0; i<max*max; i++) {
				delete myCursors[i];
			}
			myTimer.stop();
			myTimer = null;			
		}	
		
	}
	
}