<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>	
		<cfquery datasource="#session.dsn#">
			insert into CTProyectos(Ecodigo, CTPdescripcion, SNcodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTPdescripcion)#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> )
		</cfquery>

	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.dsn#">
			delete CTProyectos
			where CTPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTPcodigo#">
		</cfquery>

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CTProyectos" 
			redirect="Proyectos.cfm"
			timestamp="#form.ts_rversion#"
			field1="CTPcodigo,numeric,#form.CTPcodigo#"
			field2="Ecodigo,integer,#session.Ecodigo#">

		<cfquery datasource="#session.dsn#">
			update CTProyectos
			set CTPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CTPdescripcion)#">,
				SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			Where CTPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTPcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
</cfif>
<cflocation url="Proyectos.cfm">