<cfparam name="url.ffecha"   default="">
<cfparam name="url.flogin"   default="">
<cfparam name="url.fcedula"  default="">
<cfparam name="url.festado"  default="">
<cfparam name="url.faccion"  default="">
<cfparam name="url.fimporte" default="">
<cfparam name="url.fpagado"  default="">
<cfparam name="url.filtro"   default="1">

<cfinclude template="isadmin.cfm">
<cfinclude template="../Utiles/general.cfm">

<cfif #url.filtro# EQ 2>
	<cfset Procesado = 1>
	<cfset descripcionfiltro = "procesados">
<cfelse>
	<cfset url.filtro = 1>
	<cfset Procesado = 0>
	<cfset descripcionfiltro = "pendientes">
</cfif>

<cfparam name="PageNum_rs1" default="1">
<cfquery name="rs1x" datasource="sdc">
SELECT
	t.TPID, t.Cedula, t.Importe, t.Avance, t.Pagado,
	isnull (e.EstadoNombre,'-') as EstadoNombre,
	isnull (m.Miso4217, '-') as Miso4217,
	isnull (a.AccionNombre,'-') as AccionNombre,
	isnull (n.AvanceNombre, '-') as AvanceNombre,
	u.Usulogin, u.Pnombre + ' ' + u.Papellido1 + ' ' + u.Papellido2 as Nombre,
	convert (varchar, isnull (t.FechaFin, t.FechaInicio), 103) as Fecha
FROM TramitePasaporte t, TramitePasaporteAccion a, TramitePasaporteEstado e, Moneda m, TramitePasaporteAvance n, Usuario u
WHERE a.Accion =* t.Accion
  and e.Pestado =* t.Pestado
  and m.Mcodigo =* t.Mcodigo
  and n.Avance =* t.Avance
  and u.Usucodigo = t.Usucodigo
  and u.Ulocalizacion = t.Ulocalizacion
  and t.Procesado = <cfqueryparam cfsqltype="cf_sql_bit" value="#Procesado#">
  and convert (varchar, Pagado) like '%' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(url.fpagado)#"> + '%'
  and convert (varchar, isnull (t.FechaFin, t.FechaInicio), 103) like '%' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(url.ffecha)#"> + '%'
</cfquery>

<cfquery dbtype="query" name="rs1">
select * from rs1x
where lower(Usulogin)         like '%#LCase(url.flogin)#%'
  and lower(Cedula)           like '%#LCase(url.fcedula)#%'
  and lower(EstadoNombre)     like '%#LCase(url.festado)#%'
  and lower(AccionNombre)     like '%#LCase(url.faccion)#%'
  and lower(Miso4217)         like '%#LCase(url.fimporte)#%'
</cfquery>


<cfset MaxRows_rs1=10>
<cfset StartRow_rs1=Min((PageNum_rs1-1)*MaxRows_rs1+1,Max(rs1.RecordCount,1))>
<cfset EndRow_rs1=Min(StartRow_rs1+MaxRows_rs1-1,rs1.RecordCount)>
<cfset TotalPages_rs1=Ceiling(rs1.RecordCount/MaxRows_rs1)>

<html><!-- InstanceBegin template="/Templates/Tramites.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<!-- InstanceEndEditable -->
<cf_templatecss>
<cf_templatecss>
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
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="middle"><img src="/cfmx/sif/Imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="top" style="padding-left: 5; padding-bottom: 5;">
	
	<cfinclude template="../portlets/pubica.cfm">  
	
	  </td>
  </tr>
  <tr> 
    <td valign="top">
	 
        
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  <!--- [ Empresas iba aqui ] --->
		  </td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Tr&aacute;mite 
              de Pasaporte</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <!-- InstanceBeginEditable name="Menu" --><cfinclude template="jsTramitesAdmin.cfm" ><!-- InstanceEndEditable --></td>
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
    <td width="84" align="left" valign="top" nowrap>
	  </td>
    <td width="661" height="1" align="left" valign="top">
	   
      </td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap>  
       
	  <cfinclude template="/sif/menu.cfm">
	  </td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="/cfmx/sif/Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->Tr&aacute;mite 
            de Pasaporte<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="/cfmx/sif/Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">

