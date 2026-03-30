<cfsetting showdebugoutput="no">
// calendario
var weekend = [0,6];
var weekendColor = "#e0e0e0";
var fontface = "Verdana";
var fontsize = 2;

var gNow = new Date();
var ggWinCal;

var isNav = (navigator.appName.indexOf("Netscape") != -1) ? true : false;
var isIE = (navigator.appName.indexOf("Microsoft") != -1) ? true : false;


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Enero"
Default="Enero"
returnvariable="LB_Enero"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Febrero"
Default="Febrero"
returnvariable="LB_Febrero"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Marzo"
Default="Marzo"
returnvariable="LB_Marzo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Abril"
Default="Abril"
returnvariable="LB_Abril"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Mayo"
Default="Mayo"
returnvariable="LB_Mayo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Junio"
Default="Junio"
returnvariable="LB_Junio"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Julio"
Default="Julio"
returnvariable="LB_Julio"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Agosto"
Default="Agosto"
returnvariable="LB_Agosto"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Septiembre"
Default="Septiembre"
returnvariable="LB_Septiembre"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Octubre"
Default="Octubre"
returnvariable="LB_Octubre"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Noviembre"
Default="Noviembre"
returnvariable="LB_Noviembre"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Diciembre"
Default="Diciembre"
returnvariable="LB_Diciembre"/>

<cfoutput>
Calendar.Months = ["#LB_Enero#", "#LB_Febrero#", "#LB_Marzo#", "#LB_Abril#", "#LB_Mayo#", "#LB_Junio#",
"#LB_Julio#", "#LB_Agosto#", "#LB_Septiembre#", "#LB_Octubre#", "#LB_Noviembre#", "#LB_Diciembre#"];
</cfoutput>
// Non-Leap year Month days..
Calendar.DOMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
// Leap year Month days..
Calendar.lDOMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

function Calendar(p_item, p_WinCal, p_month, p_year, p_format) {
if ((p_month == null) && (p_year == null))	return;

if (p_WinCal == null)
this.gWinCal = ggWinCal;
else
this.gWinCal = p_WinCal;

if (p_month == null) {
this.gMonthName = null;
this.gMonth = null;
this.gYearly = true;
} else {
this.gMonthName = Calendar.get_month(p_month);
this.gMonth = new Number(p_month);
this.gYearly = false;
}

this.gYear = p_year;
this.gFormat = p_format;
this.gBGColor = "white";
this.gFGColor = "black";
this.gTextColor = "black";
this.gHeaderColor = "black";
this.gReturnItem = p_item;
}

Calendar.get_month = Calendar_get_month;
Calendar.get_daysofmonth = Calendar_get_daysofmonth;
Calendar.calc_month_year = Calendar_calc_month_year;
Calendar.print = Calendar_print;

function Calendar_get_month(monthNo) {
return Calendar.Months[monthNo];
}

function Calendar_get_daysofmonth(monthNo, p_year) {
/* 
Check for leap year ..
1.Years evenly divisible by four are normally leap years, except for... 
2.Years also evenly divisible by 100 are not leap years, except for... 
3.Years also evenly divisible by 400 are leap years. 
*/
if ((p_year % 4) == 0) {
if ((p_year % 100) == 0 && (p_year % 400) != 0)
return Calendar.DOMonth[monthNo];

return Calendar.lDOMonth[monthNo];
} else
return Calendar.DOMonth[monthNo];
}

function Calendar_calc_month_year(p_Month, p_Year, incr) {
/* 
Will return an 1-D array with 1st element being the calculated month 
and second being the calculated year 
after applying the month increment/decrement as specified by 'incr' parameter.
'incr' will normally have 1/-1 to navigate thru the months.
*/
var ret_arr = new Array();

if (incr == -1) {
// B A C K W A R D
if (p_Month == 0) {
ret_arr[0] = 11;
ret_arr[1] = parseInt(p_Year) - 1;
}
else {
ret_arr[0] = parseInt(p_Month) - 1;
ret_arr[1] = parseInt(p_Year);
}
} else if (incr == 1) {
// F O R W A R D
if (p_Month == 11) {
ret_arr[0] = 0;
ret_arr[1] = parseInt(p_Year) + 1;
}
else {
ret_arr[0] = parseInt(p_Month) + 1;
ret_arr[1] = parseInt(p_Year);
}
}

return ret_arr;
}

