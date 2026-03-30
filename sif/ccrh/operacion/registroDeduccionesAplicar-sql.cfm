<cfset mensaje= "">

<cfif isdefined("Url.chk") and not isdefined("Form.chk")>
	<cfset Form.chk = Url.chk>
</cfif>

<cfif isdefined("Url.RHIDid") and not isdefined("Form.RHIDid")>
	<cfset Form.RHIDid = Url.RHIDid>
</cfif>

<cfif isdefined("form.chk")>
	<cfset RHIDids = #form.chk#>
<cfelse>
	<cfset RHIDids = #form.RHIDid#>
</cfif>

	<cfset Request.Error.Backs = 1>
	<cfloop index="RHIDid" list="#RHIDids#" >
		 
		 <cfquery name="rsInclDeduc" datasource="#session.DSN#">
			select coalesce(RHIDmonto+(RHIDmonto*(RHIDtasa/100)),0) as SaldoFinal,* from RHInclusionDeducciones
			where RHIDid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#RHIDid#"> 
		 </cfquery>
		 
		 <cfquery name="rsTDeduccion" datasource="#session.DSN#" >
			select TDid, TDcodigo, TDdescripcion
			from TDeduccion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInclDeduc.Ecodigo#">
			and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInclDeduc.TDid#">
		</cfquery>
		
		<!------------------------------------------------------------------->	
		
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Tcodigo 
			from LineaTiempo 
			where Ecodigo =  #session.Ecodigo# 
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInclDeduc.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta 
		</cfquery>
		
		<!--- Si el empleado está cesado, buscar la ultima nomina en la cual estaba --->
		<cfif rsTipoNomina.recordCount EQ 0>
			<cfquery name="rsTipoNomina" datasource="#session.DSN#">
				select a.Tcodigo 
				from LineaTiempo a
				where a.Ecodigo =  #session.Ecodigo# 
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInclDeduc.DEid#">
				and a.LThasta = (
					select max(x.LThasta)
					from LineaTiempo x
					where x.DEid = a.DEid
					and x.Ecodigo = a.Ecodigo
				)
			</cfquery>
		</cfif>
	
		<cfquery name="rsPeriodicidad" datasource="#session.DSN#">
			select Ttipopago 
			from TiposNomina 
			where Ecodigo =  #session.Ecodigo# 
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoNomina.Tcodigo)#">
		</cfquery>
		
		<!------------------------------------------------------------------->	
		
			 <cfquery name="data" datasource="#session.DSN#">
				select *
				from DeduccionesEmpleado a
			
				inner join TDeduccion b
				on a.TDid=b.TDid
			   and a.Ecodigo=b.Ecodigo
			
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInclDeduc.DEid#">
				  and a.Ecodigo =  #session.Ecodigo# 
				  and a.Dreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsInclDeduc.RHIDreferencia)#">
				  and a.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInclDeduc.TDid#">
				  and b.TDfinanciada = 1
			</cfquery>
			
			<cfif data.RecordCount gt 0>
				
				<cfset mensaje= #mensaje# &  "El registro que desea insertar ya existe.<br>Tipo de Deducci&oacute;n: #trim(rsTDeduccion.TDcodigo)# - #rsTDeduccion.TDdescripcion#<br>Referencia: #data.Dreferencia#"& '<br>' >
				
			<cfelse><!--- Proceso de insercion de la tabla InclusionDeduccion a la tabla DeduccionesEmpleado --->
			
				<cfif isdefined("session.deduccion_empleado")>
					<cfset structDelete(session, 'deduccion_empleado')>
				</cfif>
			
				<cfset session.deduccion_empleado.DEid = rsInclDeduc.DEid >
				<cfset session.deduccion_empleado.TDid = rsInclDeduc.TDid >
				<cfset session.deduccion_empleado.Dreferencia = rsInclDeduc.RHIDreferencia >
				<cfset session.deduccion_empleado.Ddescripcion = rsInclDeduc.RHIDdesc>
				<cfset session.deduccion_empleado.SNcodigo = rsInclDeduc.SNcodigo >
				<cfset session.deduccion_empleado.Dmonto = rsInclDeduc.RHIDmonto >
				<cfset session.deduccion_empleado.Dtasa = rsInclDeduc.RHIDtasa >
				<cfset session.deduccion_empleado.Dtasainteresmora = rsInclDeduc.RHIDtasamora >
				<cfset session.deduccion_empleado.Dfechaini = rsInclDeduc.RHIDfechadesde >
				<cfset session.deduccion_empleado.Dfechadoc = rsInclDeduc.RHIDfechadoc >
				<cfset session.deduccion_empleado.Dobservacion = rsInclDeduc.RHIDobs>
				<cfset session.deduccion_empleado.Tcodigo = rsTipoNomina.Tcodigo >
				<cfset session.deduccion_empleado.Dnumcuotas = rsInclDeduc.RHIDcuotas >
				<cfset session.deduccion_empleado.Dperiodicidad = rsPeriodicidad.Ttipopago >
	
				<!--- inicio --->
				<cfquery name="rsOrigen" datasource="#session.DSN#">
					select Oorigen
					from Origenes
					where Oorigen='CCRH'
				</cfquery>
				
				<cfif rsOrigen.recordCount lte 0>
					<cfquery datasource="#session.DSN#">
						insert INTO Origenes(Oorigen, Odescripcion, Otipo, BMUsucodigo)
						values ( 'CCRH', 'Cuentas por Cobrar Empleados', 'S', <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">	)
					</cfquery>
				</cfif>
				
				<!--- Moneda de la empresa (local)--->
				<cfquery name="dataMoneda" datasource="#session.DSN#">
					select Mcodigo
					from Empresas
					where Ecodigo =  #session.Ecodigo# 
				</cfquery>
				
				<!--- Periodo auxiliar --->
				<cfquery name="rsPeriodo" datasource="#session.DSN#">
					select Pvalor
					from Parametros
					where Ecodigo =  #session.Ecodigo# 
					  and Pcodigo = 50
				</cfquery>
				
				<!--- Mes auxiliar --->
				<cfquery name="rsMes" datasource="#session.DSN#">
					select Pvalor
					from Parametros
					where Ecodigo =  #session.Ecodigo# 
					  and Pcodigo = 60
				</cfquery>
				
				<!--- Oficina del empleado, segun Centro Funcional --->
				<cfquery name="rsCF" datasource="#session.DSN#">
					select c.Ocodigo
					from LineaTiempo a
				
					inner join RHPlazas b
						on b.RHPid = a.RHPid
						and b.Ecodigo = a.Ecodigo
					
					inner join CFuncional c
						on c.CFid = b.CFid
						and c.Ecodigo = b.Ecodigo
					
					where a.Ecodigo =  #session.Ecodigo# 
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.DEid#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#session.deduccion_empleado.Dfechaini#"> between a.LTdesde and a.LThasta
			</cfquery>
				
				<!--- Si el empleado está cesado, buscar la ultima oficina en la cual estaba --->
				<cfif rsCF.recordCount EQ 0>
					<cfquery name="rsCF" datasource="#Session.DSN#">
						select c.Ocodigo
						from LineaTiempo a
					
						inner join RHPlazas b
							on b.RHPid = a.RHPid
							and b.Ecodigo = a.Ecodigo
						
						inner join CFuncional c
							on c.CFid = b.CFid
							and c.Ecodigo = b.Ecodigo
						
						where a.Ecodigo =  #session.Ecodigo# 
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.DEid#">
						and a.LThasta = (
							select max(x.LThasta)
							from LineaTiempo x
							where x.DEid = a.DEid
							and x.Ecodigo = a.Ecodigo
						)
					</cfquery>
				</cfif>
				
				<cfset continuar = true >
				<cfif rsCF.RecordCount lte 0 >
					<cfset continuar = false >
				<cfelseif len(trim(rsCF.Ocodigo)) eq 0 >
					<cfset continuar = false >
				</cfif>
				
				<cfif not continuar>
					<cfset mensaje= #mensaje# &  "El registro que desea insertar ya existe.<br>Tipo de Deducci&oacute;n: #trim(rsTDeduccion.TDcodigo)# - #rsTDeduccion.TDdescripcion#<br>Referencia: #rsInclDeduc.Dreferencia#">
				
				<cfelse>
					<cfquery name="rsCuentaSocio" datasource="#session.DSN#">
						select SNcuentacxc as Ccuenta
						from SNegocios
						where Ecodigo= #session.Ecodigo# 
						and SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.SNcodigo#">
					</cfquery>
					
					<cfif Len(Trim(rsCuentaSocio.Ccuenta)) EQ 0>
						<cfset mensaje= #mensaje# &  "Error. No ha sido definida la cuenta contable del Socio de Negocios. Aplicando la Deducción: '#rsInclDeduc.RHIDdesc#'." & '<br>'>
					
					<cfelse> 
						
						<cfquery name="rsCuentaTipo" datasource="#session.DSN#">
							select Ccuenta
							from TDeduccion
							where Ecodigo= #session.Ecodigo# 
							and TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.TDid#">
						</cfquery>
						
						<cfif rsCuentaTipo.recordCount lte 0 or ( isdefined("rsCuentaTipo.Ccuenta") and len(trim(rsCuentaTipo.Ccuenta)) eq 0 )>
							<cfset mensaje= #mensaje# &  "Error. No ha sido definida la cuenta contable del Tipo de Deducci&oacute;n. Aplicando la Deducción: '#rsInclDeduc.RHIDdesc#'."& '<br>'>
						
						<cfelse>
						
								<cftransaction>
								<cfinclude template="plan-financiamiento.cfm">
							
								<cfquery dbtype="query" name="dataCuota" maxrows="1">
									select total
									from calculo
								</cfquery>

						<cfquery name="insert" datasource="#session.DSN#">
									insert into DeduccionesEmpleado( DEid, 
																Ecodigo, 
																SNcodigo, 
																TDid, 
																Ddescripcion, 
																Dmetodo, 
																Dvalor, 
																Dfechadoc,
																Dfechaini, 
																Dfechafin, 
																Dmonto, 
																Dtasa, 
																Dsaldo, 
																Dmontoint, 
																Destado, 
																Usucodigo, 
																Ulocalizacion, 
																Dcontrolsaldo, 
																Dactivo, 
																Dreferencia, 
																BMUsucodigo, 
																Dobservacion)
																
									values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.DEid#">,
											  #session.Ecodigo# ,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.deduccion_empleado.SNcodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.TDid#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.deduccion_empleado.Ddescripcion#">,
											 1,
											 <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#dataCuota.total#">,
											 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#session.deduccion_empleado.Dfechadoc#">,
											 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#session.deduccion_empleado.Dfechaini#">,
											 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">,
											 <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Replace(dataCuota.total*rsInclDeduc.RHIDcuotas,',','','all')#">,
											 <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(session.deduccion_empleado.Dtasa,',','','all')#">,
											 <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Replace(dataCuota.total*rsInclDeduc.RHIDcuotas,',','','all')#">,
											 0,
											 1,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
											 '00',
											 1,
											 1,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.deduccion_empleado.Dreferencia#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.deduccion_empleado.Dobservacion#"> )										
											
											<cf_dbidentity1 datasource="#session.DSN#">
					
									</cfquery>
									<cf_dbidentity2 datasource="#session.DSN#" name="insert">
									
								
								<cfquery name="dataMoneda" datasource="#session.DSN#">
									select Mcodigo 
									from Empresas 
									where Ecodigo =  #session.Ecodigo# 
								</cfquery>
						
								<cfloop query="calculo">
									<cfquery datasource="#session.DSN#">
										insert into DeduccionesEmpleadoPlan( Did, 
																			PPnumero, 
																			Ecodigo, 
																			PPfecha_vence, 
																			PPsaldoant, 
																			PPprincipal, 
																			PPinteres, 
																			PPpagoprincipal, 
																			PPpagointeres, 
																			PPpagomora, 
																			PPfecha_pago, 
																			Mcodigo, 
																			PPtasa, 
																			PPtasamora, 
																			PPpagado, 
																			PPdocumento, 
																			BMUsucodigo)
										values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#calculo.PPnumero#">,
												 #session.Ecodigo# ,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#calculo.fecha#">,  <!--- *** PPfecha_vence --->
												<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Replace(calculo.saldoant,',','','all')#">,
												<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Replace(calculo.principal,',','','all')#">, <!--- PPprincipal --->
												<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Replace(calculo.intereses,',','','all')#">, <!--- PPinteres --->
												0, <!--- PPpagpprincipal --->
												0, <!--- PPpagointeres --->
												0, <!--- PPpagomora --->
												null,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataMoneda.Mcodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(session.deduccion_empleado.Dtasa,',','','all')#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(session.deduccion_empleado.Dtasainteresmora,',','','all')#">,
												0,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.deduccion_empleado.Dreferencia#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
									</cfquery>
								</cfloop>
						
								<!--- ASIENTO CONTABLE --->
								<!---  Creación de la tabla INTARC ----->
								<cfset obj = CreateObject("component", "sif.Componentes.CG_GeneraAsiento") >
								<cfset intarc = obj.CreaIntarc() >
								
								<cfset descripcion = session.deduccion_empleado.Ddescripcion >
								
								<!--- inserta debitos (a cuenta del Socio) --->
								<cfquery datasource="#session.DSN#">
									insert INTO #intarc# ( 	INTORI, <!--- Origen--->
															INTREL, 
															INTDOC, 
															INTREF, 
															INTMON, 
															INTTIP, <!--- D,C--->
															INTDES, 
															INTFEC, 
															INTCAM, 
															Periodo, 
															Mes, 
															Ccuenta, 
															Mcodigo, 
															Ocodigo, 
															INTMOE )
									values(	'CCRH',  																										<!--- INTORI --->
											0,																												<!--- INTREL --->
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.deduccion_empleado.Dreferencia#">,						<!--- INTDOC --->
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.deduccion_empleado.Dreferencia#">,						<!--- INTREF --->
											<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(session.deduccion_empleado.Dmonto,',','','all')#">,		<!--- INTMON --->
											'D',																											<!--- INTTIP --->
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#descripcion#">,												<!--- INTDES --->
											'#DateFormat(session.deduccion_empleado.Dfechadoc,'yyyymmdd')#',												<!--- INTFEC --->
											1,																												<!--- INTCAM --->
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.Pvalor#">,											<!--- periodo--->
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.Pvalor#">,												<!--- mes	 --->
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaSocio.Ccuenta#">,										<!--- Ccuenta--->
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataMoneda.Mcodigo#">,											<!--- Mcodigo--->
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCF.Ocodigo#">,												<!--- Oficina --->
											<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(session.deduccion_empleado.Dmonto,',','','all')#">		<!--- INTMON --->
										  )
								</cfquery>
								
								<!--- inserta creditos (a cuenta del tipo de deduccion) --->
								<cfquery datasource="#session.DSN#">
									insert INTO #intarc# ( 	INTORI, <!--- Origen--->
															INTREL, 
															INTDOC, 
															INTREF, 
															INTMON, 
															INTTIP, <!--- D,C--->
															INTDES, 
															INTFEC, 
															INTCAM, 
															Periodo, 
															Mes, 
															Ccuenta, 
															Mcodigo, 
															Ocodigo, 
															INTMOE )
								
									values(	'CCRH',  																										<!--- INTORI --->
											0,																												<!--- INTREL --->
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.deduccion_empleado.Dreferencia#">,						<!--- INTDOC --->
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.deduccion_empleado.Dreferencia#">,						<!--- INTREF --->
											<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(session.deduccion_empleado.Dmonto,',','','all')#">,		<!--- INTMON --->
											'C',																											<!--- INTTIP --->
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#descripcion#">,												<!--- INTDES --->
											'#DateFormat(session.deduccion_empleado.Dfechadoc,'yyyymmdd')#',												<!--- INTFEC --->
											1,																												<!--- INTCAM --->
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.Pvalor#">,											<!--- periodo--->
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.Pvalor#">,												<!--- mes	 --->
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaTipo.Ccuenta#">,										<!--- Ccuenta--->
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataMoneda.Mcodigo#">,											<!--- Mcodigo--->
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCF.Ocodigo#">,												<!--- Oficina --->
											<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(session.deduccion_empleado.Dmonto,',','','all')#">		<!--- INTMON --->
										  )
								</cfquery>
						
								<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
									<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
									<cfinvokeargument name="Oorigen" value="CCRH"/>
									<cfinvokeargument name="Eperiodo" value="#rsPeriodo.Pvalor#"/>
									<cfinvokeargument name="Emes" value="#rsMes.Pvalor#"/>
									<cfinvokeargument name="Efecha" value="#session.deduccion_empleado.Dfechadoc#"/>
									<cfinvokeargument name="Edescripcion" value="CCRH: #session.deduccion_empleado.Ddescripcion#"/>
									<cfinvokeargument name="Edocbase" value="#session.deduccion_empleado.Dreferencia#"/>
									<cfinvokeargument name="Ereferencia" value="#session.deduccion_empleado.Dreferencia#"/>				
								</cfinvoke>
								
								<cfif isdefined("IDcontable") and len(trim(IDcontable)) >
									<cfquery datasource="#session.DSN#">
										update DeduccionesEmpleadoPlan			
										set IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
										where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">
										  and Ecodigo =  #session.Ecodigo# 
									</cfquery>
								</cfif>
							
								<!--- Elimina de RHInclusionDeducciones el registro aplicado --->
								<cfquery name="delIncDeduc" datasource="#session.DSN#">
									delete from RHInclusionDeducciones where RHIDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#RHIDid#"> 
								</cfquery>
								
							</cftransaction>
					
						</cfif>  <!--- rsCuentaTipo.recordCount lte 0 or ( isdefined("rsCuentaTipo.Ccuenta") and  --->
					
					</cfif>	<!---  Len(Trim(rsCuentaSocio.Ccuenta)) EQ 0> --->
					
				</cfif> <!--- rsCuentaSocio --->
				
				<cfset structDelete(session, 'deduccion_empleado')>

			</cfif> <!--- RecordCount GT 0 --->
				
	</cfloop>
<cfif mensaje NEQ ""><!--- Ocurrio Error --->
	<cfthrow message= "#mensaje#">
<cfelse>
	<cflocation url="InclusionDeducciones.cfm">
</cfif>

