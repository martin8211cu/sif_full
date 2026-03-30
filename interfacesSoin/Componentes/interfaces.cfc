<cfset this.LvarLog = true>
<!--- 
	********************************
	PROCESOS DE ACTIVACION DEL MOTOR
	********************************
	fnActivarMotor
		fnUrlServidorMotor
--->
<cffunction name="fnActivarMotor" access="public" returntype="struct" output="no">
	<cfargument name="CEcodigo" 			type="numeric" required="yes">
	<cfargument name="urlServidor" 			type="string" default="">
	<cfargument name="invocadoDeParametros" type="boolean" default="no">

	<cfset GvarCE = Arguments.CEcodigo>
	<cfset session.CEcodigo = Arguments.CEcodigo>

	<cfif Arguments.CEcodigo EQ -1><cfreturn></cfif>

	<cfset rsMotor = fnUrlServidorMotor (Arguments.CEcodigo, urlServidor, invocadoDeParametros)>

	<cfif isdefined("Application.interfazSoin.CE_#Arguments.CEcodigo#")>
		<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"].Bitacora = rsMotor.Bitacora>
		<cfreturn rsMotor>
	</cfif>
	
	<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"] = structNew()>
	
	<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"].Bitacora = rsMotor.Bitacora>
	<cfset fnLog("","Activando Motor de Interfaces CE=#Arguments.CEcodigo#")>

	
	<!--- FINALIZA LOS PROCESOS CANCELADOS --->
	<cfquery name="rsProc" datasource="sifinterfaces">
		select NumeroInterfaz, IdProceso, SecReproceso
		  from InterfazColaProcesosCancelar
		 where CEcodigo = #Arguments.CEcodigo#
	</cfquery>
	<cfloop query="rsProc">
		<cfset fnProcesoFinalizar(rsProc.NumeroInterfaz,rsProc.IdProceso,-1, "-1", 'Proceso cancelado')>
	</cfloop>

	<!--- FINALIZA LOS PROCESOS QUE QUEDARON ACTIVOS --->
	<cfquery name="rsProc" datasource="sifinterfaces">
		select p.NumeroInterfaz, p.IdProceso, p.SecReproceso, p.TipoProcesamiento, i.eMailErrores
		  from InterfazColaProcesos p
		  	inner join Interfaz i
				on i.NumeroInterfaz = p.NumeroInterfaz
		 where p.CEcodigo = #Arguments.CEcodigo#
		   and p.StatusProceso = 2
	</cfquery>
	<cfloop query="rsProc">
		<cfif rsProc.TipoProcesamiento NEQ "A">
			<cfset fnLog("S_FP","ID=#rsProc.IdProceso#, Interfaz=#rsProc.NumeroInterfaz#, Status=3 (Finalizado con Error, se mantiene pendiente), ERROR=Proceso cancelado al iniciar el Motor. El proceso estaba dormido o el Servidor de Aplicaciones quedó fuera de servicio antes de terminar su ejecución", rsProc.eMailErrores)>
			<cfset fnProcesoFinalizarConError(rsProc.NumeroInterfaz,rsProc.IdProceso,rsProc.SecReproceso, 'Proceso cancelado al iniciar el Motor. El proceso estaba dormido o el Servidor de Aplicaciones quedó fuera de servicio antes de terminar su ejecución')>
		<cfelse>
			<cfset fnLog("A_FP","ID=#rsProc.IdProceso#, Interfaz=#rsProc.NumeroInterfaz#, Status=3 (Finalizado con Error, se mantiene pendiente), ERROR=Proceso cancelado al iniciar el Motor. El proceso estaba dormido o el Servidor de Aplicaciones quedó fuera de servicio antes de terminar su ejecución", rsProc.eMailErrores)>
			<cfset fnProcesoPendienteConError(rsProc.NumeroInterfaz,rsProc.IdProceso,rsProc.SecReproceso, 'Proceso cancelado al iniciar el Motor. El proceso estaba dormido o el Servidor de Aplicaciones quedó fuera de servicio antes de terminar su ejecución')>
		</cfif>
	</cfloop>

	<cfquery name="rsSQL" datasource="sifinterfaces">
		select <cf_dbfunction name="now" datasource="sifinterfaces"> as now
		<cfif Application.dsinfo.sifinterfaces.type EQ "oracle" OR Application.dsinfo.sifinterfaces.type EQ "db2">
			from dual
		</cfif>
	</cfquery>
	<cfset LvarFechaActivacion = rsSQL.now>

	<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"].FechaActivacion = LvarFechaActivacion>

	<cftransaction>
		<cfquery datasource="sifinterfaces">
			update InterfazMotor
			   set FechaActivacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaActivacion#">
				 , FechaActividad = null
			 where CEcodigo = #Arguments.CEcodigo#
		</cfquery>
		<cfquery datasource="sifinterfaces">
			update Interfaz
			   set FechaActivacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaActivacion#">
				 , FechaActividad 	= null
				 , Ejecutando		= 0
			 <!--- where CEcodigo = #Arguments.CEcodigo# --->
		</cfquery>
		<cfquery datasource="sifinterfaces">
			update InterfazColaProcesos
			   set FechaActivacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaActivacion#">
				 , FechaActividad = null
			 where CEcodigo = #Arguments.CEcodigo#
		</cfquery>
	</cftransaction>
	
	<cfreturn rsMotor>
</cffunction>

<cffunction name="fnUrlServidorMotor" access="public" returntype="struct" output="no">
	<cfargument name="CEcodigo" 			type="string" required="yes">
	<cfargument name="urlSrv" 				type="string" default="">
	<cfargument name="invocadoDeParametros" type="boolean" default="no">

	<cfset var LvarMSG = "">

	<cfset GvarCE = Arguments.CEcodigo>

	<cftry>
		<cfquery name="rsMotor" datasource="sifinterfaces">
			select FechaActivacion, urlServidorMotor, Activo
				 , Bitacora_S_AP, Bitacora_S_FP, Bitacora_S_DE, Bitacora_D_AP, Bitacora_D_FP, Bitacora_D_DE, Bitacora_A_IP, Bitacora_A_AT, Bitacora_A_AI, Bitacora_A_AP, Bitacora_A_FP, Bitacora_A_DE
			from 
				<cf_dbdatabase table="InterfazMotor" datasource="sifinterfaces"> 
			 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		</cfquery>
		
		<cfif rsMotor.RecordCount EQ 0>
			<cfquery datasource="sifinterfaces">
				insert into <cf_dbdatabase table="InterfazMotor" datasource="sifinterfaces"> (CEcodigo) 
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">)
			</cfquery>
			<cfquery name="rsMotor" datasource="sifinterfaces">
				select FechaActivacion, urlServidorMotor, Activo
					,Bitacora_S_AP, Bitacora_S_FP, Bitacora_S_DE, Bitacora_D_AP, Bitacora_D_FP, Bitacora_D_DE, Bitacora_A_IP, Bitacora_A_AT, Bitacora_A_AI, Bitacora_A_AP, Bitacora_A_FP, Bitacora_A_DE	
					from 
					<cf_dbdatabase table="InterfazMotor" datasource="sifinterfaces">
				 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			</cfquery>
		</cfif>

		<cfif not Arguments.invocadoDeParametros AND Arguments.urlSrv EQ "">
			<cfif Not Arguments.invocadoDeParametros and rsMotor.Activo EQ "0">
				<cfthrow type="INACTIVO" message="El Motor de Interfaces SOIN esta Inactivo">
			</cfif>
			<cfset LvarUrlServidor = fnUrlLocalhost(rsMotor.urlServidorMotor)>
		<cfelse>
			<cfset LvarUrlServidor = fnUrlLocalhost(Arguments.urlSrv)>
		</cfif>
		
		<cfif len(trim(LvarUrlServidor)) EQ 0>
			<cfthrow message="El Url del Servidor del Motor de Interfaces SOIN no puede quedar en blanco">
		</cfif>
		<cfif mid(LvarUrlServidor,len(LvarUrlServidor),1) NEQ "/">
			<cfset LvarUrlServidor = LvarUrlServidor & "/">
		</cfif>
		<cfset LvarPto = find("/cfmx/", LvarUrlServidor)>
		<cfif LvarPto EQ 0>
			<cfset LvarUrlServidor = LvarUrlServidor & "cfmx/">
		<cfelse>
			<cfset LvarUrlServidor = mid(LvarUrlServidor,1,LvarPto+5)>
		</cfif>
	
		<cfif Arguments.invocadoDeParametros>
			<cfif NOT fnMismoServidor(LvarUrlServidor)>
				<cfthrow message="No se permite activación remota. Debe conectarse a '#LvarUrlServidor#'">
			</cfif>
			
			<cfset LvarTareaAsincrona = LvarUrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#Arguments.CEcodigo#">
			<cfschedule action		= "update"
						task		= "Tarea Asincrona Motor Interfaces CE=#Arguments.CEcodigo#" 
						operation	= "httprequest"
						startdate	= "1/1/2000"
						starttime	="0:0:0"
						interval	= "61"
						url			= "#LvarTareaAsincrona#"
						>
						<!--- OPARRALES 2019-04-25 Atributo removido para CF2018--->
						<!--- requesttimeout="1" --->
		</cfif>
		
	<cfcatch type="any">
		<cfset LvarMSG = "">
		<cfif not Arguments.invocadoDeParametros>
			<cfset LvarMSG = "Error al Verificar el Motor de Interfaces SOIN: ">
		</cfif>
		<cfif cfcatch.Type EQ "URLSOIN">
			<cfset LvarMSG = LvarMSG & "Problemas con el URL del Servidor: ">
		</cfif>

		<cfset LvarMSG = LvarMSG & cfcatch.Message & " " & cfcatch.Detail>
		<cfif cfcatch.Type NEQ "INACTIVO">
			<cfquery datasource="sifinterfaces">
				update InterfazMotor
				   set Activo 	= 0
					 , MsgError			= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#mid(LvarMSG,1,255)#">
				 where CEcodigo = #Arguments.CEcodigo#
			</cfquery>
			<cfset fnLog("","ERROR: Activando Motor de Interfaces CE=#Arguments.CEcodigo#, #LvarMSG#")>
		</cfif>
		<cfthrow message="Corregir en Parametros de Interfaces SOIN: #cfcatch.Message# #cfcatch.Detail#">
	</cfcatch>
	</cftry>

	<cfset stMotor.urlServidorMotor	= LvarUrlServidor>
	<cfset stMotor.Activo 			= rsMotor.Activo>
	<cfset stMotor.FechaActivacion	= rsMotor.FechaActivacion>

	<cfset stMotor.Bitacora 		= structNew()>
	<cfset stMotor.Bitacora.S_AP	= rsMotor.Bitacora_S_AP>
	<cfset stMotor.Bitacora.S_FP	= rsMotor.Bitacora_S_FP>
	<cfset stMotor.Bitacora.S_DE	= rsMotor.Bitacora_S_DE>
	<cfset stMotor.Bitacora.D_AP	= rsMotor.Bitacora_D_AP>
	<cfset stMotor.Bitacora.D_FP	= rsMotor.Bitacora_D_FP>
	<cfset stMotor.Bitacora.D_DE	= rsMotor.Bitacora_D_DE>

	<cfset stMotor.Bitacora.A_IP	= rsMotor.Bitacora_A_IP>
	<cfset stMotor.Bitacora.A_AT	= rsMotor.Bitacora_A_AT>
	<cfset stMotor.Bitacora.A_AI	= rsMotor.Bitacora_A_AI>
	<cfset stMotor.Bitacora.A_AP	= rsMotor.Bitacora_A_AP>
	<cfset stMotor.Bitacora.A_FP	= rsMotor.Bitacora_A_FP>
	<cfset stMotor.Bitacora.A_DE	= rsMotor.Bitacora_A_DE>
	<cfreturn stMotor>
</cffunction>

