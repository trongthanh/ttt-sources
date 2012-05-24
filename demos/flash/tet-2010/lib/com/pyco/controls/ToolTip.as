/**
 * (c) Pyramid Consulting.
 * All rights reserved
 * This is a modified class from the original com.pyco.controls.Tooltip
 */
package com.pyco.controls {
    //          Imports!
    // Events
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
    // Things that show up on stage
    import flash.display.MovieClip;
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.text.TextField;
    // Utility classes
    import flash.utils.Timer;
    import flash.utils.Dictionary;
    import flash.text.AntiAliasType;
	//improve shadow with blur filter
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;

	/** 
	 * This tooltip control requires no attached symbol or movie clip to initialize. The tooltip can be customised easily 
	 * such as changing background/ background image, text color, font size, shadow... With a few line of code, you can have 
	 * your own tooltip as you like.<br/>
	 * <b>Version:      0.8</b>
	 * @author	Versus 2004/01/12
	 * @author	Joseph Poidevin 04/11/2005
	 * @author	Jeremy Echols 2007/07/22
	 * @author	Thanh.Tran 2008/04/18 (optimizing, adding more styling and display options, explaining usage)
	 * @author	Trinh.Ho
	 * @modified	 2009-10
	 *
	 * @example 
	 * <listing>
	 * ToolTip.<b>init</b>(stage, 
	 *    {textAlign: 'center',
	 *    textColor: 0xFFFFFF,
	 *    opacity: 100, 
	 *    defaultDelay: 500,
	 *    bgColor: 0x66CCFF,
	 * 	  borderColor: 'none',
	 *    cornerRadius: 10,
	 *    shadow: true,
	 *    bgClass: BgRectangle,
	 *    top: 10,
	 *    left: 10,
	 *    right: 10,
	 *    bottom: 10,
	 *    fadeTime: 100,
	 *    fontSize: 20,
	 *    fontFace: "Arial",
	 *    fontEmbed: true}); 
	 * ToolTip.<b>attach</b>(btn_instructions, 'Learn how to play\n&lt;font color="#FF0000"&gt;Scraboggle&lt;/font&gt;!');
	 * ToolTip.<b>visible</b> = true|false; //hide or show all tooltips
	 * </listing>
	 * <b>TODO:</b>
	 * <ul>
	 * <li>Add more display options regarding the default position of tooltips</li>
	 * <li>Flex compatible</li>
	 * <ul>
	 */
    public class ToolTip {

    /******************************
    *           Properties
    *******************************/
        /** Options for customizing display */
        private static var _displayOptions: ToolTipOptions;

        /** Stage object for reattaching container (to keep it above other
        * objects, since addChildAt doesn't work for higher numbers) */
        private static var _stage: Stage;

        /** Stage dimensions for keeping labels onstage */
        private static var _stageWidth: Number;
		private static var _stageHeight: Number;

        /** actual textfield object to hold our final string */
        private static var _label: TextField;

        /** text that stores the string we're using */
        private static var _text: String;

        /** movieclips for this tooltip - container that holds everything together */
        private static var _container: MovieClip;
        /** background for behind-tooltext-color, and clip for drop-shadow effect */
        private static var _background: Object;
        private static var _shadow: Shape;

        /** Can the user see the tip? */
        private static var _visible: Boolean;

        // Timer object for handling delayed hovers
        private static var _timer: Timer;

        /** Hash of hover objects' data */
        public static var hoverObjects:Dictionary;
		/** The object that is currently hovered */
		public static var currentHoverObject: DisplayObject;
		
		//improve shadow effect
		private static var _blur:BlurFilter;
		
		/** step amount to increase tooltip alpha */
		private static var _alphaDelta: Number;

		/** store tooltip option of each stage in case there are many stages */
		private static var _optionDict: Dictionary;
		
		//
		private static var _isHasBackground: Boolean = false;
    /******************************
          Accessors
    *******************************/
        
        public static function set text(t:String): void {
          _text = t;
		_label.autoSize = "left";
		_label.wordWrap = false;
        _label.htmlText = '<p align="' + _displayOptions.textAlign + '">' +_text + '</p>';
		  
		  if (_label.width > _displayOptions.textMaxWidth) {
			  _label.width = _displayOptions.textMaxWidth;
			  _label.autoSize = "left";
			  _label.wordWrap = true;
			  _label.htmlText = _text;
		  }
		  
          resetBackground();
        }
		
		/** text displayed in the tooltip */
        public static function get text():String { return _text; }
		
        /** status of the tooltip: active or not  */
        public static function get active():Boolean {return _container.visible;}
		
		/** Hide/show all tooltips
		 * @default true
		 * */
		public static function get visible():Boolean { return _visible; }
		
		public static function set visible(value:Boolean):void {
			_visible = value;
		}

    /******************************
    *     "Regular" code
    *******************************/

		/**
		 * Starts the clock for showing a tooltip, sets our text attribute
		 * @param	hoverObject
		 **/
        private static function startShowTimer(e: MouseEvent): void {
			if (_visible == false) return;
			
			//avoid bug when move mouse quickly over different tooltip-enabled objects
			_container.removeEventListener(Event.ENTER_FRAME, fadeOut);
			_container.visible = false;
			//
			var hoverObject: Object = e.currentTarget;
			
			if (_stage != hoverObject.stage) {
				_stage = hoverObject.stage;
				_label.defaultTextFormat = hoverObjects[hoverObject].tipFormat;
				_displayOptions = hoverObjects[hoverObject].tipOption;
			}
			currentHoverObject = hoverObject as DisplayObject;
            var delayMS: Number = hoverObjects[hoverObject].tipDelay;
            var tipText: String = hoverObjects[hoverObject].tipText;
			var anchor: Point = hoverObjects[hoverObject].tipAnchor;
			
			if (anchor) {
				var objPos: Point = currentHoverObject.localToGlobal(new Point(0, 0));
				anchor = objPos.add(anchor);
				_container.x = anchor.x;
				_container.y = anchor.y;
			} else {
				//if no anchor, use mouse position
				setTooltipToMouse(_stage.mouseX, _stage.mouseY);
			}

            _timer.delay = delayMS;
            _timer.repeatCount = 1;
            _timer.start();
            ToolTip.text = tipText;
        }
		
        public static function showTip(e: Event = null): void {
            // Make sure container is top-level object
            _stage.addChild(_container);
            _container.visible = true;
			if (_displayOptions.fadeTime > 0) {
				_container.alpha = 0;
				_container.addEventListener(Event.ENTER_FRAME, fadeIn);
			}
        }
		
		private static function fadeIn(e:Event): void {
			if (_container.alpha < 1) {
				_container.alpha += _alphaDelta;
			}
			else {
				_container.removeEventListener(Event.ENTER_FRAME, fadeIn);
			}
			
		}

		/** Hide tooltip when roll out */
        public static function hide(e: MouseEvent = null): void {
            _timer.stop();
			if (_container.hasEventListener(Event.ENTER_FRAME)) _container.removeEventListener(Event.ENTER_FRAME, fadeIn);
			if (_displayOptions.fadeTime > 0) {
				_container.addEventListener(Event.ENTER_FRAME, fadeOut);
			} else {
				_container.visible = false;
			}
			if (_container.parent) {
				_container.parent.removeChild(_container);
			}
        }
		
		private static function fadeOut(e:Event): void {
			if (_container.alpha > 0) {
				_container.alpha -= _alphaDelta;
			}
			else {
				_container.visible = false;
				_container.removeEventListener(Event.ENTER_FRAME, fadeOut);
			}
		}
		
		/**
		 * Initialize the ToolTips 
		 * (Build the dynamic movie clips, set up defaults, hide the tooltip object)
		 * @param	st		stage
		 * @param	opt		options object, with these properties:<br/>
		 * <ul>
		 * 		<li><b>textAlign</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		'left'|'right'|'center', <b>default</b>: 'left'</li>
		 * 		<li><b>textColor</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		text color, <b>default</b>: 0x000000</li>
		 * 		<li><b>textMaxWidth</b>:&nbsp;	maximum width of the tooltip text, <b>default</b> 300px</li>
		 * 		<li><b>opacity</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		opacity of the background, <b>value</b>: 1 - 100 or 0 - 1</li>
		 * 		<li><b>defaultDelay</b>:&nbsp;&nbsp;&nbsp;	default delay time, <b>value</b>: milliseconds, <b>default</b>: 500</li>
		 * 		<li><b>bgClass</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 		background shape, <b>value</b>: String or Class, <b>default</b>: ''.<br/>If this property is set then other background properties ( bgColor, borderColor, cornerRadius, shadow, opacity) won't effect.</li>
		 * 		<li><b>top</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			padding top of bgClass, <b>default</b>: 0</li>
		 * 		<li><b>bottom</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			padding bottom of bgClass, <b>default</b>: 0</li>
		 * 		<li><b>left</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			padding left of bgClass, <b>default</b>: 0</li>
		 * 		<li><b>right</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			padding right of bgClass, <b>default</b>: 0</li>
		 * 		<li><b>bgColor</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		background color, <b>value</b>: hex-number, <b>default</b>: 0xFFFFCC</li>
		 * 		<li><b>borderColor</b>:&nbsp;&nbsp;&nbsp;&nbsp; 	border color, <b>value</b>: 'none' or a color number, <b>default</b>: 'none'</li>
		 * 		<li><b>cornerRadius</b>:&nbsp;&nbsp; 	radius of the round corner, <b>value</b>: pixel, <b>default</b> 0</li>
		 * 		<li><b>shadow</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 		turn shadow on/off, <b>value</b>: true|false, <b>default</b> true</li>
		 * 		<li><b>fadeTime</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 		fading effect of the tooltip, <b>value</b>: milliseconds, <b>default</b> 0 (should not use with non-embedded font)</li>
		 * 		<li><b>fontFace</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		name of font, <b>value</b>: string, <b>default</b> 'Verdana'</li>
		 * 		<li><b>fontEmbed</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		is the given font embedded, <b>value</b>: true|false, <b>default</b> <code>false</code></li>
		 * 		<li><b>fontSize</b>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 		font size, <b>value</b>: pixel, <b>default</b>: 10</li>
		 * </ul>
		 **/
        public static function init(st: Stage, opt: Object): void {
            if (!hoverObjects) hoverObjects = new Dictionary();
			if (!_optionDict) _optionDict = new Dictionary();
            // Store the stage for reattaching _container
			_stage = st;
			_stage.addEventListener(Event.RESIZE, stageResizeHandler);

            // store the stage's dimensions - for this to be accurate we
            // can't have objects offstage when this call is made because
            // FOR SOME UNGODLY REASON, Flash devs thought it wise to make the
            // stage auto-size.
            _stageWidth   = st.stageWidth;
            _stageHeight  = st.stageHeight;

            // Set up default options and/or grab parameter options
			// Use an internal object for optimized performance
            _displayOptions = new ToolTipOptions();
			// Move values from general object to ToolTipOptions object
			for (var prop: String in opt) {
				_displayOptions[prop] = opt[prop];
			}
			
            _displayOptions.opacity ||= 1;
            // Be lenient and allow integer values of opacity - translate them here
            if (_displayOptions.opacity > 1) {_displayOptions.opacity /= 100;}
            _displayOptions.textAlign ||= 'left';
            _displayOptions.textMaxWidth ||= 300;
            _displayOptions.defaultDelay ||= 500;
			
			//more styling:
			if (isNaN(_displayOptions.bgColor)) _displayOptions.bgColor = 0xFFFFCC;
			_displayOptions.borderColor ||= 'none';
			_displayOptions.cornerRadius ||= 0;
			if (isNaN(_displayOptions.textColor)) _displayOptions.textColor = 0x000000;
			_displayOptions.fontFace ||= "Verdana";
			_displayOptions.fontSize ||= 10;
			if (opt.shadow == undefined) _displayOptions.shadow = true ;
			
			_optionDict[_stage] = _displayOptions;
			
			//calculate amount to increase alpha:
			var fadeTime: Number = _displayOptions.fadeTime || 0;
			var numFrames: Number = (fadeTime / 1000) * _stage.frameRate;
			if (numFrames == 0) _alphaDelta = 1;
			else _alphaDelta = 1 / numFrames;
			
            // Build movie clips
            _container   = new MovieClip();
            _shadow  = new Shape();
				// if bgClass property is set --> new this class to get background
				// else new Shape & draw it
			if ( _displayOptions.bgClass) {
				_isHasBackground = true;
				if ( typeof(_displayOptions.bgClass) == "string") {
					var ClassReference: Class = getDefinitionByName(_displayOptions.bgClass) as Class;  
					_background = new ClassReference();
					
				} else {
					_background = new (_displayOptions.bgClass as Class)();
				}
				// set padding
				_displayOptions.top ||= 0;
				_displayOptions.left ||= 0;
				_displayOptions.right ||= 0;
				_displayOptions.bottom ||= 0;
			} else {
				_background      = new Shape();
			}            

            // Built the label
            _label = new TextField();
            _label.x = 5;
            _label.y = 0;
            _label.width = 5;
            _label.height = 5;
            _label.autoSize = 'left';
            _label.antiAliasType = flash.text.AntiAliasType.ADVANCED;
            _label.selectable = false;
            _label.multiline = true;
			var fmt: TextFormat = new TextFormat()
			fmt.color = _displayOptions.textColor;
			fmt.font = _displayOptions.fontFace;
			fmt.size = _displayOptions.fontSize;
			if (_displayOptions.fontEmbed) {
				fmt.font = _displayOptions.fontFace;
				_label.embedFonts = true;
			}
			_label.defaultTextFormat = fmt;
			

            // Now attach them as necessary - _container to stage, others to _container
            //st.addChild(_container);
            _container.addChild(_shadow);
            _container.addChild(_background as DisplayObject);
            _container.addChild(_label);

            // Set up, but don't start, the timer object (for future use)
            _timer = new Timer(0, 0);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE, showTip);
			
			//prepare blur filter for shadow 
			_blur = new BlurFilter();
			_blur.blurX = 5;
			_blur.blurY = 5;
			_blur.quality = BitmapFilterQuality.LOW;
			
			//Tooltip is visible by default:
			_visible = true;
			//
            hide(null);
        }
		
		
		static private function stageResizeHandler(e:Event):void {
			_stageWidth   = _stage.stageWidth;
            _stageHeight  = _stage.stageHeight;
		}
		
		/**
		 * @private
		 */
		static protected function mouseMoveHandler(event: MouseEvent): void {
			if (_visible == false) return;
			setTooltipToMouse(_stage.mouseX, _stage.mouseY);
			
			event.updateAfterEvent();
		}

        private static function setTooltipToMouse(mouseX: Number, mouseY: Number): void {
			//trace( "set tooltip to mouse: " + mouseX,mouseY );
			
            var w: Number = _label.textWidth;
            var h: Number = _label.textHeight;
			
			var targetX: Number;
			var targetY: Number;
			
            targetX   = mouseX - (w / 2);
            targetY   = mouseY - h - 15;
			
            // Check to see if our clip is falling off the stage
            if (targetX < 5) {targetX = 5;}
            if (targetY < 5) {targetY = mouseY + 20;}

            if (targetX + _container.width > _stageWidth) {
                 targetX = _stageWidth - _container.width - 5;
            }

            if (targetY + _container.height > _stageHeight) {
                 targetY = _stageHeight - _container.height - 5;
            }
			
			//round up coordinators to avoid pixel snapping
			_container.x = int(targetX);
			_container.y = int(targetY);
        }

		/**
		 * Reset the background and shadow to the size of the text label
		 **/
        private static function resetBackground(): void {
            var l:Number;
            var t:Number;
            var w:Number = _label.textWidth + 10;
            var h:Number = _label.textHeight + 5; //bug: fix not vertical middle; was 4
			var opacity: Number = _displayOptions.opacity;				
			
			if (_label.wordWrap) {
					w += 5;
			}
			if ( _isHasBackground) {
				l = _displayOptions.left;
				t = _displayOptions.top;
				_background.x = -l + _label.x;
				_background.y = -t + _label.y;			  
				_background.width = l + _label.width + _displayOptions.right ;
				_background.height = t + _label.height + _displayOptions.bottom;
			} else {
				var cornerRadius: Number = _displayOptions.cornerRadius;
				l = _label.x - 2;
				t = _label.y;
				
				_background.graphics.clear();
				if (String(_displayOptions.borderColor) == 'none') {
					_background.graphics.lineStyle(undefined);
				} else {
					_background.graphics.lineStyle(0, _displayOptions.borderColor, opacity);
				}
				_background.graphics.beginFill(_displayOptions.bgColor, opacity);
				//bg.graphics.drawRect(l, t, w, h);
				_background.graphics.drawRoundRect(l, t, w, h, cornerRadius, cornerRadius);
				_background.graphics.endFill();

				_shadow.graphics.clear();
				if (_displayOptions.shadow == true) {
					_shadow.graphics.beginFill(0x000000, opacity / 2);
					//_shadow.graphics.drawRect(l + 3, t + 3, w, h);
					_shadow.graphics.drawRoundRect(l + 3, t + 3, w, h, cornerRadius, cornerRadius);
					_shadow.graphics.endFill();
					_shadow.filters = [_blur];
				}
			}
        }
		
		/**
		 * Attach the object that will show tooltip on mouse hover
		 * @param	hoverObject	object to show tooltip
		 * @param	tipText		tooltip text for this object, HTML enabled
		 * @param	delayMS		delay milliseconds, zero means use default delay
		 * @param	anchor			the values will be added to the coordinates of center of the hover object
		 */
        public static function attach(hoverObject: * , tipText: String, delayMS: Number = 0, anchor: Point = null): void {
			var fmt: TextFormat = new TextFormat();
			var opt: ToolTipOptions = _optionDict[hoverObject.stage];
			if (!opt) opt = _displayOptions;
            
			fmt.color = opt.textColor;
			fmt.font = opt.fontFace;
			fmt.size = opt.fontSize;
			if (opt.fontEmbed) fmt.font = opt.fontFace;
			
			hoverObjects[hoverObject] = {
                tipText:	tipText,
                tipDelay:	(delayMS > 0) ? delayMS : _displayOptions.defaultDelay,
				tipOption: opt,
				tipFormat: fmt,
				tipAnchor:	anchor
            }
            hoverObject.addEventListener(MouseEvent.ROLL_OVER, startShowTimer);       
			hoverObject.addEventListener(MouseEvent.ROLL_OUT, hide);
			if (!anchor) hoverObject.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }
		
		/**
		 * Remove tooltip from the object that has been attached
		 * @param	hoverObject object to remove tooltip
		 */
		public static function detach(hoverObject: * ):void {
			if (!hoverObjects[hoverObject]) {
				return;
			}
			
			delete hoverObjects[hoverObject];
			hoverObject.removeEventListener(MouseEvent.ROLL_OVER, startShowTimer);       
			hoverObject.removeEventListener(MouseEvent.ROLL_OUT, hide);
            hoverObject.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		/**
		 * Redraw tooltip ( for active tooltip only)
		 */
		public static function redraw(): void {
			if (active) {
				ToolTip.text = hoverObjects[currentHoverObject].tipText;
				ToolTip.resetBackground();
				ToolTip.setTooltipToMouse(_stage.mouseX, _stage.mouseY);
			}
		}
    }
}

