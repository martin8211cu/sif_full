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
	
	
<!--- Querry que determina si el Usuario es Aprobador de Tesoria--->
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
	select 
			c.CCHtipo,
			c.CCHid,
			c.CCHdescripcion #cat# ' - ' #cat# m.Miso4217 as CCHdescripcion,
			c.CCHcodigo,
			m.Miso4217
	from CCHica c
		inner join Monedas m
		on m.Mcodigo=c.Mcodigo
	where c. Ecodigo=#session.Ecodigo#
	and c.CCHestado='ACTIVA'
	<cfif LvarSAporComision>
		  and c.CCHtipo = 2   <!--- Por comisión solo se permite Cajas Especiales --->
	</cfif>
	order by c.CCHtipo desc
</cfquery>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select 
			a.GELid, 
			a.GELfecha,
			coalesce(a.CCHid,0) as CCHid,
			a.GELnumero,
			a.Mcodigo,
			a.CFid,
			a.TESBid,
			a.BMUsucodigo,
			a.ts_rversion,
			a.GELtipoCambio,
			a.GELestado,
			a.GELmsgRechazo,
			a.GELtipoP,
			GELdescripcion,
			GEAviatico,
			GEAtipoviatico,
			GECid,
			(select DEid from TESbeneficiario where TESBid=a.TESBid) as DEid,

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
				
				GELreembolso
		  from GEliquidacion a
				left outer join CFuncional b
					on b.CFid 		= a.CFid
					and b.Ecodigo 	= a.Ecodigo
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
	<cfquery name="rsTotalReal" datasource="#session.dsn#">
		select coalesce(sum (GELVmonto),0) as total 
			from GEliquidacionViaticos
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfset LvarGECid_comision = rsForm.GECid>
<cfelse>
	<cfif isdefined("form.GECid_comision")>
		<cfset LvarGECid_comision = form.GECid_comision>
	<cfelseif isdefined("session.Tesoreria.GECid")>
		<cfset LvarGECid_comision = session.Tesoreria.GECid>
	</cfif>
</cfif>
<cfif LvarSAporComision>
	<cfquery name="rsGEcomision" datasource="#session.dsn#">
		select 	cc.GECnumero, cc.GECdescripcion, cc.TESBid,
				b.DEid,
				d.DEidentificacion, d.DEnombre #CAT#' '#CAT# d.DEapellido1 #CAT#' '#CAT# d.DEapellido2 as DEnombre,
				cf.CFcodigo, cf.CFdescripcion, ofi.Oficodigo
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

