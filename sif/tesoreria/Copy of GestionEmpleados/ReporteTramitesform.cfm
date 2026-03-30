<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="GEReportes.cfm"
	FileName="GestionEmpleados.xls"
	title="Consultas Gestion Empleados">

<style type="text/css">
<!--
.style5 {font-size: 18px; font-weight: bold; }
-->

</style>
	<cfquery datasource="#session.DSN#" name="rsDatosEmpleado">
			select 
					TESBid,
					TESBeneficiario,
					TESBeneficiarioId
			from TESbeneficiario
			where  DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>

<cfif rsDatosEmpleado.recordcount lte 0>
	<cf_errorCode	code = "51703" msg = "El Empleado no tiene ningun Tramite">
</cfif>
	<cfquery  name="rsAnticipos" datasource="#session.DSN#">
			select 
					a.GEAid,
					a.GEAnumero,
					case a.GEAestado
					when 0 then 'Preparaci&oacute;n'
					when 1 then 'En Aprobaci&oacute;n'
					when 2 then 'Aprobada'
					when 3 then 'Rechazada'
					when 4 then 'Pagada'
					when 5 then 'Liquidada'
					when 6 then 'Terminado'
					end as TituloA,
					a.GEAfechaSolicitud,
					a.GEAtotalOri,
					case a.GEAtipoP
					when 0 then 'CAJA CHICA'
					when 1 then 'TESORERIA'
					end as FormaPago,
					m.Miso4217,
					c.TESdescripcion,
					c.TESid,
					d.CCHid,
					d.CCHdescripcion,
					d.CCHcodigo,
					sp.TESSPnumero
			from GEanticipo a
				inner join Monedas m
					on a.Mcodigo = m.Mcodigo
					and m.Ecodigo= #session.Ecodigo#
				inner join Tesoreria c
					on a.TESid= c.TESid
				left join CCHica d
					on a.CCHid=d.CCHid
				left join TESsolicitudPago sp
					on sp.TESSPid= a.TESSPid          	
			where a.TESBid = #rsDatosEmpleado.TESBid#
			and a.Ecodigo=#session.Ecodigo#
		<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ -1>	
			and a.GEAestado= #form.AFTRtipo# 
		</cfif>
		<cfif isdefined ('form.hasta') and form.hasta NEQ "" and isdefined ('form.desde') and form.desde NEQ "">
			and  <cf_dbfunction name="to_date00" args="a.GEAfechaSolicitud"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)# "> and 
			  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)# ">
		<cfelseif isdefined ('form.desde') and form.desde NEQ "">
			and <cf_dbfunction name="to_date00" args="a.GEAfechaSolicitud">=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)#">
		<cfelseif isdefined ('form.hasta') and form.hasta NEQ "">
			and <cf_dbfunction name="to_date00" args="a.GEAfechaSolicitud">=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)#">
		</cfif>
		<cfif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
			and a.GEAtipoP=1
		<cfelseif isdefined ('form.FormaPago') and form.FormaPago GT 0>
			and a.GEAtipoP=0
			and a.CCHid=#form.FormaPago#
		</cfif>
		
			order by a.GEAfechaSolicitud asc,a.GEAnumero asc
	</cfquery>
		
	<cfquery name="rsLiquidacion" datasource="#session.DSN#">
			select
					l.GELid,
					l.GELnumero,
					l.TESBid,
					l.Mcodigo,
					l.GELfecha,
					l.GELtotalGastos,
					l.GELreembolso,
					l.GELtotalDevoluciones,
					case l.GELtipoP
					when 0 then 'CAJA CHICA'
					when 1 then 'TESORERIA'
					end as FormaPago,
					case l.GELestado
					when 0 then 'Preparaci&oacute;n'
					when 1 then 'En Aprobaci&oacute;n'
					when 2 then 'Aprobada'
					when 3 then 'Rechazada'
					when 4 then 'Finalizada'
					when 5 then 'Por Reintegrar'
					end as Titulo,
					m.Miso4217,
					d.CCHcodigo,
					sp.TESSPnumero,
					l.GELtotalDevoluciones 
			from GEliquidacion l
				inner join Monedas m
					on l.Mcodigo = m.Mcodigo
					and m.Ecodigo= #session.Ecodigo#
				left join CCHica d
					on l.CCHid=d.CCHid
				left join TESsolicitudPago sp
					on sp.TESSPid= l.TESSPid    	
			where l.TESBid = #rsDatosEmpleado.TESBid#
			and l.Ecodigo=#session.Ecodigo#
		<cfif isdefined ('form.AFTRtipo') and form.AFTRtipo NEQ -1>	
			and l.GELestado = #form.AFTRtipo#
		</cfif>
		<cfif isdefined ('form.hasta') and form.hasta NEQ "" and isdefined ('form.desde') and form.desde NEQ "">
			and l.GELfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.desde)# "> and 
		  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.hasta)# ">
		</cfif>
		<cfif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
			and l.GELtipoP=1
		<cfelseif isdefined ('form.FormaPago') and form.FormaPago GT 0>
			and l.GELtipoP=0
			and l.CCHid=#form.FormaPago#
		</cfif>
			order by l.GELfecha asc,l.GELnumero asc
	</cfquery>
	<!---<cfif rsLiquidacion.GELid NEQ "">
		<cfquery name="rsDeposito" datasource="#session.DSN#">
			select 
					a.GELid,
					a.GELDreferencia,
					a.CBid,
					a.GELDtotalOri,
					a.GELDtotal,
					b.CBid,
					b.CBcodigo
			from
					GEliquidacionDeps a
						inner join CuentasBancos b
							on b.CBid=a.CBid
			where a.GELid=#rsLiquidacion.GELid#
				and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
		</cfquery>
	</cfif>--->
	
	<cfquery datasource="#session.DSN#" name="rsEmpresa">
			select 
					Edescripcion,
					Ecodigo
			from Empresas
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	

	<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
		</style>
	

	<table align="center" width="100%" border="0" summary="Reporte" cellpadding="0" cellspacing="0">
	<cfoutput>
		<tr class="listaPar">
			<td align="center" valign="top" colspan="12" nowrap="nowrap"><strong>#rsEmpresa.Edescripcion#</strong></td>
		</tr>
		<tr class="listaPar">
			<td align="center" valign="top" colspan="12" nowrap="nowrap"><strong>#rsAnticipos.TESdescripcion#</strong></td>
		</tr>
		<tr class="listaPar">
			<td align="center" valign="top" colspan="12"><strong>Sistema de Gastos de Empleado</strong></td>
		</tr>
		<tr class="listaPar"> 
			<td width="31%" align="center" valign="top"class="RLTtopline" colspan="12"><strong>#rsDatosEmpleado.TESBeneficiarioId# &nbsp;--&nbsp;#rsDatosEmpleado.TESbeneficiario# &nbsp;&nbsp;&nbsp;</strong></td>
		</tr>
		<tr class="listaPar"> 
			<td align="right"class="RLTtopline" nowrap="nowrap" colspan="3"><strong>Fecha Desde:</strong>&nbsp;&nbsp;<cfif isdefined ('form.desde') and form.desde NEQ "">#form.desde#</cfif></td>
			<td align="left"class="RLTtopline" nowrap="nowrap" colspan="3"><strong>&nbsp;&nbsp;&nbsp;&nbsp;Fecha Hasta:&nbsp;</strong><cfif isdefined ('form.hasta') and form.hasta NEQ "">#form.hasta#</cfif></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td  align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8" width="33%" valign="top" nowrap="nowrap">Anticipos</td>
		</tr>
		<tr>
			<td width="100%" colspan="8">
				<table width="100%" border="0">
					<tr>
						<td align="left" valign="top"><strong>N°.Ant</strong></td>
						<td align="left" valign="top"><strong>Forma Pago</strong></td>
						<td align="left" valign="top"><strong>Fecha Ant.</strong></td>
						<td align="left" valign="top"><strong>Monto</strong></td>
						<td align="left" valign="top"><strong>Estado</strong></td>
						<td align="left" valign="top"><strong>N°.SP</strong></td>					
					</tr>
					<cfloop query="rsAnticipos">
							<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td align="left" valign="top">#rsAnticipos.GEAnumero#</td>
								<td align="left" valign="top">#rsAnticipos.FormaPago#-#rsAnticipos.CCHcodigo#</td>
								<td align="left" valign="top">#LSDateFormat(rsAnticipos.GEAfechaSolicitud,"DD/MM/YYYY")#</td>
								<td align="left" valign="top">#lsnumberformat(rsAnticipos.GEAtotalOri,',.00')#&nbsp;#rsAnticipos.Miso4217#</td>
								<td align="left" valign="top">#rsAnticipos.TituloA#</td>
								<td align="left" valign="top">#rsAnticipos.TESSPnumero#</td>
							</tr>
					</cfloop>
				</table>
			</td>
		</tr>
		</cfoutput>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td  align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8" valign="top" nowrap="nowrap" >Gastos</td>
		</tr>
		<tr>
			<td colspan="8">
				<table width="100%" border="0">
					<tr>
						<td align="left" valign="top"><strong>N°Liq</strong></td>
						<td align="left" valign="top"><strong>Forma Pago</strong></td>
						<td align="left" valign="top"><strong>Fecha Liq.</strong></td>
						<td align="left" valign="top"><strong>Monto</strong></td>
						<td align="left" valign="top"><strong>Estado</strong></td>
						<td align="left" valign="top"><strong>Devoluci&oacute;n</strong></td>
						<td align="left" valign="top"><strong>N°.SP</strong></td>
						<td align="left" colspan="2" valign="top" width="200"><strong>Detalle Liquidacion</strong></td>
					</tr>
				<cfloop query="rsLiquidacion">
					<cfoutput>
						<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td align="left" valign="top">#rsLiquidacion.GELnumero#</td>
							<td align="left" valign="top">#rsLiquidacion.FormaPago#-#rsLiquidacion.CCHcodigo#</td>
							<td align="left" valign="top">#LSDateFormat(rsLiquidacion.GELfecha,"DD/MM/YYYY")#</td>
							<td align="left" valign="top">#lsnumberformat(rsLiquidacion.GELtotalGastos,',.00')#&nbsp;#rsLiquidacion.Miso4217#</td>
							<td align="left" valign="top">#rsLiquidacion.Titulo#</td>
							<cfif len(trim(rsLiquidacion.GELtotalDevoluciones)) eq 0>
								<td align="left" valign="top">&nbsp;</td>
							<cfelse>
								<td align="left" valign="top">#lsnumberformat(rsLiquidacion.GELtotalDevoluciones,',.00')#</td>
							</cfif>
							<td align="left" valign="top">#rsLiquidacion.TESSPnumero#&nbsp;</td>
							<td align="left" valign="top">&nbsp;</td>
							<td align="left" valign="top">&nbsp;</td>
						</tr>
					</cfoutput>
					<cfquery name="rsLiquidacionDet" datasource="#session.DSN#">
							select	'1'				as tipo,
									g.GELGnumeroDoc as numero,
									g.GELGtotalOri	as monto,
									''				as CBcodigo
							  from GEliquidacionGasto g
							 where g.GELid = #rsLiquidacion.GELid#
						UNION
							select	'2'				as tipo,
									<cf_dbfunction name="to_char" args="ae.GEAnumero"> 	as numero,
									a.GELAtotal		as monto,
									''				as CBcodigo
							  from GEliquidacionAnts a
								inner join GEanticipo ae
									on a.GEAid= ae.GEAid	
							 where a.GELid = #rsLiquidacion.GELid#
						UNION
							select	'3'					as tipo,
									d.GELDreferencia 	as numero,
									d.GELDtotalOri		as monto,
									b.CBcodigo 			as CBcodigo
							  from GEliquidacionDeps d
							  left join CuentasBancos b
										on b.CBid=d.CBid
							 where d.GELid = #rsLiquidacion.GELid#
                             	and coalesce(b.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
						ORDER BY 1,2
					</cfquery>
					<cfoutput query="rsLiquidacionDet" group="tipo">
						<tr>
							<td colspan="7">&nbsp;</td>
							<td align="left" valign="top" style="font-size:x-small; font-weight:bolder" colspan="2">
								<cfif tipo EQ "1">
									Detalle de Gastos
								<cfelseif tipo EQ "2">
									Detalle de Anticipos
								<cfelse>
									Detalle de Depositos
								</cfif>
							</td>
						</tr>	
						<cfoutput>
						<tr>
							<td colspan="7">&nbsp;</td>
							<td align="left" valign="top" style="font-size:x-small;" width="200" nowrap="nowrap">&nbsp;&nbsp;&nbsp;#trim(rsLiquidacionDet.numero)#</strong></td>
							<td align="left" valign="top" style="font-size:x-small;">#lsnumberformat(rsLiquidacionDet.monto,',.00')#</strong></td>
							<td align="left" valign="top" style="font-size:x-small;">#rsLiquidacionDet.CBcodigo#</strong></td>
						</tr>	
						</cfoutput>
					</cfoutput>
				</cfloop>
					</table>
				</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>		
		<!---<tr>
			<td  align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8"  valign="top" nowrap="nowrap" >Depositos</td>
		</tr>
		<tr>
			<td colspan="8">
				<cfoutput>
				<table width="100%" border="0">
					<tr>
						<td align="left" valign="top"><strong>Referencia</strong></td>
						<td align="left" valign="top"><strong>Banco</strong></td>
						<td align="left" valign="top" colspan="4"><strong>Monto</strong></td>
					</tr>
				<cfif len(trim(#rsLiquidacion.GELid#)) gt 0 and len(trim(#rsDeposito.GELid#)) gt 0>
					<cfloop query="rsDeposito">
						<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td align="left" valign="top">#rsDeposito.GELDreferencia#</td>
							<td align="left" valign="top">#rsDeposito.CBcodigo#</td>
							<td align="left" valign="top">#rsDeposito.GELDtotalOri#</td>
						</tr>
					</cfloop>
				</cfif>
				</table>
				</cfoutput>
			</td>
		</tr>--->
		<tr><td align="center" nowrap="nowrap" colspan="12"><p>&nbsp;</p>
				  <p>***Fin de Linea***</p></td></tr>
	</table>






