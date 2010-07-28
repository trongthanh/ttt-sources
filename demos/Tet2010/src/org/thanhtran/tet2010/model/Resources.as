/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.thanhtran.tet2010.model {
	import flash.display.BitmapData;
	import flash.media.Sound;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Resources {
		[Embed(source='/../assets/images/hoa_mai_01.png')]
		private static var FlowerBitmap0: Class;
		[Embed(source='/../assets/images/hoa_mai_02.png')]
		private static var FlowerBitmap1: Class;
		[Embed(source='/../assets/images/bup_mai_01.png')]
		private static var FlowerBitmap2: Class;
		[Embed(source='/../assets/images/bup_mai_02.png')]
		private static var FlowerBitmap3: Class;
		[Embed(source='/../assets/music/mua_xuan_oi_48k_stereo.mp3', mimeType='audio/mpeg')]
		private static var Audio: Class; //subclass of Sound
		
		private static var bitmapData0: BitmapData = new FlowerBitmap0().bitmapData;
		private static var bitmapData1: BitmapData = new FlowerBitmap1().bitmapData;
		private static var bitmapData2: BitmapData = new FlowerBitmap2().bitmapData;
		private static var bitmapData3: BitmapData = new FlowerBitmap3().bitmapData;
		public static var song: Sound = new Audio();
		
		public function Resources() {
			
		}
		
		public static function getRandomFlower(): BitmapData {
			//trace( "index : " + index );
			var index: uint = uint(Math.random() * 6);
			//flower is twice the occurence
			switch (index) {
				default:
				case 0: 
				case 1:
					return bitmapData0
					break;
				case 2: 
				case 3:
					return bitmapData1
					break;
				case 4: 
					return bitmapData2
					break;
				case 5: 
					return bitmapData3
					break;
			}
			
		}
		
	}

}