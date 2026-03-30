<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConsultaDeConcursosTerminados"
	Default="Consulta de Concursos Terminados"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_ConsultaDeConcursosTerminados"/>
﻿<cf_templateheader title="#LB_ConsultaDeConcursosTerminados#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	  <cf_web_portlet_start border="true" titulo="Consultas" skin="#Session.Preferences.Skin#">

			<cfinclude template="/rh/portlets/pNavegacion.cfm">

			<table width="100%" cellpadding="4" cellspacing="0">
				<tr>
					<td valign="top" nowrap  width="60%" align="center">
						<cfif not isdefined("modo")>
							<cfset modo = "alta">
						</cfif>
						<!--- <cfif isdefined("url.RHCconcurso") and LEN(url.RHCconcurso) NEQ 0>
							<cfset Form.RHCconcurso = Url.RHCconcurso>
						</cfif>
						<cfif isDefined("Url.RHPCid") and not isDefined("form.RHPCid")>
							<cfset form.RHPCid = Url.RHPCid>
						</cfif>		 --->							

						<cfif isdefined("Form.RHCconcurso") and LEN(Form.RHCconcurso) GT 0>
<!--- 							<cfinclude template="Evaluaciones.cfm">--->						
						<cfelse>
							<cflocation addtoken="no" url="/cfmx/rh/Reclutamiento/consultas/ConsulaConTerminados-lista.cfm">
						</cfif>
					</td>
				</tr>
			</table>	  
	  <cf_web_portlet_end>
<cf_templatefooter>	  
