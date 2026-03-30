<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DiasPlaneados" default ="d&iacute;as planeados" returnvariable="LB_DiasPlaneados" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_UnDiaPlaneado" default ="Un d&iacute;a planeado" returnvariable="LB_UnDiaPlaneado" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Desde" default ="desde" returnvariable="LB_Desde" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Hasta" default ="hasta" returnvariable="LB_Hasta" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default ="Oficina" returnvariable="LB_Oficina" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoSeHanAplicadoLiquidaciones" default ="No se han aplicado Liquidaciones" returnvariable="MSG_NoSeHanAplicadoLiquidaciones" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DiasTotales" default ="días totales" returnvariable="LB_DiasTotales" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_UnDiaTotal" default ="Un día total" returnvariable="LB_UnDiaTotal" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NuevaLiquidacion" default ="Nueva Liquidaci&oacute;n" returnvariable="LB_NuevaLiquidacion" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PorTesoreria" default ="Por Tesorer&iacute;a" returnvariable="LB_PorTesoreria" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ConChequeTEF" default ="Con Cheque o TEF" returnvariable="LB_ConChequeTEF" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PorCajaChica" default ="Por Caja Chica" returnvariable="LB_PorCajaChica" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ConEfectivoPorCajaEspecial" default ="Con Efectivo por Caja Especial" returnvariable="LB_ConEfectivoPorCajaEspecial" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Dias" default ="d&iacute;as" returnvariable="LB_Dias" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Dia" default ="d&iacute;a" returnvariable="LB_Dia" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MotivoRechazo" default ="Motivo de Rechazo" returnvariable="LB_MotivoRechazo" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PorFavorReviseLosSiguientesDatos" default ="Por favor revise los siguiente datos" returnvariable="MSG_PorFavorReviseLosSiguientesDatos" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DeseaRechazarLaLiquidacion" default ="¿Desea RECHAZAR la Liquidación" returnvariable="MSG_DeseaRechazarLaLiquidacion" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeDigitarUnaRazonDeCambio" default ="Debe digitar una razón de rechazo" returnvariable="MSG_DebeDigitarUnaRazonDeCambio" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TB_Anticipos" default ="Anticipos" returnvariable="TB_Anticipos" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TB_DocumentosGastos" default ="Documentos de Gastos" returnvariable="TB_DocumentosGastos" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TB_DepositosBancarios" default ="Dep&oacute;sitos Bancarios" returnvariable="TB_DepositosBancarios" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TB_DepositosEfectivo" default ="Dep&oacute;sitos en Efectivo" returnvariable="TB_DepositosEfectivo" xmlfile = "AprobarTrans_formLiq.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TB_Devoluciones" default ="Devoluciones" returnvariable="TB_Devoluciones" xmlfile = "AprobarTrans_formLiq.xml">

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfparam name="url.tab" default="1">
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
		select
				CCHid,
				CCHdescripcion,
				CCHcodigo
		from CCHica
		where Ecodigo=#session.Ecodigo#
		and CCHestado='ACTIVA'

</cfquery>
<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select m.Mcodigo, m.Miso4217
	  from Empresas e
		inner join Monedas m on m.Mcodigo = e.Mcodigo
	  where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfset LvarTipoDocumento = 7>