<!-- InstanceBeginEditable name="Contenido" --> 
            <table width="100%" border="0" cellpadding="2">
              <!--DWLayoutTable-->
              <tr> 
                <td width="5">&nbsp;</td>
                <td width="686">&nbsp;</td>
                <td width="1">&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td> <cfif #rs1.RecordCount# EQ 0>
                    <p>No hay tr&aacute;mites <cfoutput>#descripcionfiltro#</cfoutput> por mostrar.</p>
                    <cfelse>
                    <p>Tiene los siguientes tr&aacute;mites <cfoutput>#descripcionfiltro#</cfoutput>:</p>
					</cfif>
					<form method="get" name="fbuscar"><input type="hidden" name="filtro" value="<cfoutput>#filtro#</cfoutput>">
					<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<tr>
                        <td valign="top"><strong>Fecha</strong></td>
                        <td valign="top"><strong>Tramitado por</strong></td>
                        <td valign="top"><strong>N&uacute;mero de c&eacute;dula</strong></td>
                        <td valign="top"><strong>Estado del pasaporte</strong></td>
                        <td valign="top"><strong>Acci&oacute;n solicitada</strong></td>
                        <td valign="top"><strong>Importe</strong></td>
                        <td valign="top"><strong>Pagado</strong></td>
                        <td valign="top"><strong>&nbsp;</strong></td>
                      </tr>
					<tr><cfoutput>
                        <td valign="top"><input type="text" style="width:100%" name="ffecha"   value="#url.ffecha#"   onKeyPress="if (event.keyCode==13) {document.fbuscar.submit();return false}" onFocus="select()"></td>
                        <td valign="top"><input type="text" style="width:100%" name="flogin"   value="#url.flogin#"   onKeyPress="if (event.keyCode==13) {document.fbuscar.submit();return false}" onFocus="select()"></td>
                        <td valign="top"><input type="text" style="width:100%" name="fcedula"  value="#url.fcedula#"  onKeyPress="if (event.keyCode==13) {document.fbuscar.submit();return false}" onFocus="select()"></td>
                        <td valign="top"><input type="text" style="width:100%" name="festado"  value="#url.festado#"  onKeyPress="if (event.keyCode==13) {document.fbuscar.submit();return false}" onFocus="select()"></td>
                        <td valign="top"><input type="text" style="width:100%" name="faccion"  value="#url.faccion#"  onKeyPress="if (event.keyCode==13) {document.fbuscar.submit();return false}" onFocus="select()"></td>
                        <td valign="top"><input type="text" style="width:100%" name="fimporte" value="#url.fimporte#" onKeyPress="if (event.keyCode==13) {document.fbuscar.submit();return false}" onFocus="select()"></td>
                        <td valign="top">
						<select name="fpagado" style="width:100%" onChange="document.fbuscar.submit()">
						<option value="" <cfif #url.fpagado# EQ "">selected</cfif> ></option>
						<option value="1" <cfif #url.fpagado# EQ "1">selected</cfif> >S&iacute;</option>
						<option value="0" <cfif #url.fpagado# EQ "0">selected</cfif> >No</option></select>
						</td>
						</cfoutput>
                      </tr>
                      <cfoutput query="rs1" startRow="#StartRow_rs1#" maxRows="#MaxRows_rs1#"> 
						<cfset link="consulta-detalle.cfm?TPID=#TPID#">
                        <tr onClick="location.href='#link#'" style="cursor:hand"> 
                          <cfif #rs1.CurrentRow# MOD 2 EQ 0>
                            <cfset cssid="listaPar">
                            <cfelse>
                            <cfset cssid="listaNon">
                          </cfif>
                          <td class="#cssid#" nowrap title="#rs1.Fecha#"><a href="#link#">#rs1.Fecha#</a></td>
                          <td class="#cssid#" nowrap title="#rs1.Nombre#"><a href="#link#">#rs1.Usulogin#</a></td>
                          <td class="#cssid#" nowrap><a href="#link#">#rs1.Cedula#</a></td>
                          <td class="#cssid#"><a href="#link#">#rs1.EstadoNombre#</a></td>
                          <td class="#cssid#"><a href="#link#">#rs1.AccionNombre#</a></td>
                          <td class="#cssid#" align="right"><a href="#link#">#rs1.Importe#&nbsp;#rs1.Miso4217#</td>
                          <td class="#cssid#" nowrap><a href="#link#"> <cfif #rs1.Pagado#>
                              S&iacute; 
                              <cfelse>
                              No</cfif></a></td>
                        </tr>
                      </cfoutput> 
                    </table></form></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td valign="top"></td>
                <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
                <td valign="top"></td>
              </tr>
            </table>
            <!-- InstanceEndEditable -->
</td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
