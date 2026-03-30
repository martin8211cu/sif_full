<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Factura" default="Factura" returnvariable="LB_Factura" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NotaCredito" default="Nota de Credito" returnvariable="LB_NotaCredito" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NotaDebito" default="Nota de Debito" returnvariable="LB_NotaDebito" 
xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DiasVigenciaFechaEmision" default="Dias de Vigencia a partir de la fecha de Emisi&oacute;n" returnvariable="LB_DiasVigenciaFechaEmision" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Detalle" default="Detalle" returnvariable="LB_Detalle" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Subtotal" default="Sub Total" returnvariable="LB_SubTotal" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Impuesto" default="Impuesto" returnvariable="LB_Impuesto" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descuento" default="Descuento" returnvariable="LB_Descuento" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalLetra" default="Total con letras" returnvariable="LB_TotalLetra" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Observaciones" default="Observaciones" returnvariable="LB_Observaciones" xmlfile="ImpFacturaSES.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="ImpFacturaSES.xml"/>



<!--- Formato  de Impresión de Factura SES    IRR APH 231012--->
<style type="text/css">
	
	.TituloPrincipal {
		font-size: 18px;
		font-weight: bold;
		font-family:Arial, Helvetica, sans-serif
	}
	.LetraTitulo{
		font-size: 12px;
		font-weight: bold;
		font-family:Arial, Helvetica, sans-serif
	}
	.LetraEncab{
		font-size:12px;
		font-weight:bold;
		font-family:Arial, Helvetica, sans-serif
	}
	.LetraInfo{
		font-size:12px;
		font-family:Arial, Helvetica, sans-serif
	}	
	
	body {
		overflow-x: hidden;
		margin: 0;
	}

</style>

<cfquery name="Empresa" datasource="#Session.DSN#">
	select Edescripcion,ETelefono1,EDireccion1,ts_rversion,EIdentificacion   from Empresas where Ecodigo = #session.Ecodigo#
</cfquery>

 	<cfquery name="rsDatosfac" datasource="#session.DSN#">
		SELECT distinct SNnombre, SNidentificacion,SNidentificacion2, PFDocumento,
                d.direccion1 as SNdireccion, d.direccion2 as SNdireccion2,
				OItotal, OItotal as OItotalLetras, OIimpuesto, OIdescuento, 
                OItotal + OIdescuento - OIimpuesto as OIsubtotal,year(OIfecha) as anioFac,
				ltrim(rtrim(convert(char,OIfecha,102)))+' '+convert(char,OIfecha,108) as OIfecha,
                substring(convert(char, OIfecha, 112),7,2)+' de '+
        	case 
				when substring(convert(char, OIfecha, 112),5,2) = '01' then 'Enero'
				when substring(convert(char, OIfecha, 112),5,2) = '02' then 'Febrero'
				when substring(convert(char, OIfecha, 112),5,2) = '03' then 'Marzo'
                when substring(convert(char, OIfecha, 112),5,2) = '04' then 'Abril'                
				when substring(convert(char, OIfecha, 112),5,2) = '05' then 'Mayo'
				when substring(convert(char, OIfecha, 112),5,2) = '06' then 'Junio'
				when substring(convert(char, OIfecha, 112),5,2) = '07' then 'Julio'
				when substring(convert(char, OIfecha, 112),5,2) = '08' then 'Agosto'
				when substring(convert(char, OIfecha, 112),5,2) = '09' then 'Septiembre'
				when substring(convert(char, OIfecha, 112),5,2) = '10' then 'Octubre'
				when substring(convert(char, OIfecha, 112),5,2) = '11' then 'Noviembre'
				when substring(convert(char, OIfecha, 112),5,2) = '12' then 'Diciembre'
		      end+' del '+ substring(convert(char, OIfecha, 112),1,4)as fecfac,            
            case 
				when substring(convert(char, OIfecha, 112),5,2) = '01' then 'January'
				when substring(convert(char, OIfecha, 112),5,2) = '02' then 'February'
				when substring(convert(char, OIfecha, 112),5,2) = '03' then 'March'
                when substring(convert(char, OIfecha, 112),5,2) = '04' then 'April'                
				when substring(convert(char, OIfecha, 112),5,2) = '05' then 'May'
				when substring(convert(char, OIfecha, 112),5,2) = '06' then 'June'
				when substring(convert(char, OIfecha, 112),5,2) = '07' then 'July'
				when substring(convert(char, OIfecha, 112),5,2) = '08' then 'August'
				when substring(convert(char, OIfecha, 112),5,2) = '09' then 'September'
				when substring(convert(char, OIfecha, 112),5,2) = '10' then 'October'
				when substring(convert(char, OIfecha, 112),5,2) = '11' then 'November'
				when substring(convert(char, OIfecha, 112),5,2) = '12' then 'December'                
		      end+ ' ' + substring(convert(char, OIfecha, 112),7,2) + '_ '  + substring(convert(char, OIfecha, 112),1,4)as fecfacing,  
        	
              
				upper(OIDdescripcion) as  OIDdescripcion, upper(OIDdescnalterna) as OIDdescnalterna , 
				OIDCantidad,OIDtotal,OIDPrecioUni, OIObservacion,Observaciones,b.Icodigo,
				OIDdescuento, OIdiasvencimiento,Mnombre,f.PFTcodigo,f.FechaVen,f.vencimiento,
				OIvencimiento, ciudad + ', '+ estado + ', '+ 'C.P.'+codPostal  as dir,
				a.OImpresionID as NUMERODOC,SNemail,CCTcodigo,OIEstado,Bid,OIvencimiento,
                m.Mnombre,m.Msimbolo,OItipoCambio,a.Ocodigo,Udescripcion,OIDetalle
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
			    LEFT JOIN FAPreFacturaE f
			    on a.OIdocumento = f.DdocumentoREF
			    and a.Ecodigo = f.Ecodigo
                LEFT JOIN FAPreFacturaD pfd on f.Ecodigo=pfd.Ecodigo 
                and f.IDpreFactura=pfd.IDpreFactura
			    LEFT JOIN Conceptos con on pfd.Ecodigo =con.Ecodigo 
                and con.Cid=pfd.Cid
			    LEFT JOIN Unidades u on u.Ecodigo=con.Ecodigo 
                and con.Ucodigo= u.Ucodigo                
				WHERE a.OImpresionID =  #OImpresionID#
