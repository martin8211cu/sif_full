<cfif IsDefined('url.sec')>
	<!--- restablecer secuencias --->
	<cfparam name="url.sec" type="numeric">
	
	<cfquery datasource="asp" name="APParcheSQL">
		select archivo
		from APParcheSQL
		where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		order by secuencia
	</cfquery>
	<cfset puesto = 0>
	<cfset new_sec = 0>
	<cfloop query="APParcheSQL">
		<cfif archivo neq url.archivo>
			<cfset new_sec = new_sec + 1>
			<cfif new_sec EQ url.sec>
				<cfset new_sec = new_sec + 1>
			</cfif>
			<cfquery datasource="asp">
				update APParcheSQL
				set secuencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_sec#">
				where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
				  and archivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#archivo#">
			</cfquery>
		</cfif>
	</cfloop>

	<cfquery datasource="asp">
		update APParcheSQL
		set secuencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.sec#">
		where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		  and archivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.archivo#">
	</cfquery>
	
	<cflocation url="sqlbuscar.cfm">
<cfelse>
	<!--- actualizar/buscar/continuar --->
	
	<cfquery datasource="asp" name="APParcheSQL">
		select nombre, dbms, esquema
		from APParcheSQL
		where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		order by secuencia
	</cfquery>
	
	<cfparam name="form.sel" default="">
	<cfloop query="APParcheSQL">
		<cfif Not ListFind(form.sel, dbms & '/' & esquema & '/' & nombre)>
			<cfquery datasource="asp">
				delete from APParcheSQL
				where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
				  and dbms = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dbms#">
				  and esquema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#esquema#">
				  and nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre#">
			</cfquery>
		</cfif>
	</cfloop>
	<cfinvoke component="asp.parches.comp.parche" method="contar" />
	
	<cfif IsDefined('form.actualizar')>
		<cflocation url="sqlbuscar.cfm">
	<cfelseif IsDefined('form.buscar')>
		<cflocation url="sqlbuscar.cfm">
	<cfelse>
		<cflocation url="segbuscar.cfm">
	</cfif>
</cfif>