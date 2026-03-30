<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CursoDeCapacitacion"
	Default="Curso de Capacitación"
	returnvariable="LB_CursoDeCapacitacion"/>
	
<!--- FIN VARIABLES DE TRADUCCION --->
<cfset filtro = "filtro_RHIAid=#URLEncodedFormat(form.filtro_RHIAid)
		#&filtro_RHGMid=#URLEncodedFormat(form.filtro_RHGMid)
		#&filtro_RHACid=#URLEncodedFormat(form.filtro_RHACid)
		#&filtro_Mnombre=#URLEncodedFormat(form.filtro_Mnombre)
		#&filtro_RHCfdesde=#URLEncodedFormat(form.filtro_RHCfdesde)
		#&filtro_RHCfhasta=#URLEncodedFormat(form.filtro_RHCfhasta)
		#&filtro_RHCcupo=#URLEncodedFormat(form.filtro_RHCcupo)
		#&filtro_disponible=#URLEncodedFormat(form.filtro_disponible)#">
<cfif IsDefined("form.Cambio") or  IsDefined("form.Alta")>
	<!--- Proceso para crear la hora --->
	<cfset HORAI 	= FORM.HORAINI>
	<cfset MINUTOI 	= FORM.MINUTOSINI>
	<cfif FORM.PMAMINI eq 'PM' and compare(HORAI,'12') neq 0>
		<cfset HORAI = HORAI + 12 >
	<cfelseif FORM.PMAMINI eq 'AM' and compare(HORAI,'12') eq 0 >
		<cfset HORAI = 0 >
	</cfif>
	
	<cfset HORAF 	= FORM.HORAFIN>
	<cfset MINUTOF 	= FORM.MINUTOSFIN>
	<cfif FORM.PMAMFIN eq 'PM' and compare(HORAF,'12') neq 0>
		<cfset HORAF = HORAF + 12 >
	<cfelseif FORM.PMAMFIN eq 'AM' and compare(HORAF,'12') eq 0 >
		<cfset HORAF = 0 >
	</cfif>

	<CFSET HORADEINICIO  = CreateDateTime(YEAR(Now()),MONTH(YEAR(Now())),MONTH(DAY(Now())), HORAI,MINUTOI,0)>
	<CFSET HORADEFIN     = CreateDateTime(YEAR(Now()),MONTH(YEAR(Now())),MONTH(DAY(Now())), HORAF,MINUTOF,0)>

	<cfif isdefined("form.cambio")>
		<!--- Proceso para crear la hora --->
		<cfset _HORAI 	= FORM._HORAINI>
		<cfset _MINUTOI	= FORM._MINUTOSINI>
		<cfif FORM._PMAMINI eq 'PM' and compare(_HORAI,'12') neq 0>
			<cfset _HORAI = _HORAI + 12 >
		<cfelseif FORM._PMAMINI eq 'AM' and compare(_HORAI,'12') eq 0 >
			<cfset _HORAI = 0 >
		</cfif>
		
		<cfset _HORAF 	= FORM._HORAFIN>
		<cfset _MINUTOF 	= FORM._MINUTOSFIN>
		<cfif FORM._PMAMFIN eq 'PM' and compare(_HORAF,'12') neq 0>
			<cfset _HORAF = _HORAF + 12 >
		<cfelseif FORM._PMAMFIN eq 'AM' and compare(_HORAF,'12') eq 0 >
			<cfset _HORAF = 0 >
		</cfif>
	
		<CFSET _HORADEINICIO  = CreateDateTime(YEAR(Now()),MONTH(YEAR(Now())),MONTH(DAY(Now())), _HORAI,_MINUTOI,0)>
		<CFSET _HORADEFIN     = CreateDateTime(YEAR(Now()),MONTH(YEAR(Now())),MONTH(DAY(Now())), _HORAF,_MINUTOF,0)>

	</cfif>

