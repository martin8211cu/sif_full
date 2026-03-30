<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<!---<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>
--->
<body>

	<cfoutput>
<!---        <cf_htmlreportsheaders
            title="Prueba para la factura electronica" 
            filename="prueba.xls" 
            ira="formimprimedocumento.cfm">
     --->                   
        <cfif not isdefined("btnDownload")>  
            <cf_templatecss>
        </cfif>	        
    </cfoutput>
<cfquery name="rsDatosEmpresa" datasource="#session.DSN#">
select cenombre,direccion1,direccion2,ciudad,estado,codpostal,celogo
      from asp..cuentaempresarial e,asp..direcciones d,empresas
     where e.id_direccion = d.id_direccion
       and cecodigo = cliente_empresarial
       and ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
	<cfquery name="rsDatosfac" datasource="#session.DSN#">
		SELECT  SNnombre, SNidentificacion, d.direccion1 as SNdireccion, d.direccion2 as SNdireccion2,
				OItotal, OItotal as OItotalLetras, OIimpuesto, OIDescuento, 
                OItotal + OIDescuento - OIimpuesto as OIsubtotal,
				OIfecha, OIDdescripcion, upper(OIDdescnalterna) as OIDdescnalterna , 
				OIDCantidad,OIDtotal,OIDPrecioUni, OIObservacion,observaciones,
				OIDdescuento, OIdiasvencimiento,Mnombre,
				Oivencimiento,'C.P.'+CodPostal +', '+Ciudad+','+estado as dir,
				a.OImpresionID as NUMERODOC,snemail,
                ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) as fac,ltrim(rtrim(numcerfacele)) AS numcerfacele,
                anoaprofacele,numaprofacele,
                convert(varchar,a.ecodigo)+'_'+ltrim(rtrim(cadorifacele)) as cadena,ltrim(rtrim(seldogfacele)) as sello
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
				on a.mCodigo = m.Mcodigo
			    inner join faprefacturae f
			    on a.oidocumento = f.ddocumentoref
				WHERE a.OImpresionID =  #OImpresionID#
