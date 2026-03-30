<cfcomponent hint="Actualiza el CF inactivo por el que el usuario seleccione">



<cffunction name="BorraPropuesto" access="public" returntype="any">
	<cfargument name="RCNid"	type="numeric" required="yes">
	<cfargument name="CFid" 	type="numeric" required="yes">
	<cfargument name="CFidAnt" 	type="numeric" required="yes">
	
	<cftransaction>
	<cfquery datasource="#session.dsn#" name="updCFidAnt">
		Delete from RCuentasTipoExactus
		where RCNid = #Arguments.RCNid#
			and CFid = #Arguments.CFid#
			and CFidAnt = #Arguments.CFidAnt#
	</cfquery>
	</cftransaction>
	
	<cfreturn true>
	
</cffunction>	
	
<cffunction name="Actualiza" access="public" returntype="query">
	<cfargument name="RCNid"	type="numeric" required="yes">
	<cfargument name="CFid" 	type="numeric" required="yes">
	<cfargument name="CFpk" 	type="numeric" required="yes">

<cftransaction>
	<cf_dbfunction name="OP_concat" returnvariable="_Cat">
	
	<!---actualiza el valorAnt con el valor original del CF --->
	<!---CarolRS. generacion de la nueva tabla Exactus para mejor control y permitir borrados, antes se utilizaba RCuentasTipo ahora se utiliza RCuentasTipoExactus--->
	<cfquery datasource="#session.dsn#" name="updCFidAnt">
		insert into RCuentasTipoExactus(T.RCTid, T.RCNid, T.Ecodigo, T.tiporeg, T.DEid, T.referencia, T.cuenta, T.valor, T.Cformato, T.Ccuenta, T.CFcuenta, T.tipo, T.CFid, T.Ocodigo, T.Dcodigo, T.montores, T.vpresupuesto, T.BMfechaalta, T.BMUsucodigo, T.RHPPid, T.Periodo, T.Mes, T.valor2, T.CFidAnt, T.valorAnt)
		select T.RCTid, T.RCNid, T.Ecodigo, T.tiporeg, T.DEid, T.referencia, T.cuenta, T.valor, T.Cformato, T.Ccuenta,
		 T.CFcuenta, T.tipo, #Arguments.CFid#, T.Ocodigo, T.Dcodigo, T.montores, T.vpresupuesto, #now()#, T.BMUsucodigo, 
		 T.RHPPid, T.Periodo, T.Mes, T.valor2,  T.CFid, T.valorAnt 
		from RCuentasTipo T
		where T.RCNid = #Arguments.RCNid#
				and T.CFid = #Arguments.CFpk#
				<!---and <cf_dbfunction name="length" args="CFidAnt"> = 0--->
	</cfquery>
	
	
	<!---actualiza las excepciones que pueda tener--->
	<cfquery datasource="#session.dsn#" name="updExce">
		update RCuentasTipoExactus set 
			valor = coalesce(( select ec.valor2 
								 from CFExcepcionCuenta ec
								   where ec.CFid=RCuentasTipoExactus.CFid 
									 and ec.valor1= RCuentasTipoExactus.valor), RCuentasTipoExactus.valor)
		where RCuentasTipoExactus.CFidAnt > 0
		and RCuentasTipoExactus.CFid = #Arguments.CFid#
		and RCuentasTipoExactus.RCNid = #Arguments.RCNid#
	</cfquery>
	
	
	<!---actualiza las nuevas mascaras del CF--->
	<cfquery datasource="#session.dsn#" name="updExce">
		update RCuentasTipoExactus set cuenta = (select cf.CFcuentac
											from CFuncional cf
										  where cf.CFid = RCuentasTipoExactus.CFid )
		where RCuentasTipoExactus.CFidAnt > 0
			and RCuentasTipoExactus.CFid = #Arguments.CFid#
	</cfquery>
	
<!---		<cf_dbtempcol name="RCNid"  		type="numeric"			mandatory="no">
		<cf_dbtempcol name="CFid"  			type="numeric"			mandatory="no">
