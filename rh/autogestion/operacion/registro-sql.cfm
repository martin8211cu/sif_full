<cfif isdefined("form.Alta")>
<!---Validacion de los tiempos definidos en parametros rh--->
<!---Semana--->
<cfquery name="rsAut" datasource="#session.dsn#">
		select e.Gid ,min(a.Usucodigo) as Usucodigo
		from RHCMEmpleadosGrupo e
			inner join  RHCMAutorizadoresGrupo a
			on a.Gid=e.Gid
			and a.Ecodigo=e.Ecodigo
		where DEid=#form.DEid#
		and e.Ecodigo=#session.Ecodigo#
		group by e.Gid
	</cfquery>

	<cfif rsAut.recordcount eq 0>
		<cfthrow message="El usuario no ha sido autorizado para ingresar horas extras. Para solucionar este problema debe comunicarse con el jefe inmediato y solicitarle que lo ingrese en un grupo de funcionarios autorizados en Control de Marcas> Definición de Supervisores">
	</cfif>
<cfquery name="rsParamS" datasource="#session.dsn#">
	select Pvalor from RHParametros where
	Pcodigo=2040 and Ecodigo=#session.Ecodigo#
</cfquery>
<!---Mes--->
<cfquery name="rsParamM" datasource="#session.dsn#">
	select Pvalor from RHParametros where
	Pcodigo =2041 and Ecodigo=#session.Ecodigo#
</cfquery>

<cfif isdefined ('rsParamS') and isdefined('rsParamM') and rsParamS.Pvalor gt 0 and rsParamM.Pvalor gt 0 >
	<cfset fechahoramarca=LSDateFormat(form.fechahoramarca,'MM/DD/YYYY')>
	<cfset LvarAno= datepart("yyyy",fechahoramarca)>
	<cfset LvarSemana= datepart("ww",fechahoramarca)>
	<cfset LvarMes= datepart("m",fechahoramarca)>
	
	<!---Averiguar cuantas horas ha trabajado en el mes--->
	<cfquery name="sumM" datasource="#session.dsn#">
		select coalesce(sum(ICvalor),0) as ICvalor
		 from HIncidenciasCalculo
		 where DEid=#form.DEid#
		 and <cf_dbfunction name="date_part" args="mm, ICfecha">=#LvarMes#
		 and <cf_dbfunction name="date_part" args="yyyy, ICfecha">=#LvarAno#
	</cfquery>
	<cfset LvarAcumMes=sumM.ICvalor>
	
	<cfquery name="sumM" datasource="#session.dsn#">
		select coalesce(sum(Ivalor),0) as Ivalor
		 from Incidencias
		 where DEid=#form.DEid#
		 and <cf_dbfunction name="date_part" args="mm, Ifecha">=#LvarMes#
		 and <cf_dbfunction name="date_part" args="yyyy, Ifecha">=#LvarAno#
	</cfquery>
	<cfset LvarAcumMes=LvarAcumMes+sumM.Ivalor>
	
	<cfif LvarAcumMes gt rsParamM.Pvalor>
		<cfthrow message="No se puede realizar la solicitud debido a que se a excedido el número de horas extras permitidas por mes">
	</cfif>
	<!---Averiguar cuantas horas ha trabajado en la semana--->
	<cfquery name="sumW" datasource="#session.dsn#">
		select coalesce(sum(ICvalor),0) as ICvalor
		 from HIncidenciasCalculo
		 where DEid=#form.DEid#
		 and <cf_dbfunction name="date_part" args="wk, ICfecha">=#LvarSemana#
		 and <cf_dbfunction name="date_part" args="yyyy, ICfecha">=#LvarAno#
	</cfquery>
	<cfset LvarAcumWeek=sumW.ICvalor>
	
	<cfquery name="sumW" datasource="#session.dsn#">
		select coalesce(sum(Ivalor),0) as Ivalor
		 from Incidencias
		 where DEid=#form.DEid#
		 and <cf_dbfunction name="date_part" args="wk, Ifecha">=#LvarSemana#
		 and <cf_dbfunction name="date_part" args="yyyy, Ifecha">=#LvarAno#
	</cfquery>
	<cfset LvarAcumWeek=LvarAcumWeek+sumW.Ivalor>
	<cfif LvarAcumWeek gt rsParamS.Pvalor>
		<cfthrow message="No se puede realizar la solicitud debido a que se a excedido el número de horas extras permitidas por semana">
	</cfif>