</cfif>
<cfif isdefined('form.Alta')>
	<!--- BUSCA LOS EMPLEADOS DONDE EL PUESTO TENGA ASOCIADA COMPETENCIAS QUE A SU VES TENGAN ASOCIADA LA
		MATERIA QUE SE ESTA ASOCIANDO AL CURSO PROGRAMADO Y SE ENVIA EL CORREO AVISANDO QUE SE HABRIO UN CURSO
		ADEMAS SE CONSIDERA QUE EL EMPLEADO TENGA UN DOMINIO DE LA COMPENTENCIA MENOR AL 100%--->
	<cfquery name="rsCorreos" datasource="#session.DSN#">
		select distinct de.DEid
		from DatosEmpleado de
		inner join LineaTiempo lt
			on lt.DEid = de.DEid
			and getdate() between lt.LTdesde and lt.LThasta
		inner join RHPlazas p
			on p.RHPid = lt.RHPid
			and p.RHPpuesto in (select  b.RHPcodigo
							from RHConocimientosMaterias a
							inner join RHConocimientosPuesto b
								on b.RHCid = a.RHCid
							inner join RHPuestos c
								on c.RHPcodigo  = b.RHPcodigo
								and c.Ecodigo = b.Ecodigo
							where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">)
		inner join RHCompetenciasEmpleado ce
			on ce.DEid = de.DEid
			and ce.tipo = 'C'
			and RHCEdominio < 100
			and ce.RHCEfdesde = (select max(B.RHCEfdesde) 
								from RHCompetenciasEmpleado B 
								where B.DEid    =  ce.DEid
								  and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and   B.Ecodigo = ce.Ecodigo 
								  and   B.tipo = 'C' 
								  and   B.idcompetencia = ce.idcompetencia )
		where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		
		union
		
		select distinct de.DEid
		from DatosEmpleado de
		inner join LineaTiempo lt
			on lt.DEid = de.DEid
			and getdate() between lt.LTdesde and lt.LThasta
		inner join RHPlazas p
			on p.RHPid = lt.RHPid
			and p.RHPpuesto in (select  b.RHPcodigo
							from RHHabilidadesMaterias a
							inner join RHConocimientosPuesto b
								on b.RHCid = a.RHHid
							inner join RHPuestos c
								on c.RHPcodigo  = b.RHPcodigo
								and c.Ecodigo = b.Ecodigo
							where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">)
		inner join RHCompetenciasEmpleado ce
			on ce.DEid = de.DEid
			and ce.tipo = 'H'
			and RHCEdominio < 100
			and ce.RHCEfdesde = (select max(B.RHCEfdesde) 
								from RHCompetenciasEmpleado B 
								where B.DEid    =  ce.DEid
								  and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and   B.Ecodigo = ce.Ecodigo 
								  and   B.tipo = 'H'
								  and   B.idcompetencia = ce.idcompetencia )
		where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfif rsCorreos.REcordCount>
		<cfset Lvar_ListaEmpleados = ValueList(rsCorreos.DEid)>
	<cfelse>
		<cfset Lvar_ListaEmpleados = -1>
	</cfif>
</cfif>
<cfif IsDefined("form.Cambio")>
	
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHCursos"
			redirect="metadata.code.cfm"
			timestamp="#form.ts_rversion#"
			field1="RHCid"
			type1="numeric"
			value1="#form.RHCid#"
		>
	
	<cftransaction>
	<cfquery datasource="#session.dsn#">
		update RHCursos
		set RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#" null="#Len(form.RHIAid) Is 0#">
		, Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">
		, RHTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTCid#" null="#Len(form.RHTCid) Is 0#">
		
		, RHCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCcodigo#" null="#Len(form.RHCcodigo) Is 0#">
		, RHCnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCnombre#" null="#Len(form.RHCnombre) Is 0#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, RHCfdesde = <cfif Len(form.RHCfdesde)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfdesde)#"><cfelse>null</cfif>
		
		, RHCfhasta = <cfif Len(form.RHCfhasta)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfhasta)#"><cfelse>null</cfif>
		, RHCprofesor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCprofesor#" null="#Len(form.RHCprofesor) Is 0#">
		, RHCcupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(form.RHCcupo,',','','all')#" null="#Len(form.RHCcupo) Is 0#">
		, RHCautomat = <cfif isdefined("form.RHCautomat")><cfqueryparam cfsqltype="cf_sql_integer" value="#IsDefined('form.RHCautomat')#" ><cfelse>0</cfif>
		, RHECtotempresa = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHECtotempresa,',','','all')#" null="#Len(form.RHECtotempresa) Is 0#">
		, RHECtotempleado = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHECtotempleado,',','','all')#" null="#Len(form.RHECtotempleado) Is 0#">
		, idmoneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idmoneda#" null="#Len(form.idmoneda) Is 0#">
		, RHECcobrar = <cfif isdefined("form.RHECcobrar")><cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHECcobrar')#"><cfelse>0</cfif>
		,horaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEINICIO#">
		,horafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEFIN#">
		,duracion = <cfqueryparam cfsqltype="cf_sql_float" value="#form.DURACION#">
		,lugar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.LUGAR#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		, RHCdisponible=<cfif isdefined ('form.chkDisponibles') and len(trim(form.chkDisponibles)) gt 0>1<cfelse>0</cfif>
		, RHCexterno =	<cfif isdefined("form.RHCexterno")>1<cfelse>0</cfif>
		, RHCtipo =	<cfif isdefined("form.RHCtipo")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCtipo#"><cfelse>'P'</cfif>		
		, RHIid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" null="#Len(form.RHIid) Is 0#">
		,RHTSid=<cfif isdefined("form.RHTSid") and len(trim(form.RHTSid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTSid#"><cfelse>null</cfif>
		,RHCdirigido=<cfif isdefined('form.txtDir') and len(trim(form.txtDir)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtDir#"><cfelse>null</cfif>
		where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#Len(form.RHCid) Is 0#">
	</cfquery>
	
	<cfquery name="fecha_minima" datasource="#session.DSN#">
		select min(RHDCfecha) as minima
		from RHDiasCurso
		where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	</cfquery>
	<cfquery name="fecha_maxima" datasource="#session.DSN#">
		select max(RHDCfecha) as maxima
		from RHDiasCurso
		where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	</cfquery>
	
	<!--- fechas de programacion --->
	<cfif len(trim(fecha_minima.minima)) and len(trim(fecha_maxima.maxima)) >
		<!--- fechas de pantalla --->
		<cfset fecha_desde = LSparseDateTime(RHCfdesde) >
		<cfset fecha_hasta = LSparseDateTime(RHCfhasta) >
		<!--- fechas de programacion (RHDiasCurso) --->
		<cfset curso_minima = createdate(year(fecha_minima.minima), month(fecha_minima.minima), day(fecha_minima.minima)) >
		<cfset curso_maxima = createdate(year(fecha_maxima.maxima), month(fecha_maxima.maxima), day(fecha_maxima.maxima)) >
		
		<!--- Fecha de inicio --->
		<cfif datecompare(curso_minima, fecha_desde) eq -1>
			<cfset fecha_desde = dateadd('d', -1, fecha_desde) >
			<!--- eliminar fechas desde curso_minima+1(dia) hasta fecha desde--->
			<cfquery datasource="#session.DSN#">
				delete from RHAsistenciaCurso
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
				and RHACdia <= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_desde#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from RHDiasCurso
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
				and RHDCfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_desde#">
			</cfquery>
		<cfelseif datecompare(curso_minima, fecha_desde) eq 1 >
			<!--- agregar fechas desde fecha_desde hasta de curso_minima-1(dia) --->
			<cfset curso_minima = dateadd('d', -1, curso_minima) >
			<cfset iterador = fecha_desde >

			<!---- 	**** hacer para el otro extremo.
			---->
			<cfloop condition="datecompare(iterador, curso_minima) lte 0"  >
				<cfquery datasource="#session.DSN#">
					insert into RHDiasCurso(RHCid, RHDCfecha, RHDChorainicio, RHDChorafinal, RHDChoras, BMUsucodigo, BMfecha)
					values( <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHCid#">,
							<cfqueryparam cfsqltype="cf_sql_date" 		value="#iterador#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#horadeinicio#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#horadefin#">,
							<cfqueryparam cfsqltype="cf_sql_float" 		value="#abs(datediff('n', horadeinicio, horadefin)/60)#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" 		value="#now()#"> )
				</cfquery>
				<cfset iterador = dateadd('d', 1, iterador) >
			</cfloop>
		</cfif>

		<!--- Fecha de fin --->
		<cfif datecompare(curso_maxima, fecha_hasta) eq -1>
			<!--- agregar fechas desde curso_maxima+1(dia) hasta fecha_hasta  --->
			<cfset curso_maxima = dateadd('d', 1, curso_maxima) >
			<cfset iterador = curso_maxima >
			<cfloop condition="datecompare(iterador, fecha_hasta) lte 0"  >
				<cfquery datasource="#session.DSN#">
					insert into RHDiasCurso(RHCid, RHDCfecha, RHDChorainicio, RHDChorafinal, RHDChoras, BMUsucodigo, BMfecha)
					values( <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHCid#">,
							<cfqueryparam cfsqltype="cf_sql_date" 		value="#iterador#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#horadeinicio#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#horadefin#">,
							<cfqueryparam cfsqltype="cf_sql_float" 		value="#abs(datediff('n', horadeinicio, horadefin)/60)#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" 		value="#now()#"> )
				</cfquery>
				<cfset iterador = dateadd('d', 1, iterador) >
			</cfloop>
		<cfelseif datecompare(curso_maxima, fecha_hasta) eq 1 >
			<cfset fecha_hasta = dateadd('d', 1, fecha_hasta) >
			<!--- eliminar fechas desde fecha_hasta+1(dia) hasta curso_maxima--->
			<cfquery datasource="#session.DSN#">
				delete from RHAsistenciaCurso
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
				and RHACdia >= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_hasta#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from RHDiasCurso
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
				and RHDCfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_hasta#">
			</cfquery>
		</cfif>
		
		<!---*** FALTA  ***--->
		<!--- 1. actualizar duracion del curso desde aqui--->
		<!--- 2. actualizar horas si se cambian --->
		
		<!--- Si las horas cambian se actualiza en la programacion --->
		<cfset reajustar_horas = false >
		<cfif datecompare(HORADEINICIO, _HORADEINICIO) neq 0 >
			<cfset reajustar_horas = true >
			<cfquery datasource="#session.DSN#">
				update RHDiasCurso
				set RHDChorainicio = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEINICIO#">
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>
		</cfif>
		<cfif datecompare(HORADEFIN, _HORADEFIN) neq 0 >
			<cfset reajustar_horas = true >
			<cfquery datasource="#session.DSN#">
				update RHDiasCurso
				set RHDChorafinal = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEFIN#">
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>
		</cfif>
		
		<cfif reajustar_horas >
			<cfset horas = abs(datediff('n', HORADEFIN, HORADEINICIO ))/60 >
			<cfquery datasource="#session.DSN#">
				update RHDiasCurso
				set RHDChoras = <cfqueryparam cfsqltype="cf_sql_float" value="#horas#">
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>

			<cfquery datasource="#session.DSN#">
				update RHCursos
				set duracion = ( select sum(RHDChoras) from RHDiasCurso where RHCid = RHCursos.RHCid )
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>
		</cfif>
	</cfif>
	</cftransaction>	
	
	<cflocation url="index.cfm?RHCid=#URLEncodedFormat(form.RHCid)#&#filtro#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete RHDiasCurso
		where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#Len(form.RHCid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete RHCursos
		where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#Len(form.RHCid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cftransaction>
		<cfquery name="vali" datasource="#session.dsn#">
			select count(1) as cantidad from RHOfertaAcademica where RHIAid=#form.RHIAid#
							and Mcodigo=#form.Mcodigo#
		</cfquery>
		
		<cfif vali.cantidad eq 0>
			<cfquery datasource="#session.dsn#">
				insert into RHOfertaAcademica (RHIAid, Mcodigo, RHOAactivar, Ecodigo, BMfecha, BMUsucodigo)
					values (
						#form.RHIAid#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
						1, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		</cfif>
	<cfquery datasource="#session.dsn#" name="insrt">
		insert into RHCursos (RHIAid,Mcodigo,RHTCid,RHCcodigo,RHCnombre,Ecodigo,RHCfdesde,RHCfhasta,RHCprofesor,RHCcupo,
								RHCautomat,RHECtotempresa,RHECtotempleado,idmoneda,RHECcobrar,horaini,horafin,duracion,lugar,BMfecha,BMUsucodigo,
								RHCexterno, RHCtipo,RHIid,RHTSid,RHCdisponible,RHCdirigido)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#" null="#Len(form.RHIAid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTCid#" null="#Len(form.RHTCid) Is 0#">,			
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCcodigo#" null="#Len(form.RHCcodigo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCnombre#" null="#Len(form.RHCnombre) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfif Len(form.RHCfdesde)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfdesde)#"><cfelse>null</cfif>,			
				<cfif Len(form.RHCfhasta)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfhasta)#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCprofesor#" null="#Len(form.RHCprofesor) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(form.RHCcupo,',','','all')#" >,
				<cfif isdefined("form.RHCautomat")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCautomat#"><cfelse>0</cfif>,<!---null="#Len(form.RHCautomat) Is 0#"--->
				<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHECtotempresa,',','','all')#" null="#Len(form.RHECtotempresa) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHECtotempleado,',','','all')#" null="#Len(form.RHECtotempleado) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idmoneda#" null="#Len(form.idmoneda) Is 0#">,
				<cfif isdefined("form.RHECcobrar")><cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHECcobrar')#"><cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEINICIO#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#HORADEFIN#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.DURACION#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.LUGAR#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfif isdefined("form.RHCexterno")>1<cfelse>0</cfif>,
				<cfif isdefined("form.RHCtipo")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCtipo#"><cfelse>'P'</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" null="#Len(form.RHIid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTSid#">,
				<cfif isdefined ('form.chkDisponibles') and len(trim(form.chkDisponibles)) gt 0>
				1
				<cfelse>
				0
				</cfif>
				<cfif isdefined('form.txtDir') and len(trim(form.txtDir)) gt 0>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtDir#"><cfelse>,null</cfif>)
	<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="insrt">
	<!--- SI CAMBIO LA MATERIA DEL CURSO ENTONCES SE ENVIAN LOS CORREOS --->
	<cfquery name="DatosCurso" datasource="#session.DSN#">
		select RHCcodigo as codigo, RHCnombre as nombre, RHCfdesde as inicio, RHCfhasta as fin ,horaini ,horafin,duracion ,lugar,
		 <cf_dbfunction name="datediff" args="#now()# , RHCfdesde" datasource="#session.DSN#"> as difFechas
		from RHCursos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insrt.identity#">
	</cfquery>
	<cfquery name="DatosEmpl" datasource="#session.DSN#">
		select DEemail,
			   DEsexo,
			   {fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )}  as empleado
		from DatosEmpleado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DEid in (#Lvar_ListaEmpleados#)
	</cfquery>
	<!--- ENVIO DE CORREO DE AVISO DE PROGRAMACIÓN DEL CURSO --->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2117" default="" returnvariable="UsaFiltro"/>
	<cfif UsaFiltro eq 0>
	
		<cfset FromEmail = "capacitacion@soin.co.cr">
		<cfquery name="CuentaPortal"   datasource="#session.dsn#">
			Select valor
			from  <cf_dbdatabase table="PGlobal" datasource="asp">
			Where parametro='correo.cuenta'
		</cfquery>
		<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
			<cfset FromEmail = CuentaPortal.valor>
		</cfif>
			
		<cfloop query="DatosEmpl">
		<cfsavecontent variable="email_body">
			<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
			<html>
			<head>
			<title>Desarrollo Humano: Programación de Curso</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			<style type="text/css">
			<!--
			.style1 {
				font-size: 10px;
				font-family: "Times New Roman", Times, serif;
			}
			.style2 {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-weight: bold;
				font-size: 14;
			}
			.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
			.style8 {font-size: 14}
			-->
			</style>
			</head>
			
			<body>
			
				<cfoutput>
					<table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
						<tr bgcolor="##999999"><td colspan="2" height="8"></td></tr>
						<tr bgcolor="##003399"><td colspan="2" height="24"></td></tr>
						<tr bgcolor="##999999">
							<td colspan="2"><strong>Desarrollo Humanos: Programación de Curso </strong> </td>
						</tr>
						<tr><td width="70">&nbsp;</td><td width="476">&nbsp;</td></tr>
						<tr>
							<td><span class="style2"><cf_translate key="LB_De">De</cf_translate></span></td>
							<td><span class="style7"> #Session.Enombre# </span></td>
						</tr>
						<tr>
							<td><span class="style7"><strong>
							<cf_translate key="LB_Para">Para</cf_translate>
							</strong></span></td>
							<td>
								<span class="style7">
								<cfif #DatosEmpl.DEsexo# eq 'M'>
									Sr
								<cfelse>
									(a)/ Srta
								</cfif>
								: #DatosEmpl.empleado# 
								</span>
							</td>
						</tr>
						<tr><td></td><td></td></tr>
						<tr>
							<td>&nbsp;</td>
							<td><span class="style7">Informaci&oacute;n sobre curso de capacitaci&oacute;n.</span></td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<cfif not IsDefined("Request.MailArguments.Transition")>
							<tr><td><span class="style8"></span></td>
								<td><span class="style7"> </span></td>
							</tr>
						<cfelse>
							<tr>
								<td><span class="style8"></span></td>
								<td><span class="style7">#Request.MailArguments.info#</span></td>
							</tr>
						</cfif>
						<tr>
							<td><span class="style8"></span></td>
							<td><span class="style8">
								<cfif #DatosEmpl.DEsexo# eq 'M'>
									Sr
								<cfelse>
									(a)/ Srta
								</cfif>
								: #DatosEmpl.empleado# <br>
								Se ha programado el curso #DatosCurso.codigo#-#DatosCurso.nombre#,<br>
								el cual tiene una duración total de  #DatosCurso.duracion# horas<br>
								y se estará llevando acabo del día <cf_locale name="date" value="#DatosCurso.inicio#"/>  hasta el día <cf_locale name="date" value="#DatosCurso.fin#"/> <br>
								con un horario de #LSTimeFormat(DatosCurso.horaini, "hh:mm:tt")# a #LSTimeFormat(DatosCurso.horafin, "hh:mm:tt")#  <br>
								en el lugar de capacitación : #DatosCurso.lugar#<br><br>
								Si desea matricular el curso lo puede hacer en la opción Automatr&iacute;cula de Cursos
								en Autoautogesti&oacute;n.
								<br><br>	
							</span></td>
						</tr>
					</table>
				</cfoutput>
			</body>
			</html>
		</cfsavecontent>
		<cfset email_subject = LB_CursoDeCapacitacion>
		<cfset email_to = DatosEmpl.DEemail>
		<cfset Email_remitente = FromEmail>
		
		<cfif email_to NEQ ''>				
			<cfquery datasource="#session.dsn#">										insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#Email_remitente#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
			</cfquery>
		</cfif>	
	</cfloop>
	</cfif>
	</cftransaction>
	<cflocation url="index.cfm?RHCid=#URLEncodedFormat(insrt.identity)#&#filtro#">

<cfelseif isdefined("form.Programar")>
	<!---<cfinvoke component="rh.Componentes.RH_ProgramacionCursos" method="init" returnvariable="curso">--->
	<!--- elimina los datos y los vuelve a regenerar --->
	<!---
	<cfset curso.eliminarProgramacion(form.RHCid, '', session.DSN, session.Usucodigo) >
	<cfset curso.programarCurso(form.RHCid, session.DSN, session.Usucodigo, session.Ecodigo) >
	--->

	<cflocation url="programar.cfm?RHCid=#form.RHCid#">
<cfelseif isdefined("form.Participantes")>

	<cflocation url="participantes.cfm?RHCid=#form.RHCid#">
	
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="index.cfm?#filtro#">
