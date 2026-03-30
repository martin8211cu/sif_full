<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Importación de Traspaso de Responsable" skin="#Session.Preferences.Skin#">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td align="center" colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" valign="top" width="55%">
				<cf_sifFormatoArchivoImpr EIcodigo="CRAFTRASLADO" tabindex="1">
			</td>
			<td align="center" style="padding-left: 15px " valign="top">
				<cf_sifimportar EIcodigo="CRAFTRASLADO" mode="in"  tabindex="1">
			</td>
		</tr>
		<tr>
			<td width="23%" valign="top" align="center" colspan="2">
			<cfoutput>
				<input name="Regresar" type="button" value="Regresar" 
				onClick="javascript: funcRegresar();">
			</cfoutput>
			</td>
		</tr>
		<tr><td>&nbsp;&nbsp;</td></tr>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>
<script  language="JavaScript1.2">
function funcRegresar(){
	location.href = "../responsables/operacion/traspaso_resposable.cfm";
}
</script>