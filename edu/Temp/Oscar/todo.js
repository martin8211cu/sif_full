// file: calendar.js

var weekend = [0,6];
var weekendColor = "#e0e0e0";
var fontface = "Verdana";
var fontsize = 2;

var gNow = new Date();
var ggWinCal;

var isNav = (navigator.appName.indexOf("Netscape") != -1) ? true : false;
var isIE = (navigator.appName.indexOf("Microsoft") != -1) ? true : false;
/* En un futuro se implementa multilenguaje
Calendar.Months = ["January", "February", "March", "April", "May", "June",
"July", "August", "September", "October", "November", "December"];
*/
Calendar.Months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
"Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"];

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

this.wwrite("<INPUT TYPE=\"button\" onClick=\"javascript:window.opener.Build(" + 
"'" + this.gReturnItem + "', '" + dDate.getMonth() + "', '" + dDate.getYear() + "', '" + this.gFormat + "'" +
");\" value=\"Actual\">");
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
");\">Actual</A>]</TD><TD BGCOLOR='#e0e0e0' ALIGN=center>");

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

vCode = vCode + "<TR>";
vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Dom</B></FONT></TD>";
vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Lun</B></FONT></TD>";
vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Mar</B></FONT></TD>";
vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Mie</B></FONT></TD>";
vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Jue</B></FONT></TD>";
vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Vie</B></FONT></TD>";
vCode = vCode + "<TD WIDTH='16%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Sab</B></FONT></TD>";
vCode = vCode + "</TR>";

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
//"onClick=\"window.opener.document." + this.gReturnItem + ".value='" + 
"onClick=\"self.opener." + this.gReturnItem + ".value='" + 

this.format_data(vDay) + 
"';window.close();\">" + 
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
//"onClick=\"self.opener.document." + this.gReturnItem + ".value='" + 
"onClick=\"self.opener." + this.gReturnItem + ".value='" + 
this.format_data(vDay) + 
"';window.close();\">" + 
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


Calendar.prototype.get_encabezado = function(aMonth, aYear) {
	var temp = "";
	temp += "<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#e0e0e0'><TR valign=\"center\">";
	 temp += "<TD valign=\"center\" BGCOLOR='#e0e0e0'><FONT FACE='" + fontface + "' SIZE=2><B>Mes: </B></FONT>\n";
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
	temp += "<TD BGCOLOR='#e0e0e0' valign=\"center\"><FONT FACE='" + fontface + "' SIZE=2><B>A&ntilde;o: </B></FONT>";
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
 * Si no se especifica el año, se pone el año
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
        fecha.value = "" ;
    }
}
// file: cssexpr.js

function constExpression(x) {
	return x;
}

function simplifyCSSExpression() {
	try {
		var ss,sl, rs, rl;
		ss = document.styleSheets;
		sl = ss.length
	
		for (var i = 0; i < sl; i++) {
			simplifyCSSBlock(ss[i]);
		}
	}
	catch (exc) {
		alert("Got an error while processing css. The page should still work but might be a bit slower");
		throw exc;
	}
}

function simplifyCSSBlock(ss) {
	var rs, rl;
	
	for (var i = 0; i < ss.imports.length; i++)
		simplifyCSSBlock(ss.imports[i]);
	
	if (ss.cssText.indexOf("expression(constExpression(") == -1)
		return;

	rs = ss.rules;
	rl = rs.length;
	for (var j = 0; j < rl; j++)
		simplifyCSSRule(rs[j]);
	
}

function simplifyCSSRule(r) {
	var str = r.style.cssText;
	var str2 = str;
	var lastStr;
	do {
		lastStr = str2;
		str2 = simplifyCSSRuleHelper(lastStr);
	} while (str2 != lastStr)

	if (str2 != str)
		r.style.cssText = str2;
}

function simplifyCSSRuleHelper(str) {
	var i, i2;
	i = str.indexOf("expression(constExpression(");
	if (i == -1) return str;
	i2 = str.indexOf("))", i);
	var hd = str.substring(0, i);
	var tl = str.substring(i2 + 2);
	var exp = str.substring(i + 27, i2);
	var val = eval(exp)
	return hd + val + tl;
}

if (/msie/i.test(navigator.userAgent) && window.attachEvent != null) {
	window.attachEvent("onload", function () {
		simplifyCSSExpression();
	});
}

// file: stm31.js

// Ver: 3.72
var nOP=0,nOP5=0,nIE=0,nIE4=0,nIE5=0,nNN=0,nNN4=0,nNN6=0,nMac=0,nIEM=0,nIEW=0,nSTMENU=0;var NS4=0;var nVer=0.0;
bDelBorder=0;bAddBorder=0;detectNav();
bFtReg=1;
nTopTb=nIE&&(nMac||nVer<5.5)||nOP&&nVer>=6.0;

if(nNN4){	doitovNN4=getEventCode('doitov',1);doitouNN4=getEventCode('doitou',1);doitckNN4=getEventCode('doitck',1);dombovNN4=getEventCode('dombov',0);dombouNN4=getEventCode('dombou',0);	}

var MaxMenuNumber=10;
var HideSelect=1;
var HideObject=0;
var HideIFrame=0;

if(nNN6)	HideSelect=0;
if((nIEW&&nVer>=5.5)||nNN6)	HideIFrame=0;
var st_ht="";
var st_gcount=0;
var st_rl_id=null;
var st_cl_w,st_cl_h;
var st_cumei=0,st_cumbi,st_cuiti;
var st_rei=/STM([^_]*)_([0-9]*)__([0-9]*)___/;
var st_reb=/STM([^_]*)_([0-9]*)__/;
var st_menus=[];
var st_buf=[];
var st_loaded=0;
var st_scrollid=null;

if(nIE4||nNN4)	window.onerror=function(sMsg,sUrl,sLine)
{
	alert("Java Script Error\n"+"\nDescription:"+sMsg+"\nSource:"+sUrl+"\nLine:"+sLine);
	return true;
}

if(nSTMENU)		window.onload=st_onload;
if(nIEM)	window.onunload=function(){return true;}

if(typeof(st_jsloaded)=='undefined'){
if(nSTMENU&&!nNN4)
{
	var s="<STYLE>\n.st_tbcss{border:none;padding:0px;margin:0px;}\n.st_tdcss{border:none;padding:0px;margin:0px;}\n.st_divcss{border:none;padding:0px;margin:0px;}\n.st_ftcss{border:none;padding:0px;margin:0px;}\n</STYLE>";
	for(i=0;i<MaxMenuNumber;i++)
		s+="<FONT ID=st_global"+i+"></FONT>";
	if(nIEW&&nVer>=5.0&&document.body)
		document.body.insertAdjacentHTML("AfterBegin",s);
	else
		document.write(s);
}
st_jsloaded=1;}

st_state=["OU","OV"];

st_fl_id=["Box in","Box out","Circle in","Circle out","Wipe up","Wipe down","Wipe right","Wipe left","Vertical blinds","Horizontal blinds","Checkerboard across","Checkerboard down","Random dissolve","Split vertical in","Split vertical out","Split horizontal in","Split horizontal out","Strips left down","Strips left up","Strips right down","Strips right up","Random bars horizontal","Random bars vertical","Random filter","Fade",
	"Wheel","Slide","Slide push","Spread","Pixelate","Stretch right","Stretch horizontally","Cross in","Cross out","Plus in","Plus out","Star in","Star out","Diamond in","Diamond out","Checkerboard up","Checkerboard left","Blinds up","Blinds left","Wipe clock","Wipe wedge","Wipe radial","Spiral","Zigzag"];
st_fl_string=
[
	"Iris(irisStyle=SQUARE,motion=in)","Iris(irisStyle=SQUARE,motion=out)","Iris(irisStyle=CIRCLE,motion=in)","Iris(irisStyle=CIRCLE,motion=out)",
	"Wipe(GradientSize=1.0,wipeStyle=1,motion=reverse)","Wipe(GradientSize=1.0,wipeStyle=1,motion=forward)","Wipe(GradientSize=1.0,wipeStyle=0,motion=forward)","Wipe(GradientSize=1.0,wipeStyle=0,motion=reverse)",
	"Blinds(bands=8,direction=RIGHT)","Blinds(bands=8,direction=DOWN)",
	"Checkerboard(squaresX=16,squaresY=16,direction=right)","Checkerboard(squaresX=12,squaresY=12,direction=down)","RandomDissolve()",
	"Barn(orientation=vertical,motion=in)","Barn(orientation=vertical,motion=out)","Barn(orientation=horizontal,motion=in)","Barn(orientation=horizontal,motion=out)",
	"Strips(Motion=leftdown)","Strips(Motion=leftup)","Strips(Motion=rightdown)","Strips(Motion=rightup)",
	"RandomBars(orientation=horizontal)","RandomBars(orientation=vertical)","","Fade(overlap=.5)",
	"Wheel(spokes=16)","Slide(slideStyle=hide,bands=15)","Slide(slideStyle=swap,bands=15)","Inset()","Pixelate(MaxSquare=15)",
	"Stretch(stretchStyle=hide)","Stretch(stretchStyle=spin)",
	"Iris(irisStyle=cross,motion=in)","Iris(irisStyle=cross,motion=out)","Iris(irisStyle=plus,motion=in)","Iris(irisStyle=plus,motion=out)","Iris(irisStyle=star,motion=in)","Iris(irisStyle=star,motion=out)","Iris(irisStyle=diamond,motion=in)","Iris(irisStyle=diamond,motion=out)",
	"Checkerboard(squaresX=16,squaresY=16,direction=up)","Checkerboard(squaresX=16,squaresY=16,direction=left)","Blinds(bands=8,direction=up)","Blinds(bands=8,direction=left)",
	"RadialWipe(wipeStyle=clock)","RadialWipe(wipeStyle=wedge)","RadialWipe(wipeStyle=radial)","Spiral(GridSizeX=16,GridSizeY=16)","Zigzag(GridSizeX=16,GridSizeY=16)"
];

st_fl=[];	for(i=st_fl_id.length-1;i>=0;i--)	eval("st_fl['"+st_fl_id[i]+"']=i;");

function beginSTM(nam,type,pos_l,pos_t,flt,click_sh,click_hd,ver,hddelay,shdelay_h,shdelay_v,web_path,blank_src)
{
	if(!ver)		ver='300';
	if(hddelay==null)	hddelay='1000';
	if(shdelay_h==null)	shdelay_h='0';
	if(shdelay_v==null)	shdelay_v='250';
	if(!blank_src)	blank_src='blank.gif';
	eval("sdm_"+nam+"=st_cumei;");

	var pos=type;
	switch(type)
	{
	case "absolute":
		type="custom";break;
	case "custom":
	case "float":
		pos='absolute';break;
	case "relative":
		if(!eval(pos_l)&&!eval(pos_t))
		{
			pos='static';
			type='static';
		}
		break;
	case "static":
	default:
		type='static';pos='static';pos_l='0';pos_t='0';break;
	}
	if(web_path)
		blank_src=web_path+blank_src;
	else if(typeof(st_path)!='undefined')
		blank_src=st_path+blank_src;
	if(web_path==null)	web_path='';

	st_menus[st_cumei]=
	{
		bodys:		[],
		mei:		st_cumei,
		hdid:		null,

		block:		"STM"+st_cumei+"_",
		nam:		nam,
		type:		type,
		pos:		pos,
		pos_l:		eval(pos_l),
		pos_t:		eval(pos_t),
		flt:		flt,
		click_sh:	eval(click_sh),
		click_hd:	eval(click_hd),
		ver:		eval(ver),
		hddelay:	eval(hddelay),
		shdelay_h:	eval(shdelay_h),
		shdelay_v:	eval(shdelay_v),
		web_path:	web_path,

		blank:		bufimg(blank_src),		
		clicked:	false
	};
}

