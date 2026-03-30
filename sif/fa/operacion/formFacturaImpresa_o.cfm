<cfprocessingdirective pageencoding="UTF-8">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<body>

  <cfoutput>
        <cfif not isdefined("btnDownload")>  
            <cf_templatecss>
        </cfif>         
    </cfoutput>
    
        
    <cfquery name="rsDatosEmpresa" datasource="asp">
		select distinct  m.Enombre,d.direccion1,d.direccion2,ciudad,estado,codPostal 
		from CuentaEmpresarial e, Direcciones d,Empresa m		
		where m.id_direccion = d.id_direccion	
		and e.CEcodigo=m.CEcodigo	
		and m.Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
  <cfquery name="rsRFCEmpresa" datasource="#session.DSN#">
    select EIdentificacion from Empresas
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  </cfquery>
    
  <cfquery name="rsDatosfac" datasource="#session.DSN#">
    SELECT distinct SNnombre, case substring(SNidentificacion,1,9) 
      when 'EXT010101' then 'XEXX010101000'
            else SNidentificacion
            end as SNidentificacion, d.direccion1 as SNdireccion, d.direccion2 as SNdireccion2,
        OItotal, OIieps, OItotal as OItotalLetras, OIimpuesto, OIdescuento, 
                OItotal + OIdescuento - OIimpuesto - OIieps as OIsubtotal,
        ltrim(rtrim(convert(char,OIfecha,102)))+' '+convert(char,OIfecha,108) as OIfecha,
                substring(convert(char, OIfecha, 112),7,2)+'/'+
          case  
        when substring(convert(char, OIfecha, 112),5,2) = '01' then 'Ene'
        when substring(convert(char, OIfecha, 112),5,2) = '02' then 'Feb'
        when substring(convert(char, OIfecha, 112),5,2) = '03' then 'Mar'
        when substring(convert(char, OIfecha, 112),5,2) = '04' then 'Abr'                
        when substring(convert(char, OIfecha, 112),5,2) = '05' then 'May'
        when substring(convert(char, OIfecha, 112),5,2) = '06' then 'Jun'
        when substring(convert(char, OIfecha, 112),5,2) = '07' then 'Jul'
        when substring(convert(char, OIfecha, 112),5,2) = '08' then 'Ago'
        when substring(convert(char, OIfecha, 112),5,2) = '09' then 'Sep'
        when substring(convert(char, OIfecha, 112),5,2) = '10' then 'Oct'
        when substring(convert(char, OIfecha, 112),5,2) = '11' then 'Nov'
        when substring(convert(char, OIfecha, 112),5,2) = '12' then 'Dic'
          end+'/'+
      substring(convert(char, OIfecha, 112),1,4)+' '+
      substring(convert(varchar,OIfecha,114),1,8) as fecfac,

				LTRIM(RTRIM(OIDdescripcion)) as OIDdescripcion, LTRIM(RTRIM(upper(OIDdescnalterna))) as OIDdescnalterna , 
				OIDCantidad,OIDtotal,OIDPrecioUni,  OIObservacion,Observaciones,
				OIDdescuento, OIdiasvencimiento,m.Miso4217,f.PFTcodigo,pft.PFTtipo,
				OIvencimiento,'C.P.'+codPostal +', '+ciudad+','+estado as dir,
				a.OImpresionID as NUMERODOC,SNemail,
                ltrim(rtrim(seriefacele)) as serie, ltrim(rtrim(foliofacele)) as fac1,  CCTcodigo,
				case CCTcodigo
				when  'FA' then
		                'FE_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele))  
				when  'FC' then
				'FE_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele))  
				when  'ND' then
				'ND_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) 
				when  'NC' then
				'NC_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) 
				end as fac,
				ltrim(rtrim(numcerfacele)) AS numcerfacele,
                anoaprofacele,NUMaprofacele,
                ltrim(rtrim(cadorifacele)) as cadena,ltrim(rtrim(fe.SelloDigital)) as sello,
                TP.nombre_TipoPago, RF.nombre_RegFiscal,m.Mnombre,OItipoCambio, Cta_tipoPago,OIDetalle,Udescripcion,
                fe.timbre, fe.selloSAT, fe.certificadoSAT, fe.cadenaSAT, fe.fechaTimbrado 
        FROM FAEOrdenImpresion a   
          inner join FADOrdenImpresion b
                on a.OImpresionID = b.OImpresionID
                and a.Ecodigo = b.Ecodigo
          INNER JOIN SNegocios c
                on a.SNcodigo = c.SNcodigo
                and a.Ecodigo = c.Ecodigo
          LEFT JOIN  DireccionesSIF d
                on a.id_direccionFact = d.id_direccion
          LEFT JOIN  Monedas m
                on a.Mcodigo = m.Mcodigo
          INNER JOIN FAPreFacturaE f
                on a.OImpresionID = f.oidocumento
                and a.Ecodigo = f.Ecodigo
          INNER JOIN FAPFTransacciones pft
                on f.Ecodigo = pft.Ecodigo
                and f.PFTcodigo = pft.PFTcodigo
          INNER JOIN FAPreFacturaD pfd on f.Ecodigo=pfd.Ecodigo 
                and f.IDpreFactura=pfd.IDpreFactura
          INNER JOIN Conceptos con on pfd.Ecodigo =con.Ecodigo 
                and con.Cid=pfd.Cid
          INNER JOIN Unidades u on u.Ecodigo=con.Ecodigo 
                and con.Ucodigo= u.Ucodigo 
          LEFT JOIN FATipoPago TP 
                on TP.Ecodigo = a.Ecodigo and TP.codigo_TipoPago = a.codigo_TipoPago
          LEFT JOIN FARegFiscal RF 
                on RF.Ecodigo = a.Ecodigo and RF.codigo_RegFiscal = a.codigo_RegFiscal
           inner join FA_CFDI_Emitido fe
                on a.Ecodigo = fe.Ecodigo and a.OImpresionID =fe.OImpresionID
				WHERE a.OImpresionID =  #OImpresionID# and a.Ecodigo=#session.Ecodigo#
                and fe.stsTimbre=1
                order by OIDetalle
