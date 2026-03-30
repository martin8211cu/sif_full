<cfif isdefined("url.TESid") and not isdefined("form.TESid")>
	<cfset form.TESid = url.TESid >
</cfif>

<cfif isdefined("url.Tiempo") and not isdefined("form.Tiempo")>
	<cfset form.Tiempo = url.Tiempo >
</cfif>

<cfif isdefined("url.FechaFinal") and not isdefined("form.FechaFinal")>
	<cfset form.FechaFinal = url.FechaFinal>
</cfif>

<cfquery name="tesoreria" datasource="#session.DSN#" maxrows="1">
	select 	TESid, 
			TEScodigo, 
			TESdescripcion
	  from 	Tesoreria t
	 where 	CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	   and	EcodigoAdm 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	   <cfif isdefined("form.TESid") and len(trim(form.TESid))>
		   and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
	   </cfif>
	 order by TEScodigo
 </cfquery>

<form method="post" name="form1">

<cfparam name="form.Tiempo" default="">
<cfparam name="form.FechaFinal" default="">
<cfif form.FechaFinal EQ "">
	<cfset LvarFechaFinal = dateadd('m',3,now())>
<cfelse>
	<cfset LvarFechaFinal = LSParseDateTime(form.FechaFinal)>
</cfif>

<cfif not isdefined("url.imprimir")>
	<table style=" border:1px solid gray;"  width="100%" cellpadding="3" bgcolor="#CCCCCC" cellspacing="0">
		<tr>
			<td nowrap valign="middle" align="right"><strong>Trabajar con Tesorer&iacute;a:</strong>&nbsp;</td>
			<td valign="middle">	<cf_cboTESid onchange="this.form.submit();" tabindex="1"></td>
			<td nowrap><strong>Fecha Final:</strong></td>
			<td><cf_sifcalendario name="FechaFinal" value="#dateFormat(LvarFechaFinal,"DD/mm/yyyy")#" tabindex="1"></td>
			<td nowrap valign="middle" align="right">	<strong>Tipo de Reporte:</strong>&nbsp;</td>
			<td valign="middle">	
				<select name="Tiempo"  tabindex="1">
				<option value="">(Escoja el tipo de tiempo para el Reporte)</option>
				<option value="D" <cfif form.Tiempo EQ "D"> selected</cfif>>Diario</option>
				<option value="S" <cfif form.Tiempo EQ "S"> selected</cfif>>Semanal</option>
				<option value="Q" <cfif form.Tiempo EQ "Q"> selected</cfif>>Quincenal</option>
				<option value="M" <cfif form.Tiempo EQ "M"> selected</cfif>>Mensual</option>
				</select>
			</td>
			<td><input type="button" value="Genera" onclick="this.form.submit();"></td>
			<td><cf_rhimprime datos="/sif/tesoreria/FlujoEfectivo/analisisES_print.cfm" paramsuri="#params#" formato="flashpaper"></td>
		</tr>
	</table>
	<br>
</cfif>
	<cfset LvarHoy = createdate(year(now()),month(now()),day(now()))>
	<cfset LvarHoy = dateadd("d",1,LvarHoy)>
	<cfset LvarHoy = dateadd("s",-1,LvarHoy)>
	
	<cfset tipos = structnew() > 
	<cfset tipos['D'] = 'Diario'>
	<cfset tipos['S'] = 'Semanal'>
	<cfset tipos['Q'] = 'Quincenal'>
	<cfset tipos['M'] = 'Mensual'>

<cfif form.Tiempo EQ "">
	<div style=" font-size:18px; color:#003399" align="center">
	SELECCIONE UN TIPO DE REPORTE PARA SU GENERACION
	</div>
	<br />
	<cfabort>
