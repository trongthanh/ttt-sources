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
package org.libspark.betweenas3.utils
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	/**
	 * 時間に関するユーティリティです.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class TimeUtil
	{
		private static var _defaultFrameRate:Number = 30.0;
		
		/**
		 * TimeUtil の変換メソッドで使用するデフォルトのフレームレートを設定します.
		 */
		public static function get defaultFrameRate():Number
		{
			return _defaultFrameRate;
		}
		
		/**
		 * @private
		 */
		public static function set defaultFrameRate(value:Number):void
		{
			_defaultFrameRate = value;
		}
		
		/**
		 * フレーム数を時間に変換します.
		 * 
		 * @param	frames	変換するフレーム数
		 * @param	frameRate	変換に使用するフレームレート
		 * @return	時間 (秒)
		 */
		public static function toTime(frames:Number, frameRate:Number = NaN):Number
		{
			return frames * (1.0 / (isNaN(frameRate) ? _defaultFrameRate : frameRate));
		}
		
		/**
		 * 時間をフレーム数に変換します.
		 * 
		 * @param	time	変換する時間 (秒)
		 * @param	frameRate	変換に使用するフレームレート
		 * @return	フレーム数
		 */
		public static function toFrames(time:Number, frameRate:Number = NaN):Number
		{
			return time / (1.0 / (isNaN(frameRate) ? _defaultFrameRate : frameRate));
		}
		
		/**
		 * 指定されたムービークリップの総フレーム数を時間に変換します.
		 * 
		 * @param	mc	ムービークリップ
		 * @param	frameRate	変換に使用するフレームレート
		 * @return	時間 (秒)
		 */
		public static function getTotalFramesTime(mc:MovieClip, frameRate:Number = NaN):Number
		{
			return toTime(mc.totalFrames, frameRate);
		}
		
		/**
		 * 指定されたムービークリップのラベルやフレーム間のフレーム数を時間に変換します.
		 * 
		 * @param	mc	ムービークリップ
		 * @param	labelOrFrame1	ラベルまたはフレーム数
		 * @param	labelOrFrame2	ラベルまたはフレーム数
		 * @param	frameRate	変換に使用するフレームレート
		 * @return	時間 (秒)
		 */
		public static function getFramesTimeBetween(mc:MovieClip, labelOrFrame1:Object, labelOrFrame2:Object, frameRate:Number = NaN):Number
		{
			var frame1:Number = getFrameNumber(mc, labelOrFrame1);
			var frame2:Number = getFrameNumber(mc, labelOrFrame2);
			if (isNaN(frame1) || isNaN(frame2)) {
				return NaN;
			}
			return toTime(Math.abs(frame2 - frame1), frameRate);
		}
		
		private static function getFrameNumber(mc:MovieClip, labelOrFrame:Object):Number
		{
			if (labelOrFrame is Number) {
				return Number(labelOrFrame);
			}
			var label:String = String(labelOrFrame);
			var labels:Array = mc.currentLabels;
			var l:uint = labels.length;
			for (var i:uint = 0; i < l; ++i) {
				if ((labels[i] as FrameLabel).name == label) {
					return (labels[i] as FrameLabel).frame;
				}
			}
			return NaN;
		}
	}
}