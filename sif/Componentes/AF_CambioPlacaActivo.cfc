<cfcomponent>
	<!--- Funcion AF_CambioTipoActivo --->
	<cffunction name="AF_CambioPlacaActivo" access="public" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 	   type="numeric" default="0"     required="no">	<!--- Código de Empresa (sif) --->
		<cfargument name="Conexion"    type="string"  default=""      required="no">	<!--- IP de PC de Usuario --->
		<cfargument name="Usucodigo"   type="numeric" default="0" 	  required="no">	<!--- Código de Usuario (asp) --->

		<cfargument name="AGTPid" 	   type="numeric" required="yes">
		<cfargument name="Aid" 		   type="numeric" required="yes">
		<cfargument name="AplacaNueva" type="string"  required="yes">

		<cfargument name="Periodo"     type="numeric" default="0"     required="no">	<!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes"         type="numeric" default="0"     required="no">	<!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug"       type="boolean" default="false" required="no">	<!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->


		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo eq 0>
			<cfset Arguments.Ecodigo = session.Ecodigo >
			<cfset Arguments.Conexion = session.dsn >
			<cfset Arguments.Usucodigo = session.Usucodigo >
			<cfset Arguments.IPregistro = session.sitio.ip >
		</cfif>

		<!--- Antes de iniciar la transacción obtiene algunos valores requeridos --->
		<!--- Verifica si viene el Periodo sino obtiene el Periodo del query rsPeriodo --->
		<cfif Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#Arguments.Conexion#"> as value
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Pcodigo = 50
					and Mcodigo = 'GN'
			</cfquery>
		</cfif>
		
		<!--- Verifica si viene el Mes sino obtiene el Mes del query rsMes --->
		<cfif Arguments.Mes neq 0>
			<cfset rsMes.value = Arguments.Mes>
		<cfelse>
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#Arguments.Conexion#"> as value
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
		</cfif>
		
		<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
		<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
		<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>

		<cfif Arguments.debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h1>DEBUG</h1><br>
				<p>
				<strong>Periodo</strong> = #rsPeriodo.value#<br>
				<strong>Mes</strong> = #rsMes.value#<br>
				<strong>FechaAux</strong> = #rsFechaAux.value#<br>
				<strong>Fecha del Sistema</strong> = #Now()#<br>
				</p>
			</cfoutput>
			<cfdump var="#Arguments#" label="Arguments">
		</cfif>

		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0>
			<cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!">
		</cfif>
		<cfif len(trim(rsMes.value)) eq 0>
			<cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!">
		</cfif>

		<!--- VALIDACIONES DE LA PLACA ORIGEN--->
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" 	  Aid="#Arguments.Aid#"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" 	  Aid="#Arguments.Aid#" validamontos="false"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion"  Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" 	  Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" 	  Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado"     Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola"         Aid="#Arguments.Aid#"/> 	
		
		<!--- VALIDACIONES DE LA PLACA DESTINO--->
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" 	 Aplaca="#Arguments.AplacaNueva#" DebeExistir= "False"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Transito" 	 Aplaca="#Arguments.AplacaNueva#"/>
		
	
		<!--- Verifica que la placa nueva no exista en TransaccionesActivos, como parte de algún cambio --->	
		<cfquery  datasource="#session.DSN#" name="CatTA">
		Select count(1) as existe
		from TransaccionesActivos
		where IDtrans = 10
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and (	  AplacaAnt 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AplacaNueva#">
			   or AplacaNueva 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AplacaNueva#">)
		</cfquery>
		
		<cfif CatTA.existe gt 0>
			<cf_errorCode	code = "50894" msg = "No es posible realizar el cambio de placa, debido a que la nueva placa ya había sido utilizada por un activo en el pasado">
		</cfif>		


		<!---Inicio Aplicación de Cambio de placa--->
			<cftransaction>
				<!---Inserta en TransaccionesActivos--->
				<cfquery name="rsTransaccionesActivos" datasource="#Arguments.Conexion#">
					insert into TransaccionesActivos(
						Ecodigo,
						Aid,
						IDtrans,
						CFid,
						TAperiodo,
						TAmes,
						TAfecha,
						TAfalta,
						TAmontooriadq,
						TAmontolocadq,
						TAmontoorimej,
						TAmontolocmej,
						TAmontoorirev,
						TAmontolocrev,
						TAsuperavit,
						Mcodigo,
						TAtipocambio,
						Usucodigo,
						AplacaAnt,
						AplacaNueva
					)
					select 
						a.Ecodigo,
						a.Aid,
						10,
						c.CFid,
						c.AFSperiodo,
						c.AFSmes,
						#Now()#,
						#Now()#,
						c.AFSvaladq,
						c.AFSvaladq,
						c.AFSvalmej,
						c.AFSvalmej,
						c.AFSvalrev,
						c.AFSvalrev,
						0.00,
						1,
						1,
						#Arguments.Usucodigo#,
						b.Aplaca,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.AplacaNueva#">
					from ADTProceso a

							inner join Activos b
								on a.Aid = b.Aid
							   and a.Ecodigo = b.Ecodigo

							inner join AFSaldos c
								on c.Aid = b.Aid
							   and c.Ecodigo = b.Ecodigo
							   and c.AFSperiodo = #rsPeriodo.value#
							   and c.AFSmes = #rsMes.value#
							   
					where IDtrans = 10
					  and a.Ecodigo = #session.Ecodigo#
					  and a.Aid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
					  and AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.AGTPid#">
				</cfquery>
	
				<cfquery name="rsUpdatePlacaActivos" datasource="#Arguments.Conexion#">
					update Activos 
					set Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AplacaNueva#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
				</cfquery>

				<cfif Arguments.Debug>
					<h3>Ejecuta Rollback por Debug</h3>
					<cftransaction action="rollback"/>
					<cf_abort errorInterfaz="">
				</cfif>

			</cftransaction>
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn true>
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

