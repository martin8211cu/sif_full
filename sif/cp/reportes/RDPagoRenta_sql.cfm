 <cf_htmlreportsheaders
	  title="Reporte Declaración Pago Renta"  
	  irA="RDPagoRenta.cfm" 
	  filename="ReporteDeclaraciónPago_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" 
	  back="yes"
	  Download="yes"
	  >

	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
			Edescripcion,ts_rversion,
			Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		  select Enombre
			 from Empresa
		  where CEcodigo = #session.CEcodigo#
	 </cfquery>
	 
	<cfquery name="rsOficina" datasource="#session.dsn#">
		select 
			Ocodigo,
			Oficodigo,
			Odescripcion 
		from Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Ocodigo = #form.Ocodigo#
		order by Oficodigo
	</cfquery>
	 
	 <cfif isdefined ('form.tipoResumen') and #form.tipoResumen# eq 1>
	<cfset LvarColSpan = 6>
	<cfelse>
	<cfset LvarColSpan = 12>
	</cfif>
	
		 <cfset LvarSNnombre1 =  ''>
		 <cfset LvarSNcodigo1 = ''>
		 <cfset LvarSNnombre =  ''>
		 <cfset LvarSNcodigo =  ''>
		 <cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo)) gt 0>
			<cfquery name="rsProveedor" datasource="#session.dsn#">
				  select SNcodigo,SNnombre
					 from SNegocios
				  where SNcodigo = #form.SNcodigo#
				  and Ecodigo = #session.Ecodigo#
			 </cfquery>
			 <cfset LvarSNnombre =  #rsProveedor.SNnombre#>
			 <cfset LvarSNcodigo =  #rsProveedor.SNcodigo#>
		 </cfif>
						 
		<cfif isdefined('form.SNcodigo1') and len(trim(form.SNcodigo1)) gt 0>
			<cfquery name="rsProveedor2" datasource="#session.dsn#">
				  select SNcodigo,SNnombre
					 from SNegocios
				  where SNcodigo = #form.SNcodigo1#
				  and Ecodigo = #session.Ecodigo#
			</cfquery>
			 <cfset LvarSNnombre1 =  #rsProveedor2.SNnombre#>
			 <cfset LvarSNcodigo1 =  #rsProveedor2.SNcodigo#>
		</cfif>
					
		<cfif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo)) gt 0  and isdefined('form.SNcodigo1') and LEN(TRIM(form.SNcodigo1)) gt 0> 	
			<cfif #form.SNcodigo1# lt #form.SNcodigo#>
				<cfset LvarDato = #form.SNcodigo#>
				 <cfset form.SNcodigo  =  #form.SNcodigo1#>
				 <cfset form.SNcodigo1 =  #LvarDato#>
			</cfif>
		</cfif>
	
	<cfif form.mes neq ''>
		<cfswitch expression="#form.mes#">
			<cfcase value="1"><cfset vsMes = 'Enero'></cfcase>
			<cfcase value="2"><cfset vsMes  = 'Febrero'></cfcase>
			<cfcase value="3"><cfset vsMes  = 'Marzo'></cfcase>
			<cfcase value="4"><cfset vsMes  = 'Abril'></cfcase>
			<cfcase value="5"><cfset vsMes  = 'Mayo'></cfcase>
			<cfcase value="6"><cfset vsMes  = 'Junio'></cfcase>
			<cfcase value="7"><cfset vsMes  = 'Julio'></cfcase>
			<cfcase value="8"><cfset vsMes  = 'Agosto'></cfcase>
			<cfcase value="9"><cfset vsMes  = 'Setiembre'></cfcase>
			<cfcase value="10"><cfset vsMes  = 'Octubre'></cfcase>
			<cfcase value="11"><cfset vsMes  = 'Noviembre'></cfcase>
			<cfcase value="12"><cfset vsMes  = 'Diciembre'></cfcase>
		</cfswitch>
	</cfif>
	
	<cfif form.mes2 neq ''>
		<cfswitch expression="#form.mes2#">
			<cfcase value="1"><cfset vsMes2 = 'Enero'></cfcase>
			<cfcase value="2"><cfset vsMes2  = 'Febrero'></cfcase>
			<cfcase value="3"><cfset vsMes2  = 'Marzo'></cfcase>
			<cfcase value="4"><cfset vsMes2  = 'Abril'></cfcase>
			<cfcase value="5"><cfset vsMes2  = 'Mayo'></cfcase>
			<cfcase value="6"><cfset vsMes2  = 'Junio'></cfcase>
			<cfcase value="7"><cfset vsMes2  = 'Julio'></cfcase>
			<cfcase value="8"><cfset vsMes2  = 'Agosto'></cfcase>
			<cfcase value="9"><cfset vsMes2  = 'Setiembre'></cfcase>
			<cfcase value="10"><cfset vsMes2  = 'Octubre'></cfcase>
			<cfcase value="11"><cfset vsMes2  = 'Noviembre'></cfcase>
			<cfcase value="12"><cfset vsMes2  = 'Diciembre'></cfcase>
		</cfswitch>
	</cfif>
	
	<table width="80%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<cfoutput>
	  <tr>
			<td align="center" colspan="#LvarColSpan#"><font size="4"><strong>#rsEmpresa.Enombre#</strong></font></td>
	  </tr>					
	  <tr>
			<td nowrap class="tituloSub" align="center" colspan="#LvarColSpan#"><font size="4"><strong>Declaración Pago Renta  <cfif isdefined('form.SaldoCero')>(Montos Retención en Cero)</cfif></strong></font></td>
	  </tr>
	  <tr>
			<td align="center" colspan="#LvarColSpan#"><font size="4"><strong>Desde:&nbsp;#vsMes# - #periodo# hasta:&nbsp;#vsMes2# - #periodo2#</strong></font></td>
	  </tr>	
	  <tr>
			<td align="center" colspan="#LvarColSpan#"><font size="4"><strong>Oficina:&nbsp;<cfif isdefined('form.Ocodigo') and #form.Ocodigo# neq -1>(#rsOficina.Oficodigo#) - #rsOficina.Odescripcion#<cfelse>--Todas--</cfif></strong></font></td>
	  </tr>	
	  <cfif isdefined ('form.tipoResumen') and #form.tipoResumen# eq 2>
	  <tr>
			<td align="center" colspan="#LvarColSpan#"><font size="4"><strong>Proveedor Desde:&nbsp;(#LvarSNcodigo# - #LvarSNnombre#) Proveedor Hasta:&nbsp;(#LvarSNcodigo1# - #LvarSNnombre1#)</strong></font></td>
	  </tr>	
	  </cfif>
	  
	  </cfoutput>		
	  <tr><td colspan="6">&nbsp;</td></tr>
		<cfif  isdefined ('form.tipoResumen') and #form.tipoResumen# eq 1>
					 
			<cfquery datasource="#session.DSN#" name="rsDPagoRenta">
				select  sn.SNidentificacion as identificacionP,a.SNcodigo,sn.SNnombre as nombreP,sum(a.MontoR * a.Dtipocambio) retencion,sum(a.MTotal * a.Dtipocambio) totalFacturado
				from EDRetenciones enc 
					inner join DDRetenciones a 
						on enc.DRid = a.DRid 
					inner join SNegocios sn 
						on a.Ecodigo = sn.Ecodigo 
						and a.SNcodigo = sn.SNcodigo
					where enc.DRPeriodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
					and enc.DRPeriodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo2#">
						and (enc.DRPeriodo * 100 + enc.DRMes)  between #form.periodo*100+form.mes# and #form.periodo2*100+form.mes2#
						and enc.Ecodigo =  #session.Ecodigo#
						and enc.DREstado = 2
					<cfif isdefined('form.Ocodigo') and #form.Ocodigo# neq -1>
						and enc.Ocodigo  =  #form.Ocodigo#
					</cfif>
				group by  sn.SNidentificacion ,a.SNcodigo,sn.SNnombre		
			</cfquery>
				
			<tr class="tituloListas">
				<td nowrap="nowrap"><strong><font size="2">Identificación del Proveedor</font></strong>&nbsp;</td>
				<td nowrap="nowrap"><strong><font size="2">Nombre del Proveedor</font></strong>&nbsp;</td>
				<td nowrap="nowrap" align="center"><strong><font size="2">Total Facturado</font></strong>&nbsp;</td>
				<td nowrap="nowrap" align="center"><strong><font size="2">Monto Retención</font></strong>&nbsp;</td>
			</tr>
						
			<cfloop query="rsDPagoRenta">
				 <cfoutput>
					<tr class="<cfif rsDPagoRenta.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td  nowrap="nowrap">&nbsp;<font size="2">#identificacionP#</font></td>
						<td  nowrap="nowrap">&nbsp;<font size="2">#nombreP#</font></td>
						<td  x:numWith2Dec nowrap="nowrap" align="right"><font size="2">#LSNumberFormat(totalFacturado, ',9.00')#</font></td>
						<td  x:numWith2Dec nowrap="nowrap" align="right"><font size="2">#LSNumberFormat(retencion, ',9.00')#</font></td>
					 </tr>	
				</cfoutput>
			</cfloop>
			 <tr><td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td></tr>
			 <tr><td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">---  Fin del Reporte  ---</td></tr>
			 <tr><td colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td></tr>
				
		<cfelseif isdefined ('form.tipoResumen') and #form.tipoResumen# eq 2>
        
          <cfif isdefined('form.SaldoCero')>
           <cfset FechaI =  #CreateDate(form.periodo, form.mes,'01')#>
           <cfset FechaF =  #CreateDate(form.periodo2, form.mes2,'01')#>
		   <cfset FechaF =  #DateAdd('m',1,FechaF)#>        
		   <cfset FechaF =  #DateAdd('s',-1,FechaF)#>                 
                      
  			<cfquery datasource="#session.DSN#" name="rsDPagoRenta2"> 
            select  
                 'CP' as DROrigen,
                  e.IDdocumento,
                  e.Ddocumento as documento,
                  m.Miso4217 as Moneda,
                 sn.SNnombre,
				 sn.SNidentificacion,
                  e.Dtipocambio,
                  e.Dtotal as totallocal,
                 (e.Dtipocambio * e.Dtotal) as totOri,
                  e.EDmontoretori as MontoRetencion,
                 (e.Dtipocambio* e.EDmontoretori) as montolocal,                  
                  e.Dfecha as Pfecha,
                  coalesce(r.Rdescripcion,'--') as Tipo_Retencion,
                  '--' as Orden_Pago,
                  '--' as TESAPnumero
             from HEDocumentosCP e 
                   left outer join Retenciones r
                     on e.Rcodigo = r.Rcodigo 
                    and e.Ecodigo = r.Ecodigo 
                   inner join Monedas m
                     on e.Mcodigo = m.Mcodigo
                    and e.Ecodigo = m.Ecodigo 
                   inner join SNegocios  sn
					 on  e.Ecodigo 	= sn.Ecodigo
			  		 and e.SNcodigo = sn.SNcodigo 
                 where	
                  e.Ecodigo = #session.Ecodigo#
				<cfif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo)) gt 0  and isdefined('form.SNcodigo1') and LEN(TRIM(form.SNcodigo1)) gt 0>
					and sn.SNcodigo between #form.SNcodigo# and #form.SNcodigo1#
				<cfelseif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo)) gt 0>
					and sn.SNcodigo >= #form.SNcodigo#
				<cfelseif isdefined('form.SNcodigo1') and LEN(TRIM(form.SNcodigo1)) gt 0>
					and sn.SNcodigo <= #form.SNcodigo1#
				</cfif> 
                   and e.Dfecha between  <cfqueryparam cfsqltype="cf_sql_date" value="#FechaI#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#FechaF#">
                   <!---and CPTcodigo  ='FA'--->         
                    and e.Rcodigo is null
                 order by sn.SNcodigo   
            </cfquery>             
          <cfelse>   					 
			<cfquery datasource="#session.DSN#" name="rsDPagoRenta2">
				select 
					a.TESAPnumero,
					a.DROrigen,
					cb.CBcodigo, 
					cb.CBdescripcion,
					ba.Bdescripcion as bancoDescripcion,
					enc.CFid,
					cf.CFdescripcion, 
					cf.CFcodigo,
					enc.ts_rversion,
					enc.BTid,
					enc.DRNumConfirmacion,
					a.Dtipocambio,
					a.CPTRcodigo,
					ba.Bid as Bid,
					cb.CBcodigo,
					cb.CBid,
					cb.CBdescripcion,
					enc.Ocodigo,
					case enc.DREstado when 1 then 'Generado' when 2 then 'Aplicado' end as estado, 
					case enc.DRMes when 1 then 'Enero' when 2 then 'Febrero' 
					when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio'
					when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'
					end as mes, 
					enc.DRPeriodo as periodo,
					a.Ecodigo,
					a.Pfecha, 
					sn.SNnombre,
					sn.SNidentificacion,
					a.DRdocumento as documento,
					a.MTotal,
					coalesce(a.MontoR,0) as MontoRetencion,
					coalesce((a.MontoR * a.Dtipocambio),0) as montolocal,
					coalesce((a.MTotal * a.Dtipocambio),0) as totallocal,
					m.Miso4217 as Moneda,
					m.Mcodigo,
					a.CPTcodigo,
					a.Ddocumento as Orden_Pago,
					rt.Rcodigo, a.Rcodigo,
					Rdescripcion as Tipo_Retencion
				from EDRetenciones enc
					left outer join CuentasBancos cb 
					inner join Bancos ba
							on cb.Bid = ba.Bid 
							and cb.Ecodigo = ba.Ecodigo 
						on cb.CBid = enc.CBid 	
					left outer join CFuncional cf
						on cf.CFid=enc.CFid				
					inner join DDRetenciones a
						on enc.DRid = a.DRid
					inner join Retenciones rt
						on rt.Rcodigo = a.Rcodigo
						and rt.Ecodigo = a.Ecodigo
					inner join Monedas m
						on  a.Ecodigo 	= m.Ecodigo
						and a.Mcodigo 	= m.Mcodigo
					inner join SNegocios  sn
						on  a.Ecodigo 	= sn.Ecodigo
						and a.SNcodigo = sn.SNcodigo
				where enc.DRPeriodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
                and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				and enc.DRPeriodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo2#">
					and (enc.DRPeriodo * 100 + enc.DRMes)  between #form.periodo*100+form.mes# and #form.periodo2*100+form.mes2#
					and enc.Ecodigo =  #session.Ecodigo#
					and enc.DREstado = 2
				<cfif isdefined('form.Ocodigo') and #form.Ocodigo# neq -1>
					and enc.Ocodigo  =  #form.Ocodigo#
				</cfif>
				<cfif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo)) gt 0  and isdefined('form.SNcodigo1') and LEN(TRIM(form.SNcodigo1)) gt 0>
					and sn.SNcodigo between #form.SNcodigo# and #form.SNcodigo1#
				<cfelseif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo)) gt 0>
					and sn.SNcodigo >= #form.SNcodigo#
				<cfelseif isdefined('form.SNcodigo1') and LEN(TRIM(form.SNcodigo1)) gt 0>
					and sn.SNcodigo <= #form.SNcodigo1#
				</cfif>             
                 and a.MontoR > 0            
				order by sn.SNcodigo
			</cfquery>
			</cfif>	
				<cfset total_Local = 0>
				<cfset total_Retencion = 0>
				<cfset monto_Local = 0>
		
				<tr class="tituloListas">
					<td nowrap="nowrap" width="10%"><strong><font size="2">Origen</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Factura</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Id Proveedor</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Proveedor</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Total</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Moneda</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Monto Renta</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Mto RMLocal</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Orden Pago</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Fecha Pago</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Tipo Retención</font></strong>&nbsp;</td>
					<td nowrap="nowrap" width="10%"><strong><font size="2">Acuerdo Pago</font></strong>&nbsp;</td>
				</tr>
						
				<cfloop query="rsDPagoRenta2">
					<cfset LvarMonto = #numberformat(rsDPagoRenta2.totallocal, "9.00")#>
					<cfset total_Local = total_Local + #numberformat(LvarMonto, "9.00")#>
					
					<cfset LvarMontoR = #numberformat(rsDPagoRenta2.MontoRetencion, "9.00")#>
					<cfset total_Retencion = total_Retencion + #numberformat(LvarMontoR, "9.00")#>
					
					<cfset LvarMontoL = #numberformat(rsDPagoRenta2.montolocal, "9.00")#>
					<cfset monto_Local = monto_Local + #numberformat(LvarMontoL, "9.00")#>
 
                       
 
                  <cfset LvarOrden_Pago = '--'>
                  <cfset LvarTESAPnumero= '--'>
                  <cfset LvarPFecha = ''>
                  
				  <cfif isdefined('form.SaldoCero')>
                    
                    <cfquery name="rsDSolicitud" datasource="#session.dsn#">
                      select TESSPid from TESdetallePago where  TESDPidDocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">  and TESDPmoduloOri = 'CPFC'                 
                    </cfquery>				
                    
                       <cfif rsDSolicitud.recordcount gt 0 and len(trim(#rsDSolicitud.TESSPid#)) gt 0>                       
                            <cfquery name="rsSolicitud" datasource="#session.dsn#">
                               select TESOPid,TESAPid from TESsolicitudPago where  TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSolicitud.TESSPid#">                     
                            </cfquery>      
                            <cfif rsSolicitud.recordcount gt 0>
                                <cfif len(trim(#rsSolicitud.TESOPid#)) gt 0>
                                    <cfquery name="rsOrden" datasource="#session.dsn#">
                                       select TESOPnumero from TESordenPago where  TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.TESOPid#">                     
                                    </cfquery>
                                    <cfif rsOrden.recordcount gt 0>                      
                                       <cfset LvarOrden_Pago =   rsOrden.TESOPnumero>
                                   </cfif> 

                                </cfif>
                                <cfif len(trim(#rsSolicitud.TESAPid#)) gt 0> 
                                   <cfquery name="rsAcuerdo" datasource="#session.dsn#">
                                     select TESAPnumero, TASAPfecha from TESacuerdoPago where TESAPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.TESAPid#"> 
                                   </cfquery>     								   
                                   <cfif rsAcuerdo.recordcount gt 0>
                                        <cfset LvarTESAPnumero= rsAcuerdo.TESAPnumero>
                                        <cfset LvarPFecha = rsAcuerdo.TASAPfecha>
                                    </cfif>                         
                               </cfif>           
                            </cfif>    
                    </cfif>       

                  <cfelse>  
                   <cfset LvarOrden_Pago = rsDPagoRenta2.Orden_Pago>
                   <cfset LvarTESAPnumero= rsDPagoRenta2.TESAPnumero>
                   <cfset LvarPFecha = rsDPagoRenta2.PFecha>
 
                  </cfif>  
                    
                    
				
					 <cfoutput>
						<tr class="<cfif rsDPagoRenta2.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td nowrap="nowrap" width="10%">&nbsp;<font size="2">#DROrigen#</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#documento#</font></td>
							<td nowrap="nowrap" width="10%">&nbsp;<font size="2">#SNidentificacion#</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#SNnombre#</font></td>
							<td  nowrap="nowrap"width="10%" align="right"><font size="2">#LSNumberFormat(totallocal, ',9.00')#</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#Moneda#</font></td>
							<td  nowrap="nowrap"width="10%" align="right"><font size="2">#LSNumberFormat(MontoRetencion, ',9.00')#</font></td>
							<td  nowrap="nowrap"width="10%" align="right"><font size="2">#LSNumberFormat(montolocal, ',9.00')#</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LvarOrden_Pago#</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LSDateFormat(LvarPFecha,'dd/mm/yyyy')#</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#Tipo_Retencion#</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LvarTESAPnumero#</font></td>
						 </tr>	
					</cfoutput>
				</cfloop>
				<cfoutput>
							<td nowrap="nowrap" width="10%">&nbsp;<font size="2">&nbsp;</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">&nbsp;</font></td>
							<td nowrap="nowrap" width="10%">&nbsp;<font size="2">&nbsp;</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">&nbsp;</font></td>
							<td  nowrap="nowrap"width="10%" align="right"><font size="2"><strong>#LSNumberFormat(total_Local, ',9.00')#</strong></font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">&nbsp;</font></td>
							<td  nowrap="nowrap"width="10%" align="right"><font size="2"><strong>#LSNumberFormat(total_Retencion, ',9.00')#</strong></font></td>
							<td  nowrap="nowrap"width="10%" align="right"><font size="2"><strong>#LSNumberFormat(monto_Local, ',9.00')#</strong></font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">&nbsp;</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">&nbsp;</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">&nbsp;</font></td>
							<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">&nbsp;</font></td>
					</cfoutput>
					
			 <tr><td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">---  Fin del Reporte  ---</td></tr>
			 <tr><td colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td></tr>
			</cfif>	
		 </tr>
	</table>

		

	
