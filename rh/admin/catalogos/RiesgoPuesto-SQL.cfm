<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_Riesgo_Puesto_ya_esta_definido_en_la_corporacion_debe_utilizar_un_codigo:distinto_Proceso_Cancelado"
Default="Error! El Riesgo Puesto ya est&aacute; definido en la corporaci&oacute;n, debe utilizar un c&oacute;digo distinto. Proceso Cancelado"
returnvariable="MG_RiesgoPuestoDefinido"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_Riesgo_ya_esta_asignado"
Default="Error! El Riesgo ya est&aacute asignado. Proceso Cancelado"
returnvariable="MG_RiesgoAsignado"/> 

<cffunction name="fncambio" returntype="boolean">
	<cfargument name="RHRiesgoid" type="numeric">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as cambio
		from RHCFDI_Riesgo
		where RHRiesgoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRiesgoid#">
		and rtrim(ltrim(RHRiesgocodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfreturn (rse.cambio EQ 0)/>
</cffunction>

<cffunction name="fnnotExists" returntype="boolean">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as existen
		from RHCFDI_Riesgo
		where RHRiesgocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfif rse.existen>
		<cf_throw message="#MG_RiesgoPuestoDefinido#" errorcode="2130"/>
	</cfif>
	<cfreturn (rse.existen EQ 0)/>
</cffunction>

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Alta")>
        <cfif fnnotExists(form.RPcodigo)>
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert into RHCFDI_Riesgo (Ecodigo,RHRiesgocodigo,RHRiesgodescripcion,BMUsucodigo,FechaAlta)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.RPcodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.RPdescripcion#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Usucodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
                )
                <cf_dbidentity1 name="rsInsert" datasource="#session.dsn#">
            </cfquery>
            <cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnvariable="rsRPid" >
       	</cfif>
    	<cflocation url="RiesgoPuesto.cfm?RHRegimenid=#rsRPid#">
    <cfelseif isdefined("form.Cambio")>
        <cf_dbtimestamp
            datasource="#session.dsn#"
            table="RHCFDI_Riesgo"
            redirect="RiesgoPuesto.cfm"
            timestamp="#form.ts#"
            field1="RHRiesgoid,numeric,#form.RHRiesgoid#">
            		
        <cfquery datasource="#session.dsn#">
            update RHCFDI_Riesgo
            set RHRiesgodescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RPdescripcion#">,
              	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Usucodigo#">
            where RHRiesgocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RPcodigo#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        <cflocation url="RiesgoPuesto.cfm?RHRegimenid=#form.RHRiesgoid#&PageNum=#form.PageNum#">
    <cfelseif isdefined("form.Baja")>
    <!---Poner la validación de existencia en la tabla que apunte al régimen--->
        <cfquery name="rs" datasource="#session.DSN#">
            select Pvalor
            from RHParametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="301">
        </cfquery>
        <cfif rs.RecordCount gt 0 and rs.Pvalor eq Form.RHRiesgoid>
            <cf_throw message="#MG_RiesgoAsignado#" errorcode="2075">
        <cfelse>
            <cfquery datasource="#session.dsn#">
                delete from RHCFDI_Riesgo
                where RHRiesgoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRiesgoid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
        </cfif>
    </cfif>
</cfif>

<cfparam name="params" default="" type="string">
<cflocation url="RiesgoPuesto.cfm#params#">