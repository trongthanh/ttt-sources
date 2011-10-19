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
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Plane;

	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	public class EarthCollada extends PV3DARApp {
		private var _plane:Plane;
		private var _earth: DAE;
		
		public function EarthCollada() {
			this.isRasterViewMode(false);
			// Initalize application with the path of camera calibration file and patter definition file.
			addEventListener(Event.INIT, initHandler);
			init('data/camera_para.dat', 'data/flarlogo.pat');
		}
		
		private function initHandler(e:Event):void {
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ワイヤーフレームで。
			_plane = new Plane(wmat, 80, 80); // 80mm x 80mm。
			_plane.rotationX = 180;
			_markerNode.addChild(_plane); // attach to _markerNode to follow the marker.
			
			_earth = new DAE();
			_earth.load("model/earth.dae");
			_earth.scale = 10;
			_earth.rotationX = 90;
			
			_markerNode.addChild(_earth);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
		}
		
		private function enterFrameHandler(e:Event):void {
			_earth.rotationZ -= 3;
		}
		
	}

}