<form action="AprobarTrans_sql.cfm" name="form1" method="post" onsubmit="return validar(this);" id="form1">
<input type="hidden" name="TIPO" value="GASTO">
<cfif isdefined('url.GELid') and not isdefined ('form.GELid')>
	<cfset form.GELid=#url.GELid#>
		<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined ('url.Mensaje')>
	<script lenguage="javascript">
		alert('No se puede aprobar la liquidación porque el pago al empleado es mayor que cero y quedan saldos en los anticipos');
	</script>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined('form.GELid')>
	<cfset llave=#form.GELid#>
	<cfset modo = 'CAMBIO'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select
			a.GELid,
			a.GELfecha,
			coalesce(a.CCHid,0) as CCHid,
			a.GELnumero,
			a.Mcodigo,
			a.GELdesde, a.GELhasta,
			a.CFid,
			a.TESBid,
			a.BMUsucodigo,
			a.ts_rversion,
			a.GELtipoCambio,
			a.GELestado,
			a.GELmsgRechazo,
			a.GELtipoP,
				case
					when a.CCHid is null then 'TES'
					when (select CCHtipo from CCHica where CCHid = a.CCHid) = 2 then 'TES'
					else 'CCH'
				end as GELtipoPago,
			GELdescripcion,
			GEAviatico,
			GEAtipoviatico,
			a.GECid as GECid_comision,

			case
				when GELtotalDocumentos = 0 AND GELtotalGastos <> 0 then 1 else 0
			end as InitDocs,
			case
				when GELtotalDocumentos = 0 AND GELtotalGastos <> 0 then GELtotalGastos else GELtotalDocumentos
			end as GELtotalDocumentos,
			GELtotalGastos,
			GELtotalTCE,
			GELtotalRetenciones,

			GELtotalAnticipos,

			GELtotalDepositos,
			GELtotalDepositosEfectivo,
			GELtotalDevoluciones,

			GELreembolso,
			( select rtrim(cf.CFcodigo) #LvarCNCT# '-' #LvarCNCT# cf.CFdescripcion
				from CFuncional cf
				where cf.CFid = a.CFid
			) as CentroFuncional,

			(select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2
				from DatosEmpleado Em,TESbeneficiario te
					where a.TESBid=te.TESBid
					and Em.DEid=te.DEid
			) as Empleado,

			(select DEid
				from TESbeneficiario te
					where a.TESBid=te.TESBid
			) as DEid,

			mo.Mnombre as Moneda, mo.Mnombre, mo.Miso4217,
				(GELtotalDepositos + GELtotalDepositosEfectivo + GELtotalDevoluciones ) as MiDevolucion,
				(GELtotalGastos - GELtotalRetenciones - GELtotalAnticipos - GELtotalTCE 
					+ (GELtotalDepositos + GELtotalDepositosEfectivo + GELtotalDevoluciones )
					- GELreembolso) as MiTotal
		  from GEliquidacion a
				left outer join CFuncional b
					on b.CFid 		= a.CFid
					and b.Ecodigo 	= a.Ecodigo
				left join Monedas mo
					on mo.Mcodigo = a.Mcodigo
		where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
</cfif>
<cfset LvarSAporComision = isdefined("rsForm") and rsForm.GECid_comision NEQ "">
<cfif LvarSAporComision>
	<cfquery name="rsGEcomision" datasource="#session.dsn#">
		select 	cc.GECnumero, cc.GECdescripcion, cc.TESBid, cc.CFid,
				b.DEid,
				d.DEidentificacion, d.DEnombre #LvarCNCT#' '#LvarCNCT# d.DEapellido1 #LvarCNCT#' '#LvarCNCT# d.DEapellido2 as DEnombre,
				cf.CFcodigo, cf.CFdescripcion, ofi.Oficodigo,
				GECdesdePlan,GEChastaPlan,
				GECautomovil,GEChotel,GECavion,GECtipo,GEInternet,
				GECdesdeReal,GEChastaReal,
				GECobservacionesLiq,GECobservacionesResultado,GECobservacionesExceso
		  from GEcomision cc
		 	inner join TESbeneficiario b
		 		on b.TESBid=cc.TESBid
		  	inner join DatosEmpleado d
				on d.DEid=b.DEid
		  	inner join CFuncional cf
				on cf.CFid = cc.CFid
		  	inner join Oficinas ofi
				 on ofi.Ecodigo = cf.Ecodigo
				and ofi.Ocodigo = cf.Ocodigo
		 where GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.GECid_comision#">
	</cfquery>
</cfif>

<!---Total Anticipos --->
<cfquery name="totalAntic" datasource="#session.dsn#">
	select coalesce(sum(GELAtotal),0) as totalAnticipos
	from GEliquidacionAnts
	where GELid=1
</cfquery>

<cfquery name="sinAnticipos" datasource="#session.dsn#">
	select a.GEAid
	from GEliquidacionAnts a
			 inner join GEanticipoDet c
			   on c.GEAid=a.GEAid
			   and c.GEADid=a.GEADid
		where 	a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" >
</cfquery>