</cfquery>
<cfquery name="qr" datasource="#session.DSN#">
    SELECT codigoQR from 
  FAPreFacturaE f inner join FA_CFDI_Emitido fe
  on fe.Serie=f.seriefacele and fe.Folio=f.foliofacele
  WHERE f.oidocumento = #OImpresionID# and fe.Ecodigo=#session.Ecodigo#
</cfquery>
<!--- <cf_dump var=#qr.codigoQR#> --->
<cfquery name="logo" datasource="#session.DSN#">
  Select Elogo From Empresa where Ereferencia = #Session.Ecodigo#
</cfquery>
<!---<cf_dump var="#rsDatosfac#">--->
<!--- Validacion y creacion de carpetar para almacenar Facturas --->
  <cf_foldersFacturacion>
<cfdocument format="PDF" filename="c:/enviar/#Session.FileCEmpresa#/#Session.Ecodigo#/#rsDatosfac.fac#.pdf" overwrite="true">  
<cfoutput>
    <!--- Datos de la empresa spacer.gif--->
     <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%" >
          <tr>
              <td width="35%">
                  <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"  style="font-size:12px">
                       <tr>
                          <td width="300" height="85" valign="top" class="logoTop" >
        <cfimage action="writeToBrowser" source="#logo.Elogo#" width="100%" height="100%">
        </td>
                                        
                       </tr>
                       <tr><td align = "left"><strong>#Trim(rsDatosEmpresa.Enombre)#</strong></td></tr>
                       <tr><td align = "left"><strong>#Trim(rsDatosEmpresa.direccion1)#</strong></td></tr>
                       <tr><td align = "left"><strong>#Trim(rsDatosEmpresa.direccion2)# C.P. #rsDatosEmpresa.codpostal#</strong></td></tr>
                       <tr><td align = "left"><strong>#Trim(rsDatosEmpresa.ciudad)# #Trim(rsDatosEmpresa.Estado)#</strong></td></tr>
                       <tr><td align = "left"><strong>R.F.C. #Trim(rsRFCEmpresa.Eidentificacion)#</strong></td></tr>
                       <tr><td align = "left"><strong>#rsDatosfac.nombre_RegFiscal#</strong></td></tr>
                                   
                  </table>
              </td>
              <td width="30%">
                    <table style="border:outset thin" class="areaFiltro" style="font-size:12px" width="99%" >
                      <tr >
                            <td align = "left" ><strong>Serie:</strong></td>
                            <td align = "right" ><strong>#rsDatosfac.serie#</strong></td>
                        </tr> 
                        <tr>
                            <cfif #rsDatosfac.CCTcodigo# EQ "FA">
                                <td align = "left" ><strong>Factura</strong></td>
                            <cfelseif #rsDatosfac.CCTcodigo# EQ "FC">
                                <td align = "left" ><strong>Factura</strong></td>    
                            <cfelseif #rsDatosfac.CCTcodigo# EQ "ND">
                                <td align = "left" ><strong>Nota de Débito</strong></td>
                            <cfelse>
                              <td align = "left" ><strong>Nota de Crédito</strong></td>    
                            </cfif>
                                <td align = "right" ><strong>#rsDatosfac.fac1#</strong></td>
                        </tr>
                        <tr >
                            <td align = "left" ><strong>No.Serie Certificado</strong></td>
                            <td align = "right" ><strong>#rsDatosfac.numcerfacele#</strong></td>
                        </tr>
                       
                        <tr >
                            <td align = "left" ><strong>Fecha:</strong></td>
                            <td align = "right" ><strong>#rsdatosfac.fecfac#</strong></td>
                        </tr>
                        <tr >
                          <td  align="left"> <strong>Folio Fiscal </strong></td>
                            <td align="right"> <strong>#rsdatosfac.timbre#</strong></td>
                        </tr>
                        <tr>
                          <td align="left" nowrap="nowrap"> <strong>No Certificado SAT</strong></td>
                            <td align="right"> <strong>#rsdatosfac.certificadoSAT#</strong></td>
                        </tr>
                        <tr>
                          <td align="left"> <strong>Fecha Timbrado</strong></td>
                            <td align="right"> <strong>#rsdatosfac.fechaTimbrado#</strong></td>
                        </tr>
                    </table>
              </td> 
                       
             <td width="25%">&nbsp;
                      
                 </td>
            </tr>
     </table>
    
     <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%" >
       <!--- <tr><td>&nbsp;</td></tr>--->
        <tr>
          <td>
              <table border="1" cellspacing="0" cellpadding="0"  width="99%" style="font-size:16px">
                    <tr>
                        <td  align = "left" width="15%"><strong>CLIENTE</strong></td>
                        <td align = "left" width="85%" colspan="2"><strong>#rsDatosfac.snnombre#</strong></td>
                    </tr>
                    <tr>
                    <td align = "left" width="15%"><strong>DIRECCI&Oacute;N</strong></td>
                      <td align = "left" width="85%"><strong>#Trim(rsDatosfac.sndireccion)# #Trim(rsDatosfac.SNdireccion2)# #Trim(rsDatosfac.dir)#</strong></td>
                  </tr>
                <tr>
                        <td  align = "left" width="15%"><strong>RFC</strong></td>
                        <td align = "left" width="85%" colspan="2"><strong>#rsdatosfac.snidentificacion#</strong></td>
                    </tr>
              </table>
            </td>
        </tr>
        <!---<tr><td>&nbsp;</td></tr>--->
        <tr><td>&nbsp;</td></tr>
        <tr>
          <td>
              <table border="1" cellspacing="0" cellpadding="2" class="areaFiltro"  style="font-size:14px" width="99%">
                  <!---Datos de Froma de Pago,  tipoi  de Pago , moneda y  tipo  de cambio --->
                    <tr>
                        <td align = "center" width="20%"  rowspan="2"><strong>Pago en una sola exhibici&oacute;n</strong></td>
                        <td align = "center" width="20%" ><strong>Metodo de Pago </strong></td>
                        <td align = "center" width="20%" ><strong>Cuenta</strong></td>
                        <td align = "center" width="20%" ><strong>Moneda</strong></td>
                        <td align = "center" width="15%"   ><strong>Tipo de Cambio </strong></td>
                  </tr>
                     <tr>
                        <td align = "center" width="20%" ><strong>#Trim(rsDatosfac.nombre_tipopago)#</strong></td>
                        <td align = "center" width="20%" ><strong>#Trim(rsDatosfac.Cta_tipoPago)#</strong></td>
                        <td align = "center" width="20%" ><strong>#Trim(rsDatosfac.Mnombre)#</strong></td>
                        <td align = "center" width="15%"   ><strong>#numberformat(rsDatosfac.OItipoCambio, ",9.00")#</strong></td>
                     </tr>  
                </table>  
            </td>
        </tr> 
        <!--- Datos del detalle de la factura class="areaFiltro"--->      
        <tr>
          <td>
                <table border="1" cellspacing="0" cellpadding="2" class="areaFiltro" font style="font-size:14px" width="99%">
                    <tr>
                        <td align = "center" width="12%"><strong>Cantidad</strong></td>
                        <td align = "center" width="12%"><strong>Unidad de Medida</strong></td>
                        <td align = "center" width="52%"><strong>Descripci&oacute;n</strong></td>
                        <td align = "center" width="12%"><strong>Precio Unitario</strong></td>
                        <td align = "center" width="12%"><strong>Importe</strong></td>
                    </tr>
                    <cfset Descuento=0>
                    <cfloop query="rsDatosfac">
                    <tr>
                        <td align = "center" ><strong>#OIDcantidad#</strong></font></td>
                        <cfif isdefined("Udescripcion") and len(trim(Udescripcion)) and Udescripcion NEQ "Unidad">
                            <td align = "center" ><strong>#Udescripcion#</strong></td>
                         <cfelse>   
                            <td align = "center" ><strong>No Aplica</strong></td> 
                      </cfif>                     
                        <td align = "left" ><strong>#OIDdescripcion#</strong></td>
                        <td align = "right"><strong>#numberformat(OIDpreciouni, ",9.00")#</strong></td>
                        <td align = "right"><strong>#numberformat((OIDcantidad * OIDpreciouni) , ",9.00")#</strong></td>
                    </tr>
                    <cfset DescuentoLin=#numberformat(rsdatosfac.OIDdescuento,"9.00")#>
                    <cfset Descuento=#numberformat((Descuento+DescuentoLin),"9.00")#>
                    </cfloop>                             
                </table>
          </td>
        </tr> 
        <tr><td>&nbsp;</td></tr>
        
        <!---<tr><td>&nbsp;</td></tr>  --->     
        <tr>
          <td>  
            <cfset total =  #numberformat(rsdatosfac.OItotal, "9.00")# >
              <table border="1" cellspacing="0" cellpadding="2" class="areaFiltro" font style="font-size:13px" width="99%">
                  <cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
                    <cfinvokeargument name="Monto" value="#total#">
                  </cfinvoke>
                     <cfquery name="monto" datasource="#session.dsn#">
                        select  substring ('#MontoLetras#',1,(LEN('#MontoLetras#')-11)) +' pesos '+right('#MontoLetras#',7) + ' M.N.' as montoL
                     </cfquery>
                  <tr>
            <td align = "left" colspan="2"><strong>Cantidad</strong></td>
                      <td align = "left" ><strong>SUBTOTAL</strong></td>
                        <cfif Descuento GT 0>
                          <cfset subtotal = rsdatosfac.OIsubtotal + Descuento>
                        <td align = "right"><strong>#numberformat(subtotal, ",9.00")#</strong></td>
                        <cfelse>
                          <td align = "right"><strong>#numberformat(rsdatosfac.OIsubtotal, ",9.00")#</strong></td>
                        </cfif>
                  </tr>
                          
                  <tr>
                      <td align="left" valign="top" colspan="2" rowspan="4"><strong>#MontoLetras# #rsDatosfac.mnombre#</strong></td>
                       <cfif Descuento GT 0> 
			<td align = "left"><strong>Descuento</strong></td>
                        <td align = "right"><strong>#numberformat(Descuento, ",9.00")#</strong></td>
			</cfif>

                    </tr>  
                    <cfif rsdatosfac.OIieps GT 0>
                      <td align = "left" ><strong>IEPS</strong></td>
                      <td align = "right"><strong>#numberformat(rsdatosfac.OIieps, ",9.00")#</strong></td>
                    </cfif>  
                    <tr>    
                        <td align = "left" ><strong>IVA</strong></td>
                      <td align = "right"><strong>#numberformat(rsdatosfac.oiimpuesto, ",9.00")#</strong></td>
                  </tr>
                  <tr>
                      <td align = "left" ><strong>TOTAL</strong></td>
                      <td align = "right"><strong>#numberformat(rsdatosfac.oitotal, ",9.00")#</strong></td>
                  </tr>
              </table>
          </td>
        </tr>
        <!---<tr><td>&nbsp;</td></tr>--->
        <tr>
          <td>
              <table border="1" cellspacing="0" cellpadding="2" class="areaFiltro" width="99%">
              <tr>
                  <td align = "left" style="font-size:14px"><strong>Observaciones: #rsdatosfac.observaciones# #rsdatosfac.OIObservacion# </strong></td>
              </tr> 
              </table>
          </td>
        </tr>
       
       <tr><td>&nbsp;</td></tr>
       <tr>
       <td>
        <table border="0"  width="99%" style="font-size:10px">
              <tr>
                <td width="77%">
                    <table border="0"  width="99%"  style="font-size:10px">
                          <tr>
                          <td >
                                  <strong>Cadena Original del complemento de certificaci&oacute;n digital del SAT</strong>
                                </td>
                          </tr>
                            <cfset renglon = 0>
              <cfset renglon_ini = 1>
                            <cfloop condition="renglon LE #LEN(rsdatosfac.cadenaSAT)#">
                            <cfset renglon = #renglon#+100>
                            <tr>                    
                                <td > <strong>#Mid(rsdatosfac.cadenaSAT,renglon_ini,100)#</strong></td>
                            </tr>
                            <cfset renglon_ini = #renglon#+1>
                            </cfloop>
                            <tr>
                              <td > <strong>Sello Digital del Emisor</strong></td>
                            </tr>
              <cfset renglon = 0>
                             <cfset renglon_ini = 1>
                             <cfloop condition="renglon LE #LEN(rsdatosfac.sello)#">
                                 <cfset renglon = #renglon#+100>
                             <tr>                   
                                <td > <strong>#Mid(rsdatosfac.sello,renglon_ini,100)#</strong></td>
                             </tr>
                                 <cfset renglon_ini = #renglon#+1>
                             </cfloop>
                          <tr>
                              <td> <strong>Sello Digital del SAT</strong></td>
                            </tr>
                            <cfset renglon = 0>
                            <cfset renglon_ini = 1>
                            <cfloop condition="renglon LE #LEN(rsdatosfac.selloSAT)#">
                            <cfset renglon = #renglon#+100>
                            <tr>                    
                               <td > <strong>#Mid(rsdatosfac.selloSAT,renglon_ini,100)#</strong></td>
                            </tr>
                            <cfset renglon_ini = #renglon#+1>
                            </cfloop>
                  </table>
                </td>                 
            </tr>
      </table>
    </td>
    </tr>
    <tr>
   <td width="21%" valign="top" class="logoTop" rowspan="4"  >
                       <!--- <img src="C:/enviar/imgQR/#rsDatosfac.fac#.jpg"  alt="CodigoQR.net" width="300" height="300" />--->
                      <cfimage action="writeToBrowser" source="C:/enviar/#Session.FileCEmpresa#/#Session.Ecodigo#/imgQR/#rsDatosfac.fac#.jpg" height=150 width=150>
                       <!---<img src="/cfmx/plantillas/soinasp01/images/imgQR/#rsDatosfac.fac#.jpg" alt="CodigoQR.net" width="200" height="200">--->
                  </td>
  </tr>
  </table>
        

         <tr><td>&nbsp;</td></tr>
         <cfset leyenda="Deb(emos) y pagar&eacute;(emos) incondicionalmente a favor de #Trim(rsDatosEmpresa.Enombre)#. La cantidad que ampara la siguiente factura en el domicilio se&ntilde;alado"> 
         <cfset leyenda1=" en los plazos y condiciones estipuladas en la misma. En caso contrario esta factura causara  __% de inter&eacute;s moratorio a su vencimiento.">                   
     <cfset leyenda2=" ESTE DOCUMENTO ES UNA REPRESENTACI&Oacute;N IMPRESA DE UN CFDI "> 
         <cfdocumentitem type="footer">
               <tr>
                  <td>
                      <table style="border:outset"  cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">              
                          <tr>
                               <td align="left"><font style="font-size:22px">#leyenda# </td>                           
                          </tr>    
                          <tr>
                               <td align="left"><font style="font-size:22px">#leyenda1# </td>                            
                          </tr>          
                          <tr>
                               <td align="left"> <font style="font-size:22px"> #leyenda2#               Pagina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</td>
                               <!--- <td align="right"> <font style="font-size:32px"> Pagina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount# </td>   --->
                          </tr>            
                       </table>
                  </td>
              </tr>
     </cfdocumentitem>                
    </table >

