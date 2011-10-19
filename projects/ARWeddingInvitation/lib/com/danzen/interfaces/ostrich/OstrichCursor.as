
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

	
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.BlurFilter;
	import fl.transitions.Tween;
	import fl.transitions.easing.None;	
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	import flash.events.*
	
	public class OstrichCursor extends Sprite {
		
		// CONSTRUCTOR  
		// OstrichCursor(theCam:OstrichCamera, theL:Number=0, theT:Number=0, theR:Number=0, theB:Number=0, theResponse:Number=4):void
		// 		OstrichCursor makes a cursor follow motion in a specified area of an OstrichCamera
	    // 		you can then hide the cursor and make another shape follow it (custom cursor)
		// 		and / or you can use the cursor to rollover an OstrichButton and hold to activate
		// 		or you can use the cursor just as any other moving sprite to make a game controller, etc.
		//		
		// 		PARAMETERS:
		//		theCam:OstrichCamera - the cam used for motion detection
		// 		theL:Number - the left side x of the region (with respect to the OstrichCam left)
		// 		theT:Number - the top side y of the region (with respect to the OstrichCam top)
		// 		theR:Number - the right side x of the region (with respect to the OstrichCam left)
		// 		theB:Number - the bottom side y of the region (with respect to the OstrichCam top)
		// 		theResponse:Number - from 1-10 default 4.  1 is fast but jumpy - 10 is slow and smooth

		// EVENTS 
		// OstrichCursor.MOTION_START 	motion has started for a cursor 
		// OstrichCursor.MOTION_STOP 	motion has stopped for a cursor 
		
		// METHODS (in addition to constructor)
		// dispose():void - stops and removes cursor

		// PROPERTIES  
		// cursorNum:Number - read only - the cursor num starting at 0 
		// cam:OstrichCamera - the cam feed passed to the OstrichCursor object
		// x:Number - the x position of the cursor - setting this will do you no good ;-)
		// y:Number - the y position of the cursor - setting this will do you no good ;-)
		// response:Number - between 1-10 - cursor is checked each followInterval
		//					 but reported every response number of times
		//					 movement between reports is averaged to smoothen the motion
		
		// CONSTANTS  
		// MOTION_START:String - static constant (OstrichCursor.MOTION_START) for motion start event
		// MOTION_STOP:String - static constant (OstrichCursor.MOTION_STOP) for motion stop event
		
				
		// event constants
		public static const MOTION_START:String = "MotionStart";
		public static const MOTION_STOP:String = "MotionStop";
		
		// static constants and related
		private static var cursorTotal:Number = 0; // keeps track of cursor numbers starting at 0
		private var myCursorNum:Number; // used with getter method at botton of class to return cursorNum
										
		// a few initial condition varibles
		private var cursorSize:Number = 14;	// a square is drawn for the cursor
		private var fromTop:Number = 10;	// pixels cursor is drawn from top of motion rectangle		
		private var followInterval:Number = 100; // motion checking interval in ms		
		
		// various holder variables and checks
		private var myCam:OstrichCamera; // the cam instance
		private var myResponse:Number;
		private var motionRectangle:Sprite; // a holder for the motion rectangle (hidden)
		private var motionCursor:Sprite; // a holder for the cursor clip		
		private var older:BitmapData; // the old frame of motion
		private var newer:BitmapData; // the new frame of motion		
		private var myMatrix:Matrix; // to handle flipping of the camera
		private var rect:Rectangle; // from getColorBoundsRect around motion color between old and new frames		
		private var motionCheck:Boolean = false; // true when motion over an interval based on followInterval * response		
		private var timerFollow:Timer; // interval for testing motion based on followInterval		
		private var timerMoveCursor:Timer; // interval for moving the cursor based on response * followInterval
		private var tweenObject:Object = new Object(); // store the tweens on an object so we can delete them		
		
		// these are variables used in the calculations		
		private var cursorSpeed:Number; // the interval the cursor moves based on followInterval * response in ms
		private var mL:Number; // m for motionRectangle
		private var mR:Number;
		private var mT:Number;
		private var mB:Number;	
		private var mW:Number;	
		private var mM:Number;	
		private var mX:Number;	
		private var cL:Number; // c for cursor
		private var cR:Number;
		private var cT:Number;
		private var cB:Number;
		private var cW:Number;
		private var cH:Number;
		private var cR1:Number;
		private var cR2:Number;
		private var cT1:Number;
		private var cT2:Number;
		private var moveX:Number;
		private var moveY:Number;			
		private var motionL:Number = 0; // set some initial motion variables for the cursor
		private var motionR:Number = 0;
		private var motionT:Number = 0;
		private var motionB:Number = 0;
		private var motionLtotal:Number = 0;
		private var motionRtotal:Number = 0;	
		private var motionTtotal:Number = 0;	
		private var motionBtotal:Number = 0;
		private var motionTally:Number = 0;
		
		public function OstrichCursor(theCam:OstrichCamera, theL:Number=0, theT:Number=0, theR:Number=0, theB:Number=0, theResponse:Number=4) {	
			
			myCam = theCam;
			// set the rectangle in which the cursor will work			
			cL = theL; 
			cT = theT;
			cR = (theR != 0) ? theR : theL + myCam.width; 		  
			cB = (theB != 0) ? theB : theT + myCam.height; 		
			myResponse = Math.max(theResponse, 1);
			myResponse = Math.min(theResponse, 10);
			
			if (theCam.camCheck) { // double check the camera is ready
				init();
			} else {
				trace ("--------------------------------");
				trace ("please call the OstrichCursor class");
				trace ("after using an OstrichCamera.READY event");
				trace ("--------------------------------");				
			}
		} 
		
		private function init(): void {
			
			if (cursorTotal == 0) {trace ("hi from OstrichCursor");}		
			
			myCursorNum = cursorTotal++; // which means cursorNum starts at 0			
			
			// create the sprite that will hold cursor
			motionCursor = new Sprite();
			addChild(motionCursor);
		
			// create a sprite that will hold the overall motion rectangle that the cursor follows
			motionRectangle = new Sprite();
			//addChild(motionRectangle);
						
			cursorSpeed = myResponse * followInterval;
						
			// draw a cursor with black outside and grey inside square	
			drawCursor(motionCursor);	
						
			// drawing a camera always draws 100% so scale the rectangle down
			cW = (cR - cL) / myCam.xScale;  cH = (cB - cT) / myCam.yScale;		
	
			// this takes care of flipping the camera
			cR1 = cR / myCam.xScale;
			cR2 = myCam.camW - cR1;
			cT1 = cT / myCam.yScale;
			cT2 = cT1;					
			
			// here we figure out translations required to capture our rectangle
			moveX = cR2;
			moveY = cT1;
			
			// whenever we draw to a bitmap with a blend we need a transformation matrix
			myMatrix = new Matrix();					
			myMatrix.translate(-moveX, -moveY);						
			
			// prepare two bitmap objects to store the previous and current video frames		
			older = new BitmapData(cW, cH, false);
			newer = new BitmapData(cW, cH, false);					
			
			// this interval runs the function follow every followInterval milliseconds
			// follow puts a rectangle around motion			
			timerFollow = new Timer(followInterval);
			timerFollow.addEventListener(TimerEvent.TIMER, follow);
			timerFollow.start();			
	
			// this interval runs moveCursor which puts the cursor on the top
			// of the motion rectangle and to the sides as applicable			
			timerMoveCursor = new Timer(cursorSpeed);
			timerMoveCursor.addEventListener(TimerEvent.TIMER, moveCursor);
			timerMoveCursor.start();			
			
		}	
				
		
		private function follow(c: TimerEvent): void {		
				
			// Generally, capture two frames across time and apply a difference filter
			// color will only show where there is movement - turn this to one color
			// draw a rectangle around the color to create a "motion rectangle"
			// Technique learned from Grant Skinner Talk at FITC 2006 & at Interaccess
		
			// We copy the picture from the old frame to a new bitmap
			newer.copyPixels(older,older.rect,new Point(0,0));	
						
			// We then draw what is currently on the camera over top of the old frame
			// As we are specifying using the difference filter, any pixels of the new
			// frame that have the same color as the old frame will have a difference of zero
			// zero means black and then every where that is not black will be some color
			newer.draw(myCam.cam,myMatrix,null,"difference"); 
						
			// Below we draw the unaffected camera feed to the old frame so that
			// when the follow function is called again, we have a copy of the old frame
			older.draw(myCam.cam,myMatrix,null);
			
			// We apply the contrast color filter from the OstrichCamera to focus in on our motion
			newer.applyFilter(newer,newer.rect,new Point(0,0),myCam.cm);
						
			// We apply the blur filter from the OstrichCamera to smoothen our motion region
			newer.applyFilter(newer,newer.rect,new Point(0,0),myCam.bf);
						
			// We apply a threshold to turn all colors above almost black (first number) 
			// to green (second number) the last number is a mask number (confusing)
			// this for some reason will not work unless we set the alpha channel up
			// even though we are not caring about alpha in our bitmap declaration
			// that is, the threshold would work but then the colorbounds would not
			newer.threshold(newer,newer.rect,new Point(0,0),">",0x00110000,0xFF00FF00,0x00FFFFFF);
			
			// Below we get a rectangle that encompasses the color (second number)
			// the first number is a mask (confusing because it deals with bitwise operators)
			// true means a rectangle around the color - false means a rectangle not around the color
			rect = newer.getColorBoundsRect(0x00FFFFFF,0xFF00FF00,true);
			
			// below we keep a running total of rectangle positions and a tally
			// this will allow us to average the rectangle to position the cursor			
			if (rect.width > 0) {
				motionL = Math.round(myCam.cam.x - rect.right * myCam.xScale);
				motionR = Math.round(myCam.cam.x - (rect.right - rect.width) * myCam.xScale);
				motionT = Math.round(myCam.y + rect.top * myCam.yScale);
				motionB = Math.round(myCam.y + rect.bottom * myCam.yScale);			
				motionLtotal += motionL;
				motionRtotal += motionR;
				motionTtotal += motionT;	
				motionBtotal += motionB;	
				motionTally++;		
			}	
			
		}	
		

		private function moveCursor(c: TimerEvent): void {			
			
			// handle checking for any motion					
			if (motionTally > 0 && motionCheck == false && myCam.camCheck) {
				motionCheck = true;
				dispatchEvent(new Event(OstrichCursor.MOTION_START, true));
			} else if (motionTally == 0 && motionCheck && myCam.camCheck) {
				motionCheck = false;
				dispatchEvent(new Event(OstrichCursor.MOTION_STOP, true));	
			}			
			
			// averaging cursor motion		
			mL = motionLtotal / motionTally - moveX * myCam.xScale;
			mR = motionRtotal / motionTally - moveX * myCam.xScale;
			mT = motionTtotal / motionTally + moveY * myCam.yScale;
			mB = motionBtotal / motionTally + moveY * myCam.yScale;
									
			// draw the motion rectangle		
			drawRect(motionRectangle);
						
			// get a width and a middle used in the calculation that follows
			mW = mR - mL;
			//c.mM = c.mR + c.mW / 2 - (myCam._x - myCam._width);	
			mM = mL + mW / 2 - (myCam.cam.x - myCam.width);	
									
			// place cursor to left more as motion rectangle moves left
			// place cursor to right more as motion rectangle moves left
			// place cursor at the top of the motion rectangle
			mX = mL + mM / myCam.width * mW;		
			motionLtotal = motionRtotal = motionTtotal = motionBtotal = motionTally = 0;	
			
			if (mW > 0) {				
				// tween cursor to next position			
				delete(tweenObject.cursorTweenX);
				tweenObject.cursorTweenX = new Tween(motionCursor, "x", None.easeOut, motionCursor.x, mX, cursorSpeed/1000, true);
				delete(tweenObject.cursorTweenY);
				tweenObject.cursorTweenY = new Tween(motionCursor, "y", None.easeOut, motionCursor.y, mT + fromTop, cursorSpeed/1000, true);		
			}
		}		
		
		private function drawCursor(c: Sprite): void {
			c.graphics.moveTo(-cursorSize/2,-cursorSize/2); 
			c.graphics.lineStyle(1,0x000000);		
			c.graphics.lineTo(cursorSize/2,-cursorSize/2);
			c.graphics.lineTo(cursorSize/2, cursorSize/2);
			c.graphics.lineTo(-cursorSize/2, cursorSize/2);
			c.graphics.lineTo(-cursorSize/2,-cursorSize/2); 
			c.graphics.moveTo(-cursorSize/2+1,-cursorSize/2+1); 
			c.graphics.lineStyle(1,0xCCCCCC);
			c.graphics.lineTo(cursorSize/2-1, -cursorSize/2+1);
			c.graphics.lineTo(cursorSize/2-1, cursorSize/2-1);
			c.graphics.lineTo(-cursorSize/2+1, cursorSize/2-1); 
			c.graphics.lineTo(-cursorSize/2+1,-cursorSize/2+1);			
		}		
		
		private function drawRect(r: Sprite): void {
			// used to draw the overall motion rectangle that the cursor follows			
			r.graphics.clear();
			r.graphics.lineStyle(2,0xcc0000);
			r.graphics.moveTo(mL, mT);
			r.graphics.lineTo(mR, mT);
			r.graphics.lineTo(mR, mB);
			r.graphics.lineTo(mL, mB);
			r.graphics.lineTo(mL, mT);
		}		
		
		
		// when another class follows the x y positions of the OstrichCursor it		
		// really follows the x y position of the motionCursor sprite within OstrichCursor		
		protected var theX:Number;
		public override function get x():Number {
			theX = motionCursor.x;
			return this.theX;
		} 
		public override function set x(t:Number):void {
			motionCursor.x = t;
		} 
		
		protected var theY:Number;		
		public override function get y():Number {
			theY = motionCursor.y;
			return this.theY;
		} 			
		public override function set y(t:Number):void {
			motionCursor.y = t;
		} 
		
		// these getter setter methods prevent the cursorNum from being set
		public function get cursorNum(): Number {return myCursorNum;}
		public function set cursorNum(t: Number): void {trace ("cursorNum is read only");}
		
		// these getter setter methods prevent the cam from being set
		public function get cam(): OstrichCamera {return myCam;}
		public function set cam(t: OstrichCamera): void {trace ("cam is read only");}		
		
		public function get response():Number {
			return myResponse;
		}
		
		public function set response(r:Number): void {
			myResponse = Math.max(Math.min(10,r),1);
			cursorSpeed = myResponse * followInterval;	
			timerMoveCursor.delay = cursorSpeed;
		}
		
		public function dispose(): void {
			if (timerFollow) {timerFollow.stop();}
			if (timerMoveCursor) {timerMoveCursor.stop();}
			delete(tweenObject.cursorTweenX);
			delete(tweenObject.cursorTweenY);
			removeChild(motionCursor);
		}				
				
	}
	
}