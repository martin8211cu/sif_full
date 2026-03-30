<!---
		1. Obtiene el Periodo Contable
		2. Verifica que no exista ningún Período de Presupuesto ni ninguna Cuenta de Presupuesto
		3. Obtiene las máscaras asociadas a las cuentas mayores en SaldosContablesP
		4. Ajusta las máscaras con todos sus niveles de presupuesto: EsPresupuesto, FormatoP y NivelesP
		5. Crea todas las cuentas de Presupuesto para todas Cuentas Financieras de las Cmayor asociadas las máscaras ajustadas
			con CPcuenta = Ccuenta
		6. Crea un Período de Presupuesto igual al Período Contable
		7. Crea una Version de Presupuesto para el Período de Presupuesto
		8. Agrega todas las Cuentas de Presupuesto a la Versión: 
			CVMayor, 
			CVPresupuesto, 
			CVFormulacionTotales: Ocodigo, y cada mes del Período, monto=0
			CVFormulacionMonedas: Ocodigo, y cada mes del Período, monto=0, McodigoLocal, TipoCambio=1, Monto=0
		10. Actualiza CVFormulacionMonedas con SaldosContablesP
		11. Ajusta CVFormulacionTotales
		12. Aplica la Versión de Presupuesto
		13. Realiza la Ejecucion de Arranque de Presupuesto
--->

<cfsetting requesttimeout="36000">

<cfif application.CParranque>
	<cflocation url="arranque.cfm">
</cfif>

<cfif not isdefined("form.chkEcodigo")>
	<cf_errorCode	code = "50448" msg = "No escogió Empresas a generar">
</cfif>

<cfset application.CParranque = true>

<cftry>
	<cflog file="FormulacionAplica" text="================================================================">
	<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	INICIA PROCESO">
	<cflog file="FormulacionAplica" text="================================================================">
	
	<cfinclude template="arranque_verif.cfm">

	<cfset rsEcodigos = rsEcodigos()>

	<cfloop query="rsEcodigos">
<cflog file="FormulacionAplica" text="=============================================================================================">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	INICIO Ecodigo=#rsEcodigos.Ecodigo#">
<cflog file="FormulacionAplica" text="=============================================================================================">
		<cfset LvarEcodigo			= rsEcodigos.Ecodigo>
		<cfset LvarMcodigoEmpresa	= rsEcodigos.Mcodigo>
		
		<!---
			1. Obtiene el Periodo Contable
			2. Verifica que no exista ningún Período de Presupuesto ni ninguna Cuenta de Presupuesto
			3. Obtiene las máscaras asociadas a las cuentas mayores en SaldosContablesP
			4. Obtiene las Cuentas de Mayor asociadas a las máscaras ajustadas
		--->
		<cfset LvarVerifArranque = verifica_arranque (LvarEcodigo)>
		
		<cfset LvarCVid = LvarRet.CVid>
		<cfset LvarFechaIni = createDate(int(LvarVerifArranque.MesIni/100),LvarVerifArranque.MesIni mod 100,1)>
		<cfset LvarFechaFin = createDate(int(LvarVerifArranque.MesFin/100),LvarVerifArranque.MesFin mod 100,1)>
		<cfset LvarFechaFin = createDate(int(LvarVerifArranque.MesFin/100),LvarVerifArranque.MesFin mod 100,DaysInMonth(LvarFechaFin))>

		<cfif LvarVerifArranque.ERROR NEQ "">
			<cf_errorCode	code = "50449"
							msg  = "ERROR en Empresa '@errorDat_1@': @errorDat_2@. No se puede arrancar el Control de Presupuesto."
							errorDat_1="#rsEcodigos.Edescripcion#"
							errorDat_2="#LvarVerifArranque.ERROR#"
			>
		</cfif>
		
		<cfif LvarVerifArranque.GenerarEjecucion>
			<cfif LvarVerifArranque.CrearVersion>
				<!---
					4. Ajusta las máscaras con todos sus niveles de presupuesto: EsPresupuesto, FormatoP y NivelesP
				--->
