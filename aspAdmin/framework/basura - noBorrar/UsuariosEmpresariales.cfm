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
		where (agente = 11000000000002563
		  and agente_loc = '00')
		  or exists (
			select id
			from UsuarioPermiso
			where rol = 'sys.pso'
--				  and Usucodigo = 11000000000002563
--				  and Ulocalizacion = '00'
				  and activo = 1)
		order by upper(nombre)	
	</cfquery>	
<!--- 
		where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
 --->	

		<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
			<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
	  </cfif>
		<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
			<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
	  </cfif>		
		<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
			<cfparam name="Form.filtrado" default="#Url.filtrado#">
	  </cfif>	
		<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
			<cfparam name="Form.DEid" default="#Url.DEid#">
	  </cfif>
		<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
			<cfparam name="Form.sel" default="#Url.sel#">
	  </cfif>		
		
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfif isdefined("Form.filtrado")>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=" & #form.filtrado#>		
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
			<cfset filtro = filtro & " and upper(u.Usulogin) = upper('" &  #Form.Usulogin_filtro# & "')">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usulogin_filtro=" & Form.Usulogin_filtro>
	  	</cfif>	 
		<cfif isdefined("Form.Usucuenta_filtro") and Len(Trim(Form.Usucuenta_filtro)) NEQ 0>
			<cfset filtro = filtro & " and u.Usucuenta ='" &  #Form.Usucuenta_filtro# & "'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usucuenta_filtro=" & Form.Usucuenta_filtro>
	  	</cfif>	 		
	  
		<cfif isdefined("Form.sel") and form.sel NEQ 1>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
	  </cfif>		
	
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<form name="formBuscar" method="post" action="">			  	  
			<tr> 
            <td valign="middle" align="right">  
              <label id="letiqueta1"><a href="javascript: limpiaFiltrado(); buscar();">Seleccione un usuario:  </a></label>
			  <label id="letiqueta2"><a href="javascript: limpiaFiltrado(); buscar();">Datos del usuario: </a> </label>			  
			  <a href="javascript: limpiaFiltrado(); buscar();">
	              <img src="/cfmx/sif/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"> 
              </a> </td>
			</tr>
		</form>	  							
		<tr style="display: ;" id="verFiltroListaUsuarios"> 
		  <td> 
		  	<form name="formFiltroListaUsuarios" method="post" action="UsuariosEmpresariales.cfm">
		  		<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
		  		<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
				
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
                <tr> 
                  <td height="17" class="fileLabel">Cuenta Empresarial</td>
                  <td height="17" colspan="4" class="fileLabel">Nombre del Usuario</td>
                </tr>
                <tr> 
                  <td><select name="cliente_empresarial_filtro" id="cliente_empresarial_filtro">
                    <option value="-1">-- Todas --</option>
                    <cfoutput query="rsCtaEmpresarial">
                      <option value="#rsCtaEmpresarial.cliente_empresarial#" <cfif isdefined('form.cliente_empresarial_filtro') and rsCtaEmpresarial.cliente_empresarial EQ form.cliente_empresarial_filtro> selected</cfif>>#rsCtaEmpresarial.nombre#</option>
                    </cfoutput>
                  </select>
					</td>
                  <td colspan="4"><input name="nombreFiltro" type="text" id="nombreFiltro" size="130" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>"></td>
                </tr>
                <tr>
                  <td width="18%" class="fileLabel">Login</td>
                  <td class="fileLabel">Cuenta Maestra</td>
                  <td class="fileLabel">Tipo de Identificaci&oacute;n</td>
                  <td class="fileLabel">Identificaci&oacute;n</td>
                  <td rowspan="2" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar3" value="Filtrar"></td>
                </tr>
                <tr>
                  <td><input name="Usulogin_filtro" type="text" id="Usulogin_filtro" size="30" maxlength="40" value="<cfif isdefined('form.Usulogin_filtro')><cfoutput>#form.Usulogin_filtro#</cfoutput></cfif>"></td>
                  <td>
					<input name="Usucuenta_filtro" type="text" id="Usucuenta_filtro" size="15" maxlength="10" value="<cfif isdefined('form.Usucuenta_filtro')><cfoutput>#form.Usucuenta_filtro#</cfoutput></cfif>">				  
					<!---
						<input name="Usucuenta_filtro" id="Usucuenta_filtro" type="text" 
						value="<cfif isdefined('form.Usucuenta_filtro')><cfoutput>#form.Usucuenta_filtro#</cfoutput></cfif>" 
						size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,-1); "  
						onFocus="javascript:this.value=qf(this); this.select();"  
 						onKeyUp="javascript: if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"  
						alt="Cuenta Maestra">
					--->
				  </td>
                  <td><select name="TIcodigo_filtro" id="TIcodigo_filtro">
                    <option value="-1" <cfif isdefined('form.TIcodigo_filtro') and form.TIcodigo_filtro EQ '-1'> selected</cfif>>-- Todos --</option>				  
                  <cfoutput query="rsTiposIdentif">
                    <option value="#rsTiposIdentif.TIcodigo#" <cfif isdefined('form.TIcodigo_filtro') and rsTiposIdentif.TIcodigo EQ form.TIcodigo_filtro> selected</cfif>>#rsTiposIdentif.TInombre#</option>
                  </cfoutput>
                  </select></td>
                  <td><input name="Pid_Filtro" type="text" id="Pid_Filtro" size="30" maxlength="60" value="<cfif isdefined('form.Pid_Filtro')><cfoutput>#form.Pid_Filtro#</cfoutput></cfif>"></td>
                </tr>
              </table>
            </form>
          </td>
		</tr>		
        <tr style="display: ;" id="verLista"> 
          <td> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pLista"
					 returnvariable="pListaEmpl">
						<cfinvokeargument name="tabla" value="
							UsuarioEmpresarial ue
							, Usuario u
							, CuentaClienteEmpresarial cce						
						"/>
						<cfinvokeargument name="columnas" value="
							ue.Usucodigo,
								ue.Ulocalizacion,
								u.Usucuenta,
								ue.cliente_empresarial, 
								cce.nombre as nombre_cuenta,
							  case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
								  ((case	when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' '
										else null
									   	end) +
										   (case
											when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' '
											else null
											end) +
										  (case
										   when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' '
										   else null
										   end)) as nombre			
								,o=1,sel=1"/>
						<cfinvokeargument name="desplegar" value="nombre,Usulogin,Usucuenta,nombre_cuenta"/>
						<cfinvokeargument name="etiquetas" value="Nombre, Login, Cuenta, Cuenta Empresarial"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="formName" value="listaUsuarios"/>	
						<cfinvokeargument name="filtro" value="  
									ue.Usucodigo = u.Usucodigo
								  and ue.Ulocalizacion = u.Ulocalizacion
								  and ue.cliente_empresarial = cce.cliente_empresarial
								  and ue.activo = 1
								  and cce.activo = 1
								  and (
									cce.agente = 11000000000002563
									and cce.agente_loc = '00'
									
									or exists (select id from UsuarioPermiso
											where rol = 'sys.pso'
												and Usucodigo = 11000000000002563
												and Ulocalizacion = '00'))
								  and u.Usutemporal = 0
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
										   end))						
						"/>
						<cfinvokeargument name="align" value="left,left,left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="UsuariosEmpresariales.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="Conexion" value="#DSN#"/>						
						<cfinvokeargument name="keys" value="Usucodigo,Ulocalizacion,cliente_empresarial"/>
					</cfinvoke>
					<!---
									cce.agente = 11000000000002563		-- #Session.Usucodigo# 
									and cce.agente_loc = '00'	-- #Session.Ulocalizacion#					
					
												and Usucodigo = 11000000000002563	-- #Session.Usucodigo# 
												and Ulocalizacion = '00'))		-- #Session.Ulocalizacion# 					
					
							and ue.cliente_empresarial = 1000000000000040	-- #form.cuentaEmpresarial# 
							
							
					--->					
				</td>
			  </tr>
			  <tr>
				<td align="center">
					<form name="formNuevoUsuarioLista" method="post" action="UsuariosEmpresariales.cfm">
						<input type="hidden" name="o" value="1">
						<input type="hidden" name="sel" value="1">
						
						<input name="btnNuevoLista" type="submit" value="Nuevo Usuario">				
					</form>
				</td>
			  </tr>
			</table>
		  </td>
        </tr>
        <tr style="display: ;" id="verPagina"> 
          <td> 
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						
						<td class="tabContent">
							Portlet de Navegacion
							<!--- 
								<cfset regresar = "/cfmx/sif/rh/index.cfm">
								<cfinclude template="../../portlets/pNavegacion.cfm"> 
							--->
                            <cfinclude template="header.cfm">
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>																
					<tr>
						<td class="tabContent" align="center">
							<cfif tabChoice eq 1>	<!--- Datos del Usuario --->
 								<cfinclude template="formDatosUsuario.cfm">
							<cfelseif tabChoice eq 2>	<!--- ** --->
								<table width="80%" border="0" cellspacing="0" cellpadding="0">
								  <tr>
									<td>
										<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Informaci&oacute;n del Usuarios">
											<cfinclude template="encabUsuario.cfm">
										</cf_web_portlet>
									</td>
								  </tr>
								  <tr>
									<td>&nbsp;</td>
								  </tr>								  
								</table>
											Mantenimiento 2				