function beginSTMB(offset,offset_l,offset_t,arrange,arrow,arrow_w,arrow_h,spacing,padding,bg_cl,bg_image,bg_rep,bd_cl,bd_sz,bd_st,trans,spec,spec_sp,lw_max,lh_max,rw_max,rh_max,bg_pos_x,bg_pos_y,ds_sz,ds_color,hdsp,bd_cl_t,bd_cl_r,bd_cl_b,ds_st)
{
	if(!ds_sz)		ds_sz=0;
	if(!ds_color)	ds_color='gray';
	if(!hdsp)		hdsp=false;
	if(!bd_cl_t)	bd_cl_t='';
	if(!bd_cl_r)	bd_cl_r='';
	if(!bd_cl_b)	bd_cl_b='';
	if(!ds_st)		ds_st='none';
	switch(bg_rep){case 'tile':case 'tiled':{bg_rep='repeat';}break;case 'free':bg_rep='no-repeat';break;case 'tiled by x':bg_rep='repeat-x';break;case 'tiled by y':bg_rep='repeat-y';break;default:break;}

	var oldmbi=st_cumbi;var olditi=st_cuiti;st_cumbi=st_menus[st_cumei].bodys.length;st_cuiti=0;
	var menu=st_menus[st_cumei];

	menu.bodys[st_cumbi]=
	{
		items:		[],

		mei:		st_cumei,
		mbi:		st_cumbi,
		block:		"STM"+st_cumei+"_"+st_cumbi+"__",
		par:		(st_cumbi ? [st_cumei,oldmbi,olditi] : null),
		tmid:		null,
		curiti:		-1,
		isshow:		false,
		isitem:		0,
		isstatic:	!st_cumbi&&menu.type=='static',
		isvisible:	!st_cumbi&&menu.type!='custom',
		isclick:	!st_cumbi&&menu.click_sh,
		exec_ed:	false,

		arrange:	arrange,
		offset:		offset,
		offset_l:	eval(offset_l),
		offset_t:	eval(offset_t),
		arrow:		getsrc(arrow,menu),
		arrow_w:	eval(arrow_w),
		arrow_h:	eval(arrow_h),
		spacing:	eval(spacing),
		padding:	eval(padding),
		bg_cl:		bg_cl,
		bg_image:	getsrc(bg_image,menu),
		bg_rep:		bg_rep,
		bd_st:		bd_st,
		bd_sz:		eval(bd_sz),
		bd_cl:		bd_cl,
		opacity:	100-eval(trans),
		spec:		spec,
		spec_sp:	eval(spec_sp),
		fl_type:	-1,
		lw_max:		eval(lw_max),
		lh_max:		eval(lh_max),
		rw_max:		eval(rw_max),
		rh_max:		eval(rh_max),
		ds_st:		ds_st,
		ds_sz:		ds_st!='none' ? eval(ds_sz) : 0,
		ds_color:	ds_color,
		hdsp:		eval(hdsp),

		spec_init:	0,
		spec_sh:	0,
		spec_hd:	0
	};
	var body=menu.bodys[st_cumbi];
	if(st_cumbi)	getpar(body).sub=[st_cumei,st_cumbi];
	body.z_index=	!st_cumbi ? 1000 : getpar(getpar(body)).z_index+10;
	if(body.offset=="auto")
	{
		if(st_cumbi)
			body.offset=getpar(getpar(body)).arrange=="vertically" ? "right" : "down";
		else
			body.offset= "down";
	}
	if(body.bd_st=="none")
		body.bd_sz=0;
	if(nSTMENU&&!nNN4&&bd_cl_t!="")
		body.bd_cl=(bd_cl_t+" "+bd_cl_r+" "+bd_cl_b+" "+bd_cl);
	bufimg(body.bg_image);
	body.background=getbg(body.bg_cl,body.bg_image,body.bg_rep);
	if(body.mbi&&!getpar(getpar(body)).bufed)
	{
		bufimg(getpar(getpar(body)).arrow);
		getpar(getpar(body)).bufed=true;
	}
	if(nIEW&&nVer<5.0&&nVer>=4.0&&body.isstatic)
		body.speceff='normal';
	else if(nIEW&&typeof(st_fl[spec])!='undefined'&&(nVer>=5.5||(nVer<5.5&&st_fl[spec]<=23)))
		body.speceff='filter';
	else if(nIEW&&spec=="Fade")
		body.speceff='fade';
	else
		body.speceff='normal';
	eval(body.speceff+'_init(body);');
}

function appendSTMI(isimage,text,align,valign,image_ou,image_ov,image_w,image_h,image_b,type,bgc_ou,bgc_ov,sep_img,sep_size,sep_w,sep_h,icon_ou,icon_ov,icon_w,icon_h,icon_b,tip,url,target,f_fm_ou,f_sz_ou,f_cl_ou,f_wg_ou,f_st_ou,f_de_ou,f_fm_ov,f_sz_ov,f_cl_ov,f_wg_ov,f_st_ov,f_de_ov,bd_sz,bd_st,bd_cl_r_ou,bd_cl_l_ou,bd_cl_r_ov,bd_cl_l_ov,bd_cl_t_ou,bd_cl_b_ou,bd_cl_t_ov,bd_cl_b_ov,st_text,bg_img_ou,bg_img_ov,bg_rep_ou,bg_rep_ov)
{
	if(!bd_cl_t_ou)	bd_cl_t_ou='';
	if(!bd_cl_b_ou)	bd_cl_b_ou='';
	if(!bd_cl_t_ov)	bd_cl_t_ov='';
	if(!bd_cl_b_ov)	bd_cl_b_ov='';
	if(!st_text)		st_text='';
	if(!bg_img_ou)		bg_img_ou='';
	if(!bg_img_ov)		bg_img_ov='';
	if(!bg_rep_ou)		bg_rep_ou='repeat';
	if(!bg_rep_ov)		bg_rep_ov='repeat';
	switch(bg_rep_ou){case 'tile':case 'tiled':bg_rep_ou='repeat';break;case 'free':bg_rep_ou='no-repeat';break;case 'tiled by x':bg_rep_ou='repeat-x';break;case 'tiled by y':bg_rep_ou='repeat-y';break;default:break;}
	switch(bg_rep_ov){case 'tile':case 'tiled':bg_rep_ov='repeat';break;case 'free':bg_rep_ov='no-repeat';break;case 'tiled by x':bg_rep_ov='repeat-x';break;case 'tiled by y':bg_rep_ov='repeat-y';break;default:break;}

	st_cuiti=st_menus[st_cumei].bodys[st_cumbi].items.length;
	var menu=st_menus[st_cumei];
	var body=menu.bodys[st_cumbi];
	body.items[st_cuiti]=
	{
		mei:		st_cumei,
		mbi:		st_cumbi,
		iti:		st_cuiti,
		block:		"STM"+st_cumei+"_"+st_cumbi+"__"+st_cuiti+"___",
		sub:		null,
		isitem:		1,
		txblock:	"STM"+st_cumei+"_"+st_cumbi+"__"+st_cuiti+"___"+"TX",
		tmid:		null,

		isimage:	eval(isimage),
		text:		text,
		align:		align,
		valign:		valign,
		image:		[getsrc(image_ou,menu),getsrc(image_ov,menu)],

		image_w:	eval(image_w),
		image_h:	eval(image_h),
		image_b:	eval(image_b),
		type:		type,
		bg_cl:		[bgc_ou,bgc_ov],
		sep_img:	getsrc(sep_img,menu),
		sep_size:	eval(sep_size),
		sep_w:		eval(sep_w),
		sep_h:		eval(sep_h),
		icon:		[getsrc(icon_ou,menu),getsrc(icon_ov,menu)],
		icon_w:		eval(icon_w),
		icon_h:		eval(icon_h),
		icon_b:		eval(icon_b),
		tip:		tip,
		url:		url,
		target:		target,
		f_fm:		[f_fm_ou.replace(/'/g,''),f_fm_ov.replace(/'/g,'')],
		f_sz:		[f_sz_ou,f_sz_ov],
		f_cl:		[f_cl_ou,f_cl_ov],
		f_wg:		[f_wg_ou,f_wg_ov],
		f_st:		[f_st_ou,f_st_ov],
		f_de:		[f_de_ou,f_de_ov],
	
		bd_st:		bd_st,
		bd_sz:		eval(bd_sz),
		bd_cl_r:	[bd_cl_r_ou,bd_cl_r_ov],
		bd_cl_l:	[bd_cl_l_ou,bd_cl_l_ov],
		bd_cl_t:	[bd_cl_t_ou,bd_cl_t_ov],
		bd_cl_b:	[bd_cl_b_ou,bd_cl_b_ov],

		st_text:	st_text,
		bg_img:		[getsrc(bg_img_ou,menu),getsrc(bg_img_ov,menu)],
		bg_rep:		[bg_rep_ou,bg_rep_ov]
	};

	var item=st_menus[st_cumei].bodys[st_cumbi].items[st_cuiti];
	if(item.bd_st=="none"||!item.bd_sz)
	{
		item.bd_sz=0;	item.bd_st="none";
	}
	if(nOP)
	{
		if(item.bd_st=="ridge")		item.bd_st="outset";
		if(item.bd_st=="groove")	item.bd_st="inset";
	}
	if(item.bd_st=="inset")
	{
		var tmclr=item.bd_cl_l;	item.bd_cl_l=item.bd_cl_r;	item.bd_cl_r=tmclr;	item.bd_st="outset";
	}
	if(bd_cl_t_ou=="")
	{
		if("none_solid_double_dashed_dotted".indexOf(item.bd_st)>=0)
			item.bd_cl_r=item.bd_cl_l;
		if(item.bd_st=="outset")
			item.bd_st="solid";
		item.bd_cl_t=item.bd_cl_l;
		item.bd_cl_b=item.bd_cl_r;
	}
	item.bd_cl=[];
	for(i=0;i<2;i++)
		item.bd_cl[i]=item.bd_cl_t[i]+" "+item.bd_cl_r[i]+" "+item.bd_cl_b[i]+" "+item.bd_cl_l[i];
	if(item.type=="sepline")
		bufimg(item.sep_img);
	else
	{
		for(i=0;i<2;i++)
		{
			bufimg(item.icon[i]);
			if(item.isimage)
				bufimg(item.image[i]);
			bufimg(item.bg_img[i]);
		}
	}
	item.background=[getbg(item.bg_cl[0],item.type=='sepline' ? '' : item.bg_img[0],item.bg_rep[0]),getbg(item.bg_cl[1],item.bg_img[1],item.bg_rep[1])];
}

function endSTMB()
{
	var item=getpar(st_menus[st_cumei].bodys[st_cumbi]);
	if(item)
	{
		st_cumei=item.mei;
		st_cumbi=item.mbi;
		st_cuiti=item.iti;
	}
}

function endSTM()
{
	var menu=st_menus[st_cumei];
	var menuHTML="";
	var max_l=nSTMENU ? menu.bodys.length : 1;
	for(mbi=0;mbi<max_l;mbi++)
	{
		var body=menu.bodys[mbi];
		var bodyHTML=getBodyTextH(body);
		for(iti=0;iti<body.items.length;iti++)
		{
			var item=body.items[iti];
			var itemHTML="";
			itemHTML+=(body.arrange=="vertically" ? (nNN4||!nSTMENU ? "<TR HEIGHT=100%>" : "<TR ID="+item.block+"TR>") : "");
			itemHTML+=getItemText(item);
			itemHTML+=(body.arrange=="vertically" ? "</TR>" : "");
			bodyHTML+=itemHTML;
		}
		bodyHTML+=getBodyTextE(body);
		if(body.isstatic||nNN4||!nSTMENU)
			menuHTML+=bodyHTML;
		else
			st_ht+=bodyHTML;
	}
	if(menuHTML!='')
		document.write(menuHTML);
	if(nSTMENU&&!(nIEM||(nIEW&&nVer<5.0)))
	{
		if(st_ht!='')
		{
			var obj=getob('st_global'+st_gcount,'font');
			if(nNN6)
				obj.innerHTML=st_ht;
			else if(nIE&&nVer>=5.0)
				obj.insertAdjacentHTML("BeforeEnd",st_ht);
			else
				obj.document.write(st_ht);
			st_gcount++;
			st_ht='';
		}
		if(!nOP&&!nNN4)
			prefix(menu);
	}
	st_cumei++;st_cumbi=0;st_cuiti=0;
}

function getBodyTextH(body)
{
	var s="";
	if(nNN4||!nSTMENU)
	{
		if(nNN4)
		{
			s+=!body.isstatic ? "<LAYER" : "<ILAYER";
			if(body.mbi==0&&getme(body).pos=='absolute')
				s+=(" LEFT="+getme(body).pos_l+" TOP="+getme(body).pos_t);
			s+=" VISIBILITY=hide";
			s+=" ID="+body.block;
			s+=" Z-INDEX="+body.z_index;
			s+="><LAYER ID="+body.block+"IN>";
		}
		s+="<TABLE BORDER=0 CELLPADDING="+body.bd_sz+" CELLSPACING=0";
		if(body.bd_sz)
			s+=" BGCOLOR="+body.bd_cl;
		s+="><TD>";
		s+="<TABLE BORDER=0 CELLSPACING=0 CELLPADDING="+body.spacing;
		if(body.bg_image!="")
			s+=" BACKGROUND=\""+body.bg_image+"\"";
		if(body.bg_cl!="transparent")
			s+=" BGCOLOR="+body.bg_cl;
		s+=" ID="+body.block;
		s+=">";
	}
	else
	{
		var stdiv="position:"+(body.mbi ? 'absolute' : getme(body).pos)+";";
		if(body.mbi==0)
		{
			stdiv+=("float:"+getme(body).flt+";");
			stdiv+=("left:"+getme(body).pos_l+"px;");
			stdiv+=("top:"+getme(body).pos_t+"px;");
		}
		
		stdiv+="z-index:"+body.z_index+";";
		stdiv+="visibility:hidden;";

		s+=nTopTb ? "<TABLE class=st_tbcss CELLPADDING=0 CELLSPACING=0" : "<DIV class=st_divcss";
		s+=getBodyEventString(body);
		s+=" ID="+body.block;
		s+=" STYLE='";
		if(nIEM)
			s+="width:1px;";
		else if(nIE)
			s+="width:0px;";
		s+=getFilterCSS(body);
		s+=stdiv;
		s+="'>";
		if(nTopTb)
			s+="<TD class=st_tdcss ID="+body.block+"TTD>";
		s+="<TABLE class=st_tbcss CELLSPACING=0 CELLPADDING=0";
		s+=" ID="+body.block+"TB";
		s+=" STYLE='";
		s+=getBodyCSS(body);
		if(!nOP)
			s+="margin:"+body.ds_sz+"px;";
		s+="'>";
	}
	return s;
}

function getBodyTextE(body)
{
	if(!nSTMENU)
		return "</TABLE></TD></TABLE>";
	else if(nNN4)
		return "</TABLE></TD></TABLE></LAYER></LAYER>";
	else if(nTopTb)
		return "</TABLE></TD></TABLE>";
	else
		return "</TABLE></DIV>";
}

