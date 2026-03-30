<!---mcz--->
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr>
		<td align="center" valign="top" width="55%">
			<cf_sifFormatoArchivoImpr EIcodigo = 'IMMEJ'>
		</td>
		<td align="center" style="padding-left: 15px " valign="top">
			<cf_sifimportar EIcodigo="IMMEJ" mode="in">
				<cf_sifimportarparam name="AGTPid" value="#url.AGTPid#">
			</cf_sifimportar>
            <cfset LvarPar = ''>
			<cfif isdefined("session.LvarJA") and session.LvarJA>
                <cfset LvarPar = '_JA'>
            <cfelseif isdefined("session.LvarJA") and not session.LvarJA>
                <cfset LvarPar = '_Aux'>
            </cfif>
            
			<cfoutput>
			<form name="reg" action="agtProceso_genera_MEJORA#LvarPar#.cfm" method="post">
				<cfset AGTPid=#url.AGTPid#>
				<input type="hidden" value= "#AGTPid#" name="AGTPid" >
				<input type="submit" value="Regresar" name="btnRegresar">			
			</form>
			</cfoutput>
		</td>
		<cfif isdefined('url.Pagina')>
		<td valign="top"><!---<cf_botones exclude="Alta,Limpiar" regresar="../operacion/ValorRescate/adquisicion-lista.cfm?Pagina=#url.Pagina#" tabindex="1">---></td>
		</cfif>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
