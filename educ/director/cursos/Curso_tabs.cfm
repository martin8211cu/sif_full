<cfset Lhola = 1>
<cfquery name="rsCurso" datasource="#Session.DSN#">
	select  b.Mcodificacion,
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
			a.Scodigo,
			a.Cestado, 
			(case a.Cestado when 0 then 'Inactivo' when 1 then 'Activo' when 2 then 'Cerrado' else 'Estado Desconocido' end) as Estado,
			a.DOpersona,
			a.Scodigo,
			c.Snombre
	from Curso a, Materia b, Sede c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
	and a.Ecodigo = b.Ecodigo
	and a.Mcodigo = b.Mcodigo
	and a.Scodigo = c.Scodigo
</cfquery>

<cfinclude template="/educ/componentes/pTabs2.cfc">
<cfscript>
	LvarPdatos = "Ccodigo=#form.Ccodigo#";
	if (isdefined("form.CILtipoCicloDuracion"))
	{
		LvarPdatos = LvarPdatos & 
						",CILcodigo=#form.CILcodigo#" &
						",CILtipoCicloDuracion=#form.CILtipoCicloDuracion#" &
						",PLcodigo=#form.PLcodigo#" &
						",EScodigo=#form.EScodigo#" &
						",CARcodigo=#form.CARcodigo#" &
						",GAcodigo=#form.GAcodigo#" &
						",PEScodigo=#form.PEScodigo#" &
						",txtMnombreFiltro=#form.txtMnombreFiltro#" &
						",Scodigo=#form.Scodigo#" &
						",Mcodigo=#form.Mcodigo#";
		if (form.CILtipoCicloDuracion EQ "E")
		{
			LvarPdatos = LvarPdatos & ",PEcodigo=#Form.PEcodigo#";
		}
	}

	fnTabsInclude (		pTabID="TabsCurso",
						pTabs =
		  "|Curso,Curso_form.cfm,Trabajar con los Datos del Curso y su Horario"
		& "|Asistentes,CursoAsistente.cfm,Asignar Asistentes al Curso"
		& "|Parámetros,CursoParametros_form.cfm,Parámetros de Comportamiento del Curso",
						pDatos="#LvarPdatos#",
						pNoTabs=false,
						pWidth="100%" );
</cfscript> 
