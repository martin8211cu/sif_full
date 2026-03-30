<cfset modoCalifExp = "ALTA">
<cfset params = ''>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1
			from RHExpExternaEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and ltrim(rtrim(RHPcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ltrim(rtrim(form.RHPcodigo))#">
		</cfquery>
		<cfif rsExiste.recordCount GT 0>
			<cfquery name="updateCalificacion" datasource="#session.DSN#">
				update RHExpExternaEmpleado
				set RHEEEannos  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEEannos#">,
					BMusumod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechamod = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and ltrim(rtrim(RHPcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ltrim(rtrim(form.RHPcodigo))#">
			</cfquery>
		<cfelse>
			<cfquery name="insertCalificacion" datasource="#session.DSN#">
				insert into RHExpExternaEmpleado(DEid, Ecodigo, RHPcodigo, RHEEEannos , BMusumod, BMfechamod)
				values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ltrim(rtrim(form.RHPcodigo))#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEEannos#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">				
				)
			 </cfquery>
		</cfif>
	<cfelseif isdefined('form.Baja')>
		<cfquery name="deleteCalificacion" datasource="#session.DSN#">
			delete from RHExpExternaEmpleado
			where RHEEEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEEEid#">
		</cfquery>
	<cfelseif isdefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHExpExternaEmpleado"
			redirect="experiencia.cfm"
			timestamp="#form.ts_rversion#"				
			field1="RHEEEid"  type1="numeric" value1="#form.RHEEEid#">
			
		<cfquery name="updateCalificacion" datasource="#session.DSN#">
			update RHExpExternaEmpleado
			set RHEEEannos  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEEannos#">,
				BMusumod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				BMfechamod = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where RHEEEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEEEid#">
		</cfquery>
		<cfset modoCalifExp = "CAMBIO">
	</cfif>
</cfif>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "modoCalifExp=" & modoCalifExp>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "DEid=" & form.DEid>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "tab=" & 3>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "o=" & 3>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "sel=" & 1>
<cfif isdefined("form.Cambio")>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "RHEEEid=" & form.RHEEEid>
</cfif>
<cflocation url="expediente.cfm#params#">