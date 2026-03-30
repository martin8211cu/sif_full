<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_listdata" default="1">
<cfparam name="url.desde" default="-1">
<cfparam name="url.hacia" default="-1">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<cfquery datasource="#session.dsn#" name="listdata">
select t.desde, t.hacia,
	s1.nombre_estado as nombre_desde,
	s2.nombre_estado as nombre_hacia
from Transiciones t, Estado s1, Estado s2
where t.desde = s1.estado
  and t.hacia = s2.estado
</cfquery>
<cfquery datasource="#session.dsn#" name="estado">
select estado, nombre_estado
from Estado
order by estado
</cfquery>

<cfquery datasource="#session.dsn#" name="data">
select desde,hacia
from Transiciones 
where desde = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.desde#">
  and hacia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.hacia#">
</cfquery>
<cfif data.RecordCount GT 0><cfset modo="CAMBIO"><cfelse><cfset modo="ALTA"></cfif>

<cfset MaxRows_listdata=20>
<cfset StartRow_listdata=Min((PageNum_listdata-1)*MaxRows_listdata+1,Max(listdata.RecordCount,1))>
<cfset EndRow_listdata=Min(StartRow_listdata+MaxRows_listdata-1,listdata.RecordCount)>
<cfset TotalPages_listdata=Ceiling(listdata.RecordCount/MaxRows_listdata)>
<cfset QueryString_listdata=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_listdata,"PageNum_listdata=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_listdata=ListDeleteAt(QueryString_listdata,tempPos,"&")>
</cfif>
<html><!-- InstanceBegin template="/Templates/Tienda-admin.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> 
	<cfinclude template="/sif/portlets/pubica.cfm">  
	 </td>
  </tr>
  <tr> 
    <td valign="top">
	 
        
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  <cfinclude template="../config/select-tienda.cfm">
		  </td>
          <td width="50%">
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Configurar
            tienda</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap><cfinclude template="menu.cfm" ></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      	
	
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="84" align="left" valign="top" nowrap></td> 
    <td width="3" align="left" valign="top" nowrap></td>
    <td width="661" height="1" align="left" valign="top">
	   
      </td>
  </tr>
  <tr>
    <td width="1%" align="left" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td width="3" align="left" valign="top" nowrap></td> 
    <td valign="top" width="100%">
	<!-- InstanceBeginEditable name="portletMantenimientoInicio" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Titulo">
	<!-- InstanceEndEditable -->		
	

<!-- InstanceBeginEditable name="Contenido" -->
<form action="transicion_go.cfm" method="post" name="fdata"><table width="100%" border="0">
  <tr>
    <td valign="middle" align="center"><table border="0" cellpadding="2" cellspacing="0" width="100%" align="center">
        <tr>
          <td class="listaCorte">Desde</td>
          <td class="listaCorte">Hacia</td>
        </tr>
        <cfoutput query="listdata" startrow="#StartRow_listdata#" maxrows="#MaxRows_listdata#">
          <tr class="<cfif listdata.CurrentRow MOD 2 EQ 0>listaPar<cfelse>listaNon</cfif>">
            <td><a href="transicion.cfm?desde=#listdata.desde#&hacia=#listdata.hacia#">#listdata.nombre_desde#</a></td>
            <td><a href="transicion.cfm?desde=#listdata.desde#&hacia=#listdata.hacia#">#listdata.nombre_hacia#</a></td>
          </tr>
        </cfoutput>
      </table>
      <table border="0" width="50%" align="center">
        <cfoutput>
          <tr>
            <td width="23%" align="center">
              <cfif PageNum_listdata GT 1>
                <a href="#CurrentPage#?PageNum_listdata=1#QueryString_listdata#"><img src="First.gif" border=0></a>
              </cfif>
            </td>
            <td width="31%" align="center">
              <cfif PageNum_listdata GT 1>
                <a href="#CurrentPage#?PageNum_listdata=#Max(DecrementValue(PageNum_listdata),1)##QueryString_listdata#"><img src="Previous.gif" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center">
              <cfif PageNum_listdata LT TotalPages_listdata>
                <a href="#CurrentPage#?PageNum_listdata=#Min(IncrementValue(PageNum_listdata),TotalPages_listdata)##QueryString_listdata#"><img src="Next.gif" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center">
              <cfif PageNum_listdata LT TotalPages_listdata>
                <a href="#CurrentPage#?PageNum_listdata=#TotalPages_listdata##QueryString_listdata#"><img src="Last.gif" border=0></a>
              </cfif>
            </td>
          </tr>
        </cfoutput>
      </table></td>
    <td valign="top"><table width="100%" border="0">
      <tr>
        <td>Desde</td>
        <td><select name="desde">
		<option value="">[ seleccione ]</option>
		<cfoutput query="estado"><option value="#estado#" <cfif estado eq url.desde>selected</cfif> >#nombre_estado#</option></cfoutput>
        </select></td>
      </tr>
      <tr>
        <td>Hacia</td>
        <td><select name="hacia">
		<option value="">[ seleccione ]</option>
		<cfoutput query="estado"><option value="#estado#" <cfif estado eq url.hacia>selected</cfif> >#nombre_estado#</option></cfoutput>
        </select></td>
      </tr>
      <tr>
        <td colspan="2"><cfinclude template="/sif/portlets/pBotones.cfm"></td>
        </tr>
    </table></td>
  </tr>
</table></form>
<!-- InstanceEndEditable -->

	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
