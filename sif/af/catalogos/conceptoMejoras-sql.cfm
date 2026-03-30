<cfset params="">
<cfif isdefined("Form.PageNum") and len(trim(Form.PageNum)) gt 0 and Form.PageNum gt 0>
	<cfset Form.Pagina = Form.PageNum>
</cfif>
<cfparam name="Form.Pagina" default="1">					
<cfparam name="Form.MaxRows" default="15">
<cftransaction>
	<cfif isdefined("Form.Alta")>
        <cfquery name="rsInsert" datasource="#Session.DSN#">
            insert into AFConceptoMejoras(
                AFCMcodigo,
                AFCMdescripcion,
                Ecodigo,
                BMUsucodigo)
            values (
                <cfqueryparam cfsqltype="cf_sql_char" value="#form.AFCMcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFCMdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
        <cf_dbidentity1 datasource="#session.DSN#">	
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
        <cfset params=ListAppend(params,"AFCMid="&rsInsert.identity,"&")>
    <cfelseif isdefined("Form.Cambio")>
        <cf_dbtimestamp 
            table="AFConceptoMejoras"
            redirect="conceptoMejoras.cfm"
            timestamp="#form.ts_rversion#"				
            field1="AFCMid,numeric,#Form.AFCMid#">
        <cfquery name="rsUpdate" datasource="#Session.DSN#">
            update AFConceptoMejoras set
                AFCMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.AFCMcodigo#">,
                AFCMdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFCMdescripcion#">
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and AFCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFCMid#">
        </cfquery>
        <cfset params=ListAppend(params,"AFCMid="&Form.AFCMid,"&")>
    <cfelseif isdefined("Form.Baja")>
        <cfquery name="rsDelete" datasource="#Session.DSN#">
            delete from AFConceptoMejoras 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and AFCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFCMid#">
        </cfquery>
    </cfif>
</cftransaction>
<cfset fixedparams="">
<cfset fixedparams=ListAppend(fixedparams,"Pagina="&Form.Pagina,"&")>
<cfset fixedparams=ListAppend(fixedparams,"AFCMcodigo="&Form.AFCMcodigo,"&")>
<cfset fixedparams=ListAppend(fixedparams,"AFCMdescripcion="&Form.AFCMdescripcion,"&")>

<cflocation url="conceptoMejoras.cfm?#fixedparams#&#params#">