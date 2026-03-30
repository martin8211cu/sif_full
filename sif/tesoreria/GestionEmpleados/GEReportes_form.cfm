<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Archivo" default="GestionEmpleados" returnvariable="LB_Archivo" 
xmlfile ="GEReportes_form.xml"/>

<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="GEreportes.cfm"
	FileName="#LB_Archivo#.xls"
	title="Consulta"
>

<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;		  
		 } </style>

<cfquery name="antiND" datasource="#session.dsn#">
		select 
			a.GEAid,
			a.GEAnumero,
			a.GEAtotalOri,
			a.GEAdescripcion,
			case a.GEAestado
				when  0 then 'En Preparaci&oacute;n'
				when  1 then 'En Aprobaci&oacute;n'
				when  2 then 'Aprobada'
				when  3 then 'Rechazada'
				when  4 then 'Pagada'
				when  5 then 'Liquidada'
				when  6 then 'Terminada' 
				else 'Estado desconocido'
				end as estado,
			b.TESBeneficiario,
			a.TESSPid,
			sp.TESSPid,
			sp.TESSPnumero,
			case sp.TESSPestado
				when 0 then 'En Preparaci&oacute;n SP'
				when 1 then 'En Aprobaci&oacute;n SP'
				when 2 then 'SP Aprobada'
				when 3 then 'SP Rechazada'
				when 23 then 'Rechazada en Tesoreria'
				when 10 then 'En Preparaci&oacute;n OP'
				when 101 then 'En Aprobaci&oacute;n OP'
				when 103 then 'En OP rechazada'
				when 11 then 'En Emision OP'
                when 110 then 'En OP sin aplicar'
				when 12 then 'En OP pagada'
				when 13 then 'En OP anulada'
				end as EstadoSP,
			sp.TESOPid,
			op.TESOPnumero,
			case op.TESOPestado
				when 10 then 'En Preparaci&oacute;n OP'
				when 101 then 'En Aprobaci&oacute;n OP'
				when 103 then 'En OP rechazada'
				when 11 then 'En Emision OP'
                when 110 then 'En OP sin aplicar'
				when 12 then 'En OP pagada'
				when 13 then 'En OP anulada'
				end as EstadoOP,
			a.GEAfechaPagar
		from GEanticipo a
			left join TESsolicitudPago sp
				left join TESordenPago op
					on sp.TESOPid=op.TESOPid
				on a.TESSPid= sp.TESSPid
			inner join TESbeneficiario b
		  	  on b.TESBid=a.TESBid
		where a.Ecodigo=#session.Ecodigo# 
		and a.GEAestado in  (0,1)
	<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ 0 and form.AFTRtipo NEQ 1>
		and  <cf_dbfunction name="to_date00" args="a.GEAfechaSolicitud"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)#">
	</cfif>		
		order by a.GEAfechaSolicitud desc,a.GEAnumero desc
</cfquery>


