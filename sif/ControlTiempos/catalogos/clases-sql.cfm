<cfif not isdefined("Form.Nuevo")>
	<cfif not len(trim(form.CTCAorden))>
		<cfquery name="dataorden" datasource="#session.DSN#">
			select coalesce(max(CTCAorden),0) as orden
			from CTClaseActividad
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset orden = dataorden.orden >
	<cfelse>
		<cfset orden = form.CTCAorden >
	</cfif>

	<cfif isdefined("Form.Alta")>
		<cfquery datasource="#session.dsn#">
			insert into CTClaseActividad(Ecodigo, CTCAdescripcion, CTCAorden)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTCAdescripcion)#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#orden#"> )
		</cfquery>

	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.dsn#">
			delete CTClaseActividad
			where CTCAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTCAcodigo#">
		</cfquery>

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CTClaseActividad" 
			redirect="clases.cfm"
			timestamp="#form.ts_rversion#"
			field1="CTCAcodigo,numeric,#form.CTCAcodigo#"
			field2="Ecodigo,integer,#session.Ecodigo#">

		<cfquery datasource="#session.dsn#">
			update CTClaseActividad
			set CTCAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CTCAdescripcion)#">,
				CTCAorden = <cfqueryparam cfsqltype="cf_sql_integer" value="#orden#">
			Where CTCAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCAcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>

	<cfquery name="resecuenciar" datasource="#session.DSN#">
		select CTCAcodigo, CTCAorden as orden
		from CTClaseActividad
		where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by CTCAorden, CTCAdescripcion
	</cfquery>
	<cfset numero = 10 >
	<cfloop query="resecuenciar">
		<cfif numero neq resecuenciar.orden >
			<cfquery datasource="#session.DSN#">
				update CTClaseActividad
				set CTCAorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#numero#">
				where CTCAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#resecuenciar.CTCAcodigo#">
			</cfquery>
		</cfif>
		<cfset numero = numero + 10 >
	</cfloop>


</cfif>


<cflocation url="clases.cfm">