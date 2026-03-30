
<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0>
	
	<cfquery name="rsCurso" datasource="#Session.DSN#">
		select b.Mcodificacion,
				b.Mnombre,
				b.Mcreditos,
				b.Mrequisitos,
				a.Csecuencia as Grupo,
				convert(varchar, a.TRcodigo) as TRcodigo,
				a.CtipoCalificacion,
				a.CpuntosMax,
				a.CunidadMin,
				a.Credondeo,
				a.TEcodigo,
				a.CmatriculaMaxima,
				a.Cestado,
				(case a.Cestado when 'I' then 'Inactivo' when 'A' then 'Activo' when 'C' then 'Cerrado' else '' end) as Estado
		from Curso a, Materia b, MateriaCicloLectivo c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
		<cfif Session.CursosMant.CILtipoCicloDuracion EQ "E">
		<!--- Ciclo Lectivo de Universidad --->
		and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CursosMant.PEcodigo#">
		<cfelse>
		<!--- Ciclo Lectivo de Colegio --->
		and a.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CursosMant.PLcodigo#">
		</cfif>
		and a.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CursosMant.Scodigo#">
		and a.Ecodigo = b.Ecodigo
		and a.Mcodigo = b.Mcodigo
		and b.Mcodigo = c.Mcodigo
		<cfif Session.CursosMant.GAcodigo NEQ "-1">
		and b.GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CursosMant.GAcodigo#">
		<cfelse>
		and b.GAcodigo is null
		</cfif>
		and b.EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CursosMant.EScodigo#">
		and c.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CursosMant.CILcodigo#">
	</cfquery>
	
	<cfoutput>
	<table class="areaDatos" width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="##E9E9E9">
	  <tr>
		<td rowspan="2" width="50%" align="center" style="font-variant: small-caps; font-size: medium; font-weight: bold;">#rsCurso.Mcodificacion#&nbsp;#rsCurso.Mnombre#</td>
		<td width="10%" class="fileLabel" align="right" nowrap>Grupo:</td>
		<td width="20%" nowrap>#rsCurso.Grupo#</td>
		<td width="10%" class="fileLabel" align="right" nowrap>Cr&eacute;ditos:</td>
		<td width="10%" nowrap>#rsCurso.Mcreditos#</td>
	  </tr>
	  <tr>
	    <td class="fileLabel" align="right" nowrap>Requisitos:</td>
	    <td nowrap>#rsCurso.Mrequisitos#</td>
		<td class="fileLabel" align="right" nowrap>Estado:</td>
		<td>#rsCurso.Estado#</td>
      </tr>
	</table>
	<cfinclude template="Curso_form.cfm">
	<cfinclude template="CursoHorario.cfm">
	<cfinclude template="CursoDocente.cfm">
	</cfoutput>
	
</cfif>