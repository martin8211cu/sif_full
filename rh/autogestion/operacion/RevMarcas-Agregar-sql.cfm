<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoExisteJornadaParaElDiaIndicado"
	Default="No hay jornada definida para el día indicado"	
	returnvariable="MSG_NoExisteJornada"/>

<!---============================== Función: funDatosJornada =======================================----->
<!--- Función para obtener los datos de la jornada ya sea del planificador (si para esa fecha se 	----->
<!--- planificó algo) o bien de los horarios de la jornada que se encuentra definida en la linea 	----->
<!--- del tiempo para esa fecha																		----->
<!---================================================================================================---->
<cffunction name="funDatosJornada" access="public" output="true" returntype="query">
	<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
	<cfargument name="arg_fecha" 	type="date" 	required="yes">
		<cfquery name="rsPlanificador" datasource="#session.DSN#"><!---Buscar los datos en el planificador--->
			select 	a.RHPJid as Planificador,
					a.RHJid as Jornada,
					a.RHPJfinicio as HoraInicioPlan,
					a.RHPJffinal as HoraFinPlan,
					(select RHCJperiodot
					from RHComportamientoJornada b
					where a.RHJid = b.RHJid
						and b.RHCJcomportamiento = 'H'
						and b.RHCJmomento = 'D') as DespuesSalida,
					(select RHCJperiodot
					from RHComportamientoJornada b
					where a.RHJid = b.RHJid
						and b.RHCJcomportamiento = 'R'
						and b.RHCJmomento = 'A') as AntesSalida,
					(select RHCJperiodot
					from RHComportamientoJornada b
					where a.RHJid = b.RHJid
						and b.RHCJcomportamiento = 'H'
						and b.RHCJmomento = 'A') as AntesEntrada,
					(select RHCJperiodot
					from RHComportamientoJornada b
					where a.RHJid = b.RHJid
						and b.RHCJcomportamiento = 'R'
						and b.RHCJmomento = 'D') as DespuesEntrada
			from RHPlanificador a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">				
				and <cf_dbfunction name="date_format" args="a.RHPJfinicio,yyyymmdd"> = <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(Arguments.arg_fecha),'yyyymmdd')#"> 
		</cfquery>
		<cfif rsPlanificador.RecordCount EQ 0><!----Si no tiene nada en el planificador---->
			<cfquery name="rsLineaT" datasource="#session.DSN#"><!---Busca la joranada y el horario--->
				select 	'' as Planificador,
						a.RHJid as Jornada
						,d.RHJhoraini as HoraInicioPlan,
						d.RHJhorafin as HoraFinPlan,
						(select RHCJperiodot
						from RHComportamientoJornada b
						where a.RHJid = b.RHJid
							and b.RHCJcomportamiento = 'H'
							and b.RHCJmomento = 'D') as DespuesSalida,
						(select RHCJperiodot
						from RHComportamientoJornada b
						where a.RHJid = b.RHJid
							and b.RHCJcomportamiento = 'R'
							and b.RHCJmomento = 'A') as AntesSalida,
						(select RHCJperiodot
						from RHComportamientoJornada b
						where a.RHJid = b.RHJid
							and b.RHCJcomportamiento = 'H'
							and b.RHCJmomento = 'A') as AntesEntrada,
						(select RHCJperiodot
						from RHComportamientoJornada b
						where a.RHJid = b.RHJid
							and b.RHCJcomportamiento = 'R'
							and b.RHCJmomento = 'D') as DespuesEntrada
												
				from LineaTiempo a
					inner join RHJornadas c
						on a.RHJid = c.RHJid
						
						<!---inner join RHDJornadas d	<!---Obtener los datos del horario de la jornada ---->---->
						left outer join RHDJornadas d
							on c.RHJid = d.RHJid
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('w',LSParseDateTime(Arguments.arg_fecha))#">  =  d.RHDJdia
			
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">		
					and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(Arguments.arg_fecha),'yyyymmdd')#"> 
						between <cf_dbfunction name="date_format" args="a.LTdesde,yyyymmdd"> and
							 	<cf_dbfunction name="date_format" args="a.LThasta,yyyymmdd">
				
			</cfquery>
			<cfif rsPlanificador.RecordCount EQ 0>
				<cfif rsLineaT.RecordCount NEQ 0>
					<!----NOTA: La fecha de la hora planificada TIENE que ser igual a la fecha de la marca, lo que interesa es la hora, esto para efectos de comparacion ---->
					<cfif len(trim(rsLineaT.HoraInicioPlan)) and len(trim(rsLineaT.HoraFinPlan))>
						<cfset rsLineaT.HoraInicioPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)), 
								DatePart("h", "#rsLineaT.HoraInicioPlan#"), DatePart("n", "#rsLineaT.HoraInicioPlan#"),DatePart("s", "#rsLineaT.HoraInicioPlan#"))>
						<cfset rsLineaT.HoraFinPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)), 
								DatePart("h", "#rsLineaT.HoraFinPlan#"), DatePart("n", "#rsLineaT.HoraFinPlan#"),DatePart("s", "#rsLineaT.HoraFinPlan#"))>											
					</cfif>
				</cfif>
				<cfreturn rsLineaT>				
			</cfif>
		<cfelse>
			<!----NOTA: La fecha de la hora planificada TIENE que ser igual a la fecha de la marca, lo que interesa es la hora, esto para efectos de comparacion ---->
			<cfif len(trim(rsPlanificador.HoraInicioPlan)) and len(trim(rsPlanificador.HoraFinPlan))>
				<cfset rsPlanificador.HoraInicioPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)), 
						DatePart("h", "#rsPlanificador.HoraInicioPlan#"), DatePart("n", "#rsPlanificador.HoraInicioPlan#"),DatePart("s", "#rsPlanificador.HoraInicioPlan#"))>
				<cfset rsPlanificador.HoraFinPlan = CreateDateTime(year(LSParseDateTime(arg_fecha)), month(LSParseDateTime(arg_fecha)), day(LSParseDateTime(arg_fecha)), 
						DatePart("h", "#rsPlanificador.HoraFinPlan#"), DatePart("n", "#rsPlanificador.HoraFinPlan#"),DatePart("s", "#rsPlanificador.HoraFinPlan#"))>
			</cfif>
			<cfreturn rsPlanificador>
		</cfif>	
