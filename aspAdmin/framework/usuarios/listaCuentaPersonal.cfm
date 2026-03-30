<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuFM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><!--- <cfinclude template="../portlets/pEmpresas2.cfm"> ---></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="/aspAdmin/framework/jsMenuFM.cfm" ></td>
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
    <td width="3" align="left" valign="top" nowrap></td>
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr>
    <td width="1%" align="left" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td width="3" align="left" valign="top" nowrap></td> 
    <td valign="top" width="100%">
	<!-- InstanceBeginEditable name="portletMantenimientoInicio" -->	

		<cfif isdefined("url.Filtrar") and not isdefined("form.Filtrar")>
			<cfset form.Filtrar = url.Filtrar >
		</cfif>
		
		<cfif isdefined("form.Filtrar") and isdefined("url.fNombre") and not isdefined("form.fNombre") >
			<cfset form.fNombre = url.fNombre >
		</cfif>

		<cfif isdefined("form.Filtrar") and isdefined("url.fApellido1") and not isdefined("form.fApellido1") >
			<cfset form.fApellido1 = url.fApellido1 >
		</cfif>

		<cfif isdefined("form.Filtrar") and isdefined("url.fApellido2") and not isdefined("form.fApellido2") >
			<cfset form.fApellido2 = url.fApellido2 >
		</cfif>

		<cfif isdefined("form.Filtrar") and isdefined("url.fLogin") and not isdefined("form.fLogin") >
			<cfset form.fLogin = url.fLogin >
		</cfif>

		<cfif isdefined("form.Filtrar") and isdefined("url.fCuenta") and not isdefined("form.fCuenta") >
			<cfset form.fCuenta = url.fCuenta >
		</cfif>

		<script language="JavaScript1.2" type="text/javascript">
			function limpiar(){
				document.filtro.fNombre.value = "";
				document.filtro.fApellido1.value = "";
				document.filtro.fApellido2.value = "";
				document.filtro.fLogin.value  = "";
				document.filtro.fCuenta.value = "";
			}
		</script>

		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cuentas Personales">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 

			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<td><cfinclude template="../portlets/pNavegacion2.cfm"></td>
				</tr>
				<tr>
					<td>

						<cfoutput>
						<form name="filtro" style="margin:0;" action="listaCuentaPersonal.cfm" method="post">
							<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
								<tr>
									<td align="right"><b>Nombre:&nbsp;</b></td>
									<td><input name="fNombre" type="text" size="25" maxlength="255" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>#form.fNombre#</cfif>" ></td>
									<td align="right"><b>Apellidos:&nbsp;</b></td>
									<td><input name="fApellido1" type="text" size="25" maxlength="255" value="<cfif isdefined("form.fApellido1") and len(trim(form.fApellido1)) gt 0>#form.fApellido1#</cfif>" ></td>
									<td><input name="fApellido2" type="text" size="25" maxlength="255" value="<cfif isdefined("form.fApellido2") and len(trim(form.fApellido2)) gt 0>#form.fApellido2#</cfif>" ></td>
									<td align="right"><b>Login:&nbsp;</b></td>
									<td><input name="fLogin" type="text" size="20" maxlength="20" value="<cfif isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>#form.fLogin#</cfif>" ></td>
									<td align="right"><b>Cuenta:&nbsp;</b></td>
									<td><input name="fCuenta" type="text" size="20" maxlength="20" value="<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>#form.fCuenta#</cfif>" ></td>
									<td><input type="submit" name="Filtrar" value="Filtrar"></td>
									<td><input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
								</tr>
							</table>
						</form>
						</cfoutput>

						<cfif isdefined("form.Filtrar")>
							<cfset select = " Usutemporal, convert(varchar, u.Usucodigo) as Usucodigo, u.Ulocalizacion, u.Usucuenta,
											  case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
											  ((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end) +
											   (case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end) +
											   (case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end)) as nombre " >
							<cfset from = " Usuario u ">
	
							<cfset where = " u.activo = 1 
											  and not exists ( select Usucodigo from UsuarioEmpresarial where Usucodigo = u.Usucodigo and Ulocalizacion = u.Ulocalizacion )
											  and ( u.agente = 1 and u.agente_loc = '00'
													or exists ( select id from UsuarioPermiso where rol = 'sys.pso' and Usucodigo = 1 and Ulocalizacion = '00' ) )">
	
							<cfset navegacion = "&Filtrar=Filtrar">

							<cfif isdefined("form.Filtrar") and isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>
								<cfset where = where & " and upper(case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end) like upper('%#form.fNombre#%')" >
								<cfset navegacion = navegacion &  "&fNombre=#form.fNombre#" >
							</cfif> 
				
							<cfif isdefined("form.Filtrar") and isdefined("form.fApellido1") and len(trim(form.fApellido1)) gt 0>
								<cfset where = where & " and upper((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end)) like upper('%#form.fApellido1#%')" >
								<cfset navegacion = navegacion & "&fApellido1=#form.fApellido1#" >
							</cfif> 
	
							<cfif isdefined("form.Filtrar") and isdefined("form.fApellido2") and len(trim(form.fApellido2)) gt 0>
								<cfset where = where & " and upper((case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end)) like upper('%#form.fApellido2#%')" >
								<cfset navegacion = navegacion & "&fApellido2=#form.fApellido2#" >
							</cfif> 
	
							<cfif isdefined("form.Filtrar") and isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>
								<cfset where = where & " and upper(u.Usulogin) like upper('%#form.fLogin#%')" >
								<cfset navegacion = navegacion & "&fLogin=#form.fLogin#" >
							</cfif> 
				
							<cfif isdefined("form.Filtrar") and isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>
								<cfset where = where & " and upper(u.Usucuenta) like upper('%#form.fCuenta#%')" >
								<cfset navegacion = navegacion & "&fCuenta=#form.fCuenta#" >
							</cfif> 
	
							<cfset where = where & " order by upper((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end) +
															(case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end) +
															(case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end)) " >
						
							<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pLista"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="#from#"/>
								<cfinvokeargument name="columnas" value="#select#"/>
								<cfinvokeargument name="desplegar" value="Nombre, Usulogin, Usucuenta"/>
								<cfinvokeargument name="etiquetas" value="Nombre,Login,Cuenta"/>
								<cfinvokeargument name="formatos" value="V,V,V"/>
								<cfinvokeargument name="filtro" value="#where#"/>
								<cfinvokeargument name="align" value="left,left,left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="irA" value="CuentasPersonales.cfm"/>
								<cfinvokeargument name="Conexion" value="sdc"/>
								<cfinvokeargument name="MaxRows" value="30"/>
								<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
							</cfinvoke>
						</cfif>
					</td>
				</tr>
				<cfif not isdefined("form.Filtrar")>
					<tr>
						<td align="center">
							<table width="100%" align="center">
								<tr><td>&nbsp;</td></tr>
								<tr>
									<!--- <td valign="middle" align="right" width="30%"><img border="0" src="../../rh/imagenes/exclamacion.gif" height="35" width="35"></td> --->
									<td valign="middle" align="center"><b>Esta consulta puede generar un volumen de datos considerable.<br>Le sugerimos usar el filtro para que le sea más comodo consultar los datos.</b><br></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
						</td>
					</tr>
				</cfif>
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