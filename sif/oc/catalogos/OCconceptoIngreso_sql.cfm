<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>			
			<cfquery name="inserta" datasource="#session.DSN#">
				insert into OCconceptoIngreso(Ecodigo,OCIcodigo,OCIdescripcion, CFcomplementoIngreso, BMUsucodigo)
				values(	
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCIcodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCIdescripcion#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFcomplementoIngreso#" >,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
		<cfset form.OCIid = inserta.identity >
		</cftransaction>
		<cflocation url="OCconceptoIngreso.cfm?OCIid=#URLEncodedFormat(form.OCIid)#">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from OCconceptoIngreso
			where Ecodigo 	= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and OCIid 		= <cfqueryparam value="#Form.OCIid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cflocation url="OCconceptoIngreso.cfm?">
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="update" datasource="#session.DSN#">
			update OCconceptoIngreso
				set OCIcodigo				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCIcodigo#">,
					OCIdescripcion			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCIdescripcion#">,		
					CFcomplementoIngreso	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFcomplementoIngreso#">,			
					BMUsucodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			 where Ecodigo		= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			   and OCIid		= <cfqueryparam value="#Form.OCIid#" cfsqltype="cf_sql_numeric">
		</cfquery>	  
		<cflocation url="OCconceptoIngreso.cfm?OCIid=#URLEncodedFormat(form.OCIid)#">
	</cfif>
<cfelse>
	<cflocation url="OCconceptoIngreso.cfm?">	
</cfif>
	
