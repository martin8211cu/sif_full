<!---Prueba de Error Controlado con los montos del detalle y encabezado--->
<cfset LvarXML_IE = "<resultset>
						   	<row>
								 	<ID>49105</ID>
									<EcodigoSDC>1</EcodigoSDC>
									<ModuloOrigen>CP</ModuloOrigen>
									<CodigoMonedaOrigen>CRC</CodigoMonedaOrigen>
									<NumeroSocioDocOrigen>741</NumeroSocioDocOrigen>
									<CodigoTransacionOrig>NC</CodigoTransacionOrig>
									<DocumentoOrigen>rewa</DocumentoOrigen>
									<MontoOrigen>2.28</MontoOrigen>
									<ModuloDestino>CP</ModuloDestino>
									<CodigoMonedaDestino>CRC</CodigoMonedaDestino>
									<NumeroSocioDocDestino>852</NumeroSocioDocDestino>
									<CodigoTransacionDest>xFA</CodigoTransacionDest>
									<DocumentoDestino>MDMI</DocumentoDestino>
									<MontoDestino>1000</MontoDestino>
									<TipoCambio>1</TipoCambio>
									<FechaAplicacion>2012-05-31 14:23:31</FechaAplicacion>
									<TransaccionOrigen>Ber</TransaccionOrigen>
									<Referencia>1111</Referencia>
									<TipoNeteo>1</TipoNeteo>
        							<TipoNeteoDocs>2</TipoNeteoDocs>
						   	</row>
						</resultset>"> 

  <cfset LvarXML_ID = "<resultset>
						   <row>
								 <ID>49105</ID>
								<NumeroSocioDoc>741</NumeroSocioDoc>
								<Modulo>CC</Modulo>
								<CodigoTransaccion>NC</CodigoTransaccion>
								<Documento>rewa</Documento>
								<Monto>2.28</Monto>
								<MontoNC></MontoNC>
								<CodigoMoneda>CRC</CodigoMoneda>
						   </row>
						   
						 
					</resultset>">
                        
   
  <cfsetting requesttimeout="30000">

	 <cftry>
	 
	
	 <cfinvoke
			webservice="http://172.20.3.129:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
			username	= "obonilla66"
			password	= "sup3rman"
			method		= "sendToSoinXML"
			returnvariable	= "LvarXML"
			Empresa			= "soin"
			EcodigoSDC		= "2"
			Num_Interfaz		= "12"
			XML_IE			= "#LvarXML_IE#"
			XML_ID			= "#LvarXML_ID#"
            XML_IS			= ""
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
                <p>*#cfcatch.Detail#*</p>

                <p>*#cfcatch.Type#*</p>
			</cfoutput>
		</cfcatch>
	</cftry>
