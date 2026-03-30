<cfparam name="Request.calendarid"     type="numeric" default="0">
<cfparam name="Attributes.onChange"    type="string"  default="">
<cfparam name="Attributes.form"        type="string"  default="">
<cfparam name="Attributes.includeForm" type="boolean" default="yes">
<cfparam name="Attributes.name"        type="string"  default="">
<cfparam name="Attributes.value"       type="date"    default="#Now()#">
<cfparam name="Attributes.fontSize"    type="numeric" default="12">
<cfparam name="Attributes.readonly"			default="false" 					type="boolean"><!--- Solo lectura --->
<cfparam name="Attributes.style" 			default="" 							type="string">	<!--- style asociado a la caja de texto --->


<cfset Request.calendarid = Request.calendarid + 1>
<cfif Len(Attributes.form) Is 0>
	<cfset Attributes.form = 'calndr_form' & Request.calendarid>
</cfif>
<cfif Len(Attributes.name) Is 0>
	<cfset Attributes.name = 'calndr_fecha' & Request.calendarid>
</cfif>

<cfif Request.calendarid is 1>
<style type="text/css">
<!--
.calndr_font {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: <cfoutput>#Attributes.fontSize#px</cfoutput> !important;
}
.calndr_navbtn {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: <cfoutput>#Attributes.fontSize#px</cfoutput>;
	border:0px solid #999999;
	width:100%;
	background-color:#c0c0c0;
} 
td.calndr_style {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: <cfoutput>#Attributes.fontSize#px</cfoutput>;
	text-align: center;
	background-color: white;
	cursor: pointer;
}
td.calndr_selected {
	background-color: black;
	color:white;
	font-weight:bold;
}
td.calndr_today {
	font-weight:bold;
	background-color: #ededed;
}
table.calndr_style {
	background-color:#ffffff;
	border:1px solid #c0c0c0;
}
-->
</style>
</cfif>

