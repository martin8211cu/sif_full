
<cfset LvarXML_IE = "<resultset>
						<row>
							<CANTIDAD_DOCUMENTOS>1</CANTIDAD_DOCUMENTOS>
							<IMPORTE_TOTAL>200</IMPORTE_TOTAL>
							<TIPO_MENSAJE>ESTIMACION</TIPO_MENSAJE>	
						</row>
					</resultset>"> 
	
<cfset LvarXML_ID = "<resultset>
						<row>
							<CODIGO_PROYECTO></CODIGO_PROYECTO>
							<CODIGO_CONTRATO_OC></CODIGO_CONTRATO_OC>
							<FECHA_DOCUMENTO>2010-11-06 10:52:31</FECHA_DOCUMENTO>
							<PERIODO>2010</PERIODO>
							<USUARIO_QUE_ESTIMA>bmora</USUARIO_QUE_ESTIMA>
							<DOCUMENTO>50</DOCUMENTO>
							<IMPORTE_AVANCE_TOTAL>200</IMPORTE_AVANCE_TOTAL>
							<PLANDECOMPRAS>25</PLANDECOMPRAS>
							<CENTRO_FUNCIONAL>FORUM</CENTRO_FUNCIONAL>	
							<IDENTIFICACION_CONTRATISTA>19345-75</IDENTIFICACION_CONTRATISTA>
							<MONEDA_DELAESTIMACION></MONEDA_DELAESTIMACION>		
						</row>
					</resultset>">

<cfset LvarXML_IS = "<resultset>
						<row>
							<CODIGO_CONTRATO_OC></CODIGO_CONTRATO_OC>
							<LINEA_CONTRATO_OC></LINEA_CONTRATO_OC>
							<FUENTE_FINANCIAMIENTO></FUENTE_FINANCIAMIENTO>
							<DOCUMENTO>50</DOCUMENTO>
							<IMPORTE_AVANCE>80</IMPORTE_AVANCE>
							<PLANDECOMPRAS>25</PLANDECOMPRAS>
							<CENTRO_FUNCIONAL>FORUM</CENTRO_FUNCIONAL>
						</row>
						<row>
							<CODIGO_CONTRATO_OC></CODIGO_CONTRATO_OC>
							<LINEA_CONTRATO_OC></LINEA_CONTRATO_OC>
							<FUENTE_FINANCIAMIENTO></FUENTE_FINANCIAMIENTO>
							<DOCUMENTO>50</DOCUMENTO>
							<IMPORTE_AVANCE>20</IMPORTE_AVANCE>
							<PLANDECOMPRAS>26</PLANDECOMPRAS>
							<CENTRO_FUNCIONAL>FORUM</CENTRO_FUNCIONAL>
						</row>
						<row>
							<CODIGO_CONTRATO_OC></CODIGO_CONTRATO_OC>
							<LINEA_CONTRATO_OC></LINEA_CONTRATO_OC>
							<FUENTE_FINANCIAMIENTO></FUENTE_FINANCIAMIENTO>
							<DOCUMENTO>50</DOCUMENTO>
							<IMPORTE_AVANCE>45</IMPORTE_AVANCE>
							<PLANDECOMPRAS>27</PLANDECOMPRAS>
							<CENTRO_FUNCIONAL>FORUM</CENTRO_FUNCIONAL>
						</row>
						<row>
							<CODIGO_CONTRATO_OC></CODIGO_CONTRATO_OC>
							<LINEA_CONTRATO_OC></LINEA_CONTRATO_OC>
							<FUENTE_FINANCIAMIENTO></FUENTE_FINANCIAMIENTO>
							<DOCUMENTO>50</DOCUMENTO>
							<IMPORTE_AVANCE>55</IMPORTE_AVANCE>
							<PLANDECOMPRAS>28</PLANDECOMPRAS>
							<CENTRO_FUNCIONAL>FORUM</CENTRO_FUNCIONAL>
						</row>
					</resultset>">
  
    <cfsetting requesttimeout="30000">
                        
       <cfinvoke
            webservice="http://127.0.0.1:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
            username	= "bmora"
            password	= "sup3rman"
            method		= "sendToSoinXML"
            returnvariable	= "LvarXML"
            Empresa			= "soin"
            EcodigoSDC		= "2"
            Num_Interfaz		= "307"
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
	
	