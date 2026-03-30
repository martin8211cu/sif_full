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
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Usuarios Empresariales">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 
		
	<cfquery name="rsTiposIdentif" datasource="sdc">
		select TIcodigo, TInombre
		from TipoIdentificacion 
		order by TInombre
	</cfquery> 
	
	<cfquery name="rsCtaEmpresarial" datasource="sdc">
		select cliente_empresarial, nombre 
		from CuentaClienteEmpresarial
		where (agente = 1
		  and agente_loc = '00')
		  or exists (
			select id
			from UsuarioPermiso
			where rol = 'sys.pso'
				  and Usucodigo = 1
				  and Ulocalizacion = '00'
				  and activo = 1)
		order by upper(nombre)	
	</cfquery>
		
	<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
		<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
	</cfif>
	<cfif isdefined("Url.cliente_empresarial_filtro") and not isdefined("Form.cliente_empresarial_filtro")>
		<cfparam name="Form.cliente_empresarial_filtro" default="#Url.cliente_empresarial_filtro#">
	</cfif>
	<cfif isdefined("Url.Usulogin_filtro") and not isdefined("Form.Usulogin_filtro")>
		<cfparam name="Form.Usulogin_filtro" default="#Url.Usulogin_filtro#">
	</cfif>			
	<cfif isdefined("Url.Usucuenta_filtro") and not isdefined("Form.Usucuenta_filtro")>
		<cfparam name="Form.Usucuenta_filtro" default="#Url.Usucuenta_filtro#">
	</cfif>
	<cfif isdefined("Url.TIcodigo_filtro") and not isdefined("Form.TIcodigo_filtro")>
		<cfparam name="Form.TIcodigo_filtro" default="#Url.TIcodigo_filtro#">
	</cfif>	
	<cfif isdefined("Url.Pid_Filtro") and not isdefined("Form.Pid_Filtro")>
		<cfparam name="Form.Pid_Filtro" default="#Url.Pid_Filtro#">
	</cfif>		
	<cfif isdefined("Url.btnFiltrar") and not isdefined("Form.btnFiltrar")>
		<cfparam name="Form.btnFiltrar" default="#Url.btnFiltrar#">
	</cfif>			
		
	
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfif isdefined("Form.btnFiltrar")>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "btnFiltrar=" & #form.btnFiltrar#>		
		</cfif>

		<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
			<cfset filtro = filtro & " and upper(ue.Pnombre + ' ' + ue.Papellido1 + ' ' + ue.Papellido2) like upper('%" & #Form.nombreFiltro# & "%')">			
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
	  	</cfif>
	  	<cfif isdefined("Form.TIcodigo_filtro") and Len(Trim(Form.TIcodigo_filtro)) NEQ 0 and Form.TIcodigo_filtro NEQ '-1'>
			<cfset filtro = filtro & " and ue.TIcodigo = '" & #Form.TIcodigo_filtro# & "'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TIcodigo_filtro=" & #form.TIcodigo_filtro#>				
	  	</cfif>
		<cfif isdefined("Form.Pid_Filtro") and Len(Trim(Form.Pid_Filtro)) NEQ 0>
			<cfset filtro = filtro & " and ue.Pid='" & #Form.Pid_Filtro# & "'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pid_Filtro=" & Form.Pid_Filtro>
	  	</cfif>
		<cfif isdefined("Form.cliente_empresarial_filtro") and Len(Trim(Form.cliente_empresarial_filtro)) NEQ 0 and Form.cliente_empresarial_filtro NEQ '-1'>
			<cfset filtro = filtro & " and ue.cliente_empresarial=" & #Form.cliente_empresarial_filtro#>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cliente_empresarial_filtro=" & Form.cliente_empresarial_filtro>
	  	</cfif>	  
		<cfif isdefined("Form.Usulogin_filtro") and Len(Trim(Form.Usulogin_filtro)) NEQ 0>
			<cfset filtro = filtro & " and u.Usutemporal = 0">
			<cfset filtro = filtro & " and upper(u.Usulogin) like  upper('%" &  #Form.Usulogin_filtro# & "%')">			
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usulogin_filtro=" & Form.Usulogin_filtro>
	  	</cfif>	 
		<cfif isdefined("Form.Usucuenta_filtro") and Len(Trim(Form.Usucuenta_filtro)) NEQ 0>
			<cfset filtro = filtro & " and u.Usucuenta ='" &  #Form.Usucuenta_filtro# & "'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usucuenta_filtro=" & Form.Usucuenta_filtro>
	  	</cfif>	 		

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<cfset recycle  = 'javascript:activar_usuarios();'>
				<cfinclude template="../portlets/pNavegacion.cfm">
			</td>
		  </tr>
		  <tr>
			<td>
				<form name="formFiltroListaUsuarios" method="post" action="listaUsuariosEmpresariales.cfm" style="margin: 0;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
						<tr> 
						  <td height="17" class="fileLabel"><strong>Cuenta Empresarial</strong></td>
						  <td height="17" colspan="4" class="fileLabel"><strong>Nombre del Usuario</strong></td>
						</tr>
						<tr> 
						  <td><select name="cliente_empresarial_filtro" id="cliente_empresarial_filtro" tabindex="1">
							  <option value="-1" <cfif isdefined('form.cliente_empresarial_filtro') and rsCtaEmpresarial.cliente_empresarial EQ '-1'> selected</cfif>>-- Todas --</option>						  
							<cfoutput query="rsCtaEmpresarial">
							  <option value="#rsCtaEmpresarial.cliente_empresarial#" <cfif isdefined('form.cliente_empresarial_filtro') and rsCtaEmpresarial.cliente_empresarial EQ form.cliente_empresarial_filtro> selected</cfif>>#rsCtaEmpresarial.nombre#</option>
							</cfoutput>
						  </select>
							</td>
						  <td colspan="4"><input name="nombreFiltro" tabindex="2" type="text" id="nombreFiltro" size="130" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>"></td>
						</tr>
						<tr>
						  <td width="18%" class="fileLabel"><strong>Login</strong></td>
						  <td class="fileLabel"><strong>Cuenta Maestra</strong></td>
						  <td class="fileLabel"><strong>Tipo de Identificaci&oacute;n</strong></td>
						  <td class="fileLabel"><strong>Identificaci&oacute;n</strong></td>
						  <td rowspan="2" align="center"><input tabindex="7" name="btnFiltrar" type="submit" id="btnFiltrar3" value="Filtrar"></td>
						</tr>
						<tr>
						  <td><input tabindex="3" name="Usulogin_filtro" type="text" id="Usulogin_filtro" size="30" maxlength="40" value="<cfif isdefined('form.Usulogin_filtro')><cfoutput>#form.Usulogin_filtro#</cfoutput></cfif>"></td>
						  <td>
							<input tabindex="4" name="Usucuenta_filtro" type="text" id="Usucuenta_filtro" size="15" maxlength="10" value="<cfif isdefined('form.Usucuenta_filtro')><cfoutput>#form.Usucuenta_filtro#</cfoutput></cfif>">
						  </td>
						  <td><select name="TIcodigo_filtro" id="TIcodigo_filtro" tabindex="5">
							<option value="-1" <cfif isdefined('form.TIcodigo_filtro') and form.TIcodigo_filtro EQ '-1'> selected</cfif>>-- Todos --</option>				  
						  <cfoutput query="rsTiposIdentif">
							<option value="#rsTiposIdentif.TIcodigo#" <cfif isdefined('form.TIcodigo_filtro') and rsTiposIdentif.TIcodigo EQ form.TIcodigo_filtro> selected</cfif>>#rsTiposIdentif.TInombre#</option>
						  </cfoutput>
						  </select></td>
						  <td><input tabindex="6" name="Pid_Filtro" type="text" id="Pid_Filtro" size="30" maxlength="60" value="<cfif isdefined('form.Pid_Filtro')><cfoutput>#form.Pid_Filtro#</cfoutput></cfif>"></td>
						</tr>
					  </table>				
				</form>				  
			</td>
		  </tr>
		  <cfif isdefined('form.btnFiltrar') and form.btnFiltrar NEQ ''>
			  <tr>		  
				<td>		  
					<cfinvoke 
 					 component="sif.Componentes.pListas"
					 method="pLista"
					 returnvariable="pListaEmpl">
						<cfinvokeargument name="tabla" value="UsuarioEmpresarial ue, Usuario u, CuentaClienteEmpresarial cce"/>
						<cfinvokeargument name="columnas" value=" ue.Usucodigo, ue.Ulocalizacion, u.Usucuenta, ue.cliente_empresarial, 
																  cce.nombre as nombre_cuenta, case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
								  								  ((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null end) +
										   						   (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
										  						   (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) as nombre"/>
						<cfinvokeargument name="desplegar" value="nombre,nombre_cuenta,Usulogin,Usucuenta"/>
						<cfinvokeargument name="etiquetas" value="Nombre, Cuenta Empresarial,Login, Cuenta"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="formName" value="listaUsuarios"/>	
						<cfinvokeargument name="filtro" value=" ue.Usucodigo = u.Usucodigo
																and ue.Ulocalizacion = u.Ulocalizacion
																and ue.cliente_empresarial = cce.cliente_empresarial
																and ue.activo = 1
																and cce.activo = 1
																and (cce.agente = #Session.Usucodigo#
																	and cce.agente_loc = '#Session.Ulocalizacion#'
																	or exists (select id from UsuarioPermiso
																	where rol = 'sys.pso'
																	and Usucodigo = #Session.Usucodigo#
																	and Ulocalizacion ='#Session.Ulocalizacion#'))
																	
																	  #filtro#
																	order by  upper((case
																					when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' '
																					else null
																					end) +
																				   (case
																					when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' '
																					else null
																					end) +
																				  (case
																				   when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' '
																				   else null
																				   end))"/>
						<cfinvokeargument name="align" value="left,left,left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>						
						<cfinvokeargument name="irA" value="usuariosEmpresariales.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="Conexion" value="#session.DSN#"/>						
						<cfinvokeargument name="keys" value="Usucodigo,Ulocalizacion,cliente_empresarial"/>
					</cfinvoke>
				</td>
			  </tr>		  
			  <cfif isdefined('form.cliente_empresarial_filtro') and form.cliente_empresarial_filtro NEQ ''>
				  <tr>		  			  
					<td align="center">
						<form name="formNuevoUsuarioLista" method="post" action="usuariosEmpresariales.cfm" onSubmit="return valida(this);">
							<input type="hidden" name="cliente_empresarial" value="<cfoutput>#form.cliente_empresarial_filtro#</cfoutput>">
							
							<input name="btnNuevoLista" type="submit" value="Nuevo Usuario">				
						</form>			  
						
						<script language="JavaScript" type="text/javascript">
							function valida(f){
								if(document.formFiltroListaUsuarios.cliente_empresarial_filtro.value == '-1'){
									alert('Error, debe seleccionar una Cuenta Empresarial');
									document.formFiltroListaUsuarios.cliente_empresarial_filtro.focus;
									return false;								
								}else{
									f.cliente_empresarial.value = document.formFiltroListaUsuarios.cliente_empresarial_filtro.value;
								}							
																
								return true;
							}
						</script>						
					</td>
				  </tr>		  			  
			  </cfif>
		  </cfif>
		</table>

		<script type="text/javascript" language="javascript1.2">
			function activar_usuarios(){
				var top = (screen.height - 700) / 2;
				var left = (screen.width - 650) / 2;
				var idControl1 = '1';
				window.open('UsuariosRecycle.cfm', 'Informacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width=700,height=650');
			}
		</script>
	
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>