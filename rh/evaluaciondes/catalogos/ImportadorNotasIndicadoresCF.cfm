<cf_templateheader title="Importador de Indicadores por Centro Funcional">
	<!--- Parámetro del ID de la Relación --->
	<cfif isdefined("url.REid")>
		<cfset form.REid = "#url.REid#">
	</cfif>
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importador de Indicadores por Centro Funcional">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td valign="top" width="60%">
								<cf_sifFormatoArchivoImpr EIcodigo = 'RHINDICF'>
							</td>
							<td valign="top" align="center">
								<cf_sifimportar EIcodigo="RHINDICF" mode="in">
									<cf_sifimportarparam name="Relacion" value= "#form.Reid#">
								</cf_sifimportar>
							</td>
							<td valign="top">
								<cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" Regresar="NotasIndicadoresCF.cfm?REid=#form.REid#">
							</td>
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>
		</tr>
	</table>
	
<cf_templatefooter>
