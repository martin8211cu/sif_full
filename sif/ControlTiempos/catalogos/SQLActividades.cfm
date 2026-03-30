<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery datasource="#session.dsn#">
			insert into CTActividades(Ecodigo, CTAdescripcion, CTAhvisita, CTCAcodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTAdescripcion)#">,
					 <cfif isdefined("Form.CTAhvisita")>1<cfelse>0</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCAcodigo#"> )
		</cfquery>

	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.dsn#">
			delete CTActividades
			where CTAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTAcodigo#">
		</cfquery>

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CTActividades" 
			redirect="Actividades.cfm"
			timestamp="#form.ts_rversion#"
			field1="CTAcodigo,numeric,#form.CTAcodigo#"
			field2="Ecodigo,integer,#session.Ecodigo#">

		<cfquery datasource="#session.dsn#">
			update CTActividades
			set CTAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTAdescripcion)#">,
				CTAhvisita = <cfif isdefined("Form.CTAhvisita")>1<cfelse>0</cfif>,
				CTCAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCAcodigo#">
			where CTAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTAcodigo#">
		</cfquery>
	</cfif>
</cfif>
<cflocation url="Actividades.cfm">