function getItemText(item)
{
	var s="";
	if(nNN4||!nSTMENU)
	{
		var max_i=nNN4 ? 2 : 1;
		s+="<TD WIDTH=1 NOWRAP><FONT STYLE='font-size:1pt;'>";
		if(nNN4)
			s+="<ILAYER ID="+item.block+"><LAYER ID="+item.block+"IN>";
		for(i=0;i<max_i;i++)
		{
			if(item.type=="sepline"&&i)
				break;
			if(nNN4)
				s+="<LAYER ID="+item.block+st_state[i]+" Z-INDEX=10 VISIBILITY="+(i ? "HIDE" : "SHOW")+">";
			s+="<TABLE WIDTH=100% BORDER=0 CELLSPACING=0 CELLPADDING="+(item.type=="sepline" ? 0 : item.bd_sz);
			if(!nNN4)
				s+=" HEIGHT=100%";
			if(item.bd_sz)
				s+=" BGCOLOR="+item.bd_cl_l[i];
			s+="><TD WIDTH=100%>";
			s+="<TABLE WIDTH=100% BORDER=0 CELLSPACING=0 CELLPADDING="+(item.type=="sepline" ? 0 : getpar(item).padding);
			if(item.bg_img[i]!="")
				s+=" BACKGROUND=\""+item.bg_img[i]+"\"";
			if(!nNN4)
				s+=" HEIGHT=100%";
			if(item.bg_cl[i]!="transparent")
				s+=" BGCOLOR="+item.bg_cl[i];
			s+=" TITLE="+addquo(item.type!="sepline" ? item.tip : "");
			s+=">";

			if(item.type=="sepline")
			{
				s+="<TD NOWRAP VALIGN=TOP"+
					" HEIGHT="+(getpar(item).arrange=="vertically" ? item.sep_size : "100%")+
					" WIDTH="+(getpar(item).arrange=="vertically" ? "100%" : item.sep_size)+
					" STYLE='font-size:0pt;'"+
					">";
				s+=createIMG(item.sep_img,item.block+"LINE",item.sep_w,item.sep_h,0);
				s+="</TD>";
			}
			else
			{
				if(getpar(item).lw_max&&(getpar(item).arrange=="vertically"||item.icon_w))
				{
					s+="<TD ALIGN=CENTER VALIGN=MIDDLE";
					s+=getwdstr(item);
					s+=">";
					s+=createIMG(item.icon[i],item.block+"ICON",item.icon_w,item.icon_h,item.icon_b);
					s+="</TD>";
				}

				s+="<TD WIDTH=100% NOWRAP ALIGN="+item.align+" VALIGN="+item.valign+">";
				if(nNN4)
					s+="<FONT FACE='"+item.f_fm[i]+"' STYLE=\"";
				else
				{
					s+="<A HREF="+addquo(item.url=="" ? "javascript:;" : item.url); 
					s+=" TARGET="+item.target;
					s+=" STYLE=\"font-family:"+item.f_fm[0]+";";
				}
				s+="font-size:"+item.f_sz[i]+";";
				s+="color:"+item.f_cl[i]+";";
				s+="font-weight:"+item.f_wg[i]+";";
				s+="font-style:"+item.f_st[i]+";";
				s+="text-decoration:"+item.f_de[i]+";";
				s+="\">";
				if(item.isimage)
					s+=createIMG(item.image[i],item.block+"IMG",item.image_w,item.image_h,item.image_b);
				else
				{
					s+="<IMG SRC=\""+getme(item).blank.src+"\" WIDTH=1 HEIGHT=1 BORDER=0 ALIGN=ABSMIDDLE>";
					s+=item.text;
				}
				s+=(nNN4 ? "</FONT>" : "</A>");
				s+="</TD>";

				if(getpar(item).arrow_w)
				{
					s+="<TD NOWRAP ALIGN=CENTER VALIGN=MIDDLE>";
					s+=createIMG((getsub(item) ? getpar(item).arrow : getme(item).blank.src),item.block+"ARROW",getpar(item).arrow_w,getpar(item).arrow_h,0);
					s+="</TD>";
				}
			}

			s+="</TABLE>";
			s+="</TD></TABLE>";
			s+="</LAYER>";
		}
		if(nNN4&&item.type!="sepline")
		{
			s+="<LAYER ID="+item.block+"M";
			s+=" Z-INDEX=20";
			s+=">";
			s+="</LAYER>";
		}

		s+="</LAYER></ILAYER></FONT>";
		s+="</TD>";
	}
	else
	{
		s+="<TD class=st_tdcss NOWRAP VALIGN="+(nIE ? "MIDDLE" : "TOP");
		s+=" STYLE='"
			s+="padding:"+getpar(item).spacing+"px;";
		s+="'";
		s+=" ID="+getpar(item).block+item.iti;
		if(nIEW)
			s+=" HEIGHT=100%";
		s+=">";
		if(!nOP&&!nIE)
		{
			s+="<DIV class=st_divcss ID="+item.block;
			s+=getItemEventString(item);
			s+=" STYLE=\""+getItemCSS(item);
			s+="\"";
			s+=">";
		}
		s+="<TABLE class=st_tbcss CELLSPACING=0 CELLPADDING=0";
		if(!nOP)
			s+=" HEIGHT=100%";
		if(nIE)
			s+=" VALIGN=MIDDLE";

		s+=" STYLE=\"";
		if(nOP||nIE)
			s+=getItemCSS(item);
		s+="\"";
		if(nOP||nIE)
			s+=getItemEventString(item);
		if(getpar(item).arrange=="vertically"||nIEM)
			s+=" WIDTH=100%";
		s+=" ID="+(nOP||nIE ? item.block : (item.block+"TB"));
		s+=" TITLE="+addquo(item.type!="sepline" ? item.tip : "");
		s+=">";

		if(item.type=="sepline")
		{
			s+="<TD class=st_tdcss  NOWRAP VALIGN=TOP"+
				" ID="+item.block+"MTD"+
				" HEIGHT="+(getpar(item).arrange=="vertically" ? item.sep_size : "100%")+
				" WIDTH="+(getpar(item).arrange=="vertically" ? "100%" : item.sep_size)+
				">";
			s+=createIMG(item.sep_img,item.block+"LINE",item.sep_w,item.sep_h,0);
			s+="</TD>";
		}
		else
		{
			if(getpar(item).lw_max&&(getpar(item).arrange=="vertically"||item.icon_w))
			{
				s+="<TD class=st_tdcss NOWRAP ALIGN=CENTER VALIGN=MIDDLE HEIGHT=100%";
				s+=" STYLE=\"padding:"+getpar(item).padding+"px\"";
				s+=" ID="+item.block+"LTD";
				s+=getwdstr(item);
				s+=">";
				s+=createIMG(item.icon[0],item.block+"ICON",item.icon_w,item.icon_h,item.icon_b);
				s+="</TD>";
			}
			else if(getpar(item).arrange=="vertically")
			{
				s+="<TD class=st_tdcss";
				s+=" STYLE=\"padding:"+getpar(item).padding+"px\"";
				s+=" ID="+item.block+"LLTD WIDTH=3><IMG SRC=\""+getme(item).blank.src+"\" WIDTH=1 ID="+item.block+"LLTDI></TD>";
			}

			s+="<TD class=st_tdcss NOWRAP HEIGHT=100% STYLE=\"color:"+item.f_cl[0]+";";
			s+="padding:"+getpar(item).padding+"px;";
			s+="\"";
			s+=" ID="+item.block+"MTD";
			s+=" ALIGN="+item.align;
			s+=" VALIGN="+item.valign+">";
			s+="<FONT class=st_ftcss ID="+item.txblock+" STYLE=\""+getTextCSS(item)+"\">";
			if(item.isimage)
				s+=createIMG(item.image[0],item.block+"IMG",item.image_w,item.image_h,item.image_b);
			else
				s+=item.text;
			s+="</FONT>";
			s+="</TD>";

			if(getpar(item).arrow_w)
			{
				s+="<TD class=st_tdcss NOWRAP";
				s+=" STYLE=\"padding:"+getpar(item).padding+"px\"";
				s+=" ID="+item.block+"RTD";
				s+=" WIDTH="+(getpar(item).arrow_w+2);
				s+=" ALIGN=CENTER VALIGN=MIDDLE HEIGHT=100%>";
				s+=createIMG((getsub(item) ? getpar(item).arrow : getme(item).blank.src),item.block+"ARROW",getpar(item).arrow_w,getpar(item).arrow_h,0);
				s+="</TD>";
			}
			else if(getpar(item).arrange=="vertically")
			{
				s+="<TD class=st_tdcss";
				s+=" STYLE=\"padding:"+getpar(item).padding+"px\"";
				s+=" ID="+item.block+"RRTD WIDTH=3><IMG SRC=\""+getme(item).blank.src+"\" WIDTH=1 ID="+item.block+"RRTDI></TD>";
			}
		}
		
		s+="</TABLE>";
		if(!nOP&&!nIE)
			s+="</DIV>";
		s+="</TD>";
	}
	return s;
}

function getBodyCSS(body)
{
	var s="";
	s+="border-style:"+body.bd_st+";";
	s+="border-width:"+body.bd_sz+"px;";
	s+="border-color:"+body.bd_cl+";";
	if(nIE)
		s+="background:"+body.background+";";
	else
	{
		s+="background-color:"+(body.bg_cl)+";";
		if(body.bg_image!="")
		{
			s+="background-image:url("+body.bg_image+");";
			s+="background-repeat:"+body.bg_rep+";";
		}
	}
	return s;
}

function getFilterCSS(body)
{
	var s="";
	var dxpre="progid:DXImageTransform.Microsoft.";
	if(nIEW&&(nVer>=5.0||!body.isstatic))
	{
		s+="filter:";
		if(typeof(body.spec_string)!='undefined')
			s+=body.spec_string;

		s+=" ";
		if(nVer>=5.5)
			s+=dxpre;
		s+="Alpha(opacity="+body.opacity+")";

		if(body.ds_sz!=0)
		{
			s+=" ";
			if(nVer>=5.5)
				s+=dxpre;
			if(body.ds_st=="simple")
				s+="dropshadow(color="+body.ds_color+",offx="+body.ds_sz+",offy="+body.ds_sz+",positive=1) ";
			else
				s+="Shadow(color="+body.ds_color+",direction=135,strength="+body.ds_sz+") ";
		}
		s+=";";
	}
	return s;
}

function getItemCSS(item)
{
	var s="";
	if(item.type!="sepline")
	{
		s+="border-style:"+item.bd_st+";";
		s+="border-width:"+item.bd_sz+"px;";
		s+="border-color:"+item.bd_cl[0]+";";
		
		if(!nIE&&item.bg_img[0]!="")
		{
			s+="background-image:url("+item.bg_img[0]+");";
			s+="background-repeat:"+item.bg_rep[0]+";";
		}
	}
	if(nIE)
		s+="background:"+item.background[0]+";";
	else
		s+="background-color:"+item.bg_cl[0]+";";
	s+="cursor:"+getcursor(item)+";";
	return s;
}

function getTextCSS(item)
{
	var s="";
	s+="cursor:"+getcursor(item)+";";
	s+="font-family:"+item.f_fm[0]+";";
	s+="font-size:"+item.f_sz[0]+";";
	s+="font-weight:"+item.f_wg[0]+";";
	s+="font-style:"+item.f_st[0]+";";
	s+="text-decoration:"+item.f_de[0]+";";
	return s;
}

function doitov(e,obj,it)
{
	if(nIEW)
	{
		if(!it.layer)
			it.layer=obj;
		if(!getpar(it).isshow||(e.fromElement&&obj.contains(e.fromElement)))
			return;
	}
	else
	{
		if(!getpar(it).isshow||(!nNN&&(e.fromElement&&e.fromElement.id&&e.fromElement.id.indexOf(it.block)>=0)))
			return ;
	}
	if(nNN4)
		getlayer(it).document.layers[0].captureEvents(Event.CLICK);
		
	if(getme(it).hdid)
	{
		clearTimeout(getme(it).hdid);
		getme(it).hdid=null;
	}

	var curiti=getpar(it).curiti;
	var curit=null;
	if(curiti>=0)
		curit=getpar(it).items[curiti];

	if(!getpar(it).isclick||getme(it).clicked)
	{
		if(getpar(it).curiti!=it.iti)
		{
			if(getpar(it).curiti>=0)
			{
				hditpop(getpar(it).items[getpar(it).curiti]);
				getpar(it).curiti=-1;
			}
			shitpop(it);
			getpar(it).curiti=it.iti;
		}
		else
		{
			if(getsub(it)&&!getsub(it).isshow)
			{
				shitst(it,1);
				showpop(getsub(it));
			}
		}
	}
	if(it.st_text!="")
		window.status=it.st_text;
}

function doitou(e,obj,it)
{
	if(nIEW)
	{
		if(!getpar(it).isshow||e.toElement&&obj.contains(e.toElement))
			return;
	}
	else
	{
		if(!getpar(it).isshow||(!nNN&&(e.toElement&&e.toElement.id&&e.toElement.id.indexOf(it.block)>=0)))
			return ;
	}
	if(nNN4)
		getlayer(it).document.layers[0].releaseEvents(Event.CLICK);
	
	if(!getsub(it)||!getsub(it).isshow)
	{
		shitst(it,0);
		getpar(it).curiti=-1;
	}
	else if(getsub(it)&&getsub(it).isshow&&!getsub(it).exec_ed)
		hditpop(it);
	window.status="";
}

