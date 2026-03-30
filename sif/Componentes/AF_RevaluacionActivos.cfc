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
<!---*********************************************************************************
 PRIMER PROCESO DE REVALUACION
   *  Toma de Saldos
          o Se tomaran los saldos del periodo Anterior
    * Se tomara en cuenta del Periodo Actual
          o Ningún movimiento del periodo Actual
    * Cambio de Configuración
          o Ver parámetro "Considerar traslados, retiros y Revaluaciónes del último periodo en la Revaluación" 
		     en administración del sistema - Parámetros Adicionales.
*********************************************************************************--->
	<cffunction name="AF_RevaluacionActivos" access="public" returntype="numeric" output="true">
		<!---Cálculo de la Revaluación por la diferencia de indices desde la última revaluación de cada activo. Calcula la revaluación para todos los activos en estado activo,
		que no se han revaluado por completo, que no se han revaluado en el periodo y mes actual de los auxiliares, y que cumplan con los filtros 
		que se reciben como parámetros.
		--->
		<cfargument name="AGTPid" 			type="numeric" required="no"	default="0"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al cálculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" 			type="numeric" required="no"	default="0"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		type="numeric" required="no"	default="0"><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 		type="string"  required="no"	default=""><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 		type="string"  required="no"	default=""><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" 	type="string"  required="no"	default="Revaluación"><!--- Descripción de la transacción --->
		<cfargument name="FOcodigo" 		type="numeric" required="no"	default="0"><!--- Filtro por Oficina --->
		<cfargument name="FDcodigo"  		type="numeric" required="no"	default="0"><!--- Filtro por Departamento --->
		<cfargument name="FCFid" 	 		type="numeric" required="no"	default="0"><!--- Filtro por Centro  --->
		<cfargument name="FACcodigo" 		type="numeric" required="no"	default="0"><!--- Filtro por Categoria --->
		<cfargument name="FACid" 			type="numeric" required="no"	default="0"><!--- Filtro por Clase --->
		<cfargument name="FAFCcodigo" 		type="numeric" required="no"	default="0"><!--- Filtro por Tipo --->
		<cfargument name="debug" 			type="boolean" required="no"	default="false"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 			type="numeric" required="no"	default="0"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				type="numeric" required="no"	default="0"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Programar" 		type="boolean" required="no"	default="false"><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion"type="date"    required="no"	default="#CreateDate(1900,01,01)#">
		<!--- <cfset Arguments.debug = true> --->
		
		<cfif Arguments.debug>
			<h2>AF_RevaluacionActivos</h2>
			<cfdump var="#Arguments#">
		</cfif>
		
		<!---Valida Fecha de Programación Vrs Programar--->
		<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq -1)>
			<cfset Arguments.Programar = false>
		</cfif>
		
		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.AGTPid is 0>
			<cfset Arguments.Ecodigo 	= session.Ecodigo>
			<cfset Arguments.Conexion 	= session.dsn>
			<cfset Arguments.Usucodigo 	= session.Usucodigo>
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
				where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
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
		
		<!---Prepara los filtros antes de la consulta para hacerla mas clara --->
		<cfset filtroa="">
		<cfset filtrob="">
		<cfset filtrocf="">
		<cfif Arguments.FCFid>							<!--- Filtro por centro funcional--->
			<cfset filtroa = filtroa & " and a.CFid = " & Arguments.FCFid>
		</cfif>					
		<cfif Arguments.FACcodigo>  					<!--- Filtro por categoría--->
			<cfset filtrob = filtrob & " and b.ACcodigo = " & Arguments.FACcodigo>
		</cfif>					
		<cfif Arguments.FACid>     						<!--- Filtro por clase--->
			<cfset filtrob = filtrob & " and b.ACid = " & Arguments.FACid>
		</cfif>					
		<cfif Arguments.FAFCcodigo> 					<!--- Filtro por tipo--->
			<cfset filtrob = filtrob & " and b.AFCcodigo = " & Arguments.FAFCcodigo>
		</cfif>
		<cfif Arguments.FOcodigo or Arguments.FDcodigo> <!--- Join con centro funcional para filtrar ---->
				<cfset filtrocf = filtrocf & " inner join CFuncional cf 
												on cf.Ecodigo = a.Ecodigo 
												and cf.CFid = a.CFid ">
		</cfif> 																																																							
		<cfif Arguments.FOcodigo>						<!--- Filtro por oficina--->
			<cfset filtrocf = filtrocf & " and cf.Ocodigo = " & Arguments.FOcodigo>
		</cfif>
		<cfif Arguments.FDcodigo>						<!--- Filtro por departamento--->
			<cfset filtrocf = filtrocf & " and cf.Dcodigo = " & Arguments.FDcodigo>
		</cfif>

		<!---Crea Tabla temporal de las transacciones de revaluación para poder procesarlas un poco antes de insertarlas, 
		básicamente se borran algunos registro antes de insertar definitivamente las transacciones--->

		<cf_dbtemp name="AFtemp01" returnvariable="ACTIVOS" datasource="#Arguments.conexion#">
			<cf_dbtempcol name="Ecodigo"  		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="AGTPid"  		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Aid"  			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="IDtrans"  		type="int"    	mandatory="yes">
			<cf_dbtempcol name="CFid"  			type="numeric" 	mandatory="yes">
			<cf_dbtempcol name="TAfalta"  		type="datetime" mandatory="yes">
			
			<cf_dbtempcol name="TAfechainidep"  type="datetime" mandatory="yes">
			<cf_dbtempcol name="TAvalrescate"  	type="money" 	mandatory="yes">
			<cf_dbtempcol name="TAvutil"  		type="int"  	mandatory="yes">
			<cf_dbtempcol name="TAfechainirev" 	type="datetime"	mandatory="yes">
			<cf_dbtempcol name="TAperiodo"     	type="int"      mandatory="yes">
			<cf_dbtempcol name="TAmes" 			type="int"    	mandatory="yes">
			
			<cf_dbtempcol name="TAfecha" 		type="datetime" mandatory="yes">
			<cf_dbtempcol name="Usucodigo" 		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="TAmeses"  		type="int"		mandatory="yes">
			
			<cf_dbtempcol name="TAmontolocadq"  type="money"    mandatory="yes">
			<cf_dbtempcol name="TAmontolocmej"  type="money"    mandatory="yes">
			<cf_dbtempcol name="TAmontolocrev"  type="money"    mandatory="yes">
			
			<cf_dbtempcol name="TAmontodepadq"  type="money"    mandatory="yes">
			<cf_dbtempcol name="TAmontodepmej"  type="money"    mandatory="yes">
			<cf_dbtempcol name="TAmontodeprev"  type="money"    mandatory="yes">
			
			<cf_dbtempcol name="TAvaladq"  		type="money"    mandatory="yes">
			<cf_dbtempcol name="TAvalmej"  		type="money"    mandatory="yes">
			<cf_dbtempcol name="TAvalrev"  		type="money"    mandatory="yes">
			
			<cf_dbtempcol name="TAdepacumadq"  	type="money"    mandatory="yes">
			<cf_dbtempcol name="TAdepacummej"  	type="money"    mandatory="yes">
			<cf_dbtempcol name="TAdepacumrev"  	type="money"    mandatory="yes">
			
			<cf_dbtempcol name="TAsuperavit"  	type="money"    mandatory="yes">
			<cf_dbtempcol name="AFIindice"  	type="float"    mandatory="yes">
			
			<cf_dbtempkey cols="Aid">
		</cf_dbtemp>

		<cfif not Arguments.Programar>
			<!--- Obtiene el Periodo / Mes de Donde Obtener los Saldos --->
			<cfquery name="rsMesesDiferenciaFromAuxiliares" datasource="#Arguments.conexion#">
				select Pvalor from Parametros where Pcodigo = 900 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">
			 </cfquery>
			<cfscript>
				if (rsMesesDiferenciaFromAuxiliares.recordcount gt 0 and len(trim(rsMesesDiferenciaFromAuxiliares.Pvalor)) gt 0) {
					Intvar_PeriodoSaldos = rsPeriodo.value - (abs(rsMesesDiferenciaFromAuxiliares.Pvalor) \ 12);
					Intvar_MesSaldos = rsMes.value - (abs(rsMesesDiferenciaFromAuxiliares.Pvalor) mod 12);
				} else {
					/*Por defecto el Periodo / Mes de Revaluacion es el más próximo cerrado*/
					if (rsMes.value gt 1){
						Intvar_PeriodoSaldos = rsPeriodo.value;
						Intvar_MesSaldos = rsMes.value-1;
					} else {
						Intvar_PeriodoSaldos = rsPeriodo.value-1;
						Intvar_MesSaldos = 12;
					}
				}
			 </cfscript>
			 
			 <cfif Arguments.debug>
				<cfdump var="#Intvar_PeriodoSaldos#" label="PeriodoSaldos">
				<cfdump var="#Intvar_MesSaldos#" label="MesSaldos">
			 </cfif>
			
			<!---Cálculo
			Fórmula de la Revaluación:
						
						Variables:
							Saldos Mes Auxiliares - Meses Diferencia para Saldos Revaluacion - Parámetro 900 - = Saldos de Activos al Perioro Mes de Auxiliares Menos la cantidad de meses indicada por el parámetro 900
							Indice Mes Auxiliares = Indice de Revaluación al Mes de Auxiliares
							Depreciacion Acumulada Mes Auxiliares - Meses Diferencia para Saldos Revaluacion - Parámetro 900 - = Depreciación Acumulada de Activos al Perioro Mes de Auxiliares Menos la cantidad de meses indicada por el parámetro 900
		
						Fórmula:
							Revaluacion =	( Saldos Mes Auxiliares - Meses Diferencia para Saldos Revaluacion - Parámetro 900 -) * (Indice Mes Auxiliares)
							Revaluacion Depreaciacion =	( Depreciacion Acumulada Mes Auxiliares - Meses Diferencia para Saldos Revaluacion - Parámetro 900 -) * (Indice Mes Auxiliares)
							Superavit = Revaluacion - Revaluacion Depreciacion
			--->
			<!---EXEPCIONES DE LOS INDICES DE REVALUACION--->
			<cfquery datasource="#arguments.conexion#">
				insert into #ACTIVOS#
					(Ecodigo, AGTPid, Aid, IDtrans, CFid, TAfalta, 
					TAfechainidep, TAvalrescate, TAvutil, 
					TAfechainirev, TAperiodo, TAmes, 
					TAfecha, Usucodigo
					, TAmeses 
					
					,TAmontolocadq 
					,TAmontolocmej 
					,TAmontolocrev 

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
					)
				select
					a.Ecodigo, -1 as AGTPid, a.Aid, 3 as IDtrans, a.CFid, <cf_dbfunction name="now"> as TAfalta, 
					b.Afechainidep as TAfechainidep, b.Avalrescate as TAvalrescate, AFSvutiladq as TAvutil, 
					b.Afechainirev as TAfechainirev,
					#rsPeriodo.value# as TAperiodo, 
					#rsMes.value# as TAmes, 
					#rsFechaAux.value# as TAfecha,
					#Arguments.usucodigo# as Usucodigo,
					(#rsPeriodo.value# - AFSperiodourev)*12 + (#rsMes.value# - AFSmesurev) as TAmeses
					
					,case when AFSsaldovutiladq > 0 then round(AFSvaladq * e.AFIindice,2) else 0.00 end as TAmontolocadq
					,case when AFSsaldovutiladq > 0 then round(AFSvalmej * e.AFIindice,2) else 0.00 end as TAmontolocmej
					,case when AFSsaldovutilrev > 0 then round(AFSvalrev * e.AFIindice,2) else 0.00 end as TAmontolocrev
					
					,case when AFSsaldovutiladq > 0 then round(AFSdepacumadq * e.AFIindice,2) else 0.00 end as TAmontodepadq
					,case when AFSsaldovutiladq > 0 then round(AFSdepacummej * e.AFIindice,2) else 0.00 end as TAmontodepmej
					,case when AFSsaldovutilrev > 0 then round(AFSdepacumrev * e.AFIindice,2) else 0.00 end as TAmontodeprev
					
					,AFSvaladq
					,AFSvalmej
					,AFSvalrev
					
					,AFSdepacumadq
					,AFSdepacummej
					,AFSdepacumrev

					,case when AFSsaldovutiladq > 0 then round(AFSvaladq * e.AFIindice,2) else 0.00 end
					+case when AFSsaldovutiladq > 0 then round(AFSvalmej * e.AFIindice,2) else 0.00 end
					+case when AFSsaldovutilrev > 0 then round(AFSvalrev * e.AFIindice,2) else 0.00 end
					
					-case when AFSsaldovutiladq > 0 then round(AFSdepacumadq * e.AFIindice,2) else 0.00 end
					-case when AFSsaldovutiladq > 0 then round(AFSdepacummej * e.AFIindice,2) else 0.00 end
					-case when AFSsaldovutilrev > 0 then round(AFSdepacumrev * e.AFIindice,2) else 0.00 end as TAsuperavit

					,e.AFIindice
					
				from AFSaldos a
					inner join Activos b 
						on b.Aid = a.Aid
						and b.Astatus = 0 						<!--- estado activo --->
						#filtrob#								<!--- filtro por categoria / clase --->
					inner join AFIndicesExc e					<!--- Índice Actual - Con Excepcion por Oficina --->
						on e.Ecodigo = a.Ecodigo
						and e.ACcodigo = a.ACcodigo
						and e.ACid = a.ACid
						and e.AFIperiodo = a.AFSperiodo
						and e.AFImes = a.AFSmes
						and e.Ocodigo = a.Ocodigo
					#filtrocf#									<!--- filtro por oficina / departamento --->
				where a.Ecodigo =#arguments.ecodigo#
					and a.AFSperiodo = #Intvar_PeriodoSaldos#
					and a.AFSmes = #Intvar_MesSaldos#
					and a.AFSrevalua = 1						<!--- Clasificación revaluable. Se asigna en la Adquisición, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional --->
					#filtroa#	    							<!--- filtro por centro funcional --->
			</cfquery>
			<!---INDICES DE REVALUACION--->
			<cfquery datasource="#arguments.conexion#">
				insert into #ACTIVOS#
					(Ecodigo, AGTPid, Aid, IDtrans, CFid, TAfalta, 
					TAfechainidep, TAvalrescate, TAvutil, 
					TAfechainirev, TAperiodo, TAmes, 
					TAfecha, Usucodigo
					, TAmeses <!--- Cantidad de Meses a Revaluar, En realidad se calcula con base en la diferencia mese entre la ultima revaluacion y esta revaluacion --->
					
					,TAmontolocadq   <!--- revaluacion del valor de adquisicion (TAmontolocadq) --->
					,TAmontolocmej   <!--- revaluacion del valor de mejoras (TAmontolocmej) --->
					,TAmontolocrev   <!--- revaluacion del valor de revaluacion (TAmontolocrev) --->

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
					)
				select
					a.Ecodigo, -1 as AGTPid, a.Aid, 3 as IDtrans, a.CFid, <cf_dbfunction name="now"> as TAfalta, 
					b.Afechainidep as TAfechainidep, b.Avalrescate as TAvalrescate, AFSvutiladq as TAvutil, 
					b.Afechainirev as TAfechainirev,
					#rsPeriodo.value# as TAperiodo, 
					#rsMes.value# as TAmes, 
					#rsFechaAux.value# as TAfecha,
					#Arguments.usucodigo# as Usucodigo,
					(#rsPeriodo.value# - AFSperiodourev)*12 + (#rsMes.value# - AFSmesurev) as TAmeses
					
					,case when AFSsaldovutiladq > 0 then round(AFSvaladq * e.AFIindice,2) else 0.00 end as TAmontolocadq
					,case when AFSsaldovutiladq > 0 then round(AFSvalmej * e.AFIindice,2) else 0.00 end as TAmontolocmej
					,case when AFSsaldovutilrev > 0 then round(AFSvalrev * e.AFIindice,2) else 0.00 end as TAmontolocrev
					
					,case when AFSsaldovutiladq > 0 then round(AFSdepacumadq * e.AFIindice,2) else 0.00 end as TAmontodepadq
					,case when AFSsaldovutiladq > 0 then round(AFSdepacummej * e.AFIindice,2) else 0.00 end as TAmontodepmej
					,case when AFSsaldovutilrev > 0 then round(AFSdepacumrev * e.AFIindice,2) else 0.00 end as TAmontodeprev
					
					,AFSvaladq
					,AFSvalmej
					,AFSvalrev
					
					,AFSdepacumadq
					,AFSdepacummej
					,AFSdepacumrev
					
					,case when AFSsaldovutiladq > 0 then round(AFSvaladq * e.AFIindice,2) else 0.00 end
					+case when AFSsaldovutiladq > 0 then round(AFSvalmej * e.AFIindice,2) else 0.00 end
					+case when AFSsaldovutilrev > 0 then round(AFSvalrev * e.AFIindice,2) else 0.00 end
					
					-case when AFSsaldovutiladq > 0 then round(AFSdepacumadq * e.AFIindice,2) else 0.00 end
					-case when AFSsaldovutiladq > 0 then round(AFSdepacummej * e.AFIindice,2) else 0.00 end
					-case when AFSsaldovutilrev > 0 then round(AFSdepacumrev * e.AFIindice,2) else 0.00 end as TAsuperavit
					
					,e.AFIindice
					
				from AFSaldos a
					inner join Activos b 
						on b.Ecodigo = a.Ecodigo
						and b.Aid = a.Aid
						and b.Astatus = 0 						<!--- estado activo --->
						#filtrob#								<!--- filtro por categoria / clase --->
					inner join AFIndices e						<!--- Índice Actual --->
						on e.Ecodigo = a.Ecodigo
						and e.ACcodigo = a.ACcodigo
						and e.ACid = a.ACid
						and e.AFIperiodo = a.AFSperiodo
						and e.AFImes = a.AFSmes
					#filtrocf#									<!---filtro por oficina / departamento--->
				where a.Ecodigo = #arguments.ecodigo#
				  and a.AFSperiodo = #Intvar_PeriodoSaldos#
				  and a.AFSmes = #Intvar_MesSaldos#
				  and a.AFSrevalua = 1						<!--- Clasificación revaluable. Se asigna en la Adquisición, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional --->
				  #filtroa#									<!--- filtro por centro funcional --->
				  and not exists(
					select 1
					from #ACTIVOS# aa
					where aa.Aid = a.Aid
					  and aa.IDtrans = 3
					  )
			</cfquery>
			
			<!---Borra Ya Revaluados Aplicados--->
			<cfquery datasource="#arguments.conexion#">
				delete from #ACTIVOS#
				where exists (select 1
						from TransaccionesActivos b 
						where b.Ecodigo   = #ACTIVOS#.Ecodigo 
						and   b.Aid 	  = #ACTIVOS#.Aid
						and   b.TAperiodo = #rsPeriodo.value#
						and   b.TAmes 	  = #rsMes.value#
						and   b.IDtrans   = 3   
					   )
			</cfquery>
			<!---Borra Ya Revaluados Sin Aplicar--->
			<cfquery datasource="#arguments.conexion#">
				delete from #ACTIVOS#
					where exists (select 1
						from ADTProceso b 
						where b.Ecodigo   = #ACTIVOS#.Ecodigo 
						and   b.Aid 	  = #ACTIVOS#.Aid 
						and   b.TAperiodo = #rsPeriodo.value#
						and   b.TAmes 	  = #rsMes.value#
						and   b.IDtrans   = 3   
					   )
			</cfquery>
			
		<!---Validaciones
			1-Transacciones de MEJORA Pendiente de Aplicar
			2-Transacciones de DEPRECIACION Pendiente de Aplicar
			3-Transacciones de RETIROS Pendiente de Aplicar
			4-Transacciones de TRASLADOS Pendiente de Aplicar
			5-Transacciones de CAMBIO CATEGORIA-CLASE Pendiente de Aplicar
		--->
			  
			<!---1-Transacciones de MEJORA Pendiente de Aplicar--->
			<cfquery name="rsRevisaPendMejoras" datasource="#Arguments.Conexion#">
				Select count(1) as Cantidad
				from #ACTIVOS# a						
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.AGTPid  = -1
				  and exists(Select 1
							 from ADTProceso c
							 where c.Aid 		= a.Aid
							   and c.Ecodigo 	= a.Ecodigo
							   and c.IDtrans 	= 2
							   and c.TAperiodo 	= #rsPeriodo.value#
							   and c.TAmes 		= #rsMes.value#)
			</cfquery>  
			<!---2-Transacciones de DEPRECIACION Pendiente de Aplicar--->							
			<cfquery name="rsRevisaPendRevaluacion" datasource="#Arguments.Conexion#">
				Select count(1) as Cantidad
				from #ACTIVOS# a						
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.AGTPid  = -1
				  and exists(Select 1
							 from ADTProceso c
							 where c.Aid 		= a.Aid
							   and c.Ecodigo 	= a.Ecodigo
							   and c.IDtrans 	= 4
							   and c.TAperiodo 	= #rsPeriodo.value#
							   and c.TAmes		= #rsMes.value#)
			</cfquery>  
			<!---3-Transacciones de RETIROS Pendiente de Aplicar--->
			<cfquery name="rsRevisaPendRetiros" datasource="#Arguments.Conexion#">
				Select count(1) as Cantidad
				from #ACTIVOS# a						
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.AGTPid  = -1
				  and exists(Select 1
							 from ADTProceso c
							 where c.Aid 		= a.Aid
							   and c.Ecodigo 	= a.Ecodigo
							   and c.IDtrans 	= 5
							   and c.TAperiodo 	= #rsPeriodo.value#
							   and c.TAmes 		= #rsMes.value#)							   
			</cfquery>  								
			
			<!---4-Transacciones de TRASLADOS Pendiente de Aplicar--->			
			<cfquery name="rsRevisaPendRetiros" datasource="#Arguments.Conexion#">
				Select count(1) as Cantidad
				from #ACTIVOS# a						
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.AGTPid  = -1
				  and exists(Select 1
							 from ADTProceso c
							 where c.Aid 		= a.Aid
							   and c.Ecodigo 	= a.Ecodigo
							   and c.IDtrans 	= 8
							   and c.TAperiodo 	= #rsPeriodo.value#
							   and c.TAmes 		= #rsMes.value#)							   
			</cfquery>  								
			<!--- 5-Transacciones de CAMBIO CATEGORIA-CLASE Pendiente de Aplicar--->			
			<cfquery name="rsRevisaPendRetiros" datasource="#Arguments.Conexion#">
				Select count(1) as Cantidad
				from #ACTIVOS# a						
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.AGTPid  = -1
				  and exists(Select 1
							 from ADTProceso c
							 where c.Aid 		= a.Aid
							   and c.Ecodigo 	= a.Ecodigo
							   and c.IDtrans 	= 6
							   and c.TAperiodo 	= #rsPeriodo.value#
							   and c.TAmes 		= #rsMes.value# )							   
			</cfquery>  								
			
			<cfset LvarMensajeError = "">
			<cfif rsRevisaPendMejoras.Cantidad gt 0>
				<cfif LvarMensajeError NEQ "">
					<cfset LvarMensajeError & "<br>">
				</cfif>
				<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Mejora pendiente de aplicar!">
			</cfif>
			
			<cfif rsRevisaPendRevaluacion.Cantidad gt 0>
				<cfif LvarMensajeError NEQ "">
					<cfset LvarMensajeError & "<br>">
				</cfif>
				<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Depreciacion pendiente de aplicar!">
			</cfif>

			<cfif rsRevisaPendRetiros.Cantidad gt 0>
				<cfif LvarMensajeError NEQ "">
					<cfset LvarMensajeError & "<br>">
				</cfif>
				<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Retiro pendiente de aplicar!">
			</cfif>				
			<cfif rsRevisaPendRetiros.Cantidad gt 0>
				<cfif LvarMensajeError NEQ "">
					<cfset LvarMensajeError & "<br>">
				</cfif>
				<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Traslado pendiente de aplicar!">
			</cfif>	

			<cfif rsRevisaPendRetiros.Cantidad gt 0>
				<cfif LvarMensajeError NEQ "">
					<cfset LvarMensajeError & "<br>">
				</cfif>
				<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Cambio de Categoria-Clase pendiente de aplicar!">
			</cfif>	

			<cfif LvarMensajeError NEQ "">
				<cfthrow message="#LvarMensajeError#">
			</cfif>

			<cfquery name="rsVerificaCantidad" datasource="#arguments.conexion#">
				select count(1) as Cantidad
				from #ACTIVOS#
			</cfquery>
			<cfif rsVerificaCantidad.Cantidad LT 1>
					<cf_errorCode	code = "50945" msg = "NO existen Activos a considerar según los parametros indicados!">
			</cfif>
		</cfif>
		
		<!---Inicio Cálculo de la Revaluación--->
		<cftransaction>
			<cfif Arguments.AGTPid is 0>
			
				<cfinvoke component		 = "sif.Componentes.OriRefNextVal"
						  method		 = "nextVal"
						  returnvariable = "LvarNumDoc"
						  ORI			 = "AFRE"
						  REF			 = "RE"
				/>

				<!---Inserta Grupo de transacciones de Revaluación--->
				<cfquery name="idquery" datasource="#arguments.conexion#">
					insert into AGTProceso
					(Ecodigo, 
						IDtrans, 
						AGTPdocumento, 
						AGTPdescripcion,
						AGTPperiodo, 
						AGTPmes, 
						Usucodigo,
						AGTPfalta,
						AGTPipregistro,
						AGTPestadp,
						AGTPecodigo, 
						FOcodigo,
						FDcodigo,
						FCFid,
						FACcodigo,
						FACid,
						AGTPfechaprog)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">,<!----- Ecodigo--->
						3,<!----- IDtrans--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNumDoc#">, <!----- AGTPdocumento--->
						<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#Arguments.AGTPdescripcion#">,<!----- AGTPdescripcion--->
						#rsPeriodo.value#,<!----- AGTPperiodo--->
						#rsMes.value#,<!----- AGTPmes--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#">,<!----- Usucodigo--->
						<cf_dbfunction name="now">,<!----- AGTPfalta--->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ipregistro#">,<!----- AGTPipregistro--->
						<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq 1)>1<cfelse>0</cfif>,<!----- AGTPestadp--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">,<!----- AGTPecodigo--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FOcodigo#" null="#not Arguments.FOcodigo#">,<!----- FOcodigo--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FDcodigo#" null="#not Arguments.FDcodigo#">,<!----- FDcodigo--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCFid#" null="#not Arguments.FCFid#">,<!----- FCFid--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FACcodigo#" null="#not Arguments.FACcodigo#">,<!----- FACcodigo--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FACid#" null="#not Arguments.FACid#">,<!----- as FACid--->
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#"><!--- as AGTPfechaprog--->
						)
						<cf_dbidentity1 datasource="#arguments.conexion#">
				</cfquery>
				<cf_dbidentity2 datasource="#arguments.conexion#" name="idquery">
			
			<cfelse>
				<cfset idquery.identity = Arguments.AGTPid>
				<cfquery name="rstemp" datasource="#arguments.conexion#">
					update AGTProceso 
					  set AGTPestadp = 0 
					where AGTPid = #idquery.identity#
				</cfquery>				
			</cfif>

			<cfif not Arguments.Programar>
				
				<!---Inserta en ADTProceso--->
				<cfquery name="rsInsertaActivos" datasource="#arguments.conexion#">
					insert into ADTProceso
						(Ecodigo, AGTPid, Aid, IDtrans, CFid, TAfalta, 
						TAfechainidep, TAvalrescate, TAvutil, 
						TAfechainirev, TAperiodo, TAmes, 
						TAfecha, Usucodigo, TAmeses <!----- Cantidad de Meses a Revaluar, En realidad se calcula con base en la diferencia mese entre la ultima revaluacion y esta revaluacion--->
						
						,TAmontolocadq <!----- revaluacion del valor de adquisicion (TAmontolocadq)--->
						,TAmontooriadq <!----- revaluacion del valor de adquisicion (TAmontooriadq)--->
						,TAmontolocmej <!----- revaluacion del valor de mejoras (TAmontolocmej)--->
						,TAmontoorimej <!----- revaluacion del valor de mejoras (TAmontoorimej)--->
						,TAmontolocrev <!----- revaluacion del valor de revaluacion (TAmontolocrev)--->
						,TAmontoorirev <!----- revaluacion del valor de revaluacion (TAmontoorirev)--->
						
						,TAmontodepadq
						,TAmontodepmej
						,TAmontodeprev

						,TAvaladq
						,TAvalmej
						,TAvalrev
						
						,TAdepacumadq
						,TAdepacummej
						,TAdepacumrev
							
						,TAsuperavit <!----- revaluacion - revaluacion de la depreciacion--->
						
						,AFIindice
						
						,Mcodigo,TAtipocambio
						)
					select
						Ecodigo, #idquery.identity#, Aid, IDtrans, CFid, TAfalta, 
						TAfechainidep, TAvalrescate, TAvutil, 
						TAfechainirev, TAperiodo, TAmes, 
						TAfecha, Usucodigo, TAmeses <!----- Cantidad de Meses a Revaluar, En realidad se calcula con base en la diferencia mese entre la ultima revaluacion y esta revaluacion--->
						
						,TAmontolocadq <!----- revaluacion del valor de adquisicion (TAmontolocadq)--->
						,0.00 <!----- revaluacion del valor de adquisicion (TAmontooriadq)--->
						,TAmontolocmej <!----- revaluacion del valor de mejoras (TAmontolocmej)--->
						,0.00 <!----- revaluacion del valor de mejoras (TAmontoorimej)--->
						,TAmontolocrev <!----- revaluacion del valor de revaluacion (TAmontolocrev)--->
						,0.00 <!----- revaluacion del valor de revaluacion (TAmontoorirev)--->
						
						,TAmontodepadq
						,TAmontodepmej
						,TAmontodeprev

						,TAvaladq
						,TAvalmej
						,TAvalrev
						
						,TAdepacumadq
						,TAdepacummej
						,TAdepacumrev
							
						,TAsuperavit <!----- revaluacion - revaluacion de la depreciacion--->
						
						,AFIindice
						
						,#rsMoneda.value#
						,1
					from #ACTIVOS#
				</cfquery>
			</cfif>
			<cfif Arguments.debug>
				<cfquery name="rsAGTP" datasource="#arguments.conexion#">
					select * from AGTProceso where AGTPid = #idquery.identity#
				</cfquery>
				<cfquery name="rsADTP" datasource="#arguments.conexion#">
					select AFIindice, TAvaladq, TAvalmej, TAvalrev, TAmontolocadq, TAmontolocmej, TAmontolocrev, TAdepacumadq, TAdepacummej, TAdepacumrev,  TAmontodepadq, TAmontodepmej, TAmontodeprev, TAsuperavit from ADTProceso where AGTPid = #idquery.identity#
				</cfquery>
				<cfdump var="#rsAGTP#">
				<cfdump var="#rsADTP#">
				<cftransaction action="rollback"/>
				<cf_abort errorInterfaz="">
			<cfelse>
				<cftransaction action="commit"/>
			</cfif>
		
		</cftransaction><!---Fin Cálculo de la Revaluación--->
		
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn #idquery.identity#>
	</cffunction>
<!---*********************************************************************************
 SEGUNDO PROCESO DE REVALUACION
   *  Toma de Saldos
          o Se tomaran los saldos del periodo Anterior
          o En caso de ser un Activo producto de una segregación, se tomaran los montos del Traslado.
    * Se tomara en cuenta del Periodo Actual
          o Segregaciones o traslados parciales
          o Retiros Parciales
          o Reevaluaciones
    * Cambio de Configuración
          o Ver parámetro "Considerar traslados, retiros y Revaluaciónes del último periodo en la Revaluación" 
		     en administración del sistema - Parámetros Adicionales.
jmadrigal-06/10/2009-Solicitado por el ICE
*********************************************************************************--->
	<cffunction name="AF_RevaluacionActivos_second" access="public" returntype="numeric" output="true">
		<cfargument name="AGTPid" 			type="numeric" required="no"	default="0">
		<cfargument name="Ecodigo" 			type="numeric" required="no"	default="0">
		<cfargument name="Usucodigo" 		type="numeric" required="no"	default="0">
		<cfargument name="IPregistro" 		type="string"  required="no"	default="">
		<cfargument name="Conexion" 		type="string"  required="no"	default="">
		<cfargument name="AGTPdescripcion" 	type="string"  required="no"	default="Revaluación">
		<cfargument name="FOcodigo" 		type="numeric" required="no"	default="0">
		<cfargument name="FDcodigo"  		type="numeric" required="no"	default="0">
		<cfargument name="FCFid" 	 		type="numeric" required="no"	default="0">
		<cfargument name="FACcodigo" 		type="numeric" required="no"	default="0">
		<cfargument name="FACid" 			type="numeric" required="no"	default="0">
		<cfargument name="FAFCcodigo" 		type="numeric" required="no"	default="0">
		<cfargument name="debug" 			type="boolean" required="no"	default="false">
		<cfargument name="Periodo" 			type="numeric" required="no"	default="0">
		<cfargument name="Mes" 				type="numeric" required="no"	default="0">
		<cfargument name="Programar" 		type="boolean" required="no"	default="false">
		<cfargument name="FechaProgramacion"type="date"    required="no"	default="#CreateDate(1900,01,01)#">
<!---===================================<<    PASO 1    >>================================--->
<!---===============Valida Fecha de Programación Vrs Programar============================--->
		<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq -1)>
			<cfset Arguments.Programar = false>
		</cfif>
<!---===================================<<    PASO 2    >>================================--->	
<!---=====Obtener Empresa-Coneccion-Usuario-IP y Moneda===================================--->
<!---=====Obtener el parametro 900: Diferencia de Meses de Saldos para Reevaluación=======--->
		<cfif Arguments.AGTPid is 0>
			<cfset Arguments.Ecodigo 	= session.Ecodigo>
			<cfset Arguments.Conexion 	= session.dsn>
			<cfset Arguments.Usucodigo 	= session.Usucodigo>
			<cfset Arguments.IPregistro = session.sitio.ip>
		</cfif>
		<cfquery name="rsMoneda" datasource="#arguments.conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif len(trim(rsMoneda.value)) eq 0>
		       <cf_errorCode code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!">
		</cfif>
		<cfquery name="rsMesesDiferenciaFromAuxiliares" datasource="#Arguments.conexion#">
			 select Pvalor 
			    from Parametros 
			  where Pcodigo = 900 
			   and Ecodigo = #arguments.Ecodigo#
		</cfquery>
<!---===================================<<    PASO 3    >>================================--->
<!---=========Crea FechaAux, periodo - mes Auxiliar=======================================--->
<!---=========Crea el Periodo / Mes de la toma de saldos==================================--->
<!---=========Crea Fecha para empezaran a considerar las transacciones de Activos "Padres"--->
		<cfif Arguments.Mes neq 0>
			<cfset MesAuxiliar = Arguments.Mes>
		<cfelse>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" returnvariable="MesAuxiliar" Conexion="#arguments.conexion#" Ecodigo="#Arguments.Ecodigo#"/>
		</cfif>
		<cfif Arguments.Periodo neq 0>
			<cfset PeriodoAuxiliar = Arguments.Periodo>
		<cfelse>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="PeriodoAuxiliar" Conexion="#arguments.conexion#" Ecodigo="#Arguments.Ecodigo#"/>
		</cfif>
		
		<cfset FechaAux = CreateDate(fnIsNull(PeriodoAuxiliar,01), fnIsNull(MesAuxiliar,01), 01)>
		<cfset FechaAux = DateAdd("m", 1,FechaAux)>
		<cfset FechaAux = DateAdd("d",-1,FechaAux)>

		<cfscript>
		   //Periodo/mes de la toma de saldos
			if (rsMesesDiferenciaFromAuxiliares.recordcount gt 0 and len(trim(rsMesesDiferenciaFromAuxiliares.Pvalor)) gt 0) {
				Intvar_PeriodoSaldos = PeriodoAuxiliar - (abs(rsMesesDiferenciaFromAuxiliares.Pvalor) \ 12);
				Intvar_MesSaldos = MesAuxiliar - (abs(rsMesesDiferenciaFromAuxiliares.Pvalor) mod 12);
			} else {
				if (MesAuxiliar gt 1){
					Intvar_PeriodoSaldos = PeriodoAuxiliar;
					Intvar_MesSaldos = MesAuxiliar-1;
				} else {
					Intvar_PeriodoSaldos = PeriodoAuxiliar-1;
					Intvar_MesSaldos = 12;
				}
			}
			//Periodo/Mes de la toma de transacciones
				if (Intvar_MesSaldos EQ 12)
				{
					PeriodoInicioTran = Intvar_PeriodoSaldos +1;
					MesInicioTran = 1;
				}
				else
				{
					PeriodoInicioTran = Intvar_PeriodoSaldos;
					MesInicioTran 	  = Intvar_MesSaldos +1;
				}
				
		</cfscript>
		<cfif Arguments.debug>
			REEVALUACION EJECUTANDOSE EN MODO DEBUG...<P>
			DIREFENCIA DE MESES PARA REVALUAR:   #rsMesesDiferenciaFromAuxiliares.Pvalor#<P>
			PERIODO AUXILIAR:  #PeriodoAuxiliar# <P>
			MES AUXILIAR: 	#MesAuxiliar# <P>
			PERIODO TOMA DE SALDOS : #Intvar_PeriodoSaldos# <P>
			MES TOMA DE SALDOS:    #Intvar_MesSaldos#<P>
			PERIODO PARA INICIO DE TOMA DE TRANSACCIONES  #PeriodoInicioTran#<P>
			MES PARA EL INICIO DE TOMA DE TRANSACCIONES   #MesInicioTran#<P>
		</cfif>
<cfif not Arguments.Programar>
	<!---===================================<<    PASO 4    >>================================--->
	<!---===========Prepara los filtros antes de la consulta para hacerla mas clara===========--->
			<cfset filtro="">
			<cfif Arguments.FCFid>
				<cfset filtro = filtro & " and a.CFid = " & Arguments.FCFid>
			</cfif>					
			<cfif Arguments.FACcodigo>
				<cfset filtro = filtro & " and b.ACcodigo = " & Arguments.FACcodigo>
			</cfif>					
			<cfif Arguments.FACid>
				<cfset filtro = filtro & " and b.ACid = " & Arguments.FACid>
			</cfif>					
			<cfif Arguments.FAFCcodigo>
				<cfset filtro = filtro & " and b.AFCcodigo = " & Arguments.FAFCcodigo>
			</cfif>																																														
			<cfif Arguments.FOcodigo>						
				<cfset filtro = filtro & " and cf.Ocodigo = " & Arguments.FOcodigo>
			</cfif>
			<cfif Arguments.FDcodigo>						
				<cfset filtro = filtro & " and cf.Dcodigo = " & Arguments.FDcodigo>
			</cfif>
	<!---===================================<<    PASO 5    >>================================--->
	<!---==============Crea Tabla temporal de las transacciones de Revaluacion================--->
			<cf_dbtemp name="AFTempRevaSecond_v3" returnvariable="ACTIVOS" datasource="#Arguments.conexion#">
			    <!---Estos datos se obtienen del periodo Mes Auxiliar-------------->
				<cf_dbtempcol name="Ecodigo"  		type="numeric"  mandatory="yes">
				<cf_dbtempcol name="AGTPid"  		type="numeric"  mandatory="yes">
				<cf_dbtempcol name="Aid"  			type="numeric"  mandatory="yes">
				<cf_dbtempcol name="Aplaca"  		type="char(20)" mandatory="yes">
				<cf_dbtempcol name="IDtrans"  		type="int"    	mandatory="yes">
				<cf_dbtempcol name="CFid"  			type="numeric" 	mandatory="yes">
				<cf_dbtempcol name="TAfalta"  		type="datetime" mandatory="yes">
				<cf_dbtempcol name="TAfechainidep"  type="datetime" mandatory="yes">
				<cf_dbtempcol name="TAvalrescate"  	type="money" 	mandatory="yes">
				<cf_dbtempcol name="TAvutil"  		type="int"  	mandatory="yes">
				<cf_dbtempcol name="TAfechainirev" 	type="datetime"	mandatory="yes">
				<cf_dbtempcol name="TAperiodo"     	type="int"      mandatory="yes">
				<cf_dbtempcol name="TAmes" 			type="int"    	mandatory="yes">
				<cf_dbtempcol name="TAfecha" 		type="datetime" mandatory="yes">
				<cf_dbtempcol name="Usucodigo" 		type="numeric"  mandatory="yes">
				<cf_dbtempcol name="AFIindice"  	type="float"    mandatory="yes">
				<cf_dbtempcol name="TAmeses"  		type="int"		mandatory="yes">
			    <!---Estos Datos se obtienen del Periodo mes de la toma de saldos--->
			
				<cf_dbtempcol name="TAvaladq"  		type="money"    mandatory="no">
				<cf_dbtempcol name="TAvalmej"  		type="money"    mandatory="no">
				<cf_dbtempcol name="TAvalrev"  		type="money"    mandatory="no">
				<cf_dbtempcol name="TAdepacumadq"  	type="money"    mandatory="no">
				<cf_dbtempcol name="TAdepacummej"  	type="money"    mandatory="no">
				<cf_dbtempcol name="TAdepacumrev"  	type="money"    mandatory="no">
				
				<cf_dbtempcol name="FechaInicioTran"  type="datetime" mandatory="no">
				<cf_dbtempcol name="PeriodoInicioTran"type="int" 	  mandatory="no">
				<cf_dbtempcol name="MesInicioTran"    type="int" 	  mandatory="no">
				
				<cf_dbtempcol name="TAmontolocadq"  type="money"    mandatory="no">
				<cf_dbtempcol name="TAmontolocmej"  type="money"    mandatory="no">
				<cf_dbtempcol name="TAmontolocrev"  type="money"    mandatory="no">
				<cf_dbtempcol name="TAmontodepadq"  type="money"    mandatory="no">
				<cf_dbtempcol name="TAmontodepmej"  type="money"    mandatory="no">
				<cf_dbtempcol name="TAmontodeprev"  type="money"    mandatory="no">
				
				<cf_dbtempcol name="TAsuperavit"  	type="money"    mandatory="no">
				
				<cf_dbtempkey cols="Aid">
			</cf_dbtemp>
	<!---===================================<<    PASO 6    >>================================--->
	<!---Obtencion de Activos a revaluar mediante excepciones de los indices de revaluacion-==--->
	<!---Deben ser Activos en estado Activo===================================================--->
	<!---La categoria-Clase del periodo/mes Auxiliar debe ser una Categoria Revaluable========--->
	<!---La Fecha-inicio-Revaluacion debe ser mayor que el Ultimo dia del Periodo-mes Auxiliar--->
	<!---Debe Existir Excepcion del indice para la Categoria/Clase/periodo Aux/mes Aux/Oficina--->
	<!---Debe tener valor en libros mayor a cero==============================================--->
	<!---VAL EN LIBROS: ADQUI+MEJORA+REVALUACION-DEP ADQUI-DEP MEJORA-DEP REVALUA-VAL RESCATE---->
	<!---El Saldo de VU debe ser mayor a cero, No aplica para los Activos no depreciables====---->
	<!---TAmeses= Meses a Revaluar = Periodo/Mes ultima Revaluacion - Perido/Mes Auxiliar====---->
	<cfquery datasource="#arguments.conexion#" name="ActExep">
		insert into #ACTIVOS#(
			Ecodigo, 		AGTPid, 		Aid, 	Aplaca,	
			IDtrans, 		CFid, 			TAfalta, 
			TAfechainidep, 	TAvalrescate, 	TAvutil, 
			TAfechainirev, 	TAperiodo, 		TAmes, 
			TAfecha, 		Usucodigo,		AFIindice,
			TAmeses
			)
		select
			a.Ecodigo, 			-1, 					a.Aid,	b.Aplaca,
			3, 					a.CFid, 				<cf_dbfunction name="now"> , 
			b.Afechainidep, 	b.Avalrescate,  		a.AFSvutiladq, 
			b.Afechainirev, 	#PeriodoAuxiliar#, 		#MesAuxiliar#, 
			#FechaAux#,			#Arguments.usucodigo#,	e.AFIindice,
			(#PeriodoAuxiliar# - a.AFSperiodourev)*12 + (#MesAuxiliar# - a.AFSmesurev)
			
		from AFSaldos a
		  inner join Activos b 
			 on b.Aid = a.Aid
		  inner join AFIndicesExc e				
			 on e.ACcodigo 	 = a.ACcodigo
			and e.ACid 		 = a.ACid
			and e.AFIperiodo = a.AFSperiodo
			and e.AFImes     = a.AFSmes
			and e.Ecodigo 	 = a.Ecodigo
			and e.Ocodigo    = a.Ocodigo
		<cfif Arguments.FOcodigo or Arguments.FDcodigo>
		   inner join CFuncional cf
			 on cf.Ecodigo = a.Ecodigo
			and cf.CFid = a.CFid
		 </cfif> 	
		where a.Ecodigo      = #Arguments.Ecodigo#
		  and a.AFSperiodo   = #PeriodoAuxiliar#
		  and a.AFSmes       = #MesAuxiliar#
		  and a.AFSrevalua   = 1		
		  and <cf_dbfunction name="to_date00" args="b.Afechainirev"> <= #FechaAux#	 
		  and b.Astatus = 0 
		  and (a.AFSvaladq + a.AFSvalmej + a.AFSvalrev - a.AFSdepacumadq + a.AFSdepacummej + a.AFSdepacumrev - b.Avalrescate) > 0
		  and (AFSsaldovutiladq > 0 or AFSdepreciable <> 1)
		#filtro#
	</cfquery>
	<!---===================================<<    PASO 7    >>================================--->
	<!---Obtencion de Activos a revaluar mediante los indices de revaluacion==================--->
	<!---Deben ser Activos en estado Activo===================================================--->
	<!---La categoria-Clase del periodo/mes Auxiliar debe ser una Categoria Revaluable========--->
	<!---La Fecha-inicio-Revaluacion debe ser mayor que el Ultimo dia del Periodo-mes Auxiliar--->
	<!---Debe Existir Excepcion del indice para la Categoria/Clase/periodo Aux/mes Aux/Oficina--->
	<!---Debe tener valor en libros mayor a cero==============================================--->
	<!---VAL EN LIBROS: ADQUI+MEJORA+REVALUACION-DEP ADQUI-DEP MEJORA-DEP REVALUA-VAL RESCATE---->
	<!---El Saldo de VU debe ser mayor a cero, No aplica para los Activos no depreciables====---->
	<!---TAmeses= Meses a Revaluar = Periodo/Mes ultima Revaluacion - Perido/Mes Auxiliar====---->
	<cfquery datasource="#arguments.conexion#">
		insert into #ACTIVOS#(
			Ecodigo, 		AGTPid, 		Aid,	Aplaca,	
			IDtrans, 		CFid, 			TAfalta, 
			TAfechainidep, 	TAvalrescate, 	TAvutil, 
			TAfechainirev, 	TAperiodo, 		TAmes, 
			TAfecha, 		Usucodigo,		AFIindice,
			TAmeses
			)
		select
			a.Ecodigo, 			-1, 					a.Aid,	b.Aplaca,
			3, 					a.CFid, 				<cf_dbfunction name="now"> , 
			b.Afechainidep, 	b.Avalrescate,  		a.AFSvutiladq, 
			b.Afechainirev, 	#PeriodoAuxiliar#, 		#MesAuxiliar#, 
			#FechaAux#,			#Arguments.usucodigo#,	e.AFIindice,
			(#PeriodoAuxiliar# - a.AFSperiodourev)*12 + (#MesAuxiliar# - a.AFSmesurev)
			
		from AFSaldos a
		  inner join Activos b 
			 on b.Aid = a.Aid
		  inner join AFIndices e				
			 on e.Ecodigo 	 = a.Ecodigo
			and e.ACid 		 = a.ACid
			and e.ACcodigo 	 = a.ACcodigo
			and e.AFIperiodo = a.AFSperiodo
			and e.AFImes     = a.AFSmes
		<cfif Arguments.FOcodigo or Arguments.FDcodigo>
		   inner join CFuncional cf
			 on cf.Ecodigo = a.Ecodigo
			and cf.CFid = a.CFid
		 </cfif> 	
		where a.Ecodigo      = #Arguments.Ecodigo#
		  and a.AFSperiodo   = #PeriodoAuxiliar#
		  and a.AFSmes       = #MesAuxiliar#
		  and a.AFSrevalua   = 1		
		  and <cf_dbfunction name="to_date00" args="b.Afechainirev"> <= #FechaAux#	 
		  and b.Astatus = 0 
		  and (a.AFSvaladq + a.AFSvalmej + a.AFSvalrev - a.AFSdepacumadq + a.AFSdepacummej + a.AFSdepacumrev - b.Avalrescate) > 0 
		  and (AFSsaldovutiladq > 0 or AFSdepreciable <> 1)
		  #filtro#
		  and not exists(select 1
						  from #ACTIVOS# aa
						 where aa.Aid = a.Aid
						   and aa.IDtrans = 3)
	</cfquery>
	<!---===================================<<    PASO 8    >>================================--->
	<!---Borrar los Activos ya Revaluados para este Periodo / Mes Auxiliar====================--->
	<cfquery datasource="#arguments.conexion#">
		delete from #ACTIVOS#
		 where exists (select 1
						 from TransaccionesActivos b 
					   where b.Aid       = #ACTIVOS#.Aid
						 and b.IDtrans   = 3   
						 and b.Ecodigo   = #ACTIVOS#.Ecodigo 
						 and b.TAperiodo = #PeriodoAuxiliar#
						 and b.TAmes 	 = #MesAuxiliar#)
	</cfquery>
	<!---===================================<<    PASO 9    >>================================--->
	<!---Borrar los Activos que tienen transacciones de revaluacion pendiente de Aplicar======--->
	<cfquery datasource="#arguments.conexion#">
		delete from #ACTIVOS#
			where exists (select 1
							from ADTProceso b 
						  where b.Ecodigo =   #ACTIVOS#.Ecodigo 
							and b.Aid 	  =   #ACTIVOS#.Aid 
							and b.TAperiodo = #PeriodoAuxiliar#
							and b.TAmes 	= #MesAuxiliar#
							and b.IDtrans   = 3   
			   )
	</cfquery>
	<!---===================================<<    PASO 10    >>================================--->
	<!---Verifica si hay Activos a revaluar, si no hay termina el proceso======================--->
	<cfquery name="rsVerificaCantidad" datasource="#arguments.conexion#">
		select count(1) as Cantidad from #ACTIVOS#
	</cfquery>
	<cfif rsVerificaCantidad.Cantidad LT 1>
		<cf_errorCode	code = "50945" msg = "NO existen Activos a considerar según los parametros indicados!">
	</cfif>
	<!---===================================<<    PASO 11    >>================================--->
	<!---Verifica si hay los Activos tienen transacciones pendiente de aplicar=================--->
	<cfset LvarMensajeError = "">
	<cfquery name="rsRevisaPendMejoras" datasource="#Arguments.Conexion#">
		Select count(1) as Cantidad
		from #ACTIVOS# a						
		where a.Ecodigo = #Arguments.Ecodigo#
		  and a.AGTPid  = -1
		  and exists(Select 1
					 from ADTProceso c
					 where c.Aid 		= a.Aid
					   and c.Ecodigo 	= a.Ecodigo
					   and c.IDtrans 	= 2
					   and c.TAperiodo 	= #PeriodoAuxiliar#
					   and c.TAmes 		= #MesAuxiliar#)
	</cfquery>  
	<cfif rsRevisaPendMejoras.Cantidad gt 0>
		<cfif LvarMensajeError NEQ "">
			<cfset LvarMensajeError & "<br>">
		</cfif>
		<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Mejora pendiente de aplicar!">
	</cfif>
	<cfquery name="rsRevisaPendDepreciacion" datasource="#Arguments.Conexion#">
		Select count(1) as Cantidad
		from #ACTIVOS# a						
		where a.Ecodigo = #Arguments.Ecodigo#
		  and a.AGTPid  = -1
		  and exists(Select 1
					 from ADTProceso c
					 where c.Aid 		= a.Aid
					   and c.Ecodigo 	= a.Ecodigo
					   and c.IDtrans 	= 4
					   and c.TAperiodo 	= #PeriodoAuxiliar#
					   and c.TAmes		= #MesAuxiliar#)
	</cfquery>  
	<cfif rsRevisaPendDepreciacion.Cantidad gt 0>
		<cfif LvarMensajeError NEQ "">
			<cfset LvarMensajeError & "<br>">
		</cfif>
		<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Depreciacion pendiente de aplicar!">
	</cfif>
	<cfquery name="rsRevisaPendRetiros" datasource="#Arguments.Conexion#">
		Select count(1) as Cantidad
		from #ACTIVOS# a						
		where a.Ecodigo = #Arguments.Ecodigo#
		  and a.AGTPid  = -1
		  and exists(Select 1
					 from ADTProceso c
					 where c.Aid 		= a.Aid
					   and c.Ecodigo 	= a.Ecodigo
					   and c.IDtrans 	= 5
					   and c.TAperiodo 	= #PeriodoAuxiliar#
					   and c.TAmes 		= #MesAuxiliar#)							   
	</cfquery>  								
	<cfif rsRevisaPendRetiros.Cantidad gt 0>
		<cfif LvarMensajeError NEQ "">
			<cfset LvarMensajeError & "<br>">
		</cfif>
		<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Retiro pendiente de aplicar!">
	</cfif>					
	<cfquery name="rsRevisaPendTraslado" datasource="#Arguments.Conexion#">
		Select count(1) as Cantidad
		from #ACTIVOS# a						
		where a.Ecodigo = #Arguments.Ecodigo#
		  and a.AGTPid  = -1
		  and exists(Select 1
					 from ADTProceso c
					 where c.Aid 		= a.Aid
					   and c.Ecodigo 	= a.Ecodigo
					   and c.IDtrans 	= 8
					   and c.TAperiodo 	= #PeriodoAuxiliar#
					   and c.TAmes 		= #MesAuxiliar#)							   
	</cfquery> 
	<cfif rsRevisaPendTraslado.Cantidad gt 0>
		<cfif LvarMensajeError NEQ "">
			<cfset LvarMensajeError & "<br>">
		</cfif>
		<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Traslado pendiente de aplicar!">
	</cfif>	 								
	<cfquery name="rsRevisaPendCambioC" datasource="#Arguments.Conexion#">
		Select count(1) as Cantidad
		from #ACTIVOS# a						
		where a.Ecodigo = #Arguments.Ecodigo#
		  and a.AGTPid  = -1
		  and exists(Select 1
					 from ADTProceso c
					 where c.Aid 		= a.Aid
					   and c.Ecodigo 	= a.Ecodigo
					   and c.IDtrans 	= 6
					   and c.TAperiodo 	= #PeriodoAuxiliar#
					   and c.TAmes 		= #MesAuxiliar# )							   
	</cfquery>  								
	<cfif rsRevisaPendCambioC.Cantidad gt 0>
		<cfif LvarMensajeError NEQ "">
			<cfset LvarMensajeError & "<br>">
		</cfif>
		<cfset LvarMensajeError = LvarMensajeError & "Existen Activos en una transaccion de Cambio de Categoria-Clase pendiente de aplicar!">
	</cfif>				
	<cfif LvarMensajeError NEQ "">
		<cfthrow message="#LvarMensajeError#">
	</cfif>	
	<!---===================================<<    PASO 1   >>================================--->
	<!---Obtienen los saldos para Activos =====================================================--->
	<cfquery name="PreActSaldoP" datasource="#Arguments.Conexion#">
		select afs.Aid,
		         #PeriodoInicioTran# PeriodoInicioTran, 
				 #MesInicioTran# MesInicioTran,
				 <cf_jdbcquery_param cfsqltype="cf_sql_date" value="null"> FechaInicioTran,
				 afs.AFSvaladq valAdq,afs.AFSvalmej valMej,afs.AFSvalrev valRev,afs.AFSdepacumadq depAdq,afs.AFSdepacummej depMej,afs.AFSdepacumrev depRev 
		  from AFSaldos afs
		  	inner join #ACTIVOS# act
				on afs.Aid = act.Aid
		where afs.AFSperiodo = #Intvar_PeriodoSaldos#
		  and afs.AFSmes     = #Intvar_MesSaldos#
		  
		  union all
		  
		 select Act.Aid,
		       <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> PeriodoInicioTran, 
			   <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> MesInicioTran,
			   ta.TAfalta FechaInicioTran, ta.TAmontolocadq valAdq, ta.TAmontolocmej valMej, ta.TAmontolocrev valRev, ta.TAdepacumadq depAdq, ta.TAdepacummej depMej,ta.TAdepacumrev depRev
		 from #ACTIVOS# TempAct
		 	inner join  Activos Act
				on TempAct.Aid  = Act.Aid
			inner join TransaccionesActivos ta
				on ta.Aplacadestino = Act.Aplaca
	     where ta.IDtrans = 8
		 and not exists (select 1 from AFSaldos afs where Act.Aid = afs.Aid and afs.AFSperiodo = #Intvar_PeriodoSaldos# and  afs.AFSmes = #Intvar_MesSaldos#)
		 and ta.TAid = (select min(TAid) from TransaccionesActivos where Aplacadestino = Act.Aplaca and IDtrans = 8)
	</cfquery>	
	<cfloop query="PreActSaldoP">
		<cfquery datasource="#Arguments.Conexion#">	
			update #ACTIVOS#
			set TAvaladq 			= #PreActSaldoP.valAdq#,
			    TAvalmej 			= #PreActSaldoP.valMej#,
				TAvalrev 			= #PreActSaldoP.valRev#,
			    TAdepacumadq		= #PreActSaldoP.depAdq#,
			    TAdepacummej 		= #PreActSaldoP.depMej#,
			    TAdepacumrev 		= #PreActSaldoP.depRev#
			<cfif LEN(TRIM(PreActSaldoP.PeriodoInicioTran)) NEQ 0>
				,PeriodoInicioTran 	= #PreActSaldoP.PeriodoInicioTran#
			</cfif>
			<cfif LEN(TRIM(PreActSaldoP.MesInicioTran)) NEQ 0> 
				,MesInicioTran 		= #PreActSaldoP.MesInicioTran#
			</cfif>
			<cfif LEN(TRIM(PreActSaldoP.FechaInicioTran)) NEQ 0>
				,FechaInicioTran 	= '#PreActSaldoP.FechaInicioTran#'
			</cfif>
			where Aid = #PreActSaldoP.Aid#
		</cfquery>
	</cfloop>
	<!---===================INICIO DEBUG=================--->
	<cfif Arguments.debug>
		<cfquery datasource="#Arguments.Conexion#" name="debugmonto">	
			select Aplaca PLACA, TAvaladq ADQUISICION,TAvalmej MEJORA,TAvalrev REVALUACION,TAdepacumadq DEP_ADQUISICION,TAdepacummej DEP_MEJORA,TAdepacumrev DEP_REVALUACION 
			from #ACTIVOS#
		</cfquery>	
		SALDOS A HACE UN AÑO PARA ACTIVOS PADRES O MONTO DE TRASLADO PARA ACTIVOS HIJOS...<BR>
		<cfdump var="#debugmonto#"><p>
	</cfif>
	<!---===================FIN DEBUG=================--->
	<cfquery name="Incosistencias" datasource="#session.DSN#">
		select Aplaca
		 from #ACTIVOS# where 
		  TAvaladq is null and
		  TAvalmej is null and
		  TAvalrev is null and
		  TAdepacumadq is null and
		  TAdepacummej is null and
		  TAdepacumrev is null
	</cfquery>
	<cfif Incosistencias.recordcount GT 0>
		<cfset placas="">
		<cfloop query="Incosistencias">
			<cfset placas= #placas# & #Incosistencias.Aplaca#&",">
		</cfloop>
		<cfthrow message="Los siguientes Activos tienen fecha de inicio de Reevaluación Inconsistente: #LEFT(placas,LEN(placas)-1)#">
	</cfif>
	<!---===================================<<    PASO 13    >>===============================================--->
	<!---Calcula los montos de transacciones de retiro,traslado desde  FechaInicioTran a hoy==================--->
	<!---Se Restan las transacciones y se restan a cada unos de los montos de costo y depreciacion=============--->
	<cfquery name="updMonto" datasource="#Arguments.Conexion#">
		select  act.Aplaca,
				act.Aid, 
				sum(ta.TAmontolocadq) valAdq,
				sum(ta.TAmontolocmej) valMej, 
				sum(ta.TAmontolocrev) valRev,
				sum(ta.TAmontodepadq) depAdq,
				sum(ta.TAmontodepmej) depMej,
				sum(ta.TAmontodeprev) depRev 
			
			from #ACTIVOS# act
				inner join TransaccionesActivos ta
					on  ta.Aid = act.Aid
					and ta.IDtrans in (5,8)<!---Retiro, Dar traslado--->
			where 
			<!---Activos Hijos con fechas mayores o padres--->
			(ta.TAfalta > act.FechaInicioTran or act.FechaInicioTran is null) 
			 <!---Activos padres con perido mayor o Activos padre con periodo igual y mes igual o mayor o Activos hijos--->
			   and (
			         (ta.TAperiodo > act.PeriodoInicioTran or
					   ta.TAperiodo = act.PeriodoInicioTran  and  ta.TAmes >=  act.MesInicioTran 
					 )
					   or 
					   (act.PeriodoInicioTran is null and act.MesInicioTran is null)
					 )
		group by Aplaca,act.Aid
	</cfquery>
	<cfloop query="updMonto">
		<cfquery datasource="#Arguments.Conexion#">	
			update #ACTIVOS#
			set TAvaladq 		= TAvaladq     - #updMonto.valAdq#,
			    TAvalmej 		= TAvalmej     - #updMonto.valMej#,
				TAvalrev 		= TAvalrev 	   - #updMonto.valRev#,
			    TAdepacumadq	= TAdepacumadq - #updMonto.depAdq#,
			    TAdepacummej 	= TAdepacummej - #updMonto.depMej#,
			    TAdepacumrev 	= TAdepacumrev - #updMonto.depRev#
			where Aid = #updMonto.Aid#
		</cfquery>
	</cfloop>
	<!---===================INICIO DEBUG=================--->
	<cfif Arguments.debug>
		MONTOS A RESTAR POR CONCEPTO DE RETIROS Y TRASLADOS REALIZADOS<br>
		<cfdump var="#updMonto#"><p>
		 
		<cfquery datasource="#Arguments.Conexion#" name="debugmonto2">	
			select Aplaca PLACA, TAvaladq ADQUISICION,TAvalmej MEJORA,TAvalrev REVALUACION,TAdepacumadq DEP_ADQUISICION,TAdepacummej DEP_MEJORA,TAdepacumrev DEP_REVALUACION 
			from #ACTIVOS#
		</cfquery>	
		SALDOS DE LOS ACTIVOS DEPUES DE APLICAR LOS RETIROS Y TRASLADOS...<BR>
		<cfdump var="#debugmonto2#"><p>
	</cfif>
	<!---Calcula los montos de transacciones de Reevaluacion desde  FechaInicioTran a hoy======================================--->
	<!---Se suman las transacciones de los costos y se suman al  TAvalrev y se suman las depreciaciones y suman al TAdepacumrev--->
	<cfquery name="updMonto" datasource="#Arguments.Conexion#">
		select  act.Aplaca,
				act.Aid, 
				sum(ta.TAmontolocadq) valAdq,
				sum(ta.TAmontolocmej) valMej, 
				sum(ta.TAmontolocrev) valRev,
				sum(ta.TAmontodepadq) depAdq,
				sum(ta.TAmontodepmej) depMej,
				sum(ta.TAmontodeprev) depRev 
			
			from #ACTIVOS# act
				inner join TransaccionesActivos ta
					on  ta.Aid = act.Aid
					and ta.IDtrans in (3)<!---Revaluacion--->
			where 
			<!---Activos Hijos con fechas mayores o padres--->
			(ta.TAfalta > act.FechaInicioTran or act.FechaInicioTran is null) 
			 <!---Activos padres con perido mayor o Activos padre con periodo igual y mes igual o mayor o Activos hijos--->
			   and (
			         (ta.TAperiodo > act.PeriodoInicioTran or
					   ta.TAperiodo = act.PeriodoInicioTran  and  ta.TAmes >=  act.MesInicioTran 
					 )
					   or 
					   (act.PeriodoInicioTran is null and act.MesInicioTran is null)
					 )		
		group by act.Aplaca,act.Aid
	</cfquery>
	<cfloop query="updMonto">
		<cfquery datasource="#Arguments.Conexion#">	
			update #ACTIVOS#
			set TAvalrev 		= TAvalrev 	   + #updMonto.valAdq# + #updMonto.valMej# + #updMonto.valRev#,
			    TAdepacumrev 	= TAdepacumrev + #updMonto.depAdq# + #updMonto.depMej# + #updMonto.depRev#
			where Aid = #updMonto.Aid#
		</cfquery>
	</cfloop>
	<!---===================INICIO DEBUG=================--->
	<cfif Arguments.debug>
		MONTOS A SUMAR POR CONCEPTO DE REVALUACIONES<br>
		<cfdump var="#updMonto#"><p>
		 
		<cfquery datasource="#Arguments.Conexion#" name="debugmonto3">	
			select Aplaca PLACA, TAvaladq ADQUISICION,TAvalmej MEJORA,TAvalrev REVALUACION,TAdepacumadq DEP_ADQUISICION,TAdepacummej DEP_MEJORA,TAdepacumrev DEP_REVALUACION 
			from #ACTIVOS#
		</cfquery>	
		SALDOS DE LOS ACTIVOS DEPUES DE APLICAR LAS REVALUACIONES...<BR>
		<cfdump var="#debugmonto3#"><p>
	</cfif>
	<cfquery name="updMonto2" datasource="#Arguments.Conexion#">
		select act.Aid, sum(ta.TAmontolocadq) valAdq,sum(ta.TAmontolocmej) valMej, sum(ta.TAmontolocrev) valRev,sum(ta.TAmontodepadq) depAdq,sum(ta.TAmontodepmej) depMej,sum(ta.TAmontodeprev) depRev
			from #ACTIVOS# act
				inner join TransaccionesActivos ta
					on  ta.Aplacadestino = act.Aplaca
					and ta.IDtrans = 8 <!---Recibir traslado--->
			where 
			<!---Activos Hijos con fechas mayores o padres--->
			(ta.TAfalta > act.FechaInicioTran or act.FechaInicioTran is null) 
			 <!---Activos padres con perido mayor o Activos padre con periodo igual y mes igual o mayor o Activos hijos--->
			   and (
			         (ta.TAperiodo > act.PeriodoInicioTran or
					   ta.TAperiodo = act.PeriodoInicioTran  and  ta.TAmes >=  act.MesInicioTran 
					 )
					   or 
					   (act.PeriodoInicioTran is null and act.MesInicioTran is null)
					 )		
		group by act.Aid
	</cfquery>
	<cfloop query="updMonto2">
		<cfquery datasource="#Arguments.Conexion#">	
			update #ACTIVOS#
			set TAvaladq 		= TAvaladq     + #updMonto2.valAdq#,
			    TAvalmej 		= TAvalmej     + #updMonto2.valMej#,
				TAvalrev 		= TAvalrev 	   + #updMonto2.valRev#,
			    TAdepacumadq	= TAdepacumadq + #updMonto2.depAdq#,
			    TAdepacummej 	= TAdepacummej + #updMonto2.depMej#,
			    TAdepacumrev 	= TAdepacumrev + #updMonto2.depRev#
			where Aid = #updMonto2.Aid#
		</cfquery>
	</cfloop>
	<cfif Arguments.debug>
		MONTOS A SUMAR POR CONCEPTO DE TRASLADOR RECIBIDOS<br>
		<cfdump var="#updMonto#"><p>
		 
		<cfquery datasource="#Arguments.Conexion#" name="debugmonto3">	
			select Aplaca PLACA, TAvaladq ADQUISICION,TAvalmej MEJORA,TAvalrev REVALUACION,TAdepacumadq DEP_ADQUISICION,TAdepacummej DEP_MEJORA,TAdepacumrev DEP_REVALUACION 
			from #ACTIVOS#
		</cfquery>	
		SALDOS DE LOS ACTIVOS DEPUES DE APLICAR LOS TRASLADOS RECIBIDOS...<BR>
		<cfdump var="#debugmonto3#"><p>
	</cfif>
	<!---Este delete es temporal, todas aquellas transacciones que están con montos negativos generaran reevaluaciones negativas, 
         por lo que se excluirán de la reevaluación, el ICE las generara a mano, mientras se termina el desarrollo: 
	Problema: se segregan mejora hechas en este año y depreciaciones echas en este periodo
	Solución: se recreara el traslado con los montos de hace un año por medio del porcentaje del traslado
	--->
	<cfquery datasource="#Arguments.Conexion#">	
		delete from #ACTIVOS# 
		where TAvaladq     < 0 
		   or TAvalmej     < 0 
		   or TAvalrev     < 0 
		   or TAdepacumadq < 0 
		   or TAdepacummej < 0 
		   or TAdepacumrev < 0 
	</cfquery>
	<!---===================================<<    PASO 14    >>=============================================--->
	<!---Aplica el Indice de Realuacion======================================================================--->	
	<cfquery datasource="#Arguments.Conexion#">	
		update #ACTIVOS#
		  set TAmontolocadq = round(TAvaladq * AFIindice,2),
			  TAmontolocmej = round(TAvalmej * AFIindice,2), 
			  TAmontolocrev = round(TAvalrev * AFIindice,2), 

			  TAmontodepadq = round(TAdepacumadq * AFIindice,2),
			  TAmontodepmej = round(TAdepacummej * AFIindice,2),
			  TAmontodeprev = round(TAdepacumrev * AFIindice,2),
			  
			  TAsuperavit	= round(TAvaladq     * AFIindice,2) + round(TAvalmej     * AFIindice,2) + round(TAvalrev     * AFIindice,2)
					         -round(TAdepacumadq * AFIindice,2) - round(TAdepacummej * AFIindice,2) - round(TAdepacumrev * AFIindice,2)
	</cfquery>
</cfif>
	<cfif Arguments.debug>
			CON LA APLICACION DE LOS INDICES
			<cfquery datasource="#Arguments.Conexion#" name="ConIndices">	
				select * from #ACTIVOS#
			</cfquery>
			<cfdump var="#ConIndices#">
	</cfif>
	<!---===================================<<    PASO 15    >>================================--->
	<!---Inserta la transacciones de revaluacion pendiente de aplicar==========================--->
	<cftransaction>
		<cfif Arguments.AGTPid is 0>
			<cfinvoke component="sif.Componentes.OriRefNextVal" method="nextVal" returnvariable="LvarNumDoc" ORI="AFRE" REF="RE"/>
			<cfquery name="idquery" datasource="#arguments.conexion#">
				insert into AGTProceso
				(Ecodigo, 
					IDtrans, 
					AGTPdocumento, 
					AGTPdescripcion,
					AGTPperiodo, 
					AGTPmes, 
					Usucodigo,
					AGTPfalta,
					AGTPipregistro,
					AGTPestadp,
					AGTPecodigo, 
					FOcodigo,
					FDcodigo,
					FCFid,
					FACcodigo,
					FACid,
					AGTPfechaprog)
				values(
					#Arguments.ecodigo#,
					3,
					#LvarNumDoc#, 
					'#Arguments.AGTPdescripcion#',
					#PeriodoAuxiliar#,
					#MesAuxiliar#,
					#Arguments.usucodigo#,
					<cf_dbfunction name="now">,
					'#arguments.ipregistro#',
					<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq 1)>1<cfelse>0</cfif>,
					#arguments.ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FOcodigo#"          null="#not Arguments.FOcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FDcodigo#"   		  null="#not Arguments.FDcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FCFid#" 	   		  null="#not Arguments.FCFid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FACcodigo#"  		  null="#not Arguments.FACcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FACid#"      		  null="#not Arguments.FACid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#">
					)
					<cf_dbidentity1 datasource="#arguments.conexion#">
			</cfquery>
				 <cf_dbidentity2 datasource="#arguments.conexion#" name="idquery">
			<cfelse>
				<cfset idquery.identity = Arguments.AGTPid>
				<cfquery name="rstemp" datasource="#arguments.conexion#">
					update AGTProceso 
					  set AGTPestadp = 0 
					where AGTPid = #idquery.identity#
				</cfquery>				
			</cfif>		
	<cfif not Arguments.Programar>
				<!---Inserta en ADTProceso--->
				<cfquery name="rsInsertaActivos" datasource="#arguments.conexion#">
					insert into ADTProceso
						(Ecodigo, AGTPid, Aid, IDtrans, CFid, TAfalta, 
						TAfechainidep, TAvalrescate, TAvutil, 
						TAfechainirev, TAperiodo, TAmes, 
						TAfecha, Usucodigo, TAmeses 
						
						,TAmontolocadq  <!---revaluacion del valor de adquisicion (TAmontolocadq)--->
						,TAmontooriadq  <!---revaluacion del valor de adquisicion (TAmontooriadq)--->
						,TAmontolocmej  <!---revaluacion del valor de mejoras (TAmontolocmej)--->
						,TAmontoorimej  <!---revaluacion del valor de mejoras (TAmontoorimej)--->
						,TAmontolocrev  <!---revaluacion del valor de revaluacion (TAmontolocrev)--->
						,TAmontoorirev  <!---revaluacion del valor de revaluacion (TAmontoorirev)--->
						
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
						
						,Mcodigo,TAtipocambio
						)
					select
						Ecodigo, #idquery.identity#, Aid, IDtrans, CFid, TAfalta, 
						TAfechainidep, TAvalrescate, TAvutil, 
						TAfechainirev, TAperiodo, TAmes, 
						TAfecha, Usucodigo, TAmeses 
						
						,TAmontolocadq 
						,0.00 
						,TAmontolocmej 
						,0.00 
						,TAmontolocrev
						,0.00 
						
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
						
						,#rsMoneda.value#
						,1
					from #ACTIVOS#
				</cfquery>				
	</cfif>
		<cfif Arguments.debug>
			TAL Y COMO QUEDO LA TRANSACCION EN FIRME
			<cfquery name="rsInsertaActivos" datasource="#arguments.conexion#">	
				select act.APlaca, adt.*
				 from ADTProceso adt
				    inner join Activos act
					  on adt.Aid = act.Aid
					  where adt.AGTPid = #idquery.identity#
			</cfquery>
			<cfdump var="#rsInsertaActivos#">
			<cftransaction action="rollback">
			<cf_abort errorInterfaz="">
		</cfif>
	</cftransaction>			
		<cfreturn #idquery.identity#>
	</cffunction>
</cfcomponent>			