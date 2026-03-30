<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<body>

	<cfoutput>
        <cfif not isdefined("btnDownload")>  
            <cf_templatecss>
        </cfif>	        
    </cfoutput>
    
    <cfquery name="rsDatosEmpresa" datasource="#session.DSN#">
		select nombreemisor as cenombre,direccion1,direccion2,ciudad,estado,codpostal,celogo
		from asp..cuentaempresarial e,asp..direcciones d,empresas m,
		facturacionelectronica..db_ctlogemisor f
		where e.id_direccion = d.id_direccion
		and cecodigo = cliente_empresarial
		and f.ecodigo = m.ecodigo
		and m.ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
	<cfquery name="rsRFCEmpresa" datasource="#session.DSN#">
		select Eidentificacion from Empresas
		where ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
    
	<cfquery name="rsDatosfac" datasource="#session.DSN#">
		SELECT  SNnombre, SNidentificacion, d.direccion1 as SNdireccion, d.direccion2 as SNdireccion2,
				OItotal, OItotal as OItotalLetras, OIimpuesto, OIDescuento, 
                OItotal + OIDescuento - OIimpuesto as OIsubtotal,
				ltrim(rtrim(convert(char,oifecha,102)))+' '+convert(char,oifecha,108) as OIfecha,
                substring(convert(char, oifecha, 112),7,2)+'/'+
        	case 
				when substring(convert(char, oifecha, 112),5,2) = '01' then 'Ene'
				when substring(convert(char, oifecha, 112),5,2) = '02' then 'Feb'
				when substring(convert(char, oifecha, 112),5,2) = '03' then 'Mar'
                when substring(convert(char, oifecha, 112),5,2) = '04' then 'Abr'                
				when substring(convert(char, oifecha, 112),5,2) = '05' then 'May'
				when substring(convert(char, oifecha, 112),5,2) = '06' then 'Jun'
				when substring(convert(char, oifecha, 112),5,2) = '07' then 'Jul'
				when substring(convert(char, oifecha, 112),5,2) = '08' then 'Ago'
				when substring(convert(char, oifecha, 112),5,2) = '09' then 'Sep'
				when substring(convert(char, oifecha, 112),5,2) = '10' then 'Oct'
				when substring(convert(char, oifecha, 112),5,2) = '11' then 'Nov'
				when substring(convert(char, oifecha, 112),5,2) = '12' then 'Dic'
		      end+'/'+
			substring(convert(char, oifecha, 112),1,4)+' '+
			substring(convert(varchar,oifecha,114),1,8) as fecfac,

				OIDdescripcion, upper(OIDdescnalterna) as OIDdescnalterna , 
				OIDCantidad,OIDtotal,OIDPrecioUni, OIObservacion,observaciones,
				OIDdescuento, OIdiasvencimiento,Mnombre,f.PFTcodigo,
				Oivencimiento,'C.P.'+CodPostal +', '+Ciudad+','+estado as dir,
				a.OImpresionID as NUMERODOC,snemail,
                ltrim(rtrim(seriefacele)) as serie, ltrim(rtrim(foliofacele)) as fac1,  
				case CCTcodigo
				when  'FA' then
		                'FE_'+convert(varchar,a.ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele))  
				when  'FC' then
				'FE_'+convert(varchar,a.ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele))  
				when  'ND' then
				'ND_'+convert(varchar,a.ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) 
				when  'NC' then
				'NC_'+convert(varchar,a.ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) 
				end as fac,
				ltrim(rtrim(numcerfacele)) AS numcerfacele,
                anoaprofacele,numaprofacele,
                ltrim(rtrim(cadorifacele)) as cadena,ltrim(rtrim(seldogfacele)) as sello
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
			    and a.Ecodigo = f.Ecodigo
				WHERE a.OImpresionID =  #OImpresionID#
</cfquery>

