<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>
<cf_dbfunction name="op_concat" returnvariable="_CAT">
<cf_htmlReportsHeaders irA="#Regresar#" FileName="ReporteAcuerdopago.xls" title="Consulta">
<style type="text/css">
	.Tit{
		font-size:30px;
		font-weight:bold;
		color:#0000FF;
	}
	.SubTit{
		font-size:26px;
		font-weight:bold;
		color:#0000FF;
	}
	.fontT{
		font-size:12px;
	}
	.listaPar{
		background:#FFCCFF;
	}
	.listaNon{
		background:#FFFFFF;
	}
	.fontTTITULO{
		font-size:12px;
		color:#0000FF;
	}
	.fontCESION{
		font-size:12px;
		font-weight:bold;
		color:#660000;
	}
	.pageEnd{
		page-break-before:always;		
	}

</style>
<cfquery name="rsImagen" datasource="#session.dsn#">
	Select Elogo
	from Empresa
	where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsEncabezado" datasource="#session.dsn#">
	Select TESAPnumero, TESAPestado, TASAPfecha
	from TESacuerdoPago
	where TESAPid = #form.TESAPid#
</cfquery>
<cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="GetAcuerdoPago" returnvariable="rsAcuerdo">
		<cfinvokeargument name="TESAPid" 		value="#form.TESAPid#">
	</cfinvoke>
