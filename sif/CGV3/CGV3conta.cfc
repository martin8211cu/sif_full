<cfcomponent output="no">
<cfsetting requesttimeout="36000">
	<!--- PROCESO MASIVO DE GENERACION DE CUENTAS --->
	<cffunction name="sbGenerarCuentas" access="public">
		<cfargument name="Ecodigo">
		<cfargument name="Eperiodo">
		<cfargument name="Emes">
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Mstatus
			  from CGV3cierres
			 where Ecodigo		= #Arguments.Ecodigo#
			   and Eperiodo		= #Arguments.Eperiodo#
			   and Emes			= #Arguments.Emes#
		</cfquery>
		<cfif NOT listFind("1,2,-3", rsSQL.Mstatus)>
			<cfthrow message="Estado incorrecto">
		</cfif>
		<cftry>
			<cfquery datasource="#session.dsn#">
				update CGV3cierres
				   set Mstatus = 2
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes		= #Arguments.Emes#
			</cfquery>
			<cfquery name="rsCtas" datasource="#session.dsn#">
				select distinct CFformato
				  from CGV3detalles
				 where Ecodigo	= #Arguments.Ecodigo#
				   and Eperiodo	= #Arguments.Eperiodo#
				   and Emes		= #Arguments.Emes#
				   and CFcuenta	IS NULL
				   and Derror	IS NULL
			</cfquery>
			<cfloop query="rsCtas">
				<cfset sbGeneraCuentaFinanciera(Arguments.Ecodigo, Arguments.Eperiodo, Arguments.Emes, rsCtas.CFformato)>
			</cfloop>
		
			<!--- Verifica si ya termino o hay que seguir adelante --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	sum(case when CFcuenta	IS NULL 	then 1 else 0 end) as pendientes,
						sum(case when Derror	IS NOT NULL	then 1 else 0 end) as conError
				  from CGV3detalles
				 where Ecodigo	= #Arguments.Ecodigo#
				   and Eperiodo	= #Arguments.Eperiodo#
				   and Emes		= #Arguments.Emes#
			</cfquery>
			
			<cfif rsSQL.pendientes EQ 0>
				<cfquery datasource="#session.dsn#">
					update CGV3asientos
					   set Estatus = 3
					 where Ecodigo		= #Arguments.Ecodigo#
					   and Eperiodo		= #Arguments.Eperiodo#
					   and Emes			= #Arguments.Emes#
					   and Estatus 		< 4
				</cfquery>

				<cfquery datasource="#session.dsn#">
					update CGV3cierres
					   set Mstatus = 3
					 where Ecodigo		= #Arguments.Ecodigo#
					   and Eperiodo		= #Arguments.Eperiodo#
					   and Emes			= #Arguments.Emes#
				</cfquery>
	
				<cflocation url="/cfmx/sif/tasks/CGV3task.cfm?Mstatus=3&Ecodigo=#Arguments.Ecodigo#&Eperiodo=#Arguments.Eperiodo#&Emes=#Arguments.Emes#">
			<cfelseif rsSQL.pendientes EQ rsSQL.conError>
				<cfquery datasource="#session.dsn#">
					update CGV3cierres
					   set Mstatus = -3
					 where Ecodigo		= #Arguments.Ecodigo#
					   and Eperiodo		= #Arguments.Eperiodo#
					   and Emes			= #Arguments.Emes#
				</cfquery>
				<cflocation url="/cfmx/sif/CGV3/CGV3conta.cfm">
			<cfelse>
				<cflocation url="/cfmx/sif/tasks/CGV3task.cfm?Mstatus=1&Ecodigo=#Arguments.Ecodigo#&Eperiodo=#Arguments.Eperiodo#&Emes=#Arguments.Emes#">
			</cfif>
		<cfcatch type="any">
			<cfquery datasource="#session.dsn#">
				update CGV3cierres
				   set Mstatus = -3
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes			= #Arguments.Emes#
			</cfquery>
			<cfrethrow>
		</cfcatch>
		</cftry>
		<cfreturn>
	</cffunction>
	
	<!--- GENERACION DE CUENTA --->
	<cffunction name="sbGeneraCuentaFinanciera">
		<cfargument name="Ecodigo">
		<cfargument name="Eperiodo">
		<cfargument name="Emes">
		<cfargument name="CFformato">
		
		<cfset LvarFecha = createDate(Eperiodo,Emes,1)>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
				  method="fnGeneraCuentaFinanciera"
				  returnvariable="LvarMSG">
			<cfinvokeargument name="Lprm_CFformato" 		value="#Arguments.CFformato#"/>
			<cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
			<cfinvokeargument name="Conexion"				value="#session.dsn#"/>
			<cfinvokeargument name="Lprm_Ecodigo"			value="#Arguments.Ecodigo#"/>
		</cfinvoke>
		
		<cfif LvarMSG EQ "NEW" OR LvarMSG EQ "OLD">
			<cfquery datasource="#session.dsn#">
				update CGV3detalles
				   set CFcuenta	= (select max(CFcuenta) from CFinanciera where Ecodigo = CGV3detalles.Ecodigo and CFformato = CGV3detalles.CFformato)
					 , Derror 	= NULL
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes			= #Arguments.Emes#
				   and CFformato	= '#Arguments.CFformato#'
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update CGV3asientos
				   set Estatus = 
				   			case 
								when
									(
										select count(1)
										  from CGV3detalles
										 where Ecodigo		= CGV3asientos.Ecodigo
										   and Eperiodo		= CGV3asientos.Eperiodo
										   and Emes			= CGV3asientos.Emes
										   and CG5CON		= CGV3asientos.CG5CON
										   and CGBBAT		= CGV3asientos.CGBBAT
										   and Derror		is NOT null
									) > 0
								then -3
				   			 	when
									(
										select count(1)
										  from CGV3detalles
										 where Ecodigo		= CGV3asientos.Ecodigo
										   and Eperiodo		= CGV3asientos.Eperiodo
										   and Emes			= CGV3asientos.Emes
										   and CG5CON		= CGV3asientos.CG5CON
										   and CGBBAT		= CGV3asientos.CGBBAT
										   and CFcuenta		is null
									) > 0
								then 2
								else 3
							end
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes			= #Arguments.Emes#
				   and Estatus 		< 4
				   and (
							select count(1)
							  from CGV3detalles
							 where Ecodigo		= CGV3asientos.Ecodigo
							   and Eperiodo		= CGV3asientos.Eperiodo
							   and Emes			= CGV3asientos.Emes
							   and CG5CON		= CGV3asientos.CG5CON
							   and CGBBAT		= CGV3asientos.CGBBAT
							   and CFformato	= '#Arguments.CFformato#'
						) > 0
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update CGV3asientos
				   set Estatus = -3
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes			= #Arguments.Emes#
				   and Estatus 		< 4
				   and (
				   		select count(1)
						  from CGV3detalles
						 where Ecodigo		= CGV3asientos.Ecodigo
						   and Eperiodo		= CGV3asientos.Eperiodo
						   and Emes			= CGV3asientos.Emes
						   and CG5CON		= CGV3asientos.CG5CON
						   and CGBBAT		= CGV3asientos.CGBBAT
						   and CFformato	= '#Arguments.CFformato#'
						) > 0
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update CGV3detalles
				   set Derror = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMSG#">
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes			= #Arguments.Emes#
				   and CFformato	= '#Arguments.CFformato#'
			</cfquery>
		</cfif>
	</cffunction>
	
	<!--- PROCESO MASIVO DE GENERACION Y APLICACION DE ASIENTOS --->
	<cffunction name="sbGenerarAsientos">
		<cfargument name="Ecodigo">
		<cfargument name="Eperiodo">
		<cfargument name="Emes">

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Cconcepto
			  from ConceptoContableE
			 where Ecodigo		= #Arguments.Ecodigo#
			   and Cconcepto	= 300
		</cfquery>
		<cfif rsSQL.Cconcepto NEQ 300>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into ConceptoContableE 
					(Ecodigo, Cconcepto, Cdescripcion, Ctiponumeracion, BMUsucodigo)
				values 
					(#Arguments.Ecodigo#, 300, 'Contabilidad V3', 0, #session.Usucodigo#)
			</cfquery>
		</cfif>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Mstatus
			  from CGV3cierres
			 where Ecodigo		= #Arguments.Ecodigo#
			   and Eperiodo		= #Arguments.Eperiodo#
			   and Emes			= #Arguments.Emes#
		</cfquery>
		<cfif NOT listFind("3,4,-5", rsSQL.Mstatus)>
			<cfthrow message="Estado incorrecto">
		</cfif>
		<cftry>
			<cfquery datasource="#session.dsn#">
				update CGV3cierres
				   set Mstatus = 4
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes			= #Arguments.Emes#

			</cfquery>
		
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Mcodigo
				  from Empresas
				 where Ecodigo	= #Arguments.Ecodigo# 
			</cfquery>
			<cfset LvarMcodigoLocal = rsSQL.Mcodigo>
			
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Ocodigo
				  from Oficinas
				 where Ecodigo	= #Arguments.Ecodigo# 
			</cfquery>
			<cfset LvarOcodigo	= rsSQL.Ocodigo>
		
			<cfquery name="rsAsientos" datasource="#session.dsn#">
				select Estatus,CG5CON, CGBBAT, IDcontable, 
				  (select count(1) from EContables where IDcontable = CGV3asientos.IDcontable) + (select count(1) from HEContables where IDcontable = CGV3asientos.IDcontable) as Asiento
				  from CGV3asientos
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes			= #Arguments.Emes#
				   and Estatus		in (3,-4,-5)
			</cfquery>
			<cfloop query="rsAsientos">
				<cfif rsAsientos.IDcontable NEQ "" AND rsAsientos.Asiento NEQ 0>
					<cfset LvarIDcontable = rsAsientos.IDcontable> 
				<cfelse>
					<cfset LvarIDcontable = fnGeneraAsiento(Arguments.Ecodigo, Arguments.Eperiodo, Arguments.Emes, rsAsientos.CG5CON, rsAsientos.CGBBAT)>
				</cfif>
				<cfif LvarIDcontable NEQ -1>
					<cfset sbAplicarAsiento(Arguments.Ecodigo, Arguments.Eperiodo, Arguments.Emes, rsAsientos.CG5CON, rsAsientos.CGBBAT, LvarIDcontable)>
				</cfif>
			</cfloop>
		
			<!--- Verifica si ya termino o hay que seguir adelante --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	sum(case when Estatus <> 4 	then 1 else 0 end) as pendientes,
						sum(case when Estatus < 0	then 1 else 0 end) as conError
				  from CGV3asientos
				 where Ecodigo	= #Arguments.Ecodigo#
				   and Eperiodo	= #Arguments.Eperiodo#
				   and Emes		= #Arguments.Emes#
			</cfquery>
			
			<cfif rsSQL.pendientes EQ 0>
				<cfquery datasource="#session.dsn#">
					update CGV3cierres
					   set Mstatus = 4
					 where Ecodigo		= #Arguments.Ecodigo#
					   and Eperiodo		= #Arguments.Eperiodo#
					   and Emes			= #Arguments.Emes#
				</cfquery>
			<cfelseif rsSQL.pendientes EQ rsSQL.conError>
				<cfquery datasource="#session.dsn#">
					update CGV3cierres
					   set Mstatus = -4
					 where Ecodigo		= #Arguments.Ecodigo#
					   and Eperiodo		= #Arguments.Eperiodo#
					   and Emes			= #Arguments.Emes#
				</cfquery>
			<cfelse>
				<cflocation url="/cfmx/sif/tasks/CGV3task.cfm?Mstatus=3&Ecodigo=#Arguments.Ecodigo#&Eperiodo=#Arguments.Eperiodo#&Emes=#Arguments.Emes#">
			</cfif>
		<cfcatch type="any">
			<cfquery datasource="#session.dsn#">
				update CGV3cierres
				   set Mstatus = -4
				 where Ecodigo		= #Arguments.Ecodigo#
				   and Eperiodo		= #Arguments.Eperiodo#
				   and Emes			= #Arguments.Emes#
			</cfquery>
			<cfrethrow>
		</cfcatch>
		</cftry>

		<cfreturn>
	</cffunction>
	
	<cffunction name="fnGeneraAsiento" returntype="numeric">
		<cfargument name="Ecodigo">
		<cfargument name="Eperiodo">
		<cfargument name="Emes">
		<cfargument name="CG5CON">
		<cfargument name="CGBBAT">

		<cftry>
			<cftransaction>
				<cfset LvarEdocumento = fnNuevoAsiento(Arguments.Ecodigo, Arguments.Eperiodo, Arguments.Emes, 300)>
				<cfquery datasource="#session.dsn#" name="insert_Econtables">
					insert into EContables (
						Ecodigo, Cconcepto,	Eperiodo, Emes,
						Edocumento, Efecha, Edescripcion,
						Edocbase, Ereferencia, ECauxiliar, ECusuario, 
						Oorigen, Ocodigo, ECusucodigo, ECfechacreacion, 
						ECipcrea, ECestado, BMUsucodigo
						)
					select 	#Arguments.Ecodigo#, 300, #Arguments.Eperiodo#, #Arguments.Emes#,
							#LvarEdocumento#, Efecha, Edescripcion,
							'#Arguments.CG5CON#', '#Arguments.CGBBAT#', 'N', Eusuario,
							'CGV3', #LvarOcodigo#, 1, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							'0', 0, #session.Usucodigo#
					  from  CGV3asientos
					 where Ecodigo	= #Arguments.Ecodigo#
					   and Eperiodo	= #Arguments.Eperiodo#
					   and Emes		= #Arguments.Emes#
					   and CG5CON	= #Arguments.CG5CON#
					   and CGBBAT	= #Arguments.CGBBAT#
					<cf_dbidentity1 verificar_transaccion="no" datasource="#session.dsn#">
				</cfquery>
				<cf_dbidentity2 name="insert_Econtables" verificar_transaccion="no" datasource="#session.dsn#">
				<cfset LvarIDcontable = insert_Econtables.identity>
				<cfquery datasource="#session.dsn#">
					insert into DContables (
							 IDcontable, 
							 Dlinea, 
							 Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo,
							 Ddocumento, Dreferencia, Ddescripcion, 
							 Ccuenta, CFcuenta,
							 Dmovimiento, Doriginal, Dlocal, Dtipocambio, Mcodigo, CFid)
					select 
							#LvarIDcontable#,
							(
								select count(1)
								  from CGV3detalles
								 where Ecodigo	= #Arguments.Ecodigo#
								   and Eperiodo	= #Arguments.Eperiodo#
								   and Emes		= #Arguments.Emes#
								   and CG5CON	= #Arguments.CG5CON#
								   and CGBBAT	= #Arguments.CGBBAT#
								   and Did		<= d.Did
							) as Dlinea,
							#Arguments.Ecodigo#, 300,	#Arguments.Eperiodo#,	#Arguments.Emes#,	#LvarEdocumento#, #LvarOcodigo#,
							Ddocumento, Dreferencia, Ddescripcion, 
							(
								select min(Ccuenta) 
								  from CFinanciera
								 where CFinanciera.CFcuenta = d.CFcuenta
							), CFcuenta,
							Dmovimiento, round(Dmonto,2), round(Dmonto,2), 1, #LvarMcodigoLocal#, null
					  from CGV3detalles d
					 where Ecodigo	= #Arguments.Ecodigo#
					   and Eperiodo	= #Arguments.Eperiodo#
					   and Emes		= #Arguments.Emes#
					   and CG5CON	= #Arguments.CG5CON#
					   and CGBBAT	= #Arguments.CGBBAT#
				</cfquery>
				<cfquery datasource="#session.dsn#" name="insert_Econtables">
					update CGV3asientos
					   set IDcontable 	= #LvarIDcontable#
						 , Eerror  		= 'Aplicando...'
						 , Estatus		= 4
					 where Ecodigo	= #Arguments.Ecodigo#
					   and Eperiodo	= #Arguments.Eperiodo#
					   and Emes		= #Arguments.Emes#
					   and CG5CON	= #Arguments.CG5CON#
					   and CGBBAT	= #Arguments.CGBBAT#
				</cfquery>
			</cftransaction>
			<cfreturn LvarIDcontable>
		<cfcatch type="any">
			<cfquery datasource="#session.dsn#" name="insert_Econtables">
				update CGV3asientos
				   set Estatus = -4
					 , Eerror  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.Message# #cfcatch.Detail#">
				 where Ecodigo	= #Arguments.Ecodigo#
				   and Eperiodo	= #Arguments.Eperiodo#
				   and Emes		= #Arguments.Emes#
				   and CG5CON	= #Arguments.CG5CON#
				   and CGBBAT	= #Arguments.CGBBAT#
			</cfquery>
			<cfreturn -1>
		</cfcatch>
		</cftry>
	</cffunction>

	<!--- APLICACION DE ASIENTO GENERADO --->
	<cffunction name="sbAplicarAsiento" output="false">
		<cfargument name="Ecodigo">
		<cfargument name="Eperiodo">
		<cfargument name="Emes">
		<cfargument name="CG5CON">
		<cfargument name="CGBBAT">
		<cfargument name="IDcontable">
	
		<cftry>
			<!---<cfinvoke 
				 component="sif.Componentes.CG_AplicaAsiento"
				 method="CG_AplicaAsiento">
					 <cfinvokeargument name="IDcontable" value="#Arguments.IDcontable#"/>
					 <cfinvokeargument name="CtlTransaccion" value="true"/>
					 <cfinvokeargument name="inter" value="N"/>
			</cfinvoke>--->
			<cfquery datasource="#session.dsn#" name="insert_Econtables">
				update CGV3asientos
				   set Estatus = 4
					 , Eerror  = NULL
				 where Ecodigo	= #Arguments.Ecodigo#
				   and Eperiodo	= #Arguments.Eperiodo#
				   and Emes		= #Arguments.Emes#
				   and CG5CON	= #Arguments.CG5CON#
				   and CGBBAT	= #Arguments.CGBBAT#
			</cfquery>
		<cfcatch type="any">
			<cfquery datasource="#session.dsn#" name="insert_Econtables">
				update CGV3asientos
				   set Estatus = -4
					 , Eerror  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.Message# #cfcatch.Detail#">
				 where Ecodigo	= #Arguments.Ecodigo#
				   and Eperiodo	= #Arguments.Eperiodo#
				   and Emes		= #Arguments.Emes#
				   and CG5CON	= #Arguments.CG5CON#
				   and CGBBAT	= #Arguments.CGBBAT#
			</cfquery>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<!--- CREACION DE NUEVO ASIENTO --->
	<cffunction name="fnNuevoAsiento" returntype="numeric" output="false">
		<cfargument name="Ecodigo">
		<cfargument name="Eperiodo">
		<cfargument name="Emes">
		<cfargument name="Cconcepto">
		
		<cfquery name="rsNA2" datasource="#session.dsn#">
			select count(1) as cuenta
			  from ConceptoContableN
			 where Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and Cconcepto	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Cconcepto#">
			   and Eperiodo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Eperiodo#">
			   and Emes			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emes#">
		</cfquery>
		<cfif rsNA2.cuenta gt 0>
			<cfquery name="rsNA2" datasource="#session.dsn#">
				update ConceptoContableN
				   set Edocumento = Edocumento + 1
				 where Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				   and Cconcepto	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Cconcepto#">
				   and Eperiodo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Eperiodo#">
				   and Emes			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emes#">
			</cfquery>
		<cfelse>
			  <cftry>
					<cfquery name="rsNA2" datasource="#session.dsn#">
						insert into ConceptoContableN (Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento)
						values(
						  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Cconcepto#">
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Eperiodo#">
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emes#">
						, 1
						)
					</cfquery>
				<cfcatch>
					<cf_errorCode	code = "51119" msg = "No se pudo insertar el Concepto Contable! (Tabla: ConceptoContableN) Proceso Cancelado!">
				</cfcatch>
			</cftry>
		</cfif>
	
		<cfquery name="rsNA3" datasource="#session.dsn#">
			select Edocumento
			  from ConceptoContableN
			 where Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and Cconcepto	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Cconcepto#">
			   and Eperiodo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Eperiodo#">
			   and Emes			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emes#">
		</cfquery>
		<cfreturn rsNA3.Edocumento>
	</cffunction>
</cfcomponent>