</cfoutput>
</cfdocument>


 <!---    Codigo para enviar mails               mimeattach="C:/enviar/#rsDatosfac.fac#.pdf"        CC="gpaz@mailcity.com"   Factura-#rsDatosfac.fac#.pdf,--->
            <!--- <cfset archivo = "C:/enviar/#rsDatosfac.fac#.xml"> --->           
      
  <!---<cfif #rsDatosfac.snemail# neq "">
      <CFMAIL TO="#rsDatosfac.snemail#"  CC="facturacionelectronica@clearchannel.com.mx"
       FROM="facturacionelectronica@soin.co.cr"
         type="text"
       SUBJECT="Factura Electronica #rsDatosfac.fac#">
       <cfmailparam file="C:\enviar\#rsDatosfac.fac#T.xml">
       <cfmailparam file="c:\enviar\#rsDatosfac.fac#.pdf">

        Se envio la Factura Electronica Num. Factura-#rsDatosfac.fac#
                
    </CFMAIL> 
  </cfif> 
                
<!---     fin del codigo de enviar mails --->

  <cfquery name="rsupdfac" datasource="#session.DSN#">
        update faprefacturae
        set enviamail =1        
        FROM FAEOrdenImpresion a, faprefacturae f
          where a.oidocumento = f.ddocumentoref
        and   a.OImpresionID =  #OImpresionID#
     </cfquery>  --->   
