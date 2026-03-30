<CF_NAVEGACION NAME="GEid">
<CF_NAVEGACION NAME="periodo">
<CF_NAVEGACION NAME="mes">
<CF_NAVEGACION NAME="nivel">
<CF_NAVEGACION NAME="tipo">
<CF_NAVEGACION NAME="Mcodigo">

<!---►►Tabla de las empresas del reporte: #empresas#◄◄--->
<cf_dbtemp name="CONSOL_1_V1" returnVariable="empresas">
	<cf_dbtempcol name="id"  		type="int" identity="yes" mandatory="yes" >			
	<cf_dbtempcol name="nombre"		type="varchar(100)"	>
	<cf_dbtempcol name="codigo"  	type="int" >
</cf_dbtemp>

<!---►►2. Tabla de Cuentas: #fcuentas#◄◄--->
<cf_dbtemp name="CONSOL_2_V3" returnVariable="fcuentas">
	<cf_dbtempcol name="Cnivel"    		type="int" >
	<cf_dbtempcol name="Cformato"  		type="varchar(100)" >			
	<cf_dbtempcol name="Cdescripcion"	type="varchar(100)"	>
	<cf_dbtempcol name="Cmayor"  		type="char(4)" >
	<cf_dbtempcol name="tipo" 	 		type="char(1)" >
	<cf_dbtempcol name="subtipo"  		type="int" >
</cf_dbtemp>

<!---►►3. Tabla de Saldos x Cuenta x Empresa: #saldosxempresa#◄◄--->
<cf_dbtemp name="CONSOL_3_V1" returnVariable="saldosxempresa">
	<cf_dbtempcol name="Ccuenta"  type="numeric" 		mandatory="yes" >			
	<cf_dbtempcol name="Ecodigo"  type="int" 			mandatory="yes" >
	<cf_dbtempcol name="Cformato" type="varchar(100)" 	mandatory="yes" >
	<cf_dbtempcol name="nivel"    type="int" >
	<cf_dbtempcol name="saldo"    type="money" 			mandatory="yes" >
	<cf_dbtempcol name="tipo"	  type="char(1)"		mandatory="yes" >
	<cf_dbtempcol name="subtipo"  type="int" >
</cf_dbtemp>

<!---►►Tabla de las meses para Presupuesto: #CPmeses#◄◄--->
<cf_dbtemp name="CONSOL_4_V1" returnVariable="CPmeses">
	<cf_dbtempcol name="Ecodigo"	type="int" 			mandatory="yes" >
	<cf_dbtempcol name="CPCano"  	type="int" 			mandatory="yes" >
	<cf_dbtempcol name="CPCmes"  	type="int" 			mandatory="yes" >
	<cf_dbtempcol name="CPPid"		type="numeric"		mandatory="no" >
</cf_dbtemp>

<cfparam name="form.chkNivelSeleccionado" default="0">
<cfparam name="form.cboB15" default="0">
<cfset session.Conta.balances.nivelSeleccionado = (form.chkNivelSeleccionado EQ "1")>

<cfquery name="titulo_grupo" datasource="#session.dsn#">
	select GEnombre as nombre 
	  from AnexoGEmpresa
	 where GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEid#" >
</cfquery>

<cfif isdefined("Form.nivel") and Form.nivel neq "-1">
	<cfset varNivel = Form.nivel>
<cfelse>
	<cfset varNivel = "0">
</cfif>

<cfquery datasource="#session.DSN#">
	insert into #empresas# (nombre, codigo)
	values ('CONSOLIDADO', 0)
</cfquery>

<cfquery datasource="#session.DSN#">
	insert into #empresas# (nombre, codigo)
	select e.Edescripcion, e.Ecodigo
	from AnexoGEmpresaDet dg
		inner join Empresas e
			on e.Ecodigo = dg.Ecodigo
	where dg.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEid#" >
	order by e.Ecodigo
</cfquery>

<!--- Verificaciones --->

<!--- Verificar Período Corporativo --->
<cfquery name="rsCierreCorp" datasource="#Session.DSN#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.Ecodigo#
	   and Pcodigo = 46
</cfquery>

<cfquery name="rsEmpresas" datasource="#Session.DSN#">
	select e2.Ecodigo, e2.Edescripcion
	 from #empresas# e
		inner join Empresas e2
			on e2.Ecodigo = e.codigo
</cfquery>

