<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo") or not isdefined("Form.NuevoPer")>
<!---=================Agregar Formulación======================--->
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into ECalendarioVentas (          
                CVCodigo, 
                CVDescripcion, 
                CVTipo,       
                Ecodigo,
                BMUsucodigo
			)
			values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVCodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVDescripcion#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#form.CVTipo#">,
					#Session.Ecodigo#,
					#session.Usucodigo#
				) 
		</cfquery>
		<cfset modo = "ALTA">
<!---====================Eliminar  Formulación=======================--->	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from ECalendarioVentas
			  where CVid =#form.CVid# 
		</cfquery>
		<cfset modo="ALTA">
<!---====================Modificar Formulación=======================--->
	<cfelseif isdefined("Form.Cambio")>
		 <cf_dbtimestamp
					datasource="#session.dsn#"
					table="ECalendarioVentas" 
					redirect="CalendariosVenta.cfm"
					timestamp="#form.ts_rversion#"
					field1="CVid,numeric,#form.CVid# "
					>
		<cfquery name="update" datasource="#Session.DSN#">
			update ECalendarioVentas set 
            CVCodigo      =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVCodigo#">,
            CVDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVDescripcion#">,
            BMUsucodigo   = #session.Usucodigo#
			where CVid   = #form.CVid#
		</cfquery> 
		<cfset modo="CAMBIO">
<!---====================Modificar Formulación=======================--->
    <cfelseif isdefined("Form.AltaPer")>
		<cfset Rangos()>
        <cfquery name="insertD" datasource="#Session.DSN#">
			insert into DCalendarioVentas (
            	CVid, 
                CVfechaini, 
                CVfechafin,
                Ecodigo, 
                BMUsucodigo
            )
            values (
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">,
            	<cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaini#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechafin#">,
            	#session.Ecodigo#,
                #session.Usucodigo#
            )    
		</cfquery> 
		<cfset modo="CAMBIO">
<!---====================Modificar Formulación=======================--->
    <cfelseif isdefined("Form.BajaPer")>
		<cfquery name="deleteD" datasource="#Session.DSN#">
			delete from DCalendarioVentas 
			where CVid  = #form.CVid# 
            and CVlinea = #form.CVlinea# 
		</cfquery> 
		<cfset modo="CAMBIO">
<!---====================Modificar Formulación=======================--->
    <cfelseif isdefined("Form.CambioPer")>
		<cfset Rangos()>
        <cfquery name="update" datasource="#Session.DSN#">
			update DCalendarioVentas set 
            CVfechaini  = <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaini#">,
            CVfechafin  = <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechafin#">,
            BMUsucodigo = #session.Usucodigo#
			where CVlinea = #form.CVlinea#
		</cfquery> 
		<cfset modo="CAMBIO">            
	</cfif>
</cfif>

<form action="CalendariosVenta.cfm" method="post" name="sql">
	<cfif isdefined("form.NuevoPer")>
    	<cfset modo="CAMBIO">            
    </cfif>
	<input name="modo"  type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="CVid" type="hidden" value="<cfif (isdefined("form.CVid") and modo neq 'ALTA') or isdefined("form.NuevoPer")><cfoutput>#form.CVid#</cfoutput></cfif>">
    <input name="CVlinea" type="hidden" value="<cfif isdefined("form.CVlinea") and isdefined ("form.CambioPer")><cfoutput>#form.CVlinea#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cffunction name="Rangos" access="private" output="no" returntype="void">
	 	<cfquery name="rsCalendarios" datasource="#Session.DSN#">
            select 	*
            from ECalendarioVentas 
            where CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
        </cfquery>    
		    
        <cfif rsCalendarios.recordcount gt 0 > 
            <cfquery name="rsRangoI" datasource="#Session.DSN#">
            	select 	*
	            from DCalendarioVentas 
                where CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
                <cfif isdefined("Form.CambioPer")>
                	and CVlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVlinea#">
                </cfif>
                and Ecodigo = #session.Ecodigo#
                and '#LSDateFormat(form.fechaini)#' between CVfechaini and CVfechafin
            </cfquery>
            
            <cfif rsRangoI.recordcount gt 0>
            	<cf_errorCode code = "90225" msg = "Ya se encuentra un calendario con ese rango!">    
            </cfif>
            
            <cfquery name="rsRangoF" datasource="#Session.DSN#">
            	select 	*
	            from DCalendarioVentas 
                where CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
                <cfif isdefined("Form.CambioPer")>
                	and CVlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVlinea#">
                </cfif>
                and Ecodigo = #session.Ecodigo#
                and '#LSDateFormat(form.fechafin)#' between CVfechaini and CVfechafin
            </cfquery>
            
            <cfif rsRangoF.recordcount gt 0>
            	<cf_errorCode code = "90225" msg = "Ya se encuentra un calendario con ese rango!">    
            </cfif>
            
         </cfif>   
</cffunction>

