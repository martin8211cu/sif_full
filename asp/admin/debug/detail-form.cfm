<cfset classNames = ListToArray('listaNon,listaPar')>
<cfparam name="url.debugid" type="numeric">
<cfset TimeThreshold = 250>

<cfquery datasource="aspmonitor" name="MonDebugQRequest">
	SELECT uri, args, executionTime, memoryDelta, ip, login, method, requested
	FROM MonDebugQRequest
	WHERE debugid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.debugid#">
</cfquery>
<cfquery datasource="aspmonitor" name="MonDebugQSummary">
	SELECT template, totalExecutionTime, avgExecutionTime, instanceCount
	FROM MonDebugQSummary
	WHERE debugid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.debugid#">
</cfquery>
<cfquery datasource="aspmonitor" name="MonDebugQSQL">
	SELECT template, line, fecha, executionTime, queryName, datasource, sqlText, queryParams, totalRows
	FROM MonDebugQSQL
	WHERE debugid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.debugid#">
</cfquery>
<cfquery datasource="aspmonitor" name="MonDebugQException">
	SELECT *
	FROM MonDebugQException
	WHERE debugid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.debugid#">
</cfquery>
<cfquery datasource="aspmonitor" name="MonDebugQScopeVars">
	SELECT scope, name, value
	FROM MonDebugQScopeVars
	WHERE debugid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.debugid#">
	order by scope, name
</cfquery>
<cfquery datasource="aspmonitor" name="GetErrorID">
	SELECT value
	FROM MonDebugQScopeVars
	WHERE debugid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.debugid#">
	  AND scope = 'url'
	  AND name = 'ERRORID'
</cfquery>

<script type="text/javascript">
<!--
/* 
 * Changed imgObj to imgObjName to allow a link to control the tree as well
 */