import flash.geom.Point;

/**
 *	textAlign:		'left'|'right'|'center', default: 'left'
 *	textColor:		text color, default: 0x000000
 *	textMaxWidth:	maximum width of the tooltip text, default 300px
 *	opacity:		opacity of the background, value: 1 - 100 or 0 - 1
 *	defaultDelay:	default delay time, value: milliseconds, default: 500
 * 	bgClass: 		background shape, value: String or Class, default: ''. If this property is set then other background properties ( bgColor, borderColor, cornerRadius, shadow, opacity) won't effect.
 *	top:			padding top of bgClass
 *	bottom:			padding bottom of bgClass
 *	left:			padding left of bgClass
 *	right:			padding right of bgClass
 *	bgColor:		background color, value: hex-number, default: 0xFFFFCC
 *	borderColor: 	border color, value: 'none' or a color number, default: 'none'
 *	cornerRadius: 	radius of the round corner, value: pixel, default 0
 *	shadow: 		turn shadow on/off, value: true|false, default true
 *	fadeTime: 		fading effect of the tooltip, value: milliseconds, default 0 (should not use with non-embedded font)
 *	fontFace:		name of font, value: string, default 'Verdana'
 *	fontEmbed:		is the given font embedded, value: true|false, default false
 *	fontSize: 		font size, value: pixel, default: 10
 *	anchor_mode:	false|true, default: false; with this mode on, the tooltip will not move and be stationary at a position relative to the center of the object
 *  default_anchor:	Point object, default: (x=20, y=20); the values will be added to the coordinates of center of the hover object
 */

internal class ToolTipOptions {
	public var textAlign		:String;// 	= 'left';
	public var textColor		:Number;//	= 0x000000;
	public var textMaxWidth		:uint;//	= 300;
	public var opacity			:Number;// 	= 1;
	public var defaultDelay		:uint;//	= 500;
	public var bgColor			:Number;//	= 0xFFFFCC;
	public var borderColor		:*;//	= 0; 
	public var bgClass			:*;//	= ""; 
	public var left				: Number;//	= 0; 
	public var right			: Number;//	= 0; 
	public var top				: Number;//	= 0; 
	public var bottom			: Number;//	= 0; 
	public var cornerRadius		:uint;//	= 0;
	public var shadow			:Boolean;//	= true;
	public var fadeTime			:uint;//	= 0;
	public var fontFace			:String;//	= "Verdana";
	public var fontEmbed		:Boolean;//	= false;
	public var fontSize			:uint;//	= 10;	
	//
	public var background: Object;
}
