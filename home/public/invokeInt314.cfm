
<cfset LvarXML_IE = "<resultset>
						<row>
							<TIPO_CONSULTA>PLANDECOMPRAS</TIPO_CONSULTA>
							<PATRON_CONTRATACION>0020</PATRON_CONTRATACION>
							<PATRON_NOMBRE_PROVEEDOR></PATRON_NOMBRE_PROVEEDOR>
							<PATRON_IDENTIFICACION_PROVEEDO></PATRON_IDENTIFICACION_PROVEEDO>
							<PARTIDA_PRESUPUESTARIA></PARTIDA_PRESUPUESTARIA>
							<CENTRO_FUNCIONAL>FORUM</CENTRO_FUNCIONAL>
							<PERIODO>2010</PERIODO>						
						</row>
					</resultset>"> 

<cfset LvarXML_ID = "">

<cfset LvarXML_IS = "">
  
    <cfsetting requesttimeout="30000">
                        
       <cfinvoke
            webservice="http://127.0.0.1:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
            username	= "bmora"
            password	= "sup3rman"
            method		= "sendToSoinXML"
            returnvariable	= "LvarXML"
            Empresa			= "soin"
            EcodigoSDC		= "2"
            Num_Interfaz		= "314"
            XML_IE			= "#LvarXML_IE#"
            XML_ID			= ""
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
	
	