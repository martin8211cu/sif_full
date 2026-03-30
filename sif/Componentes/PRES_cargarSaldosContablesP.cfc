<cfcomponent>
	<cffunction name="CargaPresupuestoConta" access="public" output="false" returntype="numeric">
		<cfargument name="Ecodigo" type="numeric" default="-1" hint="Codigo de la Empresa">
		<cfargument name="CPPid" type="numeric" default="-1" hint="Version de Control de Presupuesto">
		<cfargument name="Conexion" type="string" default="#session.dsn#">
		
		
		<!--- Crea las tablas temporales para el proceso --->
		<cfset CPresupuestoControl	= CreaCPresupuestoControl()>
		<cfset SaldosContablesP 	= CreaSaldosContablesP()>
		
		<cfquery datasource="#arguments.Conexion#">
			insert into #CPresupuestoControl# (Ecodigo, Ocodigo, CPcuenta, CPCano, CPCmes, CPCmonto, Ctipo)
			select sp.Ecodigo, sp.Ocodigo, sp.CPcuenta, sp.CPCano, sp.CPCmes, sp.CPCpresupuestado + sp.CPCmodificado + sp.CPCvariacion + sp.CPCtrasladado + sp.CPCtrasladadoE, cm.Ctipo
			from CPresupuestoControl sp
				inner join CPresupuesto c
					inner join CtasMayor cm
					on cm.Ecodigo = c.Ecodigo
					and cm.Cmayor = c.Cmayor
				on c.CPcuenta = sp.CPcuenta
			where sp.Ecodigo = #Arguments.Ecodigo#
			  and sp.CPPid = #Arguments.CPPid#
			  and c.CPmovimiento = 'S'
			  and c.Cmayor <> c.CPformato
		</cfquery>

		<cfquery datasource="#arguments.Conexion#">
			update #CPresupuestoControl#
			set CFcuenta = ((select min(cf.CFcuenta) from CFinanciera cf where cf.CPcuenta = #CPresupuestoControl#.CPcuenta))
		</cfquery>

		<cfquery datasource="#arguments.Conexion#">
			update #CPresupuestoControl#
			set Ccuenta = (( select min(cf.Ccuenta) from CFinanciera cf where cf.CFcuenta = #CPresupuestoControl#.CFcuenta))
		</cfquery>

		<!--- Genera las Cuentas Financieras que no Existen y que su formato coincida con el de Presupuesto --->
		<cfquery name="rsCPP" datasource="#arguments.Conexion#">
			select CPPfechaDesde, CPPanoMesDesde, CPPanoMesHasta
			  from CPresupuestoPeriodo
			 where CPPid = #Arguments.CPPid#
		</cfquery>
		
		<cfquery name="rsCPresupuesto" datasource="#arguments.Conexion#">
			select 	distinct p.CPcuenta, p.CPformato
			  from	#CPresupuestoControl# t
			  	inner join CPresupuesto p
				  	inner join CPVigencia cv
						inner join PCEMascaras m
							 on m.PCEMid		= cv.PCEMid
							and m.PCEMformatoC	= m.PCEMformatoP
						 on cv.CPVid = p.CPVid
						and #rsCPP.CPPanoMesHasta# between CPVdesdeAnoMes and CPVhastaAnoMes
					on p.CPcuenta = t.CPcuenta
			  where t.Ccuenta is null
		</cfquery>
			<cfloop query="rsCPresupuesto">
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
						  method="fnGeneraCuentaFinanciera"
						  returnvariable="LvarError"
				>
							<cfinvokeargument name="Lprm_CFformato" 		value="#rsCPresupuesto.CPformato#"/>
							<cfinvokeargument name="Lprm_fecha" 			value="#rsCPP.CPPfechaDesde#"/>
							<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
							<cfinvokeargument name="Conexion" 				value="#Arguments.Conexion#"/>
							<cfinvokeargument name="Ecodigo" 				value="#Arguments.Ecodigo#"/>
				</cfinvoke>
				<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
					<cf_errorCode	code = "50462"
									msg  = "ERROR EN PRES_cargarSaldosContablesP: @errorDat_1@"
									errorDat_1="#LvarERROR#"
					>
				</cfif>
				
				<cfinvoke 
							component		= "sif.Componentes.PC_GeneraCuentaFinanciera"
							method			= "fnObtieneCFcuenta"
							returnvariable	= "rsCFinanciera"
				>
					<cfinvokeargument name="Lprm_Ecodigo"		value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Lprm_CFformato" 	value="#rsCPresupuesto.CPformato#"/>
					<cfinvokeargument name="Lprm_Fecha"			value="#rsCPP.CPPfechaDesde#"/>
					<cfinvokeargument name="Lprm_DSN" 			value="#Arguments.Conexion#"/>
				</cfinvoke>

				<cfquery datasource="#arguments.Conexion#">
					update #CPresupuestoControl#
					   set CFcuenta	= #rsCFinanciera.CFcuenta#
					     , Ccuenta	= #rsCFinanciera.Ccuenta#
					 where CPcuenta = #rsCPresupuesto.CPcuenta#
				</cfquery>
			</cfloop>

		<!--- Borrar los registros que no correspondan con Cuentas contables Construidas. No se pueden generar en Contabilidad  --->
		<cfquery datasource="#arguments.Conexion#">
			delete from #CPresupuestoControl# where Ccuenta is null
		</cfquery>
<!---
		<cfquery datasource="#arguments.Conexion#">
			update #CPresupuestoControl# set CPCmonto = -CPCmonto 
			where Ctipo in ('P', 'C', 'I')
		</cfquery>
--->
		<cfquery datasource="#arguments.Conexion#">
			insert into #SaldosContablesP# 
				  (Ccuenta, Speriodo, Smes, Ecodigo, Ocodigo, SPinicial, MLmonto, SPfinal)
			select Ccuenta, CPCano, CPCmes, Ecodigo, Ocodigo, 0.00, sum(CPCmonto), 0.00
			  from #CPresupuestoControl#
			 group by Ccuenta, CPCano, CPCmes, Ecodigo, Ocodigo
		</cfquery>
		
		<cfquery name="rsAnoMes" datasource="#Arguments.Conexion#">
			select CPCano as Speriodo, CPCmes as Smes
			  from CPmeses 
			 where Ecodigo	= #Arguments.Ecodigo#
			   and CPPid 	= #Arguments.CPPid#
		</cfquery>
	
		<cfset LvarCant = sbActualizaSaldosContablesP(rsAnoMes, Arguments.Conexion)>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from #CPresupuestoControl#
		</cfquery>

		<cfreturn LvarCant>
	</cffunction>

	<!--- 
		sbActualizaSaldosContablesP
		
		1. Ajusta los saldos iniciales
		2. Ajusta los saldos finales
		3. Mayoriza
		4. Borra los datos a insertar
		5. Insertar los datos generados	
	--->
	<cffunction name="sbActualizaSaldosContablesP" access="public" output="false" returntype="numeric">
		<cfargument name="rsAnoMes" 		type="query" 	required="yes">
		<cfargument name="Conexion" 		type="string" 	required="yes">

		<cfset var LvarPeriodoAnt = -1>
		<cfset var LvarMesAnt = -1>

		<cfif not isdefined("SaldosContablesP")>
			<cfset SaldosContablesP = request.SaldosContablesP>
		</cfif>

		<cfloop query="rsAnoMes">
			<cfif LvarMesAnt NEQ -1>
				<!--- Actualiza los Saldos Iniciales que se estan generando --->
				<cfquery datasource="#Arguments.Conexion#">
					update #SaldosContablesP#
					   set SPinicial = coalesce((
											select sum(s2.SPfinal)
											from #SaldosContablesP# s2
											where s2.Ccuenta  = #SaldosContablesP#.Ccuenta
											  and s2.Ocodigo  = #SaldosContablesP#.Ocodigo
											  and s2.Speriodo = #LvarPeriodoAnt#
											  and s2.Smes     = #LvarMesAnt#
											), 0.00)
					where Speriodo = #rsAnoMes.Speriodo#
					  and Smes     = #rsAnoMes.Smes#
				</cfquery>
			</cfif>
			<!--- Actualiza los Saldos Finales que se estan generando --->
			<cfquery datasource="#Arguments.Conexion#">
				update #SaldosContablesP#
					set SPfinal  = SPinicial + MLmonto
				where Speriodo = #rsAnoMes.Speriodo#
				  and Smes     = #rsAnoMes.Smes#
			</cfquery>

			<cfset LvarPeriodoAnt = rsAnoMes.Speriodo>
			<cfset LvarMesAnt = rsAnoMes.Smes>
		</cfloop>

		<!--- Mayorizar los montos que se estan generando --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #SaldosContablesP# 
				  (Ccuenta, Speriodo, Smes, Ecodigo, Ocodigo, SPinicial, MLmonto, SPfinal)
			select cu.Ccuentaniv, s.Speriodo, s.Smes, s.Ecodigo, s.Ocodigo, sum(s.SPinicial), sum(s.MLmonto), sum(s.SPfinal)
			from #SaldosContablesP# s
					inner join PCDCatalogoCuenta cu
						 on cu.Ccuenta = s.Ccuenta
						and cu.Ccuentaniv <> s.Ccuenta
			group by cu.Ccuentaniv, s.Speriodo, s.Smes, s.Ecodigo, s.Ocodigo
		</cfquery>

		<!--- Borrar unicamente los SaldosContablesP generados --->
		<cfquery name="rsSaldosABorrar" datasource="#Arguments.Conexion#">
			select distinct c.Ecodigo, c.Cmayor, s.Speriodo, s.Smes
			from #SaldosContablesP# s
				inner join CContables c
				on c.Ccuenta = s.Ccuenta
		</cfquery>

		<cftransaction>
			<cfloop query="rsSaldosABorrar">
				<cfquery datasource="#Arguments.Conexion#">
					delete from SaldosContablesP
					 where Speriodo = #rsSaldosABorrar.Speriodo#
					   and Smes     = #rsSaldosABorrar.Smes#
					   and Ecodigo  = #rsSaldosABorrar.Ecodigo#
	
					   and 
							(
								select count(1)
								from CContables c
								where c.Ccuenta = SaldosContablesP.Ccuenta
								  and c.Cmayor  = '#rsSaldosABorrar.Cmayor#'
								  and c.Ecodigo = #rsSaldosABorrar.Ecodigo#
							 ) > 0
				</cfquery>
			</cfloop>
		</cftransaction>

		<!--- Insertar los SaldosContablesP generados --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into SaldosContablesP  
				(Ccuenta, Speriodo, Smes, Ecodigo, Ocodigo, SPinicial, MLmonto, SPfinal)
			select Ccuenta, Speriodo, Smes, Ecodigo, Ocodigo, SPinicial, MLmonto, SPfinal
			  from #SaldosContablesP#
		</cfquery>

		<!--- Cuenta la cantidad de Saldos Generados y borra la tabla de trabajo --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from #SaldosContablesP#
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			delete from #SaldosContablesP#
		</cfquery>
		
		<cfreturn rsSQL.cantidad>
	</cffunction>
	
	<cffunction name="CreaCPresupuestoControl" access="private" output="false" returntype="string">
		<cf_dbtemp name="CPC_V1">
			<cf_dbtempcol name="Ecodigo"  	type="integer">
			<cf_dbtempcol name="Ocodigo"  	type="integer">
			<cf_dbtempcol name="CPcuenta"  	type="numeric">
			<cf_dbtempcol name="CFcuenta"  	type="numeric">
			<cf_dbtempcol name="Ccuenta"  	type="numeric">
			<cf_dbtempcol name="CPCano"  	type="integer">
			<cf_dbtempcol name="CPCmes"		type="integer">
			<cf_dbtempcol name="CPCmonto" 	type="money">
			<cf_dbtempcol name="Ctipo"  	type="char(1)">

			<cf_dbtempindex cols="Ccuenta, CPCano, CPCmes, Ecodigo, Ocodigo">
			<cf_dbtempindex cols="CPcuenta">
			<cf_dbtempindex cols="CFcuenta">
		</cf_dbtemp>
		<cfreturn temp_table>		
	</cffunction>

	<cffunction name="CreaSaldosContablesP" access="public" output="false" returntype="string">
		<cf_dbtemp name="SCP_V1">
			<cf_dbtempcol name="Ecodigo"  	type="integer">
			<cf_dbtempcol name="Ccuenta"  	type="numeric">
			<cf_dbtempcol name="Speriodo"  	type="integer">
			<cf_dbtempcol name="Smes"  		type="integer">
			<cf_dbtempcol name="Ocodigo"  	type="integer">
			<cf_dbtempcol name="SPinicial"  type="money">
			<cf_dbtempcol name="MLmonto"  	type="money">
			<cf_dbtempcol name="SPfinal"  	type="money">

			<cf_dbtempindex cols="Speriodo, Smes, Ccuenta, Ocodigo">
			<cf_dbtempindex cols="Ccuenta">
		</cf_dbtemp>
		<cfset request.SaldosContablesP = temp_table>
		<cfreturn temp_table>		
	</cffunction>
</cfcomponent>