<cfoutput>
<form action="LiquidacionAnticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" onSubmit="return validar(this);" method="post" name="form1" id="form1" style= "margin: 0;">
	<cfif isdefined ('url.GEAid') and len(trim(url.GEAid)) gt 0>
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
		select a.CFid, a.TESBid,a.Mcodigo,a.GEAmanual,a.GEAtipoP, b.CFcodigo,c.TESBeneficiario,m.Mnombre,c.DEid,b.CFdescripcion,o.Oficodigo
			from 
			GEanticipo a
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
				<strong>Num. Comision:&nbsp;</strong>
			</td>
			<td>
				<input type="hidden" name="GECid_comision" value="#LvarGECid_comision#">
				<input type="hidden" name="DEid" value="#rsGEcomision.DEid#">
				#rsGEcomision.GECnumero#
			</td>
			<td align="right">
				<strong>Descripción:&nbsp;</strong>
			</td>
			<td>
				#rsGEcomision.GECdescripcion#
			</td>
		</tr>
		<tr>				
			<!---Centro Funcional --->					
			<td align="right">
				<strong>Centro&nbsp;Funcional:&nbsp;</strong>					
			</td>
			<td colspan="1">
				<input type="text" name="CFuncional" value="#trim(rsGEcomision.CFcodigo)# - #trim(rsGEcomision.CFdescripcion)# (Oficina: #trim(rsGEcomision.Oficodigo)#)" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
			 </td>
		</tr>
		<tr>
			<!---Empleado--->
			<td align="right">
				<strong>Empleado:&nbsp;</strong>
			</td>
			<td colspan="1">
				<input type="text" name="CFuncional" value="#trim(rsGEcomision.DEidentificacion)# - #trim(rsGEcomision.DEnombre	)#" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
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
							<td valign="top" align="right"><strong>Núm. Liquidación:&nbsp;</strong>					
							</td>
							<td valign="top">						
								<cfif modo NEQ 'ALTA'>
									<input type="text" name="GELnumero" value="#rsForm.GELnumero#" style="border:none; font-weight:bolder; width:195px" tabindex="-1" readonly="true">
									<input type="hidden" name="Mcodigo" value="#rsForm.Mcodigo#">
									<input type="hidden" name="CFid" value="#rsForm.CFid#">
								<cfelse>
									<input type="text" value="-- Nueva Liquidación --" style="border:none; font-weight:bolder; width:195px" tabindex="-1" readonly="true">
								</cfif>					
							<!---Fecha Liquidación--->					
								<strong>Fecha:&nbsp;</strong>					
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
								<strong>Centro&nbsp;Funcional:&nbsp;</strong>					
							</td>
							<td colspan="1">
								<cfif isdefined ('url.GEAid')	and len(trim(url.GEAid))gt 0>
									<input type="text" name="CFuncional" value="#trim(rsAnticipo.CFcodigo)# - #trim(rsAnticipo.CFdescripcion)# (Oficina: #trim(rsAnticipo.Oficodigo)#)" disabled="disabled" size="55"/>
								<cfelseif modo neq 'ALTA'>
									<cfquery name="rsCF" datasource="#session.dsn#">
										select CFcodigo,CFdescripcion from CFuncional where CFid=#rsForm.CFid#
									</cfquery>
									<input name="CFunc" type="text" disabled="disabled" value="#rsCF.CFcodigo# - #rsCF.CFdescripcion#" size="55" />
								<cfelse>
									<cf_cboCFid tabindex="1">
								</cfif>
							</td>
						</tr>
						<tr>
							<!---Empleado--->
							<td align="right">
								<strong>Empleado:&nbsp;</strong>
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
								<cf_conlis title="LISTA DE EMPLEADOS"
								campos = "DEid, DEidentificacion, DEnombre" 
								desplegables = "N,S,S" 
								modificables = "N,S,N" 
								size = "0,15,34"
								asignar="DEid, DEidentificacion, DEnombre"
								asignarformatos="S,S,S"
								tabla="DatosEmpleado"
								columnas="DEid, DEidentificacion, DEnombre #CAT#' '#CAT# DEapellido1 #CAT#' '#CAT# DEapellido2 as DEnombre"
								filtro="Ecodigo = #Session.Ecodigo#"
								desplegar="DEidentificacion, DEnombre"
								etiquetas="Identificación,Nombre"
								formatos="S,S"
								align="left,left"
								showEmptyListMsg="true"
								EmptyListMsg=""
								form="form1"
								width="800"
								height="500"
								left="70"
								top="20"
								filtrar_por="DEidentificacion,DEnombre"
								index="1"                                  
								traerInicial="#LvarDEID NEQ ''#"
								traerFiltro="DEid=#LvarDEid#"
								readonly="#LvarModificable EQ 'N'#"
								funcion="funcCambiaDEid"
								fparams="DEid"/>        
							</td>
						</cfif>
						</tr>	
						<tr>
							<!--- Moneda Local --->
							<td valign="top" align="right">
								<strong>Moneda:&nbsp;</strong>
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
								<strong>Tipo de Cambio:&nbsp;</strong>
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
						<tr>
							<!---<cfif modo NEQ 'ALTA'>--->
							<!---<cfif LvarEsAprobadorSP>--->
							<td valign="middle"align="right" nowrap="nowrap">
								<strong>Forma de Pago:&nbsp; </strong>
							</td>
							<td valign="middle" align="left" nowrap="nowrap">
