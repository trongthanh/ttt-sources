/**
 * FLARToolKit example - Simple cube PV3D
 * --------------------------------------------------------------------------------
 * Copyright (C)2010 rokubou
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 * 
 * Contributors
 *  rokubou
 * Modified from FLARTK_Example_Single_SimpleCube_Away3D
 * by Thanh Tran
 */
package int3ractive.flar {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import flash.utils.getTimer;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import int3ractive.utils.Ticker;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import jp.nyatla.as3utils.NyMultiFileLoader;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.analyzer.raster.threshold.FLARRasterThresholdAnalyzer_SlidePTile;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.support.away3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.away3d.FLARCamera3D;
	
	
	

	public class FLARTKAway3DBase extends Sprite {
		
		/**
		 * Screen width
		 */
		protected var canvasWidth:int;
		/**
		 * Screen height
		 */
		protected var canvasHeight:int;
		
		/**
		 * 
		 */
		protected var captureWidth:int;
		protected var captureHeight:int;
		
		/**
		 * Length of the marker (px)
		 */
		protected var codeWidth:int;
		
		/**
		 * File name of the camera parameters
		 * Need to read because it contains an internal process that is not initialized.
		 * With some exceptions the use 16:9, so it can load a parameter file.
		 */
		protected var cameraParamFile:String = 'data/camera_para.dat';
		
		/**
		 * Marker pattern (.pat) file
		 */
		protected var markerPatternFile:String = 'data/L.pat';

		/**
		 * Camera parameter data
		 * Include information such as compensation for the aspect ratio and distortion
		 * @see org.libspark.flartoolkit.core.param.FLARParam
		 */
		protected var cameraParam:FLARParam;
		
		/**
		 * Marker pattern
		 * If you use multiple patterns and markers in the Vector control
		 * @see org.libspark.flartoolkit.core.FLARCode
		 */
		protected var markerPatternCode:FLARCode;
		
		/**
		 * @see flash.media.Camera
		 */
		protected var webCamera:Camera;
		
		/**
		 * flash.media.Video
		 */
		protected var video:Video;
		
		/**
		 * Bitmap input from a Web camera
		 * @see flash.display.Bitmap
		 */
		private var capture:Bitmap;
		
		/**
		 * Raster Image
		 * @see org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData
		 */
		private var raster:FLARRgbRaster_BitmapData;
		
		/**
		 * Marker detector
		 * @see org.libspark.flartoolkit.detector.FLARSingleMarkerDetector
		 */
		private var detector:FLARSingleMarkerDetector;
		
		/**
		 * When the threshold image binarization
		 * If you use a fixed value, please set the value to the location intended to be used.
		 * Recognize differences arise.
		 */
		private var _threshold:int = 110;
		
		/**
		 *  Classes for automatic adjustment of the threshold
		 * @see org.libspark.flartoolkit.core.analyzer.raster.threshold.FLARRasterThresholdAnalyzer_SlidePTile
		 */
		private var _threshold_detect:FLARRasterThresholdAnalyzer_SlidePTile;
		
		/**
		 * 
		 * @see away3d.containers.View3D
		 */
		protected var view3d:View3D;
		
		/**
		 * 
		 * @see org.papervision3d.scenes.Scene3D
		 */
		protected var scene3d:Scene3D;
		
		/**
		 * 
		 * @see org.libspark.flartoolkit.support.away3d.FLARCamera3D
		 */
		protected var camera3d:FLARCamera3D;
		
		/**
		 * Marker base node
		 * @see org.libspark.flartoolkit.support.away3d.FLARBaseNode
		 */
		protected var markerNode:FLARBaseNode;
		
		/**
		 * Container of 3D objects
		 */
		protected var container: ObjectContainer3D;
		
		/**
		 * Contains information about the marker recognition
		 * @see org.libspark.flartoolkit.core.transmat.FLARTransMatResult
		 */
		protected var resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		protected var markerResolution: uint = 16;
		protected var markerPercentage: uint = 50;
		
		protected var isMarkerAdded: Boolean;
		
		protected var hideMarkerNodeWhenRemoved: Boolean;
		
		protected var lastCheckTime: int = 0;
		protected static const DELAY_TIME: int = 40;
		
		//Signals:
		private var _initialized: Signal;
		private var _markerAdded: Signal;
		private var _markerRemoved: Signal;
		private var _markerUpdated: Signal;
		
		
		/**
		 * Constructor
		 */
		public function FLARTKAway3DBase() {
			
		}
		
		/**
		 * initialize
		 */
		protected function init():void {
			_initialized = new Signal();
			_markerAdded = new Signal();
			_markerRemoved = new Signal();
			_markerUpdated = new Signal();
			
			isMarkerAdded = false;
			// 各種サイズの初期化
			this.captureWidth = 320;
			this.captureHeight = 240;
			
			// W:H の比率は必ず captureWidth:captureHeight=canvasWidth:canvasHeight にすること
			this.canvasWidth = 640
			this.canvasHeight = 480;
			
			// マーカーの一辺の長さ(px)
			this.codeWidth = 80;

			// start load parameter files
			this.paramLoad();
		}
		
		/**
		 * カメラパラメータなどを読み込み、変数にロード
		 *@return void
		 */
		private function paramLoad():void {
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				this.cameraParamFile, URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
	 				cameraParam = new FLARParam();
					cameraParam.loadARParam(data);
					cameraParam.changeScreenSize(captureWidth, captureHeight);
				});
			mf.addTarget(
				this.markerPatternFile, URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					// 分割数(縦・横)、黒枠の幅(縦・横)
					markerPatternCode = new FLARCode(markerResolution, markerResolution, markerPercentage, markerPercentage);
					markerPatternCode.loadARPattFromFile(data);
				}
			);
			//終了後、初期化処理に遷移するように設定
			mf.addEventListener(Event.COMPLETE, initialization);
			//ロード開始
			mf.multiLoad();
			
			return;
		}
		
		/**
		 * webカメラや表示、detectorの初期化
		 * @return void
		 */
		private function initialization(e:Event): void {
			this.removeEventListener(Event.COMPLETE, initialization);
			
			// Setup camera
			this.webCamera = Camera.getCamera();
			if (!this.webCamera) {
				//throw new Error('No webcam!!!!');
				trace("No webcam!!!");
				return;
			}
			this.webCamera.setMode( this.captureWidth, this.captureHeight, 30);
			this.video = new Video( this.captureWidth, this.captureHeight);
			this.video.attachCamera(this.webCamera);
			
			// setup ARToolkit
			this.capture = new Bitmap(new BitmapData(this.captureWidth, this.captureHeight, false, 0),
										  PixelSnapping.AUTO,
										  true);
			// ウェブカメラの解像度と表示サイズが異なる場合は拡大する
			this.capture.width = this.canvasWidth;
			this.capture.height = this.canvasHeight;
			
			// キャプチャーしている内容からラスタ画像を生成
			this.raster = new FLARRgbRaster_BitmapData( this.capture.bitmapData);
			
			// キャプチャーしている内容を addChild
			//this.addChild(this.capture);
			//use video directly
			video.width = canvasWidth;
			video.height = canvasHeight;
			addChild(video);
			
			
			// setup Single marker detector
			this.detector = new FLARSingleMarkerDetector( this.cameraParam,
														  this.markerPatternCode,
														  this.codeWidth);
			// 継続認識モード発動
			this.detector.setContinueMode(true);
			// しきい値調整
			this._threshold_detect=new FLARRasterThresholdAnalyzer_SlidePTile(15,4);
			
			// 初期化完了
			//dispatchEvent(new Event(Event.INIT));
			_initialized.dispatch();
			
			// 3D objects initialization
			this.supportLibsInit();
			
			// スタート
			this.start();
		}
		
		/**
		 * 3Dオブジェクト関係の初期化
		 * 使用する3Dライブラリに応じてこの部分を書き換える。
		 */
		protected function supportLibsInit(): void {
			
			// シーンの生成
			this.scene3d = new Scene3D();
			this.markerNode = new FLARBaseNode();
			this.scene3d.addChild(this.markerNode);
			
			container = new ObjectContainer3D();
			markerNode.addChild(container);
			
			// 3Dモデル表示時の視点を設定
			this.camera3d = new FLARCamera3D();
			this.camera3d.setParam(this.cameraParam);
			
			// PV3DのViewport3Dと似たようなもの
			this.view3d = new View3D({scene:this.scene3d, camera:camera3d});
			
			// 微調整
			this.view3d.x = this.captureWidth -6;
			this.view3d.y = this.captureHeight;
			this.addChild(this.view3d);
		}
		
		/**
		 * create 3D objects
		 */
		protected function createObject():void {
			//overwrite to create objects here
		}
		
		/**
		 * 3Dオブジェクトの生成と登録
		 * マーカーイベント方式を採用しているため、markerイベントを登録
		 * スレッドのスタート
		 */
		protected function start():void {
			// create objects
			this.createObject();
			
			// マーカー認識・非認識時用のイベントを登録
			//this.addEventListener(MarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			//this.addEventListener(MarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			//this.addEventListener(MarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			markerAdded.add(onMarkerAdded);
			markerRemoved.add(onMarkerRemoved);
			markerUpdated.add(onMarkerUpdated);
			
			
			// 処理開始
			//this.addEventListener(Event.ENTER_FRAME, this.run);
			Ticker.tick.add(run);
		}
		
		/**
		 * マーカーを認識するとこの処理が呼ばれる
		 */
		public function onMarkerAdded():void {
//			trace("[add]");
			onMarkerUpdated();
		}
		
		/**
		 * マーカーの継続認識中はここ
		 * このサンプルではこの処理が呼ばれるような実装していない。
		 */
		public function onMarkerUpdated():void {
			// 今回は実装していない
			this.detector.getTransformMatrix(this.resultMat);
			this.markerNode.setTransformMatrix(this.resultMat);
		}
		
		/**
		 * マーカーが認識できなくなるとこれが呼ばれる
		 */
		public function onMarkerRemoved():void {
			
		}
		
		/**
		 * ここで処理振り分けを行っている
		 */
		protected function run():void {
			var now: int = getTimer();
			if (now - lastCheckTime < DELAY_TIME) {
				//skip until delay enough
				return;
			}
			lastCheckTime = now;
			this.capture.bitmapData.draw(this.video);
			
			// Marker detect
			var detected:Boolean = false;
			try {
				detected = this.detector.detectMarkerLite(this.raster, this._threshold) && this.detector.getConfidence() > 0.7;
			} catch (e:Error) {}
			
			// 認識時の処理
			trace( "detected : " + detected );
			if (detected) {
				// 一工夫できる場所
				// 前回認識した場所と今回認識した場所の距離を測り、
				// 一定範囲なら位置情報更新 MARKER_UPDATED を発行するなど、
				// 楽しい工夫が出来る。 参照: FLARManager
				//this.dispatchEvent(new MarkerEvent(MarkerEvent.MARKER_ADDED));
				if (isMarkerAdded) {
					_markerUpdated.dispatch();
				} else {
					isMarkerAdded = true;
					_markerAdded.dispatch();
				}
				markerNode.alpha = 1;
			// 非認識時
			} else {
				//this.dispatchEvent(new MarkerEvent(MarkerEvent.MARKER_REMOVED));
				isMarkerAdded = false;
				_markerRemoved.dispatch();
				if (hideMarkerNodeWhenRemoved) markerNode.alpha = 0;
				// マーカがなければ、探索+DualPTailで基準輝度検索
				// マーカーが見つからない場合、処理が重くなるので状況に応じてコメントアウトすると良い
				var th:int=this._threshold_detect.analyzeRaster(this.raster);
				this._threshold=(this._threshold+th)/2;
			}
			this.view3d.render();
		}
		
		public function get initialized():ISignal { return _initialized; }
		
		public function get markerAdded():ISignal { return _markerAdded; }
		
		public function get markerRemoved():ISignal { return _markerRemoved; }
		
		public function get markerUpdated():Signal { return _markerUpdated; }
	}
}