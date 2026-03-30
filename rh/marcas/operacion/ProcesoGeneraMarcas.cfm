<cfsetting requesttimeout="3600">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElEmpleadoNoTienJornadaDefinidaParaAlgunaDeLasMarcas"
	Default="El empleado no tiene jornada definida para el día de alguna de las marcas"	
	returnvariable="MSG_EmpleadoNoTieneJornada"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeEncuentroLaJornada"
	Default="No se encontró la jornada"	
	returnvariable="MSG_NoSeEncuentroLaJornada"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_HacenFaltaDatosDeLaJornada"
	Default="Hacen falta datos de la jornada:"
	returnvariable="MSG_HacenFaltaDatosDeLaJornada"/>

<!----Calculadora---->
<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>	
<!---============================== Función: funAccionPaga =========================================----->
<!--- Función para verificar si el empleado tiene una accion de tipo NO PAGA en la fecha que recibe ---->
<!---  de parámetro.  Devuelve un true si tiene y false si no									    ----->
<!---================================================================================================---->
<cffunction name="funAccionPaga" access="public" output="true" returntype="boolean">
	<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
	<cfargument name="arg_fecha" 	type="date" 	required="yes">
		<cfset vn_retorno = false>
		<cfquery name="rsLineaT" datasource="#session.DSN#">
			select b.RHTpaga,a.LTdesde, a.LThasta, a.RHTid, b.RHTcodigo
			from LineaTiempo a
				inner join RHTipoAccion b
					on a.RHTid = b.RHTid
					and b.RHTpaga = 0
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.arg_fecha#"> between a.LTdesde and a.LThasta
		</cfquery>
		<cfif rsLineaT.RecordCount NEQ 0>
			<cfset vn_retorno = true>
		</cfif>
		<cfreturn vn_retorno>
</cffunction>
<!---============================== Función: funJornada ============================================----->
<!--- Función que devuelve datos de la jornada del empleado en una fecha específica.  Si tiene 	 	 ---->
<!---  planificador lo utiliza  sino la jornada que este en la línea del tiempo. 					 ---->
<!---================================================================================================---->
<cffunction name="funJornada" access="public" output="true" returntype="query">
	<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
	<cfargument name="arg_fecha" 	type="date" 	required="yes">
		<cfquery name="rsPlanificador" datasource="#session.DSN#"><!---Buscar los datos en el planificador--->			
			select 	a.RHJid,
					b.RHJornadahora as PagoPorHoras,
					b.RHJincAusencia,
					b.RHJincHJornada,
					b.RHJincExtraA,
					b.RHJincExtraB,
					b.RHJincFeriados,		
					c.CItipo as TipoCalculo,
					coalesce(e.CIcantidad,0) as CIcantidad,
					e.CIrango,
					e.CItipo,
					e.CIdia,
					e.CImes,
					e.CIcalculo,
					(select  max(Tcodigo)
					from LineaTiempo d
					where a.RHPJfinicio between LTdesde and LThasta
						and a.DEid = d.DEid
					)as Tcodigo
					
			from RHPlanificador a
				inner join RHJornadas b
					on a.RHJid = b.RHJid
					
					left outer join CIncidentes c
						on b.RHJincFeriados = c.CIid
						
						left outer join CIncidentesD e
							on c.CIid = e.CIid
					
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">				
				and <cf_dbfunction name="date_format" args="a.RHPJfinicio,yyyymmdd"> = <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(Arguments.arg_fecha),'yyyymmdd')#"> 
		</cfquery>
		<cfif rsPlanificador.RecordCount EQ 0><!----Si no tiene nada en el planificador---->
			<cfquery name="rsLineaT" datasource="#session.DSN#"><!---Busca la joranada y el horario--->
				select  a.RHJid,
						b.RHJornadahora as PagoPorHoras,
						b.RHJincAusencia,
						b.RHJincHJornada,
						b.RHJincExtraA,
						b.RHJincExtraB,
						b.RHJincFeriados,								
						c.CItipo as TipoCalculo,
						coalesce(e.CIcantidad,0) as CIcantidad,
						e.CIrango,
						e.CItipo,
						e.CIdia,
						e.CImes,
						e.CIcalculo,
						a.Tcodigo
				
				from LineaTiempo a
					inner join RHJornadas b
						on a.RHJid = b.RHJid			
						
						left outer join CIncidentes c
							on b.RHJincFeriados = c.CIid
						
							left outer join CIncidentesD e
								on c.CIid = e.CIid
							
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
					and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(Arguments.arg_fecha),'yyyymmdd')#"> 
						between <cf_dbfunction name="date_format" args="a.LTdesde,yyyymmdd"> and
							 	<cf_dbfunction name="date_format" args="a.LThasta,yyyymmdd">
			</cfquery>
			<cfif rsPlanificador.RecordCount EQ 0>
				<cfreturn rsLineaT>				
			</cfif>
		<cfelse>
			<cfreturn rsPlanificador>
		</cfif>
