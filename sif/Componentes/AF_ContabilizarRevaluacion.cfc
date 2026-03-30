<cfcomponent>
	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
	</cffunction>

	<cffunction name="AF_ContabilizarRevaluacion" access="public" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 	 		 type="numeric" required="no" default="0" ><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		 type="numeric" required="no" default="0" ><!--- Código de Usuario (asp) --->
		<cfargument name="Usuario" 	 		 type="string"  required="no" default="" ><!--- Loggin de Usuario (asp) --->
		<cfargument name="Conexion"  		 type="string"  required="no" default="" ><!--- IP de PC de Usuario --->
		<cfargument name="IPaplica"  		 type="string"  required="no" default="" ><!--- IP de PC de Usuario --->
		<cfargument name="AGTPid" 	 		 type="numeric" required="yes">
		<cfargument name="Programar" 		 type="boolean" required="no" default="false"> <!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" type="date" 	required="no" default="#CreateDate(1900,01,01)#" >
		<cfargument name="Periodo" 			 type="numeric" required="no" default="0" ><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				 type="numeric" required="no" default="0" ><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 			 type="boolean" required="no" default="false" ><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="contabilizar" 	 type="boolean" required="no" default="true" ><!--- si se apaga no contabiliza pero si aplica la depreciación, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 		 type="string"  required="no" default="Activo Fijo: Revaluación" ><!--- Descripción de la transacción --->
		
		<!---Variables locales --->
		<cfset var lVarCuentaRev = ''>
		<cfset var lVarErrorCta = 0>
		<cfset var lVarCtasError = ''>
		
		<!---Valida Fecha de Programación Vrs Programar--->
		<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq -1)>
			<cfset Arguments.Programar = false>
		</cfif>
		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo eq 0>
			<cfset Arguments.Ecodigo = session.Ecodigo >
			<cfset Arguments.Conexion = session.dsn >
			<cfset Arguments.Usucodigo = session.Usucodigo >
			<cfset Arguments.Usuario = session.Usuario >
			<cfset Arguments.IPaplica = session.sitio.ip >
		</cfif>
		<!---Valida que el AGTPid corresponda a un Proceso Válido--->
		<cfquery name="rsAGTProceso" datasource="#Arguments.Conexion#">
			select count(1) as cuantos from AGTProceso
			where AGTPid = #Arguments.AGTPid#
			and AGTPestadp in (0,2)
		</cfquery>
		<cfif rsAGTProceso.cuantos is not 1>
			<cf_errorCode	code = "50911" msg = "El Grupo de Transacciones seleccionado es inválido!, Proceso Cancelado!">
		</cfif>
		<!---Antes de iniciar la transacción hace algunos calculos--->
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfif Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value" Conexion="#arguments.conexion#" Ecodigo="#Arguments.Ecodigo#"/>
		</cfif>
		<cfif Arguments.Mes neq 0>
			<cfset rsMes.value = Arguments.Mes>
		<cfelse>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" returnvariable="rsMes.value" Conexion="#arguments.conexion#" Ecodigo="#Arguments.Ecodigo#"/>
		</cfif>
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
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
				<strong>Moneda</strong> = #rsMoneda.value#<br>
				<strong>FechaAux</strong> = #rsFechaAux.value#<br>
				<strong>Fecha del Sistema</strong> = #Now()#<br>
				</p>
			</cfoutput>
			<cfdump var="#Arguments#" label="Arguments">
		</cfif>
		
		<!--- Obtiene el número de Documento --->
		<cfquery name="rsAGTProcesoDoc" datasource="#Arguments.Conexion#">
			select AGTPdocumento 
			from AGTProceso 
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfif rsAGTProcesoDoc.recordcount eq 0 or (rsAGTProcesoDoc.recordcount and len(trim(rsAGTProcesoDoc.AGTPdocumento)) eq 0) or rsAGTProcesoDoc.AGTPdocumento eq 0>
			<cf_errorCode	code = "50912" msg = "Error obteniendo el Documento, No se pudo obtener el documento de la transacción de depreciación, Proceso Cancelado!">
		</cfif>

		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>
		<!--- Si programar --->
		<cfif (Arguments.Programar)>
			<cfquery name="rsActualizaProceso" datasource="#Arguments.Conexion#">
				Update AGTProceso 
				set AGTPestadp = 2,
				AGTPfechaprog = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#">
				where AGTPid = #Arguments.AGTPid#
			</cfquery>
		<cfelse>
			<!--- ****************** C O N T A B I L I Z A C I O N ****************** --->
			<cfif Arguments.contabilizar is true>
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
						<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
				</cfinvoke>
				
				<cf_dbfunction name="concat" args="'Revaluación ' + b.Aplaca" returnvariable="INTDES01" delimiters="+">	
				<cf_dbfunction name="concat" args="'Revaluación Depreciación Acumulada ' + b.Aplaca" returnvariable="INTDES02" delimiters="+">		
				<cf_dbfunction name="concat" args="'Superavit ' + b.Aplaca" returnvariable="INTDES03" delimiters="+">		
				
				<!--- Débito por Revaluación --->
				<cfquery name="rstemp" datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFRE',
							1,
							<cf_dbfunction name="to_char" args="g.AGTPdocumento" datasource="#Arguments.Conexion#">, 
							'RE',
							a.TAmontolocadq + a.TAmontolocmej + a.TAmontolocrev,
							'D',
							 #PreserveSingleQuotes(INTDES01)#,
							'#DateFormat(now(),'YYYYMMDD')#',
							1.00,
							#rsPeriodo.value#, 
							#rsMes.value#,
							c.ACcrevaluacion,   <!--- a.Ccuentarev, --->
							#rsMoneda.value#,
							d.Ocodigo,
							a.TAmontolocadq + a.TAmontolocmej + a.TAmontolocrev,
                            a.CFid
					from ADTProceso a
						inner join Activos b
							on b.Aid = a.Aid
						inner join AClasificacion c
							on c.Ecodigo = b.Ecodigo
							and c.ACid = b.ACid
							and c.ACcodigo = b.ACcodigo
						inner join CFuncional d
							on d.CFid = a.CFid
						inner join AGTProceso g
							on g.AGTPid = a.AGTPid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
				
				<!--- Crédito por Revaluación de la Depreciación Acumulada --->
				<cfquery name="rstemp" datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFRE',
							1,
							<cf_dbfunction name="to_char" args="g.AGTPdocumento"  datasource="#Arguments.Conexion#">, 
							'DP',
							(a.TAmontolocadq + a.TAmontolocmej + a.TAmontolocrev) - a.TAsuperavit,
							'C',
							 #PreserveSingleQuotes(INTDES02)# ,
							'#DateFormat(now(),'YYYYMMDD')#',
							1,
							#rsPeriodo.value#, 
							#rsMes.value#,
							c.ACcdepacumrev,
							#rsMoneda.value#,
							d.Ocodigo,
							(a.TAmontolocadq + a.TAmontolocmej + a.TAmontolocrev) - a.TAsuperavit,
                            a.CFid
					from ADTProceso a
						inner join Activos b
							on b.Aid = a.Aid
						inner join AClasificacion c
							on c.Ecodigo = b.Ecodigo
							and c.ACid = b.ACid
							and c.ACcodigo = b.ACcodigo
						inner join CFuncional d
							on d.CFid = a.CFid
						inner join AGTProceso g
							on g.AGTPid = a.AGTPid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
		
				<!--- Crédito por superavit --->
				<cfquery name="rstemp" datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFRE',
							1,
							<cf_dbfunction name="to_char" args="g.AGTPdocumento"  datasource="#Arguments.Conexion#">, 
							'DP',
							a.TAsuperavit,
							'C',
							 #PreserveSingleQuotes(INTDES03)# ,
							'#DateFormat(now(),'YYYYMMDD')#',
							1,
							#rsPeriodo.value#, 
							#rsMes.value#,
							c.ACcsuperavit,
							#rsMoneda.value#,
							d.Ocodigo,
							a.TAsuperavit,
                            a.CFid
					from ADTProceso a
						inner join Activos b
							on b.Aid = a.Aid
						inner join AClasificacion c
							on c.Ecodigo = b.Ecodigo
							and c.ACid = b.ACid
							and c.ACcodigo = b.ACcodigo
						inner join CFuncional d
							on d.CFid = a.CFid
						inner join AGTProceso g
							on g.AGTPid = a.AGTPid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
			</cfif>

			<cftransaction>

				<!---Inserta en TransaccionesActivos--->
				<cfquery name="rsTransaccionesActivos" datasource="#Arguments.Conexion#">
					insert into TransaccionesActivos(
						 Ecodigo
						,Aid
						,IDtrans
						,CFid
						,TAperiodo
						,TAmes
						,TAfecha
						,TAfalta
						
						,TAmontolocadq 
						,TAmontooriadq 
						,TAmontolocmej 
						,TAmontoorimej 
						,TAmontolocrev 
						,TAmontoorirev 
						
						,TAmontodepadq
						,TAmontodepmej
						,TAmontodeprev

						,TAvaladq
						,TAvalmej
						,TAvalrev
						
						,TAdepacumadq
						,TAdepacummej
						,TAdepacumrev
							
						,TAsuperavit 
						,AFIindice
						,Mcodigo
						,TAtipocambio
						,Ccuenta
						,AGTPid
						,Usucodigo

						,TAfechainidep
						,TAvalrescate
						,TAvutil
						,TAfechainirev
						,TAmeses
					)
					select 
						 a.Ecodigo
						,a.Aid
						,a.IDtrans
						,a.CFid
						,a.TAperiodo
						,a.TAmes
						,a.TAfecha
						,a.TAfalta
						
						,TAmontolocadq   <!--- revaluacion del valor de adquisicion (TAmontolocadq)  --->
						,TAmontolocadq   <!--- revaluacion del valor de adquisicion (TAmontooriadq)  --->
						,TAmontolocmej   <!--- revaluacion del valor de mejoras (TAmontolocmej)      --->
						,TAmontolocmej   <!--- revaluacion del valor de mejoras (TAmontoorimej)      --->
						,TAmontolocrev   <!--- revaluacion del valor de revaluacion (TAmontolocrev)  --->
						,TAmontolocrev   <!--- revaluacion del valor de revaluacion (TAmontoorirev)  --->
						
						,TAmontodepadq
						,TAmontodepmej
						,TAmontodeprev

						,TAvaladq
						,TAvalmej
						,TAvalrev
						
						,TAdepacumadq
						,TAdepacummej
						,TAdepacumrev
							
						,TAsuperavit     <!--- revaluacion - revaluacion de la depreciacion   --->
						,AFIindice
						,Mcodigo
						,TAtipocambio,
						(Select ACcadq
						from AClasificacion acl
						where acl.ACid = b.ACid
						   and acl.ACcodigo = b.ACcodigo
						   and acl.Ecodigo = b.Ecodigo) as Ccuenta
						,a.AGTPid
						,#Arguments.Usucodigo#

						,b.Afechainidep
						,b.Avalrescate
						,a.TAvutil
						,b.Afechainirev
						,a.TAmeses
					from ADTProceso a
						inner join Activos b 
							on b.Aid = a.Aid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
	
				<!--- Actualiza AFSaldos --->
				<cfquery name="PorActualizar" datasource="#Arguments.Conexion#">
					select AFSid, TAmontolocadq,TAmontolocmej ,TAmontolocrev,TAmontodepadq,TAmontodepmej,TAmontodeprev
					from ADTProceso a
						inner join AFSaldos b
							on b.Aid         = a.Aid
					  		and b.AFSperiodo = a.TAperiodo
							and b.AFSmes     = a.TAmes
							and b.CFid 	 	 = a.CFid
							and b.Ecodigo    = a.Ecodigo
					where a.AGTPid     = #Arguments.AGTPid#
					  and a.TAperiodo  = #rsPeriodo.value#
					  and a.TAmes      = #rsMes.value#
					  and a.Ecodigo    = #Arguments.Ecodigo#
				</cfquery>
				<cfloop query="PorActualizar">
					<cfquery name="rsAFSaldos" datasource="#Arguments.Conexion#">
						Update AFSaldos
							set AFSvalrev = AFSvalrev + #PorActualizar.TAmontolocadq# + #PorActualizar.TAmontolocmej# + #PorActualizar.TAmontolocrev#,
								AFSdepacumrev = AFSdepacumrev + #PorActualizar.TAmontodepadq# + #PorActualizar.TAmontodepmej# + #PorActualizar.TAmontodeprev#
						where AFSid = #PorActualizar.AFSid#
					</cfquery>
				</cfloop>
				
				<cfif Arguments.contabilizar is true>
					<!--- Obtiene la minima oficina de asiento. (La oficina se le manda al genera asiento para que agrupe) --->
					<cfquery name="rsMinOficina" datasource="#session.dsn#">
					  Select Min(Ocodigo) as MinOcodigo
					   from #INTARC# 
					</cfquery>					
					<cfif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
						<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
					<cfelse>
						<cfset LvarOcodigo = -100>
					</cfif>					

					<!--- Genera Asiento --->
					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
						<cfinvokeargument name="Conexion" 	  value="#Arguments.Conexion#"/>
						<cfinvokeargument name="Ecodigo" 	  value="#Arguments.Ecodigo#"/>
						<cfinvokeargument name="Usucodigo" 	  value="#Arguments.Usucodigo#"/>
						<cfinvokeargument name="IP" 		  value="#Arguments.IPaplica#"/>
						<cfinvokeargument name="Usuario" 	  value="#Arguments.Usuario#"/>
						<cfinvokeargument name="Oorigen" 	  value="AFRE"/>
						<cfinvokeargument name="Eperiodo" 	  value="#rsPeriodo.value#"/>
						<cfinvokeargument name="Emes" 		  value="#rsMes.value#"/>
						<cfinvokeargument name="Efecha" 	  value="#rsFechaAux.value#"/>
						<cfinvokeargument name="Edescripcion" value="#Arguments.descripcion#"/>
						<cfinvokeargument name="Edocbase"     value="#rsAGTProcesoDoc.AGTPdocumento#"/>
						<cfinvokeargument name="Ereferencia"  value="RE"/>
						<cfinvokeargument name="Ocodigo"      value="#LvarOcodigo#"/>
						<cfinvokeargument name="Debug"        value="#Arguments.Debug#"/>
					</cfinvoke>
					<cfif isdefined("res_GeneraAsiento")>
					
						<cfquery name="rstemp" datasource="#session.dsn#">
							update TransaccionesActivos 
							set IDcontable = #res_GeneraAsiento#
							where AGTPid = #Arguments.AGTPid#
						</cfquery>						
					
					</cfif>
				</cfif>
				
				<!---Borra ADTProceso--->
				<cfquery name="rsDelteADTProceso" datasource="#Arguments.Conexion#">
					delete from ADTProceso
					where AGTPid = #Arguments.AGTPid#
				</cfquery>
				<!---Actualiza estado a AGTProceso--->
				<cfquery name="rsUpdateAGTProceso" datasource="#Arguments.Conexion#">
					Update AGTProceso
					set AGTPestadp = 4,
					AGTPfaplica = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					AGTPipaplica = '#arguments.IPaplica#',
					Usuaplica = #Arguments.Usucodigo#
					where AGTPid = #Arguments.AGTPid#
				</cfquery>
				
				<cfif Arguments.debug>
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#" maxrows="10">
						select * 
						from TransaccionesActivos 
						where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="TransaccionesActivos">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#" maxrows="10">
						select * 
						from AFSaldos
						where Ecodigo = #Arguments.Ecodigo#
						and AFSperiodo = #rsPeriodo.value#
						and AFSmes = #rsMes.value#
					</cfquery>
					<cfdump var="#rsTemp#" label="AFSaldos">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#" maxrows="10">
						select * 
						from ADTProceso
						where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="ADTProceso">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#" maxrows="10">
						select * 
						from AGTProceso
						where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="AGTProceso">
					<cftransaction action="rollback"/>
					<cf_abort errorInterfaz="">
				</cfif>
			</cftransaction>
		</cfif>
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn true>
	</cffunction>
</cfcomponent>