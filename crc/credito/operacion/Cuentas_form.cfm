
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle1" default = "Tablero" returnvariable="TabTitle1" xmlfile = "cuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle2" default = "Transacciones" returnvariable="TabTitle2" xmlfile = "cuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle3" default = "Detalle de Corte" returnvariable="TabTitle3" xmlfile = "cuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle4" default = "Incidencias" returnvariable="TabTitle4" xmlfile = "cuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle5" default = "Ajuste de Cr&eacute;dito" returnvariable="TabTitle5" xmlfile = "cuentas.xml">


<cfoutput>

<cfparam name="form.id">

<cfquery name="rsCuenta" datasource="#session.DSN#">
	select *
		,	concat(d.DEnombre,' ',d.DEapellido1,' ',d.DEapellido2) as GDEnombreC
		,	d.DEidentificacion GDEidentificacion
		,	c.DatosEmpleadoDEid GDEid
		,	concat(d2.DEnombre,' ',d2.DEapellido1,' ',d2.DEapellido2) as ADEnombreC
		,	d2.DEidentificacion ADEidentificacion
		,	c.DatosEmpleadoDEid2 ADEid
		,	case c.Tipo
				when 'D' then 'Vales'
				when 'TC' then 'Tarjeta de Credito'
				when 'TM' then 'Tarjeta Mayorista'
				else ''
			end as TipoDescripcion
		, 	ce.Orden
		,	c.Tipo
		,	case c.Tipo
				when 'D' then p.DSeguro
				when 'TC' then p.TCSeguro
				when 'TM' then p.TMSeguro
				else ''
			end as cuentaSeguro
		,	cd.Titulo
		,	s.SNid
	from CRCCuentas c
		inner join SNegocios s 
			on c.SNegociosSNid = s.SNid
		inner join CRCEstatusCuentas ce 
			on c.CRCEstatusCuentasid = ce.id
		left join CRCCategoriaDist cd 
			on c.CRCCategoriaDistid = cd.id
		left join DatosEmpleado d 
			on c.DatosEmpleadoDEid = d.DEid
		left join DatosEmpleado d2 
			on c.DatosEmpleadoDEid2 = d2.DEid
		left join CRCTCParametros p
			on p.CRCCuentasid = c.id
	where c.Ecodigo = #Session.Ecodigo#
		and c.id = #form.id#
</cfquery>
<cfquery name="rsSeguro" datasource="#session.DSN#">
	select  isNull(mcc.seguro,0) as montoSeguro
	from CRCCuentas c
		inner join SNegocios s 
			on c.SNegociosSNid = s.SNid
		left join CRCCortes ct
			on rtrim(ltrim(ct.Tipo)) = rtrim(ltrim(c.tipo))
		left join CRCMovimientoCuentaCorte mcc
			on mcc.Corte = ct.codigo
			and mcc.CRCCuentasID = c.id
		left join CRCTCParametros p
			on p.CRCCuentasid = c.id
	where c.Ecodigo = #Session.Ecodigo#
		and c.id = #form.id#
		and ct.status = 1;
</cfquery>


<cfquery name="q_currentCorte" datasource="#session.DSN#">
	select 
	<cfif rsCuenta.Tipo eq 'TM'>
		max(Codigo) Codigo
	<cfelse>
		Codigo
	</cfif> 
	from CRCCortes 
		where 
			Tipo = '#rsCuenta.Tipo#' 
			and FechaFin >= CURRENT_TIMESTAMP 
			and FechaInicio <= CURRENT_TIMESTAMP
			and Ecodigo = #session.ecodigo#
			<cfif rsCuenta.Tipo eq 'TM'>
				and Codigo like '%-#rsCuenta.SNid#'
			</cfif>
</cfquery>

<cfif q_currentCorte.recordCount gt 0>
	<cfset q_currentCorte="#QueryGetRow(q_currentCorte,1).codigo#">
<cfelse>
	<cfset q_currentCorte="">
</cfif>

