<style type="text/css">
	.LetraDetalle{
		font-size:10px;
	}
	.LetraEncab{
		font-size:10px;
		font-weight:bold;
	}
</style>

<cf_htmlReportsHeaders 
	title="Impresion de Solicitud de Pago" 
	filename="SolicitudPago.xls"		
	irA="imprSolicitPago.cfm?regresar=1"
	download="no"
	preview="no"
	back="no"
>

<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#"> 
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
	<cfquery name="rsDatos" datasource="#session.dsn#">
			select  a.TESBid,a.SNcodigoOri
					from TESsolicitudPago a 
			where a.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>
	
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion 
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

<cfif rsDatos.SNcodigoOri neq ''>
	<cfquery name="qryLista" datasource="#session.dsn#">
			select  a.TESSPid,a.TESSPnumero,a.TESSPtipoDocumento,a.TESSPfechaSolicitud, a.TESOPobservaciones,s.SNnombre,  m.Mnombre, m.Miso4217,a.TESSPtipoCambioOriManual,
			a.TESSPfechaPagar,a.NAP,  a.NRP,cf.CFcodigo ,cf.CFdescripcion
					from TESsolicitudPago a inner join CFuncional cf on cf.CFid = a.CFid
					inner join SNegocios s on s.SNcodigo = a.SNcodigoOri and s.Ecodigo = a.EcodigoOri
					inner join Monedas m on m.Mcodigo = a.McodigoOri
			where a.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>
<cfelseif rsDatos.TESBid neq ''>
	<cfquery name="qryLista" datasource="#session.dsn#">
			select  a.TESSPid,a.TESSPnumero,a.TESSPtipoDocumento,a.TESSPfechaSolicitud, a.TESOPobservaciones,s.TESBeneficiario,  m.Mnombre, m.Miso4217,a.TESSPtipoCambioOriManual,
			a.TESSPfechaPagar,a.NAP,  a.NRP,cf.CFcodigo ,cf.CFdescripcion
					from TESsolicitudPago a inner join CFuncional cf on cf.CFid = a.CFid
					inner join TESbeneficiario s on s.TESBid = a.TESBid 
					inner join Monedas m on m.Mcodigo = a.McodigoOri
			where a.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>
</cfif>

<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
	<cfquery name="qryLista2" datasource="#session.dsn#">
		select 
			a.UsucodigoAprobacion, 
			a.UsucodigoSolicitud,
			dt.TESSPlinea,
		case 
			when a.TESSPestado = 0 then  'En Preparación SP' 
			when a.TESSPestado    = 1 then  'En Aprobación SP'
			when a.TESSPestado    = 2 then  'SP Aprobada'
			when a.TESSPestado    = 3 then  'SP Rechazada'
		end as estado,		
			a.TESSPnumero,
			case when (dt.TESDPmontoSolicitadoOri <= 0) then 'Crédito (Ganancia)'  else 'Débito (Pago Normal)' end as tipoMov,
			imp.Idescripcion,
			coalesce(imp.Iporcentaje,0) as Iporcentaje,
			c.CFdescripcion,c.CFformato,
			dt.TESDPmontoSolicitadoOri,
			dt.TESDPdescripcion,
			dt.TESSPlinea ,
			dt.TESDPdocumentoOri,
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
			a.UsucodigoAprobacion, 
			 a.UsucodigoSolicitud,
			 dp.TESSPlinea,
		case 
			when a.TESSPestado = 0 then  'En Preparación SP' 
			when a.TESSPestado    = 1 then  'En Aprobación SP'
			when a.TESSPestado    = 2 then  'SP Aprobada'
			when a.TESSPestado    = 3 then  'SP Rechazada'
		end as estado,		
			 a.TESSPnumero,
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
			a.UsucodigoAprobacion, 
			a.UsucodigoSolicitud,
			dt.TESSPlinea,
		case 
			when a.TESSPestado = 0 then  'En Preparación SP' 
			when a.TESSPestado    = 1 then  'En Aprobación SP'
			when a.TESSPestado    = 2 then  'SP Aprobada'
			when a.TESSPestado    = 3 then  'SP Rechazada'
		end as estado,		
			a.TESSPnumero,
			dr.id_direccion, d.direccion1 #LvarCNCT# ' / ' #LvarCNCT# d.direccion2 as texto_direccion,
			dt.TESDPmontoSolicitadoOri,
			dt.TESDPdocumentoOri,
			dt.TESDPdescripcion,
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
			a.UsucodigoAprobacion, 
			a.UsucodigoSolicitud,
			dt.TESSPlinea,
		case 
			when a.TESSPestado = 0 then  'En Preparación SP' 
			when a.TESSPestado    = 1 then  'En Aprobación SP'
			when a.TESSPestado    = 2 then  'SP Aprobada'
			when a.TESSPestado    = 3 then  'SP Rechazada'
		end as estado,		
			a.TESSPnumero,
			dt.TESDPid,
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

