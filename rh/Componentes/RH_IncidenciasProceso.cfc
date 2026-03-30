<cfcomponent name="RH_Incidencias" output="true">
	<!--- 
		***********************
		Variables de Traducción 
		***********************
	--->

	<!--- Valor --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Relacion_Empleado_Concepto_Incidente_y_Fecha_ya_existe."
		Default="La relacion entre Empleado, Concepto de Incidencia y Fecha ya existe"
		returnvariable="vError"/>
	<!--- Empleado --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Empleado"
		Default="Empleado"
		XmlFile="/rh/generales.xml"
		returnvariable="vEmpleado"/>
	<!--- Concepto_Incidente --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Concepto_Incidente"
		Default="Concepto Incidente"
		XmlFile="/rh/generales.xml"
		returnvariable="vConcepto"/>
	<!--- Fecha --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha"
		Default="Fecha"
		XmlFile="/rh/generales.xml"
		returnvariable="vFecha"/>

	<!--- ******************* --->
	<!--- Alta De Incidencias --->
	<!--- ******************* --->
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="DEid" 				required="true" 	type="numeric">
		<cfargument name="CIid" 				required="true" 	type="numeric">
		<cfargument name="iFecha" 				required="true" 	type="date">
		<cfargument name="iFechaRebajo" 		required="false" 	type="string" 	default="">
		<cfargument name="iValor" 				required="true" 	type="numeric">
		<cfargument name="CFid" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="RHJid" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="Iespecial" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Icpespecial" 			required="false" 	type="numeric" 	default="0">		
		<cfargument name="RCNid" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="Mcodigo" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="Imonto" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="Debug" 				required="false" 	type="boolean" 	default="false">
		<cfargument name="TransaccionAbierta" 	required="false" 	type="boolean" 	default="true">
        <cfargument name="Ifechacontrol" 		required="false" 	type="string" 	default="">
        <cfargument name="EIlote" 				required="false" 	type="numeric">
		<cfargument name="Iobservacion" 		required="false" 	type="string" 	default="">
		<cfargument name="Iingresadopor" 		required="false" 	type="string" 	default="">
		<cfargument name="Iestadoaprobacion" 	required="false" 	type="string" 	default="">
		<cfargument name="usuCF" 				required="false" 	type="numeric" 	default="#session.usucodigo#">
		<cfargument name="Ijustificacion" 		required="false" 	type="string" 	default="">
		
		<cfif Arguments.TransaccionAbierta>
			<cfinvoke method="pAlta" argumentcollection="#arguments#" returnvariable="Lvar_Iid">
		<cfelse>
			<cftransaction>
				<cfinvoke method="pAlta" argumentcollection="#arguments#" returnvariable="Lvar_Iid">
			</cftransaction>
		</cfif>
		<cfreturn  Lvar_Iid>
	</cffunction>



	
	<cffunction access="public" name="getEmpleadoResponsable" returntype="numeric">
		<cfargument name="CFid" 			required="true" 	type="numeric">
		<cfargument name="DEid" 			required="true" 	type="numeric">
		

		<cfquery name="rs_ECFID" datasource="#session.DSN#">
			select cf.CFuresponsable ,ur.llave as UsuDEid
				from CFuncional cf
					inner join Usuario u
						on u.Usucodigo =cf.CFuresponsable
					inner  join UsuarioReferencia ur
						on STabla ='DatosEmpleado'
						and ur.Usucodigo = u.Usucodigo
				where cf.CFid=(select top 1 rp.CFid
									from DLaboralesEmpleado de
										inner join RHPlazas rp
										 on rp.RHPid = de.RHPid
									where de.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
									order by  de.DLlinea desc
								)
				and cf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rs_ECFID.recordcount eq 0 >
			<cfquery name="rs_ECFID" datasource="#session.DSN#">
				select cf.CFuresponsable ,ur.llave as UsuDEid
					from CFuncional cf
						inner join Usuario u
							on u.Usucodigo =cf.CFuresponsable
						inner  join UsuarioReferencia ur
							on STabla ='DatosEmpleado'
							and ur.Usucodigo = u.Usucodigo
					where cf.CFid=( select CFidresp
										from EmpleadoCFuncional
										where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
									)
					and cf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfquery>
		</cfif>
		<cfif rs_ECFID.recordcount eq 0> 
			<cfquery name="rs_CF" datasource="#session.DSN#">
				select  cf.CFcodigo, cf.CFdescripcion
					from CFuncional cf
					where cf.CFid=( select CFid
									from EmpleadoCFuncional
									where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
								) 
			</cfquery>
			<cf_throw message="Falta Parametrizar el Responsable del Centro Funcional #rs_CF.CFcodigo# - #rs_CF.CFdescripcion#" errorCode="10004">
		</cfif>
		<cfreturn  rs_ECFID.UsuDEid>
	</cffunction>

	<cffunction access="private" name="pAlta" returntype="numeric">
		<cfargument name="DEid" 			required="true" 	type="numeric">
		<cfargument name="CIid" 			required="true" 	type="numeric">
		<cfargument name="iFecha" 			required="true" 	type="date" >
		<cfargument name="iFechaRebajo" 	required="false" 	type="string" 	default="" >
		<cfargument name="iValor" 			required="true" 	type="numeric">
		<cfargument name="CFid" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="RHJid" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Iespecial" 		required="false" 	type="numeric" 	default="0">
		<cfargument name="Icpespecial" 		required="false" 	type="numeric" 	default="0">
		<cfargument name="RCNid" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Mcodigo" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Imonto" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">
        <cfargument name="EIlote" 			required="false" 	type="numeric">
		<cfargument name="Iobservacion" 	required="false" 	type="string" 	default="">
		<cfargument name="Iingresadopor" 		required="false" 	type="string" 	default="">
		<cfargument name="Iestadoaprobacion" 	required="false" 	type="string" 	default="">
		<cfargument name="usuCF" 				required="false" 	type="numeric" 	default="#session.usucodigo#">
		<cfargument name="Ijustificacion" 		required="false" 	type="string" 	default="">

		<!---***************************************************************************************************--->
		<!---********Logica de ingreso de incidencias segun sea necesaria la aprobacion de las mismos***********--->
		<!---***************************************************************************************************--->
		<cfset arguments.Iingresadopor = getRol()>
			
		<!---Averigua si el parametro 'Requiere aprobación incidencias' esta encendido --->
		<cfset reqAprobacion = getParam(Pcodigo = "1010")>
		
		<!---Averigua si el parametro 'Requiere aprobacion de Incidencias tipo Calculo' esta encendido --->
		<cfset reqAprobacionCalculo = getParam(Pcodigo = "1060")>
		
		<!---Averigua si el parametro 'Requiere aprobacion de Incidencias por el Jefe del Centro Funcional' esta encendido --->
		<cfset reqAprobacionJefe = getParam(Pcodigo = "2540")>
		
		<!--- Averigua el DEid del usuario--->
		<cfset DEidUser = getEmpleadoUsuario()>
		
		<!---Si el rol es de Administrador, averigua si es Admin de RH--->
		<cfset esAdminRH = 0>
		<cfif arguments.Iingresadopor EQ 2>	
			<cfset esAdminRH = esAdministradorRH()>
		</cfif>
		
		<cfset aprobarIncidencias = false >
		<cfif reqAprobacion eq 1 >
			<cfset aprobarIncidencias = true >
		</cfif>
		
		<cfset aprobarIncidenciasCalc = false >
		<cfif reqAprobacionCalculo eq 1 >
			<cfset aprobarIncidenciasCalc = true >
		</cfif>	
		
		<cfif arguments.Iingresadopor EQ 2>						<!---Ingresado desde nomina, cuando se ingresa desde nomina no importa si requiere aporbacion de incidencias u aprobacion por parte del jefe debido a que la incidencia se aprueba de forma automatica--->
			
			<cfif esAdminRH or reqAprobacion EQ 0>	
				<cfset I_ingresadopor = 2>							<!---Ingresa Administrador RH--->
				<cfset I_estado = 1>								<!---Aprobacion Directa del Administrador RH--->
				<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no--->
			<cfelse>
				<cfset I_ingresadopor = 2>							<!---Ingresa Administrador--->
				<cfset I_estado = 0>								<!---Pasa por proceso de aprobacion de un administrador--->
				<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no--->
			</cfif>
		<cfelse>												<!---Ingresado desde autogestion--->
			<cfif reqAprobacion EQ 1>
				<cfif reqAprobacionJefe EQ 1>
					
					<cfif arguments.Iingresadopor EQ 1> 			<!---Jefe--->
						
																	<!---Averigua si esta ingresando una incidencia para si mismo o para un subalterno--->
																	<!---ASUNTO: averiguar si el jefe se puede aprobar sus propias incidencias (si esta dentro del centro funcional
																	del que es autorizador o jefe) si es jefe o autorizador pero no posee su plaza dentro del centro funcional del que es 
																	jefe u autorizador no puede auto aprobarse sus propias incidencias --->
						<cfif isdefined("DEidUser") and len(trim(DEidUser.DEid)) and DEidUser.DEid EQ arguments.DEid>
								<cfset I_ingresadopor = 1>			<!---Ingresa Jefe--->
								<cfset I_estado = 0>				<!---Requiere aprobacion del Administrador--->
																		
								<!---<cfset EsSuJefe = EsSuJefe(DEid = "#arguments.DEid#")>
								<cfif EsSuJefe EQ 1>
									<cfset I_estadoAprobacion = 2>	<!---Aprobacion Directa del Jefe por ser su propio Jefe--->	
								<cfelse>
									<cfset I_estadoAprobacion = 0>	<!--- El jefe requiere aprobacion de su jefe--->
								</cfif>--->
								<cfset I_estadoAprobacion = 0>			<!---Aprobacion Directa por ser Jefe--->	
						<cfelse>
							<cfset I_ingresadopor = 1>				<!---Ingresa Jefe--->
							<cfset I_estado = 0>					<!---Requiere aprobacion del Administrador--->
							<cfset I_estadoAprobacion = 2>			<!---Aprobacion Directa por ser Jefe--->	
						</cfif>
						
					<cfelseif arguments.Iingresadopor EQ 0>	
						<cfset I_ingresadopor = 0>				<!---Ingresa Ususario--->
						<cfset I_estado = 0>					<!---Requiere aprobacion del Administrador--->
						<cfset I_estadoAprobacion = 0>			<!---Requiere aprobacion del Jefe--->	
					</cfif>
				
				<cfelse>
					<cfset I_ingresadopor = arguments.Iingresadopor>	<!---Ingresa Jefe o Usuario--->
					<cfset I_estado = 0>								<!---Requiere aprobacion del Administrador--->
					<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no, por que no requiere aprobacion del jefe--->	
				</cfif>
			<cfelse>
				<cfset I_ingresadopor = arguments.Iingresadopor>	<!---Ingresa Jefe o Usuario--->
				<cfset I_estado = 1>								<!---Aprobacion Directa por que no requiere aprobacion del administrador--->
				<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no, por que no requiere aprobacion del jefe al no requerir aprobacion del administrador--->
			</cfif>
		</cfif>
		<!---***************************************************************************************************--->
		<!---************************************************FIN************************************************--->
		<!---***************************************************************************************************--->
		
		<cfset tipo_incidencia = 'N'>
		<cfquery name="rs_tipoIncidencia" datasource="#session.DSN#">
			select CItipo
			from CIncidentes
			where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CIid#">
		</cfquery>
		<cfif len(trim(rs_tipoIncidencia.CItipo)) and rs_tipoIncidencia.CItipo eq 3>
			<cfset tipo_incidencia = 'C'>
		</cfif>
		
		<cfquery name="rsVerify" datasource="#Session.DSN#">
			select Iid
			from Incidencias 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#"> 
			  and Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Arguments.iFecha),Month(Arguments.iFecha),Day(Arguments.iFecha))#">
		</cfquery>
		<cfif not isdefined('Arguments.EIlote')>
        	<cfset Arguments.EIlote = "">
        </cfif>
		
		<cfif rsVerify.recordcount gt 0>
			<cfif arguments.Iingresadopor EQ 2 and esAdminRH>
				<!--- ACUMULAR INCIDENCIAS SI EL INGRESO LO HACE UN ADMINISTRADOR DE NOMINA O EL AYUDANTE DE ADMINISTRADOR--->
				<cfquery name="rsUpdate" datasource="#Session.DSN#" result="res">
					update Incidencias 
					  set Ivalor = Ivalor + <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">,
								   Imonto = Imonto + <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.Imonto#">  <!--- jc --->
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#"> 
					  and Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Arguments.iFecha),Month(Arguments.iFecha),Day(Arguments.iFecha))#">
				</cfquery>
				<cfset rsInsert.identity = rsVerify.Iid>
			<cfelse>
				<cfthrow message="Alerta: no es posible agregar una incidencia del mismo tipo para la misma fecha, posiblemente se haya ingresado ya una inciencia que esta en proceso de aprobación.">
				<cfabort>
			</cfif>
		<cfelse>
			<!--- AGREGAR LA NUEVA INCIDENCIA --->
			<cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
				insert into Incidencias(	DEid,
								 			CIid, 			
											Ifecha,
											IfechaRebajo,
											Ivalor, 
											Ifechasis, 		
											CFid, 			
											RHJid, 		
											Usucodigo, 
											Ulocalizacion, 	
											BMUsucodigo, 	
											Iespecial, 	
											RCNid, 
											Mcodigo, 		
											Imonto, 		
											Icpespecial,
											Iestado,
											NAP,
                                            Ifechacontrol,
                                            EIlote,
											Iobservacion,
											Iingresadopor,
											Iestadoaprobacion,
											usuCF,
											Ijustificacion)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Arguments.iFecha),Month(Arguments.iFecha),Day(Arguments.iFecha))#">,
						<cfif isdefined("Arguments.iFechaRebajo") and len(trim( Arguments.iFechaRebajo ))><cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(Arguments.iFechaRebajo)#" ><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#" null="#Arguments.CFid LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#" null="#Arguments.RHJid LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iespecial#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#" null="#Arguments.RCNid LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#" null="#Arguments.Mcodigo LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Imonto#" scale="2" null="#Arguments.Imonto LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Icpespecial#">,
						<!--- Lo que sigue se entiende asi: 
								1. 	Si la incidencia es de un tipo diferente a calculo, leer parametro 1010 y ver si requiere aprobacion. 
									Si requiere se inserta un estado 0 (pendiente de aprobar )sino el estado es 1 (aprobado).
								2. Si la incidencia es de tipo calculo, leer parametro 1060 y ver si requiere aprobacion. 
									Si requiere se inserta un estado 0 (pendiente de aprobar )sino el estado es 1 (aprobado).
							  Se hace asi porque se quiere independizar aprobacion	de incidencias normales y de calculo, son 
							  cosas diferentes. --->
						<cfif tipo_incidencia eq 'N'>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#I_estado#">
						<cfelse>
							<cfif aprobarIncidenciasCalc >0<cfelse>1</cfif>
						</cfif>,	
						<!--- el NAP se usa para mantener desarrollo inicial del tec NO TIENE INTEGRACION con presupuesto por eso esta fijo --->
						<cfif tipo_incidencia eq 'N'><cfif aprobarIncidencias >null<cfelse>100</cfif><cfelse><cfif aprobarIncidenciasCalc >null<cfelse>100</cfif></cfif> 
                        ,<cfif isdefined("Arguments.ifechacontrol") and len(trim( Arguments.ifechacontrol ))><cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Arguments.ifechacontrol),Month(Arguments.ifechacontrol),Day(Arguments.ifechacontrol))#"><cfelse>null</cfif>
                        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.EIlote#" voidnull>
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Iobservacion)#">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_ingresadopor)#">
						
						<cfif esAdminRH or not reqAprobacion>
							,null
						<cfelse>
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_estadoAprobacion)#">
						</cfif>
						
						<!---<cfif reqAprobacion and arguments.Iingresadopor NEQ 2>	<!---solo se agregan estos campos si vienen de un proceso de aprobacion, y si no es un administrador--->
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_estadoAprobacion)#">
						<cfelse>
							,null
						</cfif>--->
						
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Arguments.usuCF)#">	
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Ijustificacion)#">	
						)
				<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
		</cfif>
		
		<cfset Lvar_Iid = rsInsert.Identity>
		
		<!---<cfif arguments.Iingresadopor EQ 2 or reqAprobacion EQ 0>--->		<!---Aprobacion administrativa automatica o si el check en parametros RH esta apagado--->
		<cfif esAdminRH or reqAprobacion EQ 0>
			<cfset API= AutoApruebaIncidencia(Iid="#Lvar_Iid#")>
		</cfif>
		
		<cfif Arguments.Debug><cfdump var="#res#"></cfif>
		
		<cfinvoke method="updateCMControlSemanal" Iid="#Lvar_Iid#" Debug="#Arguments.Debug#">
		
		<cfif Arguments.Debug>
			<cfquery name="rsDebug" datasource="#Session.DSN#">
				select 
					DEid, 			CIid, 			Ifecha, 		Ivalor, 
					Ifechasis, 		CFid, 			RHJid, 			Usucodigo, 	
					Ulocalizacion, 	BMUsucodigo, 	Iespecial, 		RCNid, 
					Mcodigo,		Imonto, 		Icpespecial
				from Incidencias
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
			</cfquery>
			<cfdump var="#Arguments#">
			<cfdump var="#rsDebug#">
			<cfabort>
		</cfif>
		
		<cfreturn Lvar_Iid>
	</cffunction>
	
	<cffunction access="public" name="updateCMControlSemanal">
		<cfargument name="Iid" required="true" type="numeric">
		<cfargument name="Debug" required="false" type="boolean" default="false">
		<cfset var Lvar_PagaSeptimo 	= false> <!--- Indicador del Pago del Séptimo --->
		<cfset var Lvar_PagaQ250 		= false> <!--- Indicador del Pago del Q250 --->
		<cfset var Lvar_DateWOH 		= ""> <!--- Fecha sin horas\minutos\segundos de la Incidencia --->
		<cfset var Lvar_DateFDOTW		= ""> <!--- Fecha sin horas\minutos\segundos del primer díá de la semana --->
		<cfset var Lvar_DatePartWOH 	= 0> <!--- Indicador del día de la semana de fecha de la incidencia --->
		<cfset var Lvar_DatePartFDP 	= 0> <!--- Indicador del día de la semana definido como primero de la semana en Parámetros de RH --->
		<cfset var Lvar_DatePartDiff 	= 0> <!--- Factor para conseguir la fecha del primer día de la semana a la que corresponde la incidencia --->
		<cfset var Lvar_Iidhn			= 0> <!--- Id de la Incidencia de horas normales --->
		<cfset var Lvar_Iidhea			= 0> <!--- Id de la Incidencia de horas extra a --->
		<cfset var Lvar_Iidheb			= 0> <!--- Id de la Incidencia de horas extra b --->
		<cfset var Lvar_Iidfer			= 0> <!--- Id de la Incidencia de feriados --->
		<cfset var Lvar_RHCMDhn			= 0> <!--- Cantidad de horas normales --->
		<cfset var Lvar_RHCMDhea		= 0> <!--- Cantidad de horas extra a --->
		<cfset var Lvar_RHCMDheb		= 0> <!--- cantidad de horas extra b --->
		<cfif Arguments.Debug>
			<cfdump var="#Arguments#" label="Arguments">
		</cfif>
		<!--- Gravar en la tabla de Control Semanal (Solo cuando paga Séptimo o Q250 o Ambos) --->
		<!---***INICIO Procesamiento Séptimo y Q250***--->
		<!--- Datos Séptimo y Q250 --->
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo" 
				returnvariable="Lvar_PagaSeptimo">
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250" 
				returnvariable="Lvar_PagaQ250">
		<cfinvoke component="RHParametros" method="init" returnvariable="parametros">
		<cfif Arguments.Debug>
			<cfdump var="Lvar_PagaSeptimo=#Lvar_PagaSeptimo#" label="Lvar_PagaSeptimo">
			<cfdump var="Lvar_PagaQ250=#Lvar_PagaQ250#" label="Lvar_PagaQ250">
		</cfif>
		<cfquery name="rsHoras" datasource="#session.dsn#">
			SELECT 	a.Iid, 
					a.CIid, 			a.Ivalor, 
					a.Ifecha, 			a.DEid,
					d.RHJornadahora, 	d.RHJincHJornada, 
					d.RHJincExtraA, 	d.RHJincExtraB, 
					d.RHJincFeriados, 	d.RHJid
			FROM 	Incidencias a
						LEFT OUTER JOIN 	RHPlanificador b
						ON					b.DEid = a.DEid
						AND					<cf_dbfunction name="to_datechar" args="b.RHPJfinicio"> = 
											<cf_dbfunction name="to_datechar" args="a.Ifecha">
						INNER JOIN 			LineaTiempo c
						ON					c.DEid = a.DEid
						AND					a.Ifecha between c.LTdesde and c.LThasta
						INNER JOIN			RHJornadas d
						ON 					d.RHJid = coalesce(a.RHJid, b.RHJid, c.RHJid)
						AND 				d.RHJmarcar = 1
						AND (
											(	d.RHJornadahora 	= 1 AND
												d.RHJincHJornada 	= a.CIid	) OR
											(	d.RHJincExtraA 		= a.CIid 	) OR
											(	d.RHJincExtraB 		= a.CIid 	) OR
											(	d.RHJincFeriados	= a.CIid 	) 
						)
			WHERE 	a.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Iid#">
		</cfquery>
		<cfif Arguments.Debug><cfdump var="#rsHoras#" label="rsHoras"></cfif>
		<cfif rsHoras.CIid eq rsHoras.RHJincHJornada>
			<cfset Lvar_Iidhn			= rsHoras.Iid>
			<cfset Lvar_RHCMDhn			= rsHoras.Ivalor>
		<cfelseif rsHoras.CIid eq rsHoras.RHJincExtraA>
			<cfset Lvar_Iidhea			= rsHoras.Iid>
			<cfset Lvar_RHCMDhea		= rsHoras.Ivalor>
		<cfelseif rsHoras.CIid eq rsHoras.RHJincExtraB>
			<cfset Lvar_Iidheb			= rsHoras.Iid>
			<cfset Lvar_RHCMDheb		= rsHoras.Ivalor>
		<cfelseif rsHoras.CIid eq rsHoras.RHJincFeriados>
			<cfset Lvar_Iidfer			= rsHoras.Iid>
		</cfif>
		<cfif Arguments.Debug>
			<cfdump var="Lvar_Iidhn=#Lvar_Iidhn#">
			<cfdump var="Lvar_RHCMDhn=#Lvar_RHCMDhn#">
			<cfdump var="Lvar_Iidhea=#Lvar_Iidhea#">
			<cfdump var="Lvar_RHCMDhea=#Lvar_RHCMDhea#">
			<cfdump var="Lvar_Iidheb=#Lvar_Iidheb#">
			<cfdump var="Lvar_RHCMDheb=#Lvar_RHCMDheb#">
			<cfdump var="Lvar_Iidfer=#Lvar_Iidfer#">
		</cfif>
		<cfif (rsHoras.recordcount GT 0) AND (Lvar_PagaSeptimo or Lvar_PagaQ250)>
			<cfif Arguments.Debug><cfdump var="#rsHoras#" label="rsHoras"></cfif>
			<cfset Lvar_DateWOH = CreateDate(Year(rsHoras.Ifecha),Month(rsHoras.Ifecha),Day(rsHoras.Ifecha))>
			<cfif Arguments.Debug><cfdump var="Lvar_DateWOH=#Lvar_DateWOH#" label="Lvar_DateWOH"></cfif>
			<cfset Lvar_DatePartWOH = DatePart("w",Lvar_DateWOH)-1>
			<cfif Arguments.Debug><cfdump var="Lvar_DatePartWOH=#Lvar_DatePartWOH#" label="Lvar_DatePartWOH"></cfif>
			<cfset Lvar_DatePartFDP = parametros.get(session.dsn,session.ecodigo,780)>
			<cfif Arguments.Debug><cfdump var="Lvar_DatePartFDP=#Lvar_DatePartFDP#" label="Lvar_DatePartFDP"></cfif>
			<cfif len(trim(Lvar_DatePartFDP)) EQ 0>
				<cfset Lvar_DatePartFDP = 1>
			</cfif>
			<cfif Arguments.Debug><cfdump var="Lvar_DatePartFDP=#Lvar_DatePartFDP#" label="Lvar_DatePartFDP"></cfif>
			<cfset Lvar_DatePartDiff = Lvar_DatePartFDP - Lvar_DatePartWOH>
			<cfif Lvar_DatePartDiff GT 0>
				<cfset Lvar_DatePartDiff = Lvar_DatePartDiff - 7>
			</cfif>
			<cfset Lvar_DateFDOTW = DateAdd('d',Lvar_DatePartDiff,Lvar_DateWOH)>
			<cfif Arguments.Debug><cfdump var="Lvar_DateFDOTW=#Lvar_DateFDOTW#" label="Lvar_DateFDOTW"></cfif>
			<cfquery name="rsvInsert" datasource="#session.dsn#">
				select RHCMCSid
				from RHCMControlSemanal 
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHoras.DEid#">
				and RHCMCSfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateFDOTW#">
				and RHCMCSpagoseptimo = 0
			</cfquery>
			<cfif Arguments.Debug><cfdump var="#rsvInsert#" label="rsvInsert"></cfif>
			<cfif rsvInsert.recordcount GT 0>
				<cfset rsInsert.identity = rsvInsert.RHCMCSid>
			<cfelse>
				<cfquery name="rsInsert" datasource="#session.dsn#">
					insert into RHCMControlSemanal 
					(DEid, RHCMCSpagoseptimo, RHCMCSmontoseptimo, RHCMCSfecha, 
					BMfecha, BMUsucodigo)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHoras.DEid#">,
						0, 0.00, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateFDOTW#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)
					<cf_dbidentity1 verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 name="rsInsert" verificar_transaccion="false">
			</cfif>
			<cfif Arguments.Debug><cf_dumptable name="RHCMControlSemanal" label="RHCMControlSemanal" filtro="RHCMCSid=#rsInsert.identity#" abort="false"></cfif>
			<cfif ListFind("0,1,2,3,4,5,6","#Lvar_DatePartWOH#")>
				<cfquery name="rsRHCMDia" datasource="#session.dsn#">
					SELECT RHCMDid
					FROM RHCMDia 
					where RHCMCSid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">
					  and RHCMDdia=<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_DatePartWOH#">
					  and RHCMDfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateWOH#">
				</cfquery>
				<cfif Arguments.Debug><cfdump var="#rsRHCMDia#" label="rsRHCMDia"></cfif>
				<cfif rsRHCMDia.recordcount GT 0>
					<cfquery datasource="#session.dsn#">
						UPDATE RHCMDia 
						SET 
							<cfif rsHoras.CIid eq rsHoras.RHJincHJornada>
								RHCMDhniid= case 
											when (RHCMDhniid is null) or (RHCMDhniid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhn#">
											else RHCMDhniid 
											end
								,RHCMDhn=<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDhn#">

							<cfelseif rsHoras.CIid eq rsHoras.RHJincExtraA>
								RHCMDheaiid=case 
											when (RHCMDheaiid is null) or (RHCMDheaiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhea#">
											else RHCMDheaiid 
											end
								,RHCMDhea=<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDhea#">
							<cfelseif rsHoras.CIid eq rsHoras.RHJincExtraB>
								RHCMDhebiid=case 
											when (RHCMDhebiid is null) or (RHCMDhebiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidheb#">
											else RHCMDhebiid 
											end
	                            ,RHCMDheb=<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDheb#">
							<cfelseif rsHoras.CIid eq rsHoras.RHJincFeriados>
								RHCMDferiid=case 
											when (RHCMDferiid is null) or (RHCMDferiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidfer#">
											else RHCMDferiid 
											end
							</cfif>
						where RHCMDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHCMDia.RHCMDid#">
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.dsn#">
						insert into RHCMDia 
							(RHCMCSid, RHCMDdia, RHCMDfecha, 
							RHJid, RHCMDhn, RHCMDhea, 
							RHCMDheb, RHCMDhniid, RHCMDheaiid, 
							RHCMDhebiid, RHCMDferiid, 
							BMfecha, BMUsucodigo)
						values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_DatePartWOH#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateWOH#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHoras.RHJid#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDhn#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDhea#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDheb#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhn#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidheb#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidfer#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						)
					</cfquery>
				</cfif>
				<cfif Arguments.Debug><cf_dumptable var="RHCMDia" label="RHCMDia(1)" filtro="RHCMCSid=#rsInsert.identity# and RHCMDdia=#Lvar_DatePartWOH#" abort=false></cfif>
			</cfif>
		<cfelse>
			<cfif Arguments.Debug><cf_dumptable var="RHCMDia" label="RHCMDia(2)" filtro="RHCMDhniid=#Arguments.Iid# OR RHCMDheaiid=#Arguments.Iid# OR RHCMDhebiid=#Arguments.Iid# OR RHCMDferiid=#Arguments.Iid#" abort=false></cfif>
			<cfquery datasource="#session.dsn#">
				update 	RHCMDia 
					set RHCMDhniid = 0,
						RHCMDhn = 0
				where	RHCMDhniid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update 	RHCMDia 
					set RHCMDheaiid = 0,
						RHCMDhea = 0
				where	RHCMDheaiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update RHCMDia 
					set RHCMDhebiid = 0,
						RHCMDheb = 0
				where	RHCMDhebiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update 	RHCMDia 
					set RHCMDferiid = 0
				where	RHCMDferiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete 	from RHCMDia 
				where   RHCMDhniid = 0
				and 	RHCMDhn = 0
				and 	RHCMDheaiid = 0
				and 	RHCMDhea = 0
				and		RHCMDhebiid = 0
				and		RHCMDheb = 0
				and		RHCMDferiid = 0
			</cfquery>
			<cfif Arguments.Debug><cf_dumptable var="RHCMDia" label="RHCMDia(3)" filtro="RHCMDhniid=#Arguments.Iid# OR RHCMDheaiid=#Arguments.Iid# OR RHCMDhebiid=#Arguments.Iid# OR RHCMDferiid=#Arguments.Iid#" abort=false></cfif>
		</cfif>
		<cfif Arguments.Debug><cfabort></cfif>
	</cffunction>

	<!--- ********************* --->
	<!--- Cambio De Incidencias --->
	<!--- ********************* --->
	<cffunction access="public" name="Cambio">
		<cfargument name="Iid" 				required="true" type="numeric">
		<cfargument name="DEid" 			required="true" type="numeric">
		<cfargument name="CIid" 			required="true" type="numeric">
		<cfargument name="iFecha" 			required="true" type="date">
		<cfargument name="iFechaRebajo" 	required="false" type="string">		
		<cfargument name="iValor" 			required="true" type="numeric">
		<cfargument name="CFid" 			required="false" type="numeric" default="0">
		<cfargument name="RHJid" 			required="false" type="numeric" default="0">
		<cfargument name="Icpespecial" 		required="false" type="numeric" default="0">
		<cfargument name="Imonto" 			required="false" type="numeric" default="0">		
		<cfargument name="Iobservacion" 	required="false" 	type="string" 	default="">
		<cfargument name="Iingresadopor" 	required="false" 	type="string" 	default="">
		<cfargument name="Iestadoaprobacion"required="false" 	type="string" 	default="">
		<cfargument name="usuCF" 			required="false" 	type="numeric" 	default="#session.usucodigo#">
		<cfargument name="Ijustificacion" 	required="false" 	type="string" 	default="">
		
		<cfset This.chkExists(Arguments.DEid, Arguments.CIid, Arguments.iFecha, Arguments.Iid)>
				
		<cftransaction>
			<cfquery name="ABC_Incidencia" datasource="#Session.DSN#">
				update Incidencias set 
					DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
					Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.iFecha#">,
					IfechaRebajo = <cfif isdefined("Arguments.iFechaRebajo") and len(trim( Arguments.iFechaRebajo ))><cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(Arguments.iFechaRebajo)#" ><cfelse>null</cfif>,
					Ivalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">,
					CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#" null="#Arguments.CFid LTE 0#">,
					RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#" null="#Arguments.RHJid LTE 0#">,
					Icpespecial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Icpespecial#">,
					Imonto = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.Imonto#"> <!--- jc --->
					<cfif isdefined("Arguments.Iobservacion") and len(trim(Arguments.Iobservacion))>
						,Iobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Iobservacion)#">
					</cfif>
					where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfinvoke method="updateCMControlSemanal" Iid="#Arguments.Iid#">
		</cftransaction>
	</cffunction>
	

	<!--- ********************* --->
	<!--- Incrementar De Incidencias --->
	<!--- ********************* --->
	<cffunction access="public" name="Incrementar">
		<cfargument name="Iid" required="true" type="numeric">
		<cfargument name="iValor" required="true" type="numeric">
			<cfquery name="ABC_Incidencia" datasource="#Session.DSN#">
				update Incidencias 
				set Ivalor = Ivalor + <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Iid#">
			</cfquery>
			<cfquery name="ABC_Incidencia" datasource="#Session.DSN#">
				delete from Incidencias
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Iid#">
				and Ivalor <= 0.00
			</cfquery>
			<cfinvoke method="updateCMControlSemanal" Iid="#arguments.Iid#">
	</cffunction>

	
	<!--- ******************* --->
	<!--- Baja De Incidencias --->
	<!--- ******************* --->
	<cffunction access="public" name="Baja">
		<cfargument name="Iid" required="no" type="numeric">
        <cfargument name="EIlote" required="no" type="numeric">
        <cfquery name="ABC_Incidencia" datasource="#Session.DSN#">
            delete from Incidencias 
            where 
            <cfif isdefined('Arguments.Iid')>
            Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
            <cfelse>
            EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIlote#">
            </cfif>
        </cfquery>		
	</cffunction>
	
	
	<!--- ***************************************************************** --->
	<!--- Averigua si existe una Incidencia para un empleado para una fecha --->
	<!--- ***************************************************************** --->
	<cffunction access="public" name="chkExists">
		<cfargument name="DEid" required="true" type="numeric">
		<cfargument name="CIid" required="true" type="numeric">
		<cfargument name="iFecha" required="true" type="date">
		<cfargument name="Iid" required="false" type="numeric">
		<cfquery name="chkExists" datasource="#Session.DSN#">
			select 1
			from Incidencias
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
			  and Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.iFecha#">
			  <cfif isdefined("Arguments.Iid") and Arguments.Iid gt 0>
				  and Iid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			  </cfif>
		</cfquery>
		<cfif chkExists.recordCount GT 0>
			<cfquery name="rsInfoEmpleado" datasource="#Session.DSN#">
				select DEidentificacion, DEapellido1, DEapellido2, DEnombre
				from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			</cfquery>
			<cfquery name="rsInfoConceptoI" datasource="#Session.DSN#">
				select CIcodigo, CIdescripcion
				from CIncidentes
				where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
			</cfquery>
			<cfset reg = "">
			<cfset msg = "">
			<cfset reg = "/cfmx/rh/nomina/operacion/IncidenciasProceso.cfm">
			<cfset msg = "">
			<cfset msg = msg  & "#vError#.<br>">
			<cfset msg = msg  & " #vEmpleado#: #rsInfoEmpleado.DEidentificacion# - #rsInfoEmpleado.DEapellido1# #rsInfoEmpleado.DEapellido2# #rsInfoEmpleado.DEnombre#<br>">
			<cfset msg = msg  & " #vConcepto#: #rsInfoConceptoI.CIcodigo# - #rsInfoConceptoI.CIdescripcion#<br>">
			<cfset msg = msg  & " #vFecha#: #LSDateFormat(Arguments.Ifecha,'dd/mm/yyyy')#.<br> <br>">
			<cf_throw message="#msg#" errorCode="1005">
			<cfabort>
		</cfif>
	</cffunction>
    
    <cffunction name="fnGetDIncidencias" access="public" returntype="query">
    	<cfargument name="Iid"  	type="numeric" required="yes">
        <cfargument name="Ecodigo" 	type="numeric" required="no">
        <cfargument name="Conexion" type="numeric" required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
    
    	<cfquery name="rsIncidencias" datasource="#Arguments.Conexion#">

            select Iid, DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, BMUsucodigo, Iespecial, RCNid, Mcodigo, ts_rversion, RHJid, Imonto, Icpespecial, IfechaRebajo, Iusuaprobacion, Ifechaaprobacion, NRP, Inumdocumento, CFcuenta, NAP, Iestado, CFormato, complemento, Ifechacontrol, EIlote
            from Incidencias
            where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
        </cfquery>
        
        <cfreturn rsIncidencias>
    </cffunction>
    
    <cffunction name="fnGetCIncidencias" access="public" returntype="query">
    	<cfargument name="CIid"  	type="numeric" required="no">
        <cfargument name="CIcodigo"  type="string" required="no">
        <cfargument name="Ecodigo" 	type="numeric" required="no">
        <cfargument name="Conexion" type="numeric" required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
    
    	<cfquery name="rsIncidencias" datasource="#Arguments.Conexion#">
            select CIid,CIcodigo,CIdescripcion
            from CIncidentes
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.CIid')>
              and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
            </cfif>
            <cfif isdefined('Arguments.CIcodigo')>
              and CIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CIcodigo#">
            </cfif>
        </cfquery>
        
        <cfreturn rsIncidencias>
    </cffunction>
    
    <cffunction name="fnBajaIncidenciaCalculo" access="public">
    	<cfargument name="ICid"  	type="numeric" required="no">
    	<cfargument name="CIid"  	type="numeric" required="no">
        <cfargument name="DEid"  	type="numeric" required="no">
        <cfargument name="Conexion" type="numeric" required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
    
    	<cfquery datasource="#Arguments.Conexion#">
			delete from IncidenciasCalculo
            where
            <cfif isdefined('Arguments.ICid')>
            	ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ICid#">
          	<cfelse>
            	CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#"> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            </cfif>
        </cfquery>
    </cffunction>
    
    <cffunction name="fnAltaIncidenciaCalculo" access="public">
    	<cfargument name="RCNid"  			type="numeric" 	required="yes">
    	<cfargument name="CIid"  			type="numeric" 	required="yes">
        <cfargument name="DEid"  			type="numeric" 	required="yes">
        <cfargument name="ICfecha"  		type="date" 	required="no">
        <cfargument name="ICvalor"  		type="numeric" 	required="no">
        <cfargument name="ICfechasis"  		type="date" 	required="no">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no">
        <cfargument name="Ulocalizacion"  	type="string" 	required="no" default="">
        <cfargument name="ICmontoant"  		type="numeric" 	required="no">
        <cfargument name="ICmontores"  		type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="numeric" 	required="no">
		
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.ICfecha')>
        	<cfset Arguments.ICfecha = "">
        </cfif>
        <cfif not isdefined('Arguments.ICvalor')>
        	<cfset Arguments.ICvalor = "">
        </cfif>
        <cfif not isdefined('Arguments.ICfechasis')>
        	<cfset Arguments.ICfechasis = "">
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.ICmontores')>
        	<cfset Arguments.ICmontores = "">
        </cfif>
    
    	<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
			insert into IncidenciasCalculo(RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICmontoant, ICmontores)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RCNid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DEid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CIid#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.ICfecha#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.ICvalor#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.ICfechasis#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Ulocalizacion#" 	voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.ICmontoant#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.ICmontores#" 		voidnull>
            )
        <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsert">
        <cfreturn rsInsert.identity>
    </cffunction>
    
    <cffunction name="fnGetEIncidenciaMasiva" access="public" returntype="query">
    	<cfargument name="EIlote"  			type="numeric" 	required="no">
        <cfargument name="Tcodigo"  		type="string" 	required="no">
        <cfargument name="EIestado"  		type="numeric" 	required="no">
    	<cfargument name="Ecodigo"  		type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="numeric" 	required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
    
    	<cfquery name="rsIncidenciaE" datasource="#Arguments.Conexion#">
			select EIlote, CIid, EIdescripcion, Ecodigo, Tcodigo, EIfecha, EIfechaaplic, EIestado, Mcodigo, SNcodigo, Usucodigo, Ulocalizacion, BMUsucodigo, ts_rversion
            from EIncidencias
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.EIlote')>
			  and EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIlote#">
			</cfif>
            <cfif isdefined('Arguments.Tcodigo')>
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Tcodigo)#">
			</cfif>
            <cfif isdefined('Arguments.EIestado')>
			  and EIestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EIestado#">
			</cfif>
        </cfquery>
        <cfreturn rsIncidenciaE>
    </cffunction>
    
    <cffunction name="fnGetLote" access="public" returntype="numeric">
        <cfargument name="Conexion" type="string" required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
    
    	<cfquery name="rsLote" datasource="#Arguments.Conexion#">
            select coalesce(max(EIlote),0)+1 as Lote
            from EIncidencias
        </cfquery>
        <cfreturn rsLote.Lote>
    </cffunction>
    
    <cffunction name="fnAltaEIncidenciaMasiva" access="public" returntype="numeric">
    	<cfargument name="EIlote" 		type="numeric" 	required="no">
        <cfargument name="CIid" 		type="numeric" 	required="no">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name="Tcodigo" 		type="string" 	required="no" default="">
        <cfargument name="EIfecha" 		type="date" 	required="no">
        <cfargument name="EIfechaaplic" type="date" 	required="no">
        <cfargument name="EIestado" 	type="numeric" 	required="no" default="0">
        <cfargument name="Mcodigo" 		type="numeric" 	required="no">
        <cfargument name="SNcodigo" 	type="numeric" 	required="no">
        <cfargument name="Usucodigo" 	type="numeric" 	required="no">
        <cfargument name="Ulocalizacion" type="string" 	required="no" default="">
        <cfargument name="EIdescripcion" type="string" 	required="no" default="">
    	<cfargument name="Conexion" 	type="numeric" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.EIlote')>
        	<cfset Arguments.EIlote = fnGetLote(Arguments.Conexion)>
        </cfif>
        <cfif not isdefined('Arguments.CIid')>
        	<cfset Arguments.CIid = "">
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EIfecha')>
        	<cfset Arguments.EIfecha = "">
        </cfif>
        <cfif not isdefined('Arguments.EIfechaaplic')>
        	<cfset Arguments.EIfechaaplic = "">
        </cfif>
        <cfif not isdefined('Arguments.Mcodigo')>
        	<cfset Arguments.Mcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.SNcodigo')>
        	<cfset Arguments.SNcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
       
        
    	<cfquery datasource="#Arguments.Conexion#">
            insert into EIncidencias(EIlote, CIid, Ecodigo, Tcodigo, EIfecha, EIfechaaplic, EIestado, Mcodigo, SNcodigo, Usucodigo, Ulocalizacion, BMUsucodigo, EIdescripcion)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.EIlote#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CIid#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.Ecodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.Tcodigo#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.EIfecha#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.EIfechaaplic#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.EIestado#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Mcodigo#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.SNcodigo#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.Usucodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Ulocalizacion#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.BMUsucodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.EIdescripcion#" voidnull> 
            )
        </cfquery>
        <cfreturn Arguments.EIlote>
    </cffunction>
    
    <cffunction name="fnCambioEIncidenciaMasiva" access="public" returntype="numeric">
    	<cfargument name="EIlote" 		type="numeric" 	required="yes">
        <cfargument name="CIid" 		type="numeric" 	required="no">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name="Tcodigo" 		type="string" 	required="no" default="">
        <cfargument name="EIfecha" 		type="date" 	required="no">
        <cfargument name="EIfechaaplic" type="date" 	required="no">
        <cfargument name="EIestado" 	type="numeric" 	required="no" default="0">
        <cfargument name="Mcodigo" 		type="numeric" 	required="no">
        <cfargument name="SNcodigo" 	type="numeric" 	required="no">
        <cfargument name="Usucodigo" 	type="numeric" 	required="no">
        <cfargument name="Ulocalizacion" type="string" 	required="no" default="">
        <cfargument name="EIdescripcion" type="string" 	required="no" default="">
    	<cfargument name="Conexion" 	type="numeric" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.CIid')>
        	<cfset Arguments.CIid = "">
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EIfecha')>
        	<cfset Arguments.EIfecha = "">
        </cfif>
        <cfif not isdefined('Arguments.EIfechaaplic')>
        	<cfset Arguments.EIfechaaplic = "">
        </cfif>
        <cfif not isdefined('Arguments.Mcodigo')>
        	<cfset Arguments.Mcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.SNcodigo')>
        	<cfset Arguments.SNcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
       
    	<cfquery datasource="#Arguments.Conexion#">
        	update EIncidencias set
            	CIid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CIid#" voidnull>,
                Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.Ecodigo#">,
                Tcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.Tcodigo#" voidnull>,
                EIfecha = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.EIfecha#" voidnull>,
                EIfechaaplic = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.EIfechaaplic#" voidnull>,
                EIestado = <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.EIestado#">,
                Mcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Mcodigo#" voidnull>,
                SNcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.SNcodigo#" voidnull>,
                Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.Usucodigo#">,
                Ulocalizacion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Ulocalizacion#" voidnull>,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.BMUsucodigo#">,
                EIdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.EIdescripcion#" voidnull>
      		where EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.EIlote#">
        </cfquery>
        <cfreturn Arguments.EIlote>
    </cffunction>
    
    <cffunction name="fnBajaEIncidenciaMasiva" access="public">
    	<cfargument name="EIlote" 		type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
    	<cfargument name="Conexion" 	type="numeric" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
       
    	<cfquery datasource="#Arguments.Conexion#">
        	delete from EIncidencias
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.Ecodigo#">
              and EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.EIlote#">
        </cfquery>
        <cfreturn Arguments.EIlote>
    </cffunction>
    
    <cffunction name="fnAplicarEIncidenciaMasiva" access="public" returntype="numeric">
    	<cfargument name="EIlote" 		type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
    	<cfargument name="Conexion" 	type="numeric" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
       
    	<cfquery datasource="#Arguments.Conexion#">
        	update EIncidencias set EIestado = 1 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.Ecodigo#">
              and EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.EIlote#">
        </cfquery>
        <cfreturn Arguments.EIlote>
    </cffunction>
    
    <cffunction access="public" name="fnCambioDIncidenciaMasivaMonto" returntype="numeric">
		<cfargument name="Iid" 		required="true" 	type="numeric">
		<cfargument name="iValor" 	required="true" 	type="numeric">
		<cfargument name="Imonto" 	required="false"	type="numeric" default="0">		
        <cfargument name="Conexion" required="false"	type="string">	
        
		<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
            update Incidencias set 
              	Ivalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">,
              	Imonto = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.Imonto#">
            where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
        </cfquery>
		<cfinvoke method="updateCMControlSemanal" Iid="#Arguments.Iid#">
        <cfreturn Arguments.Iid>
	</cffunction>
	
	<!--- ***************************************************************** --->
	<!--- Actualiza la justificacion en las incidencias. --->
	<!--- ***************************************************************** --->
	
	<cffunction access="public" name="UpdateJustificacion">
		<cfargument name="Iid" required="no" type="numeric">
        <cfargument name="EIlote" required="no" type="numeric">
		<cfargument name="Ijustificacion" 	required="false" 	type="string" 	default="">
        
		<cfquery datasource="#Session.DSN#">
            Update Incidencias 
            set Ijustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ijustificacion#">
			where 
            <cfif isdefined('Arguments.Iid')>
            Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
            <cfelse>
            EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIlote#">
            </cfif>
        </cfquery>		
	</cffunction>
	
	<!--- ***************************************************************** --->
	<!--- Averiguar si se ingresa desde Autogestion o desde Nomina --->
	<!--- ***************************************************************** --->
	<cffunction access="public" name="validaLugarConsulta" returntype="string">
		<cfreturn session.monitoreo.SMCodigo>			
	</cffunction>
	
	<!--- ***************************************************************** --->
	<!--- Averiguar quienes son los subalternos de un Jefe u Autorizador --->
	<!--- ***************************************************************** --->
	<cffunction access="public" name="getSubalternos" returntype="any">
		<cfargument name="DEid" required="no" type="numeric">
		<cfargument name="incluirJefesCFhijos" required="no" type="numeric" default="0"><!---incluye o no como subalternos a los jefes de los centros funcionales --->
		<cfargument name="incluirEmpleadosCFhijos" required="no" type="numeric" default="0"><!---incluye o no como subalternos a los empleados de los centros funcionales hijos que no poseen jefes autorizadores o osuarios asignados --->
		<cfargument name="incluirDEid" required="no" type="numeric" default="1">		<!---incluye o no al jefe en la lista de subalternos--->
			
			<!---Centros funcionales de los que el usuario es jefe u autorizador--->
			<cfquery datasource="#Session.DSN#" name="rsCFJefeAutorizador">
				<!---Autorizador--->
					select cfa.CFid
					from CFautoriza cfa
						inner join Usuario a
						on  a.Usucodigo = cfa.Usucodigo 
						and a.Uestado = 1 
						and a.Utemporal = 0
						and a.CEcodigo = #Session.CEcodigo#
					
					where cfa.Ecodigo = #session.Ecodigo# 
						and cfa.Usucodigo = #session.usucodigo#
				Union 
					<!---Ocupante de plaza jefe del centro funcional LT--->
					select b.CFid
					from LineaTiempo a
					inner join RHPlazas b
						on b.RHPid = a.RHPid
					inner join CFuncional c
						on c.RHPid = b.RHPid
					where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
						and getDate() between a.LTdesde and a.LThasta 
				Union 
					<!---Ocupante de plaza jefe del centro funcional DL--->
					select b.CFid
					from DLaboralesEmpleado a
					inner join RHPlazas b
						on b.RHPid = a.RHPid
					inner join CFuncional c
						on c.RHPid = b.RHPid
					where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
						and getDate() between a.DLfvigencia and a.DLffin
				Union 
					<!---Usuario del centro fincional--->
					select c.CFid
					from CFuncional c
					where c.CFuresponsable = #session.usucodigo#
					
				Union 
					<!---usuarios del centro funcional--->
					select d.CFid
					from UsuarioCFuncional d
					where d.Usucodigo = #session.usucodigo#
			</cfquery>
			<cfquery dbtype="query" name="rsCFs">
				select distinct CFid from rsCFJefeAutorizador
			</cfquery>
			
			<cfset CFids = 0>
			<cfif rsCFs.RecordCount gt 0>
				<cfset CFids = valueList(rsCFs.CFid)>
			</cfif>
			
			<!---Es jefe de los centros funcionales hijos que no tienen jefe--->
			<cfif arguments.incluirEmpleadosCFhijos EQ 1 and CFids NEQ 0>
				
				<cfquery name="rsGetPathCFs" datasource="#session.dsn#">
					select CFpath from CFuncional where CFid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">)
				</cfquery>
				<cfset CFidHijos = ''>
				<cfloop query="rsGetPathCFs">
				
					<cfset path = rsGetPathCFs.CFpath>
					<cfquery name="rsGetHijosCFSinJefe" datasource="#session.dsn#">
						select a.CFid
						from CFuncional a 
						where a.CFpath like '#path#%'
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and a.CFid not in 
							(
							select cfa.CFid from CFautoriza cfa where cfa.CFid = a.CFid   <!-----autorizadores--->
							)
						and a.CFid not in (
							select cf.CFid from CFuncional cf where cf.CFid = a.CFid and cf.CFuresponsable is not null<!--- --usuario responsable --->
							)
						and a.CFid not in (
							select ucf.CFid from UsuarioCFuncional ucf where ucf.CFid = a.CFid 	<!---usuarios--->
							)
						and a.CFid not in (										<!---Jefe plaza--->
							select cf.CFid from CFuncional cf 
								inner join RHPlazas b
								  on coalesce(cf.RHPid,-1) = b.RHPid 
								inner join LineaTiempo lt
								  on b.RHPid = lt.RHPid
								  and getDate() between lt.LTdesde and lt.LThasta
							where cf.CFid=a.CFid
							)
					</cfquery>
					<cfif rsGetHijosCFSinJefe.RecordCount gt 0>
						<cfset CFidHijos = ListAppend(CFidHijos,valueList(rsGetHijosCFSinJefe.CFid),',')>
					</cfif>
				</cfloop>
				
				<cfif listLen(CFidHijos)>
					<cfset CFids = ListAppend(CFids,CFidHijos,',')>
				</cfif>
			
			</cfif>
			<!---Busca subalternos del(os) CF(s) del que es Jefe o Autorizador--->
			<cfquery datasource="#Session.DSN#" name="rsSubalternosAll">
				select distinct c.DEid, c.DEnombre,c.DEapellido1,c.DEapellido2
				from RHPlazas a
					inner join LineaTiempo b
					on  b.RHPid = a.RHPid 
					and getDate() between b.LTdesde and b.LThasta  
					
					inner join DatosEmpleado c
					on b.DEid = c.DEid
				where a.CFid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">) 
				Union
				select distinct c.DEid, c.DEnombre,c.DEapellido1,c.DEapellido2			<!---incluye empleados que por alguna razon no se encuentren en la linea del tiempo con la plaza indicada--->
				from RHPlazas a
					inner join DLaboralesEmpleado b
					on  b.RHPid = a.RHPid 
					and getDate() between b.DLfvigencia and b.DLffin  
					
					inner join DatosEmpleado c
					on b.DEid = c.DEid
				where a.CFid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">) 
				
				<cfif arguments.incluirJefesCFhijos EQ 1>					<!---incluye  como subalternos a los jefes de los centros funcionales hijos--->
					Union
					select distinct c.DEid, c.DEnombre,c.DEapellido1,c.DEapellido2
					from CFuncional  cf
					inner join LineaTiempo b
						on  cf.RHPid = b.RHPid 
						and getDate() between b.LTdesde and b.LThasta  
					inner join DatosEmpleado c
						on b.DEid = c.DEid
					where CFidresp in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">)
					Union 
					select distinct c.DEid, c.DEnombre,c.DEapellido1,c.DEapellido2
					from CFuncional  cf
					inner join DLaboralesEmpleado b
						on  cf.RHPid = b.RHPid 
						and getDate() between b.DLfvigencia and b.DLffin  
					inner join DatosEmpleado c
						on b.DEid = c.DEid
					where CFidresp in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">)
				</cfif>
			</cfquery>
			
			<cfquery dbtype="query" name="rsSubalternos">
				Select distinct * from rsSubalternosAll 
				<cfif incluirDEid EQ 0>
					where DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				</cfif>
			</cfquery>	
			<cfreturn rsSubalternos>	
	</cffunction>
	
	<!--- ***************************************************************** --->
	<!--- Averiguar si es Jefe. Usuario, Jefe, Administrador --->
	<!--- ***************************************************************** --->
	<cffunction access="public" name="validaJefeAutorizador" returntype="string">
		<cfargument name="DEid" required="no" type="numeric" default="0">
		
			<cfquery datasource="#Session.DSN#" name="rsEsJefe">
				select sum(x.esJefe) as verdadero
				from(
					<!---Autorizador--->
					select count(1) as esJefe
					from CFautoriza cfa
						inner join Usuario a
						on  a.Usucodigo = cfa.Usucodigo 
						and a.Uestado = 1 
						and a.Utemporal = 0
						and a.CEcodigo = #Session.CEcodigo#
					
					where cfa.Ecodigo = #session.Ecodigo# 
						and cfa.Usucodigo = #session.usucodigo#
				<cfif Arguments.DEid GT 0>
					Union 
						<!---Ocupante de plaza jefe del centro funcional LT--->
						select count(1) as esJefe
						from LineaTiempo a
						inner join RHPlazas b
							on b.RHPid = a.RHPid
						inner join CFuncional c
							on c.RHPid = b.RHPid
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
							and getDate() between a.LTdesde and a.LThasta 
					Union 
						<!---Ocupante de plaza jefe del centro funcional DL--->
						select count(1) as esJefe
						from DLaboralesEmpleado a
						inner join RHPlazas b
							on b.RHPid = a.RHPid
						inner join CFuncional c
							on c.RHPid = b.RHPid
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
							and getDate() between a.DLfvigencia and a.DLffin
				</cfif>
				Union 
					<!---Usuario del centro fincional--->
					select count(1) as esJefe
					from CFuncional c
					where c.CFuresponsable = #session.usucodigo#
					
				Union 
					<!---usuarios del centro funcional--->
					select count(1) as esJefe
					from UsuarioCFuncional d
					where d.Usucodigo = #session.usucodigo#
				)x
			</cfquery>
			
			<cfif rsEsJefe.RecordCount GT 0 and rsEsJefe.verdadero>
				<cfreturn 1>
			<cfelse>
				<cfreturn 0>
			</cfif>
		
	</cffunction>
	
	<!--- *****************************************--->
	<!--- Averiguar el DEid del usuario en session --->
	<!--- *****************************************--->	
	<cffunction access="public" name="getEmpleadoUsuario" returntype="any">
		
		<cfquery datasource="#Session.DSN#" name="rsEmpleado">	<!---averigua el DEid del usuario--->
			select a.DEid, a.DEidentificacion, {fn concat({fn concat({fn concat({ fn concat( a.DEnombre, ' ') }, a.DEapellido1)}, ' ')}, a.DEapellido2) } as 	Nombre, a.NTIcodigo
			from DatosEmpleado a 
				inner join LineaTiempo b
				on a.DEid = b.DEid
				and getDate() between b.LTdesde and b.LThasta
			where a.DEid = (select coalesce(<cf_dbfunction name="to_number" args="ue.llave">,-1)
							from UsuarioReferencia ue 
							where ue.Ecodigo = #session.EcodigoSDC# 
								and ue.STabla = 'DatosEmpleado' 
								and ue.Usucodigo = #session.usucodigo#)
		</cfquery>
		
		<cfreturn rsEmpleado>
			
	</cffunction>
	
	<!--- *****************************************--->
	<!--- Averiguar el usuario del DEid en parametro--->
	<!--- *****************************************--->	
	<cffunction access="public" name="getUsuario" returntype="any">
		<cfargument name="DEid" required="yes" type="numeric" default="0">
		
		<cfquery datasource="#Session.DSN#" name="rsUsuario">
			select coalesce(ue.Usucodigo,-1) as usuario
				from UsuarioReferencia ue 
				where ue.Ecodigo = #session.EcodigoSDC# 
					and ue.STabla = 'DatosEmpleado' 
					and coalesce(<cf_dbfunction name="to_number" args="ue.llave">,-1) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>
		
		<cfreturn rsUsuario.usuario>	
	</cffunction>
	
	<!--- ********************************************************************************** --->
	<!--- Averiguar si el usuario (que va a tener el rol=2) es Administrador en Parametros RH --->
	<!--- *********************************************************************************** --->	
	<cffunction access="public" name="esAdministradorRH" returntype="string">
		<cfset usuAdminRH = getParam(180)>							<!---Usuario Administrador de RH--->
		<cfif usuAdminRH EQ session.usucodigo>
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<!--- ***************************************************************** --->
	<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador --->
	<!--- ***************************************************************** --->	
	<cffunction access="public" name="getRol" returntype="string">
		
		<cfset Menu = validaLugarConsulta()> 
		
		<cfif Menu EQ 'NOMINA'>
			<cfreturn 2>	<!--- ES ADMINISTRADOR--->
		<cfelseif Menu EQ 'AUTO'>
			<cfquery datasource="#Session.DSN#" name="rsEmpleado">	<!---averigua el DEid del usuario--->
				select <cf_dbfunction name="to_number" args="ue.llave"> as DEid
				from UsuarioReferencia ue 
				where ue.Ecodigo = #session.EcodigoSDC# 
				and ue.STabla = 'DatosEmpleado' 
				and ue.Usucodigo = #session.usucodigo# 
			</cfquery>
			<cfset vDEid = 0>
			<cfif rsEmpleado.RecordCount GT 0>
				<cfset vDEid = rsEmpleado.DEid>
			</cfif>
			<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="validaJefeAutorizador" returnvariable="esJefeAutorizador"> <!---Averigua si el empleado es un jefe o un autorizador--->
				<cfinvokeargument name="DEid" value="#vDEid#">		
			</cfinvoke>
			
			<cfif esJefeAutorizador EQ 1>
				<cfreturn 1>	<!---ES JEFE O AUTORIZADOR--->
			<cfelse>
				<cfreturn 0>	<!---ES USUARIO NORMAL--->
			</cfif>
			
		<cfelse>
			<cfreturn -1>	<!---esta funcion se adapta solo para nomina y para autogestion--->
		</cfif>	

	</cffunction>
	
	
	<!--- ***************************************************************** --->
	<!--- Averigua Parametros RH --->
	<!--- ***************************************************************** --->	
	<cffunction access="public" name="getParam" returntype="any">
		<cfargument name="Pcodigo" required="yes" type="numeric">
		
		<cfquery name="rsParam" datasource="#Session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
		</cfquery>
		
		<cfreturn rsParam.Pvalor>
	</cffunction>
	
	<!--- ***************************************************************** --->
	<!--- Averigua si el Jefe es su propio jefe o requiere que otro jefe lo autorize --->
	<!--- ***************************************************************** --->	
	<cffunction access="public" name="EsSuJefe" returntype="string">
		<cfargument name="DEid" required="yes" type="numeric">
		
		<cfset rsSubAlternos= getSubalternos(DEid="#arguments.DEid#")>
		
		<cfquery name="rsEsJefe" dbtype="query">
			select count(1) as existe from rsSubAlternos where DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>
		
		<cfset EsJefe = 0>
		<cfif  rsEsJefe.RecordCount gt 0 AND rsEsJefe.existe GT 0 >
			<cfset EsJefe = 1>
		</cfif>
		<cfreturn EsJefe>
		
	</cffunction>
	
	<!--- ******************************************************************************** --->
	<!--- Trae los Emails del jefe y de los autorizadores del centro funcional en donde se encuentra el empleado --->
	<!--- ******************************************************************************** --->	
	<cffunction access="public" name="getEmailJefes" returntype="any">
		<cfargument name="DEid" required="yes" type="numeric">
			
			<cfquery datasource="#Session.DSN#" name="rsGetCF">
				select b.CFid	
				from LineaTiempo a
					inner join RHPlazas b
						on  a.RHPid = b.RHPid
				where getDate() between a.LTdesde and a.LThasta   <!---Empleado Activo--->
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and a.Ecodigo = #session.Ecodigo#
			</cfquery>	
			
			<cfif rsGetCF.RecordCount EQ 0>
				<cfthrow message="Alerta: el mensaje de correo no puede ser enviado. La plaza que ocupa actualmente, no esta registrado en un centro funcional.">
				<cfabort>
			<cfelse>
					<cfset usuario = getUsuario(Arguments.DEid)>
					
					<cfquery datasource="#Session.DSN#" name="rsGetNivelCF">
						select CFnivel	
						from CFuncional
						where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGetCF.CFid#">
					</cfquery>
					<cfset CFidAct = rsGetCF.CFid>
					
					<cfloop from="0" to="#rsGetNivelCF.CFnivel#" index="i" step="1">
						
						<cfquery datasource="#Session.DSN#" name="rsGetEmailsJefe">
							select distinct x.nombre, x.Email  from (<!--- x.DEidentificacion,--->
								<!---====== Emails registrados desde DatosEmpleados ======--->
									<!---Jefe CF--->
									select a.DEid, a.DEemail as Email, a.DEidentificacion,  
									{fn concat(a.DEnombre,{fn concat(' ',{fn concat(a.DEapellido1,{fn concat(' ',a.DEapellido2)})})})} as nombre
									from CFuncional c
									inner join LineaTiempo lt
										on lt.RHPid = c.RHPid
										and getDate() between lt.LTdesde and lt.LThasta   <!---Jefe en plaza Activa--->
										and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									inner join DatosEmpleado a 
										on  a.DEid = lt.DEid
									where c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidAct#">
									and a.DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">						<!---por si el dueño de la inciencia es jefe que no se incluya a si mismo--->
								Union	
									<!---Autorizadores del centro--->	
									select a.DEid, a.DEemail as Email, a.DEidentificacion,  
									 {fn concat(a.DEnombre,{fn concat(' ',{fn concat(a.DEapellido1,{fn concat(' ',a.DEapellido2)})})})} as nombre
									
									from DatosEmpleado a 
									where a.DEid in (
													select coalesce(<cf_dbfunction name="to_number" args="ue.llave">,-1)
													from UsuarioReferencia ue 
												
													inner join CFautoriza cfa
													on cfa.Usucodigo = ue.Usucodigo
													and cfa.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGetCF.CFid#">
													where ue.Ecodigo = #session.EcodigoSDC# 
														and ue.STabla = 'DatosEmpleado' 
														and ue.Usucodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">	<!---por si el dueño de la inciencia es jefe que no se incluya a si mismo--->
														)
								
								Union 
									<!---Usuario del centro funcional--->
									select a.DEid, a.DEemail as Email, a.DEidentificacion,  
									 {fn concat(a.DEnombre,{fn concat(' ',{fn concat(a.DEapellido1,{fn concat(' ',a.DEapellido2)})})})} as nombre
									from DatosEmpleado a 
									where a.DEid in (
											select coalesce(<cf_dbfunction name="to_number" args="ue.llave">,-1)
											from  CFuncional c
											inner join UsuarioReferencia ue 
												on c.CFuresponsable = ue.Usucodigo
											where c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGetCF.CFid#">
											and ue.Usucodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">	<!---por si el dueño de la inciencia es jefe que no se incluya a si mismo--->
										)
								Union 
									<!---usuarios que autorizan del centro funcional--->
									select a.DEid, a.DEemail as Email, a.DEidentificacion,  
									 {fn concat(a.DEnombre,{fn concat(' ',{fn concat(a.DEapellido1,{fn concat(' ',a.DEapellido2)})})})} as nombre
									from DatosEmpleado a 
									where a.DEid in (
											select coalesce(<cf_dbfunction name="to_number" args="ue.llave">,-1)
											from  UsuarioCFuncional c
											inner join UsuarioReferencia ue 
												on c.Usucodigo = ue.Usucodigo
											where c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGetCF.CFid#">
											and c.Usucodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">	<!---por si el dueño de la inciencia es jefe que no se incluya a si mismo--->
										)
							<!---====== Emails registrados para los usuarios desde PSO en DatosPersonales ======--->
								Union	
									<!---Autorizadores del centro--->	
									select 0 as DEid, coalesce(dp.Pemail1,dp.Pemail2)as Email, dp.Pid as DEidentificacion, {fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})} as nombre 
									from CFautoriza cfa
									inner join Usuario u 
										on cfa.Usucodigo = u.Usucodigo
									inner join DatosPersonales dp
										on dp.datos_personales = u.datos_personales
									where cfa.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidAct#">
									and cfa.Usucodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">	<!---por si el dueño de la inciencia es jefe que no se incluya a si mismo--->
								Union 
									<!---Usuario del centro funcional--->
									select 0 as DEid, coalesce(dp.Pemail1,dp.Pemail2)as Email, dp.Pid as DEidentificacion, {fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})} as nombre 
									from CFuncional cf
									inner join Usuario u 
										on cf.CFuresponsable = u.Usucodigo
									inner join DatosPersonales dp
										on dp.datos_personales = u.datos_personales
									where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidAct#">
									and cf.CFuresponsable <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">	<!---por si el dueño de la inciencia es jefe que no se incluya a si mismo--->
								Union 
									<!---usuarios que autorizan del centro funcional--->
									select 0 as DEid, coalesce(dp.Pemail1,dp.Pemail2)as Email, dp.Pid as DEidentificacion, {fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})} as nombre 
									from UsuarioCFuncional ucf
									inner join Usuario u 
										on u.Usucodigo = ucf.Usucodigo
									inner join DatosPersonales dp
										on dp.datos_personales = u.datos_personales
									where ucf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidAct#">
									and ucf.Usucodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">	<!---por si el dueño de la inciencia es jefe que no se incluya a si mismo--->
									) x
							order by x.nombre,x.Email
						</cfquery>
						
						<cfif rsGetEmailsJefe.RecordCount GT 0>
							<cfbreak>
						<cfelse>
							<cfquery datasource="#Session.DSN#" name="rsGetCFAct">
								select CFidresp	from CFuncional
								where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFidAct#">
							</cfquery>
							<cfset CFidAct = rsGetCFAct.CFidresp>
						</cfif>
					</cfloop>

			</cfif>
			<cfif not isdefined("rsGetEmailsJefe") or rsGetEmailsJefe.RecordCount EQ 0>
				<!---<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=AVISO<br>&ErrDet=#URLEncodedFormat(No se han definido aun el e-mail para los autorizadores, usuarios, o jefes en centros funcionales.)#" addtoken="no">--->
				<cfthrow message="AVISO: No se han definido aun el e-mail para los autorizadores, usuarios, o jefes en centros funcionales.">
				<!---INGRESAR EMAIL DE ADMISTRATRADOR... AGREGAR EL CAMPO EN PSO--->
			</cfif>
			<cfquery dbtype="query" name="rsEmailsJefe">
				select distinct email,nombre from rsGetEmailsJefe
			</cfquery>
			<cfreturn rsEmailsJefe>
		
	</cffunction>
	
	
	<!--- ******************************************************************************** --->
	<!--- Trae el Email del empleado --->
	<!--- ******************************************************************************** --->	
	<cffunction access="public" name="getEmailEmpleado" returntype="any">
		<cfargument name="DEid" required="yes" type="numeric">
		
		<cfquery datasource="#Session.DSN#" name="rsGetEmailEmpleado">
			select a.DEid, a.DEemail, a.DEidentificacion, {fn concat(a.DEnombre,{fn concat(' ',{fn concat(a.DEapellido1,{fn concat(' ',a.DEapellido2)})})})} as nombre
			from DatosEmpleado a 
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>
		
		<cfreturn rsGetEmailEmpleado>
		
	</cffunction>
	
	<!--- ******************************************************************************** --->
	<!--- Cambia el estado a enviar a aprobar y realiza el envio del correo correspondiente--->
	<!--- ******************************************************************************** --->	
	<cffunction access="public" name="SolicitaAprobacion" returntype="string">
		<cfargument name="Iid" required="yes" type="string">
		<cfargument name="DEid" required="yes" type="numeric">
		
		<!---Cambia el estado de la incidencia--->
		<cfquery datasource="#session.DSN#">
			Update Incidencias 
			set Iestadoaprobacion = 1
			where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Arguments.Iid#">)
		</cfquery>
		<cfset rsEnviarSolicitud = EnviaSolicitudAprobacion(Arguments.Iid,Arguments.DEid)>
		<cfreturn 1>
		
	</cffunction>
	
	
	<cffunction access="public" name="ApruebaIncidenciaEmail">
		<cfargument name="Iid" 				required="true" type="string">
		
		<!---Datos de la incidencia--->
		<cfquery name="rsEmp" datasource="#session.DSN#">
			select distinct a.DEid
			from Incidencias a
			where a.Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Arguments.Iid#">)
		</cfquery>
		<!--- Averigua el DEid del usuario--->
		<cfset DEidUser = getEmpleadoUsuario()>
		
		<cfloop query="rsEmp">
			<!--- Averigua correos de jefe/autorizador--->
			<cfset rsEmailJefes = getEmailJefes(rsEmp.DEid)>
			<!--- Averigua correo de dueño de la incidencia--->
			<cfset rsEmailEmpleado = getEmailEmpleado(rsEmp.DEid)>
	
			<!---Datos de la incidencia--->
			<cfquery name="rsIncidencia" datasource="#session.DSN#">
				select distinct b.CIcodigo,b.CIdescripcion,a.Ivalor, a.Iobservacion, a.Ifecha,a.Ijustificacion,a.DEid,CFid
				from Incidencias a
				inner join CIncidentes b
				on b.CIid = a.CIid 
				where a.Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Arguments.Iid#">)
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
			</cfquery>
			
			<cfset MensajeIncidencias = "">
				
			<!---Genera las incidencias en un cuadro--->
			<cfsavecontent variable="MensajeIncidencias"><cfoutput>#MensajeIncidencias#
				<tr><td>&nbsp;</td></tr>
				<tr><td><table cellpadding="2" cellspacing="2" border="1" width="100%"  align="center">
					<tr><td align="center"><strong>Incidencia</strong></td>
						<td align="center"><strong>Fecha</strong></td>
						<td align="center"><strong>Monto/cantidad</strong></td>
						<td align="center"><strong>Observacion</strong></td>
						<td align="center"><strong>Centro Funcional</strong></td></tr>
					<cfloop query="rsIncidencia">
						<cfif isdefined("rsIncidencia.CFid") and len(trim(rsIncidencia.CFid))>
							<cfset rsCF = getCentroFuncional(rsIncidencia.CFid)>
						<cfelse>
							<cfset rsCF = getCentroFuncional_Plaza(rsIncidencia.DEid)>
						</cfif>
						<tr><td align="center">#rsIncidencia.CIcodigo# - #rsIncidencia.CIdescripcion# </td>
							<td align="center">#LSDateFormat(rsIncidencia.Ifecha,'dd/mm/yyyy')#</td>
							<td align="center">#rsIncidencia.Ivalor#</td>
							<td align="center">#rsIncidencia.Iobservacion#</td>
							<td align="center">#rsCF.CFcodigo# - #rsCF.CFdescripcion#</td></tr>
					</cfloop>
				</table></td></tr>
				</cfoutput>
			</cfsavecontent>
			<!---Mensaje de envio a Empleado--->
			<cfsavecontent variable="MensajeEmpleado"><cfoutput><table border="0" cellpadding="0" cellspacing="0">
					<tr><td>Atencion,</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>#ucase(valueList(rsEmailEmpleado.nombre))#</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>Se ha aceptado su solicitud de incidencia.</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td><strong>Tramitado por:</strong></td></tr>
					<tr><td>#ucase(DEidUser.DEidentificacion)# - #ucase(DEidUser.nombre)#</td></tr>
					<tr><td>&nbsp;</td></tr>
					#MensajeIncidencias#
					<tr><td><hr></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>Para mayor detalle haga clic en el siguiente link:</td></tr>
					<tr><td><a href="http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm">http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm</a></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>Muchas gracias.</td></tr>
				</table></cfoutput>
			</cfsavecontent>
			
			<cfset subjectE = "Aprobacion de Incidencia">
			<cfset fromE = "gestion@soin.co.cr">
			<cfset rsToE = rsEmailEmpleado.DEemail>
			
			<!---Envia el correo de aprobacion a empleado--->
			<cfset enviaMail = enviarCorreo(fromE,rsToE,subjectE,MensajeEmpleado)>
			
			<!---Mensaje de envio a Jefes/Autorizadores--->
			<cfsavecontent variable="Mensaje"><cfoutput><table border="0" cellpadding="0" cellspacing="0">
					<tr><td>Atencion,</td></tr>
					<tr><td>&nbsp;</td></tr>
					<cfif isdefined("rsEmailJefes.nobre") and len(trim(rsEmailJefes))>
					<tr><td>#replaceNocase(ucase(valueList(rsEmailJefes.nombre)),',','<br>','all')#</td></tr>
					<tr><td>&nbsp;</td></tr>
					</cfif>
					<tr><td>Se ha aceptado una solicitud de aprobacion de incidencia.</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td><strong>Solicitante:</strong></td></tr>
					<tr><td>#ucase(rsEmailEmpleado.DEidentificacion)# - #ucase(rsEmailEmpleado.nombre)#</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td><strong>Tramitado por:</strong></td></tr>
					<tr><td>#ucase(DEidUser.DEidentificacion)# - #ucase(DEidUser.nombre)#</td></tr>
					<tr><td>&nbsp;</td></tr>
					#MensajeIncidencias#
					<tr><td><hr></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>Para mayor detalle haga clic en el siguiente link:</td></tr>
					<tr><td><a href="http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm">http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm</a></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>Muchas gracias.</td></tr>
				</table></cfoutput>
			</cfsavecontent>
			<cfset subject = "Aprobacion de Incidencia de Empleado">
			<cfset from = "gestion@soin.co.cr">
			<cfset rsTo = valueList(rsEmailJefes.Email)>
			
			<!---Envia el correo de aprobacion a empleado--->
			<cfset enviaMail = enviarCorreo(from,rsTo,subject,Mensaje)>
		</cfloop>
	</cffunction>
	
	<cffunction access="public" name="RechazaIncidenciaEmail">
		<cfargument name="Iid" 				required="true" type="string">
		
		<!---Las rechazadas en teoria ya estas en el historico--->
		<cfquery name="rsEmp" datasource="#session.DSN#">
			select distinct a.DEid
			from HIncidencias a
			where a.Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Arguments.Iid#">)
		</cfquery>
		
		<!--- Averigua el DEid del usuario--->
		<cfset DEidUser = getEmpleadoUsuario()>
		
		<cfloop query="rsEmp">
		
					<!--- Averigua correos de jefe/autorizador--->
					<cfset rsEmailJefes = getEmailJefes(rsEmp.DEid)>
					<!--- Averigua correo de dueño de la incidencia--->
					<cfset rsEmailEmpleado = getEmailEmpleado(rsEmp.DEid)>
					<!---Datos de la incidencia--->
					<cfquery name="rsIncidencia" datasource="#session.DSN#">
						select distinct b.CIcodigo,b.CIdescripcion,a.Ivalor, a.Iobservacion, a.Ifecha,a.Ijustificacion,a.DEid,a.CFid
						,a.Iestado 
						,case when a.Iestado = 1 then ( <!--- aprobado ya por admin pero Rechaza super admin--->
									select {fn concat(dp.Pid,{fn concat(' ',{fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})})})} 
									from DatosPersonales dp
									inner join Usuario u 
										on dp.datos_personales = u.datos_personales
									where u.Usucodigo = a.BMUsucodigo
							) else '' end as tramitadoPor
						
						from HIncidencias a
						inner join CIncidentes b
						on b.CIid = a.CIid 
						where a.Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Arguments.Iid#">)
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
					</cfquery>
					
					<cfset MensajeIncidencias = "">
					<!---Genera las incidencias en un cuadro--->
					<cfsavecontent variable="MensajeIncidencias"><cfoutput>#MensajeIncidencias#
						<tr><td>&nbsp;</td></tr>
						<tr><td><table cellpadding="2" cellspacing="2" border="1" width="100%"  align="center">
							<tr><td><strong>Incidencia</strong></td>
								<td align="center"><strong>Fecha</strong></td>
								<td align="right"><strong>Monto/cantidad</strong></td>
								<td align="center"><strong>Observacion</strong></td>
								<td align="center"><strong>Centro Funcional</strong></td></tr>
							<cfloop query="rsIncidencia">
								<cfif isdefined("rsIncidencia.CFid") and len(trim(rsIncidencia.CFid))>
									<cfset rsCF = getCentroFuncional(rsIncidencia.CFid)>
								<cfelse>
									<cfset rsCF = getCentroFuncional_Plaza(rsIncidencia.DEid)>
								</cfif>
								<tr><td>#rsIncidencia.CIcodigo# - #rsIncidencia.CIdescripcion# </td>
									<td align="center">#LSDateFormat(rsIncidencia.Ifecha,'dd/mm/yyyy')#</td>
									<td align="right">#rsIncidencia.Ivalor#</td>
									<td>#rsIncidencia.Iobservacion#</td>
									<td align="center">#rsCF.CFcodigo# - #rsCF.CFdescripcion#</td></tr>
							</cfloop>
						</table></td></tr>
						<tr><td>&nbsp;</td></tr>
						</cfoutput>
					</cfsavecontent>
					
					
					<!---Mensaje de envio a Empleado--->
					<cfsavecontent variable="MensajeEmpleado"><cfoutput><table border="0" cellpadding="0" cellspacing="0">
							<tr><td>Atencion,</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>#ucase(valueList(rsEmailEmpleado.nombre))#</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>Se ha negado su solicitud de aprobacion de incidencia.</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td><strong>Tramitado por:</strong></td></tr>
							<tr><td>
								<cfif rsIncidencia.Iestado EQ 1>
									#ucase(rsIncidencia.tramitadoPor)#
								<cfelse>
									#ucase(DEidUser.DEidentificacion)# - #ucase(DEidUser.nombre)#
								</cfif>
							</td></tr>
							<tr><td>&nbsp;</td></tr>
							#MensajeIncidencias#
							<tr><td><hr></td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td><strong>Justificacion:</strong></td></tr>
							<tr><td>#rsIncidencia.Ijustificacion#</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>Para mayor detalle haga clic en el siguiente link:</td></tr>
							<tr><td><a href="http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm">http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm</a></td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>Muchas gracias.</td></tr>
						</table></cfoutput>
					</cfsavecontent>
					<cfset subjectE = "Rechazo de Aprobacion de Incidencia">
					<cfset fromE = "gestion@soin.co.cr">
					<cfset rsToE = rsEmailEmpleado.DEemail>
					
					<!---Envia el correo de rechazo a empleado--->
					<cfset enviaMail = enviarCorreo(fromE,rsToE,subjectE,MensajeEmpleado)>
					
					<!---Mensaje de envio a Jefes/Autorizadores--->
					<cfsavecontent variable="Mensaje"><cfoutput><table border="0" cellpadding="0" cellspacing="0">
							<tr><td>Atencion,</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>#replaceNocase(ucase(valueList(rsEmailJefes.nombre)),',','<br>','all')#</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>Se ha rechazado una solicitud de aprobacion de incidencia.</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td><strong>Solicitante:</strong></td></tr>
							<tr><td>#ucase(rsEmailEmpleado.DEidentificacion)# - #ucase(rsEmailEmpleado.nombre)#</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td><strong>Tramitado por:</strong></td></tr>
							<tr><td>
								<cfif rsIncidencia.Iestado EQ 1>
									#ucase(rsIncidencia.tramitadoPor)#
								<cfelse>
									#ucase(DEidUser.DEidentificacion)# - #ucase(DEidUser.nombre)#
								</cfif>
							</td></tr>
							#MensajeIncidencias#
							<tr><td><hr></td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td><strong>Justificacion:</strong></td></tr>
							<tr><td>#rsIncidencia.Ijustificacion#</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>Para mayor detalle haga clic en el siguiente link:</td></tr>
							<tr><td><a href="http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm">http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm</a></td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>Muchas gracias.</td></tr>
						</table></cfoutput>
					</cfsavecontent>
					<cfset subject = "Rechazo de Aprobacion de Incidencia">
					<cfset from = "gestion@soin.co.cr">
					<cfset rsTo = valueList(rsEmailJefes.Email)>
					
					<!---Envia el correo de rechazo a empleado--->
					<cfset enviaMail = enviarCorreo(from,rsTo,subject,Mensaje)>
			</cfloop>
		
	</cffunction>
	
	<!--- ******************************************************************************** --->
	<!--- Envia correo de solicitud de aprobacion de incidencias--->
	<!--- ******************************************************************************** --->	
	<cffunction access="public" name="EnviaSolicitudAprobacion" returntype="string">
		<cfargument name="Iid" required="yes" type="string">
		<cfargument name="DEid" required="yes" type="numeric">
		
		<!---Datos de la incidencia--->
		<cfquery name="rsIncidencia" datasource="#session.DSN#">
			select b.CIcodigo,b.CIdescripcion,a.Ivalor, a.Iobservacion, a.Ifecha,a.CFid
			from Incidencias a
			inner join CIncidentes b
			on b.CIid = a.CIid 
			where a.Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Arguments.Iid#">)
		</cfquery>
		
		<!---Direcciones de correo--->
		<cfset rsEmailJefes = getEmailJefes(Arguments.DEid)>
		<cfset rsEmailEmpleado = getEmailEmpleado(Arguments.DEid)>
		
		<cfset MensajeIncidencias = "">
		<!---Genera las incidencias en un cuadro--->
		<cfsavecontent variable="MensajeIncidencias"><cfoutput>#MensajeIncidencias#
			<tr><td>&nbsp;</td></tr>
			<tr><td><table cellpadding="2" cellspacing="2" border="1" width="100%"  align="center">
				<tr><td><strong>Incidencia</strong></td>
					<td align="center"><strong>Fecha</strong></td>
					<td align="right"><strong>Monto/cantidad</strong></td>
					<td align="center"><strong>Observacion</strong></td>
					<td align="center"><strong>Centro Funcional</strong></td></tr>
				<cfloop query="rsIncidencia">
					<cfif isdefined("rsIncidencia.CFid") and len(trim(rsIncidencia.CFid))>
						<cfset rsCF = getCentroFuncional(rsIncidencia.CFid)>
					<cfelse>
						<cfset rsCF = getCentroFuncional_Plaza(rsIncidencia.DEid)>
					</cfif>
					<tr><td>#rsIncidencia.CIcodigo# - #rsIncidencia.CIdescripcion# </td>
						<td align="center">#LSDateFormat(rsIncidencia.Ifecha,'dd/mm/yyyy')#</td>
						<td align="right">#rsIncidencia.Ivalor#</td>
						<td>#rsIncidencia.Iobservacion#</td>
						<td align="center">#rsCF.CFcodigo# - #rsCF.CFdescripcion#</td></tr>
				</cfloop>
			</table></td></tr>
			<tr><td>&nbsp;</td></tr>
			</cfoutput>
		</cfsavecontent>
		
		<!---Mensaje de envio--->
		<cfsavecontent variable="Mensaje"><cfoutput><table border="0" cellpadding="0" cellspacing="0">
				<tr><td>Atencion,</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>Se ha realizado una solicitud de aprobacion de incidencia.</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td><strong>Solicitante: #ucase(rsEmailEmpleado.DEidentificacion)# - #ucase(rsEmailEmpleado.nombre)#</strong></td></tr>
				<tr><td>&nbsp;</td></tr>
				#MensajeIncidencias#
				<tr><td>Para mayor detalle haga clic en el siguiente link:</td></tr>
				<tr><td><a href="http://#session.sitio.host#/cfmx/rh/nomina/operacion/aprobarIncidenciasProceso.cfm">http://#session.sitio.host#/cfmx/rh/nomina/operacion/aprobarIncidenciasProceso.cfm</a></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>Muchas gracias.</td></tr>
			</table></cfoutput>
		</cfsavecontent>
		
		<cfloop query="rsEmailJefes">
			<cfset subject = "Solicitud de Aprobacion de Incidencia">
			<cfset from = "gestion@soin.co.cr">
			<cfset rsTo = rsEmailJefes.Email>
			
			<!---Envia el correo de aprobacion--->
			<cfset enviaMail = enviarCorreo(from,rsTo,subject,Mensaje)>
		</cfloop>
		
		<!---Mensaje de envio--->
		<cfsavecontent variable="MensajeEmp"><cfoutput><table border="0" cellpadding="0" cellspacing="0">
				<tr><td>Atencion,</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>Se ha enviado su solicitud de aprobacion de incidencia.</td></tr>
				<tr><td>&nbsp;</td></tr>
				#MensajeIncidencias#				
				<tr><td>Para mayor detalle haga clic en el siguiente link:</td></tr>
				<tr><td><a href="http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm">http://#session.sitio.host#/cfmx/rh/nomina/operacion/EstadoIncidenciasProceso.cfm</a></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>Muchas gracias.</td></tr>
			</table></cfoutput>
		</cfsavecontent>
		<cfset subject = "Solicitud de Aprobacion de Incidencia ha Sido Enviada.">
		<cfset from = "gestion@soin.co.cr">
		<cfset rsTo = rsEmailEmpleado.DEemail>
		<cfset enviaMail = enviarCorreo(from,rsTo,subject,MensajeEmp)>
		
		<cfreturn 1>
		
	</cffunction>
	
	<!--- ***************************************************************** --->
	<!--- Envio de correos --->
	<!--- ***************************************************************** --->
	<cffunction access="private" name="enviarCorreo" output="true" returntype="boolean">
		<cfargument name="from" required="yes" type="string">
		<cfargument name="to" required="yes" type="string">
		<cfargument name="subject" required="yes" type="string">
		<cfargument name="message" required="yes" type="string">
		
		<cfset errores = 0>
		
		<cftry>
			<cfquery datasource="asp">
				insert into SMTPQueue 
					(SMTPremitente, SMTPdestinatario, SMTPasunto,
					SMTPtexto, SMTPhtml)
				 values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.from)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.to)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.message#">,
					1)
			</cfquery>
			
			<cfcatch type="any">
				<cfset errores = errores + 1>
				<cfoutput>Error: Tipo: #cfcatch.type#, <br>Mensaje: #cfcatch.Message#, <br>Detalle: #cfcatch.Detail#</cfoutput>
				<cfabort>
			</cfcatch>
		</cftry>
		
		<cfreturn errores eq 0>
	</cffunction>
	
	<cffunction access="public" name="AutoApruebaIncidencia">
		<cfargument name="Iid" 				required="yes" type="string">
		<cfargument name="enviarEmail" 		required="no"  type="boolean" default="true">
		<cfargument name="usaPresupuesto" 	required="yes" type="boolean" default="false">
		
		<!--- revisar bien este proceso, falta la integracion con presupuesto --->
		<cfset consecutivo = 1 >
		<cfquery name="rs_consecutivo" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 1020
		</cfquery>
		<cfif len(trim(rs_consecutivo.Pvalor)) and isnumeric(rs_consecutivo.Pvalor) >
			<cfset consecutivo = rs_consecutivo.Pvalor + 1 >
		</cfif>
		<!--- hace la parte presupuestaria solo si parametro 540 (usa de presupuesto) esta activo--->
		<cfif Arguments.usaPresupuesto>
			<!---►►►►ACTUALIZA EL FORMATO DE LA CUENTA FINANCIERA◄◄◄◄◄--->
			<cfinvoke component="rh.Componentes.RH_AplicarMascara" method="ActualizaFormatoRCuentasTipo">
				<cfinvokeargument name="RCNid" 		value="#Arguments.RCNid#">
				<cfinvokeargument name="Periodo" 	value="#Arguments.Periodo#">
				<cfinvokeargument name="Mes" 		value="#Arguments.Mes#">
			</cfinvoke>
			<!--- calcula la cuenta financiera segun formato --->
			<cfquery datasource="#session.DSN#">
				update Incidencias
				set CFcuenta = (  	select min(CFcuenta) 
									from CFinanciera
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and CFformato = Incidencias.CFormato )
				where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
			</cfquery>
		</cfif>				
		<cfset vNAP = randrange(1, 100000) >
		<cfquery datasource="#session.DSN#">
			update Incidencias
			set Iestado = 1,
				Iusuaprobacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				Ifechaaprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				Inumdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">,
				NRP = null,
				NAP = #vNAP#							<!--- puesto a dedo para simular aprobacion de presupuesto, esto debe quitarse,NOTA: ESTO DEBE REVISARSE CON QUIEN HISO LA ESPECIFICACION. --->
			where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update RHParametros
			set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#consecutivo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 1020
		</cfquery>
		
	</cffunction>
	
	
	<cffunction access="public" name="ApruebaIncidencia">
		<cfargument name="Iid" 				required="yes" type="string">
		<cfargument name="enviarEmail" 		required="no"  type="boolean" default="true">
		<cfargument name="usaPresupuesto" 	required="yes" type="boolean" default="false">
		<!---uso de presupuesto... revisarse son quien hiso la especificacion --->
		<cfargument name="RCNid" 			required="no"  type="string" default="-1">
		<cfargument name="Periodo" 			required="no"  type="string" default="-1">
		<cfargument name="Mes" 				required="no"  type="string" default="-1">
		<cfargument name="rol" 				required="no"  type="string" default="-1">
		
		<!---El rol puede ser enviado en caso en el caso de la pantalla del Registro General de Incidencias, cuando un Adminitrador de incidencias, aprueba como un jefe o como un administrador de nomina. --->
		<cfif rol EQ -1>
			<cfset rol = getRol()>								<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador --->
		</cfif>
		
		<!---valida si no requiere aprobacion o si no se trata de una incidencia desde autogestion (para la aprobacion final del administrador)--->
		<cfif rol EQ 2>
			<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según paramatrizacion 2526--->
		</cfif>
		
		<cfset result = ValidaTramite(Iid="#Arguments.Iid#",rol="#rol#")>
		
		<cfset reqAprobacion = getParam(Pcodigo = "1010")>		<!---Averigua si el parametro 'Requiere aprobación incidencias' esta encendido --->
		<cfset reqAprobacionJefe = getParam(Pcodigo = "2540")>  <!---Averigua si el parametro 'Requiere aprobacion de Incidencias por el Jefe del Centro Funcional' esta encendido --->
		
		<!--- revisar bien este proceso, falta la integracion con presupuesto --->
		<cfset consecutivo = 1 >
		<cfquery name="rs_consecutivo" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 1020
		</cfquery>
		<cfif len(trim(rs_consecutivo.Pvalor)) and isnumeric(rs_consecutivo.Pvalor) >
			<cfset consecutivo = rs_consecutivo.Pvalor + 1 >
		</cfif>
		
		<cfif listFindNoCase('1,2',rol,',')>					<!---Solo si es Jefe/Autorizador u Administrador--->
				
			<cftransaction>
					<cfif rol EQ 2 >									<!---Administrador--->
				
					<!--- hace la parte presupuestaria solo si parametro 540 (usa de presupuesto) esta activo--->
					<cfif Arguments.usaPresupuesto>
						<!---►►►►ACTUALIZA EL FORMATO DE LA CUENTA FINANCIERA◄◄◄◄◄--->
						<cfinvoke component="rh.Componentes.RH_AplicarMascara" method="ActualizaFormatoRCuentasTipo">
							<cfinvokeargument name="RCNid" 		value="#Arguments.RCNid#">
							<cfinvokeargument name="Periodo" 	value="#Arguments.Periodo#">
							<cfinvokeargument name="Mes" 		value="#Arguments.Mes#">
						</cfinvoke>
						<!--- calcula la cuenta financiera segun formato --->
						<cfquery datasource="#session.DSN#">
							update Incidencias
							set CFcuenta = (  	select min(CFcuenta) 
												from CFinanciera
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and CFformato = Incidencias.CFormato )
							where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
						</cfquery>
					</cfif>				
					<cfset vNAP = randrange(1, 100000) >
					<cfquery datasource="#session.DSN#">
						update Incidencias
						set Iestado = 1,
							Iusuaprobacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							Ifechaaprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							Inumdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">,
							NRP = null,
							NAP = #vNAP#							<!--- puesto a dedo para simular aprobacion de presupuesto, esto debe quitarse,NOTA: ESTO DEBE REVISARSE CON QUIEN HISO LA ESPECIFICACION. --->
						where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
					</cfquery>
					<cfquery datasource="#session.DSN#">
						update RHParametros
						set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#consecutivo#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and Pcodigo = 1020
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.DSN#">
						update Incidencias
						set Iestadoaprobacion=2,
							usuCF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
					</cfquery>
				</cfif>
			</cftransaction>
				<cfif enviarEmail>
					<cfset sent = ApruebaIncidenciaEmail(Iid="#arguments.Iid#")>
				</cfif>
		<cfelse>
			<cfthrow message="Atencion: No posee permisos para realizar esta operacion. Verifique que sea Jefe u autorizador de un centro funcional.">
			<cfabort>
		</cfif>
		
	</cffunction>
	
	<cffunction access="public" name="RechazaIncidenciaFinal"><!---El rechazo final solo lo va a manejar el administrador desde el registro de incidencias o un usuario con el permiso ADM_INCIDE --->
		<cfargument name="Iid" 				required="true" type="string">
		<cfargument name="Ijustificacion" 	required="no" type="string" default="Rechazo Final del Administrador">
			
			<!---verifica que la operacion no se haya realizado ya--->
			<cftransaction>	
				<cfquery datasource="#session.DSN#">
					update Incidencias
					set 
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,<!---Rechaza super admin--->
						NAP = null,
						NRP = null,
						CFormato = null,
						complemento = null,
						CFcuenta = null,
						Ifechaaprobacion = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						Inumdocumento = null
						<cfif isdefined("Arguments.Ijustificacion") and len(trim(Arguments.Ijustificacion))>
						,Ijustificacion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.Ijustificacion#">
						</cfif>
					where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
				</cfquery>
				
				<!---Genera Históricos--->
				<cfset result = GenerarHistorico(Iid="#Arguments.Iid#")>
				
			</cftransaction>	
		
		  
		  <!---Envío de correos--->
		  <cfset sent = RechazaIncidenciaEmail(Iid="#arguments.Iid#")>
			 
	</cffunction>
	
	<cffunction access="public" name="RechazaIncidencia">
		<cfargument name="Iid" 				required="true" type="string">
		<cfargument name="Ijustificacion" 	required="true" type="string">
		
		<cfset rol = getRol()>									<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador --->
		<cfset reqAprobacion = getParam(Pcodigo = "1010")>		<!---Averigua si el parametro 'Requiere aprobación incidencias' esta encendido --->
		<cfset reqAprobacionJefe = getParam(Pcodigo = "2540")>  <!---Averigua si el parametro 'Requiere aprobacion de Incidencias por el Jefe del Centro Funcional' esta encendido --->
		
		<cfset result = ValidaTramite(Iid="#Arguments.Iid#",rol="#rol#")> <!---verifica que la operacion no se haya realizado ya--->
		
		<cfif listFindNoCase('1,2',rol,',')>					<!---Solo si es Jefe/Autorizador u Administrador--->
			
			<cftransaction>
				<cfquery datasource="#session.DSN#">
					update Incidencias
					set 
						<cfif rol EQ 2 >		<!---Rechaza admin--->
							Iestado = 2,
							Iusuaprobacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfelse>				<!---Rechaza jefe--->
							Iestadoaprobacion=3,
							usuCF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						</cfif>
						NAP = null,
						NRP = null,
						CFormato = null,
						complemento = null,
						CFcuenta = null,
						Ifechaaprobacion = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						Inumdocumento = null,
						Ijustificacion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.Ijustificacion#">
					where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
				</cfquery>
				
				<!---Genera Historicos--->
				<cfset result = GenerarHistorico(Iid="#Arguments.Iid#")>
			
			</cftransaction>
			
			<!---Envio de correos--->
			<cfset sent = RechazaIncidenciaEmail(Iid="#arguments.Iid#")>
		<cfelse>
			<cfthrow message="Atencion: No posee permisos para realizar esta operacion. Verifique que sea Jefe u autorizador de un centro funcional.">
			<cfabort>
		</cfif>
		
	</cffunction>
	
	
	<cffunction access="public" name="GenerarHistorico">
		<cfargument name="Iid" 				required="true" type="string">
			
				<cfquery datasource="#session.DSN#">
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
						HIEstado
						,HBMUsucodigo
						<!---,IfechaAnt
						*/--->
						)
					
					select 
						Iid,
						DEid,
						CIid,
						CFid,
						Ivalor,
						Ifechasis,
						Usucodigo,
						Ulocalizacion,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
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
						getDate(),
						2,
						BMUsucodigo
					from Incidencias
					where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
				</cfquery>
				
				<cfquery datasource="#session.DSN#">
					Delete Incidencias
					where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">) 
				</cfquery>
				
	</cffunction>
	
	<cffunction access="public" name="getCentroFuncional" returntype="any">
		<cfargument name="CFid" 				required="true" type="string">
		
		<cfquery name="rsCF" datasource="#session.DSN#">
			<!---Ocupante de plaza jefe del centro funcional LT--->
				select c.CFid,c.CFcodigo,c.CFdescripcion
				from CFuncional c
				where c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">	
		</cfquery>
		<cfreturn rsCF>
	</cffunction>
	
	<cffunction access="public" name="getCentroFuncional_Plaza" returntype="any">
		<cfargument name="DEid" 				required="true" type="string">
		
		<cfquery name="rsCFP" datasource="#session.DSN#">
			
			select distinct * from (	
				<!---Ocupante de plaza jefe del centro funcional LT--->
					select c.CFid,c.CFcodigo,c.CFdescripcion
					from LineaTiempo a
					inner join RHPlazas b
						on b.RHPid = a.RHPid
					inner join CFuncional c
						on c.CFid = b.CFid
					where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
						and getDate() between a.LTdesde and a.LThasta 
				Union 
					<!---Ocupante de plaza jefe del centro funcional DL--->
					select c.CFid,c.CFcodigo,c.CFdescripcion
					from DLaboralesEmpleado a
					inner join RHPlazas b
						on b.RHPid = a.RHPid
					inner join CFuncional c
						on c.CFid = b.CFid
					where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
						and getDate() between a.DLfvigencia and a.DLffin) x
		</cfquery>
		
		<cfreturn rsCFP>
		
	</cffunction>
	
	<cffunction access="public" name="ValidaTramite" returntype="any">
		<cfargument name="Iid" 		required="true" type="string">
		<cfargument name="rol" 		required="true" type="string">	<!---1=Jefe 2=Admin--->
		
		<!---Mensaje que se va a mostrar en caso de comflicto--->
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Regresar" default="Regresar" xmlfile="/rh/generales.xml" returnvariable="LB_Regresar"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"	returnvariable="LB_RecursosHumanos"/>
		<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="Aprobaci&oacute;n de Incidencias" VSgrupo="103" returnvariable="nombre_proceso"/>
		<cfsavecontent variable="rsMensaje"><cfoutput>
				<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top">
							<cf_web_portlet_start titulo="#nombre_proceso#">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" height="400">
									<tr valign="top"> 
										<td align="center">
											<cfif listlen(Arguments.Iid) GT 1 >
												<center><font color="0066CC">Una o algunas de las incidencias que desea procesar ya fue tramitada. Por favor refresque la lista.</font></center>
											<cfelse>
												<center><font color="6699FF">La incidencia que desea procesar ya fue tramitada. Por favor refresque la lista.</font></center>
											</cfif><br>
											<center><input type="button" align="middle" value="#LB_Regresar#" onclick="javascript: history.back()"></center>
										</td>
									</tr>
									<tr valign="top"> <td>&nbsp;</td></tr>
								</table>
							<cf_web_portlet_end>
						</td>	
					</tr>
				</table>	
			<cf_templatefooter>	
		</cfoutput>
		</cfsavecontent>
		
		<!---Incidencia Rechazada jefe-admin--->
		<cfquery name="rsRechazadas" datasource="#session.DSN#">	
			select distinct Iid,NAP
			from HIncidencias 
			where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Arguments.Iid#">)
		</cfquery>
		
		<cfif rsRechazadas.RecordCount GT 0>
			<cfif listlen(Arguments.Iid) GT 1 >
				<cfoutput>#rsMensaje#</cfoutput><cfabort>
			<cfelse>
				<cfoutput>#rsMensaje#</cfoutput><cfabort>
			</cfif>
		</cfif>
		
		<!---Incidencia Aprobadas--->
		<cfquery name="rsIncidencias" datasource="#session.DSN#">	
			select distinct Iestado, Iestadoaprobacion, NAP
			from Incidencias 
			where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Arguments.Iid#">)
		</cfquery>
		
		<cfif Arguments.rol EQ 1>									<!---Jefe--->
			
			<cfquery name="rsjef" dbtype="query">					<!---Incidencia Aprobadas Jefe--->
				select *
				from rsIncidencias 
				where Iestadoaprobacion in (2,3)
			</cfquery>
			<cfif rsjef.RecordCount gt 0>
				<cfif listlen(Arguments.Iid) GT 1 >
					<cfoutput>#rsMensaje#</cfoutput><cfabort>
				<cfelse>
					<cfoutput>#rsMensaje#</cfoutput><cfabort>
				</cfif>
			</cfif>
		
		<cfelseif Arguments.rol EQ 2>								<!---Admin--->
			
			<cfquery name="rsAdm" dbtype="query">					<!---Incidencia Aprobadas Admin--->
				select *
				from rsIncidencias 
				where Iestado in (1,2)
			</cfquery>
			<cfif rsAdm.RecordCount gt 0>
				<cfif listlen(Arguments.Iid) GT 1 >
					<cfoutput>#rsMensaje#</cfoutput><cfabort>
				<cfelse>
					<cfoutput>#rsMensaje#</cfoutput><cfabort>
				</cfif>
			</cfif>
		<cfelse>
			<cfthrow message="El usuario no esta autorizado para realizar esta accion.">
		</cfif>
		<cfreturn 1>
	</cffunction>
	
</cfcomponent>