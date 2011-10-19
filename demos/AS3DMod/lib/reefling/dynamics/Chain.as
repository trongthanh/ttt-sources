/**
 * This class is ported from an AS2 version at: http://www.prodevtips.com/2007/11/06/dynamics-and-procedural-animation-in-flash/
 */
package reefling.dynamics {
	import reefling.utils.HSMath;
	import reefling.utils.V2D;
	public class Chain {
		
		public var arr:Array;			//the array which will contain all the links
		//var pencil:MovieClip;
		public var elast:Number;		//the elasticity of the chain
		public var damp:Number;		//the damping of the chain
		public var spacing:Number;	//spacing in pixels between the links
		
		public function Chain(X:Number, Y:Number, numOfLinks: int, elast:Number, damp:Number, spacing:Number) {
			this.arr 		= new Array();
			this.elast		= elast;
			this.damp 		= damp;
			this.spacing	= spacing;
			
			//---------- initiation -----------------
			//the top link is positioned
			var chainLink:ChainLink = new ChainLink(X, Y, damp, elast, 0);
			this.arr[0] = chainLink;
			//the middle links are positioned
			var i: int;
			for(i = 1; i < numOfLinks - 1; i++){
				chainLink = new ChainLink(X, i*spacing, damp, elast, 1);
				this.arr[i] = chainLink;
			}
			//the end link is positioned
			//chainLink = new ChainLink(X, (numOfLinks - 1)*spacing, this.damp, this.elast, 2);
			chainLink = new ChainLink(X, (numOfLinks - 1)*spacing, this.damp, this.elast, 2);
			this.arr[numOfLinks - 1] = chainLink;
			
			
			//------- linkage -----------------------
			//the hierachy is established
			this.arr[0].child = this.arr[1];
			
			for(i = 1; i < numOfLinks - 1; i++){
				this.arr[i].parent = this.arr[i-1];
				this.arr[i].child = this.arr[i+1];
			}
			
			this.arr[numOfLinks - 1].parent = this.arr[numOfLinks - 2];
			//----------------------------------------
			//the starting difference values are set
			for(i = 0; i < numOfLinks; i++){
				this.arr[i].setInitValues();
			}
		}
		
		//calculates the angle between two links to be able to rotate eventual attached movieclip
		public function calcAngle(n1:Number, n2:Number):Number{
			var diff:V2D = HSMath.d2dif(this.arr[n1].pos, this.arr[n2].pos);
			var angle:Number = Math.atan(diff.y/diff.x);
			return angle;
		}
		
	}
}