<!--- 
	***************************************************
	PROCESOS DE INVOCACION DEL WEB SERVICE O DESDE SOIN
	(creación de Procesos en la Cola de Procesos)
	***************************************************
	WebService:
		interfaz-service.cfm
			si es WS_XML
				<cfinclude template="interfaz-serviceXML.cfm">
			sino
				fnProcesoNuevoExterno
					fnProcesoNuevo

		interfaz-serviceXML.cfm
			fnProcesoNuevoExternoXML
				fnVerificaInterfaz
				if TipoProcesamiento = "D"
					fnProcesoNuevoExternoXML_Directa
						sbEjecutarComponente
						SI ERROR:
							fnCrearProcesoXML
							ProcesoNuevoConError
				else
					fnCrearProcesoXML
						fnSiguienteIdProceso
						if ManejoDatos = "T"
							sbGeneraXMLtoTabla IE, ID, IS
						else
							Graba XML_IE, XML_ID, XML_IS en InterfazDatosXML
						endif
					fnProcesoNuevo
				endif
			endif
			if MSG='OK' AND XML_OUT
				if ManejoDatos <> "T"
					fnXMLresponse(#XML_OE#, #XML_OD#, #XML_OS#)
				else
					sbGeneraTablaToXML("OE", "OD", "OS")
				endif
			endif
			
			fnProcesoNuevo
				fnActivarMotor
				Revisa que ID no exista en cola ni en bitacora
				fnVerificaInterfaz
				Inserta en Cola
				if TipoProcesamiento <> "A" = SINCRONICO
					fnActivarProceso
						sbEjecutarComponente: 
							<cfinclude #interfaz.Componente#>
								sbReportarActividad
						sbProcesoSpFinal
						fnProcesoFinalizarConExito
						SI ERROR:
							if no es ORACLE
								Guardar Datos en XML porque se van a borrar en el rollback de la transacción
							fnProcesoFinalizarConError
				else ASINCRÓNICO
					if TipoRetardo="M" AND MinutosRetardo EQ 0
						sbInvocar_ActivarInterfaz
												
--->

<cffunction name="fnProcesoNuevoExterno" access="public" returntype="string" output="no">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="IdProceso" 			type="numeric" required="yes">
	<cfargument name="UsuarioDbInclusion"	type="string" required="yes">
	
	<cfreturn fnProcesoNuevo (Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.UsuarioDbInclusion,"EXTERNO","","")>
</cffunction>

<cffunction name="fnProcesoNuevoExternoXML" output="no" access="public" returntype="struct">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="UsuarioDbInclusion"	type="string" required="yes">

	<cfset var LvarRetXML = structNew()>
	
	<cfset GvarCE = session.CEcodigo>
	<cfset GvarNI = Arguments.NumeroInterfaz>
	<cfset GvarID = 0>
	<cfset GvarSR = 0>

	<cfset GvarXML_IE	= url.XML_IE>
	<cfset GvarXML_ID	= url.XML_ID>
	<cfset GvarXML_IS	= url.XML_IS>
	<cfset url.XML_IE = "">
	<cfset url.XML_ID = "">
	<cfset url.XML_IS = "">

	<cfset GvarXML_OE = "">
	<cfset GvarXML_OD = "">
	<cfset GvarXML_OS = "">

	<cftry>
		<cfset rsInterfaz = fnVerificaInterfaz(GvarNI, "EXTERNO_XML")>
		<cfset GvarMD = rsInterfaz.manejoDatos>
		<cfset GvarTP = rsInterfaz.tipoProcesamiento>
		<cfset LvarRetXML.ID  = GvarID>
		<cfset LvarRetXML.ManejoDatos = GvarMD>
	
		<cfif rsInterfaz.TipoProcesamiento EQ "D">
			<cfset LvarRetXML.ID		= "0">
			<cfset LvarRetXML.MSG		= fnProcesoNuevoExternoXML_Directa (rsInterfaz.Componente, Arguments.UsuarioDbInclusion, rsInterfaz.eMailErrores)>
			<cfset LvarRetXML.XML_OE	= GvarXML_OE>
			<cfset LvarRetXML.XML_OD	= GvarXML_OD>
			<cfset LvarRetXML.XML_OS	= GvarXML_OS>
		<cfelse>
			<cfset LvarRetXML.ID		= fnCrearProcesoXML ()>
			<cfset LvarRetXML.MSG		= fnProcesoNuevo (Arguments.NumeroInterfaz, GvarID, Arguments.UsuarioDbInclusion,"EXTERNO_XML","","")>
			<cfset LvarRetXML.XML_OE	= GvarXML_OE>
			<cfset LvarRetXML.XML_OD	= GvarXML_OD>
			<cfset LvarRetXML.XML_OS	= GvarXML_OS>
		</cfif>
	<cfcatch type="any">
		<cfquery name="rsInterfaz" datasource="sifinterfaces">
			select ManejoDatos
			  from Interfaz
			 where NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
		</cfquery>
		<cfset GvarMD 					= rsInterfaz.ManejoDatos>
		<cfset LvarRetXML.ManejoDatos 	= GvarMD>
		<cfset LvarRetXML.ID			= fnCrearProcesoXML ()>
		<cfif fnIsBug(cfcatch)>
			<cfset LvarMSGstackTrace = fnGetStackTrace(cfcatch)>
			<cfset LvarRetXML.MSG = "ERROR DE EJECUCION">
			<cfset fnProcesoNuevoConError (GvarNI,GvarID,Arguments.UsuarioDbInclusion,"E",LvarRetXML.MSG,LvarMSGstackTrace)>
		<cfelse>
			<cfset LvarRetXML.MSG = "ERROR ANTES DE INICIAR LA INTERFAZ (PNEX): #cfcatch.Message# #cfcatch.Detail#">
			<cfset fnProcesoNuevoConError (GvarNI,GvarID,Arguments.UsuarioDbInclusion,"E",LvarRetXML.MSG)>
		</cfif>
	</cfcatch>
	</cftry>

	<cfreturn LvarRetXML>
</cffunction>

<cffunction name="fnProcesoNuevoExternoXML_Directa" access="private" returntype="string" output="no">
	<cfargument name="Componente"			type="string" required="yes">
	<cfargument name="UsuarioDbInclusion"	type="string" required="yes">
	<cfargument name="eMailErrores"			type="string" required="no" default="">

	<cfset var LvarMSG = "">
	<cftry>
		<cfset LvarID = GetTickCount()>
		<cfset fnLog("D_AP","ID=DIRECTA(#LvarID#), Interfaz=#GvarNI#, Activar Proceso Directo")>
		<cfset sbEjecutarComponente(Arguments.Componente, "", "")>
		<cfset fnLog("D_FP","ID=DIRECTA(#LvarID#), Interfaz=#GvarNI#, Resultado OK")>
		<cfreturn "OK">
	<cfcatch type="any">
		<cfif fnIsBug(cfcatch)>
			<!--- 
				Registra el Proceso por dar ERROR DE EJECUCION:
					Crea un ID de proceso y lo registra en InterfazBitacoraProcesos
					Guarda los Datos de Entrada XML_IE,XML_ID,XML_IS en InterfazDatosXML 
			--->
			<cfset LvarRetXML.ID = fnCrearProcesoXML()>
			<cfset LvarMSGstackTrace = fnGetStackTrace(cfcatch)>
			<cfset LvarMSGstackTrace = replacenocase(LvarMSGstackTrace,"<BR>"," | ","ALL")>
			<cfset LvarPto = find("|",LvarMSGstackTrace)>
			<cfset LvarMSGstackTrace = "ERROR DE EJECUCION: " & mid(LvarMSGstackTrace,LvarPto + 2,1000)>
			<cfset LvarPto = findnocase(" | ",LvarMSGstackTrace, LvarPto+1)>
			<cfset LvarMSG = mid(LvarMSGstackTrace,1,LvarPto) & "| (Ver en la Bitácora de Procesos Finalizados de la Consola de Administración de Interfaces: Proceso ID=#GvarID#)">

			<cfset fnLog("","ID=DIRECTA(#LvarID#), ID=#GvarID#, Interfaz=#GvarNI#, ERROR DE EJECUCION, StackTrace=#LvarMSGstackTrace#", Arguments.eMailErrores)>

			<cfset fnProcesoNuevoConError(GvarNI, GvarID, Arguments.UsuarioDbInclusion, "E", LvarMSG, LvarMSGstackTrace)>
			<cfquery datasource="sifinterfaces">
				delete from InterfazDatosXML 
				 where CEcodigo			= #GvarCE#
				   and NumeroInterfaz	= #GvarNI#
				   and IdProceso		= #GvarID#
				   and TipoIO			= 'I'
			</cfquery>
			<cfquery datasource="sifinterfaces">
				insert into InterfazDatosXML 
						(
							CEcodigo, NumeroInterfaz, IdProceso, TipoIO, BMUsucodigo,
							XML_E, XML_D, XML_S
						)
					values (
							  #GvarCE#, #GvarNI#, #GvarID#, 'I', #session.Usucodigo#
							, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_IE,'utf-8')#" null="#GvarXML_IE EQ ''#">
							, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_ID,'utf-8')#" null="#GvarXML_ID EQ ''#">
							, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_IS,'utf-8')#" null="#GvarXML_IS EQ ''#">
						)
			</cfquery>
		<cfelse>
			<cfset LvarMSGstackTrace = "">
			<cfset LvarMSG = "#cfcatch.Message# #cfcatch.Detail#">
			<cfset fnLog("D_FP","ID=DIRECTA(#LvarID#), Interfaz=#GvarNI#, ERROR: #LvarMSG#", Arguments.eMailErrores)>
		</cfif>
		<cfreturn LvarMSG>
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="fnCrearProcesoXML" access="private" returntype="numeric" output="no">
	<cfset GvarID  = fnSiguienteIdProceso()>

	<cfif GvarMD EQ "T">
		<cfset sbGeneraXMLtoTabla(GvarNI, GvarID, "I", "E")>
		<cfset sbGeneraXMLtoTabla(GvarNI, GvarID, "I", "D")>
		<cfset sbGeneraXMLtoTabla(GvarNI, GvarID, "I", "S")>
	<cfelse>
		<cfquery datasource="sifinterfaces">
			delete from InterfazDatosXML 
			 where CEcodigo			= #GvarCE#
			   and NumeroInterfaz	= #GvarNI#
			   and IdProceso		= #GvarID#
			   and TipoIO			= 'I'
		</cfquery>
		<cfquery datasource="sifinterfaces">
			insert into InterfazDatosXML 
					(
						CEcodigo, NumeroInterfaz, IdProceso, TipoIO, BMUsucodigo,
						XML_E, XML_D, XML_S
						
					)
				values (
						  #GvarCE#, #GvarNI#, #GvarID#, 'I', #session.Usucodigo#
						, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_IE,'utf-8')#" null="#GvarXML_IE EQ ''#">
						, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_ID,'utf-8')#" null="#GvarXML_ID EQ ''#">
						, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_IS,'utf-8')#" null="#GvarXML_IS EQ ''#">
					)
		</cfquery>
	</cfif>	
	
	<cfreturn GvarID>
</cffunction>

<cffunction name="fnProcesoNuevoSoin" access="public" returntype="string" output="no">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="ParametrosSOIN"		type="string" required="yes">
	<cfargument name="TipoMovimientoSOIN"	type="string" required="yes">
	
	<cfreturn "OK">
	<cfif not isdefined("Application.dsinfo.sifinterfaces")>
	</cfif>
	<cfreturn fnProcesoNuevo (Arguments.NumeroInterfaz,fnSiguienteIdProceso(),session.Usulogin,"SOIN",Arguments.ParametrosSOIN,Arguments.TipoMovimientoSOIN)>
</cffunction>

<cffunction name="fnSiguienteIdProceso" access="public" returntype="numeric" output="no">
	<cfset LvarIdProceso = 0>
	<cfif Application.dsinfo.sifinterfaces.type EQ "sybase">
		<cfquery name="rsSQL" datasource="sifinterfaces">
			exec S_IdProceso_Nextval
		</cfquery>
		<cfset LvarIdProceso = rsSQL.ID>
	<cfelseif Application.dsinfo.sifinterfaces.type EQ "sqlserver">
		<cfquery name="rsSQL" datasource="sifinterfaces">
			exec S_IdProceso_Nextval
		</cfquery>
		<cfset LvarIdProceso = rsSQL.ID>
	<cfelseif Application.dsinfo.sifinterfaces.type EQ "oracle">
		<cfquery name="rsSQL" datasource="sifinterfaces">
			SELECT S_IDPROCESO.NEXTVAL as ID FROM DUAL
		</cfquery>
		<cfset LvarIdProceso = rsSQL.ID>
	<cfelseif Application.dsinfo.sifinterfaces.type EQ "db2">
		<cfquery name="countSEQ" datasource="sifinterfaces">
			select COUNT(1) SEQ from syscat.sequences where SEQNAME = 'S_IDPROCESO'
		</cfquery>
		<cfif countSEQ.SEQ EQ 0>
			<cfquery datasource="sifinterfaces">
				CREATE SEQUENCE  S_IDPROCESO
				 START WITH  1
				 INCREMENT BY  1
				 NO MAXVALUE 
				 NO CYCLE 
			</cfquery>	
		</cfif>
		<cfquery name="rsSQL" datasource="sifinterfaces">
			SELECT S_IDPROCESO.NEXTVAL as ID FROM DUAL
		</cfquery>
		<cfset LvarIdProceso = rsSQL.ID>
	<cfelse>
		<cfthrow message="Base de datos #Application.dsinfo.sifinterfaces.type# no implementada">
	</cfif>
	<cfreturn LvarIdProceso>
</cffunction>

