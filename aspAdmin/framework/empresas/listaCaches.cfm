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

		<!--- arreglo de datasources --->
		<cfinclude template="query_caches.cfm">
		
		<style type="text/css" >
			.areaCheck {  
				 background: buttonface; 
				 padding: 1px;
				 color: buttontext;
			}
		</style>
		

		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Asignación de Caches">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 


			<cfif (isdefined("url.fcliente_empresarial") and not isdefined("form.fcliente_empresarial"))>
				<cfset form.fcliente_empresarial = url.fcliente_empresarial>
			</cfif>
			<cfif (isdefined("url.fnombre_comercial") and not isdefined("form.fnombre_comercial"))>
				<cfset form.fnombre_comercial = url.fnombre_comercial>
			</cfif>
			<cfif (isdefined("url.fsistema") and not isdefined("form.fsistema"))>
				<cfset form.fsistema = url.fsistema>
			</cfif>
			<cfif (isdefined("url.fnombre_cache") and not isdefined("form.fnombre_cache"))>
				<cfset form.fnombre_cache = url.fnombre_cache>
			</cfif>
			<cfif (isdefined("url.fnasignado") and not isdefined("form.fnasignado"))>
				<cfset form.fnasignado = 1 >
			</cfif>
			
			<!--- <cfdump var="#form#"> --->
			
			<cfset navegacion = "">
			<cfset filtro = "">
			
			<cfif (isdefined("form.fcliente_empresarial") and len(trim(form.fcliente_empresarial)))>
				<cfset filtro = filtro & " and cce.cliente_empresarial =" & form.fcliente_empresarial>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fcliente_empresarial=" & form.fcliente_empresarial>
			</cfif>
			<cfif (isdefined("form.fnombre_comercial") and len(trim(form.fnombre_comercial)))>
				<cfset filtro = filtro & " and upper(e.nombre_comercial) like '%" & UCase(form.fnombre_comercial) & "%'">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fnombre_comercial=" & form.fnombre_comercial>
			</cfif>
			<cfif (isdefined("form.fsistema") and len(trim(form.fsistema)))>
				<cfset filtro = filtro & " and upper(sis.sistema) like '%" & UCase(form.fsistema) & "%'">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fsistema=" & form.fsistema>
			</cfif>
			<cfif (isdefined("form.fnombre_cache") and len(trim(form.fnombre_cache)))>
				<cfset filtro = filtro & " and upper(eid.nombre_cache) like '%" & Ucase(form.fnombre_cache) & "%'">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fnombre_cache=" & form.fnombre_cache>
			</cfif>
			<cfif  isdefined("form.fnAsignado") >
				<cfset filtro = filtro & " and eid.nombre_cache is null ">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fnasignado=1">
			</cfif>

			<cfquery name="rsCuentas" datasource="sdc">
				select cliente_empresarial, nombre from CuentaClienteEmpresarial
				where (agente = 1
				  and agente_loc = '00')
				  or exists (select id from UsuarioPermiso
				  where rol = 'sys.pso'
				  and Usucodigo = 1
				  and Ulocalizacion = '00')
				  and rtrim(nombre) != ' '
				  and activo = 1
				order by upper(nombre)
			</cfquery>
			
			<script language="JavaScript1.2" type="text/javascript">
				function limpiar(){
					document.filtro.fcliente_empresarial.value  = "";
					document.filtro.fnombre_comercial.value = "";
					document.filtro.fsistema.value  = "";
					document.filtro.fnombre_cache.value  = "";
					document.filtro.fnAsignado.checked  = false;
				}
			</script>

			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr><td><cfinclude template="../portlets/pNavegacion2.cfm"></td></tr>
				<tr>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<cfoutput>
									<form name="filtro" style="margin:0;" action="listaCaches.cfm" method="post">
										<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
											<tr>
												<td align="right" nowrap><b>Cuenta Empresarial:&nbsp;</b></td>
												<td>
													<select name="fcliente_empresarial">
														<option value="" selected>--- Todas ---</option>
														<cfloop query="rsCuentas">
															<option value="#rsCuentas.cliente_empresarial#" <cfif isdefined("form.fcliente_empresarial") and form.fcliente_empresarial eq rsCuentas.cliente_empresarial>selected</cfif> >#rsCuentas.nombre#</option>
														</cfloop>
													</select>
												</td>
						
												<td align="right"><b>Empresa:&nbsp;</b></td>
												<td><input name="fnombre_comercial" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fnombre_comercial") and len(trim(form.fnombre_comercial)) gt 0>#form.fnombre_comercial#</cfif>" onfocus="this.select();" ></td>

												<td align="right"><b>Sistema:&nbsp;</b></td>
												<td><input name="fsistema" type="text" size="15" maxlength="15" value="<cfif isdefined("form.fsistema") and len(trim(form.fsistema)) gt 0>#form.fsistema#</cfif>" onfocus="this.select();" ></td>
											</tr>
												
											<tr>
												<td align="right"><b>Cache:&nbsp;</b></td>

												<td>
													<select name="fnombre_cache">
														<option value="">--- Todos ---</option>												
														<cfloop From="1" To="#ArrayLen(datasources)#" index="i">
															<option value="#datasources[i]#" <cfif (isdefined("form.fnombre_cache") and len(trim(form.fnombre_cache)) gt 0 and form.fnombre_cache eq datasources[i] )>selected</cfif> >#datasources[i]#</option>
														</cfloop>
													</select> 
												</td>
												
												<td align="right"></td>
												<td valign="middle"><input class="areaCheck" type="checkbox" name="fnAsignado" <cfif isdefined("form.fnAsignado")>checked</cfif> >Mostrar empresas sin cache asignado</td>

												<td align="center" colspan="2" >
													<input type="submit" name="Filtrar" value="Filtrar">
													<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
												</td>
											</tr>
										</table>
									</form>
									</cfoutput>

								</td>
							</tr>
							<tr>
								<td>
									<cfinvoke 
									 component="sif.Componentes.pListas"
									 method="pLista"
									 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="CuentaClienteEmpresarial cce, Empresa e, Sistema sis, EmpresaID eid"/>
										<cfinvokeargument name="columnas" value="cce.nombre as ccenombre, cce.descripcion, e.nombre_comercial as enombre, e.razon_social,
																					upper(sis.sistema) as sistema, sis.nombre, convert(varchar,eid.Ecodigo) as sdcEcodigo, eid.sistema as sdcSistema,
																					isnull(eid.nombre_cache,'-') as nombre_cache" />
										<cfinvokeargument name="desplegar" value="ccenombre, enombre, sistema, nombre_cache"/>
										<cfinvokeargument name="etiquetas" value="Cuenta Empresarial, Empresa, Sistema, Cache"/>
										<cfinvokeargument name="formatos" value="S,S,S,S"/>
										<cfinvokeargument name="filtro" value="cce.activo = 1 and e.activo = 1 and sis.activo = 1 and eid.activo = 1 #filtro#
																					and  cce.cliente_empresarial = e.cliente_empresarial
																					and  e.Ecodigo = eid.Ecodigo and  sis.sistema = eid.sistema
																					order by cce.nombre, enombre, sistema, nombre_cache"/>
										<cfinvokeargument name="align" value="left,left,left,left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="irA" value="Caches.cfm"/>
										<cfinvokeargument name="MaxRows" value="30"/>
<!--- 										<cfinvokeargument name="cortes" value="ccenombre"/> --->
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
									</cfinvoke>
								</td>
							</tr>						
						</table>
					</td>
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