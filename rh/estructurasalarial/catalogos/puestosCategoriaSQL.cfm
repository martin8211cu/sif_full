<cfparam type="string" name="Form.RHPCfinicio">
<cfparam type="string" name="Form.RHPCffinal">
<cfparam type="string" name="Form.RHPcodigo">
<cfparam type="numeric" name="Form.RHTCid">
<cfif isdefined("Form.Cambio")>
	<cfparam type="numeric" name="RHPCid">
	<cfparam type="string" name="ts_rversion">
</cfif>
<cfquery name="ABC_RHPuestosCategoria" datasource="#Session.DSN#">
	set nocount on
	<cfif isdefined("Form.Alta")>
		insert RHPuestosCategoria 
		(Ecodigo, RHPcodigo, RHTCid, RHPCfinicio, RHPCffinal, BMUsucodigo, BMfalta, BMfmod)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHPcodigo#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTCid#">
			, convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHPCfinicio#">,103)
			, convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHPCffinal#">,103)
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			, getdate()
			, getdate()
		)
	<cfelseif isdefined("Form.Cambio")>
		update RHPuestosCategoria
		set RHPCfinicio = convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHPCfinicio#">,103), 
		RHPCffinal = convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHPCffinal#">,103), 
		BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
		BMfmod = <cf_dbfunction name="today">
		where RHPCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPCid#">
		and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
	<cfelseif isdefined("Form.Baja")>
		delete from RHPuestosCategoria
		where RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPCid#">
	</cfif>
	set nocount off
</cfquery>
<cfif isdefined("form.Alta")>
	<cflocation url="puestosCategoria.cfm?RHPcodigo=#Form.RHPcodigo#&RHPCfinicio=#Form.RHPCfinicio#&RHPCffinal=#Form.RHPCffinal#">
<cfelseif isdefined("form.Cambio")>
	<cflocation url="puestosCategoria.cfm?RHPCid=#Form.RHPCid#&RHPcodigo=#Form.RHPcodigo#&RHPCfinicio=#Form.RHPCfinicio#&RHPCffinal=#Form.RHPCffinal#">
<cfelse>
	<cflocation url="puestosCategoria.cfm">
</cfif>