<!---
        <ID>0</ID>
        <Referencia>0</Referencia>

        <ID>0</ID>
--->
<cfset LvarXML_IE = "
<resultset>
    <row>
        <EcodigoSDC>83</EcodigoSDC>
        <NumeroSocio>3101070993</NumeroSocio>
        <Modulo>CC</Modulo>
        <CodigoTransacion>ND</CodigoTransacion>
        <Documento>DocAli14</Documento>
        <Estado></Estado>
        <CodigoMoneda>CRC</CodigoMoneda>
        <FechaDocumento>2014-05-29</FechaDocumento>
        <FechaVencimiento>2014-05-29</FechaVencimiento>
        <Facturado>1</Facturado>
        <Origen>CCND</Origen>
        <VoucherNo>0</VoucherNo>
        <CodigoRetencion></CodigoRetencion>
        <CodigoOficina>1</CodigoOficina>
        <CuentaFinanciera></CuentaFinanciera>
        <CodigoConceptoServicio></CodigoConceptoServicio>
        <DiasVencimiento>0</DiasVencimiento>
        <CodigoDireccionEnvio>3101070993</CodigoDireccionEnvio>
        <CodigoDireccionFact>3101070993</CodigoDireccionFact>
        <FechaTipoCambio></FechaTipoCambio>
        <StatusProceso>10</StatusProceso>
        <DEobservacion>OBSERVACIONES 1</DEobservacion>
        <Dtipocambio>1</Dtipocambio>
        <ConceptoCobroPago></ConceptoCobroPago>
        <DEnumReclamo></DEnumReclamo>
        <DEordenCompra></DEordenCompra>
    </row>
</resultset>">

<cfset LvarXML_ID = "<resultset>
    <row>
        <Consecutivo>1</Consecutivo>
        <TipoItem>S</TipoItem>
        <CodigoItem>844002000</CodigoItem>
        <NombreBarco></NombreBarco>
        <FechaHoraCarga></FechaHoraCarga>
        <FechaHoraSalida></FechaHoraSalida>
        <PrecioUnitario>10000</PrecioUnitario>
        <CodigoUnidadMedida>UN</CodigoUnidadMedida>
        <CantidadTotal>1</CantidadTotal>
        <CantidadNeta>1</CantidadNeta>
        <CodEmbarque></CodEmbarque>
        <Referencia>1</Referencia>
        <NumeroBOL>0</NumeroBOL>
        <FechaBOL>1900-01-01</FechaBOL>
        <TripNo></TripNo>
        <ContractNo></ContractNo>
        <CodigoImpuesto></CodigoImpuesto>
        <ImporteImpuesto></ImporteImpuesto>
        <ImporteDescuento></ImporteDescuento>
        <CodigoAlmacen></CodigoAlmacen>
        <CodigoDepartamento></CodigoDepartamento>
        <PrecioTotal>10000</PrecioTotal>
        <CentroFuncional>CI20314</CentroFuncional>
        <CuentaFinancieraDet>8400-001-844-002-0228-0010</CuentaFinancieraDet>
        <OCconceptoIngreso></OCconceptoIngreso>
        <OCtransporteTipo></OCtransporteTipo>
        <OCtransporte></OCtransporte>
        <OCcontrato></OCcontrato>
        <OCconceptoCompra></OCconceptoCompra>
        <DDdescripcion>descripcion 1</DDdescripcion>
        <DDdescalterna>descripcion alterna</DDdescalterna>
        <factor></factor>
		<TipoTransaccion>TE007</TipoTransaccion>
		<Producto>183</Producto>
    </row>
</resultset>">
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
			Num_Interfaz	= "10"
			XML_IE			= "#LvarXML_IE#"
			XML_ID			= "#LvarXML_ID#"
			XML_IS			= "#LvarXML_IS#"
			XML_OUT 		= "false">
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
