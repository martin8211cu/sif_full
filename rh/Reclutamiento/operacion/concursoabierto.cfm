<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cf_translate key="LB_Autogestion">Autogestión</cf_translate>
	</cf_templatearea>
<cf_web_portlet_start border="true" titulo="Concursos Abiertos" skin="#Session.Preferences.Skin#">
	<cf_templatearea name="body">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ConcursosAbiertos"
			Default="Concursos Abiertos"
			returnvariable="LB_ConcursosAbiertos"/>
		
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" cellpadding="4" cellspacing="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td valign="top" nowrap  width="60%" align="center">
						<cfif isdefined("url.RHCconcurso")>
							<cfset Form.RHCconcurso = Url.RHCconcurso>
						</cfif>
						<cfif isdefined("Form.RHCconcurso") and len(Form.RHCconcurso) GT 0>
							<cfinclude template="formconcursoabierto.cfm">
						<cfelse><!--- --->
							
							<cflocation addtoken="no" url="listaconcursoabiertos.cfm">
							<!--- 							<cflocation addtoken="no" url="/cfmx/sif/rh../../Reclutamiento/operacion/listaconcursoabierto.cfm"> --->
						</cfif> 
					</td>
				</tr>
			</table>	  
	</cf_templatearea>
		<cf_web_portlet_end>
</cf_template>	  
