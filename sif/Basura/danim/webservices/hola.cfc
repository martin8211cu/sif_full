<cfcomponent hint="WS Ejemplo">

<cffunction name="listadoCuentas" returntype="query" access="remote">
	<cfquery datasource="asp" name="ret">
		select CEcodigo,CEnombre from CuentaEmpresarial
		order by CEnombre
	</cfquery>
	<cfreturn ret>
</cffunction>

<cffunction name="listadoCuentasStruct" returntype="array" access="remote">
	<cfquery datasource="asp" name="ret">
		select CEcodigo,CEnombre from CuentaEmpresarial
		order by CEnombre
	</cfquery>
	<cfset arr = ArrayNew(1)>
	<cfloop query="ret">
		<cfset row = CreateObject("component", "CuentaEmpresarial")>
		<cfset row.CEcodigo = ret.CEcodigo>
		<cfset row.CEnombre = ret.CEnombre>
		<cfset ArrayAppend(arr, ret)>
	</cfloop>
	<cfreturn arr>
</cffunction>

<cffunction name="listadoEmpresas" returntype="query" access="remote">
	<cfargument name="CEcodigo" type="numeric">
	<cfquery datasource="asp" name="ret">
		select Ecodigo,Enombre from Empresa
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		order by Enombre
	</cfquery>
	<cfreturn ret>
</cffunction>

<cffunction name="listadoCuentasMayor" returntype="query" access="remote">
	<cfargument name="CEcodigo" type="numeric">
	<cfargument name="Ecodigo" type="numeric">
	<cftry>
	<cfquery datasource="asp" name="cache">
		select Ccache
		from Empresa e
			join Caches c
				on c.Cid = e.Cid
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	</cfquery>
	
	<cfquery datasource="#cache.Ccache#" name="ret">
		select Cmayor, Cdescripcion
		from CtasMayor
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		order by Cmayor
	</cfquery>
	<cfcatch type="any">
		<cfset ret = QueryNew('Cmayor,Cdescripcion')>
	</cfcatch>
	</cftry>
	<cfreturn ret>
</cffunction>


</cfcomponent>