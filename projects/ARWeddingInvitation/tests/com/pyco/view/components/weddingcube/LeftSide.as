package com.pyco.view.components.weddingcube {
	import com.pyco.constant.CubeSideName;
	import flash.display.Bitmap;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	/**
	 * ...
	 * @author Thu.Hoang
	 */
	public class LeftSide extends BaseSide {
		[Embed(source = '/../assets/images/left.jpg')]
		public var LeftImage: Class;
		
		public function LeftSide(material: MaterialObject3D = null, width: Number = 0, height: Number = 0, segmentsW: Number = 0, segmentsH: Number = 0) {
			var bmp: Bitmap =  new LeftImage() as Bitmap;
			sideMaterial =  new BitmapMaterial(bmp.bitmapData);
			sideMaterial.interactive = true;
			sideMaterial.oneSide = false;
			
			super(sideMaterial, width, height, segmentsW, segmentsH);
			
			name = CubeSideName.LEFT;
		}
		
	}

}