<cfquery name="rsLineasD" datasource="#session.dsn#">
	Select
		case sp.TESSPtipoDocumento
			when 0 		then 'Manual'
			when 1 		then 'CxP' 
			when 2 		then 'Antic.CxP' 
			when 3 		then 'Antic.CxC' 
			when 4 		then 'Antic.POS' 
			when 5 		then 'ManualCF' 
			when 6 		then 'Antic.GE' 
			when 7 		then 'Liqui.GE' 
			when 8		then 'Fondo.CCh' 
			when 9 		then 'Reint.CCh' 
			when 100 	then 'Interfaz' 
			else 'Otro'
		end as TipoSP
		, sp.TESSPnumero as NumeroSP
		,case 
			when sp.SNcodigoOri is not null then
			(
			select coalesce(sn.SNnombrePago, sn.SNnombre)  from SNegocios sn where sn.Ecodigo = sp.EcodigoOri and sn.SNcodigo = sp.SNcodigoOri
			)
			when sp.TESBid is not null then
			(
			select tb.TESBeneficiario from TESbeneficiario tb where tb.TESBid = sp.TESBid
			)
			else
			(
			select cd.CDCnombre from ClientesDetallistasCorp cd where cd.CDCcodigo = sp.CDCcodigo
			)
		end as Nombre
		, case 
			when sp.SNcodigoOri is not null then
			(
			select SNidentificacion from SNegocios sn where sn.Ecodigo = sp.EcodigoOri and sn.SNcodigo=sp.SNcodigoOri
			)
			when sp.TESBid is not null then
			(
			select TESBeneficiarioId from TESbeneficiario tb where tb.TESBid = sp.TESBid
			)
			else
			(
			select CDCidentificacion from ClientesDetallistasCorp cd where cd.CDCcodigo=sp.CDCcodigo
			)
		end as Cedula
		, case 
			when sp.SNcodigoOri is not null then
			(
			select min(rtrim(c.CFformato)) from SNegocios sn inner join CFinanciera c on c.Ccuenta = sn.SNcuentacxp where sn.Ecodigo = sp.EcodigoOri and sn.SNcodigo = sp.SNcodigoOri
			)
		end as CuentaFinanciera
		, cxp.NAP
		, dp.TESDPreferenciaOri #_CAT# ' ' #_CAT# dp.TESDPdocumentoOri as Factura
		, cxp.folio
		, m.Miso4217 					as Moneda
		, case
		when dp.TESDPtipoDocumento in (0,5) AND dp.TESDPmontoSolicitadoOri < 0 then 0 else dp.TESDPmontoSolicitadoOri
		end
		*case when sp.TESSPtipoDocumento = 5 then 	tessptipocambioorimanual
			  when sp.TESSPtipoDocumento <> 5  and (sp.TESSPtipocambioOrimanual is not null
				 							   		and sp.TESSPtipocambioOrimanual <> 1) then sp.TESSPtipocambioOrimanual
				else (case when dp.TESDPtipocambioori is null then 1 else dp.TESDPtipocambioori end) 
				end as MontoBruto
		, coalesce(dp.Rmonto,0)
		*case when sp.TESSPtipoDocumento = 5 then 	tessptipocambioorimanual
			  when sp.TESSPtipoDocumento <> 5  and (sp.TESSPtipocambioOrimanual is not null
				 							   		and sp.TESSPtipocambioOrimanual <> 1) then sp.TESSPtipocambioOrimanual
				else (case when dp.TESDPtipocambioori is null then 1 else dp.TESDPtipocambioori end) 
				end			as DeducRetencion
		, coalesce(dp.Mmonto,0)
		*case when sp.TESSPtipoDocumento = 5 then 	tessptipocambioorimanual
			  when sp.TESSPtipoDocumento <> 5  and (sp.TESSPtipocambioOrimanual is not null
				 							   		and sp.TESSPtipocambioOrimanual <> 1) then sp.TESSPtipocambioOrimanual
				else (case when dp.TESDPtipocambioori is null then 1 else dp.TESDPtipocambioori end) 
				end			as DeducMultas
		, coalesce(case
		when dp.TESDPtipoDocumento in (0,5) AND dp.TESDPmontoSolicitadoOri < 0 then -dp.TESDPmontoSolicitadoOri
		end,0)
		*case when sp.TESSPtipoDocumento = 5 then 	tessptipocambioorimanual
			  when sp.TESSPtipoDocumento <> 5  and (sp.TESSPtipocambioOrimanual is not null
				 							   		and sp.TESSPtipocambioOrimanual <> 1) then sp.TESSPtipocambioOrimanual
				else (case when dp.TESDPtipocambioori is null then 1 else dp.TESDPtipocambioori end) 
				end as DeducOtros
		, (dp.TESDPmontoSolicitadoOri - (coalesce(dp.Rmonto,0)+coalesce(dp.Mmonto,0)))
		*case when sp.TESSPtipoDocumento = 5 then 	tessptipocambioorimanual
			  when sp.TESSPtipoDocumento <> 5  and (sp.TESSPtipocambioOrimanual is not null
				 							   		and sp.TESSPtipocambioOrimanual <> 1) then sp.TESSPtipocambioOrimanual
				else (case when dp.TESDPtipocambioori is null then 1 else dp.TESDPtipocambioori end) 
				end
			as MontoNeto
		, case cpc.CPCtipo 
		when 'C' then 'CESION '		#_CAT# CPCdocumento #_CAT# ' a favor de ' #_CAT# (select SNnombre from SNegocios where SNid = cpc.SNidDestino)
		when 'E' then 'EMBARGO '	#_CAT# CPCdocumento #_CAT# ' a favor de ' #_CAT# (select SNnombre from SNegocios where SNid = cpc.SNidDestino)
		end as Cesion,
			case when ((sp.TESSPtipoDocumento in (5,10) and sp.TESSPtipocambioOrimanual =1))	 then ''
				 when (sp.TESSPtipoDocumento <> 5 and (dp.TESDPtipocambioori is null 
				 										and (sp.TESSPtipocambioOrimanual is not null)
				 										and (sp.TESSPtipocambioOrimanual <> 1)))
				 then '('#_CAT# <cf_dbfunction name="to_char" args="(rtrim(sp.TESSPtipocambioOrimanual))"> #_CAT#')'
				else
					case when sp.TESSPtipoDocumento = 5 then 
															'('#_CAT# <cf_dbfunction name="to_char" args="(rtrim(sp.TESSPtipocambioOrimanual))"> #_CAT#')' 
														else 
															'('#_CAT# <cf_dbfunction name="to_char" args="(rtrim(dp.TESDPtipocambioori))"> #_CAT#')' 
														end
				end as tipocambio
	from TESsolicitudPago sp
		inner join TESdetallePago dp
			left join HEDocumentosCP cxp
				on cxp.IDdocumento = dp.TESDPidDocumento and dp.TESDPtipoDocumento = 1
		on dp.TESSPid = sp.TESSPid and dp.RlineaId is null and dp.MlineaId is null
		inner join Monedas m
			on m.Ecodigo = sp.EcodigoOri and m.Mcodigo = sp.McodigoOri
		left join CPCesion cpc
			on cpc.CPCid = sp.CPCid
	where sp.EcodigoOri = #session.Ecodigo# and sp.TESAPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESAPid#">
	order by sp.TESSPnumero,cxp.folio
