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
			and convert(varchar, RMarcas.RMfecha, 106) between a.LTdesde and a.LThasta
			and a.RHPid = b.RHPid
			
			and a.RHJid = c.RHJid
			and c.RHJjsemanal =0
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
			and b.RHJjsemanal=0
		</cfquery>
			
		<!--- Chequear que existan marcas por procesar antes de continuar --->
		<cfquery name="rsCheck" datasource="#Session.DSN#">
			select count(1) as cant
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
			and e.RHJjsemanal = 0 
			
		</cfquery>
		
		<cfif rsCheck.cant GT 0>
		
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
			
			<!--- Lista de todos los lotes generados para esta fecha --->
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
			
			<!--- arreglo q va a contener los ids de las nuevas marcas q se inserten en la tabla RHcontrolMarcas--->
			<!---<cfset RHCMidArray = ArrayNew(500)>
			<cfset index=0>--->
			<!---  --->
			
			<cfloop query="rsLotesGenerados">
				<!--- Actualizar el lote en las Marcas que corresponde a cada Centro Funcional --->
				<cfquery name="updRHPMid" datasource="#Session.DSN#">
					update RMarcas
					set RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					from RHUsuariosMarcas um, RHJornadas e, LineaTiempo d, RMarcas rm
					where RMarcas.RMmarcaproces = 0
					and RMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="-#Session.Ecodigo#">
					and RMarcas.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.CFid#">
					and RMarcas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and RMarcas.RMfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,LSParseDateTime(Form.fecha))#">
					and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					and um.RHUMtmarcas = 1
					and RMarcas.Ecodigo = um.Ecodigo
					and RMarcas.CFid = um.CFid
					
					and rm.DEid = d.DEid 
					and d.RHJid = e.RHJid
					and e.RHJjsemanal = 0 
				</cfquery>
				
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
					
				<cfquery name="rsDiaExtra" datasource="#Session.DSN#"><!--- dia extra --->
					select RHCMid
					from RHJornadas a
						inner join RHControlMarcas b
						on b.RHJid = a.RHJid
					where b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, b.RHCMfregistro), 1) = '0'
				</cfquery>
				
				<cfif rsDiaExtra.RecordCount NEQ 0>	<!--- pone la inconsistencia de dia extra (2)--->

					<cfloop query="rsDiaExtra">						
						<cfquery name="rsIncons" datasource="#session.DSN#">
							insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDiaExtra.RHCMid#">,2,0,'',
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
						</cfquery>
					</cfloop>
				</cfif>
				
				<!--- Marcar Inconsistencias los dias que no pertenecen a la jornada de trabajo --->
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas 
					set RHCMinconsistencia = 1
					from RHJornadas a
					where RHControlMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHControlMarcas.RHJid = a.RHJid
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, RHControlMarcas.RHCMfregistro), 1) = '0'
				</cfquery>
				
					
				<!--- Marcar Inconsistencias los días que no tengan alguna de las dos marcas (entrada o salida)--->
				<cfquery name="rsInconsMarcaEntr" datasource="#Session.DSN#"><!--- omision de marca de entrada--->
					select RHCMid
					from RHControlMarcas
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHCMhoraentrada is null
				</cfquery>
				
				<!--- omision de marca de entrada (0)--->	
				<cfif rsInconsMarcaEntr.RecordCount NEQ 0>
					
					<cfloop query="rsInconsMarcaEntr">
						<cfquery name="rsIncons" datasource="#session.DSN#">
							insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInconsMarcaEntr.RHCMid#">,
									0,0,'',
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
						</cfquery>
					</cfloop>
					
				</cfif>
				
				<!--- omision de marca de salida --->
				<cfquery name="rsInconsMarcaSalid" datasource="#Session.DSN#">
					select RHCMid
					from RHControlMarcas
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHCMhorasalida is null
				</cfquery>
				
				<!--- omision de marca de salida (1)--->	
				<cfif rsInconsMarcaSalid.RecordCount NEQ 0>
					<cfloop query="rsInconsMarcaSalid">	
						<cfquery name="rsIncons" datasource="#session.DSN#">
							insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInconsMarcaSalid.RHCMid#">,
									1,0,'',
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
						</cfquery>
					</cfloop>
				</cfif>
				
				<!--- Dia de Ausencia --->
				<cfquery name="rsInconsDiaAusente" datasource="#Session.DSN#">
					select RHCMid
					from RHControlMarcas
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHCMhoraentrada = null 
					and RHCMhorasalida = null
				</cfquery>
				
				<!--- Dia de Ausencia (3)--->
				<cfif rsInconsDiaAusente.RecordCount GT 0>
				
					<cfloop query="rsInconsDiaAusente">
						<cfquery name="rsIncons" datasource="#session.DSN#">
							insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInconsDiaAusente.RHCMid#">,
									3,0,'',
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
						</cfquery>
					</cfloop>
				</cfif>
				
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas 
					set RHCMinconsistencia = 1
					where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and (RHCMhoraentrada is null or RHCMhorasalida is null)
				</cfquery>
				
				<!--- Marcar Inconsistencias en el Control de Marca para cada tipo de Comportamiento en la Jornada --->
				<!--- Antes de la Hora de Entrada --->
				<cfquery name="rsLlegaAnticipada" datasource="#Session.DSN#">
					select RHCMid
					from RHComportamientoJornada a, RHJornadas b,RHControlMarcas c
					where c.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and c.RHJid = a.RHJid
					and c.RHCMhoraentradac is not null
					and a.RHCJcomportamiento = 'H'
					and a.RHCJmomento = 'A'
					and a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and datediff(mi, c.RHCMhoraentradac, convert(varchar, c.RHCMhoraentradac, 106)+' '+convert(varchar, b.RHJhoraini, 108)) >= a.RHCJperiodot
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, c.RHCMfregistro), 1) = '1'
					and c.RHCMfregistro between a.RHCJfrige and a.RHCJfhasta
				</cfquery>
				
				<!--- llegada Anticipada (4)--->
				<cfif rsLlegaAnticipada.RecordCount NEQ 0> 
					
					<cfloop query="rsLlegaAnticipada">
						<cfquery name="rsIncons" datasource="#session.DSN#">
						insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLlegaAnticipada.RHCMid#">,
								4,0,'',
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
						</cfquery>
					</cfloop>
					
				</cfif>
				
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas 
					set RHCMinconsistencia = 1
					from RHComportamientoJornada a, RHJornadas b
					where RHControlMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHControlMarcas.RHJid = a.RHJid
					and RHControlMarcas.RHCMhoraentradac is not null
					and a.RHCJcomportamiento = 'H'
					and a.RHCJmomento = 'A'
					and a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and datediff(mi, RHControlMarcas.RHCMhoraentradac, convert(varchar, RHControlMarcas.RHCMhoraentradac, 106)+' '+convert(varchar, b.RHJhoraini, 108)) >= a.RHCJperiodot
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, RHControlMarcas.RHCMfregistro), 1) = '1'
					and RHControlMarcas.RHCMfregistro between a.RHCJfrige and a.RHCJfhasta
				</cfquery>
					
				<!--- Despues de la Hora de Entrada --->
				<cfquery name="rsLlegaTarde" datasource="#Session.DSN#">
					select RHCMid
					from RHComportamientoJornada a, RHJornadas b, RHControlMarcas c
					where c.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and c.RHJid = a.RHJid
					and c.RHCMhoraentradac is not null
					and a.RHCJcomportamiento = 'R'
					and a.RHCJmomento = 'D'
					and a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and datediff(mi, convert(varchar, c.RHCMhoraentradac, 106)+' '+convert(varchar, b.RHJhoraini, 108), c.RHCMhoraentradac) >= a.RHCJperiodot
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, c.RHCMfregistro), 1) = '1'
					and c.RHCMfregistro between a.RHCJfrige and a.RHCJfhasta
				</cfquery>
					
				 <cfif rsLlegaTarde.RecordCount GT 0>
				 	<cfloop query="rsLlegaTarde">
						<cfquery name="rsIncons" datasource="#session.DSN#"><!--- Escribe Inconsistencia de llegada tarde(5) --->
							insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLlegaTarde.RHCMid#">,
									5,0,'',
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
						</cfquery>
					</cfloop>
				</cfif>
			
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas 
					set RHCMinconsistencia = 1
					from RHComportamientoJornada a, RHJornadas b
					where RHControlMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHControlMarcas.RHJid = a.RHJid
					and RHControlMarcas.RHCMhoraentradac is not null
					and a.RHCJcomportamiento = 'R'
					and a.RHCJmomento = 'D'
					and a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and datediff(mi, convert(varchar, RHControlMarcas.RHCMhoraentradac, 106)+' '+convert(varchar, b.RHJhoraini, 108), RHControlMarcas.RHCMhoraentradac) >= a.RHCJperiodot
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, RHControlMarcas.RHCMfregistro), 1) = '1'
					and RHControlMarcas.RHCMfregistro between a.RHCJfrige and a.RHCJfhasta
				</cfquery>
					
				<!--- Antes de la Hora de Salida --->
				<cfquery name="rsSalidaAnticipada" datasource="#Session.DSN#">
					select RHCMid
					from RHComportamientoJornada a, RHJornadas b, RHControlMarcas c
					where c.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and c.RHJid = a.RHJid
					and c.RHCMhorasalidac is not null
					and a.RHCJcomportamiento = 'R'
					and a.RHCJmomento = 'A'
					and a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and datediff(mi, c.RHCMhorasalidac, convert(varchar, c.RHCMhorasalidac, 106)+' '+convert(varchar, b.RHJhorafin, 108)) >= a.RHCJperiodot
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, c.RHCMfregistro), 1) = '1'
					and c.RHCMfregistro between a.RHCJfrige and a.RHCJfhasta
				</cfquery>
				
				<cfif rsSalidaAnticipada.RecordCount GT 0>
					<cfloop query="rsSalidaAnticipada">
						<cfquery name="rsIncons" datasource="#session.DSN#"><!--- Escribe Inconsistencia de salida Anticipada(6) --->
							insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalidaAnticipada.RHCMid#">,
									6,0,'',
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
						</cfquery>
					</cfloop>
				</cfif>
				 
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas 
					set RHCMinconsistencia = 1
					from RHComportamientoJornada a, RHJornadas b
					where RHControlMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHControlMarcas.RHJid = a.RHJid
					and RHControlMarcas.RHCMhorasalidac is not null
					and a.RHCJcomportamiento = 'R'
					and a.RHCJmomento = 'A'
					and a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and datediff(mi, RHControlMarcas.RHCMhorasalidac, convert(varchar, RHControlMarcas.RHCMhorasalidac, 106)+' '+convert(varchar, b.RHJhorafin, 108)) >= a.RHCJperiodot
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, RHControlMarcas.RHCMfregistro), 1) = '1'
					and RHControlMarcas.RHCMfregistro between a.RHCJfrige and a.RHCJfhasta
				</cfquery>
					
				<!--- Despues de la Hora de Salida --->
				
				<cfquery name="rsSaleTarde" datasource="#Session.DSN#">
					select RHCMid
					from RHComportamientoJornada a, RHJornadas b, RHControlMarcas c
					where c.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and c.RHJid = a.RHJid
					and c.RHCMhorasalidac is not null
					and a.RHCJcomportamiento = 'H'
					and a.RHCJmomento = 'D'
					and a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and datediff(mi, convert(varchar, c.RHCMhorasalidac, 106)+' '+convert(varchar, b.RHJhorafin, 108), c.RHCMhorasalidac) >= a.RHCJperiodot
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, c.RHCMfregistro), 1) = '1'
					and c.RHCMfregistro between a.RHCJfrige and a.RHCJfhasta
				</cfquery>
				
				<cfif rsSaleTarde.RecordCount NEQ 0>
					<cfloop query="rsSaleTarde">
						<cfquery name="rsIncons" datasource="#Session.DSN#"><!--- Escribe Inconsistencia de salida Anticipada(7) --->
							insert into RHInconsistencias(RHCMid,RHItipoinconsistencia,RHIjustificada,RHIjustificacion,BMUsucodigo)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSaleTarde.RHCMid#">,7,0,'',
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
						</cfquery>
					</cfloop>
				</cfif> 
				
				<cfquery name="rsGeneracion" datasource="#Session.DSN#">
					update RHControlMarcas 
					set RHCMinconsistencia = 1
					from RHComportamientoJornada a, RHJornadas b
					where RHControlMarcas.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotesGenerados.RHPMid#">
					and RHControlMarcas.RHJid = a.RHJid
					and RHControlMarcas.RHCMhorasalidac is not null
					and a.RHCJcomportamiento = 'H'
					and a.RHCJmomento = 'D'
					and a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and datediff(mi, convert(varchar, RHControlMarcas.RHCMhorasalidac, 106)+' '+convert(varchar, b.RHJhorafin, 108), RHControlMarcas.RHCMhorasalidac) >= a.RHCJperiodot
					and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, RHControlMarcas.RHCMfregistro), 1) = '1'
					and RHControlMarcas.RHCMfregistro between a.RHCJfrige and a.RHCJfhasta
				</cfquery>
				
			</cfloop>
						
			<!--- =======================Actualizacion de las justificaciones adelantadas de autogestion========================= --->
			
			
			
			<!--- toma los datos para modificar los registros correspondientes --->
				<cfquery  name="datos" datasource="#session.dsn#">
					select  distinct b.RHCMid, a.RHJMUsituacion, a.RHJMUid, a.RHJMUjustificacion 
					from  RHControlMarcas b, RHJustificacionMarcasUsuario a
					where a.DEid = b.DEid
					and a.RHJMUfecha = b.RHCMfregistro
					and a.RHJMUprocesada = 0
				</cfquery> 
				
				<cfif datos.RecordCount GT 0>
					
					<cfloop query="datos">
						<cfquery  name="update" datasource="#session.dsn#"><!--- escribe la justificacion en la marca y tipo de inconsistencia correcta--->
							update RHInconsistencias
							set   RHIjustificacion =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.RHJMUjustificacion#">
							where RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos.RHCMid#">
							and RHItipoinconsistencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos.RHJMUsituacion#">
						</cfquery>
					</cfloop>
					
					<cfloop query="datos"> 
						<cfquery  name="update" datasource="#session.dsn#"><!--- pone el campo de RHJMUprocesada en uno--->
							update RHJustificacionMarcasUsuario
							set   RHJMUprocesada = 1
							where RHJMUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos.RHJMUid#">
						</cfquery>
					</cfloop>
				</cfif>
			
			<!--- PENDIENTE TOMAR EN CUENTAS LAS EXCEPCIONES
			<cfdump var="RHCMidArray">
			<cfabort> --->
			
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