</cffunction>
<!---============================== Función: funDatosJornada =============================================----->
<!--- Función que devuelve los datos de la jornada y del horario para una fecha especifica y una jornada  ----->
<!---=====================================================================================================----->
<cffunction name="funDatosJornada" access="public" output="true" returntype="query">
	<cfargument name="arg_RHJid"  	type="numeric" 	required="yes">
	<cfargument name="arg_Fecha" 	type="date" 	required="yes">
	<cfargument name="arg_DEid" 	type="string" 	required="yes">
		<cfset LvarRHPlibre = 0>
		<cfquery name="rsRHPlanificador" datasource="#session.DSN#">
			select 1 
			from RHPlanificador  c
			where c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_DEid#">
			  and <cf_dbfunction name="date_format" args="c.RHPJfinicio,yyyymmdd"> = <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(Arguments.arg_Fecha,'yyyymmdd')#"> 
			  and c.RHPlibre = 1
		</cfquery>		
		<cfif rsRHPlanificador.recordcount>
			<cfset LvarRHPlibre = 1>
		</cfif>
		<cfquery name="rsDatosJornada" datasource="#session.DSN#">
			select 	a.RHJid, a.RHJmarcar, a.RHJornadahora, a.RHJjsemanal, a.RHJrebajaocio, 
					a.RHJminutosExtras, a.RHJincAusencia, a.RHJincHJornada,
					a.RHJincExtraA, a.RHJincExtraB, a.RHJincFeriados,
					(#LvarRHPlibre#) as LibrePlanificador,
					<!---==== Anterior ===== coalesce((coalesce(b.RHJhorasNormales,0))*60,0) as minutoslaboradosestimados,---->
					case datepart(dw,<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.arg_Fecha#">) 
						when  2 then ( case when a.RHJmon = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) 
						when  3 then ( case when a.RHJtue = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0) end ) 
						when  4 then ( case when a.RHJwed = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) 
						when  5 then ( case when a.RHJthu = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) 
						when  6 then ( case when a.RHJfri = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) 
						when  7 then ( case when a.RHJsat = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) 
						when  1 then ( case when a.RHJsun = 0 then 0 else coalesce((coalesce(b.RHJhorasNormales,0))*60,0)  end ) 
					end as minutoslaboradosestimados,
					case when b.RHDJdia is not null then
						coalesce(abs(datediff(mi,b.RHJhorainicom,b.RHJhorafincom)),0) 
					else 			
						coalesce(abs(datediff(mi,a.RHJhorainicom,a.RHJhorafincom)),0)
					end as minutosocioestimados
			from RHJornadas a
				left outer join RHDJornadas b
					on a.RHJid = b.RHJid
					and datepart(dw,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.arg_Fecha#">) =  RHDJdia
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_RHJid#">
		
		</cfquery>
		<!---Si tiene ese dia en el planificador y esta marcado como dia libre pone los laborados estimados en 0---->
		<cfif rsDatosJornada.RecordCount NEQ 0 and len(trim(rsDatosJornada.LibrePlanificador)) and rsDatosJornada.LibrePlanificador EQ 1>
			<cfset rsDatosJornada.minutoslaboradosestimados = 0>
		</cfif>
		<cfreturn rsDatosJornada>
</cffunction>
<!---============================== Función: funOcioEstimado ====================================================----->
<!--- Función que calcula el tiempo de ocio estimado segun las marcas de break del grupo que se esta procesando  ----->
<!---============================================================================================================----->
<cffunction name="funOcioEstimado" access="public" output="true" returntype="string">
	<cfargument name="arg_fechaextremoE"  	type="string" 	required="yes">
	<cfargument name="arg_fechaextremoF"  	type="string" 	required="yes">
	<cfargument name="rsInfoEmpleado"  		type="query" 	required="yes">
	<cftry>
		<cfset vn_minocio = 0>
		<cfdump var="#arg_fechaextremoE#"><br />
		<cfdump var="#arg_fechaextremoF#"><br />
		<cfquery name="rsMinutosOcio" datasource="#session.DSN#"><!---Obtiene todas las marcas de ocio(SB/EB)---->
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
	<cfcatch> <!---Mensaje de base de datos--->
		<cfthrow  message="Error calculando el tiempo de ocio estimado para el empleado #rsInfoEmpleado.DEidentificacion# - #rsInfoEmpleado.DEapellido1# #rsInfoEmpleado.DEapellido2# #rsInfoEmpleado.DEnombre#, para la fecha #arguments.arg_fechaextremoE#. Error: #cfcatch.Message#." detail="#cfcatch.Detail#">
	</cfcatch>
	</cftry>
	<cfreturn vn_minocio>
</cffunction>
<!---============================== Función: funInsertaDatosMarcas ================================================----->
<!--- Función que inserta datos en #TempDatos# y actualiza en la temporal de marcas el ID para efecto de amarrar   ----->
<!--- luego a las marcas el numero de lote correspondiente                                                         ----->						   
<!---===============================================================================================================---->
<cffunction name="funInsertaDatosMarcas" access="public" output="true">
	<cfargument name="arg_minutostotalesreales"  	type="string" 	required="yes" default="0">
	<cfargument name="arg_minutosocioreales"  		type="string" 	required="yes" default="0">
	<cfargument name="arg_minutoslaboradosreales"  	type="string" 	required="yes" default="0">
	<cfargument name="arg_DEid"  					type="numeric" 	required="yes">
	<cfargument name="arg_Fdesde"  					type="string" 	required="yes">
	<cfargument name="arg_grupo"  					type="numeric" 	required="yes">
	<cfargument name="arg_datos"  					type="query" 	required="yes">

	<cfset rsDatos = arguments.arg_datos> 
	<cfif len(trim(rsDatos.RHJincHJornada)) and len(trim(rsDatos.RHJincExtraA)) and len(trim(rsDatos.RHJincExtraB)) and len(trim(rsDatos.RHJincFeriados))>
		<cfquery name="inserta" datasource="#session.DSN#">
			insert into #TempDatos# (DEid,f_desde,f_hasta,jornada,
									minlaboradosestimados,minocioestimados,mintotalesreales,minsocioreales,minlaboradosreales,
									horasrebajar,horasnormales,horasextraa,horasextrab,
									montoferiado,
									incidenciarebajo,incidenciajornada,incidenciaextraa,incidenciaextrab,incidenciaferiado)
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
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJincFeriados#">
			)
			<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="inserta" verificar_transaccion="false">	
		<cfif len(trim(inserta.identity))>
			<!--Actualizar el grupo de la tabla de marcas para indicar que ya se procesaron--->
			<cfquery datasource="#session.DSN#">
				update #TempMarcas# set IdDatos = <cfqueryparam cfsqltype="cf_sql_numeric" value="#inserta.identity#">
				where grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_grupo#">
			</cfquery>
		</cfif>		
	<cfelse>
		<cf_throw message="#MSG_HacenFaltaDatosDeLaJornada#" errorcode="4055">
	</cfif>
