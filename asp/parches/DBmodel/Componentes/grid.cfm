<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>
<body>
hola

<script language="javascript">
	function sbChange()
	{
		//alert(document.styleSheets[0].rules[0].id);
		//alert(document.styleSheets[1].cssRules);
		var x = document.getElementById("VscrollBar1").jsScrollBar;
		x.goto(x,5);

	}
</script>

	<div id="VscrollBar1" style="border:solid ##990033 1px">
	</div>
	<div id="VscrollBar2" style="border:solid ##990033 1px">
	</div>

	<div id="VscrollBar" style="position:absolute; left:160px; top:138px; width:15px; height:297.488px; z-index:5	; border-style:solid; border:none;">
		<div id="bottom" style="position:relative; width:13px; height:13px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px; border-style: double" onmousedown="this.style.borderStyle='inset'" onmouseup="this.style.borderStyle='double'" onmouseout="this.style.borderStyle='double'">
			<div style="position:absolute; top:5px; left:6px; width:1px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:6px; left:5px; width:3px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:7px; left:4px; width:5px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:8px; left:3px; width:7px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:9px; left:3px; width:7px; height:1px; background-color:##cccccc;"></div>
		</div>
		<div id="bottom" style="position:relative; width:13px; height:13px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px" onmousedown="this.style.borderStyle='inset'" onmouseup="this.style.borderStyle='double'" onmouseout="this.style.borderStyle='double'">
			<div style="position:absolute; top:3px; left:4px; width:5px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:4px; left:4px; width:5px; height:1px; background-color:##CCCCCC;"></div>
			<div style="position:absolute; top:5px; left:6px; width:1px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:6px; left:5px; width:3px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:7px; left:4px; width:5px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:8px; left:3px; width:7px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:9px; left:3px; width:7px; height:1px; background-color:##cccccc;"></div>
		</div>
		<div id="scrollBar" style="position:relative; top:0px; left:0px; width:15px; height:297.488px; z-index:4; background-image:url('sb.gif'); border-style:solid; border-color:##000 ##fff ##fff ##000; border-width:0px; overflow:hidden">
			<div id="scroller" style="position:relative; top:0px; left:0px; width:13px; height:45px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px">
			</div>
		</div>
		<div id="bottom" style="position:relative; width:13px; height:13px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px; border-style: double" onmousedown="this.style.borderStyle='inset'" onmouseup="this.style.borderStyle='double'" onmouseout="this.style.borderStyle='double'">
			<div style="position:absolute; top:9px; left:4px; width:5px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:8px; left:4px; width:5px; height:1px; background-color:##CCCCCC;"></div>
			<div style="position:absolute; top:7px; left:6px; width:1px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:6px; left:5px; width:3px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:5px; left:4px; width:5px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:4px; left:3px; width:7px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:3px; left:3px; width:7px; height:1px; background-color:##cccccc;"></div>
		</div>
		<div id="bottom" style="position:relative; width:13px; height:13px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px; border-style: double" onmousedown="this.style.borderStyle='inset'" onmouseup="this.style.borderStyle='double'" onmouseout="this.style.borderStyle='double'">
			<div style="position:absolute; top:8px; left:6px; width:1px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:7px; left:5px; width:3px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:6px; left:4px; width:5px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:5px; left:3px; width:7px; height:1px; background-color:##000000;"></div>
			<div style="position:absolute; top:4px; left:3px; width:7px; height:1px; background-color:##cccccc;"></div>
		</div>
	</div>


<script type="text/javascript">
//min, max, tall
function scrollerMove(obj)
{
	alert(obj.val);
}
var scroller = {
  init:   function() {

    scroller.val = 1;
    scroller.max = 1000;
    scroller.page = 99;
    scroller.scrollBarH = document.getElementById("scrollBar").offsetHeight - 2;
    scroller.scrollerHeight = (scroller.page * scroller.scrollBarH) / scroller.max;

    if(scroller.scrollerHeight < 15) scroller.scrollerHeight = 15;
    document.getElementById("scroller").style.height = Math.round(scroller.scrollerHeight) + "px";
    
    scroller.scrollDist = Math.round(scroller.scrollBarH-scroller.scrollerHeight);
    
    Drag.init(document.getElementById("scroller"),null,0,0,0,scroller.scrollDist);
   
    document.getElementById("scroller").onDrag = function (x,y) {
      var scrollY = parseInt(document.getElementById("scroller").style.top);
      var docY = (scrollY * (scroller.max - scroller.page) / scroller.scrollDist);
	  if (docY == 0) docY = 1;
      scroller.val = Math.round(docY);
    }
    document.getElementById("scroller").onDragEnd = function (x,y) {
	  	scrollerMove(scroller);
    }

  }
}

