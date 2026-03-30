<cfif isdefined("form.Alta")>
	<cfquery datasource="#session.DSN#">
		insert into SReclamos( DRid, SRfecha, SRobs, SRestado, Usucodigo, fechaalta )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DRid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.SRfecha)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SRobs#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SRestado#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
	</cfquery>
<cfelseif isdefined("form.Cambio")>
	<cfquery datasource="#session.DSN#">
		update SReclamos
		set SRfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.SRfecha)#">,
			SRobs = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SRobs#">,
			SRestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SRestado#">
		where SRid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SRid#">
	</cfquery>		

<cfelseif isdefined("form.Baja")>
	<cfquery datasource="#session.DSN#">
		delete from SReclamos
		where SRid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SRid#">
	</cfquery>		
</cfif>

<cfoutput>
<cfset params = '?ERid=#form.ERid#&DRid=#form.DRid#'>
<cfif isdefined("form.Cambio")>
	<cfset params = params & '&SRid=#form.SRid#'>
</cfif>
<cflocation url="seguimiento.cfm#params#">
</cfoutput>