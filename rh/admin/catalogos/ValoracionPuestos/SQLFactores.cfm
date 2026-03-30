<cfset params = ''>
<cfif not isdefined("form.btnNuevo")>
	<cftransaction>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
				insert into RHHFactores (RHHFcodigo, RHHFdescripcion,RHHFponderacion,RHHFpuntuacion, BMUsucodigo,BMusuModif, BMfechaAlta, BMfechaModif, Ecodigo)
				 values ( <cfqueryparam value="#ucase(trim(form.RHHFcodigo))#" cfsqltype="cf_sql_char">,
						  <cfqueryparam value="#form.RHHFdescripcion#" cfsqltype="cf_sql_varchar">,
						  <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHHFponderacion, ',', '', 'all')#">,
						  <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHHFpuntuacion, ',', '', 'all')#">,
						  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_Puestos_insert">
		    <cfset params = 'modo=CAMBIO&RHHFid='&ABC_Puestos_insert.identity>
		<cfelseif isdefined("form.Cambio")>
				<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
					update RHHFactores
					set RHHFcodigo  = <cfqueryparam value="#ucase(trim(form.RHHFcodigo))#" cfsqltype="cf_sql_char">,
					RHHFdescripcion = <cfqueryparam value="#form.RHHFdescripcion#" cfsqltype="cf_sql_varchar">,
					RHHFponderacion = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHHFponderacion, ',', '', 'all')#">,
					RHHFpuntuacion  = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHHFpuntuacion, ',', '', 'all')#">,
					BMUsucodigo     = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfechaModif    = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					where RHHFid      = <cfqueryparam value="#form.RHHFid#" cfsqltype="cf_sql_numeric">
				</cfquery>
		    <cfset params = 'modo=CAMBIO&RHHFid='&form.RHHFid>
		<cfelseif isdefined("form.Baja")>
			<cfquery name="ABC_RHGrados" datasource="#session.DSN#">
				delete 
				from RHHSubfactores 
				where RHHFid = <cfqueryparam value="#form.RHHFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfquery name="ABC_Puestos_deleteB" datasource="#session.DSN#">
				delete RHHFactores
				where RHHFid =  <cfqueryparam value="#form.RHHFid#" cfsqltype="cf_sql_numeric">
			</cfquery>	
		    <cfset params = 'modo=ALTA'>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>	

<cfif isdefined("Form.Pagina")><cfset params = params +"&Pagina="+Form.Pagina></cfif>
<cflocation url="Factores.cfm?#params#">
