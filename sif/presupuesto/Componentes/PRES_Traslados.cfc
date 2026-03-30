<cfcomponent>
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat" datasource="#session.dsn#" >
	<cffunction name="EnviarAAprobarTraslado" access="public" returntype="void">
		<cfargument name="CPDEid"					type="numeric" required="yes">

		<cfset sbRsTrasladoE(Arguments.CPDEid)>

		<cfif rsTrasladoE.recordcount eq 0>
			<cfthrow message="No existe el Documento de Traslado [id=#Arguments.CPDEid#]">
		<cfelseif rsTrasladoE.CPDEestadoDAE EQ 9 or rsTrasladoE.CPDEestadoDAE EQ 10>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue aprobado en un documento de Autorización Externa">
		<cfelseif rsTrasladoE.CPDEenAprobacion NEQ 0>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue enviado a aprobar">
		<cfelseif rsTrasladoE.CPDEaplicado NEQ 0>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue aplicado">
		<cfelseif rsTrasladoE.CPDErechazado NEQ 0>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue rechazado">
		</cfif>
		
		

		<!--- Verificaciones --->
		<cfset VerificarVerificaciones(Arguments.CPDEid)>
        
        <cfif rsTrasladoE.CPDEtipoDocumento EQ "E">
			<cfif rsDAE.CPDAEestado NEQ '1'>
				<cfthrow type="toUser" message="Documento de Autorización Externa #rsDAE.CPDAEcodigo# está en Pausa: no admite nuevos traslados">
			</cfif>
		</cfif>

		<!--- Cambia Estado a "En Aprobacion" o Trámite --->
		<cfquery datasource="#Session.DSN#">
			update CPDocumentoE
			   set CPDEenAprobacion = 1
				 , CPDEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				 , Usucodigo = #session.Usucodigo#
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>

		<!--- Escoge proceso de Aprobacion o Trámite --->
		<cfset LvarProcessId = 0>
		<cfif rsTrasladoE.CPTTaprobacion EQ 1>
			<cfif trim(rsTrasladoE.CPTTtramites) NEQ "">
				<cfset LvarProcessId = rsTrasladoE.CPTTtramites>
			</cfif>
		<cfelseif rsTrasladoE.CPTTaprobacion EQ 2>
			<cfset LvarOficinas = listToArray(listFirst(rsTrasladoE.CPTTtramites,"|"))>
			<cfset LvarTramites = listToArray(listLast(rsTrasladoE.CPTTtramites,"|"))>
			<cfloop index="i" from="1" to="#ArrayLen(LvarOficinas)#"> 
				<cfif LvarOficinas[i] EQ rsTrasladoE.OcodigoOri>
					<cfset LvarProcessId = LvarTramites[i]>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>

		<cfif LvarProcessId EQ 0>
			<!--- Proceso de Aprobación por Centro Funcional JOIN (Pantalla de Aprobación de Traslados de Presupuesto) --->
			<cfset LvarOrigen = ",#rsTrasladoE.CFidOrigen#">
			<cfset LvarCFidresp = rsTrasladoE.CFidOrigen>
			<cfloop condition="LvarCFidresp NEQ ''">
				<cfquery name="rsCForigen" datasource="#Session.DSN#">
					select CFidresp
					  from CFuncional
					 where Ecodigo=#session.Ecodigo#
					   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
				</cfquery>
				<cfset LvarCFidresp = rsCForigen.CFidresp>
				<cfset LvarOrigen = "#LvarOrigen#,#LvarCFidresp#">
			</cfloop>

			<cfset LvarCFidresp = rsTrasladoE.CFidDestino>
			<cfloop condition="LvarCFidresp NEQ '' AND find(',#LvarCFidresp#,',LvarOrigen) EQ 0">
				<cfquery name="rsCFdestino" datasource="#Session.DSN#">
					select CFidresp
					  from CFuncional
					 where Ecodigo=#session.Ecodigo#
					   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
				</cfquery>
				<cfset LvarCFidresp = rsCFdestino.CFidresp>
			</cfloop>

			<cfquery datasource="#Session.DSN#">
				insert into CPDocumentoA
				(CPDEid, CFid)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
					,#LvarCFidresp#
				)
			</cfquery>
			
			<!--- 
				ENVIAR MAILS:
				1. APROBADORES:
					A. 	Si no hay Aprobadores en CFid=#LvarCFidresp#:  
						(select Usucodigo from CPSeguridadUsuario where CFid=#LvarCFidresp# and CPSUaprobacion = 1)
							Si no hay Responsable en CFid=#LvarCFidresp#:
							(select CFuresponsable from CFuncional where CFid=#LvarCFidresp#)
								<cftrhow "No hay Aprobadores en el Centro Funcional #LvarCFidresp# al que se le asignó la aprobación del Traslado>
							else
								Insertar el Responsable en CPSeguridadUsuario
							fin
						fin
					B.	Enviar Mails a los Aprobadores en CFid=#LvarCFidresp#:
							"Tiene Traslado para aprobar"
				2. REGISTRADOR:
					A.	Enviar mail a #session.Usucodigo#
							"El trasalado se ha asignado al CFid=#LvarCFidresp# a los siguientes aprobadores:
								xxxx
								xxxx"
			 --->
			 <!--- Obtiene datos del Usuario --->
			 <cfquery name="rsFrom" datasource="#session.dsn#">
				select <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, <cf_dbfunction name="to_char" args="Pemail1"> as correo
				from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
				where Usucodigo = #session.usucodigo#
			 </cfquery>
			 <cfif rsFrom.recordcount eq 0 or len(trim(rsFrom.nombre)) eq 0 or len(trim(rsFrom.correo)) eq 0>
				<cf_errorCode	code = "50503" msg = "ERROR AL ENVIAR MAILS: Información personal incompleta.">
			 </cfif>
			 <cfset Lvar_nombrefrom = rsFrom.nombre>
			 <cfset Lvar_correofrom = rsFrom.correo>
			 <!--- Información del traslado --->
			 <cfif rsTrasladoE.recordcount eq 0 or len(trim(rsTrasladoE.NumTraslado)) eq 0 or len(trim(rsTrasladoE.CFidOrigen)) eq 0 or len(trim(rsTrasladoE.CFidDestino)) eq 0>
				<cf_errorCode	code = "50504" msg = "ERROR AL ENVIAR MAILS: Informacion del Traslado incompleta.">
			 </cfif>
			 <cfset Lvar_CFOrigen = rsTrasladoE.CFOrigen>
			 <cfset Lvar_CFDestino = rsTrasladoE.CFDestino>
			 <cfset Lvar_NumTraslado = rsTrasladoE.NumTraslado>
			 <!--- Obtiene aprobadores --->
			 <cfquery name="rsAprobadores" datasource="#session.dsn#">
				select <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, 
					<cf_dbfunction name="to_char" args="Pemail1"> as correo
				from CPSeguridadUsuario a 
					left outer join Usuario b 
						inner join DatosPersonales c 
						on b.datos_personales = c.datos_personales 
					on a.Usucodigo = b.Usucodigo
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
				and CPSUaprobacion = 1
			 </cfquery>
			 <cfif rsAprobadores.recordCount EQ 0>
				<cfquery name="rsAprobadores" datasource="#session.dsn#">
					select <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, 
						<cf_dbfunction name="to_char" args="Pemail1"> as correo, 
						CFuresponsable, CFcodigo
					from CFuncional a 
						left outer join Usuario b 
							inner join DatosPersonales c 
							on b.datos_personales = c.datos_personales 
						on a.CFuresponsable = b.Usucodigo
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
				</cfquery>
				<cfif len(trim(rsAprobadores.CFuresponsable)) eq 0>
					<cf_errorCode	code = "50505"
									msg  = "ERROR AL ENVIAR MAILS: No hay Aprobadores definidos en el Centro Funcional '@errorDat_1@' al que se le asignó la aprobación del Traslado"
									errorDat_1="#rsAprobadores.CFcodigo#"
					>
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select count(1) as cantidad from  CPSeguridadUsuario
					 where Ecodigo		= #session.Ecodigo#
					   and CFid			= #LvarCFidResp#
					   and Usucodigo	= #rsAprobadores.CFuresponsable#
				</cfquery>
				<cfif rsSQL.cantidad GT 0>
					<cfquery datasource="#session.dsn#">
						update CPSeguridadUsuario
						   set CPSUaprobacion = 1
						 where Ecodigo		= #session.Ecodigo#
						   and CFid			= #LvarCFidResp#
						   and Usucodigo	= #rsAprobadores.CFuresponsable#
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.dsn#">
						insert into CPSeguridadUsuario
							(Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion)
							values (#session.Ecodigo# , #LvarCFidResp#, #rsAprobadores.CFuresponsable#, 1,1,1,1,1)
					</cfquery>
				</cfif>
			 </cfif>
			 <!--- Genera el correo a los aprobadores --->
			 <cfsavecontent variable="MAILTOAPROBADORES">
				<!--- TEXTO DEL MAIL--->
				<cfinclude template="mailtoaprobadores.cfm">
				<!--- /TEXTO DEL MAIL--->
			 </cfsavecontent>
			 <!--- Envía el correo a los aprobadores --->
			 <cfloop query="rsAprobadores">
				<cfif rsAprobadores.correo NEQ "">
					<cfquery datasource="#session.dsn#">
						insert into SMTPQueue 
							(SMTPremitente, SMTPdestinatario, SMTPasunto,
							SMTPtexto, SMTPhtml)
						 values(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAprobadores.correo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="APROBACION DEL TRASLADO PRESUPUESTARIO #Lvar_NumTraslado#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOAPROBADORES#">,
							1)
					</cfquery>
				</cfif>
			</cfloop>
			<!--- Genera el correo al registrador --->
			<cfsavecontent variable="MAILTOREGISTRADOR">
				<!--- TEXTO DEL MAIL--->
				<cfinclude template="mailtoregistrador.cfm">
				<!--- /TEXTO DEL MAIL--->
			</cfsavecontent>
			<!--- Envía el correo al registrador --->
			<cfquery datasource="#session.dsn#">
				insert into SMTPQueue 
					(SMTPremitente, SMTPdestinatario, SMTPasunto,
					SMTPtexto, SMTPhtml)
				 values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="ASIGNACIÓN DEL TRASLADO PRESUPUESTARIO #Lvar_NumTraslado#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOREGISTRADOR#">,
					1)
			</cfquery>
			<!--- /ENVIAR MAILS --->
		<cfelse>
			<!--- Proceso de Aprobación por Trámite: #LvarProcessId# --->
			<cfif rsTrasladoE.ProcessInstanceId EQ "">
				<!--- Creación del Proceso de Trámite --->
				<cfquery name="rsSQL2" datasource="#session.dsn#">
					select 	dp.Pnombre #_Cat# ' ' #_Cat# dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 as Usuario
					  from Usuario u 
						inner join DatosPersonales dp 
							on dp.datos_personales=u.datos_personales
					  where u.Usucodigo = #session.Usucodigo#
				</cfquery>
				<cfset dataItems = StructNew()>
				<cfset dataItems.CPDEid 	    = Arguments.CPDEid >
				<cfset dataItems.Ecodigo     	= session.Ecodigo >
				<cfif rsTrasladoE.CPDEtipoDocumento EQ "T">
					<cfset LvarDescripcion = "Solicitud de Traslado Presupuestario No. #rsTrasladoE.NumTraslado#">
				<cfelse>
					<cfset LvarDescripcion = "Inclusión de Traslado de Presupuesto No. #rsTrasladoE.NumTraslado# al Documento de Autorización Externa #rsDAE.CPDAEcodigo#">
				</cfif>
				<cfset LvarDescripcion &= "<br>Solicitado por: #rsSQL2.Usuario#">
			
				<cfinvoke component="sif.Componentes.Workflow.Management" method="startProcess" returnvariable="processInstanceId">
					<cfinvokeargument name="ProcessId"	 		value="#LvarProcessId#">
					<cfinvokeargument name="RequesterId" 		value="#session.usucodigo#">
					<cfinvokeargument name="SubjectId"   		value="0">
					<cfinvokeargument name="Description" 		value="#LvarDescripcion#">
					<cfinvokeargument name="dataItems"   		value="#dataItems#">
					<cfinvokeargument name="ObtenerUltimaVer"   value="true">
					<cfinvokeargument name="TransaccionActiva"  value="true">
					
					<cfinvokeargument name="CForigenId" 		value="#rsTrasladoE.CFidOrigen#">
					<cfinvokeargument name="CFdestinoId" 		value="#rsTrasladoE.CFidDestino#">
				</cfinvoke>
	
				<cfif isdefined('processInstanceId') and processInstanceId GT 0>
					<cfquery datasource="#Session.DSN#">
						update CPDocumentoE
						   set ProcessInstanceId = #processInstanceId#
						 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
						   and Ecodigo = #Session.Ecodigo#
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="AprobarTraslado" access="public" returntype="void">
		<cfargument name="CPDEid"				type="numeric" required="yes">
		<cfargument name="AplicarAutExterna"	type="boolean" default="no">

		<cfset sbRsTrasladoE(Arguments.CPDEid)>

		<cfif rsTrasladoE.recordcount eq 0>
			<cfthrow message="No existe el Documento de Traslado [id=#Arguments.CPDEid#]">
		<cfelseif NOT Arguments.AplicarAutExterna AND (rsTrasladoE.CPDEestadoDAE EQ 9 or rsTrasladoE.CPDEestadoDAE EQ 10)>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue aprobado en un documento de Autorización Externa">
		<cfelseif rsTrasladoE.CPDEenAprobacion NEQ 1>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# no ha sido enviado a aprobar">
		<cfelseif rsTrasladoE.CPDEaplicado NEQ 0>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue aplicado">
		<cfelseif rsTrasladoE.CPDErechazado NEQ 0>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue rechazado">
		</cfif>

		<!--- Verificaciones --->
		<cfset VerificarVerificaciones(Arguments.CPDEid)>

		<!--- Aprobación, Aplicación y Afectación Presupuestaria --->
		<cfif rsTrasladoE.CPDEtipoDocumento EQ "T" OR Arguments.AplicarAutExterna>
			<!--- TRASLADOS INTERNOS 
				O APLICACION DE TRASLADOS EXTERNOS
			--->
			
			<cfif not isdefined("LobjControl")>
				<cfscript>
					LobjControl = CreateObject("component", "sif.Componentes.PRES_Presupuesto");
					LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true);
				</cfscript>
			</cfif>
				
			<cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
				insert into #Request.intPresupuesto# (
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					
					NumeroLinea, 
					CPPid, 
					CPCano, 
					CPCmes,
					CPcuenta, 
					Ocodigo,
					TipoMovimiento,
					
					Mcodigo,
					MontoOrigen, 
					TipoCambio, 
					Monto,
					
					NAPreferencia,
					LINreferencia
				)
				
				select 'PRCO' as ModuloOrigen,
					   a.CPDEnumeroDocumento as NumeroDocumento,
					   case a.CPDEtipoDocumento when 'R' then 'Provisión' when 'L' then 'Liberación' when 'T' then 'Traslado' when 'E' then 'Traslado Aut.Externa' else '' end as NumeroReferencia,
					   a.CPDEfechaDocumento as FechaDocumento,
					   a.CPCano as AnoDocumento,
					   a.CPCmes as MesDocumento,
					   
					   b.CPDDlinea as NumeroLinea,
					   b.CPPid,
					   b.CPCano,
					   b.CPCmes,
					   b.CPcuenta,
					   b.Ocodigo,
					   case a.CPDEtipoDocumento when 'R' then 'RP' when 'L' then 'RP' when 'T' then 'T' when 'E' then 'TE' else '' end as TipoMovimiento,
					   
					   c.Mcodigo,
					   (b.CPDDmonto * CPDDtipo) as MontoOrigen,
					   1.00 as TipoCambio,
					   (b.CPDDmonto * CPDDtipo) as Monto,
					   
					   null as NAPreferencia,
					   null as LINreferencia
				from CPDocumentoE a, CPDocumentoD b, CPresupuestoPeriodo c
				where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
				and a.Ecodigo = #Session.Ecodigo#
				and a.Ecodigo = b.Ecodigo
				and a.CPDEid = b.CPDEid
				and b.Ecodigo = c.Ecodigo
				and b.CPPid = c.CPPid
			</cfquery>
			
			<cfset LvarNAP = LobjControl.ControlPresupuestario('PRCO', rsTrasladoE.NumTraslado, rsTrasladoE.NumeroReferencia, rsTrasladoE.CPDEfechaDocumento, rsTrasladoE.CPCano, rsTrasladoE.CPCmes)>
			
			<cfif LvarNAP LT 0>
				<cfquery name="updDoc" datasource="#Session.DSN#">
					update CPDocumentoE
					   set NRP = #-LvarNAP#
					<cfif rsTrasladoE.CPDEtipoDocumento EQ "T">
						 , CPDEenAprobacion = 0
						 , CPDEmsgRechazo = 'Rechazo en Control Presupuestario: NRP=#-LvarNAP#'
					<cfelse>
						 , CPDEenAprobacion = 1
						 , CPDEestadoDAE = 11
					</cfif>
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					  and Ecodigo = #Session.Ecodigo#
				</cfquery>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					delete from CPDocumentoA
					 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					   and UsucodigoAprueba is null
				</cfquery>
			<cfelse>
				<cfquery name="updDoc" datasource="#Session.DSN#">
					update CPDocumentoE
					   set NAP = #LvarNAP#
						 , CPDEenAprobacion = 0
						 , CPDEaplicado 	= 1
					<cfif rsTrasladoE.CPDEtipoDocumento EQ "E">
						 , CPDEestadoDAE = 12
					</cfif>
						 , CPDEfechaAprueba = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
						 , UsucodigoAprueba = #session.Usucodigo#
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					  and Ecodigo = #Session.Ecodigo#
				</cfquery>
				<cfquery datasource="#Session.DSN#">
					update CPDocumentoA
					   set CPDAaplicado		= 1
						 , CPDAfechaAprueba	= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
						 , UsucodigoAprueba	= #session.Usucodigo#
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					  and UsucodigoAprueba is null
				</cfquery>
			</cfif>
			
			<!--- Obtiene CentroFuncional JOIN que aprueba: SI NO HAY TRAMITE --->
			<cfset LvarCFidresp = "">
			<cfset Lvar_CFaprueba = "">
			<cfif not Arguments.AplicarAutExterna>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select CFid
					  from CPDocumentoA
					 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					   and UsucodigoAprueba = #session.Usucodigo#
				</cfquery>
				<cfif rsSQL.CFid NEQ "">
					<cfset LvarCFidresp = rsSQL.CFid>
					 <cfquery name="rsCFaprueba" datasource="#session.dsn#">
						select CFcodigo #_Cat# ' ' #_Cat# CFdescripcion as CFaprueba
						from CFuncional 
						where Ecodigo = #Session.Ecodigo#
						and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
					 </cfquery>
					 <cfset Lvar_CFaprueba = rsCFaprueba.CFaprueba>
				</cfif>
			</cfif>
			
			<cfif LvarNAP LT 0>
				<!--- ENVIAR MAILS ---->
				<!--- enviar correo al registrador --->
				 <!--- obtiene monto origen --->
				 <cfquery name="rsSQL" datasource="#session.dsn#">
					select sum(CPDDmonto) as Monto
					from CPDocumentoD 
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					and CPDDtipo = -1
				 </cfquery>
				 <cfset Lvar_MontoOrigen = rsSQL.Monto>
				 <!--- Obtiene datos del Usuario Rechaza--->
				 <cfquery name="rsFrom" datasource="#session.dsn#">
					select <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, <cf_dbfunction name="to_char" args="Pemail1"> as correo
					from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
					where Usucodigo = #session.usucodigo#
				 </cfquery>
				 <cfset Lvar_nombrefrom = rsFrom.nombre>
				 <cfset Lvar_correofrom = rsFrom.correo>
				 <!--- Obtiene datos del Usuario Registrador --->
				 <cfquery name="rsRegistrador" datasource="#session.dsn#">
					select a.Usucodigo, a.CFidDestino, <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, <cf_dbfunction name="to_char" args="Pemail1"> as correo
					from CPDocumentoE a inner join Usuario b inner join DatosPersonales c on b.datos_personales = c.datos_personales on a.Usucodigo = b.Usucodigo
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					  and Ecodigo = #Session.Ecodigo#
				 </cfquery>
				 <cfset Lvar_registradornombre = rsRegistrador.nombre>
				 <cfset Lvar_registradorcorreo = rsRegistrador.correo>
				 <cfset Lvar_cfdestino = rsRegistrador.CFidDestino>
				 <!--- Genera el correo al registrador que aprueba --->
				<cfsavecontent variable="MAILTOREGISTRADORNRP">
					<!--- TEXTO DEL MAIL--->
					<cfinclude template="mailtoregistradornrp.cfm">
					<!--- /TEXTO DEL MAIL--->
				</cfsavecontent>
				<!--- Envía el correo al registrador que aprueba --->
				<cfquery datasource="#session.dsn#">
					insert into SMTPQueue 
						(SMTPremitente, SMTPdestinatario, SMTPasunto,
						SMTPtexto, SMTPhtml)
					 values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_registradorcorreo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="RECHAZO DEL TRASLADO PRESUPUESTARIO POR NRP">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOREGISTRADORNRP#">,
						1)
				</cfquery>
				<!--- /ENVIAR MAILS ---->
			<cfelse>
				<!--- 
					ENVIAR MAILS:
					1. REGISTRADOR:
						A.	Enviar mail a :
							select Usucodigo, CFidDestino from CPDocumentoE
							where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
							and Ecodigo = #Session.Ecodigo#
								"El trasalado fue aprobado por el CFid=#LvarCFidresp# por fulanito"
					2. APROBADORES del CFdestino:
							select Usucodigo from CPSeguridadUsuario where CFid=#rsSQL.CFidDestino# and CPSUaprobacion = 1
						A. 	Si no hay Aprobadores en CFid=#rsSQL.CFidDestino#:  
								Se agrega el Responsable del CFid=#rsSQL.CFidDestino# como Aprobador
							fin
							select Usucodigo from CPSeguridadUsuario where CFid=#rsSQL.CFidDestino# and CPSUaprobacion = 1
						B.	Enviar Mails a los Aprobadores en CFid=#LvarCFidresp#:
								"Le llegó plata al CFdestino"
				 --->
				 <!--- enviar correo al registrador --->
				 <!--- obtiene monto origen --->
				 <cfquery name="rsSQL" datasource="#session.dsn#">
					select sum(CPDDmonto) as Monto
					from CPDocumentoD 
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					and CPDDtipo = -1
				 </cfquery>
				 <cfif rsSQL.recordcount eq 0 or len(trim(rsSQL.Monto)) eq 0 or rsSQL.Monto LTE 0.00>
					<cf_errorCode	code = "50508" msg = "ERROR EN LA APROBACION DEL TRASLADO: Monto Origen del traslado incorrecto.">
				 </cfif>
				 <cfset Lvar_MontoOrigen = rsSQL.Monto>
				 <!--- Obtiene datos del Usuario --->
				 <cfquery name="rsFrom" datasource="#session.dsn#">
					select <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, <cf_dbfunction name="to_char" args="Pemail1"> as correo
					from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
					where Usucodigo = #session.usucodigo#
				 </cfquery>
				 <cfset Lvar_nombrefrom = rsFrom.nombre>
				 <cfset Lvar_correofrom = rsFrom.correo>

				 <!--- consulta el registrador --->
				 <cfquery name="rsRegistrador" datasource="#session.dsn#">
					select a.Usucodigo, a.CFidDestino, <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, <cf_dbfunction name="to_char" args="Pemail1"> as correo
					from CPDocumentoE a inner join Usuario b inner join DatosPersonales c on b.datos_personales = c.datos_personales on a.Usucodigo = b.Usucodigo
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					  and Ecodigo = #Session.Ecodigo#
				 </cfquery>
				 <cfset Lvar_registradornombre = rsRegistrador.nombre>
				 <cfset Lvar_registradorcorreo = rsRegistrador.correo>
				 <cfset Lvar_cfdestino = rsRegistrador.CFidDestino>

				 <!--- consulta el Documento --->
				 <cfquery name="rsTrasladoE" datasource="#session.dsn#">
					select CPDEnumeroDocumento as NOTRASLADO
						, a.CFidOrigen
						, a.CFidDestino
						, <cf_dbfunction name="to_char" args="b.CFcodigo #_Cat# ' - ' #_Cat# b.CFdescripcion"> as CFOrigen
						, <cf_dbfunction name="to_char" args="c.CFcodigo #_Cat# ' - ' #_Cat# c.CFdescripcion"> as CFDestino
					from CPDocumentoE a
						left outer join CFuncional b
							on a.CFidOrigen = b.CFid
						left outer join CFuncional c
							on a.CFidDestino = c.CFid
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
				 </cfquery>
				 <cfif rsTrasladoE.recordcount eq 0 or len(trim(rsTrasladoE.NOTRASLADO)) eq 0 or len(trim(rsTrasladoE.CFidOrigen)) eq 0 or len(trim(rsTrasladoE.CFidDestino)) eq 0>
					<cf_errorCode	code = "50504" msg = "ERROR AL ENVIAR MAILS: Informacion del Traslado incompleta.">
				 </cfif>
				 <cfset Lvar_CFOrigen = rsTrasladoE.CFOrigen>
				 <cfset Lvar_CFDestino = rsTrasladoE.CFDestino>
				 <cfset NOTRASLADO = rsTrasladoE.NOTRASLADO>
				 <!--- Genera el correo al registrador que aprueba: solo cuando hay CF JOIN y no es AutExterna --->
				<cfif LvarCFidresp NEQ "">
					<cfsavecontent variable="MAILTOREGISTRADORAPRUEBA">
						<!--- TEXTO DEL MAIL--->
						<cfinclude template="mailtoaprobadoresaprobado.cfm">
						<!--- /TEXTO DEL MAIL--->
					</cfsavecontent>
					<!--- Envía el correo al registrador que aprueba --->
					<cfquery datasource="#session.dsn#">
						insert into SMTPQueue 
							(SMTPremitente, SMTPdestinatario, SMTPasunto,
							SMTPtexto, SMTPhtml)
						 values(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_registradorcorreo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="APROBACIÓN DEL TRASLADO PRESUPUESTARIO #NOTRASLADO# (ORIGEN)">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOREGISTRADORAPRUEBA#">,
							1)
					</cfquery>
				</cfif>
				<!--- Envía el correo a los aprobadores del destino --->
				<!--- Obtiene aprobadores --->
				 <cfquery name="rsAprobadores" datasource="#session.dsn#">
					select <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, 
						<cf_dbfunction name="to_char" args="Pemail1"> as correo
					from CPSeguridadUsuario a 
						left outer join Usuario b 
							inner join DatosPersonales c 
							on b.datos_personales = c.datos_personales 
						on a.Usucodigo = b.Usucodigo
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTrasladoE.CFidDestino#">
					and CPSUaprobacion = 1
				 </cfquery>
				 <cfif rsAprobadores.recordCount EQ 0>
					<cfquery name="rsAprobadores" datasource="#session.dsn#">
						select <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, 
							<cf_dbfunction name="to_char" args="Pemail1"> as correo, 
							CFuresponsable, CFcodigo
						from CFuncional a 
							left outer join Usuario b 
								inner join DatosPersonales c 
								on b.datos_personales = c.datos_personales 
							on a.CFuresponsable = b.Usucodigo
						where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTrasladoE.CFidDestino#">
						  and CFuresponsable is not null
					</cfquery>
					<cfif rsAprobadores.recordCount GT 0>
						<cfthrow message="No se ha definido Usuario Aprobador en el Centro Funcional Destino">
					</cfif>

					<cfif len(trim(rsAprobadores.CFuresponsable)) NEQ 0>
						<cfset LvarNotificarDestino = true>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select count(1) as cantidad from  CPSeguridadUsuario
							 where Ecodigo		= #session.Ecodigo#
							   and CFid			= #rsTrasladoE.CFidDestino#
							   and Usucodigo	= #rsAprobadores.CFuresponsable#
						</cfquery>
						<cfif rsSQL.cantidad GT 0>
							<cfquery datasource="#session.dsn#">
								update CPSeguridadUsuario
								   set CPSUaprobacion = 1
								 where Ecodigo		= #session.Ecodigo#
								   and CFid			= #rsTrasladoE.CFidDestino#
								   and Usucodigo	= #rsAprobadores.CFuresponsable#
							</cfquery>
						<cfelse>
							<cfquery datasource="#session.dsn#">
								insert into CPSeguridadUsuario
									(Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion)
									values (#session.Ecodigo# , #rsTrasladoE.CFidDestino#, #rsAprobadores.CFuresponsable#, 1,1,1,1,1)
							</cfquery>
						</cfif>
					</cfif>
				 </cfif>
				 <!--- Genera el correo a los aprobadores del Destino--->
				 <cfsavecontent variable="MAILTOAPROBADORESAPROBADO">
					<!--- TEXTO DEL MAIL--->
					<cfinclude template="mailtoaprobadoresaprobado.cfm">
					<!--- /TEXTO DEL MAIL--->
				 </cfsavecontent>
				<!--- Envía el correo a al Destino --->
				<cfif rsAprobadores.recordCount EQ 0>
					<!--- Si no hay aprobadores en el DESTINO se lo envia al ORIGEN --->
					<cfquery datasource="#session.dsn#">
						insert into SMTPQueue 
							(SMTPremitente, SMTPdestinatario, SMTPasunto,
							SMTPtexto, SMTPhtml)
						 values(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_registradorcorreo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="APROBACIÓN DEL TRASLADO PRESUPUESTARIO #NOTRASLADO# (No se pudo enviar al Destino)">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOAPROBADORESAPROBADO#">,
							1)
					</cfquery>
				<cfelse>
					<cfquery name="rsParametro" datasource="#session.DSN#">
						select Pvalor
						from Parametros
						where Ecodigo = #session.Ecodigo#
						  and Pcodigo = 735
						  <!--- Enviar Correo de Aprobado al Centro Funcional Destino --->
					</cfquery>
					<cfif rsParametro.Pvalor neq "0">
						<cfset LvarRegistrador = rsRegistrador.correo>
						<cfloop query="rsAprobadores">
							<cfif rsAprobadores.correo NEQ "">
								<cfif rsAprobadores.correo NEQ LvarRegistrador>
									<cfquery datasource="#session.dsn#">
										insert into SMTPQueue 
											(SMTPremitente, SMTPdestinatario, SMTPasunto,
											SMTPtexto, SMTPhtml)
										 values(
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAprobadores.correo#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="APROBACIÓN DEL TRASLADO PRESUPUESTARIO #NOTRASLADO# (DESTINO)">,
											<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOAPROBADORESAPROBADO#">,
											1)
									</cfquery>
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
				<!--- /ENVIAR MAILS --->
			</cfif>

			<cfif LvarNAP LT 0 AND rsTrasladoE.CPDEtipoDocumento EQ "T">
				<!---
				<cf_errorCode	code = "50499"
								msg  = "RECHAZO EN CONTROL PRESUPUESTARIO: El documento generó un Número de Rechazo Presupuestario NRP = @errorDat_1@ porque existe un exceso de presupuesto no autorizado"
								errorDat_1="#abs(LvarNAP)#"
				>
				--->
				<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
			</cfif>
		<cfelse>
			<!--- TRASLADOS EXTERNOS --->
			<!--- Aprobación o Preaprobación dentro de un Documento de Autorización Externa --->

			<cfif rsDAE.CPDAEestado NEQ '1' AND rsDAE.CPDAEestado NEQ '2'>
				<cfthrow type="toUser" message="Documento de Autorización Externa #rsDAE.CPDAEcodigo# está cerrado: no admite aprobar nuevos traslados">
			</cfif>

			<cfquery name="rsTOT" datasource="#session.dsn#">
				select sum(CPDDmonto) as Monto
				  from CPDocumentoD d
				  	inner join CPDocumentoE e
						on e.CPDEid = d.CPDEid
				 where e.Ecodigo			= #session.Ecodigo#
				   and e.CPDEtipoDocumento	= 'E'
				   and e.CPDAEid			= #rsTrasladoE.CPDAEid#
				   and e.CFidOrigen			= #rsTrasladoE.CFidOrigen#
				   and e.CPDEestadoDAE		= 10
				   and d.CPDDtipo			= -1
			</cfquery>

			<cfquery name="updDoc" datasource="#Session.DSN#">
				update CPDocumentoE
				   set CPDEenAprobacion = 1
					 , CPDEestadoDAE	= <cfif rsDAE.CPDAEmontoCF EQ 0 or rsTOT.Monto LTE rsDAE.CPDAEmontoCF>10<cfelse>9</cfif>
					 , CPDEfechaAprueba = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					 , UsucodigoAprueba = #session.Usucodigo#
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
				  and Ecodigo = #Session.Ecodigo#
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="RechazarTraslado" access="public" returntype="void">
		<cfargument name="CPDEid"			type="numeric" required="yes">
		<cfargument name="CPDEmsgRechazo"	type="string" required="yes">

		<cfset sbRsTrasladoE(Arguments.CPDEid)>

		<cfif rsTrasladoE.recordcount eq 0>
			<cfthrow message="No existe el Documento de Traslado [id=#Arguments.CPDEid#]">
		<cfelseif rsTrasladoE.CPDEaplicado NEQ 0>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue aplicado">
		<cfelseif rsTrasladoE.CPDErechazado NEQ 0>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# ya fue rechazado">
		<cfelseif rsTrasladoE.CPDEenAprobacion NEQ 1>
			<cfthrow message="El Documento de Traslado #rsTrasladoE.NumTraslado# no ha sido enviado a aprobar">
		</cfif>

		<cfquery name="updDoc" datasource="#Session.DSN#">
			update CPDocumentoE
			   set CPDErechazado	= 1
				 , CPDEenAprobacion = 0
				 , CPDEestadoDAE	= 0
				 , CPDEmsgRechazo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CPDEmsgrechazo#">
				 , CPDEfechaAprueba = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				 , UsucodigoAprueba = #session.Usucodigo#
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			update CPDocumentoA
			   set CPDArechazado	= 1
				 , CPDAfechaAprueba	= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				 , UsucodigoAprueba	= #session.Usucodigo#
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
			  and UsucodigoAprueba is null
		</cfquery>

		<!--- Obtiene CentroFuncional JOIN que aprueba: SI NO HAY TRAMITE --->
		<cfset LvarCFidresp = "">
		<cfset Lvar_CFrechazo = "">
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select CFid
			  from CPDocumentoA
			 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
			   and UsucodigoAprueba = #session.Usucodigo#
		</cfquery>
		<cfif LvarCFidresp NEQ "">
			<cfset LvarCFidresp = rsSQL.CFid>
			<cfquery name="rsCFrechazo" datasource="#session.dsn#">
				select CFcodigo #_Cat# ' ' #_Cat# CFdescripcion as CFrechazo
				  from CFuncional 
				 where Ecodigo = #Session.Ecodigo#
				   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
			</cfquery>
			<cfset Lvar_CFrechazo = rsCFrechazo.CFrechazo>
		</cfif>

		<!--- 
			ENVIAR MAILS:
			1. REGISTRADOR:
				A.	Enviar mail a :
					select Usucodigo from CPDocumentoE
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
					and Ecodigo = #Session.Ecodigo#
						"El trasalado se ha rechazado por el CFid=#LvarCFidresp# por fulanito"
		--->

		<!--- Obtiene datos del Usuario que rechaza --->
		<cfquery name="rsFrom" datasource="#session.dsn#">
			select <cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, <cf_dbfunction name="to_char" args="Pemail1"> as correo
			from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
			where Usucodigo = #session.usucodigo#
		</cfquery>
		<cfset Lvar_nombrerechazo = rsFrom.nombre>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select sum(CPDDmonto) as Monto
			from CPDocumentoD 
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
			and CPDDtipo = -1
		 </cfquery>
		 <cfset Lvar_MontoOrigen = rsSQL.Monto>
		<!--- información del registrador --->
		<cfquery name="rsRegistrador" datasource="#session.dsn#">
			select a.Usucodigo,<cf_dbfunction name="to_char" args="Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre"> as nombre, 
				<cf_dbfunction name="to_char" args="Pemail1"> as correo, CPDEnumeroDocumento as NOTRASLADO
			from CPDocumentoE a
				left outer join Usuario b 
					inner join DatosPersonales c 
					on b.datos_personales = c.datos_personales 
				on a.Usucodigo = b.Usucodigo
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPDEid#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<!--- Genera el correo al registrador --->
		<cfsavecontent variable="MAILTOREGISTRADORRECHAZO">
			<!--- TEXTO DEL MAIL--->
			<cfset LvarCPDEmsgrechazo = Arguments.CPDEmsgRechazo>
			<cfinclude template="mailtoregistradorrechazo.cfm">
			<!--- /TEXTO DEL MAIL--->
		</cfsavecontent>
		<!--- Envía el correo al registrador --->
		<cfquery datasource="#session.dsn#">
			insert into SMTPQueue 
				(SMTPremitente, SMTPdestinatario, SMTPasunto,
				SMTPtexto, SMTPhtml)
			 values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFrom.correo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRegistrador.correo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="RECHAZO DEL TRASLADO PRESUPUESTARIO #rsRegistrador.NOTRASLADO#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOREGISTRADORRECHAZO#">,
				1)
		</cfquery>
		<!--- /ENVIAR MAILS --->
	</cffunction>

	<cffunction name="VerificarVerificaciones" access="public" output="false" returntype="void">
		<cfargument name="CPDEid"			type="numeric" required="yes">
		<cfargument name="SoloCFs"			type="boolean" default="no">
		
		<cfset sbRsTrasladoE(Arguments.CPDEid)>

		<cfif rsTrasladoE.CPDEtipoDocumento EQ "E">
			<cfif rsTrasladoE.CPDAEid EQ "">
				<cfthrow message="Falta indicar el Documento de Autorización Externa">
			</cfif>
			<cfquery name="rsDAE" datasource="#session.dsn#">
				select CPPid, CPDAEid, CPDAEcodigo, CPDAEmontoCF, CPDAEestado
				  from CPDocumentoAE
				 where CPDAEid = #rsTrasladoE.CPDAEid#
			</cfquery>
			<cfif rsDAE.CPDAEid EQ "">
				<cfthrow message="No existe Documento de Autorización Externa [id=#rsTrasladoE.CPDAEid#]">
			<cfelseif rsDAE.CPPid NEQ rsTrasladoE.CPPid>
				<cfthrow message="Documento de Autorización Externa #rsDAE.CPDAEcodigo# pertenece a otro Período de Presupuesto">
			</cfif>
		</cfif>

		<cfif NOT Arguments.SoloCFs>
			<cfset LvarDeCtaEnCta = rsTrasladoE.CPDEtipoAsignacion EQ 0>
			<cfif LvarDeCtaEnCta>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select 	abs(CPDDlinea) as linea, count(1) as cantidad
					  from CPDocumentoD
					 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
					 group by abs(CPDDlinea)
					 having count(1) <> 2
				</cfquery>
				<cfif rsSQL.recordCount GT 0>
					<cfthrow message="El traslado requiere el mismo numero de Partidas Origen y Destino">
				</cfif>
			</cfif>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				select sum(CPDDmonto) as Monto
				from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				and CPDDtipo = -1
			</cfquery>
			<cfif rsSQL.recordcount eq 0>
				<cf_errorCode	code = "50506" msg = "ERROR AL VERIFICAR TRASLADO: Debe haber al menos una partidad Origen y una partida Destino">
			<cfelseif len(trim(rsSQL.Monto)) eq 0 or rsSQL.Monto LTE 0.00>
				<cf_errorCode	code = "50500" msg = "ERROR AL VERIFICAR TRASLADO: Monto Origen del traslado incorrecto.">
			</cfif>
			<cfset Lvar_MontoOrigen = rsSQL.Monto>
			
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select sum(CPDDmonto) as Monto
				from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				and CPDDtipo = 1
			</cfquery>
			<cfif rsSQL.recordcount eq 0>
				<cf_errorCode	code = "50506" msg = "ERROR AL VERIFICAR TRASLADO: Debe haber al menos una partida Origen y una partida Destino">
			<cfelseif len(trim(rsSQL.Monto)) eq 0 or rsSQL.Monto LTE 0.00>
				<cf_errorCode	code = "50501" msg = "ERROR AL VERIFICAR TRASLADO: Monto Destino del traslado incorrecto.">
			</cfif>
			<cfset Lvar_MontoDestino = rsSQL.Monto>
			<cfif Lvar_MontoOrigen neq Lvar_MontoDestino>
				<cf_errorCode	code = "50502"
								msg  = "ERROR AL VERIFICAR TRASLADO: La suma del monto origen y destino son diferentes: Origen @errorDat_1@ - Destino @errorDat_2@"
								errorDat_1="#LSNumberFormat(Lvar_MontoOrigen,',9.00')#"
								errorDat_2="#LSNumberFormat(Lvar_MontoDestino,',9.00')#"
				>
			</cfif>
		</cfif>

		<cfif rsTrasladoE.CPTTverificaciones EQ "">
			<cfreturn>
		</cfif>

		<cfset LvarVerifica_tipos =  listToArray(listFirst(rsTrasladoE.CPTTverificaciones,"|"))>
		<cfset LvarVerifica_valors = listToArray(listLast(rsTrasladoE.CPTTverificaciones,"|"))>
		<cfloop index="i" from="1" to="#arrayLen(LvarVerifica_tipos)#">
		<!--- Estas Verificaciones se realizan siempre --->
			<cfif LvarVerifica_tipos[i] EQ 1>
				<!--- Mismo Centro Funcional --->
				<cfif rsTrasladoE.CFidOrigen NEQ rsTrasladoE.CFidDestino>
					<cfthrow type="toUser" message="El Centro Funcional Origen (CF=#trim(rsTrasladoE.CFori)#) debe ser igual al Centro Funcional Destino (CF=#trim(rsTrasladoE.CFdst)#)">
				</cfif>
			<cfelseif LvarVerifica_tipos[i] EQ -1>
				<!--- Mismo Centro Funcional --->
				<cfif rsTrasladoE.CFidOrigen EQ rsTrasladoE.CFidDestino>
					<cfthrow type="toUser" message="El Centro Funcional Origen (CF=#trim(rsTrasladoE.CFori)#) debe ser distinto al Centro Funcional Destino (CF=#trim(rsTrasladoE.CFdst)#)">
				</cfif>
			<cfelseif LvarVerifica_tipos[i] EQ 2>
				<!--- Misma Oficina --->
				<cfif rsTrasladoE.OcodigoOri NEQ rsTrasladoE.OcodigoDst>
					<cfthrow type="toUser" message="La Oficina Origen (CF=#trim(rsTrasladoE.CFori)#, Ofi=#trim(rsTrasladoE.OFIori)#) debe ser igual a la Oficina Destino (CF=#trim(rsTrasladoE.CFdst)#, Ofi=#trim(rsTrasladoE.OFIdst)#)">
				</cfif>
			<cfelseif LvarVerifica_tipos[i] EQ -2>
				<!--- Misma Oficina --->
				<cfif rsTrasladoE.OcodigoOri EQ rsTrasladoE.OcodigoDst>
					<cfthrow type="toUser" message="La Oficina Origen (CF=#trim(rsTrasladoE.CFori)#, Ofi=#trim(rsTrasladoE.OFIori)#) debe ser distinta a la Oficina Destino (CF=#trim(rsTrasladoE.CFdst)#, Ofi=#trim(rsTrasladoE.OFIdst)#)">
				</cfif>
			<cfelseif LvarVerifica_tipos[i] EQ 3>
				<!--- Grupo de Oficinas --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select GOnombre
					  from AnexoGOficina
					 where Ecodigo = #session.Ecodigo#
					   and GOid = #LvarVerifica_valors[i]#
				</cfquery>
				<cfset LvarGrupo = rsSQL.GOnombre>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from AnexoGOficinaDet
					 where Ecodigo = #session.Ecodigo#
					   and GOid = #LvarVerifica_valors[i]#
					   and Ocodigo = #rsTrasladoE.OcodigoOri#
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfthrow type="toUser" message="La Oficina Origen (CF=#trim(rsTrasladoE.CFori)#, Ofi=#trim(rsTrasladoE.OFIori)#) debe pertenecer al Grupo de Oficinas '#LvarGrupo#'">
				</cfif>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from AnexoGOficinaDet
					 where Ecodigo = #session.Ecodigo#
					   and GOid = #LvarVerifica_valors[i]#
					   and Ocodigo = #rsTrasladoE.OcodigoDst#
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfthrow type="toUser" message="La Oficina Destino (CF=#trim(rsTrasladoE.CFdst)#, Ofi=#trim(rsTrasladoE.OFIdst)#) debe pertenecer al Grupo de Oficinas '#LvarGrupo#'">
				</cfif>
			<cfelseif abs(LvarVerifica_tipos[i]) EQ 7>
				<!--- Mismo Grupo de Oficinas de un Tipo de Grupo de Oficinas --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select GOTid, GOTnombre
					  from AnexoGOTipo
					 where Ecodigo = #session.Ecodigo#
					   and GOTid = #LvarVerifica_valors[i]#
				</cfquery>
				<cfset LvarTipoGrupo = rsSQL.GOTnombre>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select GOnombre
					  from AnexoGOficina
					 where Ecodigo = #session.Ecodigo#
					   and GOid = #LvarVerifica_valors[i]#
				</cfquery>
				<cfset LvarGrupo = rsSQL.GOnombre>

				<cfquery name="rsGOori" datasource="#Session.DSN#">
					select d.GOid, g.GOnombre
					  from AnexoGOficinaDet d
					  	inner join AnexoGOficina g
							on g.GOid = d.GOid
					 where g.Ecodigo = #session.Ecodigo#
					   and g.GOTid = #LvarVerifica_valors[i]#
					   and d.Ocodigo = #rsTrasladoE.OcodigoOri#
				</cfquery>
				<cfif rsGOori.recordCount EQ 0>
					<cfthrow type="toUser" message="La Oficina Origen (CF=#trim(rsTrasladoE.CFori)#, Ofi=#trim(rsTrasladoE.OFIori)#) debe pertenecer a algún Grupo de Oficinas Tipo '#LvarTipoGrupo#'">
				<cfelseif rsGOori.recordCount GT 1>
					<cfthrow type="toUser" message="La Oficina Origen (CF=#trim(rsTrasladoE.CFori)#, Ofi=#trim(rsTrasladoE.OFIori)#) pertenece a más de un Grupo de Oficinas Tipo '#LvarTipoGrupo#'">
				</cfif>
				<cfquery name="rsGOdst" datasource="#Session.DSN#">
					select d.GOid, g.GOnombre
					  from AnexoGOficinaDet d
					  	inner join AnexoGOficina g
							on g.GOid = d.GOid
					 where g.Ecodigo	= #session.Ecodigo#
					   and g.GOTid		= #LvarVerifica_valors[i]#
					   and d.Ocodigo	= #rsTrasladoE.OcodigoDst#
				</cfquery>
				<cfif rsGOdst.recordCount EQ 0>
					<cfthrow type="toUser" message="La Oficina Destino (CF=#trim(rsTrasladoE.CFdst)#, Ofi=#trim(rsTrasladoE.OFIdst)#) debe pertenecer a algún Grupo de Oficinas Tipo '#LvarTipoGrupo#'">
				<cfelseif rsGOdst.recordCount GT 1>
					<cfthrow type="toUser" message="La Oficina Destino (CF=#trim(rsTrasladoE.CFdst)#, Ofi=#trim(rsTrasladoE.OFIdst)#) pertenece a más de un Grupo de Oficinas Tipo '#LvarTipoGrupo#'">
				</cfif>
				<cfif LvarVerifica_tipos[i] EQ 7 AND rsGOori.GOid NEQ rsGOdst.GOid>
					<cfthrow type="toUser" message="Grupos de Oficinas '#LvarTipoGrupo#':<BR> El Grupo de Oficinas Origen (CF=#trim(rsTrasladoE.CFori)#, Ofi=#trim(rsTrasladoE.OFIori)#, Grupo=#trim(rsGOori.GOnombre)#) debe ser igual al Grupo de Oficinas Destino (CF=#trim(rsTrasladoE.CFdst)#, Ofi=#trim(rsTrasladoE.OFIdst)#, Grupo=#trim(rsGOdst.GOnombre)#)">
				<cfelseif LvarVerifica_tipos[i] EQ -7 AND rsGOori.GOid EQ rsGOdst.GOid>
					<cfthrow type="toUser" message="Grupos de Oficinas '#LvarTipoGrupo#':<BR> El Grupo de Oficinas Origen (CF=#trim(rsTrasladoE.CFori)#, Ofi=#trim(rsTrasladoE.OFIori)#, Grupo=#trim(rsGOori.GOnombre)#) debe ser distinto al Grupo de Oficinas Destino (CF=#trim(rsTrasladoE.CFdst)#, Ofi=#trim(rsTrasladoE.OFIdst)#, Grupo=#trim(rsGOdst.GOnombre)#)">
				</cfif>
		<!--- Estas Verificaciones se realizan sólo cuando no está prendido sóloCFs --->
			<cfelseif NOT Arguments.SoloCFs>
				<!--- Nivel de Cuenta --->
				<cfif LvarVerifica_tipos[i] EQ 4>
					<!--- Nivel de Cuenta --->
					<cfquery name="rsSQL" datasource="#Session.DSN#">
						select abs(d.CPDDlinea) as orden, d.CPDDlinea, cta.CPformato
						  from CPDocumentoD d
							inner join CPresupuesto cta
								on cta.CPcuenta = d.CPcuenta
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
						order by 1,2
					</cfquery>
					<cfloop query="rsSQL">
						<cfif listLen(rsSQL.CPformato,"-") LT LvarVerifica_valors[i]+1>
							<cfthrow type="toUser" message="Cuenta #rsSQL.CPformato# debe tener por lo menos #LvarVerifica_valors[i]# niveles">
						</cfif>
						<cfset LvarValor = listGetAt(rsSQL.CPformato,LvarVerifica_valors[i]+1,"-")>
						<cfif rsSQL.currentRow EQ 1 OR (LvarDeCtaEnCta AND rsSQL.CPDDlinea LT 0)>
							<cfset LvarCtaAnt = "#rsSQL.CPformato# de la linea #rsSQL.Orden#">
							<cfset LvarValorAnt = LvarValor>
						</cfif>
						
						<cfif LvarValorAnt NEQ LvarValor>
							<cfthrow type="toUser" message="La Cuenta #rsSQL.CPformato# tiene en el nivel #LvarVerifica_valors[i]# el valor #LvarValor#, pero debe ser igual que el valor '#LvarValorAnt#' de la cuenta #LvarCtaAnt#">
						</cfif>
					</cfloop>
				<cfelseif LvarVerifica_tipos[i] EQ 5>
					<!--- Valor de Catálogo --->
					<cfquery name="rsCat" datasource="#Session.DSN#">
						select PCEcatid, PCEcodigo, PCEdescripcion
						  from PCECatalogo
						 where PCEcatid = #LvarVerifica_valors[i]#
					</cfquery>
					<cfset LvarDeCtaEnCta = rsTrasladoE.CPDEtipoAsignacion EQ 0>
					<cfquery name="rsSQL" datasource="#Session.DSN#">
						select abs(d.CPDDlinea) as orden, d.CPDDlinea, cta.CPcuenta, cta.CPformato
						  from CPDocumentoD d
							inner join CPresupuesto cta
								on cta.CPcuenta = d.CPcuenta
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
						order by 1,2
					</cfquery>
					<cfloop query="rsSQL">
						<cfquery name="rsSQL1" datasource="#Session.DSN#">
							select cubo.PCDcatid, v.PCDvalor, cubo.PCDCniv
							  from PCDCatalogoCuentaP cubo
								inner join PCDCatalogo v
									on v.PCDcatid = cubo.PCDcatid
							 where cubo.CPcuenta = #rsSQL.CPcuenta#
							   and cubo.PCEcatid = #LvarVerifica_valors[i]#
						</cfquery>
						<cfif rsSQL1.PCDcatid EQ "">
							<cfthrow type="toUser" message="La Cuenta #rsSQL.CPformato# no contiene niveles del Catálogo #rsCat.PCEcodigo#-#rsCat.PCEdescripcion#">
						</cfif>
						<cfset LvarID 	 = rsSQL1.PCDcatid>
						<cfset LvarValor = rsSQL1.PCDvalor>
						<cfif rsSQL.currentRow EQ 1 OR (LvarDeCtaEnCta AND rsSQL.CPDDlinea LT 0)>
							<cfset LvarCtaAnt = "#rsSQL.CPformato# de la linea #rsSQL.Orden#">
							<cfset LvarValorAnt = LvarValor>
							<cfset LvarIdAnt 	= LvarID>
							<cfset LvarNivelAnt = rsSQL1.PCDCniv>
						</cfif>
						
						<cfif LvarIdAnt NEQ LvarID>
							<cfthrow type="toUser" message="La Cuenta #rsSQL.CPformato# tiene en el nivel #rsSQL1.PCDCniv# valor #LvarValor#, pero debe ser igual que el nivel #LvarNivelAnt# valor '#LvarValorAnt#' de la cuenta #LvarCtaAnt#">
						</cfif>
					</cfloop>
				<cfelseif LvarVerifica_tipos[i] EQ 6>
					<!--- Clasificación de Catálogo --->
					<cfquery name="rsCla" datasource="#Session.DSN#">
						select PCCEclaid, PCCEcodigo, PCCEdescripcion
						  from PCClasificacionE
						 where CEcodigo = #session.CEcodigo#
						   and PCCEclaid = #LvarVerifica_valors[i]#
					</cfquery>
					<cfquery name="rsCat" datasource="#Session.DSN#">
						select PCEcatid, PCEcodigo, PCEdescripcion
						  from PCECatalogo
						 where PCEcatid = #LvarVerifica_valors[i]#
					</cfquery>
					<cfset LvarDeCtaEnCta = rsTrasladoE.CPDEtipoAsignacion EQ 0>
					<cfquery name="rsSQL" datasource="#Session.DSN#">
						select abs(d.CPDDlinea) as orden, d.CPDDlinea, cta.CPcuenta, cta.CPformato
						  from CPDocumentoD d
							inner join CPresupuesto cta
								on cta.CPcuenta = d.CPcuenta
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
						order by 1,2
					</cfquery>
					<cfloop query="rsSQL">
						<cfquery name="rsSQL1" datasource="#Session.DSN#">
							select cubo.PCDcatid, v.PCDvalor, pccd.PCCDclaid, pccd.PCCDvalor, pccd.PCCDdescripcion, cubo.PCDCniv
							  from PCDCatalogoCuentaP cubo
								inner join PCDCatalogo v
									on v.PCDcatid = cubo.PCDcatid
								inner join PCDClasificacionCatalogo pcdcc
										inner join PCClasificacionD pccd
											 on pccd.PCCDclaid = pcdcc.PCCDclaid
									 on pcdcc.PCCEclaid = #LvarVerifica_valors[i]#
									and pcdcc.PCDcatid  = cubo.PCDcatid
							 where cubo.CPcuenta = #rsSQL.CPcuenta#
						</cfquery>
	
						<cfif rsSQL1.recordCount EQ 0>
							<cfthrow type="toUser" message="La Cuenta #rsSQL.CPformato# no contiene niveles Clasificados como #rsCla.PCCEcodigo# - #rsCla.PCCEdescripcion#">
						<cfelseif rsSQL1.recordCount GT 1>
							<cfthrow type="toUser" message="La Cuenta #rsSQL.CPformato# contiene más de un nivel Clasificados como #rsCla.PCCEcodigo# - #rsCla.PCCEdescripcion#, niveles: #valueList(rsSQL1.PCDCniv)#">
						</cfif>
	
						<cfset LvarID 	 = rsSQL1.PCCDclaid>
						<cfset LvarDes 	 = "#rsSQL1.PCCDvalor# - #rsSQL1.PCCDdescripcion#">
						<cfset LvarValor = rsSQL1.PCDvalor>
						<cfif rsSQL.currentRow EQ 1 OR (LvarDeCtaEnCta AND rsSQL.CPDDlinea LT 0)>
							<cfset LvarCtaAnt = "#rsSQL.CPformato# de la linea #rsSQL.Orden#">
							<cfset LvarIdAnt 	= LvarID>
							<cfset LvarDesAnt 	= LvarDes>
							<cfset LvarValorAnt = LvarValor>
							<cfset LvarNivelAnt = rsSQL1.PCDCniv>
						</cfif>
						
						<cfif LvarIdAnt NEQ LvarID>
							<cfthrow type="toUser" message="La Cuenta #rsSQL.CPformato# tiene en el nivel #rsSQL1.PCDCniv# el valor '#LvarValor#' clasificado como '#LvarDes#', pero debe estar clasificado igual que nivel #LvarNivelAnt# valor '#LvarValorAnt#' clasificado como '#LvarDesAnt#' de la cuenta #LvarCtaAnt# clasificacion '#rsCla.PCCEcodigo# - #rsCla.PCCEdescripcion#'">
						</cfif>
					</cfloop>
				<cfelseif LvarVerifica_tipos[i] EQ 7>
					<!--- Valor Clasificado --->
					<cfquery name="rsSQL" datasource="#Session.DSN#">
						select PCCEclaid, PCCEcodigo, PCCEdescripcion
						  from PCClasificacionE
						 where CEcodigo = #session.CEcodigo#
						   and PCCEclaid = #LvarVerifica_valors[i]#
					</cfquery>
					Un mismo valor Clasificado en <strong>#rsSQL.PCCEcodigo# - #rsSQL.PCCEdescripcion#</strong>
				</cfif>
			</cfif>
			</td>
		</tr>
		</cfloop>
	</cffunction>				 

	<cffunction name="sbRsTrasladoE" access="public" output="false" returntype="void">
		<cfargument name="CPDEid"			type="numeric" required="yes">

		<cfif not isdefined("rsTrasladoE.CPDEid") OR rsTrasladoE.CPDEid NEQ Arguments.CPDEid>
			<cfquery name="rsTrasladoE" datasource="#session.dsn#">
				select 	a.CPPid,
						a.CPDEid,
						a.ProcessInstanceId,
						a.CPDEnumeroDocumento as NumTraslado,
						a.CPDEfechaDocumento, 
						case a.CPDEtipoDocumento when 'R' then 'Provisión' when 'L' then 'Liberación' when 'T' then 'Traslado' when 'E' then 'Traslado Aut.Externa' else '' end as NumeroReferencia,
						a.CPCano, a.CPCmes,
						a.CPDEtipoDocumento,
						a.CPDEenAprobacion, a.CPDEaplicado, a.CPDErechazado, a.CPDEestadoDAE, a.CPDAEid, a.CPDEtipoAsignacion
						, t.CPTTaprobacion, t.CPTTtramites, t.CPTTverificaciones, t.CPTTtipoCta
						, a.CFidOrigen,  cfo.CFcodigo as CFori, cfo.CFuresponsable as CFuresponsableOri, cfo.Ocodigo as OcodigoOri, oo.Oficodigo as OfiOri
						, a.CFidDestino, cfd.CFcodigo as CFdst, cfd.CFuresponsable as CFuresponsableDst,	cfd.Ocodigo as OcodigoDst, od.Oficodigo as OfiDst, od.SScodigo, od.SRcodigo
						, <cf_dbfunction name="to_char" args="cfo.CFcodigo #_Cat# ' - ' #_Cat# cfo.CFdescripcion"> as CFOrigen
						, <cf_dbfunction name="to_char" args="cfd.CFcodigo #_Cat# ' - ' #_Cat# cfd.CFdescripcion"> as CFDestino
				from CPDocumentoE a
					left outer join CPtipoTraslado t
						on a.CPTTid = t.CPTTid
					left outer join CFuncional cfo
						inner join Oficinas oo on oo.Ecodigo=cfo.Ecodigo and oo.Ocodigo=cfo.Ocodigo
						on a.CFidOrigen = cfo.CFid
					left outer join CFuncional cfd
						inner join Oficinas od on od.Ecodigo=cfd.Ecodigo and od.Ocodigo=cfd.Ocodigo
						on a.CFidDestino = cfd.CFid
				where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				  and a.Ecodigo = #session.Ecodigo#
				  and a.CPDEtipoDocumento in ('T','E')
			</cfquery>
			<cfif rsTrasladoE.CFidOrigen EQ "">
				<cfthrow message="Falta el Centro Funcional Origen">
			</cfif>
			<cfif rsTrasladoE.CFidDestino EQ "">
				<cfthrow message="Falta el Centro Funcional Destino">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="AplicarAutorizacionExterna" access="public" output="false" returntype="void">
		<cfargument name="CPDAEid"			type="numeric" required="yes">

		<cfscript>
			LobjControl = CreateObject("component", "sif.Componentes.PRES_Presupuesto");
			LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true);
		</cfscript>

		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from CPDocumentoE
			where CPDAEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDAEid#">
			  and Ecodigo = #Session.Ecodigo#
			  and CPDEenAprobacion = 1 AND CPDEestadoDAE <> 10 AND CPDEestadoDAE <> 11
		</cfquery>
		<cfif rsSQL.cantidad GT 0>
			<cfthrow message="No se puede Aplicar Autorización Externa mientras no están todos las Aprobaciones Confirmadas">
		</cfif>

		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select CPDAEid, CPDAEcodigo as NumeroDAE, CPDAEestado
			  from CPDocumentoAE
			where CPDAEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDAEid#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset LvarNumeroDAE = rsSQL.NumeroDAE>
		<cfif rsSQL.CPDAEid EQ "">
			<cfthrow message="No existe el Documento de Autorización Externa [id=#Arguments.CPDAEid#]">
		<cfelseif rsSQL.CPDAEestado LT 3>
			<cfthrow message="El Documento de Autorización Externa numero #LvarNumeroDAE# no ha sido cerrado">
		<cfelseif rsSQL.CPDAEestado GT 10>
			<cfthrow message="El Documento de Autorización Externa numero #LvarNumeroDAE# ya fue Aplicado">
		</cfif>
				
		<cfquery name="rsCPDE" datasource="#Session.DSN#">
			select CPDEid
			  from CPDocumentoE
			where CPDAEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDAEid#">
			  and Ecodigo = #Session.Ecodigo#
			  and CPDEenAprobacion = 1
		</cfquery>
		<cfloop query="rsCPDE">
			<cfquery datasource="#Session.DSN#">
				delete from #Request.intPresupuesto#
			</cfquery>
			<cftransaction>
				<cfset AprobarTraslado(rsCPDE.CPDEid, true)>
			</cftransaction>
		</cfloop>
		
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from CPDocumentoE
			where CPDAEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDAEid#">
			  and Ecodigo = #Session.Ecodigo#
			  and CPDEenAprobacion = 1 AND CPDEestadoDAE = 11
		</cfquery>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			update CPDocumentoAE
			<cfif rsSQL.cantidad GT 0>
			   set CPDAEestado = 10
			<cfelse>
			   set CPDAEestado = 11
			</cfif>
			where CPDAEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDAEid#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
	</cffunction>
</cfcomponent>
