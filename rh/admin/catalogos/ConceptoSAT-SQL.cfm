<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_Concepto_ya_esta_definido_en_la_corporacion_debe_utilizar_un_codigo:distinto_Proceso_Cancelado"
Default="Error! El Concepto ya est&aacute; definido en la corporaci&oacute;n, debe utilizar un c&oacute;digo distinto. Proceso Cancelado"
returnvariable="MG_ConceptoDefinido"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_Concepto_ya_esta_asignado"
Default="Error! El Concepto ya est&aacute asignado. Proceso Cancelado"
returnvariable="MG_ConceptoAsignado"/> 

<cffunction name="fncambio" returntype="boolean">
	<cfargument name="RHCSATid" type="numeric">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as cambio
		from RHCFDIConceptoSAT
		where RHCSATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCSATid#">
		and rtrim(ltrim(RHCSATcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfreturn (rse.cambio EQ 0)/>
</cffunction>

<cffunction name="fnnotExists" returntype="boolean">
	<cfargument name="cod" type="string">
	<cfargument name="tipo" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as existen
		from RHCFDIConceptoSAT
		where RHCSATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
        and RHCSATtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.tipo)#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfif rse.existen>
		<cf_throw message="#MG_ConceptoDefinido#" errorcode="2130"/>
	</cfif>
	<cfreturn (rse.existen EQ 0)/>
</cffunction>

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Alta")>
        <cfif fnnotExists(form.CScodigo,form.CStipo)>
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert into RHCFDIConceptoSAT (Ecodigo,RHCSATcodigo,RHCSATdescripcion,RHCSATtipo,BMUsucodigo,FechaAlta)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.CScodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.CSdescripcion#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.CStipo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Usucodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
                )
                <cf_dbidentity1 name="rsInsert" datasource="#session.dsn#">
            </cfquery>
            <cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnvariable="rsCSid" >
       	</cfif>
    	<cflocation url="ConceptosSAT.cfm?RHCSATid=#rsCSid#">
    <cfelseif isdefined("form.Cambio")>
        <cf_dbtimestamp
            datasource="#session.dsn#"
            table="RHCFDIConceptoSAT"
            redirect="ConceptosSAT.cfm"
            timestamp="#form.ts#"
            field1="RHCSATid,numeric,#form.RHCSATid#">
            		
        <cfquery datasource="#session.dsn#">
            update RHCFDIConceptoSAT
            set RHCSATdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CSdescripcion#">,
            	RHCSATtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CStipo#">,
              	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Usucodigo#">
            where RHCSATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCSATid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        <cflocation url="ConceptosSAT.cfm?RHRegimenid=#form.RHCSATid#&PageNum=#form.PageNum#">
    <cfelseif isdefined("form.Baja")>
    <!---Poner la validación de existencia en la tabla que apunte al régimen--->
    	<cfif form.CStipo eq 'D'>
        	<cfquery name="rsConceptos" datasource="#session.dsn#">
            	select * from TDeduccion
                where RHCSATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCSATid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
        	<cfif rsConceptos.RecordCount le 0 > 
                <cfquery name="rsConceptos" datasource="#session.dsn#">
                    select * from RH_CFDI_RecibosNomina   
                    where CadenaOriginal like '%|#form.CScodigo#|%'                    
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                </cfquery>
            </cfif>
        	<cfif rsConceptos.RecordCount le 0 > 
                <cfquery name="rsConceptos" datasource="#session.dsn#">
                    select * from RHTipoAccion   
                    where RHIncapid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCSATid#">                    
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                </cfquery>
            </cfif>
    	<cfelse>
        	<cfquery name="rsConceptos" datasource="#session.dsn#">
            	select * from CIncidentes
                where RHCSATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCSATid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
    	</cfif>
        <cfif rsConceptos.RecordCount gt 0> 
			<cfset msg = "#MG_ConceptoAsignado#">
            <cf_throw message="#msg#" errorcode="2015">
            <cfabort>
        <cfelse>
            <cfquery datasource="#session.dsn#">
                delete from RHCFDIConceptoSAT
                where RHCSATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCSATid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
        </cfif>
    </cfif>
</cfif>

<cfparam name="params" default="" type="string">
<cflocation url="ConceptosSAT.cfm#params#">