<cflog file="FormulacionAplica" text="=============================================================================================">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	PASO 1 - Inicia Creacion Periodo, Cuentas y Version Presupuesto">
<cflog file="FormulacionAplica" text="=============================================================================================">
				<cftransaction>
					<cfquery datasource="#Session.DSN#">
						update PCNivelMascara
						   set PCNpresupuesto = 1
						 where exists (select 1 from #PCEM# m where m.PCEMid = PCNivelMascara.PCEMid)
					</cfquery>
					<cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery datasource="#Session.DSN#">
						update PCEMascaras 
						   set PCEMformatoC = rtrim(PCEMformato)
							 , PCEMformatoP = rtrim(PCEMformato)
							 , PCEMnivelesP = '1-' #_Cat# <cf_dbfunction name="to_char" args="len(rtrim(PCEMformato))">
						 where exists (select 1 from #PCEM# m where m.PCEMid = PCEMascaras.PCEMid)
					</cfquery>
			
					<!---
						5. Crea un Período de Presupuesto igual al Período Contable
					--->
					<cfquery name="rsCPP" datasource="#session.DSN#">
						select CPPid, CPPestado
								, CPPanoMesDesde, CPPfechaDesde
								, CPPanoMesHasta, CPPfechaHasta
						  from CPresupuestoPeriodo
						 where Ecodigo = #LvarEcodigo#
						   and #LvarVerifArranque.MesAct# between CPPanoMesDesde and CPPanoMesHasta
					</cfquery>

					<cfif rsCPP.CPPestado EQ "0">
						<cfif rsCPP.CPPanoMesDesde NEQ dateformat(LvarFechaIni,"YYYYMM")
						   OR rsCPP.CPPanoMesHasta NEQ dateformat(LvarFechaFin,"YYYYMM")>
							<cf_errorCode	code = "50450"
											msg  = "El Período de Presupuesto para Mes Actual de Contabilidad ('@errorDat_1@-@errorDat_2@') no corresponde con el Inicio y Fin del Período Contable: Período de Presupuesto='@errorDat_3@-@errorDat_4@', Período Contable='@errorDat_5@-@errorDat_6@'"
											errorDat_1="#rsParametros.Ano#"
											errorDat_2="#rsParametros.Mes#"
											errorDat_3="#dateformat(rsCPP.CPPfechaDesde,"MM/YYYY")#"
											errorDat_4="#dateformat(rsCPP.CPPfechaHasta,"MM/YYYY")#"
											errorDat_5="#dateformat(LvarFechaIni,"MM/YYYY")#"
											errorDat_6="#dateformat(LvarFechaFin,"MM/YYYY")#"
							>
						</cfif>
						<cfset LvarCPPid = rsCPP.CPPid>
					<cfelseif rsCPP.recordcount GT 0>
						<cf_errorCode	code = "50451"
										msg  = "El Período de Presupuesto para Mes Actual de Contabilidad ('@errorDat_1@/@errorDat_2@') no tiene estado 0=Inactivo: Período de Presupuesto='@errorDat_3@-@errorDat_4@', Estado=@errorDat_5@"
										errorDat_1="#rsParametros.Ano#"
										errorDat_2="#rsParametros.Mes#"
										errorDat_3="#dateformat(rsCPP.CPPfechaDesde,"MM/YYYY")#"
										errorDat_4="#dateformat(rsCPP.CPPfechaHasta,"MM/YYYY")#"
										errorDat_5="#rsCPP.CPPestado#"
						>
					<cfelse>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							insert into CPresupuestoPeriodo
								(
									 Ecodigo              ,
									 Mcodigo              ,
									 CPPtipoPeriodo       ,
									 CPPfechaDesde        ,
									 CPPfechaHasta        ,
									 CPPfechaUltmodif     ,
									 CPPanoMesDesde       ,
									 CPPanoMesHasta       ,
									 CPPestado            
								)
							values (
									#LvarEcodigo#,
									#LvarMcodigoEmpresa#,
									12, 					<!--- Tipo Anual = 12 meses --->
									<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaIni#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFin#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									#dateformat(LvarFechaIni,"YYYYMM")#,
									#dateformat(LvarFechaFin,"YYYYMM")#,
									0						<!--- Estado 0 = Inactivo --->
								)
							<cf_dbidentity1 name="rsSQL" datasource="#session.dsn#">
						</cfquery>
						<cf_dbidentity2 name="rsSQL" datasource="#session.dsn#" returnvariable="LvarCPPid">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CPresupuestoPeriodo">
					
						
						<cfset LvarMes = LvarVerifArranque.MesIni>
						<cfloop condition="LvarMes LTE LvarVerifArranque.MesFin">
							<cfquery name="rsSQL" datasource="#session.dsn#">
								insert into CPmeses
									(
										Ecodigo,
										CPPid,
										CPCano,
										CPCmes
									)
								values (
										#LvarEcodigo#,
										#LvarCPPid#,
										#int(LvarMes/100)#,
										#LvarMes mod 100#
									)
							</cfquery>
					
							<cfif (LvarMes mod 100) EQ 12>
								<cfset LvarMes = (int(LvarMes/100)+1)*100>
							</cfif>
							<cfset LvarMes = LvarMes + 1>
						</cfloop>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CPmeses">
					</cfif>
					
					<!---
						6. Crea todas las cuentas de Presupuesto para todas Cuentas Financieras de las Cmayor asociadas las máscaras ajustadas
							con CPcuenta = Ccuenta
					--->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select count(1) as cantidad
						  from CFinanciera cf
						  	inner join CPresupuesto cp
							   on cp.CPcuenta = cf.CFcuenta
						 where cf.Ecodigo = #LvarEcodigo#
					</cfquery>

					<cfif rsSQL.cantidad EQ 0>
						<cf_dbsetIdentity table="CPresupuesto" setting="ON" datasource="#session.dsn#">
						<cfquery datasource="#session.dsn#">
							insert into CPresupuesto
								(
									CPcuenta,
									CPVid,
									Ecodigo,
									Cmayor,
									CPformato,
									PCDcatid,
									CPdescripcion,
									CPdescripcionF,
									CPmovimiento,
									CPpadre
								)
							select 	cf.CFcuenta,
									cf.CPVid,
									cf.Ecodigo,
									cf.Cmayor,
									rtrim(cf.CFformato),
									cf.PCDcatid,
									cf.CFdescripcion,
									cf.CFdescripcionF,
									case
										when cf.CFmovimiento = 'S' and cf.Cmayor <> cf.CFformato
										then 'S'
										else 'N'
									end,
									cf.CFpadre
							  from CFinanciera cf
							 where Ecodigo = #LvarEcodigo#
							   and exists 
								(
									select 1 
									  from #CMAYOR# m
									 where m.CPVid  = cf.CPVid
									   and m.Cmayor = cf.Cmayor
								)
						</cfquery>
						<cf_dbsetIdentity table="CPresupuesto" setting="OFF" datasource="#session.dsn#">
	<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CPresupuesto">
	
						<cfquery datasource="#session.dsn#">
							update CFinanciera
							   set CPcuenta 	= case when Cmayor <> CFformato then CFcuenta 	else null end
								 , CFmovimiento = case when Cmayor <> CFformato then 'S' 		else 'N' end
							 where Ecodigo = #LvarEcodigo#
							   and CFmovimiento = 'S'
							   and exists 
								(
									select 1 
									  from #CMAYOR# m
									 where m.CPVid  = CFinanciera.CPVid
									   and m.Cmayor = CFinanciera.Cmayor
								)
						</cfquery>
	<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Update CFinanciera">
		
						<cfquery datasource="#session.dsn#">
							insert into PCDCatalogoCuentaP
								(
								 CPcuenta,
								 PCEMid,
								 PCEcatid,
								 PCDcatid,
								 CPcuentaniv,
								 PCDCniv
								)
							select cubo.CFcuenta, cubo.PCEMid, cubo.PCEcatid, cubo.PCDcatid, cubo.CFcuentaniv, cubo.PCDCniv
							  from PCDCatalogoCuentaF cubo
								inner join CPresupuesto cp
									 on cp.CPcuenta = cubo.CFcuenta
									and cp.Ecodigo  = #LvarEcodigo#
						</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Update CFinanciera">
	
						
						<!--- 
								Tipo Control 
									0 = Control Abierto			(No se controlan los excesos, hay saldos negativos)
									1 = Control Restringido		(Se puede autorizar un exceso)
									2 = Control Restricctivo	(No hay excesos)
								Tipo Calculo
									1 = Mensual
									2 = Acumulado
									3 = Total
						--->
						<cfset LvarTipoControl = 0>
						<cfset LvarCalculoControl = 2>
					
						<cfquery name="rsSQL" datasource="#session.dsn#">
							insert into CPCuentaPeriodo
								(
									Ecodigo,
									CPPid,
									CPcuenta,
									CPCPtipoControl,
									CPCPcalculoControl
								)
							select	#LvarEcodigo#,
									#LvarCPPid#,
									CPcuenta,
									#LvarTipoControl#, 
									#LvarCalculoControl#
							  from CPresupuesto
							 where Ecodigo = #LvarEcodigo#
							   and CPmovimiento = 'S'
						</cfquery>
	<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CPCuentaPeriodo">
					<cfelse>
						<cfset LvarTipoControl = 0>
						<cfset LvarCalculoControl = 2>
						<cfquery name="rsCtas" datasource="#session.dsn#">
							select CFcuenta, CFformato
							  from CFinanciera cf
							 where cf.Ecodigo = #LvarEcodigo#
							   and cf.CPcuenta is null
							   and cf.CFmovimiento = 'S'
							   and cf.Ccuenta is not null
							   and cf.Cmayor <> cf.CFformato
							   and exists 
								(
									select 1 
									  from #CMAYOR# m
									 where m.CPVid  = cf.CPVid
									   and m.Cmayor = cf.Cmayor
								)
						</cfquery>
						<cfloop query="rsCtas">
							<cfinvoke 
								component="sif.Componentes.PC_GeneraCuentaFinanciera"
								method="fnGeneraCuentaFinanciera"
								returnvariable="LvarError">
									<cfinvokeargument name="Lprm_Ecodigo" 			value="#LvarEcodigo#"/>
									<cfinvokeargument name="Lprm_CFformato" 		value="#rsCtas.CFformato#"/>
									<cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
									<cfinvokeargument name="Lprm_CrearPresupuesto" 	value="yes"/>
									<cfinvokeargument name="Lprm_InicializaControl"	value="yes"/>
									<cfinvokeargument name="Lprm_CPPid" 			value="#LvarCPPid#"/>
									<cfinvokeargument name="Lprm_CVPtipoControl" 	value="#LvarTipoControl#"/>
									<cfinvokeargument name="Lprm_CVPcalculoControl" value="#LvarCalculoControl#"/>
									<cfinvokeargument name="Lprm_CPdescripcion" 	value=""/>
									<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
									<cfinvokeargument name="Lprm_SoloVerificar" 	value="no"/>
							</cfinvoke>
							<cfif LvarError EQ "NEW" OR LvarError EQ "OLD">
								<cfquery datasource="#session.dsn#">
									update CFinanciera
									   set CPcuenta 	= (select CPcuenta from CPresupuesto where Ecodigo=#LvarEcodigo# and CPformato = '#rsCtas.CFformato#')
									 where CFcuenta 	= #rsCtas.CFcuenta#
								</cfquery>
							<cfelse>
								<cfthrow message="#LvarError#">
							</cfif>
						</cfloop>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	PC_GeneraCuentaFinanciera(CrearPresupuesto) #rsCtas.recordCount# veces">
						<cfquery datasource="#session.dsn#">
							update CFinanciera
							   set CFmovimiento = case when Ccuenta is not null then 'S' else 'N' end
							 where Ecodigo = #LvarEcodigo#
						</cfquery>
					</cfif>
									
					<!---
						7. Crea una Version de Presupuesto para el Período de Presupuesto
					--->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CVersion
							(
								 Ecodigo              ,
								 CVtipo               ,
								 CVdescripcion        ,
								 CPPid                ,
								 CVestado,
								 CVaprobada
							)
						values (
								#LvarEcodigo#,
								'1', 					<!--- Tipo 1 = Formulación Inicial --->
								'#LvarCVdescripcion#',
								#LvarCPPid#,
								0,						<!--- Estado 0 = Etapa Base --->
								0						<!--- Aprobada 0 = NO --->
							)
						<cf_dbidentity1 name="rsSQL" datasource="#session.dsn#">
					</cfquery>
					<cf_dbidentity2 name="rsSQL" datasource="#session.dsn#" returnvariable="LvarCVid">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CVersion">
				
					<!---
						8. Agrega todas las Cuentas de Presupuesto a la Versión: 
							CVMayor, 
							CVPresupuesto, 
							CVFormulacionTotales: Ocodigo, y cada mes del Período, monto=0
							CVFormulacionMonedas: Ocodigo, y cada mes del Período, monto=0, McodigoLocal, TipoCambio=1, Monto=0
					--->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CVMayor
							(
								Ecodigo,
								CVid,
								Cmayor,
								Ctipo,
								CPVidOri,
								PCEMidOri,
								Cmascara,
								CVMtipoControl,
								CVMcalculoControl
							)
						select	#LvarEcodigo#,
								#LvarCVid#,
								Cmayor,
								Ctipo,
								CPVid,
								PCEMid,
								PCEMformatoP,
								#LvarTipoControl#, 
								#LvarCalculoControl#
						  from #CMAYOR# m
					</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CVMayor">
					<!--- CVPcuenta = Ccuenta, para optimizar el join con SaldosContablesP --->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CVPresupuesto
							(
								Ecodigo,
								CVid,
								Cmayor,
								CVPcuenta,
								CPcuenta,
								CPformato,
								CPdescripcion,
								CVPtipoControl,
								CVPcalculoControl
							)
						select	#LvarEcodigo#,
								#LvarCVid#,
								cp.Cmayor,
								cf.Ccuenta,
								cp.CPcuenta,
								cp.CPformato,
								cp.CPdescripcion,
								#LvarTipoControl#, 
								#LvarCalculoControl#
						  from CPresupuesto cp
						  	inner join CFinanciera cf
								on cf.CPcuenta = cp.CPcuenta
						 where cp.Ecodigo = #LvarEcodigo#
						   and cp.CPmovimiento = 'S'
						   and cp.CPformato <> cp.Cmayor
					</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CVPresupuesto">
				
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CVFormulacionTotales
							(
								Ecodigo,
								CVid,
								CPCano,
								CPCmes,
								CVPcuenta,
								Ocodigo
							)
						select	#LvarEcodigo#,
								#LvarCVid#,
								m.CPCano,
								m.CPCmes,
								cvp.CVPcuenta,
								o.Ocodigo
						  from CVPresupuesto cvp, Oficinas o, CPmeses m
						 where cvp.Ecodigo	= #LvarEcodigo#
						   and cvp.CVid		= #LvarCVid#

						   and o.Ecodigo	= #LvarEcodigo#
						   and m.CPPid		= #LvarCPPid#
					</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CVFormulacionTotales">
				
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CVFormulacionMonedas
							(
								Ecodigo,
								CVid,
								CPCano,
								CPCmes,
								CVPcuenta,
								Ocodigo,
								Mcodigo,
								CVFMtipoCambio,
								CVFMmontoBase
							)
						select	#LvarEcodigo#,
								#LvarCVid#,
								cvft.CPCano,
								cvft.CPCmes,
								cvft.CVPcuenta,
								cvft.Ocodigo,
								#LvarMcodigoEmpresa#,
								1,
								0
						  from CVFormulacionTotales cvft
						 where cvft.Ecodigo	= #LvarEcodigo#
						   and cvft.CVid	= #LvarCVid#
					</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Insert into CVFormulacionMonedas">
				
					<!---
						10. Actualiza CVFormulacionMonedas con SaldosContablesP
					--->
					<!--- CVPcuenta = Ccuenta, para optimizar el join --->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update CVFormulacionMonedas
						   set CVFMmontoBase =
								coalesce(
									(
										select case when m.Ctipo IN ('A','G') then MLmonto else -MLmonto end
										  from SaldosContablesP scp
										  	inner join CContables c
												inner join CtasMayor m
												   on m.Ecodigo = c.Ecodigo
												  and m.Cmayor = c.Cmayor
											   on c.Ccuenta = scp.Ccuenta
										 where scp.Ccuenta	= CVFormulacionMonedas.CVPcuenta
										   and scp.Speriodo	= CVFormulacionMonedas.CPCano
										   and scp.Smes		= CVFormulacionMonedas.CPCmes
										   and scp.Ecodigo	= CVFormulacionMonedas.Ecodigo
										   and scp.Ocodigo	= CVFormulacionMonedas.Ocodigo
									)
								,0)
						  where Ecodigo	= #LvarEcodigo#
							and CVid	= #LvarCVid#
					</cfquery>
				</cftransaction>

				<cfset fnAjustaFormulacion()>
			<cfelse>
<cflog file="FormulacionAplica" text="=======================================================================">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	PASO 1 - N/A Ya existía Período y Version">
<cflog file="FormulacionAplica" text="=======================================================================">
			</cfif>
	
			<cfif LvarVerifArranque.AplicarVersion>
				<cfquery name="rsCPP" datasource="#session.DSN#">
					select CPPid, CPPestado, CPPanoMesDesde, CPPanoMesHasta
					  from CPresupuestoPeriodo
					 where Ecodigo = #LvarEcodigo#
					   and #LvarVerifArranque.MesAct# between CPPanoMesDesde and CPPanoMesHasta
				</cfquery>
				
				<cfset LvarCPPid   = rsCPP.CPPid>
			
				<cfif rsCPP.CPPestado NEQ "0">
					<cf_errorCode	code = "50452"
									msg  = "No existe un Período de Presupuesto Inactivo para el Mes Actual de Contabilidad: @errorDat_1@-@errorDat_2@"
									errorDat_1="#rsParametros.Ano#"
									errorDat_2="#rsParametros.Mes#"
					>
				</cfif>
<cflog file="FormulacionAplica" text="==================================================================================">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	PASO 2 - Inicia Aplicacion de Versión de Presupuesto">
<cflog file="FormulacionAplica" text="==================================================================================">
				<!---
					12. Aplica la Versión de Presupuesto
				--->
				<cfset fnAplicaVersion()>
			<cfelse>
<cflog file="FormulacionAplica" text="========================================================================">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	PASO 2 - N/A Ya estaba aprobada la Version">
<cflog file="FormulacionAplica" text="========================================================================">
			</cfif>
		</cfif>
				
		<cfif LvarVerifArranque.GenerarEjecucion OR LvarVerifArranque.GenerarFaltantes>
			<!---
				13. Realiza la Ejecucion de Arranque de Presupuesto
			--->
<cflog file="FormulacionAplica" text="============================================================================================">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	PASO 3 - Genera la Ejecución a partir de movimientos contables">
<cflog file="FormulacionAplica" text="============================================================================================">
	
			<cfquery name="rsCPP" datasource="#session.DSN#">
				select CPPid, CPPestado, CPPanoMesDesde, CPPanoMesHasta
				  from CPresupuestoPeriodo
				 where Ecodigo = #LvarEcodigo#
				   and #LvarVerifArranque.MesAct# between CPPanoMesDesde and CPPanoMesHasta
			</cfquery>
			
			<cfset LvarCPPid   = rsCPP.CPPid>
		
			<cfif rsCPP.CPPestado NEQ "1">
				<cf_errorCode	code = "50453"
								msg  = "No existe un Período de Presupuesto Abierto para el Mes Actual de Contabilidad: @errorDat_1@-@errorDat_2@"
								errorDat_1="#rsParametros.Ano#"
								errorDat_2="#rsParametros.Mes#"
				>
			</cfif>
			
			<cfset LvarPrmMes = LvarVerifArranque.MesIni>
			<cfif LvarPrmMes LT rsCPP.CPPanoMesDesde>
				<cfset LvarPrmMes = rsCPP.CPPanoMesDesde>
			</cfif>
		
			<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
			<cfset LobjControl.CreaTablaIntPresupuesto(#session.dsn#,false,true)>
		
			<cfset LvarMes = LvarPrmMes>
			<cfloop condition="LvarMes LTE LvarVerifArranque.MesAct">
				<cfset LvarDocumentoOri	 = "MES #LvarMes#">
				
				<cfquery name="rsCPP" datasource="#session.DSN#">
					delete from #request.intPresupuesto#
				</cfquery>
		
				<cfif LvarMes EQ LvarVerifArranque.MesAct and LvarVerifArranque.MesAct EQ dateFormat(now(),"YYYYMM")>
					<cfset LvarFecha = createODBCdate(now())>
				<cfelse>
					<cfset LvarFecha = createDate(int(LvarMes/100),LvarMes mod 100, 1)>
					<cfset LvarFecha = createDate(int(LvarMes/100),LvarMes mod 100, DaysInMonth(LvarFecha))>
				</cfif>
				
				<cfquery datasource="#session.DSN#">
					insert into #request.intPresupuesto#
						(
							ModuloOrigen,
							NumeroDocumento,
							NumeroReferencia,
							FechaDocumento,
							AnoDocumento,
							MesDocumento,
							
							Ccuenta, CFcuenta, CPcuenta,
							Ocodigo,
							TipoMovimiento,
							Mcodigo, 	MontoOrigen, 
							TipoCambio, Monto,
							
							CPPid, CPCano, CPCmes
						)
					select 	'#LvarModuloOri#', '#LvarDocumentoOri#', '#LvarReferenciaOri#',
							<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">,
							#DateFormat(LvarFecha,"YYYY")#, #DateFormat(LvarFecha,"MM")#,
							f.Ccuenta, f.CFcuenta, f.CPcuenta,
							s.Ocodigo,
							'E',
							e.Mcodigo,		
								CASE 
									when m.Ctipo IN ('A','G') 
									<cfif NOT LvarVerifArranque.GenerarFaltantes>
										then sum(case when s.Dmovimiento = 'D' then s.Dlocal else -s.Dlocal end)
										else sum(case when s.Dmovimiento = 'C' then s.Dlocal else -s.Dlocal end)
									<cfelse>
										then sum(s.DOdebitos-s.COcreditos)
										else sum(s.COcreditos-s.DOdebitos)
									</cfif>
								END as Doriginal, 
							1.00 as Dtipocambio, 	
								CASE 
									when m.Ctipo IN ('A','G') 
									<cfif NOT LvarVerifArranque.GenerarFaltantes>
										then sum(case when s.Dmovimiento = 'D' then s.Dlocal else -s.Dlocal end)
										else sum(case when s.Dmovimiento = 'C' then s.Dlocal else -s.Dlocal end)
									<cfelse>
										then sum(s.DOdebitos-s.COcreditos)
										else sum(s.COcreditos-s.DOdebitos)
									</cfif>
								END as Dlocal, 
							#LvarCPPid#, #DateFormat(LvarFecha,"YYYY")#, #DateFormat(LvarFecha,"MM")#
					<cfif NOT LvarVerifArranque.GenerarFaltantes>
						  from 	HEContables enc
							inner join HDContables s
								inner join Empresas e
									 on e.Ecodigo = s.Ecodigo
								inner join CFinanciera f
									inner join CtasMayor m
										 on m.Ecodigo	= f.Ecodigo
										and m.Cmayor	= f.Cmayor
									 on f.Ccuenta	= s.Ccuenta
									and f.CPcuenta is not null
								on s.IDcontable = enc.IDcontable
						 where enc.Ecodigo	= #LvarEcodigo#
						   and enc.Eperiodo	= #DateFormat(LvarFecha,"YYYY")#
						   and enc.Emes		= #DateFormat(LvarFecha,"MM")#
						   and enc.NAP is null
						group by f.Ccuenta, f.CFcuenta, f.CPcuenta, s.Ocodigo, e.Mcodigo, m.Ctipo
						having sum(case when s.Dmovimiento = 'D' then s.Dlocal else -s.Dlocal end) <> 0
					<cfelse>
						  from 	SaldosContables s
							inner join Empresas e
								 on e.Ecodigo = s.Ecodigo
							inner join CFinanciera f
								inner join CtasMayor m
									 on m.Ecodigo	= f.Ecodigo
									and m.Cmayor	= f.Cmayor
								 on f.Ccuenta	= s.Ccuenta
								and f.CPcuenta is not null
						 where s.Speriodo	= #DateFormat(LvarFecha,"YYYY")#
						   and s.Smes		= #DateFormat(LvarFecha,"MM")#
						   and s.Ecodigo	= #LvarEcodigo#
						group by f.Ccuenta, f.CFcuenta, f.CPcuenta, s.Ocodigo, e.Mcodigo, m.Ctipo
						having sum(s.DOdebitos-s.COcreditos) <> 0
					</cfif>
				</cfquery>
				<!--- 
					s.Ccuenta, s.Speriodo, s.Smes, s.Ecodigo, s.Ocodigo, s.Mcodigo
				--->
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select *
					  from #request.intPresupuesto#
				</cfquery>
				
				<cfif rsSQL.recordCount GT 0>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Inicia NAP de ejecucion Mes #DateFormat(LvarFecha,"YYYY-MM")#">
					<cftransaction>
						<cfset LvarNAP = LobjControl.ControlPresupuestario (LvarModuloOri, LvarDocumentoOri, LvarReferenciaOri, 
																LvarFecha, DateFormat(LvarFecha,"YYYY"), DateFormat(LvarFecha,"MM"), 
																session.DSN, LvarEcodigo)>
				
						<cfif LvarNAP LT 0>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	NRP =  #-LvarNAP# de Ejecucion Mes #DateFormat(LvarFecha,"YYYY-MM")#">
						<cfelse>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	NAP =  #LvarNAP# de Ejecucion Mes #DateFormat(LvarFecha,"YYYY-MM")#">
			
							<cfquery datasource="#session.dsn#">
								update HEContables 
								   set NAP = #LvarNAP#
								 where Ecodigo	= #LvarEcodigo#
								   and Eperiodo	= #DateFormat(LvarFecha,"YYYY")#
								   and Emes		= #DateFormat(LvarFecha,"MM")#
								   and coalesce(NAP,0) = 0
							</cfquery>
						</cfif>
					</cftransaction>
				<cfelse>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	No hay movimientos Mes #DateFormat(LvarFecha,"YYYY-MM")#">
					<cfquery datasource="#session.dsn#">
						update HEContables 
						   set NAP = 0
						 where Ecodigo	= #LvarEcodigo#
						   and Eperiodo	= #DateFormat(LvarFecha,"YYYY")#
						   and Emes		= #DateFormat(LvarFecha,"MM")#
						   and coalesce(NAP,0) = 0
					</cfquery>
				</cfif>
						
				<cfif (LvarMes mod 100) EQ 12>
					<cfset LvarMes = (int(LvarMes/100)+1)*100>
				</cfif>
				<cfset LvarMes = LvarMes + 1>
			</cfloop>
		</cfif>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	FINAL Ecodigo=#rsEcodigos.Ecodigo#">
<cflog file="FormulacionAplica" text="================================================================">
	</cfloop>
	<cfset application.CParranque = false>
<cflog file="FormulacionAplica" text="================================================================">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	FINAL ARRANQUE">
<cflog file="FormulacionAplica" text="================================================================">
<cfcatch type="any">
<cfoutput>
	<cfif isdefined("cfcatch.TagContext") AND isarray(cfcatch.TagContext)>
		<cfset LvarLine = cfcatch.TagContext[1]>
		<cfif isdefined("LvarLine.LINE")>
			<cfset LvarLine = "arranque_sql.cfm:#cfcatch.TagContext[1].LINE#">
		</cfif>
	<cfelseif isdefined("cfcatch.StackTrace")>
		<cfset LvarLine = find("arranque_sql.cfm", cfcatch.StackTrace)>
		<cfset LvarLine = mid(cfcatch.StackTrace,LvarLine,find(")", cfcatch.StackTrace,LvarLine)-LvarLine)>
	<cfelseif isdefined("cfcatch.RootCause.TagContext") and isarray(cfcatch.RootCause.TagContext) and arraylen(cfcatch.RootCause.TagContext) GTE 1>
		<cfset LvarLine = cfcatch.RootCause.TagContext[1]>
		<cfif isdefined("LvarLine.LINE")>
			<cfset LvarLine = "arranque_sql.cfm:#cfcatch.RootCause.TagContext[1].LINE#">
		</cfif>
	<cfelseif isdefined("cfcatch.RootCause.StackTrace")>
		<cfset LvarLine = find("arranque_sql.cfm", cfcatch.RootCause.StackTrace)>
		<cfset LvarLine = mid(cfcatch.RootCause.StackTrace,LvarLine,find(")", cfcatch.RootCause.StackTrace,LvarLine)-LvarLine)>
	<cfelse>
		<cfset LvarLine = "arranque_sql.cfm:??">
	</cfif>
</cfoutput>
		
<cflog file="FormulacionAplica" text="=========================================================================">
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	ERROR: #cfcatch.Message# - #cfcatch.Detail# (#LvarLine#)">
<cflog file="FormulacionAplica" text="=========================================================================">
	<cfset application.CParranque = false>
	<cfrethrow>
</cfcatch>
</cftry>

<cflocation url="arranque.cfm">

<cffunction name="fnAjustaFormulacion" output="false" returntype="void">

<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	INICIA AJUSTE DE FORMULACION ">
	<cfquery datasource="#session.dsn#">
		update CVFormulacionMonedas
		   set CVFMmontoAplicar = CVFMmontoBase
		 where Ecodigo 	= #LvarEcodigo#
		   and CVid 	= #LvarCVid#
	</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Ajusta CVFormulacionMonedas.CVFMmontoAplicar">

	<cfquery name="update_cvftotales" datasource="#session.dsn#">
		update CVFormulacionTotales
		   set CVFTmontoSolicitado = 
						(
							select b.CVFMmontoBase 
							  from CVFormulacionMonedas b
							 where b.Ecodigo 	= CVFormulacionTotales.Ecodigo
							   and b.CVid 		= CVFormulacionTotales.CVid
							   and b.CVPcuenta 	= CVFormulacionTotales.CVPcuenta
							   and b.CPCano 	= CVFormulacionTotales.CPCano
							   and b.CPCmes 	= CVFormulacionTotales.CPCmes
							   and b.Ocodigo 	= CVFormulacionTotales.Ocodigo
						)
		 where Ecodigo 	= #LvarEcodigo#
		   and CVid 	= #LvarCVid#
	</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Ajusta CVFormulacionTotales.CVFTmontoSolicitado">

	<cfquery name="update_cvftotales" datasource="#session.dsn#">
		update CVFormulacionTotales
		   set CVFTmontoAplicar = CVFTmontoSolicitado
		 where Ecodigo 	= #LvarEcodigo#
		   and CVid 	= #LvarCVid#
	</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	Ajusta CVFormulacionTotales.CVFTmontoAplicar">
</cffunction>

<cffunction name="fnAplicaVersion" output="false" returntype="void">

	<!--- Obtiene el numero de documento de aprobacion de version --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CVdocumentoAprobo
		  from CVersion v
		 where Ecodigo 	= #LvarEcodigo#
		   and CVid 	= #LvarCVid#
	</cfquery>

	<cfif rsSQL.CVdocumentoAprobo NEQ "">
		<cfset LvarDocumentoAprobo = rsSQL.CVdocumentoAprobo>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select max(CVdocumentoAprobo) as ultimo
			  from CVersion v
			 where Ecodigo = #LvarEcodigo#
			   and CVtipo  = '1'
		</cfquery>
		
		<cfif rsSQL.ultimo EQ "">
			<cfset LvarDocumentoAprobo = 1>
		<cfelse>
			<cfset LvarDocumentoAprobo = rsSQL.ultimo + 1>
		</cfif>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from CPresupuestoControl
		 where Ecodigo	= #LvarEcodigo#
		   and CPPid	= #LvarCPPid#
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into CPresupuestoControl
				(Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, CPCanoMes,
				 CPCpresupuestado)
			select #LvarEcodigo#, #LvarCPPid#, fm.CPCano, fm.CPCmes, c.CPcuenta, fm.Ocodigo, fm.CPCano*100+fm.CPCmes, 
					fm.CVFMmontoAplicar
			  from CVFormulacionMonedas fm
				inner join CVPresupuesto c
				   on c.Ecodigo	 	= fm.Ecodigo
				  and c.CVid	    = fm.CVid
				  and c.CVPcuenta	= fm.CVPcuenta
			 where fm.Ecodigo 	 = #LvarEcodigo#
			   and fm.CVid 	     = #LvarCVid#
		</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	insert into CPresupuestoControl">
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from CPControlMoneda
		 where Ecodigo	= #LvarEcodigo#
		   and CPPid	= #LvarCPPid#
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into CPControlMoneda
				(Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, 
				 Mcodigo, CPCMtipoCambioAplicado, CPCMpresupuestado)
			select 	#LvarEcodigo#, #LvarCPPid#, fm.CPCano, fm.CPCmes, c.CPcuenta, fm.Ocodigo,
					fm.Mcodigo, fm.CVFMtipoCambio, fm.CVFMmontoAplicar
			  from CVFormulacionMonedas fm
				inner join CVPresupuesto c
				   on c.Ecodigo	 	= fm.Ecodigo
				  and c.CVid	    = fm.CVid
				  and c.CVPcuenta	= fm.CVPcuenta
			 where fm.Ecodigo 	 = #LvarEcodigo#
			   and fm.CVid 	     = #LvarCVid#
		</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	insert into CPControlMoneda">
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select max(CPNAPnum) as NAP
		  from CPNAP
		 where Ecodigo = #LvarEcodigo#
	</cfquery>
	<cfif rsSQL.NAP EQ "">
		<cfset LvarNAP = 1>
	<cfelse>
		<cfset LvarNAP = rsSQL.NAP + 1>
	</cfif>

	<cftransaction>	
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into CPNAP
					(Ecodigo, CPNAPnum, 
					 CPPid, CPCano, CPCmes, CPNAPfecha, 
					 CPNAPmoduloOri, CPNAPdocumentoOri, CPNAPreferenciaOri, CPNAPfechaOri,
					 UsucodigoOri, UsucodigoAutoriza, CPOid, CPNAPnumReversado
					 )
			values 	(#LvarEcodigo#, #LvarNAP#, 
					 #LvarCPPid#, #dateformat(LvarFechaIni,"YYYY")#, #dateformat(LvarFechaIni,"MM")#,
					 <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LvarFechaIni#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="PRFO">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarDocumentoAprobo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="APROBACION">,
					 <cfqueryparam cfsqltype="cf_sql_date" 		value="#LvarFechaIni#">,
					 #session.Usucodigo#, 
					 #session.Usucodigo#, null, 
					 null
					)
		</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	insert into CPNAP">

<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	OJO: FALTA insert into CPNAPdetalle">

		<cfquery name="rsSQL" datasource="#session.dsn#">
			update CVersion
			   set CVaprobada = 1
				 , UsucodigoAprobo = #session.Usucodigo#
				 , CVfechaAprobo = 	<cfqueryparam cfsqltype="cf_sql_date"		value="#now()#">
				 , CVdocumentoAprobo = #LvarDocumentoAprobo#
				 , NAP = #LvarNAP#
			 where Ecodigo 	= #LvarEcodigo#
			   and CVid 	= #LvarCVid#
		</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	update CVersion">
	
		<cfquery name="rsSQL" datasource="#session.dsn#">
			update CPresupuestoPeriodo
			   set CPPestado = 1
			 where CPPid = #LvarCPPid#
		</cfquery>
<cflog file="FormulacionAplica" text="ARRANQUE SaldosContablesP:	update CPresupuestoPeriodo">

	</cftransaction>
</cffunction>


