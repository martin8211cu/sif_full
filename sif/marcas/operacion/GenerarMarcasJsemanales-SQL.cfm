<!--- #DayOfWeek(form.RHJMUfecha)# --->
<cfabort>
<cfquery name="rsAutoriza" datasource="#session.DSN#">
		Select Pvalor
		from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="510">
</cfquery>

<cfsetting requesttimeout="#3600*24#">
<!--- Verificacion de si el usuario actual tiene derechos para generar marcas --->
<cfquery name="rsPermisoGenMarca" datasource="#Session.DSN#">
	select 1
	from RHUsuariosMarcas um
	where um.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and um.RHUMtmarcas = 1
</cfquery>

<cfif rsPermisoGenMarca.recordCount GT 0>
	
	<cftransaction>
	
		<!--- Actualizar Centro Funcional en todas las Marcas de la Empresa que todavía no han sido procesadas --->
		<cfquery name="rsActualizarCF" datasource="#Session.DSN#">
			update RMarcas
			set CFid = b.CFid
			from LineaTiempo a, RHPlazas b, RHJornadas c
			where RMarcas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and RMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="-#Session.Ecodigo#">
			and RMarcas.RMfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">
			and RMarcas.RMmarcaproces = 0
			and RMarcas.Ecodigo = a.Ecodigo
			and RMarcas.DEid = a.DEid
			and convert(varchar, RMarcas.RMfecha, 106) between a.LTdesde and a.LThasta
			and a.RHPid = b.RHPid
			
			and a.RHJid = c.RHJid
			and c.RHJjsemanal =1
		</cfquery>
		
		<!--- Actualizar el Lote de las Marcas de los empleados que no requieren Marcas a 0 --->
		<cfquery name="rsActualizarCF" datasource="#Session.DSN#">
			update RMarcas
			set RHPMid = 0, RMmarcaproces = 1
			from LineaTiempo a, RHJornadas b
			where RMarcas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and RMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="-#Session.Ecodigo#">
			and RMarcas.RMfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">
			and RMarcas.RMmarcaproces = 0
			and RMarcas.Ecodigo = a.Ecodigo
			and RMarcas.DEid = a.DEid
			and convert(varchar, RMarcas.RMfecha, 106) between a.LTdesde and a.LThasta
			and a.RHJid = b.RHJid
			and b.RHJmarcar = 0
			and b.RHJjsemanal=1
		</cfquery>
			
		<!--- Chequear que existan marcas por procesar antes de continuar,
			y que cumplan con ser jornada semanal y que ademas tengan una semana completa
			si no ha pasado al menos una semana completa desde la ultima marca de su dia 
			de inicio no se debe procesar--->
		<cfquery name="rsCheck" datasource="#Session.DSN#">
			select distinct convert(varchar, rm.RMfecha,110) as finicio
			from RMarcas rm, RHUsuariosMarcas um, RHJornadas e, LineaTiempo d
			where rm.RMmarcaproces = 0
			and rm.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="-#Session.Ecodigo#">
			and rm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and rm.RMfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">
			and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			and um.RHUMtmarcas = 1
			and rm.Ecodigo = um.Ecodigo
			and rm.CFid = um.CFid
			
			and d.DEid = rm.DEid 
			and d.RHJid = e.RHJid
			and e.RHJjsemanal = 1 
			and e.RHJdiaini = datepart(dw,rm.RMfecha)
			and DateDiff(dd,rm.RMfecha,<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">) >= 7	
		  
		</cfquery>
		
		<cfif rsCheck.RecordCount GT 0>
		
			<!--- Insertar el Lote de Marcas ---->
			<cfquery name="rsEncabezado" datasource="#Session.DSN#">
				insert RHProcesamientoMarcas(CFid, Ecodigo, RHPMfproceso, RHPMusuarioInc)
				select distinct rm.CFid, rm.Ecodigo, <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(Form.fecha)#">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from RMarcas rm, RHUsuariosMarcas um 
				where rm.RMmarcaproces = 0
				and rm.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="-#Session.Ecodigo#">
				and rm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and rm.RMfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">
				and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and um.RHUMtmarcas = 1
				and rm.Ecodigo = um.Ecodigo
				and rm.CFid = um.CFid
				and not exists (
					select 1 
					from RHProcesamientoMarcas x, RHControlMarcas y
					where x.CFid = rm.CFid
					and x.Ecodigo = rm.Ecodigo
					and y.RHPMid = x.RHPMid
					and y.DEid = rm.DEid
					and convert(varchar, y.RHCMfregistro, 106) = convert(varchar, rm.RMfecha, 106)
				)
				
		  </cfquery>
			
			<!--- Lista de todos los lotes de jornadas semanales generados para esta fecha --->
			<cfquery name="rsLotesGenerados" datasource="#Session.DSN#">
				select rm.CFid, max(rm.RHPMid) as RHPMid
				from RHProcesamientoMarcas rm, RHUsuariosMarcas um
				where rm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and rm.RHPMfproceso = <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(Form.fecha)#">
				and rm.RHPMusuarioInc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and rm.RHPMfcierre is null
				and rm.Ecodigo = um.Ecodigo
				and rm.CFid = um.CFid
				and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and um.RHUMtmarcas = 1
				
				group by rm.CFid
			</cfquery>
			
			<cfloop query="rsLotesGenerados">
				<!--- Actualizar el lote de jonadas semanales en las Marcas que corresponde a cada Centro Funcional --->
				 <cfloop query="rsCheck"> 
					<cfquery name="updRHPMid" datasource="#Session.DSN#">
					update RMarcas 
					set RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					from RHUsuariosMarcas um, RHJornadas e, LineaTiempo d, RMarcas rm
					where rm.RMmarcaproces = 0
					and rm.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="-#Session.Ecodigo#">
					and rm.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.CFid#">
					and rm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and rm.RMfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">
					and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					and um.RHUMtmarcas = 1
					and rm.Ecodigo = um.Ecodigo
					and rm.CFid = um.CFid
					
					and rm.DEid = d.DEid 
					and d.RHJid = e.RHJid
					and e.RHJjsemanal = 1 
					and e.RHJdiaini = datepart(dw,rm.RMfecha)
					and rm.RMfecha between  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCheck.finicio#"> and
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(DateAdd('d',7,rsCheck.finicio),'mm-dd-yyyy')#">
					and DateDiff(dd,rm.RMfecha,<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">) >= 7	
													
					</cfquery>
					
				</cfloop> 
					
				<!--- Insertar Registros Iniciales --->
				<cfquery name="rsGeneracion1" datasource="#Session.DSN#">
					insert RHControlMarcas (RHPMid, DEid, RHJid, RHCMfregistro, RHCMfcapturada, RHCMdialibre, RHCMinconsistencia, RHCMhorasadicautor, RHCMhorasrebajar, BMUsucodigo, BMfecha)
					select distinct rm.RHPMid, a.DEid, a.RHJid, convert(varchar, rm.RMfecha, 106), convert(varchar, rm.RMfecha, 106), 0, 0, 0.00, 0.00, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					from RMarcas rm, LineaTiempo a
					where rm.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and rm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and convert(varchar, rm.RMfecha, 106) between a.LTdesde and a.LThasta
					and rm.Ecodigo = a.Ecodigo
					and rm.DEid = a.DEid
					and rm.RMmarcaproces = 0
					and not exists (
						select 1 
						from RHControlMarcas y
						where y.RHPMid = rm.RHPMid
						and y.DEid = rm.DEid
						and convert(varchar, y.RHCMfregistro, 106) = convert(varchar, rm.RMfecha, 106)
					)
				</cfquery>
				
				<!--- Actualizar jornadas del planificador y bit para saber si la jornada comprende dos días --->
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas
					set RHJid = isnull((select a.RHJid
								  from RHPlanificador a
								  where a.DEid = RHControlMarcas.DEid
								  and RHControlMarcas.RHCMfregistro between a.RHPJfinicio and a.RHPJffinal
								  ), RHControlMarcas.RHJid)
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					
					update RHControlMarcas
					set RHCMmismodia = 0
					from RHJornadas a
					where RHControlMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHJid = RHControlMarcas.RHJid
					and a.RHJhoraini > a.RHJhorafin
				</cfquery>
				
				<!--- Actualizar Horas de Entrada y Salida para las jornadas que comprenden un solo día --->
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas
					   set RHCMhoraentrada = isnull((select min(a.RMfecha)
												from RMarcas a
												where RHControlMarcas.RHPMid = a.RHPMid
												and RHControlMarcas.DEid = a.DEid
												and a.RMfecha >= RHControlMarcas.RHCMfregistro
												and a.RMfecha < dateadd(dd, 1, RHControlMarcas.RHCMfregistro)
												and a.RMtiporegis = '1'), RHControlMarcas.RHCMhoraentrada),
						   RHCMhorasalida = isnull((select max(a.RMfecha)
												from RMarcas a
												where RHControlMarcas.RHPMid = a.RHPMid
												and RHControlMarcas.DEid = a.DEid
												and a.RMfecha >= RHControlMarcas.RHCMfregistro
												and a.RMfecha < dateadd(dd, 1, RHControlMarcas.RHCMfregistro)
												and a.RMtiporegis = '2'), RHControlMarcas.RHCMhorasalida)
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHCMmismodia = 1
				</cfquery>
				
				<!--- Actualizar Horas de Entrada para las jornadas que comprenden dos días --->
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas
					   set RHCMhoraentrada = isnull((select min(a.RMfecha)
												from RMarcas a
												where RHControlMarcas.RHPMid = a.RHPMid
												and RHControlMarcas.DEid = a.DEid
												and a.RMfecha >= RHControlMarcas.RHCMfregistro
												and a.RMfecha < dateadd(dd, 1, RHControlMarcas.RHCMfregistro)
												and a.RMtiporegis = '1'), RHControlMarcas.RHCMhoraentrada),
						   RHCMhorasalida = isnull((select max(a.RMfecha)
												from RMarcas a
												where RHControlMarcas.RHPMid = a.RHPMid
												and RHControlMarcas.DEid = a.DEid
												and a.RMfecha >= dateadd(dd, 1, RHControlMarcas.RHCMfregistro)
												and a.RMfecha < dateadd(dd, 2, RHControlMarcas.RHCMfregistro)
												and a.RMtiporegis = '2'), RHControlMarcas.RHCMhorasalida)
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHCMmismodia = 0
				</cfquery>
				
				<!--- Actualizar Horas de Captura --->
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas
					set RHCMhoraentradac = RHCMhoraentrada, RHCMhorasalidac = RHCMhorasalida
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
				</cfquery>
					
				<!--- Registrar las Marcas de Reloj como Procesadas --->
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RMarcas
					set RMmarcaproces = 1
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
			</cfloop>
			
													<!---  Revicion de Inconsistencias --->
			
			<cfloop query="rsLotesGenerados">
				
				<cfquery name="rsEmpleados" datasource="#session.DSN#">	
					select distinct DEid 
					from RHControlMarcas
					where RHPMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
				</cfquery>
				
				<!--- <cfdump var="#rsLotesGenerados.RHPMid#">
				<cfabort> --->
				
				<cfloop query="rsEmpleados">
					<cfquery name="rsHorasEmpl" datasource="#session.DSN#">	
						select 
						
						Sum(convert(float,convert(varchar,convert(varchar,DateDiff(hh, RHCMhoraentradac, RHCMhorasalidac)) ||'.'||  
						case when datePart(mi,RHCMhoraentradac)< datePart(mi,RHCMhorasalidac)
						then
						convert(varchar,convert(int,datePart(mi,RHCMhorasalidac))-convert(int,datePart(mi,RHCMhoraentradac))))
						else
						convert(varchar,convert(int,datePart(mi,RHCMhoraentradac))- convert(int,datePart(mi,RHCMhorasalidac))))
						end)) as horas
						
						from RHControlMarcas
						where RHPMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
							and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
					</cfquery>
					
					<cfquery name="rsHorasSem" datasource="#session.DSN#">	
						select distinct b.RHJhorasemanal as horas
						from LineaTiempo a, RHJornadas b
						where 
							a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
							and a.RHJid = b.RHJid
							and b.RHJjsemanal=1
					</cfquery>
				
					<cfif rsHorasEmpleado.horas NEQ rsHorasSem.horas >  <!--- significa q existe inconsistencia --->
						
						<cfquery name="rsMarcasAfect" datasource="#session.DSN#">
							select distinct RHCMid 
							from RHControlMarcas
							where RHPMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
							and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
						</cfquery>
						
						<cfif rsHorasEmpleado.horas LT rsHorasSem.horas><!--- Menos horas --->
							
							<cfset hrs = rsHorasSem.horas-rsHorasEmpleado.horas>
							
							<cfloop query="rsMarcasAfect">
								<cfquery name="upMarcas" datasource="#session.DSN#"><!--- Marca inconsistencia --->
									update RHControlMarcas
									set RHCMinconsistencia=1,
										RHCMhorasrebajar=<cfqueryparam cfsqltype="cf_sql_float" value="#hrs#">
									where RHCMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcasAfect.RHCMid#">
								</cfquery>
							 	<cfquery name="insertIncos" datasource="#session.DSN#"><!--- Salida anticipada--->
									insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
									values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcasAfect.RHCMid#">,
											6,0,'',
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									)
									
								</cfquery>
							</cfloop>
						</cfif>
						
						<cfif rsHorasEmpleado.horas GT rsHorasSem.horas><!--- Mas horas --->
						  
							<cfset hrs = rsHorasEmpleado.horas- rsHorasSem.horas>
							<cfloop query="rsMarcasAfect">
								<cfquery name="upMarcas" datasource="#session.DSN#"><!--- Marca inconsistencia --->
									update RHControlMarcas
									set RHCMinconsistencia=1,
										RHCMhorasadicautor=<cfqueryparam cfsqltype="cf_sql_float" value="#hrs#">
									where RHCMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcasAfect.RHCMid#">
								</cfquery>
							 	<cfquery name="insertIncos" datasource="#session.DSN#"><!--- Salida Tarde--->
									insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
									values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarcasAfect.RHCMid#">,
											7,0,'',
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									)
									
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
					
				</cfloop>
				
			</cfloop>
			
		</cfif>
		
	</cftransaction>
</cfif>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">
	window.opener.location.reload();
	window.close();
</script>
</body>
</HTML>