<cfquery name="Busqueda" datasource="#session.dsn#">
		select 
			a.GEAid,
			a.GEAnumero,
			a.GEAtotalOri,
			a.GEAdescripcion,
			case a.GEAestado
				when  0 then 'En Preparaci&oacute;n'
				when  1 then 'En Aprobaci&oacute;n'
				when  2 then 'Aprobada'
				when  3 then 'Rechazada'
				when  4 then 'Pagada'
				when  5 then 'Liquidada'
				when  6 then 'Terminada' 
				else 'Estado desconocido'
				end as estado,
			b.TESBeneficiario,
			a.TESSPid,
			sp.TESSPid,
			sp.TESSPnumero,
			case sp.TESSPestado
				when 0 then 'En Preparaci&oacute;n SP'
				when 1 then 'En Aprobaci&oacute;n SP'
				when 2 then 'SP Aprobada'
				when 3 then 'SP Rechazada'
				when 23 then 'Rechazada en Tesoreria'
				when 10 then 'En Preparaci&oacute;n OP'
				when 101 then 'En Aprobaci&oacute;n OP'
				when 103 then 'En OP rechazada'
				when 11 then 'En Emision OP'
				when 110 then 'En OP sin aplicar'
                when 12 then 'En OP pagada'
				when 13 then 'En OP anulada'
				end as EstadoSP,
			sp.TESOPid,
			op.TESOPnumero,
			case op.TESOPestado
				when 10 then 'En Preparaci&oacute;n OP'
				when 101 then 'En Aprobaci&oacute;n OP'
				when 103 then 'En OP rechazada'
				when 11 then 'En Emision OP'
                when 110 then 'En OP sin aplicar'
				when 12 then 'En OP pagada'
				when 13 then 'En OP anulada'
				end as EstadoOP,
			a.GEAfechaPagar
		from GEanticipo a
			left join TESsolicitudPago sp
				left join TESordenPago op
					on sp.TESOPid=op.TESOPid
				on a.TESSPid= sp.TESSPid
			inner join TESbeneficiario b
			  on b.TESBid=a.TESBid
		where a.Ecodigo=#session.Ecodigo# 
	<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ -1>	
		and GEAestado= #form.AFTRtipo# 
	</cfif>
	<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ 0 and form.AFTRtipo NEQ 1>
		and  <cf_dbfunction name="to_date00" args="a.GEAfechaSolicitud"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)#">
	</cfif>		
		and  a.GEAtipoP=1
		order by a.GEAfechaSolicitud desc,a.GEAnumero desc
</cfquery> 


<cfquery name="BusquedaCCH" datasource="#session.dsn#">
		select 
			a.GEAid,
			a.GEAnumero,
			a.GEAtotalOri,
			a.GEAdescripcion,
			a.GEAfechaPagar,
			case a.GEAestado
				when  0 then 'En Preparaci&oacute;n'
				when  1 then 'En Aprobaci&oacute;n'
				when  2 then 'Aprobada'
				when  3 then 'Rechazada'
				when  4 then 'Pagada'
				when  5 then 'Liquidada'
				when  6 then 'Terminada' 
				else 'Estado desconocido'
				end as estadoCCH,
			b.TESBeneficiario,
			ch.CCHcodigo,
			ch.CCHdescripcion
		from GEanticipo a
			inner join TESbeneficiario b
		  	  on b.TESBid=a.TESBid
			inner join CCHica ch
			  on ch.CCHid=a.CCHid
		where a.Ecodigo=#session.Ecodigo# 
	<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ -1>	
		and GEAestado= #form.AFTRtipo# 
	</cfif>
	<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ 0 and form.AFTRtipo NEQ 1>
		and  <cf_dbfunction name="to_date00" args="a.GEAfechaSolicitud"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)#">
	</cfif>
	<cfif isdefined ('form.formaPago') and form.formaPago GT 0>
		and a.CCHid=#form.FormaPago#
	</cfif>			
		and a.GEAtipoP=0
		order by a.GEAfechaSolicitud desc,a.GEAnumero desc
</cfquery> 


