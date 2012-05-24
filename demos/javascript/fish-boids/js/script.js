/**
 * Copyright: 2011 (c) int3ractive.com
 * Author: Thanh Tran - trongthanh@gmail.com
 */

//util

// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) {
    arguments.callee = arguments.callee.caller;
    var newarr = [].slice.call(arguments);
    (typeof console.log === 'object' ? log.apply.call(console.log, console, newarr) : console.log.apply(console, newarr));
  }
};

// make it safe to use console.log always
(function(b){function c(){}for(var d="assert,clear,count,debug,dir,dirxml,error,exception,firebug,group,groupCollapsed,groupEnd,info,log,memoryProfile,memoryProfileEnd,profile,profileEnd,table,time,timeEnd,timeStamp,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
{console.log();return window.console;}catch(err){return window.console={};}})());

window.debugEl = $('debug');
window.trace = function(line, str) {
  window.debugEl.getElement('.line' + line).set('html', str);
};

window.debugPoint = $('debug-point');
window.tracePos = function(screenX, screenY, anchorX, anchorY) {
  if(anchorX === undefined) anchorX = 0;
  if(anchorY === undefined) anchorY = 0;

  debugPoint.setPosition({x: anchorX + screenX, y: anchorY + screenY});
};

/* ====================== main scripts ========================= */

//namespace
var T3 = {};

function BoidScene() {};

BoidScene.prototype = {
  init: function (boidContainer, numBirds, isFish) {
    var viewWidth = boidContainer.getSize().x,
      viewHeight = boidContainer.getSize().y,
      scene = new THREE.Scene(),
      camera = new THREE.PerspectiveCamera( 75, viewWidth / viewHeight, 1, 10000 ),
      renderer = new THREE.CanvasRenderer(),
      birds = [],
      boids = [],
      boid, bird,
      that = this;

    if(isFish === undefined)  isFish = false;
    numBirds = numBirds || 50;

    camera.position.z = 450;

    for ( var i = 0; i < numBirds; i ++ ) {
      if (isFish) {
        boid = boids[ i ] = new Boid(2);
      } else {
        boid = boids[ i ] = new Boid(4);
      }

      boid.position.x = Math.random() * 500 - 250;
      boid.position.y = Math.random() * 500 - 250;
      boid.position.z = Math.random() * 500 - 250;
      boid.velocity.x = Math.random() * 2 - 1;
      boid.velocity.y = Math.random() * 2 - 1;
      boid.velocity.z = Math.random() * 2 - 1;
      boid.setAvoidWalls( true );
      boid.setWorldSize( 500, 500, 400 );

      if(isFish) {
        bird = birds[ i ] = new FishMesh();
      } else {
        bird = birds[ i ] = new BirdMesh();
      }

      bird.position = boids[ i ].position;
      bird.doubleSided = true;

      scene.add( bird );
    }

    // renderer.autoClear = false;
    //TODO: check for resize
    renderer.setSize( viewWidth, viewHeight );

    document.addEventListener( 'mousemove', this.onDocumentMouseMove.bind(this), false );

    /* debug 
     var materials = [];
     for ( var j = 0; j < 6; j ++ ) {
     materials.push( new THREE.MeshBasicMaterial( { color: Math.random() * 0xffffff } ) );
     }

     this.cube = new THREE.Mesh( new THREE.CubeGeometry( 10, 10, 10, 1, 1, 1, materials ), new THREE.MeshFaceMaterial() );
     this.cube.overdraw = true;
     scene.add( this.cube ); 
*/

    /*stats = new Stats();
     stats.domElement.style.position = 'absolute';
     stats.domElement.style.left = '0px';
     stats.domElement.style.top = '0px';

     document.getElementById( 'container' ).appendChild(stats.domElement);*/

    //add scene to DOM
    boidContainer.grab(renderer.domElement);

    var lastCheck = new Date().getTime(),
        now, longEnough;

    this.animate = function () {
      
      requestAnimationFrame( that.animate );
      now = new Date().getTime();
      
      longEnough = (now - lastCheck) > 50; //50ms ~= 20fps
      
      //if(longEnough) that.render();
      that.render();
      //stats.update();

    }

    //members:
    this.container = boidContainer;
    this.viewWidth = viewWidth;
    this.viewHeight = viewHeight;
    this.halfViewWidth = viewWidth / 2;
    this.halfViewHeight = viewHeight / 2;
    this.camera = camera;
    this.scene = scene;
    this.renderer = renderer;
    this.offset = {x:0, y:0};
    this.birds = birds;
    this.boids = boids;

  },

  toElement: function (){
    return this.container;
  },

  onDocumentMouseMove: function ( e ) {
    var boid,
        offset = this.offset,
        boids = this.boids,
        vector = new THREE.Vector3( e.clientX - offset.x - this.halfViewWidth, - e.clientY - offset.y + this.halfViewHeight, 0 );
    //TODO: 0.59 is a projection scaling number that is deduced from trial & errors, will find the correct formular to convert projection later
    //old projection
    //vector.multiplyScalar(0.59);
    vector.multiplyScalar(0.87);

    //debug
    //this.cube.position = vector.clone();
    
    //trace(3, 'offset: ' + offset.x + 'x' + offset.y + ' - vector: ' + vector.x + 'x' + vector.y);

    for ( var i = 0, il = boids.length; i < il; i++ ) {
      boid = boids[ i ];
      vector.z = boid.position.z;
      boid.repulse( vector );
    }

  },

  scroll: function(main) {
    var scrollTop = main.$scrollBody.getScroll().y,
        scrollBottom = scrollTop + main.winSize.y,
        offset = this.container.getPosition(),
        frameTop = offset.y;
    //calculate inView
    this._visible = (frameTop < scrollBottom && frameTop > scrollTop - this.viewHeight);
    
    offset.y = scrollTop - offset.y;
    
    this.offset = offset;
  },

  render: function() {
    var boid, bird;

    for ( var i = 0, il = this.birds.length; i < il; i++ ) {
      boid = this.boids[ i ];
      boid.run( this.boids );
      bird = this.birds[ i ];
      bird.updateCourse(boid);

    }
    //slow netbook 
    this.renderer.render( this.scene, this.camera );
  }
};



/**
 * Main Class
 **/
function Main (win) {
  if (win.mainApp) {
    alert('T3.Main singleton exception');
  }
  
  var doc = win.document,
      that = this;

  var boidScene3 = new BoidScene();
  boidScene3.init($('fish-frame'), 50, true);
  boidScene3.animate();

  //members
  this.win = win;
  this.doc = doc;
  this.boidScene3 = boidScene3;

  this.resizeHandler();
}

Main.prototype = {
  constructor: Main,
  mouseWheelHandler: function (e) {
    trace(1, 'mouse wheel detected');
    if(this.portfolioPage.active && e) {
      e.preventDefault();
    }
  },
  scrollHandler: function(e) {

  },
  resizeHandler: function () {
    var winSize = this.win.getSize();
    this.winSize = winSize;
    this.scrollHandler();
    
    //alert('resize: ' + this.winSize.x + 'x' + this.winSize.y);
  }
};

//this is where it all begin:
window.addEvent('domready', function() {
  //main application singleton
  window.mainApp = new Main(window);
});

