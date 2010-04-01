package  {
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.data.UserData;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.BasicView;
	import reefling.dynamics.Chain;
	import reefling.dynamics.ChainLink;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Demo6PaperFlip extends BasicView {
		[Embed(source = '/../assets/images/book/03.jpg')]
		public var FrontPage: Class;
		[Embed(source = '/../assets/images/book/04.jpg')] 
		public var BackPage: Class;
		
		public var wireframeButton: Button;
		public var angleButton: Button;
		
		private var container: DisplayObject3D;
		private var paper: Cube;
		private var bmMat:BitmapMaterial;
		private var wfMat:WireframeMaterial;
		private var chain: Chain;
		
		public function Demo6PaperFlip ():void {
			super(550, 400, true, false, CameraType.FREE);
			
			init();
			initUI();
		}
		
		private function init():void {
			_camera.z = -500;
			
			wfMat = new WireframeMaterial();
			wfMat.doubleSided = true;
			
			var front: Bitmap = new FrontPage();
			var back: Bitmap = new BackPage();
			
			var frontMat: BitmapMaterial = new BitmapMaterial(front.bitmapData);
			var backMat: BitmapMaterial = new BitmapMaterial(back.bitmapData);
			
			var matList: MaterialsList = new MaterialsList();
			matList.addMaterial( frontMat, "front" );
			matList.addMaterial( backMat, "back" );
			
			paper = new Cube(matList, 300, 0, 400, 10, 1, 1);
			
			container = new DisplayObject3D("container");
			container.addChild(paper);
			container.rotationY = - 45;
			container.rotationX = 90;
			container.rotationZ = - 90;
			
			scene.addChild(container);
			
			
			//select 1 side of a plane
			var vertice: Array = paper.geometry.vertices;
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
			
			var vertice: Array = paper.geometry.vertices;
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
				//plane.material = wfMat;
				wireframeButton.label = "With Material";
			} else {
				//plane.material = bmMat;
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