function Calendar_print() {
ggWinCal.print();
}

function Calendar_calc_month_year(p_Month, p_Year, incr) {
/* 
Will return an 1-D array with 1st element being the calculated month 
and second being the calculated year 
after applying the month increment/decrement as specified by 'incr' parameter.
'incr' will normally have 1/-1 to navigate thru the months.
*/
var ret_arr = new Array();

if (incr == -1) {
// B A C K W A R D
if (p_Month == 0) {
ret_arr[0] = 11;
ret_arr[1] = parseInt(p_Year) - 1;
}
else {
ret_arr[0] = parseInt(p_Month) - 1;
ret_arr[1] = parseInt(p_Year);
}
} else if (incr == 1) {
// F O R W A R D
if (p_Month == 11) {
ret_arr[0] = 0;
ret_arr[1] = parseInt(p_Year) + 1;
}
else {
ret_arr[0] = parseInt(p_Month) + 1;
ret_arr[1] = parseInt(p_Year);
}
}

return ret_arr;
}

// This is for compatibility with Navigator 3, we have to create and discard one object before the prototype object exists.
new Calendar();

Calendar.prototype.getMonthlyCalendarCode = function() {
var vCode = "";
var vHeader_Code = "";
var vData_Code = "";

// Begin Table Drawing code here..
vCode = vCode + "<TABLE BORDER=1 BGCOLOR=\"" + this.gBGColor + "\">";

vHeader_Code = this.cal_header();
vData_Code = this.cal_data();
vCode = vCode + vHeader_Code + vData_Code;

vCode = vCode + "</TABLE>";

return vCode;
}

Calendar.prototype.show = function() {
var vCode = "";

this.gWinCal.document.open();

// Setup the page...
this.wwrite("<html>");
this.wwrite("<head><title>Calendario</title>");
this.wwrite("</head>");
//this.wwrite("<SCRIPT LANGUAGE='JavaScript' SRC='utiles.js'></SCRIPT>");
this.wwrite("<body " + 
"link=\"" + this.gLinkColor + "\" " + 
"vlink=\"" + this.gLinkColor + "\" " +
"alink=\"" + this.gLinkColor + "\" " +
"text=\"" + this.gTextColor + "\">");
this.wwrite("<FORM>"); 

this.wwrite(this.get_encabezado(this.gMonth, this.gYear));
// Show navigation buttons
var prevMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, -1);
var prevMM = prevMMYYYY[0];
var prevYYYY = prevMMYYYY[1];

var nextMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, 1);
var nextMM = nextMMYYYY[0];
var nextYYYY = nextMMYYYY[1];

