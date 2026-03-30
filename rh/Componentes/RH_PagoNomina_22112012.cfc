
<cfcomponent>
	<cffunction name="rh_HistoricosNomina" access="public" returntype="void">
		<cfargument name="ERNid" 	type="numeric" 	required="true">
		<cfargument name="debug" 	type="string" 	required="false" default="N">
		
		<cfif Arguments.debug EQ "S">
			<cfset LvarDebug = "S">
		</cfif>
		
		<cfset LvarDebug = "N">
		<!---
			** Pasa a Historicos todos los Registros Relacionados con una Nómina
			
			** Se modifican las estructuras de datos históricas del módulo de recepción de pagos
			** Este proceso no debe ejecutarse dentro de una transacción de Base de Datos
			** pues se controla la ejecución de ésta dentro del procedimiento
			**
			** Este proceso es invocado directamente desde la aplicación.  
			** Se invocan los siguientes procedimientos almacenados:
			**			rh_ContabilizaNomina:  Contabiliza la nomina si se define la interfaz 
			**			rh_HistoricoRCalculo:  afecta las estructuras de datos del sistema de nomina RH
			**
			** Creado por: Dorian Abarca
			** Fecha: 8/9/2003
			** Modificado: Mauricio Esquivel
			** Fecha: 15/07/2004
			** Motivo:  Mejorar la utilización de transacciones atómicas con su respectivo control
			
			** Convertido a Coldfusion por Ing. Óscar Bonilla
			** Fecha: 15/DIC/2005
		--->

        <!--- Validaciones --->
		
        <!--- 
			Ejecuta Store Procedure Sybase
			Hay batchs de varias instrucciones
			Se utiliza Delete From
			Se utiliza convert(...)
		--->
		
		<!--- Usa Interfaz con Contabilidad [Parametro 20] --->
		<cfset vInterfazContable = false >
		<cfquery name="usaConta" datasource="#session.DSN#">
			select Pvalor 
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 20
		</cfquery>
		<cfif usaConta.recordcount gt 0 and usaConta.Pvalor eq 1>
			<cfset vInterfazContable = true >
		</cfif>

		<!--- Validar Planilla Presupuestaria [Parametro 540] --->
		<cfset vValidaPresupuesto = false >	
		<cfquery name="validaPP" datasource="#session.DSN#">
			select Pvalor 
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 540
		</cfquery>
		<cfif validaPP.recordcount gt 0 and validaPP.Pvalor eq 1>
			<cfset vValidaPresupuesto = true >
		</cfif>
		
		<cfquery name="rsSQL" datasource="#session.DSN#">
        	select HERNestado
			  from HERNomina
			 where ERNid = #Arguments.ERNid#
		</cfquery>
		<!--- Si el estado esta en 9 significa que ya terminó todo el proceso y falló en el último delete --->
		<cfif rsSQL.HERNestado NEQ "9">
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select count(1) as cantidad 
				  from DRNomina 
				 where ERNid = #Arguments.ERNid# 
				   and DRNestado = 3
			</cfquery>
			<cfif rsSQL.cantidad GT 0>
				<cfthrow message =  "ERROR: La relación todavía tiene personas en estado Pendiente de Pago. Proceso Cancelado!">
			</cfif>
	
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select RCNid 
				  from ERNomina 
				 where ERNid = #Arguments.ERNid#
			</cfquery>
			
			<cfset LvarRCNid = rsSQL.RCNid>
			
			<cfif vValidaPresupuesto or vInterfazContable>
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select count(1) as cantidad 
					  from RCuentasTipo 
					 where RCNid = #LvarRCNid# 
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfthrow message =  "ERROR: La relación debe volverse a calcular. Proceso Cancelado!">
				</cfif>
			</cfif>

			<cfquery name="rsSQL" datasource="#session.DSN#">
				select count(1) as cantidad
				  from HERNomina
				 where ERNid = #Arguments.ERNid#
			</cfquery>
			
			<cfif rsSQL.cantidad EQ 0>
				<!--- Inicio del proceso de llenado de tablas históricas de Nóminas en Proceso de Pago --->
				<cftransaction>
					<!--- CREA LOS DIFERENTES DOCUMENTOS A CONTABILIZAR siempre que no existan ya --->
					<cfquery datasource="#session.DSN#">
						insert into RHEjecucion
							(
								RCNid, Ecodigo, RHEnumero, Periodo, Mes
							)
						select distinct RCNid, Ecodigo, null, Periodo, Mes
						  from RCuentasTipo c
						 where RCNid = #LvarRCNid#
						   and not exists
								(
									select 1
									  from RHEjecucion e
									 where e.RCNid 	 = c.RCNid
									   and e.Periodo = c.Periodo
									   and e.Mes	 = c.Mes
								)
					</cfquery>
					
 					<cfquery name="rsSQL" datasource="#session.DSN#">
						select coalesce(max(RHEnumero),0) as Maximo
						from RHEjecucion
						where Ecodigo = #session.Ecodigo#
					</cfquery>
					
 					<cfquery name="rsSQL" datasource="#session.DSN#">
						select #rsSQL.Maximo# + count(1) as Numero
						from RHEjecucion a, RHEjecucion b
						where a.RCNid = b.RCNid
							and a.Periodo * 100 + a.Mes <= b.Periodo * 100 + b.Mes
							and b.RCNid = #LvarRCNid#
							and b.RHEnumero is null
					</cfquery>
					
 					<cfquery datasource="#session.DSN#">
						update RHEjecucion
						set RHEnumero = #rsSQL.Numero#
						where RCNid = #LvarRCNid#
							and RHEnumero is null
					</cfquery>
				</cftransaction>
		
				<cftransaction>
					<!--- Encabezado --->
					<cfquery datasource="#session.DSN#">
						insert into HERNomina 
							(
								Bid, ERNid, Ecodigo,
								Tcodigo, HERNfcarga, HERNfdeposito, HERNfinicio,
								HERNffin, HERNdescripcion, HERNestado, Usucodigo,
								Ulocalizacion, HERNusuverifica, HERNfverifica, HERNusuautoriza,
								HERNfautoriza, HERNfechapago, HERNsistema, CBcc,
								HERNcuenta, CBTcodigo, Mcodigo,
								HERNcapturado, HERNfprogramacion, RCNid, RCtc 
							)
						select
								Bid, ERNid, Ecodigo,
								Tcodigo, ERNfcarga, ERNfdeposito, ERNfinicio,
								ERNffin, ERNdescripcion, ERNestado, Usucodigo,
								Ulocalizacion, ERNusuverifica, ERNfverifica, ERNusuautoriza,
								ERNfautoriza, ERNfechapago, ERNsistema, CBcc,
								ERNcuenta, CBTcodigo, Mcodigo,
								ERNcapturado, ERNfprogramacion, RCNid, RCtc
						  from ERNomina
						 where ERNid = #Arguments.ERNid#
					</cfquery>		
			
					<!--- Detalles --->
					<cfquery datasource="#session.DSN#">
						insert into HDRNomina 
							(
								ERNid, DRNlinea, NTIcodigo,
								HDRIdentificacion, Bid, HDRNcuenta, CBcc,
								CBTcodigo, Mcodigo, HDRNnombre, HDRNapellido1,
								HDRNapellido2, HDRNtipopago, HDRNperiodo, HDRNnumdias,
								HDRNsalbruto, HDRNsaladicional, HDRNreintegro, HDRNrenta,
								HDRNobrero, HDRNpatrono, HDRNotrasdeduc, HDRNliquido,
								HDRNpuesto, HDRNocupacion, HDRNotrospatrono, HDRNfondopen,
								HDRNfondocap, HDRNinclexcl, HDRNfinclexcl, HDRNautorizacion,
								DEid, HDRNmes, HDRNper, HDRNfpago, HDRNestado
							)
						select
								ERNid, DRNlinea, NTIcodigo,
								DRIdentificacion, Bid, DRNcuenta, CBcc,
								CBTcodigo, Mcodigo, DRNnombre, DRNapellido1,
								DRNapellido2, DRNtipopago, DRNperiodo, DRNnumdias,
								DRNsalbruto, DRNsaladicional, DRNreintegro, DRNrenta,
								DRNobrero, DRNpatrono, DRNotrasdeduc, DRNliquido,
								DRNpuesto, DRNocupacion, DRNotrospatrono, DRNfondopen,
								DRNfondocap, DRNinclexcl, DRNfinclexcl, <cf_dbfunction name="to_char" args="DRNlinea">,
								DEid, DRNmes, DRNper, 
								( select ERNfdeposito from ERNomina where ERNid = #Arguments.ERNid# ), 
								DRNestado
						  from DRNomina
						 where ERNid = #Arguments.ERNid#
							<!--- 05/06/2008 --->
							<!--- Cambio solicitado por Juan Carlos Gutierrez y autorizado por Marcel--->
						   	<!--- and DRNestado = 1 --->
					</cfquery>
		
					<!--- Deducciones --->
					<cfquery datasource="#session.DSN#">
						insert into HDDeducPagos 
							(
								HDDlinea, DRNlinea, Bid, HDDdescripcion, HDDmonto, 
								CBcc, HDDnombre, HDDidbenef, HDDpago, HDDpagopor, 
								CBTcodigo, Mcodigo, HDDcuenta
							)
						select 
								a.DDlinea, a.DRNlinea, a.Bid, a.DDdescripcion, a.DDmonto, 
								a.CBcc, a.DDnombre, a.DDidbeneficiario, a.DDpago, a.DDpagopor, 
								a.CBTcodigo, a.Mcodigo, a.DDcuenta
						  from DDeducPagos a, DRNomina b
						 where b.ERNid = #Arguments.ERNid#
						   <!---and b.DRNestado = 1--->
						   and a.DRNlinea = b.DRNlinea
					</cfquery>
		
					<!--- Incidencias --->
					<cfquery datasource="#session.DSN#">
						insert into HDRIncidencias 
							(
								DRIid, DRNlinea, CIid, HDRICfecha, HDRICvalor, 
								HDRICfechasis, HDRICcalculo, HDRICbatch, HDRICmontoant, 
								HDRICmontores, Usucodigo, Ulocalizacion
							)
						select 
								a.DRIid, a.DRNlinea, a.CIid, a.ICfecha, a.ICvalor, 
								a.ICfechasis, a.ICcalculo, a.ICbatch, a.ICmontoant, 
								a.ICmontores, a.Usucodigo, a.Ulocalizacion
						  from DRIncidencias a, DRNomina b
						 where b.ERNid = #Arguments.ERNid#
						   <!---and b.DRNestado = 1--->
						   and a.DRNlinea = b.DRNlinea
					</cfquery>
					
					<cfif LvarDebug EQ "S">
						<cfquery name="rsSQL" datasource="#session.DSN#">
							select 
									ERNid, Ecodigo, Tcodigo, RCNid, Bid, CBcc, ERNcuenta, 
									CBTcodigo, Mcodigo, ERNfcarga, ERNfdeposito, ERNfinicio, 
									ERNffin, ERNdescripcion, ERNestado, Usucodigo, Ulocalizacion, 
									ERNusuverifica, ERNfverifica, ERNusuautoriza, ERNfautoriza, 
									ERNfechapago, ERNfprogramacion, ERNsistema,
									ERNcapturado, ERNexportado
							  from ERNomina 
							 where ERNid = #Arguments.ERNid#
						</cfquery>
						<cfdump var="#rsSQL#">
						
						<cfquery name="rsSQL" datasource="#session.DSN#">
							select 
									DRNlinea, ERNid, NTIcodigo, DRIdentificacion, Bid, DEid, 
									DRNcuenta, CBcc, CBTcodigo, Mcodigo, 
									DRNnombre, DRNapellido1, DRNapellido2, DRNtipopago, 
									DRNperiodo, DRNnumdias, DRNsalbruto, DRNsaladicional, 
									DRNreintegro, DRNrenta, DRNobrero, DRNpatrono, 
									DRNotrasdeduc, DRNliquido, DRNpuesto, DRNocupacion, 
									DRNotrospatrono, DRNfondopen, DRNfondocap, DRNinclexcl, DRNfinclexcl, 
									DRNestado, DRNper, DRNmes
							  from DRNomina 
							 where ERNid = #Arguments.ERNid#
						</cfquery>
						<cfdump var="#rsSQL#">									
					</cfif>
				</cftransaction>
				<!--- Conclusión del proceso de llenado de tablas históricas de Nóminas en Proceso de Pago --->
			</cfif>
		
			
			<cfif LvarRCNid NEQ "">
				<cftry>
					<cfset LvarNAP = 0>
					<cfset rh_ContabilizaNomina(LvarRCNid)>

					<cfinvoke component="rh.asoc.Componentes.ACParametros" method="isUsingAsoc" 
							returnvariable="Lvar_UsaAsociacion">
					<cfif Lvar_UsaAsociacion>
						<!--- DESARROLLO HENKEL [27/06/2007]
							  Interfaz con Asociacion: Creditos
							  Este proceso hace lo siguiente:
								1. Trae las deducciones activas que pertenecen a un plan de pagos y 
								   que deben pagarse en esta nomina.
								2. Recupera la informacion necesaria sobre del pago (por ej.: monto cuota)
								3. Actualiza el acumulado de amortizacion del credito
								4. Registra el pago, para el correspondiente registro del plan de pagos
							  Los pasos del 2 al 4 dependen del paso 1, osea de la existencia de datos en 1.
							  Se hace aqui porque el componente siguiente pone el estado de las deducciones asociadasa un plan 
							  como inactivos, entonces la ultima cuot anuc ase va a marcar como pagada.
						--->
						<cfinvoke component="rh.asoc.Componentes.RH_NominaAsociacion" method="interfazCreditos">
							<cfinvokeargument name="RCNid" value="#LvarRCNid#">
						</cfinvoke>
					</cfif>

					<!--- 2. Generar los históricos de la nómina y actualizar las tablas de control --->
					<cfinvoke component="rh.Componentes.RH_HistoricoRCalculo" method="HistoricoRCalculo" returnvariable="vResultado">
						<cfinvokeargument name="conexion"	value="#session.DSN#" >
						<cfinvokeargument name="RCNid"   	value="#LvarRCNid#" >
						<cfinvokeargument name="Ecodigo"	value="#session.Ecodigo#" >
						<cfinvokeargument name="Usucodigo" 	value="#session.Usucodigo#" >
						<cfinvokeargument name="debug" 		value="false" >
					</cfinvoke>	
					<!---
					<cfquery name="rsSQL" datasource="#session.dsn#">
						set nocount on
						declare @error int
						exec @error = rh_HistoricoRCalculo
						  @Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						, @RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">
						, @Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						, @Usulocalizacion = '00'
						, @debug = '#LvarDebug#'
							
						select @error as Retorno
						set nocount off
					</cfquery>
					--->
					
					<cfif vResultado NEQ '3'>
						<cfthrow message =  "ERROR: Ejecutando rh_HistoricoRCalculo. El proceso fue abortado! ">
					</cfif>
					
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select count(1) as cantidad
						  from HRCalculoNomina 
						 where RCNid = #LvarRCNid#
					</cfquery>
					
					<cfif rsSQL.cantidad EQ 0 AND LvarDebug NEQ "S">
						<cfthrow message =  "ERROR: Se está borrando las tablas de trabajo de la Nómina sin que exista esta información en los históricos. El proceso fue abortado! ">
					</cfif>
		
					<!--- Inicio de limpieza de tablas de calculo de nomina si no existen errores --->
					<cfinvoke component="sif.Componentes.PRES_Presupuesto" returnvariable="INT_PRESUPUESTO" method="CreaTablaIntPresupuesto" >
						<cfinvokeargument name="conIdentity" value="true" />
					</cfinvoke>
			
					<cftransaction>
						<cfif vValidaPresupuesto>
							<cfset LvarNAP = rh_EjecucionPresupuestaria(LvarRCNid)>
							<cfif LvarNAP LT 0>
								<!--- Ya hubo rollback --->
								<cfthrow message="NRP">
							</cfif>
						</cfif>
						<!--- VERIFICA EL TIPO DE NOMINA QUE SE ESTA FINALIZANDO 0=NORMAL 2=ANTICIPO --->
						<cfquery datasource="#session.DSN#" name="CalendarioPagos">
							select CPtipo,Tcodigo,CPdesde,CPhasta
							from CalendarioPagos
							where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">
						</cfquery>
						<!--- ************** MODIFICACION PARA CREAR INCIDENCIA DE ANTICIPO *************************** --->
						<!--- SE CREA UNA INCIDENCIA NEGATICA CON FECHA PARA LA SIGUIENTE RELACION
							ESTO PARA QUE SE TOME EN CUENTA EL ANTICIPO QUE SE HIZO
						 --->
						 <!--- TRAE EL CONCEPTO DE PAGO DEFINIDO PARA ANTICIPO DE SALARIO --->
						<cfinvoke component="RHParametros" method="get" datasource="#session.DSN#" ecodigo="#Session.Ecodigo#" pvalor="730" default="" returnvariable="CIidAnticipo"/>
						<cfif CalendarioPagos.CPtipo EQ 2 and Not Len(CIidAnticipo)>
							<cfthrow message="Error!, No se ha definido el Concepto de Pago para Anticipos de Salario a utilizar en los parámetros del Sistema. Proceso Cancelado!!">
						</cfif>
						<cfif CalendarioPagos.CPtipo EQ 2>
							<!--- CREA LA INCIDENCIA PARA REGISTRAR EL ANTICIPO--->
							<!--- BUSCA LA FECHA DESDE DEL SIGUIENTE CALENDARIO DE PAGO --->
							<cfquery name="rsFechaIncidencia" datasource="#session.DSN#">
								select CPhasta as FechaIncidencia
								from CalendarioPagos 
								where Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CalendarioPagos.Tcodigo#">
								  and ((<cfqueryparam cfsqltype="cf_sql_date" value="#CalendarioPagos.CPdesde#"> between CPdesde and CPhasta)
									  and (<cfqueryparam cfsqltype="cf_sql_date" value="#CalendarioPagos.CPhasta#"> between CPdesde and CPhasta))
								  and CPtipo = 0
							</cfquery>
							<cfif isdefined('rsFechaIncidencia') and rsFechaIncidencia.RecordCount EQ 0>
								<cfquery name="rsFechaIncidencia" datasource="#session.DSN#">
									select min(CPdesde) as FechaIncidencia
									from CalendarioPagos
									where Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CalendarioPagos.Tcodigo#">
									  and CPdesde > (select a.CPhasta from CalendarioPagos a where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">)
									  and CPtipo = 0
								</cfquery>
							</cfif>
							<!--- MODIFICACIÓN DEL 01/08/2007 REALIZADA POR ANA VILLAVICENCIO.
								SE MODIFICÓ LA FECHA PARA LA INCIDENCIA PARA EL CASO DE LAS PERSONAS QUE HAN SIDO NOMBRADAS DESPUES
								DE LA FECHA DE INICIO DE LA NÓMINA, CUANDO SE DA ESTE CASO ENTONCES SE PONE LA FECHA DEL NOMBRAMIENTO
								DE LO CONTRARIO LA FECHA DE INICIO DE LA NÓMINA
							 --->
							<cfquery name="rsIncidenciaAnticipo" datasource="#session.DSN#">
								insert into Incidencias(DEid, 
														CIid, 
														Ifecha, 
														Ivalor, 
														Ifechasis, 
														Usucodigo, 
														Ulocalizacion)
									select a.DEid,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidAnticipo#">, 
										case when (select 1 
											from DLaboralesEmpleado dl, RHTipoAccion ta
											where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											  and dl.DEid = a.DEid
											  and dl.RHTid = ta.RHTid
											  and ta.RHTcomportam = 1
											  and dl.DLfvigencia > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CalendarioPagos.CPdesde#">) = 1 
										then (select dl.DLfvigencia
											from DLaboralesEmpleado dl, RHTipoAccion ta
											where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											  and dl.DEid = a.DEid
											  and dl.RHTid = ta.RHTid
											  and ta.RHTcomportam = 1
											  and dl.DLfvigencia > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CalendarioPagos.CPdesde#">) 
										else <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CalendarioPagos.CPdesde#"> end,
										SEliquido,
										getdate(), 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
									from SalarioEmpleado a
									inner join DatosEmpleado de
									   on de.DEid = a.DEid
									  and de.DEporcAnticipo > 0
									  and de.DEporcAnticipo <= 100
									where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">
							</cfquery>
						</cfif>
						<!--- ***************************************** --->


						<!--- 	[10/05/2007]
								Adelanto de aguinaldos:
								Para las NOMINAS ESPECIALES unicamente, se crean incidencias negativas, 
								cada vez que se hace un adelanto de aguinaldo.
								Este query garantiza que el insert se haga solo para nominas especiales y 
								solo para las incidencas especiales, cuya fecha de rebajo no sea nula.
						--->
						<!--- ACTUALIZA LA INCIDENCIA EXISTENTE --->
						<cfquery name="UpdateAdelantos" datasource="#session.DSN#">
							update Incidencias
							set Ivalor = Ivalor + (select Ivalor from DRIncidencias a
										inner join DRNomina b
										on b.DRNlinea = a.DRNlinea
										and b.ERNid = #Arguments.ERNid#
										inner join ERNomina c 
										on c.ERNid=b.ERNid 
										
										inner join IncidenciasCalculo e
										on e.RCNid=c.RCNid
										and e.DEid=b.DEid
										and e.CIid = a.CIid
										
										inner join RCalculoNomina rcn
										on rcn.RCNid=c.RCNid
										and RCpagoentractos = 0
										
										inner join CalendarioPagos cp
										on cp.CPid = rcn.RCNid
										and cp.CPtipo = 1
										
										inner join Incidencias i
										on i.Iid=e.Iid
										and i.Icpespecial=1
										and i.IfechaRebajo is not null
										
										inner join CIncidentes d
										on d.CIid=a.CIid
										where Incidencias.CIid = i.CIid
										  and Incidencias.DEid = i.DEid 
										  and Incidencias.Ifecha = i.IfechaRebajo) *-1
										  
							where exists(select 1 from DRIncidencias a
										inner join DRNomina b
										on b.DRNlinea = a.DRNlinea
										and b.ERNid = #Arguments.ERNid#
										inner join ERNomina c 
										on c.ERNid=b.ERNid 
										
										inner join IncidenciasCalculo e
										on e.RCNid=c.RCNid
										and e.DEid=b.DEid
										and e.CIid = a.CIid
										
										inner join RCalculoNomina rcn
										on rcn.RCNid=c.RCNid
										and RCpagoentractos = 0
										
										inner join CalendarioPagos cp
										on cp.CPid = rcn.RCNid
										and cp.CPtipo = 1
										
										inner join Incidencias i
										on i.Iid=e.Iid
										and i.Icpespecial=1
										and i.IfechaRebajo is not null
										
										inner join CIncidentes d
										on d.CIid=a.CIid
										where Incidencias.CIid = i.CIid
										  and Incidencias.DEid = i.DEid 
										  and Incidencias.Ifecha = i.IfechaRebajo)

						</cfquery>
						<!--- INSERTA LAS INCIDENCIAS DEL ADELANTO CUANDO NO EXISTE --->
						<cfquery datasource="#session.dsn#">
							insert into Incidencias( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, 
													 BMUsucodigo, Iespecial, RCNid, Mcodigo, RHJid, Imonto, Icpespecial )
							select b.DEid, 
								   a.CIid, 
								   i.CFid,
								   i.IfechaRebajo,
								   i.Ivalor*-1,
								   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
								   i.Ulocalizacion,
								   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
								   i.Iespecial,
								   i.RCNid,
								   i.Mcodigo,
								   i.RHJid,
								   i.Imonto,
								   i.Icpespecial
							 
							from DRIncidencias a
							
							inner join DRNomina b
							on b.DRNlinea = a.DRNlinea
							and b.ERNid = #Arguments.ERNid#
							
							inner join ERNomina c 
							on c.ERNid=b.ERNid 
							
							inner join IncidenciasCalculo e
							on e.RCNid=c.RCNid
							and e.DEid=b.DEid
							and e.CIid = a.CIid
							
							inner join RCalculoNomina rcn
							on rcn.RCNid=c.RCNid
							and RCpagoentractos = 0
							
							inner join CalendarioPagos cp
							on cp.CPid = rcn.RCNid
							and cp.CPtipo = 1
							
							inner join Incidencias i
							on i.Iid=e.Iid
							and i.Icpespecial=1
							and i.IfechaRebajo is not null
							
							inner join CIncidentes d
							on d.CIid=a.CIid
							
							where not exists(select 1 from Incidencias ic where ic.DEid = b.DEid and ic.CIid = a.CIid and ic.Ifecha = i.IfechaRebajo)
						</cfquery>
						
						<!--- -------------------------------------------- --->

						<!--- [15/05/2007]
							  Pago de Aguinaldo en dos tractos.	
							  Se insertan incidencias por el monto restante a pagar del aguinaldo en su segundo tracto.
							  Ej: si el aguinaldo es de 100,000.00 y en un primer pago se paga un 70% (70,000.00), aqui se van a insertar incidencias
							  por un 30% (30,000.00).
							  Estas incidencias se van a procesar para la siguiente nomina, que deberia corresponder al segundo tracto del aguinaldo.
						--->
						<cfquery datasource="#session.dsn#">
							insert into Incidencias( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, 
													 Ulocalizacion, BMUsucodigo, Iespecial, Imonto, Icpespecial )
							select 	ic.DEid, 
								 	ic.CIid, 
									( select CFid from Incidencias where DEid = ic.DEid and RCNid = ic.RCNid ), 
									( 	select min(cp.CPfpago)
										from CalendarioPagos cp 
										where cp.Tcodigo=(select Tcodigo from ERNomina where ERNid=#Arguments.ERNid#)
										and cp.CPtipo = 1
										and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and cp.CPfpago > ( select CPfpago
														from CalendarioPagos
														where Ecodigo = cp.Ecodigo
														  and CPtipo = 1
														  and Tcodigo = cp.Tcodigo
														  and CPid = ( select RCNid from ERNomina where ERNid=#Arguments.ERNid# ) ) 
														  and not exists ( select 1
																			from RCalculoNomina h
																			where cp.Ecodigo = h.Ecodigo
																			and cp.Tcodigo = h.Tcodigo
																			and cp.CPdesde = h.RCdesde
																			and cp.CPhasta = h.RChasta
																			and cp.CPid = h.RCNid
																		)
														   and not exists ( select 1
																			from HERNomina i
																			where cp.Tcodigo = i.Tcodigo
																			and cp.Ecodigo = i.Ecodigo
																			and cp.CPdesde = i.HERNfinicio
																			and cp.CPhasta = i.HERNffin
																			and cp.CPid = i.RCNid
																		)
														  ),
									ic.ICvalor*-1, 
									<cfqueryparam cfsqltype="cf_sql_date" value="#now()#" >, 
									#session.usucodigo#, 
								   	'00', 
									#session.usucodigo#, 
									0, 
									ic.ICvalor*-1, 
									1
							from IncidenciasCalculo ic
							where ic.RCNid=( select RCNid from ERNomina where ERNid=#Arguments.ERNid# ) 
							and ic.CIid=( select rcn.CIid 
										  from ERNomina ern
							
										  inner join RCalculoNomina rcn
										  on rcn.RCNid=ern.RCNid
							
										  where ern.ERNid=#Arguments.ERNid#  )
							and ic.ICvalor < 0
						</cfquery>
						<!--- -------------------------------------------- --->

						<!--- DESARROLLO HENKEL, ACTUALIZA RHCMCONTROLSEMANAL --->
						<!--- Datos Séptimo y Q250 --->
						<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo" 
								returnvariable="Lvar_PagaSeptimo">
						<cfif Lvar_PagaSeptimo>
							<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
							ecodigo="#session.ecodigo#" pvalor="750" default="-1" returnvariable="Lvar_CIid">
							<cfquery name="rsCIncidentes" datasource="#session.dsn#">
								select ci.CIid 
								from CIncidentes ci
								where ci.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CIid#">
							</cfquery>
							<cfif rsCIncidentes.recordcount EQ 0>
								<cfthrow message="Error en Cálculo de Séptimo. El Concepto Incidente para Séptimo no está definido. Proceso Cancelado!">
							</cfif>
							<cfquery datasource="#session.dsn#">
								UPDATE RHCMControlSemanal
								SET RHCMCSpagoseptimo = 1,
									RHCMCSmontoseptimo = 
									(
										SELECT SUM(ICmontores)
										FROM IncidenciasCalculo 
										WHERE RCNid = #LvarRCNid#
										AND DEid = RHCMControlSemanal.DEid
										AND CIid = #Lvar_CIid#
										AND ICfecha = <cf_dbfunction name="dateadd" args="6,RHCMControlSemanal.RHCMCSfecha">
									)
								WHERE RHCMCSfecha <= (SELECT CPhasta FROM CalendarioPagos WHERE CPid = #LvarRCNid#)
								AND RHCMCSpagoseptimo = 0
								AND EXISTS(
									SELECT 1
									FROM IncidenciasCalculo 
									WHERE RCNid = #LvarRCNid#
									AND DEid = RHCMControlSemanal.DEid
									AND CIid = #Lvar_CIid#
									AND ICfecha = <cf_dbfunction name="dateadd" args="6,RHCMControlSemanal.RHCMCSfecha">
								)
							</cfquery>
							<cfquery datasource="#session.dsn#">
								UPDATE RHCMControlSemanal
								SET RHCMCSpagoseptimo = 2,
									RHCMCSmontoseptimo = 0.00
								WHERE RHCMCSfecha <= (SELECT CPhasta FROM CalendarioPagos WHERE CPid = #LvarRCNid#)
								AND RHCMCSpagoseptimo = 0
								AND EXISTS(
									SELECT 1
									FROM HSalarioEmpleado
									WHERE RCNid = #LvarRCNid#
									AND DEid = RHCMControlSemanal.DEid
								)
							</cfquery>
							<!--- <cf_dumptable var="RHCMControlSemanal" abort="#true#"> --->
						</cfif>
						<!--- ----------------------------------------------- --->
						
						<cfinvoke component="rh.asoc.Componentes.ACParametros" method="isUsingAsoc" 
								returnvariable="Lvar_UsaAsociacion">
						<cfif Lvar_UsaAsociacion>
	                        <!--- DESARROLLO HENKEL [27/06/2007]
								  Interfaz con Asociacion: Ahorros
								  Este proceso hace lo siguiente:
								  	1. Obtiene las deducciones correspondientes a la Nómina que afectan un Ahorro
									de un Asociaciado, registra una transacción de aporte, y actualiza el saldo 
									de la cuenta de ahorro, para el periodo mes activo de la Asociación.
							--->
							<cfinvoke component="rh.asoc.Componentes.RH_NominaAsociacion" method="interfazAhorros">
								<cfinvokeargument name="RCNid" value="#LvarRCNid#">
							</cfinvoke>
							<!--- ----------------------------------------------- --->
						</cfif>
						
						<!--- DESARROLLO COOPESERVIDORES INTERESES CESANTIA SOLO ENTRA CON PARAMETRO 810 --->
						
						<cfset cual_fecha = "( select case when ev2.EVfliquidacion > ev2.EVfantig then ev2.EVfliquidacion 
						                                   else ev2.EVfantig end 
											   from EVacacionesEmpleado ev2 
											   where ev2.DEid=a.DEid )" >
						
						<cfinvoke component="RHParametros" method="get" datasource="#session.DSN#" ecodigo="#Session.Ecodigo#" pvalor="810" default="" returnvariable="calculaInteresCesantia"/>
						<cfif calculaInteresCesantia eq 'YES' >
							<cfquery datasource="#session.dsn#">
								insert into RHCesantiaTransacciones( DEid, DClinea, RHCTperiodo, RHCTmes, RHCTtipo, RHCTmonto, RHCTfecha, BMUsucodigo, RCNid )
								select a.DEid, 
									   a.DClinea, 
									   c.CPperiodo, 
									   c.CPmes, 
									   0, 
										round( a.CCvalorpat / 100 * ( 	select coalesce(max(RHCMporcentaje),0.00)<!---  + 1 --->
																		from EVacacionesEmpleado d
																		
																		inner join RHCesantiaMes e
																		on e.RHCMmes <= datediff( mm, 
																								  #cual_fecha#, 
																								  c.CPfpago
																								)
																		where d.DEid = a.DEid )
											   , 2),
									<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">
								from HCargasCalculo a
									inner join DCargas b
									on b.DClinea = a.DClinea
									and b.DCcalcInteres = 1
									inner join CalendarioPagos c
									on c.CPid = a.RCNid
								where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">
							</cfquery>

							<cfquery datasource="#session.dsn#">
								update RHCesantiaSaldos
								set RHCSmontoMes = RHCSmontoMes +  (
									select round(a.CCvalorpat / 100 * 
												(select coalesce(max(RHCMporcentaje),0.00)<!---  + 1 --->
												from EVacacionesEmpleado d
													inner join RHCesantiaMes e
													on e.RHCMmes <= datediff( mm,
																			  #cual_fecha#,
																			  c.CPfpago)
												where d.DEid = a.DEid)
											,2)
									from HCargasCalculo a
										inner join DCargas b
										on b.DClinea = a.DClinea
										and b.DCcalcInteres = 1
										inner join CalendarioPagos c
										on c.CPid = a.RCNid
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">
									and a.DEid = RHCesantiaSaldos.DEid
									  and a.DClinea = RHCesantiaSaldos.DClinea
									  and c.CPperiodo = RHCesantiaSaldos.RHCSperiodo
									  and c.CPmes = RHCesantiaSaldos.RHCSmes
									)
								where exists (
									select 1
									from HCargasCalculo a
										inner join DCargas b
										on b.DClinea = a.DClinea
										and b.DCcalcInteres = 1
										inner join CalendarioPagos c
										on c.CPid = a.RCNid
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">
									and a.DEid = RHCesantiaSaldos.DEid
									  and a.DClinea = RHCesantiaSaldos.DClinea
									  and c.CPperiodo = RHCesantiaSaldos.RHCSperiodo
									  and c.CPmes = RHCesantiaSaldos.RHCSmes
									)
							</cfquery>
							<cfquery datasource="#session.dsn#">
								insert into RHCesantiaSaldos 
								(DEid, DClinea, RHCSperiodo, RHCSmes, RHCSsaldoInicial, RHCSmontoMes, RHCSsaldoInicialInt, RHCSmontoMesInt, BMUsucodigo)
								select a.DEid, a.DClinea, c.CPperiodo, c.CPmes, 0, 
									round(a.CCvalorpat / 100 * 
										(select coalesce(max(RHCMporcentaje),0.00)<!---  + 1 --->
										from EVacacionesEmpleado d
											inner join RHCesantiaMes e
											on e.RHCMmes <= datediff( mm,
																	  #cual_fecha#,
																	  c.CPfpago)
										where d.DEid = a.DEid)
									,2)
									, 0, 0,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
								from HCargasCalculo a
									inner join DCargas b
									on b.DClinea = a.DClinea
									and b.DCcalcInteres = 1
									inner join CalendarioPagos c
									on c.CPid = a.RCNid
								where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRCNid#">
								and not exists(
									select 1
									from RHCesantiaSaldos x
									where x.DEid = a.DEid
									  and x.DClinea = a.DClinea
									  and x.RHCSperiodo = c.CPperiodo
									  and x.RHCSmes = c.CPmes
								)
							</cfquery>
							<!--- <cf_dumptable abort=false name="RHCesantiaSaldos">
							<cf_dumptable abort=false name="RHCesantiaTransacciones"> 
							<cfabort>--->
						</cfif>
						
						<!---Generar historico de Incidencias Originales--->
						<cfquery datasource="#session.dsn#">  
							insert into HIncidencias
							(   Iid,
								DEid,
								CIid,
								CFid,
								Ivalor,
								Ifechasis,
								Usucodigo,
								Ulocalizacion,
								BMUsucodigo,
								Iespecial,
								RCNid,
								Mcodigo,
								RHJid,
								Imonto,
								Icpespecial,
								IfechaRebajo,
								Iestado,
								Iingresadopor,
								usuCF,
								Iobservacion,
								Ijustificacion,
								Iestadoaprobacion,
								Iusuaprobacion,
								Ifechaaprobacion,
								NRP,
								Inumdocumento,
								CFcuenta,
								NAP,
								CFormato,
								complemento,
								Ifechacontrol,
								EIlote,
								Ifecha,
								BMfechaalta,
								HIEstado)
								<!---/*,HBMUsucodigo,
								,IfechaAnt
								*/--->
							
							select 
								Iid,
								DEid,
								CIid,
								CFid,
								Ivalor,
								Ifechasis,
								Usucodigo,
								Ulocalizacion,
								BMUsucodigo,
								Iespecial,
								#LvarRCNid#,
								Mcodigo,
								RHJid,
								Imonto,
								Icpespecial,
								IfechaRebajo,
								Iestado,
								Iingresadopor,
								usuCF,
								'Historico desde la nomina',<!---Iobservacion,--->
								Ijustificacion,
								Iestadoaprobacion,
								Iusuaprobacion,
								Ifechaaprobacion,
								NRP,
								Inumdocumento,
								CFcuenta,
								NAP,
								CFormato,
								complemento,
								Ifechacontrol,
								EIlote,
								getDate(),
								getDate(),
								2
							from Incidencias
							where exists (	select 1 
							  				from IncidenciasCalculo ic
							 				where ic.RCNid = #LvarRCNid#
							   					and Incidencias.Iid = ic.Iid
							   					and Incidencias.DEid = ic.DEid
							   					<!---and Incidencias.CIid = ic.CIid--->
							   					and Incidencias.Ifecha = ic.ICfecha )
						</cfquery>
						<!--- Fin Historico--->
						
						
						<cfquery datasource="#session.dsn#">
							delete from RHPagosExternos
							where exists ( 	select 1 
											from HRHPagosExternosCalculo p2
											where p2.RCNid = #LvarRCNid#
							  					and RHPagosExternos.PEXid = p2.PEXid )
						</cfquery>
						
						<cfquery datasource="#session.dsn#">  
							delete from Incidencias
							where exists (	select 1 
							  				from IncidenciasCalculo ic
							 				where ic.RCNid = #LvarRCNid#
							   					and Incidencias.Iid = ic.Iid
							   					and Incidencias.DEid = ic.DEid
							   					<!---and Incidencias.CIid = ic.CIid--->
							   					and Incidencias.Ifecha = ic.ICfecha )
						</cfquery>
						
						<cfquery datasource="#session.dsn#"> 
							delete from RHPagosExternosCalculo
							where RCNid = #LvarRCNid#
						</cfquery>
						<cfquery datasource="#session.dsn#"> 
							delete from IncidenciasCalculo 
							 where RCNid = #LvarRCNid#
						</cfquery>
						<cfquery datasource="#session.dsn#"> 
							delete from CargasCalculo 
							 where RCNid = #LvarRCNid#
						</cfquery>
						<cfquery datasource="#session.dsn#"> 
							delete from DeduccionesCalculo 
							 where RCNid = #LvarRCNid#
						</cfquery>
						<cfquery datasource="#session.dsn#"> 
							delete from PagosEmpleado
							 where RCNid = #LvarRCNid#
						</cfquery>
						<cfquery datasource="#session.dsn#"> 
							delete from SalarioEmpleado 
							 where RCNid = #LvarRCNid#
						</cfquery>
						<cfquery datasource="#session.dsn#"> 
							delete from RCalculoNomina 
							 where RCNid = #LvarRCNid#
						</cfquery>
						<cfif LvarDebug EQ "S">
							<cfthrow message="debug">
						</cfif>
					</cftransaction>	
					<!--- Fin de limpieza de tablas de calculo de nomina --->
				<cfcatch type="any">
					<!--- 
						1.Borrar los asientos contables generados si estos existen. 
						2.Borrar los Históricos de Nominas procesadas por el error generado en la nomina
						Esto simula un proceso de rollback de las transacciones anteriores.
					--->
	
					<cftransaction action="rollback" />

					<cftransaction>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select 	coalesce(a.IDcontable,0) as IDcontable, 
									coalesce(a.IDcontableNoUni,0) as IDcontableNoUni
							from RHEjecucion a 
							where a.RCNid = #LvarRCNid# 
						</cfquery>
						
						<cfquery datasource="#session.dsn#">
							delete from DContables 
							where DContables.IDcontable in ( #rsSQL.IDcontable#, #rsSQL.IDcontableNoUni# ) 
						</cfquery>
						
						<cfquery datasource="#session.dsn#">
							delete from EContables
							where EContables.IDcontable in ( #rsSQL.IDcontable#, #rsSQL.IDcontableNoUni# )
						</cfquery>
						
						<cfquery datasource="#session.dsn#">
							update RHEjecucion
							set IDcontable = NULL, IDcontableNoUni = NULL
							where RCNid = #LvarRCNid# 
						</cfquery>
						
						<cfquery name="rsLinea" datasource="#session.dsn#">
							select DRNlinea as DRNlinea 
							from HDRNomina
							where HDRNomina.ERNid = #Arguments.ERNid#
						</cfquery>
						
						<cfloop query="rsLinea">
							<cfquery datasource="#session.dsn#">
								delete from HDDeducPagos
								where HDDeducPagos.DRNlinea = #rsLinea.DRNlinea#
							</cfquery>
							
							<cfquery datasource="#session.dsn#">
								delete from HDRIncidencias
								where HDRIncidencias.DRNlinea = #rsLinea.DRNlinea#
							</cfquery>
						</cfloop>
						
						<cfquery datasource="#session.dsn#">
							delete from HDRNomina 
							where ERNid = #Arguments.ERNid#
						</cfquery>

						
						<cfquery datasource="#session.dsn#">
							delete from HERNomina  
							where ERNid = #Arguments.ERNid#
						</cfquery>
						
						<cfquery datasource="#session.dsn#">
							<!--- Cambiar estado a encabezado, que debe ser verificado al inicio del proceso --->
							update HERNomina
							set HERNestado = 9, HERNfdeposito = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							where ERNid = #Arguments.ERNid#
						</cfquery>	
					</cftransaction>
	
					<cfif cfcatch.Message EQ "debug">
						<cfabort>
					<cfelseif LvarNAP LT 0>
						<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
					<cfelse>
						<cfthrow object="#cfcatch#">
					</cfif>
				</cfcatch>
				</cftry>
			</cfif>
		</cfif>

        <!--- Borrar Detalles de las nominas en proceso que se aplicaron --->
		<cftransaction>
			<cfquery datasource="#session.dsn#">
				delete from DDeducPagos 
				where exists (	select 1  
								from DRNomina
				 				where DRNomina.ERNid = #Arguments.ERNid#
									<!--- 05/06/2008 --->
									<!--- Cambio solicitado por Juan Carlos Gutierrez y autorizado por Marcel--->
				   					<!---and DRNomina.DRNestado = 1--->
				   					and DDeducPagos.DRNlinea = DRNomina.DRNlinea )
			</cfquery>
			
			<cfquery datasource="#session.dsn#">	
				delete from DRIncidencias
				where exists ( 	select 1
								from DRNomina
				 				where DRNomina.ERNid = #Arguments.ERNid#
									<!--- 05/06/2008 --->
									<!--- Cambio solicitado por Juan Carlos Gutierrez y autorizado por Marcel--->
									<!---and DRNomina.DRNestado = 1--->
				   					and DRIncidencias.DRNlinea = DRNomina.DRNlinea )
			</cfquery>
			
			<cfquery datasource="#session.dsn#">
				delete from DRNomina
				 where ERNid = #Arguments.ERNid#
					<!--- 05/06/2008 --->
					<!--- Cambio solicitado por Juan Carlos Gutierrez y autorizado por Marcel--->
				    <!---and DRNestado = 1--->
			</cfquery>
			
			<cfquery datasource="#session.dsn#">
				delete from ERNomina
				 where ERNid = #Arguments.ERNid#
	        </cfquery>
	        
		</cftransaction>
	</cffunction>	
	
	<cffunction name="rh_ContabilizaNomina" access="public" returntype="void">
		<!---
		** Contabilización de Nómina
		** Creado por : Marcel de Mézerville L.
		** Fecha: 21 Octubre 2003
		** Modificacion por Mauricio Esquivel - 
			Separar los asientos de gastos directos y gastos de cargas sociales.
		   OJO: FALTA OBTENER TIPO DE CAMBIO ***

		** Convertido a Coldfusion por Ing. Óscar Bonilla
		** Fecha: 14/DIC/2005
		--->
		<cfargument name="RCNid" 	type="numeric" 	required="true">	
		
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select coalesce(ltrim(rtrim(Pvalor)),'0') as Contabiliza
			  from RHParametros 
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 20
		</cfquery>

		<cfif rsSQL.Contabiliza EQ '0'>
			<cfset LvarContabilizar = false>
		<cfelse>
			<cfset LvarContabilizar = true>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select count(1) as cantidad
				  from HRCalculoNomina 
				 where RCNid 	= #Arguments.RCNid# 
				   and Ecodigo 	= #session.Ecodigo#
			</cfquery>
			<cfif rsSQL.cantidad GT 0>		
				<!--- La Nomina está procesada, por lo tanto. TIENE que estar contabilizada si lo requiere --->
				<cfset LvarContabilizar = false>
			</cfif>
		</cfif>

		<cfif NOT LvarContabilizar>
			<cfreturn>
		</cfif>
	
		<!--- 
			Cuenta Contable de Pagos no realizados
		--->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select coalesce(Pvalor,'-1') as Ccuenta
			from RHParametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 150
		</cfquery>			
		<cfset LvarCcuentaPagosNoRealizados = rsSQL.Ccuenta>
		  
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select 	cc.Cformato,
					(
						select min(cf.CFcuenta) 
						  from CFinanciera cf
						 where cf.Ecodigo = #session.Ecodigo#
						   and cf.Ccuenta = cc.Ccuenta
						   and cf.CFmovimiento = 'S'
					) as CFcuenta
			  from CContables cc
			 where cc.Ccuenta = #LvarCcuentaPagosNoRealizados#
			   and cc.Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset LvarCformatoPagosNoRealizados = rsSQL.Cformato>
		<cfset LvarCFcuentaPagosNoRealizados = rsSQL.CFcuenta>

		<cfif trim(LvarCformatoPagosNoRealizados) EQ "">
			<cfthrow message="'ERROR: La cuenta contable para Pagos no Realizados no es una cuenta válida. Revise los Parámetros del Sistema. Proceso Cancelado.'">
		</cfif>	
		
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from RHParametros 
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 25
		</cfquery>
		<!--- Default unificado --->
		<cfset LvarUnificarGastosCargas = (rsSQL.Pvalor NEQ "0")>

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select 
				a.Tcodigo,
				coalesce(a.RCDescripcion,{fn concat('Nómina - ' , {fn concat( b.CPcodigo , {fn concat( <cf_dbfunction name="date_format" args="b.CPdesde,dd/mm/yyyy"> , {fn concat( ' - ' , <cf_dbfunction name="date_format" args="b.CPhasta,dd/mm/yyyy">)})})})}) as Descripcion,
				b.CPcodigo,
				b.CPhasta,
				b.CPfpago
			from RCalculoNomina a, CalendarioPagos b
			where a.RCNid = #Arguments.RCNid# 
			  and a.Ecodigo = #session.Ecodigo#
			  and a.RCNid = b.CPid
		</cfquery>
		<cfset LvarTcodigo 		= rsSQL.Tcodigo>
		<cfif LvarTcodigo EQ "">
			<cfthrow message="ERROR: No se ha  definido el Tipo de Nómina para la Relación de Cálculo que desea Aplicar">
		</cfif>
			
		<cfset LvarDescripcion 	= rsSQL.Descripcion>
		<cfset LvarCPcodigo 	= rsSQL.CPcodigo>

		<cfset LvarReferencia 	= Arguments.RCNid>
		<cfif rsSQL.CPfpago LT rsSQL.CPhasta >
			<cfset LvarFechaHasta	= rsSQL.CPhasta>
		<cfelse>
			<cfset LvarFechaHasta	= rsSQL.CPfpago>
		</cfif>
				
		<!--- Verfica la Moneda --->
		<cfset LvarTC			= 1.00>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Mcodigo 
			  from TiposNomina
			 where Ecodigo = #session.Ecodigo# 
			   and Tcodigo = '#LvarTcodigo#'
		</cfquery>
		<cfset LvarMcodigo = rsSQL.Mcodigo>

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Mcodigo 
			  from Empresas
			 where Ecodigo = #session.Ecodigo# 
		</cfquery>
		<cfset LvarMcodigoLocal = rsSQL.Mcodigo>
		
		<cfif LvarMcodigo NEQ LvarMcodigoLocal>
			<cfthrow message="ERROR: La moneda del Tipo de Nómina sólo puede ser la Moneda Local de la Empresa">
		</cfif>

		<cfquery name="rsDocumentos" datasource="#session.DSN#">
			select RHEnumero, Periodo, Mes
			  from RHEjecucion
			 where RCNid = #Arguments.RCNid#
			order by RHEnumero
		</cfquery>

		<cftransaction>
			<!--- Aplicación Contable --->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" />

			<cfloop query="rsDocumentos">
				<cfset LvarPeriodo 	= rsDocumentos.Periodo>
				<cfset LvarMes 		= rsDocumentos.Mes>
				<cfif LvarPeriodo*100+LvarMes EQ dateFormat(LvarFechaHasta,"YYYYMM")>
					<cfset LvarFecha = LvarFechaHasta>
				<cfelseif LvarPeriodo*100+LvarMes LT dateFormat(LvarFechaHasta,"YYYYMM")>
					<cfset LvarFecha = createDate(LvarPeriodo,LvarMes,1)>
					<cfset LvarFecha = createDate(LvarPeriodo,LvarMes,DaysInMonth(LvarFecha))>
				<cfelse>
					<cfthrow message="Se esta intentando aplicar una nómina con fecha mayor a la fecha hasta">
				</cfif>
				
				<!--- Genera Asiento Contable: (Gastos sin unificar) o (Gastos y Cargas Unificadas) --->
				<cfif LvarUnificarGastosCargas>
					<!--- Asiento Unificado: Gastos y Cargas) --->
					<cfset sbAsientoContable (Arguments.RCNid, rsDocumentos.RHEnumero, "U")>
				<cfelse>
					<!--- Asiento No Unificado: Gastos --->
					<cfset sbAsientoContable (Arguments.RCNid, rsDocumentos.RHEnumero, "G")>
					<!--- Asiento No Unificado: Cargas --->
					<cfset sbAsientoContable (Arguments.RCNid, rsDocumentos.RHEnumero, "C")>
				</cfif>
			</cfloop>
		
			<cfif LvarDebug EQ "S">
				<cftransaction action="rollback" />
			</cfif>

		</cftransaction>
	</cffunction>
	
	<!----===================================================================----> 
	<!----========= Validar que creditos y debitos sean iguales      =========---->	
	<!---Cuando la diferencia entre creditos y debitos sea > 0 y <= 0.010  esta diferencia se resta al menor 
	concepto de pago de tipo debito en la relacion---->
	<!----===================================================================----> 			
	<cffunction name="funcBalanceaAsiento" access="public" output="true">
		<cfargument name="RCNid" type="numeric" required="true">		
		<cfset vn_creditos = 0><!----Monto de los creditos--->
		<cfset vn_debitos = 0><!---Monto de los debitos---->
		<cfset vn_diferencia = funcDiferenciaAsiento(Arguments.RCNid)><!---Obtienen la diferencia de creditos y debitos, carga variables:vn_creditos y vn_debitos ---->
		<cfif abs(vn_diferencia) NEQ 0 and abs(vn_diferencia) LTE 0.50>
			<!---Buscar el menor concepto de pago de tipo debito--->
			<cfquery name="rsConceptoP" datasource="#session.DSN#">
				select min(a.RCTid) as RCTid
				from RCuentasTipo a
				where a.RCNid = #Arguments.RCNid# 
					and a.tipo = 'D'
					and a.tiporeg = 20
					and a.montores >= abs(#vn_diferencia#)
			</cfquery>
			<cfif rsConceptoP.RecordCount NEQ 0 and len(trim(rsConceptoP.RCTid))>
				<!----Restarle al concepto de pago la diferencia---->				
				<cfquery datasource="#session.DSN#">
					update RCuentasTipo
						set montores = montores - #vn_diferencia#
					where RCNid = #Arguments.RCNid# 							
						and RCTid = #rsConceptoP.RCTid#					
				</cfquery>
			</cfif>
		<cfelseif abs(vn_diferencia) GT 0.50>
			<cfthrow message="ERROR: El asiento Contable de la Nómina no está Balanceado: <br>Débitos=#NumberFormat(vn_debitos,',9.99')#<br> Créditos=#NumberFormat(vn_creditos,',9.99')#<br> Diferencia:#vn_diferencia#">
		</cfif>
		<!----Volver a verificar la diferencia--->
		<cfset vn_diferencia = funcDiferenciaAsiento(Arguments.RCNid)>
		<cfif abs(vn_diferencia) GT 0.50>
			<cfthrow message="ERROR: El asiento Contable de la Nómina no está Balanceado:<br> Débitos=#NumberFormat(vn_debitos,',9.99')#<br> Créditos=#NumberFormat(vn_creditos,',9.99')#<br> Diferencia:#vn_diferencia#">
		</cfif>
	</cffunction>

	<!----======================================================================================================---->
	<!---- Esta funcion devuelve que la diferencia entre debitos y creditos---->
	<!----======================================================================================================---->	
	<cffunction name="funcDiferenciaAsiento" access="public" output="true" returntype="numeric">
		<cfargument name="RCNid" type="numeric" required="true">		
		<cfset vn_diferencia = 0>		
		<cfquery name="rsDebitos" datasource="#session.DSN#">
			select round(sum(montores),2)  as debitos
			from RCuentasTipo 
			where RCNid = #Arguments.RCNid#  
				and tipo = 'D'
				and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset vn_debitos = rsDebitos.debitos>
		<cfquery name="rsCreditos" datasource="#session.DSN#">
			select round(sum(montores),2)  as creditos
			from RCuentasTipo 
			where RCNid = #Arguments.RCNid#  			
				and tipo = 'C'
				and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset vn_creditos = rsCreditos.creditos>
		<cfset vn_diferencia = rsDebitos.debitos - rsCreditos.creditos>		
		<cfset vn_diferencia = LSNumberFormat(vn_diferencia, '9.99')>
		<cfreturn vn_diferencia>
	</cffunction>

	<!--- ***************************************************************************************************************************** --->
	<cffunction name="sbAsientoContable" access="public" output="true" returntype="any">
		<cfargument name="RCNid" 		type="numeric" 	required="true">
		<cfargument name="RHEnumero"	type="numeric" 	required="true">
		<cfargument name="Tipo" 		type="string" 	required="true">
        <cfargument name="historico" 	type="string" 	required="false" default="false">
		<cfargument name="debug" 	    type="string" 	required="false" default="N">
		
		<cfif Arguments.debug EQ "S">
			<cfset LvarDebug = "S">
		</cfif>
		
		<cfset LvarDebug = "N">
		<!--- variable Arguments.historico :  <cfdump var="#Arguments.historico#"><br>
		variable LvarDebug : 			<cfdump var="#LvarDebug#"><br --->>

		<!----=============== Permitir un desbalance de 0.15 ===============----> 
		<cfset balanceaasiento=funcBalanceaAsiento(Arguments.RCNid)>

		<cfif Arguments.historico >
            
			<cfsetting requesttimeout="84600">
			<cf_dbtemp name="Errores" returnvariable="Errores" datasource="#session.DSN#">
				<cf_dbtempcol name="tiporeg" 		type="int" 			mandatory="no">
				<cf_dbtempcol name="descripcion"	type="varchar(255)"	mandatory="no">
				<cf_dbtempcol name="CFformato"		type="varchar(255)"	mandatory="no">
				<cf_dbtempcol name="tipoerr"		type="int"			mandatory="no">
			</cf_dbtemp>
			
            <cfquery name="rsSQL" datasource="#session.DSN#">
				select 	a.Tcodigo,
						{fn concat({fn concat({fn concat( {fn concat('Nómina - ', b.CPcodigo)}, <cf_dbfunction name="date_format" args="b.CPdesde,DD/MM/YYYY">)}, ' - ')}, <cf_dbfunction name="date_format" args="b.CPhasta,DD/MM/YYYY">)}  as Descripcion,
						b.CPcodigo,
						b.CPperiodo as Periodo, 
						b.CPmes as Mes,
                        b.CPhasta
				from HRCalculoNomina a, CalendarioPagos b
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and a.RCNid = b.CPid
			</cfquery>  

            <cfset LvarTcodigo 		= rsSQL.Tcodigo>
            <cfif LvarTcodigo EQ "">
                <cfthrow message="ERROR: No se ha  definido el Tipo de Nómina para la Relación de Cálculo que desea Aplicar">
            </cfif>
            
			<cfset LvarMes 		    = rsSQL.Mes >
            <cfset LvarDescripcion 	= rsSQL.Descripcion>
            <cfset LvarCPcodigo 	= rsSQL.CPcodigo>
            <cfset LvarReferencia 	= Arguments.RCNid>
            <cfset LvarFechaHasta	= rsSQL.CPhasta>
            <cfset LvarFecha 	    = now()>
			<cfset LvarPeriodo  	= rsSQL.Periodo > 
			
			
			<cftransaction>
				<cfquery datasource="#session.DSN#">
					update RCuentasTipo
					set Ccuenta = -1 
					where RCNid 	= #Arguments.RCNid#
					and Periodo 	= #LvarPeriodo#
					and Mes 		= #LvarMes#
				</cfquery>

				<!---►►►►ACTUALIZA EL FORMATO DE LA CUENTA FINANCIERA◄◄◄◄◄--->
                <cfinvoke component="rh.Componentes.RH_AplicarMascara" method="ActualizaFormatoRCuentasTipo">
                    <cfinvokeargument name="RCNid" 		value="#Arguments.RCNid#">
                    <cfinvokeargument name="Periodo" 	value="#LvarPeriodo#">
                    <cfinvokeargument name="Mes" 		value="#LvarMes#">
                </cfinvoke>
                
				<!--- Actualizar las cuentas contables que existan definidas en el catalogo de cuentas --->
				<!--- Actualizar el campo Ccuenta si los formatos existen --->
				<cfquery datasource="#session.DSN#">
					update RCuentasTipo
					set Ccuenta = coalesce((	select min(Ccuenta) 
											from CFinanciera c 
											where c.Ecodigo = RCuentasTipo.Ecodigo
											  and c.CFformato = RCuentasTipo.Cformato
											  and c.CFmovimiento = 'S' ), -1)
					where RCNid = #Arguments.RCNid#
					and Periodo = #LvarPeriodo#
					and Mes 	= #LvarMes#
				</cfquery>	
				
		<!--- LZ 2011-06-1 Modificaciones Generacion de Cuentas, cuando se utiliza Plan de Cuentas unicamente lo hace si el PLAN DE CUENTAS ESTA ACTIVO--->
		<cfquery name="rsCT_cursor" datasource="#session.DSN#">
			select rtrim(ltrim(Pvalor)) as Pvalor
			from Parametros
			Where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
			and Pcodigo=1
		</cfquery>
	
		<cfif rsCT_cursor.Pvalor EQ 'S' >	
				<!--- Ejecutar el sp del plan cuentas para las cuentas que todavía no existen --->
				<cfquery name="rsCNH_cursor" datasource="#session.DSN#">
					select distinct Cformato,  tiporeg
					from RCuentasTipo
					where Ccuenta = -1
					and Cformato is not null
					and RCNid 	= #Arguments.RCNid#
					and Periodo = #LvarPeriodo#
					and Mes 	= #LvarMes#
				</cfquery>
				
				<cfloop query="rsCNH_cursor">
					<cfif len(trim(rsCNH_cursor.Cformato)) >
						<cfset vCmayor = mid(rsCNH_cursor.Cformato, 1, 4) >
						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="MSG">
							<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#">
							<cfinvokeargument name="Lprm_Cmayor"	value="#vCmayor#">
<!--- 						<cfinvokeargument name="Lprm_Cdetalle"	value="#rsCNH_cursor.Cformato#">  2011-06-01 EL MODO EN QUE SE MANDA LA CUENTA ES INCORRECTA, DEBE ENVIARSE SIN LA CUENTA MAYOR--->
							<cfinvokeargument name="Lprm_Cdetalle"	value="#mid(rsCNH_cursor.Cformato,6,len(rsCNH_cursor.Cformato))#">	
							<cfinvokeargument name="Lprm_TransaccionActiva"	value="true">		 <!--- 2011-06-09 Se agrega el argumento Lprm_TransaccionActiva en Verdadero, pues se invoca dentro de una transaccion --->			
							<cfinvokeargument name="Lprm_debug"		value="false">
						</cfinvoke>
						<cfif MSG NEQ "NEW" AND MSG NEQ "OLD">
							<cfquery datasource="#session.DSN#">
								<!--- Llenar #Errores Cuentas invalidas --->
								insert into #Errores#(tiporeg, descripcion, CFformato, tipoerr)
								values(#rsCNH_cursor.tiporeg#, '#MSG#', '#rsCNH_cursor.Cformato#', 1)
							</cfquery>
							<cfquery datasource="#session.DSN#">
								update RCuentasTipo
								set CFcuenta = -999, Ccuenta = -999
								where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">  
								  and Ecodigo  = #session.Ecodigo#
								  and Cformato = '#rsCNH_cursor.Cformato#'
							</cfquery>
						</cfif>
					</cfif>	
				</cfloop>
		</cfif>	
				<!--- Actualizar el campo Ccuenta si los formatos existen --->
				<cfquery datasource="#session.DSN#">
					update RCuentasTipo
					set Ccuenta = coalesce((	select min(Ccuenta) 
											from CFinanciera c 
											where c.Ecodigo = RCuentasTipo.Ecodigo
											  and c.CFformato = RCuentasTipo.Cformato
											  and c.CFmovimiento = 'S' ), -1)
					where RCNid 	= #Arguments.RCNid#
					and Periodo = #LvarPeriodo#
					and Mes 	= #LvarMes#
				</cfquery>	
				
				<cfquery datasource="#session.DSN#">
					update RCuentasTipo
					set CFcuenta = coalesce((	select min(CFcuenta)
											from CFinanciera  c 
											where c.Ecodigo = RCuentasTipo.Ecodigo
											  and c.Ccuenta = RCuentasTipo.Ccuenta), -1)
					where  RCNid 	= #Arguments.RCNid#
					and Periodo = #LvarPeriodo#
					and Mes 	= #LvarMes#
				</cfquery>	
		    </cftransaction>
			
			<!--- 3) Validaciones Previas al Posteo 
			<cfquery name="rsCNH_datos11" datasource="#session.DSN#">
				select 1 
				from RCuentasTipo
				where Ccuenta < 0
				and RCNid 	= #Arguments.RCNid#
				and Periodo = #LvarPeriodo#
				and Mes 	= #LvarMes#
			</cfquery>
			
			<cfif rsCNH_datos11.recordcount gt 0>--->
				<!--- Llenar #Errores Cuentas inválidas 
				<cfinvoke component="sif.Componentes.Translate"
						  method="Translate"
						  key="MSG_La_cuenta_no_existe_o_no_es_una_cuenta_valida"
						  default="La cuenta no existe o no es una cuenta valida"
						  xmlfile="/rh/componentes.xml"
						  returnvariable="MSG_Error_9" />
	
				<cfquery datasource="#session.DSN#">
					insert into #Errores#(tiporeg, descripcion)
					select 	distinct tiporeg, 
							{fn concat('#MSG_Error_9#: ', Cformato)}
					from RCuentasTipo
					where coalesce(Ccuenta,-1) < 0
					and Cformato is not null
					and RCNid 	= #Arguments.RCNid#	
					and Periodo = #LvarPeriodo#
					and Mes 	= #LvarMes#
				</cfquery>	
			</cfif>		--->	
			
		    <cfquery name="rsSQL" datasource="#session.DSN#">
                select coalesce(Pvalor,'-1') as Ccuenta
                from RHParametros
                where Ecodigo = #session.Ecodigo#
                  and Pcodigo = 150
            </cfquery>	
					
            <cfset LvarCcuentaPagosNoRealizados = rsSQL.Ccuenta>
            
			<cfquery name="rsSQL" datasource="#session.DSN#">
                select 	cc.Cformato,
                        (
                            select min(cf.CFcuenta) 
                              from CFinanciera cf
                             where cf.Ecodigo = #session.Ecodigo#
                               and cf.Ccuenta = cc.Ccuenta
                               and cf.CFmovimiento = 'S'
                        ) as CFcuenta
                  from CContables cc
                 where cc.Ccuenta = #LvarCcuentaPagosNoRealizados#
                   and cc.Ecodigo = #session.Ecodigo#
            </cfquery>
			
            <cfset LvarCformatoPagosNoRealizados = rsSQL.Cformato>
            <cfset LvarCFcuentaPagosNoRealizados = rsSQL.CFcuenta>
    
            <cfif trim(LvarCformatoPagosNoRealizados) EQ "">
                <cfthrow message="'ERROR: La cuenta contable para Pagos no Realizados no es una cuenta válida. Revise los Parámetros del Sistema. Proceso Cancelado.'">
            </cfif>	
            
            <cfquery name="rsSQL" datasource="#session.DSN#">
                select Pvalor
                  from RHParametros 
                 where Ecodigo = #session.Ecodigo#
                   and Pcodigo = 25
            </cfquery>
            <!--- Default unificado --->
            <cfset LvarUnificarGastosCargas = (rsSQL.Pvalor NEQ "0")>            
            
                    
            <!--- Verfica la Moneda --->
            <cfset LvarTC		= 1.00>
            <cfquery name="rsSQL" datasource="#session.DSN#">
                select Mcodigo 
                  from TiposNomina
                 where Ecodigo = #session.Ecodigo# 
                   and Tcodigo = '#LvarTcodigo#'
            </cfquery>
            <cfset LvarMcodigo = rsSQL.Mcodigo>
    
            <cfquery name="rsSQL" datasource="#session.DSN#">
                select Mcodigo 
                  from Empresas
                 where Ecodigo = #session.Ecodigo# 
            </cfquery>
            <cfset LvarMcodigoLocal = rsSQL.Mcodigo>
            
            <cfif LvarMcodigo NEQ LvarMcodigoLocal>
                <cfthrow message="ERROR: La moneda del Tipo de Nómina sólo puede ser la Moneda Local de la Empresa">
            </cfif>
			
            <cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" />
		</cfif>
        

		
		
		<cfquery datasource="#session.DSN#">
			delete from #INTARC#
		</cfquery>
		<cf_dbfunction name="string_part" args="{fn concat(case a.tiporeg when 10 then 'SALARIOS ' when 20 then 'INCIDENCIAS ' when 21 then 'INCIDENCIAS ANTERIOR ' when 30 then 'GASTO CARGAS' when 31 then 'GASTO CARGAS ANTERIOR ' else 'GASTOS, OTROS REGISTROS' end, {fn concat(cf.CFcodigo, {fn concat('-', cf.CFdescripcion)})})}|1|80" delimiters="|" returnvariable="Lvar_concat">
		<!--- Generar cuentas de Gasto --->
		<cfquery  name="rsInsertINTARC" datasource="#session.DSN#">
			insert into #INTARC# 
				(
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, 
					INTDES, 
					INTFEC, INTCAM, Periodo, Mes, 
					Mcodigo, Ocodigo, INTMOE, 
					Ccuenta, CFcuenta
				)
			select 	'RHPN' as RHPN, 1, '#LvarCPcodigo#', '#LvarReferencia#', 
					<!--- round(sum(a.montores*#LvarTC#),2),  NO SE DEBE DE REDONDEAR CUANDO SE CREA EL REGISTRO EN INTARC, YA VIENE REDONDEADO--->
					sum(a.montores*#LvarTC#),
					a.tipo, 
					#PreserveSingleQuotes(Lvar_concat)#, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(LvarFecha,'yyyymmdd')#">,
					#LvarTC#, #LvarPeriodo#, #LvarMes#, 
					#LvarMcodigo#, a.Ocodigo, 
					<!--- round(sum(a.montores), 2), SE ELIMINA REDONDEO--->
					sum(a.montores),
					a.Ccuenta, a.CFcuenta
			  from RCuentasTipo a
			  	inner join CFuncional cf
			  	on cf.CFid = a.CFid
			 where a.RCNid 		= #Arguments.RCNid#
			   and a.Periodo	= #LvarPeriodo#
			   and a.Mes 		= #LvarMes#
			   and a.tiporeg in 
				<cfif Arguments.Tipo EQ "U">			<!--- Unificando Gastos y Cargas --->
				 (10,20,21,30,31)

				<cfelseif Arguments.Tipo EQ "G">		<!--- Gastos: sin unificar Cargas --->
				 (10,20,21)
				<cfelseif Arguments.Tipo EQ "C">		<!--- Cargas: sin unificar Gastos--->
				 (30,31)
				</cfif>
			group by a.tipo, a.tiporeg, a.Ocodigo, a.Ccuenta, a.CFcuenta, cf.CFcodigo, cf.CFdescripcion
			order by a.tipo desc, a.tiporeg, a.Ocodigo, cf.CFcodigo
		</cfquery>
		<cfquery datasource="#session.DSN#">
			insert into #INTARC# 
				(
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, 
					INTDES, 
					INTFEC, INTCAM, Periodo, Mes, 
					Mcodigo, Ocodigo, INTMOE, 
					Ccuenta, CFcuenta
				)
			select 	'RHPN', 1, '#LvarCPcodigo#', '#LvarReferencia#', round(sum(a.montores*#LvarTC#),2), a.tipo, 
					case a.tiporeg
						when 11 then 'SALARIOS MES ANTERIOR (CxP)'
						when 25 then 'PAGOS NO REALIZADOS'
						when 50 then 'CARGAS EMPLEADO'
						when 51 then 'Cargas EMPLEADO por distribucion'   
						when 52 then 'Cargas EMPLEADO Mes Anterior'
						when 60 then 'DEDUCCIONES'
						when 70 then 'RENTA'
						when 40 then 'CARGAS EMPRESA (CxC)'
						when 55 then 'CARGAS EMPRESA (CxP)'
						when 56 then 'CargasPatronales por distribucion'   
						when 57 then 'CargasPatronales Mes Anterior' 
						when 61 then 'INTERESES DEDUCCIONES'
					end, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(LvarFecha,'yyyymmdd')#">,
					#LvarTC#, #LvarPeriodo#, #LvarMes#, 
					#LvarMcodigo#, a.Ocodigo, round(sum(a.montores), 2),
					a.Ccuenta, a.CFcuenta
			  from RCuentasTipo a
			 where a.RCNid 		= #Arguments.RCNid#
			   and a.Periodo	= #LvarPeriodo#
			   and a.Mes 		= #LvarMes#
			   and a.tiporeg in 
				
			   <cfif Arguments.Tipo EQ "U">			<!--- Unificando Gastos y Cargas --->
				 (11,25,50,51,52,60,61,70,40,55,56,57)

				<cfelseif Arguments.Tipo EQ "G">		<!--- Gastos: sin unificar Cargas --->
				 (11,25,50,51,52,60,61,70)
				<cfelseif Arguments.Tipo EQ "C">		<!--- Cargas: sin unificar Gastos--->
				 (40,55,56,57)
				</cfif>

			group by a.tipo, a.tiporeg, a.Ocodigo, a.Ccuenta, a.CFcuenta
			order by a.tipo desc, a.tiporeg, a.Ocodigo
		</cfquery>


		<cfif Arguments.Tipo NEQ "C">		<!--- Gastos o Unificado --->
			<!--- Asiento Contable: (Pagos) --->
			<cfquery datasource="#session.DSN#">
				insert into	#INTARC# 
					(	
						INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, 
						INTDES, 
						INTFEC, INTCAM, Periodo, Mes, 
						Mcodigo, Ocodigo, INTMOE,
						Ccuenta, CFcuenta
					)
						select 	'RHPN', 1, '#LvarCPcodigo#', '#LvarReferencia#', 
						<!--- round(sum(a.montores*#LvarTC#),2), ---> 
						sum(a.montores*#LvarTC#),
						a.tipo, 
						
                        <cfif Arguments.historico>
                            case
                                when  a.tiporeg = 80 then 'BANCO'
                                when  a.tiporeg = 85 then 'SALARIOS POR PAGAR'
                            end, 
                        <cfelse>
                            case
                                when d.DRNestado = 1 AND a.tiporeg = 80 then 'BANCO'
                                when d.DRNestado = 1 AND a.tiporeg = 85 then 'SALARIOS POR PAGAR'
                            end,                        
						</cfif>
						
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(LvarFecha,'yyyymmdd')#">,
                    #LvarTC#, #LvarPeriodo#, #LvarMes#, 
                    #LvarMcodigo#, a.Ocodigo, 
					<!--- round(sum(a.montores), 2), --->
					sum(a.montores),
                    coalesce(a.Ccuenta,#LvarCcuentaPagosNoRealizados#),
                    coalesce(a.CFcuenta,#LvarCFcuentaPagosNoRealizados#)
					
					<cfif Arguments.historico>
                         from RCuentasTipo a
                         where a.RCNid 		= #Arguments.RCNid#
                           and a.Periodo 	= #LvarPeriodo#
                           and a.Mes 		= #LvarMes#
                           and a.tiporeg in (80,85)
                         group by a.tipo, a.tiporeg, a.Ccuenta, a.Ocodigo, a.CFcuenta
                    <cfelse>
                         from RCuentasTipo a, ERNomina e, DRNomina d
                         where a.RCNid 		= #Arguments.RCNid#
                           and a.Periodo 	= #LvarPeriodo#
                           and a.Mes 		= #LvarMes#
                           and a.tiporeg in (80,85)
                           and e.RCNid = a.RCNid
                           and e.ERNid = d.ERNid
                           and a.DEid  = d.DEid
                         group by a.tipo, d.DRNestado, a.tiporeg, a.Ccuenta, a.Ocodigo, a.CFcuenta
                    </cfif>
			</cfquery>
		</cfif>

		
		
		
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select 
				sum(case when INTTIP='D' then INTMON end) as Debitos, 
				sum(case when INTTIP='C' then INTMON end) as Creditos
			from #INTARC#
		</cfquery>
		<cfset LvarDebitos 	= rsSQL.Debitos>
		<cfset LvarCreditos = rsSQL.Creditos>

		<cfif LvarDebug EQ "S">
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select 
						substring(c.Cformato, 1, 25) as Cuenta, 
						substring(a.INTDES, 1, 40) as Descripcion,
						case when INTTIP='D' then INTMON end as Debitos,
						case when INTTIP='C' then INTMON end as Creditos
				  from #INTARC# a, CContables c
				 where c.Ccuenta = a.Ccuenta
			</cfquery>
			<font size="+2">
			<cfif Arguments.Tipo NEQ "C">		<!--- Gastos o Unificado --->
				Asiento Contable de la Nómina
			<cfelse>
				Asiento Contable de Otros Costos de la Nómina (no unificado)
			</cfif>
			#LvarPeriodo#-#LvarMes#
			</font>
			<cfdump var="#rsSQL#">
			<cfoutput>
				<strong>
				TOTALES:<br>
				Débitos=#NumberFormat(LvarDebitos,',9.99')#, Créditos=#NumberFormat(LvarCreditos,',9.99')#
				<cfif LvarDebitos NEQ LvarCreditos>
					<br><br>
					<font color="##FF0000" size="+2">
					<cfif Arguments.Tipo NEQ "C">		<!--- Gastos o Unificado --->
						ERROR: El asiento Contable de la Nómina no está Balanceado
					<cfelse>
						ERROR: El asiento Contable de Otros Costos de la Nómina (no unificado) no está Balanceado
					</cfif>
					</font>
				</cfif>
				</strong>
			</cfoutput>
		<cfelseif LvarDebitos NEQ LvarCreditos>
			<cfif Arguments.Tipo NEQ "C">		<!--- Gastos o Unificado --->
				<cfthrow message="ERROR: El asiento Contable de la Nómina no está Balanceado: Débitos=#NumberFormat(LvarDebitos,',9.99')#, Créditos=#NumberFormat(LvarCreditos,',9.99')# #LvarPeriodo#/#LvarMes#">
			<cfelse>
				<cfthrow message="ERROR: El asiento Contable de Otros Costos de la Nómina (no unificado) no está Balanceado: Débitos=#NumberFormat(LvarDebitos,',9.99')#, Créditos=#NumberFormat(LvarCreditos,',9.99')#  #LvarPeriodo#/#LvarMes#">
			</cfif>
		</cfif>

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Cconcepto
			  from ConceptoContable
			 where Ecodigo = #session.Ecodigo#
			   and Oorigen = 'RHPN'
		</cfquery>
		
		<cfif rsSQL.Cconcepto EQ "">
			<cfthrow message="ERROR: No se ha definido el Concepto Contable para el Origen 'RHPN = RH Pago de Nómina' en Administración del Sistema">
		</cfif>
	
		<cfset LvarCconcepto = rsSQL.Cconcepto>


		<cfif Arguments.historico>
			<!--- Actualizar el IDcontable generado --->
			<cfquery name="rsCNH_errores" datasource="#session.DSN#">
				select *
				from #Errores#
			</cfquery>
			<cfif rsCNH_errores.recordcount eq 0 >
				<cftransaction>
					<!--- Genera el Asiento Contable --->
					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
						<cfinvokeargument name="Ecodigo" 		value="#session.Ecodigo#"/>
						<cfinvokeargument name="Oorigen" 		value="RHPN"/>
						<cfinvokeargument name="Cconcepto" 		value="#LvarCconcepto#"/>
						<cfinvokeargument name="Eperiodo" 		value="#LvarPeriodo#"/>
						<cfinvokeargument name="Emes" 			value="#LvarMes#"/>
						<cfinvokeargument name="Efecha" 		value="#LvarFecha#"/>
						<cfinvokeargument name="Edocbase" 		value="#LvarCPcodigo#"/>
						<cfinvokeargument name="Ereferencia" 	value="#LvarReferencia#"/>
						<cfif Arguments.Tipo NEQ "C">		<!--- Gastos o Unificado --->
							<cfinvokeargument name="Edescripcion" 	value="#LvarDescripcion#"/>
						<cfelse>
							<cfinvokeargument name="Edescripcion" 	value="Otros Costos #LvarDescripcion#"/>
						</cfif>
						<cfinvokeargument name="debug" 			value="#LvarDebug EQ "s"#"/>
					</cfinvoke>
					<cfquery datasource="#session.DSN#">
						update HRCalculoNomina 
						set IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDcontable#">
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					</cfquery>
				</cftransaction>
			</cfif>	
			<cfquery name="rsCNH_errores" datasource="#session.DSN#">
				select tiporeg, descripcion 
				from #Errores# order by tiporeg
			</cfquery>
			<cfreturn rsCNH_errores >
		<cfelse>
			
			<!--- Genera el Asiento Contable --->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
				<cfinvokeargument name="Ecodigo" 		value="#session.Ecodigo#"/>
				<cfinvokeargument name="Oorigen" 		value="RHPN"/>
				<cfinvokeargument name="Cconcepto" 		value="#LvarCconcepto#"/>
				<cfinvokeargument name="Eperiodo" 		value="#LvarPeriodo#"/>
				<cfinvokeargument name="Emes" 			value="#LvarMes#"/>
				<cfinvokeargument name="Efecha" 		value="#LvarFecha#"/>
				<cfinvokeargument name="Edocbase" 		value="#LvarCPcodigo#"/>
				<cfinvokeargument name="Ereferencia" 	value="#LvarReferencia#"/>
				<cfif Arguments.Tipo NEQ "C">		<!--- Gastos o Unificado --->
					<cfinvokeargument name="Edescripcion" 	value="#LvarDescripcion#"/>
				<cfelse>
					<cfinvokeargument name="Edescripcion" 	value="Otros Costos #LvarDescripcion#"/>
				</cfif>
				<cfinvokeargument name="debug" 			value="#LvarDebug EQ "s"#"/>
			</cfinvoke>
			<!--- Actualizar el IDcontable generado --->
			<cfquery datasource="#session.DSN#">
				update RHEjecucion
				<cfif Arguments.Tipo NEQ "C">		<!--- Gastos o Unificado --->
				   set IDcontable = #LvarIDcontable#
				<cfelse>
				   set IDcontableNoUni = #LvarIDcontable#
				</cfif>
				 where Ecodigo 		= #session.Ecodigo#
				   and RHEnumero	= #Arguments.RHEnumero#
			</cfquery>				
		</cfif>		

	</cffunction>
	<!--- ***************************************************************************************************************************** --->
 
	<cffunction name="rh_EjecucionPresupuestaria" access="private" returntype="numeric">
		<!---
		** Contabilización de Nómina
		** Creado por : Ing. Óscar Bonilla, MBA
		** Fecha: 5 Enero 2006
		--->
		<cfargument name="RCNid" 	type="numeric" 	required="true">
		
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select 	a.Tcodigo, 
					b.CPhasta
					, b.CPcodigo
			from RCalculoNomina a, CalendarioPagos b
			where a.RCNid = #Arguments.RCNid# 
			  and a.Ecodigo = #session.Ecodigo#
			  and a.RCNid = b.CPid
		</cfquery>
		<cfset LvarFechaHasta	= rsSQL.CPhasta>
		<cfset LvarCPcodigo 	= rsSQL.CPcodigo>
		<cfset LvarTcodigo 		= rsSQL.Tcodigo>

		<!--- Trae la Moneda Local --->
		<cfset LvarTC = 1.0>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Mcodigo 
			  from TiposNomina
			 where Ecodigo = #session.Ecodigo# 
			   and Tcodigo = '#LvarTcodigo#'
		</cfquery>
		<cfset LvarMcodigo = rsSQL.Mcodigo>

		<cfquery name="rsDocumentos" datasource="#session.DSN#">
			select RHEnumero, Periodo, Mes
			  from RHEjecucion
			 where RCNid = #Arguments.RCNid#
			order by RHEnumero
		</cfquery>

		<!--- Ejecución Presupuestaria --->
		<cfquery name="rsSinPresupuesto" datasource="#session.DSN#">
			select distinct Cformato
			  from RCuentasTipo a
				  inner join CPVigencia v
					inner join PCEMascaras m
						 ON m.PCEMid 		= v.PCEMid
						AND m.PCEMformatoP 	is not null 
					on v.Ecodigo	= #session.Ecodigo#
				   and v.Cmayor		= substring(a.Cformato,1,4)
			 where a.RCNid = #Arguments.RCNid#
			   and a.vpresupuesto = 0
		</cfquery>
		<cfif rsSinPresupuesto.recordCount GT 0>
			<cfthrow message="La Cuenta '#rsSinPresupuesto.Cformato#' requiere Control de Presupuesto pero se ha indicado que no se verifique presupuesto">
		</cfif>

		<cfloop query="rsDocumentos">
			<cfset LvarPeriodo 		= rsDocumentos.Periodo>
			<cfset LvarMes 			= rsDocumentos.Mes>
			<cfset LvarRHEnumero	= rsDocumentos.RHEnumero>

			<cfif LvarPeriodo*100+LvarMes EQ dateFormat(LvarFechaHasta,"YYYYMM")>
				<cfset LvarFecha = LvarFechaHasta>
			<cfelseif LvarPeriodo*100+LvarMes LT dateFormat(LvarFechaHasta,"YYYYMM")>
				<cfset LvarFecha = createDate(LvarPeriodo,LvarMes,1)>
				<cfset LvarFecha = createDate(LvarPeriodo,LvarMes,DaysInMonth(LvarFecha))>
			<cfelse>
				<cfthrow message="Se esta intentando aplicar una nómina con fecha mayor a la fecha hasta">
			</cfif>

			<cfquery datasource="#session.DSN#">
				delete from #INT_PRESUPUESTO# 
			</cfquery>
			
			<cfquery datasource="#session.DSN#">
				insert into #INT_PRESUPUESTO# 
					(
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						CFcuenta,
						Ocodigo,
						Mcodigo,
						MontoOrigen,
						TipoCambio,
						Monto,
						TipoMovimiento
					)
				select 	'RHPN', '#LvarRHEnumero#', '#LvarCPcodigo#', 
						<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">,
						#LvarPeriodo#, #LvarMes#,
						CFcuenta, Ocodigo,
						#LvarMcodigo#, sum(round(a.montores,2)), #LvarTC#, sum(round(a.montores*#LvarTC#,2)), 
						'E'
				  from RCuentasTipo a
				 where a.RCNid 		= #Arguments.RCNid#
				   and a.Periodo 	= #LvarPeriodo#
				   and a.Mes 		= #LvarMes#
				   and a.tiporeg in (10,11,20,21,25,50,51,52,60,61,70, 30,31,40,55,56,57)
				   and a.vpresupuesto = 1
				group by a.Ocodigo, a.CFcuenta
				order by a.Ocodigo, a.CFcuenta
			</cfquery>
			
			<cfinvoke 
				 component		= "sif.Componentes.PRES_Presupuesto"
				 method			= "ControlPresupuestario"
				 returnvariable	= "LvarNAP">
						<cfinvokeargument name="ModuloOrigen"  		value="RHPN"/>
						<cfinvokeargument name="NumeroDocumento" 	value="#LvarRHEnumero#"/>
						<cfinvokeargument name="NumeroReferencia" 	value="RHPN #LvarCPcodigo#"/>
						<cfinvokeargument name="FechaDocumento" 	value="#LvarFecha#"/>
						<cfinvokeargument name="AnoDocumento"		value="#LvarPeriodo#"/>
						<cfinvokeargument name="MesDocumento"		value="#LvarMes#"/>
			</cfinvoke>
			
			<cfif LvarDebug EQ "S">
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select * from #INT_PRESUPUESTO# 
				</cfquery>
				
				<cfdump var="#rsSQL#" label="Enviado a Control de Presupuesto">
			</cfif>
			
			<cfif LvarNAP LT 0>
				<!--- Ya hubo rollback --->
				<cfreturn LvarNAP>
			</cfif>				

			<cfquery datasource="#session.DSN#">
				update RHEjecucion
					set NAP = #LvarNAP#
				 where Ecodigo 		= #session.Ecodigo#
				   and RHEnumero	= #LvarRHEnumero#
			</cfquery>
		</cfloop>				
		<cfreturn 1>
	</cffunction>
</cfcomponent>