<cffunction name="fnProcesoNuevo" access="private" returntype="string" output="no">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="IdProceso" 			type="numeric" required="yes">
	<cfargument name="UsuarioDbInclusion"	type="string" required="yes">
	<cfargument name="TipoInvocacion"		type="string" required="yes">
	<cfargument name="ParametrosSOIN"		type="string" required="yes">
	<cfargument name="TipoMovimientoSOIN"	type="string" required="yes">

	<cfset var LvarMSG = "OK">

	<cftry>
		<cfset rsMotor = fnActivarMotor (session.CEcodigo)>
		<cfquery name="rsProceso" datasource="sifinterfaces">
			select count(1) as cantidad
			  from InterfazColaProcesos
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
			   and IdProceso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
		</cfquery>
		<cfif rsProceso.cantidad GT 0>
			<cfthrow message="Proceso '#Arguments.IdProceso#' de la Interfaz '#Arguments.NumeroInterfaz#' ya fue incluido en la Cola de Procesos">
		</cfif>
	
		<cfquery name="rsProceso" datasource="sifinterfaces">
			select count(1) as cantidad
			  from InterfazBitacoraProcesos
			 where CEcodigo 		= #Session.CEcodigo#
			   and NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
			   and IdProceso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
			   and StatusProceso <> 12
		</cfquery>
		<cfif rsProceso.cantidad GT 0>
			<cfthrow message="Proceso '#Arguments.IdProceso#' de la Interfaz '#Arguments.NumeroInterfaz#' ya fue incluido y finalizado en la Cola de Procesos">
		</cfif>

		<cfif Arguments.TipoInvocacion NEQ "EXTERNO_XML">		
			<cfset rsInterfaz = fnVerificaInterfaz(Arguments.NumeroInterfaz, Arguments.TipoInvocacion)>	
		</cfif>
		<cfquery datasource="sifinterfaces">
			insert into InterfazColaProcesos
				(
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso,
					SecReproceso,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					StatusProceso, 
					UsucodigoInclusion, 
					UsuarioBdInclusion, 
					FechaInclusion,
					FechaInicioProceso
					<cfif rsInterfaz.OrigenInterfaz EQ "S">
					, ParametrosSOIN, TipoMovimientoSOIN
					</cfif>
				)
			values (
				 #session.CEcodigo#
				,<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#NumeroInterfaz#">
				,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IdProceso#">
				,0
				,#session.EcodigoSDC#
				,'#rsInterfaz.OrigenInterfaz#'
				,'#rsInterfaz.TipoProcesamiento#'
				,<cfif rsInterfaz.TipoProcesamiento EQ "A">1<cfelse>2</cfif>
				,#session.Usucodigo#
				,<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#UsuarioDbInclusion#">
				,<cf_dbfunction name="now" datasource="sifinterfaces">
				,<cfif rsInterfaz.TipoProcesamiento EQ "A">
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">
				 <cfelse>
					<cf_dbfunction name="now" datasource="sifinterfaces">
				 </cfif>
				<cfif rsInterfaz.OrigenInterfaz EQ "S">
					, <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#ParametrosSOIN#">
					, <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#TipoMovimientoSOIN#">
				</cfif>
				)
		</cfquery>
	<cfcatch type="any">
		
		<cfif fnIsBug(cfcatch)>
			<cfset LvarMSGstackTrace = fnGetStackTrace(cfcatch)>
			<cfset LvarMSG = "ERROR DE EJECUCION">
			<cfset fnProcesoNuevoConError (Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.UsuarioDbInclusion,"E",LvarMSG,LvarMSGstackTrace)>
		<cfelse>
			<cfset LvarMSG = "ERROR ANTES DE INICIAR LA INTERFAZ (PN): #cfcatch.Message# #cfcatch.Detail#">
			<cfset fnProcesoNuevoConError (Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.UsuarioDbInclusion,"E",LvarMSG)>
		</cfif>
	</cfcatch>
	</cftry>

	<cfif LvarMSG EQ "OK">
		<cfif rsInterfaz.TipoProcesamiento EQ "S">
			<!------------------------------------ PROCESAMIENTO SINCRONICO --------------------------------------->
			<cfset LvarMSG = fnActivarProceso	(session.CEcodigo, Arguments.NumeroInterfaz, Arguments.IdProceso, '0', rsInterfaz.Componente, 'S', rsInterfaz.ManejoDatos, '', '', -1,-1, rsInterfaz.eMailErrores, rsInterfaz.CG)> 
		<cfelse>
			<!------------------------------------ PROCESAMIENTO ASINCRONICO --------------------------------------->
			<cfif rsInterfaz.TipoRetardo EQ "M" AND rsInterfaz.MinutosRetardo EQ 0>
				<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 y Retardo = 0 (Inactivo, Solicitud de Procesamiento inmediato, se invoca la Cola de la Interfaz #Arguments.NumeroInterfaz#)")>
				<cfset sbInvocar_ActivarInterfaz (rsMotor.urlServidorMotor, session.CEcodigo, Arguments.NumeroInterfaz)>
			<cfelseif rsInterfaz.TipoRetardo EQ "M">
				<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 (Inactivo, Solicitud de Procesamiento, Retardo=#rsInterfaz.MinutosRetardo# minutos)")>
			<cfelse>
				<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 (Inactivo, Solicitud de Procesamiento, Retardo=hasta las #int(rsInterfaz.MinutosRetardo/60)#:#int(rsInterfaz.MinutosRetardo mod 60)#)")>
			</cfif>
		</cfif>
	</cfif>
	
	<cfreturn LvarMSG>
</cffunction>

<cffunction name="fnVerificaInterfaz" access="public" returntype="query" output="no">
	<cfargument name="NumeroInterfaz" 	type="numeric"	required="yes">
	<cfargument name="TipoInvocacion"	type="string" 	required="yes">

	<cfquery name="rsInterfaz" datasource="sifinterfaces">
		select i.Descripcion,
			   i.OrigenInterfaz,
			   i.TipoProcesamiento,
			   i.ManejoDatos,
			   i.Componente,
			   i.Activa,
			   i.TipoRetardo, 
			   coalesce(i.MinutosRetardo,0) as MinutosRetardo,
			   i.eMailErrores,
			   case when i.TipoProcesamiento = 'A' then 1 else 0 end as CG
		  from Interfaz i
		 where i.NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
	</cfquery>

	<cfif Arguments.TipoInvocacion EQ "SOIN">
		<cfif rsInterfaz.OrigenInterfaz NEQ "S">
			<cfthrow message="Interfaz '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#' no esta definida como Interfaz de SOIN hacia sistemas Externos en los parámetros del Sistema">
		<cfelseif rsInterfaz.TipoProcesamiento NEQ "A">
			<cfthrow message="ERROR DE PARAMETRIZACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': OrigenInterfaz='S-SOIN interna' sólo puede tener TipoProcesamiento='A-Asíncrono'">
		<cfelseif rsInterfaz.ManejoDatos NEQ "T">
			<cfthrow message="ERROR DE PARAMETRIZACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': OrigenInterfaz='S-SOIN interna' sólo puede tener ManejoDatos='T-Por Tablas'">
		</cfif>
	<cfelse>
		<cfif rsInterfaz.recordCount EQ 0>
			<cfthrow message="Interfaz '#Arguments.NumeroInterfaz#' no esta definida en los parámetros del Sistema">
		<cfelseif rsInterfaz.Activa NEQ 1>
			<cfthrow message="Interfaz '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#' no esta Activa en los parámetros del Sistema">
		<cfelseif rsInterfaz.OrigenInterfaz NEQ "E">
			<cfthrow message="Interfaz '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#' no esta definida como Interfaz Externa en los parámetros del Sistema">
		<cfelseif rsInterfaz.TipoProcesamiento EQ "D" and rsInterfaz.ManejoDatos NEQ "V">
			<cfthrow message="ERROR DE PARAMETRIZACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': TipoProcesamiento='D-Sincrónico Directo' sólo puede tener ManejoDatos='V-Por Variables de Memoria'">
		</cfif>
		<cfif Arguments.TipoInvocacion EQ "EXTERNO">
			<cfif rsInterfaz.TipoProcesamiento EQ "D">
				<cfthrow message="ERROR DE INVOCACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': Al invocar una Interfaz Sincrónica Directa se debe utilizar el WebService XML">
			<cfelseif rsInterfaz.ManejoDatos EQ "V">
				<cfthrow message="ERROR DE INVOCACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': Al invocar una Interfaz con ManejoDatos='V-por Variables de Memoria' se debe utilizar el WebService XML, porque es la única menera de enviar los datos de entrada">
			</cfif>
		<cfelseif Arguments.TipoInvocacion EQ "EXTERNO_XML">
			<cfif rsInterfaz.TipoProcesamiento EQ "A" and url.XML_OUT EQ "1">
				<cfthrow message="ERROR DE INVOCACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': Al invocar una Interfaz Asincrona utilizando el WebService XML no se puede indicar que devuelva datos por XML (XML_OUT debe ser 0) porque los datos se generan posterior a la invocación">
			<cfelseif rsInterfaz.TipoProcesamiento EQ "D" and url.XML_OUT EQ "0">
				<cfthrow message="ERROR DE INVOCACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': Al invocar una Interfaz Sincrónica Directa por el WebService XML se debe indicar que se devuelvan los datos por XML (XML_OUT debe ser 1), porque los datos de salida no se almacenan en la base de datos">
			<cfelseif rsInterfaz.ManejoDatos EQ "V" and url.XML_DBS EQ "1">
				<cfthrow message="ERROR DE INVOCACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': Al invocar una Interfaz con ManejoDatos='V-por Variables de Memoria' no se puede utilizar el WebService SQL, porque no existen las tablas de datos">
			</cfif>
		<cfelse>
			<cfthrow message="ERROR DE INVOCACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': Tipo de Invocación '#Arguments.TipoInvocacion#' no ha sido implementado">
		</cfif>
	</cfif>

	<cfif NOT fileExists(expandPath(rsInterfaz.Componente))>
		<cfthrow message="ERROR DE PARAMETRIZACIÓN DE INTERFAZ '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#': No existe el fuente del Componente para el procesamiento de la Interfaz '#rsInterfaz.Componente#'">
	</cfif>

	<cfreturn rsInterfaz>
</cffunction>

<cffunction name="fnProcesoNuevoConError" access="public" output="no">
	<cfargument name="NumeroInterfaz" 	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="UidDataBase" 		type="string" required="yes">
	<cfargument name="OrigenInterfaz" 	type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">

	<cfset var LvarMSG = "">

<!---
	<cfset fnLog("ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, BEGIN")>
	<cfif Arguments.MSGstackTrace NEQ ""><cfset LvarMSG=Arguments.MSGstackTrace><cfelse><cfset LvarMSG=Arguments.MSG></cfif>
	<cfset LvarStatus="12 (Error antes de iniciar la interfaz)">
	<cfset fnLog("ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=#LvarStatus#, MSG=#LvarMSG#")>
	<cfset fnLogDatos ("I", Arguments.IdProceso, Arguments.NumeroInterfaz)>
	<cfset fnLog("ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, END")>
--->

	<cfset LvarMSG = trim(Arguments.MSG)>
	
 	<cfquery datasource="#session.dsn#">
		insert into 
		<cf_dbdatabase table="InterfazBitacoraProcesos" datasource="sifinterfaces">
		    (
				CEcodigo,
				NumeroInterfaz,
				IdProceso,
				SecReproceso,
				EcodigoSDC,
				OrigenInterfaz,
				TipoProcesamiento,
				StatusProceso,
				FechaInclusion,
				UsucodigoInclusion,
				UsuarioBdInclusion,
				MsgError,
				MsgErrorCompleto,
				MsgErrorStack
			)
		values (
			 #session.CEcodigo#
			,#Arguments.NumeroInterfaz#
			,#Arguments.IdProceso#
			,999999
			,#session.EcodigoSDC#
			,'#Arguments.OrigenInterfaz#'
			,'0'
			,12
			,<cf_dbfunction name="now" datasource="sifinterfaces">
			,#session.Usucodigo#
			,<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.UidDataBase#">
			,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="255" value="#mid(LvarMSG,1,255)#">
			,	<cfif len(LvarMSG) LTE 255>
                	null
                <cfelse>
					<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#LvarMSG#">
                </cfif>
			,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#" null="#Arguments.MSGstackTrace EQ ''#">
			)
	</cfquery>
</cffunction>



<cffunction name="fnActivarProceso" access="public" returntype="string" output="no">
	<cfargument name="CEcodigo" 			type="numeric"	required="yes">
	<cfargument name="NumeroInterfaz"		type="numeric" 	required="yes">
	<cfargument name="IdProceso"			type="numeric" 	required="yes">
	<cfargument name="SecReproceso"			type="numeric" 	required="yes">
	<cfargument name="Componente"			type="string" 	required="yes">
	<cfargument name="TipoProcesamiento"	type="string" 	required="yes">
	<cfargument name="ManejoDatos"			type="string" 	required="yes">
	<cfargument name="ParametrosSOIN"		type="string" 	required="yes">
	<cfargument name="TipoMovimientoSOIN"	type="string" 	required="yes">

	<cfargument name="EcodigoSDC" 			type="numeric"	default="-1">
	<cfargument name="UsucodigoInclusion"	type="numeric"	default="-1">
	<cfargument name="eMailErrores"			type="string"	default="">
	<cfargument name="CG"					type="numeric"	default="0">

	<cfset var LvarMSG = "OK">

	<cfset GvarCE = Arguments.CEcodigo>
	<cfset GvarNI = Arguments.NumeroInterfaz>
	<cfset GvarID = Arguments.IdProceso>
	<cfset GvarSR = Arguments.SecReproceso>
	<cfset GvarMD = Arguments.ManejoDatos>
	<cfset GvarTP = Arguments.TipoProcesamiento>

	<cftry>
		<cfif Arguments.TipoProcesamiento EQ "S">
			<cfset fnLog("S_AP","ID=#GvarID#, Interfaz=#GvarNI#, Status=2 (Activación de Proceso Sincrónico)")>
			<cfif Arguments.ManejoDatos NEQ "T">
				<cfset GvarXML_OE = "">
				<cfset GvarXML_OD = "">
				<cfset GvarXML_OS = "">
			</cfif>
		<cfelse>
			<cfif Arguments.EcodigoSDC EQ -1 OR Arguments.UsucodigoInclusion EQ -1>
				<cfthrow message="Los parámetros EcodigoSDC y UsucodigoInclusion son obligatorios en fnActivarProceso cuando la Interfaz es Asincrónica">
			</cfif>
			<cfset fnLog("A_AP","ID=#GvarID#, Interfaz=#GvarNI#, Status=2 (Activación de Proceso Asincrónico)")>
			<cfquery datasource="sifinterfaces">
				update InterfazColaProcesos
				   set StatusProceso = 2
					 , FechaInicioProceso = <cf_dbfunction name="now" datasource="sifinterfaces">
				 where CEcodigo 		= #GvarCE#
				   and NumeroInterfaz	= #GvarNI#
				   and IdProceso		= #GvarID#
				   and SecReproceso		= #GvarSR#
				   and StatusProceso	= 1
			</cfquery>
			<cfset sbIniciarSession (Arguments.CEcodigo, Arguments.EcodigoSDC, Arguments.UsucodigoInclusion)>
			<cfif Arguments.ManejoDatos NEQ "T">
				<cfquery name="rsSQL" datasource="sifinterfaces">
					select XML_E, XML_D, XML_S
					  from InterfazDatosXML
					 where CEcodigo			= #GvarCE#
					   and NumeroInterfaz	= #GvarNI#
					   and IdProceso		= #GvarID#
					   and TipoIO			= 'I'
				</cfquery>
				<cfset GvarXML_IE = "">
				<cfset GvarXML_ID = "">
				<cfset GvarXML_IS = "">
				<cfif len(rsSQL.XML_E) GT 0>
					<cfset GvarXML_IE = CharsetEncode(rsSQL.XML_E,"utf-8")>
				</cfif>
				<cfif len(rsSQL.XML_D) GT 0>
					<cfset GvarXML_ID = CharsetEncode(rsSQL.XML_D,"utf-8")>
				</cfif>
				<cfif len(rsSQL.XML_S) GT 0>
					<cfset GvarXML_IS = CharsetEncode(rsSQL.XML_S,"utf-8")>
				</cfif>
				<cfset GvarXML_OE = "">
				<cfset GvarXML_OD = "">
				<cfset GvarXML_OS = "">
			</cfif>
		</cfif>

		<cfset sbEjecutarComponente(Arguments.Componente, Arguments.ParametrosSOIN, Arguments.TipoMovimientoSOIN, Arguments.CG)>

		<cfif Arguments.ManejoDatos NEQ "T">
			<cfquery datasource="sifinterfaces">
				delete from InterfazDatosXML 
				 where CEcodigo			= #GvarCE#
				   and NumeroInterfaz	= #GvarNI#
				   and IdProceso		= #GvarID#
				   and TipoIO			= 'O'
			</cfquery>
			<cfquery datasource="sifinterfaces">
				insert into InterfazDatosXML 
						(
							CEcodigo, NumeroInterfaz, IdProceso, TipoIO, BMUsucodigo,
							XML_E, XML_D, XML_S
						)
					values (
							  #GvarCE#, #GvarNI#, #GvarID#, 'O', #session.Usucodigo#
							, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_OE,'utf-8')#" null="#GvarXML_OE EQ ''#">
							, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_OD,'utf-8')#" null="#GvarXML_OD EQ ''#">
							, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_OS,'utf-8')#" null="#GvarXML_OS EQ ''#">
						)
			</cfquery>
		</cfif>

		<cfif Arguments.TipoProcesamiento EQ "S">
			<cfset fnLog("S_FP","ID=#GvarID#, Interfaz=#GvarNI#, Status=10 (Finalizado con Exito)")>
		<cfelse>
			<cfset sbProcesoSpFinal (GvarCE, GvarNI, GvarID, GvarSR)>

			<cfset fnLog("A_FP","ID=#GvarID#, Interfaz=#GvarNI#, Status=10 (Finalizado con Exito)")>
		</cfif>
		<cfset fnProcesoFinalizarConExito (GvarNI,GvarID,GvarSR)>
	<cfcatch type="any">
		<cfif fnIsBug(cfcatch)>
			<cfset LvarMSGstackTrace = fnGetStackTrace(cfcatch)>
			<cfset LvarMSG = "ERROR DE EJECUCION">
			<cfset fnLog("","ID=#GvarID#, Interfaz=#GvarNI#, #LvarMSG#, StackTrace=#LvarMSGstackTrace#", Arguments.eMailErrores)>
		<cfelse>
			<cfset LvarMSGstackTrace = "">
			<cfset LvarMSG = "#cfcatch.Message# #cfcatch.Detail#">
		</cfif>

		<cfif Arguments.TipoProcesamiento EQ "S">
			<!--- Los datos en las Tablas IE, ID, IS en procesamiento Sincrónico estan:
					En Oracle: fijos porque fueron grabados en una transaccion autónoma
					En Sybase y SQLserver: van a desaparecer en el rollback de la transaccion con Error
			--->
			<cfif GvarMD EQ "T" AND application.dsinfo.sifinterfaces.type NEQ 'oracle'>
				<cftry>
					<cfset GvarXML_IE = sbGeneraTablaToXML (GvarNI, GvarID, "I", "E", "0", false)>
					<cfset GvarXML_ID = sbGeneraTablaToXML (GvarNI, GvarID, "I", "D", "0", false)>
					<cfset GvarXML_IS = sbGeneraTablaToXML (GvarNI, GvarID, "I", "S", "0", false)>
					<cfquery datasource="sifinterfaces">
						delete from InterfazDatosXML 
						 where CEcodigo			= #GvarCE#
						   and NumeroInterfaz	= #GvarNI#
						   and IdProceso		= #GvarID#
						   and TipoIO			= 'I'
					</cfquery>
					<cfquery datasource="sifinterfaces">
						insert into InterfazDatosXML 
								(
									CEcodigo, NumeroInterfaz, IdProceso, TipoIO, BMUsucodigo,
									XML_E, XML_D, XML_S
								)
							values (
								  	  #GvarCE#, #GvarNI#, #GvarID#, 'I', #session.Usucodigo#
									, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_IE,'utf-8')#" null="#GvarXML_IE EQ ''#">
									, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_ID,'utf-8')#" null="#GvarXML_ID EQ ''#">
									, <cfqueryparam cfsqltype="cf_sql_BLOB" value="#CharsetDecode(GvarXML_IS,'utf-8')#" null="#GvarXML_IS EQ ''#">
								)
					</cfquery>
				<cfcatch type="any">
					<cfset fnLog("","ID=#GvarID#, Interfaz=#GvarNI#, (Error al guardar los datos en InterfazDatosXML, Interfaz Sincrónica en Sybase), ERROR=#cfcatch.Message#")>
				</cfcatch>
				</cftry>
			</cfif>
			<cfset fnLog("S_FP","ID=#GvarID#, Interfaz=#GvarNI#, Status=11 (Finalizado con Error), ERROR=#LvarMSG#", Arguments.eMailErrores)>
			<cfset fnProcesoFinalizarConError (GvarNI,GvarID,GvarSR,LvarMSG,LvarMSGstackTrace)>
		<cfelseif cfcatch.Type EQ "spFinal">
			<cfset fnLog("A_FP","ID=#GvarID#, Interfaz=#GvarNI#, Status=5 (Finalizado con Exito, Error en spFinal, se mantiene pendiente el spFinal), ERROR=#LvarMSG#", Arguments.eMailErrores)>
		<cfelse>
			<cfset fnLog("A_FP","ID=#GvarID#, Interfaz=#GvarNI#, Status=3 (Finalizado con Error, se mantiene pendiente), ERROR=#LvarMSG#", Arguments.eMailErrores)>
			<cfset fnProcesoPendienteConError (GvarNI,GvarID,GvarSR,LvarMSG,LvarMSGstackTrace)>
		</cfif>
	</cfcatch>
	</cftry>

	<cfreturn LvarMSG>