</cfquery>

<cfquery name="rsSUM" dbtype="query">
	Select sum(MontoBruto) MontoBruto, sum(DeducRetencion) DeducRetencion, sum(DeducMultas) DeducMultas, 
		sum(DeducOtros) DeducOtros, sum(MontoNeto) MontoNeto
	from rsLineasD
</cfquery>
<cfset CantEsp = 2>
<cfoutput>
<cfsavecontent variable="printEnc">
	<tr>
			<td align="center" colspan="27">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td align="right" colspan="3">Usuario: <strong>#session.Usulogin#</strong></td></tr>
					<tr>	
						<td width="250px" align="center"><img src="../../../home/public/logo_cuenta.cfm?CEcodigo=#session.CEcodigo#" height="60" border="0"></td>
						<td align="center" class="Tit">#session.Enombre#</td>
						<td width="250px" align="center">&nbsp;</td>
					</tr>
					<tr><td align="center" colspan="3" class="SubTit">Reporte de Pago A Proveedores</td></tr>
					<tr>
						<td>&nbsp;</td>
						<td align="center" class="SubTit">Acuerdo: #rsEncabezado.TESAPnumero#&nbsp;&nbsp;Fecha: #LSDateFormat(rsEncabezado.TASAPfecha, 'DD/MM/YYYY')#</td>
						<td>&nbsp;</td>
					</tr>
					<tr><td colspan="3" align="center">(<cfif rsEncabezado.TESAPestado eq 0>En Preparación<cfelseif rsEncabezado.TESAPestado eq 1>En Aprobación<cfelseif rsEncabezado.TESAPestado eq 2>Aprobado<cfelseif rsEncabezado.TESAPestado eq 3>Anulado</cfif>)</td>
				</table>
			</td>
		</tr>
		#RepeatString('<tr><td colspan="27">&nbsp;</td></tr>', 2)#
		<tr class="fontTTITULO">
			<td align="center" nowrap><strong>TIPO</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>No.</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>NOMBRE</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>CÉDULA</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>REGISTRO</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>RESERVA U</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>FACTURA</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>FACTURA</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>MON.</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>TOTAL A</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap colspan="3"><strong>DEDUCIONES</strong></td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap>&nbsp;</td><td>#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" nowrap><strong>NETO A</strong></td>
		</tr>
		<tr class="fontTTITULO">
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>SP</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>SP</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap>&nbsp;</td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', 2)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>JURÍDICA</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>CONTABLE</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>ORD/COMP</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>EMPRESA</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>CONAVI</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap>&nbsp;</td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', 2)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>PAGAR</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>2% RENTA</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>MULTAS</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>1 x 1000</strong></td><td style="border-bottom:ridge;border-bottom-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="center" style="border-bottom:ridge;border-bottom-width: thin" nowrap><strong>PAGAR</strong></td>
		</tr>
		<tr class="fontT">
					<td>&nbsp;  </td>
					<td>&nbsp;  </td>
		</tr>