this.wwrite("<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#e0e0e0'>");
/*
this.wwrite("<TR><TD ALIGN=center>");
this.wwrite("<INPUT TYPE=\"button\" onClick=\"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)-1) + "', '" + this.gFormat + "'" +
");\" value=\"<<\">");
this.wwrite("</TD>");
this.wwrite("<TD ALIGN=center>");
this.wwrite("<INPUT TYPE=\"button\" onClick=\"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + prevMM + "', '" + prevYYYY + "', '" + this.gFormat + "'" +
");\" value=\"<\">");
this.wwrite("</TD>");
this.wwrite("<TD ALIGN=center>");

var dDate = new Date();

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Actual"
Default="Actual"
returnvariable="LB_Actual"/>

this.wwrite("<INPUT TYPE=\"button\" onClick=\"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + dDate.getMonth() + "', '" + dDate.getYear() + "', '" + this.gFormat + "'" +
");\" value=\"<cfoutput>#LB_Actual#</cfoutput>\">");
this.wwrite("</TD>");
this.wwrite("<TD ALIGN=center>");
this.wwrite("<INPUT TYPE=\"button\" onClick=\"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + nextMM + "', '" + nextYYYY + "', '" + this.gFormat + "'" +
");\" value=\">\">");
this.wwrite("</TD>");
this.wwrite("<TD ALIGN=center>");
this.wwrite("<INPUT TYPE=\"button\" onClick=\"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)+1) + "', '" + this.gFormat + "'" +
");\" value=\">>\">");
this.wwrite("</TD>");
this.wwrite("</TR>");
*/
this.wwrite("<TR>");
this.wwrite("<TD BGCOLOR='#e0e0e0' ALIGN=center>");
this.wwrite("[<A HREF=\"" +
"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)-1) + "', '" + this.gFormat + "'" +
");" +
"\"><<<\/A>]</TD><TD BGCOLOR='#e0e0e0' ALIGN=center>");
this.wwrite("[<A HREF=\"" +
"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + prevMM + "', '" + prevYYYY + "', '" + this.gFormat + "'" +
");" +
"\"><<\/A>]</TD><TD BGCOLOR='#e0e0e0' ALIGN=center>");

var dDate = new Date();
var tYear = dDate.getYear();
tYear += (tYear<=1900)?1900:0;

this.wwrite("[<A HREF=\"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + dDate.getMonth() + "', '" + parseInt(tYear) + "', '" + this.gFormat + "'" +
");\"><cfoutput>#LB_Actual#</cfoutput></A>]</TD><TD BGCOLOR='#e0e0e0' ALIGN=center>");

this.wwrite("[<A HREF=\"" +
"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + nextMM + "', '" + nextYYYY + "', '" + this.gFormat + "'" +
");" +
"\">><\/A>]</TD><TD BGCOLOR='#e0e0e0' ALIGN=center>");
this.wwrite("[<A HREF=\"" +
"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)+1) + "', '" + this.gFormat + "'" +
");" +
"\">>><\/A>]</TD></TR></TABLE><BR>");

// Get the complete calendar code for the month..
vCode = this.getMonthlyCalendarCode();
this.wwrite(vCode);

this.wwrite("</font></FORM></body></html>");
this.gWinCal.document.close();
}

Calendar.prototype.showY = function() {
var vCode = "";
var i;
var vr, vc, vx, vy;		// Row, Column, X-coord, Y-coord
var vxf = 285;			// X-Factor
var vyf = 200;			// Y-Factor
var vxm = 10;			// X-margin
var vym;				// Y-margin
if (isIE)	vym = 75;
else if (isNav)	vym = 25;

this.gWinCal.document.open();

this.wwrite("<html>");
this.wwrite("<head><title>Calendar</title>");
this.wwrite("<style type='text/css'>\n<!--");
for (i=0; i<12; i++) {
vc = i % 3;
if (i>=0 && i<= 2)	vr = 0;
if (i>=3 && i<= 5)	vr = 1;
if (i>=6 && i<= 8)	vr = 2;
if (i>=9 && i<= 11)	vr = 3;

vx = parseInt(vxf * vc) + vxm;
vy = parseInt(vyf * vr) + vym;

this.wwrite(".lclass" + i + " {position:absolute;top:" + vy + ";left:" + vx + ";}");
}
this.wwrite("-->\n</style>");
this.wwrite("</head>");
this.wwrite("<body " + 
"link=\"" + this.gLinkColor + "\" " + 
"vlink=\"" + this.gLinkColor + "\" " +
"alink=\"" + this.gLinkColor + "\" " +
"text=\"" + this.gTextColor + "\">");
this.wwrite("<FONT FACE='" + fontface + "' SIZE=2><B>");
this.wwrite("Year : " + this.gYear);
this.wwrite("</B><BR>");

// Show navigation buttons
var prevYYYY = parseInt(this.gYear) - 1;
var nextYYYY = parseInt(this.gYear) + 1;

this.wwrite("<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#e0e0e0'><TR><TD ALIGN=center>");
this.wwrite("[<A HREF=\"" +
"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', null, '" + prevYYYY + "', '" + this.gFormat + "'" +
");" +
"\" alt='Prev Year'><<<\/A>]</TD><TD ALIGN=center>");
this.wwrite("[<A HREF=\"javascript:window.print();\">Print</A>]</TD><TD ALIGN=center>");
this.wwrite("[<A HREF=\"" +
"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', null, '" + nextYYYY + "', '" + this.gFormat + "'" +
");" +
"\">>><\/A>]</TD></TR></TABLE><BR>");

// Get the complete calendar code for each month..
var j;
for (i=11; i>=0; i--) {
if (isIE)
this.wwrite("<DIV ID=\"layer" + i + "\" CLASS=\"lclass" + i + "\">");
else if (isNav)
this.wwrite("<LAYER ID=\"layer" + i + "\" CLASS=\"lclass" + i + "\">");

this.gMonth = i;
this.gMonthName = Calendar.get_month(this.gMonth);
vCode = this.getMonthlyCalendarCode();
this.wwrite(this.gMonthName + "/" + this.gYear + "<BR>");
this.wwrite(vCode);

if (isIE)
this.wwrite("</DIV>");
else if (isNav)
this.wwrite("</LAYER>");
}

this.wwrite("</font><BR></body></html>");
this.gWinCal.document.close();
}

