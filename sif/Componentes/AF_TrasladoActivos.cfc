<cfcomponent>
	<cffunction name="AltaRelacion" access="public" returntype="numeric" output="true">
		<cfargument name="AGTPid" 			type="numeric" 	default="0" 		required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al cálculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" 			type="numeric" 	default="0" 		required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		type="numeric" 	default="0" 		required="no"><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 		type="string" 	default="" 			required="no"><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 		type="string" 	default="" 			required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" 	type="string" 	default="Traslado" 	required="no"><!--- Descripción de la transacción --->
		<cfargument name="AGTPrazon" 		type="string" 	default="" 			required="no"><!--- Razón de Traslado --->
		<cfargument name="debug" 			type="boolean" 	default="false" 	required="no"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 			type="numeric" 	default="0" 		required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				type="numeric" 	default="0" 		required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		
		<cfargument name="TransaccionActiva" type="boolean" required="false" default="false">

		<cfif Arguments.TransaccionActiva>
			<cfinvoke 
				method="AltaRelacionPrivate"
			    returnvariable="private_results"
				AGTPid="#Arguments.AGTPid#"
				Ecodigo="#Arguments.Ecodigo#"
				Usucodigo="#Arguments.Usucodigo#"
				IPregistro="#Arguments.IPregistro#"
				Conexion="#Arguments.Conexion#"
				AGTPdescripcion="#Arguments.AGTPdescripcion#"
				AGTPrazon="#Arguments.AGTPrazon#"
				debug="#Arguments.debug#"
				Periodo="#Arguments.Periodo#"
				Mes="#Arguments.Mes#"/>
		<cfelse>
			<cftransaction>
				<cfinvoke 
					method="AltaRelacionPrivate"
					returnvariable="private_results"
					AGTPid="#Arguments.AGTPid#"
					Ecodigo="#Arguments.Ecodigo#"
					Usucodigo="#Arguments.Usucodigo#"
					IPregistro="#Arguments.IPregistro#"
					Conexion="#Arguments.Conexion#"
					AGTPdescripcion="#Arguments.AGTPdescripcion#"
					AGTPrazon="#Arguments.AGTPrazon#"
					debug="#Arguments.debug#"
					Periodo="#Arguments.Periodo#"
					Mes="#Arguments.Mes#"/>
			</cftransaction>
		</cfif>
		
		<cfreturn private_results>
	</cffunction>
	
	<cffunction name="AltaRelacionPrivate" access="private" returntype="numeric" output="true">
		<cfargument name="AGTPid" 			type="numeric" 	default="0" 		required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al cálculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" 			type="numeric" 	default="0" 		required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		type="numeric" 	default="0" 		required="no"><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 		type="string" 	default="" 			required="no"><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 		type="string" 	default="" 			required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" 	type="string" 	default="Traslado" 	required="no"><!--- Descripción de la transacción --->
		<cfargument name="AGTPrazon" 		type="string" 	default="" 			required="no"><!--- Razón de Traslado --->
		<cfargument name="debug" 			type="boolean" 	default="false" 	required="no"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 			type="numeric" 	default="0" 		required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				type="numeric" 	default="0" 		required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		
		<cfif Arguments.debug>
			<h2>AF_TrasladoActivos</h2>
			<cfdump var="#Arguments#">
		</cfif>
		
		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo is 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
			<cfset Arguments.Conexion = session.dsn>
			<cfset Arguments.Usucodigo = session.Usucodigo>
			<cfset Arguments.IPregistro = session.sitio.ip>
		</cfif>
		
		<!---Antes de iniciar la transacción hace algunos calculos--->
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfif Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
			<cfquery name="rsPeriodo" datasource="#arguments.conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					and Pcodigo = 50
					and Mcodigo = 'GN'
			</cfquery>
		</cfif>
		<cfif Arguments.Mes neq 0>
			<cfset rsMes.value = Arguments.Mes>
		<cfelse>
			<cfquery name="rsMes" datasource="#arguments.conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
		</cfif>
		
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#arguments.conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		
		<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
		<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
		<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
		<cfif Arguments.debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h3>DEBUG</h3><br>
				<p>
				<strong>Periodo</strong> = #rsPeriodo.value#<br>
				<strong>Mes</strong> = #rsMes.value#<br>
				<strong>Moneda</strong> = #rsMoneda.value#<br>
				<strong>FechaAux</strong> = #rsFechaAux.value#<br>
				<strong>Descripción</strong> = #Arguments.AGTPdescripcion#<br>
				<strong>Razón</strong> = #Arguments.AGTPrazon#<br>
				</p>
			</cfoutput>
		</cfif>
		
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>


		<!---Inicio el Registro del Traslado --->
		<!--- <cftransaction> --->
			<cfinvoke component		= "sif.Componentes.OriRefNextVal"
					  method		= "nextVal"
					  returnvariable= "LvarNumDoc"
					  ORI			= "AFTR"
					  REF			= "TR"
			/>
			<cfquery name="idquery" datasource="#arguments.conexion#">
				insert into AGTProceso
				(Ecodigo, 
					IDtrans, 
					AGTPdescripcion,
					AGTPrazon,
					AGTPperiodo, 
					AGTPmes, 
					Usucodigo,
					AGTPfalta,
					AGTPipregistro,
					AGTPestadp,
					AGTPecodigo, 
					AGTPdocumento)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">,<!----- Ecodigo--->
					8,<!----- IDtrans--->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGTPdescripcion#">,<!----- AGTPdescripcion--->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGTPrazon#">,<!----- AGTPrazon--->
					#rsPeriodo.value#,<!----- AGTPperiodo--->
					#rsMes.value#,<!----- AGTPmes--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#">,<!----- Usucodigo--->
					<cf_dbfunction name="now">,<!----- AGTPfalta--->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ipregistro#">,<!----- AGTPipregistro--->
					0,<!----- AGTPestadp--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">,<!----- AGTPecodigo--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNumDoc#">
					)
					<cf_dbidentity1 datasource="#arguments.conexion#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="idquery" verificar_transaccion="false">

			<cfif Arguments.debug>
				<cfquery name="rsAGTP" datasource="#arguments.conexion#">
					select * from AGTProceso where AGTPid = #idquery.identity#
				</cfquery>
				<cfquery name="rsADTP" datasource="#arguments.conexion#">
					select * from ADTProceso where AGTPid = #idquery.identity#
				</cfquery>
				<cfdump var="#rsAGTP#">
				<cfdump var="#rsADTP#">
				<!--- <cftransaction action="rollback"/> --->
			<cfelse>
				<!--- <cftransaction action="commit"/> --->
			</cfif>
			
		<!--- </cftransaction> --->
		
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn #idquery.identity#>
	</cffunction>
	
	<cffunction name="AltaActivo" access="public" returntype="numeric" output="true">
		<cfargument name="AGTPid" 		 type="numeric" required="yes">					<!--- Id de Proceso. --->
		<cfargument name="Aid" 			 type="numeric" required="yes">					<!--- Id de Activo. --->
		<cfargument name="Aiddestino" 	 type="numeric" required="no" default="-1" >	<!--- Id de Activo destino. --->
		<cfargument name="Aplacadestino" type="string"  required="no" default="" >		<!--- Placa de Activo destino. --->		
		<cfargument name="Ecodigo" 		 type="numeric" required="no" default="0" >		<!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 	 type="numeric" required="no" default="0" >		<!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 	 type="string"  required="no" default="" >		<!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 	 type="string"  required="no" default="" >		<!--- IP de PC de Usuario --->
		<cfargument name="ADTPrazon" 	 type="string"  required="no" default="" >		<!--- Razón de Traslado --->
		<cfargument name="debug" 		 type="boolean" required="no" default="false" > <!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
	
		<cfargument name="TransaccionActiva" type="boolean" required="false" default="false">

		<cfif Arguments.TransaccionActiva>
			<cfinvoke 
				method="AltaActivoPrivate"
			    returnvariable="private_results"
				AGTPid="#Arguments.AGTPid#"
				Aid="#Arguments.Aid#"
				Aiddestino="#Arguments.Aiddestino#"
				Aplacadestino="#Arguments.Aplacadestino#"
				Ecodigo="#Arguments.Ecodigo#"
				Usucodigo="#Arguments.Usucodigo#"
				IPregistro="#Arguments.IPregistro#"
				Conexion="#Arguments.Conexion#"
				ADTPrazon="#Arguments.ADTPrazon#"
				debug="#Arguments.debug#"/>
		<cfelse>
			<cftransaction>
				<cfinvoke 
					method="AltaActivoPrivate"
					returnvariable="private_results"
					AGTPid="#Arguments.AGTPid#"
					Aid="#Arguments.Aid#"
					Aiddestino="#Arguments.Aiddestino#"
					Aplacadestino="#Arguments.Aplacadestino#"
					Ecodigo="#Arguments.Ecodigo#"
					Usucodigo="#Arguments.Usucodigo#"
					IPregistro="#Arguments.IPregistro#"
					Conexion="#Arguments.Conexion#"
					ADTPrazon="#Arguments.ADTPrazon#"
					debug="#Arguments.debug#"/>
			</cftransaction>
		</cfif>

		<cfreturn private_results>
	
	</cffunction>
	
	<cffunction name="AltaActivoPrivate" access="private" returntype="numeric" output="true">
		<cfargument name="AGTPid" 			type="numeric" required="yes">					 <!--- Id de Proceso. --->
		<cfargument name="Aid" 				type="numeric" required="yes">					 <!--- Id de Activo. --->
		<cfargument name="Aiddestino" 		type="numeric" required="no" 	default="-1">	 <!--- Id de Activo destino. --->
		<cfargument name="Aplacadestino" 	type="string"  required="no" 	default="" >	 <!--- Placa de Activo destino. --->		
		<cfargument name="Ecodigo" 			type="numeric" required="no" 	default="0" >	 <!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		type="numeric" required="no" 	default="0" >	 <!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 		type="string"  required="no" 	default="" >	 <!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 		type="string"  required="no" 	default="" >	 <!--- IP de PC de Usuario --->
		<cfargument name="ADTPrazon" 		type="string"  required="no" 	default="" >	 <!--- Razón de Traslado --->
		<cfargument name="debug" 			type="boolean" required="no" 	default="false" ><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		
		<!--- <cfset Arguments.debug = true> --->
		<cfif Arguments.debug>
			<h2>AF_TrasladoActivos</h2>
			<cfdump var="#Arguments#">
		</cfif>
		
		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo is 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
			<cfset Arguments.Conexion = session.dsn>
			<cfset Arguments.Usucodigo = session.Usucodigo>
			<cfset Arguments.IPregistro = session.sitio.ip>
		</cfif>
		
		<!---Antes de iniciar la transacción hace algunos calculos--->
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfquery name="AGTProceso" datasource="#arguments.conexion#">
			select AGTPperiodo, AGTPmes
			from AGTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				and AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGTPid#">
		</cfquery>
		<cfset rsPeriodo.value = AGTProceso.AGTPperiodo>
		<cfset rsMes.value = AGTProceso.AGTPmes>
		
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#arguments.conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		
		<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
		<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
		<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
		<cfif Arguments.debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h3>DEBUG</h3><br>
				<p>
				<strong>Periodo</strong> = #rsPeriodo.value#<br>
				<strong>Mes</strong> = #rsMes.value#<br>
				<strong>Moneda</strong> = #rsMoneda.value#<br>
				<strong>FechaAux</strong> = #rsFechaAux.value#<br>
				<strong>Razón</strong> = #Arguments.ADTPrazon#<br>
				</p>
			</cfoutput>
		</cfif>
		
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0 or
			len(trim(rsMes.value)) eq 0 or 
			len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50946" msg = "Datos Definidos Incorrectamente en Encabezado del documento de trabajo. Proceso Cancelado!"></cfif>

		<!---******************************--->
		<!---**VALIDACIONES ACTIVO ORIGEN**--->
		<!---******************************--->
		<cfset detail = "<br>Validacion del Activo Origen">
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>	
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado" Aid="#Arguments.Aid#" AGTPid= "#Arguments.AGTPid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Documentos" Aid="#Arguments.Aid#"/>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
		<!---*****************************************--->
		<!---**VALIDACIONES ACTIVO DESTINO EXISTENTE**--->
		<!---*****************************************--->
		<cfset detail = "<br>Validacion del Activo Destino">
		<cfif len(trim(Arguments.Aiddestino)) and Arguments.Aiddestino gt 0>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>	
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado" Aid="#Arguments.Aiddestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>	
			<cfif #Arguments.Aid# EQ #Arguments.Aiddestino# >
				<cf_errorCode	code = "50947" msg = "El Activo Origen y El Activo Destino son el mismo. Proceso Cancelado!">>
			</cfif>	
		<!---********************************************--->
		<!---**VALIDACIONES ACTIVO DESTINO NO EXISTENTE**--->
		<!---********************************************--->
		<cfelseif len(trim(Arguments.Aplacadestino))>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" Aplaca="#Arguments.Aplacadestino#" DebeExistir="false"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Transito" Aplaca="#Arguments.Aplacadestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
			<cftry>
			    <cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado" PlacaDestino="#Arguments.Aplacadestino#"/>
				<cfcatch type="any"><cfrethrow></cfcatch>
			</cftry>
		<cfelse>
			<cf_errorCode	code = "50948" msg = "No éstá definido el activo destino para el traslado. Proceso Cancelado!">
		</cfif>			
		<!---INSERTA EL DETALLE DEL TRASLADO PENDIENTE DE APLICAR--->
				<cfquery name="MontosT" datasource="#arguments.conexion#">
					select coalesce (SUM(TAmontolocadq),0) as TAmontolocadq,
					 	   coalesce (SUM(TAmontolocmej),0) as TAmontolocmej,
					  	   coalesce (SUM(TAmontolocrev),0) as TAmontolocrev
					 from ADTProceso
					 where AGTPid = #arguments.AGTPid#
					  and Ecodigo = #session.Ecodigo#
					  and Aid = #arguments.Aid#
				</cfquery>
				
				
			<cfquery name="rsIActivos" datasource="#arguments.conexion#">
				select 
					a.CFid,  
					b.Afechainidep, 
					b.Avalrescate, 
					a.AFSsaldovutiladq, 
					b.Afechainirev,
					AFSdepacumadq,
					AFSdepacummej,
					AFSdepacumrev,
					AFSvaladq,
					AFSvalmej,
					AFSvalrev,
					AFSdepacumadq,
					AFSdepacummej,
					AFSdepacumrev
				
				from AFSaldos a
					inner join Activos b 
						on b.Ecodigo = a.Ecodigo
						and b.Aid = a.Aid
						and b.Astatus = 0 						<!---/*estado activo*/--->
				where a.Ecodigo = #arguments.ecodigo#
					and a.AFSperiodo = #rsPeriodo.value#
					and a.AFSmes = #rsMes.value#
					and a.Aid = <cfqueryparam value="#Arguments.Aid#" cfsqltype="cf_sql_numeric">
					and a.Aid not in (
					select xyz.Aid
					from ADTProceso xyz
					where xyz.Ecodigo = a.Ecodigo
						and xyz.Aid = a.Aid
						and xyz.TAperiodo = a.AFSperiodo
						and xyz.TAmes = a.AFSmes
						and AGTPid <> #arguments.AGTPid#
						and xyz.IDtrans = 8
					)
			</cfquery>
			
			<cfquery name="rsInsertaActivos" datasource="#arguments.conexion#">
				 insert into ADTProceso
					(
					Ecodigo, 
					AGTPid, 
					Aid, 
					IDtrans, 
					CFid, 
					TAfalta, 
					TAfechainidep, 
					TAvalrescate, 
					TAvutil, 
					TAsuperavit, 
					TAfechainirev, 
					ADTPrazon, 
					TAperiodo, 
					TAmes, 
					TAfecha, 
					Usucodigo,
					TAmeses,
					TAmontolocadq, 
					TAmontooriadq, 
					TAmontolocmej, 
					TAmontoorimej, 
					TAmontolocrev, 
					TAmontoorirev, 
					TAmontodepadq,
					TAmontodepmej,
					TAmontodeprev,
					TAvaladq,
					TAvalmej,
					TAvalrev,
					TAdepacumadq,
					TAdepacummej,
					TAdepacumrev,
					Mcodigo, 
					TAtipocambio,
					<cfif len(trim(Arguments.Aiddestino)) and Arguments.Aiddestino gt 0>
					Aiddestino 
					<cfelseif len(trim(Arguments.Aplacadestino))>
					Aplacadestino
					</cfif>
					)
				values(
					#session.Ecodigo#, 
					#arguments.AGTPid#, 
					#arguments.Aid#, 
					8, 
					#rsIActivos.CFid#, 
					<cf_dbfunction name="now">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsIActivos.Afechainidep#">,
					#rsIActivos.Avalrescate#, 
					#rsIActivos.AFSsaldovutiladq#, 
					0.00, 
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsIActivos.Afechainirev#">,
					'#Arguments.ADTPrazon#',
					#rsPeriodo.value#, 
					#rsMes.value#, 
					#rsFechaAux.value#,
					#Arguments.usucodigo#,
					0,
					#rsIActivos.AFSvaladq# - #MontosT.TAmontolocadq#,
					0.00,
					#rsIActivos.AFSvalmej# - #MontosT.TAmontolocmej#,
					0.00,
					#rsIActivos.AFSvalrev# - #MontosT.TAmontolocrev#,
					0.00,
					#rsIActivos.AFSdepacumadq#,
					#rsIActivos.AFSdepacummej#,
					#rsIActivos.AFSdepacumrev#,
					#rsIActivos.AFSvaladq#,
					#rsIActivos.AFSvalmej#,
					#rsIActivos.AFSvalrev#,
					#rsIActivos.AFSdepacumadq#,
					#rsIActivos.AFSdepacummej#,
					#rsIActivos.AFSdepacumrev#,
					#rsMoneda.value#,
					1.00,
					
					
					<cfif len(trim(Arguments.Aiddestino)) and Arguments.Aiddestino gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aiddestino#">
					<cfelseif len(trim(Arguments.Aplacadestino))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Aplacadestino#">
					</cfif>						
					)
				<cf_dbidentity1 datasource="#arguments.conexion#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="rsInsertaActivos" verificar_transaccion="false">

			<cfif Arguments.debug>
				<cfquery name="RESULTADOS" datasource="#Arguments.conexion#">
					select 
						#session.Ecodigo#, #arguments.AGTPid#, #arguments.Aid#, 8, a.CFid, <cf_dbfunction name="now"> as TAfalta, 
						b.Afechainidep, b.Avalrescate, a.AFSvutiladq, 
						0.00, b.Afechainirev,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ADTPrazon#">,
						#rsPeriodo.value#, 
						#rsMes.value#, 
						#rsFechaAux.value#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#">,0
						,a.AFSvaladq,0
						,a.AFSvalmej,0
						,a.AFSvalrev,0
						,#rsMoneda.value#,1
					from AFSaldos a
						inner join Activos b 
							on b.Ecodigo = a.Ecodigo
							and b.Aid = a.Aid
							and b.Astatus = 0 						<!---/*estado activo*/--->
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">
						and a.AFSperiodo = #rsPeriodo.value#
						and a.AFSmes = #rsMes.value#
						and a.Aid = <cfqueryparam value="#Arguments.Aid#" cfsqltype="cf_sql_numeric">
						and a.Aid not in (
						select xyz.Aid
						from ADTProceso xyz
						where xyz.Ecodigo = a.Ecodigo
							and xyz.Aid = a.Aid
							and xyz.TAperiodo = a.AFSperiodo
							and xyz.TAmes = a.AFSmes
							and xyz.IDtrans = 8
						)
				</cfquery>
				<cfdump var="#RESULTADOS#" label="RESULTADOS">
				<cfquery name="rsAGTP" datasource="#arguments.conexion#">
					select * from AGTProceso where AGTPid = #Arguments.AGTPid#
				</cfquery>
				<cfquery name="rsADTP" datasource="#arguments.conexion#">
					select * from ADTProceso where AGTPid = #Arguments.AGTPid#
				</cfquery>
				<cfdump var="#rsAGTP#">
				<cfdump var="#rsADTP#">
				<!--- <cftransaction action="rollback"/> --->
				<cf_abort errorInterfaz="">
			<cfelse>
				<!--- <cftransaction action="commit"/> --->
			</cfif>
			
		<!--- </cftransaction> --->
		
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn #rsInsertaActivos.identity#><!--- <cfreturn #Arguments.AGTPid#> --->
	</cffunction>
	
	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
	</cffunction>

</cfcomponent>