<cfloop query="rsEmpresas">
	<cfquery name="rsParametro" datasource="#Session.DSN#">
		select p.Pvalor
		  from Parametros p
		 where p.Ecodigo = #rsEmpresas.Ecodigo#
		   and p.Pcodigo = 46
	</cfquery>
	
	<cfif rsParametro.Pvalor EQ "">
		<cfthrow message="La empresa #rsEmpresas.Edescripcion#, no tiene definido su Mes de Cierre Corporativo">
	<cfelseif rsParametro.Pvalor NEQ rsCierreCorp.Pvalor>
		<cfthrow message="La empresa #rsEmpresas.Edescripcion#, tiene un Mes de Cierre Corporativo diferente a #rsCierreCorp.Pvalor#">
	</cfif>
</cfloop>

<!--- Verificar Moneda de Conversion para empresas en otra moneda --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Mnombre
	from Monedas m
	where Mcodigo = #form.Mcodigo#
	  and Ecodigo = #session.Ecodigo#
</cfquery>

<!--- 
	cboB15:
		"" - Moneda Corporativa es la Local
		0 - Moneda de Conversion Corporativa
		1 - Moneda Funcional B15
		2 - Moneda Expresion B15
--->
<cfif form.cboB15 EQ 0 AND rsEmpresas.recordCount EQ 0>
	<cfset form.cboB15 = "">
</cfif>
<cfset LvarEsPresupuesto = form.tipo EQ 10>
<cfif LvarEsPresupuesto AND form.cboB15 NEQ 0>
	<cfthrow message="No se ha implementado la Conversi&oacute;n B15 de Saldos de Control de Presupuesto">
</cfif>

<cfquery name="rsEmpresas" datasource="#Session.DSN#">
	select e.Ecodigo, m.Mcodigo, m.Miso4217, e.Edescripcion
	 from #empresas# ee
		inner join Empresas e
			on e.Ecodigo = ee.codigo
		inner join Monedas m
			on m.Ecodigo = e.Ecodigo
		   and m.Mcodigo = e.Mcodigo
	where m.Miso4217 <> '#rsMoneda.Miso4217#'
</cfquery>

<cfloop query="rsEmpresas">
	<cfquery name="rsParametro" datasource="#Session.DSN#">
		select p.Ecodigo
		  from Parametros p
			inner join Monedas m
				on m.Mcodigo = <cf_dbfunction name="to_number" args="p.Pvalor">
		<cfif form.cboB15 EQ 0>
		 where p.Pcodigo = 660
		<cfelseif form.cboB15 EQ 1>
		 where p.Pcodigo = 3810
		<cfelseif form.cboB15 EQ 2>
		 where p.Pcodigo = 3900
		</cfif>
		   and p.Ecodigo = #rsEmpresas.Ecodigo#
		   and m.Miso4217 = '#rsMoneda.Miso4217#'
	</cfquery>
	
	<cfif rsParametro.recordcount eq 0>
		<cfif form.cboB15 EQ 0>
			<cfthrow message="La empresa #rsEmpresas.Edescripcion#, tiene una moneda de Conversi&oacute;n de Estados Financieros diferente a #rsMoneda.Miso4217#">
		<cfelseif form.cboB15 EQ 1>
			<cfthrow message="La empresa #rsEmpresas.Edescripcion#, tiene una moneda Funcional B15 de Estados Financieros diferente a #rsMoneda.Miso4217#">
		<cfelse>
			<cfthrow message="La empresa #rsEmpresas.Edescripcion#, tiene una moneda de Expresi&oacute;n B15 de Estados Financieros diferente a #rsMoneda.Miso4217#">
		</cfif>
	</cfif>

	<cfif NOT LvarEsPresupuesto>
		<cfquery name="rsSaldosConvertidos" datasource="#Session.DSN#">
			select count(1) as cantidad
			 from SaldosContablesConvertidos scc
			  inner join Monedas m
				on m.Mcodigo = scc.Mcodigo
			   and m.Ecodigo = scc.Ecodigo
			where scc.Ecodigo	= #rsEmpresas.Ecodigo#
			  and scc.Speriodo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
			  and scc.Smes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
			  and scc.B15		= #form.cboB15#
			  and m.Miso4217	= '#rsMoneda.Miso4217#'
		</cfquery>
		<cfif rsSaldosConvertidos.cantidad eq 0>
			<cfthrow message="La empresa #rsEmpresas.Edescripcion#, no se le ha realizado el proceso de Conversi&oacute;n de Estados Financieros para: Periodo=#form.periodo#, Mes=#form.mes#, Moneda=#rsMoneda.Miso4217#">
		</cfif>
	</cfif>
</cfloop>

<cfif form.tipo EQ 3>
	<cfset LvarSLinicialGE = "0">
	<cfset form.tipo = 2>
<cfelse>
	<cfset LvarSLinicialGE = "SLinicialGE">
