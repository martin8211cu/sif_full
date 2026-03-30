<cfsetting requesttimeout="1800">
<cfapplication name="SIF_ASP" sessionmanagement="Yes" clientmanagement="No" setclientcookies="Yes" sessiontimeout="#CreateTimeSpan(0,10,0,0)#">
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">

<cfset GvarUsuario 				    = 'abrenes'>


<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
INICIO de la interfaz 752.<br />
<cfflush interval="10">


<!--- Insertar la información para probar la Interface 752 --->

	<cfset LvarProcesar = true>
    
	<cfset LvarID = LobjColaProcesos.fnSiguienteIdProceso()>

	

	<cfquery datasource="sifinterfaces">
        insert into IE752 (
            ID,
            NumDoc,
            CodSistema,
            ECodigoOrigen
			)
            values (
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarID#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="n123">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="s123">,
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value=12>
                    )

  	</cfquery>

    	<cfset LvarMSG = LobjColaProcesos.fnProcesoNuevoExterno (752, LvarID, GvarUsuario)>
		<cfif LvarMSG NEQ "OK">
			<cfthrow message="#LvarMSG#">
		</cfif>




<cfoutput>
FIN de  ID:#LvarID#
</cfoutput>

