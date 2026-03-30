<!--- 	
	PC_GeneraCuentaFinanciera	VERSION 2:
	
			fnGeneraCuentaFinanciera:	Método tradicional, con demasiados parámetros, 
										para verificar y generar o solo verificar Cuenta Financiera + Presupuesto + de Version
					MSG = fnGeneraCtas(
							Lprm_CFformato,Lprm_Cmayor,Lprm_Cdetalle,Lprm_Ocodigo,Lprm_Fecha,Lprm_VerificarExistencia,Lprm_CrearConPlan,Lprm_CrearSinPlan,
							Lprm_CrearPresupuesto,Lprm_EsDePresupuesto,Lprm_CPPid,Lprm_CVid,Lprm_CVPtipoControl,Lprm_CVPcalculoControl,Lprm_Cdescripcion,Lprm_Cbalancen,
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_Ecodigo,
							Lprm_SoloVerificar, Lprm_NoVerificarPres, Lprm_NoVerificarSinOfi, Lprm_NoVerificarObras, Lprm_Verificar_CFid
							)
					Resultado MSG: 
						"NEW" = Cuenta Generada, 
						"OLD" = Cuenta Existente, 
						cualquier otra cosa es ERROR

			fnGeneraCFformato:			Verifica el formato de una Cuenta Financiera y si no existe lo Genera
					MSG = fnGeneraCFformato (	
							Lprm_Ecodigo,Lprm_CFformato,Lprm_Ocodigo,Lprm_Fecha,
							Lprm_Cdescripcion,Lprm_Cbalancen,
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_NoVerificarObras, Lprm_Verificar_CFid
							)
					Resultado MSG: 
						"NEW" = Cuenta Generada, 
						"OLD" = Cuenta Existente, 
						cualquier otra cosa es ERROR

			fnVerificaCFformato:			Verifica el formato de una Cuenta Financiera
					MSG = fnVerificaCFformato (	
												Lprm_Ecodigo,Lprm_CFformato,Lprm_Ocodigo,Lprm_Fecha,
												Lprm_VerificarExistencia,Lprm_NoVerificarPres,Lprm_NoVerificarSinOfi
												Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_NoVerificarObras, Lprm_Verificar_CFid
											)
					Resultado MSG: 
						"NEW" = Cuenta Generada, 
						"OLD" = Cuenta Existente, 
						cualquier otra cosa es ERROR

			fnGeneraCPformato:			Verifica el formato de una Cuenta de Presupuesto y si no existe lo Genera, o lo incluye en el Período de Presupuesto
					MSG = fnGeneraCPformato (	
							Lprm_Ecodigo,Lprm_CPformato,Lprm_Ocodigo,Lprm_Fecha,
							Lprm_CPPid, Lprm_CVPtipoControl, Lprm_CVPcalculoControl,
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN
							)
					Resultado MSG: 
						"NEW" = Cuenta Generada, 
						"OLD" = Cuenta Existente, 
						cualquier otra cosa es ERROR

			fnVerificaCPformato:			Verifica el formato de una Cuenta de Presupuesto
					MSG = fnVerificaCPformato (	
							Lprm_Ecodigo,Lprm_CPformato,Lprm_Ocodigo,Lprm_Fecha,
							Lprm_CPPid, Lprm_VerificarExistencia, Lprm_NoVerificarSinOfi,
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN
							)
					Resultado MSG: 
						"NEW" = Cuenta Generada, 
						"OLD" = Cuenta Existente, 
						cualquier otra cosa es ERROR

			fnGeneraCVPformato:			Verifica y Genera el formato de una Cuenta de Presupuesto dentro de una Versión de Formulación
					MSG = fnGeneraCVPformato (	
							Lprm_Ecodigo,Lprm_CPformato,Lprm_Ocodigo,Lprm_Fecha,
							Lprm_CVid, Lprm_CVPtipoControl, Lprm_CVPcalculoControl,
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN
							)
					Resultado MSG: 
						"NEW" = Cuenta Generada, 
						"OLD" = Cuenta Existente, 
						cualquier otra cosa es ERROR


			fnObtieneCFcuenta:			Obtiene el CFcuenta de un CFformato, tomando en cuenta la Vigencia a una fecha indicada.
										Como generalmente se requiere el CFcuenta despues de usar GeneraCuentaFinanciera, 
										hay un mecanismo para dar el CFcuenta sin leer la Base de Datos
					RES = fnObtieneCFcuenta (Lprm_Ecodigo,Lprm_CFformato,Lprm_Fecha)
					Resultado RES: 
						RES.CFcuenta:		Si es blanco es porque o No Existe o no está Vigente (para efectos prácticos No Existe)
						RES.noVigente		Si RES.CFcuenta es blanco indica si no está Vigente
						RES.CFdescripcionF
						RES.Ccuenta
						RES.CPcuenta

							<cfif RES.CFcuenta EQ "">
								<cfif RES.noVigente>
									<cf_errorCode	code = "51238" msg = "Cuenta Financiera no esta vigente en la fecha indicada">
								<cfelse>
									<cf_errorCode	code = "51239" msg = "Cuenta Financiera no existe">
								</cfif>
							</cfif>

			fnObtieneCPcuenta:			Obtiene el CPcuenta de un CPformato, tomando en cuenta la Vigencia a una fecha indicada.
					RES = fnObtieneCPcuenta (Lprm_Ecodigo,Lprm_CPformato,Lprm_Fecha)
					Resultado RES: 
						RES.CPcuenta:		Si es blanco es porque o No Existe o no está Vigente (para efectos prácticos No Existe)
						RES.noVigente		Si RES.CFcuenta es blanco indica si no está Vigente
						RES.CPdescripcionF

							<cfif RES.CPcuenta EQ "">
								<cfif RES.noVigente>
									<cf_errorCode	code = "51240" msg = "Cuenta de Presupuesto no esta vigente en la fecha indicada">
								<cfelse>
									<cf_errorCode	code = "51241" msg = "Cuenta de Presupuesto no existe">
								</cfif>
							</cfif>
