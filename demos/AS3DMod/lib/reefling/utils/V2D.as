/**
 * This class is ported from an AS2 version at: http://www.prodevtips.com/2007/11/06/dynamics-and-procedural-animation-in-flash/
 */
package reefling.utils {
	import flash.display.MovieClip;

	public class V2D {
		
		public var x:Number;
		public var y:Number;
		
		public function V2D(x:Number, y:Number): void {
			this.x = x;
			this.y = y;
		}
		
		public function set(x: Number, y: Number): void {
			this.x = x;
			this.y = y;
		}
		
		public function setVpos(v:V2D): void {
			this.x = v.x;
			this.y = v.y;
		}
		
		public function divideScal(num:Number): void {
			this.x /= num;
			this.y /= num;
		}
		
		public function multi(num:Number): void {
			this.x *= num;
			this.y *= num;
		}
		
		public function multiV(v:V2D): void {
			this.x *= v.x;
			this.y *= v.y;
		}
		
		public function inc(p:V2D): void {
			this.x += p.x;
			this.y += p.y;
		}
		
		public function incScal(num:Number): void {
			this.x += num;
			this.y += num;
		}
		
		public function incScals(x:Number, y:Number): void {
			this.x += x;
			this.y += y;
		}
		
		public function moveMovie(m:MovieClip): void {
			m._x = this.x;
			m._y = this.y;
		}
		
		public function movieSet(m:MovieClip): void {
			this.x = m._x;
			this.y = m._y;
		}
		
		public function getAngle():Number {
			return Math.atan(this.y/this.x);
		}
		
		public function decToZero(num:Number): void {
			if(Math.abs(this.x) < num)
				this.x = 0;
			else{
				if(this.x < 0)
					this.x += num;
				else
					this.x -= num;
			}
				
			if(Math.abs(this.y) < num)
				this.y = 0;
			else{
				if(this.y < 0)
					this.y += num;
				else
					this.y -= num;
			}
		}
	}
}