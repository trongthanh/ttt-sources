/**
 * Copyright: 2012 (c) int3ractive.com
 * Author: Thanh Tran - trongthanh@gmail.com
 */

/* ====================== main scripts ========================= */
/*
 * WORDLEJS namespace
 */
var WORDLEJS = WORDLEJS || {};

/* 
 * WordRectangle class
 */
WORDLEJS.WordRectangle = function (x, y, w, h) {
  this.x = x;
  this.y = y;
  this.width = w;
  this.height = h;
};

WORDLEJS.WordRectangle.prototype = {
  constructor: WORDLEJS.WordRectangle,
  
  getRight: function () {
    return this.x + this.width;
  },
  
  getBottom: function () {
    return this.y + this.height;
  }
  
};

/*
 * World class
 */
WORDLEJS.Word = function (initObj) {
  if(!initObj) throw new Error("bad Word init");

  this.text = initObj.text || ""; 
	this.weight = initObj.weight; 

  this.fontFamily = initObj.fontFamily;
  this.fontSize = initObj.fontSize;
  this.fillColor = initObj.fillColor; //Color
  this.strokeColor = initObj.strokeColor; //Color
  this.url = initObj.url;
  
  this.sprite = null; //considered later
  this.bounds = null; //bounds of the rendered text
  this._rotated = false;

};

WORDLEJS.Word.prototype = {
  constructor: WORDLEJS.Word,

  /**
   * Calculate the metrics and position of this word
   */
  calculate: function (ctx) {
    //
    var fontFamily = this.fontFamily, 
        fontSize = this.fontSize, 
        strokeColor = this.strokeColor,
        fillColor = this.fillColor,
        text = this.text,
        textMetrics,
        bounds,
        w,
        h,
        tx = 0, //translate x;
        ty = 0; //translate y;
    
    ctx.save();
    
    ctx.fillStyle = fillColor;
    ctx.font= fontSize + "pt " + fontFamily;
    
    textMetrics = ctx.measureText(text);
    
    if (Random.getRandomBoolean()) { // half chances of rotation
      //case vertical
      this._rotated = true;
      w = fontSize;
      h = textMetrics.width;
      tx = -w/2;
      ty = -h/2;
    } else {
      //case horizontal
      this._rotated = false;
      w = textMetrics.width;
      h = fontSize;
      tx = -w/2;
      ty = h/2; //register point at bottom left
    }

    bounds = new WORDLEJS.WordRectangle(tx, ty, w, h);
    
    ctx.restore();

    
    this.bounds = bounds;
  },
  
  toString: function () {
    return this.text;
  }
};

/*
 * Wordle class
 */
WORDLEJS.Wordle = function (context2d) {
  this.ctx = context2d;
};

