/**
 * This class is ported from an AS2 version at: http://www.prodevtips.com/2007/11/06/dynamics-and-procedural-animation-in-flash/
 */
package reefling.dynamics {
	import reefling.utils.HSMath;
	import reefling.utils.V2D;
	public class ChainLink {
		
		public var child:ChainLink;		//the child which will get this transformation
		public var parent:ChainLink;		//parent which controls this
		public var damping:Number;		//the strength of the damping force
		public var elasticity:Number;		//elasticity of the chain
		public var speed:V2D;				//speed of this
		public var acc:V2D;				//acceleration of this
		public var pDif:V2D;				//difference between this and parent
		public var cDif:V2D;				//diffeernce between this and child
		public var typ:Number;			//type, top-, middle- or endpoint, 0,1 or 2
		public var pos:V2D;				//position of this
		//var s:V2D;					//?
		
		public function ChainLink(x:Number, y:Number, damping:Number, elasticity:Number, typ:Number){
			this.pos 		 = new V2D(x, y);
			this.damping	 = damping;
			this.elasticity	 = elasticity;
			this.speed 		 = new V2D(0, 0);
			this.acc 		 = new V2D(0, 0);
			this.typ 		 = typ;
		}
		
		//the differences in position are set
		public function setInitValues(): void {
			if (this.parent) this.pDif = HSMath.d2dif(this.pos, this.parent.pos);
			if (this.child) this.cDif = HSMath.d2dif(this.pos, this.child.pos);
		}
		
		//translation occurs with respect to the recieved ChainLink
		public function translate(obj:ChainLink, dif:V2D): void {
			//the acceleration values are set wich respect to the recieved link
			this.acc = new V2D(obj.pos.x - (dif.x + this.pos.x), obj.pos.y - (dif.y + this.pos.y));
			//the acceleration is limited to 200 to prevent crazy motion with crazy user interaction
			this.acc.x = HSMath.setToLimit(this.acc.x, HSMath.limit);
			this.acc.y = HSMath.setToLimit(this.acc.y, HSMath.limit);
			this.acc.multi(this.elasticity);
			this.speed.inc(this.acc);
			this.pos.inc(this.speed)
			
			this.speed.multi(this.damping);
		}
		
		//the translation propagates down to the children
		public function translateChild(t:Number): void {
			switch(this.typ){
				//if the current link is at the top
				case 0:
					this.child.translateChild(t);
					break;
				//if the current link is in the middle, translate with respect to parent and then
				//propagate the translation
				case 1:
					this.translate(this.parent, this.pDif);
					this.child.translateChild(t);
					break;
				//if at the end, same as in the middle but no propagation
				case 2:
					this.translate(this.parent, this.pDif);
					break;
				default:
					trace("something is wrong");
			}
		}
		
		//the translation propagates up to the parents
		public function translateParent(t:Number): void {
			switch(this.typ){
				case 0:
					this.translate(this.child, this.cDif);
					break;
				case 1:
					this.translate(this.child, this.cDif);
					this.parent.translateParent(t);
					break;
				case 2:
					this.parent.translateParent(t);
					break;
				default:
					trace("something is wrong");
			}
		}
		
		//translation of the link whose translation will propagate to the rest of the chain,
		//if it's in the middle the propagation will occur in both directions, both up and down
		public function translationOrigin(x:Number, y:Number, t:Number): void {
			switch(this.typ){
				case 0:
					this.pos.set(x, y);
					this.child.translateChild(t);
					break;
				case 1:
					this.pos.set(x, y);
					this.child.translateChild(t);
					this.parent.translateParent(t);
					break;
				case 2:
					this.pos.set(x, y);
					this.parent.translateParent(t);
					break;
				default:
					trace("something is wrong");
			}
		}
	}
}