</cffunction>
<!---============================== Función: funActualizaDatos ================================================----->
<!--- Función actualiza datos de #TempDatos#  y actualiza en la temporal de marcas el ID para efecto de    	   ----->
<!--- amarrar luego a las marcas el numero de lote correspondiente 											   ----->
<!---==========================================================================================================----->
<cffunction name="funActualizaDatos" access="public" output="true">
	<cfargument name="arg_minutostotalesreales"  	type="string" 	required="yes">
	<cfargument name="arg_minutosocioreales"  		type="string" 	required="yes">
	<cfargument name="arg_minutoslaboradosreales"  	type="string" 	required="yes">
	<cfargument name="arg_Iddatos"  				type="numeric" 	required="yes">
	<cfargument name="arg_grupo"  					type="numeric" 	required="yes">
	<cfargument name="arg_Fdesde"  					type="string" 	required="yes">
	<cfargument name="arg_datos"  					type="query" 	required="yes">
	
	<cfquery datasource="#session.DSN#">
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
	<cfquery datasource="#session.DSN#">
		update #TempMarcas# 
			set IdDatos = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_Iddatos#">
		where grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.arg_grupo#">
	</cfquery>
</cffunction>
<!---****************************************************************************************************************---->
<!---************************************************ INICIO DEL PROCESO ********************************************----->
<!---****************************************************************************************************************---->
<!---=================================================================================================
	Definir los empleados a quienes se les van a procesar las marcas. Solo se procesan los que 
	tienen marcas registradas en la tabla RHControlMarcas 
