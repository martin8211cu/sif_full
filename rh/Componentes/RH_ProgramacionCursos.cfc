<cfcomponent>
	<!--- RESULTADO
		  Devuelve na referencia a este componente	
	--->
	<cffunction name="init" access="public">
		<cfreturn this>
	</cffunction>

	<!--- RESULTADO
		  Obtiene y devuelve los datos de un curso
	--->
	<cffunction name="obtenerCurso" access="public" returntype="query">
		<cfargument name="RHCid" 	 type="string" required="yes">
		<cfargument name="DSN" 		 type="string" required="no" default="#session.DSN#">
		<cfargument name="Usucodigo" type="string" required="no" default="#session.Usucodigo#">
		
		<cfquery name="rs_comp_datoscurso" datasource="#arguments.DSN#">
			select RHCid, RHIAid, Mcodigo, RHTCid, RHCcodigo, Ecodigo, RHCfdesde, RHCfhasta, RHCprofesor, RHCcupo, RHCautomat, RHECtotempresa, RHECtotempleado, idmoneda, RHECcobrar, RHCnombre, horaini, horafin, coalesce(duracion, 0) as duracion, lugar, RHCtipo
			from RHCursos
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
		</cfquery>

		<cfreturn rs_comp_datoscurso>
	</cffunction>

	<!--- RESULTADO
		  Obtiene y devuelve los datos de un curso
	--->
	<cffunction name="obtenerProgramacion" access="public" returntype="query">
		<cfargument name="RHCid" type="string" required="yes">
		<cfargument name="fecha" type="string" 	required="no" default="">		
		<cfargument name="DSN" 	 type="string" required="no" default="#session.DSN#">
		
		<cfquery name="rs_comp_datosprogramacion" datasource="#arguments.DSN#">
			select RHDCid, RHCid, RHDCactivo, RHDCfecha, RHDChorainicio, RHDChorafinal, RHDChoras
			from RHDiasCurso
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			  <cfif len(trim(arguments.fecha))>
				  and RHDCfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
			  </cfif>	
			order by RHDChorainicio
		</cfquery>

		<cfreturn rs_comp_datosprogramacion>
	</cffunction>

	<!--- RESULTADO
		  Obtiene y devuelve los datos de la asistencia a un curso para un empleado, dia, curso especifico
	--->
	<cffunction name="obtenerAsistencia" access="public" returntype="query">
		<cfargument name="RHCid" 	type="numeric" 	required="yes">
		<cfargument name="RHDCid" 	type="numeric" 	required="yes">
		<cfargument name="DEid" 	type="numeric" 	required="yes">
		<cfargument name="fecha" 	type="string" 	required="yes">
		<cfargument name="DSN" 	 type="string" required="no" default="#session.DSN#">
		
		<cfquery name="rs_comp_datosasistencia" datasource="#arguments.DSN#">
			select coalesce(RHAChoras, 0) as RHAChoras
			from RHAsistenciaCurso
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			  and RHDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDCid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and RHACdia = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
		</cfquery>

		<cfreturn rs_comp_datosasistencia>
	</cffunction>

	<!--- RESULTADO
		  Elimina la programacion hecha para un curso. Lo hace de forma masiva, o se le 
		  puede indicar el registro por borrar.
	--->
	<cffunction name="eliminarProgramacion" access="public" >
		<cfargument name="RHCid" 	 type="numeric" required="yes">
		<cfargument name="RHDCid" 	 type="string" required="no" default="">
		<cfargument name="DSN" 		 type="string" required="no" default="#session.DSN#">
		<cfargument name="Usucodigo" type="string" required="no" default="#session.Usucodigo#">
		
		<cfquery  datasource="#arguments.DSN#">
			delete from RHAsistenciaCurso
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			<cfif len(trim(arguments.RHDCid)) >
				and RHDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDCid#">
			</cfif>
		</cfquery>
		<cfquery  datasource="#arguments.DSN#">
			delete from RHDiasCurso
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			<cfif len(trim(arguments.RHDCid)) >
				and RHDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDCid#">
			</cfif>
		</cfquery>
	</cffunction>

	<!--- RESULTADO
		  Elimina la asistencia de forma masiva.
	--->
	<cffunction name="eliminarAsistencia" access="public" >
		<cfargument name="RHCid" type="numeric" required="yes">
		<cfargument name="fecha" type="string"  required="no">
		<cfargument name="DSN" 	 type="string"  required="no" default="#session.DSN#">

		<cfquery  datasource="#arguments.DSN#">
			delete from RHAsistenciaCurso
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			<cfif len(trim(arguments.fecha))>
				and RHACdia = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
			</cfif>
		</cfquery>
	</cffunction>
	
	<!--- RESULTADO
		  Inserta un registro en la tabla RHDiasCurso.
	--->
	<cffunction name="insertarDiaCurso" access="public" returntype="numeric"  >
		<cfargument name="RHCid" 	 		type="string" 	required="yes">
		<cfargument name="RHCDfecha" 		type="string" 	required="yes">
		<cfargument name="RHCDfechainicio" 	type="date" 	required="yes">
		<cfargument name="RHCDfechafinal" 	type="date" 	required="yes">
		<cfargument name="RHCDhoras" 		type="numeric" 	required="yes">
		<cfargument name="DSN" 		 		type="string" required="no" default="#session.DSN#">
		<cfargument name="Usucodigo" 		type="string" required="no" default="#session.Usucodigo#">

		<cfquery name="rs_comp_insert"  datasource="#arguments.DSN#">
			insert into RHDiasCurso(RHCid, RHDCfecha, RHDChorainicio, RHDChorafinal, RHDChoras, BMUsucodigo, BMfecha)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.RHCid#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#LSParseDateTime(arguments.RHCDfecha)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.RHCDfechainicio#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.RHCDfechafinal#">,
					<cfqueryparam cfsqltype="cf_sql_float" 		value="#arguments.RHCDhoras#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#now()#"> )
			<cf_dbidentity1 verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rs_comp_insert" verificar_transaccion="false">
		<cfreturn rs_comp_insert.identity>
	</cffunction>

	<!--- RESULTADO
		  Inserta un registro en la tabla RHDiasCurso.
	--->
	<cffunction name="insertarAsistencia" access="public">
		<cfargument name="RHCid"	 type="numeric" required="yes">
		<cfargument name="RHDCid" 	 type="numeric" required="yes">
		<cfargument name="DEid" 	 type="numeric" required="yes">
		<cfargument name="fecha"	 type="string" 	required="yes">
		<cfargument name="horas"	 type="numeric"	required="yes">
		<cfargument name="DSN" 		 type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Usucodigo" type="string" 	required="no" default="#session.Usucodigo#">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select count(1) as cantidad
			from RHAsistenciaCurso
			where DEid=#arguments.DEid#
			and RHCid=#arguments.RHCid#
			and (select sum(RHAChoras)+#arguments.horas#
			from RHAsistenciaCurso
			where DEid=#arguments.DEid#
			and RHCid=#arguments.RHCid#)> (select duracion from RHCursos where RHCid=#arguments.RHCid#)
		</cfquery>
		
		<cfif rsValida.cantidad gt 0>
			<cfquery name="rsDEid" datasource="#session.dsn#">
				select DEnombre,DEapellido1,DEapellido2 from DatosEmpleado where DEid=#arguments.DEid#
			</cfquery>
			<cfthrow message="Se intenta registrar un número mayor de horas autorizadas en la programación del curso para el colaborador:#rsDEid.DEnombre# #rsDEid.DEapellido1# #rsDEid.DEapellido2#">
		<cfelse>
			<cfquery datasource="#arguments.DSN#">
				insert into RHAsistenciaCurso(RHDCid, RHCid, DEid, RHACdia, RHAChoras, BMUsucodigo, BMfecha)
				values( <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.RHDCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.RHCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#LSParseDateTime(arguments.fecha)#">,
						<cfqueryparam cfsqltype="cf_sql_float" 		value="#arguments.horas#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#now()#"> )
			</cfquery>
			</cfif>
	</cffunction>

	<!--- RESULTADO
		  Genera un registro en RHDiasCurso para cada uno de los dias comprendidos entre la fecha de inicio y finalizacion de un curso 
	--->
	<cffunction name="programarCurso" access="public">
		<cfargument name="RHCid" 		type="string" required="yes">
		<cfargument name="DSN" 		 	type="string" required="no" default="#session.DSN#">
		<cfargument name="Usucodigo" 	type="string" required="no" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" 		type="string" required="no" default="#session.Ecodigo#">

		<!--- 1. recupera la informacion del curso --->
		<cfset rs_datoscurso = this.obtenerCurso(arguments.RHCid, arguments.DSN, arguments.Usucodigo) >
		
		<!--- 2. recupera fechas del curso --->
		<cfset fecha_inicio   = rs_datoscurso.RHCfdesde >
		<cfset fecha_final 	  = rs_datoscurso.RHCfhasta >
		<cfset duracion_por_dia = rs_datoscurso.duracion/IIf(datediff('d', fecha_inicio, fecha_final) gt 0, datediff('d', fecha_inicio, fecha_final), 1)  >
		<cfset hora_inicio   = rs_datoscurso.horaini >
		<cfset hora_final 	  = rs_datoscurso.horafin >
		<cfset fecha_iterador = fecha_inicio >	<!--- controlar la iteracion--->
		
		<!--- 3. elimina los datos existentes de forma masiva--->
		<cfset this.eliminarProgramacion(arguments.RHCid, '', arguments.DSN, arguments.Usucodigo) >
		
		<!--- 4. genera un registro en RHDiasCurso para cada uno de los dias comprendidos entre la fecha de inicio y finalizacion del curso --->
		<cfloop condition="DateCompare(fecha_iterador, fecha_final) lte 0 ">
			<cfset fecha_ins_inicio = CreateDateTime(year(fecha_iterador), month(fecha_iterador), day(fecha_iterador), hour(hora_inicio), minute(hora_inicio), second(hora_inicio) ) >
			<cfset fecha_ins_final = CreateDateTime(year(fecha_iterador), month(fecha_iterador), day(fecha_iterador), hour(hora_final), minute(hora_final), second(hora_final) ) >
			<cfset this.insertarDiaCurso(arguments.RHCid, LSDateFormat(fecha_ins_inicio,'dd/mm/yyyy'), fecha_ins_inicio, fecha_ins_final, duracion_por_dia, arguments.DSN, arguments.usucodigo ) >
			<cfset fecha_iterador = dateadd('d', 1, fecha_iterador) >
		</cfloop> 
		
		<!--- 5. inserta las personas matriculadas en el curso para cada dia del mismo 
			  Esto no deberia ir aqui, por si se matriculan mas personas en el curso.
			  ESTA AQUI POR PRUEBAS
		--->
		<cfset this.insertarPersonasPorDia(arguments.RHCid, '', arguments.DSN, arguments.Usucodigo, arguments.Ecodigo )>
	</cffunction>

	<!--- RESULTADO
		  Recupera los empleados matriculados en un curso. Devuelve la lista de empleados para todos los 
		  dias del curso puede hacerlo para una fecha especifica.
	--->
	<cffunction name="obtenerPersonasPorDia" access="public" returntype="query">
		<cfargument name="RHCid" 		type="string" required="yes">
		<cfargument name="fecha" 		type="string" required="no" default="">
		<cfargument name="DSN" 		 	type="string" required="no" default="#session.DSN#">
		<cfargument name="Usucodigo" 	type="string" required="no" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" 		type="string" required="no" default="#session.Ecodigo#">
		
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="valP"/>
		<cfquery name="data_comp_personas" datasource="#arguments.DSN#">
			select dc.RHDCid, dc.RHCid,dc.RHDChoras,de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, ec.DEid, dc.RHDCfecha, dc.RHDChorainicio, dc.RHDChorafinal, 0, #arguments.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			from RHEmpleadoCurso ec 
			
			inner join RHCursos c
			on c.RHCid=ec.RHCid
			
			inner join LineaTiempo lt 
			on lt.DEid=ec.DEid 
			and c.RHCfdesde between lt.LTdesde and lt.LThasta 
			
			inner join RHDiasCurso dc
			on dc.RHCid=c.RHCid
			and dc.RHDCactivo=1
			<cfif len(trim(arguments.fecha))>
				and dc.RHDCfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
			</cfif>
			
			inner join DatosEmpleado de
			on de.DEid=ec.DEid
			
			where ec.RHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			and ec.RHEMestado in (0, 10, 20, 30)
			and ec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			
			order by  de.DEapellido1, de.DEapellido2, de.DEnombre
		</cfquery>
		<cfreturn data_comp_personas >
	</cffunction>
<!--- 
<cfif valP gt 0>
				and ec.RHECestado = 50
			</cfif>
 --->
	<!--- RESULTADO
		  Modifica la cantidad de horas que una persona asistio a un curso.
	--->
	<cffunction name="modificarPersonasPorDia" access="public">
		<cfargument name="RHACid" 		type="numeric" required="yes">
		<cfargument name="horas" 		type="numeric" required="yes">
		<cfargument name="DSN" 		 	type="string" required="no" default="#session.DSN#">

		<cfquery datasource="#arguments.DSN#">
			update RHAsistenciaCurso
			set RHDChoras <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.horas#">
			where RHACid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHACid#">
		</cfquery>
	</cffunction>

	<!--- RESULTADO
		  Modifica el total de horas que estan programadas para un curso.
		  Se basa en la tabla RHDiasCurso, especificamente en los dias habilitados
		  para el curso y las horas propuestas para cada dia 
	--->
	<cffunction name="modificarDuracionCurso" access="public">
		<cfargument name="RHCid" 		type="numeric" required="yes">
		<cfargument name="DSN" 		 	type="string" required="no" default="#session.DSN#">

		<cfquery datasource="#arguments.DSN#">
			update RHCursos
			set duracion = ( select sum(coalesce(RHDChoras,0)) from RHDiasCurso a where a.RHCid = RHCursos.RHCid and RHDCactivo = 1 )
			where RHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
		</cfquery>
	</cffunction>

	<!--- RESULTADO
		  Modifica las horas y duracion para un dia de la programacion del curso
	--->
	<cffunction name="modificarFechas" access="public">
		<cfargument name="RHDCid" 			type="numeric" required="yes">
		<cfargument name="RHDCfechainicio" 	type="date" 	required="yes">
		<cfargument name="RHDCfechafinal" 	type="date" 	required="yes">
		<cfargument name="RHDChoras" 		type="numeric" 	required="yes">
		<cfargument name="DSN" 		 		type="string" required="no" default="#session.DSN#">

		<cfquery datasource="#arguments.DSN#">
			update RHDiasCurso
			set RHDCfechainicio = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.RHCDfechainicio#">,
				RHDCfechafinal = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.RHCDfechafinal#">,
				RHDChoras = <cfqueryparam cfsqltype="cf_sql_float" 	value="#arguments.RHCDhoras#">
			where RHDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
		</cfquery>
	</cffunction>

	<!--- RESULTADO
		  Modifica las horas y duracion para un dia de la programacion del curso
	--->
	<cffunction name="modificarEstadoDia" access="public">
		<cfargument name="RHDCid" 			type="numeric" required="yes">
		<cfargument name="estado" 			type="numeric" required="yes"> <!--- 0:inactivado, 1:activado--->
		<cfargument name="DSN" 		 		type="string" required="no" default="#session.DSN#">

		<cfquery datasource="#arguments.DSN#">
			update RHDiasCurso
			set RHDCactivo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.estado#">
			where RHDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDCid#">
		</cfquery>
	</cffunction>

	<!--- RESULTADO
		  Pasa hora en formato normal a hora militar.
	--->
	<cffunction name="obtenerHoraMilitar" access="public" returntype="string">
		<cfargument name="hora"		type="numeric" 	required="yes">		
		<cfargument name="meridiano" 		type="string" 	required="yes" > <!--- AM, PM--->
		
		<cfset hora_tmp = arguments.hora >

		<cfif arguments.meridiano eq 'PM' and arguments.hora neq 12>
			<cfset hora_tmp = arguments.hora + 12 >
		<cfelseif arguments.meridiano eq 'AM' and arguments.hora eq 12>
			<cfset hora_tmp = 0 >
		</cfif>
		<cfreturn hora_tmp >
	</cffunction>

	<!--- RESULTADO
		  Crea un objeto date de coldfusion, para un conjunto de valores dados.
	--->
	<cffunction name="obtenerFechaMilitar" access="public" returntype="date">
		<cfargument name="fecha" 		type="string" 	required="yes">
		<cfargument name="hora"			type="numeric" 	required="yes">
		<cfargument name="minutos"		type="numeric" 	required="yes">				
		<cfargument name="meridiano" 	type="string" 	required="yes" > <!--- AM, PM--->
		
		<cfset objeto_fecha = LSParseDateTime(arguments.fecha) >
		<cfset hora_militar = this.obtenerHoraMilitar(arguments.hora, arguments.meridiano) >
		<cfreturn createdatetime(year(objeto_fecha), month(objeto_fecha), day(objeto_fecha), hora_militar, arguments.minutos, 0 ) >
	</cffunction>

	<!--- RESULTADO
		  Crea un struct con la conversion de fecha militar a fecha normal(am,pm)
	--->
	<cffunction name="obtenerFechaMeridiano" access="public" returntype="struct">
		<cfargument name="fecha" type="date" 	required="yes">
		<cfset hora = structnew() >
		<cfset hora.hora = 0 > 
		<cfset hora.meridiano = 'AM' > 
		<cfset objeto_fecha = arguments.fecha >
		<cfset hora.minutos = minute(objeto_fecha) > 		

		<cfif hour(objeto_fecha) lte 11>
			<cfif hour(objeto_fecha) eq 0>
				<cfset hora.hora = 12 >
			<cfelse>
				<cfset hora.hora = hour(objeto_fecha) >
			</cfif>
		<cfelse>
			<cfif hour(objeto_fecha) eq 12>
				<cfset hora.hora = 12 >
			<cfelse>
				<cfset hora.hora = hour(objeto_fecha)-12 >
			</cfif>	
			<cfset hora.meridiano = 'PM' > 
		</cfif>
		<cfreturn hora>
	</cffunction>

	<!--- RESULTADO
		  Valida que la fecha este en el rango de fechas en que se impartira el curso.
	--->
	<cffunction name="validarFecha" access="public" returntype="boolean">
		<cfargument name="RHCid" type="numeric" required="yes">
		<cfargument name="fecha" type="date" required="yes">
		<cfargument name="DSN" 	 type="string"  required="no" default="#session.DSN#">
		
		<cfquery  name="rs_comp_fechas" datasource="#arguments.DSN#">
			select 1
			from RHCursos c
			where c.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			  and exists( select 1 from RHDiasCurso where RHCid=c.RHCid and RHDCactivo=1 and RHDCfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#"> )
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#"> between c.RHCfdesde and c.RHCfhasta
		</cfquery>
		<cfif rs_comp_fechas.recordcount gt 0>
			<cfreturn true >
		</cfif>
		<cfreturn false >
		
	</cffunction>

	<!--- RESULTADO
		  Obtiene la primer fecha de registro de asistencia, la cual no tiene registrada
		  asistencia
	--->
	<cffunction name="obtenerFechaSiguiente" access="public" returntype="string">
		<cfargument name="RHCid" type="numeric" required="yes">
		<cfargument name="DSN" 	 type="string"  required="no" default="#session.DSN#">
		
		<!--- busca la primer fecha que no tiene asistencia registrada --->	
		<cfquery  name="rs_comp_fechas" datasource="#arguments.DSN#">
			select min(RHDCfecha) as RHDCfecha
			from RHDiasCurso dc
			where dc.RHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			  and dc.RHDCactivo = 1
			and ( select sum(RHAChoras) from RHAsistenciaCurso where RHDCid=dc.RHDCid) is null 
		</cfquery>
		<cfif len(trim(rs_comp_fechas.RHDCfecha))>
			<cfset resultado = lsdateformat(rs_comp_fechas.RHDCfecha, 'dd/mm/yyyy') >
			<cfreturn resultado >
		</cfif>
		<!--- busca la primer fecha que tiene asistencia en cero --->			
		<cfquery  name="rs_comp_fechas" datasource="#arguments.DSN#">
			select min(RHDCfecha) as RHDCfecha
			from RHDiasCurso dc
			where dc.RHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			  and dc.RHDCactivo = 1
			and ( select sum(RHAChoras) from RHAsistenciaCurso where RHDCid=dc.RHDCid) = 0
		</cfquery>
		<cfif len(trim(rs_comp_fechas.RHDCfecha))>
			<cfset resultado = lsdateformat(rs_comp_fechas.RHDCfecha, 'dd/mm/yyyy') >
			<cfreturn resultado >
		</cfif>
		<!--- busca la primer fecha de registro --->
		<cfquery  name="rs_comp_fechas" datasource="#arguments.DSN#">
			select min(RHDCfecha) as RHDCfecha
			from RHDiasCurso dc
			where dc.RHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
			  and dc.RHDCactivo = 1
		</cfquery>
		<cfif len(trim(rs_comp_fechas.RHDCfecha))>
			<cfset resultado = lsdateformat(rs_comp_fechas.RHDCfecha, 'dd/mm/yyyy') >
			<cfreturn resultado >
		</cfif>
		
		<cfreturn '' >		
	</cffunction>

	<!--- RESULTADO
		  Se utiliza en el proceso de generacion de los dias de un curso. Guarda los datos de la 
		  tabla de asistencia, esto porque, las tablas de dias por curso y de asistencia, son borradas 
		  para ser regeneradas de nuevo. La idea es guardar los posibles datos registrados en la tabla 
		  de asistencia y volverlos a insertar, para no perderlos. Se usa como referencia el curso 
		  y la fecha para hacer el join.
	--->
	<cffunction name="guardarDatosAsistencia" access="public" returntype="string">
		<cfargument name="RHCid" type="numeric" required="yes">
		<cfargument name="DSN" 	 type="string"  required="no" default="#session.DSN#">

		<cf_dbtemp name="asistencia" returnvariable="asistencia">
			<cf_dbtempcol name="RHCid" type="numeric"> 
			<cf_dbtempcol name="DEid" type="numeric">
			<cf_dbtempcol name="RHACdia" type="datetime"> 
			<cf_dbtempcol name="RHAChoras" type="float">
		</cf_dbtemp>
		
		<cfquery datasource="#arguments.DSN#">
			insert into #asistencia#(RHCid, DEid, RHACdia, RHAChoras)
			select RHCid, DEid, RHACdia, RHAChoras
			from RHAsistenciaCurso
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
		</cfquery>
		
		<cfreturn asistencia >
	</cffunction>

	<!--- RESULTADO
		  Se utiliza en el proceso de generacion de los dias de un curso. Inserta en la 
		  tabla de asistencia despues de regenerar los dias del curso, esto porque, 
		  las tablas de dias por curso y de asistencia, pueden ser borradas para ser regeneradas. 
		  La idea es guardar los posibles datos registrados en la tabla de asistencia y volverlos 
		  a insertar, para no perderlos. Se usa como referencia el curso y la fecha para hacer el join.
	--->
	<cffunction name="recuperarDatosAsistencia" access="public">
		<cfargument name="RHCid" 		type="numeric" 	required="yes">
		<cfargument name="asistencia" 	type="string" 	required="yes">
		<cfargument name="Usucodigo"	type="string"  	required="no" default="#session.usucodigo#">
		<cfargument name="DSN" 	 		type="string"  	required="no" default="#session.DSN#">

		<cfquery datasource="#arguments.DSN#">
			insert into RHAsistenciaCurso( RHDCid, RHCid, DEid, RHACdia, RHAChoras, BMUsucodigo, BMfecha )
			select a.RHDCid, a.RHCid, b.DEid, b.RHACdia, b.RHAChoras, #arguments.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			from RHDiasCurso a
			
			inner join #arguments.asistencia# b
			on b.RHACdia=a.RHDCfecha
			and b.RHCid=a.RHCid
			and b.DEid in ( select DEid from RHEmpleadoCurso where RHCid=a.RHCid)
			
			where a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#">
		</cfquery>
		
	</cffunction>
</cfcomponent>