<cfdocument format="PDF" filename="c:/enviar/#rsDatosfac.fac#.pdf" overwrite="true">  
<cfoutput>
    <!--- Datos de la empresa spacer.gif--->
    <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%" >
    	<tr><td>
        <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%" >
            <tr>            
            	<td width="35%">
                	<table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%" font style="font-size:35px">
						<tr>
                			<td width="100%" valign="top" class="logoTop" ><img src="/cfmx/plantillas/soinasp01/images/logo_CCO.JPG" alt="MiGestion.net" width="800" height="280"></td>
                   <!---        <td width="30%"><img src="/cfmx/plantillas/soinasp01/images/RFC_AH1.jpg" alt="MiGestion.net" width="250" height="400"></td>  --->
                           <td> </td>
               			</tr>
						<tr>
                			<td> </td>
						</tr> 
                        <tr>
                        	<td align = "left"><font style="font-size:33px"><strong>#Trim(rsDatosEmpresa.cenombre)#</font></strong></td>                            
                        </tr>
                        
                        <tr>
                        	<td align = "left"><font style="font-size:33px"><strong>#Trim(rsDatosEmpresa.direccion1)#</font></strong></td>
                        </tr>
                        
                        <tr>
                        	<td align = "left"><font style="font-size:33px"><strong>#Trim(rsDatosEmpresa.direccion2)# C.P. #rsDatosEmpresa.codpostal#</font></strong></td>
                        </tr>
                        
                        <tr>
                        	<td align = "left"><font style="font-size:33px"><strong>#Trim(rsDatosEmpresa.ciudad)# #Trim(rsDatosEmpresa.Estado)#</font></strong></td>
                        </tr>
                        <tr>
                        	<td align = "left"><font style="font-size:33px"><strong>R.F.C. #Trim(rsRFCEmpresa.Eidentificacion)#</font></strong></td>
                        </tr>
                        <td> </td>
                   	</table>
				</td>
    			<td width="40%">
                	<table style="border:outset thin" class="areaFiltro"  font style="font-size:35px">
                    	<tr height="3">
                            <td align = "left"><strong>SERIE:</strong> </td>
                            <td align = "right"><strong>#rsDatosfac.serie#</strong> </td>
                    	</tr>
                        <tr height="3">
                            <cfif #rsDatosfac.PFTcodigo# EQ "PF">        
                            	<td align = "left"><strong>NUMERO DE FACTURA</strong> </td>
                            <cfelse>
                            	<td align = "left"><strong>NUMERO DE NOTA DE CREDITO</strong> </td>
                            </cfif>
                            <td align = "right"><strong>#rsDatosfac.fac1#</strong> </td>
                        </tr>
                        <tr height="3">     
                             <td align = "left"><strong>NO.SERIE CERTIFICADO</strong> </td> 
                             <td align = "right"><strong>#rsDatosfac.numcerfacele#</strong> </td>
                        </tr>        
                        <tr height="3">    
                            <td align = "left" ><strong>NO. Y A&Ntilde;0 APROBACI&Oacute;N</strong> </td> 
                            <td align = "right"><strong>#rsDatosfac.numaprofacele# #rsDatosfac.anoaprofacele#</strong> </td>
                        </tr>                     
                        <tr height="3">     
                            <td align = "left" ><strong>Fecha:</strong></td>     
<!---                            <td align = "right"><strong>#DateFormat(rsdatosfac.oifecha,"DD/MMM/YYYY HH:MM:SS")#</strong></td> --->
							<td align = "right"><strong>#rsdatosfac.fecfac#</strong></td>

                        </tr> 
                    </table>
                </td>
                
                   	<td width="35%">
                	  <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%" font style="font-size:40px">
						 <tr>
                          <cfif #session.Ecodigo# EQ 3> <!--- CCOM --->        
                 		    <td  align = "right" width="100%"><img src="/cfmx/plantillas/soinasp01/images/rfc_ccom.jpg" alt="MiGestion.net" width="600" height="300"></td> 
                          </cfif>
                          
                          <cfif #session.Ecodigo# EQ 4> <!--- RACKLIGHT S.A. DE C.V. --->        
                 		    <td  align = "right" width="100%"><img src="/cfmx/plantillas/soinasp01/images/rfc_rac.jpg" alt="MiGestion.net" width="600" height="300"></td> 
                          </cfif>
                          
                         </tr>
                      </table>   
					</td>
            </tr>
        </table>
        </td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td>
        	<table border="1" cellspacing="0" cellpadding="0" class="areaFiltro"  width="100%">
            	<tr>
                	<td  align = "left" width="15%"><font style="font-size:45px"><strong>CLIENTE</strong></td>
                    <td align = "left" width="85%" colspan="2"><font style="font-size:45px"><strong>#rsDatosfac.snnombre#</strong></td>
                </tr>