</cfquery>
<!---<cfdump var="#rsDatosfac#">--->
<cfquery name="rsBanco" datasource="#session.DSN#">
	select b.Bid,b.Bdescripcion, cb.CBcodigo,b.Bdireccion,b.BcodigoIBAN from Bancos b
	inner join CuentasBancos cb on b.Ecodigo=cb.Ecodigo and b.Bid=cb.Bid
	where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and b.Bid=#rsDatosfac.Bid#
</cfquery>

<cfquery name="rsOImpresion" datasource="#session.DSN#">
	select * ,year(OIfecha) as anioFac
    from FAEOrdenImpresion a
    where a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select Rcodigo, Rdescripcion, Rporcentaje from Retenciones 
	where Ecodigo =  #Session.Ecodigo# 
    and Rcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOImpresion.Rcodigo#"> 
	order by Rdescripcion
</cfquery>

<cfquery name="rsOficina" datasource="#session.dsn#">
	select * from Oficinas
   	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Ocodigo= #rsOImpresion.Ocodigo#
</cfquery>

<cfquery name= "rsDirOficina" datasource="#session.dsn#">
	select LTRIM(RTRIM(atencion)) as atencion,LTRIM(RTRIM(direccion1)) direccion, LTRIM(RTRIM(direccion2)) as direccion2, 
    LTRIM(RTRIM(ciudad)) as ciudad, LTRIM(RTRIM(estado)) as estado,LTRIM(RTRIM(codPostal)) as codigoPostal 
     from Direcciones where id_direccion=#rsOficina.id_direccion#
</cfquery>

<cfif rsDatosfac.recordCount EQ 1>
    <cfquery name="rsImpuestos" datasource="#session.dsn#">
        select Idescripcion from Impuestos 
        where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Icodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosfac.Icodigo#">
    </cfquery>
