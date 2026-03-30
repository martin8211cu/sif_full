
    <cfquery name="rsConsultaUsu" datasource="#Session.DSN#">
            select Usucodigo,ADSPid from ADSUsuarioPerfil
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        <cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>
            and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
        </cfif>
        <cfif isdefined("form.ADSPid") and len(trim(form.ADSPid))>
            and (ADSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADSPid#">
            or ADSPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADSPid#">)
        </cfif>
        group by Usucodigo,ADSPid
    </cfquery>


	<cfif isdefined("Form.Guardar")>

        <cftransaction>
        		<cfif not isdefined ("form.Usucodigo") or (isdefined ("form.Usucodigo") and form.Usucodigo EQ "")>
                    	<cf_errorCode	code = "80011" msg = "Debe seleccionar Usuario.">
                    <cfelseif( not isdefined("form.ADSPid") or form.ADSPid EQ "")>
                    	<cf_errorCode	code = "80012" msg = "Debe seleccionar perfil para el usuario.">
                    </cfif>
                    
				<cfif rsConsultaUsu.Recordcount GT 0>
                     <cfquery name="rsUpdate" datasource="#Session.DSN#">
                        update ADSUsuarioPerfil
                        set ADSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ADSPid#">
                        where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsultaUsu.Usucodigo#">
                     </cfquery>
                <cfelse>
                        <cfquery name="InsertSeguridadUsu" datasource="#Session.DSN#">
                            insert INTO ADSUsuarioPerfil (Ecodigo, ADSPid, Usucodigo)
                            values (
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ADSPid#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
                            )
                            <cf_dbidentity1 datasource="#Session.DSN#">
                        </cfquery>
                        	<cf_dbidentity2 datasource="#Session.DSN#" name="InsertSeguridadUsu">
                </cfif>
         </cftransaction>	
	     <cfset modo="CAMBIO">
         <cfif isdefined("session.ConfUsu")>       
    	 	<cfset StructDelete(session, "ConfUsu")>
         </cfif>
         <cfset ConfUsu = StructNew()>
         <cfset ConfUsu.Ecodigo = #session.Ecodigo#>
         <cfset ConfUsu.IdUsu = #Form.Usucodigo#>
         <cfset ConfUsu.IdPerfil = #Form.ADSPid#>
         <cfset ConfUsu.IdProceso = #session.menues.SPcodigo#>
         <cfset session.ConfUsu = ConfUsu>
         <cfset ConfUsu.Usulogin = #Form.Usulogin#>
    <cfelseif isdefined("Form.Filtrar")>
		<cfif (not isdefined ("form.Usucodigo") or form.Usucodigo EQ "") and (not isdefined("form.ADSPid") or form.ADSPid EQ "")>
	        <cf_errorCode	code = "80010" msg = "No ha definido ningún valor de búsqueda!">
		</cfif>
        
		<cfif rsConsultaUsu.recordcount GT 0>
            <cfset modo="CAMBIO">
        <cfelse>
            <cf_errorCode	code = "80008" msg = "No se ha definido perfil para este usuario!">
            <cfset modo="ALTA">
        </cfif>
        <cfif isdefined("session.ConfUsu")>       
    		<cfset StructDelete(session, "ConfUsu")>
        </cfif>
			<cfset ConfUsu = StructNew()>
            <cfset ConfUsu.Ecodigo = #session.Ecodigo#>
            <cfset ConfUsu.IdUsu = #Form.Usucodigo#>
            <cfset ConfUsu.IdPerfil = #Form.ADSPid#>
            <cfset ConfUsu.IdProceso = #session.menues.SPcodigo#>
            <cfset session.ConfUsu = ConfUsu>
            <cfset ConfUsu.Usulogin = #Form.Usulogin#>
        
    <cfelseif isdefined("Form.Finalizar")> 
    	<cfif isdefined("session.ConfUsu")>       
    		<cfset StructDelete(session, "ConfUsu")>
        </cfif>
         <cfset modo="ALTA">
	</cfif>			


<cfoutput>

<cfset param = ''>
	 <cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>
     	<cfset Usucodigo = "#form.Usucodigo#">
     <cfelse>
	     <cfset Usucodigo = "">     
     </cfif>
     <cfif isdefined("form.ADSPid") and len(trim(form.ADSPid))>
     	<cfset ADSPid = "#form.ADSPid#">
     <cfelse>
	     <cfset ADSPid = "">     
     </cfif>
<cfif isdefined("form.Filtrar") and modo EQ "CAMBIO">
	<cfset param = param & "?ADSPid=#ADSPid#"&"&modo=#modo#"&"&Usucodigo=#Usucodigo#">
<cfelseif isdefined("Form.Guardar") and modo EQ "CAMBIO">
	 <cfset param = param & "?ADSPid=#ADSPid#"&"&modo=#modo#"&"&Usucodigo=#form.Usucodigo#">
<cfelseif isdefined("Form.Finalizar")>
	 <cfset param = param & "?modo=#modo#">     
     
</cfif>

<cflocation url="seguridadUsuario.cfm#param#">
</cfoutput>