</cffunction>
 
<cffunction name="sbEjecutarComponente" access="private" returntype="string" output="no">
	<cfargument name="Componente"			type="string" 	required="yes">
	<cfargument name="ParametrosSOIN"		type="string" 	required="yes">
	<cfargument name="TipoMovimientoSOIN"	type="string" 	required="yes">
	<cfargument name="CG"					type="numeric"	default="0">

	<cfset var LvarExisteErr = false>

	<cfset StructClear(url)>
	<cfloop index="LvarParms" list="#Arguments.ParametrosSOIN#" delimiters="&">
		<cfset LvarParm = listToArray(LvarParms,"=")>
		<cfif arrayLen(LvarParm) EQ 2>
			<cfset url[LvarParm[1]] = URLDecode(LvarParm[2])>
		</cfif>
	</cfloop>
	<cfparam name="url.ID"				default="#GvarID#">
	<cfparam name="url.MODO"			default="#Arguments.TipoMovimientoSOIN#">
	<cfparam name="url._soinInterfaz__"	default="#url.ID#">

	<cftry>
		<cfquery datasource="sifinterfaces">
			delete from ERR#GvarNI# where ID = #GvarID# and IDERR > 0
		</cfquery>
		<cfset LvarExisteERR = true>
	<cfcatch type="database">
		<cfset LvarExisteERR = false>
	</cfcatch>
	</cftry>

	<cfsetting requesttimeout="36000">

	<cflock name="fnInclude" timeout="5" type="exclusive">
		<cfif not fileExists("interfacesInclude_#GvarNI#.cfc")>
			<cffile action="copy" source="#expandPath('/interfacesSoin/Componentes/interfacesInclude.cfc')#" destination="#expandPath('/interfacesSoin/Componentes/interfacesInclude_#GvarNI#.cfc')#">
		</cfif>
	</cflock>
	<cfset LvarInclude = createobject("component","interfacesInclude_#GvarNI#")>
	<cfset sbSetVariables (LvarInclude.fnInclude(Arguments.Componente,variables))>
	<cfset LvarInclude = javacast("null",0)>
	<cfif Arguments.CG EQ 1>
		<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
		<cfset javaRT.gc()>
	</cfif>
		
	<cfif LvarExisteERR>
		<cfquery name="rsSQL" datasource="sifinterfaces">
			select count(1) as cantidad from ERR#GvarNI# where ID = #GvarID# and IDERR > 0
		</cfquery>
		<cfif rsSQL.cantidad GT 0>
			<cfthrow message="SE GENERARON DETALLE DE ERRORES que se deben visualizar en la Consola de Procesos de Interfaz. Proceso ID=#GvarID#.">
		</cfif>
	</cfif>
</cffunction>

<cffunction  name="sbSetVariables" access="private" returntype="void" output="no">
	<cfargument name="var" type="struct">
	<cfset var item = "">
	<cfloop collection="#Arguments.var#" item="item">
		<cfif ucase(left(item,4)) EQ "GVAR">
			<cfset variables[item] = Arguments.var[item]>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="sbReportarActividad" access="public" output="no">
	<cfargument name="NumeroInterfaz" 		type="string" required="yes">
	<cfargument name="IdProceso" 			type="string" required="yes">

	<cfset session.InterfazSoin.NI = Arguments.NumeroInterfaz>
	<cfset session.InterfazSoin.ID = Arguments.IdProceso>
	<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
		<!--- Application.interfazSoin[i][j]: Se usa con la hora del CF --->
		<cfset Application.interfazSoin["CE_#session.CEcodigo#"]["ID_#Arguments.IdProceso#"] = now()>
		<cfif isdefined("Application.InterfazSoin.CE_#session.CEcodigo#.ID_CAN_#Arguments.IdProceso#")>
			<cfset LvarMSG = Application.InterfazSoin["CE_#session.CEcodigo#"]["ID_CAN_#Arguments.IdProceso#"]>
			<cfthrow message="#LvarMSG#">
		</cfif>
	</cflock>
	<cfreturn>
</cffunction>

<cffunction name="fnProcesoPendienteConError" access="public" output="no">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">

	<cfset LvarMSG = Arguments.MSG>
	<cfquery datasource="sifinterfaces">
		update InterfazColaProcesos
		   set StatusProceso = 3
			 , FechaFinalProceso = <cf_dbfunction name="now" datasource="sifinterfaces">
			 , MsgError			= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#mid(LvarMSG,1,255)#">
			 , MsgErrorCompleto	= <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#LvarMSG#" null="#len(LvarMSG) LTE 255#">
			 <cfif Arguments.MSGstackTrace NEQ "">
			 , MsgErrorStack	 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#">
			 </cfif>
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
		   and IdProceso		= #Arguments.IdProceso#
		   and SecReproceso		= #Arguments.SecReproceso#
		   and StatusProceso 	= 2
	</cfquery>
	<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_#Arguments.IdProceso#")>
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_CAN_#Arguments.IdProceso#")>
	</cflock>
</cffunction>

<cffunction name="fnProcesoFinalizarConExito" access="public" output="no">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfset fnProcesoFinalizar(Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.SecReproceso, "10", "OK")>
</cffunction>

<cffunction name="fnProcesoFinalizarConError" access="public" output="no">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">
	<cfset fnProcesoFinalizar(Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.SecReproceso, "11", Arguments.MSG, Arguments.MSGstackTrace)>
</cffunction>

<cffunction name="fnProcesoFinalizar" access="private" output="no">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="StatusProceso"	type="string" required="yes">
	<!--- StatusProceso EQ "-1" equivale a Cancelar un Proceso --->
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">

	<cfif Arguments.StatusProceso EQ "-1">
		<cfquery name="rsCancelado" datasource="sifinterfaces">
			select 	UsucodigoCancela, 
					FechaCancelacion, 
					MsgCancelacion
			  from InterfazColaProcesosCancelar c
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
		</cfquery>
		<cfif rsCancelado.RecordCount EQ 0>
			<cfset Cancelar.Usucodigo = session.Usucodigo>
		</cfif>
	</cfif>

	<cftransaction>
		<cfif Arguments.StatusProceso NEQ "-1">
			<cfset LvarMSG = trim(Arguments.MSG)>
			<cfquery datasource="sifinterfaces">
				update InterfazColaProcesos
				   set StatusProceso 	= #Arguments.StatusProceso#
					 , MsgError			= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#mid(LvarMSG,1,255)#">
					 , MsgErrorCompleto	= <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#LvarMSG#" null="#len(LvarMSG) LTE 255#">
					 <cfif Arguments.MSGstackTrace NEQ "">
					 , MsgErrorStack	= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#">
					 </cfif>
				 where CEcodigo = #session.CEcodigo#
				   and NumeroInterfaz	= #Arguments.NumeroInterfaz#
				   and IdProceso		= #Arguments.IdProceso#
				   and SecReproceso		= #Arguments.SecReproceso#
			</cfquery>
		</cfif>

		<cfquery datasource="sifinterfaces">
			insert into InterfazBitacoraProcesos
				(
					CEcodigo,
					NumeroInterfaz,
					IdProceso,
					SecReproceso,
					EcodigoSDC,
					OrigenInterfaz,
					TipoProcesamiento,
					StatusProceso,
					FechaInclusion,
					UsucodigoInclusion,
					UsuarioBdInclusion,
					FechaInicioProceso,
					FechaFinalProceso,
					MsgError,
					MsgErrorCompleto,
					MsgErrorStack,
					ParametrosSOIN,
					TipoMovimientoSOIN
					<cfif Arguments.StatusProceso EQ "-1">
						,UsucodigoCancela, 
						FechaCancelacion, 
						MsgCancelacion
					</cfif>
				)
			select 
					p.CEcodigo,
					p.NumeroInterfaz,
					p.IdProceso,
					p.SecReproceso,
					p.EcodigoSDC,
					p.OrigenInterfaz,
					p.TipoProcesamiento,
					p.StatusProceso,
					p.FechaInclusion,
					p.UsucodigoInclusion,
					p.UsuarioBdInclusion,
					p.FechaInicioProceso,
					case 
						when p.FechaFinalProceso is not null
							then p.FechaFinalProceso 
						when p.FechaInicioProceso is not null
							then <cf_dbfunction name="now" datasource="sifinterfaces">
					end,
					p.MsgError,
					p.MsgErrorCompleto,
					p.MsgErrorStack,
					p.ParametrosSOIN,
					p.TipoMovimientoSOIN
					<cfif Arguments.StatusProceso EQ "-1">
						,#rsCancelado.UsucodigoCancela#, 
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsCancelado.FechaCancelacion#">,
						'#rsCancelado.MsgCancelacion#'
					</cfif>
			  from InterfazColaProcesos p
			 where p.CEcodigo 			= #session.CEcodigo#
			   and p.NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and p.IdProceso			= #Arguments.IdProceso#
		</cfquery>
		<cfquery datasource="sifinterfaces">
			delete from InterfazColaProcesosCancelar
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
		</cfquery>
		<cfquery datasource="sifinterfaces">
			delete from InterfazColaProcesos
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
		</cfquery>
	</cftransaction>
	
	<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_#Arguments.IdProceso#")>
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_CAN_#Arguments.IdProceso#")>
	</cflock>
</cffunction>

<cffunction name="sbProcesoSpFinal" access="public" output="no">
	<cfargument name="CEcodigo" 		type="numeric"	required="yes">
	<cfargument name="NumeroInterfaz"	type="string" 	required="yes">
	<cfargument name="IdProceso" 		type="string" 	required="yes">
	<cfargument name="SecReproceso"		type="string" 	required="yes">

	<cfset GvarCE = Arguments.CEcodigo>

	<cftry>
		<cfquery name="rsMotor" datasource="sifinterfaces">
			select spFinal, spFinalTipo
			  from InterfazMotor
			 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		</cfquery>

		<cfquery name="rsInterfaz" datasource="sifinterfaces">
			select spFinalTipo, spFinal, ManejoDatos, TipoProcesamiento
			  from Interfaz
			 where <!--- CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#"> and ---> 
					NumeroInterfaz = #Arguments.NumeroInterfaz#
		</cfquery>

		<cfif rsInterfaz.spFinalTipo NEQ "N">
			<cfif rsInterfaz.spFinalTipo EQ "D">
				<!--- Toma los parametros default del Motor --->
				<cfset LvarSpFinalTipo 		= rsMotor.spFinalTipo>
				<cfset LvarSpFinalNombre	= rsMotor.spFinal>
			<cfelseif rsInterfaz.spFinalTipo EQ "C">
				<!--- Tipo Coldfusion Particular --->
				<cfset LvarSpFinalTipo = "C">
				<cfset LvarSpFinalNombre	= rsInterfaz.spFinal>
				<cfif LvarSpFinalNombre EQ "">
					<cfthrow message="No se indicó el nombre del componente coldfusion">
				</cfif>
			<cfelse>
				<!--- Tipo StoreProcedure Particular --->
				<cfset LvarSpFinalTipo = "S">
				<cfset LvarSpFinalNombre	= rsInterfaz.spFinal>
				<cfif LvarSpFinalNombre EQ "">
					<cfthrow message="No se indicó el nombre del procedimiento almacenado en la base de datos">
				</cfif>
			</cfif>
			
			<cfif LvarSpFinalNombre NEQ "">
				<cfset fnLog("A_AP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Activando spFinal")>
				<cfif LvarSpFinalTipo EQ "C">
					<cfif NOT fileExists(expandPath(LvarSpFinalNombre))>
						<cfthrow message="No existe el fuente '#LvarSpFinalNombre#' del Componente Coldfusion spFinal">
					</cfif>
					<cfset GvarCE = Arguments.CEcodigo>
					<cfset GvarID = Arguments.IdProceso>
					<cfset GvarNI = Arguments.NumeroInterfaz>
					<cfset GvarSR = Arguments.SecReproceso>
					<cfset GvarMD = rsInterfaz.manejoDatos>
					<cfset GvarTP = rsInterfaz.tipoProcesamiento>
					<cfif GvarMD EQ "V" and not isdefined("GvarXML_OE")>
						<cfquery name="rsSQL" datasource="sifinterfaces">
							select XML_E, XML_D, XML_S
							  from InterfazDatosXML
							 where CEcodigo			= #GvarCE#
							   and NumeroInterfaz	= #GvarNI#
							   and IdProceso		= #GvarID#
							   and TipoIO			= 'O'
						</cfquery>
						<cfset GvarXML_OE = "">
						<cfset GvarXML_OD = "">
						<cfset GvarXML_OS = "">
						<cfif len(rsSQL.XML_E) GT 0>
							<cfset GvarXML_OE = CharsetEncode(rsSQL.XML_E,"utf-8")>
						</cfif>
						<cfif len(rsSQL.XML_D) GT 0>
							<cfset GvarXML_OD = CharsetEncode(rsSQL.XML_D,"utf-8")>
						</cfif>
						<cfif len(rsSQL.XML_S) GT 0>
							<cfset GvarXML_OS = CharsetEncode(rsSQL.XML_S,"utf-8")>
						</cfif>
					</cfif>

					<cflock name="fnInclude" timeout="5" type="exclusive">
						<cfif not fileExists("interfacesInclude_#GvarNI#_spFinal.cfc")>
							<cffile action="copy" source="#expandPath('/interfacesSoin/Componentes/interfacesInclude.cfc')#" destination="#expandPath('/interfacesSoin/Componentes/interfacesInclude_#GvarNI#_spFinal.cfc')#">
						</cfif>
					</cflock>
					<cfset LvarInclude = createobject("component","interfacesInclude_#GvarNI#_spFinal")>
					<cfset sbSetVariables (LvarInclude.fnInclude(LvarSpFinalNombre,variables))>
					<cfset LvarInclude = "">

				<cfelseif application.dsinfo.sifinterfaces.type EQ 'sybase'>
					<cfquery datasource="sifinterfaces" >
						set nocount on
						exec #LvarSpFinalNombre# #Arguments.NumeroInterfaz#, #Arguments.IdProceso#
					</cfquery>
				<cfelseif Application.dsinfo.sifinterfaces.type EQ "sqlserver">
					<cfquery datasource="sifinterfaces" >
						set nocount on
						exec #LvarSpFinalNombre# #Arguments.NumeroInterfaz#, #Arguments.IdProceso#
					</cfquery>
				<cfelseif application.dsinfo.sifinterfaces.type EQ 'oracle'>
					<cfstoredproc datasource="sifinterfaces" procedure="#LvarSpFinalNombre#" >
						<cfprocparam cfsqltype="cf_sql_numeric" value="#Arguments.NumeroInterfaz#">
						<cfprocparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
					</cfstoredproc>
				<cfelse>
					<cfthrow message="Tipo de Base de Datos no soportado en datasource='sifinterfaces'">
				</cfif>
			</cfif>
		</cfif>
	<cfcatch type="any">
		<cfset LvarMSG = "#cfcatch.Message# #cfcatch.Detail#">
		<cfset fnProcesoSpFinalConError (Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.SecReproceso,LvarMSG,"")>
		<cfthrow type="spFinal" message="#LvarMSG#">
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="fnProcesoSpFinalConError" access="public" output="no">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">

	<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_#Arguments.IdProceso#")>
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_CAN_#Arguments.IdProceso#")>
	</cflock>
	<cftry>
		<cfset LvarMSG = Arguments.MSG>
		<cfquery datasource="sifinterfaces">
			update InterfazColaProcesos
			   set StatusProceso = 5
				 , FechaFinalProceso = <cf_dbfunction name="now" datasource="sifinterfaces">
				 , MsgError			= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#mid(LvarMSG,1,255)#">
				 , MsgErrorCompleto	= <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#LvarMSG#" null="#len(LvarMSG) LTE 255#">
				 <cfif Arguments.MSGstackTrace NEQ "">
				 , MsgErrorStack	 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#">
				 </cfif>
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
			   and SecReproceso		= #Arguments.SecReproceso#
		</cfquery>
	<cfcatch type="any">
		<cftry>
			<cfset LvarPersisteError = false>
			<cfset LvarMSG = Arguments.MSG>
			<cfquery datasource="sifinterfaces">
				update InterfazColaProcesos
				   set StatusProceso = 5
					 , FechaFinalProceso = <cf_dbfunction name="now" datasource="sifinterfaces">
					 , MsgError			= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#mid(LvarMSG,1,255)#">
					 , MsgErrorCompleto	= <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#LvarMSG#" null="#len(LvarMSG) LTE 255#">
					 <cfif Arguments.MSGstackTrace NEQ "">
					 , MsgErrorStack	 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#">
					 </cfif>
				 where CEcodigo 		= #session.CEcodigo#
				   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
				   and IdProceso		= #Arguments.IdProceso#
				   and SecReproceso		= #Arguments.SecReproceso#
			</cfquery>
		<cfcatch type="any">
			<cfset LvarPersisteError = true>
		</cfcatch>
		</cftry>
		<cfif LvarPersisteError>
			<cfset fnLog("","CE=#session.CEcodigo#, ERROR EN SP_FINAL QUE NO SE PUDO ATRAPAR: #Arguments.MSG#")>
			<cfif Arguments.MSGstackTrace NEQ "">
				<cfset fnLog("","CE=#session.CEcodigo#, ERROR TRACE EN SP_FINAL: #Arguments.MSGstackTrace#")>
			</cfif>
	
			<cfthrow message="ERROR EN SP_FINAL QUE NO SE PUDO ATRAPAR (ver log de interfaces): #Arguments.MSG#. ERROR POR EL QUE NO SE PUDO ATRAPAR: #cfcatch.Message#">
		</cfif>
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="sbInvocar_ActivarInterfaz" access="public" output="no">
	<cfargument name="UrlServidor" 		type="string" required="yes">
	<cfargument name="CEcodigo" 		type="numeric" required="yes">
	<cfargument name="NumeroInterfaz"	type="numeric" required="yes">

	<cfset GvarCE = Arguments.CEcodigo>

	<cfset LvarTareaAsincrona = Arguments.UrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#Arguments.CEcodigo#&NI=#Arguments.NumeroInterfaz#">
	<cfhttp 	method		= "get"
				url			= "#LvarTareaAsincrona#"
				timeout		= "1"
				throwonerror="no"
	>
	</cfhttp>
