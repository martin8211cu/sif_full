<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">	
<cfquery name="rsDatos" datasource="#session.DSN#">
	select  sum(c.Monto) as Monto, 
			b.CPformato, 
			c.Periodo, 
			c.Mes , 
			a.RHEid, 
			d.RHEdescripcion, 
			d.RHEfdesde, 
			d.RHEfhasta,
			convert(varchar,c.Periodo) #LvarCNCT#'-'#LvarCNCT# convert(varchar,c.Mes) as Corte
			
	from RHFormulacion a
		inner join RHEscenarios d
			on a.RHEid = d.RHEid
			and d.RHEestado = 'A'
		inner join RHCFormulacion b
			on a.RHFid = b.RHFid
		inner join RHCortesPeriodoF c
			on b.RHCFid = c.RHCFid			
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
			and a.RHEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfif>
		and b.CPformato is not null	
		and ltrim(rtrim(b.CPformato))!= ''	 
	group by b.CPformato, c.Periodo, c.Mes, a.RHEid, d.RHEdescripcion, d.RHEfdesde, d.RHEfhasta, convert(varchar,c.Periodo) #LvarCNCT#'-'#LvarCNCT# convert(varchar,c.Mes)
	order by a.RHEid, c.Periodo, c.Mes, b.CPformato
</cfquery>

<cfreport format="#form.formato#" template= "PresupuestosAprobados.cfr" query="rsDatos">
	<cfreportparam name="Edescripcion" value="#session.enombre#">
</cfreport>