</body>
</html>
<!---<cfscript>
// CREATE DOCUMENT
document = CreateObject("java", "com.lowagie.text.Document");
document.init();
 
// WRITER
fileIO = CreateObject("java", "java.io.FileOutputStream");
fileIO.init("C:\enviar\#rsDatosfac.fac#.pdf");
writer = CreateObject("java", "com.lowagie.text.pdf.PdfWriter");

// PAGE EVENT HELPER 
pageEvent = createObject("java", "itextutil.MyPageEvent");

// SETTINGS USED FOR DYNAMIC FOOTER TEXT  
Color = createObject("java", "java.awt.Color");  
footerText = "Página ";
footerTextColor = Color.decode("##000000");  
footerFontSize = 6;

writer = CreateObject("java", "com.lowagie.text.pdf.PdfWriter");

// PAGE EVENT
pageEvent.init(footerText,javacast("float", footerFontSize),footerTextColor);

writer.getInstance(document, fileIO).setPageEvent( pageEvent );
document.open();

// CREATE REUSABLE OBJECT
Image = CreateObject("java", "com.lowagie.text.Image");
Paragraph = CreateObject("java", "com.lowagie.text.Paragraph");
PdfPCell = CreateObject("java", "com.lowagie.text.pdf.PdfPCell");
Color = CreateObject("java", "java.awt.Color");
PdfTable = CreateObject("java", "com.lowagie.text.pdf.PdfPTable");
Phrase = CreateObject("java", "com.lowagie.text.Phrase");
Chunk = CreateObject("java", "com.lowagie.text.Paragraph");
Element = CreateObject("java", "com.lowagie.text.Element");