<!--- Query que determina si el Usuario es Aprobador de Tesoria--->
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
	select
			c.CCHtipo,
			c.CCHid,
			c.CCHdescripcion #LvarCNCT# ' - ' #LvarCNCT# m.Miso4217 as CCHdescripcion,
			c.CCHcodigo,
			m.Miso4217, m.Mcodigo
	from CCHica c
		inner join Monedas m
		on m.Mcodigo=c.Mcodigo
	where c. Ecodigo=#session.Ecodigo#
	  and c.CCHestado='ACTIVA'
	  and c.CCHtipo <> 3
	<cfif rsForm.GELtipoPago EQ "CCH">
		  and c.CCHid = #rsForm.CCHid#   <!--- Compatibilidad cuando no se verificaba CF y ya se habia incluido una CCH --->
	<cfelseif modo EQ 'CAMBIO' AND rsForm.GELtipoPago EQ "TES">
		  and c.CCHtipo = 2   <!--- Por tesoreria solo se permite Cajas Especiales --->
	<cfelseif LvarSAporComision>
		  and c.CCHtipo = 2   <!--- Por comisión solo se permite Cajas Especiales --->
	</cfif>
	order by c.CCHtipo desc
</cfquery>

<cfoutput>
<input type="hidden" name="msgRechazo" value="">
<input type="hidden" name="GELid" value="#llave#">
	<table align="center" summary="Tabla de entrada"  width="90%" border="0">
	<cfif LvarSAporComision>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_NumComision xmlfile = "AprobarTrans_formLiq.xml">Num. Comision</cf_translate>:&nbsp;</strong>
			</td>
			<td>
				<input type="hidden" name="GECid_comision" value="#rsForm.GECid_comision#">
				<input type="hidden" name="DEid" value="#rsGEcomision.DEid#">
				<input type="text" value="#rsGEcomision.GECnumero# - #rsGEcomision.GECdescripcion#"
					readonly tabindex="-1"
					style="border:none; font-weight:bold; width:350px"
				>

			</td>
			<td align="right">
				<strong><cf_translate key = LB_Planeado xmlfile = "AprobarTrans_formLiq.xml">Planeado</cf_translate>:&nbsp;</strong>
			</td>
			<td>
				<cfif rsGEcomision.GECdesdePlan NEQ "">
					<cfset LvarDias = datediff("d",rsGEcomision.GECdesdePlan,rsGEcomision.GEChastaPlan)+1>
					<cfif LvarDias GT 1>
						<cfset LvarDias = "#LvarDias# #LB_DiasPlaneados#">
					<cfelse>
						<cfset LvarDias = "#LB_UnDiaPlaneado#">
					</cfif>
					<input type="text" value="#LB_Desde# #dateFormat(rsGEcomision.GECdesdePlan,"DD/MM/YYYY")# #LB_Hasta# #dateFormat(rsGEcomision.GEChastaPlan,"DD/MM/YYYY")#  #LvarDias#" style="border:none" size="60" readonly/>
				</cfif>
			</td>
		</tr>
		<tr>
			<!---Centro Funcional --->
			<td align="right">
				<strong><cf_translate key = LB_CentroFuncional xmlfile = "AprobarTrans_formLiq.xml">Centro&nbsp;Funcional</cf_translate>:&nbsp;</strong>
			</td>
			<td colspan="1">
				<input type="text" name="CFuncional" value="#trim(rsGEcomision.CFcodigo)# - #trim(rsGEcomision.CFdescripcion)# (#LB_Oficina#: #trim(rsGEcomision.Oficodigo)#)" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
			 </td>
			<td align="right">
				<strong><cf_translate key = LB_Aprobado xmlfile = "AprobarTrans_formLiq.xml">Aprobado</cf_translate>:&nbsp;</strong>
			</td>
			<td>
				<cfif rsGEcomision.GECdesdeReal EQ "">
					#MSG_NoSeHanAplicadoLiquidaciones#
				<cfelse>
					<cfset LvarDias = datediff("d",rsGEcomision.GECdesdeReal,rsGEcomision.GEChastaReal)+1>
					<cfif LvarDias GT 1>
						<cfset LvarDias = "#LvarDias# #LB_DiasTotales#">
					<cfelse>
						<cfset LvarDias = "#LB_UnDiaTotal#">
					</cfif>
					#LB_Desde# #dateFormat(rsGEcomision.GECdesdeReal,"DD/MM/YYYY")# #LB_Hasta# #dateFormat(rsGEcomision.GEChastaReal,"DD/MM/YYYY")#
					&nbsp;<strong>#LvarDias#</strong>
				</cfif>
			</td>

		</tr>
		<tr>
			<!---Empleado--->
			<td align="right">
				<strong><cf_translate key = LB_Empleado xmlfile = "AprobarTrans_formLiq.xml">Empleado</cf_translate>:&nbsp;</strong>
			</td>
			<td colspan="1">
				<input type="text" name="CFuncional" value="#trim(rsGEcomision.DEidentificacion)# - #trim(rsGEcomision.DEnombre	)#" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
			 </td>
			<td align="right">
				<strong><cf_translate key = LB_Tipo xmlfile = "AprobarTrans_formLiq.xml">Tipo</cf_translate>:&nbsp;</strong>
			</td>
			<td>
				<cfif rsGEcomision.GECtipo EQ 1><cf_translate key = LB_Nacional xmlfile = "AprobarTrans_formLiq.xml">Nacional</cf_translate><cfelse><cf_translate key = LB_Exterior xmlfile = "AprobarTrans_formLiq.xml">Exterior</cf_translate></cfif>
				<cfif rsGEcomision.GECautomovil EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled"><cf_translate key = LB_Automovil xmlfile = "AprobarTrans_formLiq.xml">Automóvil</cf_translate>
				</cfif>
				<cfif rsGEcomision.GEChotel EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled"><cf_translate key = LB_Hotel xmlfile = "AprobarTrans_formLiq.xml">Hotel</cf_translate>
				</cfif>
				<cfif rsGEcomision.GECavion EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled"><cf_translate key = LB_Avion xmlfile = "AprobarTrans_formLiq.xml">Avión</cf_translate>
				</cfif>
                <cfif rsGEcomision.GEInternet EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled"><cf_translate key = LB_PaqDatosMov xmlfile = "solicitudesAnticipo.xml">Paquete de Datos Moviles</cf_translate>
				</cfif>

