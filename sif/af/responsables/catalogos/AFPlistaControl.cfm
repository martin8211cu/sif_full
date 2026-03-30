<cf_templateheader title="Configuración de Listas ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Configuración de Listas '>
        	<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr> 
					<td valign="top" width="65%">
						<cfset SScodigo = "SIF">
                        <cfset SMcodigo = "AF">
                        <cfset IRA 		= "AFPlistaControl-sql.cfm">
						<cfinclude template="AFPlistaControl-form.cfm"> 
					</td>
				</tr>
			</table>
    <cf_web_portlet_end>
<cf_templatefooter>