function showHide( targetName, imgObjName ) {
    var target;
    var imgObj;
    if( imgObjName ) { 
        imgObj = eval("document." + imgObjName); 
    }
    
    if( document.getElementById ) { // NS6+
        target = document.getElementById(targetName);
    } else if( document.all ) { // IE4+
        target = document.all[targetName];
    }
    
    // only attempt the show hide if a target is found, could be looking at user's other cookie name that doesn't fit as a node name
    if( target ) {
        // IE & NS6 like 'none'/'block', a value is needed for the cookie
        if( target.style.display == "none" ) {
            target.style.display = "block";
        } else {
            target.style.display = "none";
        }
    }

    if( imgObj ) {
        var imgPath = imgObj.src;
        if( imgPath ) {
            imgPath = imgPath.substring(0,imgPath.lastIndexOf("/")) + "/";
            if( imgObj.src == imgPath + "close.gif" ) {
                imgObj.src = imgPath + "open.gif";
            } else {
                imgObj.src = imgPath + "close.gif";
            }
        }
    }
} // showHide
//-->
</script>
<style>  
a 				{text-decoration:none;} 
a:hover 		{text-decoration:underline; color:#339900;} 
.link		 	{font-family:tahoma,arial,geneva,sans-serif; font-size: .7em; line-height:1.25em;} 
a.link:hover	{text-decoration:underline; color:#66ff66;} 
.buttn 			{font-size:.7em;font-family: tahoma,arial,Geneva,Helvetica,sans-serif;background-color:#e0e0d5;}

.color-title	{background-color:#888885;color:white;background-color:#7A8FA4;} 
.color-header	{background-color:#ddddd5;} 
.color-buttons	{background-color:#ccccc5;} 
.color-border	{background-color:#666666;} 
.color-row		{background-color:#fffff5;} 
.color-rowalert	{background-color:#ffddaa;} 
.combined-crimson {background-color: #dc143c; color: white; font-size: 8pt;} 
.combined-steelblue { font-weight:bold; color: 666666; font-size: 8pt;} 
kkk.combined-steelblue {background-color: #eecc99; color: 660000; font-size: 8pt;} 

.label,.text 	{font-size:.7em;font-family: tahoma,arial,Geneva,Helvetica,sans-serif;} 
.nospace		{line-height:2px;} 
.sentance,ul {font-size:.75em;	line-height:1.5em;	font-family: arial,Geneva,Helvetica,sans-serif;} 
td,p			{font-family: tahoma,arial,Geneva,Helvetica,sans-serif;} 	
th				{text-align:left;font-weight:normal;} 	
b,.b {font-weight:bold;} 
.text_bold {font-weight:bold;} 
.h3,h3 			{font-size:.9em;line-height:1.2em;font-family:arial,geneva,helvetica,sans-serif;} 	
.pagedivider	{font-size:.9em;line-height:1.2em;font-family:arial,geneva,helvetica,sans-serif;} 	
.itemdivider {background-color: silver;} 
pre {color: maroon; font-size: 8pt;}

.template  {color: black; font-size:.7em;font-family: tahoma,arial,Geneva,Helvetica,sans-serif; font-weight: normal;}  
.template_overage   {color: red; font-size:.7em;font-family: tahoma,arial,Geneva,Helvetica,sans-serif; font-weight: bold;}

img {cursor: pointer; }  
</style>
<cfoutput>
<table class="color-border" bgcolor="##999999" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td><table border="0" cellpadding="2" cellspacing="1" width="100%">
<tbody>
<tr class="color-title">
<td colspan="2" height="20"><font class="label">&nbsp; <b class="form-title">Datos Generales </b></font></td>
</tr>
<tr class="color-header">
<td valign="top" nowrap="nowrap"><font class="label">&nbsp; Página &nbsp;</font></td>
<td class="color-row" width="100%" valign="top"><font class="label">&nbsp; #MonDebugQRequest.method# #MonDebugQRequest.uri#</font></td>
</tr>
<tr class="color-header">
<td valign="top" nowrap="nowrap"><font class="label">&nbsp; Argumentos &nbsp;</font></td>
<td class="color-row" width="100%" valign="top" style="padding-left:8px"><font class="label">
# Replace( HTMLEditFormat( MonDebugQRequest.args), '&amp;', '&amp; ','all')#
</font></td>
</tr>
<tr class="color-header">
<td valign="top" nowrap="nowrap"><font class="label">&nbsp; Usuario &nbsp;</font></td>
<td class="color-row" width="100%" valign="top"><font class="label">&nbsp; #MonDebugQRequest.login# @ #MonDebugQRequest.ip#</font></td>
</tr>
<tr class="color-header">
<td valign="top" nowrap="nowrap"><font class="label">&nbsp; Duración &nbsp;</font></td>
<td class="color-row" width="100%" valign="top"><font class="label">&nbsp; #NumberFormat( MonDebugQRequest.executionTime)# &nbsp;</font></td>
</tr>
<tr class="color-header">
<td valign="top" nowrap="nowrap"><font class="label">&nbsp; Diferencial de memoria &nbsp;</font></td>
<td class="color-row" width="100%" valign="top"><font class="label">&nbsp; #NumberFormat( MonDebugQRequest.memoryDelta)# &nbsp;</font></td>
</tr>
<tr class="color-header">
<td valign="top" nowrap="nowrap"><font class="label">&nbsp; Fecha &nbsp;</font></td>
<td class="color-row" valign="top"><font class="label">&nbsp; #DateFormat(MonDebugQRequest.requested)# #TimeFormat(MonDebugQRequest.requested)#&nbsp;</font></td>
</tr>
<cfif Len(Trim(GetErrorID.value))>
<tr class="color-header">
<td valign="top" nowrap="nowrap"><font class="label">&nbsp; Error Núm #GetErrorID.value#&nbsp;</font></td>
<td class="color-row" valign="top"><font class="label">&nbsp; <a href="../errores/index.cfm?id=#GetErrorID.value#">Haga clic para ver el error completo</a>&nbsp;</font></td>
</tr></cfif>
</tbody>
</table></td>
</tr>
</tbody>
</table></cfoutput>
<!-- DEBUG DATA --->
<table class="color-border" bgcolor="#999999" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td><table border="0" cellpadding="2" cellspacing="1" width="100%">
<tbody>
<tr class="color-title">
<td height="20"><font class="label">&nbsp; <b class="form-title">Detalles de Ejecución</b></font></td>
</tr>
</tbody>
</table>
<table border="0" cellpadding="4" cellspacing="1" width="100%">
<tbody>
<tr class="color-header">
<td><table border="1" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr class="color-row">
<td><div id="cf_debug_debug_data" style="display: block;">
<!-- EXCEPTIONS -->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr bgcolor="#ffffdd">
<td><img name="img_cf_debug_exceptions" src="/cfmx/CFIDE/debug/images/close.gif" alt="" onclick="showHide('cf_debug_exceptions', this.name);" border="0" height="9" hspace="4" vspace="4" width="9"></td>
<td width="100%"><a href="javascript:showHide('cf_debug_exceptions','img_cf_debug_exceptions');" class="label">Excepciones</a></td>
</tr>
</tbody>
</table>
<table bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td height="1"></td>
</tr>
</tbody>
</table>
<div id="cf_debug_exceptions" style="display: block;">
<table border="0" cellpadding="0" cellspacing="0">
<tbody>
<cfoutput query="MonDebugQException">
<tr>
<td width="16">&nbsp;</td>
<td><table border="0" cellpadding="2" cellspacing="0">
<tbody>
<tr>
<td colspan="3" class="combined-crimson">#HTMLEditFormat(template)# (#line#) @ #TimeFormat(fecha,'HH:mm:ss.lll')#</td>
</tr>
<tr>
<td class="label">&nbsp;</td>
<td class="label">tipo</td>
<td class="label">#HTMLEditFormat(exceptionType)#</td>
</tr>
<tr>
<td class="label">&nbsp;</td>
<td class="label">mensaje</td>
<td class="label">#HTMLEditFormat(message)#</td>
</tr>
<tr>
<td class="label">&nbsp;</td>
<td class="label" valign="top">llamados</td>
<td class="label" valign="top">#Replace(HTMLEditFormat(templateStackTrace),Chr(10),'<br />','all')#</td>
</tr>
<tr>
<td class="label" valign="top"><img name="img_cf_debug_javastack#CurrentRow#" src="/cfmx/CFIDE/debug/images/open.gif" alt="" onclick="showHide('cf_debug_javastack#CurrentRow#', this.name);" border="0" height="9" hspace="0" vspace="0" width="9"></td>
<td valign="top">
<a href="javascript:showHide('cf_debug_javastack#CurrentRow#','img_cf_debug_javastack#CurrentRow#');" class="label">StackTrace</a></td>
<td class="label" valign="top"><div id="cf_debug_javastack#CurrentRow#" style="display:none;width:100%;overflow:hidden">#Replace(HTMLEditFormat(javaStackTrace),Chr(10),'<br />','all')#</div></td>
</tr>
</tbody>
</table></td>
</tr>
<tr>
<td colspan="2" class="itemdivider" height="1"></td>
</tr></cfoutput>

</tbody>
</table>
</div>
<!-- cf_debug_exceptions -->
<!-- GENERAL -->
<table bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td height="1"></td>
</tr>
</tbody>
</table>
<!-- cf_debug_general -->
<!-- TEMPLATE STACK -->
<table bgcolor="#ffffdd" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td><img name="img_cf_debug_template_stack" src="/cfmx/CFIDE/debug/images/open.gif" alt="" onclick="showHide('cf_debug_template_stack', this.name);" border="0" height="9" hspace="4" vspace="4" width="9"></td>
<td width="100%"><a href="javascript:showHide('cf_debug_template_stack','img_cf_debug_template_stack');" class="label">Tiempos de Ejecución </a></td>
</tr>
</tbody>
</table>
<table bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td height="1"></td>
</tr>
</tbody>
</table>
<div id="cf_debug_template_stack" style="display: none;">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td width="16">&nbsp;</td>
<td><table border="0" cellpadding="2" cellspacing="0">
<tbody>
<tr>
<td class="label" align="center" colspan="2"><b>Tiempo</b></td>
<td class="label" align="center">&nbsp;</td>
<td class="label">&nbsp;</td>
</tr>
<tr>
<td class="label" align="center"><b>Total</b></td>
<td class="label" align="center"><b>Promedio</b></td>
<td class="label" align="center"><b>Cantidad</b></td>
<td class="label"><b>Ruta</b></td>
</tr>
<tr>
<td colspan="4" class="itemdivider" height="1"></td>
</tr>
<cfoutput query="MonDebugQSummary">
<tr>
<td class="label" align="right">#NumberFormat(totalExecutionTime)# ms</td>
<td class="label" align="right">
<cfif avgExecutionTime GT TimeThreshold>
<font color="red"><span style="color: red;"></cfif>#NumberFormat(avgExecutionTime)# 
<cfif avgExecutionTime GT TimeThreshold></span></font></cfif> ms</td>
<td class="label" align="center">
<cfif avgExecutionTime GT TimeThreshold>
<font color="red"><span style="color: red;"></cfif>#NumberFormat(instanceCount)# 
<cfif avgExecutionTime GT TimeThreshold></span></font></cfif> ms</td>
<td class="label" align="left">
<cfif avgExecutionTime GT TimeThreshold>
<font color="red"><span style="color: red;"></cfif>
#HTMLEditFormat(template)#
<cfif avgExecutionTime GT TimeThreshold></span></font></cfif></td>
</tr>
<tr>
<td colspan="4" class="itemdivider" height="1"></td>
</tr></cfoutput>
<tr>
<td colspan="4" class="itemdivider" height="1"></td>
</tr>
<tr>
<td class="label" align="right"><cfoutput>#NumberFormat(MonDebugQRequest.executionTime)#</cfoutput> ms</td>
<td colspan="2">&nbsp;</td>
<td class="label" align="left">TIEMPO TOTAL DE EJECUCIÓN</td>
</tr>
</tbody>
</table>
<span class="template_overage">rojo = más de <cfoutput>#NumberFormat(TimeThreshold)#</cfoutput> ms de tiempo promedio</span> </td>
</tr>
<tr>
<td height="10"></td>
</tr>
<tr>
<td colspan="2" bgcolor="#999999" height="1"></td>
</tr>
</tbody>
</table>
</div>
<!-- cf_debug_template_stack -->
<!-- SQL QUERIES -->
<table bgcolor="#ffffdd" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td><img name="img_cf_debug_sql_queries" src="/cfmx/CFIDE/debug/images/open.gif" alt="" onclick="showHide('cf_debug_sql_queries', this.name);" border="0" height="9" hspace="4" vspace="4" width="9"></td>
<td width="100%"><a href="javascript:showHide('cf_debug_sql_queries','img_cf_debug_sql_queries');" class="label">Consultas SQL</a></td>
</tr>
</tbody>
</table>
<table bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td height="1"></td>
</tr>
</tbody>
</table>
<div id="cf_debug_sql_queries" style="display: none;">
<table bgcolor="#fffff5" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<cfoutput query="MonDebugQSQL">
<tr>
<td width="16">&nbsp;</td>
<td><table border="0" cellpadding="2" cellspacing="0" width="100%">
<tbody>
<tr>
<td colspan="2">
<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" class="combined-steelblue">
#HTMLEditFormat(template)# (#line#) @ #TimeFormat(fecha, 'HH:mm:ss.lll')# -
<em>#HTMLEditFormat(queryName)#</em></td><td align="right">#NumberFormat(executionTime) #ms</td></tr></table></td>
</tr>
<tr>
<td colspan="2" class="itemdivider" height="1"></td>
</tr>
<tr>
<td class="label" height="18" nowrap="nowrap">Nombre &nbsp; &nbsp;</td>
<td class="label" width="100%">#HTMLEditFormat(queryName)# </td>
</tr>
<tr valign="top">
<td class="label" height="18" nowrap="nowrap">Instrucción &nbsp; &nbsp;</td>
<td class="label">
<pre># sqlText# <cfif Len(sqlText) is 1000> &hellip; </cfif></pre>
</td>
</tr>
<tr>
<td class="label" height="18" nowrap="nowrap">Conexión &nbsp; &nbsp;</td>
<td class="label">#HTMLEditFormat(datasource)#</td>
</tr>
<tr>
<td class="label" height="18" nowrap="nowrap">Registros &nbsp; &nbsp;</td>
<td class="label">#NumberFormat(totalRows) #</td>
</tr>
<tr>
<td class="label" height="18" nowrap="nowrap">Duración &nbsp; &nbsp;</td>
<td class="label">#NumberFormat(executionTime) #ms</td>
</tr>
<cfif Len(queryParams) GT 1>
<tr>
<td colspan="2"><!-- PARAMETER LIST -->
<table border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td><img name="img_cf_debug_cfdebug_queries_parameters#CurrentRow#" src="/cfmx/CFIDE/debug/images/open.gif" alt=""
onclick="showHide('cf_debug_cfdebug_queries_parameters#CurrentRow#', this.name);" border="0" height="9" hspace="4" vspace="4" width="9"></td>
<td><a href="javascript:showHide('cf_debug_cfdebug_queries_parameters#CurrentRow#','img_cf_debug_cfdebug_queries_parameters#CurrentRow#');" class="label">Parámetros</a></td>
</tr>
</tbody>
</table>
<div id="cf_debug_cfdebug_queries_parameters#CurrentRow#" style="display: none;">
<table border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td width="16">&nbsp;</td>
<td><table border="0" cellpadding="2" cellspacing="0">
<tbody>
<tr>
<td class="label">##</td>
<td class="label">Tipo</td>
<td class="label">Valor</td>
</tr>
<cfset start = 1>
<cfloop condition="1">

<cfset parseParams = REFind('@p([0-9]+): \(([^)]+)\)([^#chr(13)#]*)', queryParams, start, true)>
<cfset start = parseParams.pos[1] + parseParams.len[1] - 1>
<cfif ArrayLen(parseParams.pos) LT 4><cfbreak></cfif>
<tr>
<td class="label">#Mid(queryParams, parseParams.pos[2], parseParams.len[2])#</td>
<td class="label">&nbsp;cf_sql_#Mid(queryParams, parseParams.pos[3], parseParams.len[3])#</td>
<td class="label">&nbsp;<cfif parseParams.len[4]>#Mid(queryParams, parseParams.pos[4], parseParams.len[4])#<cfelse>(vacío)</cfif></td>
</tr>
</cfloop>
</tbody>
</table></td>
</tr>
</tbody>
</table>
</div></td>
</tr></cfif> <!--  if Len(queryParams) -->
<tr>
<td colspan="2" class="itemdivider" height="1"></td>
</tr>
</tbody>
</table></td>
</tr>
</cfoutput>
<tr>
<td height="10"></td>
</tr>
<tr>
<td colspan="2" bgcolor="#999999" height="1"></td>
</tr>
</tbody>
</table>
</div>
<!-- VARIABLES -->
<table bgcolor="#ffffdd" border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td><img name="img_cf_debug_variables" src="/cfmx/CFIDE/debug/images/open.gif" alt="" onclick="showHide('cf_debug_variables', this.name);" border="0" height="9" hspace="4" vspace="4" width="9"></td>
<td width="100%"><a href="javascript:showHide('cf_debug_variables','img_cf_debug_variables');" class="label"> Variables</a></td>
</tr>
<tr>
<td colspan="2" bgcolor="#cccccc" height="1"></td>
</tr>
</tbody>
</table>
<div id="cf_debug_variables" style="display: none;">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td width="16">&nbsp;</td>
<td width="100%">
<cfoutput query="MonDebugQScopeVars" group="scope">
<!-- SESSION -->
<table border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td><img name="img_cf_debug_#scope#" src="/cfmx/CFIDE/debug/images/open.gif" alt=""
onclick="showHide('cf_debug_#scope#', this.name);" border="0" height="9" hspace="4" vspace="4" width="9"></td>
<td><a href="javascript:showHide('cf_debug_#scope#','img_cf_debug_#scope#');" class="label">Variables en # UCase( scope )#</a></td>
</tr>
</tbody>
</table>
<div id="cf_debug_#scope#" style="display: none;">
<table border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td width="16">&nbsp;</td>
<td width="784"><table width="762" border="0" cellpadding="2" cellspacing="0" style="width:600">
<tbody>
<cfoutput>
<tr class="#classNames[CurrentRow mod 2 + 1]#">
<td class="label" width="150">#  HTMLEditFormat(name) #</td>
<td class="label" width="442"><cfif Len(Trim(value))>#  HTMLEditFormat(value) #<cfelse>(sin valor)</cfif></td>
</tr>
<tr>
<td colspan="2" class="itemdivider" height="1"></td>
</tr></cfoutput>
</tbody>
</table></td>
</tr>
</tbody>
</table>
</div>
</cfoutput>
</td>
</tr>
<tr>
<td height="10"></td>
</tr>
<tr>
<td colspan="2" bgcolor="#999999" height="1"></td>
</tr>
</tbody>
</table>
</div>
<!-- cf_debug_parameters -->
</div></td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>
</td>
</tr>
<tr>
<td colspan="3" background="/cfmx/CFIDE/debug/images/homedivider.gif" height="7" width="100%"></td>
</tr>
<tr>
<td colspan="3" bgcolor="#336699" height="1"></td>
</tr>
</tbody>
</table>
