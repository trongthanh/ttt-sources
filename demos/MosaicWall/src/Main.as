package {
	import flash.display.Sprite;
	import flash.events.Event;
	import int3ractive.mosaicwall.model.Cell;
	import int3ractive.mosaicwall.model.Grid;
	import int3ractive.mosaicwall.view.GridDisplay;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#FFFFFF', frameRate='31', width='800', height='600')]
	public class Main extends Sprite {
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			createGrid();
		}
		
		private function createGrid():void {
			
			var cellList: Array = [
			//row 1
			new Cell(0, 0, 5, 4) , new Cell(5, 0, 2, 1) , new Cell(7, 0, 2, 1) , new Cell(9, 0, 1, 2) , new Cell(10, 0, 2, 2)
			//row 2
			,new Cell(0, 4, 3, 2) , new Cell(3, 4, 1, 2), new Cell(4, 4, 1, 1), new Cell(5, 1, 2, 4) 
			,new Cell(7, 1, 2, 2), new Cell(9, 2, 1, 1) , new Cell(10, 2, 2, 1)
			//row 3
			,new Cell(0, 6, 1, 1) , new Cell(1, 6, 3, 1), new Cell(4, 5, 2, 2), new Cell(6, 5, 1, 2) 
			,new Cell(7, 3, 5, 4)
			
			]
			
			var grid: Grid = new Grid(12, 7);
			grid.cells = cellList;
			grid.checkAdjacentCells();
			
			var gridDisplay: GridDisplay = new GridDisplay(grid);
			gridDisplay.x = 20;
			gridDisplay.y = 20;
			addChild(gridDisplay);
			gridDisplay.render();
		}
		
	}
	
}