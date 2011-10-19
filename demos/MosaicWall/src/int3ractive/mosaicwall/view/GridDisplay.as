package int3ractive.mosaicwall.view {
	import flash.display.Sprite;
	import int3ractive.mosaicwall.model.Cell;
	import int3ractive.mosaicwall.model.Grid;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class GridDisplay extends Sprite {
		private var _gridData: Grid;
		public var sizeX: Number = 50;
		public var sizeY: Number = 50;
		
		public function GridDisplay(gridData: Grid) {
			_gridData = gridData;
			
		}
		
		public function render(): void {
			graphics.beginFill(0x333333, 0.5);
			graphics.drawRect(0, 0, sizeX * _gridData.width, sizeY * _gridData.height);
			graphics.endFill();
			
			var cells: Array = _gridData.cells;
			var item: Cell;
			var cellMovie: CellDisplay;
			for (var i:int = 0; i < cells.length; i++) {
				item = cells[i];
				cellMovie = new CellDisplay(item, item.width, item.height, sizeX, sizeY, Math.random() * uint.MAX_VALUE);
				cellMovie.x = item.x * sizeX;
				cellMovie.y = item.y * sizeY;
				cellMovie.render();
				item.cellDisplay = cellMovie;
				addChild(cellMovie);
			}
			
		}
		
	}

}