</cffunction>
<!--- Función para evitar que se inserte para una misma fecha a la misma hora mas de una marca.       --->
<cffunction name="verificaHora" access="private" output="true" returntype="boolean">
	<cfargument name="DEid" type="numeric" required="true">
	<cfargument name="fechahoramarca" type="string" required="true">
	<cfargument name="RHCMid" type="numeric" required="no" default="0">
	<cfquery name="rsvh" datasource="#session.dsn#">
		select 1
		from RHControlMarcas
		where 	<!----- ===== Ecodigo ===== ------>
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<!----- ===== DEid ===== ------>
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				<!---====== fechahoramarca ======--->
				and fechahoramarca = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fechahoramarca#">
				<!---====== RHCMid ======--->
				<cfif arguments.RHCMid GT 0>
				and RHCMid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCMid#">
				</cfif>
	</cfquery>
	<cfif rsvh.recordcount gt 0>
		<cfquery name="rsE" datasource="#session.dsn#">
			select 
			{fn concat({fn concat({fn concat({fn concat({fn concat({fn concat(
			DEidentificacion, ' - ')},
			DEapellido1)},' ')},
			DEapellido2)},' ')},
			DEnombre)} as val
			from DatosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
		<cf_throw message="Ya existe una marca para el empleado #rsE.val#, en la fecha #LSDateFormat(vd_fecha,'dd/mm/yyyy')# y hora #LSTimeFormat(vd_fecha,'hh:mm tt')#." errorcode="5080">
	</cfif>
	<cfreturn true>
</cffunction>
<!----Hora de marca--->
<cfif isdefined("form.horamarca_s") and len(trim(form.horamarca_s))><!---Si es pasado meridiano y no son las 12 medianoche---->
	<cfset vn_horainicio = form.horamarca_h>
	<cfif form.horamarca_s eq 'PM' and compare(vn_horainicio,'12') neq 0>
		<cfset vn_horainicio = vn_horainicio + 12 >
	<cfelseif form.horamarca_s eq 'AM' and compare(vn_horainicio,'12') eq 0 >
		<cfset vn_horainicio = 0 >
	</cfif>
