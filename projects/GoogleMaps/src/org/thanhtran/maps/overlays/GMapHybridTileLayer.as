/*
 * Copyright (c) 2008 Tran Trong Thanh - trongthanh@gmail.com
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
	import com.google.maps.interfaces.ITileLayer;
	import com.google.maps.TileLayerBase;
	import com.google.maps.interfaces.IMapType;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import org.thanhtran.maps.info.GMapInfo;
	
	/**
	* ...
	* @author Thanh Tran
	*/
	public class GMapHybridTileLayer extends TileLayerBase implements ITileLayer {
		public static const MIN_RESOLUTION: Number = 1;
		public static const MAX_RESOLUTION: Number = 17;
		
		protected var pendingTileLoaders: Array = [];
		private var gmapInfo: GMapInfo = GMapInfo.instance;
		
		public function GMapHybridTileLayer(alpha: Number = 1) {
			super(gmapInfo.getGMapCopyrightCollection(), MIN_RESOLUTION, MAX_RESOLUTION, alpha);
			gmapInfo.addEventListener(Event.COMPLETE, gmapReadyHandler);
		}
		
		protected function gmapReadyHandler(event: Event): void {
			if (gmapInfo.isReady) {
				var tileLoader: Object;
				var numLoaders: int = pendingTileLoaders.length;
				while (tileLoader = pendingTileLoaders.pop()) {
					var tileUrl: String = gmapInfo.getHybridTileURL(tileLoader.tilePosition, tileLoader.zoom);
					tileLoader.loader.load(new URLRequest(tileUrl));
				}
			}
		}
		
		override public function loadTile(tilePosition: Point, zoom: Number): DisplayObject {
			//trace("zoom: " + zoom);
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			if (gmapInfo.isReady) {
				var tileUrl: String = gmapInfo.getHybridTileURL(tilePosition, zoom);
				loader.load(new URLRequest(tileUrl));
			} else {
				pendingTileLoaders.push( {loader: loader, tilePosition: tilePosition, zoom: zoom } );
			}
			return loader;
		}
		
		private function loaderIOErrorHandler(event: IOErrorEvent): void {
			//do nothing
		}
	}
	
}