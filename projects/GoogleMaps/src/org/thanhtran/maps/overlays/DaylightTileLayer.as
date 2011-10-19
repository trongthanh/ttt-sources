/*
 * Copyright (c) 2008 Tran Trong Thanh - trongthanh@gmail.com
 * Daylight data service (c) www.daylightmap.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.thanhtran.maps.overlays {
	import com.google.maps.TileLayerBase;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import org.thanhtran.maps.info.DaylightMapInfo;
	
	/**
	 * ...
	 * @author Thanh Tran - trongthanh@gmail.com
	 */
	public class DaylightTileLayer extends TileLayerBase {
		public static const MIN_RESOLUTION: Number = 1;
		public static const MAX_RESOLUTION: Number = 8;
		
		protected var withNightLights: Boolean;
			
		public function DaylightTileLayer(withNightLights: Boolean = false, alpha: Number = 0.6) {
			super(DaylightMapInfo.instance.getDaylightMapCopyrightCollection(), MIN_RESOLUTION, MAX_RESOLUTION, alpha);
			this.withNightLights = withNightLights;
		}
		
		override public function loadTile(tilePosition: Point, zoom: Number): DisplayObject {
			var loader: Loader = new Loader();
			var tileUrl: String = DaylightMapInfo.instance.getDaylightOverlayTileURL(tilePosition, zoom, withNightLights);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			loader.load(new URLRequest(tileUrl));
			
			return loader;
		}
		
		private function loaderErrorHandler(event: IOErrorEvent): void {
			
		}
		
	}
	
}