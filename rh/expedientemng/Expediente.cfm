<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Default="Nuevo Expediente" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate"VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" VSgrupo="103"/>				
<cfinvoke Key="LB_Expediente_Medico" Default="Expediente M&eacute;dico"	 returnvariable="LB_Expediente_Medico" component="sif.Componentes.Translate" method="Translate"/>
<!--- VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>

<cfif isdefined("cgi.HTTP_REFERER") and len(trim(cgi.HTTP_REFERER)) and ( FindNoCase('Consultorio.cfm', cgi.HTTP_REFERER) or FindNoCase('Expediente-lista.cfm', cgi.HTTP_REFERER)) >
	<cfcookie name = "expMedico_registrar" value = "Consultorio.cfm"	>	
	<cfif FindNoCase('Expediente-lista.cfm', cgi.HTTP_REFERER)>
		<cfcookie name = "expMedico_registrar" value = "Expediente-lista.cfm"	>	
	</cfif>
</cfif>

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
				   <cfset navBarLinks[1] = "/cfmx/rh/expedientemng/Expediente-lista.cfm">
				   <cfset navBarItems[1] = "#LB_Expediente_Medico#">
				   <cfset navBarStatusText[1] = "#LB_Expediente_Medico#">		 
				   <cfset Regresar = "/cfmx/rh/expedientemng/Expediente-lista.cfm">
				   <cfinclude template="/rh/portlets/pNavegacion.cfm">

				   <cfif isdefined("Form.btnCrear") or (isdefined("Form.IEid") and Len(Trim(Form.IEid)))>
					  	<cfinclude template="frame-registrarExpediente.cfm">
				   <cfelse>
						<cfinclude template="frame-nuevoExpediente.cfm">
				   </cfif>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>