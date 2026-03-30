<cfparam name="RETIRADOS" default="false">
<cfparam name="EICODIGO" default="IMPAF_ACTIVO">
<cfif RETIRADOS><cfset EICODIGO = "IMPAF_INIRET"></cfif>
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr>
		<td align="center" width="2%">&nbsp;</td>
		<td align="center" valign="top" width="55%">
			<cf_sifFormatoArchivoImpr EIcodigo = "#EICODIGO#">
		</td>
		<td align="center" style="padding-left: 15px " valign="top">
			<cf_sifimportar EIcodigo="#EICODIGO#" mode="in">
				<cf_sifimportarparam name="Retirados" value= "#RETIRADOS#">
				<cf_sifimportarparam name="Debug" value= "false">
			</cf_sifimportar>
		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