--->	
	<!--- ***** poner en los inserts el default en 1, cuando no lo pone --->
	<cf_dbtemp name="Errores" returnvariable="Errores" datasource="#session.dsn#">
		<cf_dbtempcol name="tiporeg"  		type="int"				mandatory="no">
		<cf_dbtempcol name="descripcion"	type="varchar(255)"  	mandatory="no">
		<cf_dbtempcol name="CFformato"		type="varchar(255)"  	mandatory="no">
		<cf_dbtempcol name="tipoerr"		type="int"  			mandatory="no">
	</cf_dbtemp>

	<cf_dbfunction name="findOneOf" args="Cformato, ?!*" returnvariable="findoneof_cformato">
	<cf_dbfunction name="findOneOf" args="cuenta, ?!*" returnvariable="findoneof_cuenta">
	
	<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
	<!--- procesa los ? comodines --->
	<cfquery datasource="#session.dsn#" name="RS1">
		select cuenta, valor,RCTid, valorAnt, CFidAnt, Cformato,CFcuenta,Ccuenta
		from RCuentasTipoExactus
		where RCNid = #Arguments.RCNid#
			and CFid = #Arguments.CFid#
		and (#preservesinglequotes(findoneof_cuenta)# and rtrim(ltrim(valor)) is not null)
	</cfquery>
	
	<cfif RS1.recordCount GT 0>
		<cfloop query="RS1">
			<cfset LvarFormatoCuenta = mascara.AplicarMascara(RS1.cuenta,RS1.valor)>
			<cfif isdefined("LvarFormatoCuenta") and len(trim(LvarFormatoCuenta))>
				<cfquery datasource="#session.dsn#">
					update RCuentasTipoExactus set Cformato =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFormatoCuenta#">
					where RCTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#RS1.RCTid#">
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>		
	<cfquery datasource="#session.dsn#">
		update RCuentasTipoExactus 
		set Cformato = cuenta 
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">  
		and (not #preservesinglequotes(findoneof_cuenta)# or #preservesinglequotes(findoneof_cformato)# or ltrim(rtrim(Cformato)) is null)
	</cfquery>
	
	<!--- Actualizar el CFcuenta y Ccuenta para los que requieren CFinanciera --->
		<cfquery datasource="#session.dsn#">
			update RCuentasTipoExactus
			set CFcuenta = coalesce((	select min(CFcuenta)  
										from CFinanciera c 
										where c.Ecodigo = RCuentasTipoExactus.Ecodigo
										and c.CFformato = RCuentasTipoExactus.Cformato
										and c.CFmovimiento = 'S'), -1),
				Ccuenta = coalesce((	select  min(Ccuenta)  
										from CFinanciera c 
										where c.Ecodigo = RCuentasTipoExactus.Ecodigo
										and c.CFformato = RCuentasTipoExactus.Cformato
										and c.CFmovimiento = 'S'), -1)
			where CFcuenta = 0
			  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
		</cfquery>
		<!--- Actualiza el Ccuenta para los registros que no requieren CFinanciera --->
		<cfquery datasource="#session.dsn#">
			update RCuentasTipoExactus
			set Ccuenta = coalesce((	select min(Ccuenta) 
										from CContables c 
										where c.Ecodigo = RCuentasTipoExactus.Ecodigo
										and c.Cformato = RCuentasTipoExactus.Cformato
										and c.Cmovimiento = 'S' ), -1)
			where CFcuenta is null
			  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
		</cfquery>
		
		<!---Actualizar el CFcuenta donde no requiero CFinanciera --->
		<cfquery datasource="#session.dsn#">
			update RCuentasTipoExactus
			set CFcuenta = coalesce((	select min(CFcuenta) 
										from CFinanciera a 
										where a.Ccuenta = RCuentasTipoExactus.Ccuenta ), -1)
			where CFcuenta is null
			  and Ccuenta is not null
			  and Ccuenta > 0
			  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
		</cfquery>		
		<!--- Ejecutar el sp del plan cuentas para las cuentas que todavÃ­a no existen --->
		<cfquery name="rsCT_cursor" datasource="#session.dsn#">
			select distinct Cformato, tiporeg
			from RCuentasTipoExactus 
			where CFcuenta < 0
			and Cformato is not null
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
		</cfquery>
		
		<cfloop query="rsCT_cursor">
			<!--- Ejecutar el SP del Plan de Cuentas --->
			<cfif len(trim(rsCT_cursor.Cformato)) >
				<cfset vCmayor = mid(rsCT_cursor.Cformato, 1, 4) >
				<cfset vCdetalle = mid(rsCT_cursor.Cformato, 6, 100) >
				
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="MSG">
					<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#">
					<cfinvokeargument name="Lprm_Cmayor"	value="#vCmayor#">
					<cfinvokeargument name="Lprm_Cdetalle"	value="#vCdetalle#">
					<cfinvokeargument name="Lprm_debug"		value="false">
				</cfinvoke>
				<cfif MSG NEQ "NEW" AND MSG NEQ "OLD">
					<cfquery datasource="#session.dsn#">
						<!--- Llenar #Errores Cuentas invalidas --->
						insert into #Errores#(tiporeg, descripcion, CFformato, tipoerr)
						values(#rsCT_cursor.tiporeg#, '#MSG#', '#rsCT_cursor.Cformato#', 1)
					</cfquery>
					<cfquery datasource="#session.dsn#">
						update RCuentasTipoExactus
						set CFcuenta = -999, Ccuenta = -999
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">  
						  and Ecodigo  = #session.Ecodigo#
						  and Cformato = '#rsCT_cursor.Cformato#'
					</cfquery>
				</cfif>
				
			</cfif>
		</cfloop>
		<!--- Buscar el CFcuenta y Ccuenta para las cuentas generadas --->
		<cfquery datasource="#session.dsn#">
			update RCuentasTipoExactus
			set CFcuenta = coalesce((	select min(CFcuenta)
										from CFinanciera cf
										where cf.Ecodigo = RCuentasTipoExactus.Ecodigo
										  and cf.CFformato = RCuentasTipoExactus.Cformato), -1),
					Ccuenta = coalesce((	select min(Ccuenta)
											from CFinanciera cf
											where cf.Ecodigo = RCuentasTipoExactus.Ecodigo
											  and cf.CFformato = RCuentasTipoExactus.Cformato
											), -1)
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">  
			  and (Ccuenta is null
			    or CFcuenta is null
			    or Ccuenta = -1
			    or CFcuenta = -1 )
		</cfquery>	
		
		
		<!--- 3) Validaciones Previas al Posteo --->
		<cfquery name="rsCT_datos10" datasource="#session.dsn#">
			select 1
			from RCuentasTipoExactus 
			where coalesce(Ccuenta,-1) < 0 and coalesce(Ccuenta,-1) <> -999
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
		</cfquery>	
		<cfif rsCT_datos10.recordcount gt 0>
			<!--- Llenar #Errores Cuentas inválidas --->
			<cfquery datasource="#session.dsn#">
				insert into #Errores#(tiporeg, descripcion, CFformato, tipoerr)
					select distinct tiporeg, 'La cuenta ' #_Cat# Cformato #_Cat# ' no existe o no es una cuenta válida.!',	Cformato, 1
					from RCuentasTipoExactus 
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
						and coalesce(Ccuenta,-1) < 0 AND coalesce(Ccuenta,-1) <> -999
						and Cformato is not null
			</cfquery>
		</cfif>	

		<!--- Regresa los registro que hubo con error --->
		<cfquery name="rsCT_errores" datasource="#session.dsn#">
			select tiporeg, descripcion, CFformato, tipoerr 
			from #Errores#
			order by tipoerr, tiporeg
		</cfquery>

	<cfquery datasource="#session.dsn#" name="RS2">
		select cuenta, valor,RCTid, valorAnt, CFidAnt, Cformato,CFcuenta,Ccuenta
		from RCuentasTipoExactus
		where RCNid = #Arguments.RCNid#
			and CFid = #Arguments.CFid#
		and (#preservesinglequotes(findoneof_cuenta)# and rtrim(ltrim(valor)) is not null)
	</cfquery>

	<cfif isdefined("rsCT_errores") and rsCT_errores.RecordCount GT 0>
			<cftransaction action="rollback"/>
	</cfif>
	
	
	<!---<cfquery datasource="#session.dsn#" name="rstemp">
		select * from RCuentasTipoExactus 
		where RCNid = #Arguments.RCNid#
	</cfquery>
	<cfdump label="RCuentasTipoExactus" var="#rstemp#">
	<cfquery datasource="#session.dsn#" name="rstemp">
		select * from RCuentasTipo 
		where RCNid = #Arguments.RCNid#
		and CFid = #Arguments.CFpk#
		and <cf_dbfunction name="length" args="CFidAnt"> = 0
	</cfquery>
	<cfdump label="RCuentasTipo" var="#rstemp#">
	<cfabort>--->
	<cfreturn #rsCT_errores#>
</cftransaction>	
</cffunction>
</cfcomponent>