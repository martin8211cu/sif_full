<!--- 2014-09-26. Lizandro
Se elimina toda la logica del mantenimiento desde el Modulo de Control de Vacaciones
y se sustituye por una invocacion a Mantenimiento de Empleados, de manera que se reutilice el código
y se elimine el doble mantenimiento (este ya venía desactualizado sobre cambios hechos --->

<cf_template template="#session.sitio.template#">
	<script language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cfinvoke component="sif.Componentes.TranslateDB"
        method="Translate"
        VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
        Default="Mantenimiento de Empleados"
        VSgrupo="103"
        returnvariable="nombre_proceso"/>
    <cf_templatearea name="title">

        <cfoutput>#nombre_proceso#</cfoutput>

    </cf_templatearea>

	<cf_templatearea name="body">
		<cfinclude template="/rh/Utiles/params.cfm">
        <cf_web_portlet_start border="true" titulo="<cfoutput>#nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">
    <!--- <cfinclude template="/rh/portlets/pNavegacion.cfm"> --->
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
        <cfset form.modulocontrolvacaciones=true>
		<cfinclude template="/rh/expediente/catalogos/vacaciones.cfm">
         <cf_web_portlet_end>
	</cf_templatearea>

</cf_template>

<!---
<cf_template template="#session.sitio.template#">
	<script language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cfinvoke component="sif.Componentes.TranslateDB"
		method="Translate"
		VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
		Default="Mantenimiento de Empleados"
		VSgrupo="103"
		returnvariable="nombre_proceso"/>

	<cf_templatearea name="title">
		<cfoutput>#nombre_proceso#</cfoutput>
	</cf_templatearea>

	<cf_templatearea name="body">
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					 =========================================================
					          T A B S     D E     T R A D U C C I O N
					 =========================================================
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Identificacion"
						xmlfile="/rh/generales.xml"
						Default="Identificaci&oacute;n"
						returnvariable="vIdentificacion"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nombre"
						xmlfile="/rh/generales.xml"
						Default="Nombre"
						returnvariable="vNombre"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Empleado"
						xmlfile="/rh/generales.xml"
						Default="Empleado"
						returnvariable="vEmpleado"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Filtrar"
						xmlfile="/rh/generales.xml"
						Default="Filtrar"
						returnvariable="vFiltrar"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nuevo_Empleado"
						Default="Nuevo Empleado"
						returnvariable="vNuevoEmpleado"/>
					<!--- ========================================================= --->
					<!---          T A B S     D E     T R A D U C C I O N          --->
					<!--- ========================================================= --->

					<cf_web_portlet_start border="true" titulo="<cfoutput>#nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">
						<!--- Asignación de valores a las variables del form --->
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
						<!--- Asignación de la Navegación --->
						<cfset filtro = "">
						<cfset navegacion = "">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
						<cfif isdefined("Form.DEid")>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & #form.DEid#>
						</cfif>
						<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }) like '%" & #UCase(Form.nombreFiltro)# & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
						</cfif>
						<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & UCase(Form.DEidentificacionFiltro) & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
						</cfif>
						<cfif isdefined("Form.sel") and form.sel NEQ 1>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>
						</cfif>
						<!--- Pintado de la Pantalla --->
	   					<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<cfif isdefined("form.o") and form.o eq 4 and isdefined("form.DLLinea")>
								<cfset regresar = "javascript:history.back();">
							<cfelse>
								<cfset regresar = "/cfmx/rh/index.cfm">
							</cfif>
							<tr>
								<td>
									<!--- <cfinclude template="/rh/portlets/pNavegacion.cfm"> --->
								</td>
							</tr>
							<form name="formBuscar" method="post" action="">
								<tr>
									<td valign="middle" align="right">
								  		<label id="letiqueta1">
											<a href="javascript: buscar();"><cf_translate key="LB_Seleccione_un_Empleado">Seleccione un empleado</cf_translate></a>
										</label>
								  		<a href="javascript: buscar();"><img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"></a>
									</td>
								</tr>
							</form>
							<tr style="display: ;" id="verPagina">
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  								<tr style="display: ;" id="verPagina">
		    								<td>
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
                									<tr>
                  										<td><cfinclude template="header.cfm"></td>
                									</tr>
                									<tr>
                  										<td>
															<cfquery datasource="#Session.DSN#" name="rsEncabRevisa">
																select eve.DEid
																from EVacacionesEmpleado eve, DatosEmpleado de
																where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																	and eve.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
																	and eve.DEid=de.DEid
															</cfquery>
															<cfif rsEncabRevisa.recordCount GT 0>
																<cfinclude template="ajusteVacaciones-form.cfm">
															<cfelse>
																<div align="center"> <br><br><b><cf_translate key="MSG_Este_empleado_no_posee_ENCABEZADO_de_vacaciones">Este empleado no posee ENCABEZADO de vacaciones</cf_translate></b><br><br></div>
															</cfif>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<!--- Validaciones por medio de JavaScript --->
						<script type="text/javascript">
							<!--
							function tab_set_current (n){
								validaDEid(escape(n),'expediente-cons.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1');
							}
							//-->
						</script>
						<script language="JavaScript" type="text/javascript">
							function buscar() {
								location.href = '/cfmx/rh/controlVacaciones/operacion/ajusteVacaciones-lista.cfm';
							}
						</script>
					<cf_web_portlet_end>
				</td>
			</tr>
		</table>
	</cf_templatearea>
</cf_template>--->
