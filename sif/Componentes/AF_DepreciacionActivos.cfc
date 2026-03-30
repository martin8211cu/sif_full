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
	<cffunction name="AF_DepreciacionActivos" access="public" returntype="numeric" output="true">
		<!---Cálculo de la Depreciación por el método de la categoría de cada activo. Calcula la depreciación para todos los activos en estado activo,
		que no se han depreciado por completo, que no se han depreciado en el periodo y mes actual de los auxiliares, y que cumplan con los filtros 
		que se reciben como parámetros.
		--->
		<cfargument name="AGTPid" 				type="numeric" 	default="0" 	required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al cálculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" 				type="numeric" 	default="0" 	required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 			type="numeric" 	default="0" 	required="no"><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" 			type="string" 	default="" 		required="no"><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" 			type="string" 	default="" 		required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" 		type="string" 	default="Depreciacioon" required="no"><!--- Descripción de la transacción --->
		<cfargument name="FOcodigo" 			type="numeric" 	default="-1" 	required="no"><!--- Filtro por Oficina --->
		<cfargument name="FDcodigo" 			type="numeric" 	default="-1" 	required="no"><!--- Filtro por Departamento --->
		<cfargument name="FCFid" 				type="numeric" 	default="-1" 	required="no"><!--- Filtro por Centro  --->
		<cfargument name="FACcodigo" 			type="numeric" 	default="-1" 	required="no"><!--- Filtro por Categoria --->
		<cfargument name="FACid" 				type="numeric" 	default="-1" 	required="no"><!--- Filtro por Clase --->
		<cfargument name="FAFCcodigo" 			type="numeric" 	default="-1" 	required="no"><!--- Filtro por Tipo --->
		<cfargument name="debug" 				type="boolean" 	default="false" required="no"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" 				type="numeric" 	default="0" 	required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 					type="numeric" 	default="0" 	required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Programar" 			type="boolean" 	default="false" required="no"><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" 	type="date" 	default="#CreateDate(1900,01,01)#" required="no">
		
		<!---Valida Fecha de Programación Vrs Programar--->
		<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq -1)>
			<cfset Arguments.Programar = false>
		</cfif>
		
		<cfif Arguments.AGTPid>
			<!--- Cuando Viene por Programación --->
			<cfquery name="rsData" datasource="#Arguments.Conexion#">
				select FOcodigo, FDcodigo, FCFid, FACcodigo, FACid
				from AGTProceso
				where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGTPid#">
			</cfquery>
			<cfif rsData.recordcount GT 0>
				<cfif len(rsData.FOcodigo)>	<cfset Arguments.FOcodigo  = rsData.FOcodigo></cfif>
				<cfif len(rsData.FDcodigo)>	<cfset Arguments.FDcodigo  = rsData.FDcodigo></cfif>
				<cfif len(rsData.FCFid)>	<cfset Arguments.FCFid 	   = rsData.FCFid></cfif>
				<cfif len(rsData.FACcodigo)><cfset Arguments.FACcodigo = rsData.FACcodigo></cfif>
				<cfif len(rsData.FACid)>	<cfset Arguments.FACid     = rsData.FACid></cfif>
			</cfif>
		<cfelse>
			<!--- Cuando No Viene por Programación --->
			<cfset Arguments.Ecodigo    = session.Ecodigo>
			<cfset Arguments.Conexion   = session.dsn>
			<cfset Arguments.Usucodigo  = session.Usucodigo>
			<cfset Arguments.IPregistro = session.sitio.ip>
		</cfif>

		<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
		<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" refresh="no" datasource="#Arguments.Conexion#" />
		
		<cfif not StructKeyExists(Application.dsinfo, Arguments.conexion)>
			<cf_errorCode	code = "50599"
							msg  = "Datasource no definido: @errorDat_1@"
							errorDat_1="#HTMLEditFormat(Arguments.Conexion)#"
			>
		</cfif>

		<!---►►Obtiene el Periodo y Mes de Auxiliares◄◄--->
		<cfif Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
            <cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value"/>
		</cfif>
		<cfif Arguments.Mes neq 0>
			<cfset rsMes.value = Arguments.Mes>
		<cfelse>
        	<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="rsMes.value"/>
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
		<cfset rsFechaAux.value = DateAdd("h",23,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("n",59,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("s",59,rsFechaAux.value)>
		
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
		<cfif Arguments.FCFid gte 0><cfset filtroa = filtroa & " and a.CFid = " & Arguments.FCFid></cfif><!--- Filtro por centro funcional--->
		<cfset filtrob="">
		<cfif Arguments.FACcodigo gte 0><cfset filtrob = filtrob & " and b.ACcodigo = " & Arguments.FACcodigo></cfif><!--- Filtro por categoría--->
		<cfif Arguments.FACid gte 0><cfset filtrob = filtrob & " and b.ACid = " & Arguments.FACid></cfif><!--- Filtro por clase--->
		<cfif Arguments.FAFCcodigo gte 0><cfset filtrob = filtrob & " and b.AFCcodigo = " & Arguments.FAFCcodigo></cfif><!--- Filtro por tipo--->
		<cfset filtrocf="">
		<cfif Arguments.FOcodigo  gte 0 or Arguments.FDcodigo gte 0>
			<cfset filtrocf = filtrocf & " inner join CFuncional cf 
											on a.CFid = cf.CFid ">
		</cfif>  <!--- Join con centro funcional para filtrar --->
		<cfif Arguments.FOcodigo gte 0>
			<cfset filtrocf = filtrocf & " and cf.Ocodigo = " & Arguments.FOcodigo>
			<cfset filtroa = filtroa & " and a.Ocodigo = " & Arguments.FOcodigo>
		</cfif><!--- Filtro por oficina--->
		<cfif Arguments.FDcodigo gte 0>
			<cfset filtrocf = filtrocf & " and cf.Dcodigo = " & Arguments.FDcodigo>
		</cfif><!--- Filtro por departamento--->
		

		<!---Inicio Cálculo de la Depreciación--->
		<cftransaction>
			
			<cfif Arguments.AGTPid is 0>
				
				<cfinvoke 	component		= "sif.Componentes.OriRefNextVal"
						method		= "nextVal"
						returnvariable	= "LvarNumDoc"
						ORI			= "AFDP"
						REF			= "DP"
				/>
				
				<!---Inserta Grupo de transacciones de depreciación--->
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
						#arguments.ecodigo#,<!----- Ecodigo--->
						4,<!----- IDtrans--->
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarNumDoc#">, <!----- AGTPdocumento--->
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#mid(Arguments.AGTPdescripcion, 1, 80)#" len='80'>,<!----- AGTPdescripcion--->
						#rsPeriodo.value#,<!----- AGTPperiodo--->
						#rsMes.value#,<!----- AGTPmes--->
						#Arguments.usucodigo#,<!----- Usucodigo--->
						<cf_dbfunction name="now">,<!----- AGTPfalta--->
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#arguments.ipregistro#">,<!----- AGTPipregistro--->
						<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq 1)>1<cfelse>0</cfif>,<!----- AGTPestadp--->
						#arguments.ecodigo#,<!----- AGTPecodigo--->
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FOcodigo#" null="#Arguments.FOcodigo lt 0#">,<!----- FOcodigo--->
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FDcodigo#" null="#Arguments.FDcodigo lt 0#">,<!----- FDcodigo--->
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FCFid#" null="#Arguments.FCFid lt 0#">,<!----- FCFid--->
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FACcodigo#" null="#Arguments.FACcodigo lt 0#">,<!----- FACcodigo--->
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FACid#" null="#Arguments.FACid lt 0#">,<!----- as FACid--->
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#"> <!----- as AGTPfechaprog--->
						)
						<cf_dbidentity1 datasource="#arguments.conexion#">
				</cfquery>
				<cf_dbidentity2 datasource="#arguments.conexion#" name="idquery">
			
			<cfelse>
				
				<cfset idquery.identity = Arguments.AGTPid>
				<cfquery name="rstemp" datasource="#arguments.conexion#">
					update AGTProceso set AGTPestadp = 0 where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idquery.identity#">
				</cfquery>				

			</cfif>

			<cfif not Arguments.Programar>
