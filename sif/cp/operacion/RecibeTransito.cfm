<cf_templateheader title="SIF - Cuentas por Pagar">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Recepción de Productos en Tránsito">
	 
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td valign="top">
					<cfinclude template="../../portlets/pNavegacion.cfm">
				</td>
			  </tr>
              <tr> 
                <td width="100%" valign="top"><cfinclude template="RecibeTransito_form.cfm"></td>
              </tr>
			  <tr>
			  	<td>&nbsp;</td>
			  </tr>
            </table>
		
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>