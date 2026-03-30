<cf_htmlReportsHeaders 
	irA="index.cfm" download="false"
	FileName="Reporte_Errores_#Gvar.table_name#.xls"
	title="Reporte de Errores en #Gvar.table_name#">
<cf_templatecss>
<cfquery name="err" datasource="#Gvar.Conexion#">
	select ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, count(1) as Cantidad
	from CDErrores
	group by ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue
	order by ErrorCode
</cfquery>
<table border="0" cellpadding="0" cellspacing="0" class="AreaFiltro" align="center" width="1000"> 
	<tr>
		<td colspan="7" align="center">
			<strong>Detalle de Errores de Carga de <cfoutput>#Gvar.table_dest#</cfoutput></strong>
		</td>
	</tr>
	<tr>
		<td colspan="7">
			&nbsp;
		</td>
	</tr>
	<tr>
		<td class="TituloListas" width="10">
			&nbsp;
		</td>
		<td class="TituloListas" width="10">
			C&oacute;digo
		</td>
		<td class="TituloListas" width="280">
			Error
		</td>
		<td class="TituloListas" width="100">
			Columna
		</td>
		<td class="TituloListas" width="500">
			Detalles
		</td>
		<td class="TituloListas" width="90">
			Valor
		</td>
		<td class="TituloListas" width="10">
			Cantidad
		</td>
	</tr>
	<cfoutput query="err">
		<cfset LvarListaNon = (CurrentRow MOD 2)>
		<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))> 
		<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
			<td class="#LvarClassName#">
				#currentrow#
			</td>
			<td class="#LvarClassName#">
				#ErrorCode#
			</td>
			<td class="#LvarClassName#">
				#Message#
			</td>
			<td class="#LvarClassName#">
				#ColumnName#
			</td>
			<td class="#LvarClassName#">
				#Details#
			</td>
			<td class="#LvarClassName#">
				<cfset n = 0>	
				<cfloop list="#ColumnValue#" index="ColumnValuei">
					<cfset n = n + 1>
					<cfset ColumnTypei = ListGetAt(ColumnType,n)>
					<cfif n Gt 1>, </cfif>
					<cfif len(trim(ColumnValuei)) and ColumnValuei NEQ 'NULL'>
					<cfswitch expression="#ColumnTypei#">
						<!--- I=Entero --->
						<cfcase value="I">#LSNumberFormat(ColumnValuei,'999,999,999')#</cfcase>
						<!--- N=2 decimales --->
						<cfcase value="N">#LSNumberFormat(ColumnValuei,'999,999,999.00')#</cfcase>
						<!--- M=4 decimales --->
						<cfcase value="M">#LSNumberFormat(ColumnValuei,'999,999,999.0000')#</cfcase>
						<!--- F=6 decimales --->
						<cfcase value="F">#LSNumberFormat(ColumnValuei,'999,999,999.000000')#</cfcase>
						<!--- D=Fecha --->
						<cfcase value="D">#LSDateFormat(ColumnValuei,'dd/mm/yyyy')#</cfcase>
						<!--- %=Texto --->
						<cfdefaultcase>#ColumnValuei#</cfdefaultcase>
					</cfswitch>
					<cfelse>
					#ColumnValuei#
					</cfif>
				</cfloop>
			</td>
			<td class="#LvarClassName#">
				#Cantidad#
			</td>
		</tr>
	</cfoutput>
	<tr>
		<td colspan="7">
			&nbsp;
		</td>
	</tr>
	<tr>
		<td colspan="7" align="center">
			--Fin del Reporte--
		</td>
	</tr>
</table>