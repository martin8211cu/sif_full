<cfif not (isDefined('Form.Ccodigo') and Len(Trim(Form.Ccodigo)) NEQ 0 )> 
   <cflocation addtoken="no" url="../catalogos/Conceptos.cfm" >
</cfif>
<html><!-- InstanceBegin template="/Templates/pMantenimiento02_border.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<script language="JavaScript" src="../../js/calendar.js"></script>
<!-- InstanceEndEditable -->
<link href="portlets.css" rel="stylesheet" type="text/css">
<link href="portlets.css" rel="stylesheet" type="text/css">
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
<link href="sif.css" rel="stylesheet" type="text/css">
<link href="sif.css" rel="stylesheet" type="text/css">

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" -->
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" -->
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
        <td width="44%" rowspan="2"></td>
    	 	<cfif isdefined("Session.modulo") and Session.modulo EQ "CC">
		  		<td nowrap><div align="center"></div>
		      	<div align="center"><span class="superTitulo"><font size="5">Cuentas 
              	por Cobrar</font></span></div></td>
			<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CP">
		  		<td nowrap><div align="center"></div>
		      	<div align="center"><span class="superTitulo"><font size="5">Cuentas 
              	por Pagar</font></span></div></td>
			<cfelseif isdefined("Session.modulo") and Session.modulo EQ "AD">
		  		<td nowrap><div align="center"></div>
		      	<div align="center"><span class="superTitulo"><font size="5">Administración del sistema</font></span></div></td>
			</cfif>	  
        </tr>
        <tr class="area"> 
          <td width="56%" valign="bottom">
			<cfif isdefined("Session.modulo") and Session.modulo EQ "CC">
				<cfinclude template="../../cc/jsMenuCC.cfm" >
			<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CP">
				<cfinclude template="../../cp/jsMenuCP.cfm" >
			<cfelseif isdefined("Session.modulo") and Session.modulo EQ "AD">
				<cfinclude template="../../ad/jsMenuAD.cfm">
			</cfif>
		  </td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->	
	
		</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="84" align="left" valign="top" nowrap></td>
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->Cat&aacute;logo
               de cuentas por Concepto de Facturacion<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder"><!-- InstanceBeginEditable name="Mantenimiento2" -->
            <table width="95%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td colspan="2" valign="top">
				<cfif isdefined("Session.modulo") and Session.modulo EQ 'CP'>
					<cfinclude template="../../portlets/pNavegacionCP.cfm">
				<cfelseif isdefined("Session.modulo") and Session.modulo EQ 'CC'>
					<cfinclude template="../../portlets/pNavegacionCC.cfm">
				<cfelseif isdefined("Session.modulo") and Session.modulo EQ 'AD'>
					<cfinclude template="../../portlets/pNavegacionAD.cfm">				
				</cfif>
				</td>
              </tr>
              <tr> 
                <!--- Select Ccodigo, Dcodigo, Ccuenta, Cid,timestamp
    from CuentasConceptos
 --->
                <td valign="top" width="50%"> <cfinvoke component="sif.Componentes.pListas" method="pLista"
				 returnvariable="pListaCtasCon">
                    <cfinvokeargument name="tabla" value="CuentasConceptos b, Departamentos c, CContables a"/>
                    <cfinvokeargument name="columnas" value="rtrim(ltrim(b.Ccodigo)) as Ccodigo, b.Dcodigo as Dcodigo, b.Ccuenta as Ccuenta, b.Cid as Cid, convert(varchar(25), c.Ddescripcion) as Ddescripcion , convert(varchar(25), a.Cdescripcion) as  Cdescripcion"/>
                    <cfinvokeargument name="desplegar" value="Ddescripcion, Ccodigo ,  Cdescripcion "/>
                    <!---    poner alias en desplegar       <cfinvokeargument name="desplegar" value="SNnombre, SNtiposocio"/>
 --->
                    <cfinvokeargument name="etiquetas" value="Departamento, Código, Cuenta"/>
                    <cfinvokeargument name="formatos" value=""/>
                    <!--- 					Ojo - Cuando la llave es char, se debe poner entre comillas '#form.Ccodigo#'  
 --->
                    <cfinvokeargument name="filtro" value=" 
																		b.Ccodigo = '#Trim(Form.Ccodigo)#' and 
																		b.Ecodigo=#session.Ecodigo#
																		and a.Ecodigo = b.Ecodigo 
																		and a.Ccuenta = b.Ccuenta
																		and a.Ecodigo = c.Ecodigo
																		and b.Dcodigo = c.Dcodigo
																	order by a.Ccuenta
						"/>
                    <cfinvokeargument name="align" value="left, left, left"/>
                    <cfinvokeargument name="ajustar" value="N"/>
                    <cfinvokeargument name="checkboxes" value="N"/>
                    <cfinvokeargument name="irA" value="CtasConcepto.cfm"/>
                  </cfinvoke> </td>
                <td><cfinclude template="../catalogos/formCtasConcepto.cfm"></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
            <!-- InstanceEndEditable --></td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>