<!--- 								<cfinclude template="familiares.cfm"> --->
							<cfelseif tabChoice eq 3>	<!--- ** --->
								Mantenimiento 3
							<cfelse>														
								  <div align="center"> <b>Este m&oacute;dulo no est&aacute; disponible</b></div>
							</cfif> 					
						</td>
					</tr>
				</table>
		  </td>
        </tr>
      </table>
	  <script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>	  
      <script language="JavaScript" type="text/javascript">
			var Bandera = "L";
			
			function buscar(){
				var connVerLista				= document.getElementById("verLista");
				var connVerPagina				= document.getElementById("verPagina");				
				var connverFiltroListaUsuarios	= document.getElementById("verFiltroListaUsuarios");								
				var connVerEtiqueta1			= document.getElementById("letiqueta1");												
				var connVerEtiqueta2			= document.getElementById("letiqueta2");																
				
				
				if(document.formFiltroListaUsuarios.filtrado.value != "")
					Bandera = "L";
					
				if(document.formFiltroListaUsuarios.sel.value == "1")
					Bandera = "P";					
			
				if(Bandera == "L"){	// Ver Lista
					Bandera = "P";
					connVerLista.style.display = "";
					connverFiltroListaUsuarios.style.display = "";					
					connVerPagina.style.display = "none";
					document.formBuscar.imageBusca.src="/cfmx/sif/imagenes/iindex.gif";
					connVerEtiqueta1.style.display = "none";
					connVerEtiqueta2.style.display = "";					
					document.formBuscar.imageBusca.alt="Mantenimientos";
				}else{	//Pagina
					Bandera = "L";				
					connVerLista.style.display = "none";
					connverFiltroListaUsuarios.style.display = "none";					
					connVerPagina.style.display = "";
					document.formBuscar.imageBusca.src="/cfmx/sif/imagenes/iindex.gif";					
					connVerEtiqueta1.style.display = "";
					connVerEtiqueta2.style.display = "none";										
					document.formBuscar.imageBusca.alt="Lista de empleados";
				}
			}				
			
			function limpiaFiltrado(){
				document.formFiltroListaUsuarios.filtrado.value = "";
				document.formFiltroListaUsuarios.sel.value = 0;
			}
			
			buscar();
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