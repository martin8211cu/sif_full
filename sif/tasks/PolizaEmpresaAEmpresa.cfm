<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Inicio. 

Las polizas se van a tomar de una empresa y oficina en especifico, y seran transferidas con
una empresa especifica. Las polizas seran transferidas por medio de
la tarea programada "TransferenciaPoliza_EmpresaAEmpresa", la tarea esta dada de alta en el archivo
schedule.cfm, por default esta tarea viene desactivada.

Las polizas se transfieren de las tablas HEContables y HDContables a EContables y DContables.
El campo que se utiliza para saber si una poliza debe o no ser transferida es PolizaTransferida
que se encuentra en la tabla HEContables.

--->

<!--- Tags para la traduccion --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloPagina" Default= "Bit&aacute;cora de P&oacute;lizas" XmlFile="BitacoraPolizasTransferidas.xml" returnvariable="LB_TituloPagina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloTabla" Default= "P&oacute;lizas Transferidas" XmlFile="BitacoraPolizasTransferidas.xml" returnvariable="LB_TituloTabla"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Columna1" Default= "P&oacute;liza" XmlFile="BitacoraPolizasTransferidas.xml" returnvariable="LB_Columna1"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Columna2" Default= "Estatus" XmlFile="BitacoraPolizasTransferidas.xml" returnvariable="LB_Columna2"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Columna3" Default= "Fecha de transferencia" XmlFile="BitacoraPolizasTransferidas.xml" returnvariable="LB_Columna3"/>

<!--- Origen de las polizas --->
<cfset EmpresaOrigen  = 15>
<cfset OficinaOrigen  = 3>
<!--- Destino de las polizas --->
<cfset EmpresaDestino = 27>
<!--- Estatus de las polizas, 0 - No transferida / 1 - Transferida / 2,3,4,5 - Error al procesar --->
<cfset NoTransferida = 0>
<cfset Transferida   = 1>
<cfset ErrorCuenta  = 2>
<cfset ErrorMoneda  = 3>
<cfset ErrorTipoDeCambio = 4>
<cfset ErrorGeneral  = 5>
<!--- Datasources --->
<cfset DSource = 'minisifext'>
<cfset DSource2 = 'sifinterfaces'>
<!--- Usuarios --->
<cfset varEcodigoSDC= getEcodigoSDC(EmpresaDestino)>
<cfset varCEcodigo 	= getCEcodigo(EmpresaDestino)>

<!--- Encontrar las polizas que aun no han sido transferidas --->
<cfquery name="rsExistencia" datasource="#DSource#">
	select he.IDcontable as IDcontable
	from HEContables he
	inner join HDContables hd
		on  hd.Ecodigo    = he.Ecodigo
		and hd.IDcontable = he.IDcontable
	where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
	and   hd.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#OficinaOrigen#"> <!--- Traer todo lo que haga referencia a la oficina MEX--->
	and not he.PolizaTransferida = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Transferida#"><!--- Procesar las polizas hasta que pasen --->
	and not he.ECtipo = 1  <!--- Excluye polizas de Cierre de Periodo Fiscal ---> 
	and not he.ECtipo = 11 <!--- Excluye polizas de Cierre de Periodo Corporativo --->
	group by he.IDcontable
</cfquery>
	
