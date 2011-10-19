package thanhtran.utils {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class GeomUtil {
		
		/**
		 * Gets the angle formed by the line segment of 2 points and the X-axis
		 * @param	p0
		 * @param	p1
		 * @return	angle in Degree
		 */
		public static function getAnglePt(p0: Point, p1: Point): Number {
			return getAngle(p0.x, p0.y, p1.x, p1.y);
		}
		
		/**
		 * Gets the angle formed by the line segment of 2 points (defined by 2 sets of coordinates) and the X-axis
		 * @param	x0
		 * @param	y0
		 * @param	x1
		 * @param	y1
		 * @return	angle in Degree
		 */
		public static function getAngle(x0: Number, y0: Number, x1: Number, y1: Number): Number {
			var dx:Number = x1 - x0;
			var dy:Number = y1 - y0;		
			return (Math.atan2(dy, dx) * 180 / Math.PI);
		}
		
		/**
		 * Gets the distance between 2 points
		 * @param	p0
		 * @param	p1
		 * @return
		 */
		public static function getDistancePt(p0: Point, p1: Point): Number {
			return getDistance(p0.x, p0.y, p1.x, p1.y);
		}
		
		/**
		 * Gets the distance between 2 points defined by 2 sets of coordinates
		 * @param	x0
		 * @param	y0
		 * @param	x1
		 * @param	y1
		 * @return
		 */
		public static function getDistance(x0: Number, y0: Number, x1: Number, y1: Number): Number {
			var dx:Number = x1 - x0;
			var dy:Number = y1 - y0;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
	}

}