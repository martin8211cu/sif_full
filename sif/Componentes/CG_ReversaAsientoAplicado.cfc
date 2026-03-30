<!--- 	
		M.Esquivel.  Generación del componente el 12/Feb/2008:
		Reversa un Asiento Aplicado

		NO se debe de usar si se usa presupuesto, porque NO reversa la operación sobre PPTO !!!

		NO se debe de usar si se tienen asientos interempresa.  SOLO reversa el de esta empresa !!!
--->
<cfcomponent>
	<cffunction name="CG_ReversaAsientoAplicado" access="public">
		<cfargument name="IDcontable" 		type="numeric">
		<cfargument name="CtlTransaccion" 	type="boolean" 	default="true">
		<cfargument name="tipoMensaje" 		type="string" 	required="no" 	default="cfthrow">
		<cfargument name="inter" 			type="string" 	required="no" 	default="N">
		<cfargument name='MesCierre' 		type='boolean' 	required="no"	default="false">
		
		<cfquery datasource="#session.dsn#" name="Periodo">
			select Pvalor from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 30
		</cfquery>

		<cfquery datasource="#session.dsn#" name="Mes">
			select Pvalor from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 40
		</cfquery>

		<cfquery datasource="#session.dsn#" name="EContables">
			select 	Eperiodo, Emes, Cconcepto, Edocumento, 
					ECtipo, 
					Edocbase, Ereferencia, Efecha, ECauxiliar
			 from HEContables
			where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDcontable#">
		</cfquery>

		<cfif EContables.RecordCount is 0>
			<cf_errorCode	code = "51013" msg = "El asiento no existe. Proceso Cancelado">
		</cfif>

		<cfif EContables.Eperiodo NEQ Periodo.Pvalor or EContables.Emes NEQ Mes.Pvalor>
			<cf_errorCode	code = "51084" msg = "El asiento no pertenece al mes actual, por lo que no se puede reversar. Use la opción de Copia de Asientos!. Proceso Cancelado">
		</cfif>

		<cfquery datasource="#session.dsn#" name="DContables">
			select count(1) as cantidad
			from HDContables
			where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDcontable#">
		</cfquery>

		<cfif DContables.cantidad is 0>
			<cf_errorCode	code = "51017" msg = "No existen Movimientos para este asiento. Proceso Cancelado">
		</cfif>

		<cfset LvarMes = EContables.Emes>
		<cfset LvarPeriodo = EContables.Eperiodo>
		

		<!--- Mayorizacion en la tabla de Saldos Contables. Actualiza los saldos (debitos / creditos) de todas las cuentas del asiento --->			
		<cf_dbtemp name="CGAplAsnt_v1">
			<cf_dbtempcol name="Ecodigo" type="int"> 
			<cf_dbtempcol name="Ocodigo" type="int">
			<cf_dbtempcol name="Ccuentaniv" type="numeric"> 
			<cf_dbtempcol name="Mcodigo" type="numeric">
			<cf_dbtempcol name="Speriodo" type="int">
			<cf_dbtempcol name="Smes" type="int">
			<cf_dbtempcol name="debitosl" type="money"> 
			<cf_dbtempcol name="creditosl" type="money">
			<cf_dbtempcol name="debitoso" type="money">
			<cf_dbtempcol name="creditoso" type="money">
			<cf_dbtempkey cols="Ecodigo,Ocodigo,Ccuentaniv,Mcodigo,Speriodo,Smes">
		</cf_dbtemp>
 
		<cfif CtlTransaccion>							
			<cftransaction>
				<!--- inserción de registro para evitar problemas de concurrencia (dos procesos aplicando el mismo asiento --->
				<cfquery datasource="#session.dsn#" name="select_HEcontables">
					select 
							Eperiodo, Emes, Cconcepto, Edocumento, Efecha, Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario, 
							ECtipo, 
							Ocodigo, Oorigen, ECusucodigo, ECfechacreacion, ECestado, 
							NAP, NRP, CPNAPIid
					  from 	HEContables
					 where 	IDcontable = #Arguments.IDcontable#
				</cfquery>
				<cfquery datasource="#session.dsn#" name="insert_Econtables">
					insert into EContables (
							Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Efecha, Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario, 
							ECtipo, 
							Ocodigo, Oorigen, ECusucodigo, ECfechacreacion, ECestado,
							NAP, NRP, CPNAPIid
						)
						VALUES(
						   #session.Ecodigo#,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select_HEcontables.Eperiodo#"        voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select_HEcontables.Emes#"            voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select_HEcontables.Cconcepto#"       voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select_HEcontables.Edocumento#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select_HEcontables.Efecha#"          voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#select_HEcontables.Edescripcion#"    voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select_HEcontables.Edocbase#"        voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  value="#select_HEcontables.Ereferencia#"     voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#select_HEcontables.ECauxiliar#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#select_HEcontables.ECusuario#"       voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select_HEcontables.ECtipo#"          voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select_HEcontables.Ocodigo#"         voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="4"   value="#select_HEcontables.Oorigen#"         voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_HEcontables.ECusucodigo#"     voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select_HEcontables.ECfechacreacion#" voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select_HEcontables.ECestado#"        voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_HEcontables.NAP#"             voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_HEcontables.NRP#"             voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_HEcontables.CPNAPIid#"        voidNull>
					)
										
 					<cf_dbidentity1 verificar_transaccion="no" datasource="#session.dsn#">
				</cfquery>
				<cf_dbidentity2 name="insert_Econtables" verificar_transaccion="no" datasource="#session.dsn#">
				<cfset Lvaridentity = insert_Econtables.identity>

				<cfset updSaldosContables(Arguments.IDcontable, EContables.Eperiodo, EContables.Emes, EContables.ECtipo, LvarPeriodo, LvarMes, true)>

				<cfset GrabarTransaccion(Arguments.IDcontable, Periodo.Pvalor, Mes.Pvalor, LvarMes, lvaridentity)>
			</cftransaction>
		<cfelse>
				<cf_errorCode	code = "51022" msg = "No se puede procesar la Aplicación del Asiento en una transaccion. La transacción se controla en el Posteo! Proceso Cancelado">
		</cfif>							
	</cffunction>
	
	<cffunction name="updSaldosContables" access="private">
		<cfargument name="IDcontable"       type = "numeric" required = "yes">
		<cfargument name="Periodo"          type = "numeric" required = "yes">
		<cfargument name="Mes"              type = "numeric" required = "yes">
		<cfargument name="Tipo"             type = "numeric" required = "yes">
		<cfargument name="NuevoPeriodo"     type = "numeric" required = "yes">
		<cfargument name="NuevoMes"         type = "numeric" required = "yes">
		<cfargument name="GenerarHistoria"  type = "boolean" required = "yes">
		
		<cfif Arguments.GenerarHistoria>
			
			<cfquery datasource="#session.dsn#">
				insert into #temp_table# (Ecodigo, Ocodigo, Ccuentaniv, Mcodigo,
					Speriodo, Smes,
					debitosl, creditosl, debitoso, creditoso)
				select
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo,
					a.Ocodigo,
					b.Ccuentaniv as Ccuenta,
					a.Mcodigo,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NuevoPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NuevoMes#">,
					sum(case when Dmovimiento = 'D' then round(Dlocal, 2) else 0 end) debitosl,
					sum(case when Dmovimiento = 'C' then round(Dlocal, 2) else 0 end) creditosl,
					sum(case when Dmovimiento = 'D' then round(Doriginal, 2) else 0 end) debitoso,
					sum(case when Dmovimiento = 'C' then round(Doriginal, 2) else 0 end) creditoso
				from HDContables a
					inner join PCDCatalogoCuenta b
						on b.Ccuenta = a.Ccuenta
				where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDcontable#">
				group by b.Ccuentaniv, a.Ocodigo, a.Mcodigo
			</cfquery>
	
		<cfelse>
				<cf_errorCode	code = "51085" msg = "No se puede procesar un Asiento que no corresponda a este mes!. Proceso Cancelado!">
		</cfif>

		<cfif session.dsinfo.type is 'sybase'>
			<cfquery datasource="#session.dsn#">
				<cfif Arguments.Tipo EQ 1>
					<cf_errorCode	code = "51086" msg = "No se puede procesar un Asiento que no corresponda a este mes o de Cierre!. Proceso Cancelado!">
				<cfelse>
					update SaldosContables
						set DLdebitos  = DLdebitos  - a.debitosl,
							CLcreditos = CLcreditos - a.creditosl,
							DOdebitos  = DOdebitos  - a.debitoso,
							COcreditos = COcreditos - a.creditoso
							, BMFecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					from #temp_table# a
					where SaldosContables.Ccuenta  = a.Ccuentaniv
					  and SaldosContables.Speriodo = a.Speriodo
					  and SaldosContables.Smes     = a.Smes
					  and SaldosContables.Ecodigo  = a.Ecodigo 
					  and SaldosContables.Ocodigo  = a.Ocodigo
					  and SaldosContables.Mcodigo  = a.Mcodigo
				</cfif>
			</cfquery>
		<cfelseif session.dsinfo.type is 'oracle'>
			<cfquery datasource="#session.dsn#">
				<cfif Arguments.Tipo EQ 1>
					<cf_errorCode	code = "51086" msg = "No se puede procesar un Asiento que no corresponda a este mes o de Cierre!. Proceso Cancelado!">
				<cfelse>
					update (select DLdebitos, a.debitosl,
								CLcreditos, a.creditosl,	
								DOdebitos, a.debitoso,
								COcreditos, a.creditoso
								, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> as BMFecha
						from #temp_table# a, SaldosContables
						where SaldosContables.Ccuenta  = a.Ccuentaniv
						  and SaldosContables.Speriodo = a.Speriodo
						  and SaldosContables.Smes     = a.Smes
						  and SaldosContables.Ecodigo  = a.Ecodigo
						  and SaldosContables.Mcodigo  = a.Mcodigo
						  and SaldosContables.Ocodigo  = a.Ocodigo
						  )
					set DLdebitos  = DLdebitos  - debitosl,
						CLcreditos = CLcreditos - creditosl,
						DOdebitos  = DOdebitos  - debitoso,
						COcreditos = COcreditos - creditoso
						, BMFecha	= BMFecha
				</cfif>
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "51023"
							msg  = "No implementado para DBMS @errorDat_1@"
							errorDat_1="#session.dsinfo.type#"
			>
		</cfif>
		
	</cffunction>
	

	<cffunction name="GrabarTransaccion" access="private">
			<cfargument name = "IDcontable"     type="numeric" required="yes">
			<cfargument name = "lArgPeriodo"    type="numeric" required="yes">
			<cfargument name = "lArgMes"        type="numeric" required="yes">
			<cfargument name = "lArgPeriodoMes" type="numeric" required="no">
			<cfargument name =  "LvarIdentity"  type="numeric" required="yes">

			<cfquery name="rsVerifica1" datasource="#session.dsn#">
				select count(1) as Cantidad
				from HDContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDcontable#">
			</cfquery>
			
			<!---
				Generar la historia en las estructuras de trabajo  de Asientos / Polizas Contables
				El insert a EContables pasa al inicio de la transaccion
			--->
	
			<cfquery datasource="#session.dsn#">
				insert into DContables (
					IDcontable, 
					Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Dlinea, Ocodigo, Ddescripcion, Ddocumento, Dmovimiento,
					Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LvarIdentity#">, 
					Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Dlinea, Ocodigo, Ddescripcion, Ddocumento, Dmovimiento,
					Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia
				from HDContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDcontable#">
			</cfquery>

			<cfquery name="rsVerifica2" datasource="#session.dsn#">
				select count(1) as Cantidad
				from HDContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LvarIdentity#">
			</cfquery>

			<cfquery name="rsVerifica3" datasource="#session.dsn#">
				select count(1) as Cantidad
				from EContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LvarIdentity#">
			</cfquery>

			<cfif rsVerifica1.Cantidad  NEQ  rsVerifica2.Cantidad or rsVerifica3.Cantidad NEQ 1>
				<cf_errorCode	code = "51087"
								msg  = "No se Generó el mismo número de Registros en DContables que en HDContables. Se aborta el proceso antes de borrar!"
								errorDat_1="#rsVerifica1.Cantidad#"
								errorDat_2="#rsVerifica2.Cantidad#"
								errorDat_3="#rsVerifica3.Cantidad#"
				>
			</cfif>	
	
			<!--- Borrar los detalles y Encabezado del Asiento en Proceso --->
			<cfquery datasource="#session.dsn#">
				delete from HDContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDcontable#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete from HEContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDcontable#">
			</cfquery>
	</cffunction>
</cfcomponent>

