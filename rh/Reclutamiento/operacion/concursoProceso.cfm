<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>Reclutamiento y selecci&oacute;n</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="<cfoutput>Reclutamiento y selecci&oacute;n</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<cfinclude template="concursoProceso-update.cfm">
			<cfinclude template="concursoProceso-config.cfm">
			<cfinclude template="concursoProceso-getData.cfm">
			
			<br>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="1%">&nbsp;</td>
				<!--- Columna de Ayuda --->
				<td valign="top">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>&nbsp;</td>
						<td>
							<cf_web_portlet_start titulo='#Gdescpasos[Gpaso+1]#'>
								<br>
								<cfinclude template="concursoProceso-header.cfm">
								<cfinclude template="concursoProceso-paso#Gpaso#.cfm">
								<br>
							<cf_web_portlet_end>
						</td>
						<td>&nbsp;</td>
					  </tr>
					</table>
				</td>
				<!--- Columna de Menú de Pasos y Sección de Ayuda --->
				<td valign="top" width="1%">
					<cfinclude template="concursoProceso-progreso.cfm"><br>
					<cfinclude template="concursoProceso-ayuda.cfm">
				</td>
				<td width="1%">&nbsp;</td>
			  </tr>
			</table>
			<br>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>