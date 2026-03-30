<!---<cfsetting enablecfoutputonly="yes">--->
<cfcontent type="text/html">
<cfheader name="Content-Disposition" value="attachment; filename=errores.htm">
<cfparam name="url.id" type="numeric" default="0">
<cfparam name="url.hash" type="string" default="">

<cfquery datasource="sifcontrol" name="enc">
	select * from IBitacora
	where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	  and IBhash = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.hash#">
</cfquery>
<cfif enc.RecordCount EQ 1>
	<cfquery datasource="sifcontrol" name="errores" maxrows="4000">
		select 
			  IBlinea as Linea
			, case IBerror
				when 1 then 'Sobran Columnas'
				when 2 then 'Fecha Incorrecta'
				when 3 then 'Dato Entero'
				when 4 then 'Dato Numerico Erroneo'
				when 5 then 'Faltan Columnas'
				else 'Incorrecto'
			end as TipoError
			, IBcolumna
			, IBdatos
		from IErrores
		where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	</cfquery>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" style=" border-collapse:collapse;">
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
			<tr>
				<td nowrap style="border:solid 1px #CCCCCC;"><cfoutput>#errores.Linea#</cfoutput></td>
				<td nowrap style="border:solid 1px #CCCCCC;"><cfoutput>#errores.TipoError#</cfoutput></td>
				<td align="right" nowrap style="border:solid 1px #CCCCCC;"><cfoutput>#errores.IBcolumna#</cfoutput></td>
				<td style="border:solid 1px #CCCCCC;">&nbsp;</td>
				<td style="border:solid 1px #CCCCCC;"><cfoutput>#errores.IBdatos#</cfoutput></td>			
			</tr>
		</cfloop>
	</table>
</cfif>
