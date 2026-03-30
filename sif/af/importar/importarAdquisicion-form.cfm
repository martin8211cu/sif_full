
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr>
		<td align="center" width="2%">&nbsp;</td>
		<td align="center" valign="top" width="55%">
			<cf_sifFormatoArchivoImpr EIcodigo = 'IMPADQ'>
		</td>
		
		<td align="center" style="padding-left: 15px " valign="top">
			<cf_sifimportar EIcodigo="IMPADQ" mode="in" />
		</td>
		<cfif isdefined('url.Pagina')>
		<td valign="top"><cf_botones exclude="Alta,Limpiar" regresar="../operacion/adquisicion-lista.cfm?Pagina=#url.Pagina#" tabindex="1"></td>
		</cfif>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
