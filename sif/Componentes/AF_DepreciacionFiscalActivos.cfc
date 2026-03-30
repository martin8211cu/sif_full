<!---
Modificado por: Alejandro Bolaños APH
Fecha: 27/09/2011
Motivo: Se corrige el calculo de la depreciacion fiscal, respecto de la nueva definicion entregada por usuarios

Modificado por: Alejandro Bolaños APH
Fecha: 27/01/2012
Motivo: Se corrige el calculo para el mes de enero
--->
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
	<cffunction name="AF_DepreciacionFiscalActivos" access="public" returntype="numeric" output="true">
		<!---Cálculo de la Depreciación Fiscal por el método de la categoría de cada activo. Calcula la depreciación Fiscal para todos los activos en estado activo,
		que no se han depreciado por completo, que no se han depreciado en el periodo y mes actual de los auxiliares, y que cumplan con los filtros 
		que se reciben como parámetros.
		--->
		<cfargument name="AGTPid" type="numeric" default="0" required="no"><!--- Id de Proceso, Si viene se asume que ya se creo el encabezado y se pasa directo al cálculo, se creo para calendarizar generaciones. --->
		<cfargument name="Ecodigo" type="numeric" default="0" required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" type="numeric" default="0" required="no"><!--- Código de Usuario (asp) --->
		<cfargument name="IPregistro" type="string" default="" required="no"><!--- IP de PC de Usuario --->
		<cfargument name="Conexion" type="string" default="" required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPdescripcion" type="string" default="Depreciacioon" required="no"><!--- Descripción de la transacción --->
		<cfargument name="FOcodigo" type="numeric" default="-1" required="no"><!--- Filtro por Oficina --->
		<cfargument name="FDcodigo" type="numeric" default="-1" required="no"><!--- Filtro por Departamento --->
		<cfargument name="FCFid" type="numeric" default="-1" required="no"><!--- Filtro por Centro  --->
		<cfargument name="FACcodigo" type="numeric" default="-1" required="no"><!--- Filtro por Categoria --->
		<cfargument name="FACid" type="numeric" default="-1" required="no"><!--- Filtro por Clase --->
		<cfargument name="FAFCcodigo" type="numeric" default="-1" required="no"><!--- Filtro por Tipo --->
		<cfargument name="debug" type="boolean" default="false" required="no"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="Periodo" type="numeric" default="0" required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" type="numeric" default="0" required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Programar" type="boolean" default="false" required="no"><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" type="date" default="#CreateDate(1900,01,01)#" required="no">
        <cfargument name="AplacaDesde" type="string" default="" required="no">
        <cfargument name="AplacaHasta" type="string" default="" required="no">
		
		<cfif Arguments.debug>
			<h2>AF_DepreciacionFiscalActivos</h2>
			<cfdump var="#Arguments#">
		</cfif>
	
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
				<cfif len(rsData.FOcodigo)><cfset Arguments.FOcodigo = rsData.FOcodigo></cfif>
				<cfif len(rsData.FDcodigo)><cfset Arguments.FDcodigo = rsData.FDcodigo></cfif>
				<cfif len(rsData.FCFid)><cfset Arguments.FCFid = rsData.FCFid></cfif>
				<cfif len(rsData.FACcodigo)><cfset Arguments.FACcodigo = rsData.FACcodigo></cfif>
				<cfif len(rsData.FACid)><cfset Arguments.FACid = rsData.FACid></cfif>
			</cfif>
		<cfelse>
			<!--- Cuando No Viene por Programación --->
			<cfset Arguments.Ecodigo = session.Ecodigo>
			<cfset Arguments.Conexion = session.dsn>
			<cfset Arguments.Usucodigo = session.Usucodigo>
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
						11,<!----- IDtrans--->
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
<!---====================Fórmula de la Depreciación Fiscal:=======================================
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
				<cfquery name="rsIndiceF" datasource="#arguments.conexion#">
                        select AFFindice, AFFperiodo, AFFMes from AFIndicesFiscales
                        where AFFperiodo = #rsPeriodo.value#
                        and AFFMes = #rsMes.value#
                        and Ecodigo = 1
                </cfquery>    
					
                    
					 <cf_dbfunction name="date_part"	args="YYYY,b.Afechainidep" returnvariable="periodoDep">
					 <cf_dbfunction name="date_part"	args="MM,b.Afechainidep"   returnvariable="mesDep">
					 
					
                    
					<cfquery name="rsCalculoDepLineaRecta" datasource="#arguments.conexion#">
						insert into ADTProceso
							(Aid, Ecodigo, AGTPid, IDtrans, CFid, TAfalta, 
							TAfechainidep, 
							TAvalrescate, 
							TAvutil, 
							TAsuperavit, 
							TAfechainirev,
							TAperiodo, 
							TAmes, 
							TAfecha,
							Usucodigo
							,TAmeses 		  <!--- Cantidad de Meses a Depreciar (TAmeses) --->                       	<!---16--->
							,TAmontolocadq 	  <!--- Valor de la adquisicion actualizado --->                           	<!---17---> 
							,TAmontooriadq 	                                                                           	<!---18--->
							 
                            ,TAmontolocmej 	  <!--- Valor de la mejora actualizado --->                                	<!---19--->
							,TAmontoorimej 	   																			<!---20--->
							
                            ,TAmontolocrev 	  <!---depreciacion del valor de revaluacion (TAmontolocrev) ---> 			<!---21--->
							,TAmontoorirev 	  <!---depreciacion del valor de revaluacion (TAmontoorirev) ---> 			<!---22--->
                           
							,TAmontodepadq    <!--- Valor de la depreciación de la adquisicion actualizado --->			<!---25---> 
							,TAmontodepmej    <!--- Valor de la depreciación de la mejora actualizado ---> 				<!---26--->
							,TAmontodeprev  																			<!---27--->

							,TAvaladq  																					<!---28--->
							,TAvalmej  																					<!---29--->
							,TAvalrev   																				<!---30--->
							
							,TAdepacumadq   																			<!---31--->
							,TAdepacummej    																			<!---32--->
							,TAdepacumrev    																			<!---33--->
							
							,Mcodigo             																		<!---34--->
							,TAtipocambio         																		<!---35--->
							)
						select 
                        	distinct a.Aid, 
							a.Ecodigo, 
							#idquery.identity# as AGTPid, 
							11 as IDtrans, 
							a.CFid, 
							<cf_dbfunction name="now"> as TAfalta, 
							b.Afechainidep as TAfechainidep, 
							b.Avalrescate as TAvalrescate, 
                            <!---==============================================================================================================================
							Vida Útil Fiscal (TAvutil)
							Es el valor de vida util, que se utilizara en el calculo de las Depreciaciones Fiscales, tanto para las adquisiciones (TAmontodepadqFiscal)
							como para las mejoras (TAmontodepmejFiscal)--->	
                            case 
                            	when (coalesce(ac.ACVidaUtilFiscal,0) = 0) then
                            		a.AFSvutiladq - (#PreserveSingleQuotes(CantidadMeses)# + 1)
                            
                           		else
                                	ac.ACVidaUtilFiscal - (#PreserveSingleQuotes(CantidadMeses)# + 1)
                            end as TAvutil, 
							0.00 as TAsuperavit, 
							b.Afechainirev as TAfechainirev,

							a.AFSperiodo as TAperiodo, a.AFSmes as TAmes,
							
                            #rsFechaAux.value# as TAfecha,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#"> as Usucodigo
							
							,0  as TAmeses   <!---16--->
							
							<!---==============================================================================================================================
							Valor de la adquisicion  --->	
							, a.AFSvaladq as TAmontolocadq <!---17--->
                            																					
							, 0 as TAmontooriadq   <!---18--->
							<!---==============================================================================================================================
							Valor de la mejora --->
                            ,a.AFSvalmej as TAmontolocmej  <!---19--->
							
							,0 as TAmontoorimej   <!---20---> 
							,0 as TAmontolocrev    <!---21---> 
							,0.00        <!---22--->
                            <!---==============================================================================================================================
							Valor de la depreciación --->
                       		<!---,(a.AFSvaladq / a.AFSvutiladq) * (#PreserveSingleQuotes(CantidadMeses)# + 1) as  TAmontodepadq <!---25
		</cfif>							--->--->
                            ,(case when a.AFSvaladq > ac.ACImporteMaximo and ac.ACid = 7 then ac.ACImporteMaximo else a.AFSvaladq end / a.AFSvutiladq) * (#PreserveSingleQuotes(CantidadMeses)# + 1) as  TAmontodepadq <!---25---> <!---==============================================================================================================================
							Valor de la depreciación de la mejora--->
							,(a.AFSvalmej / a.AFSvutiladq) * (#PreserveSingleQuotes(CantidadMeses)# + 1) as  TAmontodepmej   <!--- 26--->
							,0.00        	<!---27--->

							,AFSvaladq     	<!---28--->
							,AFSvalmej      <!---29--->
							,AFSvalrev      <!---30--->
							 
							,AFSdepacumadq  <!---31--->
							,AFSdepacummej  <!---32--->
							,AFSdepacumrev  <!---33--->
							
							,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#"> <!---34--->  ,1  <!---35--->                            
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
							#filtrocf#							<!---filtro por oficina / departamento--->
                            inner join AClasificacion ac
                            	  on ac.ACcodigo = c.ACcodigo
                                  and ac.Ecodigo = c.Ecodigo
                                  and ac.ACid = a.ACid
                                 
                            left outer join AFSaldosFiscales sf
                            	  on sf.AFSid = a.AFSid 
                                  and coalesce(sf.AFSsaldovutilfis,0) > 0    
                             
						where a.AFSvutiladq > 0 and
						<cfif isdefined("Arguments.AplacaDesde") and len(Arguments.AplacaDesde) and isdefined("Arguments.AplacaHasta") and len(Arguments.AplacaHasta)>
                            b.Aplaca between <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AplacaDesde#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AplacaHasta#">
						<cfelseif isdefined("Arguments.AplacaDesde") and len(Arguments.AplacaDesde)>
                            b.Aplaca > <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AplacaDesde#">
                        <cfelseif isdefined("Arguments.AplacaHasta") and len(Arguments.AplacaHasta)>
                            b.Aplaca < <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AplacaHasta#">
                        <cfelse> 
                            1=1
                        </cfif> 
                          and a.AFSdepreciable = 1				    <!---Clasificación depreciable. Se asigna en la Adquisición, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional--->
						  and a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
						  <!---and (a.AFSsaldovutiladq > 0 or a.AFSsaldovutilrev > 0)--->
                          <cf_dbfunction name="to_char" args="a.AFSperiodo*10000+a.AFSmes*100+01" returnVariable="LvarPer">
                          <cf_dbfunction name="to_date" YMD="true" args="#LvarPer#" returnVariable="LvarFecha">
                          and a.AFSperiodo = <cf_jdbcquery_param value="#rsPeriodo.value#" cfsqltype="cf_sql_integer">
						  and a.AFSmes = #rsMes.value#             
                          and coalesce(<cf_dbfunction name="datedifftot" args="b.Afechaaltaadq°#LvarFecha#°mm" delimiters="°">,0) > 0
                          and not exists(
                          				Select 1 
                                        from AFSaldosFiscales aff 
                                        where aff.AFSid = a.AFSid       <!---Esto no es necesario--->
                                        and a.AFSperiodo = <cf_jdbcquery_param value="#rsPeriodo.value#" cfsqltype="cf_sql_integer">
						  				and a.AFSmes = #rsMes.value# 
                                        and a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                                        )
                          
						#filtroa#									<!---filtro por centro funcional--->
                            and not exists(
								select 1 
								from TransaccionesActivos ta 
								where ta.Aid = a.Aid
								  and ta.IDtrans = 11
								  and ta.TAperiodo = #rsPeriodo.value#
								  and ta.TAmes     = #rsMes.value#
                                  and ta.Ecodigo = a.Ecodigo
							)
                             and not exists(
								select 1 
								from TransaccionesActivos ta 
								where ta.Aid = a.Aid
								  and ta.IDtrans = 12
								  and ta.Ecodigo = a.Ecodigo
							)
                            
						  and not exists(
								select 1 
								from ADTProceso tp 
								where tp.Aid = a.Aid
								  and tp.IDtrans = 11
								  and tp.TAperiodo = #rsPeriodo.value#
								  and tp.TAmes     = #rsMes.value#
                                  and tp.Ecodigo = a.Ecodigo
							) 
                           and not exists(
								select 1 
								from ADTProceso tp 
								where tp.Aid = a.Aid
								  and tp.IDtrans = 12
								  and tp.Ecodigo = a.Ecodigo
							)
                                
					</cfquery>

				<cfquery name="rsCalculoActualizaADQ" datasource="#arguments.conexion#">
<!---==============================================================================================================================
							En caso de que el valor de adquisicion sea mayor que el importe maximo fiscal, se utiliza el importe maximo fiscal
							definido --->	
                    
                    UPDATE ADTProceso
                    set TAmontolocadq = ac.ACImporteMaximo
                         from ADTProceso ap 
                         inner join Activos b 
								on b.Ecodigo = ap.Ecodigo
								and b.Aid = ap.Aid
								and b.Astatus = 0 
                         inner join AFSaldos a 
								 on a.Aid = b.Aid
                                and a.AFSperiodo = ap.TAperiodo
                                and a.AFSmes = ap.TAmes
								
                         inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACmetododep = 1 				
							
                         inner join AClasificacion ac
                            	  on ac.ACcodigo = c.ACcodigo
                                  and ac.Ecodigo = c.Ecodigo
                                  and ac.ACid = a.ACid
                                 
                         where ap.IDtrans = 11 
                         and ap.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                         and ap.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#idquery.identity#">
                         and b.Aid = ap.Aid  
                         and ac.ACImporteMaximo > 0
                         and ap.TAmontolocadq > ac.ACImporteMaximo
                    </cfquery>
                                       	
                    <cfquery name="rsCalculoActualizaADQ" datasource="#arguments.conexion#">
<!---==============================================================================================================================
							Valor de la adquisicion actualizado (TAmontolocadq)
							Es el valor de adquisicion multiplicado por la division resultante entre el indice Fiscal del mes y periodo auxiliar entre el 
							indice Fiscal del mes y periodo de adquisicion.
							--->	
                    
                    UPDATE ADTProceso
                    set TAmontolocadq = 
                    								<!--- Activos Irregulares adquiridos en el mismo año en que se calcula la
													depreciacion --->													
                    								coalesce((
                                            case 
                                            	when ((<cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq">) = ap.TAperiodo) then
													<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq">
                                                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq">
                                                    <cf_dbfunction name="to_number"	args="#preserveSingleQuotes(LvarMesAdq)# + (ap.TAmes-#preserveSingleQuotes(LvarMesAdq)#)/2" isInteger="false" dec="0" returnvariable="LvarMesInd">
                                            		case
                                                    	when ap.TAmes - (<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq">) > 0
                                                        then ap.TAmontolocadq * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)#),-1))" isInteger="false" dec="4" >)
                                                        when ap.TAmes - (<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq">) = 0
                                                        then ap.TAmontolocadq * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)# + 1) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)#),-1))" isInteger="false" dec="4" >)
                                                        else 
                                                        	0.0
                                                		end
												when 
                                                 <cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq3">
                                                 <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq3">
                                                 <cf_dbfunction name="dateaddm" args="b.Avutil, b.Afechainidep" returnvariable="LvarFechaFin">
                                                 <cf_dbfunction name="to_number"	args="case when (ap.TAmes/2) < 1 then 1 else ap.TAmes/2 end" isInteger="false" dec="0" returnvariable="LvarMesInd2">
                                                 
                                                 (left(convert(char(8),#LvarFechaFin#,112),4) =  <cf_dbfunction name="to_char"	args="ap.TAperiodo">) then
                                                 	case
                                                    	when  #rsFechaAux.value# <= (#LvarFechaFin#)
                                                        then ap.TAmontolocadq * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd2)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq3)# and AFFMes = #preserveSingleQuotes(LvarMesAdq3)#),-1))" isInteger="false" dec="4" >)
                                                        else 
                                                        	0.0
                                                		end
                                                else
													<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq2">
                                                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq2">
                                                    <cf_dbfunction name="to_number"	args="case when (ap.TAmes/2) < 1 then 1 else ap.TAmes/2 end" isInteger="false" dec="0" returnvariable="LvarMesInd3">
                                                    case
														when (ap.TAmes < 6) then
															ap.TAmontolocadq * (<cf_dbfunction name="to_number"	args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd3)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq2)# and AFFMes = (#preserveSingleQuotes(LvarMesAdq2)#)),-1))" isInteger="false" dec="4" >) 
															
														when (ap.TAmes >= 6) then
															ap.TAmontolocadq * (<cf_dbfunction name="to_number"	args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = 6)  /  coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq2)# and AFFMes = (#preserveSingleQuotes(LvarMesAdq2)#)),-1))" isInteger="false" dec="4" >)
                                                           	
														else 0.0 
													end	
											end),0)
                         from ADTProceso ap 
                         inner join Activos b 
								on b.Ecodigo = ap.Ecodigo
								and b.Aid = ap.Aid
								and b.Astatus = 0 
                         inner join AFSaldos a 
								 on a.Aid = b.Aid
                                and a.AFSperiodo = ap.TAperiodo
                                and a.AFSmes = ap.TAmes
								
                         inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACmetododep = 1 				
							
                         inner join AClasificacion ac
                            	  on ac.ACcodigo = c.ACcodigo
                                  and ac.Ecodigo = c.Ecodigo
                                  and ac.ACid = a.ACid
                                 
                         left outer join AFSaldosFiscales sf
                            	  on sf.AFSid = a.AFSid     
                             
                         where ap.IDtrans = 11 
                         and ap.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                         and ap.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#idquery.identity#">
                         and b.Aid = ap.Aid  
                    </cfquery>
                    
                    <cfquery name="rsCalculoActualizaDEPADQ" datasource="#arguments.conexion#">
<!---==============================================================================================================================
							Valor de la depreciación de la adquisicion actualizado (TAmontodepadq)
							Es el valor resultante de la division de el indice fiscal del mes y periodo auxiliar entre el indice fiscal del mes y periodo de 
							adquisicion por la depreciacion acumulada de adquisicion.
							En caso de que la depreciacion acumulada de adquisicion sea 0, se calcula la misma por medio de una line recta, tomando en cuenta
							el valor de adquisicion entre la vida util por los meses que han pasado desde el inicio de depreciacion. --->                    
                    UPDATE ADTProceso
                    set TAmontodepadq = 
                    								<!--- Activos Irregulares adquiridos en el mismo año en que se calcula la
													depreciacion --->													
                    								coalesce((
                                            case 
                                            	when ((<cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq">) = ap.TAperiodo) then
													<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq">
                                                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq">
                                                    <cf_dbfunction name="to_number"	args="#preserveSingleQuotes(LvarMesAdq)# + (ap.TAmes-#preserveSingleQuotes(LvarMesAdq)#)/2" isInteger="false" dec="0" returnvariable="LvarMesInd">
                                            		case
                                                    	when ap.TAmes - (<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq">) > 0
                                                        then ap.TAmontodepadq * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)#),-1))" isInteger="false" dec="4" >)
                                                        when ap.TAmes - (<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq">) = 0
                                                        then ap.TAmontodepadq * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)# + 1) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)#),-1))" isInteger="false" dec="4" >)
                                                        else 
                                                        	0.0
                                                		end
												when 
                                                 <cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq3">
                                                 <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq3">
                                                 <cf_dbfunction name="dateaddm" args="b.Avutil, b.Afechainidep" returnvariable="LvarFechaFin">
                                                 <cf_dbfunction name="to_number"	args="case when (ap.TAmes/2) < 1 then 1 else ap.TAmes/2 end" isInteger="false" dec="0" returnvariable="LvarMesInd2">
                                                 
                                                 (left(convert(char(8),#LvarFechaFin#,112),4) =  <cf_dbfunction name="to_char"	args="ap.TAperiodo">) then
                                                 	case
                                                    	when  #rsFechaAux.value# <= (#LvarFechaFin#)
                                                        then ap.TAmontodepadq * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd2)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq3)# and AFFMes = #preserveSingleQuotes(LvarMesAdq3)#),-1))" isInteger="false" dec="4" >)
                                                        else 
                                                        	0.0
                                                		end
                                                else
													<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq2">
                                                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq2">
                                                    <cf_dbfunction name="to_number"	args="case when (ap.TAmes/2) < 1 then 1 else ap.TAmes/2 end" isInteger="false" dec="0" returnvariable="LvarMesInd3">
                                                    case
														when (ap.TAmes < 6) then
															ap.TAmontodepadq * (<cf_dbfunction name="to_number"	args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd3)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq2)# and AFFMes = (#preserveSingleQuotes(LvarMesAdq2)#)),-1))" isInteger="false" dec="4" >) 
															
														when (ap.TAmes >= 6) then
															ap.TAmontodepadq * (<cf_dbfunction name="to_number"	args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = 6)  /  coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq2)# and AFFMes = (#preserveSingleQuotes(LvarMesAdq2)#)),-1))" isInteger="false" dec="4" >)
                                                           	
														else 0.0 
													end	
											end),0)
                         from ADTProceso ap 
                         inner join Activos b 
								on b.Ecodigo = ap.Ecodigo
								and b.Aid = ap.Aid
								and b.Astatus = 0 
                         inner join AFSaldos a 
								 on a.Aid = b.Aid
                                and a.AFSperiodo = ap.TAperiodo
                                and a.AFSmes = ap.TAmes
								
                         inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACmetododep = 1 				
							
                         inner join AClasificacion ac
                            	  on ac.ACcodigo = c.ACcodigo
                                  and ac.Ecodigo = c.Ecodigo
                                  and ac.ACid = a.ACid
                                 
                         left outer join AFSaldosFiscales sf
                            	  on sf.AFSid = a.AFSid     
                             
                         where ap.IDtrans = 11 
                         and ap.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                         and ap.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#idquery.identity#">
                         and b.Aid = ap.Aid  
                    </cfquery>
                    
                    <cfquery name="rsCalculoActualizaMEJ" datasource="#arguments.conexion#">
<!---==============================================================================================================================
							Valor de la mejora actualizado (TAmontolocmej)
							Es el valor de la mejora multiplicado por la division resultante entre el indice Fiscal del mes y periodo auxiliar entre el 
							indice Fiscal del mes y periodo de adquisicion. --->                    
                    UPDATE ADTProceso
                    set TAmontolocmej = 
                    								<!--- Activos Irregulares adquiridos en el mismo año en que se calcula la
													depreciacion --->													
                    								coalesce((
                                            case 
                                            	when ((<cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq">) = ap.TAperiodo) then
													<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq">
                                                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq">
                                                    <cf_dbfunction name="to_number"	args="#preserveSingleQuotes(LvarMesAdq)# + (ap.TAmes-#preserveSingleQuotes(LvarMesAdq)#)/2" isInteger="false" dec="0" returnvariable="LvarMesInd">
                                            		case
                                                    	when ap.TAmes - (<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq">) > 0
                                                        then ap.TAmontolocmej * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)#),-1))" isInteger="false" dec="4" >)
                                                        when ap.TAmes - (<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq">) = 0
                                                        then ap.TAmontolocmej * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)# + 1) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)#),-1))" isInteger="false" dec="4" >)
                                                        else 
                                                        	0.0
                                                		end
												when 
                                                 <cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq3">
                                                 <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq3">
                                                 <cf_dbfunction name="dateaddm" args="b.Avutil, b.Afechainidep" returnvariable="LvarFechaFin">
                                                 <cf_dbfunction name="to_number"	args="case when (ap.TAmes/2) < 1 then 1 else ap.TAmes/2 end" isInteger="false" dec="0" returnvariable="LvarMesInd2">
                                                 
                                                 (left(convert(char(8),#LvarFechaFin#,112),4) =  <cf_dbfunction name="to_char"	args="ap.TAperiodo">) then
                                                 	case
                                                    	when  #rsFechaAux.value# <= (#LvarFechaFin#)
                                                        then ap.TAmontolocmej * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd2)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq3)# and AFFMes = #preserveSingleQuotes(LvarMesAdq3)#),-1))" isInteger="false" dec="4" >)
                                                        else 
                                                        	0.0
                                                		end
                                                else
													<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq2">
                                                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq2">
                                                    <cf_dbfunction name="to_number"	args="case when (ap.TAmes/2) < 1 then 1 else ap.TAmes/2 end" isInteger="false" dec="0" returnvariable="LvarMesInd3">
                                                    case
														when (ap.TAmes < 6) then
															ap.TAmontolocmej * (<cf_dbfunction name="to_number"	args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd3)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq2)# and AFFMes = (#preserveSingleQuotes(LvarMesAdq2)#)),-1))" isInteger="false" dec="4" >) 
															
														when (ap.TAmes >= 6) then
															ap.TAmontolocmej * (<cf_dbfunction name="to_number"	args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = 6)  /  coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq2)# and AFFMes = (#preserveSingleQuotes(LvarMesAdq2)#)),-1))" isInteger="false" dec="4" >)
                                                           	
														else 0.0 
													end	
											end),0)
                         from ADTProceso ap 
                         inner join Activos b 
								on b.Ecodigo = ap.Ecodigo
								and b.Aid = ap.Aid
								and b.Astatus = 0 
                         inner join AFSaldos a 
								 on a.Aid = b.Aid
                                and a.AFSperiodo = ap.TAperiodo
                                and a.AFSmes = ap.TAmes
								
                         inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACmetododep = 1 				
							
                         inner join AClasificacion ac
                            	  on ac.ACcodigo = c.ACcodigo
                                  and ac.Ecodigo = c.Ecodigo
                                  and ac.ACid = a.ACid
                                 
                         left outer join AFSaldosFiscales sf
                            	  on sf.AFSid = a.AFSid     
                             
                         where ap.IDtrans = 11 
                         and ap.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                         and ap.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#idquery.identity#">
                         and b.Aid = ap.Aid  
                    </cfquery>
                    
                    <cfquery name="rsCalculoActualizaDEPMEJ" datasource="#arguments.conexion#">
<!---==============================================================================================================================
							Valor de la depreciación de la mejora actualizado (TAmontodepmej)
							Es el valor resultante de la division de el indice fiscal del mes y periodo auxiliar entre el indice fiscal del mes y periodo de 
							adquisicion por la depreciacion acumulada de las mejoras.
							En caso de que la depreciacion acumulada de las mejoras sea 0, se calcula la misma por medio de una line recta, tomando en cuenta
							el valor de las mejoras entre la vida util por los meses que han pasado desde el inicio de depreciacion. --->
                    UPDATE ADTProceso
                    set TAmontodepmej = 
                    								<!--- Activos Irregulares adquiridos en el mismo año en que se calcula la
													depreciacion --->													
                    								coalesce((
                                            case 
                                            	when ((<cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq">) = ap.TAperiodo) then
													<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq">
                                                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq">
                                                    <cf_dbfunction name="to_number"	args="#preserveSingleQuotes(LvarMesAdq)# + (ap.TAmes-#preserveSingleQuotes(LvarMesAdq)#)/2" isInteger="false" dec="0" returnvariable="LvarMesInd">
                                            		case
                                                    	when ap.TAmes - (<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq">) > 0
                                                        then ap.TAmontodepmej * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)#),-1))" isInteger="false" dec="4" >)
                                                        when ap.TAmes - (<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq">) = 0
                                                        then ap.TAmontodepmej * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)# + 1) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesAdq)#),-1))" isInteger="false" dec="4" >)
                                                        else 
                                                        	0.0
                                                		end
												when 
                                                 <cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq3">
                                                 <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq3">
                                                 <cf_dbfunction name="dateaddm" args="b.Avutil, b.Afechainidep" returnvariable="LvarFechaFin">
                                                 <cf_dbfunction name="to_number"	args="case when (ap.TAmes/2) < 1 then 1 else ap.TAmes/2 end" isInteger="false" dec="0" returnvariable="LvarMesInd2">
                                                 
                                                 (left(convert(char(8),#LvarFechaFin#,112),4) =  <cf_dbfunction name="to_char"	args="ap.TAperiodo">) then
                                                 	case
                                                    	when  #rsFechaAux.value# <= (#LvarFechaFin#)
                                                        then ap.TAmontodepmej * (<cf_dbfunction name="to_number" args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd2)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq3)# and AFFMes = #preserveSingleQuotes(LvarMesAdq3)#),-1))" isInteger="false" dec="4" >)
                                                        else 
                                                        	0.0
                                                		end
                                                else
													<cf_dbfunction name="date_part" args="MM,b.Afechaaltaadq" returnvariable="LvarMesAdq2">
                                                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="LvarPeriodoAdq2">
                                                    <cf_dbfunction name="to_number"	args="case when (ap.TAmes/2) < 1 then 1 else ap.TAmes/2 end" isInteger="false" dec="0" returnvariable="LvarMesInd3">
                                                    case
														when (ap.TAmes < 6) then
															ap.TAmontodepmej * (<cf_dbfunction name="to_number"	args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = #preserveSingleQuotes(LvarMesInd3)#) / coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq2)# and AFFMes = (#preserveSingleQuotes(LvarMesAdq2)#)),-1))" isInteger="false" dec="4" >) 
															
														when (ap.TAmes >= 6) then
															ap.TAmontodepmej * (<cf_dbfunction name="to_number"	args="((Select AFFindice from AFIndicesFiscales where AFFperiodo = ap.TAperiodo and AFFMes = 6)  /  coalesce((Select AFFindice from AFIndicesFiscales where AFFperiodo = #preserveSingleQuotes(LvarPeriodoAdq2)# and AFFMes = (#preserveSingleQuotes(LvarMesAdq2)#)),-1))" isInteger="false" dec="4" >)
                                                           	
														else 0.0 
													end	
											end),0)
                         from ADTProceso ap 
                         inner join Activos b 
								on b.Ecodigo = ap.Ecodigo
								and b.Aid = ap.Aid
								and b.Astatus = 0 
                         inner join AFSaldos a 
								 on a.Aid = b.Aid
                                and a.AFSperiodo = ap.TAperiodo
                                and a.AFSmes = ap.TAmes
								
                         inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACmetododep = 1 				
							
                         inner join AClasificacion ac
                            	  on ac.ACcodigo = c.ACcodigo
                                  and ac.Ecodigo = c.Ecodigo
                                  and ac.ACid = a.ACid
                                 
                         left outer join AFSaldosFiscales sf
                            	  on sf.AFSid = a.AFSid     
                             
                         where ap.IDtrans = 11 
                         and ap.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                         and ap.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#idquery.identity#">
                         and b.Aid = ap.Aid  
                    </cfquery>

                    <cfquery name="rsDeleteVU" datasource="#arguments.conexion#">
                        Delete 
                        from ADTProceso  
                        where IDtrans = 11 
                            and AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#idquery.identity#">
                            and (TAvutil <= 0 or TAmontolocadq < 0)
                    </cfquery>

                   	<cfquery name="rsCalculoDepFiAd" datasource="#arguments.conexion#">
                        UPDATE ADTProceso
                        set TAmontodepadqFiscal = (TAmontolocadq - TAmontodepadq) / (TAvutil)
                         where IDtrans = 11 
                         and Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                         and AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#idquery.identity#">
                         and TAvutil > 0
                    </cfquery>
                    
                    <cfquery name="rsCalculoDepFiMej" datasource="#arguments.conexion#">
                        UPDATE ADTProceso
                        set TAmontodepmejFiscal = (TAmontolocmej - TAmontodepmej) / (TAvutil)
                         where IDtrans = 11  
                         and Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                         and AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#idquery.identity#">
                         and TAvutil > 0
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
				
					update ADTProceso
					set 
						TAmontodepadqFiscal = case when TAmontodepadqFiscal < 0 then 0.00 else TAmontodepadqFiscal end,
						TAmontodepmejFiscal = case when TAmontodepmejFiscal < 0 then 0.00 else TAmontodepmejFiscal end
					where IDtrans = 11
					  and ( TAmontodepadqFiscal < 0 or TAmontodepmejFiscal < 0 )
					  
				</cfquery>				

				<!--- 
					Eliminar los registros que generaron <= 0 en TODOS los montos
				--->

				<cfquery datasource="#arguments.conexion#">
					delete from ADTProceso
					where AGTPid = #idquery.identity#
					  and TAmontolocadq       <= 0 
					  and TAmontolocmej       <= 0 
					  and TAmontolocrev       <= 0
                      and TAmontodepadqFiscal <= 0 
                      and TAmontodepmejFiscal <= 0
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

