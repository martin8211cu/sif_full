<!---
	Funciones de Cierre Mensual, Cierre Fiscal y Cierre Corporativo de Contabilidad
	Contiene las siguientes funciones:
		3. Cierre_Mes
--->
<cfcomponent displayname="CG_CierreMes" hint="Funciones de Cierre Mensual, Cierre Fiscal y Cierre Corporativo de Contabilidad">
	<cffunction output="true" name="Cierre_Mes" access="public" hint="Retorna Nulo">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="yes">

		<cfargument name="debug" type="boolean" default="false">

		<cfsetting requesttimeout="7200">

		<!---1--->
		<cfset Pcodigo_per = 30>
		<cfset Pcodigo_mes = 40>
		<cfset Pcodigo_mes_fiscal = 45>
		<cfset Pcodigo_mes_corporativo = 46>
		<cfset Pcodigo_aux_per = 50>
		<cfset Pcodigo_aux_mes = 60>
		<cfset Pcodigo_utilidad = 300>
		<cfset Pcodigo_per_ant = 301>
		<cfset Pcodigo_resumen_ingygas = 302>
		<cfset Pcodigo_ahorro = 303>
		<cfset Pcodigo_desahorro = 304>
		<cfset Pcodigo_resul_utilidad = 305>
		<cfset Pcodigo_resul_perdida = 306>
		<cfset sistema = 'CG'>
		<cfset sistema_aux = 'GN'>

		<!---2--->
		<!--- Obtener los valores de Conta --->
		<cfquery name="rsMes" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as mes
			from Parametros
			where Pcodigo = #Pcodigo_mes#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as periodo
			from Parametros
			where Pcodigo = #Pcodigo_per#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsMesFiscal" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as mes
			from Parametros
			where Pcodigo = #Pcodigo_mes_fiscal#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsMesCorporativo" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as mes
			from Parametros
			where Pcodigo = #Pcodigo_mes_corporativo#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsMesCorporativo.mes EQ "" OR rsMesCorporativo.mes LT "0">
			<cfset rsMesCorporativo = structNew()>
			<cfset rsMesCorporativo.mes = rsMesFiscal.Mes>
			<cfset sbInicializaPeriodoCorporativo(rsMesFiscal.Mes, Arguments.Ecodigo, Arguments.Conexion)>
		</cfif>
		
		<cfquery name="rsCuentaUtilidad" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_utilidad#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsCuentaPerAnt" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_per_ant#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
			<cfquery name="rsCuentaResumenIngyGasto" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_resumen_ingygas#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsCuentaAhorro" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_ahorro#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsCuentaDesahorro" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_desahorro#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsCuentaResulUtilidad" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_resul_utilidad#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsCuentaResulPerdida" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_resul_perdida#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		
		<cfset ResumenIngrYGastos = 'N'>
		<cfif rsCuentaResumenIngyGasto.recordcount NEQ 0 and len(rsCuentaResumenIngyGasto.cuenta) NEQ 0>
			<cfset ResumenIngrYGastos = 'Y'>
		</cfif>
		
		<cfif rsCuentaUtilidad.recordcount EQ 0 or len(rsCuentaUtilidad.cuenta) EQ 0>
			<cfthrow message="Error. No esta definida la Cuenta de Utilidad Acumulada. Proceso Cancelado!!">
		</cfif>
			
		<!--- Guardar AnoMes Actual de Cierre y AnoMes Nuevo --->
		<cfset LvarMesActual = rsMes.mes>
		<cfset LvarPerActual = rsPeriodo.periodo>
		
		<cfset LvarMesNuevo = (LvarMesActual MOD 12) + 1>
		<cfif LvarMesNuevo eq 1>
			<cfset LvarPerNuevo = LvarPerActual + 1>
		<cfelse>
			<cfset LvarPerNuevo = LvarPerActual>
		</cfif>

		<!---3--->
		<!--- Obtener AnoMes de Auxiliares --->
		<cfquery name="rsMes_Aux" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as mes_aux
			from Parametros
			where Pcodigo = #Pcodigo_aux_mes#
			and Mcodigo = '#sistema_aux#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsPeriodo_Aux" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as periodo_aux
			from Parametros
			where Pcodigo = #Pcodigo_aux_per#
			and Mcodigo = '#sistema_aux#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<!---4--->
		<!--- Validar si ya se realizo el cierre de Auxiliares --->
		<cfif rsPeriodo_Aux.periodo_aux lt LvarPerActual or (rsPeriodo_Aux.periodo_aux eq LvarPerActual and rsMes_Aux.mes_aux lte LvarMesActual)>
			<cf_errorCode	code = "51120" msg = "Debe realizar el cierre de auxiliares, antes de realizar el cierre contable.">
		</cfif>
		<!---5.1--->
		<!--- validar si hay documentos sin Postear --->
		<cfquery name="rsNum_Docs" datasource="#Arguments.Conexion#">
			select count(1) as num_docs
			  from EContables
			 where Ecodigo 	= #Arguments.Ecodigo#
			   and Eperiodo = #LvarPerActual#
               and Emes 	= #LvarMesActual#
			   and ECtipo  	<> 1
		</cfquery>
		<cfif rsNum_Docs.num_docs gt 0>
			<cf_errorCode	code = "51121" msg = "Aún existen documentos sin postear, para esta empresa, mes y periodo.">
		</cfif>

		<!---5.2--->
		<!--- validar si hay documentos importados sin Postear --->
		<cfquery name="rsNum_Docs" datasource="#Arguments.Conexion#">
			select count(1) as num_docs
			from EContablesImportacion
			where Ecodigo 	= #Arguments.Ecodigo#
			  and Eperiodo 	= #LvarPerActual#
			  and Emes 		= #LvarMesActual#
		</cfquery>
		<cfif rsNum_Docs.num_docs gt 0>
			<cf_errorCode	code = "51122" msg = "Aún existen documentos sin postear en el Importador, para esta empresa, mes y periodo.">
		</cfif>

		<!--- 5.3 Borrar Asientos de Cierre que aun no se hayan aplicado, por si el proceso quedo a la mitad --->
		<cfquery name="rsNum_Docs" datasource="#Arguments.Conexion#">
			select IDcontable
			  from EContables
			 where Ecodigo	= #Arguments.Ecodigo#
			   and Eperiodo	= #LvarPerActual#
               and Emes		= #LvarMesActual#
			   and ECtipo   = 1
		</cfquery>
		<cfloop query="rsNum_Docs">
        	<cfset _IDcontable = rsNum_Docs.IDcontable>
        	<cfquery datasource="#Arguments.Conexion#">
            	delete from DContables
                where IDcontable = #_IDcontable#
            </cfquery>
        	<cfquery datasource="#Arguments.Conexion#">
            	delete from EContables
                where IDcontable = #_IDcontable#
            </cfquery>
        </cfloop>

		<!--- Concepto Contable --->
		<cfset LvarContaPresupuestal = false>
		<cfif LvarMesActual EQ rsMesFiscal.mes>
			<cfquery name="rsConceptoContableE" datasource="#Arguments.Conexion#">
				select min(Cconcepto) as Cconcepto
				from ConceptoContable
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Oorigen = 'CGCF'
			</cfquery>
			
			<cfif rsConceptoContableE.recordcount EQ 0 or len(trim(rsConceptoContableE.Cconcepto)) EQ 0>
				<cf_errorCode	code = "51123" msg = "No se ha definido el Concepto para el Origen Cierre Anual Fiscal (CGCF). No se puede realizar el proceso de cierre Fiscal">
			</cfif>

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 1140
			</cfquery>
			<cfset LvarContaPresupuestal = rsSQL.Pvalor EQ "S">
			<cfif LvarContaPresupuestal>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select count(1) as cantidad
					  from Origenes
					 where Oorigen = 'CGCP'
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						insert into Origenes (Oorigen, Odescripcion, Otipo, BMUsucodigo)
						values ('CGCP', 'Cierre Contabilidad Presupuestaria', 'S', 1)
					</cfquery>
				</cfif>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select min(Cconcepto) as Cconcepto
					from ConceptoContable
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Oorigen = 'CGCP'
				</cfquery>
				<cfif rsSQL.Cconcepto EQ "">
					<cfquery datasource="#Arguments.Conexion#">
						insert into ConceptoContable (Ecodigo, Oorigen, Cconcepto, Cdescripcion)
						values (#Arguments.Ecodigo#, 'CGCP', #rsConceptoContableE.Cconcepto#, 'Cierre Contabilidad Presupuestaria')
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfif LvarMesActual EQ rsMesCorporativo.mes>
			<cfquery name="rsConceptoContableE" datasource="#Arguments.Conexion#">
				select min(Cconcepto) as Cconcepto
				from ConceptoContable
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Oorigen = 'CGCC'
			</cfquery>
			
			<cfif rsConceptoContableE.Cconcepto EQ "">
				<cfthrow message="No se ha definido el Concepto para el Origen Cierre Anual Corporativo (CGCC). No se puede realizar el proceso de cierre de Periodo Corporativo">
			</cfif>
		</cfif>

		<!--- Llenado de la Tabla de Periodos Procesados *** MDM 02/03/2006*** --->
		<!---  a) Insertar el periodo Actual si no existe --->
		<cfquery name="rsPerProcexists" datasource="#Arguments.Conexion#">
			select 1 
			from CGPeriodosProcesados 
			where Ecodigo 	= #Arguments.Ecodigo# 
			  and Speriodo 	= #LvarPerActual#
			  and Smes 		= #LvarMesActual#
		</cfquery>
		<cfif rsPerProcexists.Recordcount eq 0>
			<cfquery name="rsinsPerProc" datasource="#Arguments.Conexion#">
				insert into CGPeriodosProcesados (Ecodigo, Speriodo, Smes, BMUsucodigo, BMFecha)
				values (
					#Arguments.Ecodigo#, 
					#LvarPerActual#, 
					#LvarMesActual#, 
					#session.Usucodigo#, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">)
			</cfquery>
		</cfif>
		
		<!---  b) Insertar el nuevo periodo si no existe --->
		<cfquery name="rsPerProcexists" datasource="#Arguments.Conexion#">
			select 1 
			from CGPeriodosProcesados 
			where Ecodigo	= #Arguments.Ecodigo# 
			  and Speriodo	= #LvarPerNuevo#
			  and Smes		= #LvarMesNuevo#
		</cfquery>

		<cfif rsPerProcexists.Recordcount eq 0>
			<cfquery name="rsinsPerProc" datasource="#Arguments.Conexion#">
				insert into CGPeriodosProcesados (Ecodigo, Speriodo, Smes, BMUsucodigo, BMFecha)
				values (
					#Arguments.Ecodigo#, 
					#LvarPerNuevo#, 
					#LvarMesNuevo#, 
					#session.Usucodigo#, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">)
			</cfquery>
		</cfif>

		<cfquery name="rsVerificaExistencia" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad
			from SaldosContables
			where Ecodigo 	= #Arguments.Ecodigo#
			  and Speriodo 	= #LvarPerNuevo#
			  and Smes     	= #LvarMesNuevo#
		</cfquery>

		<cfif rsVerificaExistencia.Cantidad GT 0>
			<cfif rsVerificaExistencia.Cantidad LT 20000>
				<cfquery datasource="#Arguments.Conexion#">
					delete from SaldosContables
					where Ecodigo 	= #Arguments.Ecodigo#
					  and Speriodo 	= #LvarPerNuevo#
					  and Smes     	= #LvarMesNuevo#
				</cfquery>
			<cfelse>
				<cfquery name="rsCtasMayor" datasource="#Arguments.Conexion#">
					select Cmayor 
					  from CtasMayor 
					 where Ecodigo  = #Arguments.Ecodigo#
				</cfquery>
	
				<cfloop query="rsCtasMayor">
					<cfquery datasource="#Arguments.Conexion#">
						delete from SaldosContables
						 where Ecodigo 	= #Arguments.Ecodigo#
						   and Speriodo = #LvarPerNuevo#
						   and Smes     = #LvarMesNuevo#
						   and (
								select count(1)
								  from CContables c
								 where c.Ccuenta = SaldosContables.Ccuenta
								   and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
								   and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char"    value="#rsCtasMayor.Cmayor#">
								) > 0
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>

		<cfset sbCrearSaldosContablesNuevos(Arguments.Ecodigo, LvarPerActual, LvarMesActual, LvarPerNuevo, LvarMesNuevo,Arguments.Conexion,false)>

		<cfif LvarMesActual EQ rsMesFiscal.mes>			
			<cfset sbCrearSaldosContablesCierre	(Arguments.Ecodigo, 1, LvarPerActual, LvarMesActual, Arguments.Conexion)>
			<cfset sbGeneraAsientoCierreAnual	(Arguments.Ecodigo, 1, LvarPerActual, LvarMesActual, Arguments.Conexion, LvarMesNuevo, LvarPerNuevo)>
			<cfif LvarContaPresupuestal>
				<cfinvoke component="PRES_Presupuesto" method="CreaTablaIntPresupuesto" conIdentity="yes"></cfinvoke>
				<cftransaction>
					<cfinvoke	component		= "PRES_ContaPresupuestaria" 
								method			= "AsientoCierre"
								returnvariable	= "IDcontable" 
	
								Ecodigo			= "#Arguments.Ecodigo#"
								Periodo			= "#LvarPerActual#"
								Mes				= "#LvarMesActual#"
								Conexion		= "#Arguments.Conexion#"
					/>

					<cfinvoke	component		= "PRES_ContaPresupuestaria" 
								method			= "NAPinicio"
								returnvariable	= "LvarNAP" 
	
								Ecodigo			= "#Arguments.Ecodigo#"
								Periodo			= "#LvarPerNuevo#"
								Mes				= "#LvarMesNuevo#"
								Conexion		= "#Arguments.Conexion#"
					/>

					<cfif LvarNAP LT 0>
						<cfthrow message="Se generó un Rechazo Presupuestario NRP = #-LvarNAP#">
					</cfif>
				</cftransaction>
				<!---
					<cfinvoke component="CG_AplicaAsiento"  method="CG_AplicaAsiento">
						<cfinvokeargument name="IDcontable" value="#IDcontable#">
						<cfinvokeargument name="CtlTransaccion" value="true">
					</cfinvoke>
				--->
			</cfif>
		<cfelseif LvarMesActual EQ rsMesCorporativo.mes and rsMesFiscal.mes NEQ rsMesCorporativo.mes>
			<cfset sbCrearSaldosContablesCierre	(Arguments.Ecodigo, 11, LvarPerActual, LvarMesActual, Arguments.Conexion)>
			<cfset sbGeneraAsientoCierreAnual	(Arguments.Ecodigo, 11, LvarPerActual, LvarMesActual, Arguments.Conexion)>
		</cfif>
 
		<!---7--->
		<cftransaction>
			<!---Actualizar el Periodo y el Mes --->
			<cftry>
				<cfquery name="rsUpdParam1" datasource="#Arguments.Conexion#">
					update Parametros 
					   set Pvalor  = '#NumberFormat(LvarMesNuevo,'0')#'
					 where Ecodigo = #Arguments.Ecodigo#
					   and Pcodigo = #Pcodigo_mes#
					   and Mcodigo = '#sistema#'
				</cfquery>

				<cfquery name="rsUpdParam2" datasource="#Arguments.Conexion#">
					update Parametros 
					   set Pvalor = '#NumberFormat(LvarPerNuevo,'0')#'
					 where Ecodigo = #Arguments.Ecodigo#
					   and Pcodigo = #Pcodigo_per#
					   and Mcodigo = '#sistema#'
				</cfquery>

				<!--- Inserta en la bitácora --->
				<cfquery name="rsBitacora" datasource="#Arguments.Conexion#">
					insert into BitacoraCierres (Ecodigo, BCperiodo, BCmes, BCtipocierre, Mcodigo, BCfcierre, Usucodigo, BMUsucodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerActual#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesActual#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">, <!--- Cierre Contable --->
						<cfqueryparam cfsqltype="cf_sql_char" value="#sistema#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,						
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
				</cfquery>
				
				<cfcatch type="any">
					<cf_errorCode	code = "51126" msg = "Se presentó un error al intentar actualizar el período Contable. Proceso Cancelado!">
				</cfcatch>
			</cftry>
			<cfif Arguments.debug>
				<cftransaction action="rollback"/>
			</cfif>

		</cftransaction>

			<cfset LvarRecursivos = fnGeneraAsientosRecursivos(	Arguments.Ecodigo,
															LvarPerActual,LvarMesActual,
															LvarPerNuevo,LvarMesNuevo,
															Arguments.Conexion)>
	</cffunction>

	<cffunction name="sbCrearSaldosContablesNuevos" access="private" output="false">
		<cfargument name="Ecodigo"		type="numeric" required="yes">
		<cfargument name="AnoAnterior"	type="numeric" required="yes">
		<cfargument name="MesAnterior"	type="numeric" required="yes">
		<cfargument name="AnoNuevo"		type="numeric" required="yes">
		<cfargument name="MesNuevo"		type="numeric" required="yes">
		<cfargument name="Conexion"		type="string" required="yes">
		<cfargument name="hayViejos"	type="boolean" default="false">
		<!---
			Creación SaldosContables:
				Copiar SaldoFinal del PeriodoAnterior al SaldoInicial del PeríodoNuevo
				En los cierres anuales el Asiento de Cierre se encarga de limpiar SaldosContables de Resultado en el nuevo Período (AplicaAsiento)
				En los cierres anuales el se generan SaldosContablesCierre
				Para no generar overhead:
					En SaldosContables Mensuales no se arrastra al nuevo periodo cuando el nuevo SaldoInicial es cero
		--->
		<cfquery name="rsVerificaExistencia" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad
			  from SaldosContables s
			 where s.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and s.Speriodo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoAnterior#">
			   and s.Smes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesAnterior#">
		</cfquery>

		<cfif rsVerificaExistencia.Cantidad LT 20000>
			<cftry>
				<cfquery datasource="#Arguments.Conexion#">
					insert into SaldosContables (
						Ecodigo,
						Ocodigo, Ccuenta, 
						Mcodigo, Speriodo, Smes, 
						SLinicial, DLdebitos, CLcreditos, 
						SOinicial, DOdebitos, COcreditos,
						SLinicialGE, 
						SOinicialGE
					)
					select 
						s.Ecodigo,
						s.Ocodigo, s.Ccuenta, 
						s.Mcodigo, #Arguments.AnoNuevo#, #Arguments.MesNuevo#,
						s.SLinicial		+ s.DLdebitos - s.CLcreditos, 0, 0,
						s.SOinicial		+ s.DOdebitos - s.COcreditos, 0, 0,
						s.SLinicialGE	+ s.DLdebitos - s.CLcreditos,
						s.SOinicialGE	+ s.DOdebitos - s.COcreditos
					  from SaldosContables s
					 where s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					   and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoAnterior#">
					   and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesAnterior#">
					   and (
							s.SLinicial		+ s.DLdebitos - s.CLcreditos <> 0.00 
						 or s.SOinicial		+ s.DOdebitos - s.COcreditos <> 0.00
						 or s.SLinicialGE	+ s.DLdebitos - s.CLcreditos <> 0.00 
						 or s.SOinicialGE	+ s.DOdebitos - s.COcreditos <> 0.00
						  )
					<cfif Arguments.hayViejos>
					   and (
					  		select count(1)
							  from SaldosContables
							 where Ccuenta	= s.Ccuenta
							   and Speriodo	= #Arguments.AnoNuevo#
							   and Smes		= #Arguments.MesNuevo#
							   and Ecodigo	= s.Ecodigo
							   and Ocodigo	= s.Ocodigo
							   and Mcodigo	= s.Mcodigo
							) = 0
					</cfif>
				</cfquery>

				<cfcatch type="any">
<cfrethrow>
					<cfthrow message="Error en actualizar datos de Saldos Contables, al insertar los registros del siguiente mes: #cfcatch.Message# #cfcatch.Detail#">
					<cf_errorCode	code = "51124"
									msg  = "Error en actualizar datos de Saldos Contables, al insertar los registros del siguiente mes: @errorDat_1@ @errorDat_2@"
									errorDat_1="#cfcatch.Message#"
									errorDat_2="#cfcatch.Detail#"
					>
				</cfcatch>
			</cftry>
		<cfelse>
			<cfquery name="rsCtasMayor" datasource="#Arguments.Conexion#">
				select Cmayor 
				from CtasMayor 
				where Ecodigo  = #Arguments.Ecodigo#
			</cfquery>
	
			<cfloop query="rsCtasMayor">
				<cftry>
					<cfquery datasource="#Arguments.Conexion#">
						insert into SaldosContables (
							Ecodigo, 
							Ocodigo, Ccuenta, 
							Mcodigo, Speriodo, Smes, 
							SLinicial, DLdebitos, CLcreditos, 
							SOinicial, DOdebitos, COcreditos,
							SLinicialGE, 
							SOinicialGE
						)
						select s.Ecodigo,
							s.Ocodigo, s.Ccuenta, 
							s.Mcodigo, #Arguments.AnoNuevo#, #Arguments.MesNuevo#,
							s.SLinicial		+ s.DLdebitos - s.CLcreditos, 0, 0,
							s.SOinicial		+ s.DOdebitos - s.COcreditos, 0, 0,
							s.SLinicialGE	+ s.DLdebitos - s.CLcreditos,
							s.SOinicialGE	+ s.DOdebitos - s.COcreditos
						from CContables c
								inner join SaldosContables s
										 on s.Ccuenta = c.Ccuenta
										and s.Speriodo = #Arguments.AnoAnterior#
										and s.Smes     = #Arguments.MesAnterior#
						where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char"    value="#rsCtasMayor.Cmayor#">
						  and (
						  		s.SLinicial		+ s.DLdebitos - s.CLcreditos <> 0.00 
							 or s.SOinicial		+ s.DOdebitos - s.COcreditos <> 0.00
							 or s.SLinicialGE	+ s.DLdebitos - s.CLcreditos <> 0.00 
							 or s.SOinicialGE	+ s.DOdebitos - s.COcreditos <> 0.00
							  )
						<cfif Arguments.hayViejos>
						   and (
								select count(1)
								  from SaldosContables
								 where Ccuenta	= s.Ccuenta
								   and Speriodo	= #Arguments.AnoNuevo#
								   and Smes		= #Arguments.MesNuevo#
								   and Ecodigo	= s.Ecodigo
								   and Ocodigo	= s.Ocodigo
								   and Mcodigo	= s.Mcodigo
								) = 0
						</cfif>
					</cfquery>
	
					<cfcatch type="any">
						<cfthrow message="Error en actualizar datos de Saldos Contables, al actualizar la cuenta #rsCtasMayor.Cmayor#. Verifique el mensaje siguiente: #cfcatch.Message# #cfcatch.Detail#">
					</cfcatch>
				</cftry>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="sbCrearSaldosContablesCierre" access="private" output="false">
		<cfargument name="Ecodigo"		type="numeric" required="yes">
		<cfargument name="Tipo"			type="numeric" required="yes">
		<cfargument name="AnoCierre"	type="numeric" required="yes">
		<cfargument name="MesCierre"	type="numeric" required="yes">
		<cfargument name="Conexion"		type="string" required="yes">
		<!---
			Creación SaldosContablesCierre:
				En los cierres anuales se generan SaldosContablesCierre
				Copiando SaldoFinal del Mes de Cierre al SaldoInicial del mismo Mes en SaldosContablesCierre
				de todas las cuentas de Ingresos y Gastos y Utilidad
				Para no generar overhead:
					En SaldosContablesCierre no se arrastra al Cierre cuando el SaldoInicial de Cierre es cero
					Pero siempre arrastra la cuenta de utilidad
		--->
		<cfquery datasource="#Arguments.Conexion#">
			delete from SaldosContablesCierre
			 where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and Speriodo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoCierre#">
			   and Smes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#">
			   and ECtipo	= #Arguments.Tipo#
		</cfquery>
		
		<cfquery name="rsVerificaExistencia" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad
			  from SaldosContablesCierre s
				inner join CContables c 
					inner join CtasMayor m 
						 on m.Ecodigo = c.Ecodigo 
						and m.Cmayor  = c.Cmayor 
						and m.Ctipo   in ('I', 'G') 
					on c.Ccuenta = s.Ccuenta
			 where s.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and s.Speriodo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoCierre#">
			   and s.Smes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#">
			   and s.ECtipo		= #Arguments.Tipo#
		</cfquery>

		<cfif rsVerificaExistencia.Cantidad LT 20000>
			<cftry>
				<cfquery datasource="#Arguments.Conexion#">
					insert into SaldosContablesCierre (
						Ecodigo, ECtipo, 
						Ocodigo, Ccuenta, 
						Mcodigo, Speriodo, Smes, 
						SLinicial, DLdebitos, CLcreditos, 
						SOinicial, DOdebitos, COcreditos,
						SLinicialGE, 
						SOinicialGE
					)
					select 
						s.Ecodigo, #Arguments.Tipo#, 
						s.Ocodigo, s.Ccuenta, 
						s.Mcodigo, s.Speriodo, s.Smes,
						s.SLinicial		+ s.DLdebitos - s.CLcreditos, 0, 0,
						s.SOinicial		+ s.DOdebitos - s.COcreditos, 0, 0,
						s.SLinicialGE	+ s.DLdebitos - s.CLcreditos,
						s.SOinicialGE	+ s.DOdebitos - s.COcreditos
					  from SaldosContables s
					  	inner join CContables c 
							inner join CtasMayor m 
								 on m.Ecodigo = c.Ecodigo 
								and m.Cmayor  = c.Cmayor 
								and m.Ctipo   in ('I', 'G') 
							on c.Ccuenta = s.Ccuenta
					 where s.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					   and s.Speriodo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoCierre#">
					   and s.Smes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#">
					   and (
						    s.SLinicial		+ s.DLdebitos - s.CLcreditos	<> 0.00
						 or s.SOinicial		+ s.DOdebitos - s.COcreditos	<> 0.00
						 or s.SLinicialGE	+ s.DLdebitos - s.CLcreditos	<> 0.00
						 or s.SOinicialGE	+ s.DOdebitos - s.COcreditos	<> 0.00
						  )
				</cfquery>
				<cfcatch type="any">
					<cfthrow message="Error en actualizar datos de Saldos Contables de Cierres, al insertar los registros del siguiente mes: #cfcatch.Message# #cfcatch.Detail#">
				</cfcatch>
			</cftry>
		<cfelse>
			<cfquery name="rsCtasMayor" datasource="#Arguments.Conexion#">
				select Cmayor 
				  from CtasMayor 
				 where Ecodigo	= #Arguments.Ecodigo#
				   and Ctipo	in ('I', 'G') 
			</cfquery>
	
			<cfloop query="rsCtasMayor">
				<cftry>
					<cfquery datasource="#Arguments.Conexion#">
						insert into SaldosContablesCierre (
							Ecodigo, ECtipo, 
							Ocodigo, Ccuenta, 
							Mcodigo, Speriodo, Smes, 
							SLinicial, DLdebitos, CLcreditos, 
							SOinicial, DOdebitos, COcreditos,
							SLinicialGE, 
							SOinicialGE
						)
						select 
							s.Ecodigo, #Arguments.Tipo#,
							s.Ocodigo, s.Ccuenta, 
							s.Mcodigo, s.Speriodo, s.Smes,
							s.SLinicial		+ s.DLdebitos - s.CLcreditos, 0, 0,
							s.SOinicial		+ s.DOdebitos - s.COcreditos, 0, 0
							s.SLinicialGE	+ s.DLdebitos - s.CLcreditos,
							s.SOinicialGE	+ s.DOdebitos - s.COcreditos
						from CContables c
								inner join SaldosContables s
										 on s.Ccuenta = c.Ccuenta
										and s.Speriodo = #Arguments.AnoCierre#
										and s.Smes     = #Arguments.MesCierre#
						where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char"    value="#rsCtasMayor.Cmayor#">
						  and (
							    s.SLinicial		+ s.DLdebitos - s.CLcreditos	<> 0.00
							 or s.SOinicial		+ s.DOdebitos - s.COcreditos	<> 0.00
							 or s.SLinicialGE	+ s.DLdebitos - s.CLcreditos	<> 0.00
							 or s.SOinicialGE	+ s.DOdebitos - s.COcreditos	<> 0.00
							  )
					</cfquery>
	
					<cfcatch type="any">
						<cfthrow message="Error en actualizar datos de Saldos Contables de Cierres, al actualizar la cuenta #rsCtasMayor.Cmayor#. Verifique el mensaje siguiente: #cfcatch.Message# #cfcatch.Detail#">
					</cfcatch>
				</cftry>
			</cfloop>
		</cfif>

		<!--- Arrastra los saldos de Cuenta de Utilidades del Período de Cierre --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into SaldosContablesCierre (
				Ecodigo, ECtipo, 
				Ocodigo, Ccuenta, 
				Mcodigo, Speriodo, Smes, 
				SLinicial, DLdebitos, CLcreditos, 
				SOinicial, DOdebitos, COcreditos,
				SLinicialGE, 
				SOinicialGE
			)
			select 
				s.Ecodigo, #Arguments.Tipo#, 
				s.Ocodigo, b.Ccuentaniv, 
				s.Mcodigo, s.Speriodo, s.Smes,
				s.SLinicial		+ s.DLdebitos - s.CLcreditos, 0, 0,
				s.SOinicial		+ s.DOdebitos - s.COcreditos, 0, 0,
				s.SLinicialGE	+ s.DLdebitos - s.CLcreditos,
				s.SOinicialGE	+ s.DOdebitos - s.COcreditos
			  from SaldosContables s
					inner join PCDCatalogoCuenta b
						 on b.Ccuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaUtilidad.cuenta#">
						and b.Ccuentaniv = s.Ccuenta
			 where s.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and s.Speriodo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoCierre#">
			   and s.Smes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#">
			   and (
					select count(1)
					  from SaldosContablesCierre
					 where Ccuenta	= b.Ccuentaniv
					   and Speriodo	= s.Speriodo
					   and Smes		= s.Smes
					   and Ecodigo	= s.Ecodigo
					   and ECtipo 	= #Arguments.Tipo#
					   and Ocodigo	= s.Ocodigo
					   and Mcodigo	= s.Mcodigo
					) = 0
		</cfquery>
		<!--- Crea saldos nuevos de Cuenta de Utilidades con base en las cuentas de Resultados existentes (Mcodigo y Ocodigo) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into SaldosContablesCierre (
				Ecodigo, ECtipo, 
				Ocodigo, Ccuenta, 
				Mcodigo, Speriodo, Smes, 
				SLinicial, DLdebitos, CLcreditos, 
				SOinicial, DOdebitos, COcreditos,
				SLinicialGE, 
				SOinicialGE
			)
			select 
				DISTINCT
				s.Ecodigo, #Arguments.Tipo#, 
				s.Ocodigo, u.Ccuentaniv, 
				s.Mcodigo, s.Speriodo, s.Smes,
				0, 0, 0,
				0, 0, 0,
				0, 0
			  from SaldosContables s
				inner join CContables c 
					inner join CtasMayor m 
						 on m.Ecodigo = c.Ecodigo 
						and m.Cmayor  = c.Cmayor 
						and m.Ctipo   in ('I', 'G') 
					on c.Ccuenta = s.Ccuenta
				inner join PCDCatalogoCuenta u
					on u.Ccuenta=#rsCuentaUtilidad.cuenta#
			 where s.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and s.Speriodo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoCierre#">
			   and s.Smes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#">
			   and (
					s.SLinicial		+ s.DLdebitos - s.CLcreditos	<> 0.00
				 or s.SOinicial		+ s.DOdebitos - s.COcreditos	<> 0.00
				 or s.SLinicialGE	+ s.DLdebitos - s.CLcreditos	<> 0.00
				 or s.SOinicialGE	+ s.DOdebitos - s.COcreditos	<> 0.00
				  )
			   and (
					select count(1)
					  from SaldosContablesCierre
					 where Ccuenta	= u.Ccuentaniv
					   and Speriodo	= s.Speriodo
					   and Smes		= s.Smes
					   and Ecodigo	= s.Ecodigo
					   and ECtipo 	= #Arguments.Tipo#
					   and Ocodigo	= s.Ocodigo
					   and Mcodigo	= s.Mcodigo
					) = 0
		</cfquery>
	</cffunction>

	<!---
		Se generan registros cuando alguno de SaldoInicial, debitos, creditos no son cero
	--->
	<cffunction name="sbGeneraAsientoCierreAnual" access="private" output="false">
		<cfargument name="Ecodigo"		type="numeric" required="yes">
		<cfargument name="TipoCierre"	type="numeric" required="yes">
		<cfargument name="PerCierre"	type="numeric" required="yes">
		<cfargument name="MesCierre"	type="numeric" required="yes">
		<cfargument name="Conexion"		type="string" required="yes">
		<cfargument name="MesCierreNuevo"	type="numeric" required="yes">
		<cfargument name="PerCierreNuevo"	type="numeric" required="yes">
		<cfargument name="abrirTrans"	type="boolean" default="yes">

		<cfif Arguments.TipoCierre EQ 1>
			<cfset LvarDescripcion	= "Cierre Anual">
			<cfset LvarDocRef		= "CIERRE FISCAL">
			<cfset LvarOorigen 		= "CGCF">
		<cfelseif Arguments.TipoCierre EQ 11>
			<cfset LvarDescripcion	= "Cierre Anual Corporativo">
			<cfset LvarDocRef		= "CIERRE CORPORATIVO">
			<cfset LvarOorigen 		= "CGCC">
		<cfelse>
			<cfthrow message="Tipo de Cierre Anual Incorrecto (1=Fiscal,11=Corporativo): #Arguments.TipoCierre#">
		</cfif>
		
		<!--- Realizar el cierre Anual --->
		<cfquery name="rsConceptoContableE" datasource="#Arguments.Conexion#">
			select min(Cconcepto) as Cconcepto
			  from ConceptoContable
			 where Ecodigo = #Arguments.Ecodigo#
			   and Oorigen = '#LvarOorigen#'
		</cfquery>

		<cfif not isdefined('rsConceptoContableE') or rsConceptoContableE.recordcount LT 1 or len(trim(rsConceptoContableE.Cconcepto)) EQ 0>
			<cfif Arguments.TipoCierre EQ 1>
				<cf_errorCode	code = "51123" msg = "No se ha definido el Concepto para el Origen de Cierre Anual Fiscal (CGCF). No se puede realizar el proceso de cierre de Periodo">
			<cfelse>
				<cfthrow message="No se ha definido el Concepto para el Origen Cierre Anual Corporativo (CGCC). No se puede realizar el proceso de cierre de Periodo Corporativo">
			</cfif>
		</cfif>

		<!--- Anular los asientos de Cierre Anual ya generados porque no aplican (se borraron los SaldosContables existentes y hay que volver a calcular) --->
		<cfquery name="rsAsientosABorrar" datasource="#Arguments.Conexion#">
			select e.IDcontable, e.Edescripcion
			  from HEContables e
			 where e.Ecodigo      = #Arguments.Ecodigo#
			   and e.ECtipo       = #Arguments.TipoCierre#
			   and e.Eperiodo     = #Arguments.PerCierre#
			   and e.Emes         = #Arguments.MesCierre#
			 <!----  and e.Edescripcion like '#LvarDescripcion#:  Cuenta%'---->
		</cfquery>

		<cfloop query="rsAsientosABorrar">
			<cfquery datasource="#Arguments.Conexion#">
				delete from HDContables
				 where IDcontable = #rsAsientosABorrar.IDcontable#
			</cfquery>

			<cfquery datasource="#Arguments.Conexion#">
				update HEContables
				   set Edescripcion = 'Anulacion de Asiento #rsAsientosABorrar.Edescripcion#'
				 where IDcontable = #rsAsientosABorrar.IDcontable#
				   and Edescripcion NOT LIKE 'Anulacion de Asiento%'
			</cfquery>
		</cfloop>

		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>

		<cfquery name="rsCtasMayor" datasource="#Arguments.Conexion#">
			select Cmayor 
			  from CtasMayor c
			 where c.Ecodigo  = #Arguments.Ecodigo#
			   and c.Ctipo in ('I', 'G')
			 order by c.Cmayor
		</cfquery>

		<cfloop query="rsCtasMayor">
			<cfset LvarDocBase		= "CIERRE #Arguments.PerCierre#/#numberFormat(Arguments.MesCierre,"00")# #rsCtasMayor.Cmayor#">
			<cfquery datasource="#Arguments.Conexion#">
				delete from #Intarc#
			</cfquery>

			<cfquery name="rsIntarcInsert" datasource="#Arguments.Conexion#">
				insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
				select 
					#Arguments.PerCierre# as Periodo,
					#Arguments.MesCierre# as Mes,
					a.Ocodigo as Oficina, 
					'#LvarDescripcion#: Cuenta de Resultados #rsCtasMayor.Cmayor#' as Descripcion,
					'#LvarDocBase#'		as Documento,
					'#LvarDocRef#'		as Referencia,
					a.Ccuenta as Cuenta, 
				<cfif Arguments.TipoCierre EQ 1>
					case when (SLinicial + DLdebitos - CLcreditos) < 0 then 'D' else 'C' end as TipoMovimiento, 
					abs(SOinicial + DOdebitos - COcreditos) as SaldoOrigen,
					abs(SLinicial + DLdebitos - CLcreditos) as SaldoLocal, 
				<cfelseif Arguments.TipoCierre EQ 11>
					case when (SLinicialGE + DLdebitos - CLcreditos) < 0 then 'D' else 'C' end as TipoMovimiento, 
					abs(SOinicialGE + DOdebitos - COcreditos) as SaldoOrigen,
					abs(SLinicialGE + DLdebitos - CLcreditos) as SaldoLocal, 
				</cfif>
					a.Mcodigo as Moneda,

					0.00 as TipoCambio,
					'?', '?', 0
				from CContables b
						inner join SaldosContables a
						 on a.Ccuenta = b.Ccuenta
				where b.Ecodigo = #Arguments.Ecodigo#
				  and b.Cmayor  = '#rsCtasMayor.Cmayor#'
				  and b.Cmovimiento = 'S'
				  and a.Speriodo = #Arguments.PerCierre#
				  and a.Smes     = #Arguments.MesCierre#
				  and (
						SLinicial	+ DLdebitos - CLcreditos <> 0.00 
					 or SOinicial	+ DOdebitos - COcreditos <> 0.00
					 or SLinicialGE	+ DLdebitos - CLcreditos <> 0.00 
					 or SOinicialGE	+ DOdebitos - COcreditos <> 0.00
					  )
			</cfquery>
			
						
			<!--- Caso en que la suma de Debitos - Creditos tanto en Moneda Origen como Moneda Local sean del mismo signo --->
			<cfquery name="rsIntarcUtilidad" datasource="#Arguments.Conexion#">
				insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, INTTIP, Ccuenta, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
				select 
					#Arguments.PerCierre# as Periodo,
					#Arguments.MesCierre# as Mes,
					Ocodigo as Oficina, 
					<cfif ResumenIngrYGastos EQ 'N'>
						'#LvarDescripcion#: Cuenta Utilidad' as Descripcion,
					<cfelse>
						'#LvarDescripcion#: Cuenta Resumen Ingresos y Gastos #rsCuentaResumenIngyGasto.cuenta#' as Descripcion,
					</cfif>
					'#LvarDocBase#' 	as Documento,
					'#LvarDocRef#' 		as Referencia,
					case 
					when sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' 
					when sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) < 0 then 'D'
					else 
						case 
						when sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' 
						else 'D'
						end
					end as TipoMovimiento,
					<cfif ResumenIngrYGastos EQ 'N'>
						#rsCuentaUtilidad.cuenta# as Cuenta,
					<cfelse>
						#rsCuentaResumenIngyGasto.cuenta# as Cuenta,
					</cfif>
					abs(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end))) as SaldoOrigen,
					abs(sum(INTMON * (case INTTIP when 'C' then -1 else 1 end))) as SaldoLocal,
					Mcodigo as Moneda, 
					0.00 as TipoCambio,
					'?', '?', 0
				from #Intarc#
				where 
				<cfif ResumenIngrYGastos EQ 'N'>
					Ccuenta <> #rsCuentaUtilidad.cuenta#
				<cfelse>
					Ccuenta <> #rsCuentaResumenIngyGasto.cuenta#
				</cfif>
				group by Ocodigo, Mcodigo
				having (sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <> 0 or sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <> 0)
				and (
				(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <= 0)
				or
				(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) >= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) >= 0)
				)
			</cfquery>

			<!--- Suma de Montos en Moneda Origen dejando Moneda Local en cero cuando la suma de Debitos - Creditos en Moneda Origen son de signo diferente al de la Moneda Local --->
			<cfquery name="rsIntarcUtilidad2" datasource="#Arguments.Conexion#">
				insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, INTTIP, Ccuenta, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
				select 
					#Arguments.PerCierre# as Periodo,
					#Arguments.MesCierre# as Mes,
					Ocodigo as Oficina, 
					'#LvarDescripcion#: Ajuste Moneda Origen' as Descripcion,
					'#LvarDocBase#' 	as Documento,
					'#LvarDocRef#' 		as Referencia,
					case 
					when sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' 
					else 'D'
					end as TipoMovimiento,
					<cfif ResumenIngrYGastos EQ 'N'>
						#rsCuentaUtilidad.cuenta# as Cuenta,
					<cfelse>
						#rsCuentaResumenIngyGasto.cuenta# as Cuenta,
					</cfif>
					abs(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end))) as SaldoOrigen,
					0.00 as SaldoLocal,
					Mcodigo as Moneda, 
					0.00 as TipoCambio,
					'?', '?', 0
				from #Intarc#
				where 
				<cfif ResumenIngrYGastos EQ 'N'>
					Ccuenta <> #rsCuentaUtilidad.cuenta#
				<cfelse>
					Ccuenta <> #rsCuentaResumenIngyGasto.cuenta#
				</cfif>
				group by Ocodigo, Mcodigo
				having (sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <> 0 or sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <> 0)
				and not (
				(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <= 0)
				or
				(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) >= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) >= 0)
				)
			</cfquery>

			<!--- Suma de Montos en Moneda Local dejando Moneda Origen en cero cuando la suma de Debitos - Creditos en Moneda Origen son de signo diferente al de la Moneda Local --->
			<cfquery name="rsIntarcUtilidad3" datasource="#Arguments.Conexion#">
				insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, INTTIP, Ccuenta, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
				select 
					#Arguments.PerCierre# as Periodo,
					#Arguments.MesCierre# as Mes,
					Ocodigo as Oficina, 
					'#LvarDescripcion#: Ajuste Moneda Local' as Descripcion,
					'#LvarDocBase#' 	as Documento,
					'#LvarDocRef#' 		as Referencia,
					case 
					when sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' 
					else 'D'
					end as TipoMovimiento,
					<cfif ResumenIngrYGastos EQ 'N'>
						#rsCuentaUtilidad.cuenta# as Cuenta,
					<cfelse>
						#rsCuentaResumenIngyGasto.cuenta# as Cuenta,
					</cfif>
					0.00 as SaldoOrigen,
					abs(sum(INTMON * (case INTTIP when 'C' then -1 else 1 end))) as SaldoLocal,
					Mcodigo as Moneda, 
					0.00 as TipoCambio,
					'?', '?', 0
				from #Intarc#
				where 
				<cfif ResumenIngrYGastos EQ 'N'>
					Ccuenta <> #rsCuentaUtilidad.cuenta#
				<cfelse>
					Ccuenta <> #rsCuentaResumenIngyGasto.cuenta#
				</cfif>
				group by Ocodigo, Mcodigo
				having (sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <> 0 or sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <> 0)
				and not (
				(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <= 0)
				or
				(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) >= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) >= 0)
				)
			</cfquery>

			<cfquery name="verificaINTARC" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad 
				from #Intarc#
				where INTMOE <> 0.00 or INTMON <> 0.00
			</cfquery>

			<cfif verificaINTARC.Cantidad GT 0>
				<cfif Arguments.abrirTrans>
					<cftransaction>
						<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
							<cfinvokeargument name="Oorigen"		value="#LvarOorigen#">
							<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
							<cfinvokeargument name="Eperiodo"		value="#Arguments.PerCierre#">
							<cfinvokeargument name="Emes"			value="#Arguments.MesCierre#">
							<cfinvokeargument name="Efecha"			value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Arguments.PerCierre, Arguments.MesCierre, 1)))#">
							<cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#: Cuenta #rsCtasMayor.Cmayor#">
							<cfinvokeargument name="Edocbase"		value="#LvarDocBase#">
							<cfinvokeargument name="Ereferencia"	value="#LvarDocRef#">
							<cfinvokeargument name="interfazconta"	value="true">
							<cfinvokeargument name="debug"			value="false">
							<cfinvokeargument name="CierreAnual"	value="true">
						</cfinvoke>	
	
						<cfquery name="updEContable" datasource="#Arguments.Conexion#">
							update EContables
							   set ECtipo = #Arguments.TipoCierre#
							 where IDcontable = #IDcontable#
						</cfquery>
					</cftransaction>
				<cfelse>
					<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
						<cfinvokeargument name="Oorigen"		value="#LvarOorigen#">
						<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
						<cfinvokeargument name="Eperiodo"		value="#Arguments.PerCierre#">
						<cfinvokeargument name="Emes"			value="#Arguments.MesCierre#">
						<cfinvokeargument name="Efecha"			value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Arguments.PerCierre, Arguments.MesCierre, 1)))#">
						<cfinvokeargument name="Edescripcion"	value="#LvarDescripcion# Cuenta #rsCtasMayor.Cmayor#">
						<cfinvokeargument name="Edocbase"		value="#LvarDocBase#">
						<cfinvokeargument name="Ereferencia"	value="#LvarDocRef#">
						<cfinvokeargument name="interfazconta"	value="true">
						<cfinvokeargument name="debug"			value="false">
						<cfinvokeargument name="CierreAnual"	value="true">
					</cfinvoke>	

					<cfquery name="updEContable" datasource="#Arguments.Conexion#">
						update EContables
						   set ECtipo = #Arguments.TipoCierre#
						 where IDcontable = #IDcontable#
					</cfquery>
				</cfif>	
				<cfinvoke component="CG_AplicaAsiento"  method="CG_AplicaAsiento">
					<cfinvokeargument name="IDcontable" value="#IDcontable#">
					<cfinvokeargument name="CtlTransaccion" value="true">
				</cfinvoke>
			</cfif>
		</cfloop>
		
		<cfif ResumenIngrYGastos EQ 'Y'>
			<cfset sbGeneraPolizaAhorroODesahorro (Arguments.Ecodigo, 1, Arguments.PerCierre, Arguments.MesCierre, Arguments.PerCierreNuevo, Arguments.MesCierreNuevo, Arguments.Conexion, LvarDescripcion, LvarDocRef, LvarOorigen)>			
			<cfset sbGeneraPolizaUtilidaEjercicio (Arguments.Ecodigo, 1, Arguments.PerCierre, Arguments.MesCierre, Arguments.PerCierreNuevo, Arguments.MesCierreNuevo, Arguments.Conexion, LvarDescripcion, LvarDocRef, LvarOorigen)>	
			<cfset sbGeneraPolizaResultEjerciciosAnt (Arguments.Ecodigo, 1, Arguments.PerCierre, Arguments.MesCierre, Arguments.PerCierreNuevo, Arguments.MesCierreNuevo, Arguments.Conexion, LvarDescripcion, LvarDocRef, LvarOorigen)>				
		</cfif>						
	</cffunction>

    <cffunction name="fnGeneraAsientosRecursivos" access="public" output="no" hint="Copia los asientos marcados como recursivos al siguiente mes">
		<cfargument name="Empresa"         	type="numeric" required="yes">
        <cfargument name="PeriodoAnterior"	type="numeric" required="yes">
        <cfargument name="MesAnterior"		type="numeric" required="yes">
        <cfargument name="PeriodoActual"   	type="numeric" required="yes">
        <cfargument name="MesActual"       	type="numeric" required="yes">
        <cfargument name="Conexion"        	type="string"  required="yes">

		<cfobject name="LobjContabilidad" component="sif.Componentes.Contabilidad">
       	<cfset LvarFecha = createdate(arguments.PeriodoActual, arguments.MesActual, 01)> 
                
		<!---Relizo un query para saber si debo eliminar un asiento--->
        <cfquery name="rsAsientosRecursivosSELECT" datasource="#Arguments.conexion#">
        	select IDcontable, FFECrecursivo
              from AsientosRecursivos 
             where Ecodigo = #Arguments.Empresa# 
               and FFECrecursivo < <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"	value="#LvarFecha#"	>
        </cfquery>
        
        <!---Elimino sino cumplen el rango#--->
        <cfloop query="rsAsientosRecursivosSELECT">
        	<cfif len(trim("FFECrecursivo"))>
                <cfquery name="rsAsientosRecursivosBAJA" datasource="#Arguments.conexion#">
                    delete
                      from AsientosRecursivos 
                     where Ecodigo = #session.Ecodigo# 
					   and IDcontable = #rsAsientosRecursivosSELECT.IDcontable#
                </cfquery>
            </cfif>
        </cfloop>
        
        <cfquery name="rsAsientosRecursivos" datasource="#Arguments.conexion#">
        	select DISTINCT
			r.IDcontable, h.Cconcepto,
			CASE WHEN hdi.IDcontable is NULL THEN '0' ELSE '1' END as Intercompany
            from AsientosRecursivos r
            	inner join HEContables h					
                on h.IDcontable = r.IDcontable
				
				LEFT OUTER JOIN HDContablesInt hdi 
				on hdi.IDcontable=r.IDcontable
            where r.Ecodigo = #Arguments.Empresa#
        </cfquery>
                
		<cfloop query="rsAsientosRecursivos">
			<cftransaction>
				<cfset LvarIDcontable = rsAsientosRecursivos.IDcontable>
                <cfset LvarCconcepto  = rsAsientosRecursivos.Cconcepto>
             
                <cfset Edoc = LobjContabilidad.Nuevo_Asiento(Arguments.Empresa,Arguments.Conexion, LvarCconcepto, ' ',Arguments.PeriodoActual,Arguments.MesActual) >
    			
				<cfquery name="selectABC_NuevoAsiento" datasource="#Arguments.conexion#">
					select Cconcepto, #PeriodoActual# as Eperiodo, 
					#MesActual# as Emes, #Edoc# as Edocumento, #LvarFecha# as Efecha, 
					Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario, ECusucodigo, ECfechacreacion, '' as ECipcrea, ECestado, BMUsucodigo, ECtipo
						from HEContables
						where IDcontable = #LvarIDcontable#
				</cfquery>
                <cfquery name="ABC_NuevoAsiento" datasource="#Arguments.conexion#">
                    insert into EContables (
						Ecodigo, Cconcepto, Eperiodo, Emes, 
						Edocumento, Efecha, Edescripcion, Edocbase, 
						Ereferencia, ECauxiliar, ECusuario, ECusucodigo, 
						ECfechacreacion, ECipcrea, ECestado, BMUsucodigo, ECtipo
						)
                    VALUES(
					   #Arguments.Empresa#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_NuevoAsiento.Cconcepto#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_NuevoAsiento.Eperiodo#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_NuevoAsiento.Emes#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_NuevoAsiento.Edocumento#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectABC_NuevoAsiento.Efecha#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectABC_NuevoAsiento.Edescripcion#"    voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectABC_NuevoAsiento.Edocbase#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  value="#selectABC_NuevoAsiento.Ereferencia#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectABC_NuevoAsiento.ECauxiliar#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectABC_NuevoAsiento.ECusuario#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectABC_NuevoAsiento.ECusucodigo#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectABC_NuevoAsiento.ECfechacreacion#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectABC_NuevoAsiento.ECipcrea#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_NuevoAsiento.ECestado#"        voidNull>,
					   #session.Usucodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_NuevoAsiento.ECtipo#"          voidNull>  
				)
                
                  <cf_dbidentity1 datasource="#Arguments.Conexion#">
                </cfquery>
                
                <cf_dbidentity2 datasource="#Arguments.Conexion#" name="ABC_NuevoAsiento">
            
                <cfif isdefined("ABC_NuevoAsiento.identity")>
                    <cfquery name="ABC_DetalleAsiento" datasource="#Arguments.Conexion#">
                        insert INTO DContables(Ecodigo, IDcontable, Dlinea, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio,Ddocumento, Dreferencia,CFid)
                        select DISTINCT
								Ecodigo, 
                               <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_NuevoAsiento.identity#">, 
                               Dlinea, 
                               Cconcepto, 
                                #PeriodoActual#, #MesActual#, #Edoc#,
                               Ocodigo, Ddescripcion, 
                               Dmovimiento, 
                               Ccuenta, CFcuenta, Doriginal, 
							   case when Dtipocambio != 1 then <!--- actualizar el dlocal con el tipo de cambio actual--->
                               		(coalesce((select tc.TCpromedio
                                              from Monedas m
												inner join Htipocambio tc
												  on tc.Mcodigo = m.Mcodigo
												 and tc.Ecodigo = m.Ecodigo
												 and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
												 and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
												where m.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Empresa#">
												  and m.Mcodigo  = h.Mcodigo), Dtipocambio)*Doriginal)
                               else 
                               		(Dtipocambio+Doriginal)
                               end as Dlocal, 							   
							   Mcodigo, 
							   case when Dtipocambio != 1 then <!--- obtener el tipo de cambio local --->
                               		coalesce((select tc.TCpromedio
                                              from Monedas m
												inner join Htipocambio tc
												  on tc.Mcodigo = m.Mcodigo
												 and tc.Ecodigo = m.Ecodigo
												 and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
												 and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
												where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Empresa#">
												  and m.Mcodigo = h.Mcodigo), Dtipocambio)
                               else 
                               		Dtipocambio
                               end as Dtipocambio,
                               Ddocumento, Dreferencia,CFid
                        from 
						<cfif rsAsientosRecursivos.Intercompany EQ 1>
							HDContablesInt h
						<cfelse>
							HDContables h
						</cfif>
                        where Ecodigo = #Arguments.Empresa#
                        and IDcontable = #LvarIDcontable#
                    </cfquery>
					
					<!--- guardar relacion por la cual se genero la copia --->
					<cfquery  datasource="#Session.DSN#">
						INSERT INTO REContablesInt 
						(IDcontableOri, IDcontableGen, RECdetalle)
						values 
						( #LvarIDcontable#, <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_NuevoAsiento.identity#">,'#selectABC_NuevoAsiento.ECtipo# - Recurrente')
					</cfquery>
                <cfelse>
                    <cf_errorCode	code = "50244" msg = "Error en Copia de Detalles!.">
                </cfif>		
	        </cftransaction>
        </cfloop>
    </cffunction>

	<!---------------------------------------------------------------------------------------------------->
	
	<cffunction name="sbInicializaPeriodoCorporativo" access="public" output="false">
		<cfargument name="Mes"			type="numeric" required="yes">
		<cfargument name="Ecodigo"		type="numeric" required="yes">
		<cfargument name="Conexion"		type="string"  required="yes">
		<cfargument name="AnoIniciar"	type="numeric" default="0">
		<cfargument name="MesIniciar"	type="numeric" default="0">

		<cfset var LvarMesFiscal 		= 0> 
		<cfset var LvarPerNuevo			= 0> 
		<cfset var LvarMesNuevo			= 0> 

		<cfsetting requesttimeout="36000">

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor as ano
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 30
		</cfquery>
		<cfset LvarAnoActual = rsSQL.Ano> 

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor as mes
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 40
		</cfquery>
		<cfset LvarMesActual = rsSQL.mes>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor as mes
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 45
		</cfquery>
		<cfset LvarMesFiscal = rsSQL.mes> 

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor as mes
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 46
		</cfquery>
		<cfset LvarMesCorporativo = rsSQL.mes>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor as fecha
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 47
		</cfquery>
		<cfset LvarArranqueCorporativo = rsSQL.fecha>

		<cfquery name="rsCuentaUtilidad" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = 300
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsCuentaUtilidad.recordcount EQ 0 or len(rsCuentaUtilidad.cuenta) EQ 0>
			<cfthrow message="Error. No esta definida la Cuenta de Utilidad Acumulada. Proceso Cancelado!!">
		</cfif>
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Ccuentaniv from PCDCatalogoCuenta where Ccuenta=#rsCuentaUtilidad.cuenta#
		</cfquery>
		<cfset LvarCtasNivUtilidad = valueList(rsSQL.Ccuentaniv)>

		<cfif LvarMesActual LTE LvarMesFiscal>
			<cfset LvarAnoCierre = LvarAnoActual - 1>
		<cfelse>
			<cfset LvarAnoCierre = LvarAnoActual>
		</cfif>

		<!--- Conceptos Contables de Cierre --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from SaldosContablesCierre
			 where Ecodigo      = #Arguments.Ecodigo#
			   and ECtipo       = 1
			   and Speriodo     = #LvarAnoCierre#
			   and Smes         = #LvarMesFiscal#
		</cfquery>
		<cfset LvarInicializarCierreFiscal = rsSQL.cantidad EQ 0>
		<cfif LvarInicializarCierreFiscal>
			<cfset LvarIDContablesRet_Fisc = "">

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				delete from SaldosContablesCierre
				 where Ecodigo	= #Arguments.Ecodigo#
			</cfquery>

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from Origenes
				 where Oorigen = 'CGCF'
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into Origenes (Oorigen, Odescripcion, Otipo, BMUsucodigo)
					values ('CGCF', 'Cierre Anual Fiscal', 'S', 1)
				</cfquery>
			</cfif>			
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from Origenes
				 where Oorigen = 'CGCC'
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into Origenes (Oorigen, Odescripcion, Otipo, BMUsucodigo)
					values ('CGCC', 'Cierre Anual Corporativo', 'S', 1)
				</cfquery>
			</cfif>			

			<cfquery name="rsConceptoContableE" datasource="#Arguments.Conexion#">
				select min(Cconcepto) as Cconcepto
				from ConceptoContable
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Oorigen = 'CGCF'
			</cfquery>
			
			<cfif rsConceptoContableE.recordcount EQ 0 or len(trim(rsConceptoContableE.Cconcepto)) EQ 0>
				<cfthrow message="No se ha definido el Concepto para el Origen Cierre Anual Fiscal (CGCF). No se puede realizar el proceso de Inicialización de Período Fiscal">
			</cfif>
		</cfif>
		
		<cfset LvarHayCierreCorporativo = Arguments.Mes NEQ LvarMesFiscal>

		<cfset LvarFechaArranque = "">
		<cfif LvarHayCierreCorporativo>
			<cfset LvarIDContablesRet_Corp = "">
			<cfif Arguments.AnoIniciar EQ 0 OR Arguments.MesIniciar EQ 0>
				<cfthrow message="Falta indicar Año y Mes de los Saldos Iniciales Corporativos">
			</cfif>
			<cfset LvarFechaArranque = "01/#numberFormat(Arguments.MesIniciar,"00")#/#Arguments.AnoIniciar#">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from SaldosContables
				 where Ecodigo	= #Arguments.Ecodigo#
				   AND Speriodo = #Arguments.AnoIniciar# 
				   AND Smes 	= #Arguments.MesIniciar#
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfthrow message="No hay SaldosContables en el Año y Mes de los Saldos Iniciales Corporativos">
			</cfif>

			<!--- Concepto Contable --->
			<cfquery name="rsConceptoContableE" datasource="#Arguments.Conexion#">
				select min(Cconcepto) as Cconcepto
				from ConceptoContable
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Oorigen = 'CGCC'
			</cfquery>
			
			<cfif not isdefined('rsConceptoContableE') or rsConceptoContableE.recordcount LT 1 or len(trim(rsConceptoContableE.Cconcepto)) EQ 0>
				<cfthrow message="No se ha definido el Concepto para el Origen Cierre Anual Corporativo (CGCC). No se puede realizar el proceso de Inicialización de Período Corporativo">
			</cfif>
		</cfif>

		<cftry>
			<!--- Se indica que está en proceso la inicializacion de los saldos iniciales corporativos --->
			<cfif LvarMesCorporativo EQ "">
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into Parametros 
					(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
					select Ecodigo, 46, Mcodigo, 'Ultimo Mes de Cierre Corporativo', '0'
					  from Parametros
					 where Ecodigo = #Arguments.Ecodigo#
					   and Pcodigo = 45
				</cfquery>
			<cfelse>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					update Parametros 
					   set Pvalor = '0'
					 where Ecodigo = #Arguments.Ecodigo#
					   and Pcodigo = 46
				</cfquery>
			</cfif>

			<cfif LvarArranqueCorporativo	 EQ "">
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into Parametros 
					(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
					select Ecodigo, 47, Mcodigo, 'Fecha de Arranque de Saldos Corporativos', ''
					  from Parametros
					 where Ecodigo = #Arguments.Ecodigo#
					   and Pcodigo = 45
				</cfquery>
			<cfelse>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					update Parametros 
					   set Pvalor = ''
					 where Ecodigo = #Arguments.Ecodigo#
					   and Pcodigo = 47
				</cfquery>
			</cfif>

			<!--- Inicializa Saldos Iniciales Corporativos --->
			<cfquery name="rsDEL" datasource="#Arguments.Conexion#">
				SELECT IDcontable 
				  from HEContables
				 where Ecodigo      = #Arguments.Ecodigo#
				   and ECtipo       = 11
				   and Edescripcion NOT like 'ASIENTO ANULADO:%'
			</cfquery>

			<cfloop query="rsDEL">
				<cfquery datasource="#Arguments.Conexion#">
					delete from HDContables
					 where IDcontable = #rsDEL.IDcontable#
				</cfquery>
	
				<cfquery datasource="#Arguments.Conexion#">
					UPDATE HEContables
					   SET Edescripcion = <cf_dbfunction name="concat" args="'ASIENTO ANULADO: ',Edescripcion">
					 where IDcontable = #rsDEL.IDcontable#
					   and Edescripcion NOT like 'ASIENTO ANULADO:%'
				</cfquery>
			</cfloop>

			<cfquery datasource="#Arguments.Conexion#">
				delete from SaldosContablesCierre
				 where Ecodigo      = #Arguments.Ecodigo#
				   and ECtipo       = 11
			</cfquery>
	
			<cfset LvarMesCorporativo 	= Arguments.Mes>
			<cfset LvarAnoMesIniciar	= Arguments.AnoIniciar*100+Arguments.MesIniciar>
	
			<cfquery name="rsPer" datasource="#Arguments.Conexion#">
				select distinct Speriodo, Smes
				  from SaldosContables
				 where Ecodigo = #Arguments.Ecodigo#
				 order by 1,2
			</cfquery>
			<cfset LvarPerNuevo = rsPer.Speriodo>
			<cfset LvarMesNuevo = rsPer.Smes>
			<cfloop query="rsPer">
				<cfset LvarAnoMesProceso = rsPer.Speriodo*100+rsPer.Smes>
	
				<cfif LvarAnoMesProceso NEQ LvarPerNuevo*100+LvarMesNuevo>
					<cfthrow message="No hay SaldosContables para #LvarPerNuevo# #LvarMesNuevo#">
				</cfif>
				
				<cfset LvarMesNuevo = (rsPer.Smes MOD 12) + 1>
				<cfif LvarMesNuevo eq 1>
					<cfset LvarPerNuevo = rsPer.Speriodo + 1>
				<cfelse>
					<cfset LvarPerNuevo = rsPer.Speriodo>
				</cfif>
	
				<cfset LvarMesAnt = rsPer.Smes - 1>
				<cfif LvarMesAnt eq 0>
					<cfset LvarMesAnt = 12>
					<cfset LvarPerAnt = rsPer.Speriodo - 1>
				<cfelse>
					<cfset LvarPerAnt = rsPer.Speriodo>
				</cfif>

				<cfif NOT LvarHayCierreCorporativo>
					<cfquery datasource="#Arguments.Conexion#">
						update SaldosContables
						   set SLinicialGE = SLinicial
							 , SOinicialGE = SOinicial
						 where Ecodigo	= #Arguments.Ecodigo#
						   and Speriodo	= #rsPer.Speriodo#
						   and Smes		= #rsPer.Smes#
					</cfquery>
				<cfelseif LvarAnoMesProceso LT LvarAnoMesIniciar>
					<!--- Antes del Año y Mes de los Saldos Iniciales Corporativos se inicializan en CERO --->
					<cfquery datasource="#Arguments.Conexion#">
						update SaldosContables
						   set SLinicialGE = 0
							 , SOinicialGE = 0
						 where Ecodigo	= #Arguments.Ecodigo#
						   and Speriodo	= #rsPer.Speriodo#
						   and Smes		= #rsPer.SMes#
					</cfquery>
				<cfelseif LvarAnoMesProceso EQ LvarAnoMesIniciar>
					<!--- Los Saldos Iniciales Corporativos ya deben estar cargados en el Año y Mes indicados --->
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select count(1) as cantidad 
						  from SaldosContables s
							inner join CContables c 
								inner join CtasMayor m 
									 on m.Ecodigo = c.Ecodigo 
									and m.Cmayor  = c.Cmayor 
								on c.Ccuenta = s.Ccuenta
						 where s.Ecodigo	= #Arguments.Ecodigo#
						   and s.Speriodo	= #rsPer.Speriodo#
						   and s.Smes		= #rsPer.SMes#
						   and c.Cmovimiento = 'S'
						   and NOT (m.Ctipo	in ('I', 'G') OR s.Ccuenta in (#LvarCtasNivUtilidad#))
						   and (SLinicialGE <> SLinicial OR SOinicialGE <> SOinicial)
					</cfquery>
					<cfif rsSQL.cantidad GT 0>
						<cfthrow message="No se han cargado los saldos iniciales corporativos. Existen cuentas de balance con saldos Fiscales y Corporativos diferentes">
					</cfif>
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select count(1) as cantidad 
						  from SaldosContables s
							inner join CContables c 
								inner join CtasMayor m 
									 on m.Ecodigo = c.Ecodigo 
									and m.Cmayor  = c.Cmayor 
								on c.Ccuenta = s.Ccuenta
						 where s.Ecodigo	= #Arguments.Ecodigo#
						   and s.Speriodo	= #rsPer.Speriodo#
						   and s.Smes		= #rsPer.SMes#
						   and c.Cmovimiento = 'S'
						   and (m.Ctipo	in ('I', 'G') OR s.Ccuenta in (#LvarCtasNivUtilidad#))
						   and (SLinicialGE <> SLinicial OR SOinicialGE <> SOinicial)
					</cfquery>
					<cfif rsSQL.cantidad EQ 0>
						<cfthrow message="No se han cargado los saldos iniciales corporativos. Todas las cuentas de resultados y utilidad tienen sus saldos Fiscales y Corporativos iguales">
					</cfif>
					<!--- Registra Asiento de Arranque Corporativo como Asiento Cierre mes anterior --->
				<cfelse>
					<!--- Se inicia el proceso a partir del mes siguiente al Año y Mes de los Saldos Iniciales Corporativos --->
					<cfset sbCrearSaldosContablesNuevos(Arguments.Ecodigo,LvarPerAnt,LvarMesAnt, rsPer.Speriodo,rsPer.Smes,Arguments.Conexion,true)>
					<cfquery datasource="#Arguments.Conexion#">
						update SaldosContables
						   set SLinicialGE = 
						   		coalesce(
									(
										select s.SLinicialGE	+ s.DLdebitos - s.CLcreditos
										  from SaldosContables s
										 where s.Ccuenta	= SaldosContables.Ccuenta
										   and s.Speriodo	= #LvarPerAnt#
										   and s.Smes		= #LvarMesAnt#
										   and s.Ecodigo	= SaldosContables.Ecodigo
										   and s.Ocodigo	= SaldosContables.Ocodigo
										   and s.Mcodigo	= SaldosContables.Mcodigo
									)
								, 0)
							 , SOinicialGE = 
						   		coalesce(
									(
										select s.SOinicialGE	+ s.DOdebitos - s.COcreditos
										  from SaldosContables s
										 where s.Ccuenta	= SaldosContables.Ccuenta
										   and s.Speriodo	= #LvarPerAnt#
										   and s.Smes		= #LvarMesAnt#
										   and s.Ecodigo	= SaldosContables.Ecodigo
										   and s.Ocodigo	= SaldosContables.Ocodigo
										   and s.Mcodigo	= SaldosContables.Mcodigo
									)
								, 0)
						 where Ecodigo	= #Arguments.Ecodigo#
						   and Speriodo	= #rsPer.Speriodo#
						   and Smes		= #rsPer.SMes#
					</cfquery>
					<cfif LvarMesAnt EQ LvarMesCorporativo>
						<cfset sbCrearSaldosContablesCierre	(Arguments.Ecodigo, 11, LvarPerAnt, LvarMesAnt, Arguments.Conexion)>
						<cfset sbGeneraAsientoCierreAnual	(Arguments.Ecodigo, 11, LvarPerAnt, LvarMesAnt, Arguments.Conexion, false)>
					</cfif>
				</cfif>
	
				<cfif LvarInicializarCierreFiscal AND LvarMesAnt EQ LvarMesFiscal>
					<cfset sbCrearSaldosContablesCierre	(Arguments.Ecodigo, 1, LvarPerAnt, LvarMesAnt, Arguments.Conexion)>
					<!--- Mayorización del Cierre de Resultados (Ya incluye Retroactivos anteriores) --->
					<cfquery datasource="#Arguments.Conexion#">
						update SaldosContablesCierre
						   set 
								DLdebitos	= case when SLinicial < 0 then -SLinicial else 0 end,
								CLcreditos	= case when SLinicial > 0 then +SLinicial else 0 end,
								DOdebitos	= case when SOinicial < 0 then -SOinicial else 0 end,
								COcreditos	= case when SOinicial > 0 then +SOinicial else 0 end,
								BMFecha = <cf_dbfunction name="now">
						 where SaldosContablesCierre.Ccuenta	not in (#LvarCtasNivUtilidad#)
						   and SaldosContablesCierre.Speriodo	= #LvarPerAnt#
						   and SaldosContablesCierre.Smes		= #LvarMesAnt#
						   and SaldosContablesCierre.Ecodigo	= #Arguments.Ecodigo#
						   and SaldosContablesCierre.ECtipo		= 1
					</cfquery>
					<!--- Mayorización del Cierre de Utilidades por Oficina y Moneda --->
					<cfquery name="rsUtilAno" datasource="#Arguments.Conexion#">
						select s.Speriodo, s.Smes, s.Ocodigo, s.Mcodigo
							 , sum(DLdebitos-CLcreditos) as local
							 , sum(DOdebitos-COcreditos) as origen
						  from SaldosContablesCierre s
							inner join CContables c
								 on c.Ccuenta = s.Ccuenta
								and c.Cmovimiento = 'S'
						 where s.Ccuenta	not in (#LvarCtasNivUtilidad#)
						   and s.Speriodo	= #LvarPerAnt#
						   and s.Smes		= #LvarMesAnt#
						   and s.Ecodigo	= #Arguments.Ecodigo#
						   and s.ECtipo		= 1
						 group by s.Speriodo, s.Smes, s.Ocodigo, s.Mcodigo
					</cfquery>
					<cfloop query="rsUtilAno">
						<cfquery datasource="#Arguments.Conexion#">
							update SaldosContablesCierre
							   set 
								<cfif rsUtilAno.local GT 0>
									DLdebitos	= 0,
									CLcreditos	= #rsUtilAno.local#,
								<cfelse>
									DLdebitos	= #-rsUtilAno.local#,
									CLcreditos	= 0,
								</cfif>
								<cfif rsUtilAno.local GT 0>
									DOdebitos	= 0,
									COcreditos	= #rsUtilAno.origen#,
								<cfelse>
									DOdebitos	= #-rsUtilAno.origen#,
									COcreditos	= 0,
								</cfif>
									BMFecha = <cf_dbfunction name="now">
							 where SaldosContablesCierre.Ccuenta	in (#LvarCtasNivUtilidad#)
							   and SaldosContablesCierre.Speriodo	= #rsUtilAno.Speriodo#
							   and SaldosContablesCierre.Smes		= #rsUtilAno.Smes#
							   and SaldosContablesCierre.Ecodigo	= #Arguments.Ecodigo#
							   and SaldosContablesCierre.ECtipo		= 1
							   and SaldosContablesCierre.Ocodigo	= #rsUtilAno.Ocodigo#
							   and SaldosContablesCierre.Mcodigo	= #rsUtilAno.Mcodigo#
						</cfquery>
					</cfloop>
				</cfif>

			<!---	QUITAR ANGELES <cfthrow message="VAR LvarInicializarCierreFiscal #LvarInicializarCierreFiscal#, LvarMesAnt #LvarMesAnt# LvarMesFiscal #LvarMesAnt# ,LvarMesCorporativo #LvarMesCorporativo#, LvarAnoMesProceso #LvarAnoMesProceso#, LvarAnoMesIniciar #LvarAnoMesIniciar#">--->
				<!--- Genera un Asiento de Ajuste al Cierre Anual por cada Asiento Retroactivo del Período --->
				<cfif LvarInicializarCierreFiscal AND LvarMesAnt EQ LvarMesFiscal>
					<cfloop list="#LvarIDContablesRet_Fisc#" index="IDcontable">
						<cfinvoke component="CG_AplicaAsiento"  method="sbAsientoAjusteCierreAnualXRetroactivo">
							<cfinvokeargument name="IDcontable"		value="#IDcontable#">
							<cfinvokeargument name="ECtipo"			value="1">
							<cfinvokeargument name="Periodo"		value="#LvarPerAnt#">
							<cfinvokeargument name="Mes"			value="#LvarMesAnt#">
							<cfinvokeargument name="CuentaUtilidad"	value="#rsCuentaUtilidad.cuenta#">
							<cfinvokeargument name="fromH"			value="true">
						</cfinvoke>
					</cfloop>
					<cfset LvarIDContablesRet_Fisc = "">
				</cfif>
				<cfif LvarHayCierreCorporativo AND LvarMesAnt EQ LvarMesCorporativo AND LvarAnoMesProceso GT LvarAnoMesIniciar>
					<cfloop list="#LvarIDContablesRet_Corp#" index="IDcontable">
						<cfinvoke component="CG_AplicaAsiento"  method="sbAsientoAjusteCierreAnualXRetroactivo">
							<cfinvokeargument name="IDcontable"		value="#IDcontable#">
							<cfinvokeargument name="ECtipo"			value="11">
							<cfinvokeargument name="Periodo"		value="#LvarPerAnt#">
							<cfinvokeargument name="Mes"			value="#LvarMesAnt#">
							<cfinvokeargument name="CuentaUtilidad"	value="#rsCuentaUtilidad.cuenta#">
							<cfinvokeargument name="fromH"			value="true">
						</cfinvoke>
					</cfloop>
					<cfset LvarIDContablesRet_Corp = "">
				</cfif>

				<!--- Obtiene cada Asiento Retroactivo del Período que tenga cuentas de resultado --->
				<cfif LvarInicializarCierreFiscal OR LvarHayCierreCorporativo>
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select IDcontable
						   from HEContables e
						  where Ecodigo		= #Arguments.Ecodigo#
						    and Eperiodo	= #rsPer.Speriodo#
						    and Emes		= #rsPer.Smes#
						    and ECtipo		= 2
							and (
								select count(1)
								  from HDContables d
									inner join CContables c
											inner join CtasMayor m
													on  m.Ecodigo = c.Ecodigo
													and m.Cmayor  = c.Cmayor
													and m.Ctipo in ('I', 'G')
										on c.Ccuenta = d.Ccuenta
								 where d.IDcontable = e.IDcontable
								) > 0
					</cfquery>
					<cfif LvarInicializarCierreFiscal>
						<cfset LvarIDContablesRet_Fisc = listAppend(LvarIDContablesRet_Fisc,valuelist(rsSQL.IDcontable))>
					</cfif>
					<cfif LvarHayCierreCorporativo>
						<cfset LvarIDContablesRet_Corp = listAppend(LvarIDContablesRet_Corp,valuelist(rsSQL.IDcontable))>
					</cfif>
				</cfif>
			</cfloop>
			<!--- Se indica que ya se realizó la inicializacion de los saldos iniciales corporativos --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update Parametros 
				   set Pvalor = '#Arguments.Mes#'
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 46
			</cfquery>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update Parametros 
				   set Pvalor = '#LvarFechaArranque#'
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 47
			</cfquery>
		<cfcatch type="any">
			<!--- Se indica que no se realizó la inicializacion de los saldos iniciales corporativos --->
			<cflog file="InitSaldosCierre" text="Ecodigo=#session.Ecodigo#: #cfcatch.Message# #cfcatch.Detail#">
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update Parametros 
				   set Pvalor = '-#Arguments.Mes#'
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 46
			</cfquery>
			<cfif LvarInicializarCierreFiscal>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					delete from SaldosContablesCierre
					 where Ecodigo	= #Arguments.Ecodigo#
					   and ECtipo	= 1
				</cfquery>
			</cfif>
			<cfrethrow>
		</cfcatch>
		</cftry>

	</cffunction>
	
	<cffunction name="sbGeneraPolizaAhorroODesahorro" access="public" output="false"> 
		<cfargument name="Ecodigo"		type="numeric" required="yes">
		<cfargument name="TipoCierre"	type="numeric" required="yes">
		<cfargument name="PerCierre"	type="numeric" required="yes">
		<cfargument name="MesCierre"	type="numeric" required="yes">		
		<cfargument name="PerNuevo"	type="numeric" required="yes">
		<cfargument name="MesNuevo"	type="numeric" required="yes">
		<cfargument name="Conexion"		type="string" required="yes">
		<cfargument name="LvarDescripcion" type="string" required="yes">
		<cfargument name="LvarDocRef" type="string" required="yes">
		<cfargument name="LvarOorigen" type="string" required="yes">	
		<cfargument name="abrirTrans" type="boolean" default="yes">		
		
		
		<cfif Arguments.TipoCierre EQ 1>
			<cfset LvarDescripcion	= "Cierre Anual">
			<cfset LvarDocRef		= "CIERRE FISCAL">
			<cfset LvarOorigen 		= "CGCF">
		<cfelseif Arguments.TipoCierre EQ 11>
			<cfset LvarDescripcion	= "Cierre Anual Corporativo">
			<cfset LvarDocRef		= "CIERRE CORPORATIVO">
			<cfset LvarOorigen 		= "CGCC">
		<cfelse>
			<cfthrow message="Tipo de Cierre Anual Incorrecto (1=Fiscal,11=Corporativo): #Arguments.TipoCierre#">
		</cfif>
			
		<!----Obtiene los saldos de la Cuenta de Resumen de Ingresos y Gastos---->
		<cfquery name="rsImpPoliza" datasource="#Arguments.Conexion#">
			select distinct Mcodigo, D.Ocodigo,
				(select isnull(SUM(Doriginal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#">
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResumenIngyGasto.cuenta#"> and Dmovimiento = 'D' and Mcodigo = D.Mcodigo 									            
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) -
				(select isnull(SUM(Doriginal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResumenIngyGasto.cuenta#"> and Dmovimiento = 'C' and Mcodigo = D.Mcodigo 						 			
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) as SaldoMonOri,
				(select isnull(SUM(Dlocal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResumenIngyGasto.cuenta#"> and Dmovimiento = 'D' and Mcodigo = D.Mcodigo 					 			
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) -
				(select isnull(SUM(Dlocal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResumenIngyGasto.cuenta#"> and Dmovimiento = 'C' and Mcodigo = D.Mcodigo 			 			
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) as SaldoMonLoc
			from HEContables E
			inner join HDContables D on E.IDcontable = D.IDcontable
			where E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and E.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and E.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC') 
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">
			and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResumenIngyGasto.cuenta#"> 
			and Ddescripcion like '%Cuenta Resumen Ingresos y Gastos%'
		</cfquery>
		
 		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>
		
		<cfquery name="rsSaldoCta" datasource="#Arguments.Conexion#">
			select distinct	(select isnull(SUM(Dlocal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResumenIngyGasto.cuenta#"> and Dmovimiento = 'D' 
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) -
				(select isnull(SUM(Dlocal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResumenIngyGasto.cuenta#"> and Dmovimiento = 'C' 
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) as SaldoMonLoc
			from HEContables E
			inner join HDContables D on E.IDcontable = D.IDcontable
			where E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and E.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and E.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC') 
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">
			and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResumenIngyGasto.cuenta#"> 
			and Ddescripcion like '%Cuenta Resumen Ingresos y Gastos%'
		</cfquery>
				
		<cfloop query="rsImpPoliza">
			<cfif rsImpPoliza.SaldoMonOri LT 0> 		
				<cfset LvarDocBase		= "CIERRE #Arguments.PerCierre#/#numberFormat(Arguments.MesCierre,"00")##rsCuentaAhorro.cuenta#">
			<cfelse>
				<cfset LvarDocBase		= "CIERRE #Arguments.PerCierre#/#numberFormat(Arguments.MesCierre,"00")##rsCuentaDesahorro.cuenta#">
			</cfif>
			
			<cfquery name="rsInsertIngyGasto" datasource="#Arguments.Conexion#">
				insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
				values (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Resumen Ingresos y Gastos #rsCuentaResumenIngyGasto.cuenta#',
						'#LvarDocBase#',
						'#LvarDocRef#',
						#rsCuentaResumenIngyGasto.cuenta#, 
						<cfif (#rsImpPoliza.SaldoMonOri# * -1) LT 0>
							'C',
						<cfelse>
							'D',
						</cfif> 
						abs(#rsImpPoliza.SaldoMonOri#),
						abs(#rsImpPoliza.SaldoMonLoc#), 
						#rsImpPoliza.Mcodigo#,
						0.00,
						'?', '?', 0)
			</cfquery>
			
			<cfquery name="rsInsertAhorroDesahorro" datasource="#Arguments.Conexion#">
				insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
				values  (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza.Ocodigo#, 
						<cfif rsSaldoCta.SaldoMonLoc LT 0 >
							'#LvarDescripcion#: Cuenta Ahorro de la Gestion #rsCuentaAhorro.cuenta#', 							
						<cfelse>
							'#LvarDescripcion#: Cuenta Desahorro de la Gestion #rsCuentaDesahorro.cuenta#', 
						</cfif>	
						'#LvarDocBase#',
						'#LvarDocRef#',
						<cfif rsSaldoCta.SaldoMonLoc LT 0>
							#rsCuentaAhorro.cuenta#,
						<cfelse>
							#rsCuentaDesahorro.cuenta#,
						</cfif>
						<cfif rsImpPoliza.SaldoMonOri LT 0> 
							'C', 
						<cfelse>
							'D', 
						</cfif>
						abs(#rsImpPoliza.SaldoMonOri#),
						abs(#rsImpPoliza.SaldoMonLoc#), 
						#rsImpPoliza.Mcodigo#,
						0.00,
						'?', '?', 0)						
			</cfquery>			
		</cfloop>
		
		<cfquery name="verificaINTARC" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad 
			from #Intarc#
			where INTMOE <> 0.00 or INTMON <> 0.00
		</cfquery>

		<cfif verificaINTARC.Cantidad GT 0>
			<cfif Arguments.abrirTrans>
				<cftransaction>
						<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
							<cfinvokeargument name="Oorigen"		value="#LvarOorigen#">
							<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
							<cfinvokeargument name="Eperiodo"		value="#Arguments.PerCierre#">
							<cfinvokeargument name="Emes"			value="#Arguments.MesCierre#">
							<cfinvokeargument name="Efecha"			value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Arguments.PerCierre, Arguments.MesCierre, 1)))#">
							<cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#:  Póliza Ahorro/Desahorro">
							<cfinvokeargument name="Edocbase"		value="#LvarDocBase#">
							<cfinvokeargument name="Ereferencia"	value="#LvarDocRef#">
							<cfinvokeargument name="interfazconta"	value="true">
							<cfinvokeargument name="debug"			value="false">
							<cfinvokeargument name="CierreAnual"	value="true">
						</cfinvoke>	
	
						<cfquery name="updEContable" datasource="#Arguments.Conexion#">
							update EContables
							   set ECtipo = #Arguments.TipoCierre#
							 where IDcontable = #IDcontable#
						</cfquery>
					</cftransaction>
			<cfelse>
					<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
						<cfinvokeargument name="Oorigen"		value="#LvarOorigen#">
						<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
						<cfinvokeargument name="Eperiodo"		value="#Arguments.PerCierre#">
						<cfinvokeargument name="Emes"			value="#Arguments.MesCierre#">
						<cfinvokeargument name="Efecha"			value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Arguments.PerCierre, Arguments.MesCierre, 1)))#">
						<cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#: Póliza Ahorro/Desahorro">
						<cfinvokeargument name="Edocbase"		value="#LvarDocBase#">
						<cfinvokeargument name="Ereferencia"	value="#LvarDocRef#">
						<cfinvokeargument name="interfazconta"	value="true">
						<cfinvokeargument name="debug"			value="false">
						<cfinvokeargument name="CierreAnual"	value="true">
					</cfinvoke>	

					<cfquery name="updEContable" datasource="#Arguments.Conexion#">
						update EContables;;;
						   set ECtipo = #Arguments.TipoCierre#
						 where IDcontable = #IDcontable#
					</cfquery>
			</cfif>	
			<cfinvoke component="CG_AplicaAsiento"  method="CG_AplicaAsiento">
				<cfinvokeargument name="IDcontable" value="#IDcontable#">
				<cfinvokeargument name="CtlTransaccion" value="true">
			</cfinvoke>
		</cfif>				
	</cffunction>
	
	<cffunction name="sbGeneraPolizaUtilidaEjercicio" access="public" output="false"> 
		<cfargument name="Ecodigo"		type="numeric" required="yes">
		<cfargument name="TipoCierre"	type="numeric" required="yes">
		<cfargument name="PerCierre"	type="numeric" required="yes">
		<cfargument name="MesCierre"	type="numeric" required="yes">		
		<cfargument name="PerNuevo"	type="numeric" required="yes">
		<cfargument name="MesNuevo"	type="numeric" required="yes">
		<cfargument name="Conexion"		type="string" required="yes">
		<cfargument name="LvarDescripcion" type="string" required="yes">
		<cfargument name="LvarDocRef" type="string" required="yes">
		<cfargument name="LvarOorigen" type="string" required="yes">	
		<cfargument name="abrirTrans" type="boolean" default="yes">	
		
		<cfif Arguments.TipoCierre EQ 1>
			<cfset LvarDescripcion	= "Cierre Anual">
			<cfset LvarDocRef		= "CIERRE FISCAL">
			<cfset LvarOorigen 		= "CGCF">
		<cfelseif Arguments.TipoCierre EQ 11>
			<cfset LvarDescripcion	= "Cierre Anual Corporativo">
			<cfset LvarDocRef		= "CIERRE CORPORATIVO">
			<cfset LvarOorigen 		= "CGCC">
		<cfelse>
			<cfthrow message="Tipo de Cierre Anual Incorrecto (1=Fiscal,11=Corporativo): #Arguments.TipoCierre#">
		</cfif>
			
		<!----Obtiene los saldos de la Cuenta de Resumen de Ingresos y Gastos---->
		<cfquery name="rsImpPoliza1" datasource="#Arguments.Conexion#">
			select distinct Mcodigo, D.Ocodigo, D.Ccuenta,
				(select isnull(SUM(Doriginal),0),HD.CFid from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#">
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaDesahorro.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaAhorro.cuenta#">) and Dmovimiento = 'D' and Mcodigo = D.Mcodigo 									            
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) -
				(select isnull(SUM(Doriginal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaDesahorro.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaAhorro.cuenta#">) and Dmovimiento = 'C' and Mcodigo = D.Mcodigo 						 			
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) as SaldoMonOri,
				(select isnull(SUM(Dlocal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaDesahorro.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaAhorro.cuenta#">) and Dmovimiento = 'D' and Mcodigo = D.Mcodigo 					 			
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) -
				(select isnull(SUM(Dlocal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaDesahorro.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaAhorro.cuenta#">) and Dmovimiento = 'C' and Mcodigo = D.Mcodigo 			 			
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) as SaldoMonLoc
			from HEContables E
			inner join HDContables D on E.IDcontable = D.IDcontable
			where E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and E.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and E.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC') 
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaDesahorro.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaAhorro.cuenta#">) 		
			and (Ddescripcion like '%Ahorro de la Gestion%' or Ddescripcion like '%Desahorro de la Gestion%')	
		</cfquery>
		
		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>
		
		<cfloop query="rsImpPoliza1">	
			<cfset LvarDocBase		= "CIERRE #Arguments.PerCierre#/#numberFormat(Arguments.MesCierre,"00")##rsCuentaUtilidad.cuenta#">
	
			<cfif rsImpPoliza1.Ccuenta EQ #rsCuentaAhorro.cuenta# and rsImpPoliza1.SaldoMonOri NEQ 0>
				<cfquery name="rsInsertAhorro" datasource="#Arguments.Conexion#">
					insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL,CFid)
					values	(#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza1.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Ahorro de la Gestion #rsCuentaAhorro.cuenta#',
						'#LvarDocBase#',
						'#LvarDocRef#',
						#rsCuentaAhorro.cuenta#, <!---si el monto en MO * -1 LT 0 then C else D--->
                        <cfif (#rsImpPoliza1.SaldoMonOri# * -1) LT 0>
                        	'C',
                        <cfelse>
                        	'D',
                        </cfif> 
						abs(#rsImpPoliza1.SaldoMonOri#),
						abs(#rsImpPoliza1.SaldoMonLoc#), 
						#rsImpPoliza1.Mcodigo#,
						0.00,
						'?', '?', 0,#rsImpPoliza1.CFid#)
				</cfquery>
			
				<cfquery name="rsInsertUtilidad1" datasource="#Arguments.Conexion#">
					insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL,CFid)
					values (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza1.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Resultados del Ejercicio Utilidad #rsCuentaResulUtilidad.cuenta#',
						'#LvarDocBase#',
						'#LvarDocRef#',   
						#
						rsCuentaResulUtilidad.cuenta#,    <!---si el monto en MO LT 0 then C else D--->
                        <cfif rsImpPoliza1.SaldoMonOri LT 0>
							'C', 
                        <cfelse>
                        	'D',
                        </cfif>
						abs(#rsImpPoliza1.SaldoMonOri#),
						abs(#rsImpPoliza1.SaldoMonLoc#), 
						#rsImpPoliza1.Mcodigo#,
						0.00,
						'?', '?', 0,#rsImpPoliza1.CFid#)
				</cfquery>
			
			<cfelseif rsImpPoliza1.Ccuenta EQ #rsCuentaDesahorro.cuenta# and rsImpPoliza1.SaldoMonOri NEQ 0>
					
				<cfquery name="rsInsertDesahorro" datasource="#Arguments.Conexion#">
					insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL,CFid)
					values (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza1.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Desahorro de la Gestion #rsCuentadesahorro.cuenta#',
						'#LvarDocBase#',
						'#LvarDocRef#',
						#rsCuentadesahorro.cuenta#,
                        <cfif (#rsImpPoliza1.SaldoMonOri# * -1) LT 0>
							'C', 
                        <cfelse>
                        	'D',
                        </cfif>
						abs(#rsImpPoliza1.SaldoMonOri#),
						abs(#rsImpPoliza1.SaldoMonLoc#), 
						#rsImpPoliza1.Mcodigo#,
						0.00,
						'?', '?', 0,#rsImpPoliza1.CFid#)
				</cfquery>			
			
				<cfquery name="rsInsertUtilidad2" datasource="#Arguments.Conexion#">
					insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL,CFid)
					values (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza1.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Resultados del Ejercicio Perdida #rsCuentaResulPerdida.cuenta#',
						'#LvarDocBase#',
						'#LvarDocRef#',
						#rsCuentaResulPerdida.cuenta#,
                        <cfif rsImpPoliza1.SaldoMonOri LT 0>
                         	'C',
                        <cfelse>
                        	'D', 
                        </cfif>
						abs(#rsImpPoliza1.SaldoMonOri#),
						abs(#rsImpPoliza1.SaldoMonLoc#), 
						#rsImpPoliza1.Mcodigo#,
						0.00,
						'?', '?', 0,#rsImpPoliza1.CFid#)
				</cfquery>	
			</cfif>
		</cfloop>
		
		<cfquery name="verificaINTARC" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad 
			from #Intarc#
			where INTMOE <> 0.00 or INTMON <> 0.00
		</cfquery>

		<cfif verificaINTARC.Cantidad GT 0>
			<cfif Arguments.abrirTrans>
				<cftransaction>
						<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
							<cfinvokeargument name="Oorigen"		value="#LvarOorigen#">
							<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
							<cfinvokeargument name="Eperiodo"		value="#Arguments.PerCierre#">
							<cfinvokeargument name="Emes"			value="#Arguments.MesCierre#">
							<cfinvokeargument name="Efecha"			value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Arguments.PerCierre, Arguments.MesCierre, 1)))#">
							<cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#:  Póliza Utilidad del Ejercicio">
							<cfinvokeargument name="Edocbase"		value="#LvarDocBase#">
							<cfinvokeargument name="Ereferencia"	value="#LvarDocRef#">
							<cfinvokeargument name="interfazconta"	value="true">
							<cfinvokeargument name="debug"			value="false">
							<cfinvokeargument name="CierreAnual"	value="true">
						</cfinvoke>	
	
						<cfquery name="updEContable" datasource="#Arguments.Conexion#">
							update EContables
							   set ECtipo = #Arguments.TipoCierre#
							 where IDcontable = #IDcontable#
						</cfquery>
					</cftransaction>
			<cfelse>
					<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
						<cfinvokeargument name="Oorigen"		value="#LvarOorigen#">
						<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
						<cfinvokeargument name="Eperiodo"		value="#Arguments.PerCierre#">
						<cfinvokeargument name="Emes"			value="#Arguments.MesCierre#">
						<cfinvokeargument name="Efecha"			value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Arguments.PerCierre, Arguments.MesCierre, 1)))#">
						<cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#: Póliza Utilidad del Ejercicio">
						<cfinvokeargument name="Edocbase"		value="#LvarDocBase#">
						<cfinvokeargument name="Ereferencia"	value="#LvarDocRef#">
						<cfinvokeargument name="interfazconta"	value="true">
						<cfinvokeargument name="debug"			value="false">
						<cfinvokeargument name="CierreAnual"	value="true">
					</cfinvoke>	

					<cfquery name="updEContable" datasource="#Arguments.Conexion#">
						update EContables
						   set ECtipo = #Arguments.TipoCierre#
						 where IDcontable = #IDcontable#
					</cfquery>
			</cfif>	
			<cfinvoke component="CG_AplicaAsiento"  method="CG_AplicaAsiento">
				<cfinvokeargument name="IDcontable" value="#IDcontable#">
				<cfinvokeargument name="CtlTransaccion" value="true">
			</cfinvoke>
		</cfif>				
	</cffunction>
	
	<cffunction name="sbGeneraPolizaResultEjerciciosAnt" access="public" output="false"> 
		<cfargument name="Ecodigo"		type="numeric" required="yes">
		<cfargument name="TipoCierre"	type="numeric" required="yes">
		<cfargument name="PerCierre"	type="numeric" required="yes">
		<cfargument name="MesCierre"	type="numeric" required="yes">		
		<cfargument name="PerNuevo"	type="numeric" required="yes">
		<cfargument name="MesNuevo"	type="numeric" required="yes">
		<cfargument name="Conexion"		type="string" required="yes">
		<cfargument name="LvarDescripcion" type="string" required="yes">
		<cfargument name="LvarDocRef" type="string" required="yes">
		<cfargument name="LvarOorigen" type="string" required="yes">	
		<cfargument name="abrirTrans" type="boolean" default="yes">		
		
			
		<cfif Arguments.TipoCierre EQ 1>
			<cfset LvarDescripcion	= "Cierre Anual">
			<cfset LvarDocRef		= "CIERRE FISCAL">
			<cfset LvarOorigen 		= "CGCF">
		<cfelseif Arguments.TipoCierre EQ 11>
			<cfset LvarDescripcion	= "Cierre Anual Corporativo">
			<cfset LvarDocRef		= "CIERRE CORPORATIVO">
			<cfset LvarOorigen 		= "CGCC">
		<cfelse>
			<cfthrow message="Tipo de Cierre Anual Incorrecto (1=Fiscal,11=Corporativo): #Arguments.TipoCierre#">
		</cfif>
			
		<!----Obtiene los saldos de la Cuenta de Resumen de Ingresos y Gastos---->
		<cfquery name="rsImpPoliza2" datasource="#Arguments.Conexion#">
			select distinct Mcodigo, D.Ocodigo, D.Ccuenta,
				(select isnull(SUM(Doriginal),0),HD.CFid from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#">
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulUtilidad.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulPerdida.cuenta#">) and Dmovimiento = 'D' and Mcodigo = D.Mcodigo 
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) -
				(select isnull(SUM(Doriginal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulUtilidad.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulPerdida.cuenta#">)  and Dmovimiento = 'C' and Mcodigo = D.Mcodigo 						 			
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) as SaldoMonOri,
				(select isnull(SUM(Dlocal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulUtilidad.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulPerdida.cuenta#">) 	 and Dmovimiento = 'D' and Mcodigo = D.Mcodigo 					 			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) -
				(select isnull(SUM(Dlocal),0) from HEContables HE
			inner join HDContables HD on HE.IDcontable = HD.IDcontable
			where HE.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and HE.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and HE.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC')
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulUtilidad.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulPerdida.cuenta#">) and Dmovimiento = 'C' and Mcodigo = D.Mcodigo 			 			
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">) as SaldoMonLoc
			from HEContables E
			inner join HDContables D on E.IDcontable = D.IDcontable
			where E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and E.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerCierre#"> 
			and E.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesCierre#"> and Oorigen in ('CGCF', 'CGCC') 
			and ECtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TipoCierre#">
			<!---and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaUtilidad.cuenta#"> 
			and Ddescripcion like '%Utilidad del Ejercicio%'--->
			and Ccuenta in (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulUtilidad.cuenta#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentaResulPerdida.cuenta#">) 		
			and Ddescripcion like '%Cuenta Resultados del Ejercicio%'
		</cfquery>
				
 		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>
		
		<cfloop query="rsImpPoliza2">		
			<cfset LvarDocBase		= "CIERRE #Arguments.PerCierre#/#numberFormat(Arguments.MesCierre,"00")##rsCuentaPerAnt.cuenta#">
				
			<cfif rsImpPoliza2.Ccuenta EQ #rsCuentaResulUtilidad.cuenta# and rsImpPoliza2.SaldoMonOri NEQ 0>
				<cfquery name="rsInsertResulUtilidad" datasource="#Arguments.Conexion#">
					insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL,CFid)
				values (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza2.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Resultados del Ejercicio Utilidad #rsCuentaResulUtilidad.cuenta#',
						'#LvarDocBase#',
						'#LvarDocRef#',
						#rsCuentaResulUtilidad.cuenta#, 
                        <cfif (#rsImpPoliza2.SaldoMonOri# * -1) LT 0>
                        	'C',
                        <cfelse>
							'D',
                        </cfif>
						abs(#rsImpPoliza2.SaldoMonOri#),
						abs(#rsImpPoliza2.SaldoMonLoc#), 
						#rsImpPoliza2.Mcodigo#,
						0.00,
						'?', '?', 0,#rsImpPoliza2.CFid#)
				</cfquery>
				
				<cfquery name="rsInsertEjerciciosAnt" datasource="#Arguments.Conexion#">
					insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL,CFid)
				values  (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza2.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Resultado de Ejercicios Anteriores #rsCuentaPerAnt.cuenta#', 							
						'#LvarDocBase#',
						'#LvarDocRef#',
						#rsCuentaPerAnt.cuenta#,
                        <cfif rsImpPoliza2.SaldoMonOri LT 0>
							'C',
                        <cfelse>
                        	'D',
                        </cfif>
						abs(#rsImpPoliza2.SaldoMonOri#),
						abs(#rsImpPoliza2.SaldoMonLoc#), 
						#rsImpPoliza2.Mcodigo#,
						0.00,
						'?', '?', 0,#rsImpPoliza2.CFid#)						
				</cfquery>	
			
			<cfelseif rsImpPoliza2.Ccuenta EQ #rsCuentaResulPerdida.cuenta# and rsImpPoliza2.SaldoMonOri NEQ 0>
			
				<cfquery name="rsInsertResulPerdida" datasource="#Arguments.Conexion#">
					insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL, CFid)
				values (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza2.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Resultados del Ejercicio Perdida #rsCuentaResulPerdida.cuenta#',
						'#LvarDocBase#',
						'#LvarDocRef#',
						#rsCuentaResulPerdida.cuenta#,
                        <cfif (#rsImpPoliza2.SaldoMonOri# * -1) LT 0> 
							'C',
                        <cfelse>
                        	'D',
                        </cfif>    
						abs(#rsImpPoliza2.SaldoMonOri#),
						abs(#rsImpPoliza2.SaldoMonLoc#), 
						#rsImpPoliza2.Mcodigo#,
						0.00,
						'?', '?', 0,#rsImpPoliza2.CFid#)
				</cfquery>
				
				<cfquery name="rsInsertEjerciciosAnt" datasource="#Arguments.Conexion#">
					insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, Ccuenta, INTTIP, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL,CFid)
				values  (#Arguments.PerCierre#,
						#Arguments.MesCierre#,
						#rsImpPoliza2.Ocodigo#, 
						'#LvarDescripcion#: Cuenta Resultado de Ejercicios Anteriores #rsCuentaPerAnt.cuenta#', 							
						'#LvarDocBase#',
						'#LvarDocRef#',
						#rsCuentaPerAnt.cuenta#,
                        <cfif rsImpPoliza2.SaldoMonOri LT 0>
                        	'C',
                        <cfelse>
							'D',
                        </cfif>
						abs(#rsImpPoliza2.SaldoMonOri#),
						abs(#rsImpPoliza2.SaldoMonLoc#), 
						#rsImpPoliza2.Mcodigo#,
						0.00,
						'?', '?', 0,#rsImpPoliza2.CFid#)						
				</cfquery>
			</cfif>		
		</cfloop>
		
		<cfquery name="verificaINTARC" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad 
			from #Intarc#
			where INTMOE <> 0.00 or INTMON <> 0.00
		</cfquery>

		<cfif verificaINTARC.Cantidad GT 0>
			<cfif Arguments.abrirTrans>
				<cftransaction>
						<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
							<cfinvokeargument name="Oorigen"		value="#LvarOorigen#">
							<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
							<cfinvokeargument name="Eperiodo"		value="#Arguments.PerCierre#">
							<cfinvokeargument name="Emes"			value="#Arguments.MesCierre#">
							<cfinvokeargument name="Efecha"			value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Arguments.PerCierre, Arguments.MesCierre, 1)))#">
							<cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#:  Póliza Ejercicios de Años Anteriores">
							<cfinvokeargument name="Edocbase"		value="#LvarDocBase#">
							<cfinvokeargument name="Ereferencia"	value="#LvarDocRef#">
							<cfinvokeargument name="interfazconta"	value="true">
							<cfinvokeargument name="debug"			value="false">
							<cfinvokeargument name="CierreAnual"	value="true">
						</cfinvoke>	
	
						<cfquery name="updEContable" datasource="#Arguments.Conexion#">
							update EContables
							   set ECtipo = #Arguments.TipoCierre#
							 where IDcontable = #IDcontable#
						</cfquery>
					</cftransaction>
			<cfelse>
					<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
						<cfinvokeargument name="Oorigen"		value="#LvarOorigen#">
						<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
						<cfinvokeargument name="Eperiodo"		value="#Arguments.PerCierre#">
						<cfinvokeargument name="Emes"			value="#Arguments.MesCierre#">
						<cfinvokeargument name="Efecha"			value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Arguments.PerCierre, Arguments.MesCierre, 1)))#">
						<cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#: Póliza Ejercicios de Años Anteriores">
						<cfinvokeargument name="Edocbase"		value="#LvarDocBase#">
						<cfinvokeargument name="Ereferencia"	value="#LvarDocRef#">
						<cfinvokeargument name="interfazconta"	value="true">
						<cfinvokeargument name="debug"			value="false">
						<cfinvokeargument name="CierreAnual"	value="true">
					</cfinvoke>	

					<cfquery name="updEContable" datasource="#Arguments.Conexion#">
						update EContables
						   set ECtipo = #Arguments.TipoCierre#
						 where IDcontable = #IDcontable#
					</cfquery>
			</cfif>	
				
			<cfinvoke component="CG_AplicaAsiento"  method="CG_AplicaAsiento">
				<cfinvokeargument name="IDcontable" value="#IDcontable#">
				<cfinvokeargument name="CtlTransaccion" value="true">
			</cfinvoke>
		</cfif>		
	</cffunction>
	
</cfcomponent>

<!---
MAYORIZAR PAPAS:
update SaldosContables
   set SOinicialGE = (select sum(SOinicialGE) from SaldosContables ss
						inner join PCDCatalogoCuenta cb on cb.Ccuenta = ss.Ccuenta and cb.Ccuentaniv=s.Ccuenta
						where ss.Ecodigo=s.Ecodigo and ss.Ocodigo=s.Ocodigo and ss.Mcodigo=s.Mcodigo and ss.Speriodo=s.Speriodo and ss.Smes=s.Smes 
						)
  from SaldosContables s
 where s.Ecodigo=35	
   and SOinicialGE <> (select sum(SOinicialGE) from SaldosContables ss
						inner join PCDCatalogoCuenta cb on cb.Ccuenta = ss.Ccuenta and cb.Ccuentaniv=s.Ccuenta
						where ss.Ecodigo=s.Ecodigo and ss.Ocodigo=s.Ocodigo and ss.Mcodigo=s.Mcodigo and ss.Speriodo=s.Speriodo and ss.Smes=s.Smes 
						)

update SaldosContables
   set SLinicialGE = (select sum(SLinicialGE) from SaldosContables ss
						inner join PCDCatalogoCuenta cb on cb.Ccuenta = ss.Ccuenta and cb.Ccuentaniv=s.Ccuenta
						where ss.Ecodigo=s.Ecodigo and ss.Ocodigo=s.Ocodigo and ss.Mcodigo=s.Mcodigo and ss.Speriodo=s.Speriodo and ss.Smes=s.Smes 
						)
  from SaldosContables s
 where s.Ecodigo=35	
   and SLinicialGE <> (select sum(SLinicialGE) from SaldosContables ss
						inner join PCDCatalogoCuenta cb on cb.Ccuenta = ss.Ccuenta and cb.Ccuentaniv=s.Ccuenta
						where ss.Ecodigo=s.Ecodigo and ss.Ocodigo=s.Ocodigo and ss.Mcodigo=s.Mcodigo and ss.Speriodo=s.Speriodo and ss.Smes=s.Smes 
						)
--->