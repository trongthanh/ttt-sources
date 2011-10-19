package com.pyco.view.components.weddingcube {
	import com.pyco.constant.CubeSideName;
	import flash.display.Bitmap;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	/**
	 * ...
	 * @author Thu.Hoang
	 */
	public class TopSide extends BaseSide {
		[Embed(source = '/../assets/images/top.png')]
		public var TopImage: Class;
		
		public function TopSide(material: MaterialObject3D = null, width: Number = 0, height: Number = 0, segmentsW: Number = 0, segmentsH: Number = 0) {
			var bmp: Bitmap =  new TopImage() as Bitmap;
			sideMaterial =  new BitmapMaterial(bmp.bitmapData);
			sideMaterial.interactive = true;
			sideMaterial.oneSide = false;
			
			super(sideMaterial, width, height, segmentsW, segmentsH);
			
			name = CubeSideName.TOP;
		}
	}

}