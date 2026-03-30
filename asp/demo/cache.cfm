<!--- existe el cache --->
<cfquery name="cache" datasource="asp">
	select Cid
	from Caches
	where upper(Ccache) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(_cache)#">
</cfquery>

<!--- Inserta el cache --->
<cfif cache.recordcount eq 0 >
	<cfquery name="insertcache" datasource="asp">
		insert into Caches(CEcodigo, Ccache, Cexclusivo)
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta.identity#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_cache#">,
				 1 )
		<cf_dbidentity1 datasource="asp">
	</cfquery>
	<cf_dbidentity2 datasource="asp" name="insertcache">
	<cfquery name="cache" dbtype="query">
		select identity as Cid from insertcache
	</cfquery>
</cfif>

<!--- Asocia el cache a la cuenta empresarial --->
<cfquery datasource="asp">
	insert INTO CECaches (CEcodigo, Cid, BMfecha, BMUsucodigo)
	values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta.identity#">,
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#cache.Cid#">,
			 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> )
</cfquery>