<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
	<cfquery name="rsTotales" dbtype="query">
		select sum(TESDPmontoSolicitadoOri) as subtotal
			 , sum((Iporcentaje*TESDPmontoSolicitadoOri)/100.0) as impuesto
			 , sum(TESDPmontoSolicitadoOri + ((Iporcentaje*TESDPmontoSolicitadoOri)/100.0)) as totalestimado
		from qryLista2
	</cfquery>
</cfif>

<cfoutput query="qryLista" group="TESSPid"> 
<br>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">

	<tr>
		<td align="center" colspan="5">
			<strong><font size="3">#rsEmpresa.Edescripcion#</font></strong>
		</td>
	</tr>
	<tr><td align="center" colspan="5"><strong><font size="2">SOLICITUD DE PAGO No: #qryLista2.TESSPnumero#</font></strong></td></tr>
	<tr>
		<td colspan="4"><strong></strong></td>
	</tr>
   <tr>
		<td valign="top"><strong><cf_translate key="LB_NumeroDeSolicitud">N&uacute;mero de Solicitud</cf_translate>&nbsp;:&nbsp;</strong>#TESSPnumero#</td>
   </tr>
   <tr>
		<td valign="top"><strong><cf_translate key="LB_FechaDeLaSolicitud">Fecha de la Solicitud</cf_translate>:&nbsp;</strong>#LSDateFormat(TESSPfechaSolicitud,'dd/mm/yyy')#</td>
   </tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_Observaciones">Estado</cf_translate>&nbsp;:&nbsp;</strong>
		#qryLista2.estado#</td>
   </tr>
  
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#TESOPobservaciones#</td>
   </tr>
  
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4" class="tituloListas" style="border-bottom: 1px solid black;" >
			<strong><cf_translate key="LB_DetallesDeLineasDeLaSolicitudDePago">Detalles de L&iacute;nea(s) de la Solicitud de Pago</cf_translate></strong>
		</td>
	</tr>
</table>
</cfoutput>

