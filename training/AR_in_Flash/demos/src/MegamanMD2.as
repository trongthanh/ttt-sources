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
package  {
	import examples.PV3DARApp;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.parsers.MD2;
	import org.papervision3d.objects.primitives.Plane;

	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(width=854, height=480, backgroundColor=0x808080, frameRate=15)]
	public class MegamanMD2 extends PV3DARApp {
		private var _plane:Plane;
		private var _megaman: MD2;
		
		private var _up: Boolean;
		private var _down: Boolean;
		private var _left: Boolean;
		private var _right: Boolean;
		private var _space: Boolean;
		
		private var _running: Boolean;
		private var _attacking: Boolean;
		private var _speed: int = 20;
		
		public function MegamanMD2() {
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
			
			_megaman = new MD2(false);
			_megaman.load("model/megaman.md2", new BitmapFileMaterial("model/megaman.png"), 10, 2);
			_megaman.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, animationLoadComplete);
			_megaman.z = 40;
			_markerNode.addChild(_megaman);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyInputHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyInputHandler);
		}
		
		private function animationLoadComplete(e:FileLoadEvent):void {
			_megaman.play("stand", true);
		}
		
		private function keyInputHandler(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.UP:
					_up = (e.type == KeyboardEvent.KEY_DOWN);
					break;
				case Keyboard.DOWN:
					_down = (e.type == KeyboardEvent.KEY_DOWN);
					break;
				case Keyboard.LEFT:
					_left = (e.type == KeyboardEvent.KEY_DOWN);
					break;
				case Keyboard.RIGHT:
					_right = (e.type == KeyboardEvent.KEY_DOWN);
					break;
				case Keyboard.SPACE:
					_space = (e.type == KeyboardEvent.KEY_DOWN);
					break;
			}
		}
		
		private function enterFrameHandler(e:Event):void {
			//trace(up, down, left, right);
			if (_space) {
				if (!_attacking) {
					_megaman.play("attack", true);
					_attacking = true;
				}
			} else if  (_up || _down || _left || _right) {
				if (!_running) {
					_megaman.play("run", true);
					_running = true;
				}
			} else {
				if (_running || _attacking) {
					_megaman.play("stand", true);
					_running = false;
					_attacking = false;
				}
			}
			if (!_space) {
				if (_up) {
					_megaman.x -= _speed;
					_megaman.rotationZ = 0;
				} else if (_down) {
					_megaman.x += _speed;
					_megaman.rotationZ = 180;
				} else if (_left) {
					_megaman.y += _speed;
					_megaman.rotationZ = -90;
				} else if (_right) {
					_megaman.y -= _speed;
					_megaman.rotationZ = 90;
				}
			}
		}
		
		
		
	}

}