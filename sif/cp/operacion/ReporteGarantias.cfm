<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">

<style type="text/css">
<!--
.style1 {color: #FFFFFF}
-->
</style>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Garantías Asociadas'>

<cfif isdefined("Url.Documento") and len(trim(Url.Documento))>
	<cfset IDocumento = Url.Documento>
</cfif>
<table align="center" border="0" cellpadding="2" cellspacing="2" width="100%">				
        <cfquery name="rsOrdenes" datasource="#Session.DSN#">				
		select distinct c.TGidC, a.EOidorden
              from DOrdenCM a
                   inner join CMLineasProceso b
                        on b.ESidsolicitud = a. ESidsolicitud 
                          and b.DSlinea = a.DSlinea
                   inner join CMProcesoCompra c
                        on c.CMPid = b.CMPid                   
                   inner join    DDocumentosCxP d
                        on d.DOlinea = a.DOlinea 	
              where 
                   a.Ecodigo = #session.Ecodigo#
              and d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric"  value= "#rtrim(url.documento)#">
              and not c.TGidC is null    						 
		</cfquery>
		<cfif rsOrdenes.recordcount gt 0>
		<cfloop query="rsOrdenes">		  
		  <cfquery name="rsGarantiaRequerida" datasource="#session.dsn#">
		      select TGdescripcion, c.EOtotal,  d.Miso4217,
				 case  when TGmanejaMonto  = 1 then 
						   TGmonto
					   else  			   
						   TGporcentaje 
				  end as Valor,
				  case  when TGmanejaMonto  = 1 then 
						b.Miso4217
				   else  			   
					   '%'
				  end as Moneda ,
				  case  when TGmanejaMonto  = 1 then 
						TGmonto
				   else  			   
					  c.EOtotal * TGporcentaje /100
				  end as MontoReq ,
				  case  when TGmanejaMonto  = 1 then 
						b.Miso4217
				   else  			   
					  d.Miso4217
				  end as MonedaR
			   from TiposGarantia a
			   left outer join Monedas b
				  on a.Mcodigo = b.Mcodigo
				inner join EOrdenCM c
				  on c.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric"  value= "#rsOrdenes.EOidorden#">
				inner join Monedas d
				   on c.Mcodigo = d.Mcodigo  
				  
				where TGid = <cfqueryparam cfsqltype="cf_sql_numeric"  value= "#rsOrdenes.TGidC#">
		  </cfquery>
		  
		
		  <cfquery name="rsProcesoCompra" datasource="#session.dsn#">
		   select distinct a.DSlinea, c.CMPid, s.SNcodigo
				 from DOrdenCM a
				 inner join CMDProceso b
					 on a.DSlinea = b.DSlinea and a.ESidsolicitud = b.ESidsolicitud
				 inner join CMProceso c
					 on b.CMPid = c.CMPid
				 inner join EOrdenCM d
					 on d.EOidorden = a.EOidorden
				 inner join SNegocios s
				on d.SNcodigo = s.SNcodigo
				 inner join COHEGarantia e
					 on e.CMPid = c.CMPid and e.SNid = s.SNid
			where a.Ecodigo = #session.Ecodigo#
			 and a.EOidorden        = <cfqueryparam cfsqltype="cf_sql_numeric"  value= "#rsOrdenes.EOidorden#">
			 and e.COEGTipoGarantia   = 2
			 and e.COEGVersionActiva = 1
			group by a.DSlinea, c.CMPid, s.SNcodigo
 		<!---	having count(a.DSlinea) <= (
                     select count(1)
                         from DOrdenCM a
                         where a.Ecodigo    = #session.Ecodigo#
                         and a.EOidorden = <cfqueryparam cfsqltype= "cf_sql_numeric"  value="#rsOrdenes.EOidorden#" >)--->
		  </cfquery>		  
		</cfloop>
		  <cfif rsProcesoCompra.recordcount  gt 0>
		  <cfquery name="rsGarantia" datasource="#session.dsn#">
		   select distinct b.COEGid,  a.COEGVersion 	
			  from COHEGarantia a
     			inner join COHDGarantia b
      				on b.COEGid = a.COEGid and b.Ecodigo = a.Ecodigo and a.COEGVersion = b.COEGVersion
     			inner join SNegocios c
      				on c.SNid = a.SNid
                       where a.Ecodigo    = #session.Ecodigo#
                          and a.CMPid                    = <cfqueryparam cfsqltype= "cf_sql_numeric"  value= "#rsProcesoCompra.CMPid#" >
                          and a.COEGTipoGarantia   = 2
                          and a.COEGVersionActiva   = 1
                          and c.SNcodigo            = <cfqueryparam cfsqltype= "cf_sql_numeric"  value= "#rsProcesoCompra.SNcodigo#" >        
    	  </cfquery>		 
		  </cfif>
		<cfelse>
		<tr>
		      <td colspan="3">&nbsp;</td>
		</tr>
		<tr>	  
			  <td colspan="3" align="center"><strong>------------ No hay registros para mostrar ------------</strong></td>
		</tr>
		<cfabort>	  
		</cfif>			

 <cfif rsProcesoCompra.recordcount  gt 0>
  <cfif rsGarantia.recordcount gt 0>
     <tr >
		  <td colspan="3" align="left"><cfoutput><strong>Garantía Requerida: </strong>#rsGarantiaRequerida.TGDescripcion#</cfoutput></td>
		  <td  align="center"><cfoutput>#LsNumberFormat(rsGarantiaRequerida.Valor,'9,999.99')# #rsGarantiaRequerida.Moneda#</cfoutput></td>	
	</tr>
  <tr >
		  <td colspan="3" align="left"><cfoutput><strong>Monto Contrato/OC: </strong>#LsNumberFormat(rsGarantiaRequerida.EOtotal,'9,999.99')# #rsGarantiaRequerida.Miso4217#</cfoutput></td>
		  <td  colspan="3" align="center"><cfoutput>Monto Requerido #LsNumberFormat(rsGarantiaRequerida.MontoReq,'9,999.99')# #rsGarantiaRequerida.MonedaR#</cfoutput></td>	
	</tr>
	 <tr >
	 	<td>&nbsp;  </td>
	 </tr>
  <cfloop query="rsGarantia">
        <cfquery name="rsEncabezadoGarantia" datasource="#Session.DSN#">
              select
			       distinct a.COEGid,a.COEGReciboGarantia, m.Miso4217 as Mnombre,a.COEGMontoTotal		
			    from COHEGarantia a     			   
					inner join Monedas m
						  on a.Mcodigo = m.Mcodigo
					inner join SNegocios c
						on c.SNid = a.SNid	  
				where a.COEGid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGarantia.COEGid#">	
				    and a.COEGVersion =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGarantia.COEGVersion#">		
				    and a.Ecodigo = #session.ecodigo#	
					 and a.COEGTipoGarantia   = 2
                          and a.COEGVersionActiva   = 1
                          and c.SNcodigo            = <cfqueryparam cfsqltype= "cf_sql_numeric"  value= "#rsProcesoCompra.SNcodigo#" >				
    	  </cfquery>	
   <cfif rsEncabezadoGarantia.recordcount gt 0>	 
  	 <cfloop query="rsEncabezadoGarantia">	  
	       <tr bgcolor="#999999">
			  <td align="center"><strong>Recibo Garantía</strong></td>
			  <td align="center"><strong>Moneda</strong></td>
			  <td align="center"><strong>Monto Total</strong></td>		      			    			    
			</tr>	
 
	    	<tr bgcolor="#CCCCCC">
			  <td align="center"><cfoutput>#rsEncabezadoGarantia.COEGReciboGarantia#</cfoutput></td>
			  <td align="center"><cfoutput>#rsEncabezadoGarantia.Mnombre#</cfoutput></td>
			  <td align="center"><cfoutput>#LsNumberFormat(rsEncabezadoGarantia.COEGMontoTotal,'9,999.99')#</cfoutput></td>		      			    			    
			</tr>
		 	<cfquery name="rsDetalleGarantia" datasource="#Session.DSN#">
              select
			       distinct a.COEGid,a.CODGNumeroGarantia,ct.COTRDescripcion,b.Bdescripcion,a.CODGMonto,m.Miso4217 as Mnombre,a.CODGFechaFin 				
			    from COHDGarantia a   
				inner join COTipoRendicion ct
				      on a.COTRid = ct.COTRid   
				inner join Bancos b
				       on a.Bid = b.Bid		   
				inner join Monedas m
				      on a.CODGMcodigo = m.Mcodigo
				where a.COEGid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGarantia.COEGid#">		
				    and a.COEGVersion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGarantia.COEGVersion#">		
				    and a.Ecodigo = #session.ecodigo#					
      		</cfquery>
		<cfif rsDetalleGarantia.recordcount gt 0>
				<tr bgcolor="#99CCCC">
					  <td align="center"><strong>Número Garantía</strong></td>
					  <td align="center"><strong>Tipo Rendición</strong></td>
					  <td align="center"><strong>Banco</strong></td>
					  <td align="center"><strong>Monto</strong></td>
					  <td align="center"><strong>Moneda</strong></td>			      			    			    
					  <td align="center"><strong>Fecha Vencimiento</strong></td>
				</tr>
				<cfloop query="rsDetalleGarantia">
					<tr >
						  <td align="center"><cfoutput>#rsDetalleGarantia.CODGNumeroGarantia#</cfoutput></td>
						  <td align="center"><cfoutput>#rsDetalleGarantia.COTRDescripcion#</cfoutput></td>
						  <td align="center"><cfoutput>#rsDetalleGarantia.Bdescripcion#</cfoutput></td>	
						  <td align="center"><cfoutput>#LsNumberFormat(rsDetalleGarantia.CODGMonto,'9,999.99')#</cfoutput></td>
						  <td align="center"><cfoutput>#rsDetalleGarantia.Mnombre#</cfoutput></td>
						  <td align="center"><cfoutput>#DateFormat(rsDetalleGarantia.CODGFechaFin,'dd-mm-yyyy')#</cfoutput></td>	      			    			    
					</tr>
			  </cfloop>
	    </cfif>
      </cfloop>
   </cfif>
  </cfloop>	
  </cfif>
 </cfif>  


</table>		
<cf_web_portlet_end>
