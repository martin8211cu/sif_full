<!--- actualizar/buscar/continuar --->

<cfquery datasource="asp" name="rsCurrentRev">
	select nombre from APFuente
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
	order by 1
</cfquery>
<cfparam name="form.sel" default="">

<cfloop query="rsCurrentRev">
	<cfif Not ListFind(form.sel, nombre)>
		<cfquery datasource="asp" name="rsCurrentRev">
			delete from APFuente
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
			and nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre#">
		</cfquery>
	</cfif>
</cfloop>
<cfinvoke component="asp.parches.comp.parche" method="contar" />

<cfif IsDefined('form.actualizar') And session.parche.cant_fuentes GT 0>
	<cflocation url="svnconfirmar.cfm">
<cfelseif IsDefined('form.buscar') Or IsDefined('form.actualizar')>
	<cflocation url="svnbuscar.cfm">
<cfelse>
	<cflocation url="dbmbuscar.cfm">
	<!---<cflocation url="sqlbuscar.cfm">---->
</cfif>
