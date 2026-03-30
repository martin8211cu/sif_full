
<cfset LvarXML_IE = "<resultset>
						<row>
							<CANTIDAD_DOCUMENTOS>1</ CANTIDAD_DOCUMENTOS >
						</row>
					</resultset>"> 
	
<cfset LvarXML_ID = "<resultset>
						<row>
							<CODIGO_CONTRATO_OC></CODIGO_CONTRATO_OC>
							<LINEA_CONTRATO_OC></LINEA_CONTRATO_OC>
							<ORIGEN>SIGEPRO</ORIGEN>
							<DOCUMENTO>30</DOCUMENTO>
							<ESTATUS>A</ESTATUS>
							<MENSAJE>prueba</MENSAJE>
						</row>
					</resultset>">

  
    <cfsetting requesttimeout="30000">
                        
       <cfinvoke
            webservice="http://192.168.4.19:7800/SIFCOServices?wsdl"
            username	= "usuario.soin"
            password	= "s01n"
            method		= "SifcoSigepro"
            returnvariable	= "LvarXML"
            Empresa			= "CONAVI"
            EcodigoSDC		= "3"
            Num_Interfaz		= "309"
            XML_IE			= "#LvarXML_IE#"
            XML_ID			= "#LvarXML_ID#"
            XML_IS			= ""
            XML_OUT 		= "true"
        >          
                
		<cfoutput>
			MSG		= #LvarXML.MSG#<br>
			ID 		= #LvarXML.ID#<br>
			XML_OE 	= #LvarXML.XML_OE#<br>
			XML_OD 	= #LvarXML.XML_OD#<br>
			XML_OS 	= #LvarXML.XML_OS#<br>
		</cfoutput>
	
	