</cfif>

	<cfquery name="rsSaldos" datasource="#session.DSN#" >	
		select 	cb.Ecodigo, cb.Bid, cb.Mcodigo,
				e.Mcodigo as McodigoLocal,
				e.Edescripcion,
				b.Bdescripcion,
				cb.CBcodigo,
				m.Miso4217,
				coalesce(sb.Sinicial,0) +
				(
				   select coalesce(sum(MLmonto*case when BTtipo='D' then 1 else -1 end),0)
				   from MLibros ml
					inner join BTransacciones bt on bt.BTid = ml.BTid
				   where ml.CBid = cb.CBid
					 and ml.MLfechamov > sb.SBfecha
					 and ml.MLfechamov < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
				)
				as Saldo
		  from TEScuentasBancos tcb
			inner join CuentasBancos cb
				inner join Bancos b
					 on b.Bid = cb.Bid
				inner join Empresas e
					 on e.Ecodigo = cb.Ecodigo
				inner join Monedas m
					 on m.Mcodigo = cb.Mcodigo
				 on cb.CBid = tcb.CBid
			left join SaldosBancarios sb
				 on sb.CBid = tcb.CBid
				and sb.SBfecha = 
					(
						select max(sbm.SBfecha) 
						  from SaldosBancarios sbm
						 where sbm.CBid = tcb.CBid
						   and sbm.SBfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
					)  
		 where tcb.TESid = #session.Tesoreria.TESid#
           and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
		   and tcb.TESCBactiva = 1
		 order by cb.Ecodigo, cb.Bid, cb.Mcodigo
	</cfquery>
		
	<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td align="center"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
		<tr><td align="center"><font size="2"><strong>Tesorer&iacute;a:&nbsp;#trim(tesoreria.TEScodigo)# - #tesoreria.TESdescripcion#</strong></font></td></tr>
		<tr><td align="center"><font size="2"><strong>Reporte <cfif isdefined("form.Tiempo") and len(trim(form.Tiempo))>#tipos[form.tiempo]# </cfif>de Flujo de Efectivo</strong></font></td></tr>
		<tr><td align="center"><font size="2"><strong>Desde #dateformat(now(),"DD/MM/YYYY")# hasta #dateformat(LvarFechaFinal,"DD/MM/YYYY")#</strong></font></td></tr>
		 
	</table>
	<br>
	</cfoutput>

	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td>
	<!---<cf_web_portlet_start border="true" titulo="Saldos Bancarios" skin="#Session.Preferences.Skin#" width="75%">--->
		<table width="600px" align="center" cellpadding="2" cellspacing="0" border="0" style="border:1px solid black; " >
			<tr><td colspan="5" align="center" bgcolor="#6B89A6"><strong><font color="#FFFFFF">Saldos Bancarios</font></strong></td></tr>
			<tr bgcolor="#D3D3D3">
				<td nowrap align="center">
					<strong>Cuenta&nbsp;</strong>
				</td>
				<td nowrap>
					<strong>Moneda&nbsp;</strong>
				</td>
				<td nowrap align="right">
					<strong>Saldo Actual&nbsp;</strong>
				</td>
				<td nowrap align="right">
					<strong>Tipo Cambio&nbsp;</strong>
				</td>
				<td nowrap align="right">
					<strong>Saldo Local&nbsp;</strong>
				</td>
			</tr>
			<cfset LvarEcodigo = "">
			<cfset LvarBid = "">
			<cfset LvarMcodigo = "">
			<cfset LvarTotal = 0.00>
			<cfoutput>
			<cfloop query="rsSaldos">
				<cfif LvarEcodigo NEQ rsSaldos.Ecodigo>
					<cfset LvarEcodigo = rsSaldos.Ecodigo>
					<cfset LvarBid = "">
					<cfset LvarMcodigo = "">
					<tr>
						<td colspan="5" bgcolor="##D3D3D3" style="border-top:1px solid black; ">
							<strong>#rsSaldos.Edescripcion#</strong>
						</td>
					</tr>
				</cfif>
				<cfif LvarBid NEQ rsSaldos.Bid>
					<cfset LvarBid = rsSaldos.Bid>
					<cfset LvarMcodigo = "">
					<tr bgcolor="##e8e8e8"  >
						<td colspan="5" >
							&nbsp;&nbsp;&nbsp;&nbsp;<strong>#rsSaldos.Bdescripcion#</strong>
						</td>
					</tr>
				</cfif>
				<cfif LvarMcodigo NEQ rsSaldos.Mcodigo>
					<cfset LvarMcodigo = rsSaldos.Mcodigo>
					<cfif rsSaldos.Mcodigo EQ rsSaldos.McodigoLocal>
						<cfset LvarTipoCambio = 1.00>
					<cfelse>
						<cfquery name="rsTC" datasource="#Session.DSN#">
							select 	coalesce(tc.TCcompra,1.00) as TipoCambio
							  from Htipocambio tc
							 where tc.Mcodigo = #rsSaldos.Mcodigo#
							   and tc.Ecodigo = #rsSaldos.Ecodigo#
							   and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
							   and tc.Hfechah  > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
						</cfquery>
						<cfset LvarTipoCambio = rsTC.TipoCambio>
					</cfif>
				</cfif>

				<tr class="<cfif rsSaldos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td nowrap style="padding-left:15px; " >
						&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;#rsSaldos.CBcodigo#
					</td>
					<td nowrap align="right">
						#rsSaldos.Miso4217#
					</td>
					<td nowrap align="right">
						#LSNumberFormat(rsSaldos.Saldo,",9.99")#
					</td>
					<td nowrap align="right">
						#LSNumberFormat(LvarTipoCambio,",9.99")#&nbsp;
					</td>
					<td nowrap align="right">
						<strong>#LSNumberFormat(rsSaldos.Saldo*LvarTipoCambio,",9.99")#</strong>
						<cfset LvarTotal = LvarTotal + rsSaldos.Saldo*LvarTipoCambio>
					</td>
				</tr>

			</cfloop>

			<tr><td>&nbsp;</td></tr>
			<tr>
				<td nowrap colspan="4">
					<strong>Disponible Inicial</strong>
				</td>
				<td nowrap align="right">
					<strong>#LSNumberFormat(LvarTotal,",9.99")#</strong>
				</td>
			</tr>

			</cfoutput>
		</table>
	<!---<cf_web_portlet_end>--->
	<cfif form.Tiempo NEQ "">
			<cf_dbtemp name="TES_ES_V1" returnvariable="TABLA" datasource="#session.dsn#">
				<cf_dbtempcol name="TIPO"      type="integer"      mandatory="yes">
				<cf_dbtempcol name="FECHA"     type="datetime"     mandatory="yes">
				<cf_dbtempcol name="MONTO"     type="money"        mandatory="yes">
				<cf_dbtempcol name="FECHAVER"  type="datetime"     mandatory="no">
				<cf_dbtempcol name="FECHAVER2" type="varchar(10)"  mandatory="no">
			</cf_dbtemp>

			<cf_dbtemp name="TES_TI_V1" returnvariable="TIEMPO" datasource="#session.dsn#">
				<cf_dbtempcol name="FECHAVER2" type="varchar(10)"   mandatory="yes">
			</cf_dbtemp>
	
			<cf_dbtemp name="TES_TP_V1" returnvariable="TIPO" datasource="#session.dsn#">
				<cf_dbtempcol name="TIPO"      type="integer"      mandatory="yes">
			</cf_dbtemp>
	
			<!--- TIPO 1: Comprimisos de Tesoreria (Salidas: Montos Negativos) --->
			<cfquery datasource="#session.DSN#">
				insert into #TABLA#
					(TIPO, FECHA, MONTO)
				select 1, sp.TESSPfechaAprobacion, -sp.TESSPtotalPagarOri*coalesce(tc.TCcompra,1.00)
				  from TESsolicitudPago sp
					left join Htipocambio tc
						 on tc.Mcodigo = sp.McodigoOri
						and tc.Ecodigo = sp.EcodigoOri
						and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
						and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
				 where sp.TESid = #session.Tesoreria.TESid#
				   and sp.TESSPestado in (2, 10,11)
				   and sp.TESSPfechaAprobacion <= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinal#">
			</cfquery>
					
			<!--- TIPO 2: Vencimientos en CxC (Entradas: Montos Positivos) --->
			<cfquery datasource="#session.DSN#">
				insert into #TABLA#
					(TIPO, FECHA, MONTO)
				select 2, cxc.PPfecha_vence, +(cxc.PPprincipal+cxc.PPinteres)*coalesce(tc.TCcompra,1.00)
				  from TESempresas te
					inner join PlanPagos cxc
						 on cxc.Ecodigo	= te.Ecodigo
						and cxc.PPfecha_pago is null
					left join Htipocambio tc
						 on tc.Mcodigo = cxc.Mcodigo
						and tc.Ecodigo = cxc.Ecodigo
						and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
						and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
				 where te.TESid	= #session.Tesoreria.TESid#
				   and cxc.PPfecha_vence <= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinal#">
			</cfquery>
	
			<!--- TIPO 3: Vencimientos en CxP (Salidas: Montos Negativos) --->
			<cfquery datasource="#session.DSN#">
				insert into #TABLA#
					(TIPO, FECHA, MONTO)
				select 3, cxp.Dfechavenc, -(cxp.EDsaldo-cxp.TESDPaprobadoPendiente)*coalesce(tc.TCcompra,1.00)
				  from TESempresas te
					inner join EDocumentosCP cxp
						 on cxp.Ecodigo	= te.Ecodigo
						and cxp.EDsaldo-cxp.TESDPaprobadoPendiente > 0
					left join Htipocambio tc
						 on tc.Mcodigo = cxp.Mcodigo
						and tc.Ecodigo = cxp.Ecodigo
						and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
						and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
				 where te.TESid	= #session.Tesoreria.TESid#
				   and cxp.Dfechavenc <= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinal#">
			</cfquery>
	
			<!--- TIPO 4: Otras Entradas (Entradas: Montos Positivos) --->
			<!--- TIPO 5: Otras Salidas (Salidas: Montos Negativos) --->
			<cfquery name="rsES" datasource="#session.DSN#">
				select 	es.TESOtipo, es.TESOdescripcion, 
						es.TESOfechaDesde, es.TESOfechaHasta, 
						es.TESOmonto, es.Mcodigo, 
						TESOrecursividad, TESOrecursividadN,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as Inicio,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinal#"> as FechaFinal
				  from TESotrasEntradasSalidas es
				 where es.TESid = #session.Tesoreria.TESid#
				   and es.TESOactivo = 1
				   and es.TESOfechaHasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				   and es.TESOfechaDesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinal#">
			</cfquery>

			<cfloop query="rsES">
				<cfif rsES.TESOfechaDesde LT rsES.Inicio>
					<cfset LvarFecha = rsES.TESOfechaDesde>
					<cfloop condition="LvarFecha LT rsES.Inicio">
						<cfif rsES.TESOrecursividad EQ 0>
							<cfbreak>
						<cfelseif rsES.TESOrecursividad EQ 1>
							<cfset LvarFecha = dateAdd ("d",rsES.TESOrecursividadN,LvarFecha)>
						<cfelseif rsES.TESOrecursividad EQ 2>
							<cfset LvarFecha = dateAdd ("ww",rsES.TESOrecursividadN,LvarFecha)>
						<cfelseif rsES.TESOrecursividad EQ 3>
							<cfset LvarFecha = dateAdd ("m",rsES.TESOrecursividadN,LvarFecha)>
						<cfelseif rsES.TESOrecursividad EQ 4>
							<cfset LvarFecha = dateAdd ("yyyy",rsES.TESOrecursividadN,LvarFecha)>
						</cfif>
					</cfloop>
				<cfelse>
					<cfset LvarFecha = rsES.TESOfechaDesde>
				</cfif>

				<cfif LvarFecha LTE rsES.FechaFinal>
					<cfif rsES.TESOfechaHasta GT rsES.FechaFinal>
						<cfset LvarFechaFin = rsES.FechaFinal>
					<cfelse>
						<cfset LvarFechaFin = rsES.TESOfechaHasta>
					</cfif>

					<cfloop condition="LvarFecha LTE LvarFechaFin">
						<cfquery name="rsTC" datasource="#session.DSN#">
							select 
									<cfif rsES.TESOtipo EQ "E">
										tc.TCcompra
									<cfelse>
										tc.TCventa
									</cfif>
									as TipoCambio
							  from Htipocambio tc
							 where tc.Mcodigo = #rsES.Mcodigo#
							   and tc.Ecodigo = #session.Ecodigo#
							   and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
							   and tc.Hfechah  > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
						</cfquery>
						<cfif rsTC.TipoCambio EQ "">
							<cfset LvarTC = 1>
						<cfelse>
							<cfset LvarTC = rsTC.TipoCambio>
						</cfif>
	
						<cfquery name="rsOES" datasource="#session.DSN#">
							insert into #TABLA#
								(TIPO, MONTO, FECHA)
							values (
									<cfif rsES.TESOtipo EQ "E">
										4,
										<cfqueryparam cfsqltype="cf_sql_money" value="#rsES.TESOmonto*LvarTC#">,
									<cfelse>
										5,
										-<cfqueryparam cfsqltype="cf_sql_money" value="#rsES.TESOmonto*LvarTC#">,
									</cfif>
									<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
								)
						</cfquery>

						<cfif rsES.TESOrecursividad EQ 0>
							<cfbreak>
						<cfelseif rsES.TESOrecursividad EQ 1>
							<cfset LvarFecha = dateAdd ("d",rsES.TESOrecursividadN,LvarFecha)>
						<cfelseif rsES.TESOrecursividad EQ 2>
							<cfset LvarFecha = dateAdd ("ww",rsES.TESOrecursividadN,LvarFecha)>
						<cfelseif rsES.TESOrecursividad EQ 3>
							<cfset LvarFecha = dateAdd ("m",rsES.TESOrecursividadN,LvarFecha)>
						<cfelseif rsES.TESOrecursividad EQ 4>
							<cfset LvarFecha = dateAdd ("yyyy",rsES.TESOrecursividadN,LvarFecha)>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>

			<!--- -------------------------------------- --->
			<!--- AGRUPAR POR FECHA SEGUN TIPO DE TIEMPO --->
			<!--- -------------------------------------- --->
			<cfquery datasource="#session.DSN#">
				update #TABLA# 
				   set FECHA = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				 where FECHA < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			</cfquery>
			<cfif form.Tiempo EQ "D">
				<cfquery datasource="#session.DSN#">
					update #TABLA#
					   set FECHAVER = FECHA
				</cfquery>
			<cfelseif form.Tiempo EQ "S">
				<cfquery datasource="#session.DSN#">
					update #TABLA#
					<cf_dbfunction name="date_part" args="DW,FECHA" 			returnvariable="LvarDias">
					<cfset LvarDias = replace(LvarDias,",","°","ALL")>
					<cf_dbfunction name="dateadd" 	args="-#LvarDias#+7,FECHA" 	returnvariable="LvarFecha">
					<cfset LvarFecha = replace(LvarFecha,"°",",","ALL")>
					   set FECHAVER = #LvarFecha#
				</cfquery>
			<cfelseif form.Tiempo EQ "Q">
				<cfquery datasource="#session.DSN#">
					update #TABLA#
					<cf_dbfunction name="date_part" args="DD,FECHA" 				returnvariable="LvarDias">
					<cfset LvarDias = replace(LvarDias,",","°","ALL")>
					<cf_dbfunction name="dateadd" 	args="-#LvarDias#+1,FECHA" 	returnvariable="LvarFecha">
					<cfset LvarFecha = replace(LvarFecha,"°",",","ALL")>
					   set FECHAVER = #LvarFecha#
				</cfquery>
				<cfquery datasource="#session.DSN#">
					update #TABLA#
					<cf_dbfunction name="dateaddm" 	args="1,FECHAVER" 	returnvariable="LvarFecha">
					<cfset LvarFecha = replace(LvarFecha,",","°","ALL")>
					<cf_dbfunction name="dateadd" 	args="-1,#LvarFecha#" 	returnvariable="LvarFecha">
					<cfset LvarFecha = replace(LvarFecha,"°",",","ALL")>
					   set FECHAVER = #LvarFecha#
					 where <cf_dbfunction name="date_part" args="DD,FECHA"> > 15
				</cfquery>
				<cfquery datasource="#session.DSN#">
					update #TABLA#
					<cf_dbfunction name="dateadd" 	args="14,FECHAVER" 	returnvariable="LvarFecha">
					   set FECHAVER = #LvarFecha#
					 where <cf_dbfunction name="date_part" args="DD,FECHA"> <= 15
				</cfquery>
			<cfelseif form.Tiempo EQ "M">
				<cfquery datasource="#session.DSN#">
					update #TABLA#
					<cf_dbfunction name="date_part" args="DD,FECHA" 				returnvariable="LvarDias">
					<cfset LvarDias = replace(LvarDias,",","°","ALL")>
					<cf_dbfunction name="dateadd" 	args="-#LvarDias#+1,FECHA" 		returnvariable="LvarFecha">
					<cfset LvarFecha = replace(LvarFecha,",","°","ALL")>
					<cf_dbfunction name="dateaddm" 	args="1,#LvarFecha#" 			returnvariable="LvarFecha">
					<cfset LvarFecha = replace(LvarFecha,",","°","ALL")>
					<cf_dbfunction name="dateadd" 	args="-1,#LvarFecha#" 			returnvariable="LvarFecha">
					<cfset LvarFecha = replace(LvarFecha,"°",",","ALL")>
					   set FECHAVER = #LvarFecha#
				</cfquery>
			</cfif>

			<cfquery datasource="#session.DSN#">
				update #TABLA#
				   set FECHAVER = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinal#">
				 where FECHAVER > <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinal#">
			</cfquery>

			<cfquery datasource="#session.DSN#">
				update #TABLA#
				   set FECHAVER2 = <cf_dbfunction name="date_format" 	args="FECHAVER,YYYYMMDD">
			</cfquery>

			<cfquery datasource="#session.DSN#">
				insert into #TIEMPO# (FECHAVER2)
				select distinct FECHAVER2 from #TABLA#
			</cfquery>

			<cfquery datasource="#session.DSN#">
				insert into #TIPO# (TIPO)
				select distinct TIPO from #TABLA#
			</cfquery>
			
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select  p.TIPO, f.FECHAVER2 as FECHAVER, sum(coalesce(MONTO,0)) as MONTO
				  from #TIPO# p
				  		inner join #TIEMPO# f
							left join #TABLA# t
								 on t.FECHAVER2 =  f.FECHAVER2
							on 1=1
							and t.TIPO = p.TIPO
				group by p.TIPO, f.FECHAVER2
				order by p.TIPO, f.FECHAVER2
			</cfquery>

			<cfquery datasource="#session.DSN#" name="rsTiempo">
				select FECHAVER2 as FECHAVER from #TIEMPO#
				order by FECHAVER2
			</cfquery>
		</td></tr>



