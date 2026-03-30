<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cfdi="http://www.sat.gob.mx/cfd/4" 
    xmlns:tfd="http://www.sat.gob.mx/TimbreFiscalDigital"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:sanofi="https://mexico.sanofi.com/schemas"
    xsi:schemaLocation="http://www.sat.gob.mx/cfd/4 http://www.sat.gob.mx/sitio_internet/cfd/4/cfdv40.xsd">
	<xsl:output method="html" indent="yes"/>
    
    <xsl:param name="imgEmpresa"/>
    <xsl:param name="imgQR"/>
    <xsl:param name="SNidentificacion2"/>
    <xsl:param name="NumOrdenCompra"/>

    <xsl:template match="/cfdi:Comprobante">
        <xsl:variable name="dirFiscalEmpresa" select="cfdi:Emisor/@dirFiscal"/>
        <xsl:variable name="dirFiscalCliente" select="cfdi:Receptor/@dirFiscal"/>
        
        <html>
        <body>

            <table border = "0">
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td width="250" height="65" valign="top" align = "left">
                            <img style="width: auto; height: 95px;">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$imgEmpresa"/>
                                </xsl:attribute>
                            </img>
                        </td>
                        <td>&#160;&#160;&#160;</td>
                        <td style = "font-size : 20px;" valign = "bottom">
                            <span style="font-weight:900;">
                                <xsl:choose>
                                    <xsl:when test="@tipoDocumentoCodigo = 'FC'">
                                        FACTURA
                                    </xsl:when>
                                    <xsl:when test="@tipoDocumentoCodigo = 'NC'">
                                        NOTA DE CREDITO
                                    </xsl:when>
                                    <xsl:otherwise>
                                        UNKNOWN
                                    </xsl:otherwise>
                                </xsl:choose>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <!-- DATOS DE LA EMPRESA-->
                        <td valign="bottom">
                            <table style = "font-size : 10px;">
                                <tr>
                                    <td style = "font-size:14px;font-weight:900;"><xsl:value-of select="cfdi:Emisor/@Nombre"/></td>
                                </tr>
                                <tr>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="$dirFiscalEmpresa = 1">
                                                <xsl:value-of select="cfdi:Emisor/@calle"/>&#160;
                                                <span style="font-weight:900;position:relative;bottom:1px;">No.</span>&#160;<xsl:value-of select="cfdi:Emisor/@noExterior"/>&#160;
                                                <span style="font-weight:900;position:relative;bottom:1px;">INT.</span>&#160;<xsl:value-of select="cfdi:Emisor/@noInterior"/>&#160;
                                                <span style="font-weight:900;position:relative;bottom:1px;">COL.</span>&#160;<xsl:value-of select="cfdi:Emisor/@colonia"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="cfdi:Emisor/@direccion1"/>&#160;
                                                <xsl:value-of select="cfdi:Emisor/@direccion2"/>&#160;
                                                <xsl:value-of select="cfdi:Emisor/@estado"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <xsl:if test = "$dirFiscalEmpresa = 1">
                                            <span style="font-weight:900;position:relative;bottom:1px;">DELG.:</span><xsl:value-of select="cfdi:Emisor/@delegacion"/>&#160;
                                        </xsl:if>
                                        <span style="font-weight:900;position:relative;bottom:1px;">C.P.:</span> <xsl:value-of select="cfdi:Emisor/@codigoPostal"/>
                                    </td>
                                    <td align = "right" style = "width:100px;">
                                        <span style="font-weight:900;">No. PROVEEDOR:</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <xsl:if test = "$dirFiscalEmpresa = 1">
                                            <xsl:value-of select="cfdi:Emisor/@localidad"/>
                                        </xsl:if>
                                    </td>
                                    <td align = "center" style = "width:120px;">
                                        <!-- Numero proveedor-->
                                        <xsl:choose>
                                            <xsl:when test="cfdi:Addenda/ASONIOSCOC/@noProveedor != ''">
                                                <xsl:value-of select="cfdi:Addenda/ASONIOSCOC/@noProveedor"/>
                                            </xsl:when>
                                            <xsl:when test="cfdi:Addenda/sanofi:sanofi/sanofi:Documento/sanofi:header/sanofi:NUM_PROVEEDOR != ''">
                                                <xsl:value-of select="cfdi:Addenda/sanofi:sanofi/sanofi:Documento/sanofi:header/sanofi:NUM_PROVEEDOR"/>
                                            </xsl:when>
                                            <xsl:when test="$SNidentificacion2 != ''">
                                                <xsl:value-of select="$SNidentificacion2"/>
                                            </xsl:when>
                                            <xsl:otherwise>
												No definido
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td><xsl:value-of select="cfdi:Emisor/@Rfc"/></td>
                                </tr>
                                <tr>
                                    <td><span style="font-weight:900;position:relative;bottom:1px;">LUGAR DE EXPEDICION:</span>&#160;<xsl:value-of select="@LugarExpedicion"/></td>
                                </tr>
                                <tr>
                                    <td><span style="font-weight:900;position:relative;bottom:1px;">REGIMEN FISCAL:</span>&#160;<xsl:value-of select="cfdi:Emisor/@nomRegFiscal"/></td>
                                </tr>
                            </table>
                        </td>
                        <td>&#160;&#160;&#160;</td>
                        <!-- DATOS DE LA FACTURA-->
                        <td>
                            <table style = "font-size : 10px;">
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">SERIE:</span>&#160;<xsl:value-of select="@Serie"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">FOLIO:</span>&#160;<xsl:value-of select="@Folio"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">FECHA y HORA:</span>&#160;<xsl:value-of select="@Fecha"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">TIPO DE COMPROBANTE:</span>&#160;
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
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">NUMERO DE CERTIFICADO:</span>&#160;<xsl:value-of select="@NoCertificado"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">METODO DE PAGO:</span>&#160;<xsl:value-of select="@MetodoPago"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">FORMA DE PAGO:</span>&#160;<xsl:value-of select="@FormaPago"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">No. CUENTA PAGO : </span>&#160;<xsl:value-of select="@NumCtaPago"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight:900;position:relative;bottom:1px;">VERSI&#211;N : </span>&#160;4.0
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <!-- DATOS DEL CLIENTE Y DETALLES DE FACTURA-->
                        <td width="100%" colspan = "4">
                            <table width="100%" style = "border:1px solid black; font-size : 10px;" cellspacing = "0" cellpadding = "0">
                                <tr>
                                    <td align = "center" 
                                        style = "padding : 0px; background-color : #d80000; color : white; font-size : 15px;">
                                        DATOS DE CLIENTE
                                    </td>
                                </tr>
                                <tr>
                                    <td width="100%">
                                        <table width="100%" style = "font-size : 10px;">
                                            <tr>
                                                <td align = "left" colspan = "2">
                                                    <span style="font-weight:900;position:relative;bottom:1px;"><xsl:value-of select="cfdi:Receptor/@Nombre"/></span>
                                                </td>
                                                <td align = "right" colspan = "2" width = "300px">
                                                    <span style="font-weight:900;position:relative;bottom:1px;">No. O. C.</span>&#160;
                                                    <xsl:choose>
                                                        <xsl:when test="cfdi:Addenda/ASONIOSCOC/@ordenCompra != ''">
                                                            <xsl:value-of select="cfdi:Addenda/ASONIOSCOC/@ordenCompra"/>
                                                        </xsl:when>
                                                        <xsl:when test="cfdi:Addenda/sanofi:sanofi/sanofi:Documento/sanofi:header/sanofi:NUM_ORDEN != ''">
                                                            <xsl:value-of select="cfdi:Addenda/sanofi:sanofi/sanofi:Documento/sanofi:header/sanofi:NUM_ORDEN"/>
                                                        </xsl:when>
                                                        <xsl:when test="$NumOrdenCompra != ''">
                                                            <xsl:value-of select="$NumOrdenCompra"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            No definido
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="cfdi:Receptor/@Rfc"/>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td>
                                                    <xsl:choose>
                                                        <xsl:when test="$dirFiscalCliente = 1">
                                                            <xsl:value-of select="cfdi:Receptor/@calle"/>&#160;&#160;&#160;
                                                            <span style="font-weight:900;position:relative;bottom:1px;">No.</span>&#160;<xsl:value-of select="cfdi:Receptor/@noExterior"/>&#160;&#160;&#160;
                                                            <span style="font-weight:900;position:relative;bottom:1px;">INT.</span>&#160;<xsl:value-of select="cfdi:Receptor/@noInterior"/>&#160;&#160;&#160;
                                                            <xsl:value-of select="cfdi:Receptor/@colonia"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="cfdi:Receptor/@snDireccion"/>&#160;
                                                            <xsl:value-of select="cfdi:Receptor/@snDireccion2"/>&#160;
                                                            <xsl:value-of select="cfdi:Receptor/@dir"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <xsl:if test = "$dirFiscalCliente = 1">
                                                        <span style="font-weight:900;position:relative;bottom:1px;">DEL.</span>&#160;<xsl:value-of select="cfdi:Receptor/@delegacion"/>
                                                    </xsl:if>
                                                </td>
                                            </tr>
                                            <tr> 
                                                <td>
                                                    <xsl:if test = "$dirFiscalCliente = 1">
                                                        <xsl:value-of select="cfdi:Receptor/@pais"/>&#160;
                                                        <xsl:value-of select="cfdi:Receptor/@localidad"/>&#160;
                                                        <span style="font-weight:900;position:relative;bottom:1px;">C.P.</span>&#160; <xsl:value-of select="cfdi:Receptor/@codigoPostal"/>&#160;
                                                    </xsl:if>
                                                    <span style="font-weight:900;position:relative;bottom:1px;">USO CFDI:</span> <xsl:value-of select="@cuentaTipoPagoFacDesc"/>
                                                </td>
                                                <td>
                                                    <span style="font-weight:900;position:relative;bottom:1px;">REGIMEN FISCAL:</span> <xsl:value-of select="cfdi:Receptor/@RegimenFiscal"/>
                                               </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="100%">
                                        <table width="100%" style = "font-size : 10px;" cellspacing = "0" cellpadding = "2">
                                            <tr style = "background-color : #d80000; color : white; font-size : 12px;">
                                                <td align = "center" style = "border-left : 1px solid black;border-bottom : 1px solid black;border-top : 1px solid black;">CANTIDAD</td>
                                                <td align = "center" style = "border-left : 1px solid black;border-bottom : 1px solid black;border-top : 1px solid black;">UNIDAD</td>
                                                <td align = "center" style = "border-left : 1px solid black;border-bottom : 1px solid black;border-top : 1px solid black;">CLAVE</td>
                                                <td align = "center" style = "border-left : 1px solid black;border-bottom : 1px solid black;border-top : 1px solid black;">Concepto</td>
                                                <td align = "center" style = "border-left : 1px solid black;border-bottom : 1px solid black;border-top : 1px solid black;">PRECIO UNITARIO</td>
                                                <td align = "center" style = "border-left : 1px solid black;border-bottom : 1px solid black;border-top : 1px solid black;">IMPORTE</td>
                                                <td align = "center" style = "border-left : 1px solid black;border-bottom : 1px solid black;border-top : 1px solid black;">DESCUENTO</td>
                                                <td align = "center" style = "border-left : 1px solid black;border-bottom : 1px solid black;border-top : 1px solid black;">OBJETO IMPUESTO</td>
                                            </tr>
                                            <xsl:for-each select = "//cfdi:Conceptos/cfdi:Concepto">
                                                <tr>
                                                    <td align = "right" style = "padding-right : 5px;"><xsl:value-of select = "@Cantidad"/></td>
                                                    <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "@Unidad"/></td>
                                                    <td align = "center" style = "border-left : 1px solid black;"><xsl:value-of select = "@ClaveProdServ"/></td>
                                                    <td align = "left" style = "border-left : 1px solid black;"><xsl:value-of select = "@Descripcion"/></td>
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
                                                    
                                                </tr>
                                               
                                            </xsl:for-each>
                                            <tr>
                                                <td style = "border-top : 1px solid black; padding-bottom : 50px;" colspan = "8">
                                                    <p>
                                                        <xsl:value-of select="@observaciones"/>
                                                    </p>
                                                </td>
                                            </tr>
                                        </table>
                                         
                                    </td>
                                </tr>
                            </table>
                            
                            <table width="100%" style="font-size : 10px;" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4">
                            
                                        <table>
                                            <tr>
                                                <td>
                                                    <img alt = "CodigoQR.net">
                                                        <xsl:attribute name="src">
                                                            <xsl:value-of select="$imgQR"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="width">
                                                            133px
                                                        </xsl:attribute>
                                                        <xsl:attribute name="height">
                                                            133px
                                                        </xsl:attribute>
                                                    </img>
                                                </td>
                                                <td valign = "top">
                                                    <xsl:choose>
                                                        <xsl:when test="/cfdi:Comprobante/cfdi:CfdiRelacionados">
                                                            <table border="1" cellspacing="0" cellpadding="2" style="font-size:12px;" width="91%">
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
                                                    <table style="font-size : 10px;">
                                                        
                                                        <tr><td><span style="font-weight:900;">FOLIO FISCAL :</span></td></tr>
                                                        <tr><td><xsl:value-of select="cfdi:Complemento/tfd:TimbreFiscalDigital/@UUID"/></td></tr>
                                                        <tr><td><span style="font-weight:900;"><br/>FECHA Y HORA DE CERTIFICACION :</span></td></tr>
                                                        <tr><td><xsl:value-of select="cfdi:Complemento/tfd:TimbreFiscalDigital/@FechaTimbrado"/></td></tr>
                                                        <tr><td>**** <xsl:value-of select="@montoEnLetras"/> ****</td></tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" colspan="3" valign = "top">
                                        <table cellspacing="0" cellpadding="0" style="font-size : 10px;">
                                            <tr>
                                                <td style = "padding : 10px 30px 10px 10px; text-align : left; border-left : 1px solid black;border-bottom : 1px solid black;">SUB-TOTAL</td>
                                                <td style = "padding : 10px 10px 10px 50px; text-align : right; border-left : 1px solid black;border-right : 1px solid black;border-bottom : 1px solid black;">
                                                    <xsl:value-of select="format-number(@SubTotal, '###,###.00')"/>
                                                </td>
                                           </tr>
                                           <xsl:if test = "@descuentosFac > 0">
                                               <tr>
                                                    <td style = "padding : 10px 30px 10px 10px; border-left : 1px solid black;border-bottom : 1px solid black;">DESCUENTO</td>
                                                    <td style = "padding : 10px 10px 10px 50px; border-left : 1px solid black;border-right : 1px solid black;border-bottom : 1px solid black;">
                                                        <xsl:value-of select="format-number(@descuentosFac, '###,###.00')"/>
                                                    </td>
                                                </tr>
                                           </xsl:if>
                                           <xsl:if test = "@iepsFac > 0">
                                               <tr>
                                                    <td style = "padding : 10px 30px 10px 10px; border-left : 1px solid black;border-bottom : 1px solid black;">IEPS</td>
                                                    <td style = "padding : 10px 10px 10px 50px; border-left : 1px solid black;border-right : 1px solid black;border-bottom : 1px solid black;">
                                                        <xsl:value-of select="format-number(@iepsFac, '###,###.00')"/>
                                                    </td>
                                                </tr>
                                           </xsl:if>
                                            <tr>
                                                <td style = "padding : 10px 30px 10px 10px; border-left : 1px solid black;border-bottom : 1px solid black;">IVA 16 %</td>
                                                <td style = "padding : 10px 10px 10px 50px; border-left : 1px solid black;border-right : 1px solid black;border-bottom : 1px solid black;">
                                                   <!-- <xsl:value-of select="format-number(cfdi:Impuestos/@TotalImpuestosTrasladados, '###,###.00')"/>-->
                                                    <xsl:value-of select="format-number(@TotalIVA, '###,###.00')"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style = "padding : 10px 30px 10px 10px; border-left : 1px solid black;border-bottom : 1px solid black;">Retenci&#243;n</td>
                                                <td style = "padding : 10px 10px 10px 50px; border-left : 1px solid black;border-right : 1px solid black;border-bottom : 1px solid black;">
                                                    <xsl:value-of select="format-number(@retencion, '###,###.00')"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style = "padding : 10px 30px 10px 10px; border-left : 1px solid black;border-bottom : 1px solid black;">TOTAL</td>
                                                <td style = "padding : 10px 10px 10px 50px; border-left : 1px solid black;border-right : 1px solid black;border-bottom : 1px solid black;">
                                                    <xsl:value-of select="format-number(@Total, '###,###.00')"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>            
                            </table>
                        </td>
                    </tr>
                </table>
            </table>

        </body>
        </html>
    </xsl:template>
</xsl:transform>