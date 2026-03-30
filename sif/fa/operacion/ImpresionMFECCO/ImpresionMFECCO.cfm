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
				ltrim(rtrim(convert(char,oifecha,102)))+' '+convert(char,getdate(),108) as OIfecha,
				OIDdescripcion, upper(OIDdescnalterna) as OIDdescnalterna , 
				OIDCantidad,OIDtotal,OIDPrecioUni, OIObservacion,observaciones,
				OIDdescuento, OIdiasvencimiento,Mnombre,f.PFTcodigo,
				Oivencimiento,'C.P.'+CodPostal +', '+Ciudad+','+estado as dir,
				a.OImpresionID as NUMERODOC,snemail,
                ltrim(rtrim(seriefacele)) as serie, ltrim(rtrim(foliofacele)) as fac1,  
                convert(varchar,a.ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) as fac,ltrim(rtrim(numcerfacele)) AS numcerfacele,
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

<cfdocument format="PDF" filename="c:\enviar\#rsDatosfac.fac#.pdf" overwrite="true">  
<cfoutput>
    <!--- Datos de la empresa spacer.gif--->
    <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">
    	<tr><td>
        <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">
            <tr>            
            	<td width="50%">
                	<table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">
						<tr>
                			<td width="100%" valign="top" class="logoTop" ><img src="/cfmx/plantillas/soinasp01/images/logo_CCO.JPG" alt="MiGestion.net" width="800" height="280"></td>
						</tr>
						<tr>
                			<td> </td>
						</tr>
                        <tr>
                        	<td align = "left"><strong><font style="font-size:30px">#Trim(rsDatosEmpresa.cenombre)#</font></strong></td>
                        </tr>
                        
                        <tr>
                        	<td align = "left"><strong><font style="font-size:30px">#Trim(rsDatosEmpresa.direccion1)#</font></strong></td>
                        </tr>
                        
                        <tr>
                        	<td align = "left"><strong><font style="font-size:30px">#Trim(rsDatosEmpresa.direccion2)# C.P. #rsDatosEmpresa.codpostal#</font></strong></td>
                        </tr>
                        
                        <tr>
                        	<td align = "left"><strong><font style="font-size:30px">#Trim(rsDatosEmpresa.ciudad)# #Trim(rsDatosEmpresa.Estado)#</font></strong></td>
                        </tr>
                        <tr>
                        	<td align = "left"><strong><font style="font-size:30px">R.F.C. #Trim(rsRFCEmpresa.Eidentificacion)#</font></strong></td>
                        </tr>
                   	</table>
				</td>
    			<td width="50%">
                	<table style="border:outset thin" class="areaFiltro" font style="font-size:30px" width="100%">
                    	<tr height="3">
                            <td align = "left"><strong>SERIE:</strong> </td>
                            <td align = "right"><strong>#rsDatosfac.serie#</strong> </td>
                    	</tr>
                        <tr height="3">
                            <cfif #rsDatosfac.PFTcodigo# EQ "FC">        
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
                            <td align = "right"><strong>#DateFormat(rsdatosfac.oifecha,"DD/MMM/YYYY HH:MM:SS")#</strong></td>
                        </tr> 
                    </table>
                </td>
            </tr>
        </table>
        </td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td>
        	<table border="1" cellspacing="0" cellpadding="0" class="areaFiltro" font style="font-size:30px" width="100%">
            	<tr>
                	<td  align = "left" width="15%"><strong>CLIENTE</strong></td>
                    <td align = "left" width="85%" colspan="2"><strong>#rsDatosfac.snnombre#</strong></td>
                </tr>
