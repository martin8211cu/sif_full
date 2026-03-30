<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "ListaEmpleados" default = "Lista Empleados" returnvariable="ListaEmpleados" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DiasPlaneados" default = "d&iacute;as planeados" returnvariable="LB_DiasPlaneados" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_UnDiaPlaneado" default = "Un d&iacute;a planeado" returnvariable="LB_UnDiaPlaneado" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Desde" default = "Desde" returnvariable="LB_Desde" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Hasta" default = "Hasta" returnvariable="LB_Hasta" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DiasTotales" default = "d&iacute;as totales" returnvariable="LB_DiasTotales" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_UnDiaTotal" default = "Un d&iacute;a total" returnvariable="LB_UnDiaTotal" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NuevaLiquidacion" default = "Nueva Liquidaci&oacute;n" returnvariable="LB_NuevaLiquidacion" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Identificacion" default = "Identificaci&oacute;n" returnvariable="LB_Identificacion" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Nombre" default = "Nombre" returnvariable="LB_Nombre" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Apellido1" default = "Apellido 1" returnvariable="LB_Apellido1" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Apellido2" default = "Apellido 2" returnvariable="LB_Apellido2" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Dias" default = "d&iacute;as" returnvariable="LB_Dias" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Dia" default = "d&iacute;a" returnvariable="LB_Dia" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_PorTesoreria" default = "Por Tesorer&iacute;a" returnvariable="LB_PorTesoreria" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ConChequeTEF" default = "Con Cheque o TEF" returnvariable="LB_ConChequeTEF" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_PorCajaChica" default = "Por Caja Chica" returnvariable="LB_PorCajaChica" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ConEfectivoPorCajaEspecial" default = "Con Efectivo por Caja Especial" returnvariable="LB_ConEfectivoPorCajaEspecial" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MotivoRechazo" default = "Motivo de Rechazo" returnvariable="LB_MotivoRechazo" xmlfile = "LiquidacionAnticipos_form.xml">


<cfparam name="LvarSAporComision" default="false">
<cfset btnNameCalcular="CalcularViaticos">
<cfset btnValueCalcular= "Calcular Viaticos">
<cfset btnExcluirAbajo="Cambio,Baja,Nuevo,Alta,Limpiar">	
<!--- Formulario para la insercion de un encabezado de una liquidación --->
<cf_dbfunction name="op_concat" returnvariable="CAT">
<cfset LvarTipoDocumento = 7>
<cfparam name="form.GELid" default="">

<cfif isdefined ('url.error') and len(trim(url.error)) gt 0>
	<script language="javascript">
		alert('La moneda de la liquidación y la del documento deben de ser iguales');
	</script>
</cfif>
<cfif isdefined( 'url.GELid')  and len(trim(url.GELid))>
	<cfset form.GELid=#url.GELid#>
</cfif>
<cfif isdefined('form.GELid') and len(trim(form.GELid)) and form.GELid NEQ 0> <!---or isdefined('form.GEAnumero')--->
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<!--- Querry que determina si el Usuario es Aprobador de Tesoria--->
<cfquery name="rsSPaprobador" datasource="#session.dsn#">
	Select TESUSPmontoMax, TESUSPcambiarTES
	from TESusuarioSP
	where <!---CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
	and---> Usucodigo	= #session.Usucodigo#
	and TESUSPaprobador = 1
</cfquery>
<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>
	
