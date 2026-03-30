<cfset params = "">
<cfif isdefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into CCTrpttranapl (Ecodigo, CCTcolrpttranapl, CCTcolrpttranapldesc)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTcolrpttranapl#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcolrpttranapldesc#">)
	</cfquery>
	<cfset params = "&CCTcolrpttranapl=#form.CCTcolrpttranapl#">
<cfelseif isdefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update CCTrpttranapl 
		set CCTcolrpttranapldesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcolrpttranapldesc#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and CCTcolrpttranapl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTcolrpttranapl#">
	</cfquery>
	<cfset params = "&CCTcolrpttranapl=#form.CCTcolrpttranapl#">
<cfelseif isdefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from CCTrpttranapl
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and CCTcolrpttranapl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTcolrpttranapl#">
	</cfquery>	
	<cfquery datasource="#session.dsn#">
		update CCTrpttranapl
			set CCTcolrpttranapl = CCTcolrpttranapl - 1
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and CCTcolrpttranapl > <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTcolrpttranapl#">
	</cfquery>
</cfif>
<cflocation url="CCTrpttranapl.cfm?Pagina=#form.Pagina#&#params#">
