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
package org.libspark.betweenas3.core.updaters
{
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class UpdaterLadder implements IUpdater
	{
		public function UpdaterLadder(parent:IUpdater, child:IUpdater, propertyName:String)
		{
			_parent = parent;
			_child = child;
			_propertyName = propertyName;
		}
		
		private var _parent:IUpdater;
		private var _child:IUpdater;
		private var _propertyName:String;
		
		/**
		 * .
		 */
		public function get parent():IUpdater
		{
			return _parent;
		}
		
		/**
		 * .
		 */
		public function get child():IUpdater
		{
			return _child;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get target():Object
		{
			return null;
		}
		
		/**
		 * @private
		 */
		public function set target(value:Object):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObject(propertyName:String):Object
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setObject(propertyName:String, value:Object):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function resolveValues():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(factor:Number):void
		{
			_child.update(factor);
			_parent.setObject(_propertyName, _child.target);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():IUpdater
		{
			return new UpdaterLadder(_parent, _child, _propertyName);
		}
	}
}