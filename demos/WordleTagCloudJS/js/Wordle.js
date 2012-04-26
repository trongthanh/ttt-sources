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

window.debugEl = document.getElementById('debug');
window.trace = function(line, str) {
  window.debugEl.getElement('.line' + line).set('html', str);
};

window.debugPoint = document.getElementById('debug-point');
window.tracePos = function(screenX, screenY, anchorX, anchorY) {
  if(anchorX === undefined) anchorX = 0;
  if(anchorY === undefined) anchorY = 0;

  debugPoint.setPosition({x: anchorX + screenX, y: anchorY + screenY});
};

/* ====================== main scripts ========================= */

//namespace

var canvas = document.getElementById('drawing-canvas');  
var ctx = canvas.getContext('2d');

function drawText() {
    ctx.fillStyle = "blue";
    ctx.font="24pt Arial";
    ctx.fillText("Figure 1", 10, 250);
}

drawText();
