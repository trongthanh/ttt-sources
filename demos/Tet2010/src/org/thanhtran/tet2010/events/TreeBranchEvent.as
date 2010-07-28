/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.thanhtran.tet2010.events {
	import flash.events.Event;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class TreeBranchEvent extends Event {
		public static const NEW_BUD: String = "newBud";
		
		public var localPosition: Number3D;
		public var scenePosition: Number3D;
		public var parent: DisplayObject3D;
		
		public function TreeBranchEvent(type:String, local: Number3D = null, scene: Number3D = null, parent: DisplayObject3D = null) {
			super(type);
			this.localPosition = local;
			this.scenePosition = scene;
			this.parent = parent;
		} 
		
		public override function clone():Event { 
			return new TreeBranchEvent(type, localPosition, scenePosition, parent);
		} 
		
		public override function toString():String { 
			return formatToString("TreeBranchEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}