<!---				</cfif>
--->
			</td>
		</tr>
		<tr>
			<td colspan="10" style="border-top:solid 1px ##CCCCCC; font-size:1px;" >&nbsp;</td>
		</tr>
	</cfif>
		<tr>
		<td colspan="6">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<!---Número de la Liquidación --->
							<td valign="top" align="right" nowrap="nowrap"><strong><cf_translate key = LB_NumLiquidacion xmlfile = "AprobarTrans_formLiq.xml">Núm. Liquidación</cf_translate>:&nbsp;</strong>
							</td>
							<td valign="top">
								<cfif modo NEQ 'ALTA'>
									<input type="text" name="GELnumero" value="#rsForm.GELnumero#" style="border:none; font-weight:bolder; width:195px" tabindex="-1" readonly="true">
									<input type="hidden" name="Mcodigo" value="#rsForm.Mcodigo#">
									<input type="hidden" name="CFid" value="#rsForm.CFid#">
								<cfelse>
									<input type="text" value="-- #LB_NuevaLiquidacion# --" style="border:none; font-weight:bolder; width:195px" tabindex="-1" readonly="true">
								</cfif>
							<!---Fecha Liquidación--->
								<strong><cf_translate key = LB_Fecha xmlfile = "AprobarTrans_formLiq.xml">Fecha</cf_translate>:&nbsp;</strong>
								<cfif modo NEQ 'ALTA'>
									<strong>#LSDateFormat(rsForm.GELfecha,"DD/MM/YYYY")#</strong>
								<cfelse>
									&nbsp;&nbsp; <strong>#LSDateFormat(now(),"DD/MM/YYYY")#</strong>
								</cfif>
							</td>
						</tr>
						<tr>
							<!---Descripción Liquidación --->
							<td valign="top" align="right" nowrap="nowrap">
									<strong><cf_translate key = LB_Descripcion xmlfile = "AprobarTrans_formLiq.xml">Descripción</cf_translate>:&nbsp;</strong>
							</td>
							<td>
									<input type="text"
									  tabindex="1"
									  maxlength="40"
									  size="60"
									  id="GELdescripcion"
									  readonly tabindex="-1" style="border:none"
									  value="<cfif modo NEQ 'ALTA'>#trim(rsForm.GELdescripcion)#</cfif>">
							</td>
						</tr>
					<cfif NOT LvarSAporComision>
						<tr>
							<!---Centro Funcional --->
							<td align="right">
								<strong><cf_translate key = LB_CentroFuncional xmlfile = "AprobarTrans_formLiq.xml">Centro&nbsp;Funcional</cf_translate>:&nbsp;</strong>
							</td>
							<td colspan="1">
								<cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
									<input type="text" name="CFuncional" value="#trim(rsAnticipo.CFcodigo)# - #trim(rsAnticipo.CFdescripcion)# (Oficina: #trim(rsAnticipo.Oficodigo)#)" disabled="disabled" size="55"/>
								<cfelseif modo neq 'ALTA'>
									<cfquery name="rsCF" datasource="#session.dsn#">
										select CFcodigo,CFdescripcion from CFuncional where CFid=#rsForm.CFid#
									</cfquery>
									<input name="CFunc" type="text" readonly tabindex="-1" style="border:none" value="#trim(rsCF.CFcodigo)# - #rsCF.CFdescripcion#" size="55" />
								<cfelse>
									<cf_cboCFid tabindex="1">
								</cfif>
							</td>
						</tr>
						<tr>
							<!---Empleado--->
							<td align="right">
								<strong><cf_translate key = LB_Empleado xmlfile = "AprobarTrans_formLiq.xml">Empleado</cf_translate>:&nbsp;</strong>
							</td>
							<td valign="top" nowrap="nowrap">
								<input type="text"
								  tabindex="1"
								  maxlength="40"
								  size="60"
								  id="GELdescripcion"
								  readonly tabindex="-1" style="border:none"
								  value="#rsForm.Empleado#">

								<input type="hidden" name="DEid" id="DEid" value="#rsForm.DEid#" />
							</td>
						</tr></cfif>

						<tr>
							<!--- Moneda Local --->
							<td valign="top" align="right">
								<strong><cf_translate key = LB_Moneda xmlfile = "AprobarTrans_formLiq.xml">Moneda</cf_translate>:&nbsp;</strong>
							</td>
							<td valign="top">
								<input type="text"
								  tabindex="1"
								  maxlength="40"
								  size="60"
								  id="GELdescripcion"
								  readonly tabindex="-1" style="border:none"
								  value="#rsForm.Moneda#">
							</td>
						</tr>
						<tr>
							<!--- Tipo Cambio --->
							<td valign="top" align="right">
								<strong><cf_translate key = LB_TipoCambio xmlfile = "AprobarTrans_formLiq.xml">Tipo de Cambio</cf_translate>:&nbsp;</strong>
							</td>
							<td valign="top">
								<input type="text"
								  tabindex="1"
								  maxlength="40"
								  size="60"
								  id="GELdescripcion"
								  readonly tabindex="-1" style="border:none"
								  value="#NumberFormat(rsForm.GELtipoCambio,"0.0000")#">

							</td>
						</tr>
						<cfif  modo NEQ 'ALTA' AND rsForm.GELdesde NEQ "">
							<cfset LvarGELdesde	= rsForm.GELdesde>
							<cfset LvarGELhasta	= rsForm.GELhasta>
							<cfset LvarDias = datediff("d",LvarGELdesde,LvarGELhasta)+1>
						<cfelseif LvarSAporComision>
							<cfif rsGEcomision.GECdesdeReal EQ "">
								<cfset LvarGELdesde	= rsGEcomision.GECdesdePlan>
								<cfset LvarGELhasta	= rsGEcomision.GEChastaPlan>
							<cfelse>
								<cfset LvarGELdesde	= rsGEcomision.GECdesdeReal>
								<cfset LvarGELhasta	= rsGEcomision.GEChastaReal>
							</cfif>
							<cfset LvarDias = datediff("d",LvarGELdesde,LvarGELhasta)+1>
						<cfelse>
							<cfset LvarGELdesde	= now()>
							<cfset LvarGELhasta	= now()>
							<cfset LvarDias = 1>
						</cfif>
						<cfif LvarGELdesde EQ "">
							<cfset LvarDias = "">
						<cfelse>
							<cfif LvarDias GT 1>
								<cfset LvarDias = "#LvarDias# #LB_Dias#">
							<cfelse>
								<cfset LvarDias = "#LvarDias# #LB_Dia#">
							</cfif>
							<cfset LvarGELdesde	= DateFormat(LvarGELdesde,'DD/MM/YYYY') >
							<cfset LvarGELhasta	= DateFormat(LvarGELhasta,'DD/MM/YYYY') >
						</cfif>
						<tr>
							<!---Fechas--->
							<td align="right"><strong><cf_translate key = LB_FechasReales xmlfile = "AprobarTrans_formLiq.xml">Fechas Reales</cf_translate>:&nbsp;</strong></td>
							<td colspan="10" nowrap="nowrap">
								<table border="0">
									<tr>
										<td align="left">#LB_Desde#:</td>
										<td>#LvarGELdesde#</td>
										<td align="right">&nbsp;#LB_Hasta#:</td>
										<td>#LvarGELhasta#</td>
										<td align="left"><strong>#LvarDias#</strong></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="middle"align="right" nowrap="nowrap">
								<strong><cf_translate key = LB_FormaPago xmlfile = "AprobarTrans_formLiq.xml">Forma de Pago</cf_translate>:&nbsp; </strong>
							</td>
							<td valign="middle" align="left" nowrap="nowrap">
