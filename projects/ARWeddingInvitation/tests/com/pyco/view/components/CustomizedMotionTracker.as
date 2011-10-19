package com.pyco.view.components {
	import com.gskinner.geom.ColorMatrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import uk.co.soulwire.cv.MotionTracker;
	
	/**
	 * ...
	 * @author Thu.Hoang
	 */
	public class CustomizedMotionTracker extends MotionTracker {
		protected var trackingStartX: Number = 0;
		protected var trackingStartY: Number = 0;
		protected var trackingWidth: Number = 800;
		protected var trackingHeight: Number = 600;
		
		protected var isFirstTime: Boolean = true;
		
		public function CustomizedMotionTracker(source: Video = null) {
			super(source);
		}
		
		public function set trackingArea(rectangle: Rectangle): void {
			trackingStartX = rectangle.x;
			trackingStartY = rectangle.y;
			trackingWidth = rectangle.width;
			trackingHeight = rectangle.height;
			
			_mtx = new Matrix();
			//_mtx.translate(trackingStartX, trackingStartY);
		}
		
		override public function get trackingArea() : Rectangle { 
			return new Rectangle(trackingStartX, trackingStartY, trackingWidth, trackingHeight); 
		}
		
		/*override public function set input(v : Video) : void {
			_src = v;
			if ( _now != null ) { 
				_now.dispose(); 
				_old.dispose(); 
			}
			_now = new BitmapData(trackingWidth, trackingHeight, false);
			_old = new BitmapData(trackingWidth, trackingHeight, false);
		}*/
		
		override public function track(): void {
			_now.draw(_src, _mtx);
			_now.draw(_old, null, null, BlendMode.DIFFERENCE);
			
			_now.applyFilter(_now, new Rectangle(0, 0, trackingWidth, trackingHeight), new Point(trackingStartX, trackingStartY), _col);
			_now.applyFilter(_now, new Rectangle(0, 0, trackingWidth, trackingHeight), new Point(trackingStartX, trackingStartY), _blr);
			
			_now.threshold(_now, new Rectangle(0, 0, trackingWidth, trackingHeight), new Point(trackingStartX, trackingStartY), '>', 0xFF333333, 0xFFFFFFFF);
			_old.draw(_src, _mtx/*new Matrix(1, 0, 0, 1, trackingStartX, trackingStartY)*/);
			
			var area : Rectangle = _now.getColorBoundsRect(0xFFFFFFFF, 0xFFFFFFFF, true);
			_act = ( area.width > ( trackingWidth / 100) * _min || area.height > (trackingHeight / 100) * _min );
			
			if ( _act ) {
				_box = area;
				if (isFirstTime) {
					x = _box.x + _box.width;
					y = _box.y + _box.height;
					isFirstTime = false;
				} else {
					x = _box.x + (_box.width / 2);
					y = _box.y + (_box.height / 2);
				}
			}
		}
	}

}