<cfif isdefined('form.Alta')>
		<!--- Agregar una empresa a un concurso especifico--->
    <cfquery name="insRHEmpresasCorpConcurso" datasource="#Session.DSN#">
        insert into RHEmpresasCorpConcurso
        (RHCconcurso, Ecodigo, RHEfechaIngreso)
        values
        ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">,
         <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">,
          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        )	
    </cfquery>
<cfelseif isdefined('form.Baja')>
		<!--- Eliminar una empresa a un concurso especifico--->
        <cfquery name="delRHEmpresasCorpConcurso" datasource="#Session.DSN#">
            delete from RHEmpresasCorpConcurso
            where RHECCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHECCid#">
        </cfquery>
</cfif>