</cfoutput>
									<select name="FormaPago" id="FormaPago">
									<cfif rsForm.GELtipoPago EQ "TES">
										<optgroup label="<cfoutput>#LB_PorTesoreria#</cfoutput>">
										<option value="0" <cfif modo EQ 'CAMBIO'and rsForm.CCHid EQ 0> selected</cfif>><cfoutput>#LB_ConChequeTEF#</cfoutput></option>
									</cfif>
											<cfif rsCajaChica.RecordCount>
												<cfoutput query="rsCajaChica" group="CCHtipo">
													<cfif CCHtipo EQ 1>
														<optgroup label="<cfoutput>#LB_PorCajaChica#</cfoutput>">
													<cfelse>
														<optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cfoutput>#LB_ConEfectivoPorCajaEspecial#</cfoutput>">
													</cfif>
													<cfoutput>
													<option value="#rsCajaChica.CCHid#" <cfif modo neq "ALTA" and rsCajaChica.CCHid  eq rsForm.CCHid> selected="selected" </cfif>>#rsCajaChica.CCHcodigo#-#rsCajaChica.CCHdescripcion#</option>
													</cfoutput>
												</cfoutput>
												</optgroup>
											</cfif>
									</select>
									<script language="javascript">
										var CCH = new Object();
									<cfoutput query="rsCajaChica">
										CCH["#rsCajaChica.CCHid#"] = #rsCajaChica.Mcodigo#;
									</cfoutput>
									</script>
