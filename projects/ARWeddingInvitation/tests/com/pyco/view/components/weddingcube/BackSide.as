package com.pyco.view.components.weddingcube {
	import com.pyco.constant.CubeSideName;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import int3ractive.arinvitation.faces.back.VenueMap;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.MovieMaterial;
	/**
	 * ...
	 * @author Thu.Hoang
	 */
	public class BackSide extends BaseSide {
		[Embed(source = '/../assets/images/back.jpg')]
		public var BackImage: Class;
		private var map: Sprite = new Sprite();
		public function BackSide(material: MaterialObject3D = null, width: Number = 0, height: Number = 0, segmentsW: Number = 0, segmentsH: Number = 0) {
			//var bmp: Bitmap =  new BackImage() as Bitmap;
			//sideMaterial =  new BitmapMaterial(bmp.bitmapData);
			initValue();
			sideMaterial = new MovieMaterial(map, false, true, true, new Rectangle(0, 0, 500, 500));
			sideMaterial.interactive = true;
			sideMaterial.oneSide = false;
			
			super(sideMaterial, width, height, segmentsW, segmentsH);
			
			name = CubeSideName.BACK;
		}
		
		private function initValue(): void {
			var demo: VenueMap = new VenueMap(500, 500);
			map.addChild(demo);
			
			WeddingInvitation.mainMovie.stage.addChildAt(map, 0);
		}
	}

}