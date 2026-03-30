<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select count(1) as check1
	from    #table_name# a, 
			Departamentos b
	where   b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			and b.Deptocodigo = a.Codigo
</cfquery>
<cfset Vcheck1 = rsCheck1.check1>

<cftransaction>
	<cfif Vcheck1 LT 1>
		<cfquery datasource="#Session.DSN#">
			insert into Departamentos (Ecodigo,  Deptocodigo, Dcodigo, Ddescripcion)
			select <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, Codigo, Numero, Descripcion 
			from #table_name#
		</cfquery>
			
	<cfelse>
		<cfquery name="ERR" datasource="#Session.DSN#">
			select 'Registros ya insertados' as Motivo, <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> as Empresa, 
				   Codigo as Código, Descripcion as Descripción 
			from   #table_name# a, 
				   Departamentos b
			where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and b.Deptocodigo = a.Codigo
			order by Codigo
		</cfquery>
	</cfif>
</cftransaction>	