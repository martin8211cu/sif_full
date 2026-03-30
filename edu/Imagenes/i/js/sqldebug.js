fixSQLDebug = false;
moveSQLDebug = false;
moveSQLstartX = 0;
moveSQLstartY = 0;
numDebugSQL=1

var isIE = false, isNav = false, range = "all.", style = ".style", i, d = 0;
var topPix = ".pixelTop", leftPix = ".pixelLeft", images, storage;
if (document.layers) {
	isNav = true, range = "layers.", style = "", topPix = ".top", leftPix = ".left";
} else if (document.all) {
	isIE = true;
}

function sqlDebugFind(s)
{
	if (s == null) s = "sqlDebug";
	if (document.all) {
		return document.all[s];
	} else {
		return document.getElementById(s);
	}
}

function sqlDebugStart(numDebugSQL)
{
	var ret = "";
	ret +=
		"<table cellspacing='0' cellpadding='4' width='100%'><tr onmousemove='sqlDebugTitleMove()' onmousedown='sqlDebugTitleClick()' >"
		+ "<td align='middle' style='font: bold 7pt Verdana; color:white; background-color:skyblue;' >SQLDebug</td>"
		+ "<td align='right' style='font: bold 7pt Verdana; color:white; background-color:skyblue;'>";
	if (numDebugSQL > 0) {
		ret += "<a href='javascript:sqlDebugGoto(" + (numDebugSQL-1) + ");' style='text-decoration:none; color:white' title='Anterior'>&lt;</a>";
	} else {
		ret += "<a href='#' style='text-decoration:none; color:gray' title='Est&aacute; en el primer registro'>&lt;</a>";
	}

	ret += " " + (numDebugSQL+1) + " ";
		
	if ((numDebugSQL + 1) < debug_sql_info.length) {
		ret += "<a href='javascript:sqlDebugGoto(" + (numDebugSQL+1) + ");' style='text-decoration:none; color:white' title='Siguiente'>&gt;</a>"
	} else {
		ret += "<a href='#' style='text-decoration:none; color:gray' title='Est&aacute; en el &uacute;ltimo registro'>&gt;</a>"
	}
	ret +=
		  "<a href='javascript:sqlDebugClick();' style='text-decoration:none; color:white' title='Cerrar'> x </a>"
		+ "<a href='javascript:sqlDebugViewAll();' style='text-decoration:none; color:white' title='Ver formato tabular'> all </a>"
		+ "</td></tr>"
		+ "<tr><td style='text-decoration:none; font: 7pt Verdana;' colspan='2'>";
	return ret;
}

function sqlDebugEnd(numDebugSQL)
{
	return "</td></tr></table>";
}

function sqlDebugViewAll()
{
	var inner = sqlDebugStart(0);
	inner += "<table><tr>"
		+ "<td style='text-decoration:none; font: bold 7pt Verdana;' colspan='2'></td>"
		+ "<th style='text-decoration:none; font: bold 7pt Verdana;' colspan='2'>cache</th>"
		+ "<th style='text-decoration:none; font: bold 7pt Verdana;' colspan='2'>lap</th>"
		+ "<td style='text-decoration:none; font: bold 7pt Verdana;' colspan='2'>run</td>"
		+ "<td style='text-decoration:none; font: bold 7pt Verdana;' colspan='2'>now</td>"
		+ "<td style='text-decoration:none; font: bold 7pt Verdana;' colspan='2'>text</td></tr>";
	for (x in debug_sql_info) {
		var subtext = debug_sql_info[x].text;
		var frompos = subtext.indexOf("from");
		if (frompos == -1) {
			subtext = subtext.substring(0,20);
		} else {
			subtext = subtext.substring(frompos+5, frompos+25);
		}
		inner +=
		   "<tr><td style='text-decoration:none; font: 7pt Verdana;' align='top' colspan='2'>" + (1+parseInt(x))
		+ "</td><td style='text-decoration:none; font: 7pt Verdana;' align='top' colspan='2'>" + debug_sql_info[x].cache
		+ "</td><td style='text-decoration:none; font: 7pt Verdana;' align='top' colspan='2'>" + debug_sql_info[x].lapMillis
		+ "</td><td style='text-decoration:none; font: 7pt Verdana;' align='top' colspan='2'>" + debug_sql_info[x].runMillis
		+ "</td><td style='text-decoration:none; font: 7pt Verdana;' align='top' colspan='2'>" + debug_sql_info[x].now.split(' ')[4]
		+ "</td><td style='text-decoration:none; font: 7pt Verdana;' align='top' colspan='2'>" + subtext
		+ "</td></tr>";
	}
	inner += "</table>";
	inner += sqlDebugEnd(numDebugSQL);
	sqlDebugFind().innerHTML = inner;
}

function sqlDebugGoto(numDebugSQL)
{
	var inner = sqlDebugStart(numDebugSQL);
	inner +=
		  "<b>Nombre del cache:</b> " + debug_sql_info[numDebugSQL].cache
		+ "<br /><b>Tiempo desde &uacute;ltimo acceso:</b> " + debug_sql_info[numDebugSQL].lapMillis + " ms"
		+ "<br /><b>Tiempo de ejecuci&oacute;n:</b> " + debug_sql_info[numDebugSQL].runMillis + " ms"
		+ "<br /><b>Fecha actual:</b> " + debug_sql_info[numDebugSQL].now
		+ "<br /><b>Texto SQL:</b> <br />" + debug_sql_info[numDebugSQL].text;
	inner += sqlDebugEnd(numDebugSQL);
	sqlDebugFind().innerHTML = inner;
}

function sqlDebugMouseMove (evt)
{
	if (isIE) evt = window.event;
	var sd = sqlDebugFind();
	sqlDebugGoto(numDebugSQL);

	if (isIE) {
		sd.style.top  = document.body.scrollTop + evt.clientY - (event.clientY % 24) + 24;
		sd.style.left = document.body.scrollLeft + evt.clientX - (event.clientX % 24) + 24;
	} else {
		sd.style.top  = evt.pageY - (event.pageY % 24) + 124;
		sd.style.left = evt.pageX - (event.pageX % 24) + 124;
	}
	sd.style.width = "400";
	sd.style.padding = "8px";
	sd.style.backgroundColor = "white"
	sd.style.color="black"
	sd.style.border = fixSQLDebug ? "solid black" : "solid gray";
	sd.style.display = "inline";
}

function sqlDebugMouseOut ()
{
	if (!fixSQLDebug) {
		sqlDebugFind().style.display = "none";
	}
}

function sqlDebugClick ()
{
	fixSQLDebug = !fixSQLDebug;
	sqlDebugFind().style.border = fixSQLDebug ? "solid black" : "solid gray";
	sqlDebugFind().style.display = fixSQLDebug ? "inline" : "none";
}

function sqlDebugTitleClick(event) {
	moveSQLDebug = !moveSQLDebug;
	if (isIE) event = window.event;
	moveSQLstartY = event.clientY;
	moveSQLstartX = event.clientX;
}

function sqlDebugTitleMove(event) {
	if (isIE) event = window.event;
	if (event.button) {
		var sd = sqlDebugFind();
		sd.style.pixelTop  +=  event.clientY - moveSQLstartY;
		moveSQLstartY = event.clientY;
		sd.style.pixelLeft +=  event.clientX - moveSQLstartX;
		moveSQLstartX = event.clientX;

	}
}

function alert2(x)
{
	var sx=""
	for (i in x) sx += ","+i+"="+x[i];
	alert(sx)
}