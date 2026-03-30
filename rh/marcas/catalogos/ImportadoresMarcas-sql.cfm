<cfset modo = "ALTA">
<cfif not isdefined("Form.btnNuevo")>	
	<cfif isdefined("Form.Alta")><!---AGREGAR----->
		<cftransaction>
			<cfquery name="inserta" datasource="#Session.DSN#">
				insert into RHImportadoresMarcas (EIid, Ecodigo, RHIMcodigo, RHIMdescripcion, BMfechaalta, BMUsucodigo)
					values (<cfqueryparam value="#form.EIid#" cfsqltype="cf_sql_numeric">, 
							<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Form.RHIMcodigo#" cfsqltype="cf_sql_char">, 
							<cfqueryparam value="#Form.RHIMdescripcion#" cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,							
							<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">)
			</cfquery>
		</cftransaction>
		<cfset modo = 'ALTA'>
	<cfelseif isdefined("Form.Cambio")><!---ACTUALIZAR---->
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHImportadoresMarcas"
			redirect="ImportadoresMarcas.cfm"
			timestamp="#form.ts_rversion#"
			field1="EIid" 
			type1="numeric" 
			value1="#Form.EIid#"
			field2="Ecodigo" 
			type2="Integer" 
			value2="#session.Ecodigo#">

		<cfquery datasource="#Session.DSN#">
			update RHImportadoresMarcas set 
				RHIMcodigo = <cfqueryparam value="#Form.RHIMcodigo#" cfsqltype="cf_sql_char">, 
				RHIMdescripcion = <cfqueryparam value="#Form.RHIMdescripcion#" cfsqltype="cf_sql_varchar">								
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and EIid =  <cfqueryparam value="#Form.EIid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo = 'CAMBIO'>
	<cfelseif isdefined("Form.Baja")><!----ELIMINAR---->
		<cfquery datasource="#session.DSN#">
			delete from RHImportadoresMarcas
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and EIid =  <cfqueryparam value="#Form.EIid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo = 'ALTA'>
	</cfif>
</cfif>	
<cfoutput>
<cfset params = ''>
<cfif isdefined("modo")>
	<cfset params = "&modo=" & modo>
</cfif>
<cfif modo EQ 'CAMBIO' and isdefined("form.EIid") and len(trim(form.EIid))>
	<cfset params = params & '&EIid=' & form.EIid>
</cfif>
<cflocation url="ImportadoresMarcas.cfm?1=1#params#">
</cfoutput>
