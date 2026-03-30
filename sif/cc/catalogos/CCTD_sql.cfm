<cfset params = "">
<cfif isdefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into CCTransaccionesD (
			Ecodigo, 
			CCTcodigo, 
			CCTDleyenda1, 
			CCTD_CDCcodigo
			)
		values(
			<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" 		value="#form.CCTcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.CCTDleyenda1#">,
			<cfif isdefined("form.CCTD_CDCcodigo")>
				1
			<cfelse>
				0
			</cfif>
			)
	</cfquery>
	<cfset params = "&CCTDid=#form.CCTDid#">
<cfelseif isdefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update CCTransaccionesD 
			set CCTDleyenda1 = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTDleyenda1#">,
				CCTD_CDCcodigo = <cfif isdefined("form.CCTD_CDCcodigo")>1<cfelse>0</cfif>
		where CCTDid 		 = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTDid#">
	</cfquery>
	<cfset params = "&CCTDid=#form.CCTDid#">
<cfelseif isdefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from CCTransaccionesD
		where CCTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTDid#">
	</cfquery>
</cfif>
<cflocation url="CCTD.cfm?1=1#params#">
