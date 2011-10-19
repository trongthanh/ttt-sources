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
	
	/**
	 * IIActionTween を実装するための抽象クラスです.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class AbstractActionTween extends AbstractTween implements IIActionTween
	{
		public function AbstractActionTween(ticker:ITicker)
		{
			super(ticker, 0);
			
			_duration = 0.01;
			_lastTime = -1;
		}
		
		private var _lastTime:Number;
		
		/**
		 * @inheritDoc
		 */
		override protected function internalUpdate(time:Number):void 
		{
			if (_lastTime < 0.01 && time >= 0.01) {
				action();
			}
			else if (_lastTime > 0 && time <= 0) {
				rollback();
			}
			_lastTime = time;
		}
		
		/**
		 * このメソッドをオーバーライドして実行する動作を記述します.
		 */
		protected function action():void
		{
			
		}
		
		/**
		 * このメソッドをオーバーライドして実行した動作を元に戻す処理を記述します.
		 */
		protected function rollback():void
		{
			
		}
	}
}