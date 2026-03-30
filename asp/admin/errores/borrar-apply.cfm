<cfset op=">=">
<cfif sort lt 0>
	<cfset op="<=">
</cfif>

<cfquery datasource="aspmonitor" name="lista">
	select errorid from MonErrores
	where eliminar = 0
	<cfif abs(sort) is 1>
		order by errorid
	<cfelseif abs(sort) is 2>
		order by upper(componente)
	<cfelseif abs(sort) is 3>
		order by upper(titulo)
	</cfif>
	<cfif sort lt 0> desc </cfif>
</cfquery>

<!--- buscar el siguiente elemento en la lista --->
<cfset MaxRows_lista=16>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(lista.RecordCount,1))>

<cfset usenext=false>
<cfset nextvalue="">
<cfloop query="lista" startRow="#StartRow_lista#">
	<cfif usenext><cfset nextvalue=errorid><cfbreak></cfif>
	<cfif errorid is id><cfset usenext=true></cfif>
</cfloop>
<cfif len(nextvalue)eq 0><cfset nextvalue = lista.errorid></cfif>

<!--- borrar anterior y seguir --->
<cfquery datasource="aspmonitor">
	update MonErrores
	set eliminar =  1
	where errorid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
</cfquery>
<cflocation url="index.cfm?PageNum_lista=#url.PageNum_lista#&sort=#url.sort#&id=#nextvalue#">