onload = xOnload;

function xOnload()
{
	scroller.init(); 
	a = new jsScrollBar.init('VscrollBar1','V', 300, 	0, 100, 0);
	b = new jsScrollBar.init('VscrollBar2','V', 300, 	0, 100, 0);
}
</script>

</script>

<script language="javascript">
/**************************************************
 * jsScrollBar.js
 * 2009-09-05
 * Ing. Óscar Bonilla, MBA
 *************************************************/
var jsScrollBar = {
	init: 	function (id,t, l, mi,ma,s,	v,	bprev,bnext,bfirst,blast,pst)
	{
		if (!id || (t == undefined) || (t!="V" && t!="H") || (l == undefined)  || (l<1) || (mi == undefined) || (mi!=0 && mi!=1) || (ma == undefined) || (ma<0) || (s<0) ) 
		{
			alert("ERROR: jsScrollBar.create ('div_id','type:V|H',lon_px,min:0|1,max:+[,step:+,goto,btnPrev,btnNext,btnFirst,btnLast,clickStep])");
			return true;
		}
		this.SB = document.getElementById(id);
		if (!this.SB)
		{
			alert("ERROR: jsScrollBar.create: div_id '" + id + "' not found");
			return true;
		}
		if (v == undefined)  v=mi; 
		if (s == undefined)  s=1; 
		if (bprev == undefined) bprev=true; 
		if (bnext == undefined) bnext=true; 
		if (bfirst == undefined) bfirst=true; 
		if (blast == undefined) blast=true; 
		if (pst == undefined) pst=true; 
		var idSB_A = "jsSB$A_" + id;	// jsScrollBar Area
		var idSB_S = "jsSB$S_" + id;	;	// jsScrollBar Scroller
		if (t == 'V')
		{
			this.SB_AH = l;
			var iHTML = "";
			iHTML +=
				'<div style="position:relative; left:0px; top:0px; width:15px; height:' + l + 'px; z-index:5; border-style:solid; border:none;">';
				if (bprev)
				{
					iHTML +=
					'	<div id="jsSB$B_Prv" style="position:relative; width:13px; height:13px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px; border-style: double" onmousedown="this.style.borderStyle=\'inset\'" onmouseup="this.style.borderStyle=\'double\'" onmouseout="this.style.borderStyle=\'double\'">' +
					'		<div id="jsSB$B_Prv" style="position:absolute; top:5px; left:6px; width:1px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Prv" style="position:absolute; top:6px; left:5px; width:3px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Prv" style="position:absolute; top:7px; left:4px; width:5px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Prv" style="position:absolute; top:8px; left:3px; width:7px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Prv" style="position:absolute; top:9px; left:3px; width:7px; height:1px; background-color:##cccccc;"></div>' +
					'	</div>';
					this.SB_AH -= 15;
				}
				if (bfirst)
				{
					iHTML +=
					'	<div id="jsSB$B_Fst" style="position:relative; width:13px; height:13px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px" onmousedown="this.style.borderStyle=\'inset\'" onmouseup="this.style.borderStyle=\'double\'" onmouseout="this.style.borderStyle=\'double\'">' +
					'		<div id="jsSB$B_Fst" style="position:absolute; top:3px; left:4px; width:5px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Fst" style="position:absolute; top:4px; left:4px; width:5px; height:1px; background-color:##CCCCCC;"></div>' +
					'		<div id="jsSB$B_Fst" style="position:absolute; top:5px; left:6px; width:1px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Fst" style="position:absolute; top:6px; left:5px; width:3px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Fst" style="position:absolute; top:7px; left:4px; width:5px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Fst" style="position:absolute; top:8px; left:3px; width:7px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Fst" style="position:absolute; top:9px; left:3px; width:7px; height:1px; background-color:##cccccc;"></div>' +
					'	</div>';
					this.SB_AH -= 15;
				}
				if (bnext)
					this.SB_AH -= 15;
				if (blast)
					this.SB_AH -= 15;
			iHTML +=
				'	<div id="' + idSB_A + '" style="position:relative; top:0px; left:0px; width:15px; height:' + this.SB_AH + 'px; z-index:4; background-image:url(\'sb.gif\'); border-style:solid; border-color:##000 ##fff ##fff ##000; border-width:0px; overflow:hidden">' +
				'		<div id="' + idSB_S + '" style="position:relative; top:0px; left:0px; width:13px; height:45px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px">' +
				'		</div>' +
				'	</div>';
				if (blast)
				{
					iHTML +=
					'	<div id="jsSB$B_Lst" style="position:relative; width:13px; height:13px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px; border-style: double" onmousedown="this.style.borderStyle=\'inset\'" onmouseup="this.style.borderStyle=\'double\'" onmouseout="this.style.borderStyle=\'double\'">' +
					'		<div id="jsSB$B_Lst" style="position:absolute; top:8px; left:4px; width:5px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Lst" style="position:absolute; top:7px; left:4px; width:5px; height:1px; background-color:##CCCCCC;"></div>' +
					'		<div id="jsSB$B_Lst" style="position:absolute; top:6px; left:6px; width:1px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Lst" style="position:absolute; top:5px; left:5px; width:3px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Lst" style="position:absolute; top:4px; left:4px; width:5px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Lst" style="position:absolute; top:3px; left:3px; width:7px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Lst" style="position:absolute; top:2px; left:3px; width:7px; height:1px; background-color:##cccccc;"></div>' +
					'	</div>';
				}
				if (bnext)
				{
					iHTML +=
					'	<div id="jsSB$B_Nxt" style="position:relative; width:13px; height:13px; background-color:##cccccc; border-style:solid; border-color:##fff ##006 ##006 ##fff; border-width:1px; overflow:hidden; font-size:1px; border-style: double" onmousedown="this.style.borderStyle=\'inset\'" onmouseup="this.style.borderStyle=\'double\'" onmouseout="this.style.borderStyle=\'double\'">' +
					'		<div id="jsSB$B_Nxt" style="position:absolute; top:7px; left:6px; width:1px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Nxt" style="position:absolute; top:6px; left:5px; width:3px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Nxt" style="position:absolute; top:5px; left:4px; width:5px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Nxt" style="position:absolute; top:4px; left:3px; width:7px; height:1px; background-color:##000000;"></div>' +
					'		<div id="jsSB$B_Nxt" style="position:absolute; top:3px; left:3px; width:7px; height:1px; background-color:##cccccc;"></div>' +
					'	</div>';
				}
			iHTML +=
				'</div>';
				
			this.SB.innerHTML = iHTML;
			this.SB_A	= document.getElementById(idSB_A);
			this.SB_S	= document.getElementById(idSB_S);
			this.SB.jsScrollBar = this;
			this.SB_A.jsScrollBar = this;
			this.SB_S.jsScrollBar = this;
			this.tip		= t;
			this.lon		= l;
			this.min		= mi;
			this.max		= ma;
			this.stp		= s;
			if (s == 0)
				this.nav		= parseInt(ma/10);
			else
			 	this.nav		= s;
			this.val		= v;
			this.SB_AH = this.SB_A.offsetHeight - 2;
			this.SB_SH = (this.SB_AH * s ) / (ma - mi + 1);
		
			if(this.SB_SH < 8) this.SB_SH = 8;
			this.SB_S.style.height = Math.round(this.SB_SH) + "px";
			
			this.rng = Math.round(this.SB_AH-this.SB_SH);
			
			Drag.init(this.SB_S,null,0,0,0,this.rng);
			if (v != 1) jsScrollBar.goto(this, v);

			this.SB.onclick	= function (e)
				{
					e = jsScrollBar.fixE(e);
					var jsSB = this.jsScrollBar;

					if (e.target.id.indexOf("jsSB$A_") >= 0)
					{
						if (e.offsetY < jsSB.SB_A.style.top)
							jsScrollBar.goto(jsSB, jsSB.val - jsSB.nav);
						else
							jsScrollBar.goto(jsSB, jsSB.val + jsSB.nav);
					}
					else if (e.target.id == "jsSB$B_Fst")
					{
						jsScrollBar.goto(jsSB, jsSB.min);
					}
					else if (e.target.id == "jsSB$B_Prv")
					{
						jsScrollBar.goto(jsSB, jsSB.val - 1);
					}
					else if (e.target.id == "jsSB$B_Nxt")
					{
						jsScrollBar.goto(jsSB, jsSB.val + 1);
					}
					else if (e.target.id == "jsSB$B_Lst")
					{
						jsScrollBar.goto(jsSB, jsSB.max);
					}
				}

			this.SB_S.onDrag = function (x,y) {
				var jsSB = this.jsScrollBar;
				var y = parseInt(this.style.top);
				var v = (y * ((jsSB.max-jsSB.min+1) - jsSB.stp) / jsSB.rng);
				if (v < jsSB.min) v = jsSB.min;
				if (v > jsSB.max) v = jsSB.max;

				jsSB.val		= parseInt(v);
			}

			this.SB_S.onDragEnd = function (x,y) {
				scrollerMove(this.jsScrollBar);
			}
		}
		return true;
	},
	goto:	function (jsSB, v)
	{
		if (v < jsSB.min) v = jsSB.min;
		if (v > jsSB.max) v = jsSB.max;
		jsSB.val		= parseInt(v);
		jsSB.SB_S.style.top = v*jsSB.rng/(jsSB.max-jsSB.min+1-jsSB.stp) + "px";
	},
	add:	function (o,t,m,s,v)
	{	
	},

	fixE : function(e)
	{
		if (typeof e == 'undefined') e = window.event;
		if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
		if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
		if (typeof e.target == 'undefined') e.target = e.srcElement;
		if (typeof e.offsetY == 'undefined') e.offsetY = e.clientY - jsScrollBar.posXY(e.target).top;

		return e;
	},

	posXY: function(obj) {
		var left = top = 0;
		while (obj.offsetParent) 
		{
			left += obj.offsetLeft;
			top += obj.offsetTop;
			obj = obj.offsetParent;
		}
		
		return {
			top:  top,
			left: left
		};
	}

}

