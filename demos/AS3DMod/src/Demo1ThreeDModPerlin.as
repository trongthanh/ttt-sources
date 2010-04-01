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
	import com.as3dmod.IModifier;
	import com.as3dmod.modifiers.Perlin;
	import com.as3dmod.ModifierStack;
	import com.as3dmod.plugins.pv3d.LibraryPv3d;
	import com.as3dmod.util.bitmap.PerlinNoise;
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	
	/**
	 * 3D paper (more flag-like!!!) using AS3DMod & Perlin modifier
	 * @author Thanh Tran
	 */
	public class Demo1ThreeDModPerlin extends BasicView {
		[Embed(source='/../assets/images/flag.jpg')]
		public var FlagPhoto: Class;
		public var wireframeButton: Button;
		
		private var container: DisplayObject3D;
		private var plane: Plane;
		private var modStack: ModifierStack;
		private var perlin: Perlin;
		private var wfMat:WireframeMaterial;
		private var bmMat:BitmapMaterial;
		private var bitmap:Bitmap;		
		
		public function Demo1ThreeDModPerlin(): void {
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
			container.rotationY = -45;
			container.rotationX = 45;
			//container.rotationZ = 90;
			
			scene.addChild(container);
			
			modStack = new ModifierStack(new LibraryPv3d(), plane);
			
			var perlinNoise: PerlinNoise = new PerlinNoise(40, 40);
			bitmap = perlinNoise.bitmap;
			bitmap.x = stage.stageWidth - bitmap.width;
			this.addChild(bitmap);
			
			perlin = new Perlin(1, perlinNoise);
			modStack.addModifier(perlin);
			
			startRendering();
		}
		
		override protected function onRenderTick(event:Event = null): void {
			
			modStack.apply();
			super.onRenderTick(event);
		}
		
		private function initUI():void {
			wireframeButton = new Button();
			wireframeButton.x = 5;
			wireframeButton.y = 5;
			wireframeButton.label = "Wireframe";
			wireframeButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			addChild(wireframeButton);
			
			var noteText: TextField = new TextField();
			noteText.autoSize = "left";
			noteText.textColor = 0xFFFFFF;
			noteText.text = "Perlin noise being rendered -->";
			noteText.x = bitmap.x - noteText.width;
			addChild(noteText);
		}
		
		private function buttonClickHandler(event: MouseEvent): void {
			if (wireframeButton.label == "Wireframe") {
				plane.material = wfMat;
				wireframeButton.label = "With Material";
			} else {
				plane.material = bmMat;
				wireframeButton.label = "Wireframe";
			}
			
		}
		
	}
	
}