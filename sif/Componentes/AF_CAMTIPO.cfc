<cfcomponent>
	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn IValueIfNull>
		</cfif>
	</cffunction>
	<cffunction name="AF_CAMTIPOACT" access="public" returntype="numeric" output="true">
		<!--- Cambio de la Categoría Clase de Activo(s).--->
		<cfargument name="AGTPid" 			type="numeric" 	default="0" 	required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al cálculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" 			type="numeric" 	default="0" 	required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		type="numeric" 	default="0" 	required="no"><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 		type="string" 	default="" 		required="no"><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 		type="string" 	default="" 		required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" 	type="string" 	default="Activo Fijo: Transferencia Categoría Clasificación" required="no"><!--- Descripción de la transacción --->
		<cfargument name="debug" 			type="boolean" 	default="true"  required="no"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 			type="numeric" 	default="0" 	required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				type="numeric" 	default="0" 	required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfif Arguments.debug>
			<h2>AF_CAMCATCLASACT</h2>
			<cfdump var="#Arguments#">
		</cfif>
		
		<cfset Arguments.Ecodigo = session.Ecodigo>
		<cfset Arguments.Conexion = session.dsn>
		<cfset Arguments.Usucodigo = session.Usucodigo>
		<cfset Arguments.BMUsucodigo = session.Usucodigo>
		<cfset Arguments.IPregistro = session.sitio.ip>
				
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
				</p>
			</cfoutput>
		</cfif>
		
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>
		
		<!---Prepara los filtros antes de la consulta para hacerla mas clara--->
		<cfset filtroa="">
		<cfset filtrob="">
		<cfset filtrocf="">
		
		<!---Inicio Insert encabezado del cambio de t--->
		<cftransaction>
			<cfif Arguments.AGTPid is 0>
				
				<cfinvoke 	component		= "sif.Componentes.OriRefNextVal"
						method		= "nextVal"
						returnvariable	= "LvarNumDoc"
						ORI			= "AFCT"
						REF			= "CT"
				/>
				
				<!---Inserta encabezado del cambio de tipo--->
				<cfquery name="idquery" datasource="#arguments.conexion#">
					insert into AGTProceso
						(
						Ecodigo, 
						IDtrans, 
						AGTPdocumento, 
						AGTPdescripcion,
						AGTPperiodo, 
						AGTPmes, 
						Usucodigo,
						BMUsucodigo,
						AGTPfalta,
						AGTPipregistro,
						AGTPestadp,
						AGTPecodigo
						
						)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">,<!--- -- Ecodigo --->
						7,<!--- -- IDtrans --->
						#LvarNumDoc#, <!--- -- AGTPdocumento --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGTPdescripcion#">,<!--- -- AGTPdescripcion --->
						#rsPeriodo.value#,<!--- -- AGTPperiodo --->						
						#rsMes.value#,<!--- -- AGTPmes --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#">,<!--- -- Usucodigo --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">,<!--- -- BMUsucodigo --->
						<cf_dbfunction name="now">,<!--- -- AGTPfalta --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ipregistro#">,<!--- -- AGTPipregistro --->
						0,<!--- -- AGTPestadp --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#"><!--- -- AGTPecodigo --->
						)
						<cf_dbidentity1 datasource="#arguments.conexion#">
				</cfquery>
				<cf_dbidentity2 datasource="#arguments.conexion#" name="idquery">
			
			<cfelse>
				
				<cfset idquery.identity = Arguments.AGTPid>
				<cfquery name="rstemp" datasource="#arguments.conexion#">
					update AGTProceso set AGTPestadp = 0 
						where AGTPid = #idquery.identity#
				</cfquery>				

			</cfif>
		</cftransaction>
		<cfreturn #idquery.identity#>
	</cffunction>
</cfcomponent>