</cfif>

<!---Esta validacion se hace doble porque se esta insertando doble registro y en el proceso normal se insertan las entradas y las salidas por aparte--->
<cfif isdefined ('form.horamarca_h') and len(trim(form.horamarca_h)) gt 0>
	<cfset hora =#form.horamarca_s#>
	<cfset horaM =#form.horamarca_h#>
	<cfset Mes =#form.horamarca_m#>
	<cfif isdefined("hora") and len(trim(hora))><!---Si es pasado meridiano y no son las 12 medianoche---->
			<cfset vn_horainicio = horaM>
			<cfif hora eq 'PM' and compare(vn_horainicio,'12') neq 0>
				<cfset vn_horainicio = vn_horainicio + 12 >
			<cfelseif hora eq 'AM' and compare(vn_horainicio,'12') eq 0 >
				<cfset vn_horainicio = 0 >
			</cfif>
		</cfif>
		
		<cfset vd_fecha = CreateDateTime(year(LSParseDateTime(form.fechahoramarca)), month(LSParseDateTime(form.fechahoramarca)), day(LSParseDateTime(form.fechahoramarca)), vn_horainicio,Mes,0)>
		
		<cfset verificaHora(form.DEid,vd_fecha)>
</cfif>
<cfif isdefined ('form.horamarca_hs') and len(trim(form.horamarca_hs)) gt 0>
		<cfset hora =#form.horamarca_ss#>
		<cfset horaM =#form.horamarca_hs#>
		<cfset Mes =#form.horamarca_ms#>	
	<cfif isdefined("hora") and len(trim(hora))><!---Si es pasado meridiano y no son las 12 medianoche---->
		<cfset vn_horainicio = horaM>
		<cfif hora eq 'PM' and compare(vn_horainicio,'12') neq 0>
			<cfset vn_horainicio = vn_horainicio + 12 >
		<cfelseif hora eq 'AM' and compare(vn_horainicio,'12') eq 0 >
			<cfset vn_horainicio = 0 >
		</cfif>
	</cfif>
	
	<cfset vd_fecha = CreateDateTime(year(LSParseDateTime(form.fechahoramarca)), month(LSParseDateTime(form.fechahoramarca)), day(LSParseDateTime(form.fechahoramarca)), vn_horainicio,Mes,0)>
	
	<cfset verificaHora(form.DEid,vd_fecha)>
</cfif>	
	
	<cfif isdefined ('form.horamarca_h') and len(trim(form.horamarca_h)) gt 0 and form.horamarca_h neq 0>
		<cfset InsertaDatos('E')>
	</cfif>
	<cfif isdefined ('form.horamarca_hs') and len(trim(form.horamarca_hs)) gt 0 and form.horamarca_hs neq 0>
		<cfset InsertaDatos('S')>
	</cfif>
	<cflocation url="registro.cfm">
</cfif>

<cfif isdefined('form.Nuevo')>
	<cflocation url="registro.cfm">
</cfif>

<cfif isdefined ('Aplicar')>

<cfquery name="rsform" datasource="#session.dsn#">
	select DEid,fechahoramarca,ltrim(rtrim(tipomarca)) as tipomarca,RHCMid
	from RHControlMarcas where 
	Ecodigo=#session.Ecodigo#
	and DEid=#form.DEid#
	and registroaut =0