<cfif modo NEQ 'ALTA'>
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
			(select DEid from TESbeneficiario where TESBid=a.TESBid) as DEid,

			case 
				when GELtotalDocumentos = 0 AND GELtotalGastos <> 0 then 1 else 0 
			end as InitDocs,
			case 
				when GELtotalDocumentos = 0 AND GELtotalGastos <> 0 then GELtotalGastos else GELtotalDocumentos
			end as GELtotalDocumentos,
			mo.Mnombre, mo.Miso4217,
			GELtotalGastos,
			GELtotalTCE,
			GELtotalRetenciones,
			
			GELtotalAnticipos,
			
			GELtotalDepositos,
			GELtotalDepositosEfectivo,
			GELtotalDevoluciones,
			
			
				(GELtotalDepositos + GELtotalDepositosEfectivo + GELtotalDevoluciones ) as MiDevolucion,
				(GELtotalGastos - GELtotalRetenciones - GELtotalAnticipos - GELtotalTCE 
					+ (GELtotalDepositos + GELtotalDepositosEfectivo + GELtotalDevoluciones )
					- GELreembolso) as MiTotal,
			
			GELreembolso
		  from GEliquidacion a
				left outer join CFuncional b
					on b.CFid 		= a.CFid
					and b.Ecodigo 	= a.Ecodigo
				left join Monedas mo
					on mo.Mcodigo = a.Mcodigo
		where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		  and a.GELtipo 	= #LvarTipoDocumento#
	</cfquery>
	<!--- InitDocs: Compatibilidad Versiones Anteriores --->
	<cfif rsForm.InitDocs EQ 1>
		<cfquery datasource="#session.dsn#">
			update GEliquidacion
			   set GELtotalDocumentos = GELtotalGastos
			 where Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			   and GELtotalDocumentos	= 0
			   and GELtotalGastos		<> 0
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update GEliquidacionGasto
			   set GELGmontoOri = GELGtotalOri, GELGmonto = GELGtotal
			 where Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			   and GELGmontoOri = 0
			   and GELGtotalOri > 0
		</cfquery>
	</cfif>	
	<cfquery name="rsAntic" datasource="#session.dsn#">
		select count(1) as cantidad from GEliquidacionAnts where GELid=#form.GELid#
	</cfquery>
		<cfif rsAntic.cantidad gt 0>
			<cfset negativo=1>
		</cfif>
	<cfquery datasource="#session.dsn#" name="Benef">
		select DEid as emple from TESbeneficiario where TESBid=<cfqueryparam cfsqltype="cf_sql_numeric" value= "#rsForm.TESBid#">
	</cfquery>
	
	<!---Indica Forma de Pago cuando hay anticipos relacionados.--->
	<cfquery name="rsAntPago" datasource="#session.dsn#">
		select a.GEAid,a.GELid,b.GEAtipoP, b.CCHid
		from GEliquidacionAnts a
			inner join GEanticipo b
				on a.GEAid=b.GEAid
		where a.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfset LvarGECid_comision = rsForm.GECid_comision>
<cfelse>
	<cfif isdefined("form.GECid_comision")>
		<cfset LvarGECid_comision = form.GECid_comision>
	<cfelseif isdefined("session.Tesoreria.GECid")>
		<cfset LvarGECid_comision = session.Tesoreria.GECid>
	</cfif>
</cfif>

<cfif LvarSAporComision>
	<!--- 
		GECdesde y GEChasta son las fechas solicitadas al crear una comision o del ULTIMO anticipo solicitado
		Cuando hay anticipos aprobados:
			GECdesdePlan y GEChastaPlan son las fechas planeadas de todos los Anticipos en conjunto, o sea,
			la min(GEAdesde) y max(GEAhasta) de los Anticipos aprobados
		Cuando no hay anticipos aprobados:
			GECdesdePlan y GEChastaPlan son las fechas solicitadas de la comision GECdesde y GEChasta
	--->
	<cfquery datasource="#session.dsn#">
		update GEcomision
		   set GECdesdePlan = 
		   			coalesce((
						select min(GEAdesde)
						  from GEanticipo
						 where GECid = GEcomision.GECid
						   and GEAestado >= 2
					), GECdesde)
		     , GEChastaPlan = 
		   			coalesce((
						select min(GEAhasta)
						  from GEanticipo
						 where GECid = GEcomision.GECid
						   and GEAestado >= 2
					), GEChasta)
		 where GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGECid_comision#">
		   and GECdesdePlan IS NULL
	</cfquery>
	<cfquery name="rsGEcomision" datasource="#session.dsn#">
		select 	cc.GECnumero, cc.GECdescripcion, cc.TESBid, cc.CFid,
				b.DEid,
				d.DEidentificacion, d.DEnombre #CAT#' '#CAT# d.DEapellido1 #CAT#' '#CAT# d.DEapellido2 as DEnombre,
				cf.CFcodigo, cf.CFdescripcion, ofi.Oficodigo,
				GECdesdePlan,GEChastaPlan,
				GECautomovil,GEChotel,GECavion,GECtipo,
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
		 where GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGECid_comision#">
	</cfquery>
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select m.Mcodigo, m.Miso4217
	  from Empresas e
		inner join Monedas m on m.Mcodigo = e.Mcodigo
	  where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>