</cffunction>

<cffunction name="fnXMLresponse" access="public" output="no" returntype="string">
	<cfargument name="TipoIO_Nivel"			type="string"  required="yes">
	<cfargument name="XML"					type="string"  required="yes">
	
	<cfif Arguments.XML EQ "">
		<cfreturn "">
	</cfif>
	
	<cfset LvarCrLn = chr(13) & chr(10)>
	<cfset LvarXMLresponse = '<response name="XML_#Arguments.TipoIO_Nivel#">'>
	<cfif findNoCase (LvarXMLresponse, trim(Arguments.XML)) EQ 1>
		<cfreturn Arguments.XML>
	</cfif>
	
	<cfreturn LvarXMLresponse & LvarCrLn & Arguments.XML & LvarCrLn & '</response>'>
</cffunction>

<cffunction name="sbGeneraTablaToXML" access="public" output="yes" returntype="string">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="IdProceso" 			type="numeric" required="yes">
	<cfargument name="TipoIO"				type="string"  required="yes">
	<cfargument name="Nivel"				type="string"  required="yes">
	<cfargument name="XML_DBS"				type="string"  required="yes">
	<cfargument name="forOutput"			type="string"  required="yes">

	<cfset LobjXML = "">
	<cfobject type = "Java"	action = "Create" class = "java.lang.StringBuffer" name = "LobjXML">

	<cftry>
		<cfset LvarTipoTabla = Arguments.TipoIO & Arguments.Nivel>
		<cfquery name="rsSQL" datasource="sifinterfaces">
			select * from #LvarTipoTabla##Arguments.NumeroInterfaz#
			 where ID = #Arguments.IdProceso#
		</cfquery>
		<cf_dbstruct name="#LvarTipoTabla##Arguments.NumeroInterfaz#" datasource="sifinterfaces">
		<cfset LvarCampos 	= valueList(rsStruct.name)>
		<cfset LvarCFtypes 	= valueList(rsStruct.cf_type)>
		<cfset LvarCrLn = chr(13) & chr(10)>

		<cfif Arguments.XML_DBS EQ "1">
			<cfset LobjXML.append ('  <dbstruct>').append(LvarCrLn)>
			<cfloop query="rsStruct">
				<cfset LobjXML.append ('    <column name="#rsStruct.name#" type="#rsStruct.cf_type#" len="#rsStruct.len#" ent="#rsStruct.ent#" dec="#rsStruct.dec#" mandatory="#rsStruct.mandatory#"/>').append(LvarCrLn)>
			</cfloop>
			<cfset LobjXML.append ('  </dbstruct>').append(LvarCrLn)>
		</cfif>
		<cfset LobjXML.append ('  <resultset rows="#rsSQL.recordCount#">').append(LvarCrLn)>
		<cfif Arguments.forOutput>
			<cfset LvarXML = "">
			<cfset LvarXML = LvarXML & '<!--' & LvarCrLn>
			<cfset LvarXML = LvarXML & '<response name="XML_#LvarTipoTabla#">' & LvarCrLn>
			<cfoutput>#LvarXML#</cfoutput>
			<cfoutput>#LobjXML.toString()#</cfoutput>
			<cfset LobjXML.setLength (0)>
		</cfif>
		<cfloop query="rsSQL">
			<cfset LobjXML.append ('    <row>').append(LvarCrLn)>
			<cfset LvarPto = 0>
			<cfloop index="LvarCampo" list="#LvarCampos#">
				<cfset LvarPto = LvarPto + 1>
				<cfset LvarCFType = listGetAt(LvarCFtypes,LvarPto)>
				<cfset LvarValor  = rsSQL[LvarCampo]>
				<cfif LvarCFType EQ "B">
					<cfset LvarValor = ToBase64(LvarValor)>
				<cfelseif LvarCFType EQ "D">
					<cfset LvarValor = "#DateFormat(LvarValor,"YYYY-MM-DD")# #TimeFormat(LvarValor,"HH:mm:ss")#">
				<cfelseif LvarCFType NEQ "N">
					<cfset LvarValor = XMLformat(trim(LvarValor))>
				</cfif>
				<cfset LobjXML.append ('      <#LvarCampo#>#LvarValor#</#LvarCampo#>').append(LvarCrLn)>
			</cfloop>
			<cfset LobjXML.append ('    </row>').append(LvarCrLn)>
			<cfif Arguments.forOutput>
				<cfoutput>#LobjXML.toString()#</cfoutput>
				<cfset LobjXML.setLength (0)>
			</cfif>
		</cfloop>
		<cfset LobjXML.append ('  </resultset>').append(LvarCrLn)>
		<cfif Arguments.forOutput>
			<cfset LobjXML.append ('</response>').append(LvarCrLn)>
			<cfset LobjXML.append ('-->').append(LvarCrLn)>
			<cfoutput>#LobjXML.toString()#</cfoutput>
			<cfset LobjXML.setLength (0)>
		</cfif>
	<cfcatch type="any"></cfcatch>
	</cftry>
	<cfreturn LobjXML.toString()>
</cffunction>

<cffunction name="fnGeneraQueryToXML" access="public" output="no" returntype="string">
	<cfargument name="rsSQL" 		type="query"	required="yes">
	
	<cfset LobjXML = "">
	<cfobject type = "Java"	action = "Create" class = "java.lang.StringBuffer" name = "LobjXML">

	<cftry>
		<cfset LvarCampos 	= arrayToList(Arguments.rsSQL.getColumnNames())>
		<cfset LvarCrLn = chr(13) & chr(10)>

		<cfset LobjXML.append ('  <resultset rows="#rsSQL.recordCount#">').append(LvarCrLn)>
		<cfloop query="Arguments.rsSQL">
			<cfset LobjXML.append ('    <row>').append(LvarCrLn)>
			<cfloop index="LvarCampo" list="#LvarCampos#">
				<cfset LvarValor  = rsSQL[LvarCampo]>
				<cfif isBinary(LvarValor)>
					<cfset LvarValor = ToBase64(LvarValor)>
				<cfelseif isDate(LvarValor)>
					<cfset LvarValor = "#DateFormat(LvarValor,"YYYY-MM-DD")# #TimeFormat(LvarValor,"HH:mm:ss")#">
				<cfelseif NOT isNumeric(LvarValor)>
					<cfset LvarValor = XMLformat(trim(LvarValor))>
				</cfif>
				<cfset LobjXML.append ('      <#LvarCampo#>#LvarValor#</#LvarCampo#>').append(LvarCrLn)>
			</cfloop>
			<cfset LobjXML.append ('    </row>').append(LvarCrLn)>
		</cfloop>
		<cfset LobjXML.append ('  </resultset>').append(LvarCrLn)>
	<cfcatch type="any"></cfcatch>
	</cftry>
	<cfreturn LobjXML.toString()>
</cffunction>

