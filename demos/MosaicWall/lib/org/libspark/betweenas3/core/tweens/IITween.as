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
	import org.libspark.betweenas3.core.ticker.ITicker;
	import org.libspark.betweenas3.tweens.ITween;
	
	// BetweenAS3 の「トゥイーンの加工」は IITween が肝になる。
	// 末端は IIObjectTween で、それを他の IITween 実装クラスでデコレートすることで
	// トゥイーンの振る舞いを様々に変化させる。
	
	/**
	 * ITween 完全版.
	 * 
	 * @author	yossy:beinteractive
	 */
	public interface IITween extends ITween
	{
		/**
		 * .
		 */
		function get ticker():ITicker;
		
		/**
		 * .
		 */
		function firePlay():void;
		
		/**
		 * .
		 */
		function fireStop():void;
		
		/**
		 * このトゥイーンを指定された時間の状態に更新します.
		 * 
		 * @param	time	時間 (秒)
		 */
		function update(time:Number):void;
	}
}