<cfset top = 3>
<cfif isdefined('form.monthSearch')><cfset top = form.monthSearch></cfif>
<cfif '#Trim(rsCuenta.Tipo)#' eq 'D'><cfset top = top * 2></cfif>
<cfquery name="q_Cortes" datasource="#session.DSN#">
	select * from (
	select top((#top#)+1) * 
	from CRCCortes  
		where 
			Tipo = '#rsCuenta.Tipo#'
			and Ecodigo = #session.ecodigo#
			<cfif rsCuenta.Tipo eq 'TM'>
				and Codigo like '%-#rsCuenta.SNid#'
				<!--- and year(FechaInicio) = '#form.corteAnno#'
				and month(FechaInicio) = '#form.codigoCorte#' --->
			<cfelse>
				and FechaInicio < DateADD(d,<cfif isdefined('form.monthSearch')>#form.monthSearch#<cfelse>1</cfif>,CURRENT_TIMESTAMP)
				<!--- and FechaInicio > DateADD(m,<cfif isdefined('form.monthSearch')>-#(form.monthSearch + 1)#<cfelse>-4</cfif>,CURRENT_TIMESTAMP) --->
			</cfif>
			order by FechaFin desc
	) c
	order by Codigo
</cfquery>

<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.getParametroInfo('30000710')>
<cfif val.codigo eq ''><cfthrow message="El parametro (30000710 - Cambio automatico hasta estado) no esta definido"></cfif>
<cfif val.valor eq ''><cfthrow message="El parametro (30000710 - Cambio automatico hasta estado) no tiene valor"></cfif>
<cfset catsubsidio = objParams.getParametroInfo('30000508')>
<cfif catsubsidio.codigo eq ''><cfthrow message="El parametro (30000508 - Categoria para Seguro Subsidiado) no esta definido"></cfif>
<cfif catsubsidio.valor eq ''><cfthrow message="El parametro (30000508 - Categoria para Seguro Subsidiado) no tiene valor"></cfif>


<form name="formDetalleCuenta" action="#parentEntrancePoint#?tab=4" method="POST">
	<input name="whatToDo" type="hidden" value="" >
	<input name="currentTab" type="hidden" value="" >
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td width="50%">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td align="right">
							<strong>Numero Cuenta:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.Numero#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
							<input name="id" type="hidden" value="#rsCuenta.id#" >
						</td>
					</tr>
					<tr>
						<td align="right">
							<strong>Tipo Cuenta:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.TipoDescripcion#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>
					</tr>
					<cfif trim(rsCuenta.Tipo) eq 'D'>
						<cfif rsCuenta.Titulo neq "">
							<tr>
								<td align="right">
									<strong>Categoria:&nbsp;</strong>
								</td>
								<td>
									<cfif parentEntrancePoint eq 'CuentasAdmin.cfm'>
										<cfquery name="q_Categorias" datasource="#session.dsn#">
											select id,Orden,Titulo from CRCCategoriaDist where ecodigo = #session.ecodigo#;
										</cfquery>
										<input type="hidden" name="catsubsidio" value="#catsubsidio.valor#">
										<select name="nuevaCategoria" onchange="setWhatToDo('cambiarCategoria');">
											<cfloop query="q_Categorias">
												<option value="#rsCuenta.Tipo#|#q_Categorias.id#|#q_Categorias.Orden#" <cfif rsCuenta.CRCCategoriaDistid eq q_Categorias.id>selected</cfif> >#q_Categorias.Titulo#</option>
											</cfloop>
										</select>
									<cfelse>
										<input type="text" value="#rsCuenta.Titulo#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
									</cfif>
								</td>
							</tr>
						</cfif>
					</cfif>
					<tr>
						<td align="right">
							<strong>Socio de Negocio:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.SNnombre#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>
					</tr>
					<tr>
						<td align="right">
							<strong>Estado:&nbsp;</strong>
						</td>
						<cfif parentEntrancePoint eq 'CuentasAdmin.cfm'>
							<!---
							<cfset alDia = (NumberFormat(rsCuenta.Pagos,"0.00") + NumberFormat(rsCuenta.Condonaciones,"0.00")) - (NumberFormat(rsCuenta.SaldoVencido,"0.00") +NumberFormat(rsCuenta.GastoCobranza,"0.00") + NumberFormat(rsCuenta.Interes,"0.00") + NumberFormat(rsSeguro.montoSeguro,"0.00"))>
							<cfquery name="q_EstadosMin" datasource="#session.dsn#">
								select top(1) * from CRCEstatusCuentas where
									Ecodigo = #session.Ecodigo# 
									<cfif trim(rsCuenta.tipo) eq 'D'> and AplicaVales is not null </cfif>
									<cfif trim(rsCuenta.tipo) eq 'TC'> and AplicaTC is not null </cfif>
									<cfif trim(rsCuenta.tipo) eq 'TM'> and AplicaTM is not null </cfif>
								order by Orden asc;
							</cfquery>
							--->
							<cfquery name="q_Estados" datasource="#session.dsn#">
								select * from CRCEstatusCuentas where
									Ecodigo = #session.Ecodigo# 
									<cfif trim(rsCuenta.tipo) eq 'D'> and AplicaVales is not null </cfif>
									<cfif trim(rsCuenta.tipo) eq 'TC'> and AplicaTC is not null </cfif>
									<cfif trim(rsCuenta.tipo) eq 'TM'> and AplicaTM is not null </cfif>
									<!---
									<cfif rsCuenta.CRCEstatusCuentasid neq q_EstadosMin.id && alDia ge 0>
										and Orden >= #val.valor#
									</cfif>
									--->
								order by Orden asc;
							</cfquery>
							<td>
								<select name="nuevoEstado" onchange="setWhatToDo('cambiarEstado');">
									<cfloop query="q_Estados">
										<option value="#q_Estados.id#" <cfif rsCuenta.CRCEstatusCuentasid eq q_Estados.id>selected</cfif> >#q_Estados.Descripcion#</option>
									</cfloop>
								</select>
							</td>
						<cfelse>
							<td>
								<input type="text" value="#rsCuenta.Descripcion#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
							</td>
						</cfif>
					</tr>
					<cfquery name="rsClasificacion" datasource="#session.dsn#">
						select cld.SNCDdescripcion 
						from SNClasificacionSN cl  
						left join SNClasificacionD cld  
							on cl.SNCDid = cld.SNCDid
						left join SNClasificacionE cle
							on cld.SNCEid = cle.SNCEid
						where SNid = <cfqueryparam value="#rsCuenta.SNid#" cfsqltype="cf_sql_integer">
						and cle.SNCredyC = 1
					</cfquery>
					<tr>
						<td align="right">
							<strong>Clasificación:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsClasificacion.SNCDdescripcion#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>

					</tr>
					<!--- <cfdump var="#rsCuenta.Orden#-#val.valor#"> --->
					<cfif  rsCuenta.Orden ge val.valor>
					<!--- <cfif rsCuenta.DatosEmpleadoDEid neq ""> --->
						<tr>
							<td align="right">
								<strong>Gestor:&nbsp;</strong>
							</td>
							<td>
								<cf_conlis
									showEmptyListMsg="true"
									Campos="GDEid,GDEidentificacion,GDEnombreC"
									Values="#rsCuenta.GDEid#,#rsCuenta.GDEidentificacion#,#rsCuenta.GDEnombreC#"
									Desplegables="N,S,S"
									Modificables="N,N,N"
									Size="0,10,30"
									tabindex="1"
									Tabla="DatosEmpleado"
									Columnas="DEid as GDEid,DEidentificacion as GDEidentificacion,DEnombre as GDEnombre,DEapellido1 as GDEapellido1,DEapellido2 as GDEapellido2, concat(DEnombre,' ',DEapellido1,' ',DEapellido2) as GDEnombreC"
									form="formDetalleCuenta"
									Filtro="Ecodigo = #Session.Ecodigo# and isCobrador = 1"
									Desplegar="GDEidentificacion,GDEnombre,GDEapellido1,GDEapellido2"
									Etiquetas="Identificacion,Nombre,Apellido P,Apellido M"
									filtrar_por="GDEidentificacion,GDEnombre,GDEapellido1,GDEapellido2"
									Formatos="S,S,S,S"
									Align="left,left,left,left"
									Asignar="GDEid,GDEidentificacion,GDEnombreC"
									Asignarformatos="S,S,S"/>
									
							<cfif parentEntrancePoint eq 'CuentasAdmin.cfm'>
								&emsp;<img src="/cfmx/sif/imagenes/deleteicon.gif" style="cursor: pointer;" onclick="setWhatToDo('GDELETE')" alt="Limpiar" align="absmiddle" width="18" height="14" border="0">
							<cfelse>
								<script>document.getElementById('img_formDetalleCuenta_GDEid').innerHTML = ""</script>
							</cfif>
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Fecha Asignacion:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#DateFormat(rsCuenta.FechaGestor,'dd/mm/yyyy')#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
							</td>
						</tr>
					<!--- </cfif> --->
					<!--- <cfif rsCuenta.DatosEmpleadoDEid neq ""> --->
						<tr>
							<td align="right">
								<strong>Abogado:&nbsp;</strong>
							</td>
							<td>
								<cf_conlis
									showEmptyListMsg="true"
									Campos="ADEid,ADEidentificacion,ADEnombreC"
									Values="#rsCuenta.ADEid#,#rsCuenta.ADEidentificacion#,#rsCuenta.ADEnombreC#"
									Desplegables="N,S,S"
									Modificables="N,N,N"
									Size="0,10,30"
									tabindex="1"
									Tabla="DatosEmpleado"
									Columnas="DEid as ADEid,DEidentificacion as ADEidentificacion,DEnombre as ADEnombre,DEapellido1 as ADEapellido1,DEapellido2 as ADEapellido2, concat(DEnombre,' ',DEapellido1,' ',DEapellido2) as ADEnombreC"
									form="formDetalleCuenta"
									Filtro="Ecodigo = #Session.Ecodigo# and isAbogado = 1"
									Desplegar="ADEidentificacion,ADEnombre,ADEapellido1,ADEapellido2"
									Etiquetas="Identificacion,Nombre,Apellido P,Apellido M"
									filtrar_por="ADEidentificacion,ADEnombre,ADEapellido1,ADEapellido2"
									Formatos="S,S,S,S"
									Align="left,left,left,left"
									Asignar="ADEid,ADEidentificacion,ADEnombreC"
									Asignarformatos="S,S,S"/>
									
							<cfif parentEntrancePoint eq 'CuentasAdmin.cfm'>
								&emsp;<img src="/cfmx/sif/imagenes/deleteicon.gif" style="cursor: pointer;" onclick="setWhatToDo('ADELETE')" alt="Limpiar" align="absmiddle" width="18" height="14" border="0">
							<cfelse>
								<script>document.getElementById('img_formDetalleCuenta_ADEid').innerHTML = ""</script>
							</cfif>
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Fecha Asignacion:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#DateFormat(rsCuenta.FechaAbogado,'dd/mm/yyyy')#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
							</td>
						</tr>
					<!--- </cfif> --->
						<tr>
							<td>&emsp;</td>
							<td>
								&emsp;&emsp;&emsp;&emsp;
								<cfif parentEntrancePoint eq 'CuentasAdmin.cfm'>
									<input type="button" name="UPDATE" value="Asignar" onclick="setWhatToDo('UPDATE');" class="btnPublicar">
								</cfif>
							</td>
						</tr>
					</cfif>
					<tr>
						<td align="right">
							<strong>Seguro:&nbsp;</strong>
						</td>
						<td>
						<cfif parentEntrancePoint eq "CuentasAdmin.cfm">
							<select name="nuevoSeguro" onchange="setWhatToDo('cambiarSeguro');">
								<option value="#rsCuenta.Tipo#|0" <cfif rsCuenta.cuentaSeguro eq 0>selected</cfif> >No</option>
								<option value="#rsCuenta.Tipo#|1" <cfif rsCuenta.cuentaSeguro eq 1>selected</cfif> >Si</option>
								<option value="#rsCuenta.Tipo#|2" <cfif rsCuenta.cuentaSeguro eq 2>selected</cfif> >Subsidio</option>
							</select>
						<cfelse>
							<cfscript>
								switch(rsCuenta.cuentaSeguro){
									case 0:
										descripcionSeguro = "No";
										break;
									case 1:
										descripcionSeguro = "Si";
										break;
									case 2:
										descripcionSeguro = "Subsidio";
										break;
									default:
										descripcionSeguro = "Desconocido";
								}
							</cfscript>
							<input type="text" value="#descripcionSeguro#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><br/></td>
					</tr>
					<tr>
						<td align="right">
							<strong>Corte:&nbsp;</strong>
						</td>
						<td name="codigoSelect">
							<cfif q_Cortes.recordCount gt 0>
								<cfquery name="rsAnno" datasource="#session.dsn#">
									select distinct year(Fecha) Anno
									from CRCTransaccion
									where CRCCuentasid = #rsCuenta.id#
									order by year(Fecha) desc
								</cfquery>
								<select name="corteAnno" onchange="setWhatToDo('REFRESH')">
									<cfloop query="rsAnno">
										<option value="#rsAnno.Anno#" <cfif isdefined("form.corteAnno") and form.corteAnno eq "#rsAnno.Anno#" > selected="true"</cfif>> #rsAnno.Anno# </option>
									</cfloop>
								</select>
								<cfset monthName = ['ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE']>
								<select name="codigoCorte" onchange="setWhatToDo('REFRESH')">
									<cfif trim(rsCuenta.Tipo) eq 'TM'>
										<cfif not isdefined("form.codigoCorte")>
											<cfset form.codigoCorte=DateFormat(now(),"m")>
										</cfif>
										<option value="1" <cfif form.codigoCorte eq 1> selected="true"</cfif>> #monthName[1]#</option>
										<option value="2" <cfif form.codigoCorte eq 2> selected="true"</cfif>> #monthName[2]#</option>
										<option value="3" <cfif form.codigoCorte eq 3> selected="true"</cfif>> #monthName[3]#</option>
										<option value="4" <cfif form.codigoCorte eq 4> selected="true"</cfif>> #monthName[4]#</option>
										<option value="5" <cfif form.codigoCorte eq 5> selected="true"</cfif>> #monthName[5]#</option>
										<option value="6" <cfif form.codigoCorte eq 6> selected="true"</cfif>> #monthName[6]#</option>
										<option value="7" <cfif form.codigoCorte eq 7> selected="true"</cfif>> #monthName[7]#</option>
										<option value="8" <cfif form.codigoCorte eq 8> selected="true"</cfif>> #monthName[8]#</option>
										<option value="9" <cfif form.codigoCorte eq 9> selected="true"</cfif>> #monthName[9]#</option>
										<option value="10" <cfif form.codigoCorte eq 10> selected="true"</cfif>> #monthName[10]#</option>
										<option value="11" <cfif form.codigoCorte eq 11> selected="true"</cfif>> #monthName[11]#</option>
										<option value="12" <cfif form.codigoCorte eq 12> selected="true"</cfif>> #monthName[12]#</option>
									<cfelse>
										<cfloop query="#q_Cortes#">
											<cfif trim(rsCuenta.Tipo) eq 'D'>
												<option value="#q_Cortes.Codigo#" <cfif isDefined('form.codigoCorte')><cfif form.codigoCorte eq q_Cortes.Codigo>selected="true"</cfif><cfelse><cfif q_currentCorte eq q_Cortes.Codigo>selected="true"</cfif></cfif> >
													#monthName[DateFormat(q_Cortes.fechaFin,"m")]# - #q_Cortes.Codigo#
												</option>
											<cfelse>
												<option value="#q_Cortes.Codigo#" <cfif isDefined('form.codigoCorte')><cfif form.codigoCorte eq q_Cortes.Codigo>selected="true"</cfif><cfelse><cfif q_currentCorte eq q_Cortes.Codigo>selected="true"</cfif></cfif> >
													#monthName[DateFormat(q_Cortes.FechaInicio,"m")]# - #q_Cortes.Codigo#
												</option>
											</cfif>
										</cfloop>
									</cfif>
								</select>
								<cfif trim(rsCuenta.Tipo) neq 'TM'>
									<strong>&emsp;&emsp;Ver</strong>
									<select name="monthSearch" onchange="WaitRefreshCortes();">
										<option value="3" <cfif isdefined('form.monthSearch') && form.monthSearch eq 3>selected</cfif>>3</option>
										<option value="6" <cfif isdefined('form.monthSearch') && form.monthSearch eq 6>selected</cfif>>6</option>
										<option value="9" <cfif isdefined('form.monthSearch') && form.monthSearch eq 9>selected</cfif>>9</option>
										<option value="12" <cfif isdefined('form.monthSearch') && form.monthSearch eq 12>selected</cfif>>12</option>
									</select>
									<!---<input type="number" name="monthSearch" step="1" min="3" max="15" style="width:4em" onkeydown="return false" oninput="WaitRefreshCortes();" <cfif isdefined('form.monthSearch')>value="#form.monthSearch#"<cfelse>value="3"</cfif>>--->
									<strong>meses &nbsp;</strong>
								</cfif>
							<cfelse>
								<font color="red"><b>&emsp;No existen cortes registrados</b></font>
							</cfif>
						</td>
					</tr>
				</table>
			</td>
			<td valign="top" align="center">
				<table width="95%" border="1" cellspacing="0" cellpadding="0" align="center" style="font-weight:bold">
					<tr>
						<td align="center" colspan="2" class="listaPar">
							<b>Estado Actual</b>
						</td>
					</tr>
					<tr>
						<td width="50%" align="right" nowrap>
							<strong>Monto Aprobado:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.MontoAprobado,"0.00")))#
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<strong>Saldo Actual:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.SaldoActual,"0.00") <!--- + NumberFormat(rsCuenta.GastoCobranza,"0.00")) --->))#
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<strong>Saldo Vencido:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.SaldoVencido,"0.00")))#
						</td>
					</tr>
					<td align="right" nowrap>
							<strong>Saldo a Favor:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.saldoAFavor,"0.00")))#
						</td>
					<tr>
						<td align="right" nowrap>
							<strong>Intereses:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.Interes,"0.00")))#
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<strong>Compras:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.Compras,"0.00")))#
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<strong>Pagos:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.Pagos,"0.00")))#
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<strong>Condonaciones:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.Condonaciones,"0.00")))#
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<strong>Gasto de Cobranza:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsCuenta.GastoCobranza,"0.00")))#
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<strong>Seguro ultimo corte cerrado:&nbsp;</strong>
						</td>
						<td align="right" nowrap>
							#LSCurrencyFormat(ABS(NumberFormat(rsSeguro.montoSeguro,"0.00")))#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<hr width="95%">
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div name="dashboardTabs">
					<cfset tab_selected = ['FALSE','FALSE','FALSE','FALSE','FALSE']>
					<cfif isDefined('form.currentTab')> 
						<cfif len(trim(form.currentTab)) gt 0>
							<cfset tab_selected[form.currentTab + 1] = 'TRUE'>
						<cfelse> 
							<cfif isDefined('url.tab')> <cfif len(trim(url.tab)) gt 0><cfset tab_selected[url.tab] = 'TRUE'> </cfif></cfif>
						</cfif>
					</cfif>

					<cf_tabs width="99%">
						<cf_tab text="#TabTitle1#" selected="#tab_selected[1]#">
							<cf_web_portlet_start border="true"  titulo="#TabTitle1#" >
								<cfinclude template="Tab_Tablero.cfm"> 
							<cf_web_portlet_end>
						</cf_tab>
						<cf_tab text="#TabTitle2#" selected="#tab_selected[2]#">
							<cf_web_portlet_start border="true" titulo="#TabTitle2#" >
								<cfinclude template="Tab_Transacciones.cfm">
							<cf_web_portlet_end>
						</cf_tab>
						<cfif rsCuenta.Tipo neq 'TM'>
							<cf_tab text="#TabTitle3#" selected="#tab_selected[3]#">
								<cf_web_portlet_start border="true" titulo="#TabTitle3#" >
									<cfinclude template="Tab_MovCuenta.cfm">
								<cf_web_portlet_end>
							</cf_tab>
						</cfif>						
						<cf_tab text="#TabTitle4#" selected="#tab_selected[4]#">
							<cf_web_portlet_start border="true" titulo="#TabTitle4#" >
								<cfinclude template="Tab_Incidencias.cfm">
							<cf_web_portlet_end>
						</cf_tab>
						<!--- <cf_tab text="#TabTitle5#" selected="#tab_selected[5]#">
							<cf_web_portlet_start border="true" titulo="#TabTitle5#" >
								<cfinclude template="Tab_NotasCredito.cfm">
							<cf_web_portlet_end>
						</cf_tab> --->
					</cf_tabs>
				</div>
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script>

	/*
	var currentDate = new Date();
	var monthNames = ['ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE'];
	
	var selectHTML = '<select name="codigoCorte" onchange="setWhatToDo('+"'REFRESH'"+')">'

	var corteSelected = '<cfoutput>#form.codigoCorte#</cfoutput>';
	var corteSelected = corteSelected.replace(new RegExp(' ','g'),'');
	if(corteSelected == ''){
		var m = currentDate.getMonth()+1;
		if(m<=9){m = "0"+m;}
		if('<cfoutput>#rsCuenta.tipo#</cfoutput>' == 'D'){
			corteSelected = '<cfoutput>#rsCuenta.tipo#</cfoutput>'+currentDate.getFullYear()+""+m+"01";
		}else{
			corteSelected = '<cfoutput>#rsCuenta.tipo#</cfoutput>'+currentDate.getFullYear()+""+m;
		}
	}
	for (var i=-3; i < 3; i++){
		var date = new Date (currentDate.getFullYear(),currentDate.getMonth()+i,currentDate.getDate())
		var m = date.getMonth()+1;
		if(m<=9){m = "0"+m;}
		var q = ''
		var select = ''
		var cuentaTipo = '<cfoutput>#rsCuenta.tipo#</cfoutput>'
		var cuentaTipo = cuentaTipo.trim();
		if( cuentaTipo == 'D'){
			code = cuentaTipo+date.getFullYear()+""+m+"01";
			if(corteSelected == code){select='selected';}
			selectHTML += '<option value="'+code+'" '+select+'>'+monthNames[date.getMonth()]+' 01 - '+code+'</option>'
			var select = '';
			code = cuentaTipo+date.getFullYear()+""+m+"02";
			if(corteSelected == code){select='selected';}
			selectHTML += '<option value="'+code+'" '+select+'>'+monthNames[date.getMonth()]+' 02 - '+code+'</option>'
		}else{
			code = cuentaTipo+date.getFullYear()+""+m;
			if(corteSelected == code){select='selected';}
			selectHTML += '<option value="'+code+'" '+select+'>'+monthNames[date.getMonth()]+' - '+code+'</option>'
		}
	}
	selectHTML += '</select>'
	document.getElementsByName('codigoSelect')[0].innerHTML=selectHTML;
	*/
	
	var typewatch = function(){
		var timer = 0;
		return function(callback, ms){
			clearTimeout (timer);
			timer = setTimeout(callback, ms);
		}  
	}();

	function WaitRefreshCortes(){
		setTimeout(function(){
			//if(Number.isInteger(Number(document.formDetalleCuenta.monthSearch.value))){
				setWhatToDo('REFRESH');
		}, 1500);
	}
	
	function setWhatToDo(val){ 
		document.getElementsByName('whatToDo')[0].value = val; 
		Submit();
	}
	
	function ActiveTab(){ 
		var tabs = $('*[id^="tab_custom').get();
		for(var i in tabs){
			console.log(tabs[i].className+" - "+tabs[i].className.indexOf('active'));
			if(tabs[i].className.indexOf('active') >= 0 ){
				document.getElementsByName('currentTab')[0].value = i;
			}
		}
		return true;
	}
	
	function isNumber ( n )  {
		return !isNaN(parseFloat ( n ) ) && isFinite( n );
	}
	
	function Submit() {
		var form = document.getElementsByName('formDetalleCuenta')[0];
		var codigoCorte = document.getElementsByName('codigoCorte')[0];
		
		var tab = ActiveTab();
		var submitOK = true;
		
		if(form.GDEid != undefined && form.ADEid != undefined && form.GDEid.value != "" && form.ADEid.value != ""){
			if(document.getElementsByName('whatToDo')[0].value.indexOf('DELETE') < 0){
				alert('Escoga solo uno [ Gestor | Abogado ]');
				return false;
			}
		}
		
		if(form.Observaciones != undefined && form.Observaciones.value == "" && form.whatToDo.value.indexOf('INCI') >= 0){
			alert('Agregue una descripcion a la incidencia');
				return false;
		}
		
		if(form.tipoTransID != undefined && form.tipoTransID.value != "" && Number(form.monto.value) == 0){
			alert('Ha escogido generar gasto de cobranza pero no ha especificado el monto del gasto');
				return false;
		}

		if(form.monto.value != '' && !isNumber(form.monto.value)){
			alert('El monto de Incidencia no es un numero valido');
			return false;
		}

		if(form.tipoTransID != undefined &&  form.tipoTransID.value == "" && Number(form.monto.value) != 0){
			submitOK = confirm('Ha ingresado un monto pero no ha seleccionado generar gasto de cobranza. No se guardara el monto. Desea Continuar?');
		}
		
		
		if(form.currentUserKey != undefined && form.currentUserKey.value != form.EmpleadoID.value && form.whatToDo.value == 'updateINCI'){
			alert('No tiene permiso para modificar la transaccion');
				return false;
		}
		
		if(form.TPendiente != undefined && form.TPendiente.value != '1' && form.whatToDo.value == 'processINCI'){
			alert('La transaccion ha sido aprobada y no se puede modificar');
				return false;
		}
		
		if(form.codigoCorte == undefined){
			alert('No se ha seleccionado un corte');
				return false;
		}
		
		if(submitOK){
			form.submit();
		}
		
	}
	
	
</script>