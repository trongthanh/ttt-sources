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
package org.libspark.betweenas3.core.ticker
{
	// 本当はインターフェイスのほうが好ましいのだけど速度とメモリ的な理由からクラスで。
	
	/**
	 * 更新のタイミングを受け取るためのリスナー.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class TickerListener
	{
		/**
		 * ひとつ前のリスナーを設定します.
		 * 双方向リンクリストのために内部的に使用されます。
		 */
		public var prevListener:TickerListener = null;
		
		/**
		 * ひとつ後のリスナーを設定します.
		 * 双方向リンクリストのために内部的に使用されます。
		 */
		public var nextListener:TickerListener = null;
		
		/**
		 * 指定された時間に基づいて処理を行うべき時に呼び出されるコールバック.
		 * 
		 * @param	time	時間 (秒)
		 * @return	このリスナの処理が完了し今後コールバックを受け取る必要がないのであれば true, そうでなければ false.
		 */
		public function tick(time:Number):Boolean
		{
			return false;
		}
	}
}