</cfoutput>
									<select name="FormaPago" id="FormaPago" <cfif modo EQ 'CAMBIO' AND NOT LvarSAporComision>disabled="disabled"</cfif>>
										<option value="" >(Seleccionar Forma de Pago)</option>
										<optgroup label="Por Tesorería">
										<option value="0" <cfif modo EQ 'CAMBIO'and rsForm.CCHid EQ 0> selected= "selected" </cfif>>Con Cheque o TEF</option>
											<cfif rsCajaChica.RecordCount>
												<cfoutput query="rsCajaChica" group="CCHtipo">
													<cfif CCHtipo EQ 1>
														<optgroup label="Por Caja Chica">
													<cfelse>
														<optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Con Efectivo por Caja Especial">
													</cfif>
													<cfoutput>
													<option value="#rsCajaChica.CCHid#" <cfif modo neq "ALTA" and rsCajaChica.CCHid  eq rsForm.CCHid> selected="selected" </cfif>>#rsCajaChica.CCHcodigo#-#rsCajaChica.CCHdescripcion#</option>									
													</cfoutput>
												</cfoutput>
												</optgroup>
											</cfif>                       
									</select>					                             
<cfoutput>
									<cfif modo eq 'CAMBIO'>
										<input type="hidden" name="CCHid" value="#rsForm.CCHid#" />
										<cfif not LvarSAporComision>
											<input type="hidden" name="FormaPago" value="#rsForm.CCHid#" />
										</cfif>
									</cfif>
								
							</td>				
						</tr>
					</table>
					</td>
					<td valign="top">
					&nbsp;&nbsp;
					</td>
					<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<!---Descripción Liquidación --->
							<td colspan="2" valign="top" align="left" nowrap="nowrap">
									<strong>Descripción:&nbsp;</strong>				    
									<input type="text"
									  tabindex="1" 
									  name="GELdescripcion" 
									  maxlength="40" 
									  size="60" 
									  id="GELdescripcion" 
									  value="<cfif modo NEQ 'ALTA'>#trim(rsForm.GELdescripcion)#</cfif>">
							</td>
						</tr>
						
					<cfif modo NEQ "ALTA">
						<!--- Detalle de Liquidación --->
						<tr>
							<td colspan="2" valign="top" align="center" nowrap="nowrap" style="font-size:6px">&nbsp;
								
							</td>			    
						</tr>
						<tr>
							<td colspan="2" valign="top" align="center" nowrap="nowrap" style="border-top:solid 2px ##CCCCCC">
								<strong>LIQUIDACION DE GASTOS DE EMPLEADOS EN #rsMonedaLocal.Miso4217#s</strong>	
							</td>			    
						</tr>
						
						#sbSubtotales("GA","Total Viáticos",				rsTotalReal.total,"",True,0)#
					<cfif rsForm.GELtotalGastos EQ rsForm.GELtotalDocumentos>
						#sbSubtotales("GA","Total Gastos a Liquidar",		rsForm.GELtotalGastos,"+",True,0)#
					<cfelse>
						#sbSubtotales("GA","Total Gastos Autorizados",		rsForm.GELtotalGastos,"+",True,3)#
						#sbSubtotales("GA_1","Total Documentos",			rsForm.GELtotalDocumentos)#
						#sbSubtotales("GA_2","Gastos No Autorizados",		rsForm.GELtotalDocumentos - rsForm.GELtotalGastos,"&nbsp;- ")#
						#sbSubtotales("GA_3","TOTAL AUTORIZADO",			rsForm.GELtotalGastos,"=")#
					</cfif>
						#sbSubtotales("AN","Total Anticipos a Liquidar",	rsForm.GELtotalAnticipos,"&nbsp;- ",True,0)#
						#sbSubtotales("RET","Total Retenciones",			rsForm.GELtotalRetenciones,"&nbsp;- ",True,0)#
						#sbSubtotales("TCE","Pagos con TCE",				rsForm.GELtotalTCE,"&nbsp;- ",True,0)#
						#sbSubtotales("DE","Devoluciones",					rsForm.GELtotalDevoluciones+rsForm.GELtotalDepositos+rsForm.GELtotalDepositosEfectivo,"+",True,3)#
						#sbSubtotales("DE_1","Devolución a la Caja Chica",	rsForm.GELtotalDevoluciones)#
						#sbSubtotales("DE_2","Depósitos Bancarios",			rsForm.GELtotalDepositos)#
						#sbSubtotales("DE_3","Depósitos en Efectivo",		rsForm.GELtotalDepositosEfectivo)#
						#sbSubtotales("PA","PAGO ADICIONAL AL EMPLEADO",	rsForm.GELreembolso,"=",True,0)#

						<cfset LvarTotal = rsForm.GELtotalGastos 
										 - rsForm.GELtotalRetenciones - rsForm.GELtotalAnticipos - rsForm.GELtotalTCE 
										 + rsForm.GELtotalDepositos + rsForm.GELtotalDepositosEfectivo + rsForm.GELtotalDevoluciones
										 - rsForm.GELreembolso
						>
						<cfif LvarTotal GT 0>
							#sbSubtotales("FA","<font color='##FF0000'>FALTANTE POR REEMBOLSAR</font>",LvarTotal,"=",True,0)#
						<cfelseif LvarTotal LT 0>
							#sbSubtotales("FA","<font color='##FF0000'>FALTANTE POR DEVOLVER</font>",-LvarTotal,"=",True,0)#
						<cfelseif rsForm.GELtotalGastos EQ 0>
							<tr>
								<td colspan="2" valign="top" align="center" nowrap="nowrap" style="border-top:solid 2px ##CCCCCC">
									<strong>LIQUIDACION VACIA</strong>
								</td>			    
							</tr>
						<cfelse>
							<tr>
								<td colspan="2" valign="top" align="center" nowrap="nowrap" style="border-top:solid 2px ##CCCCCC">
									<font color='##0033FF'><strong>LIQUIDACION OK</strong></font>
								</td>			    
							</tr>
						</cfif>
					</cfif>
					</table>
					</td>
				</tr>
			</table>
		</td>
		</tr>
				
		<tr>
			<cfif modo NEQ 'ALTA'>
				<cfif #rsForm.GELestado# EQ 3>
					<td valign="top" align="right" nowrap="nowrap">
						<strong>Motivo de Rechazo:</strong>
					</td>
					<td valign="top" align="left">
					<font color="FF0000">#rsForm.GELmsgRechazo#</font>
					</td>
				<cfelse>
					<td colspan="2">&nbsp;</td>
				</cfif>
			<cfelse>
				<td colspan="2">&nbsp;</td>
			</cfif>
		<tr>
		<cfif NOT LvarSAporComision AND ((isdefined ('rsAntPago') and rsAntPago.recordcount eq 0)  or not isdefined ('rsAntPago') and  modo eq 'ALTA')><!---si no tiene anticipos asociado es decir es una liq directa--->
			<tr><td></td><td></td>
				<!---Si es Viatico--->
				<td align="right" valign="top" nowrap><strong>Vi&aacute;tico:&nbsp;</strong></td>
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
				
				<td align="right"><strong>Tipo:&nbsp;</strong></td>
				<td nowrap="nowrap" align="left">		
					<input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico1" value="1" tabindex="1" <cfif modo neq "ALTA" and #rsForm.GEAtipoviatico# EQ 1> checked=" checked " </cfif>checked >
						<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal">Interior</label>
					 <input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico2" value="2"  tabindex="1"<cfif modo neq "ALTA" and #rsForm.GEAtipoviatico# EQ 2>  checked="checked"  </cfif> >
						<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal">Exterior</label>					
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
				error_msg += "\n - La forma de pago no puede quedar en blanco.";
				error_input = formulario.GELdescripcion;
			} 
			if (formulario.DEid.value == "") {
				error_msg += "\n - La descripción del empleado no puede quedar en blanco.";
				error_input = formulario.DEid;
			}
		<cfif modo eq 'CAMBIO'>
			if (formulario.FormaPago.value == "") {
				error_msg += "\n - Debe seleccionar una forma de Pago.";
				error_input = formulario.FormaPago;
			}
		</cfif>           
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
			 return false;
			 }
	 }
	 
	if(formulario.GELtipoCambio.disabled)
		formulario.GELtipoCambio.disabled = false;
		return true;
		
	if(formulario.FormaPago.disabled)
	formulario.FormaPago.disabled = true;
	return true;
	
	}
	