<!---               <hr align="center" width="100%"/>  --->               
            	<tr>
                	<td align = "left" width="15%"><strong>DIRECCI&Oacute;N</strong></td>
                    <td align = "left" width="85%"><strong>#Trim(rsDatosfac.sndireccion)# #Trim(rsDatosfac.dir)#</strong></td>
                </tr>
            	<tr>
                	<td  align = "left" width="15%"><strong>RFC</strong></td>
                    <td align = "left" width="85%" colspan="2"><strong>#rsdatosfac.snidentificacion#</strong></td>
                </tr>
            </table>
        </td></tr>
        <tr><td>&nbsp;</td></tr>
      <!--- Datos del detalle de la factura class="areaFiltro"--->      
        <tr><td>
        	<table border="1" cellspacing="0" cellpadding="2" class="areaFiltro" font style="font-size:30px" width="100%">
            	<tr>
                    <td align = "center" width="15%"><strong>CANTIDAD</strong></td>
                    <td align = "center" width="55%"><strong>DESCRIPCI&Oacute;N</strong></td>
                    <td align = "center" width="15%"><strong>P.UNITARIO</strong></td>
                    <td align = "center" width="15%"><strong>IMPORTE</strong></td>
                </tr>
                <cfloop query="rsDatosfac">
                <tr>
                    <td align = "left" ><strong>#OIDcantidad#</strong></td>
                    <td align = "left" ><strong>#OIDdescripcion#</strong></td>
                    <td align = "right"><strong>#numberformat(OIDpreciouni, ",9.00")#</strong></td>
                   	<td align = "right"><strong>#numberformat(OIDtotal, ",9.00")#</strong></td>
                </tr>
                </cfloop>
                
        		<tr><td colspan="4">&nbsp;</td></tr>
                <cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
                	<cfinvokeargument name="Monto" value="#rsdatosfac.Oitotal#">
                </cfinvoke>
                <tr>
					<td align = "left" colspan="2"><strong>Cantidad</strong></td>
                    <td align = "left" ><strong>SUBTOTAL</strong></td>
                    <td align = "right"><strong>#numberformat(rsdatosfac.OIsubtotal, ",9.00")#</strong></td>
                </tr>
                <tr>
                    <td align="left" valign="top" colspan="2" rowspan="2"><strong>#MontoLetras# #rsDatosfac.mnombre#</strong></td>
                    <td align = "left" ><strong>IVA</strong></td>
                    <td align = "right"><strong>#numberformat(rsdatosfac.oiimpuesto, ",9.00")#</strong></td>
                </tr>
                <tr>
<!---                    <td align="left" colspan="2">&nbsp;</td> ---> 
                   	<td align = "left" ><strong>TOTAL</strong></td>
                    <td align = "right"><strong>#numberformat(rsdatosfac.oitotal, ",9.00")#</strong></td>
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

		<cfdocumentitem type="footer">
        <tr><td>
            <table style="border:outset" width="100%" font style="font-size:30px" class="areaFiltro">
            	<tr>
                <td>Deb(emos) y pagar&eacute;(emos) incondicionalmente a favor de #Trim(rsDatosEmpresa.cenombre)#. La cantidad que ampara la siguiente factura en el domicilio se&ntilde;alado y en los plazos y</td>
                </tr>
                <tr>
                <td>condiciones estipuladas en la misma. En caso contrario esta factura causara __________% de inter&eacute; moratorio a su vencimiento.</td>
                </tr>
            </table>
        </td></tr>
        <tr>
        	<td align="center"><strong><font style="font-size:30px">ESTE DOCUMENTO ES UNA IMPRESI&Oacute;N DE UN COMPROBANTE FISCAL DIGITAL</font></strong></td>
        	<td align="right" border="1"><font style="font-size:30px">Pagina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount# </td>  
        </tr>
       	</cfdocumentitem>
    </table>
</cfoutput>
</cfdocument>

<!---    Codigo para enviar mails               mimeattach="C:/enviar/#rsDatosfac.fac#.pdf"  			 CC="gpaz@mailcity.com"   Factura-#rsDatosfac.fac#.pdf,--->
            <cfset archivo = "C:/enviar/#rsDatosfac.fac#.xml">           

		<!---	<CFMAIL TO="#rsDatosfac.snemail#"
			 FROM="facturacionelectronica@clearchannel.com.mx"
             type="text"
			 SUBJECT="Factura Electronica F-#rsDatosfac.fac#">
			 <cfmailparam file="C:/enviar/#rsDatosfac.fac#.xml">
			 <cfmailparam file="C:/enviar/#rsDatosfac.fac#.pdf">

				Se envio la Factura Electronica Num. Factura-#rsDatosfac.fac#
                
			</CFMAIL> --->
                
     fin del codigo de enviar mails 

	<cfquery name="rsupdfac" datasource="#session.DSN#">
				update faprefacturae
				set enviamail =1				
				FROM FAEOrdenImpresion a, faprefacturae f
			    where a.oidocumento = f.ddocumentoref
				and   a.OImpresionID =  #OImpresionID#
     </cfquery>     
</body>
</html>

