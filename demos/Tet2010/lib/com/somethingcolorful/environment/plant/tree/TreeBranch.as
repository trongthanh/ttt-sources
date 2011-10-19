/**
 * Copyright somethingcolorful.com
 * From: http://labs.somethingcolorful.com/2008/08/29/papervision-recursive-tree-branch/
 * Licensed under MIT License
 * 
 * Edited by Thanh Tran trongthanh@gmail.com
 */
package com.somethingcolorful.environment.plant.tree
{
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.thanhtran.tet2010.events.TreeBranchEvent;
	
	
	[Event(name='newBud', type='org.thanhtran.tet2010.events.TreeBranchEvent')]
	public class TreeBranch extends DisplayObject3D
	{
		
		private var toX:Number = 0
		private var toY:Number = 0
		private var toZ:Number = 0;
		private var rad:Number = 15;
		private var ang:Number = 0;
		private var MAX_THICKNESS:Number = 5;
		private var counter:int = 0;
		private var defMat:LineMaterial;
		private var limb:Lines3D;
		private var branches:Array = new Array();
		
		//TTT: new config
		private var reach: int = 15; //31
		private var steepness: Number = 0.2; //becarefull
		public var generating: Boolean = false;
		
		
		/**
		 * 
		 * @param	name
		 * @param	x		
		 * @param	y
		 * @param	z
		 * @param	radius	radius of the trunk
		 * @param	reach	reach of the branches
		 */
		public function TreeBranch(name:String,x:int = 0,y:int = 0,z:int = 0,radius: Number = 15, reach: int = 16, steepness: Number = 0.2)
		{
			super();
			this.x = x;
			this.y = y;
			this.z = z;
			this.rad = radius;
			this.reach = reach;
			this.steepness = steepness;

			defMat = new LineMaterial(0x5E3017, 1);
			limb = new Lines3D(defMat, name);
			autoCalcScreenCoords = true;
			addChild( limb );
		}
			
		
		public function update() : void
		{
			if (rad > 2) {				
				generating = true;
				var t:Number = MAX_THICKNESS-rad+1;
			
				var fromX:Number = toX;
				var fromY:Number = toY;
				var fromZ:Number = toZ;
				
				//ang += Math.PI/180*(random(t*16+10)-(t*8+5));
				ang += Math.PI/180*(random(t*10+10)-(t*8+5));
				//ang += Math.min(10,Math.max(-10,(random(30)+3)))/180*Math.PI;
				toY -= 10;
				toX -= (toY-fromY)*Math.cos(ang);
				toZ -= (toY-fromY)*Math.sin(ang);
				rad -= steepness;

				limb.addLine( new Line3D( limb, defMat, rad, new Vertex3D(toX,toY,toZ), new Vertex3D( fromX,fromY,fromZ ) ));		
				
				var n:int = branches.length;
				for(var i:int=0;i<n;i++){
					branches[i].update();
				}
				
				if(counter == reach){
					//trace("add new branch");
					var b:TreeBranch = new TreeBranch('child', fromX, fromY, fromZ, rad, int(reach * (1 - steepness)),steepness)
					b.addEventListener(TreeBranchEvent.NEW_BUD, newBudHandler);
					b.rotationY = random(180);
					b.rotationX = random(120)-90; 
					//b.rotationZ = random(180)-90; 
					branches.push(b);
					addChild(b);
					counter=0;
				}
				
				if(rad < 5 ) {
					var localPos: Number3D = new Number3D(toX + Math.random() * 10 - 5,
														  toY,
														  toZ + Math.random() * 10 - 5
														  );
					var matrix: Matrix3D = Matrix3D.IDENTITY;
					//matrix.copy(this.transform);
					
					matrix.n14 = localPos.x;
					matrix.n24 = localPos.y;
					matrix.n34 = localPos.z;
					
					matrix.calculateMultiply(this.world, matrix);
					
					var scenePos: Number3D = new Number3D(matrix.n14, matrix.n24, matrix.n34);
					
					dispatchEvent(new TreeBranchEvent(TreeBranchEvent.NEW_BUD, localPos, scenePos, this));
				}
				counter++;
			} else {
				generating = false;
			}
		}
		
		private function newBudHandler(event: TreeBranchEvent): void {
			dispatchEvent(event);
		}
		
		private function random(v:Number) : Number
		{
			return Math.random() * v;
		}

	}
}