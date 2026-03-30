<cfcomponent>
	
	<cffunction name="AltaRelacion" access="public" returntype="numeric" output="true">
		<cfargument name="AGTPid" 			type="numeric" default="0"     required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al cálculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" 			type="numeric" default="0"     required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		type="numeric" default="0" 	   required="no"><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 		type="string"  default="" 	   required="no"><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 		type="string"  default="" 	   required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" 	type="string"  default="Retiro"required="no"><!--- Descripción de la transacción --->
		<cfargument name="AFRmotivo" 		type="numeric" default="0"     required="no"><!--- Motivo de Retiro --->
		<cfargument name="AGTPrazon" 		type="string"  default="" 	   required="no"><!--- Razón de Retiro --->
		<cfargument name="debug" 			type="boolean" default="false" required="no"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 			type="numeric" default="0"     required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				type="numeric" default="0"     required="no"><!---Si se envían No se sacan de la tabla de parámetros--->		
		<cfargument name="TransaccionActiva"type="boolean" default="false" required="false" >				
		<cfargument name="RetiroCR" 		type="boolean" default="false" required="no"><!--- True= Proviene desde control de responsables--->
		
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
				AFRmotivo="#Arguments.AFRmotivo#"
				AGTPrazon="#Arguments.AGTPrazon#"
				debug="#Arguments.debug#"
				Periodo="#Arguments.Periodo#"
				Mes="#Arguments.Mes#"
				RetiroCR="#Arguments.RetiroCR#"/>
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
					AFRmotivo="#Arguments.AFRmotivo#"
					AGTPrazon="#Arguments.AGTPrazon#"
					debug="#Arguments.debug#"
					Periodo="#Arguments.Periodo#"
					Mes="#Arguments.Mes#"
					RetiroCR="#Arguments.RetiroCR#"/>
			</cftransaction>
		</cfif>
		
		<cfreturn private_results>
	</cffunction>
	
	<cffunction name="AltaRelacionPrivate" access="private" returntype="numeric" output="true">
		<cfargument name="AGTPid" 			type="numeric" default="0" 		required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al cálculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" 			type="numeric" default="0" 		required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		type="numeric" default="0" 		required="no"><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 		type="string"  default="" 		required="no"><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 		type="string"  default=""       required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" 	type="string"  default="Retiro" required="no"><!--- Descripción de la transacción --->
		<cfargument name="AFRmotivo" 		type="numeric" default="0" 		required="no"><!--- Motivo de Retiro --->
		<cfargument name="AGTPrazon" 		type="string"  default="" 		required="no"><!--- Razón de Retiro --->
		<cfargument name="debug" 			type="boolean" default="false" 	required="no"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 			type="numeric" default="0" 		required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				type="numeric" default="0" 		required="no"><!---Si se envían No se sacan de la tabla de parámetros--->	
		<cfargument name="RetiroCR" 		type="boolean" default="false" 	required="no"><!--- True= Proviene desde control de responsables--->
		
		<cfif Arguments.debug>
			<h2>AF_RetiroActivos</h2>
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
		
		<cfif Arguments.AFRmotivo neq 0>
			<cfset rsMotivo.value = Arguments.AFRmotivo>
		<cfelse>
			<cfquery name="rsMotivo" datasource="#arguments.conexion#" maxrows="1">
				select AFRmotivo as value
				from AFRetiroCuentas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					and AFResventa = 'N'
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
				<strong>Motivo</strong> = #Arguments.AFRmotivo#<br>
				</p>
			</cfoutput>
		</cfif>
		
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>
		
		<!---Inicio el Registro del Retiro --->
		<!--- <cftransaction> --->
			<cfinvoke 	component		= "sif.Componentes.OriRefNextVal"
					method		= "nextVal"
					returnvariable	= "LvarNumDoc"
					ORI			= "AFRT"
					REF			= "RT"
			/>

			<cfif Arguments.RetiroCR>
				<cfset nuevadesc = #Arguments.AGTPdescripcion# & " - " & #LvarNumDoc#>			
			</cfif>
			
			<cfquery name="idquery" datasource="#arguments.conexion#">
				insert into AGTProceso
				(Ecodigo, 
					IDtrans, 
					AGTPdescripcion,
					AFRmotivo,
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
					5,<!----- IDtrans--->
										
					<cfif Arguments.RetiroCR>
						<!--- En caso de venir el retiro del módulo de control de responsables, 
						se concatena el número de documento a la descripción --->						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#nuevadesc#">,<!----- AGTPdescripcion--->
					
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGTPdescripcion#"> ,<!----- AGTPdescripcion--->
					</cfif>
					
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMotivo.value#">,<!----- AFRmotivo--->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGTPrazon#">,<!----- AGTPrazon--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">,<!----- AGTPperiodo--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.value#">,<!----- AGTPmes--->
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
		<cfargument name="AGTPid" 	  type="numeric"  required="yes"><!--- Id de Proceso. --->
		<cfargument name="Aid" 		  type="numeric"  required="yes"><!--- Id de Activo. --->
		<cfargument name="Ecodigo" 	  type="numeric"  required="no"  default="0" ><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo"  type="numeric"  required="no"  default="0" ><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" type="string"   required="no"  default="" ><!--- IP de PC de Usuario --->
		<cfargument name="Conexion"   type="string"   required="no"  default="" ><!--- IP de PC de Usuario --->
		<cfargument name="ADTPrazon"  type="string"   required="no"  default="" ><!--- Razón de Retiro --->
		<cfargument name="debug" 	  type="boolean"  required="no"  default="false" ><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="CRCTid"     type="numeric"  required="no"  default="-1">                 <!---Indica si la transaccion fue Producto de la apertura de la cola--->
		
		<cfargument name="TransaccionActiva" type="boolean" required="false" default="false">

		<cfif Arguments.TransaccionActiva>
			<cfinvoke 
				method="AltaActivoPrivate"
			    returnvariable="private_results"
				AGTPid="#Arguments.AGTPid#"
				Aid="#Arguments.Aid#"
				Ecodigo="#Arguments.Ecodigo#"
				Usucodigo="#Arguments.Usucodigo#"
				IPregistro="#Arguments.IPregistro#"
				Conexion="#Arguments.Conexion#"
				ADTPrazon="#Arguments.ADTPrazon#"
				debug="#Arguments.debug#"
				CRCTid="#Arguments.CRCTid#"/>
		<cfelse>
			<cftransaction>
				<cfinvoke 
					method="AltaActivoPrivate"
					returnvariable="private_results"
					AGTPid="#Arguments.AGTPid#"
					Aid="#Arguments.Aid#"
					Ecodigo="#Arguments.Ecodigo#"
					Usucodigo="#Arguments.Usucodigo#"
					IPregistro="#Arguments.IPregistro#"
					Conexion="#Arguments.Conexion#"
					ADTPrazon="#Arguments.ADTPrazon#"
					debug="#Arguments.debug#"
					CRCTid="#Arguments.CRCTid#"/>
			</cftransaction>
		</cfif>

		<cfreturn private_results>
	
	</cffunction>
	
	<cffunction name="AltaActivoPrivate" access="private" returntype="numeric" output="true">
		<cfargument name="AGTPid" 		type="numeric" 	required="yes">				   <!--- Id de Proceso. --->
		<cfargument name="Aid" 			type="numeric" 	required="yes">				   <!--- Id de Activo. --->
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">	   			   <!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 	type="numeric" 	required="no">	  			   <!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 	type="string" 	required="no">	  			   <!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 	type="string" 	required="no">	   			   <!--- Nombre de la Conexion --->
		<cfargument name="ADTPrazon"	type="string" 	required="no" default="">	   <!--- Razón de Retiro --->
		<cfargument name="debug" 		type="boolean"	required="no" default="false"> <!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="CRCTid"       type="numeric"  required="no">                 <!---Indica si la transaccion fue Producto de la apertura de la cola--->
		
		<cfif not isdefined('Arguments.Usucodigo') or NOT LEN(TRIM(Arguments.Usucodigo))>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or NOT LEN(TRIM(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') or NOT LEN(TRIM(Arguments.Ecodigo)) OR Arguments.Ecodigo EQ 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.IPregistro') or NOT LEN(TRIM(Arguments.IPregistro))>
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
			len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50944" msg = "Datos Definidos Incorrectamente en Encabezado del documento de trabajo! Proceso Cancelado!"></cfif>
		
		<!--- VALIDACIONES--->
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" 	  Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" 	  Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#" validamontos="false"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion"  Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" 	  Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" 	  Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado"     Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola"         Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#" CRCTid="#Arguments.CRCTid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Documentos"   Aid="#Arguments.Aid#" Ecodigo="#Arguments.Ecodigo#"/> 	
		

				<!---Inserta en ADTProceso--->
				<cfquery name="rsIADTProceso" datasource="#arguments.conexion#">
					select 
							a.CFid, 
							b.Afechainidep, 
							b.Avalrescate, 
							a.AFSvutiladq, 
							b.Afechainirev,
							round(AFSvaladq,2) as AFSvaladqR,
							round(AFSvalmej,2) as AFSvalmejR,
							round(AFSvalrev,2) as AFSvalrevR,
							
							round(AFSdepacumadq,2) as AFSdepacumadqR,
							round(AFSdepacummej,2) as AFSdepacummejR,
							round(AFSdepacumrev,2) as AFSdepacumrevR,
	
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
							and a.AFSperiodo = <cf_jdbcquery_param value="#rsPeriodo.value#" cfsqltype="cf_sql_numeric">
							and a.AFSmes = <cf_jdbcquery_param value="#rsMes.value#" cfsqltype="cf_sql_numeric">
							and a.Aid = <cf_jdbcquery_param value="#Arguments.Aid#" cfsqltype="cf_sql_numeric">
							and a.Aid not in (
							select xyz.Aid
							from ADTProceso xyz
							where xyz.Ecodigo = a.Ecodigo
								and xyz.Aid = a.Aid
								and xyz.TAperiodo = a.AFSperiodo
								and xyz.TAmes = a.AFSmes
								and xyz.IDtrans = 5
							)
				</cfquery>
				
				<cfquery name="rsInsertaActivos" datasource="#arguments.conexion#">
					 insert into ADTProceso
						(Ecodigo, 
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
						TAmontolocventa,
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
						BMUsucodigo
						)
					values(
						<cfif Arguments.Ecodigo neq session.ecodigo>
							#Arguments.Ecodigo#,
						<cfelse>	
							#session.Ecodigo#, 
						</cfif>
						#arguments.AGTPid#, 
						#arguments.Aid#, 
						5, 
						#rsIADTProceso.CFid#, 
						<cf_dbfunction name="now">,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsIADTProceso.Afechainidep#">,
						#rsIADTProceso.Avalrescate#, 
						#rsIADTProceso.AFSvutiladq#, 
						0.00, 
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsIADTProceso.Afechainirev#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.ADTPrazon#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMes.value#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">,
						#Arguments.usucodigo#,
						0,
						#rsIADTProceso.AFSvaladqR#,
						0.00,
						#rsIADTProceso.AFSvalmejR#,
						0.00,
						#rsIADTProceso.AFSvalrevR#,
						0.00,
						0.00,
						#rsIADTProceso.AFSdepacumadqR#,
						#rsIADTProceso.AFSdepacummejR#,
						#rsIADTProceso.AFSdepacumrevR#,
						#rsIADTProceso.AFSvaladq#,
						#rsIADTProceso.AFSvalmej#,
						#rsIADTProceso.AFSvalrev#,
						#rsIADTProceso.AFSdepacumadq#,
						#rsIADTProceso.AFSdepacummej#,
						#rsIADTProceso.AFSdepacumrev#,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">,
						1.00,
						#Arguments.Usucodigo#
						)
				<cf_dbidentity1 datasource="#arguments.conexion#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="rsInsertaActivos" verificar_transaccion="false">
			
			<cfif Arguments.debug>
				<cfquery name="RESULTADOS" datasource="#Arguments.conexion#">
					select 
						#session.Ecodigo#, #arguments.AGTPid#, #arguments.Aid#, 5, a.CFid, <cf_dbfunction name="now"> as TAfalta, 
						b.Afechainidep, b.Avalrescate, a.AFSvutiladq, 
						0.00, b.Afechainirev,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.ADTPrazon#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMes.value#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">,
						#Arguments.usucodigo#,0
						,a.AFSvaladq,0
						,a.AFSvalmej,0
						,a.AFSvalrev,0
						,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">,1
					from AFSaldos a
						inner join Activos b 
							on b.Ecodigo = a.Ecodigo
							and b.Aid = a.Aid
							and b.Astatus = 0 						<!---/*estado activo*/--->
					where a.Ecodigo = #arguments.ecodigo#
						and a.AFSperiodo = <cf_jdbcquery_param value="#rsPeriodo.value#" cfsqltype="cf_sql_numeric">
						and a.AFSmes = <cf_jdbcquery_param value="#rsMes.value#" cfsqltype="cf_sql_numeric">
						and a.Aid = <cf_jdbcquery_param value="#Arguments.Aid#" cfsqltype="cf_sql_numeric">
						and a.Aid not in (
						select xyz.Aid
						from ADTProceso xyz
						where xyz.Ecodigo = a.Ecodigo
							and xyz.Aid = a.Aid
							and xyz.TAperiodo = a.AFSperiodo
							and xyz.TAmes = a.AFSmes
							and xyz.IDtrans = 5
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
			<cfelse>
				<!--- <cftransaction action="commit"/> --->
			</cfif>
			

		
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn #rsInsertaActivos.identity#>
	</cffunction>
	
	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn IValueIfNull>
		</cfif>
	</cffunction>
	
</cfcomponent>