<cffunction name="fnGeneraXMLToQuery" access="public" output="no" returntype="query">
	<cfargument name="XML" 		type="string"	required="yes">

	<cfif trim(Arguments.XML) EQ "">
		<cfreturn QueryNew("")>
	</cfif>
	
	<cfset LvarXMLdoc	= XmlParse(XML)>
	<cfset LvarXMLrows  = LvarXMLdoc.resultset.XmlChildren>
	<cfset LvarXMLrowsN = ArrayLen(LvarXMLrows)>
	<cfif LvarXMLrowsN EQ 0>
		<cfset LvarXMLcolsN = 0>
	<cfelse>
		<cfset LvarXMLcolsN = ArrayLen(LvarXMLdoc.resultset.row[1].XmlChildren)>
		<cfset LvarXMLcols  = arrayNew(1)>
		<cfloop index="j" from = "1" to = #LvarXMLcolsN#>
			<cfset LvarXMLcols[j] = LvarXMLrows[1].XmlChildren[j].XmlName>
		</cfloop>
	</cfif>
		
	<cfif LvarXMLcolsN EQ 0>
		<cfset rsXML = QueryNew("")>
	<cfelse>
		<cfset rsXML = QueryNew(arrayToList(LvarXMLcols))>
		<cfset QueryAddRow(rsXML, LvarXMLrowsN)>
	</cfif>
	<cfloop index="i" from = "1" to = "#LvarXMLrowsN#">
		<cfloop index="j" from = "1" to = "#LvarXMLcolsN#">
			<cfset QuerySetCell(rsXML, LvarXMLcols[j], evaluate("LvarXMLrows[i].#LvarXMLcols[j]#.XmlText"), #i#)>
		</cfloop>
	</cfloop>
	<cfreturn rsXML>
</cffunction>

<cffunction name="sbGeneraXMLtoTabla" access="private" output="no">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="IdProceso" 			type="numeric" required="yes">
	<cfargument name="TipoIO"	 			type="string" required="yes">
	<cfargument name="Nivel"	 			type="string" required="yes">
	
	<cfset LvarIO_Nivel = "#Arguments.TipoIO##Arguments.Nivel#">
	
	<cfif LvarIO_Nivel EQ "IE">
		<cfset LvarXML_IO_Nivel = GvarXML_IE>
	<cfelseif LvarIO_Nivel EQ "ID">
		<cfset LvarXML_IO_Nivel = GvarXML_ID>
	<cfelseif LvarIO_Nivel EQ "IS">
		<cfset LvarXML_IO_Nivel = GvarXML_IS>
	<cfelseif LvarIO_Nivel EQ "OE">
		<cfset LvarXML_IO_Nivel = GvarXML_OE>
	<cfelseif LvarIO_Nivel EQ "OD">
		<cfset LvarXML_IO_Nivel = GvarXML_OD>
	<cfelseif LvarIO_Nivel EQ "OS">
		<cfset LvarXML_IO_Nivel = GvarXML_OS>
	</cfif>
	
	<cfif trim(LvarXML_IO_Nivel) EQ "">
		<cfreturn>
	</cfif>
	<cftry>
		<cf_dbstruct name="#LvarIO_Nivel##NumeroInterfaz#" datasource="sifinterfaces">
		<cfif rsStruct.recordCount EQ 0>
			<cfthrow message="Tabla #LvarIO_Nivel##NumeroInterfaz# no esta definida en Base Datos de Interfaz">
		</cfif>
		<cfset LvarNames = "">
		<cfset LvarDBStruct = ArrayNew(2)>
		<cfset LvarDBStructI = 1>
		<cfloop query="rsStruct">
			<cfset LvarName = rsStruct.name>
			<cfif LvarName NEQ "ts_rversion">
				<cfif LvarDBStructI EQ 1>
					<cfset LvarNames = LvarName>
				<cfelse>
					<cfset LvarNames = LvarNames & ", " & LvarName>
				</cfif>
				<cfset LvarDBStruct[LvarDBStructI][1] = rsStruct.name>
				<cfset LvarDBStruct[LvarDBStructI][2] = rsStruct.cf_type>
				<cfset LvarDBStruct[LvarDBStructI][3] = rsStruct.cf_sql_type>
				<cfset LvarDBStructI = LvarDBStructI + 1>
			</cfif>
		</cfloop>

		<cfset LvarXML = XmlParse(LvarXML_IO_Nivel)>
		<cfloop index="i" from="1" to="#arrayLen(LvarXML.resultset.XmlChildren)#"> 
			<cfset LvarXMLrow = LvarXML.resultset.row[i]>
			<cfset LvarXMLrowVals = LvarXMLrow.XmlChildren>
			<cfquery datasource="sifinterfaces">
				insert into #LvarIO_Nivel##NumeroInterfaz# (#LvarNames#)
				values (
				<cfloop index="LvarDBStructI" from="1" to="#arrayLen(LvarDBStruct)#">
					<cfset LvarName = LvarDBStruct[LvarDBStructI][1]>
					<cfif LvarName EQ "ID">
						<cfset LvarValue = GvarID>
					<cfelse>
						<cfif i  EQ 1>
							<cfset LvarPos = XmlChildPos(LvarXMLrow,LvarName, 1)>
							<cfset LvarDBStruct[LvarDBStructI][4] = LvarPos>
						<cfelse>
							<cfset LvarPos = LvarDBStruct[LvarDBStructI][4]>
							<cfif LvarPos GT arrayLen(LvarXMLrow) OR LvarXMLrow[LvarPos].XmlName NEQ LvarName>
								<cfset LvarPos = XmlChildPos(LvarXMLrow,LvarName, 1)>
							</cfif>
						</cfif>
						<cfif LvarPos EQ -1>
							<cfthrow message="No se existe valor en el XML para el Campo '#LvarName#' en la linea #i#">
						<cfelse>
							<cfset LvarValue = LvarXMLrowVals[LvarPos].XmlText>

							<cfset LvarCFType = LvarDBStruct[LvarDBStructI][2]>
							<cfif LvarCFType EQ "B">
								<cfset LvarValue = ToBinary(LvarValue)>
							<cfelseif LvarCFType EQ "D">
							<cfelseif LvarCFType EQ "N">
								<cfset LvarValue = replace(LvarValue,",","","ALL")>
							<cfelseif LvarCFType EQ "S">
							</cfif>
						</cfif>
					</cfif>
					<cfif LvarDBStructI GT 1>
						,
					</cfif>
					<cfqueryparam cfsqltype="#LvarDBStruct[LvarDBStructI][3]#" value="#LvarValue#" null="#trim(LvarValue) eq ''#">
				</cfloop>
				)
			</cfquery>

		</cfloop> 
	<cfcatch type="any">
			<cfrethrow>
	</cfcatch>
	</cftry>
</cffunction>

<!--- 
	********************************
	PROCESOS DE LA TAREA ASINCRONA
	********************************

	activarCola.cfm?CE
		sbActivarCola
			fnActivarMotor
			<cfhttp activarCola.cfm?CE,NI>
	
	activarCola.cfm?CE,NI
		sbActivarColaInterfaz
			fnActivarMotor
			Por cada proceso a ejecutar:
				sbIniciarSession
				fnActivarProceso
					sbEjecutarComponente: 
						<cfinclude #interfaz.Componente#>
							sbReportarActividad
					sbProcesoSpFinal
					fnProcesoFinalizarConExito
					SI ERROR:
						fnProcesoPendienteConError

	activarCola.cfm?CE,NI,ID
		sbIniciarSession
		fnActivarProceso
--->
<cffunction name="sbActivarCola" access="public" output="no">
	<cfargument name="CEcodigo" type="numeric" required="yes">

	<cfset var rsInterfaces		= "">
	<cfset var LvarNow			= fnNow()>
	<cfset var LvarHoy			= fnToday()>
	<!--- LvarControlLock: Se usa con la hora del CF --->
	<cfset var LvarControlLock	= 0>
<cflog file="ActivarColaDebug" text="***************************************************************************************************************************************">
<cflog file="ActivarColaDebug" text="INICIO cffunction: #now()#">

	<cftry>
<cflog file="ActivarColaDebug" text="ANTES DE: select getdate(): #now()#">
		<cfquery name="rsSQL" datasource="sifinterfaces">
			select 	#PreserveSingleQuotes(LvarNow)# as ahora, 
					#PreserveSingleQuotes(LvarHoy)# as hoy
			<cfif Application.dsinfo.sifinterfaces.type EQ "oracle" OR Application.dsinfo.sifinterfaces.type EQ "db2">
			  from dual
			</cfif>
		</cfquery>
<cflog file="ActivarColaDebug" text="DESPUES DE: select getdate(): #now()#">
		<cfset LvarNow = dateadd("s",0,rsSQL.ahora)>
		<cfset LvarHoy = dateadd("s",0,rsSQL.hoy)>
	
		<cfset GvarCE = Arguments.CEcodigo>
	
<cflog file="ActivarColaDebug" text="ANTES DE: cflock: #now()#">
		<cfset LvarControlLock	= now()>		<!--- now() OK --->
		<cflock name="ColaCE#Arguments.CEcodigo#" timeout="10" throwontimeout="yes" type="exclusive">
<cflog file="ActivarColaDebug" text="DESPUES DE: cflock: #now()#">
			<!--- LvarControlLock: Se usa con la hora del CF --->
			<cfset LvarSegEspera = datediff("s",LvarControlLock,now())>
<cflog file="ActivarColaDebug" text="ANTES DE: cfthrow: #now()#">
			<cfif LvarSegEspera GT 60>									<!--- now() OK --->
				<cfset LvarIP = "">
				<cftry>
					<cfset LvarIP = "(desde IP=#GetPageContext().getRequest().getRemoteAddr()#)">
				<cfcatch type="any">
					<cfset LvarIP = "(desde IP=No se pudo obtener)">
				</cfcatch>
				</cftry>
				<cfthrow message="Existe un problema general de congelamiento ajeno al Motor de Interfaces. Inicio tarea: #LvarControlLock# #LvarIP#">
			<cfelseif LvarSegEspera GT 1>								<!--- now() OK --->
				<cfset LvarIP = "">
				<cftry>
					<cfset LvarIP = "(desde IP=#GetPageContext().getRequest().getRemoteAddr()#)">
				<cfcatch type="any">
					<cfset LvarIP = "(desde IP=No se pudo obtener)">
				</cfcatch>
				</cftry>
				<cfthrow message="Hay mas de una tarea ejecutandose a la vez. Inicio tarea: #LvarControlLock# #LvarIP#">
			</cfif>
<cflog file="ActivarColaDebug" text="DESPUES DE: cfthrow: #now()#">
			
<cflog file="ActivarColaDebug" text="ANTES DE: java.sleep 3 segs: #now()#">
			<cfobject type = "Java"	action = "Create" class = "java.lang.Thread" name = "LobjThread">
			<cfset LobjThread.sleep(3000)>
<cflog file="ActivarColaDebug" text="DESPUES DE: java.sleep 3 segs: #now()#">

			<cfif Arguments.CEcodigo EQ -1><cfreturn></cfif>
<cflog file="ActivarColaDebug" text="ANTES DE: fnActivarMotor: #now()#">
			<cfset rsMotor = fnActivarMotor (Arguments.CEcodigo)>
<cflog file="ActivarColaDebug" text="DESPUES DE: fnActivarMotor: #now()#">
			
<cflog file="ActivarColaDebug" text="ANTES DE: fnMismoServidor: #now()#">
			<cfif NOT fnMismoServidor(LvarUrlServidor)>
				<cfthrow message="El motor de interfaz cambió de dirección URL">
			</cfif>
<cflog file="ActivarColaDebug" text="DESPUES DE: fnMismoServidor: #now()#">

<cflog file="ActivarColaDebug" text="ANTES DE: Application.interfazSoin: #now()#">
			<cfif not isdefined("Application.interfazSoin.CE_#Arguments.CEcodigo#")>
				<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"] = structNew()>
			</cfif>
			<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"].FechaActividad = LvarNow>
<cflog file="ActivarColaDebug" text="DESPUES DE: Application.interfazSoin: #now()#">
		
<cflog file="ActivarColaDebug" text="ANTES DE: update Interfaz Ejecutando=0: #now()#">
			<!--- Si la interfaz tiene mas de 12 minutos, se considera inactiva y se reinicia el procesamiento --->
			<cf_dbfunction name="timediff" 	args="FechaActividad|#LvarNow#" returnvariable="LvarMinActividad" delimiters="|">
			<cfset LvarMinActividad = "#LvarMinActividad# / 60">
			<cfquery datasource="sifinterfaces">
				update Interfaz
				   set Ejecutando = 0
                 where FechaActividad is not null
				   and MinutosAborto  is not null
                   and Activa		= 1
                   and Ejecutando	= 1
                   and #preserveSingleQuotes(LvarMinActividad)# > MinutosAborto
			</cfquery>
<cflog file="ActivarColaDebug" text="DESPUES DE: update Interfaz Ejecutando=0: #now()#">

<cflog file="ActivarColaDebug" text="ANTES DE: update InterfazMotor FechaActividad: #now()#">
			<cfquery datasource="sifinterfaces">
				update InterfazMotor
				   set FechaActividad = <cf_dbfunction name="now" datasource="sifinterfaces">
				 where CEcodigo = #Arguments.CEcodigo#
			</cfquery>
<cflog file="ActivarColaDebug" text="DESPUES DE: update InterfazMotor FechaActividad: #now()#">
		
<cflog file="ActivarColaDebug" text="ANTES DE: COMENTARIO: #now()#">
			<!--- 
				Se determina cuales Interfaces deben activarse y si existen procesos en espera:
				
				TipoRetardo = M-Minutos de retardo de la cola: la Cola se debe Activar cada N minutos a partir de la Fecha de Activación del Motor
				
				HoraActivacionCola: FechaActivacion + ( round_floor_MinutosRetardo(Now()-FechaActivacion) )
				(como la HoraActivacionCola es función de Now(), siempre va a ser menor que Now())
				FechaInclusion <= HoraActivacionCola
					  A...|....|....|....|....|....|....|....|.I..H..N.|
					  |										   |  |  |
				FechaActivacion								   |  |  Now()
												  FechaInclusion <->
																  |
														  HoraActivacionCola

				TipoRetardo = H-a una hora en particular: la Cola se debe Activar cada día unicamente a una hora particular

				HoraActivacionCola: InicioDia + MinutosRetardo
				(como la HoraActivacionCola no toma en cuenta Now(), hay que asegurarse que sea menor que Now())
				FechaInclusion <= HoraActivacionCola AND HoraActivacionCola <= now()
					  D...|....|....|....|....|....|....|....|.I..H..N.|
					  |										   |  |  |
				InicioDelDia								   |  |  Now()
												  FechaInclusion <->
																  |
														  HoraActivacionCola

			--->
	
			
			<!--- 
				TipoRetardo = M-Minutos de retardo de la cola: la Cola se debe Activar cada N minutos a partir de la Fecha de Activación del Motor
					HoraActivacion = FechaActivacion + ( round_floor_MinutosRetardo(Now()-FechaActivacion) )
			--->
<cflog file="ActivarColaDebug" text="DESPUES DE: COMENTARIO: #now()#">
			<cfset LvarFechaActivacion = "'#DateFormat(rsMotor.FechaActivacion,'dd-mm-yyyy')# #TimeFormat(rsMotor.FechaActivacion,'HH:mm:ss')#'">
			<cfset LvarSegs = dateDiff("s", rsMotor.FechaActivacion, LvarNow)>
			<cfset LvarSegs = "floor (#LvarSegs#/(i.MinutosRetardo*60))*i.MinutosRetardo*60">
			<cf_dbfunction name="timeadd" args="#LvarSegs#|#LvarFechaActivacion#"		returnvariable="LvarHoraActivacionTipoM" datasource="sifinterfaces" DELIMITERS="|">

			<!--- 
				TipoRetardo = H-a una hora en particular: la Cola se debe Activar cada día unicamente a una hora particular
					HoraActivacion = InicioDia + ( horaEspecificada ), no debe ser mayor a now()
			--->
			<cf_dbfunction name="timeadd" args="i.MinutosRetardo*60|#LvarHoy#"		returnvariable="LvarHoraActivacionTipoH" datasource="sifinterfaces" DELIMITERS="|">

<cflog file="ActivarColaDebug" text="ANTES DE: cftransaction read_uncommitted: #now()#">
			<cftransaction isolation="read_uncommitted">
<cflog file="ActivarColaDebug" text="DESPUES DE: cftransaction read_uncommitted: #now()#">
<cflog file="ActivarColaDebug" text="ANTES DE: select distinct from InterfazColaProcesos, Interfaz UNION: #now()#">
				<cfquery name="rsInterfaces" datasource="sifinterfaces">
					select distinct i.NumeroInterfaz as NumeroInterfaz
					  from InterfazColaProcesos p
						inner join Interfaz i
							 on i.NumeroInterfaz = p.NumeroInterfaz
							and i.Activa = 1 
							and i.Ejecutando = 0
							and i.TipoProcesamiento = 'A' 
					 where p.CEcodigo 		= #Arguments.CEcodigo#
					   and p.StatusProceso 	= 1
					   and i.TipoRetardo	= 'M'
					   <!--- FechaInclusion <= FechaActivacion + int((FechaActivacion-Now())/MinutosRetardo)*MinutosRetardo --->
					   and p.FechaInclusion <= 
							case coalesce(i.MinutosRetardo,0)
								when 0 then p.FechaInclusion
								else #PreserveSingleQuotes(LvarHoraActivacionTipoM)#
							end
					UNION
					select distinct i.NumeroInterfaz as NumeroInterfaz
					  from InterfazColaProcesos p
						inner join Interfaz i
							 on i.NumeroInterfaz = p.NumeroInterfaz
							and i.Activa = 1 
							and i.Ejecutando = 0
							and i.TipoProcesamiento = 'A' 
					 where p.CEcodigo 		= #Arguments.CEcodigo#
					   and p.StatusProceso 	= 1
					   and i.TipoRetardo	= 'H'
					   <!--- FechaInclusion <= LvarHoraActivacion AND LvarHoraActivacion <= now() --->
					   and #PreserveSingleQuotes(LvarHoraActivacionTipoH)# between p.FechaInclusion and #LvarNow#
					order by NumeroInterfaz
				</cfquery>
<cflog file="ActivarColaDebug" text="DESPUES DE: select distinct from InterfazColaProcesos, Interfaz UNION: #now()#">
			</cftransaction>
<cflog file="ActivarColaDebug" text="SALIR DE: cftransaction read_uncommitted: #now()#">

<cflog file="ActivarColaDebug" text="ANTES DE: fnLog: #now()#">
			<cfset fnLog("A_AT","Activando Tarea Asíncrona CE=#Arguments.CEcodigo#")>
<cflog file="ActivarColaDebug" text="DESPUES DE: fnLog: #now()#">

<cflog file="ActivarColaDebug" text="ANTES DE: cfloop: #now()#">
			<cfloop query="rsInterfaces">
<cflog file="ActivarColaDebug" text="CICLO #rsInterfaces.currentRow#: cfloop: #now()#">
				<!--- 
					Para cada Interfaz que debe activarse y que tienen procesos en espera
					se invoca a sbActivarColaInterfaz en forma Asíncrona y en paralelo
				--->
<cflog file="ActivarColaDebug" text="ANTES DE: cfset LvarTareaAsincrona: #now()#">
				<cfset LvarTareaAsincrona = LvarUrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#Arguments.CEcodigo#&NI=#rsInterfaces.NumeroInterfaz#">
<cflog file="ActivarColaDebug" text="ANTES DE: fnLog: #now()#">
				<cfset fnLog("A_AI","Invocando Cola para Interfaz #rsInterfaces.NumeroInterfaz# (CE=#Arguments.CEcodigo#): #LvarTareaAsincrona#")>
<cflog file="ActivarColaDebug" text="DESPUES DE: fnLog: #now()#">
<cflog file="ActivarColaDebug" text="ANTES DE: cfhttp: #now()#">
				<cfhttp 	method		= "get"
							url			= "#LvarTareaAsincrona#"
							timeout		= "1"
							throwonerror="no"
				>
				</cfhttp>
<cflog file="ActivarColaDebug" text="DESPUES DE: cfhttp: #now()#">
			</cfloop>
<cflog file="ActivarColaDebug" text="SALIR DE: cfloop: #now()#">
		</cflock>
<cflog file="ActivarColaDebug" text="SALIR DE: cflock: #now()#">
	<cfcatch type="any">
<cflog file="ActivarColaDebug" text="INICIO DE: cfcatch: #now()#">
		<cfset fnLog("","Error Activando Tarea Asíncrona CE=#Arguments.CEcodigo#: #cfcatch.Message#")>
		<cfif isdefined("cfcatch.SQL")>
			<cfset fnLog("","Error Activando Tarea Asíncrona CE=#Arguments.CEcodigo#: #cfcatch.SQL#")>
		</cfif>
<cflog file="ActivarColaDebug" text="FINAL DE: cfcatch: #now()#">
	</cfcatch>
	</cftry>
<cflog file="ActivarColaDebug" text="FINAL cffunction: #now()#">
</cffunction>

<cffunction name="sbActivarColaInterfaz" access="public" output="no">
	<cfargument name="CEcodigo" 		type="numeric" required="yes">
	<cfargument name="NumeroInterfaz"	type="numeric" required="yes">
	
	<cfset var rsInterfaz = "">
	
	<cfset GvarCE = Arguments.CEcodigo>

	<cfif Arguments.CEcodigo EQ -1><cfreturn></cfif>
	<cfif Arguments.NumeroInterfaz EQ -1><cfreturn></cfif>
	<cfset rsMotor = fnActivarMotor (Arguments.CEcodigo)>

	<cftry>
		<cfquery name="rsInterfaz" datasource="sifinterfaces">
			select 	i.Componente, 
					i.ManejoDatos, 
					i.eMailErrores,

					25 as ProcesosPorRequest, 
			   		case when i.TipoProcesamiento = 'A' then 1 else 0 end as CG
			  from Interfaz i
			 <!--- where i.CEcodigo 	= Arguments.CEcodigo --->
			 where i.NumeroInterfaz = #Arguments.NumeroInterfaz#
			   and i.Activa = 1
			   and i.Ejecutando = 0
			   and i.TipoProcesamiento = 'A'
		</cfquery>
		<cfif rsInterfaz.recordCount GT 0>
			<cfset fnLog("A_AI","Activando Cola para Interfaz #Arguments.NumeroInterfaz# (CE=#Arguments.CEcodigo#)")>
			<cfquery datasource="sifinterfaces">
				update Interfaz
				   set FechaActividad = <cf_dbfunction name="now" datasource="sifinterfaces">
					 , Ejecutando = 1
				 <!--- where i.CEcodigo 	= Arguments.CEcodigo --->
				 where NumeroInterfaz = #Arguments.NumeroInterfaz#
			</cfquery>

			<cfset LvarReejecutar = false>
			<cfset LvarProcesosEnRequest = 0>
			<cfloop condition="true"><cfsilent><!--- 2010-05-21- --->
				<!--- 
					Una vez Activada la Cola de la Interfaz, 
					se ejecutan secuencialmente todos los procesos en espera
					incluyendo aquellos que han sido agregados mientras la cola está activa
				--->
				<cfset rsProc = javacast("null",0)>
				<cfquery name="rsProc" datasource="sifinterfaces" maxrows="25">
					select 	p.IdProceso, p.SecReproceso, p.EcodigoSDC, p.UsucodigoInclusion, p.FechaInclusion,
							p.ParametrosSOIN, p.TipoMovimientoSOIN
					  from InterfazColaProcesos p
					 where p.CEcodigo		= #Arguments.CEcodigo#
					   and p.NumeroInterfaz	= #Arguments.NumeroInterfaz#
					   and p.StatusProceso	= 1
					order by FechaInclusion
 					<!--- OJO: aqui deberia verificarse los minutos de retardo --->
				</cfquery>
				<cfif rsProc.recordCount EQ 0>
					<cfset LvarReejecutar = false>
					<cfbreak>
				</cfif>
				<cfloop query="rsProc"><cfsilent><!--- 2010-05-21- --->
					<cfset LvarMSG = fnActivarProceso	(Arguments.CEcodigo, Arguments.NumeroInterfaz, rsProc.IdProceso, rsProc.SecReproceso, rsInterfaz.Componente, 'A', rsInterfaz.ManejoDatos, rsProc.ParametrosSOIN, rsProc.TipoMovimientoSOIN, rsProc.EcodigoSDC, rsProc.UsucodigoInclusion, rsInterfaz.eMailErrores, rsInterfaz.CG)> 
					<cfset LvarProcesosEnRequest = LvarProcesosEnRequest + 1>
					<cfif rsInterfaz.ProcesosPorRequest NEQ 0 and LvarProcesosEnRequest GTE rsInterfaz.ProcesosPorRequest>
						<cfset LvarReejecutar = true>
						<cfbreak>
					</cfif>
				</cfsilent><!--- 2010-05-21- ---></cfloop>
				<cfbreak><!--- 2010-05-21- --->
			</cfsilent><!--- 2010-05-21- ---></cfloop>
			<cfquery datasource="sifinterfaces">
				update Interfaz
				   set Ejecutando = 0
				 <!--- where i.CEcodigo 	= Arguments.CEcodigo --->
				 where NumeroInterfaz = #Arguments.NumeroInterfaz#
			</cfquery>
			<cfif LvarReejecutar>
				<cfset LvarTareaAsincrona = LvarUrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#Arguments.CEcodigo#&NI=#Arguments.NumeroInterfaz#">
				<cfset fnLog("A_AI","Reinvocando Cola para Interfaz #Arguments.NumeroInterfaz# (CE=#Arguments.CEcodigo#): #LvarTareaAsincrona#")>
				<cfhttp 	method		= "get"
							url			= "#LvarTareaAsincrona#"
							timeout		= "1"
							throwonerror= "no"
				>
				</cfhttp>
			</cfif>
		</cfif>
	<cfcatch>
		<cfquery datasource="sifinterfaces">
			update Interfaz
			   set Ejecutando = 0
			 <!--- where i.CEcodigo 	= Arguments.CEcodigo --->
			 where NumeroInterfaz = #Arguments.NumeroInterfaz#
		</cfquery>
		<cfset fnLog("","ERROR Activando Cola para Interfaz #Arguments.NumeroInterfaz# (CE=#Arguments.CEcodigo#), ERROR=#cfcatch.Message#")>
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="sbActivarColaProceso" access="public" output="no">
	<cfargument name="CEcodigo" 		type="numeric" required="yes">
	<cfargument name="NumeroInterfaz"	type="numeric" required="yes">
	<cfargument name="IdProceso"		type="numeric" required="yes">
	
	<cfset GvarCE = Arguments.CEcodigo>

	<cfif Arguments.CEcodigo EQ -1><cfreturn></cfif>
	<cfif Arguments.NumeroInterfaz EQ -1><cfreturn></cfif>
	<cfif Arguments.IdProceso EQ -1><cfreturn></cfif>

	<cfquery name="rsProc" datasource="sifinterfaces">
		select 	p.SecReproceso, p.EcodigoSDC, p.UsucodigoInclusion, p.ParametrosSOIN, p.TipoMovimientoSOIN,
				i.Componente,
				i.ManejoDatos,
				i.eMailErrores,
	   			case when i.TipoProcesamiento = 'A' then 1 else 0 end as CG
		  from InterfazColaProcesos p
				inner join Interfaz i
					 on i.NumeroInterfaz = p.NumeroInterfaz
					and i.Activa = 1
					and i.TipoProcesamiento = 'A'
		 where p.CEcodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		   and p.NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NumeroInterfaz#">
		   and p.IdProceso		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
		   and p.StatusProceso = 1
		order by p.FechaInclusion
	</cfquery>
	<cfif rsProc.recordCount GT 0>
		<cfset fnActivarProceso	(Arguments.CEcodigo, Arguments.NumeroInterfaz, Arguments.IdProceso, rsProc.SecReproceso, rsProc.Componente, 'A', rsProc.ManejoDatos, rsProc.ParametrosSOIN, rsProc.TipoMovimientoSOIN, rsProc.EcodigoSDC, rsProc.UsucodigoInclusion, rsProc.eMailErrores, rsProc.CG)>
	<cfelse>
		<cfthrow message="La Tarea Asíncrona de Activación de Interfaces SOIN no puede ser invocada directamente (no inactivo)">
	</cfif>
</cffunction>

<cffunction name="sbIniciarSession" access="public" returntype="string" output="no">
	<cfargument name="CEcodigo" 	type="numeric" required="yes">
	<cfargument name="EcodigoSDC"	type="numeric" required="yes">
	<cfargument name="Usucodigo"	type="numeric" required="yes">

	<cfset GvarCE = Arguments.CEcodigo>

	<cfset session.autoafiliado = Arguments.Usucodigo>

	<cfset session.login_no_interactivo = true>
	<cfset form.j_empresa 	= "">
	<cfset LvarEcodigoSDC 	= Arguments.EcodigoSDC>
	<cfset form.j_username 	= "">
	<cfset form.j_password 	= "">
	<cfinclude template="/home/check/dominio.cfm">
	<cfinclude template="/home/check/autentica.cfm">
	<!--- <cfinclude template="/home/check/acceso.cfm"> --->
	<cfif not isdefined("session.usucodigo") or session.usucodigo eq 0>
		<cfset fnThrow("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Usuario no Autorizado")>
	</cfif>
	<cfquery name="rsEmpresas" datasource="asp">
		select distinct p.Ecodigo as EcodigoSDC, Enombre, 
			'#trim(session.datos_personales.Nombre) & " " & trim(session.datos_personales.Apellido1) & " " & trim(session.datos_personales.Apellido2)#' as Nombre
		  from vUsuarioProcesos p
			   inner join Empresa e 
				  on CEcodigo = #Session.CEcodigo#
				 and p.Ecodigo = e.Ecodigo
		 where Usucodigo=#Session.Usucodigo#
		   and p.Ecodigo = #LvarEcodigoSDC#
	</cfquery>
	<cfif rsEmpresas.recordCount NEQ 1>
		<cfset fnThrow("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Empresa no Autorizada")>
	</cfif>
	<cfset CreateObject("Component","/home/check/functions").seleccionar_empresa(rsEmpresas.EcodigoSDC)>

	<!--- ACTUALIZA DSINFO --->
	<cfset sbDSINFO()>
</cffunction>

<cffunction name="sbDSINFO" access="public" output="no">
	<cfif not isdefined("Application.interfazSoin.dsInfo")>
		<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
			<!--- <cfinvokeargument name="refresh" 	value="yes"> --->
		</cfinvoke>
		<cfset Application.interfazSoin.dsInfo = true>
	</cfif>

	<cfif 	not isdefined("Application.dsinfo.#session.dsn#") OR
			Len(trim(Application.dsinfo["sifinterfaces"].schema)) EQ 0 OR
			Len(trim(Application.dsinfo["#session.dsn#"].schema)) EQ 0
	>
		<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
			<!--- <cfinvokeargument name="refresh" 	value="yes"> --->
		</cfinvoke>
	</cfif>
</cffunction>

<!--- 
	*************************************
	PROCESOS DE LA CONSOLA ADMINISTRACION
	*************************************
--->

<cffunction name="fnProcesoCancelar" access="public" output="no">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">

	<cfquery name="rsSQL" datasource="sifinterfaces">
		select count(1) as Cantidad
		  from InterfazColaProcesosCancelar
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
		   and IdProceso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
		   and SecReproceso		= #Arguments.SecReproceso#
	</cfquery>
	<cfif rsSQL.Cantidad EQ 0>
		<cfquery datasource="sifinterfaces">
			insert into InterfazColaProcesosCancelar 
				(
					CEcodigo,
					NumeroInterfaz,
					IdProceso,
					SecReproceso,
					UsucodigoCancela,
					FechaCancelacion,
					MsgCancelacion
				)
			values (
					#session.CEcodigo#,
					#Arguments.NumeroInterfaz#,
					#Arguments.IdProceso#,
					#Arguments.SecReproceso#,
					#session.Usucodigo#,
					<cf_dbfunction name="now" datasource="sifinterfaces">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#mid(Arguments.MSG,1,255)#">
				)
		</cfquery>
	</cfif>

	<cfquery name="rsProceso" datasource="sifinterfaces">
		select StatusProceso
		  from InterfazColaProcesos
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
		   and IdProceso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#IdProceso#">
		   and SecReproceso		= #Arguments.SecReproceso#
	</cfquery>

	<cfif rsProceso.StatusProceso EQ "2">
		<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
			<cfset Application.InterfazSoin["CE_#session.CEcodigo#"]["ID_CAN_#Arguments.IdProceso#"] = "CANCELADO POR #session.usuLogin#: " & mid(Arguments.MSG,1,255)>
		</cflock>
	<cfelse>
		<cfset fnProcesoFinalizar(Arguments.NumeroInterfaz,Arguments.IdProceso,-1, "-1", Arguments.MSG)>
	</cfif>
</cffunction>

<cffunction name="fnProcesoReprocesar" access="public" output="no">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">

	<cftransaction>
		<cfquery datasource="sifinterfaces">
			update InterfazColaProcesos
			   set StatusProceso 	= 4
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
			   and SecReproceso		= #Arguments.SecReproceso#
		</cfquery>
	
	 	<cfquery datasource="sifinterfaces">
			insert into InterfazColaProcesos
				(
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					SecReproceso,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					StatusProceso, 
					FechaInclusion,
					FechaInicioProceso,
					UsucodigoInclusion, 
					UsuarioBdInclusion,
					ParametrosSOIN,
					TipoMovimientoSOIN
				)
			select 
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					SecReproceso+1,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					1, 
					<cf_dbfunction name="now" datasource="sifinterfaces">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,
					#session.Usucodigo#, 
					UsuarioBdInclusion,
					ParametrosSOIN,
					TipoMovimientoSOIN
			  from InterfazColaProcesos
				 where CEcodigo 		= #session.CEcodigo#
				   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
				   and IdProceso		= #Arguments.IdProceso#
				   and SecReproceso		= #Arguments.SecReproceso#
		</cfquery>
	</cftransaction>
	<cfquery name="rsInterfaz" datasource="sifinterfaces">
		select TipoRetardo, coalesce(MinutosRetardo,0) as MinutosRetardo
		  from Interfaz
		 where NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
	</cfquery>

	<cfif rsInterfaz.TipoRetardo EQ "M" AND rsInterfaz.MinutosRetardo EQ 0>
		<cfquery name="rsMotor" datasource="sifinterfaces">
			select urlServidorMotor
			  from InterfazMotor
			 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
		<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 y Retardo=0 (Inactivo, Solicitud de Reprocesamiento inmediato, se invoca la Cola de la Interfaz #Arguments.NumeroInterfaz#)")>
		<cfset sbInvocar_ActivarInterfaz (fnUrlLocalhost(rsMotor.urlServidorMotor), session.CEcodigo, Arguments.NumeroInterfaz)>
	<cfelseif rsInterfaz.TipoRetardo EQ "M">
		<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 (Inactivo, Solicitud de Reprocesamiento, Retardo=#rsInterfaz.MinutosRetardo# minutos)")>
	<cfelse>
		<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 (Inactivo, Solicitud de Reprocesamiento, Retardo=hasta las #int(rsInterfaz.MinutosRetardo/60)#:#int(rsInterfaz.MinutosRetardo mod 60)#)")>
	</cfif>
</cffunction>

<cffunction name="fnBitacoraReprocesar" access="public" output="no" returntype="string">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">

	<cfquery name="rsSQL" datasource="sifinterfaces">
		select max(SecReproceso) as SecReproceso
		  from InterfazBitacoraProcesos
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
		   and IdProceso		= #Arguments.IdProceso#
	</cfquery>
	<cfif rsSQL.SecReproceso EQ "">
		<cfthrow message="No existe Proceso #Arguments.IdProceso# para la Interfaz #Arguments.NumeroInterfaz#">
	</cfif>
	<cfset LvarSecReproceso = rsSQL.SecReproceso>
	<cfquery name="rsSQL" datasource="sifinterfaces">
		select StatusProceso
		  from InterfazBitacoraProcesos
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
		   and IdProceso		= #Arguments.IdProceso#
		   and SecReproceso		= #LvarSecReproceso#
	</cfquery>
	<cfif rsSQL.StatusProceso NEQ "3" AND rsSQL.StatusProceso NEQ "11" AND rsSQL.StatusProceso NEQ "12">
		<cfthrow message="Proceso #Arguments.IdProceso# para la Interfaz #Arguments.NumeroInterfaz# no está en estado Error. Estado=#rsSQL.StatusProceso#">
	</cfif>

	<cftransaction>
		<cfquery datasource="sifinterfaces">
			update InterfazBitacoraProcesos
			   set StatusProceso 	= 4
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
			   and SecReproceso		= #LvarSecReproceso#
		</cfquery>
	
	 	<cfquery datasource="sifinterfaces">
			insert into InterfazColaProcesos
				(
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					SecReproceso,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					StatusProceso, 
					FechaInclusion,
					FechaInicioProceso,
					UsucodigoInclusion, 
					UsuarioBdInclusion,
					ParametrosSOIN,
					TipoMovimientoSOIN
				)
			select 
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					SecReproceso,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					StatusProceso, 
					FechaInclusion,
					coalesce(FechaInicioProceso,<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="null">),<!--- Nulo --->
					UsucodigoInclusion, 
					UsuarioBdInclusion,
					coalesce(ParametrosSOIN,<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="null">),<!--- Nulo --->
					coalesce(TipoMovimientoSOIN,<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="null">)<!--- Nulo --->
			  from InterfazBitacoraProcesos
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
		</cfquery>

	 	<cfquery datasource="sifinterfaces">
			insert into InterfazColaProcesos
				(
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					SecReproceso,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					StatusProceso, 
					FechaInclusion,
					FechaInicioProceso,
					UsucodigoInclusion, 
					UsuarioBdInclusion,
					ParametrosSOIN,
					TipoMovimientoSOIN
				)
			select 
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					SecReproceso+1,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					1, 
					<cf_dbfunction name="now" datasource="sifinterfaces">,
					null,
					#session.Usucodigo#, 
					UsuarioBdInclusion,
					ParametrosSOIN,
					TipoMovimientoSOIN
			  from InterfazBitacoraProcesos
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
			   and SecReproceso		= #LvarSecReproceso#
		</cfquery>

	 	<cfquery datasource="sifinterfaces">
			delete from InterfazBitacoraProcesos
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
			   and SecReproceso		= #LvarSecReproceso#
		</cfquery>
	</cftransaction>
	<cfquery name="rsInterfaz" datasource="sifinterfaces">
		select i.TipoProcesamiento,
			   i.TipoRetardo, 
			   coalesce(i.MinutosRetardo,0) as MinutosRetardo,
			   i.Componente,
			   i.ManejoDatos,
			   i.eMailErrores,
			   case when i.TipoProcesamiento = 'A' then 1 else 0 end as CG
		  from Interfaz i
		 where i.NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
	</cfquery>
	<cfset LvarMSG = "OK"> 
	<cfif rsInterfaz.TipoProcesamiento EQ "S">
		<!------------------------------------ PROCESAMIENTO SINCRONICO --------------------------------------->
		<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 y Sincronico (Inactivo, Solicitud de Reprocesamiento de Proceso Sincrónico, se ejecuta componente de Interfaz #Arguments.NumeroInterfaz#)")>
		<cfset LvarMSG = fnActivarProceso	(session.CEcodigo, Arguments.NumeroInterfaz, Arguments.IdProceso, '#LvarSecReproceso+1#', rsInterfaz.Componente, 'S', rsInterfaz.ManejoDatos, '', '', -1,-1, rsInterfaz.eMailErrores, rsInterfaz.CG)> 
	<cfelseif rsInterfaz.TipoRetardo EQ "M" AND rsInterfaz.MinutosRetardo EQ 0>
		<cfquery name="rsMotor" datasource="sifinterfaces">
			select urlServidorMotor
			  from InterfazMotor
			 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
		<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 y Retardo=0 (Inactivo, Solicitud de Reprocesamiento inmediato, se invoca la Cola de la Interfaz #Arguments.NumeroInterfaz#)")>
		<cfset sbInvocar_ActivarInterfaz (fnUrlLocalhost(rsMotor.urlServidorMotor), session.CEcodigo, Arguments.NumeroInterfaz)>
	<cfelseif rsInterfaz.TipoRetardo EQ "M">
		<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 (Inactivo, Solicitud de Reprocesamiento, Retardo=#rsInterfaz.MinutosRetardo# minutos)")>
	<cfelse>
		<cfset fnLog("A_IP","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 (Inactivo, Solicitud de Reprocesamiento, Retardo=hasta las #int(rsInterfaz.MinutosRetardo/60)#:#int(rsInterfaz.MinutosRetardo mod 60)#)")>
	</cfif>
	<cfreturn LvarMSG>
</cffunction>

<!--- 
	*************************************
	PROCESOS DEL LOG
	*************************************
--->

<cffunction name="fnLogDatos" output="no">
	<cfargument name="T"				type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">

	<cftransaction isolation="read_uncommitted">
		<cfif Arguments.T EQ "I">
			<cfset LvarTablaType = "Input">
		<cfelse>
			<cfset LvarTablaType = "Output">
		</cfif>
		
		<cftry>
			<cfset LvarTabla = "#Arguments.T#E#Arguments.NumeroInterfaz#">
			<cfset LvarPonerError = false>
			<cfquery name="rsSQL" datasource="sifinterfaces">
				select * from #LvarTabla# where ID=#Arguments.IdProceso#
			</cfquery>
			<cfset LvarPonerError = true>
			<cfset LvarCols = rsSQL.getColumnNames()>
			<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarCols)#")>
			<cfloop query="rsSQL">
				<cfset LvarVals = arrayNew(1)>
				<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
					<cfset LvarVal = rsSQL[LvarCols[i]]>
					<cfif isBinary(LvarVal)>
						<cfset LvarVals[i] = createobject("component","sif.Componentes.DButils").toTimeStamp(LvarVal)>
					<cfelse>
						<cfset LvarVals[i] = LvarVal>
					</cfif>
				</cfloop>
				<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarVals)#")>
			</cfloop>
		<cfcatch type="any">
			<cfif LvarPonerError>
				<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Error=#cfcatch.Message# #cfcatch.Detail#")>
			</cfif>
		</cfcatch>
		</cftry>
		
		<cftry>
			<cfset LvarTabla = "#Arguments.T#D#Arguments.NumeroInterfaz#">
			<cfset LvarPonerError = false>
			<cfquery name="rsSQL" datasource="sifinterfaces">
				select * from #LvarTabla# where ID=#Arguments.IdProceso#
			</cfquery>
			<cfset LvarPonerError = true>
			<cfset LvarCols = rsSQL.getColumnNames()>
			<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarCols)#")>
			<cfloop query="rsSQL">
				<cfset LvarVals = arrayNew(1)>
				<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
					<cfset LvarVal = rsSQL[LvarCols[i]]>
					<cfif isBinary(LvarVal)>
						<cfset LvarVals[i] = createobject("component","sif.Componentes.DButils").toTimeStamp(LvarVal)>
					<cfelse>
						<cfset LvarVals[i] = LvarVal>
					</cfif>
				</cfloop>
				<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarVals)#")>
			</cfloop>
		<cfcatch type="any">
			<cfif LvarPonerError>
				<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Error=#cfcatch.Message# #cfcatch.Detail#")>
			</cfif>
		</cfcatch>
		</cftry>
	
		<cftry>
			<cfset LvarTabla = "#Arguments.T#S#Arguments.NumeroInterfaz#">
			<cfset LvarPonerError = false>
			<cfquery name="rsSQL" datasource="sifinterfaces">
				select * from #LvarTabla# where ID=#Arguments.IdProceso#
			</cfquery>
			<cfset LvarPonerError = true>
			<cfset LvarCols = rsSQL.getColumnNames()>
			<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarCols)#")>
			<cfloop query="rsSQL">
				<cfset LvarVals = arrayNew(1)>
				<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
					<cfset LvarVal = rsSQL[LvarCols[i]]>
					<cfif isBinary(LvarVal)>
						<cfset LvarVals[i] = createobject("component","sif.Componentes.DButils").toTimeStamp(LvarVal)>
					<cfelse>
						<cfset LvarVals[i] = LvarVal>
					</cfif>
				</cfloop>
				<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarVals)#")>
			</cfloop>
		<cfcatch type="any">
			<cfif LvarPonerError>
				<cfset fnLog ("","ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Error=#cfcatch.Message# #cfcatch.Detail#")>
			</cfif>
		</cfcatch>
		</cftry>
	</cftransaction>
</cffunction>

<cffunction name="fnGetStackTrace" access="public" returntype="string" output="no">
	<cfargument name="LprmError">

	<cfset TemplateRoot = Replace(ExpandPath(""), "\", "/",'all')>
	<cfset LvarStackTrace = "<strong>ERROR DE EJECUCION:</strong> (Type: #LprmError.Type#)<BR>#LprmError.Message#<BR>">
	<cfif trim(LprmError.Detail) NEQ "">
		<cfset LvarStackTrace = LvarStackTrace & "#LprmError.Detail#<BR>">
	</cfif>
	<cfif IsDefined("LprmError.TagContext") and IsArray(LprmError.TagContext) and ArrayLen(LprmError.TagContext) NEQ 0>
		<cfset LvarStackTrace = LvarStackTrace & "<strong>Template Stack Trace</strong>:<br>">
		<cfloop from="1" to="#ArrayLen(LprmError.TagContext)#" index="i">
			<cfset TagContextTemplate = LprmError.TagContext[i].Template>
			<cfset TagContextTemplate = Replace(TagContextTemplate, "\", "/", 'all')>
			<cfset TagContextTemplate = ReplaceNoCase(TagContextTemplate, TemplateRoot, "")>
			<cfset LvarStackTrace = LvarStackTrace & " at " & 
				TagContextTemplate & ":" &
				LprmError.TagContext[i].Line>
				<cfset LvarTagContextI = LprmError.TagContext[i]>
				<cfif isdefined('LvarTagContextI.ID')>
					<cfset LvarStackTrace = LvarStackTrace  & " (" & LprmError.TagContext[i].ID & ")">
				</cfif>
			<cfset LvarStackTrace = LvarStackTrace & "<br>" >
		</cfloop>
	</cfif>
	<cfreturn LvarStackTrace>
</cffunction>

<cffunction name="fnIsBug" access="public" returntype="string" output="no">
	<cfargument name="LprmError">

	<cfset LvarTagContext1 = LprmError.TagContext[1]>
	<cfif isdefined('LvarTagContext1.ID')>
		<cfreturn NOT (ucase(LprmError.Type) EQ "APPLICATION" AND ucase(LprmError.TagContext[1].ID) EQ "CFTHROW")>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cffunction name="fnThrow" access="private" output="no">
	<cfargument name="msg" 		type="string"	required="yes">

	<cfset GvarMSG = Arguments.msg>
	<cfset session.AU = "">
	<cfset fnLog("","ID=#GvarID#, Interfaz=#GvarNI#, MSG=#GvarMSG#")>
	<cfthrow message="#Arguments.msg#">
</cffunction>

<cffunction name="fnLog" access="public" output="no">
	<cfargument name="tipo" type="string" required="yes">
	<cfargument name="text" type="string" required="yes">
	<cfargument name="eMailErrores"			type="string"	default="">

	<cfset var LvarBitacora = true>

	<cfif not isdefined("GvarCE")>
		<cfif isdefined("session.CEcodigo")>
			<cfset GvarCE = session.CEcodigo>
		<cfelse>
			<cfset GvarCE = "">
		</cfif>
	</cfif>
	
	<cfif Arguments.tipo NEQ "" AND isdefined("Application.interfazSoin.CE_#GvarCE#.Bitacora.#Arguments.tipo#")>
		<cfset LvarBitacora = evaluate("Application.interfazSoin.CE_#GvarCE#.Bitacora.#Arguments.tipo#") EQ "1">
	</cfif>
	<cfif LvarBitacora>
		<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="#text#">
		<cfif arguments.eMailErrores NEQ "">
			<cftry>
				<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
				<cfset LvarFrom = Politicas.trae_parametro_global("correo.cuenta")>
				<cfmail from="#LvarFrom#" to="#arguments.eMailErrores#" subject="ERROR enviado por el Motor de Interfaces" type="html">
					<cfoutput>
						#text#
					</cfoutput>
				</cfmail>
			<cfcatch type="any">
				<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="Error en CFmail al enviar error de interfaz">
			</cfcatch>
			</cftry>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="fnNow" access="public" output="no">
	<cf_dbfunction name="now" datasource="sifinterfaces" returnvariable="fnNow">
	<cfreturn #fnNow#>
</cffunction>

<cffunction name="fnToday" access="public" output="no">
	<cf_dbfunction name="today" datasource="sifinterfaces" returnvariable="LvarHoy">
	<cfreturn #LvarHoy#>
</cffunction>

<cffunction name="fnDataExists" returntype="boolean" output="no">
	<cfargument name="Datasource" type="string" required="true">
	<cfargument name="Table" type="string" required="true">
	<cfargument name="Fields" type="string" required="true">
	<cfargument name="Values" type="string" required="true">
	<cftry>
	<cfquery name="rsExists" datasource="#Arguments.Datasource#">
		select 1
		from #Arguments.Table#
		where <cfset n=0>
		<cfloop list="#Arguments.Fields#" index="field">
			<cfset n=n+1>
			<cfset value = Replace(ListGetAT(Arguments.Values,n),"''","'","all")>
			<cfif n gt 1> and </cfif>
			#field# = #PreserveSingleQuotes(value)#
		</cfloop>
	</cfquery>
	<cfcatch ><cf_dump  var="#value#"><cf_dump  var="#Arguments#"></cfcatch>
	</cftry>
	<cfreturn rsExists.recordCount GT 0>
</cffunction>

<cffunction name="fnUrlLocalhost" returntype="string" access="public" output="no">
	<cfargument name="url" type="string" required="true">
	<cfargument name="str" type="boolean" default="false">

	<cfif Arguments.str and find("/localhost:0/",arguments.url) GT 0>
		<cfreturn "(<strong>DESARROLLO LOCAL</strong>) " & replace(arguments.url,"/localhost:0/","/#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/","ONE")>
	<cfelse>
		<cfreturn replace(arguments.url,"/localhost:0/","/#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/","ONE")>
	</cfif>
</cffunction>


<cffunction name="fnMismoServidor" returntype="boolean" output="no">
	<cfargument name="urlServidorMotor">
	
	<cfset LvarUrlServidor		= fnUrlLocalhost(Arguments.urlServidorMotor)>
	<cfset LvarTareaAsincrona 	= LvarUrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm?SVR">

	<cftry>
		<cfhttp 	method		= "head"
					url			= "#LvarTareaAsincrona#"
					throwonerror="yes"
					timeout		="60"
					result		="LvarHeaders"
		>
		</cfhttp>
	<cfcatch type="any">
		<cfthrow type="URLSOIN" message="#cfcatch.Message#" detail="#cfcatch.Detail#">
	</cfcatch>
	</cftry>

	<cfparam name="application.Interfaz.serverId" 			default="-1">
	<cfparam name="LvarHeaders.Responseheader.IserverId" 	default="-2">
	<cfreturn LvarHeaders.Responseheader.IserverId EQ application.Interfaz.serverId>
</cffunction>
