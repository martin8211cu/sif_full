  <cfset LvarXML_IE = "
<resultset>
    <row>
	    <ID></ID>
	 	<Empresa>28</Empresa>
		<Articulo>LN03020083</Articulo> 
		<Almacen></Almacen>
    </row>
</resultset>">

  <cfset LvarXML_ID = "">
  <cfset LvarXML_IS = "">
  
  
  	 <cftry>	
         <cfinvoke
                webservice="http://localhost:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
                username	= "ymena"
                password	= "inso2000"
                method		= "sendToSoinXML"
                returnvariable	= "LvarXML"
                Empresa			= "soin"
                EcodigoSDC		= "83"
                Num_Interfaz		= "721"
                XML_IE			= "#LvarXML_IE#"
                XML_ID			= "#LvarXML_ID#"
                XML_IS			= "#LvarXML_IS#"
                XML_OUT 		= "1"
            >
		<cfoutput>
         <cfdump var="#LvarXML#">
			MSG		= #LvarXML.MSG#<br>
			ID 		= #LvarXML.ID#<br>
			XML_OE 	= #LvarXML.XML_OE#<br>
			XML_OD 	= #LvarXML.XML_OD#<br>
			XML_OS 	= #LvarXML.XML_OS#<br>
		</cfoutput>
	
		<cfcatch >   
			<cfoutput>
				<p>*#cfcatch.message#*</p>
			</cfoutput>
		</cfcatch>
	</cftry>
    