<cfoutput>
									<cfif modo eq 'CAMBIO'>
										<input type="hidden" name="CCHid" value="#rsForm.CCHid#" />
									</cfif>

							</td>
						</tr>
						<tr>
						<cfif NOT LvarSAporComision>
							<td align="right" valign="top" nowrap>
								<strong><cf_translate key = LB_Viaticos xmlfile = "AprobarTrans_formLiq.xml">Vi&aacute;tico</cf_translate>:&nbsp;</strong>
							</td>
							<td>
								<input type="checkbox" id="GEAviatico" name="GEAviatico" tabindex="1"    disabled="disabled"  <cfif modo NEQ "ALTA" and #rsForm.GEAviatico# EQ 1>checked="checked"  </cfif>  value="1"  />
							<cfif isdefined ("rsForm.GEAviatico") and rsForm.GEAviatico EQ 1>
								<img src="../AppData/Local/Microsoft/Windows/Temporary Internet Files/imagenes/find.small.png" style="cursor:pointer" onclick="MostrarViaticos(#form.GELid#);" />
							</cfif>
							&nbsp;&nbsp;&nbsp;
						<cfelse>
							<td></td>
							<td>
						</cfif>
								<strong><cf_translate key = LB_Tipo xmlfile = "AprobarTrans_formLiq.xml">Tipo</cf_translate>:&nbsp;</strong>
								<cfif #rsForm.GEAtipoviatico# EQ 2><cf_translate key = LB_Exterior xmlfile = "AprobarTrans_formLiq.xml">Exterior</cf_translate><cfelse><cf_translate key = LB_Nacional xmlfile = "AprobarTrans_formLiq.xml">Nacional</cf_translate></cfif>
							</td>
						</tr>
					</table>
					</td>
					<td valign="top">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
					<cfif modo NEQ "ALTA">
						<!--- Detalle de Liquidación --->
						<cfset LvarResult 		= createobject("component","sif.tesoreria.Componentes.TESgastosEmpleado").sbImprimirResultadoLiquidacion(rsForm)>
						<cfset LvarTotal 		= LvarResult.Total>
						<cfset LvarDevoluciones = LvarResult.Devoluciones>
						<cfset rsTotalReal 		= LvarResult.rsViaticos>
					</cfif>
					</table>
					</td>
				</tr>
			</table>
		</td>
		</tr>

	<cfif #rsForm.GELmsgRechazo# neq ''>
		<tr>
			<td valign="top" align="right"><div align="right"><strong>#LB_MotivoRechazo#:</strong></div></td>
			<td valign="top"><font color="FF0000">#rsForm.GELmsgRechazo#</font></td>
			<td valign="top" align="right" nowrap>&nbsp;</td>
			<td valign="top">&nbsp;</td>
		</tr>
	</cfif>
		<tr>
			<td colspan="10">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts" />
				<cfset LvarEsAprobadorGE = true>
				<cfinclude template="TESbtn_Aprobarliq.cfm">
			</td>
		</tr>
	</table>
  </form>
 </cfoutput>