<cfif isdefined("session.tesoreria.CFid") and (session.tesoreria.CFid EQ "" or session.tesoreria.CFid EQ -1)>
	<cf_cboCFid soloInicializar="true">
</cfif>

<!--- Query que determina si el Usuario es Aprobador de Tesoria--->
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
	select 
			c.CCHtipo,
			c.CCHid,
			c.CCHdescripcion #cat# ' - ' #cat# m.Miso4217 as CCHdescripcion,
			c.CCHcodigo,
			m.Miso4217, m.Mcodigo
	from CCHica c
		inner join Monedas m
		on m.Mcodigo=c.Mcodigo
		<cfif modo EQ 'CAMBIO' AND rsForm.Mcodigo NEQ "">
			and m.Mcodigo = #rsForm.Mcodigo#
		</cfif>
			<cfif modo EQ 'CAMBIO' AND rsForm.GELtipoPago EQ "CCH">
				<!--- Compatibilidad cuando no se verificaba CF y ya se habia incluido una CCH --->
			<cfelse>
				inner join CCHicaCF f
					 on f.CCHid=c.CCHid
				<cfif LvarSAporComision>
					and f.CFid=#rsGEcomision.CFid#
				<cfelseif modo NEQ 'ALTA'>
					and f.CFid=#rsForm.CFid#
				<cfelseif isdefined("form.cboCFid")>
					and f.CFid=#form.cboCFid#
				<cfelseif isdefined("session.tesoreria.CFid")>
					and f.CFid=#session.tesoreria.cfid#
				</cfif>
			</cfif>
	where c. Ecodigo=#session.Ecodigo#
	and c.CCHestado='ACTIVA'
	<cfif modo EQ 'CAMBIO' AND rsForm.GELtipoPago EQ "CCH">
		  and c.CCHid = #rsForm.CCHid#   <!--- Compatibilidad cuando no se verificaba CF y ya se habia incluido una CCH --->
	<cfelseif modo EQ 'CAMBIO' AND rsForm.GELtipoPago EQ "TES">
		  and c.CCHtipo = 2   <!--- Por comisión solo se permite Cajas Especiales --->
	<cfelseif LvarSAporComision>
		  and c.CCHtipo = 2   <!--- Por comisión solo se permite Cajas Especiales --->
	<cfelse>
		  and c.CCHtipo <> 3
	</cfif>
	order by c.CCHtipo desc
</cfquery>

