package int3ractive.mosaicwall.model {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class Grid {
		public var width: uint;
		public var height: uint;
		public var cells: Array;
		
		public function Grid(width: uint, height: uint) {
			this.width = width;
			this.height = height;
		}
		
		public function checkAdjacentCells(): void {
			if (!cells) return;
			
			for (var i:int = 0; i < cells.length; i++) {
				var item:Cell = cells[i];
				var checkPoints: Array = item.getAdjacentPoints();
				
				for (var j:int = 0; j < cells.length; j++) {
					if (j == i) continue; //avoid checking same cell
					var checkItem:Cell = cells[j];
					
					for (var k:int = 0; k < checkPoints.length; k++) {
						var point: Point  = checkPoints[k];
						if (checkItem.crossPoint(point)) {
							trace("cross at: " + point);
							item.adjacentCells.push(checkItem);
						}
					}
				}
			}
		}
	}
}