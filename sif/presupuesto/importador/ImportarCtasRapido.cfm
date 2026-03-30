<cf_dbtemp name="Cta_ERRORES" returnvariable="Tabla_Error" datasource="#session.dsn#">
	<cf_dbtempcol name="Cuenta"		type="varchar(100)"		mandatory="yes">
	<cf_dbtempcol name="MSG"		type="varchar(1024)"	mandatory="yes">
</cf_dbtemp >

<cfset session.Importador.SubTipo = "1">

<cfquery name="rsImportador" datasource="#session.dsn#">
	select Cuenta, Descripcion from #table_name# 
	 order by Cuenta desc
</cfquery>

<cfset session.Importador.SubTipo = "2">

<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<cftry>
		<cfinvoke 	<!---component		= "sif.Componentes.PC_GeneraCuentaFinanciera" --->
					method			= "sbCreaCuentaRapida" 
		>
			<cfinvokeargument name="Ecodigo"				value="#session.Ecodigo#"/>
			<cfinvokeargument name="CFformato"				value="#rsImportador.Cuenta#"/>
			<cfinvokeargument name="CFdescripcion"			value="#rsImportador.Descripcion#"/>
			<cfinvokeargument name="Conexion"				value="#session.DSN#"/>
			<cfinvokeargument name="ActualizaDescripcion"	value="yes"/>
			<cfinvokeargument name="TransaccionActiva" 		value="no"/>
			<cfinvokeargument name="CreaCuentaPresupuesto" 	value="no"/>
		</cfinvoke>
	<cfcatch type="any">
		<cfquery datasource="#session.dsn#">
			insert into #Tabla_Error# (Cuenta, MSG)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.Cuenta#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(cfcatch.Message,1024)#">
			)
		</cfquery>
	</cfcatch>
	</cftry>
</cfloop>
<cfquery name="ERR" datasource="#session.dsn#">
	select Cuenta, MSG from #Tabla_Error#
</cfquery>