function doitck(e,obj,it)
{
	if(e.button&&e.button>=2)
		return;
	if(getpar(it).isclick)
	{
		getme(it).clicked=!getme(it).clicked;
		if(getme(it).clicked)
		{
			shitpop(it);
			getpar(it).curiti=it.iti;
		}
		else
		{
			hditpop(it);
			getpar(it).curiti=-1;
		}
	}
	if(!(getpar(it).isclick&&getsub(it)))
	{
		if(it.url!="")
		{
			var _preurl="javascript:";
			if(it.url.toLowerCase().indexOf(_preurl)==0)
				eval(it.url.substring(_preurl.length,it.url.length));
			else if(nNN6&&it.target=="_self")
				window.location.href=it.url;
			else
				window.open(it.url,it.target);
		}
	}
}

function getrect(mbit)
{
	if(nNN4)
	{
		var obj=getlayer(mbit);
		return [obj.pageX,obj.pageY,obj.clip.width,obj.clip.height];
	}
	else
	{
		var l=0,t=0;
		var obj=getlayer(mbit);
		var w=parseInt(nOP ? obj.style.pixelWidth : obj.offsetWidth);
		var h=parseInt(nOP ? obj.style.pixelHeight : obj.offsetHeight);
		if(!nOP&&!nIEM&&typeof(mbit.iti)=='undefined')
			h-=mbit.ds_sz*2;
		while(obj)
		{
			l+=parseInt(obj.offsetLeft);
			t+=parseInt(obj.offsetTop);
			obj=obj.offsetParent;
		}
		if(nIEM)
		{
			l+=parseInt(document.body.leftMargin);
			l-=mbit.bd_sz;
			t-=mbit.bd_sz;
		}
		if(typeof(mbit.iti)!='undefined')
		{
			if(bDelBorder)
			{
				l-=mbit.bd_sz;
				t-=mbit.bd_sz;
			}
			if(bAddBorder)
			{
				l+=getpar(mbit).bd_sz;
				t+=getpar(mbit).bd_sz;
			}
		}
		return [l,t,w,h];
	}
}

function getxy(body)
{
	var x=body.offset_l;
	var y=body.offset_t;
	var subrc=getrect(body);
	body.rc=subrc;
	if(body.mbi==0)
	{
		if(getme(body).type=="custom")
			return [getme(body).pos_l,getme(body).pos_t];
		else if(getme(body).type=="float")
			return [getcl()+getme(body).pos_l,getct()+getme(body).pos_t];
		else
			return [subrc[0],subrc[1]];
	}
	var itrc=getrect(getpar(body));
	var bdrc=getrect(getpar(getpar(body)));
	switch(body.offset)
	{
		case "left":
			x+=itrc[0]-subrc[2];
			y+=itrc[1];
			break;
		case "up":
			x+=itrc[0];
			y+=itrc[1]-subrc[3];
			if(nIEM)
				y+=body.ds_sz;
			break;
		case "right":
			x+=itrc[0]+itrc[2];
			y+=itrc[1];
			break;
		case "down":
			x+=itrc[0];
			y+=itrc[1]+itrc[3];
			break;
		case "auto":
		default:
			break;
	}
	if(!nOP&&!nNN4)
	{
		x-=body.ds_sz;
		y-=body.ds_sz;
	}
	return adjust([x,y],body);
}

function adjust(xy,body)
{
	var rc=getrect(body);
	var tx=xy[0];
	var ty=xy[1];
	var c_l=getcl();
	var c_t=getct();
	var c_r=c_l+getcw();
	var c_b=c_t+getch();
	if(tx+rc[2]>c_r)
		tx=c_r-rc[2];
	tx=tx>c_l ? tx : c_l;
	if(ty+rc[3]>c_b)
		ty=c_b-rc[3];
	ty=ty>c_t ? ty : c_t;
	return [tx,ty];
}

function ckPage()
{
	var st_or_w=st_cl_w;
	var st_or_h=st_cl_h;
	var st_or_l=st_cl_l;
	var st_or_t=st_cl_t;
	st_cl_w=getcw();
	st_cl_h=getch();
	st_cl_l=getcl();
	st_cl_t=getct();
	if((nOP||nNN4)&&(st_cl_w-st_or_w||st_cl_h-st_or_h))
		document.location.reload();
	else if(st_cl_l-st_or_l||st_cl_t-st_or_t)
		setTimeout("scrollmenu();",500);
}

function shitst(it,nst)
{
	if(nNN4)
	{
		var st_lay=get_st_lay(it);
		st_lay[nst].visibility="show";
		st_lay[1-nst].visibility="hide";
	}
	else
	{
		var objs=getlayer(it).style;
		
		if(nIE&&nMac)
		{
			if(it.background[0]!=it.background[1])	objs.background=it.background[nst];
		}
		else
		{
			if(nOP)
				objs.background=it.bg_cl[nst];
			else
			{
				if(it.bg_cl[0]!=it.bg_cl[1])	objs.backgroundColor=it.bg_cl[nst];
			}
			if(it.bg_img[nst]!="")
			{
				if(it.bg_img[0]!=it.bg_img[1])	objs.backgroundImage="url("+it.bg_img[nst]+")";
				if(it.bg_rep[0]!=it.bg_rep[1])	objs.backgroundRepeat=it.bg_rep[nst];
			}
		}

		if(it.bd_cl[0]!=it.bd_cl[1])	objs.borderColor=it.bd_cl[nst];

		var tmp;
		if(it.icon[0]!=it.icon[1])
		{
			tmp=getob(it.block+'ICON','IMG');
			if(tmp)	tmp.src=it.icon[nst];
		}
		if(it.isimage&&it.image[0]!=it.image[1])
		{
			tmp=getob(it.block+'IMG','IMG');
			if(tmp)	tmp.src=it.image[nst];
		}

		if (!it.txstyle)	it.txstyle=getob(it.txblock,'font').style;
		tmp=it.txstyle;
		if(it.f_fm[0]!=it.f_fm[1])	tmp.fontFamily=it.f_fm[nst];
		if(it.f_sz[0]!=it.f_sz[1])	tmp.fontSize=it.f_sz[nst];
		if(it.f_wg[0]!=it.f_wg[1])	tmp.fontWeight=it.f_wg[nst];
		if(it.f_st[0]!=it.f_st[1])	tmp.fontStyle=it.f_st[nst];
		if(it.f_de[0]!=it.f_de[1])	tmp.textDecoration=it.f_de[nst];
		if(it.f_cl[0]!=it.f_cl[1])
		{
			if(nOP)	getob(it.block+'MTD','td').style.color=it.f_cl[nst];
			else	tmp.color=it.f_cl[nst];
		}
	}
}

function dombov(e,obj,mb)
{
	if(nIEW)
	{
		if(!mb.layer)
			mb.layer=obj;
		if(!mb.isshow||(e.fromElement&&obj.contains(e.fromElement)))
			return;
	}
	else
	{
		if(!mb.isshow||(!nNN&&(e.fromElement&&e.fromElement.id&&e.fromElement.id.indexOf(mb.block)>=0)))
			return ;
	}

	if(getme(mb).hdid)
	{
		clearTimeout(getme(mb).hdid);
		getme(mb).hdid=null;
	}
}

function dombou(e,obj,mb)
{
	if(nIEW)
	{
		if(!mb.isshow||(e.toElement&&obj.contains(e.toElement)))
			return;
	}
	else
	{
		if(!mb.isshow||(!nNN&&(e.toElement&&e.toElement.id&&e.toElement.id.indexOf(mb.block)>=0)))
			return ;
	}

	if(getme(mb).hdid)
	{
		clearTimeout(getme(mb).hdid);
		getme(mb).hdid=null;
	}
	getme(mb).hdid=setTimeout("hideall(st_menus['"+mb.mei+"']);",getme(mb).hddelay);
}

function showpop(body)
{
	show(body);
}

function hidepop(body)
{
	if(body.curiti>=0)
	{
		var tmp=getsub(body.items[body.curiti]);
		if(tmp&&tmp.isshow)
			hidepop(tmp);
		shitst(body.items[body.curiti],0);
		body.curiti=-1;
	}
	hide(body);
}

function shitpop(item)
{
	if(getsub(item))
	{
		if(!getsub(item).isshow)
			showpop(getsub(item));
	}
	shitst(item,1);
}

function hditpop(item)
{
	if(getsub(item)&&getsub(item).isshow)
		hidepop(getsub(item));
	shitst(item,0);
}

function hideall(menu)
{
	menu.clicked=false;
	var body=menu.bodys[0];
	if(body.isshow)
	{
		if(body.curiti>=0)
		{
			hditpop(body.items[body.curiti]);
			body.curiti=-1;
		}
		if(menu.type=="custom")
			hide(body);
	}
	menu.hdid=null;
}

function setupEvent(menu)
{
	for(mbi=0;mbi<menu.bodys.length;mbi++)
	{
		var body=menu.bodys[mbi];
		ly=getlayer(body).document.layers[0];
		ly.onmouseover=dombovNN4;
		ly.onmouseout=dombouNN4;
		for(iti=0;iti<body.items.length;iti++)
		{
			var item=body.items[iti];
			if(item.type!="sepline")
			{
				ly=getlayer(item).document.layers[0];
				ly.onmouseover=doitovNN4;
				ly.onmouseout=doitouNN4;
				ly.onclick=doitckNN4;
			}
		}
	}
}

function bufimg(sr)
{
	if(sr!="")
	{
		st_buf[st_buf.length]=new Image();
		st_buf[st_buf.length-1].src=sr;
		return st_buf[st_buf.length-1];
	}
	return null;
}

function normal_init(body)
{
}

function normal_sh(body)
{
	moveto(getxy(body),body);
	ck_win_els(-1,body);
	_sh(body);
}

function normal_hd(body)
{
	_hd(body);
	ck_win_els(+1,body);
}

function fade_init(body)
{
	body.current=0;
	body.step=parseInt(body.opacity*10/(110-body.spec_sp));
	if(body.step<=0)
		body.step=1;
}

function fade_sh(body)
{
	if(body.exec_ed)
	{
		body.current+=body.step;
		if(body.current>body.opacity)
			body.current=body.opacity;
	}
	getlayer(body).filters["Alpha"].opacity=body.current;
	if(!body.exec_ed)
	{
		moveto(getxy(body),body);
		ck_win_els(-1,body);
		_sh(body);
	}
	if(body.current!=body.opacity)
		body.tmid=setTimeout(get_sdstr(body,true),100);
}

function fade_hd(body)
{
	if(body.exec_ed)
	{
		body.current-=body.step;
		if(body.current<0||!body.hdsp)
			body.current=0;
	}
	getlayer(body).filters["Alpha"].opacity=body.current;
	if(!body.current)
	{
		_hd(body);
		ck_win_els(+1,body);
	}
	else
		body.tmid=setTimeout(get_sdstr(body,false),100);
}

function filter_init(body)
{
	body.fl_type=st_fl[body.spec];
	if(body.fl_type==23)
		body.fl_type=parseInt(23*Math.random());
	body.spec_sp=(body.spec_sp>100 ? 100 : (body.spec_sp<=10 ? 10 : body.spec_sp));
	body.duration=10/body.spec_sp;
	if(nVer<5.5)
		body.spec_string=" revealTrans(Transition="+body.fl_type+",Duration="+body.duration+")";
	else
	{
		body.spec_string=" progid:DXImageTransform.Microsoft."+st_fl_string[body.fl_type];
		body.spec_string=body.spec_string.replace(')',',Duration='+body.duration+')');
	}
}

function filter_sh(body)
{
	if(nVer<5.5)
		ft_shx(body);
	else if(bFtReg)
		eval("try{ft_shx(body);} catch(_err){bFtReg=0;normal_sh(body);}");
	else
		normal_sh(body);
}

function filter_hd(body)
{
	if(nVer<5.5)
		ft_hdx(body);
	else if(bFtReg)
		eval("try{ft_hdx(body);}catch(_err){bFtReg=0;normal_hd(body);}");
	else
		normal_hd(body);
}

function ft_shx(body)
{
	var fl_obj=getlayer(body).filters[0];
	if(fl_obj.Status!=0)
		fl_obj.stop();
	moveto(getxy(body),body);
	ck_win_els(-1,body);
	fl_obj.apply();
	_sh(body);
	fl_obj.play();
}

function ft_hdx(body)
{
	var fl_obj=getlayer(body).filters[0];
	if(fl_obj.Status!=0)
		fl_obj.stop();
	if(body.hdsp)	fl_obj.apply();
	_hd(body);
	ck_win_els(+1,body);
	if(body.hdsp)	fl_obj.play();
}

function showFloatMenuAt(nam,x,y)
{
	if(nSTMENU)
	{
		var menu=getMenuByName(nam);
		if(menu&&menu.type=="custom"&&menu.bodys.length&&!menu.bodys[0].isshow)
		{
			movetoex(menu,[x,y]);
			show(menu.bodys[0]);
		}
	}
}

function getMenuByName(nam)
{
	return st_menus[eval("sdm_"+nam)];
}


function movetoex(menu,xy)
{
	menu.pos_l=xy[0];
	menu.pos_t=xy[1];
}

function getcursor(it)
{
	return !nNN6&&it.type!="sepline"&&((it.mbi==0&&getme(it).click_sh&&getsub(it))||it.url!="") ? "hand" : "default";
}

