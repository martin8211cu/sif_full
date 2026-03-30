<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Generar Distribucion
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generar Distribucion'>
	 
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2">
                    
					<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#DFDFDF">
					  <tr align="left"> 
							<td>
							<cfinclude template="../../portlets/pNavegacion.cfm">
							</td>
                      </tr>
                    </table>					
				</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td valign="top"> </td>
                <td valign="top">
                  <cfinclude template="formDistribuir.cfm">
                </td>
              </tr>
            </table>
		  
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>