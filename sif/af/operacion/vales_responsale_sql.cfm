<cfparam name="form.action" type="string">
<cfparam name="form.params" type="string">
<cfif isdefined("form.btntransferir")>
	<cfset llaves = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(llaves)#" index="i">
		<cfquery datasource="#session.dsn#">
		insert into AFTResponsables(AFRid, DEid, Aid, AFTRfini, Usucodigo, Ulocalizacion)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">,
			<cfif len(trim(form.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"><cfelse>null</cfif>,
			<cfif len(trim(form.Aid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(form.fecha,'YYYYMMDD')#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
		)
		</cfquery>
	</cfloop>
<cfelseif isdefined("form.btnrecibir")>
	<cfset llaves = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(llaves)#" index="i">
		<cfquery datasource="#session.dsn#">
		update AFResponsables 
		set AFRffin = dateadd(dd,-1,AFTRfini),
			Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
		from AFTResponsables
		where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
		and AFTResponsables.AFRid = AFResponsables.AFRid
		</cfquery>
		<cfquery name="rsNext" datasource="#session.dsn#">
			select coalesce(max(AFRdocumento)+1,1) as value from AFResponsables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
		insert into AFResponsables (Ecodigo, CFid, DEid, Alm_Aid, Aid, AFRfini, AFRffin, AFRdocumento, Usucodigo, Ulocalizacion)
		select b.Ecodigo, b.CFid, a.DEid, a.Aid, b.Aid, a.AFTRfini, '61000101', 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNext.Value#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
		from AFTResponsables a, AFResponsables b
		where a.AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
		and a.AFRid = b.AFRid
		</cfquery>
		<cfquery datasource="#session.dsn#">
		delete from AFTResponsables
		where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
		</cfquery>
	</cfloop>				
<cfelseif isdefined("form.btnrechazar")>
	<cfset llaves = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(llaves)#" index="i">
		<cfquery datasource="#session.dsn#">
		delete from AFTResponsables
		where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
		</cfquery>
	</cfloop>				
</cfif>
<cfset dir = "#form.action##form.params#">
<cflocation url="#dir#">