</cfif>

<!--- INICIO PROCESO PARA PRESUPUESTO --->
<cfif LvarEsPresupuesto>
	<cfset form.tipo = form.CPCtipo>

	<cfif rsCierreCorp.Pvalor EQ 12>
		<cfset LvarAnoMesIni = form.periodo*100 + 1>
		<cfset LvarAnoMesFin = form.periodo*100 + rsCierreCorp.Pvalor>
	<cfelseif form.mes LTE rsCierreCorp.Pvalor>
		<cfset LvarAnoMesIni = (form.periodo-1)*100 + (rsCierreCorp.Pvalor+1)>
		<cfset LvarAnoMesFin = form.periodo*100 + rsCierreCorp.Pvalor>
	<cfelse>
		<cfset LvarAnoMesIni = form.periodo*100 + (rsCierreCorp.Pvalor+1)>
		<cfset LvarAnoMesFin = (form.periodo+1)*100 + rsCierreCorp.Pvalor>
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into #CPmeses# (Ecodigo, CPCano, CPCmes, CPPid)
		select Ecodigo, CPCano, CPCmes, CPPid
		  from CPmeses m
			inner join #empresas# e
				ON e.codigo = m.Ecodigo
		<cfif form.CPCcalculoControl EQ 1>
		 where m.CPCano		= #form.periodo#
		   and m.CPCmes		= #form.mes#
		<cfelseif form.CPCcalculoControl EQ 2>
		 where m.CPCano*100+m.CPCmes between #LvarAnoMesIni# and #form.periodo*100 + form.mes#
		<cfelseif form.CPCcalculoControl EQ 3>
		 where m.CPCano*100+m.CPCmes between #LvarAnoMesIni# and #LvarAnoMesFin#
		<cfelse>
			<cfthrow message="Calculo Control incorrecto: #form.CPCcalculoControl#">
		</cfif>
		  and m.CPPid is not null
	</cfquery>

	<cfif form.cboB15 GT 0>
		<cfthrow message="No se ha implementado la Conversion B15 de Saldos de Control de Presupuesto">
	</cfif>

	<cfif form.cboB15 EQ 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select distinct m.Ecodigo, ee.Edescripcion, m.CPCano, m.CPCmes
			  from #CPmeses# m
				inner join Monedas mm
					on mm.Ecodigo	= m.Ecodigo
				   and mm.Miso4217	= '#rsMoneda.Miso4217#'
				inner join Empresas ee
					on ee.Ecodigo	= m.Ecodigo
			 where (
					select count(1)
					  from HtiposcambioConversion tc
					 WHERE tc.Ecodigo  = m.Ecodigo 
					   AND tc.Speriodo = m.CPCano 
					   AND tc.Smes     = m.CPCmes
					   AND tc.Mcodigo  = mm.Mcodigo
					   AND tc.TCtipo   = 1
					) = 0
		</cfquery>
		<cfloop query="rsSQL">
			<cfthrow message="La empresa #rsSQL.Edescripcion#, no ha registrado los Tipos de Cambio de Conversion de Presupuesto para: Periodo=#rsSQL.CPCano#, Mes=#rsSQL.CPCmes#">
		</cfloop>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select m.Ecodigo, ee.Edescripcion, tch.TCHdescripcion, m.CPCano, m.CPCmes, cm.Cmayor
			  from #CPmeses# m
				inner join Monedas mm
					on mm.Ecodigo	= m.Ecodigo
				   and mm.Miso4217	= '#rsMoneda.Miso4217#'
				inner join Empresas ee
					on ee.Ecodigo	= m.Ecodigo
				inner join CtasMayor cm
					 on cm.Ecodigo			= m.Ecodigo
					and cm.CTCconversion	= 4
					and cm.TCHid 			is not null
				inner join CPVigencia v
					 on v.Ecodigo	= cm.Ecodigo
					and v.Cmayor	= cm.Cmayor
					and m.CPCano*100+m.CPCmes between CPVdesdeAnoMes and CPVhastaAnoMes
				inner join PCEMascaras mk
					 on mk.PCEMid		= v.PCEMid 
					and mk.PCEMformatoP	is not null
				inner join HtiposcambioConversionE tch
					 on tch.TCHid	= cm.TCHid
   			 where (
					select count(1)
					  from HtiposcambioConversionD tc
					 WHERE tc.Ecodigo  = m.Ecodigo 
					   AND tc.Speriodo = m.CPCano 
					   AND tc.Smes     = m.CPCmes
					   AND tc.Mcodigo  = mm.Mcodigo
					   AND tc.TCHid    = cm.TCHid
					   AND tc.TCHtipo  = 1
					) = 0
		</cfquery>
		<cfloop query="rsSQL">
			<cfthrow message="La empresa #rsSQL.Edescripcion#, no ha registrado los Tipos de Cambio de Conversion Adicional '#rsSQL.TCHdescripcion#' de Presupuesto para: Cmayor=#rsSQL.Cmayor#, Periodo=#rsSQL.CPCano#, Mes=#rsSQL.CPCmes#">
		</cfloop>
	</cfif>
	
	<cfif form.CPCsaldo EQ "[*DN]">
		<cfset LvarCPtipoSaldo = "Presupuesto Disponible Neto">
	<cfelseif form.CPCsaldo EQ "[*PC]">
		<cfset LvarCPtipoSaldo = "Presupuesto Consumido Total">
	<cfelseif form.CPCsaldo EQ "[*PCA]">
		<cfset LvarCPtipoSaldo = "Presupuesto Consumido por Auxiliares y Contabilidad">
	<cfelseif form.CPCsaldo EQ "[*PA]">
		<cfset LvarCPtipoSaldo = "Presupuesto Autorizado">
	<cfelseif form.CPCsaldo EQ "[*PP]">
		<cfset LvarCPtipoSaldo = "Presupuesto Planeado">
	<cfelseif form.CPCsaldo EQ "[*PF]">
		<cfset LvarCPtipoSaldo = "Presupuesto Formulado Total">
	<cfelseif form.CPCsaldo EQ "[A]" >
		<cfset LvarCPtipoSaldo = "Presupuesto Formulado Ordinario">
	<cfelseif form.CPCsaldo EQ "[M]" >
		<cfset LvarCPtipoSaldo = "Presupuesto Formulado Extraordinario">
	<cfelseif form.CPCsaldo EQ "[VC]">
		<cfset LvarCPtipoSaldo = "Presupuesto Autorizado por Variación Cambiaria">
	<cfelseif form.CPCsaldo EQ "[ME]">
		<cfset LvarCPtipoSaldo = "Presupuesto Autorizado por Excesos Autorizados">
	<cfelseif form.CPCsaldo EQ "[T]" >
		<cfset LvarCPtipoSaldo = "Presupuesto Autorizado por Traslados">
	<cfelseif form.CPCsaldo EQ "[TE]">
		<cfset LvarCPtipoSaldo = "Presupuesto Autorizado por Traslados Externos">
	<cfelseif form.CPCsaldo EQ "[RA]">
		<cfset LvarCPtipoSaldo = "Presupuesto Reservado por Períodos Anteriores">
	<cfelseif form.CPCsaldo EQ "[CA]">
		<cfset LvarCPtipoSaldo = "Presupuesto Comprometido por Períodos Anteriores">
	<cfelseif form.CPCsaldo EQ "[RP]">
		<cfset LvarCPtipoSaldo = "Presupuesto Provisionado">
	<cfelseif form.CPCsaldo EQ "[RC]">
		<cfset LvarCPtipoSaldo = "Presupuesto Reservado">
	<cfelseif form.CPCsaldo EQ "[CC]">
		<cfset LvarCPtipoSaldo = "Presupuesto Comprometido">
	<cfelseif form.CPCsaldo EQ "[NP]">
		<cfset LvarCPtipoSaldo = "Presupuesto Pendiente por Excesos Autorizados">
	<cfelseif form.CPCsaldo EQ "[E]" >
		<cfset LvarCPtipoSaldo = "Presupuesto Ejecutado">
	<cfelseif form.CPCsaldo EQ "[P]" >
		<cfset LvarCPtipoSaldo = "Presupuesto Pagado">
	<cfelseif form.CPCsaldo EQ "[E1]">
		<cfset LvarCPtipoSaldo = "Presupuesto Devengado no Pagado">
	<cfelseif form.CPCsaldo EQ "[EJ]">
		<cfset LvarCPtipoSaldo = "Presupuesto Ejercido Total">
	<cfelseif form.CPCsaldo EQ "[E2]">
		<cfset LvarCPtipoSaldo = "Presupuesto Ejercido no Pagado">
	<cfelseif form.CPCsaldo EQ "[PA]">
		<cfset LvarCPtipoSaldo = "Presupuesto Pagado por Anticipado">
	</cfif>

	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[*DN]","([*PA]-[*PC]+[NP])","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[*PC]","([*PCA]+[RP])","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[*PCA]","([*RT]+[*CT]+[E])","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[*PA]","([*PP]+[ME])","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[*PP]","([*PF]+[T]+[TE]+[VC])","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[*PF]","([A]+[M])","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[A]" ,"s.CPCpresupuestado","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[M]" ,"s.CPCmodificado","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[VC]","s.CPCvariacion","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[ME]","s.CPCmodificacion_Extraordinaria","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[T]" ,"s.CPCtrasladado","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[TE]","s.CPCtrasladadoE","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[RA]","s.CPCreservado_Anterior","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[CA]","s.CPCcomprometido_Anterior","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[RP]","s.CPCreservado_Presupuesto","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[RC]","s.CPCreservado","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[CC]","s.CPCcomprometido","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[NP]","s.CPCnrpsPendientes","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[E1]","case when [EJ]<>0 then [E]-[EJ] else [E]-[P] end","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[E2]","case when [EJ]<>0 then [EJ]-[P] else 0 end","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[E]" ,"s.CPCejecutado","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[P]" ,"s.CPCpagado","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[EJ]","s.CPCejercido","ALL")>
	<cfset form.CPCsaldo = replace(form.CPCsaldo,"[PA]","s.CPCejercido","ALL")>
	<cfquery name="rsSaldos" datasource="#session.DSN#">
		insert into #saldosxempresa#
			(	
				Ccuenta,
				Ecodigo,
				Cformato,
				nivel,
				tipo,
				subtipo,
				saldo
			)
		select distinct
				cu.CPcuentaniv,
				cc.Ecodigo,
				cc.CPformato,
				cu.PCDCniv,
				cm.Ctipo,
				case cm.Ctipo
					when 'A' then 200 
					when 'P' then 210 
					when 'C' then 220 
					else cm.Csubtipo 
				end as subtipo,
				0.00
		from #empresas# e
			INNER JOIN CtasMayor cm
				ON cm.Ecodigo = e.codigo 
			INNER JOIN CPresupuesto cc
				 ON cc.Ecodigo = cm.Ecodigo
				AND cc.Cmayor  = cm.Cmayor
			INNER JOIN PCDCatalogoCuentaP cu
				ON cu.CPcuentaniv = cc.CPcuenta
			where 
				<cfif form.tipo eq 0 >
				  cm.Ctipo in ('A', 'P', 'C', 'I', 'G')
				<cfelseif form.tipo eq 1 >
				  cm.Ctipo in ('A', 'P', 'C', 'I', 'G')  <!--- 'I','G' se usan para calcular Utilidad, luego se borran --->
				<cfelse>
				  cm.Ctipo in ('I', 'G')
				</cfif>
			  and cu.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel#">
	</cfquery>  

	<cfquery name="dos" datasource="#session.DSN#">
		update #saldosxempresa#
		set saldo = 
				coalesce(( 
					select sum(#form.CPCsaldo#
						<cfif form.cboB15 NEQ "">
							* COALESCE(
								CASE 
									WHEN ee.Mcodigo = mm.Mcodigo THEN 1.00
									ELSE (
											select 
												CASE cm.CTCconversion
													WHEN 0 THEN
														CASE cm.Ctipo 
															WHEN 'A' THEN tc.TCcompra 
															WHEN 'P' THEN tc.TCventa 
															WHEN 'C' THEN tc.TCpromedio
															WHEN 'I' THEN tc.TCpromedio
															WHEN 'G' THEN tc.TCpromedio 
															ELSE tc.TCventa 
														END
													WHEN 1 THEN tc.TCcompra 
													WHEN 2 THEN tc.TCventa 
													WHEN 3 THEN tc.TCpromedio 
													WHEN 4 THEN  (select TCHvalor
																  from HtiposcambioConversionD 
																  WHERE Ecodigo  = s.Ecodigo 
																	AND Speriodo = s.CPCano 
																	AND Smes     = s.CPCmes
																	AND Mcodigo  = mm.Mcodigo
																	AND TCHid    = cm.TCHid
																	AND TCHtipo	 = 1
																  )
												END 
											  FROM HtiposcambioConversion tc
											 WHERE tc.Ecodigo  = s.Ecodigo 
											   AND tc.Speriodo = s.CPCano 
											   AND tc.Smes     = s.CPCmes
											   AND tc.Mcodigo  = mm.Mcodigo
											   AND tc.TCtipo   = 1
										   ) 
								END, 1.00) 
						</cfif>
							)
					  from PCDCatalogoCuentaP cu
						INNER JOIN CPresupuestoControl s
							ON s.CPcuenta = cu.CPcuenta
						INNER JOIN CPresupuesto cc
							 ON cc.CPcuenta = cu.CPcuenta
						INNER JOIN CtasMayor cm
							ON cm.Ecodigo = cc.Ecodigo 
						   and cm.Cmayor  = cc.Cmayor
						inner join Empresas ee
							on ee.Ecodigo = s.Ecodigo
						inner join Monedas mm
							on mm.Ecodigo = ee.Ecodigo
						   and mm.Miso4217 = '#rsMoneda.Miso4217#'
						inner join #CPmeses# m
							 on m.Ecodigo	= s.Ecodigo
							and m.CPCano	= s.CPCano
							and m.CPCmes	= s.CPCmes
							and m.CPPid		= s.CPPid
					 where cu.CPcuentaniv	= #saldosxempresa#.Ccuenta
				  ), 0)
				  
	</cfquery>
