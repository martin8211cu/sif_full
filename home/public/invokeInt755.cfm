<cfset Doc = 'BerPrueba5'>
<cfset LvarXML_IE = "
<resultset>
    <row>
        <NumDoc>#Doc#</NumDoc>
        <Ecodigo>28</Ecodigo>
        <Miso4217>CRC</Miso4217>
        <SNcodigoext>814044</SNcodigoext>
        <SNcodigoextAgencia></SNcodigoextAgencia>
        <CCTcodigo>NC</CCTcodigo>
        <CFcodigo>CI208</CFcodigo>
        <tipoCambio>1</tipoCambio>
        <PorcentajeMontoDescuento>M</PorcentajeMontoDescuento>
        <Descuento>0</Descuento>
        <FechaDocumento>2014-12-10 15:55:48</FechaDocumento>
        <FechaVencimiento>2014-12-10 15:55:48</FechaVencimiento>
        <Usuario>Bernal</Usuario>
        <SNidentificacionVendedor></SNidentificacionVendedor>
        <SNidentificacionCobrador></SNidentificacionCobrador>
        <Observacion>Prueba NOTA CREDITO bernal</Observacion>
        <CodDireccionExt>814044</CodDireccionExt>
        <NumLote></NumLote>
        <Chkimprimir>N</Chkimprimir>
        <AplicarAFacturas>N</AplicarAFacturas>
    </row>
</resultset>">

<cfset LvarXML_ID = "<resultset>
       <row>		        
	        <NumDoc>#Doc#</NumDoc>
	        <NumLineaDet>1</NumLineaDet>
	        <TipoVenta>A</TipoVenta>
	        <TipoTransaccion>DEVP</TipoTransaccion>
	        <CodArticulo>L805100006</CodArticulo>
	        <CodAlmacen>07</CodAlmacen>
	        <Producto>0236</Producto>
	        <Descripcion>Prueba NOTA CREDITO</Descripcion>
	        <DescAlterna>Prueba NOTA CREDITO</DescAlterna>
	        <Cantidad>1</Cantidad>
	        <MontoUnitario>1000</MontoUnitario>
	        <MontoDescuento>0</MontoDescuento>
	        <Icodigo>EXE</Icodigo>
	        <MontoImpuesto>0</MontoImpuesto>
	        <MontoLinea>1000</MontoLinea>
	        <CFcodigo>CI20314 </CFcodigo>
	        <idLineaRefInt>500</idLineaRefInt>
	    </row>
</resultset>">

<cfset LvarXML_IS = "<resultset>
  	<row>		        
        <NumDoc>#Doc#</NumDoc>
        <CCTcodigoRef>FS</CCTcodigoRef>
        <DdocumentoRef>SF00302678</DdocumentoRef>
        <monto>0</monto>
    </row>
</resultset>">


<cfinvoke
	webservice="http://172.16.5.85:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
	username	= "sinterfaces"
	password	= "interfaces2000"
	method		= "sendToSoinXML"
	returnvariable	= "LvarXML"
	Empresa			= "soin"
	EcodigoSDC		= "83"
	Num_Interfaz	= "755"
	XML_IE			= "#LvarXML_IE#"
	XML_ID			= "#LvarXML_ID#"
	XML_IS			= "#LvarXML_IS#"
	XML_OUT 		= "0"
 >
	 
<cfoutput>
	MSG		= #LvarXML.MSG#<br>
	ID 		= #LvarXML.ID#<br>
	XML_OE 	= #LvarXML.XML_OE#<br>
	XML_OD 	= #LvarXML.XML_OD#<br>
	XML_OS 	= #LvarXML.XML_OS#<br>
</cfoutput>
