<cfquery name="rs3100" datasource="#session.dsn#">
	select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 3100
</cfquery>
<cfif rs3100.Recordcount GT 0 and rs3100.Pvalor EQ 1>
	<cfset Importador = "IMPCLASEEXT">
<cfelse>
	<cfset Importador = "IMPCLASE">
</cfif>

<cf_templateheader title=" Importaci&oacute;n de Clases">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Clases">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="3" align="center">&nbsp;</td>
			</tr>
			<tr>
				<td align="center" style="padding-left: 15px " valign="top">
					<cf_sifFormatoArchivoImpr EIcodigo = '#Importador#'>
				</td>
				<td align="center" style="padding-left: 15px " valign="top">
					<cf_sifimportar EIcodigo="#Importador#" mode="in">				
					</cf_sifimportar>
					<cfoutput>
						<input type="button" name="btnRegresar" value="Regresar" onclick="javascript: location.href='AClasificacion.cfm'" />
					</cfoutput>
				</td>
			<cfif isdefined('url.Pagina')>
				<td valign="top"></td>
			</cfif>
			</tr>
			<tr>
				<td colspan="3" align="center">&nbsp;
					
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>