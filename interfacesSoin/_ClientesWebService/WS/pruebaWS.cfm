  <cfset LvarXML_IE = 
        "<resultset>" &
        "    <row> " &
        "       <moduloOrigen>01</moduloOrigen> " &
        "       <numeroDocumento>11111111</numeroDocumento> " &
        "       <numeroReferencia>11111111</numeroReferencia> " &
        "       <FechaDocumento>2000-01-01 01:01:01</FechaDocumento> " &
        "       <AnoPresupuesto>2000</AnoPresupuesto> " &
        "       <MesPresupuesto>1</MesPresupuesto> " &
        "       <NAPreversado></NAPreversado> " &
        "       <SoloConsultar>1</SoloConsultar> " &
        "    </row> " &
        "</resultset> "
	>

  <cfset LvarXML_ID = 
        "<resultset>" &
        "    <row>" &
        "        <NumeroLinea>-123456789</NumeroLinea>" &
        "        <TipoMovimiento>" & XmlFormat("Esto es una Prueba") & "</TipoMovimiento>" &
        "        <CuentaFinanciera>" & XmlFormat("Esto es una '<Prueba>' de Ángel") & "</CuentaFinanciera>" &
        "        <CodigoOficina>" & XmlFormat("Esto es una Prueba") & "</CodigoOficina>" &
        "        <CodigoMonedaOrigen>" & XmlFormat("Esto es una Prueba") & "</CodigoMonedaOrigen>" &
        "        <MontoOrigen>-12345678901234.5678</MontoOrigen>" &
        "        <TipoCambio>-0.1234567890123456</TipoCambio>" &
        "        <Monto>-12345678901234.5678</Monto>" &
        "        <NAPreferencia>-123456789012345678</NAPreferencia>" &
        "        <LINreferencia>-123456789</LINreferencia>" &
        "    </row>" &
        "</resultset>"
  >
  <cfset LvarXML_IS = "">
    
  <cfinvoke
		webservice="http://localhost:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
		username="obonilla66" password="sup3rman"
		method			= "sendToSoinXML"
		returnvariable	= "LvarXML"
		
		Empresa			= "soin"
		EcodigoSDC		= "2"
		Num_Interfaz	= "8"
		XML_IE			= "#LvarXML_IE#"
		XML_ID			= "#LvarXML_ID#"
		XML_IS			= "#LvarXML_IS#"
		XML_OUT 		= "true"
	>
		
	<cfoutput>
		MSG= #LvarXML.MSG#<br>
		ID = #LvarXML.ID#<br>
		XML_OE = <textarea cols="80" rows="10">#LvarXML.XML_OE#</textarea><BR>
		XML_OD = <textarea cols="80" rows="10">#LvarXML.XML_OD#</textarea><BR>
		XML_OS = <textarea cols="80" rows="10">#LvarXML.XML_OS#</textarea><BR>
	</cfoutput>
