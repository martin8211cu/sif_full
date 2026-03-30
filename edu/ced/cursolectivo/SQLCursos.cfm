<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.btnGenerar")>
			<cfset cod = ListToArray(Form.cbcursolectivo, "|")>
			<cfif isdefined("Form.rcursotipo") and (Form.rcursotipo EQ 0 or Form.rcursotipo EQ 2)>
				<!--- Generar Cursos --->
				<cfquery name="generarCursos" datasource="#Session.Edu.DSN#">
					set nocount on
					insert into Curso (Cnombre, Mconsecutivo, CEcodigo, SPEcodigo, PEcodigo, GRcodigo, Cgenerado)
					select a.Mnombre+' '+b.GRnombre, a.Mconsecutivo, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">, b.GRcodigo, 1
					from Materia a, Grupo b
					where a.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and a.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
					<cfif Form.rcursotipo EQ 0>
					and a.Melectiva = 'R'
					<cfelseif Form.rcursotipo EQ 2>
					and (a.Melectiva = 'E' or a.Melectiva = 'C')
					</cfif>
					and a.Mactiva = 1
					and a.Ncodigo = b.Ncodigo
					and a.Gcodigo = b.Gcodigo
					and b.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and b.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and Mconsecutivo not in
					(select Mconsecutivo from Curso
					 where PEcodigo = b.PEcodigo
					   and SPEcodigo = b.SPEcodigo
					   and GRcodigo = b.GRcodigo)
					set nocount off
				</cfquery>
				<cfif Form.rcursotipo EQ 0>
				<!--- Generar Conceptos de Evaluación --->
				<cfquery name="generarConceptosEval" datasource="#Session.Edu.DSN#">
					set nocount on
					insert into EvaluacionConceptoCurso(ECcodigo, Ccodigo, PEcodigo, ECCporcentaje)
					select e.ECcodigo, c.Ccodigo, p.PEcodigo, e.EPCporcentaje
					from Curso c, Materia m, PeriodoEvaluacion p, EvaluacionPlanConcepto e
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
					and m.Melectiva = 'R'
					and m.Mactiva = 1
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
					insert EvaluacionCurso(EVTcodigo, ECcodigo, Ccodigo, PEcodigo, ECporcentaje, ECnombre, ECduracion, ECorden, ECevaluado, ECplaneada, EMcomponente, ECleccion)
					select em.EVTcodigo, em.ECcodigo, c.Ccodigo, em.PEcodigo, em.EMporcentaje as ECporcentaje, em.EMnombre as ECnombre, 1.0 as ECduracion, em.EMorden as ECorden, 'N' as ECevaluado, po.POfechainicio, em.EMcomponente, em.EMleccion
					from Curso c, Materia m, EvaluacionMateria em, PeriodoOcurrencia po
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
					and m.Melectiva = 'R'
					and m.Mactiva = 1
					and m.Mconsecutivo = em.Mconsecutivo
					and c.PEcodigo = po.PEcodigo
					and c.SPEcodigo = po.SPEcodigo
					and em.PEcodigo = po.PEevaluacion
					set nocount off
				</cfquery>
				<!--- Generar Temarios que duran menos de 1 lección --->
				<cfquery name="rsTemarios1" datasource="#Session.Edu.DSN#">
					set nocount on
					insert CursoPrograma(Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPcubierto, CPorden, MPcodigo, CPduracion, CPfecha, CPleccion)
					select c.Ccodigo, mp.PEcodigo, mp.MPnombre as CPnombre, mp.MPdescripcion as CPdescripcion, 'N' as CPcubierto, mp.MPorden as CPorden, mp.MPcodigo, mp.MPduracion, po.POfechainicio as CPfecha, mp.MPleccion
					from Curso c, Materia m, MateriaPrograma mp, PeriodoOcurrencia po
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
					and m.Melectiva = 'R'
					and m.Mactiva = 1
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
						   po.POfechainicio as CPfecha,
						   mp.MPleccion
					from Curso c, Materia m, MateriaPrograma mp, PeriodoOcurrencia po
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
					and m.Melectiva = 'R'
					and m.Mactiva = 1
					and m.Mconsecutivo = mp.Mconsecutivo
					and c.PEcodigo = po.PEcodigo
					and c.SPEcodigo = po.SPEcodigo
					and mp.PEcodigo = po.PEevaluacion
					and mp.MPduracion > 1.0
					set nocount off
				</cfquery>
				<cfloop query="rsTemarios2">
					<cfset duracion = CPduracion>
					<cfset leccion = MPleccion>
					<cfloop condition="duracion GT 0">
						<cfquery name="rsInsertarTemario" datasource="#Session.Edu.DSN#">
							set nocount on
							insert CursoPrograma(Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPcubierto, CPorden, MPcodigo, CPduracion, CPfecha, CPleccion)
							values(
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.Ccodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.PEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTemarios2.CPnombre#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTemarios2.CPdescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsTemarios2.CPcubierto#">,
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsTemarios2.CPorden#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.MPcodigo#">,
								<cfif duracion GT 1>1.0<cfelse>#duracion# * 1.0</cfif>,
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsTemarios2.CPfecha#">,
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#leccion#">
							)
							set nocount off
						</cfquery>
						<cfset duracion = duracion - 1>
						<cfset leccion = leccion + 1>
					</cfloop>
				</cfloop>
				</cfif>
				<cfquery name="finishGenerate" datasource="#Session.Edu.DSN#">
					set nocount on
					update Curso
					   set Cgenerado = 0
					from Curso c, Materia m
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
					and (m.Melectiva = 'R' or m.Melectiva = 'E' or m.Melectiva = 'C')
					and m.Mactiva = 1
					set nocount off
				</cfquery>
			<cfelseif isdefined("Form.rcursotipo") and Form.rcursotipo EQ 1>
				<!--- Generar Cursos --->
				<cfloop collection="#Form#" item="i">
					<cfif FindNoCase("sust_",i) GT 0>
						<cfset Mconsecutivo = Mid(i,6, Len(i)-5)>
						<cfset cantidad = StructFind(Form,i)>
						<cfif cantidad NEQ "">
							<cfloop index="a" from="1" to="#cantidad#">
								<cfquery name="generarCursos" datasource="#Session.Edu.DSN#">
									set nocount on
									insert into Curso (Cnombre, Mconsecutivo, CEcodigo, SPEcodigo, PEcodigo, Cgenerado)
									select Mnombre+ ' ' + char(64+<cfqueryparam cfsqltype="cf_sql_integer" value="#a#">), 
										   Mconsecutivo, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">, 1
									from Materia
									where Melectiva = 'S'
									and Mactiva = 1
									and Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mconsecutivo#">
									set nocount off
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				</cfloop>
				<cfif isdefined("masCursos")>
					<cfquery name="generarCursoAdicional" datasource="#Session.Edu.DSN#">
						set nocount on
						insert into Curso (Cnombre, Mconsecutivo, CEcodigo, SPEcodigo, PEcodigo, Cgenerado)
						select Mnombre+ ' ' + char(65+(select count(*) from Curso where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CursoAdicional#"> and SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#"> and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">)), 
							   Mconsecutivo, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">, 1
						from Materia
						where Melectiva = 'S'
						and Mactiva = 1
						and Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CursoAdicional#">
						set nocount off
					</cfquery>
				</cfif>
				<!--- Generar Conceptos de Evaluación --->
				<cfquery name="generarConceptosEval" datasource="#Session.Edu.DSN#">
					set nocount on
					insert into EvaluacionConceptoCurso(ECcodigo, Ccodigo, PEcodigo, ECCporcentaje)
					select e.ECcodigo, c.Ccodigo, p.PEcodigo, e.EPCporcentaje
					from Curso c, Materia m, PeriodoEvaluacion p, EvaluacionPlanConcepto e
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Melectiva = 'S'
					and m.Mactiva = 1
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
					insert EvaluacionCurso(EVTcodigo, ECcodigo, Ccodigo, PEcodigo, ECporcentaje, ECnombre, ECduracion, ECorden, ECevaluado, ECplaneada, EMcomponente, ECleccion)
					select em.EVTcodigo, em.ECcodigo, c.Ccodigo, em.PEcodigo, em.EMporcentaje as ECporcentaje, em.EMnombre as ECnombre, 1.0 as ECduracion, em.EMorden as ECorden, 'N' as ECevaluado, po.POfechainicio, em.EMcomponente, em.EMleccion
					from Curso c, Materia m, EvaluacionMateria em, PeriodoOcurrencia po
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Melectiva = 'S'
					and m.Mactiva = 1
					and m.Mconsecutivo = em.Mconsecutivo
					and c.PEcodigo = po.PEcodigo
					and c.SPEcodigo = po.SPEcodigo
					and em.PEcodigo = po.PEevaluacion
					set nocount off
				</cfquery>
				<!--- Generar Temarios que duran menos de 1 lección --->
				<cfquery name="rsTemarios1" datasource="#Session.Edu.DSN#">
					set nocount on
					insert CursoPrograma(Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPcubierto, CPorden, MPcodigo, CPduracion, CPfecha, CPleccion)
					select c.Ccodigo, mp.PEcodigo, mp.MPnombre as CPnombre, mp.MPdescripcion as CPdescripcion, 'N' as CPcubierto, mp.MPorden as CPorden, mp.MPcodigo, mp.MPduracion, po.POfechainicio, mp.MPleccion
					from Curso c, Materia m, MateriaPrograma mp, PeriodoOcurrencia po
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Melectiva = 'S'
					and m.Mactiva = 1
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
						   po.POfechainicio as CPfecha,
						   mp.MPleccion
					from Curso c, Materia m, MateriaPrograma mp, PeriodoOcurrencia po
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Melectiva = 'S'
					and m.Mactiva = 1
					and m.Mconsecutivo = mp.Mconsecutivo
					and c.PEcodigo = po.PEcodigo
					and c.SPEcodigo = po.SPEcodigo
					and mp.PEcodigo = po.PEevaluacion
					and mp.MPduracion > 1.0
					set nocount off
				</cfquery>
				<cfloop query="rsTemarios2">
					<cfset duracion = CPduracion>
					<cfset leccion = MPleccion>
					<cfloop condition="duracion GT 0">
						<cfquery name="rsInsertarTemario" datasource="#Session.Edu.DSN#">
							set nocount on
							insert CursoPrograma(Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPcubierto, CPorden, MPcodigo, CPduracion, CPfecha, CPleccion)
							values(
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.Ccodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.PEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTemarios2.CPnombre#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTemarios2.CPdescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsTemarios2.CPcubierto#">,
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsTemarios2.CPorden#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemarios2.MPcodigo#">,
								<cfif duracion GT 1>1.0<cfelse>#duracion# * 1.0</cfif>,
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsTemarios2.CPfecha#">,
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#leccion#">
							)
							set nocount off
						</cfquery>
						<cfset duracion = duracion - 1>
						<cfset leccion = leccion + 1>
					</cfloop>
				</cfloop>
				<cfquery name="finishGenerate" datasource="#Session.Edu.DSN#">
					set nocount on
					update Curso
					   set Cgenerado = 0
					from Curso c, Materia m
					where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and c.Cgenerado = 1
					and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[2]#">
					and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[3]#">
					and c.Mconsecutivo = m.Mconsecutivo
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cod[1]#">
					and m.Melectiva = 'S'
					and m.Mactiva = 1
					set nocount off
				</cfquery>
			</cfif>
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
