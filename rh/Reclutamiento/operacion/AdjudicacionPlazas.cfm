<cfoutput>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ReclutamientoYSeleccion"
			Default="Reclutamiento y selecci&oacute;n"
			returnvariable="LB_ReclutamientoYSeleccion"/>
		<cf_web_portlet_start titulo="#LB_ReclutamientoYSeleccion#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cfif isdefined("url.Paso")><cfset form.paso = url.Paso></cfif>
		<cfparam name="form.Paso" default="0">
		<cfparam name="form.RHCconcurso" default="">
		<cfif isdefined('url.RHCconcurso') and len(trim(url.RHCconcurso))>
			<cfset form.RHCconcurso = url.RHCconcurso>
		</cfif>
		<cfif form.Paso eq ""><cfset form.Paso = "0"></cfif>
		<cfif isdefined("form.btnSiguiente")>
			<cfset form.Paso = form.Paso+1>
		</cfif>
		<cfif isdefined("form.btnAnterior")>
			<cfset form.Paso = form.Paso-1>
		</cfif>
		<cfif isdefined("form.Paso") and form.Paso EQ 0>
			<cfset url.RHCconcurso = "">
			<cfset form.RHCconcurso = "">
		</cfif>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ListaDeConcursosTerminados"
			Default="Lista de concursos terminados"
			returnvariable="LB_ListaDeConcursosTerminados"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_AdjudicacionDePlazas"
			Default="Adjudicación de plazas"
			returnvariable="LB_AdjudicacionDePlazas"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_IngresoDeDatosDeLosConcursantes"
			Default="Ingreso de datos de los concursantes"
			returnvariable="LB_IngresoDeDatosDeLosConcursantes"/>
		<cfswitch expression="#form.Paso#">
			<cfcase value="0"><cfset  vsTitulo =LB_ListaDeConcursosTerminados></cfcase>
			<cfcase value="1"><cfset  vsTitulo =LB_AdjudicacionDePlazas></cfcase>
			<cfcase value="2"><cfset  vsTitulo =LB_IngresoDeDatosDeLosConcursantes></cfcase>
		</cfswitch>
		<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="1%">&nbsp;</td>
			<td valign="top" width="80%">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top" width="75%">
							<cf_web_portlet_start titulo='#vsTitulo#'>
								<!---Pinta un encabezado común en todas las pantallas--->
								<cfinclude template="AdjudicacionPlazas-header.cfm">
							  <!---Pinta la pantalla correspondiente--->
								<cfif form.Paso EQ 0>
									<cfinclude template="AdjudicacionPlazas-paso0.cfm">
								<cfelseif form.Paso EQ 1>
									<cfinclude template="AdjudicacionPlazas-paso1.cfm">
								<cfelseif form.Paso EQ 2>
									<cfinclude template="AdjudicacionPlazas-paso2.cfm">
								<cfelseif form.Paso EQ 3>
									<cfinclude template="AdjudicacionPlazas-paso3.cfm">
								</cfif>
							<cf_web_portlet_end>
						</td>
					</tr>
				</table>
			</td>
			<td width="1">&nbsp;</td>
			<td valign="top" width="20%">
				<!---Secciones de progreso y ayuda--->
				<cfinclude template="AdjudicacionPlazas_progreso.cfm"><br>
				<!----
				<table width="100%" class="ayuda">
					<tr><td><cfinclude template="AdjudicacionPlazas_ayuda.cfm"></td></tr>
				</table>
				------>
			</td>
		  </tr>
		</table>
		</br>
		<cf_web_portlet_end>
	<cf_templatefooter>
</cfoutput>

