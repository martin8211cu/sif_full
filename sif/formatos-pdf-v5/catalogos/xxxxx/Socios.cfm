
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
		      	<div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n del sistema</font></span></div></td>
			</cfif>	  
        </tr>
        <tr class="area"> 
          	<td width="50%" valign="bottom" nowrap>
				<cfif isdefined("Session.modulo") and Session.modulo EQ "CC">
					<cfinclude template="/sif/cc/jsMenuCC.cfm" >
				<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CP">
					<cfinclude template="/sif/cp/jsMenuCP.cfm" >
				<cfelseif isdefined("Session.modulo") and Session.modulo EQ "AD">
					<cfinclude template="../jsMenuAD.cfm">					
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
            de Socios de negocios<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder"><!-- InstanceBeginEditable name="Mantenimiento2" -->


		<cfset filtro = "Ecodigo=#session.Ecodigo#" >
		<cfif isdefined("form.fSNnumero") and len(trim(form.fSNnumero)) gt 0 >
			<cfset filtro = filtro & " and SNnumero like '%#form.fSNnumero#%' " >
		</cfif>
		<cfif isdefined("form.fSNnombre") and len(trim(form.fSNnombre)) gt 0 >
			<cfset filtro = filtro & " and upper(SNnombre) like upper('%#form.fSNnombre#%') " >
		</cfif>
		
		<cfset filtro = filtro & " order by SNtiposocio, SNnumero, SNnombre " >

            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td colspan="2" valign="top"> <cfif isdefined("Session.modulo") and Session.modulo EQ "CC">
                    <cfinclude template="../../portlets/pNavegacionCC.cfm">
                    <cfelseif isdefined("Session.modulo") and Session.modulo EQ "CP">
                    <cfinclude template="../../portlets/pNavegacionCP.cfm">
                    <cfelse>
                    <cfinclude template="../../portlets/pNavegacionAD.cfm">
                  </cfif> </td>
              </tr>
			  
			  <tr>
				  <!--- Filtro, lista--->
				  <td width="40%" valign="top">
				  		<table width="100%" cellpadding="0" cellspacing="0">
							<!--- filtro --->
							<tr>
								<td valign="top">
									<form name="filtro" method="post">
										<table  border="0" width="100%" class="areaFiltro" >
											<tr> 
											  <td nowrap>N&uacute;mero (XXX-XXXX)</td>
											  <td>Nombre</td>
											  <td>&nbsp;</td>
											</tr>
											<tr> 
											  <td><input type="text" name="fSNnumero" maxlength="8" size="10" value=""></td>
											  <td><input type="text" name="fSNnombre"  maxlength="255" size="40" value=""></td>
											  <td><input type="submit" name="btnFiltrar" value="Filtrar"></td>
											</tr>
										  </table>
									  </form>
								</td>
							</tr>
							<!--- lista--->
							<tr>
								<td>
								  <cfinvoke component="sif.Componentes.pListas" method="pLista"
										 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="SNegocios"/>
										<cfinvokeargument name="columnas" value="convert(varchar,SNcodigo) as SNcodigo,SNnumero, SNnombre, case when SNtiposocio = 'C' then 'Cliente' when SNtiposocio = 'P' then 'Proveedor' else 'Ambos' end SNtiposocio, case when EUcodigo is NULL then 'No' when EUcodigo is not NULL then 'Si' end Usuario "/>
										<cfinvokeargument name="desplegar" value="SNnumero, SNnombre, Usuario"/>
										<cfinvokeargument name="etiquetas" value="N&uacute;mero, Nombre, Usuario"/>
										<cfinvokeargument name="formatos" value=""/>
										<cfinvokeargument name="filtro" value="#filtro#"/>
										<cfinvokeargument name="align" value="left, left, left"/>
										<cfinvokeargument name="ajustar" value="N,N,N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="Cortes" value="SNtiposocio"/>
										<cfinvokeargument name="irA" value="Socios.cfm"/>
									 </cfinvoke> 
								</td>
							</tr>
						</table>
				  </td>
				  <!--- formulario ---> 	
				  <td valign="top"><cfinclude template="formSocios.cfm"></td>
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

