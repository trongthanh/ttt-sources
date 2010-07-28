/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.thanhtran.tet2010.model.data {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.objects.DisplayObject3D;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class BudPositionInfo {
		public var parent: DisplayObject3D;
		public var position: Number3D;
		
		public function BudPositionInfo(parent: DisplayObject3D = null, position: Number3D = null) {
			this.parent = parent;
			this.position = position;
		}
		
	}

}