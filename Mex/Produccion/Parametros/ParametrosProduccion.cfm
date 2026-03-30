<cfset Titulo = "Par&aacute;metros del Sistema">
<cf_templateheader title="Par&aacute;metros del Sistema">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Titulo#">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><cfinclude template="../../../sif/portlets/pNavegacion.cfm"></td>
                
<!---                template="""../../sif/portlets/pNavegacionAD.cfm"
--->			</tr>
			<tr>
				<td><cfinclude template="formParametrosProduccion.cfm"></td>
			</tr>
		</table>		   
	<cf_web_portlet_end>
<cf_templatefooter>