<cfset session.Importador.SubTipo = "3">


	<cffunction name="sbCreaCuentaRapida" output="false" access="public">
		<cfargument name="Ecodigo">
		<cfargument name="CFformato">
		<cfargument name="CFdescripcion">
		<cfargument name="Conexion">
		<cfargument name="ActualizaDescripcion">
		<cfargument name="TransaccionActiva" 		type="boolean" default="no">
		<cfargument name="CreaCuentaPresupuesto" 	type="boolean" default="no">

		<cfset GvarEcodigo = arguments.Ecodigo>
		<cfset GvarDSN = arguments.Conexion>

		<cfset LvarCFformato = replace(Arguments.CFformato," ","","ALL")>
		<cfset LvarCta = listToArray(trim(LvarCFformato),"-")>
		<cfset LvarCmayor = LvarCta[1]>

		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select Cmayor, Cdescripcion, Cbalancen
			  from CtasMayor
			 where Ecodigo = #GvarEcodigo#
			   and Cmayor = '#LvarCmayor#'
		</cfquery>
		<cfif rsSQL.recordcount EQ 0>
			<cfthrow message="Cuenta de Mayor '#LvarCmayor#' no existe">
		</cfif>
		<cfset LvarCdescripcion = rsSQL.Cdescripcion>
		<cfset LvarCbalancen = rsSQL.Cbalancen>
		<cfif LvarCbalancen EQ "D">
			<cfset LvarCbalancenormal = 1>
		<cfelse>
			<cfset LvarCbalancenormal = -1>
		</cfif>
			
		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select 	v.CPVid, v.CPVformatoF,
					m.PCEMid
			  from CPVigencia v
				left outer join PCEMascaras m
					 ON m.PCEMid = v.PCEMid
			 where v.Ecodigo = #GvarEcodigo#
			   and v.Cmayor = '#LvarCmayor#'
			   and #dateformat(now(),"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
		</cfquery>
		<cfif rsSQL.recordcount EQ 0>
			<cfthrow message="Cuenta de Mayor '#LvarCmayor#' no está vigente">
		</cfif>
		<cfset LvarCPVid = rsSQL.CPVid>
		<cfset LvarPCEMid = rsSQL.PCEMid>
		<cfset LvarFormato = trim(rsSQL.CPVformatoF)>
		
		<cfquery name="rsCta" datasource="#GvarDSN#">
			select CFcuenta, Ccuenta
			  from CFinanciera
			 where Ecodigo		= #GvarEcodigo#
			   and CFformato	= '#LvarCFformato#'
			   and CPVid		= #LvarCPVid#
		</cfquery>
		<cfset LvarCtaYaExiste = (rsCta.recordcount GT 0)>

		<!--- Genera con Mascara Predefinida, con o sin plan de cuentas --->
		<cfif LvarPCEMid NEQ "">
			<cfif LvarCtaYaExiste AND NOT Arguments.ActualizaDescripcion>
				<cfreturn>
			</cfif>
			
			<cfif isdefined("request.CP_Automatico")>
				<cfset Arguments.CreaCuentaPresupuesto = false>
			</cfif>
			<cfif Arguments.CreaCuentaPresupuesto>
				<cfset request.CP_Automatico = true>
			</cfif>
			<cfinvoke	<!--- component="sif.Componentes.PC_GeneraCuentaFinanciera" --->
						method="fnGeneraCFformato"
						returnvariable="LvarMSG"
						
						Lprm_Ecodigo			= "#GvarEcodigo#"
						Lprm_CFformato			= "#GvarCFformato#"
						Lprm_Fecha				= "#now()#"
						Lprm_Ocodigo			= "-1"
						Lprm_Cdescripcion		= "#Arguments.CFdescripcion#"
						Lprm_TransaccionActiva	= "#Arguments.TransaccionActiva#"
						Lprm_DSN				= "#GvarDSN#"
			>
			<cfif Arguments.CreaCuentaPresupuesto>
				<cfset request.CP_Automatico = false>
				<cfset structDelete(request,"CP_Automatico")>
			</cfif>
			<cfif LvarMSG NEQ "OLD" AND LvarMSG NEQ "NEW">
				<cfthrow message="#LvarMSG#">
			</cfif>
			<cfreturn>
		</cfif>
		
		<!--- Genera con formato de Parámetros o formato propio --->
		<cfif LvarCtaYaExiste>
			<cfif Arguments.ActualizaDescripcion>
				<cfquery datasource="#GvarDSN#">
					update CFinanciera
					   set CFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFdescripcion#">
					 where CFcuenta = #rsCta.CFcuenta#
				</cfquery>
				<cfquery datasource="#GvarDSN#">
					update CContables
					   set Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFdescripcion#">
					 where Ccuenta = #rsCta.Ccuenta#
				</cfquery>
			</cfif>
			<cfreturn>
		</cfif>
		
		<cfset LvarFto = listToArray(LvarFormato,"-")>
		<cfset LvarCtaN = arrayLen(LvarCta)>
		<cfif LvarCtaN GT arrayLen(LvarFto)>
			<cfthrow message="Control de Formato: El formato de la cuenta '#LvarCFformato#' no corresponde con el formato asociado a la Cuenta Mayor '#LvarFormato#'">
		</cfif>
		<cfset LvarFormato = "">
		<cfset LvarCcuenta = "">
		<cfset LvarCFcuenta = "">
		<cfset LvarCpadre = "">
		<cfset LvarCFpadre = "">
		<cfset LvarCcubo = arrayNew(1)>
		<cfset LvarCFcubo = arrayNew(1)>
		<cfif Arguments.TransaccionActiva>
			<cfset sbCreaCuentaRapidaPrivate(Arguments.CFformato, Arguments.CFdescripcion, Arguments.CreaCuentaPresupuesto)>
		<cfelse>
			<cftransaction>
				<cfset sbCreaCuentaRapidaPrivate(Arguments.CFformato, Arguments.CFdescripcion, Arguments.CreaCuentaPresupuesto)>
			</cftransaction>
		</cfif>
	</cffunction>

	<cffunction name="sbCreaCuentaRapidaPrivate" output="false" access="private">
		<cfargument name="CFformato">
		<cfargument name="CFdescripcion">
		<cfargument name="CreaCuentaPresupuesto">

		<cfloop index="i" from="1" to="#LvarCtaN#">
			<cfif len(LvarCta[i]) NEQ len(LvarFto[i])>
				<cfthrow message="Control de Formato: El formato de la cuenta '#LvarCFformato#' no corresponde con el formato asociado a la Cuenta Mayor '#LvarFormato#'">
			</cfif>
			<cfset LvarFormato = listAppend(LvarFormato,LvarCta[i],"-")>
			
			<!--- Procesa CContables --->
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select Ccuenta
				  from CContables
				 where Ecodigo = #GvarEcodigo#
				   and Cformato = '#LvarFormato#'
			</cfquery>
			<cfif rsSQL.Ccuenta NEQ "">
				<cfset LvarCcuenta = rsSQL.Ccuenta>
				<cfif i LT LvarCtaN>
					<cfquery datasource="#GvarDSN#">
						update CContables
						   set Cmovimiento = 'N'
						 where Ccuenta = #LvarCcuenta#
					</cfquery>
				</cfif>
			<cfelse>
				<!--- Crea el nivel contable --->
				<cfquery name="rsInsert" datasource="#GvarDSN#">
					insert into CContables (
						Ecodigo, Cmayor, Cformato, Cbalancen, Cbalancenormal,
						Cpadre,
						Cmovimiento, Cdescripcion
						)
					values
					(
						#GvarEcodigo#, '#LvarCmayor#','#LvarFormato#', '#LvarCbalancen#', #LvarCbalancenormal#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCpadre#" null="#LvarCpadre EQ ''#">,
					<cfif i LT LvarCtaN>
						'N', <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCdescripcion# - Nivel #i-1#">
					<cfelse>
						'S', <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFdescripcion#">
					</cfif>						
					)
					<cf_dbidentity1 name="rsInsert" datasource="#GvarDSN#" returnvariable="LvarCcuenta">
				</cfquery>
				<cf_dbidentity2 name="rsInsert" datasource="#GvarDSN#" returnvariable="LvarCcuenta">
			</cfif>
			<cfset arrayAppend(LvarCcubo,LvarCcuenta)>
			<cfset LvarCpadre = LvarCcuenta>

			<!--- Procesa CFinanciera --->
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select CFcuenta
				  from CFinanciera
				 where Ecodigo = #GvarEcodigo#
				   and CFformato = '#LvarFormato#'
				   and CPVid = #LvarCPVid#
			</cfquery>
			<cfif rsSQL.CFcuenta NEQ "">
				<cfset LvarCFcuenta = rsSQL.CFcuenta>
				<cfif i LT LvarCtaN>
					<cfquery datasource="#GvarDSN#">
						update CFinanciera
						   set CFmovimiento = 'N'
						 where CFcuenta = #rsSQL.CFcuenta#
					</cfquery>
				</cfif>
			<cfelse>
				<!--- Crea el nivel --->
				<cfquery name="rsInsert" datasource="#GvarDSN#">
					insert into CFinanciera (
						CPVid,
						Ecodigo, Cmayor, CFformato, 
						Ccuenta, CFpadre,
						CFmovimiento, CFdescripcion
					)
					values
					(
						#LvarCPVid#,
						#GvarEcodigo#, '#LvarCmayor#','#LvarFormato#',
						#LvarCcuenta#, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFpadre#" null="#LvarCFpadre EQ ''#">,
					<cfif i LT LvarCtaN>
						'N', <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCdescripcion# - Nivel #i-1#">
					<cfelse>
						'S', <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFdescripcion#">
					</cfif>						
					)
					<cf_dbidentity1 name="rsInsert" datasource="#GvarDSN#" returnvariable="LvarCFcuenta">
				</cfquery>
				<cf_dbidentity2 name="rsInsert" datasource="#GvarDSN#" returnvariable="LvarCFcuenta">
			</cfif>
			<cfset arrayAppend(LvarCFcubo,LvarCFcuenta)>
			<cfset LvarCFpadre = LvarCFcuenta>
		</cfloop>
		<cfloop index="i" from="1" to="#LvarCtaN#">
			<!--- Crea el cubo contable --->
			<cfquery datasource="#GvarDSN#">
				insert into PCDCatalogoCuenta (Ccuenta, Ccuentaniv, PCDCniv)
				values (#LvarCcuenta#, #LvarCcubo[i]#, #i-1#)
			</cfquery>
			<!--- Crea el cubo financiero --->
			<cfquery datasource="#GvarDSN#">
				insert into PCDCatalogoCuentaF (CFcuenta, CFcuentaniv, PCDCniv)
				values (#LvarCFcuenta#, #LvarCFcubo[i]#, #i-1#)
			</cfquery>
		</cfloop>
	</cffunction>
