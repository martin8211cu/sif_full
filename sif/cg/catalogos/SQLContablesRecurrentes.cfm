<cfif isdefined ("form.botonSel") and form.botonSel EQ "btnEliminar">
    <cfquery name="rsAsientosRecursivosBAJA" datasource="#session.dsn#">
        delete
        from AsientosRecursivos 
        where Ecodigo = #session.Ecodigo# and IDcontable = #form.IDcontable#
    </cfquery>
<cfelseif isdefined("form.botonSel") and form.botonSel EQ "btnModificar">
    <cfquery name="rsAsientosRecursivosCAMBIO" datasource="#session.dsn#">
        update AsientosRecursivos 
        set FFECrecursivo = <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"  value="#lsparsedatetime(form.N_FFECRECURSIVO)#" voidNull>
        where Ecodigo = #session.Ecodigo# and IDcontable = #form.IDcontable#
    </cfquery>
</cfif>
<cflocation url="DocumentosContablesRecurrentes.cfm">