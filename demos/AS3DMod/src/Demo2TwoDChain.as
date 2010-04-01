/**
 * Copyright (c) 2010 trongthanh@gmail.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package {
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.data.UserData;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	import reefling.dynamics.Chain;
	import reefling.dynamics.ChainLink;
	
	/**
	 * Interactive 3D paper using 3D object's vertex map & a 2D chain simulator
	 * @author Thanh Tran
	 */
	public class Demo2TwoDChain extends BasicView {
		[Embed(source='/../assets/images/flag.jpg')]
		public var FlagPhoto: Class;
		public var wireframeButton: Button;
		public var angleButton: Button;
		
		private var container: DisplayObject3D;
		private var plane: Plane;
		private var bmMat:BitmapMaterial;
		private var wfMat:WireframeMaterial;
		private var chain: Chain;
		
		public function Demo2TwoDChain ():void {
			super(550, 400, true, false, CameraType.FREE);
			
			init();
			initUI();
		}
		
		private function init():void {
			_camera.z = -500;
			
			wfMat = new WireframeMaterial();
			wfMat.doubleSided = true;
			
			var flag: Bitmap = new FlagPhoto();
			
			bmMat = new BitmapMaterial(flag.bitmapData);
			bmMat.doubleSided = true;
			
			plane = new Plane(bmMat, 300, 300, 10, 10);
			
			container = new DisplayObject3D("container");
			container.addChild(plane);
			container.rotationY = - 45;
			container.rotationX = 90;
			container.rotationZ = - 90;
			
			scene.addChild(container);
			
			
			//select 1 side of a plane
			var vertice: Array = plane.geometry.vertices;
			var len: int = vertice.length;
			var vertex: Vertex3D;
			var pos: Number3D;
			var step: int = 0;
			var lastX: Number = vertice[0].getPosition().x;
			for (var i:int = 0; i < len; i++) {
				vertex = vertice[i];
				pos = vertex.getPosition();
				//trace( "pos.x,y,z : " + pos.x,pos.y,pos.z );
				
				if (lastX != pos.x) {
					lastX = pos.x;
					step ++;
				}
				
				//trace( "step : " + step );
				vertex._userData = new UserData({pos: pos.clone(), step: step});
			}
			
			chain = new Chain(0, 0, 11, 0.4 /*0.65*/, 0.03, 40);
			
			
			startRendering();
		}

		
		override protected function onRenderTick(event:Event = null): void {
			var topNode: ChainLink = chain.arr[0];
			var dx: Number = viewport.mouseX - (viewport.viewportWidth/ 2);
			topNode.translationOrigin( - dx, 0, 0);
			
			var vertice: Array = plane.geometry.vertices;
			var len: int = vertice.length;
			var vertex: Vertex3D;
			var step: int;
			var node: ChainLink;
			for (var i:int = 0; i < len; i++) {
				vertex = vertice[i];
				step = int(vertex._userData.data.step);
				//trace( "step : " + step );
				node = chain.arr[step];
				if (node) {
					//vertex.x = node.pos.x;
					//vertex.y = node.pos.x;
					vertex.z = node.pos.x;
				}
			}
			
			super.onRenderTick(event);
		}
		
		private function initUI():void {
			wireframeButton = new Button();
			wireframeButton.x = 5;
			wireframeButton.y = 5;
			wireframeButton.label = "Wireframe";
			wireframeButton.addEventListener(MouseEvent.CLICK, wfButtonClickHandler);
			addChild(wireframeButton);
			
			angleButton = new Button();
			angleButton.x = wireframeButton.x + wireframeButton.width + 5;
			angleButton.y = 5;
			angleButton.label = "Side View";
			angleButton.addEventListener(MouseEvent.CLICK, angleButtonClickHandler);
			addChild(angleButton);
		}
		
		private function wfButtonClickHandler(event: MouseEvent): void {
			if (wireframeButton.label == "Wireframe") {
				plane.material = wfMat;
				wireframeButton.label = "With Material";
			} else {
				plane.material = bmMat;
				wireframeButton.label = "Wireframe";
			}
			
		}
		
		private function angleButtonClickHandler(event: MouseEvent): void {
			if (angleButton.label == "Side View") {
				//container.rotationY = -45;
				container.rotationX = 45;
				angleButton.label = "Direct View";
			} else {
				container.rotationX = 90;
				container.rotationZ = - 90;
				angleButton.label = "Side View";
			}
			
		}
		
	}
	
}