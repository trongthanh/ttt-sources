package {
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.in2ideas.fireworks.FireworksEmitter;
	import com.in2ideas.fireworks.FireworksLight;
	import com.in2ideas.fireworks.FireworksParticle;
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Camera3D;
	import flare.core.Light3D;
	import flare.core.ParticleEmiter3D;
	import flare.core.Texture3D;
	import flare.loaders.ColladaLoader;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.ColorParticleFilter;
	import flare.materials.filters.SpecularFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Material3D;
	import flare.materials.ParticleMaterial3D;
	import flare.materials.Shader3D;
	import flare.primitives.Cube;
	import flare.primitives.Plane;
	import flare.primitives.SkyBox;
	import flash.display.Sprite;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author Thanh Tran - thanh.tran@in2ideas.com
	 */
	[Frame(factoryClass = "Preloader")]
	[SWF(backgroundColor='#000000', frameRate='60', width='1000', height='600')]
	public class Main extends Sprite {
		[Embed(source = "../bin/img/skybox.jpg")] 
		private var Sky:Class;
		
		public static var isHardware: Boolean;
		
		private var timer: TweenLite;
		public var scene: Scene3D;
		public var emitters: Vector.<FireworksEmitter>;
		public var hlnyPlane: Plane;
		
		private var emissionTick: Boolean;
		
		public var perfomanceInfo: TextField;
		public var happyNewYearText: TextField;
		

		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			scene = new Viewer3D( this );
			scene.autoResize = true;
			scene.camera = new Camera3D();
			scene.camera.setPosition( 500, 500, -800);
			scene.camera.lookAt( 0, 350, 0 );
			
			// light setup should be at the first to avoid duplicated shader compilations.
			scene.defaultLight.setParams(0x808080, 5000, 1, 1);
			scene.lights.maxPointLights = 9;
			scene.clearColor.setTo(0, 0, 0);
			
			for (var i:int = 0; i < 9; i++) {
				var light: FireworksLight = new FireworksLight();
				scene.addChild( light );
			}
			
			var floorMat: Shader3D = new Shader3D("floormat");
			floorMat.filters.push(new ColorFilter(0x808080));
			floorMat.filters.push( new SpecularFilter( 1, 1 ) );
			floorMat.build();
			var floor: Plane = new Plane("floor", 2000, 2000, 1, floorMat, "+xz");
			
			scene.addChild(floor);
			
			/*var mat: Shader3D = new Shader3D("cubemat");
			mat.filters.push( new TextureFilter( new Texture3D( "img/office-texture.jpg" ) ) );
			//add some reflection
			mat.filters.push( new SpecularFilter( 100, 2 ) );
			mat.build();
			
			var cube: Cube = new Cube("cube", 200, 300, 200, 4, mat);
			scene.addChild(cube);*/
			
			//var building: ColladaLoader = new ColladaLoader("models/model1/models/warehouse_model.dae", null, scene, "models/model1/images", false, Context3DTriangleFace.BACK);
			//var building: ColladaLoader = new ColladaLoader("models/model2/models/model.dae", null, scene, "models/model2/images", false, Context3DTriangleFace.BACK);
			var building: ColladaLoader = new ColladaLoader("models/model3/models/model.dae", null, scene, "models/model3/images", false, Context3DTriangleFace.BACK);
			building.setScale(10, 10, 10);
			scene.addChild(building);
			scene.library.push(building);
			
			var texture: Texture3D = scene.addTextureFromFile( "img/fireworks.jpg" );
			//var reflection: Texture3D = scene.addTextureFromFile( "img/reflections.jpg" );
			
			var colorList: Vector.<uint> = new <uint>[ 0xffff00, 0xff0000, 0x00ff00, 0x0000ff ];
			emitters = new Vector.<FireworksEmitter>();
			// creates the emiter.
			for (var j:int = 0; j < colorList.length; j++) {
				var emitter: FireworksEmitter = new FireworksEmitter( "emitter" + emitters.length, texture, colorList[j] );
				// particles and objects with alpha, usually need to be render
				emitter.setPosition(0, 0, 0);
				// after the other 3d objects to prevent z-buffer issues.
				scene.addChild(emitter);
				emitters.push(emitter);
			}
			
			// method 1 loads the complete skybox from a single image.
			//var sky:SkyBox = new SkyBox( "../resources/skybox1.png", SkyBox.HORIZONTAL_CROSS, scene );
			
			// method 2 loads the skybox from a folder.
			//var sky:SkyBox = new SkyBox( "../resources/skybox_folder", SkyBox.FOLDER_JPG, scene );
			
			// method 3 loads the skybox from a BitmapData array.
			//var sky:SkyBox = new SkyBox( [new Sky(), new Sky(), new Sky(), new Sky(), new Sky(), new Sky()], SkyBox.BITMAP_DATA_ARRAY, scene );
			//
			//scene.addChild( sky );
			
			var hlnyMat: Shader3D = new Shader3D("hlnyMat");
			hlnyMat.filters.push(new TextureFilter(new Texture3D("img/new-year-text.png", true), 0, "normal"));
			hlnyMat.filters.push(new AlphaMaskFilter(0.7));
			hlnyMat.enableLights = false;
			hlnyMat.twoSided = true;
			hlnyMat.build();
			hlnyPlane = new Plane("hlny", 800, 86, 1, hlnyMat);
			hlnyPlane.setPosition(0, 350, 0);
			scene.addChild(hlnyPlane);
			
			scene.addEventListener( Scene3D.COMPLETE_EVENT, sceneCompleteHandler );
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
			
			//some 2D
			
			perfomanceInfo = new TextField();
			perfomanceInfo.defaultTextFormat = new TextFormat("_sans",10, 0xFFFFFF);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			
			
		}
		
		private function stageResizeHandler(e:Event = null):void {
			perfomanceInfo.x = 5;
			perfomanceInfo.y = stage.stageHeight - perfomanceInfo.height - 3;
		}
		
		private function timerTickHandler():void {
			emissionTick = true;
			timer.restart();
		}
		
		private function updateEvent(e:Event):void {
			/*light.x = Math.cos( getTimer() / 1000 ) * 500;
			light.y = 500
			light.z = Math.sin( getTimer() / 1000 ) * 500;*/
			
			if (emissionTick) {
				emissionTick = false;
				var emitter: FireworksEmitter = emitters[int(Math.random() * emitters.length)];
				emitter.setPosition(Math.random() * 700 - 350, 
									Math.random() * 200 + 300, 
									Math.random() * 700 - 350);
				emitter.emit();
			}
			//trace("emitter 0 cur frame: " + emitters[0].currentFrame);
		}
		
		private function sceneCompleteHandler(e:Event):void {
			var driverInfo: String = scene.context.driverInfo;
			trace("driverInfo: " + driverInfo);
			isHardware = (driverInfo.indexOf("Software") == -1)
			var interval: Number = (isHardware)? 0.3 : 0.5;
			timer = new TweenLite( { }, interval, { onComplete: timerTickHandler } );
			
			perfomanceInfo.autoSize = "left";
			perfomanceInfo.text = "Drag the scene to rotate it.\nRendering Mode: " + driverInfo;
			if (isHardware) {
				perfomanceInfo.appendText(" (FAST)");
			} else {
				perfomanceInfo.appendText(" (SLOW)");
			}
			stageResizeHandler();
			this.addChild(perfomanceInfo);
		}
			
	}

}