function getwdstr(obj)
{
	if(getpar(obj).arrange=="vertically")
	{
		if(getpar(obj).lw_max>0)
			return " WIDTH="+getpar(obj).lw_max;
		else
			return "";
	}
	else
	{
		if(obj.icon_w>0)
			return " WIDTH="+obj.icon_w;
		else
			return "";
	}
}

function detectNav()
{
	var naVer=navigator.appVersion;
	var naAgn=navigator.userAgent;
	nMac=naVer.indexOf("Mac")>=0;
	nOP=naAgn.indexOf("Opera")>=0;
	if(nOP)
	{
		nVer=parseFloat(naAgn.substring(naAgn.indexOf("Opera ")+6,naAgn.length));
		nOP5=nVer>=5.12&&!nMac&&naAgn.indexOf("MSIE 5.0")>=0;
	}
	else
	{
		nIE=document.all ? 1 : 0;
		if(nIE)
		{
			nIE4=(eval(naVer.substring(0,1)>=4));
			nVer=parseFloat(naAgn.substring(naAgn.indexOf("MSIE ")+5,naAgn.length));
			nIE5=nVer>=5.0&&nVer<5.5;
			nIEM=nIE4&&nMac;
			nIEW=nIE4&&!nMac;
		}
		else
		{
			nNN4=navigator.appName.toLowerCase()=="netscape"&&naVer.substring(0,1)=="4" ? 1 : 0;
			if(!nNN4)
			{
				nNN6=(document.getElementsByTagName("*") && naAgn.indexOf("Gecko")!=-1);
				if(nNN6)
				{
					nVer=parseInt(navigator.productSub);
					if(naAgn.indexOf("Netscape")>=0)
					{
						bDelBorder=nVer<20001108+1;
						bAddBorder=nVer>20020512-1;
					}
					else
					{
						bDelBorder=nVer<20010628+1;
						bAddBorder=nVer>20011221-1;
					}
				}
			}
			else
				nVer=parseFloat(naVer);
			nNN=nNN4||nNN6;
		}
	}
	nSTMENU=nOP5||nIE4||nNN;
}

function st_onload()
{
	if(nIEM||nOP5||nNN4||(nIEW&&nVer<5.0))
	{
		if(st_ht!='')
			document.body.insertAdjacentHTML('BeforeEnd',st_ht);
		for(i=0;i<st_menus.length;i++)
			prefix(st_menus[i]);
	}
	st_loaded=1;
	if(!nNN4)
	{
		for(i=0;i<st_menus.length;i++)
		{
			menu=st_menus[i];
			curit=null;
			for(body=menu.bodys[0];body&&body.isshow&&body.exec_ed;body=(curit&&getsub(curit) ? getsub(curit) : null))
			{
				ck_win_els(-1,body);
				curit=body.curiti>=0 ? body.items[body.curiti] : null;
			}
		}
	}
}

function getpar(mbit)
{
	if(mbit.isitem)
		return st_menus[mbit.mei].bodys[mbit.mbi];
	else
		return !mbit.par ? null : st_menus[mbit.par[0]].bodys[mbit.par[1]].items[mbit.par[2]];
}

function getsub(item)
{
	return !item.sub ? null : st_menus[item.sub[0]].bodys[item.sub[1]];
}

function getme(mbit)
{
	return st_menus[mbit.mei];
}

function getsrc(sr,me)
{
	if(sr=='')
		return '';
	var _sr=sr.toLowerCase();
	if(_sr.indexOf('http://')==0||(_sr.indexOf(':')==1&&_sr.charCodeAt(0)>96&&_sr.charCodeAt(0)<123)||_sr.indexOf('ftp://')==0||_sr.indexOf('/')==0||_sr.indexOf('gopher')==0)
		return sr;
	else
		return me.web_path+sr;
}

function getcl()
{
	return parseInt(nNN||nOP ? window.pageXOffset : document.body.scrollLeft);
}

function getct()
{
	return parseInt(nNN||nOP ? window.pageYOffset : document.body.scrollTop);
}

function getcw()
{
	return parseInt(nNN||nOP ? window.innerWidth : (nIEW&&document.compatMode=="CSS1Compat" ? document.documentElement.clientWidth : document.body.clientWidth));
}

function getch()
{
	return parseInt(nNN||nOP ? window.innerHeight : (nIEW&&document.compatMode=="CSS1Compat" ? document.documentElement.clientHeight : document.body.clientHeight));
}

function get_sdstr(mb,issh)
{
	return	"var _mb=st_menus['"+mb.mei+"'].bodys["+mb.mbi+"];_mb.tmid=null;"+mb.speceff+(issh? "_sh(" : "_hd(")+"_mb);_mb.exec_ed=true;"
}

function getly(id,doc)
{
	if(doc.layers[id])
		return doc.layers[id];
	for(i=doc.layers.length-1;i>=0;i--)
	{
		var ly=getly(id,doc.layers[i].document);
		if(ly)
			return ly;
	}
	return null;
}

function getlayer(mbit)
{
	if(!mbit.layer)
	{
		if(typeof(mbit.iti)=='undefined')
			mbit.layer=getob(mbit.block,nTopTb ? 'table' : 'div');
		else
			mbit.layer=nNN4 ? getlayer(getpar(mbit)).document.layers[0].document.layers[mbit.block] : getob(mbit.block,nIEW ? 'table' : null);
	}
	return mbit.layer;
}

function get_st_lay(item)
{
	var st_arr=[];
	var doc=getlayer(item).document.layers[0].document;
	for(var i=0;i<2;i++)
		st_arr[i]=doc.layers[item.block+st_state[i]];
	st_arr[2]=doc.layers[item.block+'M'];
	return st_arr;
}

function moveto(xy,body)
{
	if(xy&&(body.mbi||getme(body).pos=='absolute'))
	{
		var ly=getlayer(body);
		if(nNN4)
			ly.moveToAbsolute(xy[0],xy[1]);
		else if(nOP)
		{
			var lys=ly.style;
			lys.pixelLeft=xy[0];
			lys.pixelTop=xy[1];
		}
		else
		{
			var lys=ly.style;
			lys.left=xy[0]+'px';
			lys.top=xy[1]+'px';
		}
		body.rc=[xy[0],xy[1],body.rc[2],body.rc[3]];
	}
}

function createIMG(src,id,width,height,border)
{
	var s='<IMG SRC=';
	s+=addquo(src);
	if(id!='')
		s+=' ID='+id;
	if(width&&height)
	{
		if(width>0)
			s+=' WIDTH='+width;
		if(height>0)
			s+=' HEIGHT='+height;
	}
	s+=' BORDER='+border+'>';
	return s;
}

function show(body)
{
	var delay=body.mbi&&getpar(getpar(body)).arrange=="vertically" ? getme(body).shdelay_v : getme(body).shdelay_h;
	body.exec_ed=false;
	if(!body.rc)
		getxy(body);
	if(body.tmid)
	{
		clearTimeout(body.tmid);
		body.tmid=null;
		ck_win_els(1,body)
	}
	if(delay>0)
		body.tmid=setTimeout(get_sdstr(body,true),delay);
	body.isshow=true;
	if(delay<=0)
		eval(get_sdstr(body,true));
}

function _sh(body)
{
	var ly=getlayer(body);
	if(nNN4)
	{
		for(var i=body.items.length-1;i>=0;i--)
		{
			var it=body.items[i];
			if(it.type=="sepline")
				continue;
			var st_lay=get_st_lay(it);
			st_lay[2].resizeTo(st_lay[0].clip.width,st_lay[0].clip.height);
		}
		ly.visibility='show';
	}
	else
		ly.style.visibility='visible';
}

function hide(body)
{
	if(body.tmid)
	{
		clearTimeout(body.tmid);
		body.tmid=null;
	}
	if(body.isshow&&!body.exec_ed)
	{
		body.exec_ed=false;
		body.isshow=false;
	}
	else
	{
		body.exec_ed=false;
		body.isshow=false;
		eval(get_sdstr(body,false));
	}
}

function _hd(body)
{
	var ly=getlayer(body);
	if(nNN4)
		ly.visibility='hide';
	else
	{
		var lyf;
		if(nIE5&&!nMac)
		{
			lyf=ly.filters['Alpha'];
			lyf.opacity=0;
		}
		ly.style.visibility='hidden';
		if(nIE5&&!nMac)	lyf.opacity=body.opacity;
	}
}

function fixmenu(menu)
{
	for(mbi=0;mbi<menu.bodys.length;mbi++)
	{
		var body=menu.bodys[mbi];
		if(nOP&&nVer<6.0)
			getlayer(body).style.pixelWidth=parseInt(getob(body.block+"TB",'table').style.pixelWidth);
		if(nIEW&&nIE5)
			getlayer(body).style.width=getlayer(body).offsetWidth;
		else if(nIEM||!nIE)
		{
			if(body.arrange!="vertically")
			{
				var iti=0;
				var fixit=getob(body.block+iti);
				var h=parseInt(nOP ? fixit.style.pixelHeight : fixit.offsetHeight);
				if(h)
				{
					for(iti=0;iti<body.items.length;iti++)
					{
						var item=body.items[iti];
						var lys=getlayer(item).style;
						var tm_h=h-2*body.spacing;
						if(nOP)
							lys.pixelHeight=tm_h;
						else if(item.type=="sepline"||nIE)
							lys.height=tm_h+'px';
						else
							lys.height=tm_h-2*item.bd_sz+'px';
	
						if(nIEM)
						{
							var fh=h-2*body.spacing;
							lltd=getob(item.block+"LLTD");
							ltd=getob(item.block+"LTD");
							rtd=getob(item.block+"RTD");
							rrtd=getob(item.block+"RRTD");
							if(lltd)
								lltd.style.height=fh+'px';
							if(ltd)
								ltd.style.height=fh+'px';
							getob(item.block+"MTD").style.height=fh+'px';
							if(rtd)
								rtd.style.height=fh+'px';
							if(rrtd)
								rrtd.style.height=fh+'px';
						}
					}
				}
			}
			else if(nOP)
			{
				for(iti=0;iti<body.items.length;iti++)
				{
					var item=body.items[iti];
					if(item.type!="sepline")
					{
						var fixit=getob(body.block+iti);
						var it=getlayer(item);
						var h=parseInt(it.style.pixelHeight);
						var w=parseInt(fixit.style.pixelWidth);
						if(h)
							it.style.pixelHeight=h;
						if(w)	
							it.style.pixelWidth=w-2*body.spacing;
					}
				}
			}
		}
	}
}

function prefix(menu)
{
	var body=menu.bodys[menu.bodys.length-1];
	var item=body.items[body.items.length-1];
	while(1)
		if(getlayer(item)) break;
	if(nNN4)
		setupEvent(menu);
	else
		fixmenu(menu);
	if(menu.type!="custom")
		show(menu.bodys[0]);
	if(nIEM)
		window.onscroll=function()
		{
			if(st_scrollid)
				clearTimeout(st_scrollid);
			st_scrollid=setTimeout('scrollmenu();',500);
		}
	else if(!st_rl_id)
	{
		st_cl_w=getcw();
		st_cl_h=getch();
		st_cl_l=getcl();
		st_cl_t=getct();
		st_rl_id=setInterval("ckPage();",500);
	}
}

function scrollmenu()
{
	for(i=0;i<st_menus.length;i++)
	{
		var menu=st_menus[i];
		if(menu&&menu.type=="float")
		{
			hideall(menu);
			var _b=menu.bodys[0];
			ck_win_els(+1,_b);
			moveto([getcl()+menu.pos_l,getct()+menu.pos_t],_b);
			ck_win_els(-1,_b);
		}
	}
}

function getbg(bg_cl,bg_img,bg_rep)
{
	var s=bg_cl;
	if(bg_img!='')
		s+=" url("+bg_img+") "+bg_rep;
	return s;
}

function ck_win_els(change,obj)
{
	if(!st_loaded||nNN4||nOP||obj.isstatic)	return;
	if(HideSelect)	win_ele_vis("SELECT", change, obj);
	if(HideObject)	win_ele_vis("OBJECT", change, obj);
	if(HideIFrame)	win_ele_vis("IFRAME", change, obj);
}

function win_ele_vis(tagName, change, obj)
{
	var els=nNN6 ? document.getElementsByTagName(tagName) : document.all.tags(tagName);
	var i;
	for (i=0;i<els.length;i++)
	{
		var el=els.item(i);
		var flag;
		for(flag=0,tmobj=el.offsetParent;tmobj;tmobj=tmobj.offsetParent)
			if(tmobj.id&&tmobj.id.indexOf("STM")>=0)
				flag=1;
		if(flag)
			continue;
		else if(elements_overlap(el,obj))
		{
			if (el.visLevel)
				el.visLevel+=change;
			else
				el.visLevel=change;
			if (el.visLevel==-1)
			{
				if(typeof(el.visSave)=='undefined')
					el.visSave=el.style.visibility;
				el.style.visibility="hidden";
			}
			else if (el.visLevel==0)
				el.style.visibility=el.visSave;
		}
	}
}

