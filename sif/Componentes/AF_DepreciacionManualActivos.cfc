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
	<cffunction name="AF_DepreciacionManualActivos" access="public" returntype="numeric" output="true">
		<!---Calculo de la Depreciacin por el metodo de la categoria de cada activo. Calcula la depreciacin para todos los activos en estado activo,
	 	que no se han depreciado por completo, que no se han depreciado en el periodo y mes actual de los auxiliares, y que cumplan con los filtros 
		que se reciben como parmetros.
		--->
		<cfargument name="AGTPid" 			type="numeric" 	default="0" 			required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al clculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" 			type="numeric" 	default="0" 			required="no"><!--- Cdigo de Empresa (sif) --->
		<cfargument name="Usucodigo" 		type="numeric" 	default="0" 			required="no"><!--- Cdigo de Usuario (asp) --->
		<cfargument name="IPregistro" 		type="string" 	default="" 				required="no"><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 		type="string" 	default="" 				required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" 	type="string" 	default="Depreciacioon" required="no"><!--- Descripcin de la transaccin --->
		<cfargument name="debug" 			type="boolean" 	default="false" 		required="no"><!--- si se prende simula la transaccin, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 			type="numeric" 	default="0" 			required="no"><!---Si se envan No se sacan de la tabla de parmetros--->
		<cfargument name="Mes" 				type="numeric" 	default="0" 			required="no"><!---Si se envan No se sacan de la tabla de parmetros--->
		
		<cfif Arguments.debug>
			<h2>AF_DepreciacionActivos</h2>
			<cfdump var="#Arguments#">
		</cfif>
	
		<!--- Cuando No Viene por Programacin --->
		<cfset Arguments.Ecodigo = session.Ecodigo>
		<cfset Arguments.Conexion = session.dsn>
		<cfset Arguments.Usucodigo = session.Usucodigo>
		<cfset Arguments.IPregistro = session.sitio.ip>

		<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
		<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo"
			refresh="no"
			datasource="#Arguments.Conexion#" />
		
		<cfif not StructKeyExists(Application.dsinfo, Arguments.conexion)>
			<cf_errorCode	code = "50599"
							msg  = "Datasource no definido: @errorDat_1@"
							errorDat_1="#HTMLEditFormat(Arguments.Conexion)#"
			>
		</cfif>
				
		<!---Antes de iniciar la transaccin hace algunos calculos--->
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfif Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
			<cfquery name="rsPeriodo" datasource="#arguments.conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
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
				where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
		</cfif>

		<cfif Arguments.debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h3>DEBUG</h3><br>
				<p>
				<strong>Periodo</strong> = #rsPeriodo.value#<br>
				<strong>Mes</strong> = #rsMes.value#<br>
				<strong>Descripcin</strong> = #Arguments.AGTPdescripcion#<br>
				</p>
			</cfoutput>
		</cfif>
		
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50938" msg = "No se ha definido el parmetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50939" msg = "No se ha definido el parmetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		

		<!---Inicio Clculo de la Depreciacin--->
		<cftransaction>
			
			<cfinvoke 	component	  = "sif.Componentes.OriRefNextVal"
					    method		  = "nextVal"
					    returnvariable= "LvarNumDoc"
					    ORI			  = "AFDP"
					    REF			  = "DP"
			/>
			
			<!---Inserta Grupo de transacciones de depreciacin--->
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
					AGTPfechaprog,
					
					AGTPmanual)
				values(
					#arguments.ecodigo#,<!----- Ecodigo--->
					4,<!----- IDtrans--->
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarNumDoc#">, <!----- AGTPdocumento--->
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.AGTPdescripcion#">,<!----- AGTPdescripcion--->
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.value#">,<!----- AGTPperiodo--->
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.value#">,<!----- AGTPmes--->
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#">,<!----- Usucodigo--->
					<cf_dbfunction name="now">,<!----- AGTPfalta--->
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#arguments.ipregistro#">,<!----- AGTPipregistro--->
					0,<!----- AGTPestadp--->
					#arguments.ecodigo#,<!----- AGTPecodigo--->
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">, 			
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">, 			
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,
					1 <!-----Indica que se trata de una Dep. Manual--->
					)
					<cf_dbidentity1 datasource="#arguments.conexion#">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="idquery">

			<cfif Arguments.debug>
				<cfquery name="rsAGTP" datasource="#arguments.conexion#">
					select * from AGTProceso where AGTPid = #idquery.identity#
				</cfquery>
				<cfquery name="rsADTP" datasource="#arguments.conexion#">
					select * from ADTProceso where AGTPid = #idquery.identity#
				</cfquery>
				<cfdump var="#rsAGTP#">
				<cfdump var="#rsADTP#">
				<cftransaction action="rollback"/>
			<cfelse>
				<cftransaction action="commit"/>
			</cfif>
		
		</cftransaction><!---Fin Clculo de la Depreciacin--->
		
		<!---Si llega hasta aqu todo sali bien--->
		<cfreturn #idquery.identity#>
	</cffunction>
	
	
	<cffunction name="AF_GeneraDepManualActivos" access="public" returntype="numeric" output="true">
		<!---Clculo de la Depreciacin por el mtdodo de la categora de cada activo. Calcula la depreciacin para todos los activos en estado activo,
	 	que no se han depreciado por completo, que no se han depreciado en el periodo y mes actual de los auxiliares, y que cumplan con los filtros 
		que se reciben como parmetros.
		--->
		<cfargument name="AGTPid" 	type="numeric" 	default="0" 	required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al clculo, se creo para calendarizar generaciones. --->
		<cfargument name="Aid" 		type="numeric" 					required="yes"><!--- Id del Activo. --->
		<cfargument name="Ecodigo" 	type="numeric" 	default="0" 	required="no"><!--- Cdigo de Empresa (sif) --->
		<cfargument name="Usucodigo"type="numeric" 	default="0" 	required="no"><!--- Cdigo de Usuario (asp) --->
		<cfargument name="Conexion" type="string" 	default="" 		required="no"><!--- Conexion a la BD --->
		<cfargument name="debug" 	type="boolean" 	default="false" required="no"><!--- si se prende simula la transaccin, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 	type="numeric" 	default="0" 	required="no"><!---Si se envan No se sacan de la tabla de parmetros--->
		<cfargument name="Mes" 		type="numeric" 	default="0" 	required="no"><!---Si se envan No se sacan de la tabla de parmetros--->
	
		<cfset Arguments.Ecodigo = session.Ecodigo>
		<cfset Arguments.Conexion = session.dsn>
		<cfset Arguments.Usucodigo = session.Usucodigo>
		<cfset LvarADTPlinea = -1>
		
		<!--- Obtiene el mtodo de Depreciacin --->	
		<cfquery name="rsMetodoValido" datasource="#arguments.conexion#">
			select Pvalor as MetodoDepreciacion
			from Parametros
			where Ecodigo = #arguments.ecodigo#
			  and Pcodigo = 245
		</cfquery>
		<cfif isdefined('rsMetodoValido') and rsMetodoValido.recordcount GT 0>
				<cfset MetodoDepreciacion = rsMetodoValido.MetodoDepreciacion>
		<cfelse>
				<cfset MetodoDepreciacion = 1>
		</cfif>	
		
		<!---Antes de iniciar la transaccin hace algunos calculos--->
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfif Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
			<cfquery name="rsPeriodo" datasource="#arguments.conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
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
				where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
		</cfif>		
		
		
		<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el ltimo da del mes --->
		<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
		<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("h",23,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("n",59,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("s",59,rsFechaAux.value)>		
		
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#arguments.conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>

		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50940" msg = "No se ha definido el parmetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50938" msg = "No se ha definido el parmetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50939" msg = "No se ha definido el parmetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" 	  Aid="#Arguments.Aid#"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" 	  Aid="#Arguments.Aid#"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion"  Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" 	  Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" 	  Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado"     Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola"         Aid="#Arguments.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_isDepreciable"Aid="#Arguments.Aid#"/> 
		
		<cf_dbfunction name="datediff" args="b.Afechainidep,#rsFechaAux.value#, MM" returnvariable= "CantidadMeses">
		<cftransaction>
			<cfif MetodoDepreciacion LT 3>
				<cf_dbfunction name="date_part"	args="YYYY,b.Afechainidep" returnvariable="periodoDep">
				<cf_dbfunction name="date_part"	args="MM,b.Afechainidep"   returnvariable="mesDep">
				<!--- Deprecia en Linea Recta --->
				<cfset MESExEXCLUIR = "(select count(1) 
								from AFSaldos AFS 
							  where AFS.Aid = a.Aid 
							    and (AFS.AFSperiodo > #periodoDep# or (AFS.AFSperiodo =  #periodoDep# and AFS.AFSmes >= #mesDep#))
									 and not exists(select 1 
												from TransaccionesActivos AFT 
											   where AFT.Aid       = AFS.Aid 
											     and AFT.IDtrans   = 4
												 and AFT.TAperiodo = AFS.AFSperiodo
												 and AFT.TAmes	   = AFS.AFSmes)
									and AFS.AFSsaldovutiladq <= 0)">
				<cfquery name="rsCLR" datasource="#arguments.conexion#">
					select
						a.Ecodigo, 
						a.Aid, 
						4 as IDtrans, 
						a.CFid, 
						<cf_dbfunction name="now"> as TAfalta, 
						b.Afechainidep as TAfechainidep, 
						b.Avalrescate as TAvalrescate, 
						a.AFSsaldovutiladq as TAvutil, 
						b.Afechainirev as TAfechainirev,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.value#"> as TAperiodo, 
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.value#"> as TAmes, 
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#"> as TAfecha,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#"> as Usucodigo
						<!--- -- Cantidad de Meses a Depreciar (TAmeses) /*si se cambia esta lnea recordar cambiar en las tres siguientes lneas */--->
						,#PreserveSingleQuotes(CantidadMeses)# - #MESExEXCLUIR# + 1 - (a.AFSvutiladq - #MESExEXCLUIR# - a.AFSsaldovutiladq) as TAmeses
						<!----- Depreciación del valor de adquisición (TAmontolocadq)--->
						,case when a.AFSsaldovutiladq > 0 then round((((a.AFSvaladq-b.Avalrescate-a.AFSdepacumadq)/a.AFSsaldovutiladq)*
						(#PreserveSingleQuotes(CantidadMeses)# - #MESExEXCLUIR# + 1- (a.AFSvutiladq - #MESExEXCLUIR# - a.AFSsaldovutiladq))),2) else 0.00 end as TAmontolocadq 
						<!----- Depreciación del valor de mejoras (TAmontolocmej)--->
						,case when a.AFSsaldovutiladq > 0 then round((((a.AFSvalmej-0.00-a.AFSdepacummej)/a.AFSsaldovutiladq)*
						(#PreserveSingleQuotes(CantidadMeses)# - #MESExEXCLUIR# + 1 - (a.AFSvutiladq - #MESExEXCLUIR# - a.AFSsaldovutiladq))),2) else 0.00 end as TAmontolocmej 
						<!----- Depreciación del valor de revaluación (TAmontolocrev)--->
						,case when a.AFSsaldovutilrev > 0 then round((((a.AFSvalrev-0.00-a.AFSdepacumrev)/a.AFSsaldovutilrev)*
						(#PreserveSingleQuotes(CantidadMeses)# - #MESExEXCLUIR# + 1 -(a.AFSvutilrev - #MESExEXCLUIR# - a.AFSsaldovutilrev))),2) else 0.00 end as TAmontolocrev 

						,AFSvaladq
						,AFSvalmej
						,AFSvalrev
						
						,AFSdepacumadq
						,AFSdepacummej
						,AFSdepacumrev
						
						,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">
					from AFSaldos a
						inner join Activos b 
							on b.Ecodigo = a.Ecodigo
							and b.Aid = a.Aid
							and b.Astatus = 0 						<!---/*estado activo*/--->
							and b.Afechainidep < <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">

						inner join ACategoria c 
							on c.Ecodigo = b.Ecodigo
							and c.ACcodigo = b.ACcodigo
							and c.ACmetododep = 1 				<!---	/*metodo linea recta*/--->

					where a.AFSperiodo = #rsPeriodo.value#
					  and a.AFSmes = #rsMes.value#
					  and a.AFSdepreciable = 1				<!---/*Clasificacin depreciable. Se asigna en la Adquisicin, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional*/--->
					  and a.Ecodigo = #arguments.ecodigo#
					  and (a.AFSsaldovutiladq > 0 or a.AFSsaldovutilrev > 0)
					  and a.Aid = #arguments.Aid#
					  and not exists(
							select 1 
							from TransaccionesActivos t <cf_dbforceindex name="TActivos02">
							where t.Aid = a.Aid
							  and t.IDtrans = 4
							  and t.TAperiodo = #rsPeriodo.value#
							  and t.TAmes = #rsMes.value#
						)
					  and not exists(
							select 1 
							from ADTProceso tp <!--- El Indice no No Existe 05/09/06  *** Queda Pendiente Analisis de este subquery y el anterior, 
														sugerencia de Mau Arias, debe Agregarse Ecodigo a ambos subqueries y debe analizarse la creacin 
														de nuevos ndices que ayuden a estas subconsultas <cf_dbforceindex name="ADTProceso_FK5">--->
							where tp.Aid = a.Aid
							  and tp.IDtrans = 4
							  and tp.TAperiodo = #rsPeriodo.value#
							  and tp.TAmes = #rsMes.value#
						)
			</cfquery>
		
			<cfif rsCLR.recordcount gt 0>
					<cfquery name="rsCalculoDepLineaRecta" datasource="#arguments.conexion#">
						insert into ADTProceso
							(Ecodigo, 
							AGTPid, 
							Aid, 
							IDtrans, 
							CFid, 
							TAfalta, 
							<cfif isdefined("rsCLR.TAfechainidep") and len(trim(rsCLR.TAfechainidep)) gt 0>
							TAfechainidep, 
							</cfif>
							<cfif isdefined("rsCLR.TAvalrescate") and len(trim(rsCLR.TAvalrescate)) gt 0>
							TAvalrescate, 
							</cfif>
							<cfif isdefined("rsCLR.TAvutil") and len(trim(rsCLR.TAvutil)) gt 0>
							TAvutil, 
							</cfif>
							TAsuperavit, 
							<cfif isdefined("rsCLR.TAfechainirev") and len(trim(rsCLR.TAfechainirev)) gt 0>
							TAfechainirev,
							</cfif>
							TAperiodo, 
							TAmes, 
							TAfecha,
							Usucodigo,
							<cfif isdefined("rsCLR.TAmeses") and len(trim(rsCLR.TAmeses)) gt 0>
							TAmeses, 		<!----- Cantidad de Meses a Depreciar         (TAmeses)--->
							</cfif>
							TAmontolocadq, <!----- depreciacion del valor de adquisicion (TAmontolocadq)--->
							TAmontooriadq,<!----- depreciacion del valor de adquisicion (TAmontooriadq)--->
							TAmontolocmej, <!----- depreciacion del valor de mejoras     (TAmontolocmej)--->
							TAmontoorimej, <!----- depreciacion del valor de mejoras     (TAmontoorimej)--->
							TAmontolocrev, <!----- depreciacion del valor de revaluacion (TAmontolocrev)--->
							TAmontoorirev, <!----- depreciacion del valor de revaluacion (TAmontoorirev)--->
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
							TAtipocambio
							)
							
							values (
							#rsCLR.Ecodigo#, 
							#Arguments.AGTPid#, 
							#rsCLR.Aid#, 
							4, 
							#rsCLR.CFid#, 
							<cf_dbfunction name="now">, 
							<cfif isdefined("rsCLR.TAfechainidep") and len(trim(rsCLR.TAfechainidep)) gt 0>
						   <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsCLR.TAfechainidep#"> ,
							</cfif>
							<cfif isdefined("rsCLR.TAvalrescate") and len(trim(rsCLR.TAvalrescate)) gt 0>
							#rsCLR.TAvalrescate#, 
							</cfif>
							<cfif isdefined("rsCLR.TAvutil") and len(trim(rsCLR.TAvutil)) gt 0>
							#rsCLR.TAvutil# , 
							</cfif>
							0.00, 
							<cfif isdefined("rsCLR.TAfechainirev") and len(trim(rsCLR.TAfechainirev)) gt 0>
							<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsCLR.TAfechainirev#"> ,
							</cfif>
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.value#"> ,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.value#"> ,
							<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#">,
							
							<cfif isdefined("rsCLR.TAmeses") and len(trim(rsCLR.TAmeses)) gt 0>
							#rsCLR.TAmeses#, <!----- Cantidad de Meses a Depreciar (TAmeses) /*si se cambia esta lnea recordar cambiar en las tres siguientes lneas */--->
							</cfif>			
							#rsCLR.TAmontolocadq#, <!----- depreciacion del valor de adquisicion (TAmontolocadq)--->
							0.00, <!----- depreciacion del valor de adquisicion (TAmontooriadq)--->
							#rsCLR.TAmontolocmej#, <!----- depreciacion del valor de mejoras (TAmontolocmej)--->
							0.00,<!--- -- depreciacion del valor de mejoras (TAmontoorimej)--->
							#rsCLR.TAmontolocrev#, <!----- depreciacion del valor de revaluacion (TAmontolocrev)--->
							0.00, <!----- depreciacion del valor de revaluacion (TAmontoorirev)--->
							0.00,
							0.00,
							0.00,
							#rsCLR.AFSvaladq#,
							#rsCLR.AFSvalmej#,
							#rsCLR.AFSvalrev#,
							#rsCLR.AFSdepacumadq#,
							#rsCLR.AFSdepacummej#,
							#rsCLR.AFSdepacumrev#,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">,
							1
							)
					<cf_dbidentity1 datasource="#arguments.conexion#">
					</cfquery>
					<cf_dbidentity2 datasource="#arguments.conexion#" name="rsCalculoDepLineaRecta">
					<cfset LvarADTPlinea = #rsCalculoDepLineaRecta.identity#>
				</cfif>
			</cfif>
				
			<!---Calculo por Suma de Digitos
				Formula de la Depreciacin por Suma de Dgitos:
				Variables:
							Monto Total a Depreciar = Valor de Adquisicion - Valor de Rescate
							Vida Util = Vida Util de la Clasificacion del Activo
							Mes Depreciacion = diferencia de meses(Fecha Inicio Depreciacion, Fecha Auxiliares)
							Factor Multiplicador Mes = 	si (mes depreciacion <= Vida Util) entonces (Vida Util - mes depreciacion + 1) sino (0)
							Factor Meses = (Vida Util*(Vida Util +1)) / 2
					
										( Monto Total a Depreciar * Factor Multiplicador Mes ) 
				Formula Depreciacion=   ---------------------------------------------------------
													    ( Factor Meses )																							
			--->

			<cfif MetodoDepreciacion GT 1>
			
				<cfquery name="rsCDSD" datasource="#arguments.conexion#">
					select 
							a.Ecodigo, 
							a.Aid, 
							a.CFid, 
							b.Afechainidep as TAfechainidep, 
							b.Avalrescate as TAvalrescate, 
							a.AFSsaldovutiladq as TAvutil, 
							b.Afechainirev as TAfechainirev,
							#PreserveSingleQuotes(CantidadMeses)# + 1 -(a.AFSvutiladq-a.AFSsaldovutiladq) as TAmeses, <!----- Cantidad de Meses a Depreciar (TAmeses) /*si se cambia esta lnea recordar cambiar en las tres siguientes lneas */--->
							case when ( (a.AFSvutiladq *(a.AFSvutiladq +1)) / 2 ) > 0 then round( ( ( ( a.AFSvaladq - b.Avalrescate ) * ( case when (#PreserveSingleQuotes(CantidadMeses)# + 1 <= a.AFSvutiladq) then (a.AFSvutiladq - #PreserveSingleQuotes(CantidadMeses)# + 1) else (0.00) end ) ) / ( (a.AFSvutiladq *(a.AFSvutiladq +1)) / 2 ) ) , 2)	else 0.00 end as TAmontolocadq, <!----- depreciacion del valor de adquisicion (TAmontolocadq)--->
							case when ( (a.AFSvutiladq *(a.AFSvutiladq +1)) / 2 ) > 0 then round( ( ( ( a.AFSvalmej - 0.00 ) * ( case when (#PreserveSingleQuotes(CantidadMeses)# + 1 <= a.AFSvutiladq) then (a.AFSvutiladq - #PreserveSingleQuotes(CantidadMeses)# + 1) else (0.00) end ) ) / ( (a.AFSvutiladq *(a.AFSvutiladq +1)) / 2 ) ) , 2) else 0.00 end as TAmontolocmej, <!----- depreciacion del valor de mejoras (TAmontolocmej)--->
							case when ( (a.AFSvutilrev *(a.AFSvutilrev +1)) / 2 ) > 0 then round( ( ( ( a.AFSvalrev - 0.00 ) * ( case when (#PreserveSingleQuotes(CantidadMeses)# + 1<= a.AFSvutilrev) then (a.AFSvutilrev - #PreserveSingleQuotes(CantidadMeses)# + 1) else (0.00) end ) ) / ( (a.AFSvutilrev *(a.AFSvutilrev +1)) / 2 ) ) , 2) else 0.00 end as TAmontolocrev, <!----- depreciacion del valor de revaluacion (TAmontolocrev)--->
							AFSvaladq,
							AFSvalmej,
							AFSvalrev,
							AFSdepacumadq,
							AFSdepacummej,
							AFSdepacumrev,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">,1
						from AFSaldos a
							inner join Activos b 
								on b.Ecodigo = a.Ecodigo
								and b.Aid = a.Aid
								and b.Afechainidep < <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">
								and b.Astatus = 0 						<!---/*estado activo*/--->
	
							inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACmetododep = 2 				<!---/*metodo linea recta*/--->
	
						where a.AFSperiodo = #rsPeriodo.value#
						  and a.AFSmes = #rsMes.value#
						  and a.AFSdepreciable = 1				<!---/*Clasificacin depreciable. Se asigna en la Adquisicin, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional*/--->
						  and a.Ecodigo = #arguments.ecodigo#
						  and (a.AFSsaldovutiladq > 0 or a.AFSsaldovutilrev > 0)
						  and a.Aid = #arguments.Aid#
						  and not exists(
								select 1 
								from TransaccionesActivos t <cf_dbforceindex name="TActivos02">
								where t.Aid = a.Aid
								  and t.IDtrans = 4
								  and t.TAperiodo = #rsPeriodo.value#
								  and t.TAmes = #rsMes.value#
							)
							and not exists(
								select 1 
								from ADTProceso tp <!--- El Indice no No Existe 05/09/06  *** Queda Pendiente Analisis de este subquery y el anterior, 
															sugerencia de Mau Arias, debe Agregarse Ecodigo a ambos subqueries y debe analizarse la creacin 
															de nuevos ndices que ayuden a estas subconsultas <cf_dbforceindex name="ADTProceso_FK5">--->
								where tp.Aid = a.Aid
								  and tp.IDtrans = 4
								  and tp.TAperiodo = #rsPeriodo.value#
								  and tp.TAmes = #rsMes.value#
							)
				</cfquery>
			
			<cfif rsCDSD.recordcount gt 0>
				<cfquery name="rsCalculoDepSumaDigitos" datasource="#arguments.conexion#">
					insert into ADTProceso
						(
						Ecodigo, 
						AGTPid, 
						Aid, 
						IDtrans, 
						CFid, 
						TAfalta, 
						<cfif isdefined("rsCDSD.TAfechainidep") and len(trim(rsCDSD.TAfechainidep)) gt 0>
						TAfechainidep, 
						</cfif>
						<cfif isdefined("rsCDSD.TAvalrescate") and len(trim(rsCDSD.TAvalrescate)) gt 0>
						TAvalrescate, 
						</cfif>
						<cfif isdefined("rsCDSD.TAvutil") and len(trim(rsCDSD.TAvutil)) gt 0>
						TAvutil, 
						</cfif>
						TAsuperavit, 
						<cfif isdefined("rsCDSD.TAfechainirev") and len(trim(rsCDSD.TAfechainirev)) gt 0>
						TAfechainirev,
						</cfif>
						TAperiodo, 
						TAmes, 
						TAfecha,
						Usucodigo,
						<cfif isdefined("rsCDSD.TAmeses") and len(trim(rsCDSD.TAmeses)) gt 0>
						TAmeses, 		<!----- Cantidad de Meses a Depreciar (TAmeses)--->
						</cfif>
						TAmontolocadq, <!----- depreciacion del valor de adquisicion (TAmontolocadq)--->
						TAmontooriadq, <!----- depreciacion del valor de adquisicion (TAmontooriadq)--->
						TAmontolocmej, <!----- depreciacion del valor de mejoras (TAmontolocmej)--->
						TAmontoorimej, <!----- depreciacion del valor de mejoras (TAmontoorimej)--->
						TAmontolocrev, <!----- depreciacion del valor de revaluacion (TAmontolocrev)--->
						TAmontoorirev, <!----- depreciacion del valor de revaluacion (TAmontoorirev)--->
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
						TAtipocambio
						)
						
					values
					( 
						#rsCDSD.Ecodigo#, 
						#Arguments.AGTPid#, 
						#rsCDSD.Aid#, 
						4, 
						#rsCDSD.CFid#, 
						<cf_dbfunction name="now">, 
						<cfif isdefined("rsCDSD.TAfechainidep") and len(trim(rsCDSD.TAfechainidep)) gt 0>
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsCDSD.TAfechainidep#"> ,
						</cfif>
						<cfif isdefined("rsCDSD.TAvalrescate") and len(trim(rsCDSD.TAvalrescate)) gt 0>
						#rsCDSD.TAvalrescate#, 
						</cfif>
						<cfif isdefined("rsCDSD.TAvutil") and len(trim(rsCDSD.TAvutil)) gt 0>
						#rsCDSD.TAvutil# , 
						</cfif>
						0.00, 
						<cfif isdefined("rsCDSD.TAfechainirev") and len(trim(rsCDSD.TAfechainirev)) gt 0>
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsCDSD.TAfechainirev#"> ,
						</cfif>
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.value#"> ,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.value#"> ,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#">,
						<cfif isdefined("rsCDSD.TAmeses") and len(trim(rsCDSD.TAmeses)) gt 0>
						#rsCDSD.TAmeses#, <!----- Cantidad de Meses a Depreciar (TAmeses) /*si se cambia esta lnea recordar cambiar en las tres siguientes lneas */--->
						</cfif>			
						#rsCDSD.TAmontolocadq#, <!----- depreciacion del valor de adquisicion (TAmontolocadq)--->
						0.00, <!----- depreciacion del valor de adquisicion (TAmontooriadq)--->
						#rsCDSD.TAmontolocmej#, <!----- depreciacion del valor de mejoras (TAmontolocmej)--->
						0.00,<!--- -- depreciacion del valor de mejoras (TAmontoorimej)--->
						#rsCDSD.TAmontolocrev#, <!----- depreciacion del valor de revaluacion (TAmontolocrev)--->
						0.00, <!----- depreciacion del valor de revaluacion (TAmontoorirev)--->
						0.00,
						0.00,
						0.00,
						#rsCDSD.AFSvaladq#,
						#rsCDSD.AFSvalmej#,
						#rsCDSD.AFSvalrev#,
						#rsCDSD.AFSdepacumadq#,
						#rsCDSD.AFSdepacummej#,
						#rsCDSD.AFSdepacumrev#,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">,
						1
					)
				<cf_dbidentity1 datasource="#arguments.conexion#">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="rsCalculoDepSumaDigitos">
			<cfset LvarADTPlinea = #rsCalculoDepSumaDigitos.identity#>
		</cfif>
	</cfif>

			<!--- Se verificas que los activos a depreciar no esten dentro de 
			  una transaccin pendiente de DEPRECIACION, REVALUACION o RETIRO --->				 
			  
			<!--- Verifica si la placa esta en una transaccion pendiente de MEJORA--->
			<cfquery name="rsRevisaPend" datasource="#Arguments.Conexion#">
				Select count(1) as Cantidad
				from ADTProceso t
				where t.AGTPid = #Arguments.AGTPid#
				  and t.Aid = #Arguments.Aid#
				  and exists(
							Select 1
							from ADTProceso tp <cf_dbforceindex name="ADTProceso_FK5"> 
								where tp.Aid = t.Aid
								  and tp.IDtrans = 2
								  and tp.TAperiodo = #rsPeriodo.value#
								  and tp.TAmes = #rsMes.value#
							)	
			</cfquery>  
			
			<cfif rsRevisaPend.Cantidad gt 0>
				<cf_errorCode	code = "50941" msg = "El Activo se encuentra dentro de una transaccion de Mejora pendiente de aplicar!">
			</cfif>

			<!--- Verifica si la placa esta en una transaccion pendiente de REVALUACION--->							
			<cfquery name="rsRevisaPend" datasource="#Arguments.Conexion#">
			Select count(1) as Cantidad
			from ADTProceso t
			where t.AGTPid = #Arguments.AGTPid#
			  and t.Aid  = #Arguments.Aid#
			  and exists(
						Select 1 
						from ADTProceso tp <cf_dbforceindex name="ADTProceso_FK5">
						where tp.Aid = t.Aid
						  and tp.IDtrans = 3
						  and tp.TAperiodo = #rsPeriodo.value#
						  and tp.TAmes = #rsMes.value#
						 )
			</cfquery>  
			
			<cfif rsRevisaPend.Cantidad gt 0>
				<cf_errorCode	code = "50942" msg = "El Activo se encuentra dentro de una transaccion de Revaluacion pendiente de aplicar!">
			</cfif>

			<!--- Verifica si la placa esta en una transaccion pendiente de RETIROS--->			
			<cfquery name="rsRevisaPend" datasource="#Arguments.Conexion#">
				Select count(1) as Cantidad
				from ADTProceso t
				where t.AGTPid = #Arguments.AGTPid#
				  and t.Aid = #Arguments.Aid#
				  and exists(
							Select 1
							from ADTProceso tp <cf_dbforceindex name="ADTProceso_FK5">
							where tp.Aid = t.Aid
							  and tp.IDtrans = 5
							  and tp.TAperiodo = #rsPeriodo.value#
							  and tp.TAmes = #rsMes.value#
							)		
			</cfquery>  								
			
			<cfif rsRevisaPend.Cantidad gt 0>
				<cf_errorCode	code = "50943" msg = "El Activo se encuentra dentro de una transaccion de Retiro pendiente de aplicar!">
			</cfif>

			<!--- 
				Poner los datos que generaron < 0 en CERO (0.00) 
			--->

			<cfquery datasource="#arguments.conexion#">
				update ADTProceso
				set 
					TAmontolocadq = case when TAmontolocadq < 0 then 0.00 else TAmontolocadq end,
					TAmontolocmej = case when TAmontolocmej < 0 then 0.00 else TAmontolocmej end,
					TAmontolocrev = case when TAmontolocrev < 0 then 0.00 else TAmontolocrev end
				where AGTPid = #Arguments.AGTPid#
				  and Aid    = #Arguments.Aid#
				  and ( TAmontolocadq < 0 or TAmontolocmej < 0 or TAmontolocrev < 0 )
			</cfquery>				

			<!--- 
				Eliminar los registros que generaron <= 0 en TODOS los montos
			--->
			<cfquery  name="ValidaDEPActivo" datasource="#arguments.conexion#">
				select count(1) as cantidad from ADTProceso
				where AGTPid = #Arguments.AGTPid#
				  and Aid    = #Arguments.Aid#
				  and TAmontolocadq <= 0 
				  and TAmontolocmej <= 0 
				  and TAmontolocrev <= 0
			</cfquery>
			
			<cfif ValidaDEPActivo.Cantidad gt 0>
				<cf_errorCode	code = "50954" msg = "	El Activo tiene saldo de vida util en cero (Se encuentra totalmente depreciado), Proceso Cancelado!!">
			</cfif>

			<cfquery datasource="#arguments.conexion#">
				delete from ADTProceso
				where AGTPid = #Arguments.AGTPid#
				  and Aid    = #Arguments.Aid#
				  and TAmontolocadq <= 0 
				  and TAmontolocmej <= 0 
				  and TAmontolocrev <= 0
			</cfquery>				

			<!--- 
				Poner la depreciacion al maximo cuando el monto resultante es mayor que el saldo de la depreciacion
				Los meses a depreciar se convierten en el saldo cuando esto sucede, pues se supone que yo no puede tener vida util restante.
			--->
			<cfquery datasource="#arguments.conexion#">
				update ADTProceso
				set 
					TAmontolocadq = coalesce(( TAvaladq - TAvalrescate - TAdepacumadq) , 0.00)
				where AGTPid = #Arguments.AGTPid#
				  and Aid    = #Arguments.Aid#
				  and TAmontolocadq > (TAvaladq - TAvalrescate - TAdepacumadq)
			</cfquery>				

			<cfquery datasource="#arguments.conexion#">
				update ADTProceso
				set 			
					TAmontolocrev = coalesce(( TAvalrev - TAdepacumrev), 0.00)
				where AGTPid = #Arguments.AGTPid#
				  and Aid    = #Arguments.Aid#
				  and TAmontolocmej  > (TAvalmej - TAdepacummej)
			</cfquery>				

			<cfquery datasource="#arguments.conexion#">
				update ADTProceso
				set 
					TAmontolocrev = coalesce(( TAvalrev - TAdepacumrev), 0.00)
				where AGTPid = #Arguments.AGTPid#
				  and Aid    = #Arguments.Aid#
                  and ABS(TAmontolocrev) > ABS(( TAvalrev - TAdepacumrev ))
			</cfquery>				

			<cfquery datasource="#arguments.conexion#">
				update ADTProceso
				set 
					TAmeses = coalesce(TAvutil, 0)
				where AGTPid = #Arguments.AGTPid#
				  and Aid    = #Arguments.Aid#
				  and TAmeses > TAvutil
			</cfquery>		

			<cfif Arguments.debug>
				<cfquery name="rsAGTP" datasource="#arguments.conexion#">
					select * from AGTProceso where AGTPid = #Arguments.AGTPid#
				</cfquery>
				<cfquery name="rsADTP" datasource="#arguments.conexion#">
					select * from ADTProceso where AGTPid = #Arguments.AGTPid#
				</cfquery>
				<cfdump var="#rsAGTP#">
				<cfdump var="#rsADTP#">
				<cftransaction action="rollback"/>
			<cfelse>
				<cftransaction action="commit"/>
			</cfif>
		
		</cftransaction><!---Fin Clculo de la Depreciacin--->		
		
		<cfreturn #LvarADTPlinea#>
		
	</cffunction>
				
</cfcomponent>