<cfoutput>
<cfif Attributes.includeForm>
<cfset WriteOutput('
<form name="#Attributes.form#" id="#Attributes.form#" style="margin:0" action="javascript:void(0)" onSubmit="return false;">
')></cfif>
<cfquery name="rsIdioma" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as LOCEcodigo, b.VSdesc as LOCEetiqueta
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery> 


<input type="hidden" name="#Attributes.name#" id="#Attributes.name#" value="#LSDateFormat(Attributes.value)#">
<TABLE width="#Attributes.fontSize*16+2#" border="0" cellspacing="0" class="calndr_style" callpadding="2" align="center">
<TBODY id="caltbody#Request.calendarid#">
<TR>
  <TD colspan="7" class="calndr_navbtn">    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="18%"><input name="button" type="button" class="calndr_navbtn" onClick="calndr_add(-1,#Request.calendarid#);" value=" &laquo; ">          </td>
        <td width="33%" align="right">
		<select name="calformmo#Request.calendarid#" class="calndr_font" id="calformmo#Request.calendarid#" style="border:0; " onClick="calndr_set(#Request.calendarid#)"  onKeyUp="calndr_set(#Request.calendarid#)" onChange="calndr_set(#Request.calendarid#)" >
		  <cfloop query="rsIdioma">
          <option value="#LOCEcodigo#">#mid(LOCEetiqueta,1,3)#</option>
		  </cfloop>
        </select></td>
        <td width="31%" align="left"><input name="calformyr#Request.calendarid#" id="calformyr#Request.calendarid#" type="text" class="calndr_font" style="width:60px;#Attributes.style#" value="2004" maxlength="4" onKeyUp="calndr_set(#Request.calendarid#)" onChange="calndr_set(#Request.calendarid#)"<cfif Attributes.readonly>readonly</cfif>></td>
        <td width="18%" align="right"><input name="button2" type="button" class="calndr_navbtn" onClick="calndr_add(+1,#Request.calendarid#);" value=" &raquo; "></td>
      </tr>
    </table></TD>
  </TR>
  <TR class="calndr_font">
<TD width="15%" align="center" class="calendarTagHeader" style="background-color: skyblue"><cf_translate key="calendarioD" xmlFile="/rh/generales.xml">D</cf_translate></TD>
<TD width="14%" align="center" class="calendarTagHeader" style="background-color: skyblue"><cf_translate key="calendarioL" xmlFile="/rh/generales.xml">L</cf_translate></TD>
<TD width="14%" align="center" class="calendarTagHeader" style="background-color: skyblue"><cf_translate key="calendarioK" xmlFile="/rh/generales.xml">M</cf_translate></TD>
<TD width="14%" align="center" class="calendarTagHeader" style="background-color: skyblue"><cf_translate key="calendarioM" xmlFile="/rh/generales.xml">M</cf_translate></TD>
<TD width="14%" align="center" class="calendarTagHeader" style="background-color: skyblue"><cf_translate key="calendarioJ" xmlFile="/rh/generales.xml">J</cf_translate></TD>
<TD width="14%" align="center" class="calendarTagHeader" style="background-color: skyblue"><cf_translate key="calendarioV" xmlFile="/rh/generales.xml">V</cf_translate></TD>
<TD width="15%" align="center" class="calendarTagHeader" style="background-color: skyblue"><cf_translate key="calendarioS" xmlFile="/rh/generales.xml">S</cf_translate></TD>
</TR>
<TR>
  <TD class="calndr_style" onClick="calndr_tdclick(1,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(2,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(3,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(4,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(5,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(6,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(7,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
</TR><TR>
  <TD class="calndr_style" onClick="calndr_tdclick(8,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(9,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(10,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(11,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(12,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(13,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(14,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
</TR>
<TR>
  <TD class="calndr_style" onClick="calndr_tdclick(15,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(16,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(17,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(18,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(19,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(20,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(21,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
</TR>
<TR>
  <TD class="calndr_style" onClick="calndr_tdclick(22,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(23,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(24,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(25,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(26,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(27,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(28,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
</TR>
<TR>
  <TD class="calndr_style" onClick="calndr_tdclick(29,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(30,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(31,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(32,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(33,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(34,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(35,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
</TR>
<TR>
  <TD class="calndr_style" onClick="calndr_tdclick(36,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(37,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(38,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(39,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(40,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(41,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
  <TD class="calndr_style" onClick="calndr_tdclick(42,#Request.calendarid#,this)" onMouseOver="calndr_tdover(this)" onMouseOut="calndr_tdout(this,#Request.calendarid#)" >&nbsp;</TD>
</TR>
</TBODY></TABLE>
<cfif Attributes.includeForm>
<cfset WriteOutput('
</form>
')></cfif>
<script type="text/javascript">
<!--
<cfif Request.calendarid is 1>
function calndr_printLine(tr, date0, limit, selectedDate, todayDate){
	var td = tr.firstChild;
	for (var i=0;i<7;i++){
		while (td != null && td.nodeType != 1/*DOM ELEMENT_NODE*/){td = td.nextSibling;}
		if (td == null) break;
		if (date0 + i >= 1 && date0 + i <= limit) {
			txt = date0 + i;
		} else {
			txt = String.fromCharCode(0x00a0);
		}
		var tx = document.createTextNode( txt );
		if (td.firstChild == null) {
			td.appendChild(td);
		} else {
			td.replaceChild(tx,td.firstChild);
		}
		td.className = "calndr_style" +
			((selectedDate == date0+i) ? " calndr_selected" : 
			 ((todayDate   == date0+i) ? " calndr_today"    : ""));
		td = td.nextSibling;
	}
}

function calndr_print (calendarid) {
	var firstdate = new Date(caldate[calendarid].getFullYear(), caldate[calendarid].getMonth(), 1);
	var enddate = new Date(caldate[calendarid].getFullYear(), caldate[calendarid].getMonth()+1, 0);
	lastDateOfMonth[calendarid] = enddate.getDate();
	var tbody = document.getElementById("caltbody" + calendarid);
	var offset = firstdate.getDay();
	var tr = tbody.lastChild;
	var todayDate = -99;
	var today = new Date();
	if (firstdate.getFullYear() == today.getFullYear() && firstdate.getMonth() == today.getMonth()) {
		todayDate = today.getDate();
	}
	for (var lineno = 5;lineno>=0; lineno--) {
		while (tr != null && tr.nodeType != 1/*ELEMENT_NODE*/){tr = tr.previousSibling;}
		if (tr == null) break;
		calndr_printLine(tr, 7 * lineno + 1 - offset, lastDateOfMonth[calendarid], caldate[calendarid].getDate(), todayDate);
		tr = tr.previousSibling;
	}
}
function calndr_add(n, calendarid) {
	var newcaldate = caldate[calendarid];
	var currentDate = newcaldate.getDate();
	newcaldate = new Date(newcaldate.getFullYear(), newcaldate.getMonth() + n, currentDate);
	if (newcaldate.getDate() != currentDate && currentDate > 28) {
		newcaldate.setDate(0);
	}
	caldate[calendarid] = newcaldate;
	calndr_form[calendarid]['calformmo'+calendarid].value = caldate[calendarid].getMonth()+1;
	calndr_form[calendarid]['calformyr'+calendarid].value = caldate[calendarid].getFullYear();
	calndr_print(calendarid);
	var dmy = (newcaldate.getDate() < 10 ? '0':'') + newcaldate.getDate() + '/' 
		+ (newcaldate.getMonth() < 9 ? '0':'') + (newcaldate.getMonth()+1) + '/'
		+ newcaldate.getFullYear();
	calndr_hidn[calendarid].value = dmy;
}
function calndr_set(calendarid) {
	var newcaldate = caldate[calendarid];
	var currentDate = newcaldate.getDate();
	var newyrctl = calndr_form[calendarid]['calformyr'+calendarid];
	if (! newyrctl.value.match(/^[0-9]{1,4}$/)) {
		newyrctl.value = newcaldate.getFullYear();
	}
	var newyr = parseInt(newyrctl.value);
	if (isNaN(newyr) || newyr < 1900 || newyr > 9999) {
		newyrctl.style.color = 'red';
		return;
	}
	newyrctl.style.color = 'black';
	newcaldate = new Date(newyr,
		calndr_form[calendarid]['calformmo'+calendarid].value-1, currentDate);
	if (newcaldate.getDate() != currentDate && currentDate > 28) {
		newcaldate.setDate(0);
	}
	if (newcaldate.getTime() != caldate[calendarid].getTime()) {
		caldate[calendarid] = newcaldate;
		calndr_print(calendarid);
	}
	var dmy = (newcaldate.getDate() < 10 ? '0':'') + newcaldate.getDate() + '/' 
		+ (newcaldate.getMonth() < 9 ? '0':'') + (newcaldate.getMonth()+1) + '/'
		+ newcaldate.getFullYear();
	calndr_hidn[calendarid].value = dmy;
}
function calndr_tdclick(n,calendarid,td) {
	var firstdate = new Date(caldate[calendarid].getFullYear(), caldate[calendarid].getMonth(), 1);
	var dateOfMonth = n - firstdate.getDay();
	if (dateOfMonth < 1) {
		calndr_add(-1,calendarid);
	} else if (dateOfMonth > lastDateOfMonth[calendarid]) {
		calndr_add(+1,calendarid);
	} else {
		var value = new Date(caldate[calendarid].getFullYear(), caldate[calendarid].getMonth(), dateOfMonth);
		caldate[calendarid] = value;
		if (calndr_seltd[calendarid] != null) {
			calndr_seltd[calendarid].className = 'calndr_style';
		}
		calndr_print(calendarid);
		calndr_seltd[calendarid] = td;
		td.className = 'calndr_style calndr_selected';
		var strMonth = value.getMonth()+1;
		if (strMonth < 10) strMonth = '0' + strMonth;
		var dmy = (dateOfMonth < 10 ? '0':'') + dateOfMonth + '/' + strMonth + '/' + value.getFullYear();
		calndr_hidn[calendarid].value = dmy;
		eval(calndr_evnt[calendarid]);
	}
}
function calndr_tdover(td){
	// falta ajustar el hoy
	return;
	td.className = 'calndr_style calndr_selected';
}
function calndr_tdout(td,calendarid){
	// falta ajustar el hoy
	return;
	td.className = (calndr_seltd[calendarid] == td) ? 'calndr_style calndr_selected' : 'calndr_style';
}
lastDateOfMonth = new Array();
caldate = new Array();
calndr_form = new Array();
calndr_hidn = new Array();
calndr_evnt = new Array();
calndr_seltd = new Array();
</cfif>
<!--- inicializar calendario --->
lastDateOfMonth[#Request.calendarid#] = 31;
calndr_form[#Request.calendarid#] = document.#Attributes.form#;
calndr_hidn[#Request.calendarid#] = document.#Attributes.form#.#Attributes.name#;
calndr_evnt[#Request.calendarid#] = '#JSStringFormat(Attributes.onChange)#';
calndr_seltd[#Request.calendarid#] = null;
caldate[#Request.calendarid#] = new Date(#Year(Attributes.value)#, #Month(Attributes.value)-1#, #Day(Attributes.value)#);
calndr_add(0,#Request.calendarid#);
//-->
</script>

</cfoutput>