<!--- 
****************************************************************
AQUI ES DONDE SE DEBE PINTAR LOS DATOS
****************************************************************
 --->
 <tr><td>
<br>
<!---<cf_web_portlet_start border="true" titulo="Flujo de Efectivo" skin="#Session.Preferences.Skin#" width="75%">--->
<table cellpadding="2" border="0" cellspacing="0" align="center" width="75%" style="border:1px solid black; ">
	<tr>
		<td colspan="<cfoutput>#rsTiempo.recordCount+1#</cfoutput>" align="center" bgcolor="#6B89A6">
			<strong><font color="#FFFFFF">Flujo de Efectivo</font></strong>
		</td>
	</tr>
	<tr bgcolor="#d3d3d3">
		<td style="padding-left:15px; " align="right">
			<cfoutput>
			<strong>Del #dateFormat(now(),"DD/MM/YYYY")#</strong>
			</cfoutput>
		</td>
	<cfset LvarAno = dateFormat(now(),"YYYY")>
	<cfoutput query="rsTiempo">
		<cfif form.Tiempo EQ "D">
			<td align="right"><strong>#mid(FECHAVER,7,2)#/#mid(FECHAVER,5,2)#/#mid(FECHAVER,1,4)#</strong></td>
		<cfelseif LvarAno NEQ mid(FECHAVER,1,4)>
			<cfset LvarAno = mid(FECHAVER,1,4)>
			<td align="right"><strong>al #mid(FECHAVER,7,2)#/#mid(FECHAVER,5,2)#/#mid(FECHAVER,1,4)#</strong></td>
		<cfelse>
			<td align="right"><strong>al #mid(FECHAVER,7,2)#/#mid(FECHAVER,5,2)#</strong></td>
		</cfif>
		<cfset LvarTotales["T#FECHAVER#"] = 0>
	</cfoutput>
	</tr>
	<tr>
		<td>
			<strong>DISPONIBLE INICIAL</strong>
		</td>
		<td align="right" nowrap>
			<cfoutput>
			<strong>#LSNumberFormat(LvarTotal,",9.99")#</strong>
			</cfoutput>
		</td>
	</tr>
