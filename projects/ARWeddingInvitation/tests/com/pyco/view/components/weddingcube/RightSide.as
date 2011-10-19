package com.pyco.view.components.weddingcube {
	import com.pyco.constant.CubeSideName;
	import flash.display.Bitmap;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	/**
	 * ...
	 * @author Thu.Hoang
	 */
	public class RightSide extends BaseSide {
		[Embed(source = '/../assets/images/right.jpg')]
		public var RightImage: Class;
		
		public function RightSide(material: MaterialObject3D = null, width: Number = 0, height: Number = 0, segmentsW: Number = 0, segmentsH: Number = 0) {
			var bmp: Bitmap =  new RightImage() as Bitmap;
			sideMaterial =  new BitmapMaterial(bmp.bitmapData);
			sideMaterial.interactive = true;
			sideMaterial.oneSide = false;
			
			super(sideMaterial, width, height, segmentsW, segmentsH);
			
			name = CubeSideName.RIGHT;
		}
		
	}

}