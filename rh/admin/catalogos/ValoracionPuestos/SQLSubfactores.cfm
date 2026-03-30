<cfset params = ''>
<cfif not isdefined("form.Nuevo")>
	<cftransaction>
	<cftry>
		<cfif isdefined("form.Alta")>
        	<cfquery name="rsExiste" datasource="#session.DSN#">
            	select count(1) cantidad 
               	from RHHSubfactores 
                where Ecodigo = #session.Ecodigo# and RHHSFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHHSFcodigo)#">
            </cfquery>
            <cfif rsExiste.cantidad gt 0>
            	<cfthrow message="El código ingresdo ya está en uso y no puede ser utilizado, Proceso Cancelado!!!">
            </cfif>
			<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
				insert into RHHSubfactores (RHHFid,RHHSFcodigo, RHHSFdescripcion,RHHSFponderacion,RHHSFpuntuacion, BMUsucodigo,BMusuModif, BMfechaAlta, BMfechaModif, Ecodigo)
				 values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#">,
				 		  <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHHSFcodigo)#">,
						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHHSFdescripcion#">,
						  <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHHSFponderacion, ',', '', 'all')#">,
						  <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHHSFpuntuacion, ',', '', 'all')#">,
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                          <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_Puestos_insert">
		    <cfset params = 'modo=CAMBIO&RHHSFid='&ABC_Puestos_insert.identity&"&RHHFid="&form.RHHFid>
		<cfelseif isdefined("form.Cambio")>
        	<cfquery name="rsExiste" datasource="#session.DSN#">
            	select count(1) cantidad 
               	from RHHSubfactores 
                where Ecodigo = #session.Ecodigo# 
                  and RHHSFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHHSFcodigo)#">
                  and RHHSFid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#">
            </cfquery>
            <cfif rsExiste.cantidad gt 0>
            	<cfthrow message="El código ingresdo ya está en uso y no puede ser utilizado, Proceso Cancelado!!!">
            </cfif>
            <cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
                update RHHSubfactores
                    set RHHSFcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHHSFcodigo)#">,
                    RHHSFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHHSFdescripcion#">,
                    RHHSFponderacion = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHHSFponderacion, ',', '', 'all')#">,
                    RHHSFpuntuacion  = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHHSFpuntuacion, ',', '', 'all')#">,
                    BMUsucodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    BMfechaModif     = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                    Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#">
                  and RHHSFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#">
            </cfquery>
		    <cfset params = 'modo=CAMBIO&RHHFid='&form.RHHFid &"&RHHSFid="&form.RHHSFid>
		<cfelseif isdefined("form.Baja")>
			<cfquery name="ABC_Puestos_deleteB" datasource="#session.DSN#">
				delete RHHSubfactores
				where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#">
				  and RHHSFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#">
			</cfquery>	
		   	<cfset params = 'modo=ALTA&RHHFid='&form.RHHFid>
		</cfif>
        <cfcatch type="any">
            <cfinclude template="/sif/errorPages/BDerror.cfm">
            <cfabort>
        </cfcatch>
	</cftry>
	</cftransaction>
<cfelse>
   <cfset params = 'modo=ALTA&RHHFid='&form.RHHFid>
</cfif>	
<cfif isdefined("Form.Pagina")><cfset params = params +"&Pagina="+Form.Pagina></cfif>
<cflocation url="Subfactores.cfm?#params#">
