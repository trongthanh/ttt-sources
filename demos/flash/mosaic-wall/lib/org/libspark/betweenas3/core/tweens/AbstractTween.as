/*
 * BetweenAS3
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 BeInteractive! (www.be-interactive.org) and
 *                    Spark project  (www.libspark.org)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
package org.libspark.betweenas3.core.tweens
{
	import flash.events.Event;
	import org.libspark.betweenas3.core.ticker.ITicker;
	import org.libspark.betweenas3.core.ticker.TickerListener;
	import org.libspark.betweenas3.core.utils.ClonableEventDispatcher;
	import org.libspark.betweenas3.events.TweenEvent;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class AbstractTween extends TickerListener implements IITween
	{
		public function AbstractTween(ticker:ITicker, position:Number)
		{
			_ticker = ticker;
			_position = position;
		}
		
		protected var _ticker:ITicker;
		protected var _position:Number = 0;
		protected var _duration:Number = 0;
		protected var _startTime:Number;
		protected var _isPlaying:Boolean = false;
		protected var _stopOnComplete:Boolean = true;
		protected var _dispatcher:ClonableEventDispatcher;
		protected var _willTriggerFlags:uint = 0;
		protected var _classicHandlers:ClassicHandlers;
		
		/**
		 * @inheritDoc
		 */
		public function get ticker():ITicker
		{
			return _ticker;
		}
		
		/**
		 * このトゥイーンの継続時間 (秒) を返します.
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * このトゥイーンの現在位置 (秒) を返します.
		 */
		public function get position():Number
		{
			return _position;
		}
		
		/**
		 * このトゥイーンが現在再生中であれば true, そうでなければ false を返します.
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get stopOnComplete():Boolean
		{
			return _stopOnComplete;
		}
		
		/**
		 * @private
		 */
		public function set stopOnComplete(value:Boolean):void
		{
			_stopOnComplete = value;
		}
		
		public function get onPlay():Function
		{
			return _classicHandlers != null ? _classicHandlers.onPlay : null;
		}
		
		public function set onPlay(value:Function):void
		{
			getClassicHandlers().onPlay = value;
		}
		
		public function get onPlayParams():Array
		{
			return _classicHandlers != null ? _classicHandlers.onPlayParams : null;
		}
		
		public function set onPlayParams(value:Array):void
		{
			getClassicHandlers().onPlayParams = value;
		}
		
		public function get onStop():Function
		{
			return _classicHandlers != null ? _classicHandlers.onStop : null;
		}
		
		public function set onStop(value:Function):void
		{
			getClassicHandlers().onStop = value;
		}
		
		public function get onStopParams():Array
		{
			return _classicHandlers != null ? _classicHandlers.onStopParams : null;
		}
		
		public function set onStopParams(value:Array):void
		{
			getClassicHandlers().onStopParams = value;
		}
		
		public function get onUpdate():Function
		{
			return _classicHandlers != null ? _classicHandlers.onUpdate : null;
		}
		
		public function set onUpdate(value:Function):void
		{
			getClassicHandlers().onUpdate = value;
		}
		
		public function get onUpdateParams():Array
		{
			return _classicHandlers != null ? _classicHandlers.onUpdateParams : null;
		}
		
		public function set onUpdateParams(value:Array):void
		{
			getClassicHandlers().onUpdateParams = value;
		}
		
		public function get onComplete():Function
		{
			return _classicHandlers != null ? _classicHandlers.onComplete : null;
		}
		
		public function set onComplete(value:Function):void
		{
			getClassicHandlers().onComplete = value;
		}
		
		public function get onCompleteParams():Array
		{
			return _classicHandlers != null ? _classicHandlers.onCompleteParams : null;
		}
		
		public function set onCompleteParams(value:Array):void
		{
			getClassicHandlers().onCompleteParams = value;
		}
		
		protected function getClassicHandlers():ClassicHandlers
		{
			return _classicHandlers || (_classicHandlers = new ClassicHandlers());
		}
		
		/**
		 * このトゥイーンの再生を現在の位置から開始します.
		 */
		public function play():void
		{
			if (!_isPlaying) {
				if (_position >= _duration) {
					_position = 0;
				}
				var t:Number = _ticker.time;
				_startTime = t - _position;
				_isPlaying = true;
				_ticker.addTickerListener(this);
				if ((_willTriggerFlags & 0x01) != 0) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.PLAY));
				}
				if (_classicHandlers != null && _classicHandlers.onPlay != null) {
					_classicHandlers.onPlay.apply(null, _classicHandlers.onPlayParams);
				}
				tick(t);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function firePlay():void
		{
			if ((_willTriggerFlags & 0x01) != 0) {
				_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.PLAY));
			}
			if (_classicHandlers != null && _classicHandlers.onPlay != null) {
				_classicHandlers.onPlay.apply(null, _classicHandlers.onPlayParams);
			}
		}
		
		/**
		 * このトゥイーンの再生を現在の位置で停止します.
		 */
		public function stop():void
		{
			if (_isPlaying) {
				_isPlaying = false;
				if ((_willTriggerFlags & 0x02) != 0) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.STOP));
				}
				if (_classicHandlers != null && _classicHandlers.onStop != null) {
					_classicHandlers.onStop.apply(null, _classicHandlers.onStopParams);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function fireStop():void
		{
			if ((_willTriggerFlags & 0x02) != 0) {
				_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.STOP));
			}
			if (_classicHandlers != null && _classicHandlers.onStop != null) {
				_classicHandlers.onStop.apply(null, _classicHandlers.onStopParams);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function togglePause():void
		{
			if (_isPlaying) {
				stop();
			}
			else {
				play();
			}
		}
		
		/**
		 * このトゥイーンの再生を指定された位置から開始します.
		 * 
		 * @param	position	再生を開始する位置 (秒)
		 */
		public function gotoAndPlay(position:Number):void
		{
			if (position < 0) {
				position = 0;
			}
			if (position > _duration) {
				position = _duration;
			}
			_position = position;
			play();
		}
		
		/**
		 * このトゥイーンの再生を指定された位置で停止します.
		 * 
		 * @param	position	再生を停止する位置 (秒)
		 */
		public function gotoAndStop(position:Number):void
		{
			if (position < 0) {
				position = 0;
			}
			if (position > _duration) {
				position = _duration;
			}
			_position = position;
			internalUpdate(position);
			if ((_willTriggerFlags & 0x04) != 0) {
				_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
			}
			if (_classicHandlers != null && _classicHandlers.onUpdate != null) {
				_classicHandlers.onUpdate.apply(null, _classicHandlers.onUpdateParams);
			}
			stop();
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(time:Number):void
		{
			var isComplete:Boolean = false;
			
			if ((_position < _duration && _duration <= time) || (0 < _position && time <= 0)) {
				isComplete = true;
			}
			
			_position = time;
			internalUpdate(time);
			
			if ((_willTriggerFlags & 0x04) != 0) {
				_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
			}
			if (_classicHandlers != null && _classicHandlers.onUpdate != null) {
				_classicHandlers.onUpdate.apply(null, _classicHandlers.onUpdateParams);
			}
			
			if (isComplete) {
				if ((_willTriggerFlags & 0x08) != 0) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
				}
				if (_classicHandlers != null && _classicHandlers.onComplete != null) {
					_classicHandlers.onComplete.apply(null, _classicHandlers.onCompleteParams);
				}
			}
			
		}
		
		override public function tick(time:Number):Boolean
		{
			if (!_isPlaying) {
				return true;
			}
			
			var t:Number = time - _startTime;
			
			_position = t;
			internalUpdate(t);
			
			if ((_willTriggerFlags & 0x04) != 0) {
				_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
			}
			if (_classicHandlers != null && _classicHandlers.onUpdate != null) {
				_classicHandlers.onUpdate.apply(null, _classicHandlers.onUpdateParams);
			}
			
			if (_isPlaying) {
				if (t >= _duration) {
					_position = _duration;
					if (_stopOnComplete) {
						_isPlaying = false;
						if ((_willTriggerFlags & 0x08) != 0) {
							_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
						}
						if (_classicHandlers != null && _classicHandlers.onComplete != null) {
							_classicHandlers.onComplete.apply(null, _classicHandlers.onCompleteParams);
						}
						return true;
					}
					else {
						if ((_willTriggerFlags & 0x08) != 0) {
							_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
						}
						if (_classicHandlers != null && _classicHandlers.onComplete != null) {
							_classicHandlers.onComplete.apply(null, _classicHandlers.onCompleteParams);
						}
						_position = t - _duration;
						_startTime = time - _position;
						tick(time);
					}
				}
				return false;
			}
			
			return true;
		}
		
		/**
		 * .
		 * 
		 * @param	time
		 */
		protected function internalUpdate(time:Number):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():ITween
		{
			var instance:AbstractTween = newInstance();
			if (instance != null) {
				instance.copyFrom(this);
			}
			return instance;
		}
		
		/**
		 * .
		 * 
		 * @return
		 */
		protected function newInstance():AbstractTween
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		protected function copyFrom(source:AbstractTween):void
		{
			_ticker = source._ticker;
			_duration = source._duration;
			_stopOnComplete = source._stopOnComplete;
			if (source._classicHandlers != null) {
				_classicHandlers = new ClassicHandlers();
				_classicHandlers.copyFrom(source._classicHandlers);
			}
			if (source._dispatcher != null) {
				_dispatcher = new ClonableEventDispatcher(this);
				_dispatcher.copyFrom(source._dispatcher);
			}
			_willTriggerFlags = source._willTriggerFlags
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (_dispatcher == null) {
				_dispatcher = new ClonableEventDispatcher(this);
			}
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			updateWillTriggerFlags();
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			if (_dispatcher != null) {
				return _dispatcher.dispatchEvent(event);
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			if (_dispatcher != null) {
				return _dispatcher.hasEventListener(type);
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (_dispatcher != null) {
				_dispatcher.removeEventListener(type, listener, useCapture);
				updateWillTriggerFlags();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean
		{
			if (_dispatcher != null) {
				return _dispatcher.willTrigger(type);
			}
			return false;
		}
		
		protected function updateWillTriggerFlags():void
		{
			if (_dispatcher.willTrigger(TweenEvent.PLAY)) {
				_willTriggerFlags |= 0x01;
			}
			else {
				_willTriggerFlags &= ~0x01;
			}
			if (_dispatcher.willTrigger(TweenEvent.STOP)) {
				_willTriggerFlags |= 0x02;
			}
			else {
				_willTriggerFlags &= ~0x02;
			}
			if (_dispatcher.willTrigger(TweenEvent.UPDATE)) {
				_willTriggerFlags |= 0x04;
			}
			else {
				_willTriggerFlags &= ~0x04;
			}
			if (_dispatcher.willTrigger(TweenEvent.COMPLETE)) {
				_willTriggerFlags |= 0x08;
			}
			else {
				_willTriggerFlags &= ~0x08;
			}
		}
	}
}

internal class ClassicHandlers
{
	public var onPlay:Function;
	public var onPlayParams:Array;
	public var onStop:Function;
	public var onStopParams:Array;
	public var onUpdate:Function;
	public var onUpdateParams:Array;
	public var onComplete:Function;
	public var onCompleteParams:Array;
	
	public function copyFrom(source:ClassicHandlers):void
	{
		onPlay = source.onPlay;
		onPlayParams = source.onPlayParams;
		onStop = source.onStop;
		onStopParams = source.onStopParams;
		onUpdate = source.onUpdate;
		onUpdateParams = source.onUpdateParams;
		onComplete = source.onComplete;
		onCompleteParams = source.onCompleteParams;
	}
}