--->
<cfcomponent>
	<cf_dbfunction name="OP_concat"	returnvariable="_CAT" datasource="asp">
	<cfset LvarFechaNULL = createDate(1900,1,1)>
	<cffunction name="fnGeneraCuentaFinanciera" access="public" output="yes" returntype="string">
		<!--- Se debe pasar o Lprm_CFformato o Lprm_Cmayor+Lprm_Cdetalle --->
		<!--- RESULTADO 'NEW' u 'OLD' es OK, cualquier otra cosa es ERROR --->
		<cfargument name="Lprm_CFformato" 			type="string"  default="°">  
		<cfargument name="Lprm_Cmayor" 				type="string"  default="°">
		<cfargument name="Lprm_Cdetalle" 			type="string"  default="°">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" default="-1">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">

		<cfargument name="Lprm_EsDePresupuesto"		type="boolean" default="false">

		<cfargument name="Lprm_VerificarExistencia"	type="boolean" default="#fnVerificarExistenciaDefault(Arguments.Lprm_EsDePresupuesto)#">
		<cfargument name="Lprm_CrearConPlan"		type="boolean" default="#NOT Arguments.Lprm_VerificarExistencia#">
		<cfargument name="Lprm_CrearSinPlan"		type="boolean" default="#NOT Arguments.Lprm_VerificarExistencia#">
		<cfargument name="Lprm_CrearPresupuesto"	type="boolean" default="#NOT Arguments.Lprm_VerificarExistencia AND Lprm_EsDePresupuesto#">

		<cfargument name="Lprm_CPPid"				type="numeric" default="-1">
		<cfargument name="Lprm_CVid"				type="numeric" default="-1">
		<cfargument name="Lprm_CVPtipoControl"		type="numeric" default="-1">
		<cfargument name="Lprm_CVPcalculoControl"	type="numeric" default="-1">
		<cfargument name="Lprm_Cdescripcion"		type="string"  default="">
		<cfargument name="Lprm_Cbalancen"			type="string"  default="°">

		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		<cfargument name="Lprm_debug" 				type="boolean" default="false">
		<cfargument name="Lprm_DSN" 				type="string"  default="">
		<cfargument name="Lprm_Ecodigo" 			type="string"  default="">
		<cfargument name="Lprm_SoloVerificar"		type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarPres"		type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarSinOfi"	type="boolean" default="true">
		<!--- OJO:	Lprm_NoVerificarSinOfi debe tener default "false" pero primero hay que modificar todas las pantallas --->
		<cfargument name="Lprm_NoVerificarObras"	type="boolean" default="false">
		<!--- OJO:	Lprm_NoVerificarObras debe utilizarse únicamente en el Sistema de Obras, 
					para que se brinca el Control de Obras en Agregar cuentas y Liquidacion --->
		<cfargument name="Lprm_Verificar_CFid" 		type="numeric" default="-1">
		<!--- 		Lprm_Verificar_CFid: ignora el Lprm_Ocodigo y utiliza el Ocodigo del CF, 
					además realiza el Control de máscaras por Centro Funcional --->
		<cfargument name="Lprm_EsDePlanCompras" 	type="boolean" default="false">
	
		<cfreturn fnGeneraCtas(
					Lprm_CFformato,Lprm_Cmayor,Lprm_Cdetalle,
					Lprm_Ocodigo,
					Lprm_Fecha,
					Lprm_CrearConPlan,Lprm_CrearSinPlan,Lprm_CrearPresupuesto,Lprm_EsDePresupuesto,
					Lprm_CPPid,Lprm_CVid,
					Lprm_CVPtipoControl,Lprm_CVPcalculoControl,
					Lprm_Cdescripcion,Lprm_Cbalancen,
					
					Lprm_TransaccionActiva,Lprm_debug,
					Lprm_DSN,Lprm_Ecodigo,
					Lprm_SoloVerificar, 
					Lprm_NoVerificarPres, Lprm_NoVerificarSinOfi, Lprm_NoVerificarObras,Lprm_Verificar_CFid, 
					Lprm_EsDePlanCompras
				)
		>
	</cffunction>

	<!--- Esta funcion se necesita para hacer un cfif en cfargument --->
	<cffunction name="fnVerificarExistenciaDefault" access="private" output="no" returntype="boolean">
		<cfargument name="Lprm_EsDePresupuesto"		type="boolean" default="false">
		
		<cfif Arguments.Lprm_EsDePresupuesto>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="fnGeneraCtas" access="private" output="no" returntype="string">
		<!--- Se debe pasar o Lprm_CFformato o Lprm_Cmayor+Lprm_Cdetalle --->
		<!--- RESULTADO 'NEW' u 'OLD' es OK, cualquier otra cosa es ERROR --->
		<cfargument name="Lprm_CFformato" 			type="string"  default="°">  
		<cfargument name="Lprm_Cmayor" 				type="string"  default="°">
		<cfargument name="Lprm_Cdetalle" 			type="string"  default="°">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" default="-1">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_CrearConPlan"		type="boolean" default="false">
		<cfargument name="Lprm_CrearSinPlan"		type="boolean" default="false">
		<cfargument name="Lprm_CrearPresupuesto"	type="boolean" default="false">
		<cfargument name="Lprm_EsDePresupuesto"		type="boolean" default="false">
		<cfargument name="Lprm_CPPid"				type="numeric" default="-1">
		<cfargument name="Lprm_CVid"				type="numeric" default="-1">
		<cfargument name="Lprm_CVPtipoControl"		type="numeric" default="-1">
		<cfargument name="Lprm_CVPcalculoControl"	type="numeric" default="-1">
		<cfargument name="Lprm_Cdescripcion"		type="string"  default="">
		<cfargument name="Lprm_Cbalancen"			type="string"  default="°">
		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		<cfargument name="Lprm_debug" 				type="boolean" default="true">
		<cfargument name="Lprm_DSN" 				type="string"  default="">
		<cfargument name="Lprm_Ecodigo" 			type="string"  default="">
		<cfargument name="Lprm_SoloVerificar"		type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarPres"		type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarSinOfi"	type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarObras"	type="boolean" default="false">
		<cfargument name="Lprm_Verificar_CFid" 		type="numeric" default="-1">
		<cfargument name="Lprm_EsDePlanCompras" 	type="boolean" default="false">
	
		<cfset var LvarMSG = "">

		<cfset request.PC_GeneraCFctaAnt = structNew()>
        
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_VerifCta" 	Default="VERIFICACION DE CUENTA" returnvariable="LB_VerifCta" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ErrEjec" 	Default="ERROR EJECUCION" returnvariable="LB_ErrEjec" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
        
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CtaVerForPr" 	Default="La cuenta es de Versión de Formulación de Presupuesto" returnvariable="LB_CtaVerForPr" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CtaesdePr" 	Default="La cuenta es de Presupuesto" returnvariable="LB_CtaesdePr" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CtaesdePlCmpr" 	Default="La cuenta es de Plan de Compras" returnvariable="LB_CtaesdePlCmpr" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>



		<cftry>
			<cfset GvarIDtemp = NumberFormat(int(rand()*1e18),"0")>
			<cfset GvarBMfecha = "#now()#">
			<cfset NIVELES = "PC_NIVELES">

			<cfif arguments.Lprm_DSN NEQ "">
				<cfset GvarDSN = arguments.Lprm_DSN>
			<cfelse>
				<cfset GvarDSN = session.dsn>
			</cfif>
	
			<cfif Application.dsinfo[GvarDSN].type EQ "sqlserver">
				<cfset NOLOCK	= " WITH (NOLOCK) ">
				<cfset ROWLOCK	= " WITH (ROWLOCK) ">
			<cfelse>
				<cfset NOLOCK	= "">
				<cfset ROWLOCK	= "">
			</cfif>
	
			<cfif arguments.Lprm_Ecodigo NEQ "">
				<cfset GvarEcodigo = arguments.Lprm_Ecodigo>
			<cfelse>
				<cfset GvarEcodigo = session.Ecodigo>
			</cfif>
	
			<cfif arguments.Lprm_Fecha EQ LvarFechaNULL>
				<cfset arguments.Lprm_Fecha = fnFechaDefault()>
			</cfif>
			
			<cfif Lprm_CFformato NEQ "°">
				<cfset Lprm_Cmayor = mid(Lprm_CFformato,1,4)>
				<cfset Lprm_Cdetalle = mid(Lprm_CFformato,6,100)>
			<cfelseif Lprm_Cmayor EQ "°" OR Lprm_Cdetalle EQ "°">
				<cf_errorCode	code = "51242" msg = "The parameter [Lprm_CFformato] OR [Lprm_Cmayor AND Lprm_Cdetalle] to function fnGeneraCuentaFinanciera is required but was not passed in.">
				<cfreturn "The parameter [Lprm_CFformato] OR [Lprm_Cmayor AND Lprm_Cdetalle] to function fnGeneraCuentaFinanciera is required but was not passed in.">
			</cfif>
			<cfset Lprm_Cmayor 	 = trim(Lprm_Cmayor)>
			<cfset Lprm_Cdetalle = trim(Lprm_Cdetalle)>
			<cfset Lvar_fmtVerif = Lprm_Cmayor & '-' & Lprm_Cdetalle>	<!--- Formato de la cuenta completa a revisar --->

			<cfset IsLock = arrayNew(1)>
			<cflock name="#GvarEcodigo#-#left(Lvar_fmtVerif,15)#" throwontimeout="yes" timeout="10" type="exclusive">
				<cfset sbIniciar_PC_GeneraCFctaAnt(	GvarEcodigo, Lvar_fmtVerif, Arguments.Lprm_Fecha )> 
				<cfif Lprm_CVid	NEQ "-1">
					<cfset request.PC_GeneraCFctaAnt.MSG = "#LB_CtaVerForPr#">
				<cfelseif Lprm_EsDePresupuesto>
					<cfset request.PC_GeneraCFctaAnt.MSG = "#LB_CtaesdePr#">
				<cfelseif Lprm_EsDePlanCompras>
					<cfset request.PC_GeneraCFctaAnt.MSG = "#LB_CtaesdePlCmpr#">
				</cfif>
				
				<cfset LvarMSG = fnGeneraCtasLck (
									IsLock,
									Lprm_CFformato, Lprm_Cmayor, Lprm_Cdetalle,
									Lprm_Ocodigo,
									Lprm_Fecha,
									Lprm_CrearConPlan, Lprm_CrearSinPlan, Lprm_CrearPresupuesto, Lprm_EsDePresupuesto,
									Lprm_CPPid, Lprm_CVid,
									Lprm_CVPtipoControl, Lprm_CVPcalculoControl,
									Lprm_Cdescripcion, Lprm_Cbalancen,
									
									Lprm_TransaccionActiva,
									Lprm_debug,
									Lprm_DSN,
									Lprm_Ecodigo,
									Lprm_SoloVerificar,
									Lprm_NoVerificarPres,
									Lprm_NoVerificarSinOfi,
									Lprm_NoVerificarObras,
									Lprm_Verificar_CFid,
									Lprm_EsDePlanCompras
								)
				>
				<cfset sbBorrarNIVELES()>
			</cflock>
			<cfif LvarMSG EQ "NEW" OR LvarMSG EQ "OLD">
				<cfreturn LvarMSG>
			<cfelse>
				<cfset LvarMSG = "#LB_VerifCta# '#Lvar_fmtVerif#':#chr(10)#  #LvarMSG#"> 
				<cfset sbLimpiar_PC_GeneraCFctaAnt(	LvarMSG )> 
				<cfreturn LvarMSG>
			</cfif>
		<cfcatch type="any">
			<cfset sbBorrarNIVELES()>
			<cfset sbLimpiar_PC_GeneraCFctaAnt(	"#LB_ErrEjec# '#Lvar_fmtVerif#':  #cfcatch.Message# #cfcatch.Detail#" )> 
			<cfrethrow>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="sbBorrarNIVELES" access="private" output="no" returntype="void">
		<!--- ===================================================================================================== --->
		<!--- Borrado de las transacciones que quedaron en la tabla Fisica                                          --->
		<!--- ===================================================================================================== --->

		<cfquery name="rsBorraTablaFisica" datasource="#GvarDSN#">
			delete from #NIVELES# #ROWLOCK#
			 where IDtemp  = #GvarIDtemp#
			   and BMfecha = #GvarBMfecha#
		</cfquery>
	</cffunction>
	
	<cffunction name="fnGeneraCtasLck" access="private" output="no" returntype="string">
		<!--- Se debe pasar o Lprm_CFformato o Lprm_Cmayor+Lprm_Cdetalle --->
		<!--- RESULTADO 'NEW' u 'OLD' es OK, cualquier otra cosa es ERROR --->
		<cfargument name="Usar_fnGeneraCtas" 		type="array"   required="yes">
		<cfargument name="Lprm_CFformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Cmayor" 				type="string"  required="yes">
		<cfargument name="Lprm_Cdetalle" 			type="string"  required="yes">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    required="yes">
		<cfargument name="Lprm_CrearConPlan"		type="boolean" required="yes">
		<cfargument name="Lprm_CrearSinPlan"		type="boolean" required="yes">
		<cfargument name="Lprm_CrearPresupuesto"	type="boolean" required="yes">
		<cfargument name="Lprm_EsDePresupuesto"		type="boolean" required="yes">
		<cfargument name="Lprm_CPPid"				type="numeric" required="yes">
		<cfargument name="Lprm_CVid"				type="numeric" required="yes">
		<cfargument name="Lprm_CVPtipoControl"		type="numeric" required="yes">
		<cfargument name="Lprm_CVPcalculoControl"	type="numeric" required="yes">
		<cfargument name="Lprm_Cdescripcion"		type="string"  required="yes">
		<cfargument name="Lprm_Cbalancen"			type="string"  required="yes">
		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" required="yes">
		<cfargument name="Lprm_debug" 				type="boolean" required="yes">
		<cfargument name="Lprm_DSN" 				type="string"  required="yes">
		<cfargument name="Lprm_Ecodigo" 			type="string"  required="yes">
		<cfargument name="Lprm_SoloVerificar"		type="boolean" required="yes">
		<cfargument name="Lprm_NoVerificarPres"		type="boolean" required="yes">
		<cfargument name="Lprm_NoVerificarSinOfi"	type="boolean" required="yes">
		<cfargument name="Lprm_NoVerificarObras"	type="boolean" required="yes">
		<cfargument name="Lprm_Verificar_CFid" 		type="numeric" required="yes">
		<cfargument name="Lprm_EsDePlanCompras" 	type="boolean" required="yes">

		<cfset var LvarMSG = "">
		
		<cfset LvarERRs  = "">									<!--- Mensaje de Errores para regresar a la aplicacion --->

		<!--- VERIFICACION DE EMPRESA Y OFICINA / CENTRO FUNCIONAL --->
		<!--- El CFid tiene prioridad sobre Ocodigo --->
		<cfquery name="rsEmpresa" datasource="#GvarDSN#">
			select e.Ecodigo, e.Edescripcion, CEaliaslogin as CEalias
			  from Empresas e
			  	inner join <cf_dbdatabase table="CuentaEmpresarial" datasource="asp"> c
					on c.CEcodigo = e.cliente_empresarial
			 where e.Ecodigo = #GvarEcodigo#
		</cfquery>
		<cfif rsEmpresa.Ecodigo EQ "">
			<cfreturn "No existe Empresa Ecodigo=[#GvarEcodigo#]">
		</cfif>
		<cfset GvarCEalias = rsEmpresa.CEalias>

		<cfif Lprm_Ocodigo NEQ "-1">
			<cfquery name="rsOfi" datasource="#GvarDSN#">
				select ofi.Ocodigo, ofi.Oficodigo, ofi.Odescripcion
				  from Oficinas ofi
				 where ofi.Ecodigo = #GvarEcodigo#
				   and ofi.Ocodigo	= #Lprm_Ocodigo#
			</cfquery>
			<cfif rsOfi.Ocodigo EQ "">
				<cfreturn "La Oficina Ocodigo=[#Lprm_Ocodigo#] no pertenece a la Empresa='#rsEmpresa.Edescripcion#'">
			</cfif>
		</cfif>

		<cfif Lprm_Verificar_CFid NEQ "-1">
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select cf.Ecodigo, cf.CFcodigo, cf.Ocodigo, cf.CFdescripcion
				  from CFuncional cf
				 where cf.CFid = #Lprm_Verificar_CFid#
			</cfquery>
			<cfif rsSQL.Ecodigo EQ "">
				<cfreturn "No existe Centro Funcional CFid=[#Lprm_Verificar_CFid#]">
			<cfelseif rsEmpresa.Ecodigo NEQ rsSQL.Ecodigo>
				<cfreturn "El Centro Funcional '#trim(rsSQL.CFcodigo)#' CFid=[#Lprm_Verificar_CFid#] no pertenece a la Empresa '#rsEmpresa.Edescripcion#'">
			<cfelseif Lprm_Ocodigo NEQ -1 AND Lprm_Ocodigo NEQ rsSQL.Ocodigo>
				<cfreturn "El Centro Funcional '#trim(rsSQL.CFcodigo)#-#rsSQL.CFdescripcion#' CFid=[#Arguments.Verificar_CFid#] no pertenece a la Oficina='#rsOfi.Oficodigo#-#rsOfi.Odescripcion#'">
			</cfif>
			<cfset Lprm_Ocodigo = rsSQL.Ocodigo>
		</cfif>

		<cfif ucase(GvarCEalias) EQ 'GRUPOICE' AND Lprm_Ocodigo NEQ "-1" AND Lprm_CVid EQ "-1" AND NOT Lprm_EsDePresupuesto>
			<!---  Verificar si la cuenta existe ya --->
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select 	cf.CFcuenta,		coalesce(cf.CFdescripcionF,cf.CFdescripcion) as CFdescripcionF,
						cf.CFmovimiento,	coalesce(c.Mcodigo, 1) as Auxiliar,
						cf.Cmayor,			m.Ctipo,
						cf.Ccuenta,			c.Cformato, 
						cf.CPcuenta,		'' as CPformato
				  from CFinanciera cf
					inner join CtasMayor m
					   on m.Ecodigo = cf.Ecodigo
					  and m.Cmayor  = cf.Cmayor
					inner join CContables c
					   on c.Ccuenta = cf.Ccuenta
				 where cf.CFformato	= '#Lvar_fmtVerif#'
				   and cf.Ecodigo	= #GvarEcodigo#
			</cfquery>
			
			<cfif rsSQL.CFcuenta NEQ "">
				<cfquery name="rs" datasource="#GvarDSN#">
					set nocount on 
					declare @MSG varchar(1024)
					select  @MSG = 'LA CUENTA NO SE PUDO VALIDAR ...'
					exec sif_interfaces..sp_ValidaCuentaExistente
							  @Ecodigo		= #GvarEcodigo#
							, @CFcuenta		= #rsSQL.CFcuenta#
							, @Ccuenta		= #rsSQL.Ccuenta#
							, @Oficodigo	= '#rsOfi.Oficodigo#'
							, @CFformato	= '#Lvar_fmtVerif#' 
							, @Cmayor		= '#rsSQL.Cmayor#'
							, @Cdetalle		= '#replace(mid(Lvar_fmtVerif,6,100),"-","","ALL")#'
							, @Cmovimiento	= '#rsSQL.CFmovimiento#'
							, @Fecha		= '#dateFormat(Arguments.Lprm_Fecha,"YYYYMMDD")#'
							, @MSG_sal		= @MSG output
							, @GenError		= 'N'
					select @MSG as MSG
					set nocount off
				</cfquery> 

				<cfif rs.MSG EQ "OK">
					<cfset sbGuardar_PC_GeneraCFctaAnt(	GvarEcodigo, 	Lvar_fmtVerif, 		Arguments.Lprm_Fecha,
														"OLD",
														rsSQL.CFcuenta, rsSQL.CFdescripcionF,
														rsSQL.Ccuenta,  rsSQL.Cformato, 
														rsSQL.CPcuenta, rsSQL.CPformato, 
														rsSQL.Ctipo, 	rsSQL.CFmovimiento,	rsSQL.Auxiliar)>

					<cfreturn "OLD">
				<cfelse>
					<cfreturn rs.MSG>
				</cfif>
			</cfif>
		</cfif>

		<cfif NOT Lprm_EsDePresupuesto AND Lprm_Ocodigo EQ "-1" AND NOT Lprm_NoVerificarSinOfi AND NOT Lprm_SoloVerificar>
			<cfreturn "ERROR INVOCACION PC_GeneraCuentaFinanciera: No se envi&oacute; la Oficina y no se envi&oacute; el indicador de No verificar sin Oficina">
		</cfif>
		
		<cfif Lprm_EsDePresupuesto AND Lprm_NoVerificarPres>
			<cf_errorCode	code = "51243" msg = "ERROR INVOCACION PC_GeneraCuentaFinanciera: No se puede indicar NoVerificarPres cuando se genera o verifica una Cuenta de Presupuesto">
		<cfelseif NOT Lprm_SoloVerificar AND Lprm_NoVerificarPres AND NOT Lprm_EsDePlanCompras>
			<cf_errorCode	code = "51244" msg = "ERROR INVOCACION PC_GeneraCuentaFinanciera: Solo se puede indicar NoVerificarPres cuando se indica SoloVerificar una Cuenta Financiera">
		</cfif>

		<cfif Lprm_CrearPresupuesto OR Lprm_EsDePresupuesto>
			<cfset Lprm_EsDePresupuesto = true>

			<cfif Lprm_CVid EQ "-1" and Lprm_CPPid EQ "-1">
				<cfreturn "The parameter [Lprm_CVid] OR [Lprm_CPPid] to function fnGeneraCuentaFinanciera is required when [Lprm_EsDePresupuesto] but was not passed in.">
				<cf_errorCode	code = "51245" msg = "The parameter [Lprm_CVid] OR [Lprm_CPPid] to function fnGeneraCuentaFinanciera is required when [Lprm_EsDePresupuesto] but was not passed in.">
			</cfif>
			<cfif Lprm_CVid NEQ "-1" and Lprm_CPPid NEQ "-1">
				<cfreturn "The parameter [Lprm_CVid] AND [Lprm_CPPid] to function fnGeneraCuentaFinanciera are exclusive but were passed both.">
				<cf_errorCode	code = "51246" msg = "The parameter [Lprm_CVid] AND [Lprm_CPPid] to function fnGeneraCuentaFinanciera are exclusive but were passed both.">
			</cfif>

			<cfif Lprm_CVid EQ "-1">
				<!--- No Es Control de Version --->
				<cfif Arguments.Lprm_CVPtipoControl EQ "-1">
					<cfreturn "The parameter [Lprm_CVPtipoControl] to function fnGeneraCuentaFinanciera is required when [Lprm_CPPid] but was not passed in.">
					<cf_errorCode	code = "51247" msg = "The parameter [Lprm_CVPtipoControl] to function fnGeneraCuentaFinanciera is required when [Lprm_CPPid] but was not passed in.">
				</cfif>
				<cfif Arguments.Lprm_CVPcalculoControl EQ "-1">
					<cfreturn "The parameter [Lprm_CVPcalculoControl] to function fnGeneraCuentaFinanciera is required when [Lprm_CPPid] but was not passed in.">
					<cf_errorCode	code = "51248" msg = "The parameter [Lprm_CVPcalculoControl] to function fnGeneraCuentaFinanciera is required when [Lprm_CPPid] but was not passed in.">
				</cfif>
				<cfset Lvar_CVPtipoControl 		= Arguments.Lprm_CVPtipoControl>
				<cfset Lvar_CVPcalculoControl 	= Arguments.Lprm_CVPcalculoControl>

				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select CPPid, CPPanoMesDesde, CPPanoMesHasta, CPPfechaDesde, CPPfechaHasta,
							case CPPtipoPeriodo
								when 1 then 'Mensual' when 2 then 'Bimensual' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' 
							end as Tipo
					  from CPresupuestoPeriodo
					 where Ecodigo 	= #GvarEcodigo#
					   and CPPid 	= #Lprm_CPPid#
				</cfquery>
				<cfif rsSql.recordcount eq 0>
					<cfreturn "ERROR INVOCACION PC_GeneraCuentaFinanciera: Error en el Periodo Digitado. No existe el Periodo de Presupuesto id='[#Lprm_CPPid#]'">
				</cfif>
				<cfif NOT (dateFormat(Lprm_Fecha,"YYYYMM") GTE rsSQL.CPPanoMesDesde AND dateFormat(Lprm_Fecha,"YYYYMM") GTE rsSQL.CPPanoMesDesde)>
					<cfreturn "ERROR INVOCACION PC_GeneraCuentaFinanciera: Error en la Fecha Digitada. La Fecha no pertenece al Periodo de Presupuesto #rsSQL.Tipo# de #dateFormat(rsSQL.CPPfechaDesde,'dd/mm/yyyy')# a #dateFormat(rsSQL.CPPfechaHasta,'dd/mm/yyyy')#">
				</cfif>
			</cfif>
		</cfif>

		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select PCEMid, Cbalancen, Cmayor, Cdescripcion, Ctipo
			  from CtasMayor
			 where Ecodigo = #GvarEcodigo#
			   and Cmayor = '#Lprm_Cmayor#'
		</cfquery>
		<cfif rsSQL.recordcount EQ 0>
			<cfreturn "No existe la Cuenta Mayor '#Lprm_Cmayor#'">
		</cfif>

		<cfset Lprm_Cmayor    = rsSQL.Cmayor>
		<cfset Lvar_Cdescripcion = rsSQL.Cdescripcion>
		<cfset Lvar_Ctipo = rsSQL.Ctipo>
		<cfif Lprm_Cbalancen EQ "°">
			<cfset Lvar_Cbalancen = rsSQL.Cbalancen>
		<cfelse>
			<cfset Lvar_Cbalancen = Lprm_Cbalancen>
		</cfif>
		<cfif Lvar_Cbalancen EQ "D">
			<cfset Lvar_Cbalancenormal = 1>
		<cfelse>
			<cfset Lvar_Cbalancenormal = -1>
		</cfif>
			
		<cfif Lprm_CVid EQ "-1">
			<!--- No es de Presupuesto o No Es Control de Version --->
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select 	v.CPVid, 
						m.PCEMid, m.PCEMplanCtas
				  from CPVigencia v
					left outer join PCEMascaras m
						 ON m.PCEMid = v.PCEMid
				 where v.Ecodigo = #GvarEcodigo#
				   and v.Cmayor = '#Lprm_Cmayor#'
				   and #dateformat(Lprm_Fecha,"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
			</cfquery>
			<cfif rsSql.recordcount eq 0>
				<cfreturn "No hay m&aacute;scara vigente para la Cuenta Mayor '#Lprm_Cmayor#'">
			</cfif>
			<cfset Lvar_VigenciaID = rsSQL.CPVid>
	
			<cfset Lvar_MascaraID = rsSQL.PCEMid>
			<cfset Lvar_ConPlanCtas = (rsSQL.PCEMid NEQ "" AND rsSQL.PCEMplanCtas EQ 1)>
		<cfelse>
			<!--- Es Control de Version --->
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select count(1) as cantidad
				  from CVersion
				 where Ecodigo = #GvarEcodigo#
				   and CVid    = #Lprm_CVid#
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfreturn "No existe la Versi&oacute;n de Formulaci&oacute;n CVid=[#Lprm_CVid#]">
			</cfif>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select 	vm.CPVidOri, coalesce(vm.PCEMidNueva, vm.PCEMidOri) as PCEMid,
						vm.CVMtipoControl, vm.CVMcalculoControl,
						m.PCEMplanCtas
				  from CVMayor vm
					left outer join PCEMascaras m
						 ON m.PCEMid = coalesce(vm.PCEMidNueva, vm.PCEMidOri,-1)
				 where vm.Ecodigo = #GvarEcodigo#
				   and vm.CVid    = #Lprm_CVid#
				   and vm.Cmayor = '#Lprm_Cmayor#'
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cfreturn "Cuenta Mayor no Existe en la Versi&oacute;n">
			</cfif>
			<cfif rsSql.CPVidOri EQ "">
				<cfreturn "No hay m&aacute;scara vigente para la Cuenta Mayor">
			</cfif>
			<cfset Lvar_VigenciaID  = rsSQL.CPVidOri>
			<cfset Lvar_MascaraID   = rsSQL.PCEMid>
			<cfset Lvar_ConPlanCtas = (rsSQL.PCEMid NEQ "" AND rsSQL.PCEMplanCtas EQ 1)>

			<cfif Lprm_CVPtipoControl EQ "-1">
				<cfset Lvar_CVPtipoControl = rsSQL.CVMtipoControl>
			<cfelse>
				<cfset Lvar_CVPtipoControl = Arguments.Lprm_CVPtipoControl>
			</cfif>
			<cfif Lprm_CVPcalculoControl EQ "-1">
				<cfset Lvar_CVPcalculoControl = rsSQL.CVMcalculoControl>
			<cfelse>
				<cfset Lvar_CVPcalculoControl = Arguments.Lprm_CVPcalculoControl>
			</cfif>
		</cfif>
		
		<!--- ======================================================== --->
		<!---   SI NO TIENE MASCARA PREDEFINIDA SE VALIDA EXISTENCIA   --->
		<!--- ======================================================== --->
		<cfif Lvar_MascaraID EQ "">
			<cfset Lvar_ConPlanCtas = false>
			<cfif Lprm_EsDePresupuesto or Lprm_EsDePlanCompras>
        		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CTR_CtaMaySinMasc" Default="Control de Formato: Cuenta Mayor no tiene M&aacute;scara, s&oacute;lo las cuentas con m&aacute;scara predefinida pueden contener Niveles de Presupuesto" returnvariable="CTR_CtaMaySinMasc" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
				<cfreturn "#CTR_CtaMaySinMasc#">
			</cfif>

			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select 	cf.CFcuenta, cf.Ccuenta, cf.CPcuenta, cf.CFformato, coalesce(cf.CFdescripcionF,cf.CFdescripcion) as CFdescripcionF,
						cf.CFmovimiento, coalesce(c.Mcodigo, 1) as Auxiliar,
						c.Cformato, p.CPformato
				  from CFinanciera cf
					 left join CContables c
					   on c.Ccuenta = cf.Ccuenta
					 left join CPresupuesto p
					   on p.CPcuenta = cf.CPcuenta
				 where cf.Ecodigo 		= #GvarEcodigo#
				   and cf.CFformato 	= <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fmtVerif#">
			       and cf.CPVid 		= #Lvar_VigenciaID#
				   and cf.Cmayor 		= '#Lprm_Cmayor#'
			</cfquery>
			
			<cfif rsSQL.recordCount GT 0>
				<cfset Lvar_CuentaYaExiste = true>

				<cfset sbGuardar_PC_GeneraCFctaAnt(	GvarEcodigo, Lvar_fmtVerif, Arguments.Lprm_Fecha,
													"OLD",
													rsSQL.CFcuenta, rsSQL.CFdescripcionF,
													rsSQL.Ccuenta, rsSQL.Cformato, 
													rsSQL.CPcuenta, rsSQL.CPformato, 
													Lvar_Ctipo, rsSQL.CFmovimiento, rsSQL.Auxiliar)>
			<cfelse>
				<cfset Lvar_CuentaYaExiste = false>

				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select CFcuenta
					  from CFinanciera
					 where Ecodigo = #GvarEcodigo#
					   and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fmtVerif#">
				</cfquery>

				<cfset sbLimpiar_PC_GeneraCFctaAnt(	"NEW", rsSQL.CFcuenta )>

				<cfif rsSQL.CFcuenta EQ "">
					<cfreturn "No existe la Cuenta Financiera">
				<cfelse>
					<cfreturn "La Cuenta Financiera existe pero no est&aacute; vigente">
				</cfif>

			</cfif>

			<cfif Lprm_debug>
				<cfset sbDebug("SIN_MASCARA",Lprm_EsDePresupuesto, Lprm_CVid, Lprm_Cmayor)>
			</cfif>

			<cfset Lvar_NivelesF = 0>
			<cfset Lvar_NivelesC = 0>
			<cfset Lvar_NivelesP = 0>
			<!--- FIN SIN MASCARA --->

		<cfelse>
		
			<!--- ================================================================================ --->
			<!---   CON MASCARA PREDEFINIDA SEPARA EL FORMATO EN CUENTA PRESUPUESTO Y FINANCIERA   --->
			<!--- ================================================================================ --->


			<!--- Verifica construcción de Descripcion por nivel --->
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select PCNid as PCNidF, 
					  (select count(1) from PCNivelMascara n2 where n2.PCEMid=n1.PCEMid and n2.PCNid<=n1.PCNid and n1.PCNcontabilidad=1 and n2.PCNcontabilidad=1) as PCNidC, 
					  (select count(1) from PCNivelMascara n2 where n2.PCEMid=n1.PCEMid and n2.PCNid<=n1.PCNid and n1.PCNpresupuesto=1  and n2.PCNpresupuesto=1)  as PCNidP
				  from PCNivelMascara n1 
				 where PCEMid = #Lvar_MascaraID#
				   and PCNDescripCta = 1
			</cfquery>
			<cfset LvarDescripcion_PCNidF = fnArmar_Descripcion_PCNid(valueList(rsSQL.PCNidF), "PCDCniv",  "n.Cdescripcion")>
			<cfset LvarDescripcion_PCNidC = fnArmar_Descripcion_PCNid(valueList(rsSQL.PCNidC), "PCDCnivC", "n.Cdescripcion")>
			<cfset LvarDescripcion_PCNidP = fnArmar_Descripcion_PCNid(valueList(rsSQL.PCNidP), "PCDCnivP", "n.Cdescripcion")>

			<!--- Crear Cuenta Contable y Cuenta Financiera NO SE HA IMPLEMENTADO --->
	
			<!--- Cuenta Financiera --->
			<!--- Total de niveles y longitud total de la cuenta de detalle (con guiones por cada nivel) --->
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select count(1) as niveles, sum(PCNlongitud + 1) as longitud
				  from PCNivelMascara
				 where PCEMid = #Lvar_MascaraID#
			</cfquery>
			<cfset Lvar_NivelesF = rsSQL.niveles>
			<cfif Lvar_NivelesF EQ 0>
				<cfset Lvar_longtot = 0>
			<cfelse>
				<cfset Lvar_longtot = rsSQL.longitud - 1>
			</cfif>
			
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select count(1) as niveles
				  from PCNivelMascara
				 where PCEMid = #Lvar_MascaraID#
				   and PCNcontabilidad = 1
			</cfquery>
			<cfset Lvar_NivelesC = rsSQL.niveles>
	
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select count(1) as niveles, sum(PCNlongitud + 1) as longitud
				  from PCNivelMascara
				 where PCEMid = #Lvar_MascaraID#
				   and PCNpresupuesto = 1
			</cfquery>
			<cfset Lvar_NivelesP = rsSQL.niveles>
	
			<cfif Lprm_EsDePresupuesto>
				<cfif Lvar_NivelesP EQ 0>
        			<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CTR_CtaMayConMascSinNivPre" Default="Control de Formato: La Cuenta Mayor tiene una M&aacute;scara que no contiene Niveles de Presupuesto" returnvariable="CTR_CtaMayConMascSinNivPre" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
					<cfreturn "#CTR_CtaMayConMascSinNivPre#">
				</cfif>
				<cfset Lvar_longtot = rsSQL.longitud - 1>
				<cfif len(Lprm_Cdetalle) NEQ Lvar_longtot>
        			<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CTR_LongCtaNoCorrMascPre" Default="Control de Formato: La longitud de la Cuenta no corresponde con la M&aacute;scara de Presupuesto asociada a la Cuenta Mayor" returnvariable="CTR_LongCtaNoCorrMascPre" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
					<cfreturn "#CTR_LongCtaNoCorrMascPre#">
				</cfif>
			<cfelse>
				<cfif len(Lprm_Cdetalle) NEQ Lvar_longtot>
        			<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CTR_LongCtaNoCorrMascAsocCM" Default="Control de Formato: La longitud de la Cuenta no corresponde con la M&aacute;scara asociada a la Cuenta Mayor" returnvariable="CTR_LongCtaNoCorrMascAsocCM" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
					<cfreturn "#CTR_LongCtaNoCorrMascAsocCM#">
				</cfif>
			</cfif>
			<cfif Lvar_NivelesC EQ 0>
        		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CTR_CtaMayMascNoPNivCont" Default="Control de Formato: La Cuenta Mayor tiene una M&aacute;scara que no posee Niveles de Contabilidad" returnvariable="CTR_CtaMayMascNoPNivCont" XmlFile="/sif/cg/operacion/DocumentosContables.xml"/>
				<cfreturn "#CTR_CtaMayMascNoPNivCont#">
			</cfif>
		</cfif>

		<!--- Obtiene Periodo Presupuesto --->
		<cfif Lprm_EsDePresupuesto or Lprm_EsDePlanCompras>
			<cfset LvarModuloOrigen = 'PRFO'>
		<cfelse>
			<cfset LvarModuloOrigen = ''>
		</cfif>			
		<cfinvoke 	component		= "PRES_Presupuesto"
					method			= "rsCPresupuestoPeriodo" 
					returnvariable	= "rsSQL"
					
					Ecodigo			= "#GvarEcodigo#"
					ModuloOrigen	= "#LvarModuloOrigen#"
					FechaDocumento	= "#Lprm_Fecha#"
					AnoDocumento	= "#DateFormat(Lprm_Fecha,"YYYY")#"
					MesDocumento	= "#DateFormat(Lprm_Fecha,"MM")#"
		/>
		<cfset LvarCPPid = rsSQL.CPPid>
		<cfif Lprm_EsDePresupuesto>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				SELECT count(distinct CPTCtipo) as cantidad, max(CPTCtipo) as CPTCtipo
				  from CPtipoCtas
				 where CPPid	= #LvarCPPid# 
				   AND Ecodigo	= #GvarEcodigo#
				   AND Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" value="#left(Lvar_fmtVerif,4)#">
				   AND <cf_dbfunction name="LIKE" args="'#trim(Lvar_fmtVerif)#',CPTCmascara">
			</cfquery>
			<cfif rsSQL.cantidad GT 1>
				<cfthrow message="Control de Presupuesto: La Cuenta de Presupuesto '#Lvar_fmtVerif#' esta definida en diferentes Excepciones en la Clasificación de Cuentas según tipo de Presupuesto.">
			<cfelseif rsSQL.CPTCtipo EQ 'X'>
				<cfthrow message="Control de Presupuesto: La Cuenta de Presupuesto '#Lvar_fmtVerif#' esta definida como EXCLUSION en la Clasificación de Cuentas según tipo de Presupuesto.">
			</cfif>
		<cfelse>
			<cfif LvarCPPid NEQ "">
				<cfif isdefined("request.CP_Automatico")>
					<cfset LvarPermiteCrearCPcuenta		= true>
					<cfset LvarPermiteCrearFormulacion 	= true>
					<cfset Lvar_CVPtipoControl 			= "0">
					<cfset Lvar_CVPcalculoControl 		= "3">
				<cfelse>
					<cfset LvarPermiteCrearCPcuenta		= (rsSQL.CPPcrearCtaCalculo NEQ "0")>
					<cfset LvarPermiteCrearFormulacion 	= (rsSQL.CPPcrearFrmCalculo NEQ "0")>
					<cfset Lvar_CVPtipoControl 			= "0">
					<cfset Lvar_CVPcalculoControl 		= rsSQL.CPPcrearFrmCalculo>
				</cfif>
			<cfelse>
				<cfset LvarPermiteCrearCPcuenta		= false>
				<cfset LvarPermiteCrearFormulacion 	= false>
				<cfset Lvar_CVPtipoControl 			= "">
				<cfset Lvar_CVPcalculoControl 		= "">

				<cfset Lvar_NivelesP	= 0>
				<cfset Lvar_CPcuenta	= "">
				<cfset Lvar_fmtGenerarP	= "">
			</cfif>
		</cfif>

		<cfset Lvar_Crear = NOT Lprm_SoloVerificar AND ((Lvar_ConPlanCtas AND Lprm_CrearConPlan) OR (NOT Lvar_ConPlanCtas AND Lprm_CrearSinPlan) OR (Lprm_CrearPresupuesto))>

		<!--- ======================================================== --->
		<!---  GENERACION DEL ARBOL DE CUENTAS TEMPORAL EN #NIVELES#   --->
		<!--- ======================================================== --->		
		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #GvarEcodigo#
			   and Pcodigo = 99
		</cfquery>
		<cfset LvarUsarDescripcionAlterna = (rsSQL.Pvalor EQ "1")>

		<cfset LvarMSG = fnGeneraNiveles(Lprm_Cmayor,Lprm_Cdetalle,Lprm_Fecha,Lvar_Crear,Lprm_CrearPresupuesto,Lprm_EsDePresupuesto, Lprm_CPPid, Lprm_CVid, Lprm_Cdescripcion, Lprm_debug, Lprm_TransaccionActiva, Lprm_EsDePlanCompras)>
		<cfif LvarMSG NEQ "OK">
			<cfreturn "#LvarMSG#">
		</cfif>
		
		<!--- ====================================================== --->
		<!--- VERIFICACION DEL FORMATO Y DE LOS NIVELES DE LA CUENTA --->
		<!--- - Control de Obras               (Formato + Ocodigo)   --->
		<!--- - Control de Plan de Cuentas     (Niveles + Ocodigo)   --->
		<!--- - Control de Cuentas Inactivas   (Niveles)             --->
		<!--- - Control de Reglas Financieras  (Formato + Ocodigo)   --->
		<!--- - Control de Centro Funcional    (Formato + CFid)      --->
		<!--- - Existencia o creación de la Cuenta de Presupuesto    --->
		<!---                                                        --->
		<!--- Si no se envía Ocodigo (Lprm_Ocodigo="-1")             --->
		<!--- la verificacion es parcial                             --->
		<!--- y requiere VerificacionCuentasMasiva posterior         --->
		<!--- ====================================================== --->		
		<cfset LvarMSG = fnVerificaNiveles(Lprm_Cmayor, Lprm_Fecha, Lprm_Ocodigo, Lprm_Verificar_CFid, Lprm_EsDePresupuesto, Lprm_NoVerificarPres, Lprm_NoVerificarObras, Lprm_debug)>
		
		<cfif LvarMSG NEQ "OK">
			<cfreturn "#LvarMSG#">
		</cfif>

		<cfif Lvar_MascaraID EQ "">
			<cfif Lvar_CuentaYaExiste>
				<cfreturn "OLD">
			<cfelse>
				<cfreturn "NEW">
			</cfif>
		</cfif>

		<!--- ======================================================== --->
		<!--- INICIO DE TRANSACCION Y GENERACION DE LAS CUENTAS        --->
		<!--- ======================================================== --->

		<!--- Cuando es de presupuesto se debe enviar a fnGeneraCuenta aunque exista porque debe o incluir la cuenta en el periodo o en la version --->
		<cfif NOT Lvar_CuentaYaExiste OR Lprm_EsDePresupuesto>
			<cfif NOT Lvar_Crear>
				<cfif Lvar_CuentaYaExiste>
					<cfset LvarMSG = "OLD">
				<cfelse>
					<cfset LvarMSG = "NEW">
					<cfset request.PC_GeneraCFctaAnt.MSG = "NEW - La cuenta es correcta y puede ser generada">
				</cfif>
			<cfelseif Lprm_TransaccionActiva>
				<cfif Lprm_Debug>
					<cfreturn "The parameter [Lprm_TransaccionActiva] to function fnGeneraCuentaFinanciera must be 'false' when [Lprm_SoloVerificar] or [Lprm_Debug] is 'true'.">
				</cfif>
				<cfset LvarMSG = fnGeneraCuenta(Lprm_Cmayor,Lprm_Fecha,Lprm_CrearPresupuesto,Lprm_EsDePresupuesto, Lprm_CPPid, Lprm_CVid, Lprm_Cdescripcion, Lprm_debug, Lprm_EsDePlanCompras)>
			<cfelse>
            	<cfset varTransaction = InTransaction()>
                <cfif varTransaction>
					<cfset LvarMSG = fnGeneraCuenta(Lprm_Cmayor,Lprm_Fecha,Lprm_CrearPresupuesto,Lprm_EsDePresupuesto, Lprm_CPPid, Lprm_CVid, Lprm_Cdescripcion, Lprm_debug, Lprm_EsDePlanCompras)>
                    <cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
                        <cfthrow message="ERROR: Al crear Cuenta #Lprm_Cmayor# - #Lprm_Cdescripcion#">
                    <cfelseif LvarMSG NEQ "NEW" AND Lprm_Debug>
                        <cfset request.PC_GeneraCFctaAnt.MSG = "NEW - La cuenta es correcta y puede ser generada">
                    <cfelseif Lprm_Debug>
                        <cfthrow message="DEBUG: Cuenta #Lprm_Cmayor# - #Lprm_Cdescripcion#">
                    </cfif>
				<cfelse>
					<cftransaction>
                        <cfset LvarMSG = fnGeneraCuenta(Lprm_Cmayor,Lprm_Fecha,Lprm_CrearPresupuesto,Lprm_EsDePresupuesto, Lprm_CPPid, Lprm_CVid, Lprm_Cdescripcion, Lprm_debug, Lprm_EsDePlanCompras)>
                        <cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
                            <cftransaction action="rollback" />
                        <cfelseif LvarMSG NEQ "NEW" AND Lprm_Debug>
                            <cfset request.PC_GeneraCFctaAnt.MSG = "NEW - La cuenta es correcta y puede ser generada">
                            <cftransaction action="rollback" />
                        <cfelseif Lprm_Debug>
							<cftransaction action="rollback" />
                        </cfif>
                    </cftransaction>
                </cfif>
			</cfif>
		<cfelse>
			<cfset LvarMSG = "OLD">
		</cfif>

		<cfreturn LvarMSG>
	</cffunction>
	
	
	<cffunction name="fnArmar_Descripcion_PCNid" returntype="string">
		<cfargument name="PCNids">
		<cfargument name="PCDCniv">
		<cfargument name="Cdescripcion">
		
		<cfif Arguments.PCNids EQ "">
			<cfreturn Arguments.Cdescripcion>
		</cfif>
		<cfset LvarDescripcion_PCN = "">
		<cfloop list="#Arguments.PCNids#" index="LvarNiv">
			<cfif LvarNiv NEQ 0>
				<cfif LvarDescripcion_PCN NEQ "">
					<cfset LvarDescripcion_PCN = "#LvarDescripcion_PCN# #_CAT# ' - ' #_CAT# ">
				</cfif>
				<cfset LvarDescripcion_PCN = "#LvarDescripcion_PCN#(select vv.PCDdescripcion from #NIVELES# nn #NOLOCK# inner join PCDCatalogo vv ON vv.PCDcatid = nn.PCDcatid where nn.IDtemp = n.IDtemp and nn.BMfecha = n.BMfecha and nn.PCDCniv = #LvarNiv#)">
			</cfif>
		</cfloop>
		<cfreturn LvarDescripcion_PCN>
	</cffunction>				

	<cffunction name="sbDebug" access="private" output="true" returntype="void">
		<cfargument name="Lprm_tipo" 				type="string" 	required="yes">
		<cfargument name="Lprm_EsDePresupuesto"		type="boolean" 	required="yes">
		<cfargument name="Lprm_CVid"				type="numeric" 	required="yes">
		<cfargument name="Lprm_Cmayor" 				type="string" 	required="yes">
		
        <cfinclude template="../Utiles/sifConcat.cfm">
		<cfif Arguments.Lprm_tipo EQ "SIN_MASCARA">
			<cfdump var="#rsSQL#">
		
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select 'CContables' as AA_TABLA, C.*
				  from CFinanciera F 
					   LEFT JOIN CContables as C
							ON C.Ccuenta = F.Ccuenta
				 where F.Ecodigo = #GvarEcodigo# 
				   and F.CFformato  = '#Lvar_fmtVerif#'
				   and F.CPVid = #Lvar_VigenciaID#
			</cfquery>
			<cfdump var="#rsSQL#">
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select 'CPresupuesto' as AA_TABLA, C.*
				  from CFinanciera F 
					   LEFT JOIN CPresupuesto as C
							ON C.CPcuenta = F.CPcuenta
				 where F.Ecodigo = #GvarEcodigo# 
				   and F.CFformato  = '#Lvar_fmtVerif#'
					and F.CPVid = #Lvar_VigenciaID#
			</cfquery>
			<cfdump var="#rsSQL#">
		
			<cfif NOT Lvar_CuentaYaExiste>
				<cfoutput>LA CUENTA NO SE CREO PORQUE ESTABA EN MODO DEBUG (SE EJECUTO UN ROLLBACK TRANSACTION)</cfoutput>
				<cftransaction action="rollback"/>
			</cfif>
		<cfelseif Arguments.Lprm_tipo EQ "YA_EXISTE">
			<cfoutput>
			<table>
			<cfif Lprm_EsDePresupuesto>
				<tr><td>CUENTA PRESUPUESTO YA EXISTE:</td><td>#Lvar_fmtGenerarP#</td></tr>
			<cfelse>
				<tr><td>CUENTA FINANCIERA YA EXISTE: </td><td>#Lvar_fmtGenerarF#</td></tr>
				<tr><td>CUENTA CONTABLE:   </td><td>#Lvar_fmtGenerarC#</td></tr>
				<tr><td>CUENTA PRESUPUESTO:</td><td>#Lvar_fmtGenerarP#</td></tr>
			</cfif>
			</table>
			</cfoutput>
		<cfelseif Arguments.Lprm_tipo EQ "NO_EXISTE">
			<cfoutput>
			<table>
			<cfif Lprm_EsDePresupuesto>
				<tr><td>CUENTA PRESUPUESTO A GENERAR:</td><td>#Lvar_fmtGenerarP#</td></tr>
			<cfelse>
				<tr><td>CUENTA FINANCIERA A GENERAR: </td><td>#Lvar_fmtGenerarF#</td></tr>
				<tr><td>CUENTA CONTABLE A GENERAR:   </td><td>#Lvar_fmtGenerarC#</td></tr>
				<tr><td>CUENTA PRESUPUESTO A VERIFICAR:</td><td>#Lvar_fmtGenerarP#</td></tr>
			</cfif>
			</table>
			</cfoutput>
		<cfelseif Arguments.Lprm_tipo EQ "GENERADO">
			<cfoutput><BR>NIVELES</cfoutput>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select * 
				from #NIVELES# n #NOLOCK#
				where n.IDtemp  = #GvarIDtemp#
				  and n.BMfecha = #GvarBMfecha#
			</cfquery>
			<cfdump var="#rsSQL#">
			<cfif not Lprm_EsDePresupuesto>
				<cfoutput>CATALOGO FINANCIERO: CFinanciera</cfoutput>
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select F.*
					  from CFinanciera F
					 where F.Ecodigo = #GvarEcodigo# 
					   and '#Lvar_fmtGenerarF#' like rtrim(F.CFformato) #_Cat# '%'
				</cfquery> 
				<cfdump var="#rsSQL#">
				<cfoutput>CATALOGO CONTABLE: CContables</cfoutput>
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select C.*
					  from CContables C
					 where C.Ecodigo = #GvarEcodigo# 
					   and '#Lvar_fmtGenerarC#' like rtrim(C.Cformato) #_Cat# '%'
				</cfquery>
				<cfdump var="#rsSQL#">
			</cfif>
			<cfif Lprm_CVid EQ "-1">
				<cfoutput>CATALOGO PRESUPUESTO: CPresupuesto</cfoutput>
				<!--- No es de Control de Version --->
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select P.*
					  from CPresupuesto P
					 where P.Ecodigo = #GvarEcodigo# 
					   and '#Lvar_fmtGenerarP#' like rtrim(P.CPformato) #_Cat# '%'
				</cfquery>
			<cfelse>
				<cfoutput>CATALOGO PRESUPUESTO VERSION: CVPresupuesto</cfoutput>
				<!--- Es de Control de Version --->
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select P.*
					  from CVPresupuesto P
					 where P.Ecodigo = #GvarEcodigo# 
					   and P.CVid	 = #Lprm_CVid#
					   and P.Cmayor  = '#Lprm_Cmayor#'
					   and '#Lvar_fmtGenerarP#' like rtrim(P.CPformato) #_Cat# '%'
				</cfquery>
			</cfif>
			<cfdump var="#rsSQL#">
			<cfif not Lprm_EsDePresupuesto>
				<cfoutput>CUBO FINANCIERO: PCDCatalogoCuentaF</cfoutput>
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select f.CFformato as AA_Zformato, CC.*
					  from PCDCatalogoCuentaF CC, CFinanciera f
					 where f.Ecodigo = #GvarEcodigo#
					   and f.CFformato  = '#trim(Lvar_fmtGenerarF)#'
					   and f.CPVid = #Lvar_VigenciaID#
					   and CC.CFcuenta = f.CFcuenta
					 order by PCDCniv
				</cfquery>
				<cfdump var="#rsSQL#">
				<cfoutput>CUBO CONTABLE: PCDCatalogoCuenta</cfoutput>
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select c.Cformato as AA_Zformato, CC.*
					  from PCDCatalogoCuenta CC, CContables c
					 where c.Ecodigo = #GvarEcodigo#
					   and c.Cformato  = '#trim(Lvar_fmtGenerarC)#'
					   and CC.Ccuenta = c.Ccuenta
					 order by PCDCniv
				</cfquery>
				<cfdump var="#rsSQL#">
			</cfif>
			<cfif Lprm_CVid EQ "-1">
				<!--- No es de Control de Version --->
				<cfoutput>CUBO PRESUPUESTO: PCDCatalogoCuentaP</cfoutput>
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select c.CPformato as AA_Zformato, CC.*
					  from PCDCatalogoCuentaP CC, CPresupuesto c
					 where c.Ecodigo = #GvarEcodigo#
					   and c.CPformato  = '#trim(Lvar_fmtGenerarP)#'
						and c.CPVid = #Lvar_VigenciaID#
					   and CC.CPcuenta = c.CPcuenta
					 order by PCDCniv
				</cfquery>
				<cfdump var="#rsSQL#">
			</cfif>
			<cfoutput>LA CUENTA NO SE CREO PORQUE ESTABA EN MODO DEBUG (SE EJECUTO UN ROLLBACK TRANSACTION)</cfoutput>
		</cfif>
	</cffunction>
	
	<cffunction name="fnGeneraNiveles" access="private" output="no" returntype="string">
		<cfargument name="Lprm_Cmayor" 				type="string"  required="yes">
		<cfargument name="Lprm_Cdetalle" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    required="yes">
	
		<cfargument name="Lprm_Crear"				type="boolean" required="yes">
		<cfargument name="Lprm_CrearPresupuesto"	type="boolean" required="yes">
		<cfargument name="Lprm_EsDePresupuesto"		type="boolean" required="yes">
		<cfargument name="Lprm_CPPid"				type="numeric" required="yes">
		<cfargument name="Lprm_CVid"				type="numeric" required="yes">
		<cfargument name="Lprm_Cdescripcion"		type="string"  default="">
		<cfargument name="Lprm_debug" 				type="boolean" required="yes">
		<cfargument name="Lprm_TransaccionActiva"	type="boolean" required="yes">
		<cfargument name="Lprm_EsDePlanCompras"		type="boolean" default="no">

		<cfset var LvarMSG = "">
		<!--- ======================================================== --->
		<!---                   GENERACION DE NIVELES                  --->
		<!--- ======================================================== --->

		<cfif Lprm_EsDePresupuesto>
			<cfset Lvar_CPcuenta = "">

			<cfif Lprm_CVid EQ "-1">
				<!--- No es Control de Version --->
				<cfquery name="rsCPresupuesto" datasource="#GvarDSN#">
					select c.Cmayor, c.CPcuenta, c.CPformato, coalesce(c.CPdescripcionF, c.CPdescripcion) as CPdescripcion
					  from CPresupuesto c
					 where c.Ecodigo   	= #GvarEcodigo#
					   and c.Cmayor    	= '#Lprm_Cmayor#'
					   and c.CPVid     	= #Lvar_VigenciaID#
					   and c.CPformato 	= '#Lvar_fmtVerif#'
				</cfquery>

				<cfif not Lprm_CrearPresupuesto AND rsCPresupuesto.recordCount EQ 0>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select count(1) as cantidad
						  from CPresupuesto c
						 where c.Ecodigo   	= #GvarEcodigo#
						   and c.CPformato 	= '#Lvar_fmtVerif#'
					</cfquery>

					<cfif rsSQL.cantidad EQ 0>
						<cfreturn "Control de Presupuesto: No existe la Cuenta de Presupuesto '#Lvar_fmtVerif#' (1).">
					<cfelse>
						<cfreturn "Control de Presupuesto: La Cuenta de Presupuesto '#Lvar_fmtVerif#' existe pero no est&aacute; vigente">
					</cfif>
				</cfif>

				<cfset Lvar_CPcuenta = rsCPresupuesto.CPcuenta>
			<cfelse>
				<!--- Es control de Version --->
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select CPcuenta, CVPcuenta
					  from CVPresupuesto
					 where Ecodigo   = #GvarEcodigo#
					   and CVid      = #Lprm_CVid#
					   and Cmayor    = '#Lprm_Cmayor#'
					   and CPformato = '#Lvar_fmtVerif#'
				</cfquery>

				<cfset LvarCVPcuenta = rsSQL.CVPcuenta>
				<cfset Lvar_CPcuenta = LvarCVPcuenta>
			</cfif>
			
			<cfset Lvar_CuentaYaExiste = (Lvar_CPcuenta NEQ "")>
		<cfelseif Lprm_EsDePlanCompras>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select PCGcuenta, CFformato, CPformato
				  from PCGcuentas
				 where Ecodigo  	= #GvarEcodigo#
				   and CFformato 	= '#Lvar_fmtVerif#'
				   and CPVid		= #Lvar_VigenciaID#
			</cfquery>

			<cfset Lvar_PCGcuenta	= rsSQL.PCGcuenta>
			<cfset Lvar_fmtGenerarF	= rsSQL.CFformato>
			<cfset Lvar_fmtGenerarP = rsSQL.CPformato>

			<cfset Lvar_CFcuenta	= Lvar_PCGcuenta>
			<cfset Lvar_Ccuenta 	= Lvar_PCGcuenta>
			<cfset Lvar_CPcuenta	= Lvar_PCGcuenta>
			<cfset Lvar_fmtGenerarC = Lvar_fmtGenerarF>
			
			<cfset Lvar_CuentaYaExiste = (Lvar_PCGcuenta NEQ "")>
		<cfelse>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select cf.CFcuenta, cf.Ccuenta, cf.CPcuenta, cf.CFformato, coalesce(cf.CFdescripcionF,cf.CFdescripcion) as CFdescripcionF,
						cf.CFmovimiento, coalesce(c.Mcodigo, 1) as Auxiliar,
						c.Cformato, p.CPformato
				  from CFinanciera cf
					 left join CContables c
					   on c.Ccuenta = cf.Ccuenta
					 left join CPresupuesto p
					   on p.CPcuenta = cf.CPcuenta
				 where cf.Ecodigo  	= #GvarEcodigo#
				   and cf.Cmayor   	= '#Lprm_Cmayor#'
				   and cf.CFformato 	= '#Lvar_fmtVerif#'
				   and cf.CPVid 		= #Lvar_VigenciaID#
			</cfquery>

			<cfif not Lprm_Crear AND rsSQL.recordCount EQ 0>
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select count(1) as cantidad
					  from CFinanciera
					 where Ecodigo  	= #GvarEcodigo#
					   and CFformato 	= '#Lvar_fmtVerif#'
				</cfquery>

				<cfif rsSQL.cantidad EQ 0>
					<cfset LvarMSG = "">
                    <cfset Lvar_CuentaYaExiste = false>
					<cfreturn "OK">
				<cfelse>
					<cfreturn "La Cuenta Financiera existe pero no est&aacute; vigente">
				</cfif>
			</cfif>

			<cfset Lvar_CFcuenta	= rsSQL.CFcuenta>
			<cfset Lvar_Ccuenta 	= rsSQL.Ccuenta>
			<cfset Lvar_fmtGenerarF	= rsSQL.CFformato>
			<cfset Lvar_fmtGenerarC = rsSQL.Cformato>

			<cfif LvarCPPid NEQ "">
				<cfset Lvar_CPcuenta	= rsSQL.CPcuenta>
				<cfset Lvar_fmtGenerarP = rsSQL.CPformato>
			</cfif>
			
			<cfset Lvar_CuentaYaExiste = (Lvar_CFcuenta NEQ "")>
		</cfif>

		<cfif Lvar_CuentaYaExiste>
			<!--- La cuenta ya existe. No se debe generar la cuenta y se supone que todos los valores ya se encuentran en el cubo --->
			<cfif Lprm_EsDePresupuesto>
				<cfset Lvar_fmtGenerarP = Lvar_fmtVerif>
			<cfelseif Lprm_EsDePlanCompras>
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					insert into #NIVELES# #ROWLOCK# ( PCDCniv, CformatoF,
											valor, PCEcatid, PCDcatid, PCNdep, Cdescripcion, 
											IDtemp, BMfecha)
					select  a.PCDCniv, c.CFformato, 
							v.PCDvalor, a.PCEcatid, a.PCDcatid, 0, 'Cuenta Plan Compras', 
							#GvarIDtemp#, 
							#GvarBMfecha#
					  from PCDCatalogoCuentaPCG a 
							LEFT  JOIN PCDCatalogo v 
							   on v.PCDcatid = a.PCDcatid
							INNER JOIN PCGcuentas c 
							   on c.PCGcuenta = a.PCGcuenta
					 where a.PCGcuenta = #Lvar_PCGcuenta#
					 order by a.PCDCniv
				</cfquery>
			<cfelse>
				<cfif rsSQL.CFmovimiento NEQ "S">
					<cfreturn "La Cuenta Financiera no es de ultimo nivel">
				<cfelseif Lvar_Ccuenta EQ "">
					<cfreturn "ERROR GRAVE EN GENERACION DE CUENTAS: La Cuenta Financiera CFcuenta=[#Lvar_CFcuenta#] no tiene asignada una Cuenta Contable">
				<cfelseif Lvar_CPcuenta EQ "" AND Lvar_NivelesP GT 0>
					<!--- BUSCA Y RELACIONA UNA CUENTA DE PRESUPUESTO GENERADA DESPUES DE LA CUENTA FINANCIERA --->
					<cfset Lvar_CPcuenta = fnRelacionaCPcuenta(Lprm_Cmayor, Lprm_Cdetalle)>
					<cfif Lvar_CPcuenta EQ -1>
						<cfreturn "Control de Presupuesto: No existe la Cuenta de Presupuesto '#Lvar_fmtGenerarP#' (2).">
					<cfelseif Lvar_CPcuenta EQ -2>
						<cfreturn "Control de Presupuesto: La Cuenta de Presupuesto '#Lvar_fmtGenerarP#' existe pero no est&aacute; vigente">
					</cfif>
				</cfif>

				<!--- Guarda el último CFcuenta Verificado para no volver a leer CFinanciera --->
				<cfset sbGuardar_PC_GeneraCFctaAnt(	GvarEcodigo, Lvar_fmtVerif, Arguments.Lprm_Fecha, 
													"OLD",
													rsSQL.CFcuenta, rsSQL.CFdescripcionF,
													rsSQL.Ccuenta, rsSQL.Cformato, 
													rsSQL.CPcuenta, rsSQL.CPformato, 
													Lvar_Ctipo, rsSQL.CFmovimiento, rsSQL.Auxiliar)>

				<cfquery name="rsSQL" datasource="#GvarDSN#">
					insert into #NIVELES# #ROWLOCK# ( PCDCniv, CcuentaF, CformatoF,
											valor, PCEcatid, PCDcatid, PCNdep, Cdescripcion, 
											IDtemp, BMfecha)
					select  a.PCDCniv, a.CFcuentaniv, c.CFformato, 
							v.PCDvalor, a.PCEcatid, a.PCDcatid, 0, c.CFdescripcion, 
							#GvarIDtemp#, 
							#GvarBMfecha#
					  from PCDCatalogoCuentaF a 
							LEFT  JOIN PCDCatalogo v 
							   on v.PCDcatid = a.PCDcatid
							INNER JOIN CFinanciera c 
							   on c.CFcuenta = a.CFcuenta
					 where a.CFcuenta = #Lvar_CFcuenta#
					 order by a.PCDCniv
				</cfquery>

				<cfquery name="rsSQL" datasource="#GvarDSN#">
					insert into #NIVELES# #ROWLOCK# ( PCDCnivC, CcuentaC, CformatoC, PCDCniv, 
											valor, PCEcatid, PCDcatid, PCNdep, Cdescripcion,
											IDtemp, BMfecha)
					select  a.PCDCniv, a.Ccuentaniv, c.Cformato, -1,
							v.PCDvalor, a.PCEcatid, a.PCDcatid, 0, c.Cdescripcion,
							#GvarIDtemp# , 
							#GvarBMfecha#
					  from PCDCatalogoCuenta a 
							LEFT  JOIN PCDCatalogo v ON v.PCDcatid = a.PCDcatid
							INNER JOIN CContables c  ON c.Ccuenta = a.Ccuenta
					 where a.Ccuenta = #Lvar_Ccuenta#
					 order by a.PCDCniv
				</cfquery>
			</cfif>
			<cfif Lvar_NivelesP GT 0>
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					insert into #NIVELES# #ROWLOCK# ( PCDCnivP, CcuentaP, CformatoP, PCDCniv,
											valor, PCEcatid, PCDcatid, PCNdep, Cdescripcion,
											IDtemp, BMfecha)
					select  a.PCDCniv, a.CPcuentaniv, c.CPformato, -1,
							v.PCDvalor, a.PCEcatid, a.PCDcatid, 0, c.CPdescripcion,
							#GvarIDtemp# , 
							#GvarBMfecha#
					  from PCDCatalogoCuentaP a 
							LEFT  JOIN PCDCatalogo  v ON v.PCDcatid = a.PCDcatid
							INNER JOIN CPresupuesto c ON c.CPcuenta = a.CPcuenta
					 where a.CPcuenta = #Lvar_CPcuenta#
					 order by a.PCDCniv
				</cfquery>
			</cfif>

			<cfif Lprm_debug>
				<cfset sbDebug("YA_EXISTE",Lprm_EsDePresupuesto, Lprm_CVid, Lprm_Cmayor)>
			</cfif>
		<cfelse>
			<!--- La cuenta no existe. Se debe generar la cuenta y todos los valores del cubo --->
		
			<!--- Insertar el nivel cero - Cuenta de Mayor en el cubo --->
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				<cfif Lprm_EsDePresupuesto>
					insert into #NIVELES# #ROWLOCK# (PCDCniv, PCDCnivP, CformatoP, IDtemp, BMfecha)
					values (0, 0, '#Lprm_Cmayor#',
							#GvarIDtemp# , 
							#GvarBMfecha#
					)
				<cfelse>
					insert into #NIVELES# #ROWLOCK# (PCDCniv, PCDCnivC, PCDCnivP, CformatoF, CformatoC, CformatoP, IDtemp, BMfecha)
					values (0, 0, 0, '#Lprm_Cmayor#', '#Lprm_Cmayor#', '#Lprm_Cmayor#',
							#GvarIDtemp# , 
							#GvarBMfecha#
					)
				</cfif>
			</cfquery>
			
			<cfset Lvar_fmtGenerarF = Lprm_Cmayor>
			<cfset Lvar_fmtGenerarC = Lprm_Cmayor>
			<cfif Lprm_EsDePresupuesto OR Lvar_NivelesP GT 0>
				<cfset Lvar_fmtGenerarP = Lprm_Cmayor>
			<cfelse>
				<cfset Lvar_CPcuenta = "">
				<cfset Lvar_fmtGenerarP = "">
			</cfif>
			<cfset Lvar_PCDCnivP = 0>
			<cfset Lvar_PCDCnivC = 0>
			<cfset Lvar_PCDCnivF = 1>
			<cfset Lvar_posicion = 1>
			<cfset LvarNiveles_I = arrayNew(1)>
			
			<cfloop condition="Lvar_PCDCnivF LTE Lvar_NivelesF">
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select PCNlongitud, PCEcatid, PCNdep,
						   PCNcontabilidad, PCNpresupuesto
					  from PCNivelMascara
					 where PCEMid = #Lvar_MascaraID#
					   and PCNid = #Lvar_PCDCnivF#
				</cfquery>
				<cfset Lvar_longitud	= rsSQL.PCNlongitud>
				<cfset Lvar_valor		= mid(Lprm_Cdetalle, Lvar_posicion, Lvar_longitud)>

				<cfset Lvar_PCEcatid	= rsSQL.PCEcatid>
				<cfset Lvar_nivelPadre	= rsSQL.PCNdep>
				<cfset Lvar_nivelConta	= rsSQL.PCNcontabilidad>
				<cfset Lvar_nivelPresu	= rsSQL.PCNpresupuesto>
				<cfset Lvar_PCDcatid	= "">
				<cfset Lvar_valor_Des	= "">

				<cfif Lvar_ConPlanCtas>
					<cfset LvarNiveles_I[Lvar_PCDCnivF] = structNew()>
					<cfset LvarNiveles_I[Lvar_PCDCnivF].PCEcatid = 0>
					<cfif Lvar_PCEcatid EQ "" AND Lvar_nivelPadre EQ "">
						<cfreturn "Error en la definici&oacute;n de la M&aacute;scara: No se defini&oacute; 'Catalogo Independiente' ni 'Nivel al que Depende' en el nivel #Lvar_PCDCnivF# de la m&aacute;scara">
					</cfif>
					<cfif NOT Lprm_EsDePresupuesto OR Lvar_nivelPresu EQ "1">
						<cfif Lvar_nivelPadre NEQ "">
							<!--- OBTIENE LAS REFERENCIAS A LOS CATALOGOS DE NIVELES DEPENDIENTES --->
							<!--- Se obtiene el catálogo del nivel padre: Catalogo Referenciado del Valor del nivel padre --->
							<cfif LvarNiveles_I[Lvar_nivelPadre].PCEcatid EQ "0">
								<cfreturn "Control de Cat&aacute;logos: No se encontr&oacute; 'Nivel Padre' para el nivel " & Lvar_nivelPadre & " de la cuenta de Presupuesto " & Lprm_Cmayor & "-" & Lprm_Cdetalle>
							</cfif>
							<cfset Lvar_PCEcatid = LvarNiveles_I[Lvar_nivelPadre].PCEcatidRef>
							<!--- Excepto si el Catalogo del nivel padre es RefPorMayor y está registrada la cuenta mayor con el Valor del nivel padre --->
							<cfif LvarNiveles_I[Lvar_nivelPadre].CatRefPorMayor EQ "1">
								<cfquery name="rsSQL" datasource="#GvarDSN#">
									select rm.PCEcatidref
									  from PCDCatalogoRefMayor rm
									 where rm.PCDcatid  = #LvarNiveles_I[Lvar_nivelPadre].PCDcatid#
									   and rm.Ecodigo   = #GvarEcodigo#
									   and rm.Cmayor    = '#Arguments.Lprm_Cmayor#'
								</cfquery>
								<cfif rsSQL.PCEcatidref NEQ "">
									<cfset Lvar_PCEcatid = rsSQL.PCEcatidref>
								</cfif>
							</cfif>
							<cfif trim(Lvar_PCEcatid) EQ "">
								<cfif Lprm_EsDePresupuesto>
									<cfreturn "Control de Cat&aacute;logos: No se defini&oacute; 'Catalogo de Referencia' para el valor del nivel " & Lvar_nivelPadre & " de la cuenta de Presupuesto " & Lprm_Cmayor & "-" & Lprm_Cdetalle>
								<cfelse>
									<cfreturn "Control de Cat&aacute;logos: No se defini&oacute; 'Catalogo de Referencia' para el valor del nivel " & Lvar_nivelPadre & " de la cuenta Financiera " & Lprm_Cmayor & "-" & Lprm_Cdetalle>
								</cfif>
							</cfif>
						</cfif>
	
						<!--- Se obtiene las características del Catálogo del nivel actual (INDEPENDIENTE O DEPENDIENTE) --->
						<cfquery name="rsPCE" datasource="#GvarDSN#">
							select PCEcatid, PCEempresa, PCEreferenciarMayor, PCEcodigo, PCEdescripcion
							  from PCECatalogo
							 where PCEcatid = #Lvar_PCEcatid#
						</cfquery>
						<cfset LvarNiveles_I[Lvar_PCDCnivF].PCEcatid		= rsPCE.PCEcatid>
						<cfset LvarNiveles_I[Lvar_PCDCnivF].CatRefPorMayor	= rsPCE.PCEreferenciarMayor>
						<!--- Se obtiene las características del Valor del nivel actual --->
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							select v.PCDcatid, v.PCEcatidref,
								<cfif LvarUsarDescripcionAlterna AND rsPCE.PCEempresa EQ "0">
									coalesce(v.PCDdescripcionA,v.PCDdescripcion) as PCDdescripcion
								<cfelse>
									v.PCDdescripcion
								</cfif>
							  from PCDCatalogo v
							 where v.PCEcatid = #Lvar_PCEcatid#
							   and v.PCDvalor = '#Lvar_Valor#'
							<cfif rsPCE.PCEempresa EQ "0">
							   and v.Ecodigo is null
							<cfelse>
							   and v.Ecodigo = #GvarEcodigo#
							</cfif>
						</cfquery>
						<cfif rsSQL.recordCount EQ 0>
							<cfreturn "Control de Cat&aacute;logos: Valor='#trim(Lvar_Valor)#', Cat&aacute;logo='#trim(rsPCE.PCEcodigo)#-#trim(rsPCE.PCEdescripcion)#', Valor no existe en Cat&aacute;logo.">
						</cfif>
						<cfset Lvar_PCDcatid	= rsSQL.PCDcatid>
						<cfset Lvar_valor_Des	= rsSQL.PCDdescripcion>
						<cfset LvarNiveles_I[Lvar_PCDCnivF].PCDcatid 		= rsSQL.PCDcatid>
						<cfset LvarNiveles_I[Lvar_PCDCnivF].PCEcatidRef		= rsSQL.PCEcatidref>
					</cfif>
				</cfif>

				<!--- Obtiene la longitud del valor entre Guiones --->
				<cfset Lvar_longitudValor = find("-",Lprm_Cdetalle,Lvar_posicion)>
				<cfif Lvar_longitudValor EQ 0>
					<cfset Lvar_longitudValor = len(Lprm_Cdetalle)+1>
				</cfif>
				<cfset Lvar_longitudValor = Lvar_longitudValor - Lvar_posicion>

				<cfif Lvar_nivelPresu EQ "1">
					<cfset Lvar_PCDCnivP = Lvar_PCDCnivP + 1>
					<cfset Lvar_fmtGenerarP = Lvar_fmtGenerarP & '-' & Lvar_valor>
					<cfquery name="rsCP" datasource="#GvarDSN#">
						select CPcuenta
						  from CPresupuesto
						 where Ecodigo  	= #GvarEcodigo# 
						   and Cmayor 		= '#Lprm_Cmayor#' 
						   and CPVid 		= #Lvar_VigenciaID#
						   and CPformato	= '#Lvar_fmtGenerarP#'
					</cfquery>
				</cfif>
				
				<!--- OBTIENE LA ESTRUCTURA DE LA MASCARA: REFERENCIA A LOS CATALOGOS INDEPENDIENTES Y REFERENCIA A LOS NIVELES DEPENDIENTES --->
				<cfif Lprm_EsDePresupuesto>
					<cfif Lvar_nivelPresu EQ "1">
						<cfif Lvar_longitud NEQ Lvar_longitudValor>
							<cfreturn "Control de Formato: La longitud del nivel #Lvar_PCDCnivP-1# de la Cuenta no corresponde con la m&aacute;scara de Presupuesto asociada a la Cuenta Mayor">
						</cfif>
						<cfquery datasource="#GvarDSN#">
							insert into #NIVELES# #ROWLOCK# (
								  valor
								, PCEcatid, PCNdep
								, PCDcatid, Cdescripcion
								, PCDCniv, PCDCnivP, CformatoP
								<cfif rsCP.CPcuenta NEQ "">, CcuentaP</cfif>
								, IDtemp, BMfecha
								)
							values ('#Lvar_valor#' 
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCEcatid#" null="#Lvar_PCEcatid EQ ""#">
								, <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_nivelPadre#" null="#Lvar_nivelPadre EQ ""#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCDcatid#" null="#Lvar_PCDcatid EQ ""#">
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_valor_des#">
								, #Lvar_PCDCnivF#, #Lvar_PCDCnivP#, '#Lvar_fmtGenerarP#'
								<cfif rsCP.CPcuenta NEQ "">, #rsCP.CPcuenta#</cfif>
								, #GvarIDtemp#, #GvarBMfecha#
								)
						</cfquery>
						<cfset Lvar_posicion = Lvar_posicion + Lvar_longitud + 1>
					</cfif>
				<cfelse>
					<cfif Lvar_longitud NEQ Lvar_longitudValor>
						<cfreturn "Control de Formato: La longitud del nivel #Lvar_PCDCnivF-1# de la Cuenta no corresponde con la M&aacute;scara Financiera asociada a la Cuenta Mayor: '#Lprm_Cdetalle#'">
					</cfif>
					<cfset Lvar_fmtGenerarF = Lvar_fmtGenerarF & '-' & Lvar_valor>
					<cfquery name="rsCF" datasource="#GvarDSN#">
						select CFcuenta
						  from CFinanciera 
						 where CFformato	= '#Lvar_fmtGenerarF#' 
						   and Ecodigo  	= #GvarEcodigo# 
						   and Cmayor 		= '#Lprm_Cmayor#' 
						   and CPVid 		= #Lvar_VigenciaID#
					</cfquery>

					<cfif Lvar_nivelConta EQ "1">
						<cfset Lvar_PCDCnivC = Lvar_PCDCnivC + 1>
						<cfset Lvar_fmtGenerarC = Lvar_fmtGenerarC & '-' & Lvar_valor>
						<cfquery name="rsCC" datasource="#GvarDSN#">
							select Ccuenta
							  from CContables
							 where Cformato	= '#Lvar_fmtGenerarC#' 
							   and Ecodigo  = #GvarEcodigo# 
						</cfquery>
					</cfif>

					<cfquery name="rsSQL" datasource="#GvarDSN#">
						insert into #NIVELES# #ROWLOCK# (
								  valor
								, PCEcatid, PCNdep
								, PCDcatid, Cdescripcion
								, PCDCniv, CformatoF
								<cfif rsCF.CFcuenta NEQ "">, CcuentaF</cfif>
								<cfif Lvar_nivelConta EQ "1">
									, PCDCnivC, CformatoC
									<cfif rsCC.Ccuenta NEQ "">, CcuentaC</cfif>
								</cfif>
								<cfif Lvar_nivelPresu EQ "1">
									, PCDCnivP, CformatoP
									<cfif rsCP.CPcuenta NEQ "">, CcuentaP</cfif>
								</cfif>
								, IDtemp, BMfecha
							)
						values ('#Lvar_valor#'
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCEcatid#" null="#Lvar_PCEcatid EQ ""#">
								, <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_nivelPadre#" null="#Lvar_nivelPadre EQ ""#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCDcatid#" null="#Lvar_PCDcatid EQ ""#">
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_valor_des#">
								, #Lvar_PCDCnivF#, '#Lvar_fmtGenerarF#'
								<cfif rsCF.CFcuenta NEQ "">, #rsCF.CFcuenta#</cfif>
								<cfif Lvar_nivelConta EQ "1">
									, #Lvar_PCDCnivC#, '#Lvar_fmtGenerarC#'
									<cfif rsCC.Ccuenta NEQ "">, #rsCC.Ccuenta#</cfif>
								</cfif>
								<cfif Lvar_nivelPresu EQ "1">
									, #Lvar_PCDCnivP#, '#Lvar_fmtGenerarP#'
									<cfif rsCP.CPcuenta NEQ "">, #rsCP.CPcuenta#</cfif>
								</cfif>
								, #GvarIDtemp#
								, #GvarBMfecha#
							)
					</cfquery>
					<cfset Lvar_posicion = Lvar_posicion + Lvar_longitud + 1>
				</cfif>

				<cfset Lvar_PCDCnivF = Lvar_PCDCnivF + 1>
			</cfloop>
			<!--- FIN CATALOGOS --->

			<cfif Lprm_debug>
				<cfset sbDebug("NO_EXISTE",Lprm_EsDePresupuesto, Lprm_CVid, Lprm_Cmayor)>
			</cfif>
		</cfif>

		<cfreturn "OK">
	</cffunction>

	<cffunction name="fnRelacionaCPcuenta" access="private" output="no" returntype="numeric">
		<cfargument name="Lprm_Cmayor" 				type="string"  required="yes">
		<cfargument name="Lprm_Cdetalle" 			type="string"  required="yes">

		<!--- Obtiene el Formato Presupuestario --->
		<cfset Lvar_fmtGenerarP = Lprm_Cmayor>
		<cfset Lvar_PCDCnivP = 0>
		<cfset Lvar_PCDCnivF = 1>
		<cfset Lvar_posicion = 1>
		<cfloop condition="Lvar_PCDCnivF LTE Lvar_NivelesF">
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select PCNlongitud, PCNpresupuesto
				  from PCNivelMascara
				 where PCEMid = #Lvar_MascaraID#
				   and PCNid = #Lvar_PCDCnivF#
			</cfquery>
		
			<!--- Obtiene el siguiente valor --->
			<cfset Lvar_longitud = rsSQL.PCNlongitud>
			<cfset Lvar_valor = mid(Lprm_Cdetalle, Lvar_posicion, Lvar_longitud)>
			
			<!--- Obtiene la longitud del valor entre Guiones --->
			<cfset Lvar_longitudValor = find("-",Lprm_Cdetalle,Lvar_posicion)>
			<cfif Lvar_longitudValor EQ 0>
				<cfset Lvar_longitudValor = len(Lprm_Cdetalle)+1>
			</cfif>
			<cfset Lvar_longitudValor = Lvar_longitudValor - Lvar_posicion>
		
			<cfif rsSQL.PCNpresupuesto EQ "1">
				<cfset Lvar_fmtGenerarP = Lvar_fmtGenerarP & '-' & Lvar_valor>
			</cfif>
			
			<cfset Lvar_posicion = Lvar_posicion + Lvar_longitud + 1>
			<cfset Lvar_PCDCnivF = Lvar_PCDCnivF + 1>
		</cfloop>
		
		<cfquery name="rsCP" datasource="#GvarDSN#">
			select CPcuenta
			  from CPresupuesto
			 where Ecodigo  	= #GvarEcodigo# 
			   and Cmayor 		= '#Lprm_Cmayor#' 
			   and CPVid 		= #Lvar_VigenciaID#
			   and CPformato 	= '#Lvar_fmtGenerarP#'
		</cfquery>
		<cfif rsCP.CPcuenta EQ "">
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select count(1) as cantidad
				  from CPresupuesto
				 where Ecodigo  	= #GvarEcodigo# 
				   and CPformato 	= '#Lvar_fmtGenerarP#'
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfreturn -1>
			<cfelse>
				<cfreturn -2>
			</cfif>
		<cfelse>
			<cfquery datasource="#GvarDSN#">
				update CFinanciera
				   set CPcuenta = #rsCP.CPcuenta#
				 where CFcuenta	= #Lvar_CFcuenta# 
			</cfquery>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select cf.CFcuenta, cf.Ccuenta, cf.CPcuenta, cf.CFformato, coalesce(cf.CFdescripcionF,cf.CFdescripcion) as CFdescripcionF,
						cf.CFmovimiento, coalesce(c.Mcodigo, 1) as Auxiliar,
						c.Cformato, p.CPformato
				  from CFinanciera cf
					 inner join CContables c
					   on c.Ccuenta = cf.Ccuenta
					 inner join CPresupuesto p
					   on p.CPcuenta = cf.CPcuenta
				 where cf.CFcuenta 	= #Lvar_CFcuenta#
			</cfquery>
		</cfif>
		
		<cfreturn rsCP.CPcuenta>
	</cffunction>
	
	<cffunction name="fnVerificaNiveles" access="private" output="no" returntype="string">
		<cfargument name="Lprm_Cmayor" 				type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    required="yes">
		<cfargument name="Lprm_Ocodigo"				type="numeric" required="yes">
		<cfargument name="Lprm_Verificar_CFid"				type="numeric" required="yes">

		<cfargument name="Lprm_EsDePresupuesto"		type="boolean" required="yes">
		<cfargument name="Lprm_NoVerificarPres"		type="boolean" required="yes">
		<cfargument name="Lprm_NoVerificarObras"	type="boolean" required="yes">

		<cfargument name="Lprm_debug" 				type="boolean" required="yes">
	
		<cfset var LvarERRs		= "">
		<cfset var LvarFecha	= createODBCdatetime(createODBCdate(Lprm_Fecha))>

		<!--- 
			OJO:	Si no se envía Lprm_Ocodigo la verificación es parcial:
					- Control de Obras:
						Sólo se verificaría la existencia de la cuenta en obras
					- Control de Cuentas Inactivas:
						OK
					- Control de Plan de Cuentas:
						Faltaría Valores por Oficina
					- Control de Reglas Financieras:
						No se verificaría ninguna regla
		 --->

		<!--- VERIFICACION DE CONTROL DE OBRAS --->
		<cfif NOT Lprm_EsDePresupuesto AND NOT Lprm_NoVerificarObras>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select om.OBCcontrolCuentas
				  from OBctasMayor om
				 where om.Ecodigo	= #GvarEcodigo#
				   and om.Cmayor	= '#Lprm_Cmayor#'
			</cfquery>
			<cfif rsSQL.OBCcontrolCuentas EQ "1">
				<cfif Lprm_Ocodigo EQ "-1">
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select    ec.CFformato
								, p.OBPcodigo
								, o.OBOcodigo, o.OBOestado
								, min(ec.OBECestado) as OBECestado
						  from OBetapaCuentas ec
							inner join OBetapa e
								inner join OBobra o
									inner join OBproyecto p
									   on p.OBPid = o.OBPid
								   on o.OBOid = e.OBOid
							   on e.OBEid = ec.OBEid
						 where ec.Ecodigo	 = #GvarEcodigo#
						   and ec.CFformato  = '#Lvar_fmtVerif#'
						   and ec.OBECestado <> '0'
						 group by ec.CFformato
								, p.OBPcodigo
								, o.OBOcodigo, o.OBOestado
					</cfquery>
					<cfif rsSQL.recordCount EQ 0>
						<cfreturn "Control de Obras: Cuenta no ha sido registrada o generada en Obras.">
					<cfelseif rsSQL.OBOestado EQ "3">
						<cfreturn "Control de Obras: Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Obra liquidada.">
					<cfelseif rsSQL.OBOestado NEQ "1">
						<cfreturn "Control de Obras: Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Obra inactiva.">
					<cfelseif rsSQL.OBECestado NEQ "1">
						<cfreturn "Control de Obras: Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Cuenta inactiva.">
					<cfelse>
						<cfreturn "OK">
					</cfif>
				<cfelse>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select 	  Oficodigo
								, EC_CFformato
								, OBPcodigo
								, OBOcodigo, 	OBOestado
								, Oficinas, 	Etapas,		Activas
						  from (
							select	  ofi.Oficodigo
									, coalesce(ec.CFformato,'*') as EC_CFformato
									, p.OBPcodigo
									, o.OBOcodigo, o.OBOestado
									, count(case when e.Ocodigo = ofi.Ocodigo then 1 end) Oficinas
									, count(case when e.Ocodigo = ofi.Ocodigo AND e.OBEestado='1' then 1 end) Etapas
									, count(case when e.Ocodigo = ofi.Ocodigo AND e.OBEestado='1' AND ec.OBECestado='1' then 1 end) Activas
							  from Oficinas ofi
								 left join OBetapaCuentas ec
									inner join OBetapa e
										inner join OBobra o
											inner join OBproyecto p
											   on p.OBPid = o.OBPid
										   on o.OBOid = e.OBOid
										  and o.OBOestado <> '0'
									   on e.OBEid = ec.OBEid
								   on ec.Ecodigo	= #GvarEcodigo#
								  and ec.CFformato  = '#Lvar_fmtVerif#'
								  and ec.OBECestado <> '0'
							 where ofi.Ecodigo 	= #GvarEcodigo#
							   and ofi.Ocodigo	= #Lprm_Ocodigo#
							group by  ofi.Oficodigo
									, coalesce(ec.CFformato,'*')
									, p.OBPcodigo
									, o.OBOcodigo, o.OBOestado
						) as rsSQL
						 where EC_CFformato = '*'
							OR OBOestado 	<> '1'
							OR Oficinas		= 0
							OR Etapas		= 0
							OR Activas		= 0
					</cfquery>
			
					<cfloop query="rsSQL">
						<cfset LvarERRs = LvarERRs & "Control de Obras: ">
						<cfif rsSQL.EC_CFformato EQ "*">
							<cfset LvarERRs = LvarERRs & "Cuenta no ha sido registrada o generada en Obras.#chr(10)#">
						<cfelseif rsSQL.OBOestado EQ "3">
							<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Obra liquidada.#chr(10)#">
						<cfelseif rsSQL.OBOestado NEQ "1">
							<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Obra inactiva.#chr(10)#">
						<cfelseif rsSQL.Oficinas EQ 0>
							<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Cuenta no asignada a Oficina='#trim(rsSQL.Oficodigo)#'.#chr(10)#">
						<cfelseif rsSQL.Etapas EQ 0>
							<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Etapas inactivas para Oficina='#trim(rsSQL.Oficodigo)#'.#chr(10)#">
						<cfelseif rsSQL.Activas EQ 0>
							<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Cuenta inactiva.#chr(10)#">
						</cfif>
						<cfreturn LvarERRs>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>

		<!--- VERIFICACION DE CONTROL DE PLAN DE CUENTAS --->
		<cfif Lvar_ConPlanCtas>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select 	  n.PCDCniv 	, n.valor
						, ec.PCEcatid	, ec.PCEcodigo	, ec.PCEdescripcion, ec.PCEactivo
						, dc.PCDcatid	, dc.PCDvalor	, dc.PCDactivo,
						<cfif LvarUsarDescripcionAlterna>
							coalesce(dc.PCDdescripcionA,dc.PCDdescripcion) as PCDdescripcion
						<cfelse>
							dc.PCDdescripcion
						</cfif>
						
				  from #NIVELES# n #NOLOCK# 
					 left join PCECatalogo ec
					   on ec.PCEcatid = n.PCEcatid
					 left join PCDCatalogo dc
					   on dc.PCDcatid = n.PCDcatid
				 where n.IDtemp  = #GvarIDtemp#
				   and n.BMfecha = #GvarBMfecha#
				   and n.PCDCniv > 0
				   and (
						  ec.PCEcatid is null
					   OR ec.PCEactivo = 0
					   OR dc.PCDcatid is null
					   OR dc.PCDactivo = 0
				<cfif Lprm_Ocodigo NEQ "-1">
					   OR (
								ec.PCEempresa = 1
							and ec.PCEoficina = 1
							and
								(
									select count(1)
									  from PCDCatalogoValOficina vo
									 where vo.PCDcatid = n.PCDcatid
									   and vo.Ecodigo  = #GvarEcodigo#
									   and vo.Ocodigo  = #Lprm_Ocodigo#
								) = 0
						  )
				</cfif>
					    )
				  order by n.PCDCniv
			</cfquery>
			<cfloop query="rsSQL">
				<cfset LvarERRs = LvarERRs & "    Nivel=#trim(rsSQL.PCDCniv)#, ">
				<cfif rsSQL.PCEcatid EQ "">
					<cfset LvarERRs = LvarERRs & "Error en la definici&oacute;n de la M&aacute;scara, no tiene definido ni cat&aacute;logo independiente, ni nivel dependiente.#chr(10)#">
				<cfelseif rsSQL.PCEactivo EQ "0">
					<cfset LvarERRs = LvarERRs & "Valor='#trim(rsSQL.valor)#', Cat&aacute;logo='#trim(rsSQL.PCEcodigo)#-#trim(rsSQL.PCEdescripcion)#', Cat&aacute;logo Inactivo.#chr(10)#">
				<cfelseif rsSQL.PCDcatid EQ "">
					<cfset LvarERRs = LvarERRs & "Valor='#trim(rsSQL.valor)#', Cat&aacute;logo='#trim(rsSQL.PCEcodigo)#-#trim(rsSQL.PCEdescripcion)#', Valor no existe en Cat&aacute;logo.#chr(10)#">
				<cfelseif rsSQL.PCDactivo EQ "0">
					<cfset LvarERRs = LvarERRs & "Valor='#trim(rsSQL.valor)#-#trim(rsSQL.PCDdescripcion)#', Cat&aacute;logo='#trim(rsSQL.PCEcodigo)#-#trim(rsSQL.PCEdescripcion)#', Valor Inactivo en Cat&aacute;logo.#chr(10)#">
				<cfelse>
					<cfquery name="rsOfi" datasource="#GvarDSN#">
						select Oficodigo, Odescripcion
						  from Oficinas
						 where Ecodigo = #GvarEcodigo#
						   and Ocodigo = #Lprm_Ocodigo#
					</cfquery>
					<cfset LvarERRs = LvarERRs & "Valor='#trim(rsSQL.valor)#-#trim(rsSQL.PCDdescripcion)#', Cat&aacute;logo='#trim(rsSQL.PCEcodigo)#-#trim(rsSQL.PCEdescripcion)#', Valor no asignado a Oficina='#trim(rsOfi.Oficodigo)#-#trim(rsOfi.Odescripcion)#'.#chr(10)#">
				</cfif>
			</cfloop>
			
			<cfif LvarERRs NEQ "">
				<cfif rsSQL.recordCount EQ 1>
					<cfreturn "Control de Plan de Cuentas: #trim(LvarERRs)#">
				<cfelse>
					<cfreturn "Control de Plan de Cuentas:#chr(10)##LvarERRs#">
				</cfif>
			</cfif>
		</cfif>

		<!--- VERIFICACION DE CONTROL DE CUENTAS INACTIVAS --->
		<cfquery name="rsSQL" datasource="#GvarDSN#">
			<cfif NOT Lprm_EsDePresupuesto>
				<!--- Cuentas Financieras --->
				select 'F' as tipo, ci.CFformato as FormatoI, i.CFIdesde as desde, i.CFIhasta as hasta
				  from #NIVELES# n #NOLOCK# 
					inner join CFInactivas i 
					   on i.CFcuenta = n.CcuentaF
					inner join CFinanciera ci
					   on ci.CFcuenta = n.CcuentaF
				 where n.IDtemp  = #GvarIDtemp#
				   and n.BMfecha = #GvarBMfecha#
				   and #LvarFecha# between i.CFIdesde and i.CFIhasta
				UNION
				<!--- Cuentas Contables --->
				select 'C' as tipo, ci.Cformato as FormatoI, i.CCIdesde as desde, i.CCIhasta as hasta
				  from #NIVELES# n #NOLOCK# 
					inner join CCInactivas i 
					   on i.Ccuenta = n.CcuentaC
					inner join CContables ci
					   on ci.Ccuenta = n.CcuentaC
				 where n.IDtemp  = #GvarIDtemp#
				   and n.BMfecha = #GvarBMfecha#
				   and #LvarFecha# between i.CCIdesde and i.CCIhasta
				UNION
			</cfif>
			<!--- Cuentas de Presupuesto --->
			select 'P' as tipo, ci.CPformato as FormatoI, i.CPIdesde as desde, i.CPIhasta as hasta
			  from #NIVELES# n #NOLOCK# 
				inner join CPInactivas i 
				   on i.CPcuenta = n.CcuentaP
				inner join CPresupuesto ci
				   on ci.CPcuenta = n.CcuentaP
			 where n.IDtemp  = #GvarIDtemp#
			   and n.BMfecha = #GvarBMfecha#
			   and #LvarFecha# between i.CPIdesde and i.CPIhasta
			 ORDER BY FormatoI
		</cfquery>

		<cfparam name="Lvar_fmtGenerarF" default="">
		<cfparam name="Lvar_fmtGenerarP" default="">

		<cfset Lvar_fmtGenerarF = trim(Lvar_fmtGenerarF)>
		<cfif Lprm_EsDePresupuesto>
			<cfset Lvar_fmtGenerar = Lvar_fmtGenerarP>
		<cfelse>
			<cfset Lvar_fmtGenerar = Lvar_fmtGenerarF>
		</cfif>
		<cfloop query="rsSQL">
			<cfif rsSQL.Tipo EQ "F">
				<cfset LvarERRs = LvarERRs & "    Cuenta Financiera ">
				<cfif Lvar_fmtGenerar NEQ trim(rsSQL.FormatoI)>
					<cfset LvarERRs = LvarERRs & "'#trim(rsSQL.FormatoI)#' ">
				</cfif>
			<cfelseif rsSQL.Tipo EQ "C">
				<cfset LvarERRs = LvarERRs & "    Cuenta Contable ">
				<cfif Lvar_fmtGenerar NEQ trim(rsSQL.FormatoI)>
					<cfset LvarERRs = LvarERRs & "'#trim(rsSQL.FormatoI)#' ">
				</cfif>
			<cfelse>
				<cfset LvarERRs = LvarERRs & "    Cuenta de Presupuesto ">
				<cfif Lvar_fmtGenerar NEQ trim(rsSQL.FormatoI)>
					<cfset LvarERRs = LvarERRs & "'#trim(rsSQL.FormatoI)#' ">
				</cfif>
			</cfif>
			<cfset LvarERRs = LvarERRs & "inactiva del #dateFormat(rsSQL.desde,"dd/mm/yy")# al #dateFormat(rsSQL.hasta,"dd/mm/yy")#.#chr(10)#">
		</cfloop>

		<cfif LvarERRs NEQ "">
			<cfif rsSQL.recordCount EQ 1>
				<cfreturn "Control de Cuentas Inactivas: #trim(LvarERRs)#">
			<cfelse>
				<cfreturn "Control de Cuentas Inactivas:#chr(10)##LvarERRs#">
			</cfif>
		</cfif>

		<!--- VERIFICACION DE CONTROL DE REGLAS FINANCIERAS --->
		<cfif NOT Lprm_EsDePresupuesto AND Lprm_Ocodigo NEQ "-1">
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				SELECT 'I' as Tipo, ofi.Oficodigo
				  from Oficinas ofi
				 where Ecodigo 	= #GvarEcodigo#
				   and Ocodigo	= #Lprm_Ocodigo#
				   and
					(	
						select count(1)
						  from PCReglas R
						 where R.PCRref 	is 		null
						   and R.PCRvalida  = 		1
						   and R.Cmayor 	= 		'#Lprm_Cmayor#'
						   and R.Ecodigo 	= 		ofi.Ecodigo
						   and #LvarFecha# between 	R.PCRdesde and R.PCRhasta
						   and
								(
									select count(1)
									  from PCReglas  RI
									 where RI.PCRref 			is 		null
									   and RI.PCRvalida 		= 		1
									   and RI.Cmayor 			= 		R.Cmayor
									   and RI.Ecodigo 			= 		R.Ecodigo
									   and #LvarFecha# 			between RI.PCRdesde and RI.PCRhasta
									   and <cf_dbfunction name="like" args="'#Lvar_fmtVerif#';RI.PCRregla" delimiters=";">
									   and <cf_dbfunction name="like" args="ofi.Oficodigo;coalesce(RI.OficodigoM, '%')" delimiters=";">
									   and
											(
												select count(1)
												  from PCReglas EC
												 where EC.PCRref			= RI.PCRid
												   and EC.PCRvalida			= 0
												   and #LvarFecha#			between EC.PCRdesde and EC.PCRhasta 
												   and <cf_dbfunction name="like" args="'#Lvar_fmtVerif#';EC.PCRregla" delimiters=";">
												   and <cf_dbfunction name="like" args="ofi.Oficodigo;coalesce(EC.OficodigoM, '%')" delimiters=";">
											) = 0
								) = 0
					) > 0
				UNION
				select 'E' as Tipo, ofi.Oficodigo
				  from Oficinas ofi
				 where Ecodigo 	= #GvarEcodigo#
				   and Ocodigo	= #Lprm_Ocodigo#
				   and
					(
						select count(1)
						  from PCReglas  RE
						 where RE.PCRref 			is 		null
						   and RE.PCRvalida			= 		0
						   and RE.Cmayor			= 		'#Lprm_Cmayor#'
						   and RE.Ecodigo			= 		ofi.Ecodigo
						   and #LvarFecha#			between RE.PCRdesde and RE.PCRhasta
						   and <cf_dbfunction name="like" args="'#Lvar_fmtVerif#';RE.PCRregla" delimiters=";">
						   and <cf_dbfunction name="like" args="ofi.Oficodigo;coalesce(RE.OficodigoM, '%')" delimiters=";">
						   and
								(
									select count(1)
									  from PCReglas EC
									 where EC.PCRref 			= 		RE.PCRid
									   and EC.PCRvalida			= 		1
									   and #LvarFecha#			between EC.PCRdesde and EC.PCRhasta 
									   and <cf_dbfunction name="like" args="'#Lvar_fmtVerif#';EC.PCRregla" delimiters=";">
									   and <cf_dbfunction name="like" args="ofi.Oficodigo;coalesce(EC.OficodigoM, '%')" delimiters=";">
								) = 0
					) > 0
				order by Tipo desc
			</cfquery>
			
			<cfloop query="rsSQL">
				<cfset LvarOficodigo = #trim(rsSQL.Oficodigo)#>
				<cfset LvarERRs = LvarERRs & "    #chr(10)#">
				<cfif rsSQL.Tipo EQ "I">
					<!--- obtener descripcion de la regalas de inclusion --->
						<cfquery name="rsIncluSQL" datasource="#GvarDSN#">
							select Distinct R.PCRdescripcion as descRegla
								  from PCReglas R
								 where R.PCRref is null
								   and R.PCRvalida  = 		1
								   and R.Cmayor 	= 		'#Lprm_Cmayor#'
								   and R.Ecodigo 	= 		 #GvarEcodigo#
								   and #LvarFecha# between 	R.PCRdesde and R.PCRhasta
								   and
										(
											select count(1)
											  from PCReglas  RI
											 where RI.PCRref 			is 		null
											   and RI.PCRvalida 		= 		1
											   and RI.Cmayor 			= 		R.Cmayor
											   and RI.Ecodigo 			= 		R.Ecodigo
											   and #LvarFecha# 			between RI.PCRdesde and RI.PCRhasta
											   and <cf_dbfunction name="like" args="'#Lvar_fmtVerif#';RI.PCRregla" delimiters=";">
											   and <cf_dbfunction name="like" args="'#rsSQL.Oficodigo#';coalesce(RI.OficodigoM, '%')" delimiters=";">
											   and
													(
														select count(1)
														  from PCReglas EC
														 where EC.PCRref			= RI.PCRid
														   and EC.PCRvalida			= 0
														   and #LvarFecha#			between EC.PCRdesde and EC.PCRhasta 
														   and <cf_dbfunction name="like" args="'#Lvar_fmtVerif#';EC.PCRregla" delimiters=";">
														   and <cf_dbfunction name="like" args="'#rsSQL.Oficodigo#';coalesce(EC.OficodigoM, '%')" delimiters=";">
													) = 0
										) = 0
						</cfquery>
					<!--- mostrar las descripciones de las reglas--->
					<cfif rsIncluSQL.recordcount GT 0 >
						<cfloop query="rsIncluSQL">
							<cfset LvarERRs = LvarERRs & "#chr(10)#No cumple Regla de Inclusión, Regla-Descripción: "& rsIncluSQL.descRegla & ".">
						</cfloop>
					</cfif>
				<cfelse>
						<!--- obtener descripcion de la regalas de Exclusion --->
						<cfquery name="rsExcluSQL" datasource="#GvarDSN#">
							select ''#_Cat# RE.PCRregla #_Cat#' - ' #_Cat# RE.PCRdescripcion  as descRegla
								  from PCReglas  RE
								 where RE.PCRref 			is 		null
								   and RE.PCRvalida			= 		0
								   and RE.Cmayor			= 		'#Lprm_Cmayor#'
								   and RE.Ecodigo			= 		#GvarEcodigo#
								   and #LvarFecha#			between RE.PCRdesde and RE.PCRhasta
								   and <cf_dbfunction name="like" args="'#Lvar_fmtVerif#';RE.PCRregla" delimiters=";">
								   and <cf_dbfunction name="like" args="'#rsSQL.Oficodigo#';coalesce(RE.OficodigoM, '%')" delimiters=";">
								   and
										(
											select count(1)
											  from PCReglas EC
											 where EC.PCRref 			= 		RE.PCRid
											   and EC.PCRvalida			= 		1
											   and #LvarFecha#			between EC.PCRdesde and EC.PCRhasta 
											   and <cf_dbfunction name="like" args="'#Lvar_fmtVerif#';EC.PCRregla" delimiters=";">
											   and <cf_dbfunction name="like" args="'#rsSQL.Oficodigo#';coalesce(EC.OficodigoM, '%')" delimiters=";">
										) = 0
						</cfquery>
				<!--- mostrar las descripciones de las reglas--->
					<cfif rsIncluSQL.recordcount GT 0 >
						<cfloop query="rsExcluSQL">
							<cfset LvarERRs = LvarERRs & "#chr(10)#Rechazada por Regla de Exclusi&oacute;n, Regla-Descripci&oacute;n: "& rsExcluSQL.descRegla &".">
						</cfloop>
					</cfif>
				</cfif>
			</cfloop>
			<!--- Control de Reglas Financieras --->
			<cfif LvarERRs NEQ "">
				<cfif rsSQL.recordCount EQ 1>
					<cfreturn "Control de Reglas Financieras (Oficina='#LvarOficodigo#'): #trim(LvarERRs)#">
				<cfelse>
					<cfreturn "Control de Reglas Financieras (Oficina='#LvarOficodigo#'): #chr(10)##LvarERRs#">
				</cfif>
			</cfif>
		</cfif>

		<!--- VERIFICACION DE CONTROL DE MASCARAS DE CENTRO FUNCIONAL --->
		<cfif NOT Lprm_EsDePresupuesto AND Lprm_Verificar_CFid NEQ "-1">
			<cfquery name="rsCFctas" datasource="#GvarDSN#">
				select 	CFcodigo, 			CFdescripcion,
						CFcuentac, 			CFcuentaaf,
						CFcuentainversion, 	CFcuentainventario,
						CFcuentaingreso, 	CFcuentagastoretaf,
						CFcuentaingresoretaf
				  from CFuncional
				 where CFid = #Lprm_Verificar_CFid#
			</cfquery>
			<cfif 	 ReFind(fnComodinToMascaraRegExp(rsCFctas.CFcuentac),				Lvar_fmtVerif)
					+ReFind(fnComodinToMascaraRegExp(rsCFctas.CFcuentaaf),				Lvar_fmtVerif)
					+ReFind(fnComodinToMascaraRegExp(rsCFctas.CFcuentainversion),		Lvar_fmtVerif)
					+ReFind(fnComodinToMascaraRegExp(rsCFctas.CFcuentainventario),		Lvar_fmtVerif)
					+ReFind(fnComodinToMascaraRegExp(rsCFctas.CFcuentaingreso),			Lvar_fmtVerif)
					+ReFind(fnComodinToMascaraRegExp(rsCFctas.CFcuentagastoretaf),		Lvar_fmtVerif)
					+ReFind(fnComodinToMascaraRegExp(rsCFctas.CFcuentaingresoretaf),	Lvar_fmtVerif)
			 EQ 0>
				<cfreturn "Control de Centro Funcional: La cuenta no corresponde a las m&aacute;scaras del Centro Funcional='#trim(rsCFctas.CFcodigo)#'">
			</cfif>
		</cfif>
		
		<!--- VERIFICACION DE LA EXISTENCIA O CREACION DE LA CUENTA DE PRESUPUESTO --->
		<cfif NOT Lprm_EsDePresupuesto AND NOT Lprm_NoVerificarPres>
			<cfif Lvar_NivelesP EQ 0>
				<!--- Cuenta no contiene niveles de presupuesto o es periodo que no controla presupuesto --->
				<cfset Lvar_CPcuenta = "">
				<cfset Lvar_fmtGenerarP = "">
			<cfelse>
				<!--- Lvar_fmtGenerarP se construyó en GeneraNiveles --->
				<cfset Lvar_fmtGenerarP = trim(Lvar_fmtGenerarP)>

				<!--- Busca la Cuenta de Presupuesto --->
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					SELECT count(distinct CPTCtipo) as cantidad, max(CPTCtipo) as CPTCtipo
					  from CPtipoCtas
					 where CPPid	= #LvarCPPid# 
					   AND Ecodigo	= #GvarEcodigo#
					   AND Cmayor	= '#left(Lvar_fmtGenerarP,4)#'
					   AND <cf_dbfunction name="LIKE" args="'#trim(Lvar_fmtGenerarP)#',CPTCmascara">
				</cfquery>
				<cfif rsSQL.cantidad GT 1>
					<cfthrow message="Control de Presupuesto: La Cuenta de Presupuesto '#Lvar_fmtGenerarP#' esta definida en diferentes Excepciones en la Clasificación de Cuentas según tipo de Presupuesto.">
				</cfif>
				<cfset LvarCPcuentaDeExclusion = (rsSQL.CPTCtipo EQ 'X')>

				<cfif Lvar_CuentaYaExiste>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select P.CPcuenta, c.CPPid
						  from CPresupuesto P
							left join CPCuentaPeriodo c
							  on c.Ecodigo   = P.Ecodigo
							 and c.CPPid     = #LvarCPPid#
							 and c.CPcuenta  = P.CPcuenta
						 where P.Ecodigo 	= #GvarEcodigo#
						   and P.CPcuenta	= #Lvar_CPcuenta#
						   and P.CPVid		= #Lvar_VigenciaID#
					</cfquery>
				<cfelse>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select P.CPcuenta, c.CPPid
						  from CPresupuesto P
							left join CPCuentaPeriodo c
							  on c.Ecodigo   = P.Ecodigo
							 and c.CPPid     = #LvarCPPid#
							 and c.CPcuenta  = P.CPcuenta
						 where P.Ecodigo 	= #GvarEcodigo#
						   and P.Cmayor		= '#Lprm_Cmayor#'
						   and P.CPformato	= '#Lvar_fmtGenerarP#'
						   and P.CPVid		= #Lvar_VigenciaID#
					</cfquery>
				</cfif>

				<cfif rsSQL.CPcuenta NEQ "">
					<!--- Se encontró la Cuenta de Presupuesto--->
					<cfset Lvar_CPcuenta = rsSQL.CPcuenta>

					<cfif rsSQL.CPPid NEQ "" OR LvarCPcuentaDeExclusion>
						<!--- La cuenta ya está definida en el Período de Presupuesto --->
						<!--- Si es una Cuenta con mascara de Presupuesto pero de Exclusion no es necesario Formularla --->
					<cfelseif LvarPermiteCrearFormulacion>
						<!--- Se permite crear formulación en linea por lo que se agrega al período --->
						<cfquery datasource="#GvarDSN#">
							insert into CPCuentaPeriodo
								(
									Ecodigo, CPPid, CPcuenta, 
									CPCPtipoControl, CPCPcalculoControl
								)
							values
								(
									#GvarEcodigo#,
									#LvarCPPid#,
									#Lvar_CPcuenta#,
									#Lvar_CVPtipoControl#,
									#Lvar_CVPcalculoControl#
								)
						</cfquery>
					<cfelse>
						<!--- La cuenta no se ha definido en el Período de Presupuesto --->
						<cfreturn "Control de Presupuesto: No se ha formulado la cuenta de presupuesto '#Lvar_fmtGenerarP#' para el Per&iacute;odo">
					</cfif>
				<cfelseif LvarPermiteCrearCPcuenta OR LvarCPcuentaDeExclusion>
					<!--- Permite crear en línea una Cuenta de Presupuesto nueva --->
					<!--- Si es una Cuenta con mascara de Presupuesto pero de Exclusion se crea la cuenta pero no se usa --->
					<cfset Lvar_CuentaYaExiste_BK = Lvar_CuentaYaExiste>
					<cfset Lvar_CuentaYaExiste = false>
					<cfset LvarMSG = fnGeneraCuenta(Lprm_Cmayor, Lprm_Fecha, true, true, LvarCPPid, -1, '', Lprm_debug, false)>
					<cfset Lvar_CuentaYaExiste = Lvar_CuentaYaExiste_BK>
					<cfif LvarMSG NEQ "NEW">
						<cfreturn "Control de Presupuesto: Error creando dinámicamente la Cuenta de Presupuesto: #LvarMSG#">
					</cfif>
				<cfelse>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select count(1) as cantidad
						  from CPresupuesto
						 where Ecodigo 		= #GvarEcodigo#
						   and CPformato	= '#Lvar_fmtGenerarP#'
					</cfquery>
					<cfif rsSQL.cantidad EQ 0>
						<cfreturn "Control de Presupuesto: No existe la Cuenta de Presupuesto '#Lvar_fmtGenerarP#' (3).">
					<cfelse>
						<cfreturn "Control de Presupuesto: La Cuenta de Presupuesto '#Lvar_fmtGenerarP#' existe pero no est&aacute; vigente">
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		
		<cfreturn "OK">
	</cffunction>
	
	<cffunction name="fnComodinToMascaraRegExp" access="private" output="no">
		<cfargument name="Comodin" type="string" required="yes">
	
		<cfset var LvarComodines = "?,*,!,_">
	
		<cfset var LvarMascara = Arguments.Comodin>
		<cfloop index="LvarChar" list="#LvarComodines#">
			<cfset LvarMascara = replace(LvarMascara,mid(LvarChar,1,1),"(.{1})","ALL")>
		</cfloop>
		<cfreturn LvarMascara>
	</cffunction>
	
	<cffunction name="fnGeneraCuenta" access="private" output="no" returntype="string">
		<cfargument name="Lprm_Cmayor" 				type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    required="yes">
		<cfargument name="Lprm_CrearPresupuesto"	type="boolean" required="yes">
		<cfargument name="Lprm_EsDePresupuesto"		type="boolean" required="yes">
		<cfargument name="Lprm_CPPid"				type="numeric" required="yes">
		<cfargument name="Lprm_CVid"				type="numeric" required="yes">
		<cfargument name="Lprm_Cdescripcion"		type="string"  default="">
		<cfargument name="Lprm_debug" 				type="boolean" required="yes">
		<cfargument name="Lprm_EsDePlanCompras"		type="boolean" required="yes">

		<cfif Lprm_EsDePresupuesto>
			<cfif Lprm_CVid EQ "-1">
				<!--- No es Control de Version --->
				<cfif Lprm_CrearPresupuesto AND Lvar_CPcuenta NEQ "">
					<cfif fnExists(
							  "select 1 
								 from CPCuentaPeriodo
								where Ecodigo   = #GvarEcodigo#
								  and CPPid     = #Lprm_CPPid#
								  and CPcuenta  = #Lvar_CPcuenta#
					")>
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							update CPCuentaPeriodo
							   set CPCPtipoControl = #Lvar_CVPtipoControl#,
								   CPCPcalculoControl = #Lvar_CVPcalculoControl#
							 where Ecodigo   = #GvarEcodigo#
							   and CPPid     = #Lprm_CPPid#
							   and CPcuenta  = #Lvar_CPcuenta#
						</cfquery>
					<cfelse>
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							insert into CPCuentaPeriodo
								(Ecodigo, CPPid, CPcuenta, 
								 CPCPtipoControl, CPCPcalculoControl
								)
							values
								(
								#GvarEcodigo#,
								#Lprm_CPPid#,
								#Lvar_CPcuenta#,
								#Lvar_CVPtipoControl#,
								#Lvar_CVPcalculoControl#
								)
						</cfquery>
					</cfif>
				</cfif>
			<cfelse>
				<!--- Es control de Version --->
				<cfquery name="rsCPresupuesto" datasource="#GvarDSN#">
					select c.Cmayor, c.CPcuenta, c.CPformato, coalesce(c.CPdescripcionF, c.CPdescripcion) as CPdescripcion
					  from CPresupuesto c
					 where c.Ecodigo   	= #GvarEcodigo#
					   and c.Cmayor    	= '#Lprm_Cmayor#'
					   and c.CPVid     	= #Lvar_VigenciaID#
					   and c.CPformato 	= '#Lvar_fmtVerif#'
				</cfquery>
	
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select CPcuenta, CVPcuenta
					  from CVPresupuesto
					 where Ecodigo   = #GvarEcodigo#
					   and CVid      = #Lprm_CVid#
					   and Cmayor    = '#Lprm_Cmayor#'
					   and CPformato = '#Lvar_fmtVerif#'
				</cfquery>

				<cfset LvarCVPcuenta = rsSQL.CVPcuenta>

				<cfif rsSQL.CPcuenta EQ "" AND rsCPresupuesto.CPcuenta NEQ "">
					<cfif LvarCVPcuenta NEQ "">
						<cfquery datasource="#GvarDSN#">
							update CVPresupuesto
							   set CPcuenta = #rsCPresupuesto.CPcuenta#
							 where Ecodigo   = #GvarEcodigo#
							   and CVid      = #Lprm_CVid#
							   and CVPcuenta = #LvarCVPcuenta#
						</cfquery>
					<cfelse>
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							select max(CVPcuenta) as ultimo
							  from CVPresupuesto
							 where Ecodigo	= #GvarEcodigo#
							   and CVid		= #Lprm_CVid#
						</cfquery>
						<cfif rsSQL.ultimo EQ "">
							<cfset LvarCVPcuenta = 1>
						<cfelse>
							<cfset LvarCVPcuenta = rsSQL.ultimo + 1>
						</cfif>
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							insert into CVPresupuesto (
								Ecodigo, 
								CVid,
								CVPcuenta,
								Cmayor, CPcuenta, 
								CPformato, CPdescripcion,
								CVPtipoControl,
								CVPcalculoControl
								)
							values (
								#GvarEcodigo#, 
								#Lprm_CVid#, 
								#LvarCVPcuenta#,
								'#rsCPresupuesto.Cmayor#', #rsCPresupuesto.CPcuenta#, 
								'#rsCPresupuesto.CPformato#', '#rsCPresupuesto.CPdescripcion#', 
								#Lvar_CVPtipoControl#, 
								#Lvar_CVPcalculoControl#
								)
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<!--- CREACION DE LA CUENTA --->
		<cfif NOT Lvar_CuentaYaExiste AND Lvar_Crear>
			<cfif Lprm_EsDePlanCompras>
				<!--- La Cuenta de Plan de Compras sólo almacena el último nivel --->
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					insert into PCGcuentas (
						Ecodigo, CFformato, CPformato, CPVid
						)
					values ( 
						#GvarEcodigo#, '#Lvar_fmtGenerarF#', '#Lvar_fmtGenerarP#', #Lvar_VigenciaID#
						)
					<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarDSN#">
				</cfquery>
				<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" datasource="#GvarDSN#">
				<cfset Lvar_PCGcuenta = rsSQL.identity>

				<cfquery name="rsSQL" datasource="#GvarDSN#">
					insert into PCDCatalogoCuentaPCG (PCGcuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv)
					select #Lvar_PCGcuenta#, a.PCEcatid, a.PCDcatid, #Lvar_MascaraID#, a.PCDCniv
					  from #NIVELES# a #NOLOCK#
					 where a.IDtemp  = #GvarIDtemp#
					   and a.BMfecha = #GvarBMfecha#
					   and a.PCDCniv > 0
					 order by a.PCDCniv
				</cfquery>
			<cfelse>
            	<!---Parametro Generar la Descripción de Cuentas Financieras en el Idioma de la Empresa--->
                <cfquery name="rsSQL" datasource="#GvarDSN#">
                    select coalesce(Pvalor,0) as Pvalor
                      from Parametros
                     where Ecodigo = #GvarEcodigo#
                       and Pcodigo = 200005
                </cfquery>
            	<cfset LvarGenCtasIdEmpr = rsSQL.Pvalor>
            
				<!--- Las Cuentas Financieras, Contable y Presupuesto almacenan cada nivel: Nivel 0=Mayor + Nivel 1 + ... Nivel N --->
				<!--- 1 - Crear Cuenta nivel 0 = Cta Mayor y obtiene IDs de Cuentas--->
				<cfif Lprm_EsDePresupuesto>
					<cfif Lprm_CVid EQ "-1">
						<!--- No es de Control de Version --->
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							select CPcuenta 
							  from CPresupuesto 
							 where Ecodigo		= #GvarEcodigo# 
							   and CPformato	= '#Lprm_Cmayor#' 
							   and CPVid 		= #Lvar_VigenciaID#
						</cfquery>
						<cfif rsSQL.CPcuenta NEQ "">
							<cfset Lvar_CPcuenta = rsSQL.CPcuenta>
						<cfelse>
							<cfquery name="rsSQL" datasource="#GvarDSN#">
								insert into CPresupuesto (
									CPVid,
									Ecodigo, Cmayor, CPformato, CPdescripcion,
									PCDcatid, CPmovimiento, 
									CPpadre
									)
								values ( 
									#Lvar_VigenciaID#,
									#GvarEcodigo#, '#Lprm_Cmayor#', '#trim(Lprm_Cmayor)#', '#Lvar_Cdescripcion#',
									null, 'N', <!--- PCDcatid, CPmovimiento--->
									null
									)
								<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarDSN#">
							</cfquery>
							<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" datasource="#GvarDSN#">
							<cfset Lvar_CPcuenta = rsSQL.identity>
						</cfif>
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							update #NIVELES# #ROWLOCK#
							   set CcuentaP = #Lvar_CPcuenta#
							 where IDtemp  = #GvarIDtemp#
							   and BMfecha = #GvarBMfecha#
							   and PCDCniv = 0
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select Ccuenta
						  from CContables
						 where Ecodigo		= #GvarEcodigo#
						   and Cformato		= '#Lprm_Cmayor#'
					</cfquery>
					<cfif rsSQL.Ccuenta NEQ "">
						<cfset Lvar_CCcuenta = rsSQL.Ccuenta>
					<cfelse>
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							insert into CContables (
								Ecodigo, Cmayor, Cformato, Cdescripcion,
								Mcodigo, SCid, PCDcatid, Cmovimiento, Cpadre, 
								Cbalancen, Cbalancenormal)
							values (
								#GvarEcodigo#, '#Lprm_Cmayor#', '#Lprm_Cmayor#', '#Lvar_Cdescripcion#',
								null, null, null, 'N', null, <!--- Mcodigo, SCid, PCDcatid, Cmovimiento, Cpadre --->
								'#Lvar_Cbalancen#', #Lvar_Cbalancenormal#
								)
							<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarDSN#">
						</cfquery>
						<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" datasource="#GvarDSN#">
						<cfset Lvar_CCcuenta = rsSQL.identity>
                        
					</cfif>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						update #NIVELES# #ROWLOCK#
						   set CcuentaC = #Lvar_CCcuenta#
						 where IDtemp  = #GvarIDtemp#
						   and BMfecha = #GvarBMfecha#
						   and PCDCniv = 0
					</cfquery>
	
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select CFcuenta
						  from CFinanciera a
						 where a.Ecodigo	= #GvarEcodigo#
						   and CFformato	= '#Lprm_Cmayor#'
						   and CPVid		= #Lvar_VigenciaID#
					</cfquery>
					<cfif rsSQL.CFcuenta NEQ "">
						<cfset Lvar_CFcuenta = rsSQL.CFcuenta>
					<cfelse>
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							insert into CFinanciera (
								CPVid,
								Ecodigo, Cmayor, CFformato, CFdescripcion,
								PCDcatid, CFmovimiento,  
								CFpadre, Ccuenta, CPcuenta)
							values (
								#Lvar_VigenciaID#,
								#GvarEcodigo#, '#Lprm_Cmayor#', '#Lprm_Cmayor#', '#Lvar_Cdescripcion#',
								null, 'N', <!--- PCDcatid, CFmovimiento --->
								null, null, null
								)
							<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarDSN#">
						</cfquery>
						<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" datasource="#GvarDSN#">
						<cfset Lvar_CFcuenta = rsSQL.identity>
					</cfif>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						update #NIVELES# #ROWLOCK#
						   set CcuentaF = #Lvar_CFcuenta#
						 where IDtemp  = #GvarIDtemp#
						   and BMfecha = #GvarBMfecha#
						   and PCDCniv = 0
					</cfquery>
	
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select CPcuenta 
						  from CPresupuesto 
						 where Ecodigo		= #GvarEcodigo# 
						   and CPformato	= '#Lprm_Cmayor#' 
						   and CPVid 		= #Lvar_VigenciaID#
					</cfquery>
					<cfset Lvar_CPcuenta = rsSQL.CPcuenta>
	
					<cfif rsSQL.CPcuenta NEQ "">
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							update #NIVELES# #ROWLOCK#
							   set CcuentaP = #Lvar_CPcuenta#
							 where IDtemp  = #GvarIDtemp#
							   and BMfecha = #GvarBMfecha#
							   and PCDCniv = 0
						</cfquery>
					</cfif>
				</cfif>
	
				<!--- 2- Crear Detalle de Cuenta --->
				<cfparam name="Lvar_CFcuenta" default="">
				<cfparam name="Lvar_CCcuenta" default="">
				<cfparam name="Lvar_CPcuenta" default="">
	
				<cfset Lvar_CFformato = Lprm_Cmayor>
				<cfset Lvar_CCformato = Lprm_Cmayor>
				<cfset Lvar_CPformato = Lprm_Cmayor>
	
				<cfset Lvar_CFpadre = "">
				<cfset Lvar_CCpadre = "">
				<cfset Lvar_CPpadre = "">
	
				<cfquery name="rsSQL" datasource="#GvarDSN#">
					select 	PCDCniv,	PCDCnivC,	PCDCnivP
					  from #NIVELES# n #NOLOCK#
					 where IDtemp  = #GvarIDtemp#
					   and BMfecha = #GvarBMfecha#
				</cfquery>

				<cfset Lvar_PCDCnivF = 1>
				<cfloop condition="Lvar_PCDCnivF LTE Lvar_NivelesF">
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						select 	CcuentaF,	CcuentaC,	CcuentaP,
								CformatoF,	CformatoC,	CformatoP, Cdescripcion,
								PCDCniv,	PCDCnivC,	PCDCnivP
						  from #NIVELES# n #NOLOCK#
						 where IDtemp  = #GvarIDtemp#
						   and BMfecha = #GvarBMfecha#
						   and PCDCniv = #Lvar_PCDCnivF#
					</cfquery>
	
					<cfset Lvar_CFpadre			= Lvar_CFcuenta>
					<cfset Lvar_CFformato		= rsSQL.CformatoF>
					<cfset Lvar_CFcuenta		= rsSQL.CcuentaF>
					<cfset Lvar_CFdescripcionF	= rsSQL.Cdescripcion>
					<cfset Lvar_PCDCnivC 		= rsSQL.PCDCnivC>
					<cfif rsSQL.CformatoC NEQ "">
						<cfset Lvar_CCpadre		= Lvar_CCcuenta>
						<cfset Lvar_CCcuenta	= rsSQL.CcuentaC>
						<cfset Lvar_CCformato	= rsSQL.CformatoC>
					</cfif>
	
					<cfset Lvar_PCDCnivP 	= rsSQL.PCDCnivP>
					<cfif rsSQL.CformatoP NEQ "">
						<cfset Lvar_CPpadre		= Lvar_CPcuenta>
						<cfset Lvar_CPcuenta	= rsSQL.CcuentaP>
						<cfset Lvar_CPformato 	= trim(rsSQL.CformatoP)>
					</cfif>
	
					<cfif Lprm_EsDePresupuesto>
						<!--- Crea la Cuenta Presupuesto solo si no existe --->
						<cfif Lprm_CVid EQ "-1">
							<!--- No es de Control de Version --->
							<cfif Lvar_PCDCnivP GT 0 AND Lvar_CPcuenta EQ "">
								<!--- Detalle de la Cuenta Presupuesto --->
								<cfquery name="rsNiveles" datasource="#GvarDSN#">
									select 
										#Lvar_VigenciaID# as VigenciaID,
										#GvarEcodigo# as GvarEcodigo,
										'#Lprm_Cmayor#' as Lprm_Cmayor,
										'#Lvar_CPformato#' as Lvar_CPformato,
										<cfif Lvar_PCDCnivP EQ Lvar_NivelesP>
											<cfif Lvar_ConPlanCtas and LEN(TRIM(LvarDescripcion_PCNidP)) and LvarDescripcion_PCNidP NEQ 'NULL'>
												#preserveSingleQuotes(LvarDescripcion_PCNidP)# as CPdescripcion, 
											<cfelse>
												'#Lvar_Cdescripcion# Ultimo Nivel' as CPdescripcion,
											</cfif>
											
											<cfif trim(Lprm_Cdescripcion) EQ "">
												<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as CPdescripcionF
											<cfelse>
 												'#Lprm_Cdescripcion#' as CPdescripcionF
											</cfif>, 
											
											'S' as CPmovimiento,
											
										<cfelse>
											<cfif Lvar_ConPlanCtas>
							                    n.Cdescripcion as CPdescripcion,
												<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as  CPdescripcionF,
											<cfelse>
												'#Lvar_Cdescripcion# Nivel #Lvar_PCDCnivP#' as CPdescripcion,
										          <cfif trim(Lprm_Cdescripcion) EQ "">
										              <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
												  <cfelse>
												      '#Lprm_Cdescripcion# Nivel #Lvar_PCDCnivP#'
												  </cfif>
												  		as CPdescripcionF, 
											</cfif>										
											'N' as CPmovimiento,
										</cfif>
										n.PCDcatid as PCDcatid,	
										#Lvar_CPpadre# as Lvar_CPpadre
									from #NIVELES# n #NOLOCK#
									where n.IDtemp  = #GvarIDtemp#
									  and n.BMfecha = #GvarBMfecha#
									  and n.PCDCniv = #Lvar_PCDCnivF#
								</cfquery>
                                <cfif NOT LEN(TRIM(rsNiveles.CPdescripcionF)) and LEN(TRIM(rsNiveles.CPdescripcion))>
                                   	<cfset rsNiveles.CPdescripcionF = rsNiveles.CPdescripcion>
                                 </cfif>
                                <cfif LEN(TRIM(rsNiveles.CPdescripcionF)) and NOT LEN(TRIM(rsNiveles.CPdescripcion))>
                                   	<cfset rsNiveles.CPdescripcion = rsNiveles.CPdescripcionF>
                                 </cfif>
								<cfquery name="rsSQL" datasource="#GvarDSN#">
									insert into CPresupuesto (
										CPVid,
										Ecodigo, Cmayor, CPformato, 
										CPdescripcion, CPdescripcionF, CPmovimiento, 
										PCDcatid, 
										CPpadre
										)
								VALUES(
								   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsNiveles.VigenciaID#"          voidNull>,
								   #GvarEcodigo#,
								   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="4"   value="#rsNiveles.Lprm_Cmayor#"         voidNull>,
								   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#rsNiveles.Lvar_CPformato#"      voidNull>,
								   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#rsNiveles.CPdescripcion#"  		voidNull>,
								   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#rsNiveles.CPdescripcionF#" 		voidNull>,
								   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#rsNiveles.CPmovimiento#"   		voidNull>,
								   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsNiveles.PCDcatid#"       		voidNull>,								   
								   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsNiveles.Lvar_CPpadre#"        voidNull>
							)
									<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarDSN#">
								</cfquery>
								<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" datasource="#GvarDSN#">
								<cfset Lvar_CPcuenta = rsSQL.identity>
                                <cfif LvarGenCtasIdEmpr eq 1>
                                    <cfquery name="rsSQL" datasource="#GvarDSN#">
                                        insert into CPresupuestoIdioma ( Ecodigo, CPcuenta, Iid, CPdescripcionI, BMUsucodigo )
                                        select #GvarEcodigo#, #Lvar_CPcuenta#, Iid, PCDdescripcionI,
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                                        from PCDCatalogoIdioma
                                        where 
                                        PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNiveles.PCDcatid#">
                                    </cfquery>
                                </cfif>
								<cfquery name="rsSQL" datasource="#GvarDSN#">
									update #NIVELES# #ROWLOCK#
									   set CcuentaP = #Lvar_CPcuenta#
									 where IDtemp  = #GvarIDtemp#
									   and BMfecha = #GvarBMfecha#
									   and PCDCniv = #Lvar_PCDCnivF#
								</cfquery>
	
								<cfif Lvar_PCDCnivP EQ Lvar_NivelesP>
									<cfquery name="rsSQL" datasource="#GvarDSN#">
										insert into CPCuentaPeriodo
											(Ecodigo, CPPid, CPcuenta, 
											 CPCPtipoControl, CPCPcalculoControl
											)
										values
											(
											#GvarEcodigo#,
											#Lprm_CPPid#,
											#Lvar_CPcuenta#,
											#Lvar_CVPtipoControl#,
											#Lvar_CVPcalculoControl#
											)
									</cfquery>
								</cfif>
							</cfif>
	
							<!--- Creación del cubo --->
							<cfif Lvar_PCDCnivF EQ Lvar_NivelesF>
								<cfquery name="rsSQL" datasource="#GvarDSN#">
									insert into PCDCatalogoCuentaP (CPcuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv, CPcuentaniv)
									select #Lvar_CPcuenta#, a.PCEcatid, a.PCDcatid, #Lvar_MascaraID#, a.PCDCnivP, c.CPcuenta
									  from #NIVELES# a #NOLOCK#, CPresupuesto c
									 where a.IDtemp  = #GvarIDtemp#
									   and a.BMfecha = #GvarBMfecha#
	
									   and c.CPcuenta = a.CcuentaP
									<!---
									   and c.Ecodigo = #GvarEcodigo#
									   and c.Cmayor = '#Lprm_Cmayor#'
									   and c.CPformato = a.CformatoP
									   and c.CPVid = #Lvar_VigenciaID#
									--->
									 order by a.PCDCnivP
								</cfquery>
							</cfif>
						<cfelse>
							<!--- Es Control de Version --->
							<cfif Lvar_PCDCnivP EQ Lvar_NivelesP AND 
									NOT fnExists("
									  select 1 
										from CVPresupuesto
										where Ecodigo 	= #GvarEcodigo#
										  and CVid 		= #Lprm_CVid#
										  and Cmayor    = '#Lprm_Cmayor#'
										  and CPformato	= '#Lvar_CPformato#'
							")>
								<!--- Ultimo Nivel de la Cuenta Presupuesto en Control de Versiones--->
								<cfquery name="rsSQL" datasource="#GvarDSN#">
									select max(CVPcuenta) as ultimo
									  from CVPresupuesto
									 where Ecodigo	= #GvarEcodigo#
									   and CVid		= #Lprm_CVid#
								</cfquery>
								<cfif rsSQL.ultimo EQ "">
									<cfset LvarCVPcuenta = 1>
								<cfelse>
									<cfset LvarCVPcuenta = rsSQL.ultimo + 1>
								</cfif>
								<cfquery name="rsSQL" datasource="#GvarDSN#">
									insert into CVPresupuesto (
										Ecodigo, 
										CVid,
										CVPcuenta,
										Cmayor, CPformato, 
										CPdescripcion,
										CVPtipoControl,
										CVPcalculoControl
										)
									select 
										#GvarEcodigo#, 
										#Lprm_CVid#,
										#LvarCVPcuenta#,
										'#Lprm_Cmayor#', '#Lvar_CPformato#', 
										<cfif Lvar_ConPlanCtas AND Lprm_Cdescripcion EQ "">#preserveSingleQuotes(LvarDescripcion_PCNidP)#<cfelse>'#Lprm_Cdescripcion#'</cfif>,
										#Lvar_CVPtipoControl#,
										#Lvar_CVPcalculoControl#
									from #NIVELES# n #NOLOCK#
									where n.IDtemp  = #GvarIDtemp#
									  and n.BMfecha = #GvarBMfecha#
									  and n.PCDCniv = #Lvar_PCDCnivF#
								</cfquery>
								<cfset Lvar_CPcuenta = LvarCVPcuenta>
							</cfif>
						</cfif>
					<cfelse>
						<!---*************************************************--->
						<!---**Crea la Cuenta Contable solo si no existe**----->
						<!---*************************************************--->
						<cfif Lvar_PCDCnivC GT 0 AND Lvar_CCcuenta EQ "">
							<cfquery name="insertCContables" datasource="#GvarDSN#">
								select 
									<cfif Lvar_PCDCnivC EQ Lvar_NivelesC>
										<cfif Lvar_ConPlanCtas>
											#preserveSingleQuotes(LvarDescripcion_PCNidC)# as Cdescripcion,
										<cfelse>
											'#Lvar_Cdescripcion# Ultimo Nivel' as Cdescripcion,
										</cfif>
										<cfif trim(Lprm_Cdescripcion) EQ "">
											<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as CdescripcionF
										<cfelse>
											'#Lprm_Cdescripcion#' as CdescripcionF
										</cfif>, 
										'S' Cmovimiento,
									<cfelse>
										<cfif Lvar_ConPlanCtas>
											n.Cdescripcion as Cdescripcion,
											<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as CdescripcionF,
										<cfelse>
											'#Lvar_Cdescripcion# Nivel #Lvar_PCDCnivC#' as Cdescripcion,
											<cfif trim(Lprm_Cdescripcion) EQ "">
												 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as CdescripcionF
											<cfelse>
												 '#Lprm_Cdescripcion# Nivel #Lvar_PCDCnivC#' as CdescripcionF
											</cfif>, 
										</cfif>
										'N' Cmovimiento,
									</cfif>
									n.PCDcatid PCDcatid	
								from #NIVELES# n #NOLOCK#
								where n.IDtemp  = #GvarIDtemp#
								  and n.BMfecha = #GvarBMfecha#
								  and n.PCDCniv = #Lvar_PCDCnivF#
							</cfquery>	
                            
							<cfquery name="rsSQL" datasource="#GvarDSN#">
								insert into CContables (
									Ecodigo, Cmayor, Cformato, Cdescripcion, 
									CdescripcionF, Cmovimiento, PCDcatid, Cpadre, 
									Cbalancen, Cbalancenormal)
								values
								(
									#GvarEcodigo#, '#Lprm_Cmayor#','#Lvar_CCformato#', 
                                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="80" voidnull value="#insertCContables.Cdescripcion#">, 
									<cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="80" voidnull value="#insertCContables.CdescripcionF#">, 
									'#insertCContables.Cmovimiento#', #insertCContables.PCDcatid#, #Lvar_CCpadre#, 
									'#Lvar_Cbalancen#', #Lvar_Cbalancenormal#
								)
								<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarDSN#">
							</cfquery>
								<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" datasource="#GvarDSN#">
							<cfset Lvar_CCcuenta = rsSQL.identity>
                            <cfif LvarGenCtasIdEmpr eq 1>    
                                <cfquery name="rsSQL" datasource="#GvarDSN#">
                                    insert into CContablesIdioma ( Ecodigo, Ccuenta, Iid, CdescripcionI, BMUsucodigo )
                                    select #GvarEcodigo#, #Lvar_CCcuenta#, Iid, PCDdescripcionI,
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
                                    from PCDCatalogoIdioma
                                    where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertCContables.PCDcatid#">
                                </cfquery>
                            </cfif>    
							<cfquery name="rsSQL" datasource="#GvarDSN#">
								update #NIVELES# #ROWLOCK#
								   set CcuentaC = #Lvar_CCcuenta#
								 where IDtemp  = #GvarIDtemp#
								   and BMfecha = #GvarBMfecha#
								   and PCDCniv = #Lvar_PCDCnivF#
							</cfquery>
						</cfif>
	
						<!---*************************************************--->
						<!---**Crea la Cuenta Financiera solo si no existe**----->
						<!---*************************************************--->
						<cfif Lvar_CFcuenta EQ "">
							<cfquery name="insertCFinanciera" datasource="#GvarDSN#">
								select 
									<cfif Lvar_PCDCnivF EQ Lvar_NivelesF>
										<cfif Lvar_ConPlanCtas>
											#preserveSingleQuotes(LvarDescripcion_PCNidF)# CFdescripcion, 
										<cfelse>
											'#Lvar_Cdescripcion# Ultimo Nivel' CFdescripcion,
										</cfif>
										<cfif trim(Lprm_Cdescripcion) EQ "">
											<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> CFdescripcionF,
										<cfelse>
											'#Lprm_Cdescripcion#' CFdescripcionF,
										</cfif> 
										'S' CFmovimiento,
									<cfelse>
										<cfif Lvar_ConPlanCtas>
											n.Cdescripcion CFdescripcion,
											<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> CFdescripcionF,
										<cfelse>
											'#Lvar_Cdescripcion# Nivel #Lvar_PCDCnivF#' CFdescripcion,
											<cfif trim(Lprm_Cdescripcion) EQ "">
												<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> CFdescripcionF,
											<cfelse>
												'#Lprm_Cdescripcion# Nivel #Lvar_PCDCnivF#' CFdescripcionF,
											</cfif> 
										</cfif>
										'N' CFmovimiento,
									</cfif>
									n.PCDcatid,	
									<cfif Lvar_PCDCnivF EQ Lvar_NivelesF>
										#Lvar_CCcuenta# Ccuenta,
										<cfif Lvar_CPcuenta NEQ "">
											#Lvar_CPcuenta# CPcuenta
										<cfelse>
											<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> CPcuenta
										</cfif>
									<cfelse>
										<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> Ccuenta, 
										<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> CPcuenta
									</cfif>
								from #NIVELES# n #NOLOCK#
								where n.IDtemp  = #GvarIDtemp#
								  and n.BMfecha = #GvarBMfecha#
								  and n.PCDCniv = #Lvar_PCDCnivF#
							</cfquery>
                            
							<cfquery name="rsSQL" datasource="#GvarDSN#">
								insert into CFinanciera (
									CPVid,
									Ecodigo, Cmayor, CFformato, 
									CFdescripcion,
									CFmovimiento
									,CFdescripcionF
									<cfif Lvar_CFpadre               GT 0>,CFpadre  </cfif>
									<cfif insertCFinanciera.PCDcatid GT 0>,PCDcatid </cfif>
									<cfif insertCFinanciera.Ccuenta  GT 0>,Ccuenta  </cfif>
									<cfif insertCFinanciera.CPcuenta GT 0>,CPcuenta </cfif>
								)
									values
									(
									#Lvar_VigenciaID#,
									#GvarEcodigo#, '#Lprm_Cmayor#', '#Lvar_CFformato#',
									<cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="80" voidnull value="#insertCFinanciera.CFdescripcion#">, 
									'#insertCFinanciera.CFmovimiento#',
									<cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="80" voidnull value="#insertCFinanciera.CFdescripcionF#">
									<cfif #Lvar_CFpadre#               GT 0>,#Lvar_CFpadre#				  </cfif>
									<cfif #insertCFinanciera.PCDcatid# GT 0>,#insertCFinanciera.PCDcatid# </cfif>
									<cfif #insertCFinanciera.Ccuenta#  GT 0>,#insertCFinanciera.Ccuenta#  </cfif>
									<cfif #insertCFinanciera.CPcuenta# GT 0>,#insertCFinanciera.CPcuenta# </cfif>
								)
								<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarDSN#">                                
							</cfquery>
								<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" datasource="#GvarDSN#">
							<cfset Lvar_CFcuenta = rsSQL.identity>
                            <cfif LvarGenCtasIdEmpr eq 1>
								<cfif #insertCFinanciera.PCDcatid# GT 0>    
                                    <cfquery name="rsSQL" datasource="#GvarDSN#">
                                        insert into CFinancieraIdioma ( Ecodigo, CFcuenta, Iid, CFdescripcionI, BMUsucodigo )
                                        select #GvarEcodigo#, #Lvar_CFcuenta#, Iid, PCDdescripcionI,
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
                                        from PCDCatalogoIdioma
                                        where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertCFinanciera.PCDcatid#">
                                    </cfquery>
                                </cfif>
                            </cfif>    
							<cfquery name="rsSQL" datasource="#GvarDSN#">
								update #NIVELES# #ROWLOCK#
								   set CcuentaF = #Lvar_CFcuenta#
								 where IDtemp  = #GvarIDtemp#
								   and BMfecha = #GvarBMfecha#
								   and PCDCniv = #Lvar_PCDCnivF#
							</cfquery>

							<!--- Creación del cubo --->
							<cfif Lvar_PCDCnivF EQ Lvar_NivelesF>
								<cfif Lprm_Cdescripcion NEQ "">
									<cfset Lvar_CFdescripcionF = Lprm_Cdescripcion>
								<cfelse>
									<cfset Lvar_CFdescripcionF = "#Lvar_Cdescripcion# Ultimo Nivel">
								</cfif>
	
								<!--- Guarda el último CFcuenta Generado para no volver a leer CFinanciera --->
								<cfset sbGuardar_PC_GeneraCFctaAnt(	GvarEcodigo, Lvar_CFformato, Arguments.Lprm_Fecha,
																	"NEW",
																	Lvar_CFcuenta, Lvar_CFdescripcionF,
																	Lvar_CCcuenta, Lvar_fmtGenerarC, 
																	Lvar_CPcuenta, Lvar_fmtGenerarP, 
																	Lvar_Ctipo, "S", 1)>
								
								<!--- Insertar todos los catalogos existentes en #NIVELES# para armar el cubo de referencia --->
								<cfquery name="rsSQL" datasource="#GvarDSN#">
									insert into PCDCatalogoCuentaF (CFcuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv, CFcuentaniv)
									select #Lvar_CFcuenta#, a.PCEcatid, a.PCDcatid, #Lvar_MascaraID#, a.PCDCniv, c.CFcuenta
									  from #NIVELES# a #NOLOCK#, CFinanciera c
									 where a.IDtemp  = #GvarIDtemp#
									   and a.BMfecha = #GvarBMfecha#
	
									   and c.CFcuenta = a.CcuentaF
									<!---
									   and c.Ecodigo = #GvarEcodigo#
									   and c.Cmayor = '#Lprm_Cmayor#'
									   and c.CFformato = a.CformatoF
									   and c.CPVid = #Lvar_VigenciaID#
									--->
									 order by a.PCDCniv
								</cfquery>
	
								<cftry>
									<cfquery name="rsSQL" datasource="#GvarDSN#">
										insert into PCDCatalogoCuenta (Ccuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv, Ccuentaniv)
										select #Lvar_CCcuenta#, a.PCEcatid, a.PCDcatid, #Lvar_MascaraID#, a.PCDCnivC, c.Ccuenta
										  from #NIVELES# a #NOLOCK#, CContables c
										 where a.IDtemp  = #GvarIDtemp#
										   and a.BMfecha = #GvarBMfecha#
		
										   and c.Ccuenta = a.CcuentaC
										<!---
										   and c.Ecodigo = #GvarEcodigo#
										   and c.Cmayor = '#Lprm_Cmayor#'
										   and c.Cformato = a.CformatoC
										--->
										 order by a.PCDCnivC
									</cfquery>
								<cfcatch>
								</cfcatch>
								</cftry>
							</cfif>
						</cfif>
			
					</cfif>
	
					<cfset Lvar_PCDCnivF = Lvar_PCDCnivF + 1>
				</cfloop>
				
				<!--- Obtiene los IDs de Cuentas de Presupuesto para Versiones --->
				<cfif Lprm_EsDePresupuesto AND Lprm_CVid NEQ "-1">
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						update #NIVELES# #ROWLOCK#
						set CcuentaP =   
							(
								select a.CPcuenta from CVPresupuesto a
								 where a.Ecodigo	= #GvarEcodigo#
								   and a.CVid		= #Lprm_CVid#
								   and a.Cmayor		= '#Lprm_Cmayor#'
								   and a.CPformato 	= #NIVELES#.CformatoP
							)
						where IDtemp  = #GvarIDtemp#
						  and BMfecha = #GvarBMfecha#
						  and
							(
								select count(1) 
								  from CVPresupuesto a
								 where a.Ecodigo	= #GvarEcodigo#
								   and a.CVid		= #Lprm_CVid#
								   and a.Cmayor		= '#Lprm_Cmayor#'
								   and a.CPformato 	= #NIVELES#.CformatoP
							) > 0
					</cfquery>
				</cfif>
	
				<!--- ======================================================== --->
				<!---                 ACTUALIZA ACEPTA MOVIMIENTOS             --->
				<!--- ======================================================== --->
				<cfif Lprm_EsDePresupuesto>
					<cfif Lprm_CVid EQ "-1">
						<!--- No es de Control de Version --->
						<cfquery name="rsSQL" datasource="#GvarDSN#">
							update CPresupuesto
							   set CPmovimiento = 'N'
							 where exists 
								(
									select 1 
									  from #NIVELES# a #NOLOCK# 
									 where a.IDtemp  = #GvarIDtemp#
									   and a.BMfecha = #GvarBMfecha#
									   and a.CcuentaP = CPresupuesto.CPcuenta
									   and a.PCDCniv < 
											(
												select max(PCDCnivP) 
												  from #NIVELES# n #NOLOCK#
												 where IDtemp  = #GvarIDtemp#
												   and BMfecha = #GvarBMfecha#
											)
								)
							   and coalesce(CPmovimiento,'*') <> 'N'
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						update CContables 
						   set Cmovimiento = 'N'
						 where exists 
							(
								select 1 
								  from #NIVELES# a #NOLOCK# 
								 where a.IDtemp  = #GvarIDtemp#
								   and a.BMfecha = #GvarBMfecha#
								   and a.CcuentaC = CContables.Ccuenta
								   and a.PCDCnivC < 
										(
											select max(PCDCnivC) 
											  from #NIVELES# n #NOLOCK#
											 where IDtemp  = #GvarIDtemp#
											   and BMfecha = #GvarBMfecha#
										)
							)
						   and coalesce(Cmovimiento,'*') <> 'N'
					</cfquery>
					<cfquery name="rsSQL" datasource="#GvarDSN#">
						update CFinanciera
						   set CFmovimiento = 'N'
						 where exists 
							(
								select 1 
								  from #NIVELES# a #NOLOCK# 
								 where a.IDtemp  = #GvarIDtemp#
								   and a.BMfecha = #GvarBMfecha#
								   and a.CcuentaF = CFinanciera.CFcuenta
								   and a.PCDCniv < 
										(
											select max(PCDCniv) 
											  from #NIVELES# n #NOLOCK#
											 where IDtemp  = #GvarIDtemp#
											   and BMfecha = #GvarBMfecha#
										)
							)
						   and coalesce(CFmovimiento,'*') <> 'N'
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<!--- FIN GENERACION DE CUENTAS --->
		
		<cfif Lprm_debug>
			<cfset Lprm_Cmayor = Arguments.Lprm_Cmayor>
			<cfset sbDebug("GENERADO",Lprm_EsDePresupuesto, Lprm_CVid, Lprm_Cmayor)>
		</cfif>

		<cfif Lvar_CuentaYaExiste>
			<cfreturn "OLD">
		<cfelse>
			<cfreturn "NEW">
		</cfif>
	</cffunction>
	
	<cffunction name="fnExists" access="private" output="no" returntype="boolean">
		<cfargument name="LvarSQL">

		<cfquery name="rsExists" datasource="#GvarDSN#" >
			select count(1) as cantidad from dual where exists(#preservesinglequotes(LvarSQL)#)
		</cfquery>
		<cfreturn (rsExists.cantidad EQ 1)>
	</cffunction>

	<cffunction name="fnGeneraCFformato" output="no" returntype="string">
		<cfargument name="Lprm_Ecodigo" 			type="numeric" required="yes">
		<cfargument name="Lprm_CFformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" default="-1">

		<cfargument name="Lprm_Cdescripcion"		type="string"  default="">
		<cfargument name="Lprm_Cbalancen"			type="string"  default="°">

		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		<cfargument name="Lprm_debug" 				type="boolean" default="false">
		<cfargument name="Lprm_DSN" 				type="string"  default="">
		<cfargument name="Lprm_NoVerificarObras"	type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarSinOfi"	type="boolean" default="false">
		<!--- OJO:	Lprm_NoVerificarObras debe utilizarse únicamente en el Sistema de Obras, 
					para que se brinca el Control de Obras en Agregar cuentas y Liquidacion --->

		<cfset var LvarMSG = fnGeneraCtas(
							Lprm_CFformato,"°","°",Lprm_Ocodigo,Lprm_Fecha,true,true,
							false,false,-1,-1,-1,-1,Lprm_Cdescripcion,Lprm_Cbalancen,
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_Ecodigo,
							false, false, 
							Lprm_NoVerificarSinOfi, 
							Lprm_NoVerificarObras
							)>
							
		<cfif LvarMSG EQ "NEW" OR LvarMSG EQ "OLD">
			<cfreturn LvarMSG>
		<cfelse>
			<cfreturn "VERIFICACION DE CUENTA '#Lprm_CFformato#':#chr(10)#  #LvarMSG#">
		</cfif>
	</cffunction>

	<cffunction name="fnVerificaCFformato" output="no" returntype="string">
		<cfargument name="Lprm_Ecodigo" 			type="numeric" required="yes">
		<cfargument name="Lprm_CFformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" required="no" default="-1">

		<cfargument name="Lprm_VerificarExistencia"	type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarPres"		type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarSinOfi"	type="boolean" default="false">

		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		<cfargument name="Lprm_debug" 				type="boolean" default="false">
		<cfargument name="Lprm_DSN" 				type="string"  default="">
		<cfargument name="Lprm_NoVerificarObras"	type="boolean" default="false">
		<!--- OJO:	Lprm_NoVerificarObras debe utilizarse únicamente en el Sistema de Obras, 
					para que se brinca el Control de Obras en Agregar cuentas y Liquidacion --->

		<cfset var LvarMSG = fnGeneraCtas(
							Lprm_CFformato,"°","°",Lprm_Ocodigo,Lprm_Fecha,NOT Lprm_VerificarExistencia,NOT Lprm_VerificarExistencia,
							false,false,-1,-1,-1,-1,"","°",
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_Ecodigo,
							true, 
							Lprm_NoVerificarPres, Lprm_NoVerificarSinOfi, 
							Lprm_NoVerificarObras
							)>
							
		<cfif LvarMSG EQ "NEW" OR LvarMSG EQ "OLD">
			<cfreturn LvarMSG>
		<cfelse>
			<cfreturn "VERIFICACION DE CUENTA '#Lvar_fmtVerif#':#chr(10)#  #LvarMSG#">
		</cfif>
	</cffunction>

	<cffunction name="fnGeneraCPformato" output="no" returntype="string">
		<cfargument name="Lprm_Ecodigo" 			type="numeric" required="yes">
		<cfargument name="Lprm_CPformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" required="yes">

		<cfargument name="Lprm_CPPid"				type="numeric" required="yes">
		<cfargument name="Lprm_CVPtipoControl"		type="numeric" required="yes">
		<cfargument name="Lprm_CVPcalculoControl"	type="numeric" required="yes">

		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		<cfargument name="Lprm_debug" 				type="boolean" default="false">
		<cfargument name="Lprm_DSN" 				required="false">

		<cfset var LvarMSG = fnGeneraCtas(
							Lprm_CPformato,"°","°",Lprm_Ocodigo,Lprm_Fecha,false,false,
							true,true,Lprm_CPPid,-1,Lprm_CVPtipoControl,Lprm_CVPcalculoControl,"","°",
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_Ecodigo,
							false, false, false, false
							)>
							
		<cfif LvarMSG EQ "NEW" OR LvarMSG EQ "OLD">
			<cfreturn LvarMSG>
		<cfelse>
			<cfreturn "VERIFICACION DE CUENTA '#Lvar_fmtVerif#':#chr(10)#  #LvarMSG#">
		</cfif>
	</cffunction>
	
	<cffunction name="fnVerificaCPformato" output="no" returntype="string">
		<cfargument name="Lprm_Ecodigo" 			type="numeric" required="yes">
		<cfargument name="Lprm_CPformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" required="no" default="-1">

		<cfargument name="Lprm_CPPid"				type="numeric" required="yes">
		<cfargument name="Lprm_VerificarExistencia"	type="boolean" default="true">
		<cfargument name="Lprm_NoVerificarSinOfi"	type="boolean" default="false">

		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		<cfargument name="Lprm_debug" 				type="boolean" default="false">
		<cfargument name="Lprm_DSN" 				required="false">

		<cfset var LvarMSG = fnGeneraCtas(
							Lprm_CPformato,"°","°",Lprm_Ocodigo,Lprm_Fecha,false,false,
							NOT Lprm_VerificarExistencia,true,Lprm_CPPid,-1,Lprm_CVPtipoControl,Lprm_CVPcalculoControl,"","°",
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_Ecodigo,
							true, false, 
							Lprm_NoVerificarSinOfi, false
							)>
							
		<cfif LvarMSG EQ "NEW" OR LvarMSG EQ "OLD">
			<cfreturn LvarMSG>
		<cfelse>
			<cfreturn "VERIFICACION DE CUENTA '#Lvar_fmtVerif#':#chr(10)#  #LvarMSG#">
		</cfif>
	</cffunction>
	

	<cffunction name="fnGeneraCPVcuenta" output="no" returntype="string">
		<cfargument name="Lprm_Ecodigo" 			type="numeric" required="yes">
		<cfargument name="Lprm_CPformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" required="yes">

		<cfargument name="Lprm_CVid"				type="numeric" required="yes">
		<cfargument name="Lprm_CVPtipoControl"		type="numeric" default="-1">
		<cfargument name="Lprm_CVPcalculoControl"	type="numeric" default="-1">

		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		<cfargument name="Lprm_debug" 				type="boolean" default="false">
		<cfargument name="Lprm_DSN" 				type="string"  default="">

		<cfset var LvarMSG = fnGeneraCtas(
							Lprm_CPformato,"°","°",Lprm_Ocodigo,Lprm_Fecha,false,false,
							true,true,-1,Lprm_CVid,Lprm_CVPtipoControl,Lprm_CVPcalculoControl,"","°",
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_Ecodigo,
							false, false, false, false
							)>
							
		<cfif LvarMSG EQ "NEW" OR LvarMSG EQ "OLD">
			<cfreturn LvarMSG>
		<cfelse>
			<cfreturn "VERIFICACION DE CUENTA '#Lvar_fmtVerif#':#chr(10)#  #LvarMSG#">
		</cfif>
	</cffunction>
	
	<cffunction name="fnObtieneCFcuenta" access="public" output="no" returntype="struct">
		<cfargument name="Lprm_Ecodigo" 			type="numeric"  required="yes">
		<cfargument name="Lprm_CFformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_DSN" 				type="string"  default="">
		
		<cfset GvarEcodigo = arguments.Lprm_Ecodigo>
		<cfif arguments.Lprm_DSN NEQ "">
			<cfset GvarDSN = arguments.Lprm_DSN>
		<cfelse>
			<cfset GvarDSN = session.dsn>
		</cfif>

		<cfif arguments.Lprm_Fecha EQ LvarFechaNULL>
			<cfset arguments.Lprm_Fecha = fnFechaDefault()>
		</cfif>

		<cfset Arguments.Lprm_CFformato = trim(Arguments.Lprm_CFformato)>

		<cfif isdefined("request.PC_GeneraCFctaAnt.CFformato")
			AND request.PC_GeneraCFctaAnt.Ecodigo	EQ Arguments.Lprm_Ecodigo
			AND request.PC_GeneraCFctaAnt.CFformato	EQ Arguments.Lprm_CFformato
			AND request.PC_GeneraCFctaAnt.CFfecha	EQ Arguments.Lprm_Fecha
			AND trim(request.PC_GeneraCFctaAnt.CFcuenta) NEQ "">

			<cfreturn request.PC_GeneraCFctaAnt>
		</cfif>

		<cfset sbIniciar_PC_GeneraCFctaAnt(	Arguments.Lprm_Ecodigo, Arguments.Lprm_CFformato, Arguments.Lprm_Fecha )>
		
		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select 	cf.CFcuenta, cf.Ccuenta, cf.CPcuenta, coalesce(cf.CFdescripcionF,cf.CFdescripcion) as CFdescripcionF, 
					m.Ctipo, cf.CFmovimiento, coalesce(c.Mcodigo, 1) as Auxiliar,
					c.Cformato, p.CPformato
			  from CFinanciera cf
			  	inner join CtasMayor m
					on m.Cmayor = cf.Cmayor
				inner join CPVigencia vg
				   on vg.Ecodigo	= cf.Ecodigo
				  and vg.Cmayor 	= cf.Cmayor
				  and vg.CPVid 		= cf.CPVid
				  and #dateformat(Arguments.Lprm_Fecha,"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
				 left join CContables c
				   on c.Ccuenta = cf.Ccuenta
				 left join CPresupuesto p
				   on p.CPcuenta = cf.CPcuenta
			 where cf.CFformato 	= '#Arguments.Lprm_CFformato#'
			   and cf.Ecodigo		= #Arguments.Lprm_Ecodigo#
		</cfquery>

		<cfif rsSQL.recordCount EQ 0>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select CFcuenta
				  from CFinanciera cf
				 where cf.CFformato 	= '#Arguments.Lprm_CFformato#'
				   and cf.Ecodigo		= #Arguments.Lprm_Ecodigo#
			</cfquery>
		
			<cfif rsSQL.CFcuenta NEQ "">
				<cfset sbLimpiar_PC_GeneraCFctaAnt(	"No existe la Cuenta Financiera")>
			<cfelse>
				<cfset sbLimpiar_PC_GeneraCFctaAnt(	"La Cuenta Financiera existe pero no est&aacute; vigente", rsSQL.CFcuenta)>
			</cfif>
		<cfelse>
			<cfset sbGuardar_PC_GeneraCFctaAnt(	Arguments.Lprm_Ecodigo, Arguments.Lprm_CFformato, Arguments.Lprm_Fecha, 
												"OLD",
												rsSQL.CFcuenta, rsSQL.CFdescripcionF,
												rsSQL.Ccuenta,  rsSQL.Cformato, 
												rsSQL.CPcuenta, rsSQL.CPformato, 
												rsSQL.Ctipo, rsSQL.CFmovimiento, rsSQL.Auxiliar)>
		</cfif>
		
		<cfreturn request.PC_GeneraCFctaAnt>
	</cffunction>
	
	<cffunction name="fnObtieneCPcuenta" access="public" output="no" returntype="struct">
		<cfargument name="Lprm_Ecodigo" 			type="numeric"  required="yes">
		<cfargument name="Lprm_CPformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_DSN" 				type="string"  default="#session.DSN#">

		<cfset GvarEcodigo = arguments.Lprm_Ecodigo>
		<cfif arguments.Lprm_DSN NEQ "">
			<cfset GvarDSN = arguments.Lprm_DSN>
		<cfelse>
			<cfset GvarDSN = session.dsn>
		</cfif>

		<cfif arguments.Lprm_Fecha EQ LvarFechaNULL>
			<cfset arguments.Lprm_Fecha = fnFechaDefault()>
		</cfif>

		<cfset Arguments.Lprm_CPformato = trim(Arguments.Lprm_CPformato)>

		<cfset LvarResultado = structNew()>
		
		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select 	cf.CPcuenta, coalesce(cf.CPdescripcionF,cf.COdescripcion) as CPdescripcionF
			  from CPresupuesto cp
				inner join CPVigencia vg
				   on vg.Ecodigo	= cp.Ecodigo
				  and vg.Cmayor 	= cp.Cmayor
				  and vg.CPVid 		= cp.CPVid
				  and #dateformat(Arguments.Lprm_Fecha,"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
			 where cp.CPformato 	= '#Arguments.Lprm_CPformato#'
			   and cp.Ecodigo		= #Arguments.Lprm_Ecodigo#
		</cfquery>

		<cfif rsSQL.recordCount EQ 0>
			<cfquery name="rsSQL" datasource="#GvarDSN#">
				select count(1) as cantidad
				  from CPresupuesto cp
				 where cp.CPformato 	= '#Arguments.Lprm_CPformato#'
				   and cp.Ecodigo		= #Arguments.Lprm_Ecodigo#
			</cfquery>
		
			<cfset LvarResultado.CPcuenta		= "">
			<cfset LvarResultado.CPdescripcionF	= "">
			<cfset LvarResultado.NoVigente		= (rsSQL.cantidad GT 0)>
		<cfelse>
			<cfset LvarResultado.CPcuenta		= rsSQL.CPcuenta>
			<cfset LvarResultado.CPdescripcionF	= rsSQL.CPdescripcionF>
			<cfset LvarResultado.NoVigente		= false>
		</cfif>
		
		<cfreturn LvarResultado>
	</cffunction>
	
	<cffunction name="sbIniciar_PC_GeneraCFctaAnt" access="private" output="no" returntype="void">
		<cfargument name="Ecodigo"			type="numeric" 	required="yes">
		<cfargument name="CFformato"		type="string" 	required="yes">
		<cfargument name="CFfecha"			type="date" 	required="yes">

		<cfset request.PC_GeneraCFctaAnt.Ecodigo		= Arguments.Ecodigo>
		<cfset request.PC_GeneraCFctaAnt.CFformato		= trim(Arguments.CFformato)>
		<cfset request.PC_GeneraCFctaAnt.CFfecha		= Arguments.CFfecha>
		<cfset request.PC_GeneraCFctaAnt.Inicial		= true>
		<cfset request.PC_GeneraCFctaAnt.CFcuentaNoVigente	= "">
		<cfset request.PC_GeneraCFctaAnt.NoVigente			= false>
		<cfset request.PC_GeneraCFctaAnt.CFcuenta		= "">
		<cfset request.PC_GeneraCFctaAnt.CFdescripcion	= "">
		<cfset request.PC_GeneraCFctaAnt.MSG			= "">
		<cfset request.PC_GeneraCFctaAnt.Ccuenta 		= "">
		<cfset request.PC_GeneraCFctaAnt.Cformato		= "">
		<cfset request.PC_GeneraCFctaAnt.CPcuenta		= "">
		<cfset request.PC_GeneraCFctaAnt.CPformato		= "">
		<cfset request.PC_GeneraCFctaAnt.Ctipo			= "">
		<cfset request.PC_GeneraCFctaAnt.CFmovimiento	= "">
		<cfset request.PC_GeneraCFctaAnt.Auxiliar		= "">
	</cffunction>
	
	<cffunction name="sbLimpiar_PC_GeneraCFctaAnt" access="private" output="no" returntype="void">
		<cfargument name="MSG"					type="string"	required="true">
		<cfargument name="CFcuentaNoVigente"	type="string"	default="">

		<cfparam name="request.PC_GeneraCFctaAnt.Inicial" default="true">
		<cfif request.PC_GeneraCFctaAnt.Inicial>
			<cfset request.PC_GeneraCFctaAnt.Inicial			= false>
			<cfset request.PC_GeneraCFctaAnt.CFcuentaNoVigente	= Arguments.CFcuentaNoVigente>
			<cfset request.PC_GeneraCFctaAnt.NoVigente			= Arguments.CFcuentaNoVigente NEQ "">
		</cfif>
		<cfset request.PC_GeneraCFctaAnt.MSG			= Arguments.MSG>
		<cfset request.PC_GeneraCFctaAnt.CFcuenta		= "">
		<cfset request.PC_GeneraCFctaAnt.CFdescripcion	= "">
		<cfset request.PC_GeneraCFctaAnt.Ccuenta 		= "">
		<cfset request.PC_GeneraCFctaAnt.Cformato		= "">
		<cfset request.PC_GeneraCFctaAnt.CPcuenta		= "">
		<cfset request.PC_GeneraCFctaAnt.CPformato		= "">
		<cfset request.PC_GeneraCFctaAnt.Ctipo			= "">
		<cfset request.PC_GeneraCFctaAnt.CFmovimiento	= "">
		<cfset request.PC_GeneraCFctaAnt.Auxiliar		= "">
	</cffunction>
	
	<cffunction name="sbGuardar_PC_GeneraCFctaAnt" access="private" output="no" returntype="void">
		<cfargument name="Ecodigo"			type="numeric" 	required="yes">
		<cfargument name="CFformato"		type="string" 	required="yes">
		<cfargument name="CFfecha"			type="date" 	required="yes">

		<cfargument name="MSG"				type="string"	required="true">
		<cfargument name="CFcuenta"			required="yes">
		<cfargument name="CFdescripcion"	required="yes">
		<cfargument name="Ccuenta"			required="yes">
		<cfargument name="Cformato"			required="yes">
		<cfargument name="CPcuenta"			required="yes">
		<cfargument name="CPformato"		required="yes">
		<cfargument name="Ctipo"			required="yes">
		<cfargument name="CFmovimiento"		required="yes">
		<cfargument name="Auxiliar"			required="yes">

		<cfif Arguments.CFcuenta EQ "">
			<cfthrow message="Se está guardando una cuenta que no existe">
		</cfif>

		<cfset request.PC_GeneraCFctaAnt 				= structNew()>
		<cfset request.PC_GeneraCFctaAnt.Ecodigo		= Arguments.Ecodigo>
		<cfset request.PC_GeneraCFctaAnt.CFformato		= trim(Arguments.CFformato)>
		<cfset request.PC_GeneraCFctaAnt.CFfecha		= Arguments.CFfecha>
		<cfset request.PC_GeneraCFctaAnt.MSG			= Arguments.MSG>
		<cfset request.PC_GeneraCFctaAnt.NoVigente		= false>
		<cfset request.PC_GeneraCFctaAnt.CFcuenta		= Arguments.CFcuenta>
		<cfset request.PC_GeneraCFctaAnt.CFdescripcion	= trim(Arguments.CFdescripcion)>
		<cfset request.PC_GeneraCFctaAnt.Ccuenta 		= Arguments.Ccuenta>
		<cfset request.PC_GeneraCFctaAnt.Cformato		= trim(Arguments.Cformato)>
		<cfset request.PC_GeneraCFctaAnt.CPcuenta		= Arguments.CPcuenta>
		<cfset request.PC_GeneraCFctaAnt.CPformato		= trim(Arguments.CPformato)>
		<cfset request.PC_GeneraCFctaAnt.Ctipo			= Arguments.Ctipo>
		<cfset request.PC_GeneraCFctaAnt.CFmovimiento	= Arguments.CFmovimiento>
		<cfset request.PC_GeneraCFctaAnt.Auxiliar		= Arguments.Auxiliar>
	</cffunction>
	
	<cffunction name="sbActualizaCuboPresupuesto" output="true">
		<cfset LvarError = false>
		<cftransaction>
			<cfquery name="rsCPresupuesto" datasource="#session.dsn#">
				select p.CPcuenta, vg.PCEMid, me.PCEMformatoP, p.CPformato
				  from CPresupuesto p 
						inner join CPVigencia vg
								inner join PCEMascaras me
								   on me.PCEMid=vg.PCEMid
						   on vg.Ecodigo = p.Ecodigo 
						  and vg.CPVid 	 = p.CPVid 
						  and vg.Cmayor	 = p.Cmayor
				 where p.Ecodigo = #session.Ecodigo#
				   and p.CPmovimiento='S' 
				   and
						(
							select count(1) 
							  from PCDCatalogoCuentaP c 
							 where c.CPcuenta=p.CPcuenta
						) = 0
			</cfquery>
			<cfdump var="#rsCPresupuesto#">
			<cfloop query="rsCPresupuesto">
				<cfset LvarNivel = len(rsCPresupuesto.PCEMformatoP) - len(replace(rsCPresupuesto.PCEMformatoP,"-","","ALL"))>
				<cfset LvarCPcuenta = rsCPresupuesto.CPcuenta>
				<cfloop condition="LvarCPcuenta NEQ ''">
					<cfquery name="rsNivel" datasource="#session.dsn#">
						select p.CPcuenta, cd.PCEcatid, p.PCDcatid, p.CPpadre
						  from CPresupuesto p 
								left join PCDCatalogo cd
										inner join PCECatalogo ce
										   on ce.PCEcatid = cd.PCEcatid
								   on cd.PCDcatid = p.PCDcatid
						 where p.CPcuenta = #LvarCPcuenta#
					</cfquery>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into PCDCatalogoCuentaP (CPcuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv, CPcuentaniv)
						values (
							#rsCPresupuesto.CPcuenta#,
							<cfif rsNivel.PCEcatid EQ "">null<cfelse>#rsNivel.PCEcatid#</cfif>,
							<cfif rsNivel.PCDcatid EQ "">null<cfelse>#rsNivel.PCDcatid#</cfif>,
							<cfif rsCPresupuesto.PCEMid EQ "">null<cfelse>#rsCPresupuesto.PCEMid#</cfif>,
							#LvarNivel#,
							<cfif rsNivel.CPcuenta EQ "">null<cfelse>#rsNivel.CPcuenta#</cfif>
							)
					</cfquery>
					<cfset LvarCPcuenta = rsNivel.CPpadre>
					<cfset LvarNivel = LvarNivel - 1>
				</cfloop>
				<cfoutput>CPcuenta: #rsCPresupuesto.CPcuenta# #rsCPresupuesto.CPformato#</cfoutput>
				<cfif LvarNivel NEQ -1>
					<cfset LvarError = true>
				********** MENOS NIVELES ***********
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select * from PCDCatalogoCuentaP
					 where CPcuenta = #rsCPresupuesto.CPcuenta#
				</cfquery>
				<cfdump var="#rsSQL#">
			</cfloop>
			<cfif LvarError>
				********** ROLLBACK ***********
				<cftransaction action="rollback"/>
			</cfif>
		</cftransaction>
	</cffunction>
	
	<cffunction name="sbActualizaCuboContable" output="true">
		<cfset LvarError = false>
		<cftransaction>
			<cfquery name="rsCContables" datasource="#session.dsn#">
				select p.Ccuenta, vg.PCEMid, coalesce(me.PCEMformatoC, p.Cformato) as TamanoFormato, p.Cformato
				  from CContables p 
				  		inner join CFinanciera f
							on f.Ccuenta = p.Ccuenta
						inner join CPVigencia vg
								left join PCEMascaras me
								   on me.PCEMid=vg.PCEMid
						   on vg.Ecodigo=f.Ecodigo and vg.CPVid = f.CPVid and vg.Cmayor=f.Cmayor
				 where p.Ecodigo = #session.Ecodigo#
				   and p.Cmovimiento='S' 
				   and
				   		(
							select count(1) 
							  from PCDCatalogoCuenta 
							 where Ccuenta=p.Ccuenta
						) = 0
			</cfquery>
			<cfdump var="#rsCContables#">
			<cfloop query="rsCContables">
				<cfset LvarNivel = len(TamanoFormato) - len(replace(TamanoFormato,"-","","ALL"))>
				<cfset LvarCcuenta = rsCContables.Ccuenta>
				<cfloop condition="LvarCcuenta NEQ ''">
					<cfquery name="rsNivel" datasource="#session.dsn#">
						select p.Ccuenta, cd.PCEcatid, p.PCDcatid, p.Cpadre
						  from CContables p 
								left join PCDCatalogo cd
										inner join PCECatalogo ce
										   on ce.PCEcatid = cd.PCEcatid
								   on cd.PCDcatid = p.PCDcatid
						 where p.Ccuenta = #LvarCcuenta#
					</cfquery>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into PCDCatalogoCuenta (Ccuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv, Ccuentaniv)
						values (
							#rsCContables.Ccuenta#,
							<cfif rsNivel.PCEcatid EQ "">null<cfelse>#rsNivel.PCEcatid#</cfif>,
							<cfif rsNivel.PCDcatid EQ "">null<cfelse>#rsNivel.PCDcatid#</cfif>,
							<cfif rsCContables.PCEMid EQ "">null<cfelse>#rsCContables.PCEMid#</cfif>,
							#LvarNivel#,
							<cfif rsNivel.Ccuenta EQ "">null<cfelse>#rsNivel.Ccuenta#</cfif>
							)
					</cfquery>
					<cfset LvarCcuenta = rsNivel.Cpadre>
					<cfset LvarNivel = LvarNivel - 1>
				</cfloop>
				<cfoutput>Ccuenta: #rsCContables.Ccuenta# #rsCContables.Cformato#</cfoutput>
				<cfif LvarNivel NEQ -1>
					<cfset LvarError = true>
				********** MENOS NIVELES ***********
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select * from PCDCatalogoCuenta
					 where Ccuenta = #rsCContables.Ccuenta#
				</cfquery>
				<cfdump var="#rsSQL#">
			</cfloop>
			<cfif LvarError>
				********** ROLLBACK ***********
				<cftransaction action="rollback"/>
			</cfif>
		</cftransaction>
	</cffunction>

	<cffunction name="fnFechaDefault" access="private" output="no" returntype="date">
		<!--- Obtiene el Periodo-Mes de Auxiliares --->
		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #GvarEcodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfset LvarAuxAno = rsSQL.Pvalor>
		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #GvarEcodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAuxMes = rsSQL.Pvalor>

		<cfset LvarAuxMesFechaIni = createDate(LvarAuxAno,LvarAuxMes,1)>
		<cfset LvarAuxMesFechaFin = createDate(LvarAuxAno,LvarAuxMes,DaysInMonth(LvarAuxMesFechaIni))>

		<cfset LvarAuxAnoMes = LvarAuxAno*100 + LvarAuxMes>
		<cfset LvarHoyAnoMes = DateFormat(now(),"YYYYMM")>

		<cfif LvarHoyAnoMes LT LvarAuxAnoMes>
			<!--- Si se digita antes del mes de Aux: Fecha inicial --->
			<cfreturn LvarAuxMesFechaIni>
		<cfelseif LvarHoyAnoMes GT LvarAuxAnoMes>
			<!--- Si se digita despues del mes de Aux: Fecha final --->
			<cfreturn LvarAuxMesFechaFin>
		<cfelse>
			<!--- Si se digita durante el mes de Aux: Fecha actual --->
			<cfreturn createDate(LvarAuxAno,LvarAuxMes, Day(now()) )>
		</cfif>
	</cffunction>
	
	<cffunction name="fnJSStringFormat" access="public" output="no" returntype="string">
		<cfargument name="hilera" type="string" required="yes">
		
		<cfset LvarHilera = JSStringFormat(replace(Arguments.hilera,"\n","#chr(10)#","ALL"))>
	
		<cfset LvarHilera = replace(LvarHilera,"&aacute;","á","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&eacute;","é","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&iacute;","í","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&oacute;","ó","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&uacute;","ú","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&nacute;","ñ","ALL")>
		<cfreturn LvarHilera>
	</cffunction>

	<cffunction name="fnMascaraCFformato" access="public" output="no" returntype="string">
		<cfargument name="Lprm_Ecodigo" 			type="numeric"  required="yes">
		<cfargument name="Lprm_CFformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_Comodines" 			type="string"  default="">
		<cfargument name="Lprm_DSN" 				type="string"  default="">
		
		<cfset GvarEcodigo = arguments.Lprm_Ecodigo>
		<cfif arguments.Lprm_DSN NEQ "">
			<cfset GvarDSN = arguments.Lprm_DSN>
		<cfelse>
			<cfset GvarDSN = session.dsn>
		</cfif>

		<cfif arguments.Lprm_Fecha EQ LvarFechaNULL>
			<cfset arguments.Lprm_Fecha = fnFechaDefault()>
		</cfif>

		<cfset Arguments.Lprm_CFformato = trim(Arguments.Lprm_CFformato)>
		<cfset Lvar_Cmayor	= mid(Arguments.Lprm_CFformato,1,4)>

		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select PCEMid, Cbalancen, Cmayor, Cdescripcion, Ctipo
			  from CtasMayor
			 where Ecodigo = #GvarEcodigo#
			   and Cmayor = '#Lvar_Cmayor#'
		</cfquery>
		<cfif rsSQL.recordcount EQ 0>
			<cfreturn "VERIFICACION DE FORMATO DE LA CUENTA '#Arguments.Lprm_CFformato#':#chr(10)#  No existe la Cuenta Mayor '#Lvar_Cmayor#'">
		</cfif>
		<cfquery name="rsSQL" datasource="#GvarDSN#">
			select 	v.CPVid, 
					m.PCEMid, m.PCEMplanCtas,
					v.CPVformatoF
			  from CPVigencia v
				left outer join PCEMascaras m
					 ON m.PCEMid = v.PCEMid
			 where v.Ecodigo = #GvarEcodigo#
			   and v.Cmayor = '#Lvar_Cmayor#'
			   and #dateformat(Lprm_Fecha,"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
		</cfquery>
		<cfif rsSql.recordcount eq 0>
			<cfreturn "VERIFICACION DE FORMATO DE LA CUENTA '#Arguments.Lprm_CFformato#':#chr(10)#  No hay m&aacute;scara vigente para la Cuenta Mayor '#Lprm_Cmayor#'">
		</cfif>

		<cfreturn fnFormato(Arguments.Lprm_CFformato, rsSQL.CPVformatoF, Arguments.Lprm_Comodines)>
	</cffunction>

	<cffunction name="fnFormato" access="private" output="no" returntype="string">
		<cfargument name="Lprm_CFformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Mascara" 			type="string"  required="yes">
		<cfargument name="Lprm_Comodines" 			type="string"  default="">

		<cfset LvarCaracteres = "0123456789" & Arguments.Lprm_Comodines>
		<cfset LvarResultado = "">
		<cfset LvarCaracterInvalido = "">
		<cfloop index="i" from="1" to="#len(Lprm_CFformato)#">
			<cfif mid(Lprm_CFformato,i,1) EQ "-">
				<cfset LvarResultado = LvarResultado & "-">
			<cfelse>
				<cfset LvarResultado = LvarResultado & "X">
				<cfif LvarCaracterInvalido EQ "" AND NOT find(mid(Lprm_CFformato,i,1),LvarCaracteres)>
					<cfset LvarCaracterInvalido = mid(Lprm_CFformato,i,1)>
				</cfif>
			</cfif>
		</cfloop>
		<cfif LvarResultado NEQ ucase(trim(Lprm_Mascara))>
			<cfreturn "VERIFICACION DE FORMATO DE LA CUENTA '#Arguments.Lprm_CFformato#':#chr(10)#  El formato de la Cuenta no corresponde con la M&aacute;scara asociada a la Cuenta Mayor: '#ucase(trim(Lprm_Mascara))#'">
		<cfelseif LvarCaracterInvalido NEQ "">
			<cfreturn "VERIFICACION DE FORMATO DE LA CUENTA '#Arguments.Lprm_CFformato#':#chr(10)#  Se utilizó un caracter no autorizado: '#LvarCaracterInvalido#'">
		</cfif>

		<cfreturn "OK">
	</cffunction>

	<cffunction name="fnGeneraCuentaPlanCompras" output="no" returntype="struct">
		<cfargument name="Lprm_DSN" 				type="string"  default="">
		<cfargument name="Lprm_Ecodigo" 			type="numeric" required="yes">
		<cfargument name="Lprm_CFformato" 			type="string"  required="yes">
		<cfargument name="Lprm_Fecha" 				type="date"    default="#LvarFechaNULL#">
		<cfargument name="Lprm_Ocodigo" 			type="numeric" required="no" default="-1">

		<cfargument name="Lprm_SoloVerificar"		type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarSinOfi"	type="boolean" default="false">
		<cfargument name="Lprm_NoVerificarObras"	type="boolean" default="false">
		<cfargument name="Lprm_Verificar_CFid"		type="numeric" default="-1">

		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		<cfargument name="Lprm_debug" 				type="boolean" default="false">

		<cfset var LvarResult = structNew()>
		<cfset LvarResult.MSG = fnGeneraCtas(
							Lprm_CFformato,"°","°",Lprm_Ocodigo,Lprm_Fecha,
							true,false,					<!--- Lprm_CrearConPlan,Lprm_CrearSinPlan --->
							false,false,-1,-1,-1,-1,	<!--- Presupuesto --->
							"","°",						<!--- Lprm_Cdescripcion,Lprm_Cbalancen --->
							Lprm_TransaccionActiva,Lprm_debug,Lprm_DSN,Lprm_Ecodigo,
							Lprm_SoloVerificar, 
							true, 						<!--- Lprm_NoVerificarPres --->
							Lprm_NoVerificarSinOfi, 
							Lprm_NoVerificarObras,
							Lprm_Verificar_CFid,
							true						<!--- Lprm_EsDePlanCompras --->
							)
		>
		<cfif LvarResult.MSG EQ "NEW" or LvarResult.MSG EQ "OLD">
			<cfset LvarResult.MSG = "OK">
			<cfset LvarResult.PCGcuenta = Lvar_PCGcuenta>
		</cfif>
		<cfreturn LvarResult>
	</cffunction>

	<cffunction name="sbCreaCPresupuestoDeVersion" access="public" output="false" returntype="void">
		<cfargument name="Lprm_CVid" 			type="numeric"  required="yes">
		<cfargument name="Lprm_Verificar" 		type="boolean"  default="no">

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo 	= #session.Ecodigo#
			   and Pcodigo	= 541
		</cfquery>
		
		<cfif Arguments.Lprm_Verificar>
			<cfif rsSQL.Pvalor NEQ "S">
				<cfabort>
			</cfif>
		<cfelse>
			<cfif rsSQL.Pvalor NEQ "S">
				<cfthrow message="No se ha definido el Parámetro 541: Crear Cuentas de Presupuesto en la Versión de Formulación">
			</cfif>
		</cfif>

		<cfset LvarCVid = Arguments.Lprm_CVid>
		<cfquery name="rsCPeriodo" datasource="#session.dsn#">
			select v.CVaprobada, p.CPPid, p.CPPfechaDesde
			  from CVersion v
				INNER JOIN CPresupuestoPeriodo p
				ON p.CPPid = v.CPPid
			 where v.Ecodigo 	= #session.Ecodigo#
			   and v.CVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCVid#">
		</cfquery>
		<cfset LvarCPPid	= rsCPeriodo.CPPid>
		<cfset LvarFechaIni	= rsCPeriodo.CPPfechaDesde>
		
		<cfif rsCPeriodo.CPPid EQ "">
			<cfthrow message="Versión de Formulación no existe">
		<cfelseif rsCPeriodo.CVaprobada>
			<cfthrow message="Versión de Formulación ya fue aprobada">
		</cfif>

		<cfquery name="rsCVFormulacion" datasource="#session.dsn#">
			select 	c.CVPcuenta,
					c.Cmayor, c.CPformato, c.CPdescripcion, c.CVPtipoControl, c.CVPcalculoControl, 
					vg.CPVid
			  from CVPresupuesto c
					left outer join CPVigencia vg
						on vg.Ecodigo = c.Ecodigo
					   and vg.Cmayor  = c.Cmayor
					   and #dateformat(LvarFechaIni,"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
			 where c.Ecodigo 	= #session.Ecodigo#
			   and c.CVid		= #LvarCVid#
			   and c.CPcuenta 	is NULL
			   and (
			   		select count(1)
					  from CVFormulacionTotales f
					 where f.Ecodigo   = c.Ecodigo
					   and f.CVid 	   = c.CVid
					   and f.CVPcuenta = c.CVPcuenta
					) > 0
		</cfquery>
		
		<cfloop query="rsCVFormulacion">
			<cfset LvarCFformato = trim(rsCVFormulacion.CPformato)>
			<cfinvoke 
				method="fnGeneraCuentaFinanciera"
				returnvariable="LvarError">
					<cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
					<cfinvokeargument name="Lprm_fecha" 			value="#LvarFechaIni#"/>
					<cfinvokeargument name="Lprm_CrearPresupuesto" 	value="yes"/>
					<cfinvokeargument name="Lprm_CPPid" 			value="#LvarCPPid#"/>
					<cfinvokeargument name="Lprm_CVPtipoControl" 	value="#rsCVFormulacion.CVPtipoControl#"/>
					<cfinvokeargument name="Lprm_CVPcalculoControl" value="#rsCVFormulacion.CVPcalculoControl#"/>
					<cfinvokeargument name="Lprm_CPdescripcion" 	value="#rsCVFormulacion.CPdescripcion#"/>
					<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
			</cfinvoke>
		
			<cfif (LvarError EQ "NEW" OR LvarError EQ "OLD")>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					update CVPresupuesto
					   set CPcuenta = 
							(
								select CPcuenta
								  from CPresupuesto
								 where Ecodigo	 = #session.Ecodigo# 
								   AND Cmayor	 = '#rsCVFormulacion.Cmayor#'
								   AND CPVid	 = #rsCVFormulacion.CPVid# 
								   AND CPformato = '#LvarCFformato#'
							)
					  where CVPcuenta = #rsCVFormulacion.CVPcuenta#
				</cfquery>
			<cfelse>
				<cfthrow message="Cuenta de Presupuesto '#LvarCFformato#': #LvarError#">
			</cfif>
		</cfloop>
	</cffunction>
	
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
						Lprm_CFformato			= "#LvarCFformato#"
						Lprm_Fecha				= "#now()#"
						Lprm_Ocodigo			= "-1"
						Lprm_Cdescripcion		= "#Arguments.CFdescripcion#"
						Lprm_TransaccionActiva	= "#Arguments.TransaccionActiva#"
						Lprm_DSN				= "#GvarDSN#"
						Lprm_NoVerificarObras	= "no"
						Lprm_NoVerificarSinOfi	= "yes"
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
	<!--- Esta funcion Verifica si hay una transaccion abierta--->
    <CFFUNCTION name="InTransaction" access="public" output="No" RETURNTYPE="boolean">
		<CFSET var objTrans ="">
        <CFSET var blnActiveTransaction=false>
        <CFSET var objCurrentTrans="">
        <!--- Call to CF implementation of TransactionTag to expose Java functions --->
        <cfobject type="Java" class="coldfusion.tagext.sql.TransactionTag" name="objTrans" action="create">
        <!--- objCurrentTrans will become undefined if the Java function call getCurrent() returns Null,
        otherwise this returns a pointer to current transaction instance --->
        <cfset objCurrentTrans = objTrans.getCurrent()>
        <cfif IsDefined("objCurrentTrans")>
        	<CFSET blnActiveTransaction=true>
        </cfif>
        <!--- return result --->
        <CFRETURN blnActiveTransaction>
    </CFFUNCTION>
</cfcomponent>