</cfif>

  <cfoutput>  
    <table width="100%" border="0" cellpadding="2" cellspacing="1" align="center">
        <tr>
        	<td colspan="6">
        		<table align="center" width="100%" border="0" cellpadding="0" cellspacing="3">
        			<cfset PrintHeader()>
                    <tr><td>&nbsp;</td></tr>
                    <cfif LTRIM(RTRIM(session.idioma)) EQ "en">
                    	<cfset fecha =#replace(rsDatosfac.fecfacing,"_",", ")#>
                    <cfelse>
                    	 <cfset fecha= #rsDatosfac.fecfac#>
                     </cfif>    
                     <tr>
                        <td class="LetraTitulo" align="right"nowrap="nowrap">#fecha# </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <cfif rsDirOficina.direccion GT 0>                    	
                        <tr>
                        	<td class="LetraInfo" nowrap="nowrap"><cfoutput>#rsDirOficina.direccion#</cfoutput></td>
                    	</tr><tr><td>&nbsp;</td></tr>
                        <tr>
                        	<td class="LetraInfo" nowrap="nowrap"><cfoutput>#rsDirOficina.direccion2#</cfoutput></td>
                    	</tr><tr><td>&nbsp;</td></tr>
                        <tr>
                        	<td class="LetraInfo"><strong><cfoutput>#rsDirOficina.Atencion#</cfoutput></strong></td>
                    	</tr>
                        <tr>
                        	<td class="LetraInfo" nowrap="nowrap"><cfoutput>#rsDirOficina.ciudad#  #rsDirOficina.codigoPostal#</cfoutput></td>
                    	</tr>
                        
                    </cfif>
                    <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
        			<tr>
                        <td class="LetraTitulo" nowrap="nowrap"><cfoutput>#rsDatosfac.SNnombre#</cfoutput></td>
                    </tr>
                   
                    <tr>
                        <td class="LetraInfo"><cfoutput>#rsDatosfac.SNdireccion#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="LetraInfo"><cfoutput>#rsDatosfac.SNdireccion2#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="LetraInfo"><cfoutput>#rsDatosfac.dir#</cfoutput></td>
                    </tr>
                     <tr>
                      <td class="LetraTitulo" nowrap="nowrap">RFC <cfoutput>#rsDatosfac.SNidentificacion# #rsDatosfac.SNidentificacion2#</cfoutput></td>
                    </tr>
	        	</table>  
    	 	</td>
        </tr>
        <cfset PrintLineasHeader()>  
       	<cfif isdefined ("rsDatosfac") and rsDatosfac.recordCount gt 0>
            	<tr><td> #LB_Detalle# </td></tr>
        </cfif>
            <cfset PrintLineas()>
           
        
        <cfset PrintTotal()>  
        
        <cfset PrintFooter()>  
    </table>
</cfoutput>

<cffunction name="Printheader" output="yes">
    <tr>
    	<td  colspan="6" class="TituloPrincipal" align="center">#replace(Empresa.Edescripcion,'ñ','n')# #rsOficina.ODescripcion#</td>    
    </tr>
    <tr>
    	<H2>   
    </tr>
    
    <tr>
    	<td colspan="6">&nbsp;</td>
    </tr>
</cffunction>

<cffunction name="PrintLineasHeader">
    <tr><td colspan="5"><hr style="border-top-width: 2px;"></hr></td><tr>  
    <tr>
    <cfif rsDatosfac.OIEstado EQ 'I'>
    	<cfset docs=#rsDatosfac.PFDocumento#>
    <cfelse>
		<cfif rsDatosfac.CCTcodigo EQ 'FC' OR rsDatosfac.CCTcodigo EQ 'FA'> <cfset docs='#LB_Factura# #rsDatosfac.PFDocumento#'>
        <cfelseif rsDatosfac.CCTcodigo EQ 'NC'> <cfset docs='#LB_NOTACREDITO# #rsDatosfac.PFDocumento#'>
        <cfelseif rsDatosfac.CCTcodigo EQ 'ND'> <cfset docs='#LB_NOTADEBITO# #rsDatosfac.PFDocumento#'>
        </cfif>
    </cfif>    
        <td class="LetraEncab" align="left"><strong><cfoutput>#LB_Documento#: #docs#</cfoutput></strong></td>
    </tr>
    <tr><td class="LetraEncab"  align="left"><cfoutput>#LB_DiasVigenciaFechaEmision#: #Dateformat(rsDatosfac.OIvencimiento,'dd/mm/yyyy')#</cfoutput></td> </tr>
    <tr><td colspan="5"><hr style="border-top-width: 2px;"/></td><tr>
</cffunction>