</cfquery>
     <!--- Validacion y creacion de carpetar para almacenar Facturas --->
     <cf_foldersFacturacion>
     <cfdocument format="PDF" filename="c:\enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\Factura-#rsDatosfac.fac#.pdf" overwrite="true">  
	<cfoutput>
    <!--- Datos de la empresa spacer.gif--->

 		 <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">
 		    <tr><td>
 		    	<table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">
                    <td width="171" rowspan="3" valign="top" class="logoTop"><img src="/cfmx/plantillas/soinasp01/images/logo_AH.JPG" alt="MiGestion.net" width="163" height="71"></td>
                    <td align = "right" ><img src="/cfmx/plantillas/soinasp01/images/RFC_AH1.jpg" alt="MiGestion.net" width="163" height="71"></td>
                </table>
             </tr></td>  
            
            <tr><td>
                <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	
 			    	<tr>            
                    	<td align = "left"  width= "600"> <strong>#rsDatosEmpresa.cenombre#</strong></td>         
                     	<td align = "left"  width= "185"><strong>Factura: </strong> </td>
                    	<td align = "right"  width= "250"><strong>#rsDatosfac.fac# </strong> </td>                                     
            		</tr>
             	</table>
             </tr></td>
             
			   <tr><td>
                 <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	             
                     <tr>
                       <td align = "left" width= "1100"><strong>#rsDatosEmpresa.direccion1#</strong></td> 
                        <td align = "left" width= "185"><strong>Fecha:</strong> </td>      
                        <td align = "right"width= "500" ><strong>#DateFormat(rsdatosfac.oifecha,"DD/MMM/YYYY HH:MM:SS")# </strong></td>
                     </tr>  
                 </table>
               </tr></td>
               
               <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>    
                         <td align = "left" width= "633"><strong>#rsDatosEmpresa.direccion2#</strong>                         
                         <strong>#rsDatosEmpresa.Estado#</strong></td> 
                         <td align = "left" width= "175"><strong>No. Certificado:</strong> </td> 
                         <td align = "right" width= "230"><strong>#rsDatosfac.numcerfacele#</strong> </td>
                     </tr>   
                   </table>
               </tr></td>
               
               <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>
                        <td align = "left" width= "593"><strong>C.P. #rsDatosEmpresa.codpostal#</strong></td>
                        <td align = "left" width= "175"><strong>A&ntilde;o Aprobaci&oacute;n:</strong> </td> 
                        <td align = "right" width= "250"><strong>#rsDatosfac.anoaprofacele#</strong> </td>
                     </tr>   
                   </table>
               </tr></td>
               
               <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>              
                        <td align = "left" width= "545"><strong>R.F.C. AHO-010103-SH3</strong></td>
                        <td align = "left  width= "185"><strong>No.Aprobaci&oacute;n:</strong> </td> 
                        <td align = "right" width= "250"><strong>#rsDatosfac.numaprofacele#</strong> </td>                   
                   </tr>   
                 </table>
               </tr></td>
               
               <tr><td>
                  <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">            	                                
                             <tr><td>&nbsp;</td></tr>           
			      </table>                                
               </tr></td>
			  
                <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>              
                        <td  align = "left" ><strong>Datos Cliente</strong></td> 
                   </tr>   
                 </table>
               </tr></td>
               
                <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>              
                      <td align = "left" ><strong> #rsDatosfac.snnombre#</strong></td> 
                   </tr>   
                 </table>
               </tr></td>
               
                <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>              
                        <td align = "left" ><strong> #rsDatosfac.sndireccion#</strong></td>  
                   </tr>   
                 </table>
               </tr></td>
               
                <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>              
                    	 <td align = "left" ><strong> #rsDatosfac.dir#</strong></td>      
                   </tr>   
                 </table>
               </tr></td>
			     
               <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>              
                      <td align = "left" ><strong>R.F.C.  #rsdatosfac.snidentificacion#</strong> </td>                  
                   </tr>   
                 </table>
               </tr></td>
                   
                <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>              
                    	<td align = "left"><strong>Condiciones de Pago:  #rsDatosfac.OIdiasvencimiento# Dias</strong></td>
                    	<td align = "left"><strong>Moneda: #rsDatosfac.mnombre#</strong></td>                                        
                   </tr>   
                 </table>
               </tr></td>

			    <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<tr>              
                       <td align = "left" width = "75">Cantidad</strong></td>
                       <td align = "Center" width = "700"><strong>Descripcion</strong></td>
                       <td align = "Center" width = "100"><strong>Precio Unitario</strong></td>
                   	   <td align = "Center" width = "100"><strong>Subtotal</strong></td>                	
                   </tr>   
                 </table>
               </tr></td>

               <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                	<cfloop query="rsDatosfac">
                     <tr>              
                      <td width = "60"><strong > #OIDcantidad# </strong></td>
                      <td width = "700"><strong > #OIDdescripcion# </strong></td>
                      <td align = "right" width = "100"><strong>#numberformat(OIDpreciouni, ",9.00")# </strong></td>
                      <td align = "right" width = "100"><strong>#numberformat(OIDtotal, ",9.00")# </strong></td>
                    </tr>   
                   </cfloop>
                 </table>
               </tr></td>
               
			  
             <tr><td>
                  <table border="0" style="border:outset"  width="100%"  class="areaFiltro" font style="font-size:10px">
          	    	 	<tr>
         	               <td width="100"><strong>Cadena Original</strong></td>
            	        </tr>
         		          <tr>                  	
          	              <td width="900"> <strong>#rsdatosfac.cadena#</strong></td>
         	            </tr>  
             	</table>
              </tr></td>
             
             <tr><td>
               <table border="0" style="border:outset" width="100%"  class="areaFiltro" font style="font-size:10px">                           
	                 <tr>
	                   	<td width="100"> <strong>Sello Digital</strong></td>
	                 </tr>
	                                              
	                <cfset renglon = 0>
	                 <cfset renglon_ini = 1>
	                 <cfloop condition="renglon LE #LEN(rsdatosfac.sello)#">
	                 	 <cfset renglon = #renglon#+120>
	                     <tr>                  	
	                        <td width="900"> <strong>#Mid(rsdatosfac.sello,renglon_ini,renglon)#</strong></td>
	                     </tr>
	                     <cfset renglon_ini = #renglon#+1>
	                 </cfloop>
                </table>
       		  </tr></td>
             
               <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                    <tr>
               	    	<td width="1080"></td>
                        <td align = "right" width="80" ><strong>Subtotal </strong></td>
                      	<td align = "right" width="180" ><strong>#numberformat(rsdatosfac.OIsubtotal, ",9.00")# </strong></td>
                </tr>
                 </table>
               </tr></td>
       
                <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                       <tr>
                         <td width="1050"></td>
                      	<td align = "right" width="100" ><strong>I.V.A.   </strong></td>
                     	<td align = "right" width="200" ><strong>#numberformat(rsdatosfac.oiimpuesto, ",9.00")# </strong></td>
                      </tr>            
                 </table>
               </tr></td>
               
               <cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
					<cfinvokeargument name="Monto" value="#rsdatosfac.Oitotal#">
			   </cfinvoke>
			   
                <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                    <tr>
                      <td width="1100" align="right"><strong>#MontoLetras# </strong></td>				                   
                	  <td align="right" width="100" ><strong>Total    </strong></td>                                    
                      <td align="right" width="200"><strong>#numberformat(rsdatosfac.oitotal, ",9.00")# </strong></td>
                   </tr> 
                 </table>
               </tr></td>
                            
                                                                     
 	           <cfset leyenda="Este Documento es una Impresion de un comprobante Fiscal Digital">
                               		
    	       <cfdocumentitem type="footer"> 
    	         <tr><td>
                  <table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%"font style="font-size:20px">            	                                
                       <tr>
                           <td align="center" border="1"><font style="font-size:30px">#leyenda# </td>
                      </tr>            
                 </table>
                </tr></td>
	     </table>
            </cfdocumentitem>
            

    </cfoutput>               
               
 	</cfdocument>
        
                </body>
</html>