<cfoutput>
<form action="LiquidacionAnticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" onSubmit="return validar(this);" method="post" name="form1" id="form1" style= "margin: 0;">
	<cfif isdefined ('url.GEAid') and len(trim(url.GEAid)) gt 0>
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
		select a.CFid, a.TESBid,a.Mcodigo,a.GEAmanual,a.GEAtipoP, b.CFcodigo,c.TESBeneficiario,m.Mnombre,c.DEid,b.CFdescripcion,o.Oficodigo
			from GEanticipo a
				inner join CFuncional b
					inner join Oficinas o
					on b.Ocodigo=o.Ocodigo
				on a.CFid=b.CFid
				inner join TESbeneficiario c
				on a.TESBid=c.TESBid
				inner join Monedas m
				on a.Mcodigo=m.Mcodigo
			where 
			GEAid=#url.GEAid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>
			<input type="hidden" name="DEid" value="#rsAnticipo.DEid#" />
			<input type="hidden" name="McodigoE" value="#rsAnticipo.Mcodigo#" />
			<input type="hidden" name="GELtipoCambio" value="#rsAnticipo.GEAmanual#" />
	</cfif>

	<table align="center" summary="Tabla de entrada"  width="100%" border="0">
	<cfif LvarSAporComision>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_NumComision xmlfile = "LiquidacionAnticipos_form.xml">Num. Comision</cf_translate>:&nbsp;</strong>
			</td>
			<td>
				<input type="hidden" name="GECid_comision" value="#LvarGECid_comision#">
				<input type="hidden" name="DEid" value="#rsGEcomision.DEid#">
				<input type="text" value="#rsGEcomision.GECnumero# - #rsGEcomision.GECdescripcion#"
					readonly tabindex="-1"
					style="border:none; font-weight:bold; width:350px"
				>
				
			</td>
			<td align="right">
				<strong><cf_translate key = LB_Planeado xmlfile = "LiquidacionAnticipos_form.xml">Planeado</cf_translate>:&nbsp;</strong>
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
				<strong><cf_translate key = LB_CentroFuncional xmlfile = "LiquidacionAnticipos_form.xml">Centro&nbsp;Funcional</cf_translate>:&nbsp;</strong>					
			</td>
			<td colspan="1">
				<input type="text" name="CFuncional" value="#trim(rsGEcomision.CFcodigo)# - #trim(rsGEcomision.CFdescripcion)# (Oficina: #trim(rsGEcomision.Oficodigo)#)" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
			 </td>
			<td align="right">
				<strong><cf_translate key = LB_Aprobado xmlfile = "LiquidacionAnticipos_form.xml">Aprobado</cf_translate>:&nbsp;</strong>
			</td>
			<td>
				<cfif rsGEcomision.GECdesdeReal EQ "">
                <cf_translate key = MSG_NoSeAplicaronLiquidaciones xmlfile = "LiquidacionAnticipos_form.xml">
					No se han aplicado Liquidaciones
                </cf_translate>
				<cfelse>
					<cfset LvarDias = datediff("d",rsGEcomision.GECdesdeReal,rsGEcomision.GEChastaReal)+1>
					<cfif LvarDias GT 1>
						<cfset LvarDias = "#LvarDias# #LB_DiasTotales#">
					<cfelse>
						<cfset LvarDias = "#LB_UnDiaTotal#">
					</cfif>
					desde #dateFormat(rsGEcomision.GECdesdeReal,"DD/MM/YYYY")# hasta #dateFormat(rsGEcomision.GEChastaReal,"DD/MM/YYYY")#
					&nbsp;<strong>#LvarDias#</strong>
				</cfif>
			</td>
				
		</tr>
		<tr>
			<!---Empleado--->
			<td align="right">
				<strong><cf_translate key = LB_Empleado xmlfile = "LiquidacionAnticipos_form.xml">Empleado</cf_translate>:&nbsp;</strong>
			</td>
			<td colspan="1">
				<input type="text" name="CFuncional" value="#trim(rsGEcomision.DEidentificacion)# - #trim(rsGEcomision.DEnombre	)#" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
			 </td>
			<td align="right">
				<strong><cf_translate key = LB_Tipo xmlfile = "LiquidacionAnticipos_form.xml">Tipo</cf_translate>:&nbsp;</strong>
			</td>
			<td>
				<cfif rsGEcomision.GECtipo EQ 1><cf_translate key = LB_Nacional xmlfile = "LiquidacionAnticipos_form.xml">Nacional</cf_translate><cfelse><cf_translate key = LB_Exterior xmlfile = "LiquidacionAnticipos_form.xml">Exterior</cf_translate></cfif>
				<cfif rsGEcomision.GECautomovil EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled"><cf_translate key = LB_Automovil xmlfile = "LiquidacionAnticipos_form.xml">Automóvil</cf_translate>
				</cfif>
				<cfif rsGEcomision.GEChotel EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled"><cf_translate key = LB_Hotel xmlfile = "LiquidacionAnticipos_form.xml">Hotel</cf_translate>
				</cfif>
				<cfif rsGEcomision.GECavion EQ 1>
					&nbsp;&nbsp;
					<input type="checkbox" checked disabled="disabled"><cf_translate key = LB_Avion xmlfile = "LiquidacionAnticipos_form.xml">Avión</cf_translate>
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="10" style="border-top:solid 1px ##CCCCCC; font-size:1px;" >&nbsp;</td>
		</tr>
	</cfif>
		<tr>
		<td colspan="6">
			<table cellpadding="0" cellspacing="0" border="0" style=" font-size:12px">
				<tr>
					<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<!---Número de la Liquidación --->
							<td valign="top" align="right" nowrap="nowrap"><strong><cf_translate key = LB_NumLiquidacion xmlfile = "LiquidacionAnticipos_form.xml">Núm. Liquidación</cf_translate>:&nbsp;</strong>					
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
								<strong><cf_translate key = LB_Fecha xmlfile = "LiquidacionAnticipos_form.xml">Fecha</cf_translate>:&nbsp;</strong>					
								<cfif modo NEQ 'ALTA'>
									<strong>#LSDateFormat(rsForm.GELfecha,"DD/MM/YYYY")#</strong>
									<input type="hidden" name="GELfecha" value="#rsForm.GELfecha#">
								<cfelse>
									&nbsp;&nbsp; <strong>#LSDateFormat(now(),"DD/MM/YYYY")#</strong>
								</cfif>					
							</td>
						</tr>
					<cfif NOT LvarSAporComision>
						<tr>				
							<!---Centro Funcional --->					
							<td align="right">
								<strong><cf_translate key = LB_CentroFuncional xmlfile = "LiquidacionAnticipos_form.xml">Centro&nbsp;Funcional</cf_translate>:&nbsp;</strong>					
							</td>
							<td colspan="1">
								<cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
									<input type="text" name="CFuncional" value="#trim(rsAnticipo.CFcodigo)# - #trim(rsAnticipo.CFdescripcion)# (Oficina: #trim(rsAnticipo.Oficodigo)#)" disabled="disabled" size="55"/>
								<cfelseif modo neq 'ALTA'>
									<cfquery name="rsCF" datasource="#session.dsn#">
										select CFcodigo,CFdescripcion from CFuncional where CFid=#rsForm.CFid#
									</cfquery>
									<input name="CFunc" type="text" disabled="disabled" value="#trim(rsCF.CFcodigo)# - #rsCF.CFdescripcion#" size="55" />
								<cfelse>
									<cf_cboCFid tabindex="1">
								</cfif>
							</td>
						</tr>
						<tr>
							<!---Empleado--->
							<td align="right">
								<strong><cf_translate key = LB_Empleado xmlfile = "LiquidacionAnticipos_form.xml">Empleado</cf_translate>:&nbsp;</strong>
							</td>
							<td valign="top" nowrap="nowrap">
								<cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
									<input type="text" name="Empleado" value="#rsAnticipo.TESBeneficiario#" size="55" disabled="disabled"/>
								<cfelse>
									<cfif modo NEQ 'ALTA'>
										<!---<cfif isdefined("LvarSAporEmpleado") OR rsForm.GELtotalGastos NEQ 0 or rsAntic.cantidad gt 0>--->
											<cfset LvarModificable = 'N'>
									<!---	<cfelse>
											<cfset LvarModificable = 'S'>
										</cfif>   --->
										<cfset LvarDEid = rsForm.DEid>
									<cfelse>
										<cfif isdefined("LvarSAporEmpleado")>
											<cfquery name="rsSQL" datasource="#session.dsn#">
												select llave as DEid
												from UsuarioReferencia
												where Usucodigo= #session.Usucodigo#
												and Ecodigo      = #session.EcodigoSDC#
												and STabla        = 'DatosEmpleado'
											</cfquery>
												<cfif rsSQL.recordCount EQ 0>
													<cf_errorCode	code = "50740" msg = "El usuario no ha sido registrado como Empleado de la Empresa">
												</cfif>
											<cfset LvarDEid = rsSQL.DEid>
											<cfset LvarModificable = 'N'>
										<cfelse>
											<cfset LvarDEid = "">
											<cfset LvarModificable = 'S'>
										</cfif>
									</cfif>
				
								</cfif>
                                
                                <cf_conlis title="#ListaEmpleados#"
                                    campos = "DEid, DEidentificacion, DEnombreTodo" 
                                    desplegables = "N,S,S" 
                                    modificables = "N,S,N" 
                                    size = "0,15,34"
                                    asignar="DEid, DEidentificacion, DEnombreTodo"
                                    asignarformatos="S,S,S"
                                    tabla="DatosEmpleado"
                                    columnas="DEid, DEidentificacion, DEnombre #CAT#' '#CAT# DEapellido1 #CAT#' '#CAT# DEapellido2 as DEnombreTodo,DEnombre,DEapellido1,DEapellido2"
                                    filtro="Ecodigo = #Session.Ecodigo#"
                                    desplegar="DEidentificacion, DEnombre,DEapellido1,DEapellido2"
                                    etiquetas="#LB_Identificacion#,#LB_Nombre#,#LB_Apellido1#,#LB_Apellido2#"
                                    formatos="S,S,S,S"
                                    align="left,left,left,left"
                                    showEmptyListMsg="true"
                                    EmptyListMsg=""
                                    form="form1"
                                    width="800"
                                    height="500"
                                    left="70"
                                    top="20"
                                    filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
                                    index="1"			
                                    traerInicial="#LvarDEID NEQ ''#"
                                    traerFiltro="DEid=#LvarDEid#"
                                    readonly="#LvarModificable EQ 'N'#"
                                    funcion="funcCambiaDEid"
                                    fparams="DEid"
                                    />         
							</td>
						</tr>	
					</cfif>
						<tr>
							<!---Descripción Liquidación --->
							<td valign="top" align="right" nowrap="nowrap">
									<strong><cf_translate key = LB_Descripcion xmlfile = "LiquidacionAnticipos_form.xml">Descripción</cf_translate>:&nbsp;</strong>		
							</td>
							<td>		    
									<input type="text"
									  tabindex="1" 
									  name="GELdescripcion" 
									  maxlength="40" 
									  size="60" 
									  id="GELdescripcion" 
									  value="<cfif modo NEQ 'ALTA'>#trim(rsForm.GELdescripcion)#</cfif>">
							</td>
						</tr>
						<tr>
							<!--- Moneda Local --->
							<td valign="top" align="right">
								<strong><cf_translate key = LB_Moneda xmlfile = "LiquidacionAnticipos_form.xml">Moneda</cf_translate>:&nbsp;</strong>
							</td>
							<td valign="top">	
							  <cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
								<input type="text" name="Moneda" value="#rsAnticipo.Mnombre#" disabled="disabled" />
							  <cfelse>						
								<cfif  modo NEQ 'ALTA'>
									<cfquery name="rsMoneda" datasource="#session.DSN#">
										select Mcodigo, Mnombre
										from Monedas
										where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
											and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									</cfquery>
				<!---						<cfif rsForm.GELtotalGastos GT 0 or rsAntic.cantidad gt 0>
				--->							<cf_sifmonedas onChange="asignaTC();" valueTC="#rsForm.GELtipoCambio#" 	
										form="form1" Mcodigo="McodigoE" query="#rsMoneda#" 
										FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1" habilita="Y" readOnly="yes">
									<!---<cfelse>
										<cf_sifmonedas onChange="asignaTC();" valueTC="#rsForm.GELtipoCambio#" 
										form="form1" Mcodigo="McodigoE" query="#rsMoneda#" 
										FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
									</cfif>--->
								<cfelse>
									<cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" 
									form="form1" Mcodigo="McodigoE"  tabindex="1" readOnly="yes">
								</cfif>	
							  </cfif>						
							</td>
						</tr>
						<tr>
							<!--- Tipo Cambio --->
							<td valign="top" align="right">
								<strong><cf_translate key = LB_TipoCambio xmlfile = "LiquidacionAnticipos_form.xml">Tipo de Cambio</cf_translate>:&nbsp;</strong>
							</td>
							<td valign="top">
							  <cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
								<input type="text" name="tipoC" value="#rsAnticipo.GEAmanual#" disabled="disabled"/>
							  <cfelse>
								<input name="GELtipoCambio" 
								id="GELtipoCambio"
								maxlength="10"
								value="<cfif modo NEQ'ALTA'>#NumberFormat(rsForm.GELtipoCambio,"0.0000")#</cfif>"
								style="text-align:right;"
								onfocus="this.value=qf(this); this.select();" 
								onblur="javascript: fm(this,4);"
								onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
								tabindex="1" />
							  </cfif>
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
							<td align="right"><strong><cf_translate key = LB_FechaReales xmlfile = "LiquidacionAnticipos_form.xml">Fechas Reales</cf_translate>:&nbsp;</strong></td>
							<td colspan="10" nowrap="nowrap">
								<table border="0">
									<tr>
										<td align="left"><cf_translate key = LB_Desde xmlfile = "LiquidacionAnticipos_form.xml">Desde</cf_translate>:</td>
										<td><cf_sifcalendario 	name="GELdesde" 	form="form1" value="#LvarGELdesde#" tabindex="1"></td> 
										<td align="right">&nbsp;<cf_translate key = LB_Hasta xmlfile = "LiquidacionAnticipos_form.xml">Hasta</cf_translate>:</td>
										<td><cf_sifcalendario 	name="GELhasta" 	form="form1" value="#LvarGELhasta#" tabindex="1"></td>	
										<td align="left"><strong>#LvarDias#</strong></td>
									</tr>
								</table>
							</td>
						</tr>						
						<tr>
							<td valign="middle"align="right" nowrap="nowrap">
								<strong><cf_translate key = LB_FormaPago xmlfile = "LiquidacionAnticipos_form.xml">Forma de Pago</cf_translate>:&nbsp; </strong>
							</td>
							<td valign="middle" align="left" nowrap="nowrap">
