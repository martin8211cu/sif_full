<cfoutput>
<form name="formD" method="post" action="LiquidacionAnticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#">


<input type="hidden" name="GELid" value="#form.GELid#" />
<cfquery name="rsCaja" datasource="#session.dsn#">
	select a.CCHid, m.Miso4217
	from 
	GEliquidacion a
	inner join CCHica c
		inner join Monedas m
		on c.Mcodigo=m.Mcodigo
	on c.CCHid=a.CCHid
	where GELid=#form.GELid#
</cfquery>

<cfquery name="rsDev" datasource="#session.dsn#">
	select GELtotalDevoluciones from GEliquidacion where GELid=#form.GELid#
</cfquery>
	<table align="center">
		<tr>
			<td>
				<strong>Monto de Devolución</strong>
			</td>
			<td>
				<cfif rsDev.recordcount gt 0>
					<cf_inputNumber name="MontoD" value="#rsDev.GELtotalDevoluciones#" size="15" enteros="13" decimales="2" ><strong>#rsCaja.Miso4217#</strong>
				<cfelse>
					<cf_inputNumber name="MontoD" value="0.00" size="15" enteros="13" decimales="2" ><strong>#rsCaja.Miso4217#</strong>
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<input type="submit" name="AgregarD" value="Agregar">
			</td>
		</tr>
	</table>
</cfoutput>
</form>