<cfquery name="rsReporte" datasource="#session.dsn#">
	select 
			c.GELid,
			c.TESBid,
			c.GELdescripcion,
			c.Mcodigo,
			c.Ecodigo,
			c.GELreembolso,
			c.GELid,
			c.GELnumero,
			b.TESBeneficiario,
			c.GELfecha,
			c.GELnumero,
			c.TESSPid,
			sp.TESSPid,
			sp.TESSPnumero,
			case sp.TESSPestado
				when 0 then 'En Preparaci&oacute;n SP'
				when 1 then 'En Aprobaci&oacute;n SP'
				when 2 then 'SP Aprobada'
				when 3 then 'SP Rechazada'
				when 23 then 'Rechazada en Tesoreria'
				when 10 then 'En Preparaci&oacute;n OP'
				when 101 then 'En Aprobaci&oacute;n OP'
				when 103 then 'En OP rechazada'
				when 11 then 'En Emision OP'
				when 110 then 'En OP sin aplicar'
                when 12 then 'En OP pagada'
				when 13 then 'En OP anulada'
				end as EstadoSP,
			sp.TESOPid,
			op.TESOPnumero,
			case op.TESOPestado
				when 10 then 'En Preparaci&oacute;n OP'
				when 101 then 'En Aprobaci&oacute;n OP'
				when 103 then 'En OP rechazada'
				when 11 then 'En Emision OP'
				when 12 then 'En OP pagada'
				when 13 then 'En OP anulada'
				end as EstadoOP,
			coalesce(c.GELtotalGastos,0) as GELtotalGastos,
			coalesce(c.GELtotalAnticipos,0) as GELtotalAnticipos,
			coalesce(c.GELtotalDepositos,0) as GELtotalDepositos,
				case c.GELestado
				when 0 then 'Preparaci&oacute;n'
				when 1 then 'En Aprobaci&oacute;n'
				when 2 then 'Aprobada'
				when 3 then 'Rechazada'
				when 4 then 'Finalizada'
				when 5 then 'Por reintegrar'
				end as Titulo,
			m.Miso4217	
	from GEliquidacion c
		left join TESsolicitudPago sp
			left join TESordenPago op
				on sp.TESOPid=op.TESOPid
			on c.TESSPid= sp.TESSPid
		inner join TESbeneficiario b
			on c.TESBid=b.TESBid
		inner join Monedas m 
			on m.Mcodigo=c.Mcodigo
	where c.Ecodigo=#session.Ecodigo#
<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ -1>	
	and c.GELestado = #form.AFTRtipo#
</cfif>
		and c.GELtipoP=1
		  
	<cfif isdefined("form.desde") and len(trim(form.desde)) and isdefined("form.hasta") and len(trim(form.hasta))>
		and c.GELfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)#">
	
	<cfelseif isdefined("form.desde") and len(trim(form.desde))>
		and c.GELfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)#">
	
	<cfelseif isdefined("form.hasta") and len(trim(form.hasta))>
		and c.GELfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)#">
	</cfif>
		order by  c.GELfecha desc, c.GELnumero desc
</cfquery> 

<cfquery name="rsReporteCCH" datasource="#session.dsn#">
	select 
	c.GELid,
	c.TESBid,
	c.GELdescripcion,
	c.Mcodigo,
	c.Ecodigo,
	b.TESBeneficiario,
	c.GELreembolso,
	c.GELid,
	c.GELnumero,
	c.GELfecha,
	c.GELnumero,
	ch.CCHcodigo,
	ctp.CCHcod,
	sp.TESSPnumero,
	op.TESOPnumero,
	ch.CCHdescripcion,
	coalesce(c.GELtotalGastos,0) as GELtotalGastos,
	coalesce(c.GELtotalAnticipos,0) as GELtotalAnticipos,
	coalesce(c.GELtotalDepositos,0) as GELtotalDepositos,
		case c.GELestado
		when 0 then 'Preparaci&oacute;n'
		when 1 then 'En Aprobaci&oacute;n'
		when 2 then 'Aprobada'
		when 3 then 'Rechazada'
		when 4 then 'Finalizada'
		when 5 then 'Por Reintegrar'
		end as TituloL,
	m.Miso4217	
		from GEliquidacion c
			inner join Monedas m 
				on m.Mcodigo=c.Mcodigo
			inner join TESbeneficiario b
				on c.TESBid=b.TESBid
			inner join CCHica ch
				on ch.CCHid=c.CCHid
			inner join CCHTransaccionesProceso tp
				left join CCHTransaccionesAplicadas ta
					left join CCHTransaccionesProceso ctp
						left join STransaccionesProceso stSP
							left join TESsolicitudPago sp
								on sp.TESSPid=stSP.CCHTrelacionada
							on stSP.CCHTid=ctp.CCHTid
							and stSP.CCHTtrelacionada='Solicitud de Pago'
							
						left join STransaccionesProceso stOP
							left join TESordenPago op
								on op.TESOPid=stOP.CCHTrelacionada
							on stOP.CCHTid=ctp.CCHTid
							and stOP.CCHTtrelacionada='Orden de Pago'
						on ctp.CCHTid=ta.CCHTAreintegro
					on ta.CCHTAtranRelacionada=tp.CCHTid
				on tp.CCHTrelacionada=c.GELid
				and tp.CCHTtipo='GASTO'

			where c.Ecodigo=#session.Ecodigo#
		<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ -1>	
			and c.GELestado = #form.AFTRtipo#
		</cfif>
			and c.GELtipoP=0
		<cfif isdefined ('form.formaPago') and form.formaPago GT 0>
			and c.CCHid=#form.FormaPago#
		</cfif>	
		  
	<cfif isdefined("form.desde") and len(trim(form.desde)) and isdefined("form.hasta") and len(trim(form.hasta))>
		and c.GELfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)#">
	
	<cfelseif isdefined("form.desde") and len(trim(form.desde))>
		and c.GELfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)#">
	
	<cfelseif isdefined("form.hasta") and len(trim(form.hasta))>
		and c.GELfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)#">
	</cfif>
		order by  c.GELfecha desc, c.GELnumero desc