function elements_overlap(el,obj)
{
	var left=0;
	var top=0;
	var width=el.offsetWidth;
	var height=el.offsetHeight;
	if(width)
		el._width=width;
	else
		width=el._width;
	if(height)
		el._height=height;
	else
		height=el._height;
	
	while(el)
	{
		left+=el.offsetLeft;
		top+=el.offsetTop;
		el=el.offsetParent;
	}
	return ((left<obj.rc[2]+obj.rc[0]) && (left+width>obj.rc[0]) && (top<obj.rc[3]+obj.rc[1]) && (top+height>obj.rc[1]));
}

function getob(id,t)
{
	if(nNN6)
		return document.getElementById(id);
	else if(nNN4)
		return getly(id,document);
	else
		return t ? document.all.tags(t)[id] : document.all[id];
}

function getBodyEventString(body)
{
	var s=" onMouseOver='dombov(event,this,st_menus["+body.mei+"].bodys["+body.mbi+"]);'";
	s+=" onMouseOut='dombou(event,this,st_menus["+body.mei+"].bodys["+body.mbi+"]);'";
	return s;
}

function getItemEventString(item)
{
	if(item.type=='sepline')	return '';
	var s=" onMouseOver='doitov(event,this,st_menus["+item.mei+"].bodys["+item.mbi+"].items["+item.iti+"]);'";
	s+=" onMouseOut='doitou(event,this,st_menus["+item.mei+"].bodys["+item.mbi+"].items["+item.iti+"]);'";
	s+=" onClick='doitck(event,this,st_menus["+item.mei+"].bodys["+item.mbi+"].items["+item.iti+"]);'";
	return s;
}

function getEventCode(pre,isitem)
{
	var s=isitem ? 'st_rei' : 'st_reb';
	s+='.exec(this.id);mei=RegExp.$1;mbi=parseInt(RegExp.$2);';
	if(isitem)	s+='iti=parseInt(RegExp.$3);return '+pre+'(e,this,st_menus[mei].bodys[mbi].items[iti]);';
	else	s+='return '+pre+'(e,this,st_menus[mei].bodys[mbi]);';
	return new Function('e',s);
}

function addquo(n)
{
	return "\""+n+"\"";
}

// file: tabs.js

function setClassName(name, className)
{
	var obj = document.all ?
		document.all[name] : document.getElementById(name);
	if (obj == null)
		return false;
	obj.className = className;
	return (obj.className == className);
}

function setActiveTab(t, pfx)
{
	// iterar tab_title_* y tab_body_*
	
	if (pfx == null) {
		pfx = "tab";
	}
	
	var i = 0;
	while (i++ < 100) {
		if (!setClassName(pfx + "_title_" + i, i == t ? "tab-title-select" : "tab-title-normal"))
			break;
		if (!setClassName(pfx + "_body_" + i,  i == t ? "tab-body-select"  : "tab-body-normal" ))
			break;
	}
}
// file: utiles.js

//Devuelve el codigo ASCII de una tecla en el evento keyUp
function Key(evento)
 {
	var version4 = window.Event ? true : false;
	if (version4) { // Navigator 4.0x 
		var whichCode = evento.which	
	} else {// Internet Explorer 4.0x
		if (evento.type == "keyup") { // the user entered a character
			var whichCode = evento.keyCode
		} else {
			var whichCode = evento.button;
		}
	}
return (whichCode)
}

// Detecta el nombre y la version del browser, retorna
 // NS6 si es Netscape 6, 
 // NS4 si es Netscape4.x, 
 // MSIE5 si es Microsoft Internet Explorer 5.x, 
 // MSIE4 si es Microsoft Internet Explorer 4.x y 
 // OTHER si es otro
function detectBrowser() {
	var browserVersion = "";
  
	if (navigator.appName == "Netscape") {
		if (parseInt(navigator.appVersion) >= 5) {
			browserVersion = "NS6";
		} else if (parseInt(navigator.appVersion) >= 4) {
			browserVersion = "NS4";
		} else {    
			browserVersion = "OTHER";   
		}
	} else if (navigator.appName == "Microsoft Internet Explorer") {
		if (navigator.appVersion.indexOf["MSIE 5"] != -1) {
			browserVersion = "MSIE5";
		} else if (parseInt(navigator.appVersion) >= 4) {
			browserVersion = "MSIE4";
		} else {
		    browserVersion = "OTHER";
		}
	} else {
		browserVersion = "OTHER";
	}
	return browserVersion;
 }

function ltrim(tira) {
    var CARACTER="", HILERA="";
    if (tira.name) {
        VALOR=tira.value;
    } else {
        VALOR=tira;
    }
 
    HILERA = VALOR;
    INICIO = VALOR.lastIndexOf(" ");
    if (INICIO>-1) {
        for (var i=0; i<VALOR.length; i++) { 
            CARACTER=VALOR.substring(i,i+1);
            if (CARACTER!=" ") {
                HILERA = VALOR.substring(i,VALOR.length);
                i = VALOR.length;
            }
        }
    }
    return HILERA
}


function trim(tira)
 {return ltrim(rtrim(tira))}

//ELIMINA LOS ESPACIOS EN BLANCO DE LA DERECHA DE UN CAMPO 
function rtrim(tira) {
    if (tira.name) {
        VALOR=tira.value;
    }
    else {
        VALOR=tira;
    }
    var CARACTER = "";
    var HILERA = VALOR;
    INICIO = VALOR.lastIndexOf(" ");
    if(INICIO>-1) {
        for(var i=VALOR.length; i>0; i--) {
            CARACTER= VALOR.substring(i,i-1);
            if(CARACTER==" ")
                HILERA = VALOR.substring(0,i-1);
            else
                i=-200;
        }
    }
    return HILERA
}

//***********************************************************************************************************
//                                FUNCIONES DESPUES DE SIF EN EL PORTAL
//***********************************************************************************************************
//***********************************************************************************************************



//Verifica si un valor es numerico (soporta unn punto para los decimales unicamente)
function ESNUMERO(aVALOR)
{
var NUMEROS="0123456789."
var CARACTER=""
var CONT=0
var PUNTO="."
var VALOR = aVALOR.toString();

for (var i=0; i<VALOR.length; i++)
    {	
	CARACTER =VALOR.substring(i,i+1);
	if (NUMEROS.indexOf(CARACTER)<0) {
		return false;
		} 
    }
for (var i=0; i<VALOR.length; i++)
    {	
	CARACTER =VALOR.substring(i,i+1);
	if (PUNTO.indexOf(CARACTER)>-1)
	    {CONT=CONT+1;} 
    }

if (CONT>1) {
	return false;
}

return true;
}

//---------------------------------------------------------------------------------------------------------

//Le entra un string y un separador (un caracter) y devuelve un arreglo con todos los tokens

function tokens(s,sep){
   var str=new String(s)
   var v=new Array
   var tam=str.length
   var p1=0
   var temp=""
   var pos=0
   var n=0
   if (tam>0)   {
      pos=str.indexOf(sep)
      while (pos>=0)    {
         temp=str.substring(0,pos)
         tam=str.length
         str=str.substring(pos+1,tam)
         pos=str.indexOf(sep)
         v[n]=temp
         n++
      }
      if (pos>0 || (pos<0 && str!=''))
         v[n]=str
   }
   return v
}

//---------------------------------------------------------------------------------------------------------

function ValidaPorcentaje(Obj) {
  if  (parseInt(Obj.value) > 100 || parseInt(Obj.value) < 0) {
    alert("Porcentaje debe estar entre 0 y 100");
    return false;
  }
  
  return true;
}

//---------------------------------------------------------------------------------------------------------



<!--- esto es lo que estaba en ~/general/js/utiles.js ----->



botonActual="";

//Devuelve el codigo ASCII de una tecla en el evento keyUp
function Key(evento) {
	var version4 = window.Event ? true : false;
	if (version4) { // Navigator 4.0x 
		var whichCode = evento.which	
	} else {// Internet Explorer 4.0x
		if (evento.type == "keyup") { // the user entered a character
			var whichCode = evento.keyCode
		} else {
			var whichCode = evento.button;
		}
	}
    return (whichCode)
}

// Oprime el botón tipo submit que se corresponda
function defaultBtn(formulario) {
	var version4 = window.Event ? true : false;
	if (version4) {         // Netscape
        //formulario[formulario.btnDefaultbtn.value].click();
        if (formulario.name=='Mantenimiento') {
            formulario.btnCambiar.click();
        } else if (formulario.name=='Insercion') {
            formulario.btnAgregar.click();
        }
    } else {                // Internet Explorer
        //formulario[formulario.btnDefaultbtn.value].focus();
        if (formulario.name=='Mantenimiento') {
            formulario.btnCambiar.focus();
        } else if (formulario.name=='Insercion') {
            formulario.btnAgregar.focus();
        }
    }
}

// Selecciona el botón
function setBtn(boton) {
    botonActual = boton.name;
}

// Verificar si existe un boton
function btnSelected(name) {
    return (botonActual == name)
}

// Eliminar los espacios de la izquierda
function ltrim(tira) {
    var CARACTER="", HILERA="";
    if (tira.name) {
        VALOR=tira.value;
    } else {
        VALOR=tira;
    }
 
    HILERA = VALOR;
    INICIO = VALOR.lastIndexOf(" ");
    if (INICIO>-1) {
        for (var i=0; i<VALOR.length; i++) { 
            CARACTER=VALOR.substring(i,i+1);
            if (CARACTER!=" ") {
                HILERA = VALOR.substring(i,VALOR.length);
                i = VALOR.length;
            }
        }
    }
    return HILERA
}

// Eliminar los espacios de la derecha
function rtrim(tira) {
    if (tira.name) {
        VALOR=tira.value;
    }
    else {
        VALOR=tira;
    }
    var CARACTER = "";
    var HILERA = VALOR;
    INICIO = VALOR.lastIndexOf(" ");
    if(INICIO>-1) {
        for(var i=VALOR.length; i>0; i--) {
            CARACTER= VALOR.substring(i,i-1);
            if(CARACTER==" ")
                HILERA = VALOR.substring(0,i-1);
            else
                i=-200;
        }
    }
    return HILERA
}

// Función para los checks en 
function setCheck(checkbox, hidden) {
    if (checkbox.checked) {
        hidden.value='S'
    } else {
        hidden.value='N'
    }
}

// Hace falta validar la existencia de un único punto decimal, un único menos y comas en buena posición
function validaNumero(control) {
  var numero = control.value;
  var digito = numero.charAt(numero.length-1);
  var resto = numero.substr(0,numero.length-1);
  /*
  if ((digito==".") && (resto.indexOf(".")!=-1)) {
      control.value = resto;
  } else if ((digito=="-") && (resto.length!=0)) {
      control.value = resto;
  } else 
  */
  if ((digito<"0" || digito>"9") && digito!="." && digito!="-"){
      control.value = resto;
  }
}

function quiteCaracter(str,caracter){
    if (str.indexOf(caracter)!=-1) {
        str = str.substring(0,str.indexOf(caracter)) + quiteCaracter(str.substring(str.indexOf(caracter)+1,str.length),caracter);
    }
    return str;
}

// Formatea un número con comas y punto decimal
function formatNum(num) {
    myNum = quiteCaracter(""+num,",");
    negativo=false;
    pos = myNum.indexOf("-");
    if (pos!=-1) {
        myNum=myNum.substring(pos+1,myNum.length);
        negativo=true;
    }
    pos = myNum.indexOf(".");
    if (pos!=-1) {
        myNum = myNum.substring(0,pos+3);
        for (s=myNum.length; s<pos+3; s++)
            myNum+="0";
    } else {
        myNum+=".00";
    }
    pos = myNum.indexOf(".");
    while ((Math.floor(pos/3)>0) && (pos!=3)){
        myNum=myNum.substring(0,pos-3)+","+myNum.substring(pos-3,myNum.length);
        pos = myNum.indexOf(",");
    }
    if (negativo) return "-"+myNum
    else return myNum;
}





/************************************************** 
* FUNCIONCITAS DE VALIDACION DE CAPTURA DE NUMEROS *
* QUE NOS MANDARON DEL SIF PARA QUE QUEDE BONITO   *
 ***************************************************/


/*
EL OBJETO SE PINTA DE LA SIGUIENTE FORMA
	<INPUT TYPE="text" NAME="CJM03DIA" VALUE="" SIZE="6" MAXLENGTH="6" 
	ONBLUR="fm(this,-1); " 
	ONFOCUS="this.value=qf(this); this.select(); " 
	ONKEYUP="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
	style=" text-align:left;">

	A CONTINUACION LAS FUNCIONES fm(), qf() y snumber()
	EL VALOR -1 SIGNIFICA QUE EL CAMPO NO TIENE DECIMALES 
	DE LO CONTRARIO SE COLOCA EL NUMERO DE DECIMALES QUE SE QUIERAN

*/

//Funcion para validar los numeros, Autor: Ricardo Soto

function snumber(obj,e,d)
{
str= new String("")
str= obj.value
var tam=obj.size
var t=Key(e)
var ok=false

if(tam>d) {tam=tam-d}
if(tam>1) {tam=tam-1}

if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;
if(t>=16 && t<=20) return false;
if(t>=33 && t<=40) return false;
if(t>=112 && t<=123) return false;

if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)

if(t>=48 && t<=57)  ok=true
if(t>=96 && t<=105) ok=true
//if(d>=0) {if(t==188) ok=true} //LA COMA

if(d>0)
{
if(t==110) ok=true
if(t==190) ok=true
}

if(!ok) 
{    
    str=fm(str,d)
    obj.value=str
}
return true
}

