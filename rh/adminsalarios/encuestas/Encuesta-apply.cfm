<cfquery datasource="#session.dsn#" name="existe">
	select EEid
	from RHEncuestadora
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
</cfquery>

<cfif existe.RecordCount>
	<cfquery datasource="#session.dsn#">
		update RHEncuestadora
		set Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#" null="#Len(form.Eid) Is 0#">,
		    ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
	</cfquery>
<cfelse>
	<cfquery datasource="#session.dsn#" name="otras">
		select EEid
		from RHEncuestadora
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		insert into RHEncuestadora (Ecodigo, EEid, Eid, ETid, 
			RHEdefault,
			BMfecha, BMUsucodigo)
		values ( 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#" null="#Len(form.Eid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#otras.RecordCount EQ 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		)
	</cfquery>
</cfif>
<cflocation url="RHEncuestadora.cfm">
