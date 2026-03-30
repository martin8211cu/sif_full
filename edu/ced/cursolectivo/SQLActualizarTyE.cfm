<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.InsTyE") and Len(Trim(Form.InsTyE)) NEQ 0>
			<cfquery name="deleteCurso" datasource="#Session.Edu.DSN#">
				set nocount on
				delete CursoPrograma
				from Curso a
				where CursoPrograma.Ccodigo = a.Ccodigo
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.InsTyE#">

				delete EvaluacionCurso
				from Curso a
				where EvaluacionCurso.Ccodigo = a.Ccodigo
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.InsTyE#">
				
				delete EvaluacionConceptoCurso
				from Curso a
				where EvaluacionConceptoCurso.Ccodigo = a.Ccodigo
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.InsTyE#">
				set nocount off
			</cfquery>
			<!--- Generar Conceptos de Evaluación --->
			<cfquery name="generarConceptosEval" datasource="#Session.Edu.DSN#">
				set nocount on
				insert into EvaluacionConceptoCurso(ECcodigo, Ccodigo, PEcodigo, ECCporcentaje)
				select e.ECcodigo, c.Ccodigo, p.PEcodigo, e.EPCporcentaje
				from Curso c, Materia m, PeriodoEvaluacion p, EvaluacionPlanConcepto e
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.InsTyE#">
				and c.Mconsecutivo = m.Mconsecutivo
				and (m.Melectiva = 'R' or m.Melectiva = 'S')
				and m.Ncodigo = p.Ncodigo
				and m.EPcodigo = e.EPcodigo
				and not exists(
				select 1
				from EvaluacionConceptoCurso
				where ECcodigo = e.ECcodigo
				and Ccodigo = c.Ccodigo
				and PEcodigo = p.PEcodigo
				)
				set nocount off
			</cfquery>
			<!--- Generar Evaluaciones --->
			<cfquery name="rsEvaluaciones" datasource="#Session.Edu.DSN#">
				set nocount on
				insert EvaluacionCurso(EVTcodigo, ECcodigo, Ccodigo, PEcodigo, ECporcentaje, ECnombre, ECduracion, ECorden, ECevaluado, ECplaneada, EMcomponente)
				select em.EVTcodigo, em.ECcodigo, c.Ccodigo, em.PEcodigo, em.EMporcentaje as ECporcentaje, em.EMnombre as ECnombre, 1.0 as ECduracion, em.EMorden as ECorden, 'N' as ECevaluado, po.POfechainicio, em.EMcomponente
				from Curso c, Materia m, EvaluacionMateria em, PeriodoOcurrencia po
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.InsTyE#">
				and c.Mconsecutivo = m.Mconsecutivo
				and (m.Melectiva = 'R' or m.Melectiva = 'S')
				and m.Mconsecutivo = em.Mconsecutivo
				and c.PEcodigo = po.PEcodigo
				and c.SPEcodigo = po.SPEcodigo
				and em.PEcodigo = po.PEevaluacion
				set nocount off
			</cfquery>
			<!--- Generar Temarios que duran menos de 1 lección --->
			<cfquery name="rsTemarios1" datasource="#Session.Edu.DSN#">
				set nocount on
				insert CursoPrograma(Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPcubierto, CPorden, MPcodigo, CPduracion, CPfecha)
				select c.Ccodigo, mp.PEcodigo, mp.MPnombre as CPnombre, mp.MPdescripcion as CPdescripcion, 'N' as CPcubierto, mp.MPorden as CPorden, mp.MPcodigo, mp.MPduracion, po.POfechainicio as CPfecha
				from Curso c, Materia m, MateriaPrograma mp, PeriodoOcurrencia po
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.InsTyE#">
				and c.Mconsecutivo = m.Mconsecutivo
				and (m.Melectiva = 'R' or m.Melectiva = 'S')
				and m.Mconsecutivo = mp.Mconsecutivo
				and c.PEcodigo = po.PEcodigo
				and c.SPEcodigo = po.SPEcodigo
				and mp.PEcodigo = po.PEevaluacion
				and mp.MPduracion <= 1.0
				set nocount off
			</cfquery>
			<!--- Generar Temarios que duran mas de 1 lección --->
			<cfquery name="rsTemarios2" datasource="#Session.Edu.DSN#">
				set nocount on
				select convert(varchar, c.Ccodigo) as Ccodigo, 
					   convert(varchar, mp.PEcodigo) as PEcodigo, 
					   mp.MPnombre as CPnombre, 
					   mp.MPdescripcion as CPdescripcion, 
					   'N' as CPcubierto, 
					   mp.MPorden as CPorden, 
					   convert(varchar, mp.MPcodigo) as MPcodigo, 
					   mp.MPduracion as CPduracion, 
					   po.POfechainicio as CPfecha
				from Curso c, Materia m, MateriaPrograma mp, PeriodoOcurrencia po
				where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.InsTyE#">
				and c.Mconsecutivo = m.Mconsecutivo
				and (m.Melectiva = 'R' or m.Melectiva = 'S')
				and m.Mconsecutivo = mp.Mconsecutivo
				and c.PEcodigo = po.PEcodigo
				and c.SPEcodigo = po.SPEcodigo
				and mp.PEcodigo = po.PEevaluacion
				and mp.MPduracion > 1.0
				set nocount off
			</cfquery>
			<cfloop query="rsTemarios2">
				<cfset duracion = CPduracion>
				<cfloop condition="duracion GT 0">
					<cfquery name="rsInsertarTemario" datasource="#Session.Edu.DSN#">
						set nocount on
						insert CursoPrograma(Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPcubierto, CPorden, MPcodigo, CPduracion, CPfecha)
						values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.Ccodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.PEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTemarios2.CPnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTemarios2.CPdescripcion#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsTemarios2.CPcubierto#">,
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsTemarios2.CPorden#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.MPcodigo#">,
							<cfif duracion GT 1>1.0<cfelse>#duracion# * 1.0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsTemarios2.CPfecha#">
						)
						set nocount off
					</cfquery>
					<cfset duracion = duracion - 1>
				</cfloop>
			</cfloop>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Cursos.cfm" method="post" name="sql">
	<input name="cbcursolectivo" type="hidden" value="<cfif isdefined("Form.cbcursolectivo")><cfoutput>#Form.cbcursolectivo#</cfoutput></cfif>">
	<input name="rcursotipo" type="hidden" value="<cfif isdefined("Form.rcursotipo")><cfoutput>#Form.rcursotipo#</cfoutput></cfif>">
	<input name="Gcodigo" type="hidden" value="<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>">
	<input name="btnCursos" type="hidden" value="">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
