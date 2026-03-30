<cfif IsDefined("form.Alta")>
	<cfquery name="insAreaRespO" datasource="#Session.DSN#">
		insert into CGAreaResponsabilidadO (CGARid, Ecodigo, Ocodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Empresa#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
		)
	</cfquery>

<cfelseif IsDefined("form.Cambio")>

<cfelseif IsDefined("form.BajaO") and Form.BajaO EQ 1 and isdefined("Form.CGAROid") and Len(Trim(Form.CGAROid))>

	<cfquery name="delAreaRespO" datasource="#Session.DSN#">
		delete from CGAreaResponsabilidadO
		where CGAROid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGAROid#">
		  and CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
	</cfquery>

</cfif>

<cfset Form.tab = 2>
<cfinclude template="AreaResponsabilidad-relocation.cfm">
