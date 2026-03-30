<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
      		Facturaci&oacute;n	
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cierre de Caja'>
	 
		  	<table width="100%">
				<tr><td><cf_sifreporte principal="CierreCaja.cfm" datos="/sif/fa/operacion/formConsultaCierreCaja.cfm" modulo="Facturaci&oacute;n" ></td></tr>
			</table>
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>