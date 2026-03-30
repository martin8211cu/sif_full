<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
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

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
                  <!--- Navegacion --->                 
					<cfif isdefined("url.TEid") and not isdefined("form.TEid")>
						<cfset form.TEid = url.TEid>
	                </cfif>	
                  	<cfif isdefined("url.EFEid") and not isdefined("form.EFEid")>
						<cfset form.EFEid = url.EFEid>
                  	</cfif>                  <!--- fin nav. --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_FormatosdeExpediente"
						Default="Formatos de Expediente"
						returnvariable="LB_FormatosdeExpediente"/>
				  
                  <cf_web_portlet_start titulo="#LB_FormatosdeExpediente#">
				<!--- ======================================================================================== --->
				<!--- ======================================================================================== --->
				<cfquery name="rsTipo" datasource="#session.DSN#">
					select TEdescripcion 
					from TipoExpediente 
					where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEid#">
				</cfquery>

				<!--- establece los modos para los diferentes mantenimientos --->
				<cfinclude template="FormatosModo.cfm">

				<script src="/cfmx/sif/js/qForms/qforms.js"></script>
				<script language="JavaScript1.2" type="text/javascript">
					/* ====== QForms ====== */
					// specify the path where the "/qforms/" subfolder is located
					qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
					// loads all default libraries
					qFormAPI.include("*");
					//Funciones que utilizan el objeto Qform.
				
					//definicion del color de los campos con errores de validacion para cualquier instancia de qforms
					qFormAPI.errorColor = "#FFFFCC";
					/* ====== QForms ====== */

					function trim(dato) {
						dato = dato.replace(/^\s+|\s+$/g, '');
						return dato;
					}
				
					function setBtn(obj){
					    var form = obj.form;
						form.botonSel.value = obj.name;
					}

					function TiposExpediente() {
						<cfif ef_modo neq 'ALTA'>
						document.formRegresar.action = 'FormatosPrincipal.cfm';
						<cfelse>
						document.formRegresar.action = 'TiposExpediente.cfm';
						</cfif>
						document.formRegresar.modo.value = 'CAMBIO';
						document.formRegresar.submit();
					}									
				</script>
				
				<cfset navegacion = "TEid=#form.TEid#">
				<cfif isdefined("form.EFEid") and len(trim(form.EFEid)) gt 0>
					<cfset navegacion = navegacion & "&EFEid=#form.EFEid#&ef_modo=CAMBIO" >
				</cfif>
				
				<!--- Tabla principal --->
				<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<!--- Portlet de Navegacion --->
					<tr>
						<td>
							<cfset regresar = "javascript: TiposExpediente();">
							<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
							<cfset navBarItems[1] = "Estructura Organizacional">
							<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm" >
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
						</td>
					</tr>
					
					<tr><td align="center">
						<table width="98%" cellpadding="10" cellspacing="0" align="center">
							<tr>
								<td align="center" class="tituloAlterno">
									<cf_translate key="LB_TipoDeExpediente">Tipo de Expediente</cf_translate>:&nbsp; <cfoutput>#rsTipo.TEdescripcion#</cfoutput></td></tr>
						</table>
					</td></tr>
				
					<!--- Mantenimiento de Formatos de Expediente --->
					<tr>
						<td align="center">
							<table width="98%" cellpadding="0" cellspacing="0" align="center">
								<tr>
									<td align="center">
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="LB_EncabezadoDeFormatosDeExpediente"
											Default="Encabezado de Formatos de Expediente"
											returnvariable="Expediente"/>
										<cf_web_portlet_start titulo="#Expediente#">
											<cfinclude template="EFormatosExpediente.cfm">
										<cf_web_portlet_end>
									</td>
								</tr>
							</table>
						</td>
					</tr> <!--- Formatos de Expediente --->
					
					<!--- Pinta los demas mantenimientos --->
					<cfif ef_modo neq 'ALTA'>
						<!--- Detalle de Formatos de Expediente  --->
						<tr>
							<td align="center">
								<table width="98%" cellpadding="0" cellspacing="0" align="center">
									<tr>
										<td align="center">
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="LB_DetalleDeFormatosDeExpediente"
												Default="Detalle de Formatos de Expediente"
												returnvariable="Expediente"/>
											<cf_web_portlet_start titulo="#Expediente#">
												<cfinclude template="DFormatosExpediente.cfm">
											<cf_web_portlet_end>
										</td>
									</tr>
								</table>
							</td>	
						</tr>

						<!--- Acciones por tipo de Accion y Formato  --->
						<tr>
							<td align="center">
								<table width="98%" cellpadding="0" cellspacing="0" align="center">
									<tr>
										<td align="center">
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="LB_AccionesPorTipoDeExpedienteFormato"
												Default="Acciones por Tipo de Expediente/Formato"
												returnvariable="LB_AccionesPorTipoDeExpedienteFormato"/>
											<cf_web_portlet_start titulo="#LB_AccionesPorTipoDeExpedienteFormato#">
												<cfinclude template="AccionesExpediente.cfm">
											<cf_web_portlet_end>
										</td>
									</tr>
								</table>
							</td>	
						</tr>

						<!--- Usarios por tipo de Accion y Formato  --->
						<!---
						<tr>
							<td align="center">
								
								<table width="98%" cellpadding="0" cellspacing="0" align="center">
									<tr>
										<td align="center">
											<cf_web_portlet_start titulo="Usuarios por Tipo de Expediente/Formato">
												<cfinclude template="UsuariosExpediente.cfm">
											<cf_web_portlet_end>
										</td>
									</tr>
								</table>
							</td>	
						</tr>
						--->
					
					</cfif>
				
					<tr><td>&nbsp;</td></tr>
				</table><!--- Tabla principal --->
	              <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>