<cffunction name="PrintLineas" output="yes">
    <tr>
    	<td colspan="5" >
        	<table border="0" align="center" width="100%" cellpadding="0" cellspacing="5"> 
            <cfloop query="rsDatosFac">
               <tr><td  width ="100%" class="LetraInfo" align="justify" ><p>#rsDatosFac.OIDdescripcion# #rsDatosFac.OIDdescnalterna#</p></td></tr>
            </cfloop>
  			</table>
  		</td>
    </tr>    
</cffunction>	

<cffunction name="PrintTotal" output="yes">
    
    <tr><td colspan="5"><hr style="border-top-width: 2px;"/></td><tr>  

       <tr>  <!---<td colspan="5"> ---> 
             <table border="0" align="center" width="100%" cellpadding="0" cellspacing="3">  
                <!---<tr>
                    <td width="100%" colspan="6">&nbsp;</td>
                   <!--- <td class="LetraTitulo" align="left">&nbsp;</td>--->
                </tr>--->
                <tr>
                	<!---<td colspan="5">&nbsp;</td>--->
                    <td width="82%" align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">#LB_SubTotal#:</td>
                    <td align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">#LSCurrencyFormat(rsDatosFac.OIsubtotal, 'none')#</td>
                </tr>
                
                <!---<cfloop query="rsDatosFac">--->
                <tr>
                	<!---<td colspan="5">&nbsp;</td>--->
                    <td align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">#LB_Impuesto#
                      <cfif rsDatosFac.recordCount EQ 1>
                    	 #rsImpuestos.Idescripcion#
                    </cfif>
                   
                    : </td><td width="18%" align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">#LSCurrencyFormat(rsDatosFac.OIimpuesto, 'none')#</td>
                </tr>
                <!---</cfloop>--->
                <cfif rsDatosFac.OIdescuento GT 0>
                <tr>
                	<!---<td colspan="5">&nbsp;</td>--->
                    <td  align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">#LB_Descuento#:</td>
                <td align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">#LSCurrencyFormat(rsDatosFac.OIdescuento, 'none')#</td>    
                </tr>
                </cfif>
                
                <cfif rsOImpresion.mRet EQ 1>
                 <tr>
                	<!---<td colspan="5">&nbsp;</td>--->
                    <td  align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">Impuesto Retenido #rsRetenciones.Rporcentaje#%:</td>
                   <cfset retencion =  (rsDatosFac.OIsubtotal*rsRetenciones.Rporcentaje)/100> 
                   <cfset total = rsDatosFac.OIsubtotal - retencion + rsDatosFac.OIimpuesto>
                <td align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">- #LSCurrencyFormat(retencion, 'none')#</td>    
                </tr>
                </cfif>
                <tr>
                	<!---<td colspan="5">&nbsp;</td>--->
                    <td width="80%" align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">TOTAL:</td>
                    
                    <cfif rsOImpresion.mRet EQ 1>
                    	<cfset total = rsDatosFac.OIsubtotal - retencion + rsDatosFac.OIimpuesto>
                    
                    <cfelse>
                    	<cfset total = rsDatosFac.OItotal>
                    <!---<td width="18%" align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif; ">#rsDatosFac.Msimbolo# #LSCurrencyFormat(rsDatosFac.OItotal, 'none')#</td>--->
                    </cfif>
                    <td width="18%" align="right" nowrap="nowrap" class="LetraTitulo" style="font-size:12px; font-family:Verdana, Geneva, sans-serif; ">#rsDatosFac.Msimbolo# #LSCurrencyFormat(total, 'none')#</td>
                </tr>
                </table>
                <tr>
                	<td width="100%">
                        <table width="100%">
                            <tr>
                              <cfif rsOImpresion.mRet EQ 1>
                                <cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
                                    <cfinvokeargument name="Monto" value="#total#">
                                </cfinvoke>
                              <cfelse>  
                                <cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
                                    <cfinvokeargument name="Monto" value="#rsdatosfac.Oitotal#">
                                </cfinvoke>
                              </cfif>  
                                 <td   class="LetraTitulo" style="font-size:10px; font-family:Verdana, Geneva, sans-serif; ">#Ucase(LB_TotalLetra)#: #Ucase(MontoLetras)# #rsDatosFac.Mnombre#<cfif rsDatosFac.OItotal GT 1>s</cfif> </td>
                 
                </tr>
                        </table>
                    </td>    
                </tr>
    	</td>  
    </tr>  
