<cfinvoke component="rh.Componentes.RH_ProgramacionCursos" method="init" returnvariable="curso">
<cfif isdefined("form.programar") or isdefined("form.eliminar")>
	<cfif form.contador gt 0 >
		<cftransaction>
		<cfset tabla_temporal = curso.guardarDatosAsistencia(form.RHCid, session.DSN) >
		<cfset curso.eliminarProgramacion(form.RHCid, '', session.DSN, session.Usucodigo) >
		<cfloop from="1" to="#contador#" index="i">
			<cfset fecha = form['fecha_#i#'] >
			<cfset ins_fecha_inicio = curso.obtenerFechaMilitar(fecha, form['horaini_#i#'], form['minutosini_#i#'], form['meridianoini_#i#'] ) >			
			<cfset ins_fecha_final = curso.obtenerFechaMilitar(fecha, form['horafin_#i#'], form['minutosfin_#i#'], form['meridianofin_#i#'] ) >
			<cfif form['horas_#i#'] lte 0 or len(trim(form['horas_#i#'])) eq 0 >
				<cfset duracion_dia = abs(datediff('n', ins_fecha_final, ins_fecha_inicio)) >
				<cfset duracion_dia =  duracion_dia/60 >
			<cfelse>
				<cfset duracion_dia = form['horas_#i#'] >
			</cfif>

			<cfset id = curso.insertarDiaCurso(form.RHCid, fecha, ins_fecha_inicio, ins_fecha_final, duracion_dia, session.DSN, session.Usucodigo) >

			<cfif isdefined("eliminar_#i#")>
				<cfset curso.modificarEstadoDia(id, 0, session.DSN) >
			</cfif>
		</cfloop>
	
		<cfset curso.recuperarDatosAsistencia( form.RHCid, tabla_temporal, session.Usucodigo, session.DSN) >
		<cfset curso.modificarDuracionCurso(form.RHCid, session.DSN) >
		</cftransaction>
	</cfif>
</cfif>
<cflocation url="programar.cfm?RHCid=#form.RHCid#">