<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document">

<!---
	En este componente se prefiere utilizar la funcion getdate( de la base de datos ) en lugar de Now( de coldfusion )
	
	con el fin de evitar diferencias en la bitácora mostrada cuando haya más de un servidor trabajando.
	
	la excepción es finish_time, que no queda guardado en la base de datos
	
--->
	
	<cffunction name="tasar" access="remote" returntype="numeric" output="false">
		<cfargument name="datasource">
		<cfargument name="servicio">
		<cfargument name="maxrows">
		
		<cfset normalizar = CreateObject("component", "normalizar")>
	
		<cfset registros_total = 0>
		<cfset count_medio = 0>
		<cfset count_login = 0>
		<cfset count_sintasar = 0>
		<cfset count_prepago = 0>
		<cfset start_time = GetTickCount()>
		<cfset EVmillisMax = 0>
		<cfset EVmillisMin = 999999>
		<cfset EVadminTime = 0>

		<cfset dtparser = CreateObject("java", "java.text.SimpleDateFormat").init ("MM/dd/yyyy HH:mm:ss")>
		
		<cfquery datasource="tasacion" name="qsize">
			<!---
			select count(1) as cant
			from cs_accounting_log
			AT ISOLATION READ UNCOMMITTED
			--->
			select coalesce (sum (rowcnt(i.doampg)), 0) as cant
			from sysindexes i
			where i.id = object_id ('cs_accounting_log')
		</cfquery>
		<cfset EVselect_inicio = GetTickCount()>
		<cfloop from="1" to="10" index="retries">
		
			<cfquery datasource="tasacion" name="acctlog" maxrows="#Arguments.maxrows#">
				<!---
					Esta lectura se hace AT ISOLATION READ UNCOMMITTED (LEVEL 0).
					La verificación para usar un registro se realiza en el isb_evento, y la secuenciación
					de las tareas permite asumir que no se repetirán registros distintas tareas en la mayoría de las veces.
				--->
				select top #Arguments.maxrows#
					log_id, blob_ordinal, blob_data
				from tasacion..cs_accounting_log
				where log_id > (select TGultimoId from isb..ISBtasarGlobal)
				order by log_id, blob_ordinal
				AT ISOLATION READ UNCOMMITTED
			</cfquery>
			<cfif acctlog.RecordCount EQ Arguments.maxrows>
				<!--- hay más --->
				<cfset TGultimoId = acctlog.log_id[acctlog.RecordCount]>
			<cfelse>
				<!--- no hubo registros, restablecer contador para todos --->
				<cfset TGultimoId = 0>
			</cfif>
			<cfquery datasource="#Arguments.datasource#" name="updateok">
				update isb..ISBtasarGlobal
				set TGultimoId = <cfqueryparam cfsqltype="cf_sql_integer" value="#TGultimoId#">
				where TGultimoId != <cfqueryparam cfsqltype="cf_sql_integer" value="#TGultimoId#">
				select @@rowcount as rc
			</cfquery>
			<cfif TGultimoId EQ 0 Or updateok.rc><cfbreak></cfif>
		</cfloop>
		<cfset EVselect = GetTickCount() - EVselect_inicio>
		<cfset admin_mark = GetTickCount()>
		<cfif acctlog.RecordCount Is 0>
			<!--- si no hay trabajo por realizar, indico el bloque de trabajo en ceros --->
			<cfset setEstado(Arguments.datasource, Arguments.servicio, '', '$', 0, 
				0, 0, 0, 0)>
		<cfelse>
			<!--- indico el bloque con el que voy a trabajar --->
			<cfset setEstado(Arguments.datasource, Arguments.servicio, '', '$', 0, 
				acctlog.log_id[1], acctlog.log_id[1], acctlog.log_id[acctlog.RecordCount], acctlog.RecordCount)>
		</cfif>
		<cfset EVadminTime = EVadminTime + (GetTickCount() - admin_mark)>
		
		
		<cfoutput query="acctlog" group="log_id">
			<cfset registro_inicio = GetTickCount()>
			<cfset lineno = 0>
			<cfset blob_full = ''>
			<cfset secuencia_incompleta = false>
			<cfset blob_data_len = 0>
			<cfoutput>
				<cfset lineno = lineno+1>
				<cfset blob_full = blob_full & blob_data>
				<cfset blob_data_len = Len(blob_data)>
				<cfif lineno neq blob_ordinal>
					<cfset secuencia_incompleta = true>
				</cfif>
			</cfoutput>
			<cfset ultimo_atributo = Trim(ListFirst(ListLast(blob_full, Chr(9)), '='))>
			
	
			<cfif (Not secuencia_incompleta) 
				  And (blob_data_len LT 255 or ListFind('nas-tx-speed,Acct-Delay-Time', ultimo_atributo) )>
				<!--- Registro completo, procesar --->
	

				<!--- primero indico con quién estoy trabajando por si hay errores que se guarden estos dos datos --->
				<cfset form.blob_data = blob_full>
				<cfset form.log_id = acctlog.log_id>
				
				<cfset blob_array = ListToArray(blob_full, Chr(9))>
				<cfset blob_struct = StructNew()>
				<cfset blob_struct.access_server = blob_array[1]>
				
				<cfif ArrayLen(blob_array) GE 2> 
				<cfset blob_struct.isb_login_name = blob_array[2]>
				<cfelse>
				<cfset blob_struct.isb_login_name = "sinlogin">
				</cfif>
				
				<!--- // no se usa
				<cfset blob_struct.serial_port = blob_array[3]>  --->
				
				<cfif ArrayLen(blob_array) GE 4> 
				<cfset blob_struct.telephone = blob_array[4]>
				<cfelse>
				<cfset blob_struct.telephone = "0000000">
				</cfif>
				
				<cfif ArrayLen(blob_array) GE 5> 
				<cfset blob_struct.command = blob_array[5]>
				<cfelse>
				<cfset blob_struct.command = "_">
				</cfif>
				
				
				
				<!--- // no se usa
				<cfset blob_struct.cs_server = blob_array[6]> --->
				
				<cfloop from="7" to="#ArrayLen(blob_array)#" index="i">
					<cfif ListLen(blob_array[i], '=') EQ 2>
						<cfset key = Trim(ListFirst(blob_array[i], '='))>
						<cfset key = Replace(key, '-', '_', 'all')>
						<cfset key = Replace(key, ' ', '_', 'all')>
						<cfset StructInsert(blob_struct, key, Trim(ListRest(blob_array[i], '=')), true)>
					</cfif>
				</cfloop>
				
				<cfparam name="blob_struct.time" default="00:00:00">
				<cfparam name="blob_struct.date" default="01/01/1999">
				<!---<cfif StructKeyExists(blob_struct, 'Framed_Protocol')>--->
				<cfif StructKeyExists(blob_struct, 'Acct_Session_Time')>
					<!--- es RADIUS ! --->
					<cfset protocolo = 'R'>
					
					<cfif StructKeyExists(blob_struct, 'Login_Service')>
					<cfset blob_struct.service = LCase(blob_struct.Login_Service)></cfif>
					
					<cfif StructKeyExists(blob_struct, 'Acct_Session_Time')>
						<cfset blob_struct.elapsed_time = blob_struct.Acct_Session_Time></cfif>
						
					<cfif StructKeyExists(blob_struct, 'Framed_Address')>
						<cfset blob_struct.addr = blob_struct.Framed_Address></cfif>
						
					<cfif StructKeyExists(blob_struct, 'Acct_Input_Octets')>
						<cfset blob_struct.bytes_in = blob_struct.Acct_Input_Octets></cfif>
						
					<cfif StructKeyExists(blob_struct, 'Acct_Output_Octets')>
						<cfset blob_struct.bytes_out = blob_struct.Acct_Output_Octets></cfif>

				<cfelse>
					<cfset protocolo = 'T'>
				</cfif>
				
				<cfparam name="blob_struct.service" default="_">
				<cfparam name="blob_struct.elapsed_time" default="0">
				<cfparam name="blob_struct.start_time" default="">
				<cfparam name="blob_struct.addr" default="">
				<cfparam name="blob_struct.bytes_in" default="">
				<cfparam name="blob_struct.bytes_out" default="">
				<cfparam name="blob_struct.nas_tx_speed" default="">
				<cfparam name="blob_struct.nas_rx_speed" default="">
				
				<!--- date time en formato dd/MM/yyyy HH:mm:ss --->
				
				<cfset EVfinal = dtparser.parse (blob_struct.date & ' ' & blob_struct.time)>
				<cfif REFind('^[0-9]+$', blob_struct.start_time)>
					<cfset EVinicio = DateAdd('h',-6,(DateAdd('s', blob_struct.start_time, CreateDate(1970, 1, 1))) )>
				<cfelseif REFind('^[0-9]+$', blob_struct.elapsed_time)>
					<cfset EVinicio = DateAdd('s', -blob_struct.elapsed_time, EVfinal)>
				<cfelse>
					<cfset EVinicio = EVfinal>
				</cfif>
				
					
				<!--- Limitar los valores a enteros, de lo contrario eliminarlos --->
				<cfif blob_struct.elapsed_time GT 2147483647>
					<cfset blob_struct.elapsed_time = 0>
				</cfif>
				<cfif blob_struct.nas_rx_speed GT 2147483647>
					<cfset blob_struct.nas_rx_speed = 0>
				</cfif>
				<cfif blob_struct.nas_tx_speed GT 2147483647>
					<cfset blob_struct.nas_tx_speed = 0>
				</cfif>
				<cfif blob_struct.bytes_in GT 2147483647>
					<cfset blob_struct.bytes_in = 0>
				</cfif>
				<cfif blob_struct.bytes_out GT 2147483647>
					<cfset blob_struct.bytes_out = 0>
				</cfif>
				
				<cfset EVmonto = 0 ><!--- ?? --->
				<!---
					Probé tanto cfquery como cfstoredproc y, curiosamente,
					el primero resultó ser ligeramente más eficiente. danim, 27-Feb-2006
				--->

				
				<!---<cflog file="isb_tasacion" text="log_id=#acctlog.log_id#">
				<cflog file="isb_tasacion" text="blob_struct.command=#blob_struct.command#">
				<cflog file="isb_tasacion" text="blob_struct.service=#blob_struct.service#">--->
				<!---
				<cflog file="isb_tasacion" text="blob_struct.elapsed_time=#blob_struct.elapsed_time#">
				<cflog file="isb_tasacion" text="blob_struct.time=#blob_struct.time#">
				<cflog file="isb_tasacion" text="blob_struct.date#blob_struct.date#">
				<cflog file="isb_tasacion" text="EVinicio=#EVinicio#">
				<cflog file="isb_tasacion" text="EVfinal=#EVfinal#">--->
				
				
				
				<cfquery datasource="#Arguments.datasource#" name="insertado">
					exec isb_evento
					@command = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(blob_struct.command)#">,
					@service = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(blob_struct.service)#">,
					@login_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blob_struct.isb_login_name#" null="#Len(blob_struct.isb_login_name) eq 0#">,
					@EVinicio = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#EVinicio#">,
					@EVfinal = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#EVfinal#">,
					@EVduracion = <cfqueryparam cfsqltype="cf_sql_integer" value="#blob_struct.elapsed_time#" null="#Len(blob_struct.elapsed_time) EQ 0#">,
					@EVtelefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blob_struct.telephone#">,
					@EVmonto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EVmonto#" null="#Len(EVmonto) EQ 0#">,
					@protocolo = <cfqueryparam cfsqltype="cf_sql_char" value="#protocolo#">,
					@access_server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blob_struct.access_server#">,
					@ipaddr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blob_struct.addr#" null="#Len(blob_struct.addr) eq 0#">,
					@ipaddrNormal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#normalizar.normalizar_ip(blob_struct.addr)#" null="#Len(blob_struct.addr) eq 0#">,
					@log_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#acctlog.log_id#">,
					@bytes_in = <cfqueryparam cfsqltype="cf_sql_integer" value="#blob_struct.bytes_in#" null="#Len(blob_struct.bytes_in) eq 0#">,
					@bytes_out = <cfqueryparam cfsqltype="cf_sql_integer" value="#blob_struct.bytes_out#" null="#Len(blob_struct.bytes_out) eq 0#">,
					@tx_speed = <cfqueryparam cfsqltype="cf_sql_integer" value="#blob_struct.nas_tx_speed#" null="#Len(blob_struct.nas_tx_speed) eq 0#">,
					@rx_speed = <cfqueryparam cfsqltype="cf_sql_integer" value="#blob_struct.nas_rx_speed#" null="#Len(blob_struct.nas_rx_speed) eq 0#">,
					@blob_data = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blob_full#" null="#Len(blob_full) eq 0#">
				</cfquery>
				<cfset admin_mark = GetTickCount()>
				<cfif Len(insertado.rowsdeleted)>
					<cfset setEstado(Arguments.datasource, Arguments.servicio, '', '$', insertado.rowsdeleted, acctlog.log_id)>
					<cfset registros_total = registros_total + insertado.rowsdeleted>
				</cfif>
				<cfif insertado.status EQ 'M'>
					<cfset count_medio = count_medio + 1>
				<cfelseif insertado.status EQ 'P'>
					<cfset count_prepago = count_prepago + 1>
				<cfelseif insertado.status EQ 'L'>
					<cfset count_login = count_login + 1>
				<cfelseif insertado.status EQ 'N'>
					<cfset count_sintasar = count_sintasar + 1>
				<cfelseif insertado.status EQ '-'>
					<!---
						el '-' representa un registro que no se movió, por:
							- no era command=stop
							- no era service=ppp,vpdn
							- otro proceso me lo ganó y lo ignoro
						solamente el tercer caso se guarda en la bitácora
					--->
					<cfif Trim(blob_struct.command) Is 'stop' And ListFind('ppp,vpdn', Trim(blob_struct.service))>
						<cflog file="isb_tasacion" text="insertado.status = '#insertado.status#' , log_id = #acctlog.log_id#, command:{#Trim(blob_struct.command)#}, service:{#Trim(blob_struct.service)#}">
					</cfif>
				</cfif>
				<!---<cflog file="isb_tasacion" text="status: '#insertado.status#'; count_medio:#count_medio# count_login:#count_login# count_prepago:#count_prepago# count_sintasar:#count_sintasar#">--->
				<cfset EVadminTime = EVadminTime + (GetTickCount() - admin_mark)>
			</cfif><!--- cfif Registro Completo --->
			<cfset millis_registro = GetTickCount() - registro_inicio>
			<cfif EVmillisMax LT millis_registro>
				<cfset EVmillisMax = millis_registro>
			</cfif>
			<cfif EVmillisMin GT millis_registro>
				<cfset EVmillisMin = millis_registro>
			</cfif>
		</cfoutput>
		<cfset millis = GetTickCount() - start_time >
		<!---<cflog file="isb_tasacion" text="count_medio:#count_medio# count_login:#count_login# count_prepago:#count_prepago# count_sintasar:#count_sintasar#">--->

		<cfif (count_medio + count_login + count_prepago + count_sintasar) NEQ 0>
			<cfquery datasource="#Arguments.datasource#">
				insert into ISBeventoBitacora (
					EVregistro, EVservicio, EVcrudo, EVmedio, EVlogin, EVprepago, EVsintasar,
					EVmillis, EVcola, EVmillisMax, EVmillisMin, EVselect, EVadminTime)
				values (
					getdate(),
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.servicio#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#registros_total#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#count_medio#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#count_login#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#count_prepago#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#count_sintasar#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#millis#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#qsize.cant#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#EVmillisMax#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#EVmillisMin#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#EVselect#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#EVadminTime#"> )
			</cfquery>
		</cfif>
		
		<cfreturn registros_total>
	</cffunction>
	
	<cffunction name="run" output="false">
		<!--- Que no ejecute por siempre, solamente trabajará por diez minutos. Esto para evitar memory leaks --->
		<cfargument name="datasource" required="yes">
		<cfargument name="servicio" required="yes">
		
		<!---<cflock name="saci-tasador-#servicio#" timeout="5" throwontimeout="yes">--->
		<cfset hostname = getStatus(Arguments.datasource, Arguments.servicio).hostname>
		<cfset maxrows = getConfig(Arguments.datasource, hostname).maxFilas>
		<cfset thread = CreateObject("java", "java.lang.Thread")>
		<cfset setEstado(Arguments.datasource, Arguments.servicio, 'running', '')>
		<cfsetting requesttimeout="#15*60#"><!--- quince minutos, por si se pegara --->
		<cfset finish_time = DateAdd('n', 10, Now())><!--- diez minutos --->
		<cfset error_object = 0>
		<cftry>
			<!--- asegurar que exista el registro en ISBtasarGlobal --->
			<cfset global = getGlobal(Arguments.datasource)>
			<cfloop condition="DateCompare(finish_time, Now()) EQ 1 And getStatus(Arguments.datasource, Arguments.servicio).estado EQ 'running'">
				<cfset setEstado(Arguments.datasource, Arguments.servicio, '')>
				<cfset count_crudo = tasar (Arguments.datasource, Arguments.servicio, maxrows)>
				<cfif count_crudo>
					<cfset setEstado(Arguments.datasource, Arguments.servicio, '', '')>
				<cfelse>
					<cfset setEstado(Arguments.datasource, Arguments.servicio, 'sleeping', '')>
					<!--- Dar 10 segundos si no hay más trabajo. --->
					<cfset thread.sleep(10000)>
					<cfif FindNoCase('sleeping', getStatus(Arguments.datasource, Arguments.servicio).estado)>
						<cfset setEstado(Arguments.datasource, Arguments.servicio,'running')>
					</cfif>
				</cfif>
			</cfloop>
			
			<cfset setEstado(Arguments.datasource, Arguments.servicio, 'stopped')>
			
			<cfcatch type="any">
				<cflog file="isb_tasacion" text="tasacion::run #cfcatch.Message# #cfcatch.Detail#">
				<cfset error_message = cfcatch.Message & ' ' & cfcatch.Detail>
				<cfif IsDefined('cfcatch.TagContext') >
					<cfloop from="1" to="#ArrayLen(cfcatch.TagContext)#" index="i">
						<cfset error_message = error_message & Chr(13) & ' en ' & GetFileFromPath( cfcatch.TagContext[i].template ) & ':' & cfcatch.TagContext[i].line>
					</cfloop>
				</cfif>
				<cfset setEstado(Arguments.datasource, Arguments.servicio, 'stopped', error_message)>
				<cfthrow object="#cfcatch#">
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="datasource" required="yes">
		<cfargument name="servicio" required="yes">
		
		<cfif ListFind("runnable,running,sleeping", getStatus(Arguments.datasource, Arguments.servicio).estado)>
			<cfset setEstado(Arguments.datasource, Arguments.servicio, 'stopping')>
		</cfif>
	</cffunction>
	
	<cffunction name="start" output="false">
		<cfargument name="datasource" required="yes">
		<cfargument name="servicio" required="yes">

		<cfset var status = getStatus(Arguments.datasource, Arguments.servicio, false)>
		<cfif status.RecordCount EQ 0>
			<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="hostname"/>
			<cfquery datasource="#Arguments.datasource#">
				insert into ISBtasarStatus (
					servicio, hostname,
					bloqueInicio, bloqueFinal, bloqueCant, bloqueActual,
					estado, mensaje,
					horaMensaje, horaInicio, horaFinal, horaReporte,
					registrosTotal, datasource, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.servicio#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#hostname#">,
					
					0, 0, 0, 0,
					'runnable', ' ',
						getdate(),
						getdate(),
						getdate(),
						getdate(),
					0, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.datasource#">, 0)
			</cfquery>
		<cfelseif ListFind("stopped,stopping", status.estado )>
			<cfset setEstado(Arguments.datasource, Arguments.servicio, 'runnable', '$')>
		</cfif>
	</cffunction>

	<cffunction name="getGlobal" returntype="query" output="false">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="insertable" type="boolean" default="yes">
		
		<cfquery datasource="#Arguments.datasource#" name="config" maxrows="1">
			select TGultimoId
			from ISBtasarGlobal
		</cfquery>
		<cfif config.RecordCount>
			<cfreturn config>
		</cfif>
		<cfif Not Arguments.insertable>
			<cfthrow message="No se pudo insertar el registro global">
		</cfif>
		<cfquery datasource="#Arguments.datasource#">
			insert into ISBtasarGlobal (TGuno, TGultimoId)
			values (1, 0)
		</cfquery>
		<cfreturn getGlobal(Arguments.datasource, false)>
	</cffunction>
	
	<cffunction name="getConfig" returntype="query" output="false">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="hostname" type="string" required="yes">
		<cfargument name="insertable" type="boolean" default="yes">
		
		<cfquery datasource="#Arguments.datasource#" name="config">
			select procesos, maxFilas
			from ISBtasarConfig
			where hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.hostname#">
		</cfquery>
		<cfif config.RecordCount>
			<cfreturn config>
		</cfif>
		<cfif Not Arguments.insertable>
			<cfthrow message="No se pudo insertar el registro de configuración">
		</cfif>
		<cfquery datasource="#Arguments.datasource#">
			insert into ISBtasarConfig (hostname, procesos, maxFilas, BMUsucodigo, httpHost, httpPort)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.hostname#">,
				1, 100, 0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.hostname#">, 80)
		</cfquery>
		<cfreturn getConfig(Arguments.datasource, Arguments.hostname, false)>
	</cffunction>
	
	<cffunction name="getStatus" returntype="query" output="false">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="servicio" type="string" required="yes">
		<cfargument name="throwOnError" type="boolean" default="yes">
		
		<cfquery datasource="#Arguments.datasource#" name="getStatus_query">
			select s.estado, s.hostname
			from ISBtasarStatus s
			where s.servicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.servicio#">
		</cfquery>
		<cfif (getStatus_query.RecordCount EQ 0) And Arguments.throwOnError>
			<cfthrow message="getStatus regresó #getStatus_query.RecordCount# registros.  Debe regresar siempre un registro">
		</cfif>
		<cfreturn getStatus_query>
	</cffunction>
	
	<cffunction name="setEstado" returntype="void" output="false">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="servicio" type="string" required="yes">
		<cfargument name="estado" type="string" required="yes">
		<cfargument name="mensaje" type="string" default="$">
		<cfargument name="count_crudo" type="numeric" default="0">
		<cfargument name="bloqueActual" type="numeric" default="-1">
		<cfargument name="bloqueInicio" type="numeric" default="-1">
		<cfargument name="bloqueFinal" type="numeric" default="-1">
		<cfargument name="bloqueCant" type="numeric" default="-1">
		
		<cfquery datasource="#Arguments.datasource#">
			update ISBtasarStatus
			set horaReporte = getdate()
			<cfif Len(Arguments.estado)>
				, estado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.estado#">
				<cfif Arguments.estado EQ 'stopped'>
				, horaFinal = getdate()
				</cfif>
			</cfif>
			<cfif Arguments.mensaje Neq '$'>
				, mensaje = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.mensaje#">
				, horaMensaje = getdate()
			</cfif>
			<cfif Arguments.count_crudo>
				, registrosTotal = registrosTotal + <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.count_crudo#">
			</cfif>
			<cfif Arguments.bloqueActual NEQ -1>
				, bloqueActual = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.bloqueActual#">
			</cfif>
			<cfif Arguments.bloqueInicio NEQ -1>
				, bloqueInicio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.bloqueInicio#">
			</cfif>
			<cfif Arguments.bloqueFinal NEQ -1>
				, bloqueFinal = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.bloqueFinal#">
			</cfif>
			<cfif Arguments.bloqueCant NEQ -1>
				, bloqueCant = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.bloqueCant#">
			</cfif>
			, spid = @@spid
			, threadName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateObject('java', 'java.lang.Thread').currentThread().getName()#">
			where servicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.servicio#">
		</cfquery>
	</cffunction>
	
</cfcomponent>