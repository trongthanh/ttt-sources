/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org + blog.papervision3d.org + osflash.org/papervision3d
 *
 *  Modified by Thanh Tran trongthanh@gmail.com
 */

// _______________________________________________________________________ PaperCloud

package
{
import fl.transitions.Tween;
import flash.display.*;
import flash.display.stage.*;
import flash.events.*;
import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.Dictionary;
import flash.net.URLRequest;
//import flash.filters.*;


// Import Papervision3D
import org.papervision3d.core.proto.*;
import org.papervision3d.scenes.*;
import org.papervision3d.cameras.*;
import org.papervision3d.objects.*;
import org.papervision3d.materials.*;

//	Flickr API
import com.adobe.webapis.flickr.events.FlickrResultEvent;
import com.adobe.webapis.flickr.methodgroups.Photos;
import com.adobe.webapis.flickr.PagedPhotoList;
import com.adobe.webapis.flickr.Photo;
import com.adobe.webapis.flickr.PhotoUrl;
import com.adobe.webapis.flickr.FlickrService;
import org.trongthanh.flickr.FlickrPhotoURL;
import org.trongthanh.flickr.FlickrPhotoSize;
import flash.system.*;

//custom
import PhotoItem;

public class Main extends Sprite
{
	// ___________________________________________________________________ 3D vars

	private var container :Sprite;
	private var scene     :MovieScene3D;
	private var camera    :Camera3D;

	private var planeByContainer :Dictionary;


	// ___________________________________________________________________ Album vars

	private var paperSize :Number = 0.5;
	private var cloudSize :Number = 1500;
	private var rotSize   :Number = 360;
	private var maxPhotos :Number = 50;
	private var num       :Number = 0;


	// ___________________________________________________________________ stage

	public var iFull :SimpleButton = new SimpleButton();
	public var previous_btn: SimpleButton;
	public var next_btn: SimpleButton;
	public var loadingProgress_mc: MovieClip;
	public var currentPhoto_tf: TextField;
	public var progress_tf: TextField;
	public var loadingWheel_mc: MovieClip;
	public var start_btn: SimpleButton;
	//new
	public var zoomOut_btn: SimpleButton;
	public var changeUser_btn: SimpleButton;
	public var changeUser_mc: ChangeUserDialog;
	
	// ___________________________________________________________________ Flickr
	private var service: FlickrService;
	private var photos: Photos;
	private const MY_API_KEY: String = "d4fe2442dcd10f3e420a41da80c21c9e";
	private const MY_ID: String = "9803330@N04";
	private var photoArray: Array;
	private var currentPhoto: int;
	private var bigPhoto: MovieClip;
	private var photoLoader: Loader;
	private var isLoading: Boolean;
	private var isCameraMoving: Boolean;
	private var isAdded: Boolean;
	private var fadeIn: Tween;
	private var currentID: String;

	// ___________________________________________________________________ main

	public function Main()
	{
		Security.allowDomain("*");
		
		if (root.loaderInfo.parameters.flickrid != undefined) {
			currentID = String(root.loaderInfo.parameters.flickrid);
		} else {
			currentID = MY_ID;
		}
		
		init();
	}
	
	private function init(): void {
		iFull.visible = stage.hasOwnProperty("displayState");
		iFull.addEventListener( MouseEvent.CLICK, goFull );
		stage.quality = StageQuality.MEDIUM;
		addChild( iFull );
		//
		
		//navigator:
		var textFormat: TextFormat = new TextFormat();
		textFormat.font = "Arial";
		textFormat.size = 10;
		textFormat.bold = true;
		//textFormat.color = 0x000000;
		currentPhoto_tf = new TextField();
		currentPhoto_tf.background = true;
		currentPhoto_tf.backgroundColor = 0xFFFFFF;
		currentPhoto_tf.border = true;
		currentPhoto_tf.borderColor = 0x000000;
		currentPhoto_tf.width = 45;
		currentPhoto_tf.height = 16;
		currentPhoto_tf.x = 54;
		currentPhoto_tf.y = 458;
		currentPhoto_tf.defaultTextFormat = textFormat;
		
		this.addChildAt(currentPhoto_tf, 1);
		
		previous_btn = new PreviousBtn();
		previous_btn.addEventListener(MouseEvent.CLICK, goPrevious);
		previous_btn.x = 4;
		previous_btn.y = 459;
		
		this.addChildAt(previous_btn, 2);
		
		next_btn = new NextBtn();
		next_btn.addEventListener(MouseEvent.CLICK, goNext);
		next_btn.x = 100;
		next_btn.y = 459;
		
		this.addChildAt(next_btn, 3);

		//new buttons
		zoomOut_btn.addEventListener(MouseEvent.CLICK, onZoomOutClick);
		start_btn.addEventListener(MouseEvent.CLICK, start3DScene);
		changeUser_btn.addEventListener(MouseEvent.CLICK, onChangeUserClick);
		changeUser_mc.addEventListener(ChangeFlickrUserEvent.CHANGE_USER, onChangeUser);
		
		//
		currentPhoto_tf.visible = false;
		next_btn.visible = false;
		previous_btn.visible = false;
		isLoading = false;
		isCameraMoving = false;
		isAdded = false;
		loadingProgress_mc.visible = false;
		zoomOut_btn.visible = false;
		start_btn.visible = false;
		changeUser_mc.hide();
		loadingWheel_mc.visible = true;
		
		//
		initFlickrService();
	}
	
	private function onZoomOutClick(e: MouseEvent): void {
		trace("rotate");
		var target :DisplayObject3D = new DisplayObject3D();

		var currentPlane: Plane = scene.getChildByName( "Photo" + currentPhoto ) as Plane;
		if (currentPlane == null) return;
	
		target.copyTransform( currentPlane);
		target.moveBackward( 1500 );
		
		camera.extra.goPosition.copyPosition( target );
		camera.extra.goTarget.copyPosition( new DisplayObject3D("centerPoint"));
		
		isAdded = true;
		loadingProgress_mc.visible = false;
		loadingWheel_mc.visible = false;
		
		// Render
		//scene.renderCamera( this.camera );
		
	}
	private function onChangeUserClick(e: MouseEvent): void {
		changeUser_mc.show();
	}
	/* *
	 * Init Flickr
	 * */
	private function initFlickrService(): void {
		service = new FlickrService(MY_API_KEY);
		service.addEventListener(FlickrResultEvent.PEOPLE_GET_PUBLIC_PHOTOS, receivePhotoList);
		service.people.getPublicPhotos(currentID,"date_taken,tags", maxPhotos, 1);
	}
	
	private function receivePhotoList(e: FlickrResultEvent) : void {
		if (e.success) {
			var photoList: PagedPhotoList = e.data.photos;
			maxPhotos = photoList.photos.length;
			var photo: Photo;
			photoArray = new Array();
			
			for (var i: int = 0; i < maxPhotos; i ++) {
				photo = photoList.photos[i];
				photoArray.push(photo);
			}
			
			bigPhoto = new BigPhotoContainer();
			bigPhoto.addEventListener(MouseEvent.CLICK, onBigPhotoContainerClick);
			
			start_btn.visible = true;
			loadingWheel_mc.visible = false;
		} else {
			loadingWheel_mc.visible = false;
			changeUser_mc.show();
			changeUser_mc.error_tf.text = "User ID error. Please change user!";
		}
		
	}
	
	private function start3DScene(e: MouseEvent): void {
		//start 3D scene:
		start_btn.visible = false;
		init3D();
		this.addEventListener( Event.ENTER_FRAME, loop );
	}
	
	private function onChangeUser(e: ChangeFlickrUserEvent): void {
		trace("on change user init");
		currentID = e.newUser.nsid;
		if (container != null) this.removeChild(container);
		container = null;
		this.removeEventListener( Event.ENTER_FRAME, loop );
		num = 0;
		// start up values
		currentPhoto_tf.text = "";
		currentPhoto_tf.visible = false;
		next_btn.visible = false;
		previous_btn.visible = false;
		isLoading = false;
		isCameraMoving = false;
		isAdded = false;
		loadingProgress_mc.visible = false;
		zoomOut_btn.visible = false;
		start_btn.visible = false;
		loadingWheel_mc.visible = true;
		//
		
		initFlickrService();
	}

	// ___________________________________________________________________ Init3D

	private function init3D():void
	{
		// Create container sprite and center it in the stage
		container = new Sprite();
		addChildAt( container, 0 ); // bottom
		container.x = stage.width / 2;
		container.y = stage.height / 2;

		// Create scene
		scene = new MovieScene3D( container );

		// Create camera
		camera = new Camera3D();
		camera.zoom = 5;

		// Store camera properties
		
		camera.extra =
		{
			goPosition: new DisplayObject3D(),
			goTarget:   new DisplayObject3D()
		};

		camera.extra.goPosition.copyPosition( camera );
		
		planeByContainer = new Dictionary();
		
		loadingWheel_mc.visible = false;
		zoomOut_btn.visible = true;
		next_btn.visible = true;
		currentPhoto_tf.visible = true;
		previous_btn.visible = true;
		currentPhoto = -1;
	}

	// ___________________________________________________________________ Create album

	private function createPhoto()
	{
		//var material:MovieAssetMaterial = new MovieAssetMaterial( "PhotoItem" );
		var photo: PhotoItem = new PhotoItem();
		photo.setFlickrPhoto(photoArray[num]);
		
		var material: MovieMaterial = new MovieMaterial(photo, true);

		//material.animated = true; // greatly reduce performance
		material.doubleSided = true;
		material.lineColor = 0xFFFFFF;
		
		//material.updateBitmap();

		var plane :Plane = new Plane( material, paperSize, 0, 2, 2 );
		
		// Randomize position
		var gotoData :DisplayObject3D = new DisplayObject3D();

		gotoData.x = Math.random() * cloudSize - cloudSize/2;
		gotoData.y = Math.random() * cloudSize - cloudSize/2;
		gotoData.z = Math.random() * cloudSize - cloudSize/2;

		gotoData.rotationX = Math.random() * rotSize;
		gotoData.rotationY = Math.random() * rotSize;
		gotoData.rotationZ = Math.random() * rotSize;

		plane.extra =
		{
			goto: gotoData,
			id: num
		};

		// Include in scene
		scene.addChild( plane, "Photo" + String( num ) );

		var container:Sprite = plane.container;
		container.buttonMode = true;
		container.addEventListener( MouseEvent.ROLL_OVER, doRollOver );
		container.addEventListener( MouseEvent.ROLL_OUT, doRollOut );
		container.addEventListener( MouseEvent.MOUSE_DOWN, doPress );

		planeByContainer[ container ] = plane;

		num++;
	}

	// ___________________________________________________________________ Button events

	private function doPress(event:Event):void
	{
		var plane:Plane = planeByContainer[ event.target ];
		plane.scaleX = 1;
		plane.scaleY = 1;
		setNewCameraTarget(plane);
		/*
		var target :DisplayObject3D = new DisplayObject3D();

		target.copyTransform( plane );
		target.moveBackward( 350 );

		camera.extra.goPosition.copyPosition( target );
		camera.extra.goTarget.copyPosition( plane );

		plane.material.lineAlpha = 0;

//		event.target.filters = null;

		//get number:
		
		currentPhoto = Number(plane.extra.id);
		currentPhoto_tf.text = String (currentPhoto + 1);
		*/
	};

	private function doRollOver(event:Event):void
	{
		var plane:Plane = planeByContainer[ event.target ];
		plane.scaleX = 1.1;
		plane.scaleY = 1.1;

		plane.material.lineAlpha = 1;

		//var glow:Number = Math.max( 20, Math.min( 30, 10 + 20 * (1 - plane.screenZ / cloudSize ) ) );
		//event.target.filters = [new GlowFilter( 0xFFFFFF, 0.7, glow, glow, 1, 1, false, false ) ];
	};


	private function doRollOut(event:Event):void
	{
		var plane:Plane = planeByContainer[ event.target ];
		plane.scaleX = 1;
		plane.scaleY = 1;

		plane.material.lineAlpha = 0;

//		event.target.filters = null;
	};


	// ___________________________________________________________________ Loop

	private function loop(event:Event):void
	{
		if( num < maxPhotos )
			createPhoto();

		update3D();

		//iFull.x = 640 + (stage.stageWidth - 640)/2;
		//iFull.y = 480 + (stage.stageHeight - 480)/2;
	}


	private function update3D():void
	{
		var target     :DisplayObject3D = camera.target;
		var goPosition :DisplayObject3D = camera.extra.goPosition;
		var goTarget   :DisplayObject3D = camera.extra.goTarget;

		camera.x -= (camera.x - goPosition.x) /32;
		camera.y -= (camera.y - goPosition.y) /32;
		camera.z -= (camera.z - goPosition.z) / 32;

		target.x -= (target.x - goTarget.x) /32;
		target.y -= (target.y - goTarget.y) /32;
		target.z -= (target.z - goTarget.z) /32;

		var paper :DisplayObject3D;
		var plane: Plane;
		var photoItem: PhotoItem;
		for( var i:int = 0; i < num ; i++ )
		{
			paper = scene.getChildByName( "Photo" + i );
			
			plane = paper;
			photoItem = plane.material["movie"] as PhotoItem;
			/*
			if (photoItem.isAdded == false) {
				plane.material.updateBitmap();
			}
			*/
			if (photoItem.isLoaded && photoItem.isAdded == false ) {
				photoItem.isAdded = true;
				plane.material.updateBitmap();
			}
			
			var goto :DisplayObject3D = paper.extra.goto;

			paper.x -= (paper.x - goto.x) / 32;
			paper.y -= (paper.y - goto.y) / 32;
			paper.z -= (paper.z - goto.z) / 32;

			paper.rotationX -= (paper.rotationX - goto.rotationX) /32;
			paper.rotationY -= (paper.rotationY - goto.rotationY) /32;
			paper.rotationZ -= (paper.rotationZ - goto.rotationZ) /32;
		}

		// Render
		scene.renderCamera( this.camera );
		
		//load Big photo:
		if (Math.abs(camera.x - goPosition.x) <= 10 && Math.abs(camera.y - goPosition.y) <= 10 && Math.abs(camera.z - goPosition.z) <= 10) {
			isCameraMoving = false;
		}
		
		if (!isLoading && !isCameraMoving && photoLoader != null && !isAdded) {
			//trace("rotX: " + goPosition.rotationX);
			showBigPhoto();
		}
		
	}
	// ___________________________________________________________________ Navigator

	private function goPrevious(e: MouseEvent): void {
		currentPhoto --;
		if (currentPhoto < 0) currentPhoto = maxPhotos - 1;
		
		var plane:Plane = scene.getChildByName( "Photo" + currentPhoto );
		plane.scaleX = 1;
		plane.scaleY = 1;

		setNewCameraTarget(plane);
	}
	
	private function goNext(e: MouseEvent): void {
		currentPhoto ++;
		if (currentPhoto >= maxPhotos) currentPhoto = 0;
		
		var plane:Plane = scene.getChildByName( "Photo" + currentPhoto );
		plane.scaleX = 1;
		plane.scaleY = 1;

		setNewCameraTarget(plane);
	}
	
	private function setNewCameraTarget(plane: Plane): void {
		var target :DisplayObject3D = new DisplayObject3D();

		target.copyTransform( plane );
		target.moveBackward( 350 );

		camera.extra.goPosition.copyPosition( target );
		camera.extra.goTarget.copyPosition( plane );

		plane.material.lineAlpha = 0;
		//get number:		
		currentPhoto = Number(plane.extra.id);
		currentPhoto_tf.text = String (currentPhoto + 1) + " of " + String(maxPhotos);

		isCameraMoving = true;
		isAdded = false;
		isLoading = false;
		removeLoadProgress();
		loadBigPhoto();
	}
	
	private function onBigPhotoContainerClick(e: MouseEvent): void {
		//if (e.target == bigPhoto) {
			bigPhoto.removeChild(photoLoader);
			this.removeChild(bigPhoto);
		//}
	}
	
	private function showBigPhoto(): void {
		if (currentPhoto < 0 || isLoading) return;
		trace("show photo");
		isAdded = true;
		photoLoader.x = (bigPhoto.width - photoLoader.width) / 2;
		photoLoader.y = (bigPhoto.height - photoLoader.height) / 2;
		bigPhoto.addChildAt(photoLoader, 1);
		var info_tf: TextField = bigPhoto.info_tf;
		var thisPhoto: Photo = photoArray[currentPhoto];
		
		var html: String = "<font size='16' color='#CCCCCC'><b>" + thisPhoto.title + "</b></font><br/>" + thisPhoto.dateTaken.toDateString();
		html += "<br/><br/>Tags:<br/>" + thisPhoto.tags.join(" &lt;<br/>") + " &lt;";
		info_tf.htmlText = html;
		
		this.addChild(bigPhoto);	
		
		fadeIn = new Tween(bigPhoto, "alpha", null, 0, 1, 0.5, true);
	}
	
	private function loadBigPhoto(): void {
		if (currentPhoto < 0 || isLoading) return;
		trace("load photo: " + currentPhoto);
		isLoading = true;
		var photoURL: String = FlickrPhotoURL.getURLfromPhoto(photoArray[currentPhoto], FlickrPhotoSize.MEDIUM);
		photoLoader = new Loader();
		var contentLoader: LoaderInfo = photoLoader.contentLoaderInfo;
		contentLoader.addEventListener(Event.COMPLETE, loadComplete);
		contentLoader.addEventListener(ProgressEvent.PROGRESS, loadProgress);
		photoLoader.load(new URLRequest(photoURL));
		loadingProgress_mc.visible = true;
		loadingProgress_mc.scaleX = 0;
		loadingWheel_mc.visible = true;
		
	}
	
	private function loadComplete(e:Event):void {
		isLoading = false;
		loadingWheel_mc.visible = false;
		removeLoadProgress();
	}
	
	private function removeLoadProgress(): void {
		if (photoLoader != null)
		photoLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
	}
	
	private function loadProgress(e: ProgressEvent): void {
		var loaderInfo: LoaderInfo = LoaderInfo(e.target);
		
		//var percent: int = Math.round((loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 100);
		//progress_tf.text = String (percent);
		loadingProgress_mc.scaleX = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
	}
	// ___________________________________________________________________ FullScreen

	private function goFull(event:MouseEvent):void
	{
		if( stage.hasOwnProperty("displayState") )
		{
			if( stage.displayState != StageDisplayState.FULL_SCREEN )
				stage.displayState = StageDisplayState.FULL_SCREEN;
			else
				stage.displayState = StageDisplayState.NORMAL;
		}
	}
	
	// ___________________________________________________________________Utilities
	function randRange(min:Number, max:Number):Number {
		var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
		return randomNum;
	}

}
}