<cfoutput>
	<input type="hidden" name="CTid" value="<cfif ExisteCuenta>#rsCuenta.CTid#</cfif>">
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr><td>
			<cfinclude template="cuenta-resumen-cuenta.cfm">
		</td></tr>
		<tr align="center"><td class="subTitulo">Mecanismo de Env&iacute;o</td></tr>
		<tr><td>
			<cfinclude template="cuenta-resumen-envio.cfm">	
		</td></tr>
		<tr align="center"><td class="subTitulo">Forma de Cobro</td></tr>
		<tr><td>
			<cfinclude template="cuenta-resumen-cobro.cfm">	
		</td></tr>
		<tr><td>
			<cfinclude template="cuenta-resumen-garantia.cfm">	
		</td></tr>	
	</table>
</cfoutput>