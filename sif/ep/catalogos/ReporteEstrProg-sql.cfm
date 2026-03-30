
<cfif IsDefined("form.btnAgregar")>
	<cfquery name="BuscaRelacion" datasource="#Session.DSN#">
    	select ID_RepEstrProg from CGReEstrProg
        where
        	SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SPcodigo#">
        and ID_Estr  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
	</cfquery>
    <cfif BuscaRelacion.RecordCount EQ 0 >
        <cfquery name="insReporteEstrProg" datasource="#Session.DSN#">
            insert into CGReEstrProg (ID_Estr, SPcodigo, BMUsucodigo<cfif Form.ID_Firma NEQ "">,ID_Firma</cfif>)
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
                <cfqueryparam cfsqltype="cf_sql_char" 	 value="#Form.SPcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				<cfif Form.ID_Firma NEQ "">,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Firma#"></cfif>
            )
        </cfquery>
    </cfif>
<cfelseif IsDefined("form.btnModificar")>

	<cfquery name="BuscaRelacion" datasource="#Session.DSN#">
    	select ID_RepEstrProg from CGReEstrProg
        where
        	SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SPcodigo#">
        and ID_Estr      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
	</cfquery>

    <cfif BuscaRelacion.RecordCount GT 0 >
        <cfquery name="UpdReporteEstrProg" datasource="#Session.DSN#">
            Update CGReEstrProg
            set ID_Estr    	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ID_Estr#">,
                SPcodigo 	= <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.SPcodigo#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				ID_Firma = <cfif Form.ID_Firma NEQ ""><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Firma#"><cfelse>NULL</cfif>
            Where ID_RepEstrProg= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_RepEstrProg#">
        </cfquery>
	<cfelse>
		<cfquery name="insReporteEstrProg" datasource="#Session.DSN#">
            insert into CGReEstrProg (ID_Estr, SPcodigo, BMUsucodigo<cfif Form.ID_Firma NEQ "">,ID_Firma</cfif>)
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
                <cfqueryparam cfsqltype="cf_sql_char" 	 value="#Form.SPcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				<cfif Form.ID_Firma NEQ "">,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Firma#"></cfif>
            )
        </cfquery>
    </cfif>
<cfelseif IsDefined("form.btnEliminar")>
	<cfquery name="DelReporteEstrProg" datasource="#Session.DSN#">
        Delete from CGReEstrProg
        Where ID_RepEstrProg = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_RepEstrProg#">
	</cfquery>
</cfif>

<cfset params= "">

<cflocation url="ReporteEstrProg.cfm#params#">

