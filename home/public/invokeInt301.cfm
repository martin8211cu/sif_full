  	<cfset LvarXML_IE = 
"<resultset>
    <row>
        <CANTIDAD_DOCUMENTOS>1</CANTIDAD_DOCUMENTOS>
        <IMPORTE_TOTAL>100.00</IMPORTE_TOTAL>
    </row>
</resultset>">

  	<cfset LvarXML_ID = 
"<resultset>
    <row>
        <DOCUMENTO>0001</DOCUMENTO>
        <FECHA_ESTIMACION>#dateFormat(now(),"YYYY-MM-DD")# #timeFormat(now(),"HH:MM:SS")#</FECHA_ESTIMACION>
        <TIPO_PRESUPUESTO>PO</TIPO_PRESUPUESTO>
        <IMPORTE_DOCUMENTO>100.00</IMPORTE_DOCUMENTO>
    </row>
</resultset>">

  	<cfset LvarXML_IS = 
"<resultset>
    <row>
        <DOCUMENTO>0001</DOCUMENTO>
        <LINEA>1</LINEA>
        <CANTIDAD_RECURSOS>1</CANTIDAD_RECURSOS>
        <CENTRO_FUNCIONAL>113000</CENTRO_FUNCIONAL>
        <CONCEPTO_GASTO>000-01-01</CONCEPTO_GASTO>
		<IMPORTE_LINEA>100.00</IMPORTE_LINEA>
		<JUSTIFICACION>primeras pruebas</JUSTIFICACION>
    </row>	 
</resultset>">

 <cfinvoke
		webservice="http://10.7.7.208:8301/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
		<!---username	= "obonilla6"
		password	= "sup3rman"
		--->
		username	= "soin"
		password	= "sup3rman"

		method		= "sendToSoinXML"
		returnvariable	= "LvarXML"
		
		Empresa			= "conavi"
		EcodigoSDC		= "42"
		Num_Interfaz	= "301"
		XML_IE			= "#LvarXML_IE#"
		XML_ID			= "#LvarXML_ID#"
		XML_IS			= "#LvarXML_IS#"
		XML_OUT 		= "true"
	>
		
	<cfoutput>
		MSG		= #LvarXML.MSG#<br>
		ID 		= #LvarXML.ID#<br>
		XML_OE 	= #LvarXML.XML_OE#<br>
		XML_OD 	= #LvarXML.XML_OD#<br>
		XML_OS 	= #LvarXML.XML_OS#<br>
	</cfoutput>
