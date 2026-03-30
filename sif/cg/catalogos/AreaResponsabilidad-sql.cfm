<cfif IsDefined("form.Alta")>
	<cftransaction>
		<cfquery name="insAreaResp" datasource="#Session.DSN#">
			insert into CGAreaResponsabilidad (Ecodigo, CGARcodigo, CGARdescripcion, CGARresponsable, CGARemail, PCEcatid)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CGARcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CGARdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CGARresponsable#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CGARemail#" null="#Len(Trim(Form.CGARemail)) EQ 0#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
			)
			<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="insAreaResp">
	</cftransaction>
	<cfset Form.CGARid = insAreaResp.identity>

<cfelseif IsDefined("form.Cambio")>
	<cfquery name="updAreaResp" datasource="#Session.DSN#">
		update CGAreaResponsabilidad set
			CGARcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CGARcodigo#">, 
			CGARdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CGARdescripcion#">, 
			CGARresponsable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CGARresponsable#">, 
			CGARemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CGARemail#" null="#Len(Trim(Form.CGARemail)) EQ 0#">, 
			PCEcatid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
		where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

<cfelseif IsDefined("form.Baja")>
	<cftransaction>
		<cfquery name="delAreaResp" datasource="#Session.DSN#">
			delete from CGAreaResponsabilidadO
			where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
		</cfquery>
	
		<cfquery name="delAreaResp" datasource="#Session.DSN#">
			delete from CGAreaResponsabilidadD
			where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
		</cfquery>
	
		<cfquery name="delAreaResp" datasource="#Session.DSN#">
			delete from CGAreaResponsabilidad
			where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cftransaction>
</cfif>

<cfinclude template="AreaResponsabilidad-relocation.cfm">