<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr class="tituloListas">
		<td nowrap width="5%" style="padding-right: 5px;  border-bottom: 1px solid black;"><cf_translate key="LB_">L&iacute;nea</cf_translate></td>
		
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
			<td nowrap width="2%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_pagoT">Pago a Terceros</cf_translate></td>
		</cfif>
		<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM' or TipoSol eq 'APCP'>
			<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_CtaFinanc">Cta.Financiera</cf_translate></td>
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
			<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_CtaFinanc">Fecha Vencimiento</cf_translate></td>
		</cfif>		
		<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
			<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_TipoMov">Tipo Movimiento</cf_translate></td>
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
			<td nowrap width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Monto">Moneda</cf_translate></td>		
		<cfelseif isdefined('url.TipoSol') and TipoSol eq 'APCP'>
			<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Impuesto">Direccion</cf_translate></td> 
		</cfif>	
		<cfif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
			<td nowrap width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Monto">Saldo Vence</cf_translate></td>		
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
				<td width="5%" style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#TESSPlinea#&nbsp;</td>
				<cfif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
					<td width="17%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#origen#&nbsp;</td>
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'DAnt'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#TESDPfechaVencimiento#&nbsp;</td>
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
					<td nowrap width="2%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#TESRPTCcodigo# - #TESRPTCdescripcion# &nbsp;</td> 
				</cfif>
				<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM' or TipoSol eq 'APCP'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#CFformato# - #CFdescripcion#&nbsp;</td>
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#FechaVence#&nbsp;</td>
				</cfif>	
				<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#tipoMov#&nbsp;</td>	
				<cfelseif isdefined('url.TipoSol') and TipoSol eq 'PDCP'>
					<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Mnombre#&nbsp;</td>	
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
	<tr>
		<td colspan="4">&nbsp;</td>
		<cfif isdefined('url.TipoSol') and  TipoSol eq 'PDCP'>
			<cfset createObject("component","sif.tesoreria.Componentes.TESafectaciones").sbImprimeCPCsTramites(#url.TESSPid#, true)>
	  </cfif>		
	</tr>
	<tr>
		<td colspan="11"><table><tr>
			<!--- Obtiene el login y el nombre del Usucodigo que aplicó----->
			<cfquery name="rsLogin" datasource="#session.DSN#">
				select a.Usulogin, b.Pnombre #_Cat#' '#_Cat# b.Papellido1 #_Cat#' '#_Cat# b.Papellido2 as nombre
				from Usuario a
					left outer join DatosPersonales b
						on a.datos_personales = b.datos_personales	
				where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryLista2.UsucodigoSolicitud#">
			</cfquery>
			<td nowrap valign="top" class="LetraEncab">
				Usuario que Aplicó:
			</td>				
			<td colspan="10" valign="top" class="LetraDetalle">
				<cfif rsLogin.RecordCount NEQ 0>&nbsp;<cfoutput>#rsLogin.nombre#</cfoutput>&nbsp;</cfif>
			</td>
		</tr></table></td>
	</tr>
	<tr>
		<td colspan="11"><table><tr>
			<!--- Obtiene el login y el nombre del Usucodigo que aprobó----->
			<cfquery name="rsLogin" datasource="#session.DSN#">
				select a.Usulogin, b.Pnombre #_Cat#' '#_Cat# b.Papellido1 #_Cat#' '#_Cat# b.Papellido2 as nombre
				from Usuario a
					left outer join DatosPersonales b
						on a.datos_personales = b.datos_personales	
				where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryLista2.UsucodigoAprobacion#">
			</cfquery>
			<td nowrap valign="top" class="LetraEncab">
				Usuario que Aprobó:
			</td>				
			<td colspan="10" valign="top" class="LetraDetalle">
				<cfif rsLogin.RecordCount NEQ 0>&nbsp;<cfoutput>#rsLogin.nombre#</cfoutput>&nbsp;</cfif>
			</td>
		</tr></table></td>
	</tr>
	<cfif isdefined('url.TipoSol') and TipoSol eq 'SPM'>
	<cfoutput> 
	 <tr>
		<td colspan="11" align="right">
			<table>
			  <tr>
				<td align="right" class="LetraEncab">Subtotal Estimado:</td>
				<td align="right" class="LetraEncab">#LSNumberFormat(rsTotales.subtotal,',9.00')#</td>
			  </tr>
			  <tr>
				<td align="right" class="LetraEncab">Impuesto Estimado:</td>
				<td align="right" class="LetraEncab">#LSNumberFormat(rsTotales.impuesto,',9.00')#</td>
			  </tr>
			  <tr>
				<td align="right" class="LetraEncab">Total Estimado:</td>
				<td align="right" class="LetraEncab">#LSNumberFormat(rsTotales.totalestimado,',9.00')#</td>
			  </tr>
		  </table>
		</td>
	 </tr>
	</cfoutput>
	</cfif>
</table>


