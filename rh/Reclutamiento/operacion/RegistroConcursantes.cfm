<!---*******************************--->
<!--- Pantalla principal para el    --->
<!--- mantenimientos de             --->
<!--- participantes para un concurso--->
<!---*******************************--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>Reclutamiento y selecci&oacute;n</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
	<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//utiles</script>
		<cf_web_portlet_start titulo="<cfoutput>Reclutamiento y selecci&oacute;n</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
<!---***********************************--->
<!--- agrega archivo de configuración   --->
<!--- y archivo de selecion de SQL      --->
<!---***********************************--->
		<cfif isdefined("url.paso")>
			<cfset Form.paso = url.paso>
		</cfif>

			<cfinclude template="RegistroConcursantes-config.cfm">
			<cfinclude template="RegistroConcursantes-update.cfm">
			
		<cfif isdefined("url.flag")>
			<cfset Form.flag = url.flag>
		</cfif>
		<cfif isdefined("url.TipoConcursante") and not isdefined("form.TipoConcursante")>
			<cfset form.TipoConcursante = url.TipoConcursante>
		</cfif>
			<br>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="1%">&nbsp;</td>
				<td valign="top">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>&nbsp;</td>
						<td>
<!---*********************************************--->
<!--- agrega archivo de cfm que indica el paso    --->
<!--- y archivo de encabezado                     --->
<!---*********************************************--->
							<cf_web_portlet_start titulo='#Gdescpasos[Gpaso+1]#'>
								<br>
								<cfinclude template="RegistroConcursantes-header.cfm">
								<cfinclude template="RegistroConcursantes-paso#Gpaso#.cfm">
								<br>
							
							<cf_web_portlet_end>
						</td>
						<td>&nbsp;</td>
					  </tr>
					</table>
				</td>
<!---*********************************************--->
<!--- agrega archivo de cfm de proceso de pasos   --->
<!--- y archivo de ayuda                          --->
<!---*********************************************--->
				<td valign="top" width="1%">
					<cfinclude template="RegistroConcursantes-progreso.cfm"><br>
					 <cfinclude template="RegistroConcursantes-ayuda.cfm">
				</td>
				<td width="1%">&nbsp;</td>
			  </tr>
			</table>
		 <br>
		 <cf_web_portlet_end>
	</cf_templatearea>
</cf_template>