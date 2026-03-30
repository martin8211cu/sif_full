<cfif isdefined("form.Alta")>
	<cfquery name="rsQPassUsuarioOficina" datasource="#session.DSN#">
    	insert into QPassUsuarioOficina (
            		Ecodigo,
                    Ocodigo,
                    Usucodigo)
      	values (
        	#session.Ecodigo#,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
        )
        <cf_dbidentity1 datasource="#Session.DSN#">
    </cfquery>
    <cf_dbidentity2 datasource="#Session.DSN#" name="rsQPassUsuarioOficina">
    
    <cflocation url="QPassUsuxOfi.cfm?QPUOid=#rsQPassUsuarioOficina.identity#" addtoken="no">
<cfelseif isdefined("form.Cambio")>
    <cfquery datasource="#session.DSN#">
        update QPassUsuarioOficina
        set Ocodigo    = <cfqueryparam cfsqltype="cf_sql_integer"	value="#form.Ocodigo#">, 
            Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">
        where QPUOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPUOid#">
    </cfquery>

    <cflocation url="QPassUsuxOfi.cfm?QPUOid=#form.QPUOid#" addtoken="no">
<cfelseif isdefined("form.Baja")>
    <cfquery datasource="#session.DSN#">
        delete from QPassUsuarioOficina 
        where QPUOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPUOid#">
    </cfquery>
	
    <cflocation url="QPassUsuxOfi.cfm" addtoken="no">
</cfif>