</script>

<script language="javascript">

/**************************************************
 * dom-drag.js
 * 09.25.2001
 * www.youngpup.net
 **************************************************
 * 10.28.2001 - fixed minor bug where events
 * sometimes fired off the handle, not the root.
 **************************************************/

var Drag = {

	obj : null,

	init : function(o, oRoot, minX, maxX, minY, maxY, bSwapHorzRef, bSwapVertRef, fXMapper, fYMapper)
	{
		o.onmousedown	= Drag.start;

		o.hmode			= bSwapHorzRef ? false : true ;
		o.vmode			= bSwapVertRef ? false : true ;

		o.root = oRoot && oRoot != null ? oRoot : o ;

		if (o.hmode  && isNaN(parseInt(o.root.style.left  ))) o.root.style.left   = "0px";
		if (o.vmode  && isNaN(parseInt(o.root.style.top   ))) o.root.style.top    = "0px";
		if (!o.hmode && isNaN(parseInt(o.root.style.right ))) o.root.style.right  = "0px";
		if (!o.vmode && isNaN(parseInt(o.root.style.bottom))) o.root.style.bottom = "0px";

		o.minX	= typeof minX != 'undefined' ? minX : null;
		o.minY	= typeof minY != 'undefined' ? minY : null;
		o.maxX	= typeof maxX != 'undefined' ? maxX : null;
		o.maxY	= typeof maxY != 'undefined' ? maxY : null;

		o.xMapper = fXMapper ? fXMapper : null;
		o.yMapper = fYMapper ? fYMapper : null;

		o.root.onDragStart	= new Function();
		o.root.onDragEnd	= new Function();
		o.root.onDrag		= new Function();
	},

	start : function(e)
	{
		var o = Drag.obj = this;
		e = Drag.fixE(e);
		var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
		var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );
		o.root.onDragStart(x, y);

		o.lastMouseX	= e.clientX;
		o.lastMouseY	= e.clientY;

		if (o.hmode) {
			if (o.minX != null)	o.minMouseX	= e.clientX - x + o.minX;
			if (o.maxX != null)	o.maxMouseX	= o.minMouseX + o.maxX - o.minX;
		} else {
			if (o.minX != null) o.maxMouseX = -o.minX + e.clientX + x;
			if (o.maxX != null) o.minMouseX = -o.maxX + e.clientX + x;
		}

		if (o.vmode) {
			if (o.minY != null)	o.minMouseY	= e.clientY - y + o.minY;
			if (o.maxY != null)	o.maxMouseY	= o.minMouseY + o.maxY - o.minY;
		} else {
			if (o.minY != null) o.maxMouseY = -o.minY + e.clientY + y;
			if (o.maxY != null) o.minMouseY = -o.maxY + e.clientY + y;
		}

		document.onmousemove	= Drag.drag;
		document.onmouseup		= Drag.end;

		return false;
	},

	drag : function(e)
	{
		e = Drag.fixE(e);
		var o = Drag.obj;

		var ey	= e.clientY;
		var ex	= e.clientX;
		var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
		var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );
		var nx, ny;

		if (o.minX != null) ex = o.hmode ? Math.max(ex, o.minMouseX) : Math.min(ex, o.maxMouseX);
		if (o.maxX != null) ex = o.hmode ? Math.min(ex, o.maxMouseX) : Math.max(ex, o.minMouseX);
		if (o.minY != null) ey = o.vmode ? Math.max(ey, o.minMouseY) : Math.min(ey, o.maxMouseY);
		if (o.maxY != null) ey = o.vmode ? Math.min(ey, o.maxMouseY) : Math.max(ey, o.minMouseY);

		nx = x + ((ex - o.lastMouseX) * (o.hmode ? 1 : -1));
		ny = y + ((ey - o.lastMouseY) * (o.vmode ? 1 : -1));

		if (o.xMapper)		nx = o.xMapper(y)
		else if (o.yMapper)	ny = o.yMapper(x)

		Drag.obj.root.style[o.hmode ? "left" : "right"] = nx + "px";
		Drag.obj.root.style[o.vmode ? "top" : "bottom"] = ny + "px";
		Drag.obj.lastMouseX	= ex;
		Drag.obj.lastMouseY	= ey;

		Drag.obj.root.onDrag(nx, ny);
		return false;
	},

	end : function()
	{
		document.onmousemove = null;
		document.onmouseup   = null;
		Drag.obj.root.onDragEnd(	parseInt(Drag.obj.root.style[Drag.obj.hmode ? "left" : "right"]), 
									parseInt(Drag.obj.root.style[Drag.obj.vmode ? "top" : "bottom"]));
		Drag.obj = null;
	},

	fixE : function(e)
	{
		if (typeof e == 'undefined') e = window.event;
		if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
		if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
		return e;
	}
};

