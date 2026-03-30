<cfset LvarXML_IE = "<resultset>
						  <row>
								 <Ecodigo>1</Ecodigo>
								<Ano>2011</Ano>
								<Fechaini>Nov 01 2011</Fechaini>
								<Fechahasta>Dec 31 2011</Fechahasta>
						  </row>
				</resultset>
">
<cfset LvarXML_ID = "">
<cfset LvarXML_IS = "">
<cfsetting requesttimeout="30000">

<cfinvoke
		webservice="http://172.20.18.33/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
		username = "tecrh"
		password = "12345x"

		method = "sendToSoinXML"
		returnvariable = "LvarXML"

		Empresa = "itcr"
		EcodigoSDC = "2"

		Num_Interfaz = "418"
		XML_IE = "#LvarXML_IE#"
		XML_ID = "#LvarXML_ID#"
		XML_IS = "#LvarXML_IS#"
		XML_OUT = "true"
>

<cfoutput>
MSG = #LvarXML.MSG#<br>
ID = #LvarXML.ID#<br>
XML_OE = #LvarXML.XML_OE#<br>
XML_OD = #LvarXML.XML_OD#<br>
XML_OS = #LvarXML.XML_OS#<br>
</cfoutput> 
