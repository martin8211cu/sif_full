<cfset LvarXML_IE = "
					<resultset>
						<row>
							<Empresa>28</Empresa>(Mandatory)
							<EstadoVale>0</EstadoVale>
							<Clasificacion></Clasificacion> 
							<Almacen>08</Almacen>
							<fechaIni></fechaIni>
							<fechaFin></fechaFin>
							<Numero_Requisicion></Numero_Requisicion>
							<Centro_Costo></Centro_Costo>
						</row>
					</resultset>
					"> 

  <cfset LvarXML_ID = "">
  <cfset LvarXML_IS = "">
  <cfsetting requesttimeout="30000">

	 <cftry>
	 
	
	 <cfinvoke
		webservice="http://172.16.5.86:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
		username	= "sinterfaces"
		password	= "interfaces2000"
		method		= "sendToSoinXML"
		returnvariable	= "LvarXML"
		Empresa			= "soin"
		EcodigoSDC		= "83"
		Num_Interfaz	= "715"
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
	
		<cfcatch type = "ANY">   
			<cfoutput>
				<p>*#cfcatch.message#*</p>
			</cfoutput>
		</cfcatch>
	</cftry>
