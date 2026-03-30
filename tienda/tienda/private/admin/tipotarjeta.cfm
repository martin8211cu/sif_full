<cfparam name="url.tc_tipo" default="">
<cfquery datasource="#session.dsn#" name="listdata">
	select tc_tipo, nombre_tipo_tarjeta, mascara
	from TipoTarjeta
	order by 2
</cfquery>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_listdata" default="1">
<cfset MaxRows_listdata=10>
<cfset StartRow_listdata=Min((PageNum_listdata-1)*MaxRows_listdata+1,Max(listdata.RecordCount,1))>
<cfset EndRow_listdata=Min(StartRow_listdata+MaxRows_listdata-1,listdata.RecordCount)>
<cfset TotalPages_listdata=Ceiling(listdata.RecordCount/MaxRows_listdata)>
<cfset QueryString_listdata=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_listdata,"PageNum_listdata=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_listdata=ListDeleteAt(QueryString_listdata,tempPos,"&")>
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><!-- InstanceBegin template="/Templates/Tienda-admin.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
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

<cfquery datasource="#session.dsn#" name="data">
	select tc_tipo, nombre_tipo_tarjeta, mascara
	from TipoTarjeta
	where tc_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.tc_tipo#">
</cfquery>
<cfif data.RecordCount GT 0><cfset modo="CAMBIO"><cfelse><cfset modo="ALTA"></cfif>
<table width="100%" border="0">
  <tr>
    <td valign="top"><table border="0" cellpadding="2" cellspacing="0">
        <tr>
          <td class="listaCorte">Siglas</td>
          <td class="listaCorte">Nombre</td>
          <td class="listaCorte">M&aacute;scara</td>
        </tr>
        <cfoutput query="listdata" startrow="#StartRow_listdata#" maxrows="#MaxRows_listdata#">
          <tr class="<cfif listdata.CurrentRow MOD 2 EQ 0>listaPar<cfelse>listaNon</cfif>">
            <td><a href="tipotarjeta.cfm?tc_tipo=#listdata.tc_tipo#">#listdata.tc_tipo#</a></td>
            <td><a href="tipotarjeta.cfm?tc_tipo=#listdata.tc_tipo#">#listdata.nombre_tipo_tarjeta#</a></td>
            <td><a href="tipotarjeta.cfm?tc_tipo=#listdata.tc_tipo#">#listdata.mascara#</a></td>
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
    <td><form name="form1" method="post" action="tipotarjeta_go.cfm">
	<cfoutput>
    <table width="100%" border="0">
      <tr>
        <td>Siglas</td>
        <td><input name="tc_tipo" type="text" id="tc_tipo" value="#data.tc_tipo#" size="30" maxlength="4" onFocus="select()" <cfif Len(data.tc_tipo) GT 0>readonly</cfif>></td>
      </tr>
      <tr>
        <td>Nombre</td>
        <td><input name="nombre_tipo_tarjeta" type="text" id="nombre_tipo_tarjeta" value="#data.nombre_tipo_tarjeta#" size="30" maxlength="30" onFocus="select()"></td>
      </tr>
      <tr>
        <td>M&aacute;scara</td>
        <td><input name="mascara" type="text" id="mascara" value="#data.mascara#" size="30" maxlength="30" onFocus="select()"></td>
      </tr>
      <tr align="center">
        <td colspan="2"><cfinclude template="/sif/portlets/pBotones.cfm">
        </td>
        </tr>
    </table></cfoutput>
    </form></td>
  </tr>
</table>
<!-- InstanceEndEditable -->

	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
