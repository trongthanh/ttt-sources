/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
package {
	import examples.PV3DARApp;
	import flash.events.Event;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Plane;

	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	public class MultiplePicturePlanes extends FLARTK_Example_Multiple_SimpleCube_PV3D {

		public function MultiplePicturePlanes() {
			
		}
		
		override protected function init():void {
			//width & height of webcam's video
			this.captureWidth = 320;
			this.captureHeight = 240;
			
			//W&H of render canvas: captureWidth:captureHeight=canvasWidth:canvasHeight
			this.canvasWidth = 640
			this.canvasHeight = 480;
			
			// camera parameter data, do not change unless you know what it is
			this.cameraParamFile = 'data/camera_para.dat';
			
			// list of marker patterns
			this.markerPatternList = new Vector.<FLARCode>();
			
			// list of paths to pattern files
			this.markerPatternFileList = new Vector.<String>();
			this.markerPatternFileList.push('data/L.pat', 
											'data/flarlogo.pat');
			
			this.codeWidthList = new Vector.<Number>();
			this.codeWidthList.push( 80, 80);
			
			// start load patterns and camera params
			this.paramLoad();
			
			//this.scaleX = -1;
			//this.x = stage.stageWidth;
		}
		
		override protected function start():void {
			
			// add 3D objects to the marker nodes
			this.markerNodeList[0].addChild(createImagePlane("images/thap_rua.jpg", 480, 720));
			this.markerNodeList[1].addChild(createImagePlane("images/em_be_vn.jpg", 604, 420));
			
			// start detecting
			this.addEventListener(Event.ENTER_FRAME, this.run);
		}
		
		protected function createImagePlane(url: String, w: int, h: int): DisplayObject3D {
			var bitmapMat: BitmapFileMaterial = new BitmapFileMaterial(url);
			bitmapMat.doubleSided = true;
			var plane: Plane = new Plane(bitmapMat, w, h, 2,2);
			plane.rotationZ = 90;
			plane.rotationX = 180;
			return plane;
			
		}
		
	}

}