======================================================================================================----->
<cfquery name="rsEmpleados" datasource="#session.DSN#">
	select distinct b.DEid
	from RHCMEmpleadosGrupo b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		<cfif isdefined("form.FGid") and len(trim(form.FGid))>
			and b.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FGid#">					
		</cfif>
		<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FDEid#">	
		</cfif>
</cfquery>

<!---=================================================================================================
	Tabla temporal de datos
======================================================================================================----->
<cf_dbtemp name="TempDatos" returnvariable="TempDatos" datasource="#session.DSN#">
	<cf_dbtempcol name="IdDatos" 					type="numeric"		mandatory="yes"  identity="yes">
	<cf_dbtempcol name="DEid" 						type="numeric"		mandatory="yes">
	<cf_dbtempcol name="f_desde" 					type="datetime"		mandatory="no">
	<cf_dbtempcol name="f_hasta" 					type="datetime"		mandatory="no">
	<cf_dbtempcol name="jornada" 					type="numeric"		mandatory="no">
	<cf_dbtempcol name="minlaboradosestimados" 		type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="minocioestimados" 			type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="mintotalesreales" 			type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="minsocioreales" 			type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="minlaboradosreales" 		type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="horasrebajar" 				type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="horasnormales" 				type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="horasextraa" 				type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="horasextrab" 				type="numeric(9,2)"		mandatory="no">
	<cf_dbtempcol name="montoferiado" 				type="money"		mandatory="no">
	<cf_dbtempcol name="incidenciarebajo" 			type="numeric"		mandatory="no">
	<cf_dbtempcol name="incidenciajornada" 			type="numeric"		mandatory="no">
	<cf_dbtempcol name="incidenciaextraa" 			type="numeric"		mandatory="no">
	<cf_dbtempcol name="incidenciaextrab" 			type="numeric"		mandatory="no">
	<cf_dbtempcol name="incidenciaferiado" 			type="numeric"		mandatory="no">
</cf_dbtemp>
<!---=================================================================================================
	Tabla temporal de marcas
======================================================================================================----->	
<cf_dbtemp name="TempMarcas" returnvariable="TempMarcas" datasource="#session.DSN#">
	<cf_dbtempcol name="IdMarca" 		type="numeric"		mandatory="yes">
	<cf_dbtempcol name="DEid" 			type="numeric"		mandatory="yes">
	<cf_dbtempcol name="tipo" 			type="char(2)"		mandatory="no">
	<cf_dbtempcol name="fechahora" 		type="datetime"		mandatory="no">
	<cf_dbtempcol name="jornada" 		type="numeric"		mandatory="no">
	<cf_dbtempcol name="grupomarca" 	type="numeric"		mandatory="no">
	<cf_dbtempcol name="IdDatos" 		type="numeric"		mandatory="no">
