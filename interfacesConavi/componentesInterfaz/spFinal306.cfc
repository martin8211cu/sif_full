<cfcomponent>
	<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
	<cfset GvarXML_IE = LobjInterfaz.sbGeneraTablaToXML (GvarNI, GvarID, "I", "E", "0", false)>
	<cfset GvarXML_ID = LobjInterfaz.sbGeneraTablaToXML (GvarNI, GvarID, "I", "D", "0", false)>
	<cfset GvarXML_IS = LobjInterfaz.sbGeneraTablaToXML (GvarNI, GvarID, "I", "S", "0", false)>

	<!---<cfinvoke webservice="http://192.168.4.19:7800/SIFCOServices?WSDL"  method="SifcoSigepro"  >
	<cfinvokeargument name="Num_Interfaz" 	value="#GvarNI#"> 
	<cfinvokeargument name="ID_Proceso" 	value="#GvarID#">
	<cfinvokeargument name="EcodigoSDC" 	value="#session.EcodigoSDC#">
	<cfinvokeargument name="XML_IE" 		value="#GvarXML_IE#">
	<cfinvokeargument name="XML_ID" 		value="#GvarXML_ID#">
	<cfinvokeargument name="XML_IS" 		value="#GvarXML_IS#">
	</cfinvoke> --->
<cfinvoke webservice =
"http://10.7.7.131:8300/cfmx/interfacesSoin/ws/prueba.cfc?WSDL" method="sp_finalXML">
	<cfinvokeargument name="Num_Interfaz" 	value="306"> 
	<cfinvokeargument name="ID_Proceso" 	value="#GvarID#">
	<cfinvokeargument name="EcodigoSDC" 	value="#session.EcodigoSDC#">
	<cfinvokeargument name="XML_IE" 		value="#GvarXML_IE#">
	<cfinvokeargument name="XML_ID" 		value="#GvarXML_ID#">
	<cfinvokeargument name="XML_IS" 		value="#GvarXML_IS#">
	</cfinvoke>	
</cfcomponent>