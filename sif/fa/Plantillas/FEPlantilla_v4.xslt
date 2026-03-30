<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cfdi="http://www.sat.gob.mx/cfd/4" 
    xmlns:tfd="http://www.sat.gob.mx/TimbreFiscalDigital"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 

    xsi:schemaLocation="http://www.sat.gob.mx/cfd/4 http://www.sat.gob.mx/sitio_internet/cfd/4/cfdv40.xsd">
	<xsl:output method="html" indent="yes"/>

    <xsl:param name="imgEmpresa"/>

    <xsl:template match="/cfdi:Comprobante">
        <xsl:variable name="dirFiscalEmpresa" select="cfdi:Emisor/@dirFiscal"/>
        <xsl:variable name="dirFiscalCliente" select="cfdi:Receptor/@dirFiscal"/>
        <xsl:variable name="referenciaEmpresa" select="cfdi:Emisor/@referencia"/>
        <xsl:variable name="referenciaCliente" select="cfdi:Receptor/@referencia"/>

        <html>

        <style>
        table {
            font-family:'DejaVu Sans Condensed';
        }
        </style>
        <body>
            <table border="0">
                <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">
                    <tr>
                        <!-- DATOS DE LA EMPRESA-->
                        <td width="35%">
                            <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"  style="font-size:12px">
                                <xsl:if test = "$imgEmpresa != ''">
                                <tr>
                                    <td width="300" height="65" valign="top" class="logoTop" >
                                        <img>
                                            <xsl:attribute name="src">
                                                <xsl:value-of select="$imgEmpresa"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="width">
                                                200px
                                            </xsl:attribute>
                                        </img>
                                    </td>            
                                </tr>
                                </xsl:if>
                                <tr><td align = "left"><strong><xsl:value-of select="cfdi:Emisor/@Nombre"/></strong></td></tr>
                                <tr><td align = "left"><strong>R.F.C. &#160; <xsl:value-of select="cfdi:Emisor/@Rfc"/></strong></td></tr>
                                <xsl:choose>
                                    <xsl:when test="$dirFiscalEmpresa = 1">
                                        <tr><td align = "left"><strong><xsl:value-of select="cfdi:Emisor/@calle"/>&#160;
                                                                       <xsl:value-of select="cfdi:Emisor/@numExt"/>&#160;
                                                                       <xsl:value-of select="cfdi:Emisor/@numInt"/>
                                                                </strong></td></tr>
                                        <tr><td align = "left"><strong><xsl:value-of select="cfdi:Emisor/@colonia"/>&#160;
                                                                       <xsl:value-of select="cfdi:Emisor/@localidad"/>
                                                                </strong></td></tr>
                                        <tr><td align = "left"><strong><xsl:value-of select="cfdi:Emisor/@delegacion"/></strong></td></tr>
                                        <xsl:if test = "$referenciaEmpresa != 'ND'"> 
                                            <tr><td align = "left"><strong><xsl:value-of select="cfdi:Emisor/@referencia"/> </strong></td></tr>
                                        </xsl:if>
                                        <tr><td align = "left"><strong>C.P. <xsl:value-of select="cfdi:Emisor/@codigoPostal"/>&#160;
                                                                       <xsl:value-of select="cfdi:Emisor/@estado"/>&#160;
                                                                       <xsl:value-of select="cfdi:Emisor/@pais"/>
                                                                </strong></td></tr>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <tr><td align = "left"><strong><xsl:value-of select="cfdi:Emisor/@direccion1"/></strong></td></tr>
                                        <tr><td align = "left"><strong><xsl:value-of select="cfdi:Emisor/@direccion2"/></strong></td></tr>  
                                        <tr><td align = "left"><strong>C.P. <xsl:value-of select="cfdi:Emisor/@codigoPostal"/>&#160;
                                                                            <xsl:value-of select="cfdi:Emisor/@estado"/>
                                                                </strong></td></tr>   
                                    </xsl:otherwise>
                                </xsl:choose>
                                <tr><td align = "left"><strong><xsl:value-of select="cfdi:Emisor/@nomRegFiscal"/></strong></td></tr>
                            </table>
                        </td>
                        <td width="35%">&#160;</td>
                        <!-- DATOS DE LA FACTURA -->
                        <td width="30%" align="right">
                            <table class="areaFiltro" style="font-size:12px; border:outset thin;" width="99%">
                                <tr>
                                    <td align = "left"><strong>Tipo de Comprobante:</strong></td>
                                    <td align = "right">
                                    <strong>
                                        <xsl:choose>
                                            <xsl:when test="@TipoDeComprobante = 'I'">
                                                Ingreso
                                            </xsl:when>
                                            <xsl:when test="@TipoDeComprobante = 'E'">
                                                Egreso
                                            </xsl:when>
                                            <xsl:when test="@TipoDeComprobante = 'T'">
                                                Traslado
                                            </xsl:when>
                                            <xsl:when test="@TipoDeComprobante = 'P'">
                                                Pago
                                            </xsl:when>
                                            <xsl:otherwise>
                                                UNKNOWN
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td align = "left"><strong>Serie y Folio:</strong></td>
                                    <td align = "right"><strong><xsl:value-of select="@Serie"/>&#160;
                                                                <xsl:value-of select="@Folio"/>
                                                        </strong></td>
                                </tr> 
                                <!--<tr>
                                    <td align = "left"><xsl:value-of select="contenidoDocumento/datosFactura/tipoDocumento/@value"/><strong></strong></td>
                                    <td align = "right"><strong><xsl:value-of select="contenidoDocumento/datosFactura/folio/@value"/></strong></td>
                                </tr>--> 
                                <tr>
                                    <td align = "left"><strong>No.Serie Certificado</strong></td>
                                    <td align = "right"><strong><xsl:value-of select="@NoCertificado"/></strong></td>
                                </tr>
                                <tr>
                                    <td align = "left"><strong>Fecha:</strong></td>
                                    <td align = "right"><strong><xsl:value-of select="@Fecha"/></strong></td>
                                </tr>
                                <tr>
                                    <td align="left"> <strong>Folio Fiscal </strong></td>
                                    <td align="right"> <strong><xsl:value-of select="@folioFiscal"/></strong></td>
                                </tr>
                                <tr>
                                    <td align="left" nowrap="nowrap"><strong>No Certificado SAT</strong></td>
                                    <td align="right"><strong><xsl:value-of select="cfdi:Complemento/tfd:TimbreFiscalDigital/@NoCertificadoSAT"/></strong></td>
                                </tr>
                                <tr>
                                    <td align="left"><strong>Fecha Timbrado</strong></td>
                                    <td align="right"><strong><xsl:value-of select="cfdi:Complemento/tfd:TimbreFiscalDigital/@FechaTimbrado"/></strong></td>
                                </tr>
                                <tr>
                                    <td align="left"><strong>Versi&#243;n</strong></td>
                                    <td align="right"><strong>4.0</strong></td>
                                </tr>
                            </table>
                        </td>
                        <td>&#160;</td>
                    </tr>
                </table>
                <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">
                    <tr><td>&#160;</td></tr>
                    <tr>
                        <td>
                            <!-- DATOS DEL CLIENTE -->
                            <table border="1" cellspacing="0" cellpadding="0"  width="100%" style="font-size:12px">
                                <tr>
                                    <td align = "left" width="15%"><strong>CLIENTE</strong></td>
                                    <td align = "left" width="85%" colspan="2"><strong><xsl:value-of select="cfdi:Receptor/@Nombre"/></strong></td>
                                </tr>
                                <tr>
                                    <td align = "left"><strong>DIRECCI&#211;N</strong></td>
                                    <xsl:choose>
                                        <xsl:when test="$dirFiscalCliente = 1">
                                            <td align = "left">
                                                <xsl:value-of select="cfdi:Receptor/@calle"/>&#160;
                                                <xsl:value-of select="cfdi:Receptor/@numExt"/>&#160;
                                                <xsl:value-of select="cfdi:Receptor/@numInt"/>
                                                <br/>  
                                                <xsl:value-of select="cfdi:Receptor/@colonia"/>&#160;
                                                <xsl:value-of select="cfdi:Receptor/@localidad"/>
                                                <br/>
                                                <xsl:value-of select="cfdi:Receptor/@delegacion"/>
                                                <br/>
                                                <xsl:if test = "$referenciaCliente != 'ND'"> 
                                                    <xsl:value-of select="cfdi:Receptor/@referencia"/>
                                                    <br/>
                                                </xsl:if>
                                                C.P. <xsl:value-of select="cfdi:Receptor/@codigoPostal"/>&#160;
                                                <xsl:value-of select="cfdi:Receptor/@estado"/>&#160;
                                                <xsl:value-of select="cfdi:Receptor/@pais"/>
                                            </td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td align = "left">
                                                <xsl:value-of select="cfdi:Receptor/@snDireccion"/>&#160;
                                                <xsl:value-of select="cfdi:Receptor/@snDireccion2"/>
                                                <br/>
                                                <xsl:value-of select="cfdi:Receptor/@dir"/>
                                            </td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </tr>
                                <tr>
                                    <td align = "left" width="15%"><strong>RFC</strong></td>
                                    <td align = "left" width="85%" colspan="2"><strong><xsl:value-of select="cfdi:Receptor/@Rfc"/></strong></td>
                                </tr>
                                <tr>
                                    <td align = "left" width="15%"><strong>Regimen Fiscal</strong></td>
                                    <td align = "left" width="85%" colspan="2"><strong><xsl:value-of select="cfdi:Receptor/@RegimenFiscal"/></strong></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&#160;</td></tr>
                </table>
                <!-- Datos del Complemento  INE -->
                <!--<table border="1" cellspacing="0" cellpadding="0"  width="100%" style="font-size:10px">
                    
                </table>-->
                <!-- Datos de Froma de Pago,  tipo de Pago , moneda y tipo de cambio -->
                <br/>
                <table border="1" cellspacing="0" cellpadding="0"  width="100%" style="font-size:10px">
                    <tr>
                        <td align = "center" width="25%" >
                        <strong>
                            <xsl:value-of select="@metodoDePagoFac"/>
                        </strong>
                        </td>
                        <td align = "center" width="25%" ><strong>Forma de Pago</strong></td>
                        <td align = "center" width="25%" ><strong>Moneda</strong></td>
                        <td align = "center" width="25%" ><strong>Tipo de Cambio </strong></td>
                    </tr>
                    <tr>
                        <td align = "center" width="20%" ><strong>USO: <xsl:value-of select="@cuentaTipoPagoFac"/></strong></td>
                        <td align = "center" width="20%" ><strong><xsl:value-of select="@formaDePagoFac"/></strong></td>
                        <td align = "center" width="20%" ><strong><xsl:value-of select="@tipoMonedaFac"/></strong></td>
                        <td align = "center" width="15%" ><strong><xsl:value-of select="@tipoCambioFac"/></strong></td>
                    </tr>
                </table>
                <!-- DETALLES DE LA FACTURA -->
                <table border="1" cellspacing="0" cellpadding="2" style="font-size:12px;" width="851px">
                    <tr>
                        <td align = "center" width="8%"><strong>Cantidad</strong></td>
                        <td align = "center" width="8%"><strong>Clave Unidad de Medida</strong></td>
                        <td align = "center" width="9%"><strong>Unidad de Medida</strong></td>
                        <td align = "center" width="9%"><strong>Clave de Servicio/Producto</strong></td>
                        <td align = "center" width="30%"><strong>Descripci&#243;n</strong></td>
                        <td align = "center" width="9%"><strong>Precio Unitario</strong></td>
                        <td align = "center" width="9%"><strong>Importe</strong></td>
                        <td align = "center" width="8%"><strong>Descuento</strong></td>
                        <td align = "center" width="10%"><strong>Objeto Impuesto</strong></td>
                    </tr>
                    <xsl:for-each select = "//cfdi:Conceptos/cfdi:Concepto">
                        <tr>
                            <td align = "center" style = "padding-right : 5px;"><xsl:value-of select = "@Cantidad"/></td>
                            <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "@ClaveUnidad"/></td>
                            <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "@Unidad"/></td>
                            <td align = "left" style = "border-left : 1px solid black;"><xsl:value-of select = "@ClaveProdServ"/></td>
                            
                            <!-- Código para dividir la descripcion -->
                                <xsl:variable name="descripcion" select="@Descripcion" />
                                <xsl:variable name="valueLength" select="string-length($descripcion)" />

                                <xsl:choose>
                                    <xsl:when test="$valueLength &gt; 37">
                                        <xsl:variable name="string1" select="substring ($descripcion ,0, 37 )"/>
                                        <xsl:variable name="string2" select="substring ($descripcion ,37, $valueLength)"/>
                                                <td align = "left" style = "border-left : 1px solid black;">
                                                    <xsl:value-of select = "$string1"/>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select = "$string2"/>
                                                </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                         <td align = "left" style = "border-left : 1px solid black;"><xsl:value-of select = "$descripcion"/></td>
                                    </xsl:otherwise>
                                </xsl:choose>
                            <!-- Código para dividir la descripcion-->
                            <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "format-number(@ValorUnitario, '###,###.00')"/></td>
                            <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "format-number(@Importe, '###,###.00')"/></td>
                            <xsl:choose>
                                <xsl:when test="@Descuento > 0">
                                    <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "format-number(@Descuento, '###,###.00')"/></td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "0.00"/></td>
                                </xsl:otherwise>
                            </xsl:choose>

                            <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "@ObjetoImp"/></td>
                           <!--<xsl:if test="@ObjetoImp='02'">
                                <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "Aplica"/></td>
                            </xsl:if>--> 
                            
                            
                            
                        </tr>
                    </xsl:for-each>
                </table>
                <br/>
                <!-- CANTIDADES -->
                <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" style="font-size:13px" width="100%">
                    <tr>
                        <td align = "left" width = "70%"><strong>Cantidad</strong></td>
                        <td align = "left" width = "15%"><strong>SUBTOTAL</strong></td>
                        <td align = "right" width = "15%">
                            <xsl:value-of select="format-number(@SubTotal, '###,##0.00')"/>
                        </td>
                    </tr>
                    <tr>
                        <td align = "left" width = "70%"><xsl:value-of select="@montoEnLetras"/></td>
                        <td colspan = "2">
                            <table border = "1" cellspacing="0" width = "100%"  style="font-size:13px">
                                <xsl:if test = "@descuentosFac > 0">
                                    <tr>
                                        <td width = "50%">Descuento</td>
                                        <td width = "50%" align = "right"><xsl:value-of select="format-number(@descuentosFac, '###,##0.00')"/></td>
                                    </tr>
                                </xsl:if>
                                <xsl:for-each select = "datosImpuesto/imp">
                                <xsl:if test = "@Clave != ''">
                                    <tr>
                                        <td width = "50%"><xsl:value-of select="@Clave"/>|<xsl:value-of select="@Nombre"/></td>
                                        <td width = "50%" align = "right"><xsl:value-of select="format-number(@Monto, '###,##0.00')"/></td>
                                    </tr>
                                </xsl:if>
                                </xsl:for-each>

                                <!--Prueba de Quitar Retencion si es igual a "Sin Retenciones en Pantalla "-->
                                <!--Entonces el campo generando el PDF se ocultara, de lo contrario se mostrara el valor.-->
                                <xsl:if test = "@retencion > 0">
                                <tr>
                                    <td width = "50%">Retenci&#243;n</td>
                                    <td width = "50%" align = "right"><xsl:value-of select="format-number(@retencion, '###,##0.00')"/></td>
                                </tr>
                                </xsl:if>
                               
                                <tr>
                                    <td width = "50%">TOTAL</td>
                                    <td width = "50%" align = "right"><xsl:value-of select="format-number(@Total, '###,##0.00')"/></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan = "3" align = "left" width = "100%"><xsl:value-of select="@observaciones"/></td>
                    </tr>
                </table>
                <br/>

                <xsl:choose>
                 <xsl:when test="/cfdi:Comprobante/cfdi:CfdiRelacionados">
                    <table border="1" cellspacing="0" cellpadding="2" style="font-size:12px;" width="40%">
                        <tr>
                            <td align = "left" width="25%"><strong>CFDI RELACIONADOS</strong></td>
                        </tr>
                    </table>
                    <table border="1" cellspacing="0" cellpadding="2" style="font-size:12px;" width="40%">          
                    <tr>
                        <td align = "left" width="25%"><strong>Tipo Relaci&#243;n</strong></td>
                         <xsl:for-each select = "//cfdi:CfdiRelacionados">
                            <td align = "left" style = "padding-right : 5px;"><xsl:value-of select = "@TipoRelacion"/></td>
                        </xsl:for-each>
                    </tr> 
                    <tr>
                        <td align = "left" width="25%"><strong>UUID</strong></td>
                        <xsl:for-each select = "//cfdi:CfdiRelacionados/cfdi:CfdiRelacionado">
                            <td align = "left" style = "padding-right : 5px;"><xsl:value-of select = "@UUID"/></td>
                        </xsl:for-each>
                    </tr>
                </table>
                 </xsl:when>
                 <xsl:otherwise>
                 
                 </xsl:otherwise>
                </xsl:choose>
                


            </table>
        </body>
        </html>
    </xsl:template>
</xsl:transform>