<!--- Si hay polizas por transferir --->
<cfif isDefined("rsExistencia") and rsExistencia.recordcount gt 0>
	<!--- Para cada poliza por procesar --->
	<cfloop query="rsExistencia">
		<!--- Trae Encabezado --->
		<cfquery name="rsTrae" datasource="#DSource#">
			select 	he.Eperiodo,
							he.Emes,	
								case 
									when (select Cconcepto from ConceptoContable
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">
												and Oorigen = he.Oorigen) is null then 0
									else	(select Cconcepto from ConceptoContable
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">
												and Oorigen = he.Oorigen)
								end
							as Cconcepto,
							he.Efecha,
							he.Edescripcion,
							he.Edocbase,
							he.Ereferencia,
							he.Efecha as Falta,
							he.ECusuario as Usuario,
							he.ECreversible as ECIreversible,
							he.Edocumento as Edocumento,
							he.ECusucodigo as CodigoUsuario
			from HEContables he
			where he.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistencia.IDcontable#">
			and   he.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
		</cfquery>
		<!--- Usuario --->
		<cfif isDefined("rsTrae.CodigoUsuario") and #rsTrae.CodigoUsuario# neq "">
			<cfset GvarUsucodigo = #rsTrae.CodigoUsuario#> 
		<cfelse>
			<cfset GvarUsucodigo = 6> <!--- default soin --->
		</cfif>
		<!--- Trae Detalle --->
		<cfquery name="rsTraeD" datasource="#DSource#">
			select  hd.Dlinea as DCIconsecutivo,
							he.Efecha as DCIEfecha,
							hd.Eperiodo,
							hd.Emes,
							hd.Ddescripcion,
							hd.Dreferencia,
							hd.Dmovimiento,
							case 	
								when hd.Ocodigo is null then null
								else (select Ocodigo from Oficinas
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">
											and Oficodigo = (select Oficodigo from Oficinas 
																			where Ecodigo = hd.Ecodigo 
																			and   Ocodigo = hd.Ocodigo))
							end as Ocodigo,
								(select Mcodigo from Monedas
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">
								and  Miso4217 = (select Miso4217 from Monedas
											 					where Ecodigo = hd.Ecodigo
											 					and   Mcodigo = hd.Mcodigo))
							as Mcodigo,
							hd.Doriginal,	
							case 
								when 	(select Miso4217 from Monedas where Ecodigo = hd.Ecodigo and Mcodigo = hd.Mcodigo) =
									 		(select Miso4217 from Monedas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">
									 		and Mcodigo = (select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">))
								then 	hd.Doriginal
								else	round(hd.Dlocal * 
												round(1/
													(select TCpromedio from Htipocambio 
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
													and ((he.Efecha >= Hfecha) and (he.Efecha < Hfechah))
													and Mcodigo = (select Mcodigo from Monedas
																				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
																				and Miso4217  =	(select m.Miso4217 from Empresas e 
																												inner join Monedas m
																													on m.Ecodigo = e.Ecodigo
																													and m.Mcodigo = e.Mcodigo 
																												where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">)))
												,10,1)
											,2)
						 	end as Dlocal,
						 	case
						 		when hd.Doriginal = 0 then 1
						 		else
								 	round( 	case 
														when 	(select Miso4217 from Monedas where Ecodigo = hd.Ecodigo and Mcodigo = hd.Mcodigo) =
															 		(select Miso4217 from Monedas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">
															 		and Mcodigo = (select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">))
														then 	hd.Doriginal
														else	round(hd.Dlocal * 
																		round(1/
																			(select TCpromedio from Htipocambio 
																			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
																			and ((he.Efecha >= Hfecha) and (he.Efecha < Hfechah))
																			and Mcodigo = (select Mcodigo from Monedas
																										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
																										and Miso4217  =	(select m.Miso4217 from Empresas e 
																																		inner join Monedas m
																																			on m.Ecodigo = e.Ecodigo
																																			and m.Mcodigo = e.Mcodigo 
																																		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">)))
																		,10,1)
																	,2)
												 	end 	/ hd.Doriginal,4) 
								end
							as Dtipocambio,
							hd.Cconcepto,
							getdate() as BMfalta,
								(select CFformato from CFinanciera
								where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
								and  CFcuenta = hd.CFcuenta)
							as CFformato,
								(select Oficodigo from Oficinas 
								where Ecodigo = hd.Ecodigo 
								and   Ocodigo = hd.Ocodigo)
							as Oficodigo,
								(select Miso4217 from Monedas
			 					where Ecodigo = hd.Ecodigo
			 					and   Mcodigo = hd.Mcodigo)
			 				as Miso4217,
			 					case
			 						when hd.CFid is null then (select CFcodigo from CFuncional
			 																			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
			 																			and   Ocodigo = hd.Ocodigo)
			 						else (select CFcodigo from CFuncional
			 									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
			 									and CFid = hd.CFid)
			 					end
			 				as CFcodigo, 
			 				hd.Ddocumento
			from HDContables hd
				inner join HEContables he
				on	he.Ecodigo    = hd.Ecodigo
				and he.IDcontable = hd.IDcontable
			where hd.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistencia.IDcontable#">
			and hd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
			and hd.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#OficinaOrigen#">
		</cfquery>

		<!--- Se crea una session para poder utilizar el componente GeneraCuenta--->
		<cfapplication 	name="SIF_ASP"
										sessionmanagement="Yes"
										sessiontimeout=#CreateTimeSpan(0,0,1,0)#
										applicationTimeout = #CreateTimeSpan(0,0,1,0)#
										clientmanagement="Yes">
		<cfset session.Ecodigo = #EmpresaDestino#>
		<cfset session.Usucodigo = #GvarUsucodigo#>
		<cfset session.DSN = "#DSource#">
		<cfset application.scope = "server">
		<cfset application.dsinfo.type = "sqlserver">

    <!--- Verifica las cuentas en la poliza, si no existen intenta crearlas --->
    <cfset ErrorEnCuentas = false>
		<cfloop query="rsTraeD">
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
				method="fnGeneraCuentaFinanciera"
				returnvariable="Lvar_MsgError">
				<cfinvokeargument name="Lprm_CFformato"	value="#rsTraeD.CFformato#"/>
				<cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
				<cfinvokeargument name="Lprm_NoCrear" value="false"/>
				<cfinvokeargument name="Lprm_CrearSinPlan" value="false"/>
				<cfinvokeargument name="Lprm_debug" value="false"/>
				<cfinvokeargument name="Lprm_Ecodigo"	value="#EmpresaDestino#"/>
				<cfinvokeargument name="Lprm_DSN"	value="#DSource#"/>
			</cfinvoke>	
			
			<cfif isdefined("Lvar_MsgError") AND not (Lvar_MsgError EQ "OLD" OR Lvar_MsgError EQ "NEW")>
				<cfset ErrorAlTransferir = "Error en la cuenta #rsTraeD.CFformato#"> 
				<cfset estatusPoliza = #ErrorCuenta#>
				<cfset ErrorEnCuentas = true>
				<cfbreak>
			</cfif>
		</cfloop>
	
		<!--- Si no se tiene error en las cuentas --->	
		<cfif not ErrorEnCuentas>
			<!--- Inserta los valores --->
			<cftransaction action="begin">
			<cftry>
				<cfset ErrorAlTransferir = "Error al insertar el Encabezado en la interfaz 18">
				<cfset varIDmax = ExtraeMaximo("IE18","ID")>

				<!--- Inserta Encabezado --->
				<cfquery name="rsInsert" datasource="#DSource2#">
					insert into IE18	(ID, 
					                  Ecodigo, 
					                  Cconcepto, 
					                  Eperiodo, 
					                  Emes, 
					                  Efecha,
					                  Edescripcion, 
					                  Edocbase, 
					                  Ereferencia, 
					                  Falta, 
					                  Usuario,
					                  ECIreversible,
					                  IDcontableOri)

										values	(<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDmax#">, 
							              <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">, 
							              <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTrae.Cconcepto#">,
							              <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTrae.Eperiodo#">, 
							              <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTrae.Emes#">, 
							              <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrae.Efecha#">,
							              <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTrae.Edescripcion#">, 
							              <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTrae.Edocbase#">, 
							              <cfif isDefined("rsTrae.Ereferencia")  and rsTrae.Ereferencia neq "">
							              	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTrae.Ereferencia#">,
							              <cfelse>
							              	<cfqueryparam cfsqltype="cf_sql_varchar" value="Pol. Origen:#rsTrae.Edocumento#">,
							              </cfif> 
							              <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrae.Falta#">, 
							              <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTrae.Usuario#">,
							              <cfqueryparam cfsqltype="cf_sql_bit" value="#rsTrae.ECIreversible#">,
							              <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistencia.IDcontable#">)
				</cfquery>
				<cfset ErrorAlTransferir = "Detalle">

				<!--- Inserta Detalle --->
				<cfloop query="rsTraeD">
					<cfquery name="rsInsertD" datasource="#DSource2#">
						insert into ID18	(ID, 
					                    DCIconsecutivo, 
					                    Ecodigo, 
					                    DCIEfecha, 
					                    Eperiodo, 
					                    Emes,
					                    Ddescripcion, 
					                    Ddocumento, 
					                    Dreferencia, 
					                    Dmovimiento, 
					                    Ocodigo, 
					                    Mcodigo, 
					                    Doriginal, 
					                    Dlocal, 
					                    Dtipocambio,
					                    Cconcepto, 
					                    BMfalta, 
					                    EcodigoRef, 
					                    CFformato, 
					                    Oficodigo, 
					                    Miso4217, 
					                    CFcodigo) 
			                    
											values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDmax#">, 
							                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTraeD.DCIconsecutivo#">, 
							                <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">,
							                <cfqueryparam cfsqltype="cf_sql_date" value="#rsTraeD.DCIEfecha#">, 
							                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTraeD.Eperiodo#">, 
							                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTraeD.Emes#">,
							                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTraeD.Ddescripcion#">, 
							                <cfif isDefined("rsTraeD.Ddocumento")  and rsTraeD.Ddocumento neq "">
							              		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTraeD.Ddocumento#">, 
							              	<cfelse>
							              		<cfqueryparam cfsqltype="cf_sql_varchar" value="Pol. Origen:#rsTrae.Edocumento#">,
							              	</cfif>
							                <cfif isDefined("rsTraeD.Dreferencia")  and rsTraeD.Dreferencia neq "">
							              		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTraeD.Dreferencia#">, 
							              	<cfelse>
							              		<cfqueryparam cfsqltype="cf_sql_varchar" value="Pol. Origen:#rsTrae.Edocumento#">,
							              	</cfif>
							                <cfqueryparam cfsqltype="cf_sql_char" value="#rsTraeD.Dmovimiento#">, 
							                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTraeD.Ocodigo#">, 
							                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTraeD.Mcodigo#">, 
							                <cfqueryparam cfsqltype="cf_sql_money" value="#rsTraeD.Doriginal#">, 
							                <cfqueryparam cfsqltype="cf_sql_money" value="#rsTraeD.Dlocal#">, 
							                <cfqueryparam cfsqltype="cf_sql_float" value="#rsTraeD.Dtipocambio#">,
							                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTrae.Cconcepto#">, 
							                <cfqueryparam cfsqltype="cf_sql_date" value="#rsTraeD.BMfalta#">, 
							                <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaDestino#">, 
							                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTraeD.CFformato#">, 
							                <cfqueryparam cfsqltype="cf_sql_char" value="#rsTraeD.Oficodigo#">, 
							                <cfqueryparam cfsqltype="cf_sql_char" value="#rsTraeD.Miso4217#">,
							                <cfif isDefined("rsTraeD.CFcodigo") and rsTraeD.CFcodigo neq "">
							              		<cfqueryparam cfsqltype="cf_sql_char" value="#rsTraeD.CFcodigo#"> 
							              	<cfelse>
							              		<cfqueryparam cfsqltype="cf_sql_char" value="NULL">
							              	</cfif>)
					</cfquery>
				</cfloop><!--- rsTraeD --->
				<cfset ErrorAlTransferir = "Error al insertar en la Cola de Procesos">

				<!--- Cola de procesos --->
				<cfquery datasource="#DSource2#">
	        insert into InterfazColaProcesos ( 	CEcodigo, 
	        																		NumeroInterfaz, 
	        																		IdProceso, 
	        																		SecReproceso,
																			        EcodigoSDC, 
																			        OrigenInterfaz, 
																			        TipoProcesamiento, 
																			        StatusProceso,
																			        FechaInclusion, 
																			        UsucodigoInclusion, 
																			        Cancelar	)
																			       
														        values	(	<cfqueryparam cfsqltype="cf_sql_integer" value="#varCEcodigo#">,
																	        		<cfqueryparam cfsqltype="cf_sql_integer" value="18">,
																	          	<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDmax#">,
																	          	<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
																	          	<cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigoSDC#">,
																	          	<cfqueryparam cfsqltype="cf_sql_char" value="E">,
																	          	<cfqueryparam cfsqltype="cf_sql_char" value="A">,
																	          	<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
																	          	getdate(),
																	          	<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">,
																	          	<cfqueryparam cfsqltype="cf_sql_bit" value="0">	)
	    	</cfquery>

	    	<cfset ErrorAlTransferir = "Poliza transferida a interfaz 18">

	    	<cfset estatusPoliza = #Transferida#>
				<cftransaction action="commit"/>

				<cfcatch type="any">
					<cftransaction action="rollback"/>
					<cfset estatusPoliza = #ErrorGeneral#>
					<cfif ErrorAlTransferir eq "Detalle">
						<cfif rsTraeD.Mcodigo eq ''>
							<cfset ErrorAlTransferir = "La poliza utiliza una moneda no definida en la empresa destino">
							<cfset estatusPoliza = #ErrorMoneda#>
						<cfelseif rsTraeD.Doriginal eq '' or rsTraeD.Dtipocambio eq ''>
							<cfset ErrorAlTransferir = "La poliza utiliza un tipo de cambio no definido en la empresa destino">
							<cfset estatusPoliza = #ErrorTipoDeCambio#>
						<cfelse>
							<cfset ErrorAlTransferir = 'Error al transferir la poliza' & ', Detalle del error:' & '#cfcatch.Detail#'>
							<cfset estatusPoliza = #ErrorGeneral#>
						</cfif>
					</cfif>
				</cfcatch>

			</cftry>
			</cftransaction>

			<!--- Para Contabilidad Electronica Inicio --->
    	<cfquery datasource="#DSource#">
				insert into PolizasTransferidas ( IDcontableOri, EcodigoOri, fechaTransferencia)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistencia.IDcontable#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#EmpresaOrigen#">,
								getdate())
			</cfquery><!--- Para Contabilidad Electronica Fin --->
		</cfif>	<!--- not ErrorEnCuentas --->

		<!--- Actualizar el estatus de la poliza --->
			<cfquery name="rsEstatusPoliza" datasource="#DSource#">
				update HEContables
					set PolizaTransferida = <cfqueryparam cfsqltype="cf_sql_numeric" value="#estatusPoliza#">
				where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
				and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistencia.IDcontable#">
			</cfquery>

	</cfloop><!--- rsExistencia --->
</cfif><!--- rsExistencia.recordcount gt 0 --->

<!--- FUNCION getEcodigoSDC --->
<cffunction name="getEcodigoSDC" returntype="string" output="no">
	<cfargument name="Ecodigo" type="numeric" required="true">
	<cfquery name="rsGetEcodigoSDC" datasource="#DSource#">
    select EcodigoSDC
    from Empresas e
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
  </cfquery>
  <cfreturn rsGetEcodigoSDC.EcodigoSDC>
</cffunction>

<!--- FUNCION GETCECODIGO --->
<cffunction name="getCEcodigo" returntype="string" output="no">
	<cfargument name="Ecodigo" type="numeric" required="true">
	<cfquery name="rsCEcodigo" datasource="#DSource#">
    select CEcodigo 
    from Empresa e
    inner join Empresas s
    on  e.Ereferencia = s.Ecodigo 
		and s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
  </cfquery>
  <cfreturn rsCEcodigo.CEcodigo>
</cffunction>

<!--- Funcion para extraer el maximo --->
<cffunction name = 'ExtraeMaximo' returntype="numeric"> 
    <cfargument name='Tabla' type='string'	required='true' hint="Tabla">
    <cfargument name='CampoID' type='string'	required='true' hint="Proceso">
    
    <cfquery name="rsMaximo_Tabla" datasource="#DSource2#">
        select coalesce (max(#Arguments.CampoID#), 0) + 1 as Maximo from #Arguments.Tabla#
    </cfquery>
    
    <cfif rsMaximo_Tabla.Maximo NEQ "">
        <cfset Max_Tabla = rsMaximo_Tabla.Maximo>
    <cfelse>
        <cfset Max_Tabla = 0>
    </cfif>
    
    <cfquery name="rsMaximo_IdProceso" datasource="#DSource2#">
        select 1
        from IdProceso 
    </cfquery>
    
    <cfif rsMaximo_IdProceso.recordcount LTE 0>
        <cfquery datasource="#DSource2#">
            insert IdProceso(Consecutivo,BMUsucodigo) values(0,1)
        </cfquery>
    </cfif>
    
    <cfquery name="rsMaximo_IdProceso" datasource="#DSource2#">
        select isnull(max(Consecutivo),0) + 1 as Maximo
        from IdProceso 
    </cfquery>
    
    <cfset Max_Cons = rsMaximo_IdProceso.Maximo>
    
    <cfif  Max_Cons LT Max_Tabla>
        <cfset retvalue = rsMaximo_Tabla>
    <cfelse>
        <cfset retvalue = rsMaximo_IdProceso>
    </cfif>
    <cfquery datasource="#DSource2#">
        update IdProceso
        set Consecutivo = #retvalue.Maximo#
    </cfquery>
    <cfreturn retvalue.Maximo>
</cffunction>

<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Fin. --->