</cfoutput>
									<select name="FormaPago" id="FormaPago">
									<cfif NOT (modo EQ 'CAMBIO' AND rsForm.GELtipoPago EQ "CCH")>
										<option value="" >(<cf_translate key = LB_SeleccionarFormaPago xmlfile = "LiquidacionAnticipos_form.xml">Seleccionar Forma de Pago</cf_translate>)</option>
										<optgroup label="<cfoutput>#LB_PorTesoreria#</cfoutput>">
										<option value="0" <cfif modo EQ 'CAMBIO'and rsForm.CCHid EQ 0> selected= "selected" </cfif>><cfoutput>#LB_ConChequeTEF#</cfoutput></option>
									</cfif>
											<cfif rsCajaChica.RecordCount>
												<cfoutput query="rsCajaChica" group="CCHtipo">
													<cfif CCHtipo EQ 1>
														<optgroup label="<cfoutput>#LB_PorCajaChica#</cfoutput>">
													<cfelse>
														<optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfoutput>#LB_ConEfectivoPorCajaEspecial#</cfoutput>">
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
				<cfif modo NEQ 'ALTA'>
					<cfif #rsForm.GELestado# EQ 3>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td valign="top" align="right" nowrap="nowrap">
								<strong>#LB_MotivoRechazo#:&nbsp;</strong>
							</td>
							<td valign="top" align="left">
							<font color="FF0000">#rsForm.GELmsgRechazo#</font>
							</td>
						<tr>
					</cfif>
				</cfif>
					</table>
					</td>
					<td valign="top">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
					<cfif modo NEQ "ALTA">
						<!--- Detalle de Liquidación --->
						<cfset LvarResult		= createobject("component","sif.tesoreria.Componentes.TESgastosEmpleado").sbImprimirResultadoLiquidacion(rsForm)>
						<cfset LvarTotal 		= LvarResult.Total>
						<cfset LvarVacia 		= LvarResult.Vacia>
						<cfset LvarDevoluciones = LvarResult.Devoluciones>
						<cfset rsTotalReal 		= LvarResult.rsViaticos>
					</cfif>
					</table>
					</td>
				</tr>
			</table>
		</td>
		</tr>
				
		<cfif NOT LvarSAporComision AND ((isdefined ('rsAntPago') and rsAntPago.recordcount eq 0)  or not isdefined ('rsAntPago') and  modo eq 'ALTA')><!---si no tiene anticipos asociado es decir es una liq directa--->
			<tr><td></td><td></td>
				<!---Si es Viatico--->
				<td align="right" valign="top" nowrap><strong><cf_translate key = LB_Viatico xmlfile = "LiquidacionAnticipos_form.xml">Vi&aacute;tico </cf_translate>:&nbsp;</strong></td>
					<td>
						<input type="checkbox" id="GEAviatico" name="GEAviatico" tabindex="1" onchange="cambiaUsoCuenta();"     <cfif modo NEQ "ALTA" and #rsForm.GEAviatico# EQ 1>checked="checked" disabled="disabled" </cfif>  value="1"  />
					</td>
			</tr>
			<tr>

				<td></td>	
				<cfif isdefined ("rsForm.GEAviatico") and rsForm.GEAviatico EQ 1>
					<td align="right">
						<input name="LvarSAporEmpleadoCFM" id="LvarSAporEmpleadoCFM" value="#LvarSAporEmpleadoCFM#" type="hidden" />
						<cf_botones modo="#modo#" includevalues="#btnValueCalcular#" align="right"  	include="#btnNameCalcular#" exclude="#btnExcluirAbajo#">		
					</td>	
				<cfelse>
					<td></td>
				</cfif>
				
				<td align="right"><strong><cf_translate key = LB_Tipo xmlfile = "LiquidacionAnticipos_form.xml">Tipo</cf_translate>:&nbsp;</strong></td>
				<td nowrap="nowrap" align="left">		
					<input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico1" value="1" tabindex="1" <cfif modo neq "ALTA" and #rsForm.GEAtipoviatico# EQ 1> checked=" checked " </cfif>checked >
						<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key = LB_Nacional xmlfile = "LiquidacionAnticipos_form.xml">Nacional</cf_translate></label>
					 <input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico2" value="2"  tabindex="1"<cfif modo neq "ALTA" and #rsForm.GEAtipoviatico# EQ 2>  checked="checked"  </cfif> >
						<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key = LB_Exterior xmlfile = "LiquidacionAnticipos_form.xml">Exterior</cf_translate></label>					
				</td>	
				
			</tr>
		</cfif>
		<tr>
			<td colspan="4" class="formButtons" align="center">
			<cfif modo NEQ 'ALTA'>
				<input type="hidden" name="GELid" value="#HTMLEditFormat(rsForm.GELid)#">
				<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm.BMUsucodigo)#">				
				<cfset ts = "">
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
						artimestamp="#rsForm.ts_rversion#" returnvariable="ts">							
					</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
			<cfset LvarEsAprobadorGE = true>
			<cfinclude template="TESbtn_Aprobar.cfm">	
					
			
		</tr>
	</table>
