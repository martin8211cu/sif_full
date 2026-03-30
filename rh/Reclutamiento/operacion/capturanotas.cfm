<cf_template template="#session.sitio.template#">
	<script language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
      Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cfif isDefined("Url.RHCconcurso") and not isDefined("form.RHCconcurso")>
		<cfset form.RHCconcurso = Url.RHCconcurso>
	</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Captura notas del Concurso'>
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfinclude template="capturanotas-form.cfm">
				<cf_web_portlet_end>	
			</td>	
		</tr>
	</table>	
	</cf_templatearea>
</cf_template>