<cfelse>
<!--- INICIO PROCESO PARA CONTABILIDAD --->
	<cfquery name="rsSaldos" datasource="#session.DSN#">
		insert into #saldosxempresa#
			(	
				Ccuenta,
				Ecodigo,
				Cformato,
				nivel,
				tipo,
				subtipo,
				saldo
			)
		select distinct
				cu.Ccuentaniv,
				cc.Ecodigo,
				cc.Cformato,
				cu.PCDCniv,
				cm.Ctipo,
				case cm.Ctipo
					when 'A' then 200 
					when 'P' then 210 
					when 'C' then 220 
					else cm.Csubtipo 
				end as subtipo,
				0.00
		from #empresas# e
			INNER JOIN CtasMayor cm
				ON cm.Ecodigo = e.codigo 
			INNER JOIN CContables cc
				 ON cc.Ecodigo = cm.Ecodigo
				AND cc.Cmayor  = cm.Cmayor
				INNER JOIN PCDCatalogoCuenta cu
				ON cu.Ccuentaniv = cc.Ccuenta
			where 
				<cfif form.tipo eq 0 >
				  cm.Ctipo in ('A', 'P', 'C', 'I', 'G')
				<cfelseif form.tipo eq 1 >
				  cm.Ctipo in ('A', 'P', 'C', 'I', 'G')		<!--- 'I','G' se usan para calcular Utilidad, luego se borran --->
				<cfelse>
				  cm.Ctipo in ('I', 'G')
				</cfif>
			  and cu.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel#">
	</cfquery>  

	<cfif form.cboB15 NEQ "">
		<cfquery name="dos" datasource="#session.DSN#">
			update #saldosxempresa#
			set saldo = coalesce(( 
							select sum(#LvarSLinicialGE# + DLdebitos - CLcreditos)
							from SaldosContablesConvertidos scc
							where scc.Ccuenta = #saldosxempresa#.Ccuenta
							  and scc.Speriodo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
							  and scc.Smes 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
							  and scc.B15  		= #form.cboB15#
						), 0.00)
		</cfquery>
	</cfif>
	
	<cfquery datasource="#session.DSN#">
		update #saldosxempresa#
		   set saldo = coalesce(( 
							select sum(#LvarSLinicialGE# + DLdebitos - CLcreditos)
							from SaldosContables sc
							where sc.Ccuenta = #saldosxempresa#.Ccuenta
							  and sc.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
							  and sc.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
					  ), 0.00)
		<cfif form.cboB15 NEQ "">
		 where (
				select count(1)
				  from SaldosContablesConvertidos scc
				 where scc.Ccuenta	= #saldosxempresa#.Ccuenta
				   and scc.Speriodo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
				   and scc.Smes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
				   and scc.B15  	= #form.cboB15#
			  ) = 0
		</cfif>
	</cfquery>

	<!--- Cambiar el signo estandar de las cuentas:  P=Pasivo, C=Capital, I=Ingreso  pues tienen saldos normalmente al Credito  --->
	<cfquery datasource="#session.DSN#">
		update #saldosxempresa#
		set saldo = -saldo
		where tipo in ('P', 'C', 'I')
	</cfquery>
</cfif>

<!--- Borrar las cuentas que tengan saldo en cero o que no sean nivelSeleccionado --->
<cfquery datasource="#session.DSN#">
	delete from #saldosxempresa#
	 where (saldo = 0.00 and nivel <> 0)
	<cfif session.Conta.balances.nivelSeleccionado>
	   OR (
		      nivel 	<> #varNivel#
		  and nivel 	<> 0
		  and (select Cmovimiento from CContables where Ccuenta=#saldosxempresa#.Ccuenta) <> 'S'
		  )
	</cfif>
</cfquery>
	
<cfif form.tipo lte 1 >
	<!--- Insertar la cuenta de utilidad por cada empresa --->
	<cfquery datasource="#session.DSN#">
		insert into #fcuentas# (Cnivel, Cformato, Cdescripcion, Cmayor, tipo, subtipo)
		select
			0,
			'UTILIDAD', 
			'Utilidad del Periodo', 
			'UUUU', 
			'C',
			300 
		 from dual
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		insert into #saldosxempresa#
			(	
				Ccuenta,
				Ecodigo,
				Cformato,
				nivel,
				tipo,
				subtipo,
				saldo
			)
		select 	0,
				Ecodigo,
				'UTILIDAD',
				0,
				'C',
				300,
				sum(case tipo when 'I' then saldo else -saldo end)
		  from #saldosxempresa#
		 where tipo in ('I', 'G')
		   and nivel = 0
		 group by Ecodigo
	</cfquery>

	<cfif form.tipo eq 1 >
		<cfquery datasource="#session.DSN#">
			delete from #saldosxempresa#
			 where tipo in ('I', 'G')
		</cfquery>
	</cfif>
</cfif>

<!--- Insertar todas las cuentas diferentes encontradas --->
<cfquery datasource="#session.DSN#">
	insert into #fcuentas# (Cnivel, Cformato, Cdescripcion, Cmayor, tipo, subtipo)
	select distinct 
		se.nivel,
		se.Cformato, 
		' ', 
		c.Cmayor, 
		se.tipo,
		se.subtipo
	from #saldosxempresa# se
			inner join <cfif LvarEsPresupuesto>CPresupuesto<cfelse>CContables</cfif> c
				on c.<cfif LvarEsPresupuesto>CPcuenta<cfelse>Ccuenta</cfif>=se.Ccuenta
</cfquery>

<!--- Actualizar la descripcion de la cuenta.  Pueden tener descripciones distintas, por lo que se usa la primera --->
<cfquery datasource="#session.DSN#">
	update #fcuentas#
	set Cdescripcion = coalesce(
			( 
				select min(c.<cfif LvarEsPresupuesto>CPdescripcion<cfelse>Cdescripcion</cfif>)
				  from #empresas# e
					inner join <cfif LvarEsPresupuesto>CPresupuesto<cfelse>CContables</cfif> c
						inner join CtasMayor cm
							 on cm.Ecodigo = c.Ecodigo
							and cm.Cmayor = c.Cmayor
						on c.Ecodigo = e.codigo
					   and c.<cfif LvarEsPresupuesto>CPformato<cfelse>Cformato</cfif> = #fcuentas#.Cformato
				 where #fcuentas#.tipo = cm.Ctipo
				   and #fcuentas#.subtipo = 
							case cm.Ctipo
								when 'A' then 200 
								when 'P' then 210 
								when 'C' then 220 
								else cm.Csubtipo 
							end
			), 'N/A')
	where Cformato <> 'UTILIDAD'
</cfquery>

<!--- Insertar las cuentas y saldos de la empresa CONSOLIDADA --->
<cfquery datasource="#session.DSN#">
	insert into #saldosxempresa# (
			Ccuenta,
			Ecodigo,
			Cformato,
			nivel,
			tipo,
			subtipo,
			saldo
			)
	select 0, 0, Cformato, nivel, tipo, subtipo, sum(saldo)
	from #saldosxempresa#
	group by Cformato, nivel, tipo, subtipo
</cfquery>

<!--- Cantidad de columnas a generar -  A esto se debe sumar dos columnas de la cuenta y la descripcion --->
<cfquery name="empresa" datasource="#session.DSN#">
	select id as Columna, codigo as Codigo, nombre as Nombre
	from #empresas# 
	where codigo <> 0
	order by id
</cfquery>	
	
<!--- Salida para generar la tabla HTML --->
<cfquery datasource="#session.DSN#" name="datos0">	
	select 	fc.Cformato as Cuenta, 
			fc.Cdescripcion as Cdescripcion, 
			e.id as Columna, 
			e.codigo as Ecodigo, 
			e.nombre as NombreEmpresa, 
			se.nivel, 
			coalesce(se.saldo, 0.00) as Saldo,
			fc.tipo,
			fc.subtipo
	from #fcuentas# fc
		inner join #empresas# e
			on 1=1
		left outer join #saldosxempresa# se
		   on e.codigo    	= se.Ecodigo
		  and se.Cformato 	= fc.Cformato 
		  and se.tipo		= fc.tipo
		  and se.subtipo	= fc.subtipo
	order by fc.subtipo, fc.Cformato, e.id
</cfquery>

<cfcontent reset="yes">
<cfif not isdefined('form.btnDownload')>
	<cf_templatecss>
<cfelse>
	<cfset oldlocale = SetLocale("French (Canadian)")>
</cfif>
  
<cf_htmlReportsHeaders irA="consolidado-cuentas-filtro.cfm" FileName="consolidado.xls" title="Consolidado de Empresas">

	<cfsetting enablecfoutputonly="no">
	
	<cfflush interval="1000">
	
	<style type="text/css">
		.negrita{ font-weight:bold; 
			white-space:nowrap; 
			mso-number-format:"\##\,\##\##0\.00";
			}
		
		.encabReporte {
			background-color: #006699;
			font-weight: bold;
			color: #FFFFFF;
			padding-top: 2px;
			padding-bottom: 2px;
			font-size:12px;
			font:Arial, Helvetica, sans-serif;
			text-transform:uppercase;
		}
		.Datos
		{
			white-space:nowrap; 
			mso-number-format:"\##\,\##\##0\.00";
		}
	</style> 

	<cfoutput>
	<table width="99%" align="center" cellpadding="0" cellspacing="0">
		<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
		<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>
			<cfif LvarEsPresupuesto>
				<cfif form.CPCtipo eq 0>
					Reporte Consolidado de #LvarCPtipoSaldo# para todas las Cuentas
				<cfelseif form.CPCtipo eq 1>
					Reporte Consolidado de #LvarCPtipoSaldo# para Cuentas de Balance
				<cfelseif form.CPCtipo eq 2>
					Reporte Consolidado de #LvarCPtipoSaldo# para Cuentas de Resultado
				</cfif>
			<cfelseif form.tipo eq 0>
				Reporte de Saldos Contables Consolidado de Empresas
			<cfelseif form.tipo eq 1>
				Balance General Consolidado de Empresas
			<cfelseif form.tipo eq 2>
				Estado de Resultados Consolidado de Empresas
			</cfif>
		</strong></font></td></tr>
		<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#titulo_grupo.nombre#</strong></font></td></tr>
		<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Nivel: #form.Nivel#
			<cfif form.cboB15 EQ 2>
				- En Moneda de Expresion B15 #rsMoneda.Mnombre#
			<cfelseif form.cboB15 EQ 1>
				- En Moneda de Funcional B15 #rsMoneda.Mnombre#
			<cfelse>
				- En #rsMoneda.Mnombre#
			</cfif>
		</strong></font></td></tr>
		<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>
			<cfif LvarEsPresupuesto>
				<cfif form.CPCcalculoControl EQ 1>
					Mensual: #form.mes#/#form.Periodo#
				<cfelseif form.CPCcalculoControl EQ 2>
					Acumulado: del #right("#LvarAnoMesIni#",2)#/#left("#LvarAnoMesIni#",4)# al #form.mes#/#form.Periodo#
				<cfelseif form.CPCcalculoControl EQ 3>
					Periodo: del #right("#LvarAnoMesIni#",2)#/#left("#LvarAnoMesIni#",4)# al #right("#LvarAnoMesFin#",2)#/#left("#LvarAnoMesFin#",4)#
				</cfif>
			<cfelseif LvarSLinicialGE EQ "0">
				Movimientos del Mes: #numberFormat(form.mes,"00")#/#form.Periodo#
			<cfelse>
				Saldos Al Mes: #numberFormat(form.mes,"00")#/#form.Periodo#
			</cfif>
		</strong></font></td></tr>

	</table>
	</cfoutput>
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td class="tituloListas">Cuenta</td>
			<td class="tituloListas"><div style="width:300px">Descripci&oacute;n</div></td>
			<td class="tituloListas" align="right">Consolidado</td>
			<cfoutput query="empresa">
				<td class="tituloListas" align="right">#REPLACE(empresa.nombre,". ",".","ALL")#</td>
				<!--- TOTALIZAR --->
			</cfoutput>
		</tr>
	
		<cfif (form.tipo EQ 1 OR form.tipo EQ 2)>
			<cfset datos = datos0>
			<cfset subtotalizar = 0>
			<cfinclude template="consolidado-cuentas-impr2.cfm">
		<cfelseif form.tipo EQ 0>
			<cfquery dbtype="query" name="datos">	
				select 	*
				from datos0 
				where subtipo >= 200
			</cfquery>
			<cfset form.tipo = 1>
			<cfset subtotalizar = 0>
			<cfinclude template="consolidado-cuentas-impr2.cfm">
			<cfquery dbtype="query" name="datos">	
				select 	*
				from datos0 
				where subtipo < 200
			</cfquery>
			<cfset form.tipo = 2>
			<cfset subtotalizar = 0>
			<cfinclude template="consolidado-cuentas-impr2.cfm">
		</cfif>
	</table>
	<br />
</body></html>