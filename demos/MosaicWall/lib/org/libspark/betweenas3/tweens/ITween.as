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
package org.libspark.betweenas3.tweens
{
	import flash.events.IEventDispatcher;
	
	// EventDispatcher は委譲 & 遅延生成で実装しましょう。
	
	/**
	 * トゥイーン及びその制御.
	 * 
	 * @author	yossy:beinteractive
	 */
	public interface ITween extends IEventDispatcher
	{
		/**
		 * このトゥイーンの継続時間 (秒) を返します.
		 */
		function get duration():Number;
		
		/**
		 * このトゥイーンの現在位置 (秒) を返します.
		 */
		function get position():Number;
		
		/**
		 * このトゥイーンが現在再生中であれば true, そうでなければ false を返します.
		 */
		function get isPlaying():Boolean;
		
		/**
		 * このトゥイーンの完了時に再生を停止するのであれば true, そうでなければ false を設定します.
		 */
		function get stopOnComplete():Boolean;
		
		/**
		 * @private
		 */
		function set stopOnComplete(value:Boolean):void;
		
		function get onPlay():Function;
		function set onPlay(value:Function):void;
		function get onPlayParams():Array;
		function set onPlayParams(value:Array):void;
		function get onStop():Function;
		function set onStop(value:Function):void;
		function get onStopParams():Array;
		function set onStopParams(value:Array):void;
		function get onUpdate():Function;
		function set onUpdate(value:Function):void;
		function get onUpdateParams():Array;
		function set onUpdateParams(value:Array):void;
		function get onComplete():Function;
		function set onComplete(value:Function):void;
		function get onCompleteParams():Array;
		function set onCompleteParams(value:Array):void;
		
		/**
		 * このトゥイーンの再生を現在の位置から開始します.
		 */
		function play():void;
		
		/**
		 * このトゥイーンの再生を現在の位置で停止します.
		 */
		function stop():void;
		
		/**
		 * このトゥイーンの再生を一時停止または再開します.
		 */
		function togglePause():void;
		
		/**
		 * このトゥイーンの再生を指定された位置から開始します.
		 * 
		 * @param	position	再生を開始する位置 (秒)
		 */
		function gotoAndPlay(position:Number):void;
		
		/**
		 * このトゥイーンの再生を指定された位置で停止します.
		 * 
		 * @param	position	再生を停止する位置 (秒)
		 */
		function gotoAndStop(position:Number):void;
		
		/**
		 * この ITween のクローンを生成して返します.
		 * 
		 * @return	この ITween のクローン
		 */
		function clone():ITween;
	}
}