</cfif>
<cfset vd_fecha = CreateDateTime(year(LSParseDateTime(form.fechahoramarca)), month(LSParseDateTime(form.fechahoramarca)), day(LSParseDateTime(form.fechahoramarca)), vn_horainicio, form.horamarca_m,0)>
<!---=========== Agregar marca ============---->
<cfif isdefined("form.btnAgregar")>	
	<cfset rsDatos = funDatosJornada(form.DEid,form.fechahoramarca)>
	<cfif rsDatos.RecordCount EQ 0 and form.Atipomarca NEQ 'EB' and  form.Atipomarca NEQ 'SB'><!---Si el tipo de marca es SB o EB (Break's)--->
		<cf_throw message="#MSG_NoExisteJornada#" errorcode="5085">
	</cfif>
	<cfset verificaHora(form.DEid,vd_fecha)>
	<cfquery datasource="#session.DSN#">
		insert into RHControlMarcas(Ecodigo, 
									DEid, 
									RHASid, 
									fechahorareloj, 
									tipomarca, 
									justificacion, 
									registroaut, 
									fechahoraautorizado, 
									usuarioautor, 
									fechahoramarca, 
									regprocesado, 
									RHJid, 
									RHPJid, 
									RHCMhoraplan, 
									ttoleranciaantes, 
									ttoleranciadesp, 
									numlote, 
									canthoras, 
									BMUsucodigo, 
									BMfecha)
		values(	<!----- ===== Ecodigo ===== ------>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<!----- ===== DEid ===== ------>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
				<!---- ===== RHASid ===== ---->
				<cfif isdefined("form.RHASid") and len(trim(form.RHASid))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHASid#">,
				<cfelse>
					null,
				</cfif>
				<!----- ===== fechahorareloj =====----->
				null,
				<!-----===== tipomarca =====--->
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.AtipoMarca#">,
				<!----====== justificacion ======----->
				<cfif isdefined("form.justificacion") and len(trim(form.justificacion))>
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.justificacion#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("form.registroaut")>
					<!----====== registroaut ======---->
					1,
					<!----==== fechahoraautorizado =====--->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<!---- ====== usuarioautor ======---->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfelse>
					<!--- ====== registroaut ======--->
					0,
					<!----==== fechahoraautorizado =====--->
					null,
					<!---- ====== usuarioautor ======---->
					null,
				</cfif>
				<!---====== fechahoramarca ======--->
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">,
				<!-----===== regprocesado ======----->
				0,
				<!---===== RHJid =====--->
				<cfif len(trim(rsDatos.Jornada))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Jornada#">,
				<cfelse>
					null,
				</cfif> 
				<!-----===== RHPJid =====----->
				<cfif len(trim(rsDatos.Planificador))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Planificador#">,
				<cfelse>
					null,	
				</cfif>				
				<!------==== RHCMhoraplan =====--->
				<cfif form.AtipoMarca EQ 'E'><!---Si la marca es de entrada--->
					<cfif len(trim(rsDatos.HoraInicioPlan))>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.HoraInicioPlan#">
					<cfelse>	
						null
					</cfif>,
				<cfelseif form.AtipoMarca EQ 'S'><!---Si la marca es de salida--->
					<cfif len(trim(rsDatos.HoraFinPlan))>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.HoraFinPlan#">
					<cfelse>	
						null
					</cfif>,
				<cfelse>
					null,
				</cfif>				
				<!-----===== ttoleranciaantes =====----->
				<cfif form.AtipoMarca EQ 'E' ><!-----Si la marca es de entrada----->
					<cfif len(trim(rsDatos.AntesEntrada))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.AntesEntrada#">
					<cfelse>	
						null
					</cfif>,
				<cfelseif form.AtipoMarca EQ 'S' ><!-----Si la marca es de salida----->
					<cfif len(trim(rsDatos.AntesSalida))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.AntesSalida#">
					<cfelse>	
						null
					</cfif>,
				<cfelse>
					null,
				</cfif>				
				<!-----===== ttoleranciadesp =====----->
				<cfif form.AtipoMarca EQ 'E'><!-----Si la marca es de entrada----->
					<cfif len(trim(rsDatos.DespuesEntrada))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DespuesEntrada#">
					<cfelse>	
						null
					</cfif>,
				<cfelseif form.AtipoMarca EQ 'S'><!-----Si la marca es de salida----->
					<cfif len(trim(rsDatos.DespuesSalida))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DespuesSalida#">
					<cfelse>	
						null
					</cfif>,
				<cfelse>
					null,
				</cfif>								
				<!---- ===== numlote ===== ----->
				null,
				<!---- ===== canthoras ===== ----->
				null,
				<!---- ===== BMUsucodigo ===== ---->
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<!---- ===== BMfecha ===== ---->
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
	</cfquery>
<!----========= Eliminar marca ===========--->
<cfelseif isdefined("form.btnEliminar")>
	<cfquery name="traeGrupo" datasource="#session.DSN#">
		select grupomarcas
		from RHControlMarcas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
	</cfquery>
	<cfif len(trim(traeGrupo.grupomarcas))>
		<cfquery datasource="#session.DSN#">
			update RHControlMarcas
			set grupomarcas = null
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#traeGrupo.grupomarcas#">
		</cfquery>
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into HRHControlMarcas (RHCMid, Ecodigo, DEid, RHASid, fechahorareloj, tipomarca, justificacion, registroaut, fechahoraautorizado, usuarioautor, fechahoramarca, regprocesado, RHJid, RHPJid, RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, numlote, canthoras, grupomarcas, BMUsucodigo, BMfecha)
		select RHCMid, Ecodigo, DEid, RHASid, fechahorareloj, tipomarca, justificacion, registroaut, fechahoraautorizado, usuarioautor, fechahoramarca, regprocesado, RHJid, RHPJid, RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, numlote, canthoras, grupomarcas, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		from RHControlMarcas
		where RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from RHControlMarcas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
	</cfquery>
	
<!-----========== Modificar marca ===========----->	
<cfelseif isdefined("form.btnModificar")>
	<cfset rsDatos = funDatosJornada(form.DEid,form.fechahoramarca)>
	<cfif rsDatos.RecordCount EQ 0 and form.Atipomarca NEQ 'EB' and  form.Atipomarca NEQ 'SB'>
		<cf_throw message="#MSG_NoExisteJornada#" errorcode="5085">
	</cfif>
	
	<cfquery name="traeGrupo" datasource="#session.DSN#">
		select grupomarcas
		from RHControlMarcas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
	</cfquery>
	<cfif len(trim(traeGrupo.grupomarcas))>
		<cfquery datasource="#session.DSN#">
			update RHControlMarcas
			set grupomarcas = null
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#traeGrupo.grupomarcas#">
		</cfquery>
	</cfif>
	
	<cfset verificaHora(form.DEid,vd_fecha,form.RHCMid)>
	<cfquery datasource="#session.DSN#">
		update RHControlMarcas set
			tipomarca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.AtipoMarca#">,
			justificacion = <cfif isdefined("form.justificacion") and len(trim(form.justificacion))>
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.justificacion#">
							<cfelse>
								null
							</cfif>,
			<cfif isdefined("form.registroaut")>
				registroaut = 1,
				fechahoraautorizado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				usuarioautor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfelse>
				registroaut = 0,
				fechahoraautorizado = null,
				usuarioautor = null,
			</cfif>			
			fechahoramarca = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">,
			regprocesado = 0,
			RHJid = <cfif len(trim(rsDatos.Jornada))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Jornada#">
					<cfelse>
						null
					</cfif>,
			RHPJid = 	<cfif len(trim(rsDatos.Planificador))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Planificador#">
						<cfelse>
							null
						</cfif>,
			RHCMhoraplan =	<cfif form.AtipoMarca EQ 'E'><!---Si la marca es de entrada--->
								<cfif len(trim(rsDatos.HoraInicioPlan))>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.HoraInicioPlan#">
								<cfelse>
									null
								</cfif>,
							<cfelseif form.AtipoMarca EQ 'S'><!---Si la marca es de salida--->
								<cfif len(trim(rsDatos.HoraFinPlan))>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.HoraFinPlan#">
								<cfelse>
									null
								</cfif>,
							<cfelse>
								null,
							</cfif>	
			ttoleranciaantes = 	<cfif form.AtipoMarca EQ 'E' ><!-----Si la marca es de entrada----->
									<cfif len(trim(rsDatos.AntesEntrada))>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.AntesEntrada#">
									<cfelse>
										null
									</cfif>,
								<cfelseif form.AtipoMarca EQ 'S' ><!-----Si la marca es de salida----->
									<cfif len(trim(rsDatos.AntesSalida))>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.AntesSalida#">
									<cfelse>
										null
									</cfif>,
								<cfelse>
									null,
								</cfif>	
			ttoleranciadesp = 	<cfif form.AtipoMarca EQ 'E'><!-----Si la marca es de entrada----->
									<cfif len(trim(rsDatos.DespuesEntrada))>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DespuesEntrada#">
									<cfelse>
										null
									</cfif>,										
								<cfelseif form.AtipoMarca EQ 'S'><!-----Si la marca es de salida----->
									<cfif len(trim(rsDatos.DespuesSalida))>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DespuesSalida#">
									<cfelse>
										null
									</cfif>,	
								<cfelse>
									null,
								</cfif>	
			RHASid = 	<cfif isdefined("form.RHASid") and len(trim(form.RHASid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHASid#">
						<cfelse>
							null
						</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
	</cfquery>
	<!---======= Si se des-autoriza la marca se elimina el grupo al que pertenece =======---->
	<cfif not isdefined("form.registroaut")>
		<cfquery name="rs" datasource="#session.DSN#">
			select grupomarcas from RHControlMarcas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#"> 
		</cfquery>
		<cfif rs.RecordCount NEQ 0 and len(trim(rs.grupomarcas))>
			<cfquery datasource="#session.DSN#">
				update RHControlMarcas
				set grupomarcas = null
				where grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.grupomarcas#"> 
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<cfif isdefined("url.PageNum") and len(trim(url.PageNum))>
	<cfset form.pagina = url.PageNum>
</cfif>	
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.pagina = url.Pagina>
</cfif>	
<cfparam name="form.pagina" default="1">
<cfoutput>
	<form name="form1" action="RevMarcas-tabs.cfm" method="post">		
		<cfif isdefined("form.chkTodos")>
			<input type="hidden" name="Todos" value="1">
		</cfif>
		<input type="hidden" name="btnFiltrar" value="btnFiltrar">	
		<input type="hidden" name="chk" value="<cfif isdefined("form.chkTodos")>#form.chk#</cfif>">	
		<input type="hidden" name="FDEid" value="<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>#form.FDEid#</cfif>">		
		<input type="hidden" name="FDEIdentificacion" value="<cfif isdefined("form.FDEIdentificacion") and len(trim(form.FDEIdentificacion))>#form.FDEIdentificacion#</cfif>">
		<input type="hidden" name="FNombre" value="<cfif isdefined("form.FNombre") and len(trim(form.FNombre))>#form.FNombre#</cfif>">
		<input type="hidden" name="Grupo" value="<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>#form.Grupo#</cfif>">
		<input type="hidden" name="ver" value="<cfif isdefined("form.ver") and len(trim(form.ver))>#form.ver#</cfif>">
		<input type="hidden" name="Inicio_h" value="<cfif isdefined("form.Inicio_h") and len(trim(form.Inicio_h))>#form.Inicio_h#</cfif>">	
		<input type="hidden" name="Inicio_m" value="<cfif isdefined("form.Inicio_m") and len(trim(form.Inicio_m))>#form.Inicio_m#</cfif>">	
		<input type="hidden" name="Inicio_s" value="<cfif isdefined("form.Inicio_s") and len(trim(form.Inicio_s))>#form.Inicio_s#</cfif>">	
		<input type="hidden" name="Fin_h" value="<cfif isdefined("form.Fin_h") and len(trim(form.Fin_h))>#form.Fin_h#</cfif>">	
		<input type="hidden" name="Fin_m" value="<cfif isdefined("form.Fin_m") and len(trim(form.Fin_m))>#form.Fin_m#</cfif>">	
		<input type="hidden" name="Fin_s" value="<cfif isdefined("form.Fin_s") and len(trim(form.Fin_s))>#form.Fin_s#</cfif>">
		<input type="hidden" name="FTipoMarca" value="<cfif isdefined("form.FTipoMarca") and len(trim(form.FTipoMarca))>#form.FTipoMarca#</cfif>">
		<input type="hidden" name="fechaInicio" value="<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>#form.fechaInicio#</cfif>">
		<input type="hidden" name="fechaFinal" value="<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>#form.fechaFinal#</cfif>">
		<input type="hidden" name="ordenarpor" valuut type="hidden" name="ordenarpor" value="<cfif isdefined("form.ordenarpor") and len(trim(form.ordenarpor))>#form.ordenarpor#</cfif>">
		<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and len(trim(form.Estado))>#form.Estado#</cfif>">	
		<input type="hidden" name="pagina" value="#form.pagina#">
	</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