<!---/**************************************************
 * dom-drag.js
 * 09.25.2001
 * www.youngpup.net
 **************************************************
 * 10.28.2001 - fixed minor bug where events
 * sometimes fired off the handle, not the root.
 **************************************************/

var Drag = {

	obj : null,
	sts : 0,
	
	init : function(p, o, oh, minX, maxX, minY, maxY, bSwapHorzRef, bSwapVertRef, fXMapper, fYMapper)
	{
		o.onmousedown	= Drag.start;
		o.onclick		= Drag.clickO;
		p.onclick		= Drag.clickP;

		o.hmode			= bSwapHorzRef ? false : true ;
		o.vmode			= bSwapVertRef ? false : true ;
		o.oh = oh;
		o.root = o ;
		p.root = o ;
		p.pt = 138 ;

		if (o.hmode  && isNaN(parseInt(o.root.style.left  ))) o.root.style.left   = "0px";
		if (o.vmode  && isNaN(parseInt(o.root.style.top   ))) o.root.style.top    = "0px";
		if (!o.hmode && isNaN(parseInt(o.root.style.right ))) o.root.style.right  = "0px";
		if (!o.vmode && isNaN(parseInt(o.root.style.bottom))) o.root.style.bottom = "0px";

		o.minX	= typeof minX != 'undefined' ? minX : null;
		o.minY	= typeof minY != 'undefined' ? minY : null;
		o.maxX	= typeof maxX != 'undefined' ? maxX : null;
		o.maxY	= typeof maxY != 'undefined' ? maxY : null;

		o.xMapper = fXMapper ? fXMapper : null;
		o.yMapper = fYMapper ? fYMapper : null;

		o.root.onDragStart	= new Function();
		o.root.onDragEnd	= new Function();
		o.root.onDrag		= new Function();
	},

	start : function(e)
	{
		Drag.sts = 1;
		var o = Drag.obj = this;
		e = Drag.fixE(e);
		var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
		var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );
		o.root.onDragStart(x, y);

		o.lastMouseX	= e.clientX;
		o.lastMouseY	= e.clientY;

		if (o.hmode) {
			if (o.minX != null)	o.minMouseX	= e.clientX - x + o.minX;
			if (o.maxX != null)	o.maxMouseX	= o.minMouseX + o.maxX - o.minX;
		} else {
			if (o.minX != null) o.maxMouseX = -o.minX + e.clientX + x;
			if (o.maxX != null) o.minMouseX = -o.maxX + e.clientX + x;
		}

		if (o.vmode) {
			if (o.minY != null)	o.minMouseY	= e.clientY - y + o.minY;
			if (o.maxY != null)	o.maxMouseY	= o.minMouseY + o.maxY - o.minY;
		} else {
			if (o.minY != null) o.maxMouseY = -o.minY + e.clientY + y;
			if (o.maxY != null) o.minMouseY = -o.maxY + e.clientY + y;
		}

		document.onmousemove	= Drag.drag;
		document.onmouseup		= Drag.end;

		return false;
	},

	drag : function(e)
	{
		e = Drag.fixE(e);
		var o = Drag.obj;

		var ey	= e.clientY;
		var ex	= e.clientX;
		var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
		var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );
		var nx, ny;

		if (o.minX != null) ex = o.hmode ? Math.max(ex, o.minMouseX) : Math.min(ex, o.maxMouseX);
		if (o.maxX != null) ex = o.hmode ? Math.min(ex, o.maxMouseX) : Math.max(ex, o.minMouseX);
		if (o.minY != null) ey = o.vmode ? Math.max(ey, o.minMouseY) : Math.min(ey, o.maxMouseY);
		if (o.maxY != null) ey = o.vmode ? Math.min(ey, o.maxMouseY) : Math.max(ey, o.minMouseY);

		nx = x + ((ex - o.lastMouseX) * (o.hmode ? 1 : -1));
		ny = y + ((ey - o.lastMouseY) * (o.vmode ? 1 : -1));

		if (o.xMapper)		nx = o.xMapper(y)
		else if (o.yMapper)	ny = o.yMapper(x)

		Drag.obj.root.style[o.hmode ? "left" : "right"] = nx + "px";
		Drag.obj.root.style[o.vmode ? "top" : "bottom"] = ny + "px";
		Drag.obj.lastMouseX	= ex;
		Drag.obj.lastMouseY	= ey;

		Drag.obj.root.onDrag(nx, ny);
		return false;
	},

	end : function()
	{
		document.onmousemove = null;
		document.onmouseup   = null;
		Drag.obj.root.onDragEnd(	parseInt(Drag.obj.root.style[Drag.obj.hmode ? "left" : "right"]), 
									parseInt(Drag.obj.root.style[Drag.obj.vmode ? "top" : "bottom"]));
		Drag.obj = null;
	},

	clickO : function()
	{
		Drag.sts = 2;
	},

	clickP : function(e)
	{
		if (Drag.sts == 2)
		{
			Drag.sts = 1;
			return false;
		}
		var o	= this.root;
		if (Drag.sts == 0)
		{
			Drag.sts = 1;
			o.minMouseX = o.minX;
			o.maxMouseX = o.maxX;
			o.lastMouseX = 0;
			o.minMouseY = o.minY;
			o.maxMouseY = o.maxY;
			o.lastMouseY = 0;
		}

		{
			e = Drag.fixE(e);
			
			var ey	= e.clientY - 170;
			var ex	= e.clientX - 160;
			var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
			var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );

			if (o.minX != null) ex = o.hmode ? Math.max(ex, o.minX) : Math.min(ex, o.maxX);
			if (o.maxX != null) ex = o.hmode ? Math.min(ex, o.maxX) : Math.max(ex, o.minX);
			if (o.minY != null) ey = o.vmode ? Math.max(ey, o.minY) : Math.min(ey, o.maxY);
			if (o.maxY != null) ey = o.vmode ? Math.min(ey, o.maxY) : Math.max(ey, o.minY);
			
			tip = ex - x + ey - y;
		}
		
		if (tip != 0)
		{
			nx = x + o.oh * (tip > 0 ? 1 : -1);
			ny = y + o.oh * (tip > 0 ? 1 : -1);
			if (o.minX != null) nx = o.hmode ? Math.max(nx, o.minX) : Math.min(nx, o.maxX);
			if (o.maxX != null) nx = o.hmode ? Math.min(nx, o.maxX) : Math.max(nx, o.minX);
			if (o.minY != null) ny = o.vmode ? Math.max(ny, o.minY) : Math.min(ny, o.maxY);
			if (o.maxY != null) ny = o.vmode ? Math.min(ny, o.maxY) : Math.max(ny, o.minY);

			o.style[o.hmode ? "left" : "right"] = parseInt(nx) + "px";
			o.style[o.vmode ? "top" : "bottom"] = parseInt(ny) + "px";
			o.onDrag	(nx, ny); 
			o.onDragEnd	(nx, ny); 
		}
		return false;
	},

	fixE : function(e)
	{
		if (typeof e == 'undefined') e = window.event;
		if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
		if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
		return e;
	}
};--->
</script>


</body>
</html>
</cfoutput>