<!---TAP--->
<cf_templatecss>
	<script language="JavaScript" type="text/JavaScript">
		function MM_reloadPage(init)
		{
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		function validar(formulario)
		{
			var error_input;
			var error_msg = '';

			if (formulario.FormaPago.value == "") {
				error_msg += "\n - Debe seleccionar una forma de Pago.";
				error_input = formulario.FormaPago;
				}

			// Validacion terminada
			if (error_msg.length != "") {
				alert("#MSG_PorFavorReviseLosSiguientesDatos#:"+error_msg);
				error_input.focus();
				return false;
			}
			return true;
		}

		function MostrarViaticos(GELid) {
			_VControl = false;
			_lvar_width = 1200;
			_lvar_height = 600;
			_lvar_left = 100;
			_lvar_top = 100;
			//_lvar_num = GEAnumero;
			_lvar_liq = GELid;
			_lvar_ant = -1;
			_lvar_via = 1;

			if(_VpopUpWin) {
				if(!_VpopUpWin.closed) _VpopUpWin.close();
			}
			_VpopUpWin = open('/cfmx/sif/tesoreria/GestionEmpleados/DetalleAnticipo.cfm?GELid='+_lvar_liq+'&GEAviatico='+_lvar_via+'&GEAid='+_lvar_ant+'', '_VpopUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+_lvar_width+',height='+_lvar_height+',left='+_lvar_left+', top='+_lvar_top+',screenX='+_lvar_left+',screenY='+_lvar_top+'');

		}

	</script>
			<cfif not isdefined("form.tab") and isdefined("url.tab") >
               <cfset form.tab = url.tab >
			</cfif>
			<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab) )>
               <cfset form.tab = 1 >
    		</cfif>
			<cf_tabs width="99%">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_DatosGenerales"
				Default="Anticipos"
				returnvariable="X"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Cuentas"
					Default="Gastos Empleado"
					returnvariable="X"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Depositos"
					Default="Depositos"
					returnvariable="X"/>

				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Depositos"
					Default="Depositos"
					returnvariable="X"/>

					<cf_tab text="#TB_Anticipos#" selected="#form.tab eq 1#">
						<cfinclude template="TabT1_Anticipos_Aprobar.cfm">
					</cf_tab>

					<cf_tab text="#TB_DocumentosGastos#" selected="#form.tab eq 2#">
						<cfinclude template="TabT2_Gastos.cfm">
					</cf_tab>
				<cfif rsForm.GELtipoPago EQ 'TES'>
					<cf_tab text="#TB_DepositosBancarios#" selected="#form.tab eq 3#">
						<cfinclude template="TabT3_Depositos.cfm">
					</cf_tab>
					<cf_tab text="#TB_DepositosEfectivo#" selected="#form.tab eq 5#">
						<cfinclude template="TabT5_DepositosE.cfm">
					</cf_tab>
				<cfelse>
					<cf_tab text="TB_Devoluciones" selected="#form.tab eq 4#">
						<cfinclude template="TabT4_Devoluciones.cfm">
					</cf_tab>
				</cfif>
			</cf_tabs>
		<cf_web_portlet_end>
        </td>
      </tr>
    </table>

<script language="javascript">
		function funcRechazar()
		{
			var vReason = prompt('<cfoutput>#MSG_DeseaRechazarLaLiquidacion#</cfoutput> #. <cfoutput>#rsForm.GELnumero#</cfoutput>?, <cfoutput>#MSG_DebeDigitarUnaRazonDeCambio#</cfoutput>!','');
			if (vReason != null )
			{
				if(vReason != '')
				{
				document.form1.msgRechazo.value = vReason;
				return true;
				}
				else
				{
				alert('<cfoutput>#MSG_DebeDigitarUnaRazonDeCambio#</cfoutput>!');
				return false;
				}
			}
			else
			{
			return false;
			}

		}
</script>