Calendar.prototype.wwrite = function(wtext) {
this.gWinCal.document.writeln(wtext);
}

Calendar.prototype.wwriteA = function(wtext) {
this.gWinCal.document.write(wtext);
}

Calendar.prototype.cal_header = function() {
var vCode = "";

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Dom"
Default="Dom"
returnvariable="LB_Dom"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Lun"
Default="Lun"
returnvariable="LB_Lun"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Martes"
Default="Mar"
returnvariable="LB_Martes"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Mie"
Default="Mie"
returnvariable="LB_Mie"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Jue"
Default="Jue"
returnvariable="LB_Jue"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Vie"
Default="Vie"
returnvariable="LB_Vie"/>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Sab"
Default="Sab"
returnvariable="LB_Sab"/>

<cfoutput>
	vCode = vCode + "<TR>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>#LB_Dom#</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>#LB_Lun#</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>#LB_Martes#</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>#LB_Mie#</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>#LB_Jue#</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>#LB_Vie#</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='16%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>#LB_Sab#</B></FONT></TD>";
	vCode = vCode + "</TR>";
</cfoutput>
return vCode;
}

Calendar.prototype.cal_data = function() {
var vDate = new Date();
vDate.setDate(1);
vDate.setMonth(this.gMonth);
vDate.setFullYear(this.gYear);

var vFirstDay=vDate.getDay();
var vDay=1;
var vLastDay=Calendar.get_daysofmonth(this.gMonth, this.gYear);
var vOnLastDay=0;
var vCode = "";

/*
Get day for the 1st of the requested month/year..
Place as many blank cells before the 1st day of the month as necessary. 
*/

vCode = vCode + "<TR>";
for (i=0; i<vFirstDay; i++) {
vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(i) + "><FONT SIZE='2' FACE='" + fontface + "'> </FONT></TD>";
}

// Write rest of the 1st week
for (j=vFirstDay; j<7; j++) {
vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j) + "><FONT SIZE='2' FACE='" + fontface + "'>" + 
"<A HREF='#' " + 
"onClick=\"self.opener." +this.gReturnItem + ".focus(); self.opener.finishCalendar('" + this.gReturnItem + "', '" + this.format_data(vDay) + "'); window.close();\">" + 
<!---
"onClick=\"if (self.opener.funcFecha) {self.opener." + this.gReturnItem + ".value='" + this.format_data(vDay) + "';self.opener.funcFecha('" +this.gReturnItem + "');} " +
"else {self.opener.finishCalendar('" + this.gReturnItem + "', '" + this.format_data(vDay) + "');} window.close();\">" + 
--->
this.format_day(vDay) + 
"</A>" + 
"</FONT></TD>";
vDay=vDay + 1;
}
vCode = vCode + "</TR>";

