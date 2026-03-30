
<cfcomponent>
	<!--- VARIABLES DE TRADUCCIÓN --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_El_empleado_no_tiene_jornada_definida_para_alguna_de_las_marcas"
		default="El empleado no tiene jornada definida para alguna de las marcas"
		returnvariable="MSG_EmpleadoNoTieneJornada"
		xmlfile="/rh/Componentes/RH_ProcesoGeneraMarcas.xml"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_No_se_encuentro_la_jornada"
		default="No se encontró la jornada"	
		returnvariable="MSG_NoSeEncuentroLaJornada"
		xmlfile="/rh/Componentes/RH_ProcesoGeneraMarcas.xml"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"
		default="Usted no tiene grupos asociados. No puede acceder este proceso."
		returnvariable="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"
		xmlfile="/rh/Componentes/RH_ProcesoGeneraMarcas.xml"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_Error_calculando_el_tiempo_de_ocio_estimado_para_el_empleado"
		default="Error calculando el tiempo de ocio estimado para el empleado"	
		returnvariable="MSG_Error_calculando_el_tiempo_de_ocio_estimado_para_el_empleado"
		xmlfile="/rh/Componentes/RH_ProcesoGeneraMarcas.xml"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_para_la_fecha"
		default="MSG para la fecha"	
		returnvariable="MSG_para_la_fecha"
		xmlfile="/rh/Componentes/RH_ProcesoGeneraMarcas.xml"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_Hacen_falta_datos_de_la_jornada"
		default="Hacen falta datos de la jornada:"	
		returnvariable="MSG_HacenFaltaDatosDeLaJornada"
		xmlfile="/rh/Componentes/RH_ProcesoGeneraMarcas.xml"/>
	<!----Calculadora---->
	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
	<!---	============================== Función: funAccionPaga =======================================
			Función para verificar si el empleado tiene una accion de tipo NO PAGA en la fecha que recibe
			de parámetro.  Devuelve un true si tiene y false si no									     
			=============================================================================================
	--->
	<cffunction name="funAccionPaga" access="private" output="false" returntype="boolean">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
		<cfargument name="arg_fecha" 	type="date" 	required="yes">
			<cfset vn_retorno = false>
			<cfquery name="rsLineaT" datasource="#Arguments.Conexion#">
				select b.RHTpaga,a.LTdesde, a.LThasta, a.RHTid, b.RHTcodigo
				from LineaTiempo a
					inner join RHTipoAccion b
						on a.RHTid = b.RHTid
						and b.RHTpaga = 0
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.arg_fecha#"> between a.LTdesde and a.LThasta
			</cfquery>
			<cfif rsLineaT.RecordCount NEQ 0>
				<cfset vn_retorno = true>
			</cfif>
			<cfreturn vn_retorno>
	</cffunction>
	<!---	============================== Función: funJornada =====================================
			Función que devuelve datos de la jornada del empleado en una fecha específica.  Si tiene
			planificador lo utiliza  sino la jornada que este en la línea del tiempo. 				
			========================================================================================
	--->
	<cffunction name="funJornada" access="private" output="true" returntype="query">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
		<cfargument name="arg_fecha" 	type="date" 	required="yes">
		<cfquery name="rsPlanificador" datasource="#Arguments.Conexion#"><!---Buscar los datos en el planificador--->
				select 	'RHPlanificador' as Origen,
						a.RHJid,
						coalesce(b.RHJornadahora,0) as PagoPorHoras,
						coalesce(b.RHJincAusencia,0) as RHJincAusencia,
						coalesce(b.RHJincHJornada,0) as RHJincHJornada,
						coalesce(b.RHJincExtraA,0) as RHJincExtraA,
						coalesce(b.RHJincExtraB,0) as RHJincExtraB,
						coalesce(b.RHJincFeriados,0) as RHJincFeriados,		
						c.CItipo as TipoCalculo,
						coalesce(e.CIcantidad,0) as CIcantidad,
						e.CIrango,
						e.CItipo,
						e.CIdia,
						e.CImes,
						e.CIcalculo,
						(select  max(Tcodigo)
						from LineaTiempo d
						where <cf_dbfunction name="to_datechar" args="a.RHPJfinicio"> between LTdesde and LThasta
							and a.DEid = d.DEid
						)as Tcodigo,
						b.RHJhoradiaria,
						e.CIspcantidad,
						e.CIsprango 
						
				from RHPlanificador a
					inner join RHJornadas b
						on a.RHJid = b.RHJid
						
						left outer join CIncidentes c
							on b.RHJincFeriados = c.CIid
							
							left outer join CIncidentesD e
								on c.CIid = e.CIid
						
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
					and <cf_dbfunction name="to_datechar" args="a.RHPJfinicio"> = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.arg_fecha#">
		</cfquery>
		<!--- ESTUDIAR POR QUE SIEMPRE ENCUENTRA UNA PLANIFICACIÓN SI REALMENTE NO EXISTE NINGUNA --->
		<cfif rsPlanificador.RecordCount EQ 0><!----Si no tiene nada en el planificador---->
			<cfquery name="rsLineaT" datasource="#Arguments.Conexion#"><!---Busca la joranada y el horario--->
					select  'LineaTiempo' as Origen,
							a.RHJid,
							coalesce(b.RHJornadahora,0) as PagoPorHoras,
							coalesce(b.RHJincAusencia,0) as RHJincAusencia,
							coalesce(b.RHJincHJornada,0) as RHJincHJornada,
							coalesce(b.RHJincExtraA,0) as RHJincExtraA,
							coalesce(b.RHJincExtraB,0) as RHJincExtraB,
							coalesce(b.RHJincFeriados,0) as RHJincFeriados,
							c.CItipo as TipoCalculo,
							coalesce(e.CIcantidad,0) as CIcantidad,
							e.CIrango,
							e.CItipo,
							e.CIdia,
							e.CImes,
							e.CIcalculo,
							a.Tcodigo,
							b.RHJhoradiaria
					from LineaTiempo a
						inner join RHJornadas b
							on a.RHJid = b.RHJid			
						left outer join CIncidentes c
							on b.RHJincFeriados = c.CIid
						left outer join CIncidentesD e
							on c.CIid = e.CIid
								
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.arg_fecha#">
							between <cf_dbfunction name="to_datechar" args="a.LTdesde"> 
							and <cf_dbfunction name="to_datechar" args="a.LThasta">
			</cfquery>
			<cfif rsPlanificador.RecordCount EQ 0>
				<cfreturn rsLineaT>				
			</cfif>
		<cfelse>
			<cfreturn rsPlanificador>
		</cfif>
	</cffunction>
	<!---	============================== Función: funDatosJornada ==========================================
		 	Función que devuelve los datos de la jornada y del horario para una fecha especifica y una jornada
			==================================================================================================
	----->
	<cffunction name="funDatosJornada" access="private" output="false" returntype="query">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="arg_RHJid"  	type="numeric" 	required="yes">
		<cfargument name="arg_Fecha" 	type="date" 	required="yes">
		<cfargument name="arg_DEid" 	type="string" 	required="yes">
			<cfset LvarRHPlibre = 0>
			<cfquery name="rsRHPlanificador" datasource="#Arguments.Conexion#">
				select 1 
				from RHPlanificador  c
				where c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
				  and <cf_dbfunction name="date_format" args="c.RHPJfinicio,yyyymmdd"> = <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(Arguments.arg_Fecha,'yyyymmdd')#"> 
				  and c.RHPlibre = 1
			</cfquery>		
			<cfif rsRHPlanificador.recordcount>
				<cfset LvarRHPlibre = 1>
			</cfif>
			
			<!--- 20110701 Si RHJtipoPago=1 Significa que no hay que ver el Horario, para saber el costo de los Topes por Tipo Hora, se saca directo Jornada --->
			<cfquery name="HorariooDia" datasource="#Arguments.Conexion#">
				select RHJtipoPago 
				from RHJornadas
				where RHJid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_RHJid#">
			</cfquery>				

			<cfif HorariooDia.RHJtipoPago EQ 0>		
				<cfset Lvar_dw = DatePart('w',#Arguments.arg_Fecha#)>
			<cfelse> 
				<cfset Lvar_dw = 0>
			</cfif>				
			<cfquery name="rsDatosJornada" datasource="#Arguments.Conexion#">
				select 	a.RHJid, a.RHJmarcar, a.RHJornadahora, a.RHJjsemanal, a.RHJrebajaocio, 
						a.RHJminutosExtras, a.RHJincAusencia, a.RHJincHJornada,
						a.RHJincExtraA, a.RHJincExtraB, a.RHJincFeriados,
						(#LvarRHPlibre#) as LibrePlanificador,
						<cf_dbfunction name="timediff"	args="a.RHJhorainicom, a.RHJhorafincom" >/60 as MinOcio,
						<!---==== Anterior ===== coalesce((coalesce(b.RHJhorasNormales,0))*60,0) as minutoslaboradosestimados,---->
						<cfswitch expression="#Lvar_dw#">
							<cfcase value="2">( case when a.RHJmon = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) </cfcase>
							<cfcase value="3">( case when a.RHJtue = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) </cfcase>
							<cfcase value="4">( case when a.RHJwed = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) </cfcase>
							<cfcase value="5">( case when a.RHJthu = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) </cfcase>
							<cfcase value="6">( case when a.RHJfri = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) </cfcase>
							<cfcase value="7">( case when a.RHJsat = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) </cfcase>
							<cfcase value="1">( case when a.RHJsun = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) </cfcase>
							<cfcase value="0">( coalesce(a.RHJhoradiaria,0)*60  ) </cfcase>							
						</cfswitch> as minutoslaboradosestimados,
						<cfswitch expression="#Lvar_dw#">
							<cfcase value="2">( case when a.RHJmon = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraA,0))*60,0)  end ) </cfcase>
							<cfcase value="3">( case when a.RHJtue = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraA,0))*60,0)  end ) </cfcase>
							<cfcase value="4">( case when a.RHJwed = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraA,0))*60,0)  end ) </cfcase>
							<cfcase value="5">( case when a.RHJthu = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraA,0))*60,0)  end ) </cfcase>
							<cfcase value="6">( case when a.RHJfri = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraA,0))*60,0)  end ) </cfcase>
							<cfcase value="7">( case when a.RHJsat = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraA,0))*60,0)  end ) </cfcase>
							<cfcase value="1">( case when a.RHJsun = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraA,0))*60,0)  end ) </cfcase>
							<cfcase value="0">( coalesce(a.RHJhorasExtraA,0)*60  ) </cfcase>																					
						</cfswitch> as minutoslaboradosestimadosHEA,
						<cfswitch expression="#Lvar_dw#">
							<cfcase value="2">( case when a.RHJmon = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraB,0))*60,0)  end ) </cfcase>
							<cfcase value="3">( case when a.RHJtue = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraB,0))*60,0)  end ) </cfcase>
							<cfcase value="4">( case when a.RHJwed = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraB,0))*60,0)  end ) </cfcase>
							<cfcase value="5">( case when a.RHJthu = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraB,0))*60,0)  end ) </cfcase>
							<cfcase value="6">( case when a.RHJfri = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraB,0))*60,0)  end ) </cfcase>
							<cfcase value="7">( case when a.RHJsat = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraB,0))*60,0)  end ) </cfcase>
							<cfcase value="1">( case when a.RHJsun = 0 then 0 else coalesce((coalesce(b.RHJhorasExtraB,0))*60,0)  end ) </cfcase>
							<cfcase value="0">( coalesce(a.RHJhorasExtraB,0)*60  ) </cfcase>																					
						</cfswitch> as minutoslaboradosestimadosHEB,
						case when b.RHDJdia is not null then
							coalesce(abs(<cf_dbfunction name="datediff" args="b.RHJhorainicom,b.RHJhorafincom,mi">),0) 
						else 			
							coalesce(abs(<cf_dbfunction name="datediff" args="a.RHJhorainicom,a.RHJhorafincom,mi">),0)
						end as minutosocioestimados
				from RHJornadas a
					left outer join RHDJornadas b
						on a.RHJid = b.RHJid
						and #Lvar_dw# =  RHDJdia
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_RHJid#">
			</cfquery>			
			
			<!---Si tiene ese dia en el planificador y esta marcado como dia libre pone los laborados estimados en 0---->
			<cfif rsDatosJornada.RecordCount NEQ 0 and len(trim(rsDatosJornada.LibrePlanificador)) and rsDatosJornada.LibrePlanificador EQ 1>
				<cfset rsDatosJornada.minutoslaboradosestimados = 0>
			</cfif>
			<cfreturn rsDatosJornada>
	</cffunction>
	<!---	============================== Función: funOcioEstimado =================================================
			Función que calcula el tiempo de ocio estimado segun las marcas de break del grupo que se esta procesando
			=========================================================================================================
	--->
	<cffunction name="funOcioEstimado" access="private" output="false" returntype="string">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="arg_fechaextremoE"  	type="string" 	required="yes">
		<cfargument name="arg_fechaextremoF"  	type="string" 	required="yes">
		<cfargument name="rsInfoEmpleado"  		type="query" 	required="yes">
		<cftry>
			<cfset vn_minocio = 0>
			
			<cfquery name="rsMinutosOcio" datasource="#Arguments.Conexion#"><!---Obtiene todas las marcas de ocio(SB/EB)---->
				select fechahora,tipo
				from #TempMarcas#
				where fechahora > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.arg_fechaextremoE#">
					and fechahora < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.arg_fechaextremoF#">
				order by fechahora
			</cfquery>
			
			<cfloop query="rsMinutosOcio">
				<cfif trim(rsMinutosOcio.tipo) EQ 'SB' or trim(rsMinutosOcio.tipo) EQ 'S'><!---La marca es de salida---->				
					<cfset vdfecha1 = rsMinutosOcio.fechahora>
				<cfelse><!---La marca es de entrada---->
					<cfset vdfecha2 = rsMinutosOcio.fechahora>
					<cfif isdefined("vdfecha1") and len(trim(vdfecha1)) gt 0 and len(trim(vdfecha2))>
						<cfset vn_minocio = vn_minocio + DateDiff("n", vdfecha1, vdfecha2)>
					</cfif>
					<cfset vdfecha1 = ''>
					<cfset vdfecha2 = ''>				
				</cfif>			
			</cfloop>
		<cfcatch>
			<cfthrow  message="#MSG_Error_calculando_el_tiempo_de_ocio_estimado_para_el_empleado# #rsInfoEmpleado.DEidentificacion# - #rsInfoEmpleado.DEapellido1# #rsInfoEmpleado.DEapellido2# #rsInfoEmpleado.DEnombre#, #MSG_para_la_fecha# #arguments.arg_fechaextremoE#. Error: #cfcatch.Message#." detail="#cfcatch.Detail#">
		</cfcatch>
		</cftry>
		<cfreturn vn_minocio>
	</cffunction>
	<!---	============================== Función: funInsertaDatosMarcas ============================================
			Función que inserta datos en #TempDatos# y actualiza en la temporal de marcas el ID para efecto de amarrar
			luego a las marcas el numero de lote correspondiente 													  
			==========================================================================================================
	--->
	<cffunction name="funInsertaDatosMarcas" access="private" output="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="arg_minutostotalesreales"  	type="string" 	required="yes" default="0">
		<cfargument name="arg_minutosocioreales"  		type="string" 	required="yes" default="0">
		<cfargument name="arg_minutoslaboradosreales"  	type="string" 	required="yes" default="0">
		<cfargument name="arg_DEid"  					type="numeric" 	required="yes">
		<cfargument name="arg_Fdesde"  					type="string" 	required="yes">
		<cfargument name="arg_grupo"  					type="numeric" 	required="yes">
		<cfargument name="arg_datos"  					type="query" 	required="yes">
		<cfset rsDatos = arguments.arg_datos> 
		<cfif len(trim(rsDatos.RHJincHJornada)) and len(trim(rsDatos.RHJincExtraA)) and len(trim(rsDatos.RHJincExtraB)) and len(trim(rsDatos.RHJincFeriados))>
			<cfquery name="inserta" datasource="#Arguments.Conexion#">
				insert into #TempDatos# (DEid,f_desde,f_hasta,jornada,
										minlaboradosestimados,
										minocioestimados,mintotalesreales,minsocioreales,minlaboradosreales,
										horasrebajar,horasnormales,horasextraa,horasextrab,
										montoferiado,
										incidenciarebajo,incidenciajornada,incidenciaextraa,incidenciaextrab,incidenciaferiado,
										minlaboradosestimadosHEA,
										minlaboradosestimadosHEB
										)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.arg_Fdesde#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.arg_Fdesde#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsDatos.minutoslaboradosestimados#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsDatos.minutosocioestimados#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.arg_minutostotalesreales#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.arg_minutosocioreales#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.arg_minutoslaboradosreales#">,
						0.00,0.00,0.00,0.00,
						0.00,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJincAusencia#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJincHJornada#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJincExtraA#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJincExtraB#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJincFeriados#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsDatos.minutoslaboradosestimadosHEA#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsDatos.minutoslaboradosestimadosHEB#">
				)
				<cf_dbidentity1 datasource="#Arguments.Conexion#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.Conexion#" name="inserta" verificar_transaccion="false">	

			<cfif len(trim(inserta.identity))>
				<!--Actualizar el grupo de la tabla de marcas para indicar que ya se procesaron--->
				<cfquery datasource="#Arguments.Conexion#">
					update #TempMarcas# set IdDatos = <cfqueryparam cfsqltype="cf_sql_numeric" value="#inserta.identity#">
					where grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_grupo#">
				</cfquery>
			</cfif>		

		<cfelse>
			<cfthrow message="#MSG_HacenFaltaDatosDeLaJornada#">
		</cfif>
	</cffunction>
	<!---	============================== Función: funActualizaDatos =======================================
			Función actualiza datos de #TempDatos#  y actualiza en la temporal de marcas el ID para efecto de
			amarrar luego a las marcas el numero de lote correspondiente 									
			=================================================================================================
	--->
	<cffunction name="funActualizaDatos" access="private" output="false">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="arg_minutostotalesreales"  	type="string" 	required="yes">
		<cfargument name="arg_minutosocioreales"  		type="string" 	required="yes">
		<cfargument name="arg_minutoslaboradosreales"  	type="string" 	required="yes">
		<cfargument name="arg_Iddatos"  				type="numeric" 	required="yes">
		<cfargument name="arg_grupo"  					type="numeric" 	required="yes">
		<cfargument name="arg_Fdesde"  					type="string" 	required="yes">
		<cfargument name="arg_datos"  					type="query" 	required="yes">
		
		<cfquery datasource="#Arguments.Conexion#">
			update #TempDatos#
				set f_hasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.arg_Fdesde#">,
					minlaboradosestimados = coalesce(minlaboradosestimados,0) + <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsDatos.minutoslaboradosestimados#">,
					minocioestimados = coalesce(minocioestimados,0) + <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsDatos.minutosocioestimados#">,
					mintotalesreales = coalesce(mintotalesreales,0) + <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.arg_minutostotalesreales#">,
					minsocioreales = coalesce(minsocioreales,0) + <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.arg_minutosocioreales#">,
					minlaboradosreales = coalesce(minlaboradosreales,0) + <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.arg_minutoslaboradosreales#">
			where IdDatos = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_Iddatos#">
		</cfquery>
		<!--Actualizar el grupo de la tabla de marcas para indicar que ya se procesaron--->
		<cfquery datasource="#Arguments.Conexion#">
			update #TempMarcas# 
				set IdDatos = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_Iddatos#">
			where grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_grupo#">
		</cfquery>
	</cffunction>
	<!---=================================================================================================
			Tabla temporal de datos
	======================================================================================================----->
	<cffunction name="createTempDatos" access="private">
		<cfargument name="Conexion" type="string" required="true">
		<cf_dbtemp name="TempDatos" returnvariable="TempDatos" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="IdDatos" 					type="numeric"		mandatory="yes"  identity="yes">
			<cf_dbtempcol name="DEid" 						type="numeric"		mandatory="yes">
			<cf_dbtempcol name="f_desde" 					type="datetime"		mandatory="no">
			<cf_dbtempcol name="f_hasta" 					type="datetime"		mandatory="no">
			<cf_dbtempcol name="jornada" 					type="numeric"		mandatory="no">
			<cf_dbtempcol name="minlaboradosestimados" 		type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="minocioestimados" 			type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="mintotalesreales" 			type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="minsocioreales" 			type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="minlaboradosreales" 		type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="horasrebajar" 				type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="horasnormales" 				type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="horasextraa" 				type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="horasextrab" 				type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="montoferiado" 				type="money"		mandatory="no">
			<cf_dbtempcol name="incidenciarebajo" 			type="numeric"		mandatory="no">
			<cf_dbtempcol name="incidenciajornada" 			type="numeric"		mandatory="no">
			<cf_dbtempcol name="incidenciaextraa" 			type="numeric"		mandatory="no">
			<cf_dbtempcol name="incidenciaextrab" 			type="numeric"		mandatory="no">
			<cf_dbtempcol name="incidenciaferiado" 			type="numeric"		mandatory="no">
			<cf_dbtempcol name="generadoporferiado" 		type="numeric"		mandatory="no">	
			<cf_dbtempcol name="generadoporpermiso" 		type="numeric"		mandatory="no">	
			<cf_dbtempcol name="minlaboradosestimadosHEA"	type="numeric(9,2)"	mandatory="no">
			<cf_dbtempcol name="minlaboradosestimadosHEB"	type="numeric(9,2)"	mandatory="no">
		</cf_dbtemp>
	</cffunction>
	<!---=================================================================================================
		Tabla temporal de marcas
	======================================================================================================----->	
	<cffunction name="createTempMarcas" access="private">
		<cfargument name="Conexion" type="string" required="true">
		<cf_dbtemp name="TempMarcas" returnvariable="TempMarcas" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="IdMarca" 		type="numeric"		mandatory="yes">
			<cf_dbtempcol name="DEid" 			type="numeric"		mandatory="yes">
			<cf_dbtempcol name="tipo" 			type="char(2)"		mandatory="no">
			<cf_dbtempcol name="fechahora" 		type="datetime"		mandatory="no">
			<cf_dbtempcol name="jornada" 		type="numeric"		mandatory="no">
			<cf_dbtempcol name="grupomarca" 	type="numeric"		mandatory="no">
			<cf_dbtempcol name="IdDatos" 		type="numeric"		mandatory="no">
		</cf_dbtemp>
	</cffunction>
	<!---	============================== RH_ProcesoGeneraMarcas ============================== --->
	<cffunction name="RH_ProcesoGeneraMarcas" access="public" output="false">
		<cfargument name="Ecodigo" type="numeric" required="false">
		<cfargument name="Conexion" type="string" required="false">
		<cfargument name="Usucodigo" type="numeric" required="false">
		<cfargument name="Debug" type="boolean" default="false">
		<cfargument name="Gid" type="numeric" required="false" default="0">
		<cfargument name="DEid" type="numeric" required="false" default="0">
		<cfargument name="fechaFin" type="date" required="false" default="#Now()#">
		

		<!---		<cfquery name="x" datasource="#session.dsn#">
		</cfquery>--->
		
		<!--- DEFINE ARGUMENTOS ECODIGO, CONEXION, USUCODIGO. CUANDO NO VIENEN. --->
		<cfif (not isdefined("Arguments.Ecodigo")) and (isdefined("Session.Ecodigo"))>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
		</cfif>
		<cfif (not isdefined("Arguments.Conexion")) and (isdefined("Session.Dsn"))>
			<cfset Arguments.Conexion = Session.Dsn>
		</cfif>
		<cfif (not isdefined("Arguments.Usucodigo")) and (isdefined("Session.Usucodigo"))>
			<cfset Arguments.Usucodigo = Session.Usucodigo>
		</cfif>
		
		<!--- Consultas Grupos del Usuario --->
		<cfif isdefined("Arguments.Usucodigo") and len(trim(Arguments.Usucodigo)) GT 0 and Arguments.Usucodigo GT 0>
			<cfquery name="rsGrupos" datasource="#Arguments.Conexion#">
				select  a.Gid
				from RHCMAutorizadoresGrupo a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and a.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			</cfquery>
			<cfif rsGrupos.recordcount eq 0>
				<cfthrow message="#MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso#">
			</cfif>
		</cfif>
		<!---=================================================================================================
			Definir los empleados a quienes se les van a procesar las marcas. Solo se procesan los que 
			tienen marcas registradas en la tabla RHControlMarcas 
		======================================================================================================----->
		<cfquery name="rsEmpleados" datasource="#Arguments.Conexion#">
			select distinct b.DEid
			from RHCMEmpleadosGrupo b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">  
				<cfif isdefined("Arguments.Gid") and len(trim(Arguments.Gid)) and Arguments.Gid>
					and b.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Gid#">
				<cfelseif isdefined("rsGrupos") and ListLen(ValueList(rsGrupos.Gid)) GT 0>
					and b.Gid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsGrupos.Gid)#" list="true">)
				</cfif>
				<cfif isdefined("Arguments.DEid") and len(trim(Arguments.DEid)) and Arguments.DEid>
					and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
				</cfif>
		</cfquery>

		<cfinvoke method="createTempDatos" conexion="#Arguments.Conexion#">
		<cfinvoke method="createTempMarcas" conexion="#Arguments.Conexion#">
		<!---=================================================================================================
			Definición de variables
		======================================================================================================----->	
		<cfset fechadesde = ''><!---Fecha inico rango de busqueda ----->
		<cfset fechahasta = ''><!---Fecha fin rango de busqueda ---->
		<cfset vnEmpleado = ''><!---Empleado a procesar ---->
		<!---=================================================================================================
			PARA CADA EMPLEADO 
		======================================================================================================----->
		
		<cfloop query="rsEmpleados">
			<!----Limpiar tablas temporales y variables ----->
			<cfquery datasource="#Arguments.Conexion#">
				delete from #TempDatos#
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				delete from #TempMarcas#
			</cfquery>
			<cfset fechadesde = ''><!---Fecha desde a procesar---->
			<cfset fechahasta = ''><!---Fecha hasta a procesar---->
			<cfset minutostotalesreales = 0>
			<cfset minutosocioreales = 0>
			<cfset minutoslaboradosreales = 0>
			<cfset vnEmpleado = rsEmpleados.DEid><!---Variable con el DEid del empleado--->
			<!--- Consulta Datos del Empleado para enviar mensajes de error referentes al empleado --->
			<cfquery name="rsInfoEmpleado" datasource="#Arguments.Conexion#">
				select DEidentificacion, DEapellido1, DEapellido2, DEnombre
				from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
			</cfquery>
			
			<!---========== BUSCAR RANGO DE FECHAS=============----->
			<!---====== Buscar fecha desde a procesar (ultima marca de salida procesada) ======---->

			<cfquery name="rsFechadesde" datasource="#Arguments.Conexion#"><!---Ultima marca de salida procesada (numlote not null)---->
				select max(fechahoramarca) as fechadesde
				from RHControlMarcas a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and ltrim(rtrim(a.tipomarca)) = 'S'
					and a.registroaut = 1
					and a.numlote is not null
					and a.grupomarcas is not null 
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
					and fechahoramarca < ( select min(fechahoramarca)
											from RHControlMarcas b
											where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
											  and ltrim(rtrim(b.tipomarca)) = 'E'
											  and b.numlote is null
											  and b.grupomarcas is not null)
			</cfquery>
		
			<cfif (rsFechadesde.RecordCount EQ 0) or (len(trim(rsFechadesde.fechadesde)) EQ 0)>
			<!--- OJO la condición del a.numlote is null estaba comentada 
						and a.numlote is not null
			---->				
						
				<cfquery name="rsFechadesdeB" datasource="#Arguments.Conexion#"><!---Ultima marca de entrada procesada (numlote is not null)---->
					select min(fechahoramarca) as fechadesde
					from RHControlMarcas a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						and ltrim(rtrim(a.tipomarca)) = 'E'
						and a.registroaut = 1
						and a.numlote is null
						and a.grupomarcas is not null
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
						and <cf_dbfunction name="date_format" args="a.fechahoramarca,yyyymmdd"> <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat((Arguments.fechaFin),'yyyymmdd')#">
				</cfquery>	
				<cfif (rsFechadesdeB.RecordCount EQ 0) or (len(trim(rsFechadesdeB.fechadesde)) EQ 0)><!----Si no aplica ninguno de los anteriores se asigna la fecha hasta del parametro ---->
					<cfset fechadesde = CreateDateTime(year((Arguments.fechaFin)), month((Arguments.fechaFin)), day((Arguments.fechaFin)), 00, 00,0)>
				<cfelse>
					<cfset fechadesde = DateAdd("s", -1, "#rsFechadesdeB.fechadesde#")>	
				</cfif>		
			<cfelse>
				<cfset fechadesde = DateAdd("s", 1, "#rsFechadesde.fechadesde#")>
			</cfif>
			
			
			<!---===== Buscar la fecha hasta a procesar ======---->
			<cfquery name="rsFechahasta" datasource="#Arguments.Conexion#"><!---Ultima marca de entrada--->
				select RHCMid,grupomarcas,fechahoramarca
				from RHControlMarcas 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
				and fechahoramarca = (select  max(fechahoramarca) 
									from RHControlMarcas a
									where ltrim(rtrim(a.tipomarca)) = 'E'
										and a.registroaut = 1
										and a.grupomarcas is not null
										<!----and a.numlote is not null---->											
										and a.DEid = RHControlMarcas.DEid
										and a.fechahoramarca <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDateTime(year((Arguments.fechaFin)), month((Arguments.fechaFin)), day((Arguments.fechaFin)), 23, 59,59)#">
									)
			</cfquery>
		
			
			<cfif (rsFechahasta.RecordCount EQ 0) or (len(trim(rsFechahasta.fechahoramarca)) EQ 0)>				
				opcion uno<cfset fechahasta = CreateDateTime(year((Arguments.fechaFin)), month((Arguments.fechaFin)), day((Arguments.fechaFin)), 23, 59,59)>
			<cfelse>opcion dos
				<cfif len(trim(rsFechahasta.grupomarcas))>
					<cfquery name="rsFechahastaB" datasource="#Arguments.Conexion#">
						select max(a.fechahoramarca) as fechahasta
						from RHControlMarcas a
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							and ltrim(rtrim(a.tipomarca)) = 'S'
							and a.grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFechahasta.grupomarcas#">
					</cfquery>
					
					<cfif rsFechahastaB.RecordCount NEQ 0 and len(trim(rsFechahastaB.fechahasta)) GT 0>
						2<cfset fechahasta = CreateDateTime(year(rsFechahastaB.fechahasta), month(rsFechahastaB.fechahasta), day(rsFechahastaB.fechahasta), 23, 59,59)>
						
					<cfelse>
						3<cfset fechahasta = CreateDateTime(year((Arguments.fechaFin)), month((Arguments.fechaFin)), day((Arguments.fechaFin)), 23, 59,59)>
					</cfif>
				<cfelse>
					4<cfset fechahasta = CreateDateTime(year((Arguments.fechaFin)), month((Arguments.fechaFin)), day((Arguments.fechaFin)), 23, 59,59)>
				</cfif>
			</cfif>
			
			<!--- ***********************************************************
			***SE COMENTA EL CÓDIGO DE CÁLCULO DE FERIADOS PARA HACERLO DE***
			***FORMA  MANUAL, EN CONTROL MARCAS EN PROCESAMIENTO DE MARCAS***
			***SE  AGREGÓ UN  BOTÓN  QUE  GENERA  LOS FERIADOS, DEFINIENDO***
			***UN FERIADO. **************************************************
			*************************************************************--->
			<!---====== CALCULAR FERIADOS ======
			<cfquery name="rsFeriados" datasource="#Arguments.Conexion#">
				select a.RHFfecha
				from RHFeriados a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					<!--- and a.RHFpagooblig = 1 --->
					and a.RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#fechadesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#fechahasta#">
					<!---Que no este ya procesado el feriado--->
					and not exists (select 1
								from RHCMCalculoAcumMarcas b
								where b.CAMfdesde = a.RHFfecha	
								and CAMestado = 'P'
								and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
								and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">)
			</cfquery>
			<!---
			<cfdump var="#fechadesde#">
			<cfdump var="#fechahasta#">
			<cf_dump var="#rsFeriados#">
			--->
			<cfif rsFeriados.RecordCount GT 0>
				<!---Procesar cada feriado de las marcas del empleado---->
				<cfloop query="rsFeriados">
					<cfset vn_montoFeriado = 0><!---Monto calculado de incidencias tipo calculo---->
					<cfset rsJornada = ''>
					<cfquery datasource="#Arguments.Conexion#" name="rsVerificaNombramiento">
							select LTid
							from LineaTiempo lt
							where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
							  and <cfqueryparam cfsqltype="cf_sql_date"  value="#RHFfecha#"> between lt.LTdesde and lt.LThasta
							  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>
					<!---
					<cf_dump var="#rsVerificaNombramiento#">
					--->
					<!--- Si el empleado no está nombrado en la fecha del proceso, la marca se debe dejar sin procesar --->
					<cfif rsVerificaNombramiento.recordcount GT 0>
						<!----<cfset RHFfecha = rsFeriados.RHFfecha>
						 Verificar en la linea del tiempo si el empleado tiene una accion de tipo NO PAGA ---->		
						<cfif not funAccionPaga(Arguments.Ecodigo, Arguments.Conexion, vnEmpleado, RHFfecha)>			
							<!---Buscar la jornada del empleado en esa fecha--->
							<cfset rsJornada = funJornada(Arguments.Ecodigo, Arguments.Conexion, vnEmpleado, RHFfecha)>
							<cfif rsJornada.RecordCount NEQ 0>
								<cfif rsJornada.PagoPorHoras EQ 1><!---Si la jornada es por hora--->					
									<cfif len(trim(rsJornada.TipoCalculo)) and rsJornada.TipoCalculo EQ 3><!---Si la incidencia es de tipo calculo---->
										<!----Llamado a la calculadora---->
										<cfscript>
											current_formulas = rsJornada.CIcalculo;
											presets_text = get_presets(LSParseDateTime(RHFfecha),
																	   LSParseDateTime(RHFfecha),
																	   rsJornada.CIcantidad,
																	   rsJornada.CIrango,
																	   rsJornada.CItipo,
																	   vnEmpleado,
																	   rsJornada.RHJid,
																	   Arguments.Ecodigo,
																	   0,
																	   0,
																	   rsJornada.CIdia,
																	   rsJornada.CImes,
																	   rsJornada.Tcodigo,
																	   'false'
																	   );
											values = calculate ( presets_text & ";" & current_formulas );
										</cfscript>				
										<cfif Not IsDefined("values")>
											<cfif isdefined("presets_text")>
												<cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
											<cfelse>
												<cfthrow detail="#calc_error#" >
											</cfif>
										<cfelse>
											<cfset vn_montoFeriado = values.get('resultado').toString()>
										</cfif>
									</cfif>
									<cfquery datasource="#Arguments.Conexion#">
										insert into #TempDatos# (DEid,f_desde,f_hasta,jornada,minlaboradosestimados,minocioestimados,
																mintotalesreales,minsocioreales,minlaboradosreales,horasrebajar,horasnormales,
																horasextraa,horasextrab,montoferiado,incidenciarebajo,incidenciajornada,
																incidenciaextraa,incidenciaextrab,incidenciaferiado)
										values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#RHFfecha#">,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#RHFfecha#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJid#">,
												0.00, 0.00,	0.00, 0.00,	0.00,
												0.00,0.00,0.00,0.00,
												<cfqueryparam cfsqltype="cf_sql_money" value="#vn_montoFeriado#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincAusencia#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincHJornada#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincExtraA#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincExtraB#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincFeriados#">
										)
									</cfquery>					
								</cfif>
							<cfelse><!---Si no se encontro la jornada---->
								<cfthrow message="#MSG_EmpleadoNoTieneJornada# (#rsInfoEmpleado.DEidentificacion# - #rsInfoEmpleado.DEapellido1# #rsInfoEmpleado.DEapellido2# #rsInfoEmpleado.DEnombre#)">
							</cfif><!---Fin de si se encontro la jornada--->
						</cfif><!---Fin de si tiene accion de NO paga--->
					</cfif><!--- Si el empleado no está nombrado --->
				</cfloop><!---Fin del Loop de FERIADOS---->
			</cfif>--->
			<!---=========== PROCESAR MARCAS ============---->
			<!---Obtener bloque de las marcas en el rango de fechas a procesar insertarlo en temporal de marcas---->
			<cfquery name="rsInsertaMarcas" datasource="#Arguments.Conexion#">
				insert into #TempMarcas# (IdMarca,DEid,tipo,fechahora,jornada,grupomarca)
				select 	rhcm.RHCMid,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">,
						rhcm.tipomarca, 
						rhcm.fechahoramarca, 
						rhcm.RHJid,
						rhcm.grupomarcas
				from RHControlMarcas rhcm
					inner join LineaTiempo lt
					on lt.DEid = rhcm.DEid
					and <cf_dbfunction name="to_datechar" args="rhcm.fechahoramarca"> between lt.LTdesde and lt.LThasta
					left outer join RHPlanificador p
					on p.DEid = rhcm.DEid
					and <cf_dbfunction name="date_format" args="p.RHPJfinicio,yyyymmdd"> =
						<cf_dbfunction name="date_format" args="rhcm.fechahoramarca,yyyymmdd">
					inner join RHJornadas j
					on j.RHJid = coalesce(p.RHJid,lt.RHJid)
					and j.RHJmarcar = 1
				where rhcm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
					and rhcm.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
					and rhcm.registroaut = 1
					and rhcm.grupomarcas is not null
					and rhcm.numlote is null
					and rhcm.fechahoramarca >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechadesde#">
					and rhcm.fechahoramarca <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechahasta#">
				order by rhcm.fechahoramarca asc
			</cfquery>

			<!---============ PROCESAR BLOQUE DE DATOS ===============---->		
			<!---Obtener los grupos de marcas---->
			<cfset rsGMS = QueryNew("grupomarca","BigInt")>
			<cfquery name="rsGMS" datasource="#Arguments.Conexion#">
				select distinct grupomarca
				from #TempMarcas#
			</cfquery>

			<!---Procesar grupos---->
			<cfloop query="rsGMS">
				<cfset minutostotalesreales = 0>
				<cfset minutosocioreales = 0>
				<cfset minutoslaboradosreales = 0>
				<cfset pagohoraalmuerzo = 0>

				<!---Averigua si el grupo paga hora de almuerzo --->
				<cfquery name="rsPHA" datasource="#Arguments.Conexion#">
					select 1
					from RHControlMarcas
					where grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGMS.grupomarca#">
					  and pagohoraalmuerzo = 1
				</cfquery>
				<cfif rsPHA.recordcount GT 0>
					<cfset pagohoraalmuerzo = 1>
				</cfif>
				<!---Extremo inicial del grupo---->
				<cfquery name="rsExtremoE" datasource="#Arguments.Conexion#">
					select fechahora, jornada, grupomarca
					from #TempMarcas#
					where ltrim(rtrim(tipo)) = 'E'				
						and fechahora = (select min(fechahora)
										from #TempMarcas#
										where IdDatos is null
											and ltrim(rtrim(tipo)) = 'E'
											and grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGMS.grupomarca#">
										)
				</cfquery>
				
				<cfif rsExtremoE.RecordCount NEQ 0>
					<!------Extremo final del grupo---->
					<cfquery name="rsExtremoF" datasource="#Arguments.Conexion#">
						select fechahora, jornada, grupomarca
						from #TempMarcas#
						where ltrim(rtrim(tipo)) = 'S'			
							and fechahora = (select max(fechahora)
											from #TempMarcas#
											where IdDatos is null
												and ltrim(rtrim(tipo)) = 'S'
												and grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExtremoE.grupomarca#">)
					</cfquery>	
					
					<cfif rsExtremoF.RecordCount NEQ 0>
						<cfset minutostotalesreales = DateDiff("n", rsExtremoE.fechahora, rsExtremoF.fechahora)>
						
					</cfif>
					

				</cfif>	
				<!--- Agrega una hora adicional por la hora de almuerzo --->
				<cfif pagohoraalmuerzo>
					<cfset minutostotalesreales = minutostotalesreales + 60>
				</cfif>
				
				<!---Si hay extremos ---->
				<cfif rsExtremoE.RecordCount NEQ 0 and rsExtremoF.RecordCount NEQ 0>
					<!---Obtener datos de la jornada y el horario para el dia de la semana correspondiente a la fecha del extremo inicial--->
					<cfset rsDatosJornada = funDatosJornada(Arguments.Ecodigo, Arguments.Conexion, rsExtremoE.jornada, rsExtremoE.fechahora, vnEmpleado)>
					
					<cfif rsDatosJornada.RecordCount NEQ 0><!---Si la Jornada definida existe--->						
						<!----======= La jornada registra o no marca =======--->
						
			<cfquery name="rsParam" datasource="#session.dsn#">
				select Pvalor from RHParametros where Pcodigo=2042
				and Ecodigo=#session.Ecodigo#
			</cfquery>

						<cfif rsDatosJornada.RHJmarcar EQ 0 and rsParam.Pvalor eq 0><!---NO registra marcas --->
							<cfquery datasource="#Arguments.Conexion#"><!---Poner -1 en el iddatos--->
								update #TempMarcas#
								set IdDatos = -1
								where grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExtremoE.grupomarca#">
							</cfquery>
							<cfquery datasource="#Arguments.Conexion#"><!---Poner en -1 el lote de marcas --->
								update RHControlMarcas 
									set numlote = -1
								from RHControlMarcas
									inner join #TempMarcas# b
										on RHControlMarcas.RHCMid = b.IdMarca
										and b.grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExtremoE.grupomarca#">
							</cfquery>	
						<cfelse><!-----SI registra marcas---->
							<!---Calcular los minutos ocio (marcas tipo EB/SB) ---->				
							<cfset minutosocioreales = funOcioEstimado(Arguments.Ecodigo, Arguments.Conexion, rsExtremoE.fechahora, rsExtremoF.fechahora, rsInfoEmpleado)>
							<!-----Calcular tiempo laborado real en minutos ---->
							<cfif len(trim(rsDatosJornada.RHJrebajaocio)) and rsDatosJornada.RHJrebajaocio EQ 1><!---Si la jornada rebaja tiempo de ocio--->								
								<cfif minutosocioreales eq 0>
								<cfset minutoslaboradosreales = minutostotalesreales - minutosocioreales-#rsDatosJornada.MinOcio#>
								<cfelse>
								<cfset minutoslaboradosreales = minutostotalesreales - minutosocioreales>
								</cfif>
							<cfelseif len(trim(rsDatosJornada.RHJrebajaocio)) and rsDatosJornada.RHJrebajaocio EQ 0><!----Si la jornada NO rebaja tiempo ocio--->						
								<cfif minutosocioreales GT rsDatosJornada.minutosocioestimados>
									<cfset minutoslaboradosreales = minutostotalesreales - (minutosocioreales - rsDatosJornada.minutosocioestimados)>
								<cfelse><!----Cualquier otro caso----->
									<cfset minutoslaboradosreales = minutostotalesreales>
								</cfif>			
							</cfif>
							<!---Si la jornada verifica marca por dia---->				
							<cfif rsDatosJornada.RHJjsemanal EQ 0><!---Por dia--->
								<!---Insertar en #TempDatos#---->
								<cfset vnIdentity = funInsertaDatosMarcas(Arguments.Ecodigo, Arguments.Conexion, minutostotalesreales,minutosocioreales,minutoslaboradosreales,vnEmpleado,rsExtremoE.fechahora,rsExtremoE.grupomarca,rsDatosJornada)>
							<cfelse><!---Por semana--->
								<cfquery name="rsVerifica" datasource="#Arguments.Conexion#"><!---Verificar si ya existe el dato--->
									select IdDatos from #TempDatos#
									where jornada = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExtremoE.jornada#">
										<!---and IdDatos is null--->	
								</cfquery>
								
								<cfif rsVerifica.RecordCount EQ 0 or len(trim(rsVerifica.IdDatos)) EQ 0><!---Si no existe insertar el registro--->						
									<cfset vnIdentity = funInsertaDatosMarcas(Arguments.Ecodigo, Arguments.Conexion, minutostotalesreales,minutosocioreales,minutoslaboradosreales,vnEmpleado,rsExtremoE.fechahora,rsExtremoE.grupomarca,rsDatosJornada)>
								<cfelse><!---Si existe actualizarlo--->						
									<cfset vnIdentity = funActualizaDatos(Arguments.Ecodigo, Arguments.Conexion, minutostotalesreales,minutosocioreales,minutoslaboradosreales,rsVerifica.IdDatos,rsExtremoE.grupomarca,rsExtremoE.fechahora,rsDatosJornada)>
								</cfif>
							</cfif><!---Fin de si verifica marca por dia o semana---->
						</cfif><!---Fin de si registra o no marcas la jornada--->
					</cfif><!---Fin de si existe la jornada--->				
				</cfif><!---Fin de si hay extremos--->
			</cfloop><!---Fin del loop de MARCAS--->	
			<!----================= PROCESAR LOS DATOS DE LA TEMPORAL #TempDatos# =====================---->
			<cfinvoke method="funcProcesaTempDatos" conexion="#Arguments.Conexion#" ecodigo="#Arguments.Ecodigo#" usucodigo="#Arguments.Usucodigo#"/>
		</cfloop><!---Fin del Loop de EMPLEADOS---->

	</cffunction>

	<cffunction access="private" name="funcProcesaTempDatos">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="false">
		<cfargument name="Usucodigo" type="numeric" required="false">

		
		<cfquery name="rsTempDatos" datasource="#Arguments.Conexion#"><!---Marcas sin jornada establecida--->
			select 	IdDatos,DEid,f_desde,f_hasta,jornada,
					coalesce(minlaboradosestimados,0) as minlaboradosestimados,
					coalesce(minlaboradosestimadosHEA,0) as minlaboradosestimadosHEA,
					coalesce(minlaboradosestimadosHEB,0) as minlaboradosestimadosHEB,
					coalesce(minocioestimados,0) as minocioestimados,
					coalesce(mintotalesreales,0) as mintotalesreales,
					coalesce(minsocioreales,0) as minsocioreales,
					coalesce(minlaboradosreales,0) as minlaboradosreales,
					horasrebajar,
					horasnormales,
					horasextraa,horasextrab,montoferiado,incidenciarebajo,incidenciajornada,
					incidenciaextraa,incidenciaextrab,incidenciaferiado,generadoporferiado,generadoporpermiso
			from #TempDatos#
			order by 2,3
		</cfquery>
		<cftransaction>
			<cfloop query="rsTempDatos">		
				<!---Variables--->				
				<cfset vn_minextraA = 0>
				<cfset vn_minextraB = 0>
				<cfset vn_horasrebajar = 0>
				<cfset vn_horasjornadanormal = 0>
				<cfset vn_horasextraA = 0>
				<cfset vn_horasextraB = 0>
				<cfset 	rsDJornada.recordCount = 0>
				<cfset 	minutoslaboradosreales = rsTempDatos.minlaboradosreales>	
				<cfset vnEmpleado = rsTempDatos.DEid>
				<!----======= Tiene Jornada definida ========---->
				<cfif len(trim(rsTempDatos.jornada))>
					<cfquery name="rsDJornada" datasource="#Arguments.Conexion#">
						select 	RHJid, RHJornadahora, coalesce(RHJfraccionesExtras,1) as RHJfraccionesExtras, 
								coalesce(RHJminutosExtras,1) as RHJminutosExtras,
								coalesce(coalesce(RHJhorasJornada,0)*60,0) as RHJhorasJornada, 
								coalesce(coalesce(RHJhorasExtraA,0)*60,0) as RHJhorasExtraA, 
								coalesce(coalesce(RHJhorasExtraB,0)*60,0) as RHJhorasExtraB
						from RHJornadas
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							and RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTempDatos.jornada#">
					</cfquery>
					<cfif rsDJornada.RecordCount NEQ 0><!---SI existe la jornada---->
						<cfif rsDJornada.RHJornadahora EQ 0><!---Si la jornada es mensual--->
							<cfif minutoslaboradosreales  LT  rsTempDatos.minlaboradosestimados><!---===Anterior===  rsDJornada.RHJhorasJornada---->
								<cfset vn_horasrebajar = (rsTempDatos.minlaboradosestimados- minutoslaboradosreales)/60><!---===Anterior===  (rsDJornada.RHJhorasJornada - minutoslaboradosreales)/60>---->
								<cfset minutoslaboradosreales = rsTempDatos.minlaboradosestimados>
							<cfelse>
								<cfset vn_horasrebajar = 0>
							</cfif>
						<cfelse><!---La jornada es por horas --->
								<cfset vn_horasrebajar = 0>
						</cfif>
						
						<!---
							1. Si laborado <= al tope de Horas Normales  (la canti de horas es menor a las normales)
								horas normales = Tiempo Real
							2. Si laborado <= al tope de Horas Extra A   (la canti de horas es menor a las ExtraA)
								horas normales = tiempo estimado
								horas extra    = 
												if Tope Horas Extra A <> Tope Horas Normales
														tiempo real - minutos estimado
												else 
														No Paga Extras	
								horas extra b  = 0
							3. Si laborado <= al tope de Horas Extra B	(la canti de horas es menor a las ExtraB)
								horas normales = tiempo estimado
								horas extra a    = 
												if Tope Horas Extra A <> Tope Horas Normales
														Tope Horas Extra A - HorasNormales (DIFERENCIA TOPE)
												else 
														No Paga Extras	
								horas extra b  = 
												if Tope Horas Extra A <> Tope Horas Extra B
														Minutos Reales -  HORASR EXTRAB (DIFERENCIA TOPE ANTERIOR)
												else 
														No Paga Extras									
							4. else										(son mayores a las ExtraB)
									horas normales = tiempo laborado
									horas extra a    = 
												if Tope Horas Extra A <> Tope Horas Normales
														Tope Horas Extra A - HorasNormales (DIFERENCIA TOPE)
												else 
														No Paga Extras	
									horas extra b  = 
												if Tope Horas Extra A <> Tope Horas Extra B
														Tope Horas Extra B - Tope Horas Extra A 
												else 
														No Paga Extras																		
						--->

						
						
						
						  <cfset vn_minextraB   = 0>
					      <cfset vn_minextraA   = 0>
					      <cfset vn_minjornadanormal  = 0>
					  					  
					      <cfif minutoslaboradosreales lte rsTempDatos.minlaboradosestimados>
					          	  <cfset vn_minjornadanormal  = minutoslaboradosreales>
								  <cfset vn_minextraB   = 0>
							      <cfset vn_minextraA   = 0>
					      <cfelseif minutoslaboradosreales lte rsTempDatos.minlaboradosestimadosHEA>
					       		  <cfset vn_minjornadanormal  = rsTempDatos.minlaboradosestimados>
					       		  <cfif rsTempDatos.minlaboradosestimados neq rsTempDatos.minlaboradosestimadosHEA>
					        			<cfset vn_minextraA  = minutoslaboradosreales - rsTempDatos.minlaboradosestimados>
					        	  <cfelse>
					        			<cfset vn_minextraA   = 0>
					       		  </cfif>
					       		  <cfset vn_minextraB   = 0>
					      <cfelseif minutoslaboradosreales lte rsTempDatos.minlaboradosestimadosHEB>
					      		 <cfset vn_minjornadanormal  = rsTempDatos.minlaboradosestimados>
					      		 
					       		  <cfif rsTempDatos.minlaboradosestimados neq rsTempDatos.minlaboradosestimadosHEA>
					        			<cfset vn_minextraA  = rsTempDatos.minlaboradosestimadosHEA - rsTempDatos.minlaboradosestimados>
					        	  <cfelse>
					        			<cfset vn_minextraA   = 0>
					       		  </cfif>	
					       		  
					       		  <cfif rsTempDatos.minlaboradosestimadosHEA neq rsTempDatos.minlaboradosestimadosHEB>
					        			<cfset vn_minextraB  = minutoslaboradosreales - rsTempDatos.minlaboradosestimadosHEA> 
					        	  <cfelse>
					        			<cfset vn_minextraB   = 0>
					       		  </cfif>
						  <cfelse>
					      		 <cfset vn_minjornadanormal  = rsTempDatos.minlaboradosestimados>
								
					       		  <cfif rsTempDatos.minlaboradosestimados neq rsTempDatos.minlaboradosestimadosHEA>
					        			<cfset vn_minextraA  = rsTempDatos.minlaboradosestimadosHEA- rsTempDatos.minlaboradosestimados>
					        	  <cfelse>
					        			<cfset vn_minextraA   = 0>
					       		  </cfif>	
					       		  
					       		  <cfif rsTempDatos.minlaboradosestimadosHEA neq rsTempDatos.minlaboradosestimadosHEB>
					        			<cfset vn_minextraB  = rsTempDatos.minlaboradosestimadosHEB - rsTempDatos.minlaboradosestimadosHEA>
					        	  <cfelse>
					        			<cfset vn_minextraB   = 0>
					       		  </cfif>		
					       		  <!---
						       		  minutoslaboradosreales<cfdump var="#minutoslaboradosreales#"><BR>
						       		  topeNormal<cfdump var="#rsTempDatos.minlaboradosestimados#"><BR>
						       		  TopeExtraA<cfdump var="#rsTempDatos.minlaboradosestimadosHEA#"><BR>
						       		  TopeExtraB<cfdump var="#rsTempDatos.minlaboradosestimadosHEB#"><BR>
						       		  <cfdump var="LZLZLZLZLZLZLZLZ"><BR>
						       		  MinutosNormal<cfdump var="#vn_minjornadanormal#"><BR>
						       		  MinutosA<cfdump var="#vn_minextraA#"><BR>
						       		  MinutosB<cfdump var="#vn_minextraB#"><BR>
						       		--->
					      </cfif>
					      
						<!---
							1. Si laborado > extraA
								horas normales = tiempo estimado
								horas extra    = minutos A - minutos estimado
								horas extra b  = tiempo laborado - extra A
							2. Si laborado > estimado
								horas normales = tiempo estimado
								horas extra    = laborado - estimado
								horas extra b  = 0
							3. else
								horas normales = tiempo laborado
						--->
						<!--- CODIGO ANTERIOR PARA CALCULAR TIEMPOS...
						<cfif minutoslaboradosreales GT rsTempDatos.minlaboradosestimadosHEA>
								<cfset vn_minextraB = minutoslaboradosreales - rsTempDatos.minlaboradosestimadosHEA>
								<cfset vn_minextraA = rsTempDatos.minlaboradosestimadosHEA - rsTempDatos.minlaboradosestimados>
								<cfset vn_minjornadanormal = rsTempDatos.minlaboradosestimados>
						<cfelseif minutoslaboradosreales GT rsTempDatos.minlaboradosestimados>
							<cfset vn_minextraB = 0>
							<cfset vn_minextraA = minutoslaboradosreales - rsTempDatos.minlaboradosestimados>
							<cfset vn_minjornadanormal = rsTempDatos.minlaboradosestimados>
						<cfelse>
							<cfset vn_minextraB = 0>
							<cfset vn_minextraA = 0>
							<cfset vn_minjornadanormal = minutoslaboradosreales>
						</cfif>
						--->
						
						<!---   Debug:
							<br />
							<cfdump var="#minutoslaboradosreales#"><br />
							<br />
							<cfdump var="#vn_minjornadanormal#"><br />
							<cfdump var="#vn_minextraA#"><br />
							<cfdump var="#vn_minextraB#"><br />
							<br />
						--->
						<cfif rsDJornada.RHJornadahora EQ 1>
							<cfset vn_horasjornadanormal = vn_minjornadanormal / 60>
						<cfelse>
							<cfset vn_horasjornadanormal = 0>
						</cfif>
						<cfset lvarminFraccion = rsDJornada.RHJminutosExtras>
						
						<cfif lvarminFraccion LT 1>
								<cfset lvarminFraccion = 1>
						</cfif>
						
						<cfset vn_parteentera = 0>
						
						<cfset vn_parteentera = Fix(vn_minextraA/Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras))>
						<!--- Considerar los minutos restantes de las fracciones enteras si es que quedan --->
						<cfset LvarCalculo = vn_parteentera * Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras)>
						<cfset LvarCalculo = vn_minextraA - LvarCalculo>

						<cfif LvarCalculo GTE lvarminFraccion>
							<cfset vn_parteentera = vn_parteentera + 1>
						</cfif>
						
						<cfset vn_horasextraA = vn_parteentera * Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras) /60>
						<cfset vn_parteentera = 0>
						<cfset vn_parteentera = Fix(vn_minextraB/Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras))>

						<!--- Considerar los minutos restantes de las fracciones enteras si es que quedan --->
						<cfset LvarCalculo = vn_parteentera * Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras)>
						<cfset LvarCalculo = vn_minextraB - LvarCalculo>

						<cfif LvarCalculo GTE lvarminFraccion>
							<cfset vn_parteentera = vn_parteentera + 1>
						</cfif>

						<cfset vn_horasextraB = vn_parteentera * Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras) /60>
						<!---   Debug:
							<cfdump var="#rsTempDatos.jornada#"><br />
							<cfdump var="#rsTempDatos.f_desde#"><br />
							<cfdump var="#rsTempDatos.f_hasta#"><br />
							<cfdump var="#rsTempDatos.mintotalesreales#"><br />
							<cfdump var="#rsTempDatos.minsocioreales#"><br />
							<cfdump var="#rsTempDatos.minlaboradosreales#"><br />
							<cfdump var="#vn_horasrebajar#"><br />
							<cfdump var="#vn_horasjornadanormal#"><br />
							<cfdump var="#vn_horasextraA#"><br />
							<cfdump var="#vn_horasextraB#"><br />
							<cfdump var="#vn_horasrebajar#"><br />
							<cfdump var="#vn_horasjornadanormal#"><br />
							<cfdump var="#vn_horasextraA#"><br />
							<cfdump var="#vn_horasextraB#"><br />
							<br />
						--->

						<!---Insertar en tabla de acumulados ---->
						<cfquery name="InsertaAcumulado" datasource="#Arguments.Conexion#">			
							insert into RHCMCalculoAcumMarcas (	DEid, RHJid, CAMfdesde, 
																Ecodigo, CAMfhasta, 
																CAMtotminutos, CAMociominutos,
																CAMtotminlab, CAMcalchorasreb, 
																CAMcalchorasjornada, CAMcalchorasextA, 
																CAMcalchorasextB, CAMcalcmontoferiado, 
																CAMincidrebhoras, CAMincidjornada, 
																CAMincidhorasextA, CAMincidhorasextB, 
																CAMincidferiados, CAMcanthorasreb,
																CAMcanthorasjornada, CAMcanthorasextA, 
																CAMcanthorasextB, CAMmontoferiado, 
																CAMsuphorasreb, CAMsuphorasjornada, 
																CAMsuphorasextA, CAMsuphorasextB, 
																CAMsupmontoferiado, CAMestado, 
																CAMgeneradoporferiado,
																CAMpermiso,
																BMUsucodigo, BMfecha)
							values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTempDatos.jornada#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsTempDatos.f_desde#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsTempDatos.f_hasta#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsTempDatos.mintotalesreales#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsTempDatos.minsocioreales#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#rsTempDatos.minlaboradosreales#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasrebajar#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasjornadanormal#">,	
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasextraA#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasextraB#">,																			
									<cfqueryparam cfsqltype="cf_sql_money" value="#rsTempDatos.montoferiado#">,	
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTempDatos.incidenciarebajo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTempDatos.incidenciajornada#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTempDatos.incidenciaextraa#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTempDatos.incidenciaextrab#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTempDatos.incidenciaferiado#">,		
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasrebajar#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasjornadanormal#">,	
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasextraA#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasextraB#">,	
									<cfqueryparam cfsqltype="cf_sql_money" value="#rsTempDatos.montoferiado#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasrebajar#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasjornadanormal#">,	
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasextraA#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#vn_horasextraB#">,	
									<cfqueryparam cfsqltype="cf_sql_money" value="#rsTempDatos.montoferiado#">, 
									'P', 
									<cfif len(trim(rsTempDatos.generadoporferiado)) gt 0 and rsTempDatos.generadoporferiado gt 0>1<cfelse>0</cfif>,
									<cfif len(trim(rsTempDatos.generadoporpermiso)) gt 0 and rsTempDatos.generadoporpermiso gt 0>1<cfelse>0</cfif>,
									<cfif isdefined("Arguments.Usucodigo") and len(trim(Arguments.Usucodigo)) GT 0 and Arguments.Usucodigo GT 0>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#"><cfelse>null</cfif>,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">						
									)		
							<cf_dbidentity1 datasource="#Arguments.Conexion#">		
						</cfquery>
						<cf_dbidentity2 datasource="#Arguments.Conexion#" name="InsertaAcumulado">
						<!---Actualizar la tabla de marcas para indicar a cual lote pertenece--->
						<cfquery name="ActualizaMarcas" datasource="#Arguments.Conexion#">
							update RHControlMarcas
								set numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#InsertaAcumulado.Identity#">	
							where exists (	
								select 1
								from #TempMarcas# a
								where a.IdDatos = #rsTempDatos.IdDatos#
								and a.IdMarca = RHControlMarcas.RHCMid
							)
						</cfquery>
					<cfelse><!---Si no existe la jornada--->
						<cfthrow message="#MSG_NoSeEncuentroLaJornada#">
					</cfif><!---Fin de si existe la jornada---->			
				<cfelse><!----========== NO tiene jornada ===========---->
				
					<cfquery name="InsertaAcumulado" datasource="#Arguments.Conexion#">			
						insert into RHCMCalculoAcumMarcas (	DEid, RHJid, CAMfdesde, 
															Ecodigo, CAMfhasta, 
															CAMtotminutos, CAMociominutos,
															CAMtotminlab, CAMcalchorasreb, 
															CAMcalchorasjornada, CAMcalchorasextA, 
															CAMcalchorasextB, CAMcalcmontoferiado, 
															CAMincidrebhoras, CAMincidjornada, 
															CAMincidhorasextA, CAMincidhorasextB, 
															CAMincidferiados, CAMcanthorasreb,
															CAMcanthorasjornada, CAMcanthorasextA, 
															CAMcanthorasextB, CAMmontoferiado, 
															CAMsuphorasreb, CAMsuphorasjornada, 
															CAMsuphorasextA, CAMsuphorasextB, 
															CAMsupmontoferiado, CAMestado, 
															BMUsucodigo, BMfecha)							
						select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#"> as DEid,
								jornada as RHJid,
								f_desde as CAMfdesde,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> as Ecodigo,
								f_hasta as CAMfhasta,
								mintotalesreales as CAMtotminutos,
								minsocioreales as CAMociominutos,
								minlaboradosreales as CAMtotminlab,
								horasrebajar as CAMcalchorasreb,
								horasnormales as CAMcalchorasjornada,
								horasextraa as CAMcalchorasextA,
								horasextrab as CAMcalchorasextB,
								montoferiado as CAMcalcmontoferiado,
								incidenciarebajo as CAMincidrebhoras,
								incidenciajornada as CAMincidjornada,
								incidenciaextraa as CAMincidhorasextA, 
								incidenciaextrab as CAMincidhorasextB, 
								incidenciaferiado as CAMincidferiados, 
								horasrebajar as CAMcanthorasreb,
								horasnormales as CAMcanthorasjornada, 
								horasextraa as CAMcanthorasextA, 
								horasextrab as CAMcanthorasextB, 
								montoferiado as CAMmontoferiado, 
								horasrebajar as CAMsuphorasreb,
								horasnormales as CAMsuphorasjornada, 
								horasextraa as CAMsuphorasextA, 
								horasextrab as CAMsuphorasextB, 
								montoferiado as CAMsupmontoferiado, 
								'P',
								<cfif isdefined("Arguments.Usucodigo") and len(trim(Arguments.Usucodigo)) GT 0 and Arguments.Usucodigo GT 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#"><cfelse>null</cfif>
								as BMUsucodigo, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">as BMfecha				
						from #TempDatos#
						where jornada is null	
						<cf_dbidentity1 datasource="#Arguments.Conexion#">
					</cfquery>
					<cf_dbidentity2 datasource="#Arguments.Conexion#" name="InsertaAcumulado">			
					<!---Actualizar la tabla de marcas para indicar a cual lote pertenece--->
					<cfquery name="ActualizaMarcas" datasource="#Arguments.Conexion#">
						update RHControlMarcas
							set numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#InsertaAcumulado.Identity#">	
						from #TempMarcas# a
							inner join RHControlMarcas b
								on a.IdMarca = b.RHCMid
						where a.IdDatos = #rsTempDatos.IdDatos#
					</cfquery>
				</cfif><!---Fin de si tiene o no jornada la tabla temporal #TempDatos#---->
			</cfloop><!---Fin del Loop de #TempDatos#---->
		</cftransaction>
	</cffunction>
	<!---	============================== RH_ProcesoGeneraFeriados ============================== --->
	<cffunction name="RH_ProcesoGeneraFeriados" access="public" output="true">
		<!--- Recibe como parámetro el ID del Feriado por Generar --->
		<cfargument name="RHFid" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="false">
		<cfargument name="Conexion" type="string" required="false">
		<cfargument name="Usucodigo" type="numeric" required="false">
		<!---
			Si Prende el Debug se pintará la siguiente información y no se culminará la transacción:
			1- La Lista de Empleados por procesar feriados:
				- Se limita para poder estudiarla.
				- Se puede limitar por cantidad con el DebugCantEmpleados, o para un empleado
				específico con el DebugDEid.
			2- Por cada empleado se pintará la jornada con la información requerida para calcular 
				el monto del feriado y generar el cálculo de horas dentro de esta lista viene una 
				columna de nombre origen que indica el origen de la jornada si es por planificador o
				por linea del tiempo en caso de que no se haya encontrado la planificación. Ojo que si
				no se encuentra jornada o el pago no es por horas no se genera ningun registro. Además
				que si no viene el tipo calculo o no es tres, el monto del feriado quedaría en cero.
			3- Cuando cumple todas las condiciones para el cálculo se pintará una leyenda que indicará
				el monto calculado para el feriado, con el cual se podría observar el resultado del 
				cálculo. la leyenda seríal algo como: MONTO FERIADO CALCULADO: 1910023.7825.
			4- Se pintará al final los cálculos de horas por generar.
		--->
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfargument name="DebugCantEmpleados" type="numeric" required="false" default="3">
		<cfargument name="DebugDEid" type="numeric" required="false" default="-1">
		<!--- DEFINE ARGUMENTOS ECODIGO, CONEXION, USUCODIGO. CUANDO NO VIENEN. --->
		<cfif (not isdefined("Arguments.Ecodigo")) and (isdefined("Session.Ecodigo"))>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
		</cfif>
		<cfif (not isdefined("Arguments.Conexion")) and (isdefined("Session.Dsn"))>
			<cfset Arguments.Conexion = Session.Dsn>
		</cfif>
		<cfif (not isdefined("Arguments.Usucodigo")) and (isdefined("Session.Usucodigo"))>
			<cfset Arguments.Usucodigo = Session.Usucodigo>
		</cfif>
		<!---Crea Tabla temporal de procesamiento --->
		<cfinvoke method="createTempDatos" conexion="#Arguments.Conexion#">
		<cfinvoke method="createTempMarcas" conexion="#Arguments.Conexion#">
		<!--- Obtiene la finformación del Feriado --->
		<cfquery name="rsFeriados" datasource="#Arguments.Conexion#">
			select a.RHFfecha
			from RHFeriados a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHFid#">
				and a.RHFpagooblig = 1
		</cfquery>
		<cfset vnFecha = rsFeriados.RHFfecha>
		<cfquery name="rsEmpleado" datasource="#Arguments.Conexion#">
			<cfif arguments.debug>
				<cf_dbrowcount1 rows="#Arguments.DebugCantEmpleados#">
			</cfif>
			select distinct a.DEid
			from RHCMEmpleadosGrupo a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and not exists (select 1
				from RHCMCalculoAcumMarcas b
				where <cf_dbfunction name="to_datechar" args="b.CAMfdesde"> = <cfqueryparam cfsqltype="cf_sql_date" value="#vnFecha#">
				and CAMgeneradoporferiado = 1
				and b.Ecodigo = a.Ecodigo
				and b.DEid = a.DEid
			)
			and exists(
				select 1 from LineaTiempo lt
				where lt.DEid = a.DEid
				  and lt.Ecodigo = a.Ecodigo
				  and <cfqueryparam cfsqltype="cf_sql_date"  value="#vnFecha#"> between lt.LTdesde and lt.LThasta
			)
			and not exists(
				select 1 from LineaTiempo lt
					inner join RHTipoAccion b
						on lt.RHTid = b.RHTid
						and b.RHTpaga = 0
				where lt.DEid = a.DEid
				  and lt.Ecodigo = a.Ecodigo
				  and <cfqueryparam cfsqltype="cf_sql_date"  value="#vnFecha#"> between lt.LTdesde and lt.LThasta
			)
			<cfif arguments.debug and Arguments.DebugDEid GT 0>
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DebugDEid#">
			</cfif>
			<cfif arguments.debug>
				<cf_dbrowcount2 rows="#Arguments.DebugCantEmpleados#">
			</cfif>
		</cfquery>
		<cfif arguments.debug>
			<cfdump var="#rsEmpleado#">
		</cfif>
		<cfloop query="rsEmpleado">
			<cfset vnEmpleado = rsEmpleado.DEid>
			<cfset vn_montoFeriado = 0><!---Monto calculado de incidencias tipo calculo---->
			<cfset rsJornada = funJornada(Arguments.Ecodigo, Arguments.Conexion, vnEmpleado, vnFecha)>
			<cfif arguments.debug>
				<cfdump var="#rsJornada#">
			</cfif>
			<cfquery name="valParam" datasource="#session.dsn#">
				select Pvalor from RHParametros
				where Ecodigo=#session.Ecodigo#
				and Pcodigo=2042
			</cfquery>
			<cfif rsJornada.recordcount GT 0 and (rsJornada.PagoPorHoras EQ 1 or valParam.Pvalor eq 1)>
				<cfif len(trim(rsJornada.TipoCalculo)) and rsJornada.TipoCalculo EQ 3><!---Si la incidencia es de tipo calculo---->
					<!----Llamado a la calculadora---->
					<cfset current_formulas = rsJornada.CIcalculo>
					<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(vnFecha),
												   LSParseDateTime(vnFecha),
												   rsJornada.CIcantidad,
												   rsJornada.CIrango,
												   rsJornada.CItipo,
												   vnEmpleado,
												   rsJornada.RHJid,
												   Arguments.Ecodigo,
												   0,
												   0,
												   rsJornada.CIdia,
												   rsJornada.CImes,
												   rsJornada.Tcodigo,
												   'true',
												   'false',
												   '',
												   FindNoCase('DiasRealesCalculoNomina', current_formulas))> <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
					<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
                    <cfset calc_error = RH_Calculadora.getCalc_error()>
					<cfif Not IsDefined("values")>
						<cfif isdefined("presets_text")>
							<cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
						<cfelse>
							<cfthrow detail="#calc_error#" >
						</cfif>
					<cfelse>
						<cfset vn_montoFeriado = values.get('resultado').toString()>
					</cfif>
					<cfif arguments.debug>
						<cfdump var="MONTO FERIADO CALCULADO: #vn_montoFeriado#">
					</cfif>
				</cfif>
				<cfquery datasource="#Arguments.Conexion#">
					insert into #TempDatos# (DEid,f_desde,f_hasta,jornada,minlaboradosestimados,minocioestimados,
											mintotalesreales,minsocioreales,minlaboradosreales,horasrebajar,horasnormales,
											horasextraa,horasextrab,montoferiado,incidenciarebajo,incidenciajornada,
											incidenciaextraa,incidenciaextrab,incidenciaferiado,generadoporferiado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vnFecha#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vnFecha#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJid#">,
							0.00, 0.00,	0.00, 0.00,	0.00,
							0.00,0.00,0.00,0.00,
							<cfqueryparam cfsqltype="cf_sql_money" value="#vn_montoFeriado#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincAusencia#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincHJornada#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincExtraA#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincExtraB#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincFeriados#">,
							1
					)
				</cfquery>
			</cfif>
		</cfloop>
		<cfif arguments.debug>
			<cfabort><!--- 	Este abort es redundante porque por defecto el dumptable lo
					 		hace pero es para que quede explicito que con debug hace un 
					 		abort. 
					 --->
		</cfif>
		<cfinvoke method="funcProcesaTempDatos" conexion="#Arguments.Conexion#" ecodigo="#Arguments.Ecodigo#" usucodigo="#Arguments.Usucodigo#"/>
	</cffunction>
	<!--- FUNCION QUE GENERA MARCAS PARA LAS PERSONAS QUE ESTEN DE PERMISO --->
	<cffunction name="RH_ProcesoGeneraPermisos" access="public" output="true">
		<cfargument name="Ecodigo" type="numeric" required="false">
		<cfargument name="Conexion" type="string" required="false">
		<cfargument name="Usucodigo" type="numeric" required="false">
		<cfargument name="Debug" type="boolean" required="false" default="false">
		<cfargument name="fecha" type="date" required="false" default="01/01/6100">
		<!--- DEFINE ARGUMENTOS ECODIGO, CONEXION, USUCODIGO. CUANDO NO VIENEN. --->
		<cfif (not isdefined("Arguments.Ecodigo")) and (isdefined("Session.Ecodigo"))>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
		</cfif>
		<cfif (not isdefined("Arguments.Conexion")) and (isdefined("Session.Dsn"))>
			<cfset Arguments.Conexion = Session.Dsn>
		</cfif>
		<cfif (not isdefined("Arguments.Usucodigo")) and (isdefined("Session.Usucodigo"))>
			<cfset Arguments.Usucodigo = Session.Usucodigo>
		</cfif>
		<!---Crea Tabla temporal de procesamiento --->
		<cfinvoke method="createTempDatos" conexion="#Arguments.Conexion#">
		<cfinvoke method="createTempMarcas" conexion="#Arguments.Conexion#">
		<!--- SE BUSCAN LOS EMPLEADOS QUE TRABAJAN POR MARCAS Y QUE TENGAN ACCIONES DE PERMISO CON GOSE
			SE SALARIO
			Permiso  = 4  --->
		<cfquery name="rsEmpleado" datasource="#Arguments.Conexion#">
			 select a.DEid,LTdesde,coalesce(LThasta,<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">) as LThasta
			 from LineaTiempo a
                 inner join RHTipoAccion b
                    on b.RHTid = a.RHTid 
                    and b.RHTcomportam = 4
                    and b.RHTpaga = 1 
                 left outer join RHPlanificador p
                    on p.DEid = a.DEid
                    and <cf_dbfunction name="to_datechar" args="p.RHPJfinicio"> = <cf_dbfunction name="to_datechar" args="a.LTdesde"><!--- Si el permiso es de varios días unos con jornada que marque y otros no  JEJEJEJEJEJEJEJEJE !!!!--->
                 inner join RHJornadas j
                    on j.RHJid = coalesce(p.RHJid,a.RHJid)
                    and j.RHJmarcar = 1
                    and j.RHJornadahora = 1
             where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
             and 
             	<!--- Esta es la cantidad de días de la acción  --->
                <cf_dbfunction name="date_part" args="dd,a.LThasta"> + 1 - <cf_dbfunction name="date_part" args="dd,a.LTdesde"> > 
                <!--- Esta es la cantidad de días generados por permiso  --->
                (
             	select count(1) from RHCMCalculoAcumMarcas
                where DEid = a.DEid
                and CAMfdesde between a.LTdesde and a.LThasta
                and CAMpermiso = 1
             )
             <!--- limitar de alguna forma para que no traiga a Raimundo --->
		</cfquery>
		<cfloop query="rsEmpleado">
			<cfset cantDias = DateDiff('d',rsEmpleado.LTdesde,rsEmpleado.LThasta)+1>
			<cfset vnEmpleado = rsEmpleado.DEid>
			<cfset vFecha = rsEmpleado.LTdesde>
			<cfloop index="i" from="1" to="#cantDias#">
				<!--- VERIFICA SI LA FECHA DEL PERMISO ES UN DIA FERIADO, SI ES FERIADO NO GENERA LA MARCA --->
                <cfquery name="rsFeriado" datasource="#Arguments.Conexion#">
                    select a.RHFfecha
                    from RHFeriados a
                    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                        and a.RHFpagooblig = 1
                        and a.RHFfecha = <cfqueryparam cfsqltype="cf_sql_date"  value="#vFecha#">
                </cfquery>
				<cfif vFecha LTE Arguments.Fecha and rsFeriado.RecordCount EQ 0>
                	
					<!--- VERIFICA QUE LA MARCA NO HAYA SIDO GENERADA --->
					<cfquery name="rsVerifMarca" datasource="#session.DSN#">
						select 1
						from RHCMCalculoAcumMarcas b
						where <cf_dbfunction name="to_datechar" args="b.CAMfdesde"> = <cfqueryparam cfsqltype="cf_sql_date" value="#vFecha#">
						and CAMpermiso = 1
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
					</cfquery>

					<cfif isdefined('rsVerifMarca') and rsVerifMarca.RecordCount EQ 0>
						<cfset rsJornada = funJornada(Arguments.Ecodigo, Arguments.Conexion, vnEmpleado, vFecha)>
						<cfset Lvar_dw = DatePart('w',#vFecha#)>
						<cfif rsJornada.RecordCount>
							<cfquery name="VerificaDia" datasource="#session.DSN#">
								select RHJhorasNormales
								from RHDJornadas a
								where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJid#">
								  and RHDJdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_dw#">
							</cfquery>
							<cfif isdefined('VerificaDia') and VerificaDia.RecordCount>
								<cfquery datasource="#Arguments.Conexion#">
									insert into #TempDatos# (DEid,f_desde,f_hasta,jornada,
															minlaboradosestimados,
															minlaboradosestimadosHEA,
															minlaboradosestimadosHEB,
															minocioestimados,
															mintotalesreales,
															minsocioreales,
															minlaboradosreales,
															horasrebajar,horasnormales,
															horasextraa,horasextrab,montoferiado,incidenciarebajo,incidenciajornada,
															incidenciaextraa,incidenciaextrab,incidenciaferiado,
															generadoporferiado,generadoporpermiso)
									values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFecha#">,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFecha#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJid#">,
											coalesce((coalesce(#VerificaDia.RHJhorasNormales#,0))*60,0),
											coalesce((coalesce(#VerificaDia.RHJhorasNormales#,0))*60,0),
											coalesce((coalesce(#VerificaDia.RHJhorasNormales#,0))*60,0),
											0.00,
											coalesce((coalesce(#VerificaDia.RHJhorasNormales#,0))*60,0), 
											0.00,
											coalesce((coalesce(#VerificaDia.RHJhorasNormales#,0))*60,0),
											0.00,
											0.00,
											0.00,0.00,0.00,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincAusencia#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincHJornada#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincExtraA#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincExtraB#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJornada.RHJincFeriados#">,
											0,
											1
									)
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
				<cfset vFecha = DateAdd('d',1,vFecha)>
			</cfloop>
		</cfloop>
		<cfinvoke method="funcProcesaTempDatos" conexion="#Arguments.Conexion#" ecodigo="#Arguments.Ecodigo#" usucodigo="#Arguments.Usucodigo#"/>
	</cffunction>
</cfcomponent>

