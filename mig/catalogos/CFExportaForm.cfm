<cfset titulo = 'Exportar Centros Funcionales'>

<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr>
		<td align="center" style="padding-left: 15px " valign="top">
			<cf_sifimportar EIcodigo="CFEXPORTADOR" mode="out">
				<cf_sifimportarparam name="CFpk" value="#url.CFpk#">
			</cf_sifimportar>
			<cf_botones exclude="Alta,Limpiar" regresar="CFuncional.cfm?CFpk=#url.CFpk#&tab=1" tabindex="1">
		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
