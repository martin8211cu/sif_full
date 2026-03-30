<cfcontent type="text/html">
<cfheader name="Content-Disposition" value="attachment; filename=errores.htm">
	<cfquery datasource="#session.dsn#" name="errores" maxrows="4000">
		select * from ErrorProceso where Ecodigo = #Session.Ecodigo# and Spcodigo = '#Session.menues.SPCODIGO#' and Usucodigo = #session.Usucodigo#
	</cfquery>

	<table width="100%" border="0" cellpadding="0" cellspacing="0" style=" border-collapse:collapse;">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="5" align="center"><strong>REPORTE DE ERRORES EN LA IMPORTACION</strong></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
				<td style="border:solid 1px #CCCCCC;">Linea</td>
				<td style="border:solid 1px #CCCCCC;">TipoError</td>
				<td align="right" style="border:solid 1px #CCCCCC;">Columna</td>
				<td style="border:solid 1px #CCCCCC;">&nbsp;</td>
				<td style="border:solid 1px #CCCCCC;">Dato</td>
		</tr>
		<cfloop query="errores">
			<cfset ArrayLineas = ArrayNew(1)>
			<cfset ArrayAppend(ArrayLineas, "#errores.Valor#")>
			<cfset Listlineas = ArrayToList(ArrayLineas, "|")>
            <cfset ArrayLineas = listtoarray(Listlineas , "|")>
			<tr>
				<td nowrap style="border:solid 1px #CCCCCC;"><cfoutput>#ArrayLineas[3]#</cfoutput></td>
				<td nowrap style="border:solid 1px #CCCCCC;"><cfoutput>#errores.Descripcion#</cfoutput></td>
				<td align="right" nowrap style="border:solid 1px #CCCCCC;"><cfoutput>#ArrayLineas[4]#</cfoutput></td>
				<td style="border:solid 1px #CCCCCC;">&nbsp;</td>
				<td style="border:solid 1px #CCCCCC;"><cfoutput>#ArrayLineas[1]#</cfoutput></td>
			</tr>
		</cfloop>
	</table>

