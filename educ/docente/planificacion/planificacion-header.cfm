<!--- Obtener los cursos que está impartiendo el Docente --->
<cfquery name="rsCursosDocente" datasource="#Session.DSN#">
	select a.Ecodigo, a.PLcodigo, a.PEcodigo, a.Mcodigo, a.Csecuencia, a.Ccodigo, a.Cnombre, 
		   a.Scodigo, a.TRcodigo, a.PEVcodigo, a.CtipoCalificacion, a.CpuntosMax, a.CunidadMin, 
		   a.Credondeo, a.TEcodigo, a.Cestado, a.CsolicitudMaxima, a.Csolicitados, a.CmatriculaMaxima, 
		   a.Cmatriculados, a.DOpersona, 
		   b.CILcodigo, b.PLnombre, b.PLcorto, b.PLinicio, b.PLfinal,
		   l.CILtipoCicloDuracion,
		   m.MtipoCicloDuracion
	from Curso a, Materia m, CicloLectivo l, PeriodoLectivo b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.DOpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#u.llave#">
	and a.Cestado = 1
	and a.Mcodigo = m.Mcodigo
	and m.CILcodigo = l.CILcodigo
	and a.PLcodigo = b.PLcodigo
	and a.Ecodigo = b.Ecodigo
	order by b.PLinicio, a.Csecuencia, a.Cnombre
</cfquery>

<cfif rsCursosDocente.recordCount EQ 0>
	<cfparam name="form.Ccodigo" default="-1">
<cfelse>
	<cfparam name="form.Ccodigo" default="#rsCursosDocente.Ccodigo#">
</cfif>

<cfquery name="rsCurso" dbtype="query">
	select *
	from rsCursosDocente
	where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
</cfquery>

<cfset tipoPeriodicidad = 0>
<!--- Si el curso se imparte en un periodo de evaluacion --->
<cfif rsCurso.CILtipoCicloDuracion EQ "E">
	<!--- Curso normal de universidad --->
	<cfif rsCurso.MtipoCicloDuracion EQ "E">
		<!--- Periodo en que está matriculado el curso --->
		<cfquery name="rsPeriodos" datasource="#Session.DSN#">
			select a.PEcodigo, b.PLnombre + ': ' + a.PEnombre as PEnombre
			from PeriodoEvaluacion a, PeriodoLectivo b
			where a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCurso.PEcodigo#">
			and a.PLcodigo = b.PLcodigo
			order by b.PLinicio, a.PEinicio
		</cfquery>
		<cfset tipoPeriodicidad = 1>
		
	<!--- Curso tipo 'Generales' --->
	<cfelseif rsCurso.MtipoCicloDuracion EQ "L">
		<!--- Pendiente de hacer --->
		<cfset tipoPeriodicidad = 2>
	</cfif>

	<cfif rsPeriodos.recordCount EQ 0>
		<cfparam name="Form.PEcodigo" default="-1">
	<cfelse>
		<cfparam name="Form.PEcodigo" default="#rsPeriodos.PEcodigo#">
	</cfif>
<!--- Si el curso se imparte durante todo un periodo lectivo --->
<cfelseif rsCurso.CILtipoCicloDuracion EQ "L">
	<!--- Pendiente de hacer --->
	<cfset tipoPeriodicidad = 3>
</cfif>
<cfparam name="Form.PEcodigo" default="-1">

<!--- <cfquery name="rsConceptos" datasource="#Session.DSN#">
	select a.CEcodigo, b.CEnombre, a.CCEporcentaje
	from CursoConceptoEvaluacion a, ConceptoEvaluacion b
	where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
	and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
	and a.CEcodigo = b.CEcodigo
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by a.CCEorden
</cfquery> 

<cfif rsConceptos.recordCount EQ 0>
	<cfparam name="Form.CEcodigo" default="-1">
<cfelse>
	<cfparam name="Form.CEcodigo" default="#rsConceptos.CEcodigo#">
</cfif>



<cfquery name="rsConcepto" dbtype="query">
	select *
	from rsConceptos
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
</cfquery>
--->	
<cfif form.Ccodigo EQ -1>
  <div align="center">
  	<strong>El profesor no tiene cursos asignados</strong>
  </div>
  <cfexit>
</cfif>
<cfoutput>
	<form name="fCursos" method="post">
		<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border-top: 1px solid gray; border-bottom: 1px solid gray; ">
		  <tr>
			<td class="etiqueta" align="right" nowrap>Curso: </td>
			<td nowrap>
				<select name="Ccodigo" onChange="javascript: this.form.submit();">
					<cfloop query="rsCursosDocente">
						<option value="#rsCursosDocente.Ccodigo#"<cfif isdefined("Form.Ccodigo") and Form.Ccodigo EQ rsCursosDocente.Ccodigo> selected</cfif>>#rsCursosDocente.Cnombre#</option>
					</cfloop>
				</select>
			</td>
		  </tr>
		  <tr>
			<td class="etiqueta" align="right" nowrap>Periodo: </td>
			<td nowrap>
				<cfif tipoPeriodicidad EQ 1>
					<!---
					Quitado por Yu Hui 10/06/2004 porque el PEcodigo debe calcularse a partir del Ccodigo (Curso) seleccionado y no estarse reenviando
					<input type="hidden" name="PEcodigo" value="#rsPeriodos.PEcodigo#">
					--->
					#rsPeriodos.PEnombre#
				<cfelse>
					<select name="PEcodigo" onChange="javascript: this.form.submit();">
						<cfloop query="rsPeriodos">
							<option value="#rsPeriodos.PEcodigo#"<cfif isdefined("Form.Ccodigo") and Form.PEcodigo EQ rsPeriodos.PEcodigo> selected</cfif>>#rsPeriodos.PEnombre#</option>
						</cfloop>
					</select>
				</cfif>
			</td>
		  </tr>
		</table>
	</form>
</cfoutput>
	