</cffunction> 

<cffunction name="PrintFooter" output="yes">
    <tr><td colspan="5"><hr style="border-top-width: 2px;" /></td><tr>  
    <tr><td>
    	<table align="center" width="100%" border="0">
    		<tr>
            	<td class="LetraInfo" align="left" colspan="2" nowrap="nowrap"><strong>#LB_Observaciones#</strong></td>
            </tr>
            <tr>
              <td class="LetraInfo" align="left" colspan="2" nowrap="nowrap"><strong>#rsDatosFac.Observaciones# #rsDatosFac.OIObservacion#</strong></td>
            </tr>
            
         </table>
         <tr><td colspan="6"><hr style="border-bottom-width: 2px;" /></td><tr>  
    </td> </tr>
    
        <tr>
            <td colspan="5"> 
            	<table align="center" width="100%" border="0">
                	<tr>
                    	<td class="LetraInfo" align="left" colspan="2" nowrap="nowrap"><strong>#rsBanco.Bdescripcion#</strong></td>
                    </tr>
                    <tr>    
                        <td class="LetraInfo" align="left" colspan="2" nowrap="nowrap"><strong>#rsBanco.Bdireccion#</strong></td>
                    </tr>

                     <tr>    
                        <td class="LetraInfo" align="left" colspan="1" nowrap="nowrap"><strong>#LB_Cuenta# #rsBanco.BcodigoIBAN#</strong></td>
                    </tr>
                    
                </table>
            </td>
        </tr>   
</cffunction>

<cfif rsDatosfac.OIEstado EQ 'I'>
<cfquery datasource="#Session.DSN#" name="rsPeriodo">
		select ltrim(rtrim(Pvalor)) as Periodo from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 50
	</cfquery>

	<cfquery name="rsfolioFac" datasource="#session.dsn#">
    	select  Folio from FAFoliosSES
        where Ecodigo=#session.Ecodigo#
        and Oficina=#rsDatosfac.Ocodigo#
        and Periodo=#rsPeriodo.Periodo#
        and Transaccion = '#rsDatosfac.CCTcodigo#'
    </cfquery>

	<cfif rsfolioFac.recordCount EQ 0>  
    	<cfquery  name="insFolioNP" datasource="#session.dsn#">
        	insert into FAFoliosSES (Ecodigo,Oficina,Folio,Periodo,Transaccion)
            values (#session.Ecodigo#,#rsDatosfac.Ocodigo#,0,#rsPeriodo.Periodo#,'#rsDatosfac.CCTcodigo#')
        </cfquery>
        <cfquery name="rsfolioFac" datasource="#session.dsn#">
    	select  Folio from FAFoliosSES
        where Ecodigo=#session.Ecodigo#
        and Oficina=#rsDatosfac.Ocodigo#
        and Periodo=#rsPeriodo.Periodo#
        and Transaccion='#rsDatosfac.CCTcodigo#'
    </cfquery>
    </cfif>

	<cfquery  name="upOI" datasource="#session.DSN#">
        	update FAEOrdenImpresion
            set OIEstado = 'R'
            where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>    
    
	<cfset folio='#rsDatosfac.CCTcodigo#/#trim(rsOficina.Oficodigo)#/#LSNumberFormat(rsfolioFac.Folio+1,'000')#/#rsPeriodo.Periodo#'>  
      
    <cfquery name="folioFactura" datasource="#session.dsn#">
    	update FAPreFacturaE
		set PFDocumento='#folio#'
		where Ecodigo=#session.Ecodigo# 
        and DdocumentoREF=(select OIdocumento from FAEOrdenImpresion where Ecodigo=#session.Ecodigo# and OImpresionID= #OImpresionID#)
    </cfquery>
    
    <cfquery name="actFolioFactura" datasource="#session.dsn#">
    	update    FAFoliosSES
        set Folio=#rsfolioFac.Folio#+1
        where Ecodigo=#session.Ecodigo#
        and Oficina=#rsDatosfac.Ocodigo#
        and Periodo=#rsPeriodo.Periodo#
        and Transaccion='#rsDatosfac.CCTcodigo#'
    </cfquery>
    

</cfif>    
