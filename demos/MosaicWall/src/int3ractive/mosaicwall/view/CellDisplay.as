package int3ractive.mosaicwall.view {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import int3ractive.mosaicwall.model.Cell;
	import org.libspark.betweenas3.BetweenAS3;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class CellDisplay extends Sprite {
		private var _cellInfo: Cell;
		private var _uw: uint;
		private var _uh: uint;
		private var _sizeX: Number;
		private var _sizeY: Number;
		private var _color: uint;
		private var _padding: Number;
		
		public function CellDisplay(cellInfo: Cell, unitW: uint, unitH: uint, sizeX: Number, sizeY: Number, color: uint) {
			_cellInfo = cellInfo;
			_uw = unitW;
			_uh = unitH;
			_sizeX = sizeX;
			_sizeY = sizeY;
			_color = color;
			//default
			_padding = 2;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			
			render();
		}
		
		private function clickHandler(e:MouseEvent):void {
			trace("cell clicked:" + _cellInfo.x, _cellInfo.y);
			//BetweenAS3.to(this, { alpha:1 }, 0.5);
			trace( "_cellInfo.adjacentCells.length : " + _cellInfo.adjacentCells.length );
			for (var i:int = 0; i < _cellInfo.adjacentCells.length; i++) {
				var item: Cell = _cellInfo.adjacentCells[i];
				trace( "item : " + item );
				item.cellDisplay.blink();
			}
		}
		
		private function blink(): void {
			BetweenAS3.from(this, { alpha: 0.5 }, 0.5).play();
		}
		
		public function render(): void {
			var g: Graphics = this.graphics;
			g.clear();
			//g.lineStyle(1, _color, 1);
			g.beginFill(_color, 1);
			g.drawRoundRect(_padding, _padding, _uw * _sizeX - (2 *_padding), _uh * _sizeY - (2 * _padding), 10, 10);
			g.endFill();
		}
		
		public function get displayWidth(): Number {
			return _uw * _sizeX;
		}
		
		public function get displayHeight(): Number {
			return _uh * _sizeY;
		}
		
	}

}