WORDLEJS.Wordle.prototype = {
  //member
  biggestSize: 80,
  smallestSize: 14,
  words: [],
  dRadius: 10.0,
  dDeg: 10,
  doSortType: -1,
  allowRotate: Boolean = true,
  ctx = null,

  //methods
  constructor: WORDLEJS.Wordle,
  
  setWords: function (arr, maxium) {
    maxium = maxium || 100;
    
    for (var i = 0; i < maxium; ++i) {
      var wordObject = arr[i];
      if (i > maxium || !wordObject) {
        trace( "words limit : " + i );
        break;
      }
      
      //trace( "wordObject : " + wordObject.text, wordObject.count );
      
      var w  = {
        text: wordObject.text, 
        weight: wordObject.count,
        url: 'http://www.google.com/search?q=' + wordObject.text,
        strokeColor: Random.getRandomColor(),
        fontFamily: Random.getRandomBoolean() ? 'sans-serif' : 'serif'
      }
      
      words.push(new WORDLEJS.Word(w);
    }
  },
  
  /**
   * calculate words positions
   */
  doLayout: function () {
    var words = this.words,
        ctx = this.ctx;
    
    if (words.length <= 0) {
      log('no word to render');
      return;
    }
    
    //startTime = getTimer();
    
    switch(this.doSortType) {
      case 1:
        // sort from biggest to smallest
        words.sort(function (w1, w2) {
          return w2.weight - w1.weight;
        });
        break;
        
      case 2:
        //sort from smallest to biggest
        words.sort(function (w1, w2) {
          return w1.weight - w2.weight;
        });
        
        break;
      case 3:
        //sort by alphabet
        words.sort(function (w1, w2) {
          if (w1.text.toLowerCase() < w2.text.toLowerCase()) { 
            return -1; 
          } else if (w1.text.toLowerCase() > w2.text.toLowerCase()) { 
            return 1; 
          } else { 
            return 0; 
          }
        });
        
        break;
      default:
        //TODO: implement shuffle array
        break;
        
      }
    //trace( "words : " + words );
    var first = words[0],
        high = - Number.MAX_VALUE,
        low = Number.MAX_VALUE,
        w,
        wl = words.length,
        i;
    
    for (i = 0; i < wl; i++) {
      w = words[i];
      //check for highest & lowest weight to scatter the font size accordingly
      high = (high > w.weight) ? high : w.weight;
      low = (low < w.weight) ? low : w.weight;
    }
    
    //render and add words to display list
    for (i = 0; i < wl; i++) {
      w = words[i];
      w.fontSize = (((w.weight - low) / (high - low)) * (this.biggestSize-this.smallestSize)) + this.smallestSize;
      w.calculate(ctx);
    }

    //start position
    center = {x: 0, y: 0};
    curIdx = 0;
    
    layoutNextWord();
    addEventListener(Event.ENTER_FRAME, layoutNextWord);
    
  }
  
  layoutNextWord: function (e: Event = null): void {
    if (curIdx >= wl) {
      //finish layout
      removeEventListener(Event.ENTER_FRAME, layoutNextWord);
      
      //final touch AND/OR debug (if any)
      for (var i: int = 0; i < wl; i++) {
        //w = words[i];
        //addChild(w.sprite);
        //debug bounds:
        //drawBound(w);
      }
      
      runTime = getTimer() - startTime;
      trace("run time: " + runTime);
      
      _layoutComplete.dispatch(runTime);
      
      return;
    }
    
    current = this.words[curIdx];
    //calculate current center
    center.x=0;
    center.y=0;
    var totalWeight: uint = 0.0;
    var prev: int;
    //NOT UNDERSTAND
    for (prev = 0; prev < curIdx;++prev) {
      var wPrev: Word = this.words[prev];
      center.x += wPrev.bounds.centerX * wPrev.weight;
      center.y += wPrev.bounds.centerY * wPrev.weight;
      totalWeight+=wPrev.weight;
    }
    center.x /= (totalWeight);
    center.y /= (totalWeight);
    //trace( "center : " + center );
    
    var bounds: WordleRectangle = current.bounds;
    var done: Boolean = false;
    var radius: Number = 0.5 * Math.min(first.bounds.width, first.bounds.height);
    
    var loopPrevent: uint = 0;
    
    while (!done) {
      loopPrevent ++;
      if (loopPrevent > 100000) {
        trace("maximum loop reach");
        break;
      }
      
      var startDeg: int = Random.getRandomInt(0, 359);
      //loop over spiral
      var prev_x: int = -1;
      var prev_y: int = -1;
      
      for(var deg: int = startDeg; deg < startDeg + 360; deg+= dDeg) {
        var rad: Number= (deg/Math.PI)*180.0;
        var cx: int=(center.x+radius*Math.cos(rad));
        var cy: int=(center.y+radius*Math.sin(rad));
        
        if(prev_x==cx && prev_y==cy) continue;
        
        prev_x = cx;
        prev_y = cy;
        //trace( "cx,cy : " + cx,cy );
        //test:
        //graphics.beginFill(0xFF0000, 0.5);
        //graphics.drawCircle(cx, cy, 0.5);

        var candidateBounds: WordleRectangle = new WordleRectangle (	
          current.bounds.x + cx,
          current.bounds.y + cy,
          current.bounds.width,
          current.bounds.height
        )
        
        if (pixelPerfect)	{
          current.sprite.x = candidateBounds.centerX;
          current.sprite.y = candidateBounds.centerY;
        }
        //any collision ?
        prev=0;
        for(prev=0;prev< curIdx;++prev) {
          if (pixelPerfect) {
            if (CollisionDetection.checkForCollision(current.sprite, words[prev].sprite)) {
            //if (SkyCollisionDetection.bitmapHitTest(current.sprite, words[prev].sprite)) {
              //trace( "current.sprite : " + current.sprite.x, current.sprite.y );
              break;
            }
          } else {
            if (candidateBounds.intersects(words[prev].bounds)) {
              break;
            }
          }
        }
        //no collision: we're done
        if (prev == curIdx) {
          current.bounds = candidateBounds;
          current.sprite.x = candidateBounds.centerX;
          current.sprite.y = candidateBounds.centerY;
          current.sprite.visible = true;
          done=true;
          break;
        }
      }
      radius+=this.dRadius;
    }
    _layoutProgress.dispatch(current);
    curIdx++;
  }
  
  
  
};


/* ============ MAIN SCRIPT ============== */
var main = (function (win) {
  //global
  var doc = win.document;
  //member
  var testStr = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diamvoluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consete"
  
  var sortResult = TextUtil.countWordOccurence(testStr);
  
  var wordle = new WORDLEJS.Wordle();
  
  wordle.setWords(sortResult, 200);
  
  
  







}(this));


/* TESTING
var main = (function (win) {
  //global
  var doc = win.document;

  var canvas = doc.getElementById('drawing-canvas'),
      ctx = canvas.getContext('2d'),
      output = doc.getElementById('output'),
      container = doc.getElementById('main-container'),
      rect,
      h = 50,
      tm, rectBounds; //TextMeasure


  function drawText(text, isVertical) {
      ctx.save();

      ctx.fillStyle = "blue";
      ctx.font= h + "pt Ubuntu";
      tm = ctx.measureText(text);
      
      if (isVertical) {
        ctx.translate(0, 0);
        ctx.rotate(90*Math.PI/180);
        rectBounds = {width: h, height: tm.width};
      } else {
        ctx.translate(0, h);
        ctx.rotate(0);
        rectBounds = {width: tm.width, height: h};
      }
      ctx.fillText(text, 0, 0);

      var rect = doc.createElement("div");
      rect.className = "rect";
      rect.style.backgroundColor = "#" + Math.floor(Math.random() * 0xFFFFFF).toString(16);
      rect.style.height = rectBounds.height + "px";//"30px";
      rect.style.width =  rectBounds.width + "px"; //tm.width + "px";
      container.appendChild(rect);
      
      ctx.restore();
  }

  drawText("Thanh");
  drawText("Thao", true);

  trace(1, "width: " + rectBounds.width);

}(this)); */

