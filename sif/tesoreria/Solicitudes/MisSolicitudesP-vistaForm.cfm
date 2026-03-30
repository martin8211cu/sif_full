<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#"> 
	<cfquery name="rsDatos" datasource="#session.dsn#">
			select  a.TESBid,a.SNcodigoOri
					from TESsolicitudPago a 
			where a.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>

<cfif rsDatos.SNcodigoOri neq ''>
	<cfquery name="qryLista" datasource="#session.dsn#">
			select  a.McodigoOri,a.TESSPtipoCambioOriManual,a.TESSPtotalPagarOri,a.TESSPid,a.TESSPnumero,a.TESSPtipoDocumento,a.TESSPfechaSolicitud, a.TESOPobservaciones,s.SNnombre,  m.Mnombre, m.Miso4217,a.TESSPtipoCambioOriManual,
			a.TESSPfechaPagar,a.NAP,  a.NRP,cf.CFcodigo ,cf.CFdescripcion
					from TESsolicitudPago a inner join CFuncional cf on cf.CFid = a.CFid
					inner join SNegocios s on s.SNcodigo = a.SNcodigoOri and s.Ecodigo = a.EcodigoOri
					inner join Monedas m on m.Mcodigo = a.McodigoOri
			where a.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>
<cfelseif rsDatos.TESBid neq ''>
	<cfquery name="qryLista" datasource="#session.dsn#">
			select  a.McodigoOri,a.TESSPtipoCambioOriManual,a.TESSPtotalPagarOri,a.TESSPid,a.TESSPnumero,a.TESSPtipoDocumento,a.TESSPfechaSolicitud, a.TESOPobservaciones,s.TESBeneficiario,  m.Mnombre, m.Miso4217,a.TESSPtipoCambioOriManual,
			a.TESSPfechaPagar,a.NAP,  a.NRP,cf.CFcodigo ,cf.CFdescripcion
					from TESsolicitudPago a inner join CFuncional cf on cf.CFid = a.CFid
					inner join TESbeneficiario s on s.TESBid = a.TESBid 
					inner join Monedas m on m.Mcodigo = a.McodigoOri
			where a.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>
</cfif>



	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select Mcodigo 
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
	</cfquery>
	<cfif rsMonedaLocal.Mcodigo EQ qryLista.McodigoOri>
		<cfset LvarTC = 1>
	<cfelse>
		<cfquery name="TCsug" datasource="#Session.DSN#">
			select tc.Hfecha, tc.TCcompra, tc.TCventa
			from Htipocambio tc
			where tc.Ecodigo = #Session.Ecodigo#
				and tc.Mcodigo = #rsForm.McodigoOri#
				and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		</cfquery>
		<cfset LvarTC = TCsug.TCcompra>
	</cfif>



<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
	<cfquery name="qryLista2" datasource="#session.dsn#">
		select 
			case when (dt.TESDPmontoSolicitadoOri <= 0) then 'Crédito (Ganancia)'  else 'Débito (Pago Normal)' end as tipoMov,
			imp.Idescripcion,
			c.CFdescripcion,c.CFformato,
			dt.TESDPmontoSolicitadoOri,
			dt.TESDPtipoCambioSP,
			dt.TESDPdescripcion,
			dt.TESSPlinea ,
			dt.TESDPdocumentoOri,
			dt.Miso4217Ori,
			a.TESSPid,      
			a.TESid,            
			a.EcodigoOri,   
			a.TESSPnumero, 
			a.TESSPtipoDocumento,  
			a.TESSPestado,             
			a.SNcodigoOri ,             
			a.TESSPfechaPagar,   
			a.McodigoOri,         
			a.TESSPtipoCambioOriManual ,
			a.CFid,                  
			a.TESSPtotalPagarOri,  
			a.TESSPobservaciones,
			a.TESSPfechaSolicitud, 
			a.UsucodigoSolicitud,     
			a.TESSPfechaAprobacion,
			a.UsucodigoAprobacion,    
			a.TESSPmsgRechazo,       
			a.TESSPidDuplicado,         
			a.TESBid,                
			a.TESOPid,             
			a.CBid,                     
			a.TESMPcodigo ,   
			a.EcodigoSP,          
			a.SNid,                     
			a.TESOPfechaPago, 
			a.BMUsucodigo,      
			a.CDCcodigo,          
			a.TESSPfechaRechazo, 
			a.UsucodigoRechazo,     
			a.TESOPobservaciones, 
			a.TESOPinstruccion,        
			a.TESOPbeneficiarioSuf, 
			a.NAP,                    
			a.NRP ,                   
			a.CFcuentaTraslado,   
			TESRPTCcodigo,     
			TESRPTCdescripcion   
		from TESsolicitudPago a  inner join TESdetallePago dt on dt.TESSPid =a.TESSPid
		inner join CFinanciera c on c.CFcuenta = dt.CFcuentaDB 
		left outer join Impuestos imp on imp.Icodigo = dt.Icodigo and imp.Ecodigo = dt.EcodigoOri
		left outer join TESRPTconcepto cp on cp.TESRPTCid = dt.TESRPTCid
		where a.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>
