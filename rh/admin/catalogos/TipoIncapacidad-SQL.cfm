<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_Tipo_Incapacidad_ya_esta_definido_en_la_corporacion_debe_utilizar_un_codigo:distinto_Proceso_Cancelado"
Default="Error! El Tipo Incapacidad ya est&aacute; definido en la corporaci&oacute;n, debe utilizar un c&oacute;digo distinto. Proceso Cancelado"
returnvariable="MG_TipoIncDefinido"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_TipoIncapacidad_ya_esta_asignado"
Default="Error! El Tipo Incapacidad ya est&aacute asignado. Proceso Cancelado"
returnvariable="MG_TipoIncapacidad"/> 

<cffunction name="fncambio" returntype="boolean">
	<cfargument name="RHIncapid" type="numeric">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as cambio
		from RHCFDIIncapacidad
		where RHIncapid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHIncapid#">
		and rtrim(ltrim(RHIncapcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfreturn (rse.cambio EQ 0)/>
</cffunction>

<cffunction name="fnnotExists" returntype="boolean">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as existen
		from RHCFDIIncapacidad
		where RHIncapcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfif rse.existen>
		<cf_throw message="#MG_TipoIncDefinido#" errorcode="2130"/>
	</cfif>
	<cfreturn (rse.existen EQ 0)/>
</cffunction>

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Alta")>
        <cfif fnnotExists(form.TIcodigo)>
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert into RHCFDIIncapacidad (Ecodigo,RHIncapcodigo,RHIncapdescripcion,BMUsucodigo,FechaAlta)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIdescripcion#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Usucodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
                )
                <cf_dbidentity1 name="rsInsert" datasource="#session.dsn#">
            </cfquery>
            <cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnvariable="rsTIid" >
       	</cfif>
    	<cflocation url="TipoIncapacidad.cfm?RHIncapid=#rsTIid#">
    <cfelseif isdefined("form.Cambio")>
        <cf_dbtimestamp
            datasource="#session.dsn#"
            table="RHCFDIIncapacidad"
            redirect="TipoIncapacidad.cfm"
            timestamp="#form.ts#"
            field1="RHIncapid,numeric,#form.RHIncapid#">
            		
        <cfquery datasource="#session.dsn#">
            update RHCFDIIncapacidad
            set RHIncapdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIdescripcion#">,
              	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Usucodigo#">
            where RHIncapcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TIcodigo#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        <cflocation url="TipoIncapacidad.cfm?RHIncapid=#form.RHIncapid#&PageNum=#form.PageNum#">
    <cfelseif isdefined("form.Baja")>
    <!---Poner la validación de existencia en la tabla que apunte al régimen--->
        <cfquery name="rs" datasource="#session.DSN#">
            select * from RHTipoAccion
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
              and RHIncapid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIncapid#">
        </cfquery>
        <cfif rs.RecordCount gt 0>
            <cf_throw message="#MG_TipoIncapacidad#" errorcode="2075">
        <cfelse>
            <cfquery datasource="#session.dsn#">
                delete RHCFDIIncapacidad
                where RHIncapid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIncapid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
        </cfif>
    </cfif>
</cfif>

<cfparam name="params" default="" type="string">
<cflocation url="TipoIncapacidad.cfm#params#">