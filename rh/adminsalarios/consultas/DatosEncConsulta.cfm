	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	  <cf_web_portlet_start border="true" titulo="Encuestas Salariales" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" cellpadding="4" cellspacing="0">
				<tr>
					<td valign="top" nowrap  width="60%" align="center">
						<cfif isdefined("url.Eid")>
							<cfset Form.Eid = Url.Eid>
						</cfif>
						<cfif not isdefined("modo")and not isdefined("Form.Eid")>
							<cfset modo = 'ALTA'>
						</cfif>
						<cfif not isdefined("modo") and isdefined("Form.Eid")>
							<cfset modo = 'CAMBIO'>
						</cfif>
						<cfif isdefined("url.Mcodigo")>
							<cfset Form.Mcodigo = Url.Mcodigo>
						</cfif>
						<cfif modo NEQ 'ALTA' and isdefined("Form.Eid")>
							<cfinclude template="formDatosEncConsulta.cfm">
						<cfelse>
							<cflocation addtoken="no" url="../../adminsalarios/consultas/listaDatosEncConsulta.cfm">
						</cfif>
					</td>
				</tr>
			</table>	  
	  <cf_web_portlet_end>
	<cf_templatefooter>	