<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
	<cfquery datasource="#session.dsn#" name="qryLista2">
		select
			 a.TESSPnumero,
			 dp.TESDPtipoCambioSP,
			 dp.TESDPid, 
			 dp.TESDPmoduloOri as origen, 
			 dp.TESDPdocumentoOri, 
			 dp.TESDPreferenciaOri as Referencia, 
			 p3.TESRPTCdescripcion,
			 dp.TESDPdescripcion,
			 dp.SNcodigoOri, 
			 sn.SNnombre,
			 dp.TESDPfechaVencimiento as FechaVence, 
			 dp.TESDPfechaSolicitada as FechaSolicitud,
			 m.Mnombre, 
			 dp.Miso4217Ori, 
			 p3.TESRPTCcodigo,
			 dp.TESDPmontoVencimientoOri as MontoVence,
			 dp.TESDPmontoSolicitadoOri,
			 dp.Rcodigo, 
			 dp.Rmonto 
		  from TESdetallePago dp
		 	 inner join TESsolicitudPago  a
				 on a.TESSPid = dp.TESSPid
			 inner join SNegocios sn
				 on sn.SNcodigo	= dp.SNcodigoOri
				 and sn.Ecodigo	= dp.EcodigoOri
			 inner join Monedas m
				 on m.Miso4217	= dp.Miso4217Ori
				and m.Ecodigo	= dp.EcodigoOri
			left join TESRPTconcepto p3
				 on p3.TESRPTCid = dp.TESRPTCid
		 where dp.EcodigoOri=#session.Ecodigo#
		   and dp.TESSPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>	
<cfelseif isdefined('url.TipoSol') and TipoSol eq 'APCP'>
	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfquery name="qryLista2" datasource="#session.dsn#">
		Select 
			dr.id_direccion, d.direccion1 #LvarCNCT# ' / ' #LvarCNCT# d.direccion2 as texto_direccion,
			dt.TESDPmontoSolicitadoOri,
			dt.TESDPtipoCambioSP,
			dt.TESDPdocumentoOri,
			dt.TESDPdescripcion,
			dt.Miso4217Ori,
			dr.id_direccion, 
			d.direccion1, 
			d.direccion2 ,
			tr.CPTcodigo,
			tr.CPTdescripcion,
			cp.TESRPTCcodigo, 
			cp.TESRPTCdescripcion,
			c.CFformato,c.CFdescripcion
		from TESdetallePago  dt
		inner join TESsolicitudPago  a
			on a.TESSPid = dt.TESSPid
		inner join CPTransacciones  tr 
			on  tr.CPTcodigo =  dt.TESDPreferenciaOri 
		left outer join TESRPTconcepto cp on cp.TESRPTCid = dt.TESRPTCid
		inner join CFinanciera c 
			on c.CFcuenta = dt.CFcuentaDB 
		left outer join SNDirecciones dr 
			on dr.Ecodigo = dt.EcodigoOri
			and dr.SNcodigo = dt.SNcodigoOri
			and dr.id_direccion = dt.id_direccion
		left outer join DireccionesSIF d
			on d.id_direccion = dr.id_direccion
		where a.TESSPid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
 		and tr.CPTtipo = 'D'
		and Coalesce(tr.CPTpago,0) != 1
		and tr.Ecodigo = #session.Ecodigo#
	</cfquery>
<cfelseif isdefined('url.TipoSol') and TipoSol eq 'DAnt'>
	<cfquery name="qryLista2" datasource="#session.dsn#">
		Select 	
			dt.TESDPid,
			dt.Miso4217Ori,
			dt.TESDPtipoCambioSP,
			dt.TESDPfechaVencimiento,
			dt.TESDPdocumentoOri,
			dt.TESDPreferenciaOri as Referencia,
			dt.TESDPdescripcion, 
			dt.TESDPmontoVencimientoOri, 
			dt.TESDPmontoSolicitadoOri 
		from TESdetallePago dt
			inner join TESsolicitudPago  a
				on a.TESSPid = dt.TESSPid
		where dt.EcodigoOri= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.TESSPid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">	
	</cfquery>
