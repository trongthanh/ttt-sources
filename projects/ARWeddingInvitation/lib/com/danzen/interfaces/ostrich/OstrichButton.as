
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
	
	// **** people on macs may need to adjust their active camera setting in Flash

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

	import flash.display.*
	import flash.utils.Timer;
	import flash.events.*

	public class OstrichButton extends Sprite {
		
		// CONSTRUCTOR  
		// OstrichCursor(theCursor:OstrichCursor, theButton:Object, theHoldDuration:Number=2):void
		// 		OstrichButton takes in an OstrichCursor and some premade "button" DisplayObject
		// 		It then checks to see if the cursor moves over or out of the button
		// 		and also if the user holds on the button for the time given by the third constructor parameter
		//		
		// 		PARAMETERS:
		// 		theCursor:OstrichCursor - the OstrichCursor object we are using
		// 		theButton:Object - a Sprite or MovieClip - the class just uses location and size
		// 		theHoldDuration:Number - seconds on button before a hold is triggered (default 2)

		// EVENTS 
		// OstrichButton.MOTION_OVER 	the cursor has moved over the button 
		// OstrichButton.MOTION_OUT 	the cursor has moved out from the button 
		// OstrichButton.MOTION_HOLD 	the cursor has stayed on the button for the specified myHoldTime
		
		// METHODS (in addition to constructor)
		// dispose():void - removes OstrichButton object - not your original button

		// PROPERTIES  
		// buttonNum:Number - read only - the button num starting at 0 
		// button:Object - reference to the "button" passed in to the OstrichButton object
		// cursor:OstrichCursor - the OstrichCursor passed in to the OstrichButton object
		
		// CONSTANTS  
		// MOTION_START:String - static constant (OstrichCursor.MOTION_START) for motion start event
		// MOTION_STOP:String - static constant (OstrichCursor.MOTION_STOP) for motion stop event
		
		
		public static const MOTION_OVER:String = "MotionOver";
		public static const MOTION_OUT:String = "MotionOut";		
		public static const MOTION_HOLD:String = "MotionHold";
		
		// static constants and related
		private static var buttonTotal:Number = 0; // keeps track of button numbers starting at 0
		private var myButtonNum:Number; // used with getter method at botton of class to return buttonNum
				
		// general holder and check variables
		private var myCursor:OstrichCursor;
		private var myButton:Object;	
		private var myHoldDuration:Number;
		private var motionOnButton:Object;
		private var motionOnButtonHold:Object;
		private var clearCheck:Boolean;
		private var clearCheckHold:Boolean = true;
		private var timerButton:Timer;
		private var timerHold:Timer;
		
		public function OstrichButton(theCursor:OstrichCursor, theButton:Object, theHoldDuration:Number=2) {
						
			if (buttonTotal == 0) {trace ("hi from OstrichButton");}						
						
			myButtonNum = buttonTotal++; // which means cursorNum starts at 0
	
			myCursor = theCursor;	
			myButton = theButton;
			myHoldDuration = theHoldDuration;
			
			timerButton = new Timer(500);
			timerButton.start();
			
			motionOver();
			motionOut();
			motionHold();
			
		}		
		
		// --------------  Over function ----------------------------
		
		private function motionOver() {		
			timerButton.addEventListener(TimerEvent.TIMER, overFunction);
			clearCheck = true;	
		}
		private function overFunction(e:Event) {
			if (myCursor.hitTestObject(DisplayObject(myButton))) {			
				if (clearCheck) {
					dispatchEvent(new Event(OstrichButton.MOTION_OVER, true));
					motionOnButton = myButton;
					clearCheck = false;
				} 		
			} else {
				clearCheck = true;
			}
		}		
		
		// --------------  Out function ----------------------------
		
		private function motionOut() {
			timerButton.addEventListener(TimerEvent.TIMER, outFunction);
			clearCheck = true;	
		}
		private function outFunction(e:Event) {
			if (!myCursor.hitTestObject(DisplayObject(myButton))) {
				if (motionOnButton == myButton) {
					dispatchEvent(new Event(OstrichButton.MOTION_OUT, true));
					motionOnButton = null;
				} 		
			} 
		}		
		
		// --------------  Hold function ---------------------------- 
		
		private function motionHold() {
			timerButton.addEventListener(TimerEvent.TIMER, holdFunction);
			clearCheck = true;				
		}
		private function holdFunction(e:Event) {
			if (myCursor.hitTestObject(DisplayObject(myButton))) {
				if (clearCheckHold) {					
					timerHold = new Timer(myHoldDuration*1000,1);
					timerHold.addEventListener(TimerEvent.TIMER, holdTime);
					timerHold.start();	
					motionOnButtonHold = myButton;
					clearCheckHold = false;
				} 		
			} else {
				clearCheckHold = true;
				if (motionOnButtonHold == myButton) {
					timerHold.stop();
					motionOnButtonHold = null;
				} 				
			}
		}		
		private function holdTime(e:Event) {
			motionOnButtonHold = null;
			dispatchEvent(new Event(OstrichButton.MOTION_HOLD, true));
		}			
		
		// these getter setter methods prevent the buttonNum from being set
		public function get buttonNum() {return myButtonNum;}
		public function set buttonNum(t) {trace ("buttonNum is read only");}		
		
		// these getter setter methods prevent the cursor from being set
		public function get cursor() {return myCursor;}
		public function set cursor(t) {trace ("cursor is read only");}		
		
		// these getter setter methods prevent the button from being set
		public function get button() {return myButton;}
		public function set button(t) {trace ("button is read only");}				
		
		public function dispose() {
			if (timerButton) {timerButton.stop();}
			if (timerHold) {timerHold.stop();}
		}		
		
	}
	
}