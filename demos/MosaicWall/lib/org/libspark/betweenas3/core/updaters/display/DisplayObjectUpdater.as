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
	import flash.display.DisplayObject;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.filters.GradientGlowFilter;
//	import flash.filters.ShaderFilter;
	import org.libspark.betweenas3.core.updaters.AbstractUpdater;
	import org.libspark.betweenas3.core.utils.ClassRegistry;
	
	/**
	 * DisplayObject を対象とした IUpdater の実装です.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class DisplayObjectUpdater extends AbstractUpdater
	{
		public static const TARGET_PROPERTIES:Array = [
			'x',
			'y',
//			'z',
			'scaleX',
			'scaleY',
//			'scaleZ',
			'rotation',
//			'rotationX',
//			'rotationY',
//			'rotationZ',
			'alpha',
			'width',
			'height',
			'_bevelFilter',
			'_blurFilter',
			'_colorMatrixFilter',
			'_convolutionFilter',
			'_displacementMapFilter',
			'_dropShadowFilter',
			'_glowFilter',
			'_gradientBevelFilter',
			'_gradientGlowFilter',
//			'_shaderFilter',
		];
		
		public static function register(registry:ClassRegistry):void
		{
			registry.registerClassWithTargetClassAndPropertyNames(DisplayObjectUpdater, DisplayObject, TARGET_PROPERTIES);
		}
		
		protected var _target:DisplayObject = null;
		protected var _source:DisplayObjectParameter = new DisplayObjectParameter();
		protected var _destination:DisplayObjectParameter = new DisplayObjectParameter();
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
			_target = value as DisplayObject;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			if (propertyName == 'x') {
				_flags |= 0x0001;
				_source.relativeFlags |= isRelative ? 0x0001 : 0;
				_source.x = value;
			}
			else if (propertyName == 'y') {
				_flags |= 0x0002;
				_source.relativeFlags |= isRelative ? 0x0002 : 0;
				_source.y = value;
			}
//			else if (propertyName == 'z') {
//				_flags |= 0x0004;
//				_source.relativeFlags |= isRelative ? 0x0004 : 0;
//				_source.z = value;
//			}
			else if (propertyName == 'scaleX') {
				_flags |= 0x0008;
				_source.relativeFlags |= isRelative ? 0x0008 : 0;
				_source.scaleX = value;
			}
			else if (propertyName == 'scaleY') {
				_flags |= 0x0010;
				_source.relativeFlags |= isRelative ? 0x0010 : 0;
				_source.scaleY = value;
			}
//			else if (propertyName == 'scaleZ') {
//				_flags |= 0x0020;
//				_source.relativeFlags |= isRelative ? 0x0020 : 0;
//				_source.scaleZ = value;
//			}
			else if (propertyName == 'rotation') {
				_flags |= 0x0040;
				_source.relativeFlags |= isRelative ? 0x0040 : 0;
				_source.rotation = value;
			}
//			else if (propertyName == 'rotationX') {
//				_flags |= 0x0080;
//				_source.relativeFlags |= isRelative ? 0x0080 : 0;
//				_source.rotationX = value;
//			}
//			else if (propertyName == 'rotationY') {
//				_flags |= 0x0100;
//				_source.relativeFlags |= isRelative ? 0x0100 : 0;
//				_source.rotationY = value;
//			}
//			else if (propertyName == 'rotationZ') {
//				_flags |= 0x0200;
//				_source.relativeFlags |= isRelative ? 0x0200 : 0;
//				_source.rotationZ = value;
//			}
			else if (propertyName == 'alpha') {
				_flags |= 0x0400;
				_source.relativeFlags |= isRelative ? 0x0400 : 0;
				_source.alpha = value;
			}
			else if (propertyName == 'width') {
				_flags |= 0x0800;
				_source.relativeFlags |= isRelative ? 0x0800 : 0;
				_source.width = value;
			}
			else if (propertyName == 'height') {
				_flags |= 0x1000;
				_source.relativeFlags |= isRelative ? 0x1000 : 0;
				_source.height = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			if (propertyName == 'x') {
				_flags |= 0x0001;
				_destination.relativeFlags |= isRelative ? 0x0001 : 0;
				_destination.x = value;
			}
			else if (propertyName == 'y') {
				_flags |= 0x0002;
				_destination.relativeFlags |= isRelative ? 0x0002 : 0;
				_destination.y = value;
			}
//			else if (propertyName == 'z') {
//				_flags |= 0x0004;
//				_destination.relativeFlags |= isRelative ? 0x0004 : 0;
//				_destination.z = value;
//			}
			else if (propertyName == 'scaleX') {
				_flags |= 0x0008;
				_destination.relativeFlags |= isRelative ? 0x0008 : 0;
				_destination.scaleX = value;
			}
			else if (propertyName == 'scaleY') {
				_flags |= 0x0010;
				_destination.relativeFlags |= isRelative ? 0x0010 : 0;
				_destination.scaleY = value;
			}
//			else if (propertyName == 'scaleZ') {
//				_flags |= 0x0020;
//				_destination.relativeFlags |= isRelative ? 0x0020 : 0;
//				_destination.scaleZ = value;
//			}
			else if (propertyName == 'rotation') {
				_flags |= 0x0040;
				_destination.relativeFlags |= isRelative ? 0x0040 : 0;
				_destination.rotation = value;
			}
//			else if (propertyName == 'rotationX') {
//				_flags |= 0x0080;
//				_destination.relativeFlags |= isRelative ? 0x0080 : 0;
//				_destination.rotationX = value;
//			}
//			else if (propertyName == 'rotationY') {
//				_flags |= 0x0100;
//				_destination.relativeFlags |= isRelative ? 0x0100 : 0;
//				_destination.rotationY = value;
//			}
//			else if (propertyName == 'rotationZ') {
//				_flags |= 0x0200;
//				_destination.relativeFlags |= isRelative ? 0x0200 : 0;
//				_destination.rotationZ = value;
//			}
			else if (propertyName == 'alpha') {
				_flags |= 0x0400;
				_destination.relativeFlags |= isRelative ? 0x0400 : 0;
				_destination.alpha = value;
			}
			else if (propertyName == 'width') {
				_flags |= 0x0800;
				_destination.relativeFlags |= isRelative ? 0x0800 : 0;
				_destination.width = value;
			}
			else if (propertyName == 'height') {
				_flags |= 0x1000;
				_destination.relativeFlags |= isRelative ? 0x1000 : 0;
				_destination.height = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getObject(propertyName:String):Object
		{
			if (propertyName == '_blurFilter') {
				return getFilterByClass(BlurFilter);
			}
			if (propertyName == '_glowFilter') {
				return getFilterByClass(GlowFilter);
			}
			if (propertyName == '_dropShadowFilter') {
				return getFilterByClass(DropShadowFilter);
			}
			if (propertyName == '_colorMatrixFilter') {
				return getFilterByClass(ColorMatrixFilter);
			}
			if (propertyName == '_bevelFilter') {
				return getFilterByClass(BevelFilter);
			}
			if (propertyName == '_gradientGlowFilter') {
				return getFilterByClass(GradientGlowFilter);
			}
			if (propertyName == '_gradientBevelFilter') {
				return getFilterByClass(GradientBevelFilter);
			}
			if (propertyName == '_convolutionFilter') {
				return getFilterByClass(ConvolutionFilter);
			}
			if (propertyName == '_displacementMapFilter') {
				return getFilterByClass(DisplacementMapFilter);
			}
//			if (propertyName == '_shaderFilter') {
//				return getFilterByClass(ShaderFilter);
//			}
			return null;
		}
		
		protected function getFilterByClass(klass:Class):BitmapFilter
		{
			var filter:BitmapFilter = null;
			var filters:Array = _target.filters;
			var l:uint = filters.length;
			for (var i:uint = 0; i < l; ++i) {
				if ((filter = filters[i] as BitmapFilter) is klass) {
					return filter;
				}
			}
			filter = new klass();
			filters.push(filter);
			_target.filters = filters;
			return filter;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setObject(propertyName:String, value:Object):void
		{
			if (propertyName == '_blurFilter') {
				setFilterByClass(value as BitmapFilter, BlurFilter);
				return;
			}
			if (propertyName == '_glowFilter') {
				setFilterByClass(value as BitmapFilter, GlowFilter);
				return;
			}
			if (propertyName == '_dropShadowFilter') {
				setFilterByClass(value as BitmapFilter, DropShadowFilter);
				return;
			}
			if (propertyName == '_colorMatrixFilter') {
				setFilterByClass(value as BitmapFilter, ColorMatrixFilter);
				return;
			}
			if (propertyName == '_bevelFilter') {
				setFilterByClass(value as BitmapFilter, BevelFilter);
				return;
			}
			if (propertyName == '_gradientGlowFilter') {
				setFilterByClass(value as BitmapFilter, GradientGlowFilter);
				return;
			}
			if (propertyName == '_gradientBevelFilter') {
				setFilterByClass(value as BitmapFilter, GradientBevelFilter);
				return;
			}
			if (propertyName == '_convolutionFilter') {
				setFilterByClass(value as BitmapFilter, ConvolutionFilter);
				return;
			}
			if (propertyName == '_displacementMapFilter') {
				setFilterByClass(value as BitmapFilter, DisplacementMapFilter);
				return;
			}
//			if (propertyName == '_shaderFilter') {
//				setFilterByClass(value as BitmapFilter, ShaderFilter);
//				return;
//			}
		}
		
		protected function setFilterByClass(filter:BitmapFilter, klass:Class):void
		{
			var filters:Array = _target.filters;
			var l:uint = filters.length;
			for (var i:uint = 0; i < l; ++i) {
				if (filters[i] is klass) {
					filters[i] = filter;
					_target.filters = filters;
					return;
				}
			}
			filters.push(filter);
			_target.filters = filters;
		}
		
		override protected function resolveValues():void 
		{
			var t:DisplayObject = _target, d:DisplayObjectParameter = _destination, s:DisplayObjectParameter = _source, f:uint = _flags;
			
			if ((f & 0x0001) != 0) {
				if (isNaN(s.x)) {
					s.x = t.x;
				}
				else if ((s.relativeFlags & 0x0001) != 0) {
					s.x += t.x;
				}
				if (isNaN(d.x)) {
					d.x = t.x;
				}
				else if ((d.relativeFlags & 0x0001) != 0) {
					d.x += t.x;
				}
			}
			if ((f & 0x0002) != 0) {
				if (isNaN(s.y)) {
					s.y = t.y;
				}
				else if ((s.relativeFlags & 0x0002) != 0) {
					s.y += t.y;
				}
				if (isNaN(d.y)) {
					d.y = t.y;
				}
				else if ((d.relativeFlags & 0x0002) != 0) {
					d.y += t.y;
				}
			}
//			if ((f & 0x0004) != 0) {
//				if (isNaN(s.z)) {
//					s.z = t.z;
//				}
//				else if ((s.relativeFlags & 0x0004) != 0) {
//					s.z += t.z;
//				}
//				if (isNaN(d.z)) {
//					d.z = t.z;
//				}
//				else if ((d.relativeFlags & 0x0004) != 0) {
//					d.z += t.z;
//				}
//			}
			if ((f & 0x0008) != 0) {
				if (isNaN(s.scaleX)) {
					s.scaleX = t.scaleX;
				}
				else if ((s.relativeFlags & 0x0008) != 0) {
					s.scaleX += t.scaleX;
				}
				if (isNaN(d.scaleX)) {
					d.scaleX = t.scaleX;
				}
				else if ((d.relativeFlags & 0x0008) != 0) {
					d.scaleX += t.scaleX;
				}
			}
			if ((f & 0x0010) != 0) {
				if (isNaN(s.scaleY)) {
					s.scaleY = t.scaleY;
				}
				else if ((s.relativeFlags & 0x0010) != 0) {
					s.scaleY += t.scaleY;
				}
				if (isNaN(d.scaleY)) {
					d.scaleY = t.scaleY;
				}
				else if ((d.relativeFlags & 0x0010) != 0) {
					d.scaleY += t.scaleY;
				}
			}
//			if ((f & 0x0020) != 0) {
//				if (isNaN(s.scaleZ)) {
//					s.scaleZ = t.scaleZ;
//				}
//				else if ((s.relativeFlags & 0x0020) != 0) {
//					s.scaleZ += t.scaleZ;
//				}
//				if (isNaN(d.scaleZ)) {
//					d.scaleZ = t.scaleZ;
//				}
//				else if ((d.relativeFlags & 0x0020) != 0) {
//					d.scaleZ += t.scaleZ;
//				}
//			}
			if ((f & 0x0040) != 0) {
				if (isNaN(s.rotation)) {
					s.rotation = t.rotation;
				}
				else if ((s.relativeFlags & 0x0040) != 0) {
					s.rotation += t.rotation;
				}
				if (isNaN(d.rotation)) {
					d.rotation = t.rotation;
				}
				else if ((d.relativeFlags & 0x0040) != 0) {
					d.rotation += t.rotation;
				}
			}
//			if ((f & 0x0080) != 0) {
//				if (isNaN(s.rotationX)) {
//					s.rotationX = t.rotationX;
//				}
//				else if ((s.relativeFlags & 0x0080) != 0) {
//					s.rotationX += t.rotationX;
//				}
//				if (isNaN(d.rotationX)) {
//					d.rotationX = t.rotationX;
//				}
//				else if ((d.relativeFlags & 0x0080) != 0) {
//					d.rotationX += t.rotationX;
//				}
//			}
//			if ((f & 0x0100) != 0) {
//				if (isNaN(s.rotationY)) {
//					s.rotationY = t.rotationY;
//				}
//				else if ((s.relativeFlags & 0x0100) != 0) {
//					s.rotationY += t.rotationY;
//				}
//				if (isNaN(d.rotationY)) {
//					d.rotationY = t.rotationY;
//				}
//				else if ((d.relativeFlags & 0x0100) != 0) {
//					d.rotationY += t.rotationY;
//				}
//			}
//			if ((f & 0x0200) != 0) {
//				if (isNaN(s.rotationZ)) {
//					s.rotationZ = t.rotationZ;
//				}
//				else if ((s.relativeFlags & 0x0200) != 0) {
//					s.rotationZ += t.rotationZ;
//				}
//				if (isNaN(d.rotationZ)) {
//					d.rotationZ = t.rotationZ;
//				}
//				else if ((d.relativeFlags & 0x0200) != 0) {
//					d.rotationZ += t.rotationZ;
//				}
//			}
			if ((f & 0x0400) != 0) {
				if (isNaN(s.alpha)) {
					s.alpha = t.alpha;
				}
				else if ((s.relativeFlags & 0x0400) != 0) {
					s.alpha += t.alpha;
				}
				if (isNaN(d.alpha)) {
					d.alpha = t.alpha;
				}
				else if ((d.relativeFlags & 0x0400) != 0) {
					d.alpha += t.alpha;
				}
			}
			if ((f & 0x0800) != 0) {
				if (isNaN(s.width)) {
					s.width = t.width;
				}
				else if ((s.relativeFlags & 0x0800) != 0) {
					s.width += t.width;
				}
				if (isNaN(d.width)) {
					d.width = t.width;
				}
				else if ((d.relativeFlags & 0x0800) != 0) {
					d.width += t.width;
				}
			}
			if ((f & 0x1000) != 0) {
				if (isNaN(s.height)) {
					s.height = t.height;
				}
				else if ((s.relativeFlags & 0x1000) != 0) {
					s.height += t.height;
				}
				if (isNaN(d.height)) {
					d.height = t.height;
				}
				else if ((d.relativeFlags & 0x1000) != 0) {
					d.height += t.height;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateObject(factor:Number):void 
		{
			var t:DisplayObject = _target, d:DisplayObjectParameter = _destination, s:DisplayObjectParameter = _source, f:uint = _flags;
			
			var invert:Number = 1.0 - factor;
			
			if ((f & 0x0001) != 0) {
				t.x = s.x * invert + d.x * factor;
			}
			if ((f & 0x0002) != 0) {
				t.y = s.y * invert + d.y * factor;
			}
//			if ((f & 0x0004) != 0) {
//				t.z = s.z * invert + d.z * factor;
//			}
			if ((f & 0x0038) != 0) {
				if ((f & 0x0008) != 0) {
					t.scaleX = s.scaleX * invert + d.scaleX * factor;
				}
				if ((f & 0x0010) != 0) {
					t.scaleY = s.scaleY * invert + d.scaleY * factor;
				}
//				if ((f & 0x0020) != 0) {
//					t.scaleZ = s.scaleZ * invert + d.scaleZ * factor;
//				}
			}
			if ((f & 0x03c0) != 0) {
				if ((f & 0x0040) != 0) {
					t.rotation = s.rotation * invert + d.rotation * factor;
				}
//				if ((f & 0x0080) != 0) {
//					t.rotationX = s.rotationX * invert + d.rotationX * factor;
//				}
//				if ((f & 0x0100) != 0) {
//					t.rotationY = s.rotationY * invert + d.rotationY * factor;
//				}
//				if ((f & 0x0200) != 0) {
//					t.rotationZ = s.rotationZ * invert + d.rotationZ * factor;
//				}
			}
			if ((f & 0x1c00) != 0) {
				if ((f & 0x0400) != 0) {
					t.alpha = s.alpha * invert + d.alpha * factor;
				}
				if ((f & 0x0800) != 0) {
					t.width = s.width * invert + d.width * factor;
				}
				if ((f & 0x1000) != 0) {
					t.height = s.height * invert + d.height * factor;
				}
			}
		}
		
		override protected function newInstance():AbstractUpdater 
		{
			return new DisplayObjectUpdater();
		}
		
		override protected function copyFrom(source:AbstractUpdater):void 
		{
			super.copyFrom(source);
			
			var obj:DisplayObjectUpdater = source as DisplayObjectUpdater;
			
			_target = obj._target;
			_source.copyFrom(obj._source);
			_destination.copyFrom(obj._destination);
			_flags = obj._flags;
		}
	}
}

internal class DisplayObjectParameter
{
	public var relativeFlags:uint = 0;
	public var x:Number;
	public var y:Number;
//	public var z:Number;
	public var scaleX:Number;
	public var scaleY:Number;
//	public var scaleZ:Number;
	public var rotation:Number;
//	public var rotationX:Number;
//	public var rotationY:Number;
//	public var rotationZ:Number;
	public var alpha:Number;
	public var width:Number;
	public var height:Number;
	
	public function copyFrom(obj:DisplayObjectParameter):void
	{
		relativeFlags = obj.relativeFlags;
		x = obj.x;
		y = obj.y;
//		z = obj.z;
		scaleX = obj.scaleX;
		scaleY = obj.scaleY;
//		scaleZ = obj.scaleZ;
		rotation = obj.rotation;
//		rotationX = obj.rotationX;
//		rotationY = obj.rotationY;
//		rotationZ = obj.rotationZ;
		alpha = obj.alpha;
		width = obj.width;
		height = obj.height;
	}
}