<!---               <hr align="center" width="100%"/>  --->               
            	<tr>
                	<td align = "left" width="15%"><font style="font-size:45px"><strong>DIRECCI&Oacute;N</strong></td>
                    <td align = "left" width="85%"><font style="font-size:45px"><strong>#Trim(rsDatosfac.sndireccion)# #Trim(rsDatosfac.SNdireccion2)# #Trim(rsDatosfac.dir)#</strong></td>
                </tr>
            	<tr>
                	<td  align = "left" width="15%"><font style="font-size:45px"><strong>RFC</strong></td>
                    <td align = "left" width="85%" colspan="2"><font style="font-size:45px"><strong>#rsdatosfac.snidentificacion#</strong></td>
                </tr>
            </table>
        </td></tr>
        <tr><td>&nbsp;</td></tr>
      <!--- Datos del detalle de la factura class="areaFiltro"--->      
        <tr><td>
        	<table border="1" cellspacing="0" cellpadding="2" class="areaFiltro" font style="font-size:10px" width="100%">
            	<tr>
                    <td align = "center" width="15%"><font style="font-size:45px"><strong>CANTIDAD</strong></td>
                    <td align = "center" width="55%"><font style="font-size:45px"><strong>DESCRIPCI&Oacute;N</strong></td>
                    <td align = "center" width="15%"><font style="font-size:45px"><strong>P.UNITARIO</strong></td>
                    <td align = "center" width="15%"><font style="font-size:45px"><strong>IMPORTE</strong></td>
                </tr>
                <cfloop query="rsDatosfac">
                <tr>
                    <td align = "left" ><font style="font-size:45px"><strong>#OIDcantidad#</strong></td>
                    <td align = "left" ><font style="font-size:45px"><strong>#OIDdescripcion#</strong></td>
                    <td align = "right"><font style="font-size:45px"><strong>#numberformat(OIDpreciouni, ",9.00")#</strong></td>
                   	<td align = "right"><font style="font-size:45px"><strong>#numberformat(OIDtotal, ",9.00")#</strong></td>
                </tr>
                </cfloop>              
        	<tr><td colspan="4">&nbsp;</td></tr>
	 			
		    <tr>
		         <td align = "left" ><font style="font-size:45px"><strong>Observaciones: </strong></td>
			 <td align = "left" ><font style="font-size:45px">#rsdatosfac.observaciones# #rsdatosfac.OIObservacion#</td>
		    </tr> 


                <cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
                	<cfinvokeargument name="Monto" value="#rsdatosfac.Oitotal#">
                </cfinvoke>
                <tr>
					<td align = "left" colspan="2"><font style="font-size:45px"><strong>Cantidad</strong></td>
                    <td align = "left" ><font style="font-size:45px"><strong>SUBTOTAL</strong></td>
                    <td align = "right"><font style="font-size:45px"><strong>#numberformat(rsdatosfac.OIsubtotal, ",9.00")#</strong></td>
                </tr>
                <tr>
                    <td align="left" valign="top" colspan="2" rowspan="2"><font style="font-size:45px"><strong>#MontoLetras# #rsDatosfac.mnombre#</strong></td>
                    <td align = "left" ><font style="font-size:45px"><strong>IVA</strong></td>
                    <td align = "right"><font style="font-size:45px"><strong>#numberformat(rsdatosfac.oiimpuesto, ",9.00")#</strong></td>
                </tr>
                <tr>
