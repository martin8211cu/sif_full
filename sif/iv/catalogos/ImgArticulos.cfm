<!--- 						<script language="JavaScript1.2" type="text/javascript">
							function regresar(){
								document.form1.action = 'Articulos.cfm';
								document.form1.submit();
							}
						</script> --->

<cf_templateheader title="Inventarios">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Im&aacute;genes'>
						<cfinclude template="paramURL-FORM.cfm">				
			
						<cfoutput>
							<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="##DFDFDF">
								<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
							</table>
						</cfoutput>

		  				<cfinclude template="/sif/iv/catalogos/formImgArticulos.cfm">
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>