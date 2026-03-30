<cfinclude template="../Utiles/general.cfm">
<cfparam name="PageNum_rs1" default="1">
<cfquery name="rs1" datasource="sdc">
SELECT
	isnull (t.FechaFin, t.FechaInicio) as Fecha,
	t.TPID, t.Cedula, t.Importe, t.Avance,
	isnull (e.EstadoNombre,'-') as EstadoNombre,
	isnull (m.Miso4217, '-') as Miso4217,
	isnull (a.AccionNombre,'-') as AccionNombre
FROM TramitePasaporte t, TramitePasaporteAccion a, TramitePasaporteEstado e, Moneda m
WHERE t.Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
  AND t.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
  and a.Accion =* t.Accion
  and e.Pestado =* t.Pestado
  and m.Mcodigo =* t.Mcodigo
  and t.Avance != '6'
order by convert (varchar, isnull (t.FechaFin, t.FechaInicio),112) desc, t.Cedula
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
            <!-- InstanceBeginEditable name="Menu" --><cfinclude template="jsTramites.cfm" ><!-- InstanceEndEditable --></td>
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
  <tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td> 
	<cfif #rs1.RecordCount# EQ 0>
	  <p>Actualmente no tiene tr&aacute;mites en proceso.</p>
	<cfelse>
	  <p>Actualmente tiene los siguientes tr&aacute;mites en proceso:</p>
	                <table border="0" cellspacing="0" cellpadding="2" width="100%">
                      <tr> 
                        <td valign="top"><strong>Fecha</strong></td>
                        <td valign="top"><strong>N&uacute;mero de c&eacute;dula</strong></td>
                        <td valign="top"><strong>Estado del pasaporte</strong></td>
                        <td valign="top"><strong>Acci&oacute;n solicitada</strong></td>
                        <td valign="top"><strong>Importe</strong></td>
                        <td valign="top"><strong>&nbsp;</strong></td>
                      </tr>
                      <cfoutput query="rs1" startRow="#StartRow_rs1#" maxRows="#MaxRows_rs1#"> 
                        <tr> 
                          <cfif #rs1.CurrentRow# MOD 2 EQ 0>
                            <cfset cssid="listaPar">
                            <cfelse>
                            <cfset cssid="listaNon">
                          </cfif>
                          <td class="#cssid#" nowrap>#LSDateFormat(rs1.Fecha)#</td>
                          <td class="#cssid#" nowrap>#rs1.Cedula#</td>
                          <td class="#cssid#">#rs1.EstadoNombre#</td>
                          <td class="#cssid#">#rs1.AccionNombre#</td>
                          <td class="#cssid#" align="right">#rs1.Importe# #rs1.Miso4217#</td>
                          <td class="#cssid#" nowrap align="right"> <cfif #rs1.Avance# EQ '1'>
                              <a href="trpass--.cfm?TPID=#rs1.TPID#">[ 
                              Consultar ]</a> 
                              <cfelseif #rs1.Avance# EQ '2'>
                              <input style="width:100%" type="button" value="Continuar" onClick="location.href='trpass02.cfm?TPID=#TPID#'">
                              <cfelseif #rs1.Avance# EQ '3'>
                              <input style="width:100%" type="button" value="Pagar" onClick="location.href='trpass03.cfm?TPID=#TPID#'">
                              <cfelseif #rs1.Avance# EQ '4'>
                              <a href="trpass--.cfm?TPID=#rs1.TPID#">[ 
                              Completar pago ]</a> 
                              <cfelseif #rs1.Avance# EQ '5'>
                              <input style="width:100%" type="button" value="Imprimir recibo" onClick="location.href='trpass05.cfm?TPID=#TPID#'">
                              <cfelseif #rs1.Avance# EQ '6'>
                              <a href="trpass--.cfm?TPID=#rs1.TPID#">[ 
                              Historia ]</a> 
                              <cfelse>
                              [ Pendiente ] </cfif></td>
                        </tr>
                      </cfoutput> 
                    </table>
		</cfif>
</td>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td><input type="button" value="Iniciar tr&aacute;mite" onClick="location.href='trpass01.cfm'"></td>
	<td>&nbsp;</td>
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
