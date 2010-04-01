/**
 * This class is ported from an AS2 version at: http://www.prodevtips.com/2007/11/06/dynamics-and-procedural-animation-in-flash/
 */
package reefling.utils {
	public class HSMath {
		
		public static var HSRAD:Number = 0.017453293;
		public static var HSDEG:Number = 57.29577951;
		public static var PIthru2:Number = Math.PI/2;
		public static var PIthru2times3:Number = Math.PI * 1.5;
		public static var PItimes2:Number = Math.PI*2;
		public static var limit:Number = 200;
		//static var ORIGO:hsPoint = new hsPoint(0, 0, 0);
		
		public static function d2dif(P1:V2D, P2:V2D):V2D{
			var temp:V2D = new V2D(P2.x-P1.x, P2.y-P1.y);
			return temp;
		}
		
		public static function make_neg(n:Number):Number{
			if(n > 0)
				return -n;
			
			return n;
		}
		
		public static function d2divideRange(P1:V2D, P2:V2D):Number{
			return (P2.y - P2.x) / (P1.y - P1.x);
		}
		
		public static function getNegPos(n:Number):Number{
			if(n < 0)
				return -1;
			else if(n > 0)
				return 1;
				
			return 0;
		}
		
		public static function setToLimit(v:Number, l:Number):Number{
			if(v > l)
				return l;
			
			if(v < -l)
				return -l;
				
			return v;
		}
		
		public static function upToZero(v:Number):Number{
			if(v < 0)
				return 0;
			else
				return v;
		}
		
		public static function convertAngle(startAngle:Number, angle:Number):Number{
			angle *= HSMath.HSDEG;
			angle = HSMath.continuousAngle(angle);
			angle -= startAngle;
			return angle;
		}
		
		public static function continuousAngle(angle:Number):Number{
			if (angle < 0)
				angle += 180;
				
			return angle;
		}
		
		public static function d2abs(P1:V2D, P2:V2D):Number{
			var temp:V2D = HSMath.d2dif(P1, P2);
			return Math.sqrt(Math.pow(temp.x, 2) + Math.pow(temp.y, 2));
		}
		
		public static function negaPosi(n:Number):Number{
			if(Math.random() < 0.5)
				return -n;
				
			return n;
		}
		
		public static function generateCode(n:Number):String{
			var temp:String = new String("abcdefghijklmnopqrstuvxyz0123456789");
			var code:String = "";
			for(var i:Number = 0; i < n; i++){
				code += temp.charAt(int(Math.random()*temp.length));
			}
			
			return code;
			
		}
		
	}
}