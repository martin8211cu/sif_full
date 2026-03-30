<!--- Invocación a la interfaz 102 --->

<cfif not isdefined("url.EPDid")>
	<cf_errorCode	code = "50246" msg = "Debe enviar el campo EPDid con su valor por URL.">
</cfif>

<cfquery name="rsDocumentosPoliza" datasource="#session.dsn#"> 
	select EDIid 
	from EDocumentosI 
	where EPDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EPDid#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and EDIestado = 10 
</cfquery> 

<cfloop query="rsDocumentosPoliza">
	<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> 
	<cfset LobjInterfaz.fnProcesoNuevoSoin(102,"EDIid=#rsDocumentosPoliza.EDIid#","R")>
</cfloop>

<cfoutput>
Proceso terminado
<br />
<br />
NO refresque la pagina pues enviará de nuevo el documento a la interfaz
<br />
<br />

Oprima <a href="/cfmx/sif/">aquí</a> para ir al menu principal de SIF
</cfoutput>



