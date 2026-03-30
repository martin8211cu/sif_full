<cfparam name="modoreq" default="ALTA">
<cfif isdefined("form.Agregar")>
	<cfif isdefined("form.ventanilla_default")>
		<cfquery datasource="#session.tramites.dsn#">
			update TPRFuncionarioVentanilla  set 
			ventanilla_default = 0
			where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
		</cfquery>
	</cfif>
	<cfif isdefined("form.funcionario_default")>
		<cfquery datasource="#session.tramites.dsn#">
			update TPRFuncionarioVentanilla  set 
			funcionario_default = 0
		    where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#">
		</cfquery>
	</cfif>	
	<cfquery datasource="#session.tramites.dsn#">
		insert TPRFuncionarioVentanilla( id_ventanilla, 
							  id_funcionario, 
							  ventanilla_default, 
							  funcionario_default, 
							  BMUsucodigo, 
							  BMfechamod)
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">,
				<cfif isdefined("form.ventanilla_default")>1<cfelse>0</cfif>,
				0,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
	</cfquery>
	<cfset modoreq="CAMBIO">
<cfelseif isdefined("form.Modificar")>
	<cfif isdefined("form.ventanilla_default")>
		<cfquery datasource="#session.tramites.dsn#">
			update TPRFuncionarioVentanilla  set 
			ventanilla_default = 0
			where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
			and  id_ventanilla != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#">

		</cfquery>
	</cfif>
	<cfif isdefined("form.funcionario_default")>
		<cfquery datasource="#session.tramites.dsn#">
			update TPRFuncionarioVentanilla  set 
			funcionario_default = 0
		    where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#">
			and  id_funcionario != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
		</cfquery>
	</cfif>		
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPRFuncionarioVentanilla"
			redirect="instituciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_ventanilla" 
			type1="numeric" 
			value1="#form.id_ventanilla#"
			field2="id_funcionario" 
			type2="numeric" 
			value2="#form.id_funcionario#">
	<cfquery datasource="#session.tramites.dsn#">
		update TPRFuncionarioVentanilla
		set ventanilla_default = <cfif isdefined("form.ventanilla_default")>1<cfelse>0</cfif>,
			funcionario_default = <cfif isdefined("form.funcionario_default")>1<cfelse>0</cfif>
		 where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#">
		 and id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
	</cfquery>
	<cfset modoreq="CAMBIO">
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPRFuncionarioVentanilla
		 where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#">
		 and id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
	</cfquery>
	<cfset modoreq="ALTA">
</cfif>

<cfset p = "?tab=4&id_inst=#form.id_inst#">
<cfif isdefined("form.id_funcionario") and len(trim(form.id_funcionario))>
	<cfset p = p & "&id_funcionario=#form.id_funcionario#">
</cfif>

<cflocation url="instituciones.cfm#p#">