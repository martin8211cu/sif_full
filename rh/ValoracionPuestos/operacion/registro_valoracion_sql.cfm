<cfset params = "">
<cfset modoreturn = "ALTA">
<cfif isdefined("url.params") and not isdefined("form.params") and len(trim(url.params)) gt 0><cfset form.params = url.params></cfif>
<cfif isdefined("form.params") and len(trim(form.params)) gt 0><cfset params = form.params></cfif>
<cfif isdefined("url.RHVPid") and not isdefined("form.RHVPid") and len(trim(url.RHVPid)) gt 0><cfset form.RHVPid = url.RHVPid></cfif>
<cfif isdefined("url.ts_rversion") and not isdefined("form.ts_rversion") and len(trim(url.ts_rversion)) gt 0><cfset form.ts_rversion = url.ts_rversion></cfif>

<!--- Los demás valores solo son actualizados por post --->
<cfparam name="form.RHVPid" default="-1" type="numeric">
<cfparam name="form.RHVPfdesde" default="#LSDateFormat(Now())#" type="string">
<cfif isdefined("form.RHVPfhasta") and len(trim(form.RHVPfhasta)) eq 0><cfset form.RHVPfhasta = "01/01/6100"></cfif>
<cfparam name="form.RHVPfhasta" default="#LSDateFormat(Now())#" type="numeric">
<cfif isdefined("form.Alta") or isdefined("form.Cambio")><!--- Requeridos en estas acciones --->
	<cfparam name="form.RHVPdescripcion" type="string">
</cfif>

<cftransaction>
	<cfif isdefined("form.Alta")>
		<cfquery name="ABC_Valoracion" datasource="#Session.DSN#">
            insert into RHValoracionPuesto (Ecodigo, BMUsucodigo, RHVPdescripcion, RHVPfdesde, RHVPfhasta,BMfechaalta,RHVUsaPropuestos)
			values(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHVPdescripcion#">
				, <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHVPfdesde)#">
				, <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHVPfhasta)#">
                , <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#" >
                <cfif isdefined("form.RHVUsaPropuestos")>
                    ,1
                <cfelse>
                    ,0
                </cfif>
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 name="ABC_Valoracion" datasource="#Session.DSN#" returnvariable="LvarRHVPid">
		<cfset modoreturn = "CAMBIO">
		
	<cfelseif isdefined("form.Cambio")>
		<cfquery name="ABC_Valoracion" datasource="#Session.DSN#">
			update RHValoracionPuesto
			set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				, RHVPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHVPdescripcion#">
				, RHVPfdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHVPfdesde)#">
				, RHVPfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHVPfhasta)#">
				<!--- <cfif isdefined("form.RHVUsaPropuestos")>
                    ,RHVUsaPropuestos = 1
                <cfelse>
                    ,RHVUsaPropuestos = 0
                </cfif> --->
                
			where RHVPid = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
			and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
		</cfquery>
		<cfset modoreturn = "CAMBIO">
	<cfelseif isdefined("form.Baja")>
		<cfquery name="ABC_Valoracion" datasource="#Session.DSN#">
			delete from RHPropuestaPuesto
            where RHVPid = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
		</cfquery>
        
        <cfquery name="ABC_Valoracion" datasource="#Session.DSN#">
			delete from RHDispersionPuesto
            where RHVPid = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
		</cfquery>
        
        <cfquery name="ABC_Valoracion" datasource="#Session.DSN#">
			delete from RHGradosFactorPuesto
            where RHVPid = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
		</cfquery>
        
        <cfquery name="ABC_Valoracion" datasource="#Session.DSN#">
			delete from RHValoracionPuesto
            where RHVPid = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modoreturn = "ALTA">
	</cfif>
</cftransaction>

<cfif modoreturn eq "CAMBIO">
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=CAMBIO">
	<cfif isdefined("LvarRHVPid") and len(trim(LvarRHVPid)) gt 0>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHVPid="  &  LvarRHVPid>
	<cfelseif isdefined("form.RHVPid") and len(trim(form.RHVPid)) gt 0 and form.RHVPid neq -1>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHVPid="  &  form.RHVPid>
	</cfif>
<cfelseif isdefined("form.Nuevo")>
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=ALTA">
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "btnNuevo=Nuevo">
</cfif>
<cflocation url="registro_valoracion.cfm#params#">
