<cfparam name="Session.modulo" default="index">
<cfparam name="Session.Idioma" default="">

<cfif isdefined("Form.Idioma")>
	<cfset Session.Idioma = Form.idioma>
</cfif>
<cfset Session.modulo = 'index'>

<cfinclude template="portlets/pEmpresas2.cfm">
<cflocation url="/cfmx/home/menu/sistema.cfm?s=SIF">
<cfabort>

<html>
<head>
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<title>Index SIF</title>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
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
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
  <tr> 
    <td width="1%"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td width="38%" valign="baseline" class="area"><cfinclude template="portlets/pEmpresas2.cfm"></td>
    <td width="50%" valign="top" class="area"> 
      <div align="center"><font face="Arial, Helvetica, sans-serif"><font size="+2">
		<cfoutput>#Request.Translate('Titulo','','/sif/Utiles/Generales.xml','#Session.Idioma#')#</cfoutput>
		</font></font></div></td>
  </tr>
  <tr> 
    <td width="1%" rowspan="3" align="center" valign="top"><cfinclude template="Utiles/Idiomas.cfm">
	</td>
    <td colspan="2"><cfinclude template="/sif/portlets/pubica.cfm"></td>
  </tr>
  <tr> 
    <td colspan="2"> <div align="center" class="tituloAlterno">
	<cfoutput>#Request.Translate('Greeting','¡Bienvenido al Sistema Financiero Integral!','/sif/Utiles/Generales.xml','#Session.Idioma#')#</cfoutput>	
	</div></td>
  </tr>
  <tr> 
    <td height="1" colspan="2"><font size="-7">&nbsp;</font></td>
  </tr>  
  <tr> 
    <td width="1%" valign="top">
	<cfinclude template="menu.cfm">
	</td>
    <td colspan="2" rowspan="2" valign="top"> 
		<!--- Verifica si los parámetros generales están definidos para esa empresa en base a un parámetro --->
		<cfquery name="rsParametrosGenDef" datasource="#Session.DSN#">
			select Pvalor from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Pcodigo = 5
		</cfquery>
		
		<!--- mensaje en caso de que no estén definidos los parámetros --->
		<cfset mensaje = "">
		<cfset parametrosDefinidos = true>			
		<cfif rsParametrosGenDef.RecordCount EQ 0>
			<cfset parametrosDefinidos = false>
			<cfset mensaje = "¡No se han definido los parámetros generales! <br>Debe definirlos en el apartado de Administración.">
		<cfelseif rsParametrosGenDef.Pvalor EQ "N">
			<cfset parametrosDefinidos = false>
			<cfset mensaje = "¡No se han definido los parámetros generales! <br>Debe definirlos en el apartado de Administración.">
		</cfif>
		
		<table  border="0" cellpacing="0" cellpading="0" align="center" >
        <tr> 
          <td width='1'>&nbsp;</td>
          <td colspan="6" class="subTitulo">&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td colspan="6" class="subTitulo"><strong> <cfoutput>#Request.Translate('Opcion','Seleccione una Opción:')#</cfoutput> </strong></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td colspan="6">&nbsp;</td>
        </tr>
        <tr> 
          <td width='1'>&nbsp;</td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href='/cfmx/sif/cg/MenuCG.cfm'></cfif><img src='/cfmx/sif/imagenes/Contabilidad01_T.gif' border="0"><cfif parametrosDefinidos ></a></cfif></font></td>
          <td valign="middle"><font size="2"><cfif parametrosDefinidos ><a href='/cfmx/sif/cg/MenuCG.cfm'></cfif> 
            <cfoutput>#Request.Translate('ModuloCG','','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif></font></td>
          <td width='19'><font size="2">&nbsp;</font></td>
          <td width='37' ><font size="2"><cfif parametrosDefinidos ><a href="/cfmx/sif/an/MenuAn.cfm"></cfif><img src='/cfmx/sif/imagenes/Anexos01.gif' border="0"><cfif parametrosDefinidos ></a></cfif></font></td>
          <td width='160' valign="middle"><font size="2"><cfif parametrosDefinidos ><a href="/cfmx/sif/an/MenuAn.cfm"></cfif> 
            <cfoutput>#Request.Translate('ModuloAN','','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif></font></td>
          <td width='17'>&nbsp;</td>
        </tr>
        <tr> 
          <td width='1'>&nbsp;</td>
          <td colspan="2"><font size="2">&nbsp;</font><font size="2">&nbsp;</font></td>
          <td width='19'><font size="2">&nbsp;</font></td>
          <td >&nbsp;</td>
          <td>&nbsp;</td>
          <td width='17'>&nbsp;</td>
        </tr>
        <tr> 
          <td width='1'>&nbsp;</td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href="/cfmx/sif/cp/MenuCP.cfm"></cfif><img src='/cfmx/sif/imagenes/CxP01_T.gif' border="0"><cfif parametrosDefinidos ></a></cfif></font></td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href="/cfmx/sif/cp/MenuCP.cfm"></cfif> 
            <cfoutput>#Request.Translate('ModuloCP','','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif></font></td>
          <td width='19'><font size="2">&nbsp;</font></td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href='/cfmx/sif/af/MenuAF.cfm'></cfif><img src='/cfmx/sif/imagenes/Computer01_T2.gif' border="0"><cfif parametrosDefinidos ></a></cfif></font></td>
          <td><font size="2"><cfif parametrosDefinidos ><a href='/cfmx/sif/af/MenuAF.cfm'></cfif> 
            <cfoutput>#Request.Translate('ModuloAF','','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif></font></td>
          <td width='17'>&nbsp;</td>
        </tr>
        <tr> 
          <td width='1'>&nbsp;</td>
          <td colspan="2"><font size="2">&nbsp;</font><font size="2">&nbsp;</font></td>
          <td width='19'><font size="2">&nbsp;</font></td>
          <td >&nbsp;</td>
          <td >&nbsp;</td>
          <td width='17'>&nbsp;</td>
        </tr>
        <tr> 
          <td width='1'>&nbsp;</td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href="/cfmx/sif/cc/MenuCC.cfm"></cfif><img src='/cfmx/sif/imagenes/CxC01_T.gif' border="0"><cfif parametrosDefinidos ></a></cfif></font></td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href="/cfmx/sif/cc/MenuCC.cfm"></cfif> 
            <cfoutput>#Request.Translate('ModuloCC','','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif></font></td>
          <td width='19'><font size="2">&nbsp;</font></td>
          <td ><font size="2"> <cfif parametrosDefinidos ><a href="/cfmx/sif/iv/MenuIV.cfm"></cfif> 
            <img src='/cfmx/sif/imagenes/Inventarios01_T.gif' border="0"> <cfif parametrosDefinidos ></a></cfif></font></td>
          <td valign="middle"><font size="2"> <cfif parametrosDefinidos ><a href="/cfmx/sif/iv/MenuIV.cfm"></cfif> 
            <cfoutput>#Request.Translate('ModuloIN','','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif> </font></td>
          <td width='17'>&nbsp;</td>
        </tr>
        <tr> 
          <td width='1'>&nbsp;</td>
          <td colspan="2"><font size="2">&nbsp;</font><font size="2">&nbsp;</font></td>
          <td width='19'><font size="2">&nbsp;</font></td>
          <td >&nbsp;</td>
          <td valign="middle">&nbsp;</td>
          <td width='17'>&nbsp;</td>
        </tr>
        <tr> 
          <td width='1'>&nbsp;</td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href="/cfmx/sif/mb/MenuMB.cfm"></cfif><img src='/cfmx/sif/imagenes/Bancos01_T.gif' border="0"><cfif parametrosDefinidos ></a></cfif></font></td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href="/cfmx/sif/mb/MenuMB.cfm"></cfif> 
            <cfoutput>#Request.Translate('ModuloMB','Bancos','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif></font></td>
          <td width='19'><font size="2">&nbsp;</font></td>
          <td ><font size="2"> <cfif parametrosDefinidos><a href='/cfmx/sif/cm/MenuCM.cfm'></cfif> 
            <img src='/cfmx/sif/imagenes/Shopping.gif' border="0"> <cfif parametrosDefinidos></a></cfif> 
            </font></td>
          <td> <font size="2"><cfif parametrosDefinidos ><a href='/cfmx/sif/cm/MenuCM.cfm'></cfif> 
            <cfoutput>#Request.Translate('ModuloCM','','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif></font> </td>
          <td width='17'>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td colspan="2" ><font size="2">&nbsp;</font><font size="2">&nbsp;</font></td>
          <td><font size="2">&nbsp;</font></td>
          <td >&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>

        <tr> 
          <td>&nbsp;</td>
          <td ><font size="2"> 
            <cfif parametrosDefinidos >
            </cfif>
            <a href="/cfmx/sif/fa/MenuFA.cfm"><img src='/cfmx/sif/imagenes/Fac01_T.gif' border="0"></a> 
            <cfif parametrosDefinidos >
              <a href="/cfmx/sif/fa/MenuFA.cfm"></a> 
            </cfif>
            </font></td>
          <td ><font size="2"> 
            <cfif parametrosDefinidos >
            </cfif>
            <a href="/cfmx/sif/fa/MenuFA.cfm"> <cfoutput>#Request.Translate('ModuloFA','Facturación','/sif/Utiles/Generales.xml')#</cfoutput> </a> 
            <cfif parametrosDefinidos >
              <a href="/cfmx/sif/fa/MenuFA.cfm"></a> 
            </cfif>
            </font></td>
          <td><font size="2">&nbsp;</font></td>
          <td ><font size="2"><img src='/cfmx/sif/imagenes/Tesoreria.gif' border="0"></font></td>
          <td><font size="2"><cfoutput>#Request.Translate('ModuloTS','Tesorería','/sif/Utiles/Generales.xml')#</cfoutput></font></td>
          <td>&nbsp;</td>
        </tr>

        <tr> 
          <td>&nbsp;</td>
          <td colspan="2" ><font size="2">&nbsp;</font><font size="2">&nbsp;</font></td>
          <td><font size="2">&nbsp;</font></td>
          <td >&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>

        <tr> 
          <td>&nbsp;</td>
          <td ><font size="2"><a href="/cfmx/sif/ad/MenuAD.cfm"><img src='/cfmx/sif/imagenes/Check01_T.gif' border="0"></a></font></td>
          <td valign="middle"><font size="2"><a href="/cfmx/sif/ad/MenuAD.cfm"> <cfoutput>#Request.Translate('ModuloAD','','/sif/Utiles/Generales.xml')#</cfoutput> </a></font></td>
          <td><font size="2">&nbsp;</font></td>
          <td ><font size="2"><cfif parametrosDefinidos ><a href='/cfmx/sif/admin/MenuAdmin.cfm'></cfif><img src='/cfmx/sif/imagenes/Graficos02_T.gif' border="0"><cfif parametrosDefinidos ></a></cfif></font></td>
          <td valign="middle"><font size="2"><cfif parametrosDefinidos ><a href='/cfmx/sif/admin/MenuAdmin.cfm'></cfif> 
            <cfoutput>#Request.Translate('ModuloAdmin','','/sif/Utiles/Generales.xml')#</cfoutput> <cfif parametrosDefinidos ></a></cfif></font></td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td >&nbsp;</td>
          <td valign="middle">&nbsp;</td>
          <td>&nbsp;</td>
          <td >&nbsp;</td>
          <td valign="middle">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td colspan="2" ><font size="2">&nbsp;</font><font size="2">&nbsp;</font></td>
          <td><font size="2">&nbsp;</font></td>
          <td >&nbsp;</td>
          <td valign="middle"><a href="/cfmx/sif/hh/MenuHH.cfm">&nbsp;</a></td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td colspan='7'><div align="center" class="etiqueta"><font color="#FF0000"><cfoutput>#mensaje#</cfoutput></font></div></td>
        </tr>


      </table></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;
	
	</td>
  </tr>
</table>
</body>
<cfset monitoreo_modulo="sif">
<cfinclude template="/sif/monitoreo.cfm">
</html>