<cfparam name="form.B15" default="false">
<cftransaction>
    <cfquery datasource="#session.DSN#">
        delete from SaldosContablesConvertidos
          where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and Speriodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
            and (Speriodo * 100 + Smes) >= (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">)
        <cfif form.B15>
            and B15 in (1,2)
        <cfelse>
            and B15 = 0
        </cfif>
    </cfquery>
    
    <cfquery datasource="#session.DSN#">
        delete
        from HtiposcambioConversion<cfif form.B15>B15</cfif>
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Speriodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
        and (Speriodo * 100 + Smes) >= (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">)
		<cfif not form.B15>and TCtipo =0</cfif>
    </cfquery>
    
    <cfquery datasource="#session.DSN#">
        delete
        from HtiposcambioConversionD
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Speriodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
        and (Speriodo * 100 + Smes) >= (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">)
		and TCHtipo = 0
    </cfquery>
</cftransaction>
<cfif form.B15>
	<cflocation url="EliminarDatosConversionB15.cfm">
<cfelse>
	<cflocation url="eliminarDatosConversion.cfm">
</cfif>