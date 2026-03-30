<cfif url.WS_XML>
 	<cfinclude template="interfaz-serviceXML.cfm">
	<cfabort>
</cfif>
<cftry>
	<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
	<cfset GvarMSG = LobjColaProcesos.fnProcesoNuevoExterno (GvarNI, GvarID, GvarUD)>
<cfcatch type="any">
	<cfset GvarMSG = "ERROR DE ANTES DE INICIAR LA INTERFAZ (WS): #cfcatch.Message# #cfcatch.Detail#">
</cfcatch>
</cftry>

<cfheader name="SOIN-MSG" 	value="#URLEncodedFormat(GvarMSG)#">
<cfinclude template="interfaz-service-form.cfm">