/* aqui asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
function asignaTC() {      
	if (document.form1.McodigoE.value == "#rsMonedaLocal.Mcodigo#") {
		formatCurrency(document.form1.TC,2);
		document.form1.GELtipoCambio.disabled = true;                                   
	}
	else
		document.form1.GELtipoCambio.disabled = true;
		var estado = document.form1.GELtipoCambio.disabled;
		document.form1.GELtipoCambio.disabled = true;
		document.form1.GELtipoCambio.value = fm(document.form1.TC.value,4);
		document.form1.GELtipoCambio.disabled = estado;
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
function sbVerDetalle(id, n)
{
		var LvarDsp = "*";
		for(var i=1; i<=n; i++)
			if(document.getElementById(id+"_"+i))
			{
				if (LvarDsp == "*")
				{
					LvarDsp = document.getElementById(id+"_"+i).style.display;
					if (LvarDsp == "")
					  LvarDsp = "none";
					else
					  LvarDsp = "";
				}
				document.getElementById(id+"_"+i).style.display = LvarDsp;
			}
}
 //-->
</script>
</cfoutput>
<cfif MODO NEQ "ALTA">
	<cfinclude template="DetLiquidaciones.cfm">
</cfif>

		
<cffunction name="sbSubtotales" output="true">
	<cfargument name="id">
	<cfargument name="Descripcion">
	<cfargument name="Monto">
	<cfargument name="Signo" default="+">
	<cfargument name="Principal" default="false">
	<cfargument name="N" default="0">
	
	<cfif Arguments.Monto NEQ 0>
		<cfoutput>
		<cfif Arguments.Principal>
			<tr>
				<td rowspan="1" valign="top" align="left" nowrap="nowrap">
					<strong>#Arguments.Descripcion#:&nbsp;</strong>
					<img 	src="/cfmx/sif/imagenes/findsmall.gif" 
							style="cursor:pointer;<cfif Arguments.N EQ 0>visibility:hidden;</cfif>"
							onclick="sbVerDetalle('#Arguments.id#',#Arguments.N#);"
					/>
					
				</td>
				<td valign="top" align="left">
					#Arguments.signo#
					<cf_inputNumber name="ff" value="#Arguments.Monto#" size="20" enteros="15" decimales="2" readonly="yes">
				</td>
			</tr>
		<cfelse>
			<tr id="#Arguments.id#" style="display:none;">
				<td rowspan="1" valign="top" align="left" nowrap="nowrap">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<strong>#Arguments.Descripcion#:&nbsp;</strong>
				</td>
				<td valign="top" align="left">
					&nbsp;&nbsp;&nbsp;
					#Arguments.signo#
					<cf_inputNumber name="ff" value="#Arguments.Monto#" size="20" enteros="15" decimales="2" readonly="yes">
				</td>
			</tr>
		</cfif>
		</cfoutput>
	</cfif>
</cffunction>