<cfset LvarTipoAnt = "">
<cfoutput query="rsSQL" >
	<cfif LvarTipoAnt NEQ rsSQL.tipo>
		<cfif LvarTipoAnt NEQ "">
	</tr>
		</cfif>
		<cfset LvarTipoAnt = rsSQL.tipo>
	<tr class="<cfif rsSQL.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
		<td style="padding-left:15px;" nowrap>
			<cfif rsSQL.tipo eq 1>Compromisos de Tesorer&iacute;a
			<cfelseif rsSQL.tipo eq 2>Vencimientos de CxC
			<cfelseif rsSQL.tipo eq 3>Vencimientos de CxP
			<cfelseif rsSQL.tipo eq 4>Otras Entradas Tesorer&iacute;a
			<cfelseif rsSQL.tipo eq 5>Otras Salidas Tesorer&iacute;a
			</cfif>
		</td>
	</cfif>
		<td style="padding:3px " align="right" nowrap>#LSNumberFormat(rsSQL.MONTO,',9.00')#</td>
		<cfset LvarTotales["T#FECHAVER#"] = LvarTotales["T#FECHAVER#"] + rsSQL.MONTO>
</cfoutput>
	</tr>
	<tr>
		<td style="padding-left:15px;" nowrap>
			<strong>TOTALES</strong>
		</td>
	<cfoutput query="rsTiempo">
		<td style="padding:3px " align="right" nowrap>
			<strong>#LSNumberFormat(LvarTotales["T#FECHAVER#"],',9.00')#</strong>
			<cfset LvarTotal = LvarTotal + LvarTotales["T#FECHAVER#"]>
			<cfset LvarTotales["T#FECHAVER#"] = LvarTotal>
		</td>
	</cfoutput>
	</tr>
	<tr>
		<td>
			<strong>DISPONIBLE FINAL</strong>
		</td>
	<cfoutput query="rsTiempo">
		<td style="padding:3px " align="right" nowrap>
			
			<font color="<cfif LvarTotales["T#FECHAVER#"] LT 0>##FF0000<cfelse>##000000</cfif>">
			&nbsp;&nbsp;<strong>#LSNumberFormat(LvarTotales["T#FECHAVER#"],',9.00')#</strong>
			</font>
		</td>
	</cfoutput>
	</tr>
<cfif rsSQL.recordcount eq 0 ><tr><td colspan="3" align="center">---No se encontraron registros---</td></tr></cfif>
</table>
<!---<cf_web_portlet_end>--->

		</td></tr>
	</table>
 <!--- //////////////////////////////////////////////////////--->
	</cfif>

	<table width="100%"><tr><td>&nbsp;</td></tr><tr><td align="center">-------- Fin del Reporte --------</td></tr><tr><td>&nbsp;</td></tr></table>
	</form>
<script language="javascript" type="text/javascript">
	document.form1.TESid.focus();
</script>