////////////////////
function decimals(str,d)
{
var largo=str.length	     
var punto=-1
for(var i=0;i<str.length;i++)
  {punto=str.indexOf('.')}
punto++
if(punto>0 && largo-punto>d)
  return false
else
  return true 
}
 
////////////////////
function ints(str,ints)
{
	var largo=str.length	     
	var punto=-1
	for(var i=0;i<str.length;i++)
	  {punto=str.indexOf('.')}
	punto++
	if(punto>0)
	  {str=str.substring(0,punto-1)}
	str=strReplace(str,',','');
	if(str.length>ints) {
	  return false;
	} else {
	  return true;
	}
}


//elimina el formato numerico de una hilera, retorna la hilera
function qf(Obj)
{
var VALOR=""
var HILERA=""
var CARACTER=""
if(Obj.name)
  VALOR=Obj.value
else
  VALOR=Obj
for (var i=0; i<VALOR.length; i++) {	
	CARACTER =VALOR.substring(i,i+1);
	if (CARACTER=="," || CARACTER==" ") {
		CARACTER=""; //CAMBIA EL CARACTER POR BLANCO
	}  
	HILERA+=CARACTER;
}
return HILERA
}




//Formato por Randall Vargas
//Formatea como float un valor de un campo
//Recibe como parametro el campo y la cantidad de decimales a mostrar
function fm(campo,ndec) {
   var s = "";
   if (campo.name)
     s=campo.value
   else
     s=campo

   if(s=='' && ndec>0) 
		s='0'

   var nc=""
   var s1=""
   var s2=""
   if (s != '') {
      str = new String("")
      str_temp = new String(s)
      t1 = str_temp.length
      cero_izq=true
      if (t1 > 0) {
         for(i=0;i<t1;i++) {
            c=str_temp.charAt(i)
            if ((c!="0") || (c=="0" && ((i<t1-1 && str_temp.charAt(i+1)==".")) || i==t1-1) || (c=="0" && cero_izq==false)) {
               cero_izq=false
               str+=c
            }
         }
      }
      t1 = str.length
      p1 = str.indexOf(".")
      p2 = str.lastIndexOf(".")
      if ((p1 == p2) && t1 > 0) {
         if (p1>0)
            str+="00000000"
         else
            str+=".0000000"

         p1 = str.indexOf(".")
         s1=str.substring(0,p1)
         s2=str.substring(p1+1,p1+1+ndec)
         t1 = s1.length
         n=0
         for(i=t1-1;i>=0;i--) {
             c=s1.charAt(i)
             if (c == ".") {flag=0;nc="."+nc;n=0}
             if (c>="0" && c<="9") {
                if (n < 2) {
                   nc=c+nc
                   n++
                }
                else {
                   n=0
                   nc=c+nc
                   if (i > 0)
                      nc=","+nc
                }
             }
         }
         if (nc != "" && ndec > 0)
            nc+="."+s2
      }
      else {ok=1}
   }
   
   if(campo.name) {
	   if(ndec>0) {
		 campo.value=nc
	   } 
	   else {
		 campo.value=qf(nc)
		}
   } 
   else {
     return nc
   }
}

//reemplaza un string por otro dentro de una hilera, devuelve la hilera reemplazada
function strReplace(str,oldc,newc) 
{
   var HILERA=""
   var CARACTER=""
   for (var i=0; i<str.length; i++) 
   {
      CARACTER=str.substring(i,i+1)
      if (CARACTER==oldc)  
        {CARACTER=newc}
      HILERA=HILERA+CARACTER;
   }
   return HILERA;
}
   
/************************************************** 
*               FIN DE                             *
* FUNCIONCITAS DE VALIDACION DE CAPTURA DE NUMEROS *
* QUE NOS MANDARON DEL SIF PARA QUE QUEDE BONITO   *
 ***************************************************/

/**
 * Esta funcion se debe llamar en el evento onsubmit
 * de los formularios que tienen una imagen asociada
 * Esto es especialmente importante cuando hay dos
 * puertos distintos para el Upload y PowerDynamo
 */
function preparaImagen(formulario)
{
	if (formulario.url) {
		if (formulario.url.value.substring(0,1) == "/") {
			formulario.url.value = document.location.protocol
				+ "//" + document.location.host	// host incluye hostname:port
				+ formulario.url.value;
		};
		/*
		** esto va a servir cuando el action tenga el pgSQL por separado.
		** probado con IE6.0, falta IE5.0,5.5 y NS
		var coll = formulario.elements, i, hasImages = false;
		for (i = 0; i < coll.length; i++) {
			var item = coll.item(i);
			var isFile = (item.tagName == "INPUT" || item.tagName == "input")
			          && (item.type == "FILE" || item.type == "file");
			if (isFile && item.value != "") {
				hasImages = true;
				break;
			}
		}
		if (!hasImages) {
			formulario.action = formulario.url.value;
		}
		*/
	}
	
	return true;
}
// file: validar.js

/**
 * validaciones genéricas comunes a los formularios generados
 */

function onblurdatetime(elemento)
{
    var f = elemento.value;
    var partes = f.split ("/");
    var ano = 0, mes = 0; dia = 0;
    if (partes.length == 3) {
        ano = parseInt(partes[2], 10);
        mes = parseInt(partes[1], 10);
        dia = parseInt(partes[0], 10);
    } else if (partes.length == 2) {
        var hoy = new Date;
        ano = hoy.getFullYear();
        mes = parseInt(partes[1], 10);
        dia = parseInt(partes[0], 10); // mama si inicia en 0
    } else {
        // no es fecha
    }
    if (ano < 100) {
        ano += (ano < 50 ? 2000 : 1900);
    }
    var d = new Date(ano, mes - 1, dia);
    if ((d.getFullYear() == ano) && 
        (d.getMonth()    == mes-1) && 
        (d.getDate()     == dia))
    {   // ok
        elemento.value 
            = (d.getDate()  < 10 ? "0" : "") + d.getDate() + "/" 
            + (d.getMonth() < 9 ? "0" : "") + (d.getMonth()+1) + "/" + d.getFullYear();
    } else {
        elemento.value = "";
    }
}

function onblurnumeric(elemento, precision, scale)
{
    var floatValue = parseFloat(elemento.value);
    
    if (isNaN(floatValue) || !isFinite(floatValue)) {
        elemento.value = "";
    } else {
        if (precision == undefined) {
            precision = 18;
        } 
        if (scale == undefined) {
            scale = 0;
        }
    
        var comp = ("" + floatValue).split(".");
        // comp[0] es la parte entera y comp[1] es la parte decimal
        
        // check precision
        if (comp.length >= 1 && comp[0].length > (precision-scale)) {
            alert("Arithmetic overflow: max int part = " + (precision-scale) + " digits");
            elemento.focus();
            comp[0] = comp[0].substring(0, precision-scale);
        }
        
        // check scale
        var zeroes = "00000000000000000000000000000";
        if (scale == 0) {
            floatValue = parseFloat(comp[0]);
        } else if (comp.length == 1) {
            floatValue = comp[0] + "." + zeroes.substring(0, scale);
        } else if (comp.length >= 2) {
            if (comp[1].length > scale) {
                comp[1] = comp[1].substring(0, scale);
            } else if (comp[1].length < scale) {
                comp[1] += zeroes.substring(0, scale-comp[1].length);
            }
            floatValue = comp[0] + "." + comp[1];
        }
        elemento.value = floatValue;
    }
}
onblurdecimal  = onblurnumeric;

function onblurmoney (element)
{
    return onblurnumeric(element,16,2);
}

function onblurreal (element)
{
    return onblurnumeric(element,16,9);
}

function onblurfloat (element)
{
    return onblurnumeric(element,16,9);
}

function onblurdouble_precision (element)
{
    return onblurnumeric(element,16,9);
}

function onblurint(elemento)
{
    var intValue = parseInt(elemento.value);
    if (isNaN(intValue) || !isFinite(intValue)) {
        elemento.value = "";
    } else {
        elemento.value = intValue;
    }
}
onblursmallint = onblurint;
onblurtinyint  = onblurint;

function onblurchar(elemento)
{
}
onblurnchar = onblurchar;
onblurvarchar = onblurchar;
onblurnvarchar = onblurchar;

// falta definir estas
onblurbinary = onblurchar;
onblurvarbinary = onblurchar;
onblurtext      = onblurchar;
onblurbit       = onblurchar;
onblurimage     = onblurchar;
// file: xmenu.js

/*
 * This script was created by Erik Arvidsson (erik@eae.net)
 * for WebFX (http://webfx.eae.net)
 * Copyright 2001
 * 
 * For usage see license at http://webfx.eae.net/license.html	
 *
 * Created:		2001-01-12
 * Updates:		2001-11-20	Added hover mode support and removed Opera focus hacks
 *				2001-12-20	Added auto positioning and some properties to support this
 */
 
// check browsers
var ua = navigator.userAgent;
var opera = /opera [56789]|opera\/[56789]/i.test(ua);
var ie = !opera && /MSIE/.test(ua);
var ie50 = ie && /MSIE 5\.[01234]/.test(ua);
var ie6 = ie && /MSIE [6789]/.test(ua);
var ieBox = ie && (document.compatMode == null || document.compatMode != "CSS1Compat");
var moz = !opera && /gecko/i.test(ua);
var nn6 = !opera && /netscape.*6\./i.test(ua);
// define the default values
webfxMenuDefaultWidth			= 100;

webfxMenuDefaultBorderLeft		= 1;
webfxMenuDefaultBorderRight		= 1;
webfxMenuDefaultBorderTop		= 1;
webfxMenuDefaultBorderBottom	= 1;
webfxMenuDefaultPaddingLeft		= 1;
webfxMenuDefaultPaddingRight	= 1;
webfxMenuDefaultPaddingTop		= 1;
webfxMenuDefaultPaddingBottom	= 1;

webfxMenuDefaultShadowLeft		= 0;
webfxMenuDefaultShadowRight		= ie && !ie50 && /win32/i.test(navigator.platform) ? 4 :0;
webfxMenuDefaultShadowTop		= 0;
webfxMenuDefaultShadowBottom	= ie && !ie50 && /win32/i.test(navigator.platform) ? 4 : 0;

webfxMenuItemDefaultHeight		= 18;
webfxMenuItemDefaultText		= "Untitled";
webfxMenuItemDefaultHref		= "javascript:void(0)";

webfxMenuSeparatorDefaultHeight	= 6;

webfxMenuDefaultEmptyText		= "Empty";

webfxMenuDefaultUseAutoPosition	= nn6 ? false : true;

// other global constants
webfxMenuImagePath				= "";

webfxMenuUseHover				= opera ? true : false;
webfxMenuHideTime				= 500;
webfxMenuShowTime				= 200;

var webFXMenuHandler = {
	idCounter		:	0,
	idPrefix		:	"webfx-menu-object-",
	all				:	{},
	getId			:	function () { return this.idPrefix + this.idCounter++; },
	overMenuItem	:	function (oItem) {
		if (this.showTimeout != null)
			window.clearTimeout(this.showTimeout);
		if (this.hideTimeout != null)
			window.clearTimeout(this.hideTimeout);
		var jsItem = this.all[oItem.id];
		if (webfxMenuShowTime <= 0)
			this._over(jsItem);
		else
			//this.showTimeout = window.setTimeout(function () { webFXMenuHandler._over(jsItem) ; }, webfxMenuShowTime);
			// I hate IE5.0 because the piece of shit crashes when using setTimeout with a function object
			this.showTimeout = window.setTimeout("webFXMenuHandler._over(webFXMenuHandler.all['" + jsItem.id + "'])", webfxMenuShowTime);
	},
	outMenuItem	:	function (oItem) {
		if (this.showTimeout != null)
			window.clearTimeout(this.showTimeout);
		if (this.hideTimeout != null)
			window.clearTimeout(this.hideTimeout);
		var jsItem = this.all[oItem.id];
		if (webfxMenuHideTime <= 0)
			this._out(jsItem);
		else
			//this.hideTimeout = window.setTimeout(function () { webFXMenuHandler._out(jsItem) ; }, webfxMenuHideTime);
			this.hideTimeout = window.setTimeout("webFXMenuHandler._out(webFXMenuHandler.all['" + jsItem.id + "'])", webfxMenuHideTime);
	},
	blurMenu		:	function (oMenuItem) {
		window.setTimeout("webFXMenuHandler.all[\"" + oMenuItem.id + "\"].subMenu.hide();", webfxMenuHideTime);
	},
	_over	:	function (jsItem) {
		if (jsItem.subMenu) {
			jsItem.parentMenu.hideAllSubs();
			jsItem.subMenu.show();
		}
		else
			jsItem.parentMenu.hideAllSubs();
	},
	_out	:	function (jsItem) {
		// find top most menu
		var root = jsItem;
		var m;
		if (root instanceof WebFXMenuButton)
			m = root.subMenu;
		else {
			m = jsItem.parentMenu;
			while (m.parentMenu != null && !(m.parentMenu instanceof WebFXMenuBar))
				m = m.parentMenu;
		}
		if (m != null)	
			m.hide();	
	},
	hideMenu	:	function (menu) {
		if (this.showTimeout != null)
			window.clearTimeout(this.showTimeout);
		if (this.hideTimeout != null)
			window.clearTimeout(this.hideTimeout);

		this.hideTimeout = window.setTimeout("webFXMenuHandler.all['" + menu.id + "'].hide()", webfxMenuHideTime);
	},
	showMenu	:	function (menu, src, dir) {
		if (this.showTimeout != null)
			window.clearTimeout(this.showTimeout);
		if (this.hideTimeout != null)
			window.clearTimeout(this.hideTimeout);
		if (arguments.length < 3)
			dir = "vertical";
		
		menu.show(src, dir);
	}
};