// Write the rest of the weeks
for (k=2; k<7; k++) {
vCode = vCode + "<TR>";

for (j=0; j<7; j++) {
vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j) + "><FONT SIZE='2' FACE='" + fontface + "'>" + 
"<A HREF='#' " + 
"onClick=\"self.opener." +this.gReturnItem + ".focus(); self.opener.finishCalendar('" + this.gReturnItem + "', '" + this.format_data(vDay) + "'); window.close();\">" + 
this.format_day(vDay) + 
"</A>" + 
"</FONT></TD>";
vDay=vDay + 1;

if (vDay > vLastDay) {
vOnLastDay = 1;
break;
}
}

if (j == 6)
vCode = vCode + "</TR>";
if (vOnLastDay == 1)
break;
}

// Fill up the rest of last week with proper blanks, so that we get proper square blocks
for (m=1; m<(7-j); m++) {
if (this.gYearly)
vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j+m) + 
"><FONT SIZE='2' FACE='" + fontface + "' COLOR='gray'> </FONT></TD>";
else
vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j+m) + 
"><FONT SIZE='2' FACE='" + fontface + "' COLOR='gray'>" + m + "</FONT></TD>";
}

return vCode;
}

Calendar.prototype.format_day = function(vday) {
var vNowDay = gNow.getDate();
var vNowMonth = gNow.getMonth();
var vNowYear = gNow.getFullYear();

if (vday == vNowDay && this.gMonth == vNowMonth && this.gYear == vNowYear)
return ("<FONT COLOR=\"RED\"><B>" + vday + "</B></FONT>");
else
return (vday);
}

Calendar.prototype.write_weekend_string = function(vday) {
var i;

// Return special formatting for the weekend day.
for (i=0; i<weekend.length; i++) {
if (vday == weekend[i])
return (" BGCOLOR=\"" + weekendColor + "\"");
}

return "";
}

Calendar.prototype.format_data = function(p_day) {
var vData;
var vMonth = 1 + this.gMonth;
vMonth = (vMonth.toString().length < 2) ? "0" + vMonth : vMonth;
var vMon = Calendar.get_month(this.gMonth).substr(0,3).toUpperCase();
var vFMon = Calendar.get_month(this.gMonth).toUpperCase();
var vY4 = new String(this.gYear);
var vY2 = new String(this.gYear.substr(2,2));
var vDD = (p_day.toString().length < 2) ? "0" + p_day : p_day;

switch (this.gFormat) {
case "MM\/DD\/YYYY" :
vData = vMonth + "\/" + vDD + "\/" + vY4;
break;
case "MM\/DD\/YY" :
vData = vMonth + "\/" + vDD + "\/" + vY2;
break;
case "MM-DD-YYYY" :
vData = vMonth + "-" + vDD + "-" + vY4;
break;
case "MM-DD-YY" :
vData = vMonth + "-" + vDD + "-" + vY2;
break;

case "DD\/MON\/YYYY" :
vData = vDD + "\/" + vMon + "\/" + vY4;
break;
case "DD\/MON\/YY" :
vData = vDD + "\/" + vMon + "\/" + vY2;
break;
case "DD-MON-YYYY" :
vData = vDD + "-" + vMon + "-" + vY4;
break;
case "DD-MON-YY" :
vData = vDD + "-" + vMon + "-" + vY2;
break;

case "DD\/MONTH\/YYYY" :
vData = vDD + "\/" + vFMon + "\/" + vY4;
break;
case "DD\/MONTH\/YY" :
vData = vDD + "\/" + vFMon + "\/" + vY2;
break;
case "DD-MONTH-YYYY" :
vData = vDD + "-" + vFMon + "-" + vY4;
break;
case "DD-MONTH-YY" :
vData = vDD + "-" + vFMon + "-" + vY2;
break;

case "DD\/MM\/YYYY" :
vData = vDD + "\/" + vMonth + "\/" + vY4;
break;
case "DD\/MM\/YY" :
vData = vDD + "\/" + vMonth + "\/" + vY2;
break;
case "DD-MM-YYYY" :
vData = vDD + "-" + vMonth + "-" + vY4;
break;
case "DD-MM-YY" :
vData = vDD + "-" + vMonth + "-" + vY2;
break;

default :
vData = vMonth + "\/" + vDD + "\/" + vY4;
}

return vData;
}

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Mes"
Default="Mes"
returnvariable="LB_Mes"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_anno"
Default="A&ntilde;o"
returnvariable="LB_anno"/> 


