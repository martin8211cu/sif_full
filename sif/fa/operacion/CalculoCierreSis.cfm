<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		 
      		Facturaci&oacute;n
		
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cierre de Caja'>
	 
				<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
					<tr><td><cfinclude template="../../portlets/pNavegacionFA.cfm"></td></tr>
					<tr><td align="center">
						<table width="90%" align="center">
							<tr><td><cfinclude template="formCalculoCierreSis.cfm"></td></tr>
						</table>
					</td></tr>
				</table>
		  
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>