</cfquery>


<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select Edescripcion 
	from Empresas
	where Ecodigo = #session.Ecodigo#
</cfquery>
	
<cfflush interval="64">
<table width="100%" cellpadding="0" cellspacing="0" border="0">	
	<tr class="listaPar">
		<td style="font-size:18px" colspan="6" align="center">
		<cfoutput>#rsEmpresa.Edescripcion#</cfoutput>
		</td>
	</tr>
	
	<tr class="listaPar" align="center">
		<td align="center">
			<cfoutput><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>:</strong>#dateFormat(now(),'dd/mm/yyyy')#</cfoutput>
		</td>
	</tr>
	<tr class="listaPar" align="center">
		<td align="center"  style="font-size:16px" colspan="3">
			<strong><cf_translate key=LB_RpteEdoCtaEmp>Reporte de Estado de Cuenta por Empleado</cf_translate></strong>
		</td>
	</tr>
	<tr class="listaPar" align="center">
		<td align="center" >
		</td>
	</tr>
	<tr>
			<td nowrap="nowrap"colspan="5">&nbsp;</td>
		</tr>


</BR></BR>
	</table>
<cfif isdefined ('form.formaPago') and form.formaPago EQ 0 or form.formaPago EQ "">
	<cfif rsReporte.recordcount gt 0>
		<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" colspan="8">
					<strong><cf_translate key=LB_LiqPagTeso>Liquidaciones pagadas por Tesoreria</cf_translate></strong>
				</td>
			</tr>	
		</table>
		</cfoutput>
		
			<table width="100%" cellpadding="2" cellspacing="0" border="1">	
				<cfoutput>		
					<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
						<td width="8%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_NumeroLiquidacion>N°Liquidaci&oacute;n</cf_translate></td>
						<td width="16%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Empleado>Empleado</cf_translate></td>
						<td width="14%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Fecha>Fecha</cf_translate></td>
						<td width="35%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Descripcion>Descripción</cf_translate></td>
						<td width="15%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Estado>Estado</cf_translate></td>
						<td width="35%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_MontoAnticipo>Monto Anticipos</cf_translate></td>
						<td width="35%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_MontoGasto>Monto Gastos</cf_translate></td>
						<td width="35%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_MontoDeposito>Monto Depósito</cf_translate></td>
						<td width="18%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_PagoEmpleado>Pago al Empleado</cf_translate></td>
						<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_SolicitudPagoEstado>N° Solicitud Pago/Estado</cf_translate></td>
						<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_OrdenPagoEstado>N° Orden Pago/Estado</cf_translate></td>
					</tr>
					
					<cfloop query="rsReporte">
						<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td align="left" style="font-size:9px">
								<a href="javascript:doConlis(#rsReporte.GELid#,'L');">
									#rsReporte.GELnumero#
								</a>
							</td>
							<td align="left" style="font-size:9px">#rsReporte.TESBeneficiario#</td>	
							<td align="left" style="font-size:9px">#LSDateFormat(rsReporte.GELfecha, 'dd/mm/yyyy')#</td>
							<td align="left" style="font-size:9px">#rsReporte.GELdescripcion#</td>	
							<td align="left" style="font-size:9px">#rsReporte.Titulo#</td>	
							<td align="left" style="font-size:9px">#LSNumberFormat(rsReporte.GELtotalAnticipos, ',9.00')#</td>	
							<td align="left" style="font-size:9px">#LSNumberFormat(rsReporte.GELtotalGastos, ',9.00')#</td>	
							<td align="left" style="font-size:9px">#LSNumberFormat(rsReporte.GELtotalDepositos, ',9.00')#</td>	
							<td align="right" style="font-size:9px">#LSNumberFormat(rsReporte.GELreembolso, ',9.00')#</td>
							<td align="right" style="font-size:9px">#rsReporte.TESSPnumero#/#rsReporte.EstadoSP#</td>
							<td align="right" style="font-size:9px">#rsReporte.TESOPnumero#/#rsReporte.EstadoOP#</td>				
						
					</tr>
				</cfloop>
				</cfoutput>
			</table>
	</cfif>
