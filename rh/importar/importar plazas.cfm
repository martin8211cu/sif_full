<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select count(1) as check1
	from RHPlazas d, #table_name# a
	where d.RHPcodigo = a.codigo
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset Vcheck1 = rsCheck1.check1>

<cftransaction>
	<cfif Vcheck1 LT 1>
	<!---/*
	  select 'Estos puestos no existen en RHPuestos',* from #table_name# a
	  where not exists 
		(select 1 from RHPuestos b 
		where b.Ecodigo = @Ecodigo 
		  and a.puesto = b.RHPcodigo )
	*/--->
		<cfquery datasource="#Session.DSN#">
			update #table_name# 
			set descripcion = 'Plaza '||codigo||' - '||p.RHPdescpuesto
			from #table_name# a, RHPuestos p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   and a.puesto = p.RHPcodigo
			   and a.descripcion is Null
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			insert INTO RHPlazas (Ecodigo, RHPcodigo, RHPdescripcion, RHPpuesto, CFid, Dcodigo, Ocodigo) 
			select <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, codigo, descripcion, puesto, CFid, Dcodigo, Ocodigo
			from #table_name# a, CFuncional b
			where a.centro_func = b.CFcodigo
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	<cfelse>
		<cfquery name="ERR" datasource="#Session.DSN#">
			select 'Datos ya existen', RHPcodigo, RHPdescripcion, RHPpuesto
			from RHPlazas d, #table_name# a
			where d.RHPcodigo = a.codigo
			and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
</cftransaction>