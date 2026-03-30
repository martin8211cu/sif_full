<cftry>
 	<cfset LvarXML_OUT  = url.XML_OUT>
	<cfset LVarXML_DBS	= url.XML_DBS>
	<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">

	<cfset GvarXML = LobjColaProcesos.fnProcesoNuevoExternoXML (GvarNI, GvarUD)>

	<cfset GvarMSG = GvarXML.MSG>
	<cfset GvarID  = GvarXML.ID>
	
<cfcatch type="any">
	<cfset LvarMSGstackTrace = LobjColaProcesos.fnGetStackTrace(cfcatch)>

	<cfset LobjColaProcesos.fnLog("","ERROR DE ANTES DE INICIAR LA INTERFAZ (WSX), StackTrace=#LvarMSGstackTrace#")>

	<cfset GvarMSG = "ERROR DE ANTES DE INICIAR LA INTERFAZ (WSX): #cfcatch.Message# #cfcatch.Detail#">
</cfcatch>
</cftry>

<cfheader name="SOIN-MSG" 	value="#URLEncodedFormat(GvarMSG)#">
<cfheader name="SOIN-ID" 	value="#URLEncodedFormat(GvarID)#">
<cftry>
<cfif GvarMSG EQ  "OK" AND LvarXML_OUT EQ "1">
	<cfif GvarXML.ManejoDatos NEQ "T">
		<cfparam name="GvarXML.XML_OE" default="">
		<cfparam name="GvarXML.XML_OD" default="">
		<cfparam name="GvarXML.XML_OS" default="">
		<cfoutput>
<!--
#LobjColaProcesos.fnXMLresponse("OE",GvarXML.XML_OE)#
#LobjColaProcesos.fnXMLresponse("OD",GvarXML.XML_OD)#
#LobjColaProcesos.fnXMLresponse("OS",GvarXML.XML_OS)#
-->
		</cfoutput>
	<cfelse>
		<cfset LobjColaProcesos.sbGeneraTablaToXML (GvarNI, GvarID, "O", "E", LvarXML_DBS, true)>
		<cfset LobjColaProcesos.sbGeneraTablaToXML (GvarNI, GvarID, "O", "D", LvarXML_DBS, true)>
		<cfset LobjColaProcesos.sbGeneraTablaToXML (GvarNI, GvarID, "O", "S", LvarXML_DBS, true)>
	</cfif>
</cfif>
<cfcatch type="any">
</cfcatch>
</cftry>
<cfinclude template="interfaz-service-form.cfm">