</cfif>

<cfoutput query="qryLista" group="TESSPid"> 
<br>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="6" class="tituloListas"><strong><cf_translate key="LB_DatosDeLaSolicutudDeCompra">Datos de la Solicitud de Pago</cf_translate></strong></td>
	</tr>
	<tr>
		<td colspan="4"><strong></strong></td>
	</tr>
  <tr>
		<td valign="top"><strong><cf_translate key="LB_NumeroDeSolicitud">N&uacute;mero de Solicitud</cf_translate>:</strong></td>
		<td valign="top">#TESSPnumero#</td>
  </tr>
  <tr>
		<td valign="top"><strong><cf_translate key="LB_FechaDeLaSolicitud">Fecha de la Solicitud</cf_translate>:</strong></td>
		<td valign="top">#LSDateFormat(TESSPfechaSolicitud,'dd/mm/yyy')#</td>
		<cfif rsDatos.SNcodigoOri neq ''>
		<td valign="top"><strong><cf_translate key="LB_Proveedor">Proveedor</cf_translate>:</strong></td>
		<td valign="top">#SNnombre#</td>
		<cfelse>
		<td valign="top"><strong><cf_translate key="LB_Proveedor">Beneficiario</cf_translate>:;</strong></td>
		<td valign="top">#TESBeneficiario#</td>
		</cfif>
  </tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:</strong></td>
		<td valign="top">#TESOPobservaciones#</td>
		<td valign="top"><strong><cf_translate key="LB_Moneda">Moneda</cf_translate>:</strong></td>
		<td valign="top">#Miso4217# - #Mnombre# </td>
  </tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong></td>
		<td valign="top">#CFcodigo# - #CFdescripcion#</td>
		<td valign="top"><strong><cf_translate key="LB_TipoDeCambio">Tipo de Cambio</cf_translate>:</strong></td>
		<td valign="top">#LSCurrencyFormat(LvarTC,'none')#</td>
  </tr>
	<tr>
		<cfif NAP EQ 0 or NAP EQ ''>
				<td valign="top"><strong><cf_translate key="LB_NAP">NAP</cf_translate>:</strong></td>	
				<td valign="top"><cf_translate key="LB_NA">N/A</cf_translate></td>
			<cfelse>
				<td valign="top"><strong><cf_translate key="LB_NAP">NAP</cf_translate>:</strong></td>
				<td valign="top">#NAP#</td>	
			</cfif>
			<cfif NRP EQ 0 or NRP EQ ''>
				<td valign="top"><strong>NRP:&nbsp;</strong></td>	
				<td valign="top"><cf_translate key="LB_NA">N/A</cf_translate></td>
			<cfelse>
				<td valign="top"><strong><cf_translate key="LB_NRP">NRP</cf_translate>:&nbsp;</strong></td>	
				<td valign="top">#NRP#</td>
			</cfif>
			
		<td valign="top"><strong><cf_translate key="LB_Moneda">Total del Pago Solicitado</cf_translate>:&nbsp;</strong></td>
		<td valign="top">&nbsp;#NumberFormat(TESSPtotalPagarOri,",0.00")#&nbsp;</td>
			
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="7" class="tituloListas" style="border-bottom: 1px solid black;" >
			<strong><cf_translate key="LB_DetallesDeLineasDeLaSolicitudDePago">Detalles de L&iacute;nea(s) de la Solicitud de Pago</cf_translate></strong>
		</td>
	</tr>
</table>
</cfoutput>

