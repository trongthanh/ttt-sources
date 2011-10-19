package int3ractive.mosaicwall.model {
	import flash.geom.Point;
	import int3ractive.mosaicwall.view.CellDisplay;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Cell {
		public var width: uint;
		public var height: uint;
		public var x: int;
		public var y: int;
		public var adjacentCells: Array = [];
		public var cellDisplay: CellDisplay;
		
		public function Cell(x: int, y: int, width: int, height: uint) {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
		}
		
		public function get right(): int {
			return x + width;
		}
		
		public function get bottom(): int {
			return y + height;
		}
		
		public function get left(): int {
			return x;
		}
		public function get top(): int {
			return y;
		}
		
		/**
		 * Checks if this cell's borders cross the point
		 * @param	p
		 * @return
		 */
		public function crossPoint(p: Point): Boolean {
			var crossed: Boolean = false;
			if (!p) return crossed;
			
			for (var i: int = left; i < right; ++i) {
				for (var j: int = top; j < bottom; ++j) {
					//iterate around the border:
					if (i == left || i == right || j == top || j == bottom) {
						if (p.x == i && p.y == j) {
							crossed = true;
							break;
						}
					}					
				}
			}
			
			return crossed;
			
		}
		
		public function getAdjacentPoints(): Array {
			var al: int = x - 1;
			var at: int = y - 1;
			var ar: int = al + width + 2;
			var ab: int = at + height + 2;
			
			var pointsArr: Array = []
			for (var i: int = al; i < ar; ++i) {
				for (var j: int = at; j < ab; ++j) {
					//iterate around the border:
					if (i == al || i == ar || j == at|| j == ab) {
						pointsArr.push(new Point(i, j));
					}
				}
			}
			return pointsArr;
		}
		
	}

}