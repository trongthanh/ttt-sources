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
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.pyco.controls.ToolTip;
	import com.somethingcolorful.environment.plant.tree.TreeBranch;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.data.UserData;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Quaternion;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	import org.thanhtran.tet2010.controller.SimpleAudioPlayer;
	import org.thanhtran.tet2010.events.TreeBranchEvent;
	import org.thanhtran.tet2010.model.data.BudPositionInfo;
	import org.thanhtran.tet2010.model.data.UserInfo;
	import org.thanhtran.tet2010.model.Resources;
	import org.thanhtran.tet2010.view.Fireworks;
	import org.thanhtran.tet2010.view.OchnaFlower3D;
	import org.thanhtran.tet2010.view.SoundButton;
	import org.thanhtran.tet2010.view.ThumbImage;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Main extends BasicView {
		public static const BRANCH_INTERVAL: int = 40;//80;
		public static const FLOWER_INTERVAL: int = 35;//60;
		public static const ROTATE_SPEED: Number = 0.5;
		
		public var theTree: TreeBranch;
		
		public var audioPlayer: SimpleAudioPlayer;
		public var soundButton: SoundButton;
		
		private var flowerCount: int = 0;
		private var budPlaces: Array = [];
		private var flowers: Array = [];
		private var flowerComplete: Boolean = false;
		private var thumbList: Array;
		private var planeList: Array;
		private var len: int;
		
		private var defaultDistance: int = 500;
		
		private var timer: Timer;
		private var angle:Number = 0;
		
		
		public function Main():void {
			super(1024, 768, true, true, CameraType.TARGET);
		}
		
		public function init(thumbList: Array = null):void {
			this.thumbList = thumbList;
			len = thumbList.length;
			init3D();
			init2D();
		}

		private function init3D():void {
			_camera.z = - defaultDistance;
			viewport.interactive = true;
			viewport.containerSprite.buttonMode = true;
			viewport.containerSprite.useHandCursor = false;
			
			planeList = [];
			var plane: Plane;
			var mat: BitmapMaterial;
			var thumb: ThumbImage;
			
			for (var i:int = 0; i < len; i++) {
				thumb = thumbList[i];
				mat = new BitmapMaterial(thumb.bitmap.bitmapData);
				mat.doubleSided = true;
				mat.interactive = true;
				
				plane = new Plane(mat, 30, 30, 1, 1);
				plane.userData = new UserData(thumb.userInfo);
				plane.extra = { };
				resetPlanePosition(plane);
				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, planeRollOverHandler);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, planeRollOutHandler);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, planeClickHandler);
				
				planeList.push(plane);
			}
			
			theTree = new TreeBranch("tree", 0, -500,0);
			theTree.addEventListener(TreeBranchEvent.NEW_BUD, newBudHandler);
			theTree.rotationZ = 180;
			
			scene.addChild(theTree);
			theTree.update();
			
			timer = new Timer(BRANCH_INTERVAL);
			timer.addEventListener(TimerEvent.TIMER, generateBranchHandler);
			timer.start();
			
			startRendering();
		}
		
		private function planeClickHandler(event: InteractiveScene3DEvent): void {
			var info: UserInfo = Plane(event.currentTarget).userData.data as UserInfo;
			trace( "plane click: " + info.name );
			navigateToURL(new URLRequest(info.profileURL), "_blank");
		}
		
		private function planeRollOutHandler(event: InteractiveScene3DEvent): void {
			viewport.containerSprite.useHandCursor = false;
			Plane(event.currentTarget).extra.isOver = false;
			ToolTip.hoverObjects[viewport].tipText = "ttt_conan chúc mừng Năm Mới";
		}
		
		private function planeRollOverHandler(event: InteractiveScene3DEvent): void {
			viewport.containerSprite.useHandCursor = true;
			
			var plane: Plane = Plane(event.currentTarget);
			var name: String = UserInfo(plane.userData.data).name;
			ToolTip.text = name;
			ToolTip.hoverObjects[viewport].tipText = name; 
			plane.extra.isOver = true;
		}
		
		private function init2D():void {
			//audio
			audioPlayer = new SimpleAudioPlayer(Resources.song);
			audioPlayer.play();
			
			soundButton = new SoundButton();
			soundButton.mouseChildren = false;
			soundButton.muteIcon.visible = false;
			soundButton.buttonMode = true;
			soundButton.addEventListener(MouseEvent.CLICK, soundButtonClickHandler);
			soundButton.x = stage.stageWidth - soundButton.width - 10;
			soundButton.y = stage.stageHeight - soundButton.height - 10;
			addChild(soundButton);
			
			ToolTip.init(stage, 
			{ 
				textAlign: 'center',
				textColor: 0x000000,
				opacity: 50,
				defaultDelay: 100,
				bgColor: 0xFFFF00,
				borderColor: 'none',
				cornerRadius: 10,
				shadow: false,
				top: 5,
				left: 5,
				right: 5,
				bottom: 5,
				fadeTime: 100,
				fontSize: 12,
				fontFace: "_sans",
				fontEmbed: false
			} );
			ToolTip.attach(viewport, "ttt_conan chúc mừng Năm Mới");
			
		}
		
		private function soundButtonClickHandler(event: MouseEvent): void {
			if (soundButton.soundIcon.visible) {
				soundButton.soundIcon.visible = false;
				soundButton.muteIcon.visible = true;
				TweenLite.to(audioPlayer, 0.5, { volume: 0, ease: Linear.easeNone } );
				
				
			} else {
				soundButton.soundIcon.visible = true;
				soundButton.muteIcon.visible = false;
				TweenLite.to(audioPlayer, 0.5, {volume: 1, ease: Linear.easeNone});
			}
		}
		
		private function newBudHandler(event: TreeBranchEvent): void {
			budPlaces.push(new BudPositionInfo(event.parent, event.localPosition));
			
		}
		
		private function generateBranchHandler(event: Event): void {
			if (theTree.generating) {
				theTree.update();
			} else {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, generateBranchHandler);
				timer.delay = FLOWER_INTERVAL;
				timer.addEventListener(TimerEvent.TIMER, generateFlowersHandler);
				timer.start();
				trace( "budPlaces.length : " + budPlaces.length );
			}
			
		}
		
		private function generateFlowersHandler(event: Event): void {
			if (flowerCount < 200) {
				//TODO: get len once
				var randIndex: int = Math.random() * budPlaces.length;
				//trace( "randIndex : " + randIndex );
				//var pos: Number3D = budPlaces.splice(randIndex, 1)[0] as Number3D;
				var posInfo: BudPositionInfo = budPlaces[randIndex];
				var pos: Number3D = posInfo.position;
				//trace( "pos : " + pos );
				//trace( "flowerCount : " + flowerCount );
				if (pos) {
					var flower: OchnaFlower3D = new OchnaFlower3D();
					flower.x = pos.x + Math.random() * 10 - 5;
					flower.y = pos.y + Math.random() * 10 - 5;;
					flower.z = pos.z + Math.random() * 10 - 5;;
					flower.rotationX = Math.random() * 360;
					flower.rotationY = Math.random() * 360;
					flower.rotationZ = Math.random() * 360;
					//flower.transform.calculateMultiply(Matrix3D.inverse(theTree.world), flower.transform);
					//theTree.addChild(flower);
					//scene.addChild(flower);
					posInfo.parent.addChild(flower, "flower" + flowers.length);
					flowers.push(flower);
					flowerCount ++;
				}
				//singleRender();
				
			} else {
				timer.removeEventListener(TimerEvent.TIMER, generateFlowersHandler);
				timer.stop();
				//testing 
				//stage.addEventListener(MouseEvent.CLICK, clickHandler);
				//stage.addEventListener(KeyboardEvent.KEY_UP, keyPressHandler);
				var fireworks: Fireworks = new Fireworks();
				fireworks.y = -100;
				fireworks.x = 190;
				addChildAt(fireworks, 0);
				
				
				//delay timer
				TweenLite.to(fireworks, 8, {onComplete: throwThumbConfetti } );
			}
		}
		
		private function throwThumbConfetti():void {
			flowerComplete = true;
			var plane: Plane;
			for (var i:int = 0; i < len; i++) {
				plane = planeList[i];
				scene.addChild(plane);
				
			}
		}
		
		private function resetPlanePosition(plane: Plane): void {
			plane.y = 800 + Math.random() * 5000;
			plane.x = Math.random() * 2000 - 1000; //x vary from -1000 to 1000
			plane.z = Math.random() * 700 - 450; //z vary from -450 to 250
			plane.extra.speed = 3 + Math.random() * 5;
			plane.extra.rotX = Math.random() * 5; 
			plane.extra.rotY = Math.random() * 5; 
			plane.extra.rotZ = Math.random() * 5;
			plane.extra.isOver = false;
			
		}
		
		
		override protected function onRenderTick(event:Event = null): void {
			super.onRenderTick(event);
			
			if (flowerComplete) {
				var plane: Plane;
				var extra: Object;
				for (var i:int = 0; i < len; i++) {
					plane = planeList[i];
					extra = plane.extra;
					if (!extra.isOver) {
						plane.y -= extra.speed;
						plane.rotationX += extra.rotX;
						plane.rotationY += extra.rotY;
						plane.rotationZ += extra.rotZ;
					}
					
					if (plane.y < -1000) {
						resetPlanePosition(plane);
					}
				}
			}
			/*
			var deltaX: Number = (stage.stageWidth - this.mouseX) / stage.stageWidth;
			deltaX = - 0.5 + deltaX;
			theTree.rotationY = deltaX * 90;
			/*/
			theTree.rotationY += ROTATE_SPEED;
			//*/
			//camera.x = deltaX * 500;
			
		}
	}
	
}