<cfoutput>
<cfif ExisteCuenta>
	<cfquery datasource="#Attributes.conexion#" name="rsProducs">
		select a.Contratoid, b.PQcodigo, b.PQnombre 
		from ISBproducto a
			inner join ISBpaquete b
				on b.PQcodigo = a.PQcodigo
				and b.Habilitado=1
		where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
			and CTcondicion not in ('C','X')
	</cfquery>
	<center>
	<cfif rsProducs.recordCount gt 0>		
		<table border="0" cellpadding="2" cellspacing="0">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td align="right"><label>Paquete</label></td>
				<td>
					<select id="contrat" name="contrat" tabindex="1">
						<cfloop query="rsProducs">
						<option value="#rsProducs.Contratoid#">#rsProducs.PQnombre#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</table>
	<cfelse>
		-- No hay cuentas activas --
	</cfif>
	</center>
</cfif>
</cfoutput>