Calendar.prototype.get_encabezado = function(aMonth, aYear) {
	var temp = "";
	temp += "<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#e0e0e0'><TR valign=\"center\">";
	 temp += "<TD valign=\"center\" BGCOLOR='#e0e0e0'><FONT FACE='" + fontface + "' SIZE=2><B><cfoutput>#LB_Mes#</cfoutput>: </B></FONT>\n";
	temp += "<SELECT name=\"mesAct\" onChange=\"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "',this.selectedIndex, '" + (parseInt(this.gYear)) + "', '" + this.gFormat + "'" +
");\">\n";
	for (var i=1; i<=12; i++) {
		if (i == (aMonth+1)) {
			temp += "<OPTION value=\"" + parseInt(i) + "\" selected>" + Calendar.get_month(i-1) + "</OPTION>\n";
		} else {
			temp += "<OPTION value=\"" + parseInt(i) + "\">" + Calendar.get_month(i-1) + "</OPTION>\n";
		}		
	}
	temp += "</SELECT>\n";
	temp += "</TD>\n";
	temp += "<TD BGCOLOR='#e0e0e0' valign=\"center\"><FONT FACE='" + fontface + "' SIZE=2><B><cfoutput>#LB_anno#</cfoutput>: </B></FONT>";
	temp += "<INPUT TYPE=\"textbox\" MAXLENGTH=\"4\" SIZE=\"4\" value=\"" + aYear + "\" ONKEYUP=\"if (this.value.length==4) window.opener.Build('"+this.gReturnItem+"', (''+(parseInt(this.form.mesAct.value)-1)), this.value, 'DD/MM/YYYY');\">";
	//temp += "<INPUT TYPE=\"textbox\" MAXLENGTH=\"4\" SIZE=\"4\" ONFOCUS=\" this.blur();\" value=\"" + aYear + "\">";	
//ONKEYUP=\"snumber(this,event,-1);\" 
	temp += "</TD>\n";
	temp += "</TR>";
	temp += "</TABLE>\n";
	return temp;
	
}

function Build(p_item, p_month, p_year, p_format) {
var p_WinCal = ggWinCal;
gCal = new Calendar(p_item, p_WinCal, p_month, p_year, p_format);

// Customize your Calendar here..
gCal.gBGColor="white";
gCal.gLinkColor="black";
gCal.gTextColor="black";
gCal.gHeaderColor="darkgreen";

// Choose appropriate show function
if (gCal.gYearly)	gCal.showY();
else	gCal.show();
}