</cfquery>

	<cfquery name="rsAplica" datasource="#session.dsn#">
		update RHControlMarcas 
		set registroaut =1 , 
			fechahoraautorizado=#now()#, 
			usuarioautor=#session.Usucodigo#
		where Ecodigo=#session.Ecodigo#
		and DEid=#form.DEid#
		and registroaut=0
	</cfquery>
	

	<cfquery name="rsAut" datasource="#session.dsn#">
		select e.Gid ,min(a.Usucodigo) as Usucodigo
		from RHCMEmpleadosGrupo e
			inner join  RHCMAutorizadoresGrupo a
			on a.Gid=e.Gid
			and a.Ecodigo=e.Ecodigo
		where DEid=#form.DEid#
		and e.Ecodigo=#session.Ecodigo#
		group by e.Gid
	</cfquery>

	<cfif rsAut.recordcount eq 0>
		<cfthrow message="El usuario no ha sido autorizado para ingresar horas extras. Para solucionar este problema debe comunicarse con el jefe inmediato y solicitarle que lo ingrese en un grupo de funcionarios autorizados en Control de Marcas> Definición de Supervisores">
	</cfif>
	<cfinvoke component="rh.Componentes.RH_ProcesoAgrupaMarcas" method="RH_ProcesoAgrupaMarcas">
		<cfinvokeargument name="Usucodigo2" value="#rsAut.Usucodigo#">
	</cfinvoke>

	<cflocation url="registro.cfm">
</cfif>

<cfif isdefined ('form.Baja')>
	<cfquery name="rsEli" datasource="#session.dsn#">
		delete from RHControlMarcas where RHCMid=#form.RHCMid# and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cflocation url="registro.cfm">
</cfif>

<cfif isdefined ('form.Cambio')>

<cfset rsDatos = funDatosJornada(form.DEid,form.fechahoramarca)>
<cfif form.tipo eq 'E'>
		<cfset hora =#form.horamarca_s#>
		<cfset horaM =#form.horamarca_h#>
		<cfset Mes =#form.horamarca_m#>
	<cfelse>
		<cfset hora =#form.horamarca_ss#>
		<cfset horaM =#form.horamarca_hs#>
		<cfset Mes =#form.horamarca_ms#>
	</cfif>
	
	<cfif isdefined("hora") and len(trim(hora))><!---Si es pasado meridiano y no son las 12 medianoche---->
		<cfset vn_horainicio = horaM>
		<cfif hora eq 'PM' and compare(vn_horainicio,'12') neq 0>
			<cfset vn_horainicio = vn_horainicio + 12 >
		<cfelseif hora eq 'AM' and compare(vn_horainicio,'12') eq 0 >
			<cfset vn_horainicio = 0 >
		</cfif>
	</cfif>
	
	<cfset vd_fecha = CreateDateTime(year(LSParseDateTime(form.fechahoramarca)), month(LSParseDateTime(form.fechahoramarca)), day(LSParseDateTime(form.fechahoramarca)), vn_horainicio,Mes,0)>
	
	<cfset verificaHora(form.DEid,vd_fecha)>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update RHControlMarcas
			set tipomarca=<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">,
 				fechahoramarca=	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">	
		where  RHCMid=#form.RHCMid# and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cflocation url="registro.cfm?RHCMid=#form.RHCMid#">
</cfif>

<!---*************************************************************************************************--->
<!---                                             FUNCIONES                                           --->
<!---*************************************************************************************************--->

<!--- Función para evitar que se inserte para una misma fecha a la misma hora mas de una marca.       --->
<cffunction name="verificaHora" access="private" output="true" returntype="boolean">
	<cfargument name="DEid" type="numeric" required="true">
	<cfargument name="fechahoramarca" type="string" required="true">
	<cfargument name="RHCMid" type="numeric" required="no" default="0">
	<cfquery name="rsvh" datasource="#session.dsn#">
		select 1
		from RHControlMarcas
		where 	
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">			
				and fechahoramarca = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fechahoramarca#">
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

<!---============================== Función: funDatosJornada =======================================----->
<!--- Función para obtener los datos de los horarios de la jornada que se encuentra definida en la linea del tiempo para esa fecha----->

