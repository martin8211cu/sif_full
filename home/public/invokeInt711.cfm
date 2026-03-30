<!---Prueba de Error Controlado con los montos del detalle y encabezado--->
<cfset LvarXML_IE = "<resultset>
						   <row>
								<TEScodigo>0001</TEScodigo>
								<SNcodigo>10031</SNcodigo>
								<TESOPfechaPago>2011-09-21</TESOPfechaPago>
								<EcodigoPago></EcodigoPago>
								<CBcodigoPago>1234567890</CBcodigoPago>
								<TESMPcodigo>TEF</TESMPcodigo>
								<TESTPcuentab></TESTPcuentab>
								<TESOPobservaciones>Prueba Interfaz Orden de Pago</TESOPobservaciones>
								<GeneraOP>1</GeneraOP>
								<SecOrden>1</SecOrden>
						   </row>
						</resultset>"> 

  <cfset LvarXML_ID = "<resultset>
						   <row>
								<SecOrden>1</SecOrden>
								<SecSolicitud>1</SecSolicitud>
								<EcodigoOri></EcodigoOri>
								<CFcodigo>RAIZ</CFcodigo>
								<TESSPtipoDocumento>0</TESSPtipoDocumento>
								<TESSPfechaPagar>2011-09-21</TESSPfechaPagar>
								<Miso4217>CRC</Miso4217>
								<TESPtipoCambioOriManual>1</TESPtipoCambioOriManual>
								<TESSPfechaSolicitud>2011-09-21</TESSPfechaSolicitud>
								<TESSPobservaciones>Prueba I707 (O:1 S:1)</TESSPobservaciones>
						   </row>
						   
						   <row>
								<SecOrden>1</SecOrden>
								<SecSolicitud>2</SecSolicitud>
								<EcodigoOri></EcodigoOri>
								<CFcodigo>RAIZ</CFcodigo>
								<TESSPtipoDocumento>0</TESSPtipoDocumento>
								<TESSPfechaPagar>2011-09-21</TESSPfechaPagar>
								<Miso4217>CRC</Miso4217>
								<TESPtipoCambioOriManual>1</TESPtipoCambioOriManual>
								<TESSPfechaSolicitud>2011-09-21</TESSPfechaSolicitud>
								<TESSPobservaciones>Prueba I707 (O:1 S:2)</TESSPobservaciones>
						   </row>
						</resultset>">
                        
  <cfset LvarXML_IS = "<resultset>
						   <row>
								<SecOrden>1</SecOrden>
								<SecSolicitud>1</SecSolicitud>
								<TESDPdocumentoOri>60</TESDPdocumentoOri>
								<TESDPreferenciaOri>SP MANUAL</TESDPreferenciaOri>
								<TESDPfechaVencimiento>2011-09-21</TESDPfechaVencimiento>
								<TESDPmontoVencimientoOri>225</TESDPmontoVencimientoOri>
								<TESDPdescripcion>Prueba Detalle I707 (O:1 S:1) 1</TESDPdescripcion>
								<Icodigo>IV</Icodigo>
								<CFformato>0021-10</CFformato>
						   </row>
						   
						   <row>
								<SecOrden>1</SecOrden>
								<SecSolicitud>1</SecSolicitud>
								<TESDPdocumentoOri>61</TESDPdocumentoOri>
								<TESDPreferenciaOri>SP MANUAL</TESDPreferenciaOri>
								<TESDPfechaVencimiento>2011-09-21</TESDPfechaVencimiento>
								<TESDPmontoVencimientoOri>625</TESDPmontoVencimientoOri>
								<TESDPdescripcion>Prueba Detalle I707 (O:1 S:1) 2</TESDPdescripcion>
								<Icodigo>IV</Icodigo>
								<CFformato>0021-10</CFformato>
						   </row>
						   
						   <row>
								<SecOrden>1</SecOrden>
								<SecSolicitud>2</SecSolicitud>
								<TESDPdocumentoOri>62</TESDPdocumentoOri>
								<TESDPreferenciaOri>SP MANUAL</TESDPreferenciaOri>
								<TESDPfechaVencimiento>2011-09-21</TESDPfechaVencimiento>
								<TESDPmontoVencimientoOri>400</TESDPmontoVencimientoOri>
								<TESDPdescripcion>Prueba Detalle I707 (O:1 S:2) 1</TESDPdescripcion>
								<Icodigo>IV</Icodigo>
								<CFformato>0021-10</CFformato>
						   </row>
						   
						   <row>
								<SecOrden>1</SecOrden>
								<SecSolicitud>2</SecSolicitud>
								<TESDPdocumentoOri>63</TESDPdocumentoOri>
								<TESDPreferenciaOri>SP MANUAL</TESDPreferenciaOri>
								<TESDPfechaVencimiento>2011-09-21</TESDPfechaVencimiento>
								<TESDPmontoVencimientoOri>800</TESDPmontoVencimientoOri>
								<TESDPdescripcion>Prueba Detalle I707 (O:1 S:2) 2</TESDPdescripcion>
								<Icodigo>IV</Icodigo>
								<CFformato>0021-10</CFformato>
						   </row>
						</resultset>">
  
  <cfsetting requesttimeout="30000">

	 <cftry>
	 
	
	 <cfinvoke
			webservice="http://10.7.7.54:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
			username	= "obonilla66"
			password	= "sup3rman"
			method		= "sendToSoinXML"
			returnvariable	= "LvarXML"
			Empresa			= "soin"
			EcodigoSDC		= "2"
			Num_Interfaz		= "711"
			XML_IE			= "#LvarXML_IE#"
			XML_ID			= "#LvarXML_ID#"
			XML_IS			= "#LvarXML_IS#"
			XML_OUT 		= "false"
		>
		<cfoutput>
			MSG		= #LvarXML.MSG#<br>
			ID 		= #LvarXML.ID#<br>
			XML_OE 	= #LvarXML.XML_OE#<br>
			XML_OD 	= #LvarXML.XML_OD#<br>
			XML_OS 	= #LvarXML.XML_OS#<br>
		</cfoutput>
	
		<cfcatch type = "ANY">   
			<cfoutput>
				<p>*#cfcatch.message#*</p>
			</cfoutput>
		</cfcatch>
	</cftry>