</form>
<!---ValidacionesFormulario--->
<script type="text/javascript">
<!--
function validar(formulario){
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1) && !btnSelected('Anticipos',document.form1)){
		var error_input;
      	var error_msg = '';
		
			if (formulario.McodigoE.value == "") {
				error_msg += "\n - La Moneda no puede quedar en blanco.";
				error_input = formulario.McodigoE;
 			}
			
			if (formulario.GELdescripcion.value == "") {
				error_msg += "\n - La descripción no puede quedar en blanco.";
				error_input = formulario.GELdescripcion;
			} 
			
			if (formulario.FormaPago.value == "") {
			<cfif modo NEQ 'ALTA'>
				error_msg += "\n - La forma de pago no puede quedar en blanco.";
				error_input = formulario.GELdescripcion;
			</cfif>
			}
			else
			{
				var FP = formulario.FormaPago.options[formulario.FormaPago.selectedIndex].text;
				if ((FP.substr(FP.length-5,1) == "-") && (CCH[formulario.FormaPago.value+""] != formulario.McodigoE.value))
				{
					error_msg += "\n - La Moneda de la Caja debe coincidir con la moneda de la Liquidación";
					error_input = formulario.FormaPago;
				}
			}
			if (formulario.DEid.value == "") {
				error_msg += "\n - La descripción del empleado no puede quedar en blanco.";
				error_input = formulario.DEid;
			}
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
			 return false;
			 }
			 
	 }
	 
	formulario.GELtipoCambio.disabled = false;
	return true;
	
	}
	
/* aqui asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
function asignaTC() {      
	if (document.form1.McodigoE.value == "#rsMonedaLocal.Mcodigo#") {
		formatCurrency(document.form1.TC,2);
		document.form1.GELtipoCambio.disabled = true;                                   
	}
	else
		document.form1.GELtipoCambio.disabled = false;
		document.form1.GELtipoCambio.value = fm(document.form1.TC.value,4);
	}
asignaTC();


function cambiaUsoCuenta()
{
	if(document.form1.GEAviatico.checked) 
	{
		 SiViatico ();
	}
}

function SiViatico ()
{
	var estado=document.form1.GEAviatico.checked;
	
	if(!estado){
		disabled="disabled";
		document.form1.GEAtipoviatico1.disabled=disabled;
		document.form1.GEAtipoviatico2.disabled=disabled;
	}else{
		var disabled="";
		document.form1.GEAtipoviatico1.disabled=disabled;
		document.form1.GEAtipoviatico2.disabled=disabled;
	}

}
 //-->
</script>
</cfoutput>
<cfif MODO NEQ "ALTA">
	<cfinclude template="LiquidacionAnticipos_tabs.cfm">
</cfif>

		
