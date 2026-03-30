<cfif isdefined('url.imprimir')>
	<cfif isdefined('url.ACcodigodesde') and not isdefined('form.ACcodigodesde')>
		<cfset form.ACcodigodesde = url.ACcodigodesde>
	</cfif>
	<cfif isdefined('url.ACcodigohasta') and not isdefined('form.ACcodigohasta')>
		<cfset form.ACcodigohasta = url.ACcodigohasta>
	</cfif>
</cfif>

<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }

.style4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
.style5 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 7px;
	font-weight: bold;
}
-->
</style>

<!--- Asignación de valores de la tabla de Procesos --->
<cfset HoraReporte = Now()> 

<!--- Consulta para pintar el reporte de Categorias --->
<cfquery name="listaDetalle" datasource="#session.DSN#" maxrows="22001">
	select a.ACcodigo, b.ACdescripcion
		, case b.ACmetododep when 1 then 'Linea Recta' when 2 then 'Ambos' when 3 then 'Suma Digitos' end as ACmetododep
		, a.ACid, a.ACcodigodesc, b.ACcodigodesc as ACCcodigodesc, a.ACdescripcion as ACCdescripcion
		, a.ACdepreciable
		, a.ACrevalua
		, case a.ACtipo when 'M' then 'Por Monto' when 'P' then 'Por Porcentaje' end as ACtipo
		, a.ACvalorres
	from AClasificacion a
		inner join ACategoria b on b.ACcodigo = a.ACcodigo and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif form.ACcodigodesde GT 0>
		and a.ACcodigo >= <cfoutput>#form.ACcodigodesde#</cfoutput>
	</cfif>
	<cfif form.ACcodigohasta GT 0>
		and a.ACcodigo <= <cfoutput>#form.ACcodigohasta#</cfoutput>
	</cfif>
	order by a.ACcodigo

</cfquery>


<!--- Valida que la consulta del reporte no pase de las 22000 registros --->
<cfif listaDetalle.recordcount GT 22000>
	<table width="50%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td align="left">
				<p>
					La cantidad de activos sobrepasa los 22000 registros. Genero <cfoutput>#listaDetalle.recordcount#</cfoutput> Registros<br>
					Reduzca el rango mediante los filtros o utilice la opción de cargar la información en un archivo (Descargar).
					Proceso Cancelado.
				</p>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	
<cfelse>
	<cf_htmlReportsHeaders 
			title="Categor&iacute;as Clases" 
			filename="RepCategoriasClases.xls"
			irA="repCategoriasClases.cfm?ACcodigodesde="
			download="no"
			preview="no">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="6" align="center" bgcolor="#E4E4E4"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>		</tr>			
		<tr>
			<td colspan="6" align="center"><span class="style1">Lista de Categor&iacute;as Clases</span></td>
		</tr>
		<tr>
			<td colspan="6" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
		</tr>
		
		<cfflush interval="128">
		<cfset temp_categoria = "">
		<cfoutput query="listaDetalle">
			<cfif temp_categoria NEQ #ACcodigo#>
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr nowrap="nowrap" class="style5">
				<td align="left" bgcolor="CCCCCC" colspan="6"><strong>Categor&iacute;a:</strong> #ACCcodigodesc# - #ACdescripcion# &nbsp;&nbsp;&nbsp;<strong>M&eacute;todo de Depreciaci&oacute;n:</strong> #ACmetododep#</td>
			</tr>
			<tr class="style5">
				<td align="left" bgcolor="E1E1E1"><strong>Clase</strong></td>
				<td align="left" bgcolor="E1E1E1"><strong>Descripci&oacute;n</strong></td>
				<td align="left" bgcolor="E1E1E1"><strong>Depreciable</strong></td>
				<td align="left" bgcolor="E1E1E1"><strong>Revaluable</strong></td>
				<td align="left" bgcolor="E1E1E1"><strong>Tipo de Valor Residual</strong></td>
				<td align="left" bgcolor="E1E1E1"><strong>Valor Residual</strong></td>
			</tr>

				<cfset temp_categoria = ACcodigo>
			</cfif>
			<tr nowrap="nowrap" class="style4">
				<td align="left">#ACcodigodesc#</td>
				<td align="left">#ACCdescripcion#</td>
				<td align="left">#ACdepreciable#</td>
				<td align="left">#ACrevalua#</td>
				<td align="left">#ACtipo#</td>
				<td align="left">#ACvalorres#</td>
			</tr>
		</cfoutput>
	</table>
</cfif>