</cfif>

<cfif isdefined ('form.formaPago') and form.formaPago gt 0 or form.formaPago EQ "">
	<cfif rsReporteCCH.recordcount gt 0>
		<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" colspan="8">
					<strong><cf_translate key=LiqPagCajaChica>Liquidaciones pagadas por Caja Chica</cf_translate></strong>
				</td>
			</tr>	
		</table>
		</cfoutput>
		
			<table width="100%" cellpadding="2" cellspacing="0" border="1">	
					<cfoutput>	
					<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
						<td width="9%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_NumeroLiquidacion>N°Liquidaci&oacute;n</cf_translate></td>
						<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Empleado>Empleado</cf_translate></td>
						<td width="8%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Fecha>Fecha</cf_translate></td>
						<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Descripcion>Descripción</cf_translate></td>
						<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LBCajaChica>Caja Chica</cf_translate></td>
						<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_EstadoReintegroSPOP>Estado/N°Reintegro/N°SP/N°OP<cf_translate></td>
						<td width="11%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_MontoAnticipo>Monto Anticipos</cf_translate></td>
						<td width="12%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_MontoGasto>Monto Gastos</cf_translate></td>
						<td width="11%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_MontoDeposito>Monto Depósito</cf_translate></td>
						<td width="9%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_PagoEmpleado>Pago al Empleado</cf_translate></td>
					</tr>
					<cfloop query="rsReporteCCH" >
						<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td align="left" style="font-size:9px">
							<a href="javascript:doConlis(#rsReporteCCH.GELid#,'L');">
									#rsReporteCCH.GELnumero#
							</a>
						</td>	
						<td align="left" style="font-size:9px">#rsReporteCCH.TESBeneficiario#</td>
						<td align="left" style="font-size:9px">#LSDateFormat(rsReporteCCH.GELfecha, 'dd/mm/yyyy')#</td>
						<td align="left" style="font-size:9px">#rsReporteCCH.GELdescripcion#</td>
						<td align="left" style="font-size:9px">#rsReporteCCH.CCHcodigo#-#rsReporteCCH.CCHdescripcion#</td>	
						<td align="left" style="font-size:9px">#rsReporteCCH.TituloL#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfif rsReporteCCH.TituloL EQ 'Por Reintegrar'>/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsReporteCCH.CCHcod#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsReporteCCH.TESSPnumero#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/#rsReporteCCH.TESOPnumero#</cfif></td>	
						<td align="left" style="font-size:9px">#LSNumberFormat(rsReporteCCH.GELtotalAnticipos, ',9.00')#</td>	
						<td align="left" style="font-size:9px">#LSNumberFormat(rsReporteCCH.GELtotalGastos, ',9.00')#</td>	
						<td align="left" style="font-size:9px">#LSNumberFormat(rsReporteCCH.GELtotalDepositos, ',9.00')#</td>	
						<td align="right" style="font-size:9px">#LSNumberFormat(rsReporteCCH.GELreembolso, ',9.00')#</td>				
					</tr>
				</cfloop>
				</cfoutput>
			</table>
	</cfif>
