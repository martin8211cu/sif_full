<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#Request.Translate('ModuloFA','Facturación','/sif/Utiles/Generales.xml')#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
        <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consulta Detalle de Comisiones por Vendedor">

		<cfif isdefined("url.ETfecha") and len(trim(url.ETfecha)) and not isdefined("form.ETfecha")>
			<cfset form.ETfecha = url.ETfecha >
		</cfif>

		<cfif isdefined("url.FVid") and len(trim(url.FVid)) and not isdefined("form.FVid")>
			<cfset form.FVid = url.FVid >
		</cfif>

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td valign="top">
					<table width="100%" border="0" cellpadding="2" cellspacing="1" align="center">
						<tr><td><cfinclude template="repComisionesDetalle-form.cfm"></td></tr>
					</table>
				</td>	
			</tr>
		</table>	
        </cf_web_portlet>
</cf_templatearea>
</cf_template>