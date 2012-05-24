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
package org.libspark.betweenas3.core.updaters.display
{
	import flash.display.MovieClip;
	import org.libspark.betweenas3.core.updaters.AbstractUpdater;
	import org.libspark.betweenas3.core.utils.ClassRegistry;
	
	/**
	 * MovieClip を対象とした IUpdater の実装です.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class MovieClipUpdater extends AbstractUpdater
	{
		public static const TARGET_PROPERTIES:Array = [
			'_frame',
		];
		
		public static function register(registry:ClassRegistry):void
		{
			registry.registerClassWithTargetClassAndPropertyNames(MovieClipUpdater, MovieClip, TARGET_PROPERTIES);
		}
		
		protected var _target:MovieClip = null;
		protected var _source:MovieClipParameter = new MovieClipParameter();
		protected var _destination:MovieClipParameter = new MovieClipParameter();
		protected var _flags:uint = 0;
		
		/**
		 * @inheritDoc
		 */
		override public function get target():Object
		{
			return _target;
		}
		
		/**
		 * @private
		 */
		override public function set target(value:Object):void
		{
			_target = value as MovieClip;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			if (propertyName == '_frame') {
				_flags |= 0x0001;
				_source.relativeFlags |= isRelative ? 0x0001 : 0;
				_source.frame = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			if (propertyName == '_frame') {
				_flags |= 0x0001;
				_destination.relativeFlags |= isRelative ? 0x0001 : 0;
				_destination.frame = value;
			}
		}
		
		override protected function resolveValues():void 
		{
			var t:MovieClip = _target, d:MovieClipParameter = _destination, s:MovieClipParameter = _source, f:uint = _flags;
			
			if ((f & 0x0001) != 0) {
				if (isNaN(s.frame)) {
					s.frame = t.currentFrame;
				}
				else if ((s.relativeFlags & 0x0001) != 0) {
					s.frame += t.currentFrame;
				}
				if (isNaN(d.frame)) {
					d.frame = t.currentFrame;
				}
				else if ((d.relativeFlags & 0x0001) != 0) {
					d.frame += t.currentFrame;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateObject(factor:Number):void 
		{
			var t:MovieClip = _target, d:MovieClipParameter = _destination, s:MovieClipParameter = _source, f:uint = _flags;
			
			var invert:Number = 1.0 - factor;
			
			if ((f & 0x0001) != 0) {
				t.gotoAndStop(Math.round(s.frame * invert + d.frame * factor));
			}
		}
		
		override protected function newInstance():AbstractUpdater 
		{
			return new MovieClipUpdater();
		}
		
		override protected function copyFrom(source:AbstractUpdater):void 
		{
			super.copyFrom(source);
			
			var obj:MovieClipUpdater = source as MovieClipUpdater;
			
			_target = obj._target;
			_source.copyFrom(obj._source);
			_destination.copyFrom(obj._destination);
			_flags = obj._flags;
		}
	}
}

internal class MovieClipParameter
{
	public var relativeFlags:uint = 0;
	public var frame:Number;
	
	public function copyFrom(obj:MovieClipParameter):void
	{
		relativeFlags = obj.relativeFlags;
		frame = obj.frame;
	}
}