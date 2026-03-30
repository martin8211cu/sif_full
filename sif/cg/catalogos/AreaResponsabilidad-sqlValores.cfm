<cfif IsDefined("form.Alta")>
	<cfquery name="insAreaRespD" datasource="#Session.DSN#">
		insert into CGAreaResponsabilidadD (CGARid, PCDcatid)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCDcatid#">
		)
	</cfquery>

<cfelseif IsDefined("form.Cambio")>

<cfelseif IsDefined("form.BajaD") and Form.BajaD EQ 1 and isdefined("Form.CGARDid") and Len(Trim(Form.CGARDid))>

	<cfquery name="delAreaRespD" datasource="#Session.DSN#">
		delete from CGAreaResponsabilidadD
		where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
		and CGARDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARDid#">
	</cfquery>

</cfif>

<cfset Form.tab = 1>
<cfinclude template="AreaResponsabilidad-relocation.cfm">
