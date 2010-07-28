/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.thanhtran.tet2010.view {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.thanhtran.tet2010.model.Resources;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class OchnaFlower3D extends Plane {
		
		public function OchnaFlower3D() {
			var bitmapData: BitmapData = Resources.getRandomFlower();
			
			var mat: BitmapMaterial = new BitmapMaterial(bitmapData);
			mat.doubleSided = true;
			super(mat, 20, 20, 1, 1);
		}
		
	}

}