<!---====================Fórmula de la Depreciación por Línea Recta:=======================================
	Variables:
			Monto Total a Depreciar = Valor de Adquisicion - Valor de Rescate
			Depreciacion Acumulada 	= Suma de las Depreciaciones Aplicadas
			Vida Util = Vida Util de la Clasificacion del Activo
			Saldo de Vida Util = Saldo de Vida Util de la Tabla de Saldos
			Cantidad de Meses a Depreciar = (diferencia de meses(Fecha Inicio Depreciacion, Fecha Auxiliares)-(Vida Util - Saldo Vida Util)-Los meses que halla pasado el Activo Totalmente depreciado)
			
					( Monto Total a Depreciar - Depreciacion Acumulada ) 
	Fórmula:	  ------------------------------------------------------ 	*  Cantidad de Meses a Depreciar
								( Saldo de Vida Util )
==========================================================================================================--->

				<cf_dbfunction name="datediff" args="b.Afechainidep,#rsFechaAux.value#,MM" returnvariable= "CantidadMeses">
                <cf_dbfunction name="date_part"	args="YYYY,b.Afechainidep" returnvariable="periodoDep">
                <cf_dbfunction name="date_part"	args="MM,b.Afechainidep"   returnvariable="mesDep">
					 
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
					<cfquery name="rsCalculoDepLineaRecta" datasource="#arguments.conexion#">
						insert into ADTProceso
							(Ecodigo, AGTPid, Aid, IDtrans, CFid, TAfalta, 
							TAfechainidep, 
							TAvalrescate, 
							TAvutil, 
							TAsuperavit, 
							TAfechainirev,
							TAperiodo, 
							TAmes, 
							TAfecha,
							Usucodigo
							,TAmeses 		 <!--- Cantidad de Meses a Depreciar (TAmeses) --->
							,TAmontolocadq 	 <!---depreciacion del valor de adquisicion (TAmontolocadq)---> 
							,TAmontooriadq 	 <!---depreciacion del valor de adquisicion (TAmontooriadq) --->
							,TAmontolocmej 	 <!---depreciacion del valor de mejoras (TAmontolocmej) --->
							,TAmontoorimej 	 <!---depreciacion del valor de mejoras (TAmontoorimej)---> 
							,TAmontolocrev 	 <!---depreciacion del valor de revaluacion (TAmontolocrev) --->
							,TAmontoorirev 	 <!---depreciacion del valor de revaluacion (TAmontoorirev) --->
							
							,TAmontodepadq
							,TAmontodepmej
							,TAmontodeprev

							,TAvaladq
							,TAvalmej
							,TAvalrev
							
							,TAdepacumadq
							,TAdepacummej
							,TAdepacumrev
							
							,Mcodigo
							,TAtipocambio
							)
						select 
							a.Ecodigo, 
							#idquery.identity# as AGTPid, 
							a.Aid, 
							4 as IDtrans, 
							a.CFid, 
							<cf_dbfunction name="now"> as TAfalta, 
							b.Afechainidep as TAfechainidep, 
							b.Avalrescate as TAvalrescate, 
							a.AFSsaldovutiladq as TAvutil, 
							0.00 as TAsuperavit, 
							b.Afechainirev as TAfechainirev,
							#rsPeriodo.value# as TAperiodo, 
							#rsMes.value# as TAmes, 
							#rsFechaAux.value# as TAfecha,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#"> as Usucodigo
							<!---===============================================================================================================================
							Cantidad de meses a depreciar: Es la diferencia de meses que han pasado desde el inicio de depreciación hasta el periodo mes Auxiliar
							Mas uno (Mes a depreciar) ,menos la cantidad de meses que ya halla depreciado el Activo, menos todos aquellos meses que el Activo 
							estuvieron Inactivos, (es decir totalmente depreciado y sin depreciacion ese mes)--->
							,#PreserveSingleQuotes(CantidadMeses)# - #MESExEXCLUIR# + 1 - (a.AFSvutiladq-#MESExEXCLUIR#-a.AFSsaldovutiladq) as TAmeses 
							<!---==============================================================================================================================
							Depreciación del valor de adquisición (TAmontolocadq)
							Es el valor en Adquisición menos el valor de rescate menos la depreciación Acumulada de la Adquisición esto nos da el valor en libros
							se divide entre el saldo de vida útil, esto nos da el monto a depreciar por mes y por ultimo se multiplica por la cantidad de meses a
							depreciar (TAmeses-Explicación arriba)--->	
							,case when a.AFSsaldovutiladq > 0 then round((((a.AFSvaladq-b.Avalrescate-a.AFSdepacumadq)/a.AFSsaldovutiladq) * 
							(#PreserveSingleQuotes(CantidadMeses)#-#MESExEXCLUIR# + 1- (a.AFSvutiladq-#MESExEXCLUIR#-a.AFSsaldovutiladq))),2) 
							else 0.00 end as TAmontolocadq 
							,0.00
							<!---==============================================================================================================================
							Depreciación del valor de mejoras (TAmontolocmej)
							Es el valor en mejoras menos la depreciación Acumulada de la mejora esto nos da el valor en libros
							se divide entre el saldo de vida útil de la Adquisición, esto nos da el monto a depreciar por mes y por ultimo se multiplica por la 
							cantidad de meses a depreciar (TAmeses-Explicación arriba) --->
							,case when a.AFSsaldovutiladq > 0 then round((((a.AFSvalmej-0.00		 -a.AFSdepacummej)/a.AFSsaldovutiladq) * 
							(#PreserveSingleQuotes(CantidadMeses)#- #MESExEXCLUIR# + 1- (a.AFSvutiladq - #MESExEXCLUIR# - a.AFSsaldovutiladq))),2) 
							else 0.00 end as TAmontolocmej
							,0.00 
							<!---==============================================================================================================================
							Depreciación del valor de reevaluación (TAmontolocrev)
							Es el valor en Reevaluación menos la depreciación Acumulada de la Reevaluación esto nos da el valor en libros
							se divide entre el saldo de vida útil de la Reevaluación, esto nos da el monto a depreciar por mes y por ultimo se multiplica por la 
							cantidad de meses a depreciar (TAmeses-Explicacin arriba) --->
							,case when a.AFSsaldovutilrev > 0 then round((((a.AFSvalrev-0.00  -a.AFSdepacumrev)/a.AFSsaldovutilrev) * 
							(#PreserveSingleQuotes(CantidadMeses)# - #MESExEXCLUIR# + 1- (a.AFSvutilrev - #MESExEXCLUIR#- a.AFSsaldovutilrev))),2) 
							else 0.00 end as TAmontolocrev 
							,0.00 
							
							,0.00
							,0.00
							,0.00

							,AFSvaladq
							,AFSvalmej
							,AFSvalrev
							
							,AFSdepacumadq
							,AFSdepacummej
							,AFSdepacumrev
							
							,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">,1
						from AFSaldos a
							inner join Activos b 
								on b.Ecodigo = a.Ecodigo
								and b.Aid = a.Aid
								and b.Astatus = 0 					<!---estado activo--->
								and <cf_dbfunction name="to_date00" args="b.Afechainidep"> <= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">
								#filtrob#							<!---filtro por categoria / clase--->
							inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACmetododep = 1 				<!---metodo linea recta--->
							#filtrocf#								<!---filtro por oficina / departamento--->
						where a.AFSperiodo = <cf_jdbcquery_param value="#rsPeriodo.value#" cfsqltype="cf_sql_integer">
						  and a.AFSmes = #rsMes.value#
						  and a.AFSdepreciable = 1				    <!---Clasificación depreciable. Se asigna en la Adquisición, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional--->
						  and a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
						  and (a.AFSsaldovutiladq > 0 or a.AFSsaldovutilrev > 0)
						#filtroa#									<!---filtro por centro funcional--->
						  and not exists(
								select 1 
								from TransaccionesActivos t <cf_dbforceindex name="TActivos02" datasource="#Arguments.Conexion#">
								where t.Aid = a.Aid
								  and t.IDtrans = 4
								  and t.TAperiodo = #rsPeriodo.value#
								  and t.TAmes     = #rsMes.value#
							)
						  and not exists(
								select 1 
								from ADTProceso tp <!--- El Indice no No Existe 05/09/06  *** Queda Pendiente Analisis de este subquery y el anterior, 
															sugerencia de Mau Arias, debe Agregarse Ecodigo a ambos subqueries y debe analizarse la creación 
															de nuevos índices que ayuden a estas subconsultas <cf_dbforceindex name="ADTProceso_FK5">--->
								where tp.Aid = a.Aid
								  and tp.IDtrans = 4
								  and tp.TAperiodo = #rsPeriodo.value#
								  and tp.TAmes     = #rsMes.value#
							)
					</cfquery>
				
				<!---Cálculo por Suma de Dígitos
				     Fórmula de la Depreciación por Suma de Dígitos:
					 Variables:
								Monto Total a Depreciar = Valor de Adquisicion - Valor de Rescate
								Vida Util = Vida Util de la Clasificacion del Activo
								Mes Depreciacion = diferencia de meses(Fecha Inicio Depreciacion, Fecha Auxiliares)
								Factor Multiplicador Mes = 	si (mes depreciacion <= Vida Util) entonces (Vida Util - mes depreciacion + 1) sino (0)
								Factor Meses = (Vida Util*(Vida Util +1)) / 2
							
							    			  ( Monto Total a Depreciar * Factor Multiplicador Mes ) 	
					 Fórmula Depreciacion: = ---------------------------------------------------------
												               ( Factor Meses )
				--->

					<cfquery name="rsCalculoDepSumaDigitos" datasource="#arguments.conexion#">
						insert into ADTProceso
							(
							Ecodigo, AGTPid, Aid, IDtrans, CFid, TAfalta, 
							TAfechainidep, 
							TAvalrescate, 
							TAvutil, 
							TAsuperavit, 
							TAfechainirev,
							TAperiodo, 
							TAmes, 
							TAfecha,
							Usucodigo
							,TAmeses 	   <!--- Cantidad de Meses a Depreciar (TAmeses)    --->
							,TAmontolocadq <!--- depreciacion del valor de adquisicion (TAmontolocadq) --->
							,TAmontooriadq <!--- depreciacion del valor de adquisicion (TAmontooriadq) --->
							,TAmontolocmej <!--- depreciacion del valor de mejoras (TAmontolocmej) --->
							,TAmontoorimej <!--- depreciacion del valor de mejoras (TAmontoorimej) --->
							,TAmontolocrev <!--- depreciacion del valor de revaluacion (TAmontolocrev) --->
							,TAmontoorirev <!--- depreciacion del valor de revaluacion (TAmontoorirev) --->
							
							,TAmontodepadq
							,TAmontodepmej
							,TAmontodeprev

							,TAvaladq
							,TAvalmej
							,TAvalrev
							
							,TAdepacumadq
							,TAdepacummej
							,TAdepacumrev
							
							,Mcodigo
							,TAtipocambio
							)
						select 
							a.Ecodigo, 
							#idquery.identity# as AGTPid, 
							a.Aid, 
							4 as IDtrans, 
							a.CFid, 
							<cf_dbfunction name="now"> as TAfalta, 
							b.Afechainidep as TAfechainidep, 
							b.Avalrescate as TAvalrescate, 
							a.AFSsaldovutiladq as TAvutil, 
							0.00 as TAsuperavit, 
							b.Afechainirev as TAfechainirev,
							#rsPeriodo.value# as TAperiodo, 
							#rsMes.value# as TAmes, 
							#rsFechaAux.value# as TAfecha,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#"> as Usucodigo
							,#PreserveSingleQuotes(CantidadMeses)# + 1 -(a.AFSvutiladq-a.AFSsaldovutiladq) as TAmeses <!---Cantidad de Meses a Depreciar (TAmeses) /*si se cambia esta línea recordar cambiar en las tres siguientes líneas --->
							,case when a.AFSvutiladq *(a.AFSvutiladq +1) / 2 > 0 then round(((a.AFSvaladq-b.Avalrescate )*(case when #PreserveSingleQuotes(CantidadMeses)# + 1 <= a.AFSvutiladq then a.AFSvutiladq - (#PreserveSingleQuotes(CantidadMeses)# + 1) else 0.00 end)) / ((a.AFSvutiladq *(a.AFSvutiladq +1)) / 2),2) else 0.00 end as TAmontolocadq <!---depreciacion del valor de adquisicion (TAmontolocadq)--->
							,0.00 <!---depreciacion del valor de adquisicion (TAmontooriadq)--->
							,case when a.AFSvutiladq *(a.AFSvutiladq +1) / 2 > 0 then round(((a.AFSvalmej - 0.00 ) *      (case when #PreserveSingleQuotes(CantidadMeses)# + 1 <= a.AFSvutiladq then a.AFSvutiladq - (#PreserveSingleQuotes(CantidadMeses)# + 1) else 0.00 end)) / ((a.AFSvutiladq *(a.AFSvutiladq +1)) / 2),2) else 0.00 end as TAmontolocmej <!---depreciacion del valor de mejoras (TAmontolocmej)--->
							,0.00 <!--- depreciacion del valor de mejoras (TAmontoorimej)--->
							,case when a.AFSvutilrev *(a.AFSvutilrev +1) / 2 > 0 then round(((a.AFSvalrev - 0.00 ) *      (case when #PreserveSingleQuotes(CantidadMeses)# + 1 <= a.AFSvutilrev then a.AFSvutilrev - (#PreserveSingleQuotes(CantidadMeses)# + 1) else 0.00 end)) / ((a.AFSvutilrev *(a.AFSvutilrev +1)) / 2),2) else 0.00 end as TAmontolocrev <!--- depreciacion del valor de revaluacion (TAmontolocrev)--->
							,0.00 <!--- depreciacion del valor de revaluacion (TAmontoorirev)--->
							
							,0.00
							,0.00
							,0.00

							,AFSvaladq
							,AFSvalmej
							,AFSvalrev
							
							,AFSdepacumadq
							,AFSdepacummej
							,AFSdepacumrev
							
							,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">,1
						from AFSaldos a
							inner join Activos b 
								on b.Ecodigo = a.Ecodigo
								and b.Aid = a.Aid
								and <cf_dbfunction name="to_date00" args="b.Afechainidep"> <=  <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsFechaAux.value#">
								and b.Astatus = 0 				<!---estado activo--->
								#filtrob#						<!---filtro por categoria / clase--->
							inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACmetododep = 2 			<!---metodo linea recta--->
							#filtrocf#							<!---filtro por oficina / departamento--->
						where a.AFSperiodo = <cf_jdbcquery_param value="#rsPeriodo.value#" cfsqltype="cf_sql_numeric">
						  and a.AFSmes = <cf_jdbcquery_param value="#rsMes.value#" cfsqltype="cf_sql_numeric">
						  and a.AFSdepreciable = 1				<!---Clasificación depreciable. Se asigna en la Adquisición, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional--->
						  and a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.ecodigo#">
						  and (a.AFSsaldovutiladq > 0 or a.AFSsaldovutilrev > 0)
							#filtroa#							<!---filtro por centro funcional--->
							and not exists(
								select 1 
								from TransaccionesActivos t <cf_dbforceindex name="TActivos02" datasource="#Arguments.Conexion#">
								where t.Aid = a.Aid
								  and t.IDtrans = 4
								  and t.TAperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">
								  and t.TAmes = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMes.value#">
							)
							and not exists(
								select 1 
								from ADTProceso tp <!--- El Indice no No Existe 05/09/06  *** Queda Pendiente Analisis de este subquery y el anterior, 
															sugerencia de Mau Arias, debe Agregarse Ecodigo a ambos subqueries y debe analizarse la creación 
															de nuevos índices que ayuden a estas subconsultas <cf_dbforceindex name="ADTProceso_FK5">--->
								where tp.Aid = a.Aid
								  and tp.IDtrans = 4
								  and tp.TAperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">
								  and tp.TAmes = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMes.value#">
							) 
					</cfquery>
					
				<!--- Se verificas que los activos a mejorar no esten dentro de 
				  una transacción pendiente de DEPRECIACION, REVALUACION o RETIRO --->				 
				  
				<!--- Verifica si la placa esta en una transaccion pendiente de MEJORA--->
				<cfquery name="rsRevisaPend" datasource="#Arguments.Conexion#">
					Select count(1) as Cantidad
					from ADTProceso t
					where t.AGTPid = #idquery.identity#
					  and (
								Select count(1)
								from ADTProceso tp <cf_dbforceindex name="ADTProceso_FK5" datasource="#Arguments.Conexion#"> 
									where tp.Aid = t.Aid
									  and tp.IDtrans = 2
									  and tp.TAperiodo = #rsPeriodo.value#
									  and tp.TAmes 	   = #rsMes.value#
							)	> 0
				</cfquery>  
				
				<cfif rsRevisaPend.Cantidad gt 0>
					<cf_errorCode	code = "50935" msg = "Existen Activos que se encuentran dentro de una transaccion de Mejora pendiente de aplicar!">
				</cfif>

				<!--- Verifica si la placa esta en una transaccion pendiente de REVALUACION--->							
				<cfquery name="rsRevisaPend" datasource="#Arguments.Conexion#">
				Select count(1) as Cantidad
				from ADTProceso t
				where t.AGTPid = #idquery.identity#
				  and (
				  			Select count(1) 
							from ADTProceso tp <cf_dbforceindex name="ADTProceso_FK5" datasource="#Arguments.Conexion#">
							where tp.Aid = t.Aid
							  and tp.IDtrans = 3
							  and tp.TAperiodo =#rsPeriodo.value#
							  and tp.TAmes = #rsMes.value#
						) > 0
				</cfquery>  
				
				<cfif rsRevisaPend.Cantidad gt 0>
					<cf_errorCode	code = "50936" msg = "Existen Activos que se encuentran dentro de una transaccion de Revaluacion pendiente de aplicar!">
				</cfif>

				<!--- Verifica si la placa esta en una transaccion pendiente de RETIROS--->			
				<cfquery name="rsRevisaPend" datasource="#Arguments.Conexion#">
					Select count(1) as Cantidad
					from ADTProceso t
					where t.AGTPid = #idquery.identity#
					  and (
								Select count(1)
								from ADTProceso tp <cf_dbforceindex name="ADTProceso_FK5" datasource="#Arguments.Conexion#">
								where tp.Aid = t.Aid
								  and tp.IDtrans = 5
								  and tp.TAperiodo = #rsPeriodo.value#
								  and tp.TAmes = #rsMes.value#
							) > 0		
				</cfquery>  								
				
				<cfif rsRevisaPend.Cantidad gt 0>
					<cf_errorCode	code = "50937" msg = "Existen Activos que se encuentran dentro de una transaccion de Retiro pendiente de aplicar!">
				</cfif>

				<!--- 
					Poner los datos que generaron < 0 en CERO (0.00) 
				--->

				<cfquery datasource="#arguments.conexion#">
				<!---
					update ADTProceso
					set 
						TAmontolocadq = case when TAmontolocadq < 0 then 0.00 else TAmontolocadq end,
						TAmontolocmej = case when TAmontolocmej < 0 then 0.00 else TAmontolocmej end,
						TAmontolocrev = case when TAmontolocrev < 0 then 0.00 else TAmontolocrev end
					where AGTPid = #idquery.identity#
					  and ( TAmontolocadq < 0 or TAmontolocmej < 0 or TAmontolocrev < 0 )
				--->	  
					  
					update ADTProceso
					set 
						TAmontolocadq = 0.00
					where TAmontolocadq < 0
					  
				</cfquery>				

				<!--- 
					Eliminar los registros que generaron <= 0 en TODOS los montos
				--->

				<cfquery datasource="#arguments.conexion#">
					delete from ADTProceso
					where AGTPid = #idquery.identity#
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
					where AGTPid = #idquery.identity#
					  and TAmontolocadq >= 0
					  and TAmontolocadq > (TAvaladq - TAvalrescate - TAdepacumadq)
				</cfquery>				

				<cfquery datasource="#arguments.conexion#">
					update ADTProceso
					set 
						TAmontolocadq = coalesce(( TAvaladq - TAvalrescate - TAdepacumadq) , 0.00)
					where AGTPid = #idquery.identity#
					  and TAmontolocadq < 0
					  and TAmontolocadq < (TAvaladq - TAvalrescate - TAdepacumadq)
				</cfquery>				

				<cfquery datasource="#arguments.conexion#">
					update ADTProceso
					set 
						TAmontolocmej = coalesce(( TAvalmej - TAdepacummej), 0.00)
					where AGTPid = #idquery.identity#
					  and TAmontolocmej  >= 0
					  and TAmontolocmej  > (TAvalmej - TAdepacummej)
				</cfquery>				

				<cfquery datasource="#arguments.conexion#">
					update ADTProceso
					set 
						TAmontolocmej = coalesce(( TAvalmej - TAdepacummej), 0.00)
					where AGTPid = #idquery.identity#
					  and TAmontolocmej  < 0
					  and TAmontolocmej  < (TAvalmej - TAdepacummej)
				</cfquery>				

				<cfquery datasource="#arguments.conexion#">
					update ADTProceso
					set 
						TAmontolocrev = coalesce(( TAvalrev - TAdepacumrev), 0.00)
					where AGTPid = #idquery.identity#
					  and TAmontolocrev >= 0
					  and TAmontolocrev > ( TAvalrev - TAdepacumrev )
				</cfquery>				

				<cfquery datasource="#arguments.conexion#">
					update ADTProceso
					set 
						TAmontolocrev = coalesce(( TAvalrev - TAdepacumrev), 0.00)
					where AGTPid = #idquery.identity#
					  and TAmontolocrev < 0
					  and TAmontolocrev < ( TAvalrev - TAdepacumrev )
				</cfquery>				

				<cfquery datasource="#arguments.conexion#">
					update ADTProceso
					set 
						TAmeses = coalesce(TAvutil, 0)
					where AGTPid = #idquery.identity#
					  and TAmeses > TAvutil
				</cfquery>				

			</cfif>
			
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
		
		</cftransaction><!---Fin Cálculo de la Depreciación--->
		
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn #idquery.identity#>
	</cffunction>
</cfcomponent>