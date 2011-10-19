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
package org.libspark.betweenas3
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.core.easing.IPhysicalEasing;
	import org.libspark.betweenas3.core.ticker.ITicker;
	import org.libspark.betweenas3.core.tweens.actions.AddChildAction;
	import org.libspark.betweenas3.core.tweens.actions.FunctionAction;
	import org.libspark.betweenas3.core.tweens.actions.RemoveFromParentAction;
	import org.libspark.betweenas3.core.tweens.decorators.DelayedTween;
	import org.libspark.betweenas3.core.tweens.decorators.RepeatedTween;
	import org.libspark.betweenas3.core.tweens.decorators.ReversedTween;
	import org.libspark.betweenas3.core.tweens.decorators.ScaledTween;
	import org.libspark.betweenas3.core.tweens.decorators.SlicedTween;
	import org.libspark.betweenas3.core.tweens.groups.ParallelTween;
	import org.libspark.betweenas3.core.tweens.groups.SerialTween;
	import org.libspark.betweenas3.core.tweens.IITween;
	import org.libspark.betweenas3.core.tweens.ObjectTween;
	import org.libspark.betweenas3.core.tweens.PhysicalTween;
	import org.libspark.betweenas3.core.tweens.TweenDecorator;
	import org.libspark.betweenas3.core.updaters.BezierUpdater;
	import org.libspark.betweenas3.core.updaters.display.DisplayObjectUpdater;
	import org.libspark.betweenas3.core.updaters.display.MovieClipUpdater;
	import org.libspark.betweenas3.core.updaters.geom.PointUpdater;
	import org.libspark.betweenas3.core.updaters.ObjectUpdater;
	import org.libspark.betweenas3.core.updaters.UpdaterFactory;
	import org.libspark.betweenas3.core.utils.ClassRegistry;
	import org.libspark.betweenas3.easing.Linear;
	import org.libspark.betweenas3.easing.Physical;
	import org.libspark.betweenas3.tickers.EnterFrameTicker;
	import org.libspark.betweenas3.tweens.IObjectTween;
	import org.libspark.betweenas3.tweens.ITween;
	import org.libspark.betweenas3.tweens.ITweenGroup;
	
	// 新しい ITween, ITweenTarget 実装クラスを作った場合、BetweenAS3 クラスにメソッド追加するのは無理なので、
	// HogeTween.hoge(t).play(); という形でそのクラス自体にファクトリメソッドを用意してもらう感じにする (暫定)。
	// そのとき必要になりそうなユーティリティメソッドは BetweenAS3 側で用意する。
	
	// SmartRotation は smartRotation という特殊プロパティを用意する。
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class BetweenAS3
	{
		public static const VERSION:String = '0.2 (Alpha)';
		
		// TODO
		// SmartRotation
		// frame based
		
		// とりあえず
		
		private static var _ticker:ITicker;
		private static var _updaterClassRegistry:ClassRegistry;
		private static var _updaterFactory:UpdaterFactory;
		
		{
			_ticker = new EnterFrameTicker();
			_ticker.start();
			
			_updaterClassRegistry = new ClassRegistry();
			_updaterFactory = new UpdaterFactory(_updaterClassRegistry);
			
			ObjectUpdater.register(_updaterClassRegistry);
			DisplayObjectUpdater.register(_updaterClassRegistry);
			MovieClipUpdater.register(_updaterClassRegistry);
			PointUpdater.register(_updaterClassRegistry);
		}
		
		/**
		 * 新しいトゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	to	トゥイーンの終了値
		 * @param	from	トゥイーンの開始値
		 * @param	time	トゥイーンに掛ける時間
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function tween(target:Object, to:Object, from:Object = null, time:Number = 1.0, easing:IEasing = null):IObjectTween
		{
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.create(target, to, from);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * 新しいトゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	to	トゥイーンの終了値
		 * @param	time	トゥイーンに掛ける時間
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function to(target:Object, to:Object, time:Number = 1.0, easing:IEasing = null):IObjectTween
		{
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.create(target, to, null);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * 新しいトゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	from	トゥイーンの開始値
		 * @param	time	トゥイーンに掛ける時間
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function from(target:Object, from:Object, time:Number = 1.0, easing:IEasing = null):IObjectTween
		{
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.create(target, null, from);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * 指定されたオブジェクトにトゥイーンの値を適用します.
		 * 
		 * @param	target	対象となるオブジェクト
		 * @param	to	トゥイーンの終了値
		 * @param	from	トゥイーンの開始値
		 * @param	time	トゥイーンに掛ける時間
		 * @param	applyTime	適用する時間
		 * @param	easing	トゥイーンに使用するイージング
		 */
		public static function apply(target:Object, to:Object, from:Object = null, time:Number = 1.0, applyTime:Number = 1.0, easing:IEasing = null):void
		{
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.create(target, to, from);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			tween.update(applyTime);
		}
		
		/**
		 * 新しいベジェトゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	to	トゥイーンの終了値
		 * @param	from	トゥイーンの開始値
		 * @param	controlPoint	コントロールポイント
		 * @param	time	トゥイーンに掛ける時間
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function bezier(target:Object, to:Object, from:Object = null, controlPoint:Object = null, time:Number = 1.0, easing:IEasing = null):IObjectTween
		{
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.createBezier(target, to, from, controlPoint);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * 新しいベジェトゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	to	トゥイーンの終了値
		 * @param	controlPoint	コントロールポイント
		 * @param	time	トゥイーンに掛ける時間
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function bezierTo(target:Object, to:Object, controlPoint:Object = null, time:Number = 1.0, easing:IEasing = null):IObjectTween
		{
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.createBezier(target, to, null, controlPoint);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * 新しいベジェトゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	from	トゥイーンの開始値
		 * @param	controlPoint	コントロールポイント
		 * @param	time	トゥイーンに掛ける時間
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function bezierFrom(target:Object, from:Object, controlPoint:Object = null, time:Number = 1.0, easing:IEasing = null):IObjectTween
		{
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.createBezier(target, null, from, controlPoint);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * 新しい物理トゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	to	トゥイーンの終了値
		 * @param	from	トゥイーンの開始値
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function physical(target:Object, to:Object, from:Object = null, easing:IPhysicalEasing = null):IObjectTween
		{
			var tween:PhysicalTween = new PhysicalTween(_ticker);
			tween.updater = _updaterFactory.createPhysical(target, to, from, easing || Physical.exponential());
			return tween;
		}
		
		/**
		 * 新しい物理トゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	to	トゥイーンの終了値
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function physicalTo(target:Object, to:Object, easing:IPhysicalEasing = null):IObjectTween
		{
			var tween:PhysicalTween = new PhysicalTween(_ticker);
			tween.updater = _updaterFactory.createPhysical(target, to, null, easing || Physical.exponential());
			return tween;
		}
		
		/**
		 * 新しい物理トゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	from	トゥイーンの開始値
		 * @param	easing	トゥイーンに使用するイージング
		 * @return	作成されたトゥイーン
		 */
		public static function physicalFrom(target:Object, from:Object, easing:IPhysicalEasing = null):IObjectTween
		{
			var tween:PhysicalTween = new PhysicalTween(_ticker);
			tween.updater = _updaterFactory.createPhysical(target, null, from, easing || Physical.exponential());
			return tween;
		}
		
		/**
		 * 指定されたオブジェクトに物理トゥイーンの値を適用します.
		 * 
		 * @param	target	対象となるオブジェクト
		 * @param	to	トゥイーンの終了値
		 * @param	from	トゥイーンの開始値
		 * @param	applyTime	適用する時間
		 * @param	easing	トゥイーンに使用するイージング
		 */
		public static function physicalApply(target:Object, to:Object, from:Object = null, applyTime:Number = 1.0, easing:IPhysicalEasing = null):void
		{
			var tween:PhysicalTween = new PhysicalTween(_ticker);
			tween.updater = _updaterFactory.createPhysical(target, to, from, easing || Physical.exponential());
			tween.update(applyTime);
		}
		
		/**
		 * 指定さたトゥイーンを結合して、同時に実行するトゥイーンを作成します.
		 * 
		 * @param	...tweens	結合するトゥイーン
		 * @return	作成されたトゥイーン
		 */
		public static function parallel(...tweens:Array):ITweenGroup
		{
			return parallelTweens(tweens);
		}
		
		/**
		 * 指定された配列内のトゥイーンを結合して、同時に実行するトゥイーンを作成します.
		 * 
		 * @param	tweens	結合するトゥイーンの配列
		 * @return	作成されたトゥイーン
		 */
		public static function parallelTweens(tweens:Array):ITweenGroup
		{
			return new ParallelTween(tweens, _ticker, 0);
		}
		
		/**
		 * 指定さたトゥイーンを結合して、順番に実行するトゥイーンを作成します.
		 * 
		 * @param	...tweens	結合するトゥイーン
		 * @return	作成されたトゥイーン
		 */
		public static function serial(...tweens:Array):ITweenGroup
		{
			return serialTweens(tweens);
		}
		
		/**
		 * 指定された配列内のトゥイーンを結合して、順番に実行するトゥイーンを作成します.
		 * 
		 * @param	tweens	結合するトゥイーンの配列
		 * @return	作成されたトゥイーン
		 */
		public static function serialTweens(tweens:Array):ITweenGroup
		{
			return new SerialTween(tweens, _ticker, 0);
		}
		
		/**
		 * 指定されたトゥイーンを逆にしたトゥイーンを作成します.
		 * 
		 * @param	tween	元となるトゥイーン
		 * @param	reversePosition	作成されたトゥイーンが元となるトゥイーンと同じ位置を指すようポジションを設定するのであれば true そうでなければ false
		 * @return	作成されたトゥイーン
		 */
		public static function reverse(tween:ITween, reversePosition:Boolean = true):ITween
		{
			var pos:Number = reversePosition ? tween.duration - tween.position : 0.0;
			if (tween is ReversedTween) {
				return new TweenDecorator((tween as ReversedTween).baseTween, pos);
			}
			if ((tween as Object).constructor == TweenDecorator) {
				tween = (tween as TweenDecorator).baseTween;
			}
			return new ReversedTween(tween as IITween, pos);
		}
		
		/**
		 * 指定されたトゥイーンを繰り返したトゥイーンを作成します.
		 * 
		 * @param	tween	元となるトゥイーン
		 * @param	repeatCount	繰り返す回数
		 * @return	作成されたトゥイーン
		 */
		public static function repeat(tween:ITween, repeatCount:uint):ITween
		{
			return new RepeatedTween(tween as IITween, repeatCount);
		}
		
		/**
		 * 指定されたトゥイーンをタイムスケールしたトゥイーンを作成します.
		 * 
		 * @param	tween	元となるトゥイーン
		 * @param	scale	スケール値
		 * @return	作成されたトゥイーン
		 */
		public static function scale(tween:ITween, scale:Number):ITween
		{
			return new ScaledTween(tween as IITween, scale);
		}
		
		/**
		 * 指定されたトゥイーンの一部分を切り出したトゥイーンを作成します.
		 * 
		 * @param	tween	元となるトゥイーン
		 * @param	begin	切り出しの開始時間
		 * @param	end	切り出しの終了時間
		 * @param	isPercent	切り出しの時間を元のトゥイーンにかかる時間に対する割合で指定するのであれば true そうでなければ false
		 * @return	作成されたトゥイーン
		 */
		public static function slice(tween:ITween, begin:Number, end:Number, isPercent:Boolean = false):ITween
		{
			if (isPercent) {
				begin = tween.duration * begin;
				end = tween.duration * end;
			}
			if (begin > end) {
				return new ReversedTween(new SlicedTween(tween as IITween, end, begin), 0);
			}
			return new SlicedTween(tween as IITween, begin, end);
		}
		
		/**
		 * 指定されたトゥイーンに遅延を加えたトゥイーンを作成します.
		 * 
		 * @param	tween	元となるトゥイーン
		 * @param	delay	トゥイーン前の遅延時間
		 * @param	postDelay	トゥイーン後の遅延時間
		 * @return	作成されたトゥイーン
		 */
		public static function delay(tween:ITween, delay:Number, postDelay:Number = 0.0):ITween
		{
			return new DelayedTween(tween as IITween, delay, postDelay);
		}
		
		/**
		 * 指定された DislayObjectContainer に DisplayObject を追加するトゥイーンを作成します.
		 * 
		 * @param	target	DisplayObjectContainer に追加される DisplayObject
		 * @param	parent	DisplayObject を追加する DisplayObjectContainer
		 * @return	作成されたトゥイーン
		 */
		public static function addChild(target:DisplayObject, parent:DisplayObjectContainer):ITween
		{
			return new AddChildAction(_ticker, target, parent);
		}
		
		/**
		 * 指定された DisplayObject の親から DisplayObject を削除するトゥイーンを作成します.
		 * 
		 * @param	target	親から削除する DisplayObject
		 * @return	作成されたトゥイーン
		 */
		public static function removeFromParent(target:DisplayObject):ITween
		{
			return new RemoveFromParentAction(_ticker, target);
		}
		
		/**
		 * 指定された関数を実行するトゥイーンを作成します.
		 * 
		 * @param	func	実行する関数
		 * @param	params	実行する関数に渡す引数
		 * @param	useRollback	ロールバック時に関数を実行するのであれば true そうでなければ false
		 * @param	rollbackFunc	ロールバック時に実行する関数
		 * @param	rollbackParams	ロールバック時に実行する関数に渡す引数
		 * @return
		 */
		public static function func(func:Function, params:Array = null, useRollback:Boolean = false, rollbackFunc:Function = null, rollbackParams:Array = null):ITween
		{
			return new FunctionAction(_ticker, func, params, useRollback, rollbackFunc, rollbackParams);
		}
	}
}