<cfsetting requesttimeout="1800">
<cfapplication name="SIF_ASP" sessionmanagement="Yes" clientmanagement="No" setclientcookies="Yes" sessiontimeout="#CreateTimeSpan(0,10,0,0)#">
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">

<cfset GvarUsuario = 'jcarmona'>

<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
INICIO de la interfaz 18.<br />
<cfflush interval="10">

<cfset LvarProcesar = true>

<cfset LvarID = LobjColaProcesos.fnSiguienteIdProceso()>

<cfquery datasource="sifinterfaces" name="rsIE18">
	select ID from IE18
</cfquery>

<cfoutput>Asientos de Ingresos por Procesar #rsIE18.RecordCount#</cfoutput><br />
	
<cfloop query="rsIE18">
	<cfoutput>
		Procesando #rsIE18.ID#
		<cfset LvarMSG = LobjColaProcesos.fnProcesoNuevoExterno (18, rsIE18.ID, GvarUsuario)>
		
		<cfif LvarMSG NEQ "OK">
			#LvarMSG#
		<cfelse>
			
		</cfif>	
	</cfoutput>
	<br />
</cfloop>