<!---                    <td align="left" colspan="2">&nbsp;</td> ---> 
                   	<td align = "left" ><font style="font-size:45px"><strong>TOTAL</strong></td>
                    <td align = "right"><font style="font-size:45px"><strong>#numberformat(rsdatosfac.oitotal, ",9.00")#</strong></td>
                </tr>
            </table>
        </td></tr>
        <tr><td>&nbsp;</td></tr>
        
        <tr><td>
            <table  style="border:outset thin" width="100%" font style="font-size:30px" class="areaFiltro">
           	 	<tr>
                    <td><strong>Cadena Original</strong></td>
                </tr>
                <tr>                  	
                   	<td> <strong>#HTMLEditFormat(rsdatosfac.cadena)#</strong></td>
                </tr>   
            </table>        
        </td></tr> 
        <tr><td>&nbsp;</td></tr>
        <tr><td>
            <table style="border:outset thin" width="100%" font style="font-size:30px" class="areaFiltro">                           
                 <tr>
                   	<td> <strong>Sello Digital </strong></td>
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
        </td></tr> 
        <tr><td>&nbsp;</td></tr>
             
		<!--- <cfdocumentitem type="footer">
		<table style="border:outset" width="100%" class="areaFiltro" font style="font-size:40px">
        <tr><td>
            
            	<tr>
                   <td><font style="font-size:40px"> <strong>Deb(emos) y pagar&eacute;(emos) incondicionalmente a favor de #Trim(rsDatosEmpresa.cenombre)#. La cantidad que ampara la siguiente factura en el domicilio se&ntilde;alado y en los plazos y<strong></td>
                </tr>
                  <tr>
                     <td><font style="font-size:40px"> <strong>condiciones estipuladas en la misma. En caso contrario esta factura causara __________% de inter&eacute;s moratorio a su vencimiento.<strong></td>
                  </tr>           
        </td>
        </tr>
        <tr>
        	<td align="left"><font style="font-size:40px"> <strong> ESTE DOCUMENTO ES UNA IMPRESI&Oacute;N DE UN COMPROBANTE FISCAL DIGITAL </strong></td>
        	<td align="right" border="1"><font style="font-size:40px"><strong> Pagina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount# <strong></td>
        </tr>
                
        </table>
       	</cfdocumentitem> --->
       	
       	 	        <cfset leyenda="Deb(emos) y pagar&eacute;(emos) incondicionalmente a favor de #Trim(rsDatosEmpresa.cenombre)#. La cantidad que ampara la siguiente factura en el domicilio se&ntilde;alado y en los plazos y">
					<cfset leyenda1="condiciones estipuladas en la misma. En caso contrario esta factura causara  __% de interes inter&eacute;s moratorio a su vencimiento.">       	 	        
					<cfset leyenda2=" ESTE DOCUMENTO ES UNA IMPRESI&Oacute;N DE UN COMPROBANTE FISCAL DIGITAL ">       	 	        					
                               		
    		<cfdocumentitem type="footer">
    	         <tr><td>
                  <table style="border:outset"  cellspacing="0" cellpadding="0" class="areaFiltro" width="2700">            	                                
                      <tr>
                           <td align="left"><font style="font-size:32px">#leyenda# </td>                           
                      </tr>    
                         <tr>
                           <td align="left"><font style="font-size:32px">#leyenda1# </td>	                           
                         </tr>          
                         <tr>
                           <td align="left"> <font style="font-size:32px"> #leyenda2# Pagina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</td>
                           <!--- <td align="right"> <font style="font-size:32px"> Pagina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount# </td>   --->
                      </tr>            
                 </table>
                </td></tr>
			</cfdocumentitem>                

       	       	
       	
    </table>
</cfoutput>
</cfdocument>

<!---    Codigo para enviar mails               mimeattach="C:/enviar/#rsDatosfac.fac#.pdf"  			 CC="gpaz@mailcity.com"   Factura-#rsDatosfac.fac#.pdf,--->
            <cfset archivo = "C:/enviar/#rsDatosfac.fac#.xml">           
			
	<cfif #rsDatosfac.snemail# neq "">
			<CFMAIL TO="#rsDatosfac.snemail#"  CC="facturacionelectronica@clearchannel.com.mx"
			 FROM="facturacionelectronica@clearchannel.com.mx"
		             type="text"
			 SUBJECT="Factura Electronica #rsDatosfac.fac#">
			 <cfmailparam file="C:\enviar\#rsDatosfac.fac#.xml">
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
     </cfquery>     
</body>
</html>

