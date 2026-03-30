<cfif IsDefined('form.borrar')>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from RHEncuestaPuesto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from RHEncuestadora
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
		</cfquery>
	</cftransaction>
	<cflocation url="RHEncuestadora.cfm">
<cfelse>
	<cfquery datasource="#session.dsn#">
		update RHEncuestadora
		set Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#" null="#Len(form.Eid) Is 0#">,
			ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">,
			RHEdefault = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IsDefined('form.RHEdefault')#">,
			RHEinactiva = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IsDefined('form.RHEinactiva')#">,
			BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
	</cfquery>
	<cflocation url="RHEncuestaPuesto.cfm?EEid=#URLEncodedFormat(form.EEid)#">
</cfif>