function show_calendar() {
/* 
p_month : 0-11 for Jan-Dec; 12 for All Months.
p_year	: 4-digit year
p_format: Date format (mm/dd/yyyy, dd/mm/yy, ...)
p_item	: Return Item.
*/

p_item = arguments[0];
if (arguments[1] == null)
p_month = new String(gNow.getMonth());
else
p_month = arguments[1];
if (arguments[2] == "" || arguments[2] == null)
p_year = new String(gNow.getFullYear().toString());
else
p_year = arguments[2];
if (arguments[3] == null)
p_format = "DD/MM/YYYY";
else
p_format = arguments[3];

vWinCal = window.open("", "Calendar", 
"width=250,height=250,status=no,resizable=no,top=200,left=200");
vWinCal.opener = self;
ggWinCal = vWinCal;

Build(p_item, p_month, p_year, p_format);
}
/*
Yearly Calendar Code Starts here
*/
function show_yearly_calendar(p_item, p_year, p_format) {
// Load the defaults..
if (p_year == null || p_year == "")
p_year = new String(gNow.getFullYear().toString());
if (p_format == null || p_format == "")
p_format = "MM/DD/YYYY";

var vWinCal = window.open("", "Calendar", "scrollbars=yes");
vWinCal.opener = self;
ggWinCal = vWinCal;

Build(p_item, null, p_year, p_format);
}

function showCalendar(aDateField, control) {
/*
	if (control != null) {
		var pos1 = control.value.indexOf("/");
		if (pos1 != -1) {
			var sbst = control.value.substring(pos1+1, control.value.length);
			var pos2 = sbst.indexOf("/");
			if (pos2 != -1) {
				var x_month = ""+(parseInt(sbst.substring(0,pos2))-1);
				var x_year = sbst.substring(pos2+1, sbst.length);
				show_calendar(aDateField, x_month, x_year);
			} else {
				show_calendar(aDateField);
			}
		} else {
			show_calendar(aDateField);
		}
	} else {
		show_calendar(aDateField);
	}
*/
	show_calendar(aDateField);
}


/**
 * Formato de la fecha en formato dd/mm/yyyy
 * Si no se especifica el ao, se pone el ao
 * actual
 * Tomado de fecha.js
 * Si se modifica esto, hay que cambiar /recursos/calendar.js
 */
function fechaBlur (fecha)
{
    var f = fecha.value;
    var partes = f.split ("/");
    var ano = 0, mes = 0; dia = 0;
    if (partes.length == 3) {
        ano = parseInt(partes[2], 10);
        mes = parseInt(partes[1], 10); // para que no tome el 09 como octal
        dia = parseInt(partes[0], 10);
    } else if (partes.length == 2) {
        var hoy = new Date();
        ano = hoy.getFullYear();
        mes = parseInt(partes[1], 10);
        dia = parseInt(partes[0], 10);
    } else {
        // no es fecha
    }
    
    if (ano < 100) {
        ano += (ano < 50 ? 2000 : 1900);
    } else if (ano < 1753) {
        ano = 0;
    }
    
    var d = new Date(ano, (mes - 1), dia);
    if ((d.getFullYear() == ano) && 
        (d.getMonth()    == mes - 1) && 
        (d.getDate()     == dia))
    {   // ok
        fecha.value 
            = (d.getDate()  < 10 ? "0" : "") + d.getDate() + "/" 
            + (d.getMonth() < 9 ? "0" : "") + (d.getMonth()+1) + "/" + d.getFullYear();
    } else {
        fecha.value = "";
    }
}

function finishCalendar(campo, valor)
{
	var obj  	  = eval(campo);
    var navegador = navigator.userAgent;
	var obj2 	  = document.getElementById("img_" + campo.split(".")[1] + "_" + campo.split(".")[2]);
	// el window.focus fuerza a que la ventana tenga el focus para que el blur sirva en firefox
	window.focus();
	obj.value = valor;
	if (window.funcFecha)
		window.funcFecha(campo);
	// el obj2.focus fuerza el onblur de obj

    //Si existe la funcion y no es IE, Chrome 0 Safari (Opera no sirve por completo el SifCalendar)
    if (eval('window.fnCalendar_'+obj.name)  &&  navigator.userAgent.indexOf("MSIE") < 0 && navigator.userAgent.indexOf("Chrome") < 0 && navigator.userAgent.indexOf("Safari") < 0)
    	eval('window.fnCalendar_'+obj.name+'()');

	obj2.focus();
}
