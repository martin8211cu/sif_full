<cfparam name="modo" default="ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="ABC_vent" datasource="#session.tramites.dsn#" >
				insert into TPVentanilla (
				codigo_ventanilla,
				nombre_ventanilla,
				id_sucursal, 
				BMUsucodigo,
				BMfechamod)
				values (
					<cfqueryparam cfsqltype="cf_sql_char"    value="#UCase(Form.codigo_ventanilla)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_ventanilla#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
				
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_vent">
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset Form.id_ventanilla = ABC_vent.identity>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_vent" datasource="#session.tramites.dsn#">			
			delete TPVentanilla 
			where  id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_ventanilla#">				  
			and   id_sucursal 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPVentanilla"
			redirect="instituciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_ventanilla" 
			type1="numeric" 
			value1="#form.id_ventanilla#">
		<cfquery name="ABC_vent" datasource="#session.tramites.dsn#">			
			update TPVentanilla set 
			codigo_ventanilla  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_ventanilla)#">, 
			nombre_ventanilla  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_ventanilla#">, 
			BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
			BMfechamod  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where  id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_ventanilla#">
			and   id_sucursal 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
		</cfquery>
		<cfset modo="CAMBIO">				  				  
	</cfif>			
</cfif>

<cflocation url="instituciones.cfm?tab=2&tabsuc=suc2&id_inst=#form.id_inst#&id_sucursal=#form.id_sucursal#">