function WebFXMenu() {
	this._menuItems	= [];
	this._subMenus	= [];
	this.id			= webFXMenuHandler.getId();
	this.top		= 0;
	this.left		= 0;
	this.shown		= false;
	this.parentMenu	= null;
	webFXMenuHandler.all[this.id] = this;
}

WebFXMenu.prototype.width			= webfxMenuDefaultWidth;
WebFXMenu.prototype.emptyText		= webfxMenuDefaultEmptyText;
WebFXMenu.prototype.useAutoPosition	= webfxMenuDefaultUseAutoPosition;

WebFXMenu.prototype.borderLeft		= webfxMenuDefaultBorderLeft;
WebFXMenu.prototype.borderRight		= webfxMenuDefaultBorderRight;
WebFXMenu.prototype.borderTop		= webfxMenuDefaultBorderTop;
WebFXMenu.prototype.borderBottom	= webfxMenuDefaultBorderBottom;

WebFXMenu.prototype.paddingLeft		= webfxMenuDefaultPaddingLeft;
WebFXMenu.prototype.paddingRight	= webfxMenuDefaultPaddingRight;
WebFXMenu.prototype.paddingTop		= webfxMenuDefaultPaddingTop;
WebFXMenu.prototype.paddingBottom	= webfxMenuDefaultPaddingBottom;

WebFXMenu.prototype.shadowLeft		= webfxMenuDefaultShadowLeft;
WebFXMenu.prototype.shadowRight		= webfxMenuDefaultShadowRight;
WebFXMenu.prototype.shadowTop		= webfxMenuDefaultShadowTop;
WebFXMenu.prototype.shadowBottom	= webfxMenuDefaultShadowBottom;

WebFXMenu.prototype.add = function (menuItem) {
	this._menuItems[this._menuItems.length] = menuItem;
	if (menuItem.subMenu) {
		this._subMenus[this._subMenus.length] = menuItem.subMenu;
		menuItem.subMenu.parentMenu = this;
	}
	
	menuItem.parentMenu = this;
};

WebFXMenu.prototype.show = function (relObj, sDir) {
	if (this.useAutoPosition)
		this.position(relObj, sDir);
	
	var divElement = document.getElementById(this.id);
	divElement.style.left = opera ? this.left : this.left + "px";
	divElement.style.top = opera ? this.top : this.top + "px";
	divElement.style.visibility = "visible";
	this.shown = true;
	if (this.parentMenu)
		this.parentMenu.show();
};

WebFXMenu.prototype.hide = function () {
	this.hideAllSubs();
	var divElement = document.getElementById(this.id);
	divElement.style.visibility = "hidden";
	this.shown = false;
};

WebFXMenu.prototype.hideAllSubs = function () {
	for (var i = 0; i < this._subMenus.length; i++) {
		if (this._subMenus[i].shown)
			this._subMenus[i].hide();
	}
};
WebFXMenu.prototype.toString = function () {
	var top = this.top + this.borderTop + this.paddingTop;
	var str = "<div id='" + this.id + "' class='webfx-menu' style='" + 
	"width:" + (!ieBox  ?
		this.width - this.borderLeft - this.paddingLeft - this.borderRight - this.paddingRight  : 
		this.width) + "px;" +
	(this.useAutoPosition ?
		"left:" + this.left + "px;" + "top:" + this.top + "px;" :
		"") +
	(ie50 ? "filter: none;" : "") +
	"'>";
	
	if (this._menuItems.length == 0) {
		str +=	"<span class='webfx-menu-empty'>" + this.emptyText + "</span>";
	}
	else {	
		// loop through all menuItems
		for (var i = 0; i < this._menuItems.length; i++) {
			var mi = this._menuItems[i];
			str += mi;
			if (!this.useAutoPosition) {
				if (mi.subMenu && !mi.subMenu.useAutoPosition)
					mi.subMenu.top = top - mi.subMenu.borderTop - mi.subMenu.paddingTop;
				top += mi.height;
			}
		}

	}
	
	str += "</div>";

	for (var i = 0; i < this._subMenus.length; i++) {
		this._subMenus[i].left = this.left + this.width - this._subMenus[i].borderLeft;
		str += this._subMenus[i];
	}
	
	return str;
};
// WebFXMenu.prototype.position defined later
function WebFXMenuItem(sText, sHref, sToolTip, oSubMenu) {
	this.text = sText || webfxMenuItemDefaultText;
	this.href = (sHref == null || sHref == "") ? webfxMenuItemDefaultHref : sHref;
	this.subMenu = oSubMenu;
	if (oSubMenu)
		oSubMenu.parentMenuItem = this;
	this.toolTip = sToolTip;
	this.id = webFXMenuHandler.getId();
	webFXMenuHandler.all[this.id] = this;
};
WebFXMenuItem.prototype.height = webfxMenuItemDefaultHeight;
WebFXMenuItem.prototype.toString = function () {
	return	"<a" +
			" id='" + this.id + "'" +
			" href='" + this.href + "'" +
			(this.toolTip ? " title='" + this.toolTip + "'" : "") +
			" onmouseover='webFXMenuHandler.overMenuItem(this)'" +
			(webfxMenuUseHover ? " onmouseout='webFXMenuHandler.outMenuItem(this)'" : "") +
			(this.subMenu ? " unselectable='on' tabindex='-1'" : "") +
			">" +
			(this.subMenu ? "<img class='arrow' src='" + webfxMenuImagePath + "rt.png'>" : "") +
			this.text + 
			"</a>";
};


function WebFXMenuSeparator() {
	this.id = webFXMenuHandler.getId();
	webFXMenuHandler.all[this.id] = this;
};
WebFXMenuSeparator.prototype.height = webfxMenuSeparatorDefaultHeight;
WebFXMenuSeparator.prototype.toString = function () {
	return	"<div" +
			" id='" + this.id + "'" +
			(webfxMenuUseHover ? 
			" onmouseover='webFXMenuHandler.overMenuItem(this)'" +
			" onmouseout='webFXMenuHandler.outMenuItem(this)'"
			:
			"") +
			"></div>"
};

function WebFXMenuBar() {
	this._parentConstructor = WebFXMenu;
	this._parentConstructor();
}
WebFXMenuBar.prototype = new WebFXMenu;
WebFXMenuBar.prototype.toString = function () {
	var str = "<div id='" + this.id + "' class='webfx-menu-bar'>";
	
	// loop through all menuButtons
	for (var i = 0; i < this._menuItems.length; i++)
		str += this._menuItems[i];
	
	str += "</div>";

	for (var i = 0; i < this._subMenus.length; i++)
		str += this._subMenus[i];
	
	return str;
};

function WebFXMenuButton(sText, sHref, sToolTip, oSubMenu) {
	this._parentConstructor = WebFXMenuItem;
	this._parentConstructor(sText, sHref, sToolTip, oSubMenu);
}
WebFXMenuButton.prototype = new WebFXMenuItem;
WebFXMenuButton.prototype.toString = function () {
	return	"<a" +
			" id='" + this.id + "'" +
			" href='" + this.href + "'" +
			(this.toolTip ? " title='" + this.toolTip + "'" : "") +
			(webfxMenuUseHover ?
				(" onmouseover='webFXMenuHandler.overMenuItem(this)'" +
				" onmouseout='webFXMenuHandler.outMenuItem(this)'") :
				(
					" onfocus='webFXMenuHandler.overMenuItem(this)'" +
					(this.subMenu ?
						" onblur='webFXMenuHandler.blurMenu(this)'" :
						""
					)
				)) +
			">" +
			this.text + 
			(this.subMenu ? " <img class='arrow' src='" + webfxMenuImagePath + "dn.png' align='absmiddle'>" : "") +				
			"</a>";
};


/* Position functions */

function getInnerLeft(el) {
	if (el == null) return 0;
	if (ieBox && el == document.body || !ieBox && el == document.documentElement) return 0;
	return getLeft(el) + getBorderLeft(el);
}

function getLeft(el) {
	if (el == null) return 0;
	return el.offsetLeft + getInnerLeft(el.offsetParent);
}

function getInnerTop(el) {
	if (el == null) return 0;
	if (ieBox && el == document.body || !ieBox && el == document.documentElement) return 0;
	return getTop(el) + getBorderTop(el);
}

function getTop(el) {
	if (el == null) return 0;
	return el.offsetTop + getInnerTop(el.offsetParent);
}

function getBorderLeft(el) {
	return ie ?
		el.clientLeft :
		parseInt(window.getComputedStyle(el, null).getPropertyValue("border-left-width"));
}

function getBorderTop(el) {
	return ie ?
		el.clientTop :
		parseInt(window.getComputedStyle(el, null).getPropertyValue("border-top-width"));
}

function opera_getLeft(el) {
	if (el == null) return 0;
	return el.offsetLeft + opera_getLeft(el.offsetParent);
}

function opera_getTop(el) {
	if (el == null) return 0;
	return el.offsetTop + opera_getTop(el.offsetParent);
}

function getOuterRect(el) {
	return {
		left:	(opera ? opera_getLeft(el) : getLeft(el)),
		top:	(opera ? opera_getTop(el) : getTop(el)),
		width:	el.offsetWidth,
		height:	el.offsetHeight
	};
}

// mozilla bug! scrollbars not included in innerWidth/height
function getDocumentRect(el) {
	return {
		left:	0,
		top:	0,
		width:	(ie ?
					(ieBox ? document.body.clientWidth : document.documentElement.clientWidth) :
					window.innerWidth
				),
		height:	(ie ?
					(ieBox ? document.body.clientHeight : document.documentElement.clientHeight) :
					window.innerHeight
				)
	};
}

function getScrollPos(el) {
	return {
		left:	(ie ?
					(ieBox ? document.body.scrollLeft : document.documentElement.scrollLeft) :
					window.pageXOffset
				),
		top:	(ie ?
					(ieBox ? document.body.scrollTop : document.documentElement.scrollTop) :
					window.pageYOffset
				)
	};
}

/* end position functions */

WebFXMenu.prototype.position = function (relEl, sDir) {
	var dir = sDir;
	// find parent item rectangle, piRect
	var piRect;
	if (!relEl) {
		var pi = this.parentMenuItem;
		if (!this.parentMenuItem)
			return;
		
		relEl = document.getElementById(pi.id);
		if (dir == null)
			dir = pi instanceof WebFXMenuButton ? "vertical" : "horizontal";
		
		piRect = getOuterRect(relEl);
	}
	else if (relEl.left != null && relEl.top != null && relEl.width != null && relEl.height != null) {	// got a rect
		piRect = relEl;
	}
	else
		piRect = getOuterRect(relEl);
	
	var menuEl = document.getElementById(this.id);
	var menuRect = getOuterRect(menuEl);
	var docRect = getDocumentRect();
	var scrollPos = getScrollPos();
	var pMenu = this.parentMenu;
	
	if (dir == "vertical") {
		if (piRect.left + menuRect.width - scrollPos.left <= docRect.width)
			this.left = piRect.left;
		else if (docRect.width >= menuRect.width)
			this.left = docRect.width + scrollPos.left - menuRect.width;
		else
			this.left = scrollPos.left;
			
		if (piRect.top + piRect.height + menuRect.height <= docRect.height + scrollPos.top)
			this.top = piRect.top + piRect.height;
		else if (piRect.top - menuRect.height >= scrollPos.top)
			this.top = piRect.top - menuRect.height;
		else if (docRect.height >= menuRect.height)
			this.top = docRect.height + scrollPos.top - menuRect.height;
		else
			this.top = scrollPos.top;
	}
	else {
		if (piRect.top + menuRect.height - this.borderTop - this.paddingTop <= docRect.height + scrollPos.top)
			this.top = piRect.top - this.borderTop - this.paddingTop;
		else if (piRect.top + piRect.height - menuRect.height + this.borderTop + this.paddingTop >= 0)
			this.top = piRect.top + piRect.height - menuRect.height + this.borderBottom + this.paddingBottom + this.shadowBottom;
		else if (docRect.height >= menuRect.height)
			this.top = docRect.height + scrollPos.top - menuRect.height;
		else
			this.top = scrollPos.top;

		var pMenuPaddingLeft = pMenu ? pMenu.paddingLeft : 0;
		var pMenuBorderLeft = pMenu ? pMenu.borderLeft : 0;
		var pMenuPaddingRight = pMenu ? pMenu.paddingRight : 0;
		var pMenuBorderRight = pMenu ? pMenu.borderRight : 0;
		
		if (piRect.left + piRect.width + menuRect.width + pMenuPaddingRight +
			pMenuBorderRight - this.borderLeft + this.shadowRight <= docRect.width + scrollPos.left)
			this.left = piRect.left + piRect.width + pMenuPaddingRight + pMenuBorderRight - this.borderLeft;
		else if (piRect.left - menuRect.width - pMenuPaddingLeft - pMenuBorderLeft + this.borderRight + this.shadowRight >= 0)
			this.left = piRect.left - menuRect.width - pMenuPaddingLeft - pMenuBorderLeft + this.borderRight + this.shadowRight;
		else if (docRect.width >= menuRect.width)
			this.left = docRect.width  + scrollPos.left - menuRect.width;
		else
			this.left = scrollPos.left;
	}
};
