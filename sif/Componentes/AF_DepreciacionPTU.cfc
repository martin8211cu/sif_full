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
	<cffunction name="AF_DepreciacionPTU" access="public" returntype="numeric" output="true">
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
						13,<!----- IDtrans--->
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
<!---====================Fórmula de la Depreciación para efecto de PTU:=======================================
	
	Variables:
				Monto Original de la inversión  = Valor de adquisicion del acitvo
				Porcentaje maximo de deduccion 	= Porcentaje de deduccion PTU permitidos.
					
	Fórmula:	 Monto Original de la inversión * Porcentaje maximo de deduccion
								
==========================================================================================================--->

					<cf_dbfunction name="datediff" args="b.Afechaaltaadq,#rsFechaAux.value#,YYYY" returnvariable= "CantidadMeses">
					<cf_dbfunction name="date_part"	args="YYYY,b.Afechainidep" returnvariable="periodoDep">
					<cf_dbfunction name="date_part"	args="MM,b.Afechainidep"   returnvariable="mesDep">
                    <cf_dbfunction name="date_part" args="YYYY,b.Afechaaltaadq" returnvariable="periodoAdq"> 
                    <cf_dbfunction name="date_part"	args="MM,b.Afechaaltaadq"   returnvariable="mesAdq">
                    <cf_dbfunction name="to_char" args="a.AFSperiodo*10000+a.AFSmes*100+1" returnVariable="LvarToChar">
                    <cf_dbfunction name="to_date" YMD args="#LvarToChar#" returnVariable="LvarToDate">
                    <cf_dbfunction name="datediff" args="b.Afechaaltaadq°#LvarToDate#°yyyy" delimiters="°" returnVariable="LvarDateDiffTot">
                    
					<cfset saldoPTU = "coalesce((select TAmontooriadq from TransaccionesActivos afi 
                            			where afi.Ecodigo = b.Ecodigo
        		                        and afi.TAperiodo = (a.AFSperiodo - 1)
                                        and afi.Aid = b.Aid
                		                and afi.IDtrans = 13),0)">
                                        
                    <cfset existePTU = "(select count(1) from TransaccionesActivos afi 
                            			where afi.Ecodigo = b.Ecodigo
        		                        and afi.TAperiodo = (a.AFSperiodo - 1)
                                        and afi.Aid = b.Aid
                		                and afi.IDtrans = 13)">
                    
                    <cfset AFsaldos = "(select count(1) from AFSaldos afs 
                            			where afs.Ecodigo = b.Ecodigo
        		                        and afs.AFSperiodo = #preserveSingleQuotes(periodoAdq)# 
										and afs.AFSmes = #preserveSingleQuotes(mesAdq)#
                                        and afs.Aid = b.Aid)">
                                        
					<cfset sumaPTU = "coalesce((select SUM(TAmontolocadq) from TransaccionesActivos afi 
                            			where afi.Ecodigo = b.Ecodigo
        		                        and afi.Aid = b.Aid
                		                and afi.IDtrans = 13),0)">
                                        
                    <cfset PTUCTA = "((a.AFSvaladq + coalesce(a.AFSvalmej,0)) * (
																						case 
																						when (((coalesce(ac.ACPorcentajePTU,0)/100) * (#PreserveSingleQuotes(LvarDateDiffTot)# +1)) > 1) then
																							1
																						else 
																							(coalesce(ac.ACPorcentajePTU,0)/100) * (#PreserveSingleQuotes(LvarDateDiffTot)#+1)
																						end
											 										)) - (#sumaPTU#)">
                                        
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
							13 as IDtrans, 
							a.CFid, 
							<cf_dbfunction name="now"> as TAfalta, 
							b.Afechainidep as TAfechainidep, 
							b.Avalrescate as TAvalrescate, 
                            0 as TAvutil, 
							0.00 as TAsuperavit, 
							b.Afechainirev as TAfechainirev,

							a.AFSperiodo as TAperiodo, 
                            a.AFSmes as TAmes,
							
                            #rsFechaAux.value# as TAfecha,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#"> as Usucodigo
							
							,0  as TAmeses   <!---16--->
							
							<!---==============================================================================================================================
							Disminución de la base para efecto del cálculo de PTU (TAmontolocadq)
							Es el monto original de la inversion (valor de adquisicion) por el porcentaje maximo de deduccion anual, en caso de que el saldo pendiente para
							disminuir menor que el calculo anterior, se utiliza el saldo que tenemos, de lo contrario se realiza el calculo --->	
							,case 
                            	when (#existePTU# > 0) then 
                                	#PTUCTA#
                                else
                                	case 
                                    	when (#AFsaldos# > 0) and (#preserveSingleQuotes(periodoAdq)# = (a.AFSperiodo)) then
                                        	(a.AFSvaladq + coalesce(a.AFSvalmej,0)) * (coalesce(ac.ACPorcentajePTU,0)/100)
                                    	else
                                        	0 
                                    end
                            end as TAmontolocadq <!---17--->
                            
                            <!---==============================================================================================================================
							Saldo pendiente de disminuir para PTU (TAmontolocadq)
							Es el saldo que queda pendiente a disminur.  --->																					
							,case 
                            	when (#existePTU# > 0) then 
                                	(a.AFSvaladq + coalesce(a.AFSvalmej,0)) - (#PTUCTA# + #sumaPTU#) 
                                else
                                	case 
                                    	when (#AFsaldos# > 0) and (#preserveSingleQuotes(periodoAdq)# = (a.AFSperiodo)) then
                                        	(a.AFSvaladq + coalesce(a.AFSvalmej,0)) - ((a.AFSvaladq + coalesce(a.AFSvalmej,0)) * (coalesce(ac.ACPorcentajePTU,0)/100))
                                    	else
                                        	0
                                    end
                            end as TAmontooriadq   <!---18--->
							<!---==============================================================================================================================
							Porcentaje máximo de deducción anual  (TAmontolocmej)
							Es el porcentaje de deduccion anual permitido por la ley de ISR --->
                            ,case
                                when (coalesce(ac.ACPorcentajePTU,0) * (#PreserveSingleQuotes(LvarDateDiffTot)#+1)) > 100 then
                                	case
                                    	when (100 - ((coalesce(ac.ACPorcentajePTU,0) * (#PreserveSingleQuotes(LvarDateDiffTot)#+1)) - (coalesce(ac.ACPorcentajePTU,0))) < 0) then
                                        	0
                                        else
                                        	100 - ((coalesce(ac.ACPorcentajePTU,0) * (#PreserveSingleQuotes(LvarDateDiffTot)#+1)) - (coalesce(ac.ACPorcentajePTU,0)))
                                    end
                                else 
                                	coalesce(ac.ACPorcentajePTU,0)
                            end as TAmontolocmej  <!---19--->
							<!---==============================================================================================================================
							Saldo anterior de PTU  (TAmontoorimej)
							Es el saldo que habia anteriormente antes de aplicarle la rebaja del cálculo PTU --->
							,case 
                            	when (#saldoPTU# > 0 and #existePTU# > 0) then 
                                	#saldoPTU#
                                when (#saldoPTU# = 0 and #existePTU# > 0) then 
                                	(a.AFSvaladq + coalesce(a.AFSvalmej,0)) - #sumaPTU#
                                else
                                	case 
                                    	when (#AFsaldos# > 0) and (#preserveSingleQuotes(periodoAdq)# = (a.AFSperiodo)) then
                                        	(a.AFSvaladq + coalesce(a.AFSvalmej,0)) 
                                    	else
                                        	0
                                    end
                            end as TAmontoorimej   <!---20---> 
							,0.00 as TAmontolocrev    <!---21---> 
							,0.00        <!---22--->
                            <!---==============================================================================================================================
							Valor de la depreciación de la adquisicion actualizado (TAmontodepadq)
							Es el valor resultante de la division de el indice fiscal del mes y periodo auxiliar entre el indice fiscal del mes y periodo de 
							adquisicion por la depreciacion acumulada de adquisicion.
							En caso de que la depreciacion acumulada de adquisicion sea 0, se calcula la misma por medio de una line recta, tomando en cuenta
							el valor de adquisicion entre la vida util por los meses que han pasado desde el inicio de depreciacion. --->
                       		,0.00 as  TAmontodepadq <!---25--->
                            <!---==============================================================================================================================
							Valor de la depreciación de la mejora actualizado (TAmontodepmej)
							Es el valor resultante de la division de el indice fiscal del mes y periodo auxiliar entre el indice fiscal del mes y periodo de 
							adquisicion por la depreciacion acumulada de las mejoras.
							En caso de que la depreciacion acumulada de las mejoras sea 0, se calcula la misma por medio de una line recta, tomando en cuenta
							el valor de las mejoras entre la vida util por los meses que han pasado desde el inicio de depreciacion. --->
							,0 as  TAmontodepmej   <!--- 26--->
							,0.00        	<!---27--->

							,(a.AFSvaladq + coalesce(a.AFSvalmej,0)) as TAvaladq     	<!---28--->
							,AFSvalmej      <!---29--->
							,AFSvalrev      <!---30--->
							 
							,AFSdepacumadq  <!---31--->
							,AFSdepacummej  <!---32--->
							,AFSdepacumrev  <!---33--->
							
							,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#"> <!---34--->  ,1  <!---35--->                            
 						from Activos b
                        	inner join AFSaldos a
                              on a.Aid = b.Aid
                            	and a.AFSperiodo = (#rsPeriodo.value#-1)
                            	and a.AFSmes = case 
                                					when (a.AFSperiodo = #rsPeriodo.value#) then 
                                                    	<cf_jdbcquery_param value="#rsMes.value#" cfsqltype="cf_sql_integer">
                                                    else 
                                                    	<cf_jdbcquery_param value="12" cfsqltype="cf_sql_integer">
                                                    end
                            	and a.Ecodigo = b.Ecodigo
                        		
							#filtrob#							<!---filtro por categoria / clase--->
							inner join ACategoria c 
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
							#filtrocf#							<!---filtro por oficina / departamento--->
                            inner join AClasificacion ac
                            	  on ac.ACcodigo = c.ACcodigo
                                  and ac.Ecodigo = c.Ecodigo
                                  and ac.ACid = a.ACid
                             
						where a.AFSdepreciable = 1				    <!---Clasificación depreciable. Se asigna en la Adquisición, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional--->
							and b.Astatus = 0 					<!---estado activo--->
							and <cf_dbfunction name="to_date00" args="b.Afechaaltaadq"> < <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">
                            and a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
						 	
                            #filtroa#									<!---filtro por centro funcional--->
                            and not exists(
								select 1 
								from TransaccionesActivos ta 
								where ta.Aid = b.Aid
								  and ta.IDtrans = 13
								  and ta.TAperiodo = (#rsPeriodo.value#-1)
								  and ta.Ecodigo = b.Ecodigo
							)
                            
                            and not exists(
								select 1 
								from TransaccionesActivos tr 
								where tr.Aid = b.Aid
								  and tr.IDtrans = 13
								  and tr.Ecodigo = b.Ecodigo
                                  and tr.TAmontolocadq  = 0
							)
                            
						  	and not exists(
								select 1 
								from ADTProceso tp 
								where tp.Aid = b.Aid
								  and tp.IDtrans = 13
								  and tp.Ecodigo = b.Ecodigo
							) 
                            
                            and exists(
								select 1 
								from AFSaldos afss 
								where afss.Aid = b.Aid
								  and afss.AFSperiodo = <cf_jdbcquery_param value="#rsPeriodo.value#" cfsqltype="cf_sql_integer">
                                  and afss.AFSmes = #rsMes.value# 
								  and afss.Ecodigo = b.Ecodigo
							)
					</cfquery>
                   
                <!--- 
					Eliminar los registros que generaron <= 0 en la disminución de la base para efecto del cálculo de PTU (TAmontolocadq, TAmontooriadq, TAmontoorimej)
				--->

				<cfquery name="rsDeletePTU" datasource="#arguments.conexion#">
					delete from ADTProceso
					where AGTPid = #idquery.identity#
					  and TAmontolocadq = 0 
                      and TAmontooriadq = 0 
                      and TAmontoorimej = 0 
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

