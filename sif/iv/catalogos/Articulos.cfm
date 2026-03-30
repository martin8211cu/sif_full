<cf_templateheader title="Inventarios">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Art&iacute;culos'>
			<table width="100%"  border="0" cellpadding="2" cellspacing="0" >
            	<tr> 
                	<td colspan="2"><cfinclude template="../../portlets/pNavegacionIV.cfm"></td>
              	</tr>
				<tr>               	
					<td valign="top" width="60%" align="center" >
						<cfinclude template="formArticulos.cfm">
					</td>
              </tr>
            </table>
		<cf_web_portlet_end>
	<cf_templatefooter>