</cfif>
		</BR>
		<cfif antiND.recordcount gt 0>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<cfoutput>
			<tr>
				<td align="center" colspan="8">
					<strong><cf_translate key=LB_AnticiposinFormaPago>Anticipos Sin Forma de Pago Definida</cf_translate></strong>
				</td>
			</tr>	
			</cfoutput>
		</table>
		
		<table width="100%" cellpadding="2" cellspacing="0" border="1">	
			<cfoutput>		
				<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="left" class="tituloListas">
					<td width="7%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_NumeroAnticipo>N°Anticipo</cf_translate></td>
					<td width="15%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Empleado>Empleado</cf_translate></td>
					<td width="13%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Fecha>Fecha</cf_translate></td>
					<td width="17%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_PagoEmpleado>Pago al Empleado</cf_translate></td>
					<td width="32%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Descripcion>Descripción</cf_translate></td>
					<td width="16%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Estado>Estado</cf_translate></td>
				</tr>
					<cfloop query="antiND">
						<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td align="left" style="font-size:9px">
								<a href="javascript:doConlis(#antiND.GEAid#,'A');">#antiND.GEAnumero#</a>
							</td>
							<td align="left" style="font-size:9px">#antiND.TESBeneficiario#</td>	
							<td align="left" style="font-size:9px">#LSDateFormat(antiND.GEAfechaPagar,"DD/MM/YYYY")# </td>
							<td align="right" style="font-size:9px">#NumberFormat(antiND.GEAtotalOri,"0.00")#</td>
							<td align="left" style="font-size:9px">#antiND.GEAdescripcion#</td>
							<td align="left" style="font-size:9px">#antiND.estado#</td>
						</tr>
						<tr></tr>
					</cfloop>
			</cfoutput>
		</table>
		</cfif>
	<cfif isdefined ('form.formaPago') and form.formaPago EQ 0 or form.formaPago EQ "">	
		<cfif Busqueda.recordcount gt 0>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<cfoutput>
			<tr>
				<td align="center" colspan="8">
					<strong><cf_translate key=LB_AnticipoPagadoPorTesoreria>Anticipos Pagados por Tesorería</cf_translate></strong>
				</td>
			</tr>	
			</cfoutput>
		</table>
		
		<table width="100%" cellpadding="2" cellspacing="0" border="1">	
			<cfoutput>		
				<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="left" class="tituloListas">
					<td width="7%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_NumeroAnticipo>N°Anticipo</cf_translate></td>
					<td width="15%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Empleado>Empleado</cf_translate></td>
					<td width="13%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Fecha>Fecha</cf_translate></td>
					<td width="17%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_PagoEmpleado>Pago al Empleado</cf_translate></td>
					<td width="32%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Descripcion>Descripción</cf_translate></td>
					<td width="16%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Estado>Estado</cf_translate></td>
					<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_MontoDeposito>Monto Depósito</cf_translate></td>
					<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_PagoEmpleado>Pago al Empleado</cf_translate></td>
					
				</tr>
					<cfloop query="Busqueda">
						<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td align="left" style="font-size:9px">
								<a href="javascript:doConlis(#Busqueda.GEAid#,'A');">#Busqueda.GEAnumero#</a>
							</td>
							<td align="left" style="font-size:9px">#Busqueda.TESBeneficiario#</td>	
							<td align="left" style="font-size:9px">#LSDateFormat(Busqueda.GEAfechaPagar,"DD/MM/YYYY")# </td>
							<td align="right" style="font-size:9px">#NumberFormat(Busqueda.GEAtotalOri,"0.00")#</td>
							<td align="left" style="font-size:9px">#Busqueda.GEAdescripcion#</td>
							<td align="left" style="font-size:9px">#Busqueda.estado#</td>
							<td align="left" style="font-size:9px">#Busqueda.TESSPnumero#/#Busqueda.EstadoSP#</td>	
							<td align="left" style="font-size:9px">#Busqueda.TESOPnumero#/#Busqueda.EstadoOP#</td>		
						</tr>
						<tr></tr>
					</cfloop>
			</cfoutput>
		</table>
		</cfif>
	</cfif>
	
	<cfif isdefined ('form.formaPago') and form.formaPago GT 0 or form.formaPago EQ "">		
		<cfif BusquedaCCH.recordcount gt 0>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<cfoutput>
			<tr>
				<td align="center" colspan="8">
					<strong><cf_translate key=LB_AnticipoPagadoCajaChica>Anticipos Pagados por Caja Chica</cf_translate></strong>
				</td>
			</tr>	
			</cfoutput>
		</table>
		
		<table width="100%" cellpadding="2" cellspacing="0" border="1">	
			<cfoutput>		
				<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="left" class="tituloListas">
					<td width="9%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_NumeroAnticipo>N°Anticipo</cf_translate></td>
					<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Empleado>Empleado</cf_translate></td>
					<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_CajaChica>Caja Chica</cf_translate></td>
					<td width="10%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Fecha>Fecha</cf_translate></td>
					<td width="13%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_PagoEmpleado>Pago al Empleado</cf_translate></td>
					<td width="34%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Descripcion>Descripción</cf_translate></td>
					<td width="14%" colspan="0" align="left" nowrap="nowrap"><cf_translate key=LB_Estado>Estado</cf_translate></td>
					
				</tr>
					<cfloop query="BusquedaCCH">
						<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td align="left" style="font-size:9px">
								<a href="javascript:doConlis(#BusquedaCCH.GEAid#,'A');">#BusquedaCCH.GEAnumero#</a>
							</td>
							<td align="left" style="font-size:9px">#BusquedaCCH.TESBeneficiario#</td>
							<td align="left" style="font-size:9px">#BusquedaCCH.CCHcodigo#-#BusquedaCCH.CCHdescripcion#</td>	
							<td align="left" style="font-size:9px">#LSDateFormat(BusquedaCCH.GEAfechaPagar,"DD/MM/YYYY")# </td>
							<td align="right" style="font-size:9px">#NumberFormat(BusquedaCCH.GEAtotalOri,"0.00")#</td>
							<td align="left" style="font-size:9px">#BusquedaCCH.GEAdescripcion#</td>
							<td align="left" style="font-size:9px">#BusquedaCCH.estadoCCH#</td>	
						</tr>
						<tr></tr>
					</cfloop>
			</cfoutput>
		</table>
		</cfif>
	</cfif>
<script language="javascript1.1" type="text/javascript">

var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}

function doConlis(id,tipo){
<cfoutput>
	popUpWindow("/cfmx/sif/tesoreria/GestionEmpleados/RepDisponible_popUp.cfm?id="+id+"&transac="+tipo,350,250,800,500);					
</cfoutput>
}

function closePopUp(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}
</script>
	


