<!--- #DayOfWeek(form.RHJMUfecha)# --->

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
			and RMarcas.RMfecha between a.LTdesde and a.LThasta
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
			and RMarcas.RMfecha between a.LTdesde and a.LThasta
			and a.RHJid = b.RHJid
			and b.RHJmarcar = 0
			and b.RHJjsemanal=1
		</cfquery>
			
		<!--- Chequear que existan marcas por procesar antes de continuar, y que cumplan con
		 ser jornada semanal y que ademas tengan una semana completasi no ha pasado al menos
		  una semana completa desde su dia de inicio de jornada no se debe procesar--->
		<!--- dias a restar para crear finicio = (dw_fechaMin de las marcas sin procesar por jornada) - (dw_Inicico de jornada) + 7 MOD 7--->
		<!--- finicio = (fechaMin de las marcas sin procesar por jornada)-(dias a restar para crear finicio)  --->
		
		 <cfquery name="rsCheck" datasource="#Session.DSN#">
			select distinct e.RHJid, 
				DateAdd(dd,
				-((datepart(dw,(select min(convert(varchar, xx.RMfecha,110))
				from RMarcas xx
				where xx.RMmarcaproces =rm.RMmarcaproces
				and xx.Ecodigo = rm.Ecodigo
				and xx.RHPMid = rm.RHPMid
				and xx.Ecodigo = rm.Ecodigo
				and xx.CFid = rm.CFid
				and xx.DEid = rm.DEid ))-e.RHJdiaini+7)% 7),
    	
				(select min(convert(varchar, xx.RMfecha,110))
				from RMarcas xx
				where xx.RMmarcaproces =rm.RMmarcaproces
				and xx.Ecodigo = rm.Ecodigo
				and xx.RHPMid = rm.RHPMid
				and xx.Ecodigo = rm.Ecodigo
				and xx.CFid = rm.CFid
				and xx.DEid = rm.DEid )
				)as finicio
			
			from RMarcas rm, RHUsuariosMarcas um, RHJornadas e, LineaTiempo d
			where rm.RMmarcaproces = 0
			and rm.Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			and rm.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="-#Session.Ecodigo#">
			and um.RHUMtmarcas = 1
			and rm.Ecodigo = um.Ecodigo
			and rm.CFid = um.CFid
			and d.DEid = rm.DEid 
			and d.RHJid = e.RHJid
			and e.RHJjsemanal = 1
			and rm.RMfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(DateAdd('d',1,LSParseDateTime(Form.fecha)),'mm-dd-yyyy')#">
			and DateDiff(dd,
					(select min(xx.RMfecha)
					from RMarcas xx
					where xx.RMmarcaproces =rm.RMmarcaproces
					and xx.Ecodigo = rm.Ecodigo
					and xx.RHPMid = rm.RHPMid
					and xx.Ecodigo = rm.Ecodigo
					and xx.CFid = rm.CFid
					and xx.DEid = rm.DEid ),
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(DateAdd('d',1,LSParseDateTime(Form.fecha)),'mm-dd-yyyy')#">) >= 7
		</cfquery> 
		
		<!--- <cfdump var="#rsCheck#">
		<cfabort> --->
		
		
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
				 	
					<cfset diasExac = DateDiff('d',LSDateFormat(rsCheck.finicio,'mm-dd-yyyy'),LSDateFormat(form.fecha,'mm-dd-yyyy'))>
					<cfset numDias = diasExac - (diasExac MOD 7)-1>
					
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
						 
						<!--- and e.RHJdiaini = datepart(dw,rm.RMfecha) --->
						and e.RHJid = #rsCheck.RHJid# 
						and rm.RMfecha between  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(rsCheck.finicio,'mm-dd-yyyy')#"> and
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(DateAdd('d',numDias,rsCheck.finicio),'mm-dd-yyyy')#">
						
						<!--- and rm.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCheck.DEid#"> --->
						<!--- and DateDiff(dd,rm.RMfecha,<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">) >= 7  --->	
					</cfquery>
					
				</cfloop> 
				
				<!--- Insertar Registros Iniciales --->
				<cfquery name="rsGeneracion1" datasource="#Session.DSN#">
					insert RHControlMarcas (RHPMid, DEid, RHJid, RHCMfregistro, RHCMfcapturada, RHCMdialibre, RHCMinconsistencia, RHCMhorasadicautor, RHCMhorasrebajar, BMUsucodigo, BMfecha)
					select distinct rm.RHPMid, a.DEid, a.RHJid, rm.RMfecha, rm.RMfecha, 0, 0, 0.00, 0.00, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
					from RMarcas rm, LineaTiempo a
					where rm.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and rm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and rm.RMfecha between a.LTdesde and a.LThasta
					and rm.Ecodigo = a.Ecodigo
					and rm.DEid = a.DEid
					and rm.RMmarcaproces = 0
					and not exists (
						select 1 
						from RHControlMarcas y
						where y.RHPMid = rm.RHPMid
						and y.DEid = rm.DEid
						and y.RHCMfregistro = rm.RMfecha
					)
				</cfquery>
				
				<!--- Actualizar jornadas del planificador y bit para saber si la jornada comprende dos días --->
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas
					set RHJid = coalesce((select a.RHJid
								  from RHPlanificador a
								  where a.DEid = RHControlMarcas.DEid
								  and RHControlMarcas.RHCMfregistro between a.RHPJfinicio and a.RHPJffinal
								  ), RHControlMarcas.RHJid)
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					
					update RHControlMarcas
					set RHCMmismodia = 0
					from 	RHJornadas a
							<!---=====Se pega con el detalle de la jornada para obtener las horas especificas para c/dia de la semana--->
							,RHDJornadas b
							
					where RHControlMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHJid = RHControlMarcas.RHJid
						
						<!---=============== Join con la tabla de detalle ===============----->
						and a.RHJid = b.RHJid
						and a.Ecodigo = b.Ecodigo
						and datepart(dw,RHControlMarcas.RHCMfregistro) = b.RHDJdia	<!---Trae los detalles de la jornada RHDJornadas que son del dia de la semana de la marca--->
						
						<!---======= Valida que la hora de inicio sea mayor que la hora de finalizacion del detalle de la jornada =======--->
						<!---and a.RHJhoraini > a.RHJhorafin--->
						and b.RHJhoraini > b.RHJhorafin	

				</cfquery>
				
				<!--- Actualizar Horas de Entrada y Salida para las jornadas que comprenden un solo día --->
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas
					   set RHCMhoraentrada = coalesce((select min(a.RMfecha)
												from RMarcas a
												where RHControlMarcas.RHPMid = a.RHPMid
												and RHControlMarcas.DEid = a.DEid
												and a.RMfecha >= RHControlMarcas.RHCMfregistro
												and a.RMfecha < dateadd(dd, 1, RHControlMarcas.RHCMfregistro)
												and a.RMtiporegis = '1'), RHControlMarcas.RHCMhoraentrada),
						   RHCMhorasalida = coalesce((select max(a.RMfecha)
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
					   set RHCMhoraentrada = coalesce((select min(a.RMfecha)
												from RMarcas a
												where RHControlMarcas.RHPMid = a.RHPMid
												and RHControlMarcas.DEid = a.DEid
												and a.RMfecha >= RHControlMarcas.RHCMfregistro
												and a.RMfecha < dateadd(dd, 1, RHControlMarcas.RHCMfregistro)
												and a.RMtiporegis = '1'), RHControlMarcas.RHCMhoraentrada),
						   RHCMhorasalida = coalesce((select max(a.RMfecha)
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
					select distinct a.DEid,  
							DateAdd(dd,
							-((datepart(dw,(select min(convert(varchar, x.RHCMfregistro,110))
							from RHControlMarcas x
							where x.RHPMid = a.RHPMid
							and x.DEid=a.DEid
							and x.RHJid =a.RHJid
							))-c.RHJdiaini+7)% 7),
	
							(select min(convert(varchar, x.RHCMfregistro,110))
							from RHControlMarcas x
							where x.RHPMid = a.RHPMid
							and x.DEid=a.DEid
							and x.RHJid =a.RHJid
							))as finicio
					from RHControlMarcas a, LineaTiempo b, RHJornadas c
					where a.RHPMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and a.DEid=b.DEid
					and a.RHJid=b.RHJid
					and b.RHJid=c.RHJid
				</cfquery>
				
				<!---<cfdump var="#rsEmpleados#">
				<cfquery name="prueba" datasource="#session.DSN#">
					select * from RHControlMarcas where RHPMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
				</cfquery>--->
				
				<!---<cfdump var="#rsLotesGenerados#">
				<cfdump var="#prueba#">
				<cfabort>--->
				
				<cfloop query="rsEmpleados">
					
					<cfset diasExac = DateDiff('d',LSDateFormat(rsEmpleados.finicio,'mm-dd-yyyy'),LSDateFormat(form.fecha,'mm-dd-yyyy'))>
					<cfset numDias = diasExac - (diasExac MOD 7)-1>
				
					<cfset finicio = rsEmpleados.finicio>
					<cfset ffinal = DateAdd('d',numDias,rsEmpleados.finicio)>
				
					<cfset finicioX = DateFormat(finicio,'mm-dd-yyyy')>
					<cfset ffinalX = DateFormat(DateAdd('d',6,finicio),'mm-dd-yyyy')>
						
					<cfloop condition="#ffinalX# LTE #ffinal#">
						
						<!---<cfdump var=", Fecha F.inicio Semana=#finicioX#">
						<cfdump var=", Fecha F.final Semana=#ffinalX#">--->
					
						<cfquery name="rsHorasEmpl" datasource="#session.DSN#">	
						select sum
						(case when a.RHCMhoraentradac is not null and a.RHCMhorasalidac is not null then
						 	convert(float,{fn concat(convert(varchar,DateDiff(hh,a.RHCMhoraentradac, a.RHCMhorasalidac)),{fn concat('.',convert(varchar,DateDiff(mi,a.RHCMhoraentradac, a.RHCMhorasalidac)%60))})})
							<!----convert(float,convert(varchar,DateDiff(hh,a.RHCMhoraentradac, a.RHCMhorasalidac)) ||'.'||  convert(varchar,DateDiff(mi,a.RHCMhoraentradac, a.RHCMhorasalidac)%60))--->
							when a.RHCMhoraentradac is null and a.RHCMhorasalidac is null then
								0
							when a.RHCMhoraentradac is null or a.RHCMhorasalidac is not null then
								0
							else
								0
							end)	as horas	
						from RHControlMarcas a
						where a.RHPMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
						and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
						and a.RHCMfregistro between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finicioX#"> and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ffinalX#">
						</cfquery>
							
						<cfquery name="rsHorasSem" datasource="#session.DSN#">	
							select distinct b.RHJhorasemanal as horas
							from LineaTiempo a, RHJornadas b
							where 
								a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
								and a.RHJid = b.RHJid
								and b.RHJjsemanal=1
						</cfquery>
						
						<!---<cfdump var="#rsHorasEmpl#">	
						<cfdump var="#rsHorasSem#">
						<cfabort> --->
						
						<cfif rsHorasEmpl.horas NEQ rsHorasSem.horas>  <!--- significa q existe inconsistencia --->
								
							<cfquery name="rsMarcasAfect" datasource="#session.DSN#">
								select distinct RHCMid 
								from RHControlMarcas
								where RHPMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
								and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
								and RHCMfregistro between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finicioX#"> and
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ffinalX#">
						
							</cfquery>
							
							<cfif val(rsHorasEmpl.horas) LT val(rsHorasSem.horas)><!--- Menos horas --->
								
								<cfset hrs = val(rsHorasSem.horas)-val(rsHorasEmpl.horas)>
							
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
								
							<cfif val(rsHorasEmpl.horas) GT val(rsHorasSem.horas)><!--- Mas horas --->
							  
								<cfset hrs = val(rsHorasEmpl.horas)- val(rsHorasSem.horas)>
								
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
								<!---<cfdump var="AGREGA">--->
							</cfif>
							
							<!---<cfdump var="Semana=#finicioX#, EmpleadoHoras=#rsHorasEmpl.horas#, Semana=#rsHorasSem.horas#, Hdescontar=#hrs#">
							--->
						</cfif>
						
						<cfset finicioX = DateFormat(DateAdd('d',7,finicioX),'mm-dd-yyyy')>
						<cfset ffinalX =DateFormat(DateAdd('d',6,finicioX),'mm-dd-yyyy')>
						
				</cfloop>
				<!---<cfabort>--->
			</cfloop><!--- Loop empleados --->
				
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