</cf_dbtemp>	
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
	<cfquery datasource="#session.DSN#">
		delete from #TempDatos#
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from #TempMarcas#
	</cfquery>
	<cfset fechadesde = ''><!---Fecha desde a procesar---->
	<cfset fechahasta = ''><!---Fecha hasta a procesar---->
	<cfset minutostotalesreales = 0>
	<cfset minutosocioreales = 0>
	<cfset minutoslaboradosreales = 0>
	<cfset vnEmpleado = rsEmpleados.DEid><!---Variable con el DEid del empleado--->
	<!--- Consulta Datos del Empleado para enviar mensajes de error referentes al empleado --->
	<cfquery name="rsInfoEmpleado" datasource="#Session.DSN#">
		select DEidentificacion, DEapellido1, DEapellido2, DEnombre
		from DatosEmpleado
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
	</cfquery>
	<!---========== BUSCAR RANGO DE FECHAS=============----->
	<!---====== Buscar fecha desde a procesar (ultima marca de salida procesada) ======---->
	<cfquery name="rsFechadesde" datasource="#session.DSN#"><!---Ultima marca de salida procesada (numlote not null)---->
		select max(fechahoramarca) as fechadesde
		from RHControlMarcas a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
				
		<cfquery name="rsFechadesdeB" datasource="#session.DSN#"><!---Ultima marca de entrada procesada (numlote is not null)---->
			select min(fechahoramarca) as fechadesde
			from RHControlMarcas a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ltrim(rtrim(a.tipomarca)) = 'E'
				and a.registroaut = 1
				and a.numlote is null
				and a.grupomarcas is not null
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
				and <cf_dbfunction name="date_format" args="a.fechahoramarca,yyyymmdd"> <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(LSParseDateTime(form.fechaFin),'yyyymmdd')#">
		</cfquery>	
		<cfif (rsFechadesdeB.RecordCount EQ 0) or (len(trim(rsFechadesdeB.fechadesde)) EQ 0)><!----Si no aplica ninguno de los anteriores se asigna la fecha hasta del parametro ---->
			<cfset fechadesde = CreateDateTime(year(LSParseDateTime(form.fechaFin)), month(LSParseDateTime(form.fechaFin)), day(LSParseDateTime(form.fechaFin)), 00, 00,0)>
		<cfelse>
			<cfset fechadesde = DateAdd("s", -1, "#rsFechadesdeB.fechadesde#")>	
		</cfif>		
	<cfelse>
		<cfset fechadesde = rsFechadesde.fechadesde>		
	</cfif>
	<!---===== Buscar la fecha hasta a procesar ======---->
	<cfquery name="rsFechahasta" datasource="#session.DSN#"><!---Ultima marca de entrada--->
		select RHCMid,grupomarcas,fechahoramarca
		from RHControlMarcas 
		where fechahoramarca = (select  max(fechahoramarca) 
							from RHControlMarcas a
							where ltrim(rtrim(a.tipomarca)) = 'E'
								and a.registroaut = 1
								and a.grupomarcas is not null
								<!----and a.numlote is not null---->											
								and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
								and <cf_dbfunction name="date_format" args="a.fechahoramarca,yyyymmdd"> <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(LSParseDateTime(form.fechaFin),'yyyymmdd')#">
							)
	</cfquery>
	<cfif (rsFechahasta.RecordCount EQ 0) or (len(trim(rsFechahasta.fechahoramarca)) EQ 0)>				
		<cfset fechahasta = CreateDateTime(year(LSParseDateTime(form.fechaFin)), month(LSParseDateTime(form.fechaFin)), day(LSParseDateTime(form.fechaFin)), 23, 59,59)>
	<cfelse>
		<cfif len(trim(rsFechahasta.grupomarcas))>
			<cfquery name="rsFechahastaB" datasource="#session.DSN#">
				select max(a.fechahoramarca) as fechahasta
				from RHControlMarcas a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ltrim(rtrim(a.tipomarca)) = 'S'
					and a.grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFechahasta.grupomarcas#">
			</cfquery>
			<cfif rsFechahastaB.RecordCount NEQ 0 and len(trim(rsFechahastaB.fechahasta))>
				<cfset fechahasta = CreateDateTime(year(rsFechahastaB.fechahasta), month(rsFechahastaB.fechahasta), day(rsFechahastaB.fechahasta), 23, 59,59)>
			<cfelse>
				<cfset fechahasta = CreateDateTime(year(LSParseDateTime(form.fechaFin)), month(LSParseDateTime(form.fechaFin)), day(LSParseDateTime(form.fechaFin)), 23, 59,59)>
			</cfif>
		<cfelse>
			<cfset fechahasta = CreateDateTime(year(LSParseDateTime(form.fechaFin)), month(LSParseDateTime(form.fechaFin)), day(LSParseDateTime(form.fechaFin)), 23, 59,59)>
		</cfif>
	</cfif>
	<!---
	<cfdump var="#fechadesde#">
	<cfdump var="#fechahasta#">
	<cfdump var="#form.fechaFin#">
	--->
	<!---====== CALCULAR FERIADOS ======---->
	<cfquery name="rsFeriados" datasource="#session.DSN#">
		select a.RHFfecha
		from RHFeriados a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<!--- and a.RHFpagooblig = 1 --->
			and a.RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#fechadesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#fechahasta#">
			<!---Que no este ya procesado el feriado--->
			and not exists (select 1
						from RHCMCalculoAcumMarcas b
						where b.CAMfdesde = a.RHFfecha	
						and CAMestado = 'P'
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
			<cfquery datasource="#Session.DSN#" name="rsVerificaNombramiento">
					select LTid
					from LineaTiempo lt
					where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
					  and <cfqueryparam cfsqltype="cf_sql_date"  value="#RHFfecha#"> between lt.LTdesde and lt.LThasta
					  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<!---
			<cf_dump var="#rsVerificaNombramiento#">
			--->
			<!--- Si el empleado no está nombrado en la fecha del proceso, la marca se debe dejar sin procesar --->
			<cfif rsVerificaNombramiento.recordcount GT 0>
				<!----<cfset RHFfecha = rsFeriados.RHFfecha>
				 Verificar en la linea del tiempo si el empleado tiene una accion de tipo NO PAGA ---->		
				<cfif not funAccionPaga(vnEmpleado,RHFfecha)>			
					<!---Buscar la jornada del empleado en esa fecha--->
					<cfset rsJornada = funJornada(vnEmpleado,RHFfecha)>
					<cfif rsJornada.RecordCount NEQ 0>
						<cfif rsJornada.PagoPorHoras EQ 1><!---Si la jornada es por hora--->					
							<cfif len(trim(rsJornada.TipoCalculo)) and rsJornada.TipoCalculo EQ 3><!---Si la incidencia es de tipo calculo---->
								<!----Llamado a la calculadora---->
								<cfset current_formulas = rsJornada.CIcalculo>
								<cfset presets_text = RH_Calculadora.get_presets.get_presets(LSParseDateTime(RHFfecha),
															   LSParseDateTime(RHFfecha),
															   rsJornada.CIcantidad,
															   rsJornada.CIrango,
															   rsJornada.CItipo,
															   vnEmpleado,
															   rsJornada.RHJid,
															   session.Ecodigo,
															   0,
															   0,
															   rsJornada.CIdia,
															   rsJornada.CImes,
															   rsJornada.Tcodigo,
															   'true',
															   'false',
															   '',
															   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
															   )>
								<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
                                <cfset calc_error = RH_Calculadora.getCalc_error()>
								<cfif Not IsDefined("values")>
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_NoEsPosibleRealizarElCalculo"
								Default="No es posible realizar el c&aacute;lculo"
								returnvariable="LB_NoEsPosibleRealizarElCalculo"/> 
							
								<cfif Not IsDefined("values")>
									<cfif isdefined("presets_text")>
										<cf_throw detail="#LB_NoEsPosibleRealizarElCalculo#&nbsp;#presets_text#&nbsp;#current_formulas#&nbsp#calc_error#" errorCode="1000">
									<cfelse>
										<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#&nbsp;#calc_error#" errorCode="1000">
									</cfif>
								<cfelse>
									<cfset vn_montoFeriado = values.get('resultado').toString()>
								</cfif>
							</cfif>
							<cfquery datasource="#session.DSN#">
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
						<cf_throw message="#MSG_EmpleadoNoTieneJornada# (#rsInfoEmpleado.DEidentificacion# - #rsInfoEmpleado.DEapellido1# #rsInfoEmpleado.DEapellido2# #rsInfoEmpleado.DEnombre#)" errorcode="4060">
					</cfif><!---Fin de si se encontro la jornada--->
				</cfif><!---Fin de si tiene accion de NO paga--->
			</cfif><!--- Si el empleado no está nombrado --->
		</cfloop><!---Fin del Loop de FERIADOS---->
	</cfif>
	<!---=========== PROCESAR MARCAS ============---->		
	<!---Obtener bloque de las marcas en el rango de fechas a procesar insertarlo en temporal de marcas---->
	<cfquery name="rsInsertaMarcas" datasource="#session.DSN#">
		insert into #TempMarcas# (IdMarca,DEid,tipo,fechahora,jornada,grupomarca)
		select 	RHCMid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">,
				tipomarca, 
				fechahoramarca, 
				RHJid,
				grupomarcas
				
		from RHControlMarcas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">
			and registroaut = 1
			and grupomarcas is not null
			and numlote is null
			and fechahoramarca > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechadesde#">
			and fechahoramarca <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechahasta#">
			and exists(
				select 1
				from LineaTiempo lt
					inner join RHJornadas j
						on j.RHJid = lt.RHJid
						and j.RHJmarcar = 1
				where lt.DEid = RHControlMarcas.DEid
				  and <cf_dbfunction name="date_format" args="RHControlMarcas.fechahoramarca,yyyymmdd"> between lt.LTdesde and lt.LThasta
				  and lt.Ecodigo = RHControlMarcas.Ecodigo
				  )
		order by fechahoramarca asc, datepart(hh,fechahoramarca), datepart(mi,fechahoramarca), datepart(ss,fechahoramarca)
	</cfquery>
	<!---============ PROCESAR BLOQUE DE DATOS ===============---->		
	<!---Obtener los grupos de marcas---->
	<cfquery name="rsGrupos" datasource="#session.DSN#">
		select a.grupomarca, min(a.fechahora)
		from #TempMarcas# a
		group by a.grupomarca
		order by 2 asc
	</cfquery>
	<!---Procesar grupos---->
	<cfloop query="rsGrupos">
		<cfset minutostotalesreales = 0>
		<cfset minutosocioreales = 0>
		<cfset minutoslaboradosreales = 0>
		<!---Extremo inicial del grupo---->
		<cfquery name="rsExtremoE" datasource="#session.DSN#">
			select fechahora, jornada, grupomarca
			from #TempMarcas#
			where ltrim(rtrim(tipo)) = 'E'				
				and fechahora = (select min(fechahora)
								from #TempMarcas#
								where IdDatos is null
									and ltrim(rtrim(tipo)) = 'E'
									and grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrupos.grupomarca#">
								)
		</cfquery>
		<cfif rsExtremoE.RecordCount NEQ 0>
			<!------Extremo final del grupo---->
			<cfquery name="rsExtremoF" datasource="#session.DSN#">
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
		<!---Si hay extremos ---->
		<cfif rsExtremoE.RecordCount NEQ 0 and rsExtremoF.RecordCount NEQ 0>
			<!---Obtener datos de la jornada y el horario para el dia de la semana correspondiente a la fecha del extremo inicial--->
			<cfset rsDatosJornada = funDatosJornada(rsExtremoE.jornada,rsExtremoE.fechahora,vnEmpleado)>	
			<cfif rsDatosJornada.RecordCount NEQ 0><!---Si la Jornada definida existe--->						
				<!----======= La jornada registra o no marca =======--->
				<cfif rsDatosJornada.RHJmarcar EQ 0><!---NO registra marcas --->
					<cfquery datasource="#session.DSN#"><!---Poner -1 en el iddatos--->
						update #TempMarcas#
						set IdDatos = -1
						where grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExtremoE.grupomarca#">
					</cfquery>
					<cfquery datasource="#session.DSN#"><!---Poner en -1 el lote de marcas --->
						update RHControlMarcas 
							set numlote = -1
						from RHControlMarcas
							inner join #TempMarcas# b
								on RHControlMarcas.RHCMid = b.IdMarca
								and b.grupomarca = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExtremoE.grupomarca#">
					</cfquery>	
				<cfelse><!-----SI registra marcas---->
					<!---Calcular los minutos ocio (marcas tipo EB/SB) ---->				
					<cfset minutosocioreales = funOcioEstimado(rsExtremoE.fechahora,rsExtremoF.fechahora,rsInfoEmpleado)>
					<!-----Calcular tiempo laborado real en minutos ---->
					<cfif len(trim(rsDatosJornada.RHJrebajaocio)) and rsDatosJornada.RHJrebajaocio EQ 1><!---Si la jornada rebaja tiempo de ocio--->
						<cfset minutoslaboradosreales = minutostotalesreales - minutosocioreales>
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
						<cfset vnIdentity = funInsertaDatosMarcas(minutostotalesreales,minutosocioreales,minutoslaboradosreales,vnEmpleado,rsExtremoE.fechahora,rsExtremoE.grupomarca,rsDatosJornada)>
					<cfelse><!---Por semana--->
						<cfquery name="rsVerifica" datasource="#session.DSN#"><!---Verificar si ya existe el dato--->
							select IdDatos from #TempDatos#
							where jornada = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExtremoE.jornada#">
								<!---and IdDatos is null--->	
						</cfquery>
						<cfif rsVerifica.RecordCount EQ 0 or len(trim(rsVerifica.IdDatos)) EQ 0><!---Si no existe insertar el registro--->						
							<cfset vnIdentity = funInsertaDatosMarcas(minutostotalesreales,minutosocioreales,minutoslaboradosreales,vnEmpleado,rsExtremoE.fechahora,rsExtremoE.grupomarca,rsDatosJornada)>
						<cfelse><!---Si existe actualizarlo--->						
							<cfset vnIdentity = funActualizaDatos(minutostotalesreales,minutosocioreales,minutoslaboradosreales,rsVerifica.IdDatos,rsExtremoE.grupomarca,rsExtremoE.fechahora,rsDatosJornada)>
						</cfif>
					</cfif><!---Fin de si verifica marca por dia o semana---->
				</cfif><!---Fin de si registra o no marcas la jornada--->
			</cfif><!---Fin de si existe la jornada--->				
		</cfif><!---Fin de si hay extremos--->
	</cfloop><!---Fin del loop de MARCAS--->		
	<!----================= PROCESAR LOS DATOS DE LA TEMPORAL #TempDatos# =====================---->
	<cfquery name="rsTempDatos" datasource="#session.DSN#"><!---Marcas sin jornada establecida--->
		select 	IdDatos,DEid,f_desde,f_hasta,jornada,
				coalesce(minlaboradosestimados,0) as minlaboradosestimados,
				coalesce(minocioestimados,0) as minocioestimados,
				coalesce(mintotalesreales,0) as mintotalesreales,
				coalesce(minsocioreales,0) as minsocioreales,
				coalesce(minlaboradosreales,0) as minlaboradosreales,
				horasrebajar,
				horasnormales,
				horasextraa,horasextrab,montoferiado,incidenciarebajo,incidenciajornada,
				incidenciaextraa,incidenciaextrab,incidenciaferiado
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
			<!----======= Tiene Jornada definida ========---->
			<cfif len(trim(rsTempDatos.jornada))>
				<cfquery name="rsDJornada" datasource="#session.DSN#">
					select 	RHJid, RHJornadahora, coalesce(RHJfraccionesExtras,1) as RHJfraccionesExtras, 
							coalesce(RHJminutosExtras,1) as RHJminutosExtras,
							coalesce(coalesce(RHJhorasJornada,0)*60,0) as RHJhorasJornada, 
							coalesce(coalesce(RHJhorasExtraA,0)*60,0) as RHJhorasExtraA, 
							coalesce(coalesce(RHJhorasExtraB,0)*60,0) as RHJhorasExtraB
					from RHJornadas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
					<cfif minutoslaboradosreales GT rsDJornada.RHJhorasExtraA>
						<cfset vn_minextraB = minutoslaboradosreales - rsDJornada.RHJhorasExtraA>
						<cfset vn_minextraA = rsDJornada.RHJhorasExtraA - rsTempDatos.minlaboradosestimados>
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

					<cfset vn_parteentera = 0>
					<cfset vn_parteentera = Fix(vn_minextraA/Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras))>
					<cfset vn_horasextraA = vn_parteentera/(60/Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras))>

					<cfset vn_parteentera = 0>
					<cfset vn_parteentera = Fix(vn_minextraB/Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras))>
					<cfset vn_horasextraB = vn_parteentera/(60/Iif(rsDJornada.RHJfraccionesExtras EQ 0, 1, rsDJornada.RHJfraccionesExtras))>

					
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
					<cfquery name="InsertaAcumulado" datasource="#session.DSN#">			
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
															CAMestado, BMUsucodigo, BMfecha)
						values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTempDatos.jornada#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsTempDatos.f_desde#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
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
								'P', 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">						
								)		
						<cf_dbidentity1 datasource="#session.DSN#">		
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="InsertaAcumulado">
					<!---Actualizar la tabla de marcas para indicar a cual lote pertenece--->
					<cfquery name="ActualizaMarcas" datasource="#session.dsn#">
						update RHControlMarcas
							set numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#InsertaAcumulado.Identity#">	
						from #TempMarcas# a
							inner join RHControlMarcas b
								on a.IdMarca = b.RHCMid
						where a.IdDatos = #rsTempDatos.IdDatos#
					</cfquery>
				<cfelse><!---Si no existe la jornada--->
					<cf_throw message="#MSG_NoSeEncuentroLaJornada#" errorcode="4065">
				</cfif><!---Fin de si existe la jornada---->			
			<cfelse><!----========== NO tiene jornada ===========---->
				<cfquery name="InsertaAcumulado" datasource="#session.DSN#">			
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
														CAMestado, BMUsucodigo, BMfecha)							
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnEmpleado#"> as DEid,
							jornada as RHJid,
							f_desde as CAMfdesde,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo,
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
							'P', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as BMUsucodigo, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">as BMfecha				
					from #TempDatos#
					where jornada is null	
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="InsertaAcumulado">			
				<!---Actualizar la tabla de marcas para indicar a cual lote pertenece--->
				<cfquery name="ActualizaMarcas" datasource="#session.dsn#">
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
</cfloop><!---Fin del Loop de EMPLEADOS---->
<cfoutput>
	<cfset params = ''>
	<cfif isdefined("form.btnFiltrar")>
		<cfset params = params & "&btnFiltrar=1">
	</cfif>
	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		<cfset params = params & "&DEid=" & form.DEid>
	</cfif>
	<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
		<cfset params = params & "&RHJid=" & form.RHJid>
	</cfif>
	<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
		<cfset params = params & "&Grupo=" & form.Grupo>
	</cfif>
	<cfif isdefined("form.ver") and len(trim(form.ver))>
		<cfset params = params & "&ver=" & form.ver>
	</cfif>
	<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
		<cfset params = params & "&fechaInicio=" & form.fechaInicio>
	</cfif>
	<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
		<cfset params = params & "&fechaFinal=" & form.fechaFinal>
	</cfif>
	<script type="text/javascript" language="javascript1.2">	
		window.opener.location.href = "ProcesaMarcas-Lista.cfm?1=1"+'#params#';
		window.close();
	</script>
</cfoutput>
