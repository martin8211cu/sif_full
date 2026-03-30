<style type="text/css">
	.TitulosReporte{
		font-weight:bold;		
	}
   	.header{		
        border-bottom: 1px solid #0079c1;
        padding-bottom: 0;
		font-weight:bold;
	}
	.lineas{
		 background:#D9E6E9;
		 font-weight:bold;
	}	
   .subtotal{		
		 font-weight:bold;
	}		
	
</style>
<style media="print">
.botonera
     {
	 display:none;
	 }	 
</style>
<cf_dbfunction name="op_concat" returnvariable="_CNCT">
<cf_templateheader title="#Request.Translate('ModuloFA','Facturación','/sif/Utiles/Generales.xml')#">
	<cfinclude template="/sif/portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Reporte de Documentos de Cierre">
        <cfif isdefined('url.caja') and len(trim(url.caja)) gt 0>
           <cfset form.FCid = url.caja>
        </cfif>
           <cfset parametros = 'reporteCierre.cfm?1=1'>
          	<cfif isdefined('form.FCid') and len(trim(#form.FCid#)) gt 0>
			  <cfset parametros = parametros&'&caja=#form.FCid#'>
            </cfif>
          <cfset FileName        = "DocumentosCierre">
          <cfset FileName 	   = FileName & ".xls">
          <cf_htmlreportsheaders title="Reporte de Documentos de Cierre" filename="#FileName#" download="yes" ira="#parametros#" >
           <!--- monedas registradas en pagos --->
			<cfquery name="rsMonedasP" datasource="#session.DSN#">
				select distinct a.Mcodigo, c.Mnombre , c.Miso4217, c.Msimbolo 
				from ETransacciones a
                 inner join Monedas c
                    on a.Mcodigo=c.Mcodigo
                  and a.Ecodigo = c.Ecodigo                     
				where  a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and a.ETestado='C'
				  and a.FACid is null
                 union all 
               select distinct a.Mcodigo, c.Mnombre , c.Miso4217, c.Msimbolo 
				from HPagos a 
                 inner join Monedas c
              	  on a.Mcodigo=c.Mcodigo
                  and a.Ecodigo = c.Ecodigo
				where a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and a.FACid is null                 
                  and a.Mcodigo not in ( select distinct Mcodigo
                                            from ETransacciones 
                                          where  FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                              and ETestado='C'
                                              and FACid is null
                                         )
        <cf_isolation nivel="read_committed">
			</cfquery>
            
            <!--- descripcion de la caja--->
			<cfquery name="rsCaja" datasource="#session.DSN#">
				select rtrim(FCcodigo)+', '+FCdesc as FCcaja 
				from FCajas 
				where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
			</cfquery>
            
            <cfset rsMonedas = QueryNew("Mcodigo, Mnombre,Miso4217, Msimbolo")>
			<!--- Moneas registradas en los pagos--->
			<cfloop query="rsMonedasP">
				<!--- Agrega la fila procesada --->
				<cfset fila = QueryAddRow(rsMonedas, 1)>
				<cfset tmp  = QuerySetCell(rsMonedas, "Mcodigo", #rsMonedasP.Mcodigo#) >
				<cfset tmp  = QuerySetCell(rsMonedas, "Mnombre", #rsMonedasP.Mnombre#) >
                <cfset tmp  = QuerySetCell(rsMonedas, "Miso4217", #rsMonedasP.Miso4217#) >
                <cfset tmp  = QuerySetCell(rsMonedas, "Msimbolo", #rsMonedasP.Msimbolo#) >
			</cfloop>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <cfoutput>	
			  <tr> 
				<td colspan="3"><div align="center"><strong><font size="2">Caja: #rsCaja.FCcaja#</font></strong></div></td>
			  </tr>
			  <tr> 
				<td colspan="3"><div align="center"><strong><font size="2">Fecha de reporte: #LSDateFormat(Now(), 'dd/mm/yyyy')#</font></strong></div></td>
			  </tr>
              </cfoutput>
              </table>
            <cfloop query="rsMonedas">
						<cfquery name="rsPagos" datasource="#session.dsn#">
						select              et.ETnumero,
                                et.ETserie #_CNCT# ' ' #_CNCT#   <cf_dbfunction name="to_char" args="et.ETdocumento">  as documento,
                                et.ETfecha as fecha,
                                et.ETtotal as MontoOriginal,                              
                                  m.Msimbolo,m.Miso4217,
                                  'Facturas de contado' as Origen
                                  , 'F' as tipo
                                  ,m.Mcodigo
                                 ,coalesce(et.ETnombredoc,sn.SNnombre) as nombreDoc                                  
                                from  ETransacciones et                                 
                                inner join Monedas m
                                  on  et.Mcodigo = m.Mcodigo 
                                  and et.Ecodigo = m.Ecodigo
                                inner join CCTransacciones ct
                                  on et.CCTcodigo = ct.CCTcodigo
                                 and et.Ecodigo   = ct.Ecodigo 
                                inner join SNegocios sn
                                     on et.SNcodigo = sn.SNcodigo
                                    and et.Ecodigo  = sn.Ecodigo
                               where et.Mcodigo = #Mcodigo#
                                and et.ETesLiquidacion = 0
                                and et.FACid IS NULL
                                and et.ETestado = 'C' 
                                and ct.CCTvencim = -1
                                and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                            UNION ALL 
                            select 
                                et.ETnumero,
                                et.ETserie #_CNCT# ' ' #_CNCT#   <cf_dbfunction name="to_char" args="et.ETdocumento">  as documento,
                                et.ETfecha as fecha,
                                et.ETtotal as MontoOriginal,                              
                                  m.Msimbolo,m.Miso4217,
                                  'Facturas de crédito' as Origen
                                  , 'H' as tipo
                                  ,m.Mcodigo
                                 ,coalesce(et.ETnombredoc,sn.SNnombre) as nombreDoc                                  
                                from  ETransacciones et                                 
                                inner join Monedas m
                                  on  et.Mcodigo = m.Mcodigo 
                                  and et.Ecodigo = m.Ecodigo
                                inner join CCTransacciones ct
                                  on et.CCTcodigo = ct.CCTcodigo
                                 and et.Ecodigo   = ct.Ecodigo 
                                inner join SNegocios sn
                                     on et.SNcodigo = sn.SNcodigo
                                    and et.Ecodigo  = sn.Ecodigo
                               where et.Mcodigo = #Mcodigo#
                                and et.ETesLiquidacion = 0
                                and et.FACid IS NULL
                                and et.ETestado = 'C' 
                                and coalesce(ct.CCTvencim,0) <> -1
                                and ct.CCTtipo = 'D'
                                and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                            UNION ALL                                                          
                          select
                           '0' as ETnumero, 
                           l.NumLote as documento,
                           l.Fecha,
                            coalesce((select sum(ETtotal)
                            from FALiquidacionRuteros a
                            LEFT join ETransacciones b
                               on a.NumLote = b.ETlote
                              and a.Ecodigo = b.Ecodigo  
                            WHERE b.ETesLiquidacion = 1
                            and a.NumLote = l.NumLote
                            and a.FCid = l.FCid
                            and b.FACid IS NULL
                            and b.ETestado = 'C' 
                            and b.Mcodigo = #Mcodigo#),0)
                            + coalesce((
                            select sum(Ptotal)
                            from FALiquidacionRuteros a
                            inner join HPagos c
                               on a.NumLote = c.Plote
                              and a.Ecodigo = c.Ecodigo
                            and c.PesLiquidacion = 1
                            and c.Plote = l.NumLote
                            and c.FCid = l.FCid
                            and c.Mcodigo = #Mcodigo#),0)
                            as MontoOriginal,
                            (select m.Msimbolo from Monedas m 
                             where Ecodigo = #session.Ecodigo# 
                             and Mcodigo = #Mcodigo#) as Msimbolo,
                             (select m.Miso4217 from Monedas m 
                             where Ecodigo = #session.Ecodigo# 
                             and Mcodigo = #Mcodigo#) as Miso4217,                          
                           'Liquidacion cobradores' as Origen
                          , 'L' as tipo
                         ,#Mcodigo# as Mcodigo                        
                         ,de.DEnombre #_CNCT# ' ' #_CNCT#  de.DEapellido1 #_CNCT# ' '  #_CNCT#   de.DEapellido2 #_CNCT# ' - '  #_CNCT# l.Descripcion   as nombreDoc    
                     from     FALiquidacionRuteros l
                      inner join DatosEmpleado de
                        on l.DEid = de.DEid
                    where l.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">                
                     and l.FACid is null
                     and l.estado = 'P'                                                        
                            UNION ALL 
                            select distinct  
                                '0' as ETnumero,                           
                               p.Pserie #_CNCT# ' ' #_CNCT#  coalesce(<cf_dbfunction name="to_char" args="p.Pdocumento">, p.Pcodigo)  as documento, 
                                 p.Pfecha as fecha, 
                                 p.Ptotal as MontoOriginal,                             
                                 m.Msimbolo,m.Miso4217,
                                 'Recibos' as Origen 
                                 ,'R' as tipo
                                 ,m.Mcodigo
                                 ,sn.SNnombre as nombreDoc
                                from  HPagos p    
                               inner join Monedas m
                                on p.Mcodigo = m.Mcodigo 
                               and p.Ecodigo = m.Ecodigo
                               inner join SNegocios sn
                                on p.SNcodigo = sn.SNcodigo
                               and p.Ecodigo  = sn.Ecodigo                               
                                where p.Mcodigo = #Mcodigo# 
                                 and PesLiquidacion = 0
                                 and coalesce(PfacturaContado,'N') = 'N'
                                 and p.FACid IS NULL
                                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                           UNION ALL 
                            select distinct    
                              '0' as ETnumero,                            
                               bm.CCTcodigo #_CNCT# ' ' #_CNCT# bm.Ddocumento  as documento, 
                                 p.Pfecha as fecha, 
                                 p.Ptotal as MontoOriginal,                             
                                 m.Msimbolo,m.Miso4217,
                                 'Devolucion' as Origen 
                                 ,'D' as tipo
                                 ,m.Mcodigo
                                 ,sn.SNnombre as nombreDoc
                                from  HPagos p    
                               inner join Monedas m
                                on p.Mcodigo = m.Mcodigo 
                               and p.Ecodigo = m.Ecodigo
                              inner join BMovimientos bm
                                 on p.CCTcodigo = bm.CCTRcodigo
                               and p.Pcodigo = bm.DRdocumento
                               and p.Ecodigo = bm.Ecodigo
                               inner join SNegocios sn
                                on p.SNcodigo = sn.SNcodigo
                               and p.Ecodigo  = sn.Ecodigo                               
                                where p.Mcodigo = #Mcodigo# 
                                 and PesLiquidacion = 0
                                 and coalesce(PfacturaContado,'N') = 'D'
                                 and p.FACid IS NULL
                                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                            UNION ALL 
                            select 
                                '0' as ETnumero, 
                                et.ETserie #_CNCT# ' ' #_CNCT#   <cf_dbfunction name="to_char" args="et.ETdocumento">  as documento,
                                et.ETfecha as fecha,
                                et.ETtotal as MontoOriginal,
                                  m.Msimbolo, m.Miso4217,
                                  'Credito' as Origen 
                                  , 'C' as tipo
                                  ,m.Mcodigo
                                 ,coalesce(et.ETnombredoc,sn.SNnombre) as nombreDoc                                  
                                from  ETransacciones et    
                                 inner join Monedas m
                                   on et.Mcodigo = m.Mcodigo 
                                  and et.Ecodigo = m.Ecodigo
                                 inner join SNegocios sn
                                   on et.SNcodigo = sn.SNcodigo
                                  and et.Ecodigo  = sn.Ecodigo                                  
                                inner join CCTransacciones ct 
                                  on et.CCTcodigo = ct.CCTcodigo
                                 and et.Ecodigo = ct.Ecodigo
                              where et.Mcodigo = #Mcodigo#
                                and et.FACid IS NULL
                                and et.ETestado = 'C' 
                                and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                and et.ETesLiquidacion = 0
                                and ct.CCTtipo = 'C'
                                <!---and ct.CCTvencim <> -1--->
                             order by tipo,fecha
                <cf_isolation nivel="read_committed">
						</cfquery>   
                     
                       <cfif rsPagos.recordcount gt 0>                    
                         <cfoutput>	
                            
                       
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td colspan="5" align="left"><h4 class="header">#Mnombre# (#Miso4217#)</h4></td>
                              </tr>
                              <tr>
                                 <td></td>
                                 <td class="TitulosReporte">Documento</td>                                 
                                 <td class="TitulosReporte">Fecha</td>
                                 <td class="TitulosReporte">Cliente/Socio</td>
                                 <td class="TitulosReporte">Tipo Pago</td>
                                 <td class="TitulosReporte">Referencia</td>
                                 <td class="TitulosReporte">Monto</td>
                              </tr>
                            <cfset cambio = ''>  
                            <cfset Montocambio = -0>  
                            <cfset TotalMonedas = 0>                                   
                            <cfloop query="rsPagos">                              
                               <cfif cambio neq rsPagos.tipo>  
                                   <cfif Montocambio neq -0> 
                                     <tr>
                                        <td colspan="5">&nbsp;</td>                                     
                                     </tr> 
                                     <tr>
                                         <td colspan="4">
                                         </td>
                                         <td class="subtotal">Total: #LSCurrencyFormat(Montocambio,'none')#</td> 
                                          <cfset TotalMonedas += Montocambio>                                       
                                      </tr>   
                                       <cfset Montocambio = 0>                                      
                                    </cfif>
                                <tr class="lineas">
                                     <td align="center">
                                      <cfswitch expression="#Tipo#">
                                            <cfcase value="F">
                                                Facturas de Contado 
                                            </cfcase>
                                            <cfcase value="C">
                                                Notas de Credito 
                                            </cfcase>
                                            <cfcase value="R">
                                                Recibos
                                            </cfcase>
                                            <cfcase value="L">
                                                Liquidaciones
                                            </cfcase>
                                            <cfcase value="D">
                                                Devoluciones
                                            </cfcase>
                                             <cfcase value="H">
                                                Facturas de Credito
                                            </cfcase>												
									   </cfswitch>
                                     </td>
                                     <td colspan="4">
                                     </td>                                     
                                </tr>                                                                                                          
                                </cfif>
                                <cfquery  name="rsDetallesPagos" datasource="#session.dsn#">
                                  select coalesce(FPReferencia,'-') FPReferencia,  coalesce(FPMonto, 0) - coalesce(FPVuelto, 0) FPMonto,
                                          case when Tipo  = 'E' then
                                              'Efectivo'
                                          when Tipo = 'T' then 
                                              'Tarjeta'
                                          when Tipo = 'D' then
                                              'Deposito'
                                          when Tipo = 'C' then
                                              'Cheque'
                                          when Tipo = 'A' then 
                                              'Documento'
                                          when Tipo = 'F' then 
                                              'Diferencia'
                                          else
                                              '-'
                                          end            
                                          as Tipo
                                          from FPagos
                                          where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagos.ETnumero#">
                                </cfquery>
                                
                                <cfif rsDetallesPagos.recordcount gt 0>
                                    <cfloop query="rsDetallesPagos">
                                        <tr>
                                            <td></td>
                                            <td>#rsPagos.documento#</td>
                                            <td>#LSDateFormat(rsPagos.fecha,'DD/MM/YYYY hh:mm:ss')#</td>
                                            <td>#rsPagos.nombreDoc#</td>
                                            <td>#rsDetallesPagos.Tipo#</td>
                                            <td>#rsDetallesPagos.FPReferencia#</td>
                                            <td>
                                              <cfif rsDetallesPagos.FPMonto eq 0>
                                                #LSCurrencyFormat(rsPagos.MontoOriginal,'none')#
                                              <cfelse>
                                                #LSCurrencyFormat(rsDetallesPagos.FPMonto,'none')#
                                              </cfif>
                                            </td>                                     
                                        </tr>
                                    </cfloop>
                                <cfelse>
                                  <tr>
                                     <td></td>
                                     <td>#rsPagos.documento#</td>
                                     <td>#LSDateFormat(rsPagos.fecha,'DD/MM/YYYY hh:mm:ss')#</td>
                                     <td>#rsPagos.nombreDoc#</td>
                                     <td>-</td>
                                     <td>-</td>
                                     <td>#LSCurrencyFormat(rsPagos.MontoOriginal,'none')#</td>                                     
                                  </tr>
                                </cfif>
                                 
                                <cfif rsPagos.recordcount eq rsPagos.currentrow>
                                   <cfset Montocambio += MontoOriginal>	
                                    <tr>
                                        <td colspan="5">&nbsp;</td>                                     
                                     </tr> 
                                     <tr>
                                         <td colspan="6">
                                         </td>
                                         <td class="subtotal">Total: #LSCurrencyFormat(Montocambio,'none')#</td> 
                                          <cfset TotalMonedas += Montocambio>                                       
                                      </tr> 
                                </cfif>	
                                 <cfset cambio = Tipo>  <!---Asigna el tipo de transaccion, cuando cambia se imprime el titulo ----> 
                                 <cfset Montocambio += MontoOriginal>	
                                                         					   
                            </cfloop> <!---fin del loop de los pagos ----> 
                             <tr>
                                 <td colspan="3">
                                 </td>
                                 <td colspan="4" class="subtotal">Total por moneda #Miso4217#: #LSCurrencyFormat(TotalMonedas,'none')#</td>                                     
                              </tr>  
                            <cfset TotalMonedas = 0>                         
                     </cfoutput>
                </cfif>  <!---fin if si existen registros por monedas ---->                     
          </cfloop><!---fin Looop de las monedas ---->
                                   <tr>
                                     <td colspan="7" align="center">&nbsp;
                                     
                                     </td>                                                                        
                                 </tr>
                                 <tr>
                                     <td colspan="7" align="center">
                                     ----------- Fin del reporte  ---------------
                                     </td>                                                                        
                                 </tr>
                                 <tr>
                                     <td colspan="5" align="center">&nbsp;
                                     
                                     </td>                                                                        
                                 </tr>
                                 <tr class="botonera">
                                     <td colspan="7" align="center">
                                      <input type="button" class="btnAnterior" onclick="regresar();" name="btnAnterior" value="Regresar"/>
                                     </td>                                                                        
                                  </tr>
                       </table>
		<script type="text/javascript" language="javascript1.2">
			function regresar(){
			 window.location.assign("/cfmx/crc/cobros/operacion/CierreCaja.cfm");				
			}
		</script>
		<cf_web_portlet_end>
<cf_templatefooter> 