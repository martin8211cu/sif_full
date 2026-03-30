<cfquery name="rsListaClasificacionesDato" datasource="#session.dsn#">
	select CDcodigo, CDdescripcion
	from ClasificacionesDato
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.arbol_pos#">
</cfquery>
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="2"><hr width="99%" align="center"></td></tr>
	<tr>
		<td colspan="2" style="color:##0000FF">Caracter&iacute;sticas de la Clasificaci&oacute;n</td>
	</tr>
	<tr>
	<td width="35%">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="tituloListas">Caracter&iacute;stica</td>
			</tr>
			<cfloop query="rsListaClasificacionesDato">
			<tr class="<cfif CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
			<td onClick="javascript:fnProcesarCar();">
				<a href="##" onClick="javascript:fnProcesarCar();">#CDdescripcion#</a>
			</td>
			<td><img src="../../imagenes/Borrar01_S.gif"></td>
			</tr>
			</cfloop>
		</table>
	</td>
	<td width="65%"></td>
	</tr>
</table>
</cfoutput>