<cffunction name="funDatosJornada" access="public" output="true" returntype="query">
	<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
	<cfargument name="arg_fecha" 	type="date" 	required="yes">
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
</cffunction>

<!---Funcion que inserta los datos correspondientes al registro de marcas--->
<cffunction name="InsertaDatos" access="private" output="true" >
	<cfargument name="tipo" type="any" required="yes">
	<cfset rsDatos = funDatosJornada(form.DEid,form.fechahoramarca)>
	<cfif rsDatos.RecordCount EQ 0><!---Si el tipo de marca es SB o EB (Break's)--->
		<cf_throw message="No existe la jornada" errorcode="5085">
	</cfif>
	
	<cfif arguments.tipo eq 'E'>
		<cfset hora =#form.horamarca_s#>
		<cfset horaM =#form.horamarca_h#>
		<cfset Mes =#form.horamarca_m#>
	<cfelse>
		<cfset hora =#form.horamarca_ss#>
		<cfset horaM =#form.horamarca_hs#>
		<cfset Mes =#form.horamarca_ms#>
	</cfif>
	
	<cfif isdefined("hora") and len(trim(hora))><!---Si es pasado meridiano y no son las 12 medianoche---->
		<cfset vn_horainicio = horaM>
		<cfif hora eq 'PM' and compare(vn_horainicio,'12') neq 0>
			<cfset vn_horainicio = vn_horainicio + 12 >
		<cfelseif hora eq 'AM' and compare(vn_horainicio,'12') eq 0 >
			<cfset vn_horainicio = 0 >
		</cfif>
	</cfif>
	
	<cfset vd_fecha = CreateDateTime(year(LSParseDateTime(form.fechahoramarca)), month(LSParseDateTime(form.fechahoramarca)), day(LSParseDateTime(form.fechahoramarca)), vn_horainicio,Mes,0)>
	
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
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
				<cfif isdefined("form.RHASid") and len(trim(form.RHASid))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHASid#">,
				<cfelse>
					null,
				</cfif>
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.tipo#">,
				<cfif isdefined("form.justificacion") and len(trim(form.justificacion))>
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.justificacion#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("form.registroaut")>
					1,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfelse>
					0,
					null,
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">,
				0,
				<cfif len(trim(rsDatos.Jornada))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Jornada#">,
				<cfelse>
					null,
				</cfif> 
				<cfif len(trim(rsDatos.Planificador))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Planificador#">,
				<cfelse>
					null,	
				</cfif>				
				<cfif arguments.tipo EQ 'E'><!---Si la marca es de entrada--->
					<cfif len(trim(rsDatos.HoraInicioPlan))>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.HoraInicioPlan#">
					<cfelse>	
						null
					</cfif>,
				<cfelseif arguments.tipo EQ 'S'><!---Si la marca es de salida--->
					<cfif len(trim(rsDatos.HoraFinPlan))>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.HoraFinPlan#">
					<cfelse>	
						null
					</cfif>,
				<cfelse>
					null,
				</cfif>				
				<cfif arguments.tipo EQ 'E' ><!-----Si la marca es de entrada----->
					<cfif len(trim(rsDatos.AntesEntrada))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.AntesEntrada#">
					<cfelse>	
						null
					</cfif>,
				<cfelseif arguments.tipo EQ 'S' ><!-----Si la marca es de salida----->
					<cfif len(trim(rsDatos.AntesSalida))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.AntesSalida#">
					<cfelse>	
						null
					</cfif>,
				<cfelse>
					null,
				</cfif>				
				<cfif arguments.tipo EQ 'E'><!-----Si la marca es de entrada----->
					<cfif len(trim(rsDatos.DespuesEntrada))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DespuesEntrada#">
					<cfelse>	
						null
					</cfif>,
				<cfelseif arguments.tipo EQ 'S'><!-----Si la marca es de salida----->
					<cfif len(trim(rsDatos.DespuesSalida))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DespuesSalida#">
					<cfelse>	
						null
					</cfif>,
				<cfelse>
					null,
				</cfif>							
				null,
				null,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
	</cfquery>
</cffunction>