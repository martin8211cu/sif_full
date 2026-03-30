<cfif RHPLPid GT 0>
	<cfquery name="rsRHLiquidacionPersonal" datasource="#session.dsn#">
		select a.RHPLPid, 
			   {fn concat({fn concat({fn concat({ fn concat( b.DEapellido1, ' ') }, b.DEapellido2)}, ' ')}, b.DEnombre) } as nombre,
		   	   b.DEidentificacion as DEidentificacion, coalesce(a.RHPLPrenta, 0) as renta
		from RHPreLiquidacionPersonal a
		  inner join DatosEmpleado b
			on a.Ecodigo = b.Ecodigo
			and a.DEid = b.DEid
		where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
	</cfquery>
</cfif>