// COMPANY LOGO
logo = Image.getInstance(#logo.Elogo#);
logo.scaleAbsolute(120,30);
logo.setDpi(300,300);

// QR
qr = Image.getInstance(#qr.codigoQR#);
qr.scaleAbsolute(120,120);
qr.setDpi(300,300);

// THE FONTS
FontFactory = Createobject("java", "com.lowagie.text.FontFactory");
Font = CreateObject("java", "com.lowagie.text.Font");
HelveticaLarge    = Font.init(Font.HELVETICA, 9.0);
HelveticaLargeB   = Font.init(Font.HELVETICA, 9.0, Font.BOLD);
HelveticaNormal   = Font.init(Font.HELVETICA, 8.0);
HelveticaNormalB  = Font.init(Font.HELVETICA, 8.0, Font.BOLD);
HelveticaSmall    = Font.init(Font.HELVETICA, 6.0);
//HelveticaSmallB  = Font.init(Font.HELVETICA, 6.0, Font.BOLD);
//////////////////////////////////////////////////////////////////////////////////////////////////

// DATOS EMPRESA
combParagraph = CreateObject("java", "com.lowagie.text.Paragraph");

paragraph.init(#rsDatosEmpresa.Enombre#, HelveticaLargeB);
combParagraph.add(paragraph);

paragraph.init(#rsRFCEmpresa.Eidentificacion#, HelveticaNormal);
combParagraph.add(paragraph);

paragraph.init(#rsDatosEmpresa.direccion1#, HelveticaNormal);
combParagraph.add(paragraph);

paragraph.init(#rsDatosEmpresa.direccion2#, HelveticaNormal);
combParagraph.add(paragraph);

paragraph.init("C.P. #rsDatosEmpresa.codpostal# #rsDatosEmpresa.ciudad# #rsDatosEmpresa.estado#", HelveticaNormal);
combParagraph.add(paragraph);

paragraph.init("Regimen: #rsdatosfac.nombre_RegFiscal#", HelveticaNormal);
combParagraph.add(paragraph);

// CREATE A TABLE HEADER
tableH = PdfTable.init( javacast("int", 4) );
tableH.setWidthPercentage(100);
tableH.setSpacingBefore(15);
tableH.setSpacingAfter(30);

// ADD SOME FORMATTED CELLS
// LOGO
logoEmpresa = PdfPCell.init( logo );
logoEmpresa.setBorder(0);
tableH.addCell( logoEmpresa );

// DATOS EMPRESA
datEmpresa = PdfPCell.init( combParagraph );
datEmpresa.setBorder(0);
datEmpresa.setHorizontalAlignment(Element.ALIGN_CENTER);
datEmpresa.setColspan( javacast("int", 2) );
//datEmpresa.setColspan( javacast("int", 2) );  
//cellColor = Color.init( javacast("int", 192), javacast("int", 192), javacast("int", 192) );  
//datEmpresa.setBackgroundColor( cellColor );  
tableH.addCell( datEmpresa );  
      
// none
empty = PdfPCell.init( Paragraph.init(" ") );
empty.setBorder(0);
tableH.addCell( empty );
 
document.add( tableH );  
////////////////////////////////////////////////////////////////////////////////////////////////////
// CREATE A TABLE
tableO = PdfTable.init( javacast("int", 1) );
tableO.setWidthPercentage(100);
tableO.setSpacingAfter(10);

// Tabla Interna
tableI = PdfTable.init( javacast("int", 3) );
tableI.setSpacingBefore(5);
tableI.setSpacingAfter(10);

// Folio
combParagraph = CreateObject("java", "com.lowagie.text.Paragraph");

paragraph.init("Folio Fiscal", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init(#rsdatosfac.timbre#, HelveticaNormal);
combParagraph.add(paragraph);
if (#rsDatosfac.PFTtipo# == "D"){
  paragraph.init("Factura: #rsDatosfac.serie# #rsDatosfac.fac1#", HelveticaNormal);
}else{
  paragraph.init("Nota de Crédito: #rsDatosfac.serie# #rsDatosfac.fac1#", HelveticaNormal);
  }
combParagraph.add(paragraph);

// CELL
cell = PdfPCell.init( combParagraph );
cell.SetLeading(1.2,1.2);
cell.setBorder(0);
cell.setHorizontalAlignment(Element.ALIGN_CENTER);
tableI.addCell( cell );

// Certificetum
combParagraph = CreateObject("java", "com.lowagie.text.Paragraph");
paragraph.init("No. Certificado SAT", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init(#rsdatosfac.certificadoSAT#, HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init("No. Certificado Emisor", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init(#rsDatosfac.numcerfacele#, HelveticaNormal);
combParagraph.add(paragraph);

// CELL
cell = PdfPCell.init( combParagraph );
cell.SetLeading(1.2,1.2);
cell.setBorder(0);
cell.setHorizontalAlignment(Element.ALIGN_CENTER);
tableI.addCell( cell );

// FECHA
combParagraph = CreateObject("java", "com.lowagie.text.Paragraph");

paragraph.init("Fecha Timbrado", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init(#rsdatosfac.fechaTimbrado#, HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init("Expedido en #rsDatosEmpresa.ciudad# #rsDatosEmpresa.estado#", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init(#rsdatosfac.OIfecha#, HelveticaNormal);
combParagraph.add(paragraph);

// CELL
cell = PdfPCell.init( combParagraph );
cell.SetLeading(1.2,1.2);
cell.setBorder(0);
cell.setHorizontalAlignment(Element.ALIGN_CENTER);
tableI.addCell( cell );

cellO = PdfPCell.init( tableI );
tableO.addCell(cellO);
document.add( tableO );
///////////////////////////////////////////  CLIENTE  //////////////////////////////////////////////////////

tableC = PdfTable.init( javacast("int", 1) );
tableC.setWidthPercentage(100);

combParagraph = CreateObject("java", "com.lowagie.text.Paragraph");

paragraph.init("Datos Cliente:", HelveticaLargeB);
combParagraph.add(paragraph);
paragraph.init(#rsDatosfac.snnombre#, HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init("#rsDatosfac.sndireccion# #rsDatosfac.sndireccion2#", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init(#rsDatosfac.dir#, HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init("R.F.C.  #rsdatosfac.snidentificacion#", HelveticaNormal);
combParagraph.add(paragraph);
 
cell = PdfPCell.init( combParagraph );
cell.SetLeading(1.2,1.2);

tableC.addCell( cell );
tableC.setSpacingBefore(5);
tableC.setSpacingAfter(10);
document.add( tableC );
///////////////////////////////////////////// SUB HEADER ////////////////////////////////////////////////////
tableSB = PdfTable.init( javacast("int", 4) );
tableSB.setWidthPercentage(100);
tableSB.setSpacingAfter(10);

paragraph.init("Condiciones de Pago:  #rsDatosfac.OIdiasvencimiento# Dias", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  tableSB.addCell( cell );

paragraph.init("Forma de Pago: una sola Exhibición", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  //cell.setColspan( javacast("int", 2) );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  tableSB.addCell( cell );

paragraph.init("Método de Pago: #rsDatosfac.nombre_TipoPago#", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  //cell.setColspan( javacast("int", 2) );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  tableSB.addCell( cell );

if(#rsDatosfac.mnombre# == 'Pesos Mexicanos'){
  paragraph.init("Moneda Nacional", HelveticaNormalB);
}else{
  paragraph.init("Moneda: #rsDatosfac.mnombre#", HelveticaNormalB);
}
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  tableSB.addCell( cell );

document.add( tableSB );
//////////////////////////////////////////////////// ALT ///////////////////////////////////////////////////////
tableA = PdfTable.init( javacast("int", 8) );
tableA.setWidthPercentage(100);

paragraph.init("Cantidad", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  tableA.addCell( cell );

paragraph.init("U.Medida", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  tableA.addCell( cell );

paragraph.init("Descripcion", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  cell.setColspan( javacast("int", 4) );
  tableA.addCell( cell );

paragraph.init("Precio Unitario", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  tableA.addCell( cell );

paragraph.init("Importe", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
  tableA.addCell( cell );

document.add( tableA );
///////////////////////////////////////////////// DATA ////////////////////////////////////////////////////////////
tableData = PdfTable.init( javacast("int", 8) );
tableData.setWidthPercentage(100);
Descuento = 0;
PageBreak = 1;

for(x=1; x <= rsDatosfac.recordcount; x++){

  paragraph.init("#rsDatosfac['OIDcantidad'][x]# ", HelveticaNormal);
    cell = PdfPCell.init( paragraph );
    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
    tableData.addCell( cell );
  
  paragraph.init("Servicios", HelveticaNormal);
    cell = PdfPCell.init( paragraph );
    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
    tableData.addCell( cell );
  
  paragraph.init("#rsDatosfac['OIDdescripcion'][x]# #rsDatosfac['OIDdescnalterna'][x]#", HelveticaNormal);
    cell = PdfPCell.init( paragraph );
    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
    cell.setColspan( javacast("int", 4) );
    tableData.addCell( cell );
  
  paragraph.init("#numberformat(rsDatosfac['OIDpreciouni'][x], ',9.00')#", HelveticaNormal);
    cell = PdfPCell.init( paragraph );
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
    tableData.addCell( cell );
  
  paragraph.init("#numberformat(rsDatosfac['OIDcantidad'][x] * rsDatosfac['OIDpreciouni'][x], ',9.00')#", HelveticaNormal);
    cell = PdfPCell.init( paragraph );
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
    tableData.addCell( cell );

    if (PageBreak == 40){
      PageBreak = 1;
      document.newPage();
    }else{
      PageBreak = PageBreak + 1;
    }
  Descuento = Descuento + #numberformat(rsDatosfac['OIDdescuento'][x], ',9.00')#;
}
document.add(tableData);

/////////////////////////////////////////////////// BLANK LINE ///////////////////////////////////////////////////////////////////
tableB = PdfTable.init( javacast("int", 8) );
tableB.setWidthPercentage(100);

paragraph.init(" ", HelveticaNormal);
  cell = PdfPCell.init( paragraph );
  cell.setColspan( javacast("int", 8) );
  tableB.addCell( cell );
document.add(tableB);
/////////////////////////////////////////////////// SUBTOTAL ///////////////////////////////////////////////////////////////////
tableI = PdfTable.init( javacast("int", 2) );
tableI.setWidthPercentage(100);

// Subtotal
Subtotal = rsdatosfac.OIsubtotal + Descuento;

paragraph.init("Subtotal", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
  tableI.addCell( cell );

paragraph.init("#numberformat(Subtotal, ",9.00")# ", HelveticaNormal);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
  tableI.addCell( cell );

// Descuento 
paragraph.init("Descuento", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
  tableI.addCell( cell );

paragraph.init("#numberformat(Descuento, ",9.00")#", HelveticaNormal);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
  tableI.addCell( cell );

// IEPS
if (rsdatosfac.OIieps > 0){
  paragraph.init("IEPS", HelveticaNormalB);
    cell = PdfPCell.init( paragraph );
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
    tableI.addCell( cell );
  
  paragraph.init("#numberformat(rsdatosfac.OIieps, ",9.00")#", HelveticaNormal);
    cell = PdfPCell.init( paragraph );
    cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
    tableI.addCell( cell );
}
// IVA
paragraph.init("I.V.A.", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
  tableI.addCell( cell );

paragraph.init("#numberformat(rsdatosfac.oiimpuesto, ",9.00")#", HelveticaNormal);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
  tableI.addCell( cell );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
table = PdfTable.init( javacast("int", 8) );
table.setWidthPercentage(100);
// Descripción
paragraph.init("#rsDatosfac.observaciones#", HelveticaNormal);
  cell = PdfPCell.init( paragraph );
  cell.setColspan( javacast("int", 6) );
  table.addCell( cell );

paragraph.init(" ", HelveticaNormal);
  cell = PdfPCell.init( tableI );
  cell.setColspan( javacast("int", 2) );
  table.addCell( cell );

// Total
if(#rsDatosfac.Miso4217# == 'MXP'){
  paragraph.init("#Ucase(monto.montoL)#", HelveticaNormalB);
}else{
  paragraph.init("#MontoLetras# #rsDatosfac.mnombre#", HelveticaNormalB);
}
  cell = PdfPCell.init( paragraph );
  cell.setColspan( javacast("int", 6) );
  table.addCell( cell );

paragraph.init("Total", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
  table.addCell( cell );

paragraph.init("#numberformat(rsdatosfac.oitotal, ",9.00")#", HelveticaNormalB);
  cell = PdfPCell.init( paragraph );
  cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
  table.addCell( cell );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tableI = PdfTable.init( javacast("int", 8) );
tableI.setWidthPercentage(100);

combParagraph = CreateObject("java", "com.lowagie.text.Paragraph");

paragraph.init("Cadena Original del complemento de certificación digital del SAT", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init("#rsdatosfac.cadenaSAT#", HelveticaSmall);
combParagraph.add(paragraph);

paragraph.init("Sello Digital del Emisor", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init("#rsdatosfac.sello#", HelveticaSmall);
combParagraph.add(paragraph);

paragraph.init("Sello Digital del SAT", HelveticaNormal);
combParagraph.add(paragraph);
paragraph.init("#rsdatosfac.selloSAT#", HelveticaSmall);
combParagraph.add(paragraph);

cell = PdfPCell.init( combParagraph );
cell.setColspan( javacast("int", 6) );
cell.setBorder(0);
cell.SetLeading(1.2,1.2);
tableI.addCell( cell );

cell = PdfPCell.init( qr );
cell.setColspan( javacast("int", 2) );
cell.setPadding(2);
cell.setBorder(0);
tableI.addCell( cell );

cell = PdfPCell.init( tableI );
cell.setColspan( javacast("int", 8) );
table.addCell( cell );
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//string = (writer.getPageNumber()).toString;
paragraph.init("Este Documento es una representación impresa de un CFDI", HelveticaNormal);
//paragraph.init(string,HelveticaNormal);

cell = PdfPCell.init( paragraph );
cell.setColspan( javacast("int", 8) );
table.addCell( cell );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
document.add(table);

document.close();
</cfscript> --->
<cf_throw message="Archivo generado c:\enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\#rsDatosfac.fac#.pdf ">