<cfcomponent hint="Ver SACI-03-H016.doc" extends="base">
	<!--- actdesPrepagos: H016a --->

	<cffunction name="prepagosMasivo" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="prefijo" type="string" required="yes">
		<cfargument name="rango_inicial" type="string" required="yes">
		<cfargument name="rango_final" type="string" required="yes">
		<cfargument name="estado" type="string" required="yes">
		<cfargument name="agente" type="string" required="yes" default="0">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H016a', Arguments.prefijo  & ': '  & Arguments.rango_inicial & ' - ' & Arguments.rango_final & ' - ' & Arguments.S02CON)>
		
		<cftry>
			<cfset validarOrigen(Arguments.origen)>
			
		
			<cfif Arguments.estado is 'A'>
				<cfset TJestado = 1>
			<cfelseif Arguments.estado is 'D'>
				<cfset TJestado = 5>
			<cfelseif Arguments.estado is 'J'>
				<cfset TJestado = 6>
			<cfelseif Arguments.estado is 'F'>
				<cfset TJestado = 7>
		   <cfelseif Arguments.estado is 'B'>
				<cfset TJestado = 0>
			<cfelse>	
				<cfthrow message="Estado inválido: #estado#." errorcode="ISB-0018">
			</cfif>
			<!--- Se llama al componente para que realice el update. El update en masa genera --->
			<!--- múltiples eventos de update, lo que permite hacer la activación por tarjeta --->
			<!--- Cada update genera un evento en el REP connector, ante cada evento --->
			<!--- se hace la activación/desactivación en CISCO/IPASS y la respectiva --->
			<!--- inserción en la bitacora de prepagos. --->
			<cfset control_servicio( 'saci' )>
			<cfset control_mensaje( 'ISB-0019', 'Cambio a estado #TJestado# para #Arguments.prefijo# desde #Arguments.rango_inicial# hasta #Arguments.rango_final#' )>
			
			<cfif Arguments.estado is 'B' and Not Arguments.agente is '0'>

				<cfinvoke component="saci.comp.ISBprepago" method="AsignaAgenteRango">
					<cfinvokeargument name="prefijo" value="#Arguments.prefijo#">
					<cfinvokeargument name="rangoIni" value="#Arguments.rango_inicial#">
					<cfinvokeargument name="rangoFin" value="#Arguments.rango_final#">  
					<cfinvokeargument name="AGid" value="#Arguments.agente#">
				</cfinvoke>
		
			<cfelseif Not TJestado is 0>
			
				
			
				<cfinvoke component="saci.comp.ISBprepago" method="CambioEstadoRango">
					<cfinvokeargument name="prefijo" value="#Arguments.prefijo#">
					<cfinvokeargument name="rangoIni" value="#Arguments.rango_inicial#">
					<cfinvokeargument name="rangoFin" value="#Arguments.rango_final#">  
					<cfinvokeargument name="TJestado" value="#TJestado#">
					<cfinvokeargument name="S02CON" value="#Arguments.S02CON#">
				</cfinvoke>			
			<cfelse>
				<cfthrow message="Estado inválido: #estado#." errorcode="ISB-0018">
			</cfif>

			<!--- siic --->
			<cfif Arguments.origen is 'siic'>
				<!--- cumplimiento no aplica, se envía individual en la H016b --->
				<cfset control_servicio( 'siic' )>
				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#"
					EnviarCumplimiento="false"
					EnviarHistorico="true" />
			</cfif>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
				S02CON="#Arguments.S02CON#" 
				Error="#Request._saci_intf.Error#"/>
		</cfcatch>
		</cftry>
	</cffunction>
	<!--- H016b: updateIndividual: para invocarse desde el repconn de saci --->
	<cffunction name="updateIndividual" access="public" returntype="void">
		<cfargument name="TJid" type="numeric" required="yes">
		<cfargument name="origen" type="string" default="saci">
		<cfargument name="updateSaldo" type="boolean" required="yes">
		<cfargument name="updateEstado" type="boolean" required="yes">
		<cfargument name="updateAgente" type="boolean" required="yes">
		

		<!---
			El significado de TJestado es el siguiente:
			0	Generada
			1	Activa
			2	Utilizada
			3	Consumida
			4	Vencida
			5	Desactivar (Inactiva)
			6	Anulada
			7	Bloqueada x Spam
			Sólo en los estados 1 y 2 la tarjeta está habilitada para su uso,
			en los demás estados está inactiva.
		--->
		<cfset control_inicio( Arguments, 'H016b', Arguments.TJid )>
		<!--- estos dos valores se inicializan por si hay un error desplegar algo --->
		<cfset prefijo = ''>
		<cfset consecutivo = Arguments.TJid>
		<cftry>
			<cfset control_servicio( 'saci' )>
			<!--- Carga la info de la tarjeta --->
			<cfquery datasource="#session.dsn#" name="ISBprepago">
				select TJlogin, TJpassword, TJestado, TJdsaldo, PQnombre, AGid, isnull(S02CON,0) as S02CON
				from ISBprepago pp
					join ISBpaquete pq
						on pp.PQcodigo = pq.PQcodigo
				where TJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJid#">
			</cfquery>
			<!--- por si el siguiente query diera error tener algo que reportar --->
			<cfset control_mensaje( 'ISB-0019', 'S02CON=#ISBprepago.S02CON#')>
			<cfset consecutivo = ISBprepago.TJlogin>
			<cfset control_asunto ( ISBprepago.TJlogin )>
			<!--- Calcular el prefijo y separarlo del consecutivo, para la alerta a SIIC --->
			<cfquery datasource="#session.dsn#" name="prefijo">
				select max (prefijo) as prefijo
				from ISBprefijoPrepago
				where <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBprepago.TJlogin#">
					like ( prefijo || '%' )
			</cfquery>
			<cfset prefijo = prefijo.prefijo>
			<cfset consecutivo = Right (ISBprepago.TJlogin, Len(ISBprepago.TJlogin) - Len(prefijo))>
		
			<cfset control_servicio( 'saci' )>
			<cfif Arguments.updateEstado or Arguments.updateAgente>
				<!--- Inserción en la bitácora --->
				<cfinvoke component="saci.comp.ISBbitacoraPrepago" method="Alta">
					<cfinvokeargument name="TJid" value="#Arguments.TJid#">
					<cfinvokeargument name="TJlogin" value="#ISBprepago.TJlogin#">  
					<cfinvokeargument name="BPautomatica" value="true">  						
					<cfif Arguments.updateAgente>
						<cfinvokeargument name="BPobs" value="#textoObs(99)# #ISBprepago.AGid#">
					<cfelse>
						<cfinvokeargument name="BPobs" value="#textoObs(ISBprepago.TJestado)#">
					</cfif>
				</cfinvoke>
			</cfif>
			<cfif ListFind('1,2', ISBprepago.TJestado)>
				<!--- Activar el prepago en CISCO --->
				<cfset control_servicio( 'acceso' )>
				<cfif Not Len(ISBprepago.TJdsaldo) or ISBprepago.TJdsaldo eq 0>
					<cfthrow message="La Tarjeta #ISBprepago.TJlogin# no tiene segundos restantes">
				</cfif>
				<cfinvoke component="CiscoService" method="existePerfil"
					usuario="#ISBprepago.TJlogin#" returnvariable="prepago_existe"/>
				<!--- convertir los segundos de TJdsaldo a minutos para cisco. Mínimo cero --->
				<cfset saldo_en_minutos = Max (0, Ceiling( ISBprepago.TJdsaldo / 60 ))>
				<cfif prepago_existe And Arguments.updateSaldo>
					<!--- actualizar timeout --->
					<cfinvoke component="CiscoService" method="updateTimeout"
						usuario="#ISBprepago.TJlogin#"
						newTimeout="#saldo_en_minutos#"/>
				<cfelseif not prepago_existe>
					<!--- el prepago no existe: Crear aunque not Arguments.updateEstado --->
					<cfinvoke component="CiscoService" method="createUser"
						usuario="#ISBprepago.TJlogin#"
						clave="#ISBprepago.TJpassword#"
						parentGroup="#ISBprepago.PQnombre#"
						newTimeOut="#saldo_en_minutos#"/>
				</cfif>
				<cfif Arguments.updateEstado>
					<!--- Guardar el login en la lista de excepciones de Ipass.
						Los prepagos no tienen roaming --->
					<cfset control_servicio( 'roaming' )>
					<cfinvoke component="IPassService" method="agregarLoginIpass"
						usuario="#ISBprepago.TJlogin#" />
					<cfif ISBprepago.TJestado is 1>
						<!--- Cumplimiento del prepago: Solo aplica para activaciones --->
						<cfset control_servicio( 'siic' )>
						<cfinvoke component="SSXS02" method="Cumplimiento_Prepago"
							S01ACC="C"
							S01VA1="#prefijo#*#consecutivo#"
							S01VA2="A"
							SERCLA="#ISBprepago.TJlogin#"
							S02CON="#ISBprepago.S02CON#"/>
					</cfif>
				</cfif>
			<cfelseif Arguments.updateEstado>
				<!--- Desactivar el prepago en CISCO --->
				<cfset control_servicio( 'acceso' )>
				<cfinvoke component="CiscoService" method="deleteUser"
					usuario="#ISBprepago.TJlogin#"/>
				<!--- Sacar el login en la lista de excepciones de Ipass --->
				<cfset control_servicio( 'roaming' )>
				<cfinvoke component="IPassService" method="borrarLoginIpass"
					usuario="#ISBprepago.TJlogin#" />
				<!--- Cumplimiento del prepago: sólo aplica para desactivaciones --->
				<cfif ListFind('1,5,6,7',ISBprepago.TJestado)>
					<cfset control_servicio( 'siic' )>
					<cfinvoke component="SSXS02" method="Cumplimiento_Prepago"
						S01ACC="C"
						S01VA1="#prefijo#*#consecutivo#"
						S01VA2="A"
						SERCLA="#ISBprepago.TJlogin#" 
						S02CON="#ISBprepago.S02CON#"/>
				</cfif>
				<cfif ListFind('3,4', ISBprepago.TJestado)>
					<!--- consumida o vencida.  Este TJestado lo genera /saci/tasks/isb_prepago_vence.cfm --->
					<cfset control_servicio( 'siic' )>
					<cfinvoke component="SSXS02" method="Cumplimiento_Prepago"
						S01ACC="P"
						S01VA1="#ListGetAt('H,P', ListFind('3,4', ISBprepago.TJestado))#"
						S01VA2="#ISBprepago.TJlogin#"
						SERCLA="#prefijo#*#consecutivo#" 
						S02CON="#ISBprepago.S02CON#"/>
				</cfif>
		    <cfelseif Arguments.updateAgente>				
				<cfset control_servicio( 'siic' )>
				<cfinvoke component="SSXS02" method="Cumplimiento_Prepago"
					S01ACC="C"
					S01VA1="#prefijo#*#consecutivo#"
					S01VA2="A"
					SERCLA="#ISBprepago.TJlogin#"
					S02CON="#ISBprepago.S02CON#"/>
			</cfif>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfif ListFind('1,5,6,7',ISBprepago.TJestado) and Not Arguments.updateSaldo>
				<cfinvoke component="SSXS02" method="Cumplimiento_Prepago"
					S01ACC="C"
					S01VA1="#prefijo#*#consecutivo#"
					S01VA2="N*#cfcatch.message#"
					SERCLA="#ISBprepago.TJlogin#"
					S02CON="#ISBprepago.S02CON#"/>
					<!---"#calculaS01ACC(ISBprepago.TJestado)#"--->
			</cfif>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---textoObs--->
	<cffunction name="textoObs" returntype="string" output="false" hint="Calcula las observaciones">
		<cfargument name="TJestado" type="numeric" required="yes">
		<cfswitch expression="#Arguments.TJestado#">
			<cfcase value="0">	<cfreturn 'Tarjeta de prepago generada'></cfcase>
			<cfcase value="1">	<cfreturn 'Activación de prepago'></cfcase>
			<cfcase value="2">	<cfreturn 'Uso de prepago'></cfcase>
			<cfcase value="3">	<cfreturn 'Consumo de prepago'></cfcase>
			<cfcase value="4">	<cfreturn 'Vencimiento de prepago'></cfcase>
			<cfcase value="5">	<cfreturn 'Desactivación de prepago'></cfcase>
			<cfcase value="6">	<cfreturn 'Anulación de prepago'></cfcase>
			<cfcase value="7">	<cfreturn 'Borrado por spam'></cfcase>
			<cfcase value="99">	<cfreturn 'Asignación de Agente Autorizado'></cfcase>
			<cfdefaultcase>		<cfreturn 'Estado #TJestado#'></cfdefaultcase>
		</cfswitch>
	</cffunction>
	<!---calculaS01ACC--->
	<cffunction name="calculaS01ACC" returntype="string" output="false" hint="Calcula el S01ACC correspondiente a un TJestado para generar el cumplimiento">
		<cfargument name="TJestado" type="numeric" required="yes">
		<cfswitch expression="#Arguments.TJestado#">
			<cfcase value="1">				<cfreturn 'A'>		</cfcase>
			<cfcase value="5">				<cfreturn 'D'>		</cfcase>
		</cfswitch>
		<cfthrow message="TJestado inválido para cumplimiento: #Arguments.TJestado#">
	</cffunction>
</cfcomponent>