<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr class="tituloListas">
		<cfif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
			<td nowrap width="17%" style="padding-right: 5px;  border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Documento">Origen</cf_translate></td>
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'DAnt'>
			<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_CtaFinanc">Fecha Vencimiento</cf_translate></td>
		</cfif>
			<td nowrap width="17%" style="padding-right: 5px;  border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Documento">Documento</cf_translate></td>
		<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
			<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Impuesto">Impuesto</cf_translate></td> 
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP' or TipoSol eq 'DAnt'>
			<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Impuesto">Referencia</cf_translate></td> 
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'APCP'>
			<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Impuesto">Transacción</cf_translate></td> 
		</cfif>
		<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM' or TipoSol eq 'APCP' or TipoSol eq 'DAnt'>
			<td nowrap width="15%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Desc">Descripci&oacute;n</cf_translate></td>	
		</cfif>	
		<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM' or TipoSol eq 'APCP' or TipoSol eq 'PDCP'>
			<td nowrap width="2%" align="left" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_pagoT">Descripci&oacute;n</cf_translate></td>
		</cfif>
		<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM' or TipoSol eq 'APCP'>
			<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_CtaFinanc">Cta.Financiera</cf_translate></td>
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
			<td nowrap width="3%" align="left" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_CtaFinanc">Fecha Vencimiento</cf_translate></td>
		</cfif>		
		<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
			<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_TipoMov">Tipo Movimiento</cf_translate></td>
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
			<td nowrap width="25%" align="left" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Monto">Moneda</cf_translate></td>		
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'APCP'>
			<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Impuesto">Direccion</cf_translate></td> 
		</cfif>	
		<cfif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
			<td nowrap width="25%" align="left" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Monto">Saldo Vence</cf_translate></td>		
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'DAnt'>
			<td nowrap width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Monto">Saldo</cf_translate></td>		
		</cfif>
			<td nowrap width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Monto">Monto</cf_translate></td>		
		<cfif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
			<td nowrap width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Monto">Retención</cf_translate></td>		
		</cfif>			
	</tr>
	
	<cfif qryLista2.RecordCount eq 0>
		<tr class="listaNon">
			<td colspan="<cfif not isdefined("url.imprimir")>11<cfelse>10</cfif>" style="padding-right: 5px; border-bottom: 1px solid black; text-align:center">
				&nbsp;--------- <cf_translate key="LB_NoHayDetallesEnLaSolicitudDeCompra">No hay detalles en la Solicitud de Pago</cf_translate> ---------&nbsp;
			</td>
		</tr>
	<cfelse>
		<cfoutput query="qryLista2"> 
			<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
				<cfif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
					<td width="17%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#origen#&nbsp;</td>
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'DAnt'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSDateFormat(TESDPfechaVencimiento,'dd/mm/yyy')#&nbsp;</td>
				</cfif>
					<td width="17%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#TESDPdocumentoOri#&nbsp;</td>
				<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
					<td width="40%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Idescripcion#&nbsp;</td>
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP' or TipoSol eq 'DAnt'>
					<td width="40%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Referencia#&nbsp;</td>
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'APCP'>
					<td width="40%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#CPTcodigo# - #CPTdescripcion#&nbsp;</td>
				</cfif>				
				<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM' or TipoSol eq 'APCP' or TipoSol eq 'DAnt'>
					<td width="15%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#TESDPdescripcion#&nbsp;</td>	
				</cfif>	
				<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM' or TipoSol eq 'APCP' or TipoSol eq 'PDCP'>
					<td nowrap width="2%" align="left" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#TESDPdescripcion#&nbsp;</td> 
				</cfif>
				<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM' or TipoSol eq 'APCP'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#CFformato# - #CFdescripcion#&nbsp;</td>
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSDateFormat(FechaVence,'dd/mm/yyyy')#&nbsp;</td>
				</cfif>	
				<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#tipoMov#&nbsp;</td>	
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Miso4217Ori#&nbsp;&nbsp;</td>	
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'APCP'>
					<td width="40%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#texto_direccion#&nbsp;</td>
				</cfif>				
				<cfif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#NumberFormat(MontoVence,",0.00")#&nbsp;</td>	
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'DAnt'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#NumberFormat(TESDPmontoVencimientoOri,",0.00")#&nbsp;</td>	
				</cfif>
					<td width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSCurrencyFormat(TESDPmontoSolicitadoOri,'none')#&nbsp;</td>				
				<cfif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#NumberFormat(Rmonto,",0.00")#&nbsp;</td>	
				</cfif>			
			</tr>
		</cfoutput>
	</cfif>
</table>
<cfif not isdefined("url.imprimir")>
<script type="text/javascript" language="javascript1.2" >
	function info(index){
		open('../consultas/Solicitudes-info.cfm?index='+index, 'Solicitudes','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=410,left=250, top=200,screenX=250,screenY=200');	
		//open('Solicitudes-info.cfm?observaciones=DOobservaciones&descalterna=DOalterna&titulo=Ordenes de Compra&index='+index, 'ordenes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
</script>
</cfif>