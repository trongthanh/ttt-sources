/**
 * Copyright: 2012 (c) int3ractive.com
 * Author: Thanh Tran - trongthanh@gmail.com
 */


/* ====================== main scripts ========================= */
//namespace
var WORDLEJS = WORDLEJS || {};

WORDLEJS.WordRectangle = function () {
  //TODO: implement

};

WORDLEJS.Word = function (initObj) {
  if(!initObj) throw new Error("bad Word init");

  this.text = initObj.text || ""; 
	this.weight = initObj.weight; 

  this.fontFamily = initObj.fontFamily;
  this.fontSize = initObj.fontSize;
  this.fill = initObj.fill; //Color
  this.stroke = initObj.stroke; //Color
  this.url = initObj.url;
  
  this.sprite = null; //considered later
  this.bounds = new WORDLEJS.WordRectangle();
  this._rotated = false;

};

WORDLEJS.Word.prototype = {
  constructor: WORDLEJS.Word,

  /**
   * Render the visual elements of this word
   */
  render: function (allowRotate) {
    //
    var textFormat = {fontFamily, fontSize, stroke);
    var tf: TextField = new TextField();
    tf.embedFonts = true;
    tf.defaultTextFormat = textFormat;
    tf.autoSize = "left";
    tf.text = this.text;
    tf.selectable = false;
    
    var tx: Number = 0; //translate x;
    var ty: Number = 0; //translate y;
    
    if (allowRotate && Math.random() < 0.5) { // half chances of rotation
      this._rotated = true;
      tf.rotation = 90;
      tf.x = tf.width / 2;
      tf.y = -tf.height / 2;
      tx = tf.x;
      ty = -tf.y;
    } else {
      this._rotated = false;
      tf.x = -tf.width / 2;
      tf.y = -tf.height / 2;
      tx = -tf.x;
      ty = -tf.y;
    }
    
    var sprite: Sprite = new Sprite();
    sprite.addChild(tf);
    this.sprite = sprite;
    
    //get pixel perfect bounds
    var bm: BitmapData = new BitmapData(sprite.width, sprite.height, false);
    var matrix: Matrix = new Matrix();
    matrix.tx = tx;
    matrix.ty = ty;
    bm.draw(sprite, matrix);
    
    var textBounds: WordleRectangle = WordleRectangle.createFromRect(bm.getColorBoundsRect(0xFFFFFFFF, 0xFF000000 | this.stroke , true));
    /// Indeed make the 'tf' center the 'sprite'
    var xPos: Number = -textBounds.width / 2 - textBounds.x;
    var yPos: Number = -textBounds.height / 2 - textBounds.y;
    if (this._rotated) {
      var left: Number = textBounds.x;
      var right: Number = tf.width - textBounds.x - textBounds.width;
      tf.x += (right - left) / 2;
    } else {
      tf.x = xPos;
    }
    tf.y = yPos;
    textBounds.x += xPos;
    textBounds.y += yPos;
    
    this.bounds = textBounds;
  },
  
  toString: function () {
    return this.text;
  }



};







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

}(this));

