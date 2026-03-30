<cfparam name="form.ETAR" 			default="0"><!--- ETA real--->
<cfparam name="form.CMATFDO_" 	default="0"><!--- Envio de los documentos a la aduana--->
<cfparam name="form.ETA_A_" 		default="0"><!--- Fecha de Salida del puerto Origen--->
<cfparam name="form.ETS_" 			default="0"><!--- Fecha de Salida del puerto Origen--->

<cfif isdefined("form.ActividadAsociada") and form.ActividadAsociada eq 1><cfset form.ETAR = 1>
<cfelseif isdefined("form.ActividadAsociada") and form.ActividadAsociada eq 2><cfset form.ETA_A_ = 1>
<cfelseif isdefined("form.ActividadAsociada") and form.ActividadAsociada eq 3><cfset form.ETS_ = 1>	
<cfelseif isdefined("form.ActividadAsociada") and form.ActividadAsociada eq 4><cfset form.CMATFDO_ = 1>	
</cfif>

<cfif isdefined("form.Alta")>
	<cfquery datasource="sifpublica">
		insert into CMActividadTracking (CMATcodigo, CMATdescripcion, BMUsucodigo, Ecodigo,ETA_R ,ETA_A ,CMATFDO,ETS) 
		values (
        			<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.CMATcodigo)#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMATdescripcion#">, 
                    #session.Usucodigo#, 
                    #session.Ecodigo#,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#form.ETAR#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#form.ETA_A_#">, 
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#form.CMATFDO_#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#form.ETS_#">)
	</cfquery>
<cfelseif isdefined("form.Cambio")>
	<cf_dbtimestamp datasource="sifpublica" table="CMActividadTracking" redirect="trackingActividad.cfm" timestamp="#form.timestamp#"
    	field1="CMATcodigo" type1="string" value1="#trim(form.CMATcodigo)#"
		field2="Ecodigo" type2="integer" value2="#session.Ecodigo#" >

	<cfquery datasource="sifpublica">
		update CMActividadTracking 
		set CMATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.CMATcodigo)#">,
		     CMATdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMATdescripcion#">,
             ETA_R = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.ETAR#">,
             ETA_A = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.ETA_A_#">, 
             CMATFDO = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.CMATFDO_#">,
			 ETS = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.ETS_#">
		where Ecodigo = #session.Ecodigo#
		  and CMATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMATid#">
	</cfquery>
<cfelseif isdefined("form.Baja")>
	<cfquery datasource="sifpublica">
		delete from CMActividadTracking 
		where Ecodigo = #session.Ecodigo#
		  and CMATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMATid#">
	</cfquery>
</cfif>
<cfif isdefined("form.Cambio")>
	<cflocation url="trackingActividad.cfm?CMATid=#form.CMATid#" addtoken="no">
<cfelse>
	<cflocation url="trackingActividad.cfm" addtoken="no">
</cfif>