</cfsavecontent>
	<cfif rsLineasD.recordcount gt 0>
	<cfset LvarLineasRecorridas = 0>
	<cfset counCeesion = 0>		
		<cfloop query="rsLineasD">
			<cfif LvarLineasRecorridas  GT 36 and rsLineasD.currentRow NEQ 1>
				    <tr class="fontT">
					</table>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr class="pageEnd"></tr>
					
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td>#printEnc#</td></tr>
					<cfset LvarLineasRecorridas = 3>
			<cfelse>
				<cfif rsLineasD.currentRow EQ 1>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td>#printEnc#</td></tr>
				</cfif>
				<cfset LvarLineasRecorridas = LvarLineasRecorridas+3>	
			</cfif>				
				<tr class="fontT">
				<td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#rsLineasD.TipoSP#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#rsLineasD.NumeroSP#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td  width="5%" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>nowrap>#Mid(rsLineasD.Nombre,1,20)##RepeatString('&nbsp;', 20 - Len(Mid(rsLineasD.Nombre,1,20)))#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#rsLineasD.Cedula#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#rsLineasD.CuentaFinanciera#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#rsLineasD.NAP#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#rsLineasD.Factura#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right"<cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#rsLineasD.folio#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="center"<cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#rsLineasD.Moneda# #rsLineasD.tipocambio#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#fnFormatMoney(rsLineasD.MontoBruto)#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#fnFormatMoney(rsLineasD.DeducRetencion)#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#fnFormatMoney(rsLineasD.DeducMultas)#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#fnFormatMoney(rsLineasD.DeducOtros)#</td><td <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RepeatString('&nbsp;', CantEsp)#</td>
				<td align="right" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> wrap>#fnFormatMoney(rsLineasD.MontoNeto)#</td>
			</tr>
			<cfif len(trim(rsLineasD.Cesion)) gt 0>
				<tr class="fontCESION">
					<td colspan="4" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> >&nbsp;</td>
					<td colspan="24" <cfif rsLineasD.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> >&nbsp;&nbsp;&nbsp;<strong>#rsLineasD.Cesion#</strong></td>
				</tr>
				<cfset LvarLineasRecorridas = LvarLineasRecorridas+1>
			</cfif>
			<tr class="fontT">
					<td>&nbsp;  </td>
					<td>&nbsp;  </td>
			</tr>
		</cfloop>
		<tr class="fontTTITULO">
			<td colspan="14" nowrap>&nbsp;</td>
			<td nowrap colspan="4"><strong>#LvarLineasRecorridas# MONTOS TOTALES</strong></td>
			<td align="right" style="border-top:ridge;border-top-width: thin" nowrap>#fnFormatMoney(rsSUM.MontoBruto)#</td><td style="border-top:ridge;border-top-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="right" style="border-top:ridge;border-top-width: thin" nowrap>#fnFormatMoney(rsSUM.DeducRetencion)#</td><td style="border-top:ridge;border-top-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="right" style="border-top:ridge;border-top-width: thin" nowrap>#fnFormatMoney(rsSUM.DeducMultas)#</td><td style="border-top:ridge;border-top-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="right" style="border-top:ridge;border-top-width: thin" nowrap>#fnFormatMoney(rsSUM.DeducOtros)#</td><td style="border-top:ridge;border-top-width: thin">#RepeatString('&nbsp;', CantEsp)#</td>
			<td align="right" style="border-top:ridge;border-top-width: thin" nowrap>#fnFormatMoney(rsSUM.MontoNeto)#</td>
		</tr>
		#RepeatString('<tr><td colspan="27">&nbsp;</td></tr>', 1)#
		<tr><td colspan="14"><table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr class="fontT">
				<td>&nbsp;</td>
				<td nowrap>________________________________________</td>
				<td>#RepeatString('&nbsp;', 20)#</td>
				<td nowrap>________________________________________</td>
				<td>&nbsp;</td>
			</tr>
			<cfset espacio = RepeatString('&nbsp;', 20)>
			<tr class="fontT">
				<td>&nbsp;</td>
				<td nowrap>#espacio##ListGetAt(rsAcuerdo.TESAPautorizador1, 1,';')#</td>
				<td>#RepeatString('&nbsp;', 40)#</td>
				<td nowrap>#espacio##ListGetAt(rsAcuerdo.TESAPautorizador2, 1,';')#</td>
				<td>&nbsp;</td>
			</tr>
				<tr>
				<td>&nbsp;</td>
				<td nowrap>#espacio#<cfif ListLen(rsAcuerdo.TESAPautorizador1,';') gt 1 >#ListGetAt(rsAcuerdo.TESAPautorizador1, 2,';')#</cfif></td>
				<td>&nbsp;</td>
				<td nowrap>#espacio#<cfif ListLen(rsAcuerdo.TESAPautorizador2,';') gt 1 >#ListGetAt(rsAcuerdo.TESAPautorizador2, 2,';')#</cfif></td>
				<td>&nbsp;</td>
			</tr>
		</table></td>
	<cfelse>
		<td align="center"><strong>No exiten datos para este Acuerdo de Pago</strong></td>
	</tr></cfif>
	
</table>
</cfoutput>
</body></html>
<cffunction name="fnFormatMoney" access="private" returntype="string">
	<cfargument name="Monto" type="numeric">
	<cfargument name="Decimales" type="numeric" default="2">
	<cfreturn LsCurrencyFormat(NumberFormat(Arguments.Monto,".99"),'none')>
</cffunction>