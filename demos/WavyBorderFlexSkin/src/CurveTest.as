/**
* CurveTests by Grant Skinner. May 30, 2008
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
* You may distribute and modify this code freely.
*/

// for unloading:
function halt():void {
	removeEventListener(MouseEvent.MOUSE_DOWN,handlePress);
	stage.removeEventListener(MouseEvent.MOUSE_MOVE,doDrag);
	stage.removeEventListener(MouseEvent.MOUSE_UP,endDrag);
	stage.removeEventListener(MouseEvent.CLICK,handleClick);
}

//

var pts:Array = [pt1,pt2,pt3,pt4,pt5];

var canvas:Sprite = new Sprite();
addChildAt(canvas,1);

draw();

function draw():void {
	var g:Graphics = canvas.graphics;
	g.clear();
	var prevMidpt:Point = null;
	var l:Number = pts.length;
	for (var i:Number=1;i<l;i++) {
		var pt1:Object = pts[i-1];
		var pt2:Object = pts[i];
		
		// draw the straight lines:
		g.lineStyle(0,0xBBBBBB,0.6);
		g.moveTo(pt1.x,pt1.y);
		g.lineTo(pt2.x,pt2.y);
		
		// draw the bisection:
		g.lineStyle(0,0xBBBBBB,0.5);
		var midpt:Point = new Point(pt1.x+(pt2.x-pt1.x)/2,pt1.y+(pt2.y-pt1.y)/2);
		var a:Number = Math.atan2(pt2.y-pt1.y,pt2.x-pt1.x);
		g.moveTo(midpt.x+Math.cos(a+Math.PI/2)*8,midpt.y+Math.sin(a+Math.PI/2)*8);
		g.lineTo(midpt.x-Math.cos(a+Math.PI/2)*8,midpt.y-Math.sin(a+Math.PI/2)*8);
		
		// draw the curves:
		g.lineStyle(2,0x66FFFF,1);
		if (prevMidpt) {
			g.moveTo(prevMidpt.x,prevMidpt.y);
			g.curveTo(pt1.x,pt1.y,midpt.x,midpt.y);
		} else {
			// draw start segment:
			g.moveTo(pt1.x,pt1.y);
			g.lineTo(midpt.x,midpt.y);
		}
		prevMidpt = midpt;
	}
	// draw end segment:
	g.lineTo(pt2.x,pt2.y);
}

addEventListener(MouseEvent.MOUSE_DOWN,handlePress);
var dragProps:Object;
function handlePress(evt:MouseEvent):void {
	if (evt.target is Anchor) {
		dragProps = {target:evt.target};
		stage.addEventListener(MouseEvent.MOUSE_MOVE,doDrag);
		stage.addEventListener(MouseEvent.MOUSE_UP,endDrag);
	}
}

function doDrag(evt:MouseEvent):void {
	dragProps.target.x = mouseX;
	dragProps.target.y = mouseY;
	draw();
}

function endDrag(evt:MouseEvent):void {
	dragProps = null;
	stage.removeEventListener(MouseEvent.MOUSE_MOVE,doDrag);
	stage.removeEventListener(MouseEvent.MOUSE_UP,endDrag);
}

stage.addEventListener(MouseEvent.CLICK,handleClick);
function handleClick(evt:MouseEvent):void {
	if (evt.target is Anchor) { return; }
	var anchor:Anchor = new Anchor();
	anchor.x = mouseX;
	anchor.y = mouseY;
	pts.push(anchor);
	addChild(anchor);
	draw();
}
