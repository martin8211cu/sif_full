
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Avance de insertado de datos
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cargando datos en la empresa'>
			<table width="95%" cellpadding="0" cellspacing="0" align="center">
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>				
				<tr><td align="center"><strong>
					<font color="#000099" style="font-family: Tahoma; font-size:12px">Por favor, espere unos minutos mientras se cargan los datos</font></strong>
				</td></tr>
				<tr><td align="center" style="vertical-align:top">
					<iframe name="ifrAvance" style=" vertical-align:top;" 
						width ="700"
						height="900"
						frameborder="0"						
						src="/cfmx/rh/nomina/operacion/insertado.cfm?<cfoutput>RCNid=#url.RCNid#&Tcodigo=#url.Tcodigo#&RCDescripcion=#url.RCDescripcion#&RCdesde=#url.RCdesde#&RChasta=#url.RChasta#</cfoutput>"
					</iframe>
				</td></tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
