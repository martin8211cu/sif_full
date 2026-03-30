<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_Regimen_de_Contratación_ya_esta_definido_en_la_corporacion_debe_utilizar_un_codigo:distinto_Proceso_Cancelado"
Default="Error! El r&eacute;gimen de  Contrataci&oacute;n ya est&aacute; definido en la corporaci&oacute;n, debe utilizar un c&oacute;digo distinto. Proceso Cancelado"
returnvariable="MG_RegContraDefinido"/> 
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_Regimen_ya_esta_asignado"
Default="Error! El R&eacute;gimen ya est&aacute asignado. Proceso Cancelado"
returnvariable="MG_RegimenAsignado"/> 

<cffunction name="fncambio" returntype="boolean">
	<cfargument name="RHRegimenid" type="numeric">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as cambio
		from RHCFDI_Regimen
		where RHRegimenid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRegimenid#">
		and rtrim(ltrim(RHRegimencodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfreturn (rse.cambio EQ 0)/>
</cffunction>

<cffunction name="fnnotExists" returntype="boolean">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as existen
		from RHCFDI_Regimen
		where RHRegimencodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfif rse.existen>
		<cf_throw message="#MG_RegContraDefinido#" errorcode="2130"/>
	</cfif>
	<cfreturn (rse.existen EQ 0)/>
</cffunction>

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Alta")>
        <cfif fnnotExists(form.RCcodigo)>
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert into RHCFDI_Regimen (Ecodigo,RHRegimencodigo,RHRegimendescripcion,BMUsucodigo,FechaAlta)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.RCcodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.RCdescripcion#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Usucodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
                )
                <cf_dbidentity1 name="rsInsert" datasource="#session.dsn#">
            </cfquery>
            <cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnvariable="rsRCid" >
       	</cfif>
    	<cflocation url="RegimenContratacion.cfm?RHRegimenid=#rsRCid#">
    <cfelseif isdefined("form.Cambio")>
        <cf_dbtimestamp
            datasource="#session.dsn#"
            table="RHCFDI_Regimen"
            redirect="RegimenContratacion.cfm"
            timestamp="#form.ts#"
            field1="RHRegimenid,numeric,#form.RHRegimenid#">
            		
        <cfquery datasource="#session.dsn#">
            update RHCFDI_Regimen
            set RHRegimendescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RCdescripcion#">,
              	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Usucodigo#">
            where RHRegimencodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RCcodigo#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        <cflocation url="RegimenContratacion.cfm?RHRegimenid=#form.RHRegimenid#&PageNum=#form.PageNum#">
    <cfelseif isdefined("form.Baja")>
    <!---Poner la validación de existencia en la tabla que apunte al régimen--->
        <cfquery name="rs" datasource="#session.DSN#">
            select * from DatosEmpleado
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
              and RHRegimenid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRegimenid#">
        </cfquery>
        <cfif rs.RecordCount gt 0>
            <cf_throw message="#MG_RegimenAsignado#" errorcode="2075">
        <cfelse>
            <cfquery datasource="#session.dsn#">
                delete from RHCFDI_Regimen
                where RHRegimenid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRegimenid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
        </cfif>
    </cfif>
</cfif>

<cfparam name="params" default="" type="string">
<cflocation url="RegimenContratacion.cfm#params#">