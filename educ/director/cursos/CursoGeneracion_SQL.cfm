<cfif isdefined("Form.btnGenerar")>
	<!--- Averiguar datos acerca del ciclo lectivo --->
	<cfquery name="rsCicloLectivo" datasource="#Session.DSN#">
		select convert(varchar,a.CILcodigo) as CILcodigo, CILnombre, CILtipoCicloDuracion
		from CicloLectivo a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
	</cfquery>
	
	<cftransaction>
			<!--- Si la generación se va a realizar por periodo de evaluacion --->
			<cfif rsCicloLectivo.CILtipoCicloDuracion EQ "E">

				<cfif isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0>
					<cfset materias = ListToArray(Replace(Form.chk, ' ', '', 'all'), ',')>
					
					<cfloop index="i" from="1" to="#ArrayLen(materias)#">
						<!--- Averiguar la duración del ciclo lectivo de la materia para decidir como se va a realizar la generacion de los periodos de la materia --->
						<cfquery name="rsMateria" datasource="#Session.DSN#">
							select Mnombre,
								   convert(varchar, a.TRcodigo) as TRcodigo, 
								   convert(varchar, a.PEVcodigo) as PEVcodigo, 
								   a.MtipoCalificacion, a.MpuntosMax, a.MunidadMin, a.Mredondeo, 
								   convert(varchar, a.TEcodigo) as TEcodigo, 
								   a.MtipoCicloDuracion,
								   b.TRcantidadAmpliacion
							from Materia a, TablaResultado b
							where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">
							and a.TRcodigo *= b.TRcodigo
						</cfquery>
						
						<!--- Curso normal de universidad --->
						<cfif rsMateria.MtipoCicloDuracion EQ "E">
							<!--- Averiguar si ya hay cursos generados para obtener la última secuencia de grupo --->
							<cfquery name="rsSecuencias" datasource="#Session.DSN#">
								select isnull(max(a.Csecuencia), 0) + 1 as Secuencia
								from Curso a
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">
								and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
							</cfquery>
							<!--- Generar el Curso --->
							<cfloop index="j" from="#rsSecuencias.Secuencia#" to="#rsSecuencias.Secuencia+Evaluate('Form.Cant_#materias[i]#')-1#">
								<cfquery name="rsGeneracion" datasource="#Session.DSN#">
									declare @Ccodigo numeric
								
									insert Curso (Ecodigo, PLcodigo, PEcodigo, Mcodigo, Csecuencia, Cnombre, Scodigo, 
												  TRcodigo, PEVcodigo, CtipoCalificacion, CpuntosMax, CunidadMin, Credondeo, TEcodigo, 
												  Cestado, CsolicitudMaxima, Csolicitados, CmatriculaMaxima, Cmatriculados)
									values(
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#j#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMateria.Mnombre#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">,
										<cfif Len(Trim(rsMateria.TRcodigo))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.TRcodigo#">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.PEVcodigo))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.PEVcodigo#">,
										<cfelse>
											null,
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_char" value="#rsMateria.MtipoCalificacion#">,
										<cfif Len(Trim(rsMateria.MpuntosMax))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.MpuntosMax#" scale="2">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.MunidadMin))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.MunidadMin#" scale="2">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.Mredondeo))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mredondeo#" scale="3">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.TEcodigo))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.TEcodigo#">,
										<cfelse>
											null,
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_tinyint" value="0">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#Evaluate('Form.Cupo_#materias[i]#')#">,
										0,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#Evaluate('Form.Cupo_#materias[i]#')#">,
										0
									)
									
									select @Ccodigo = @@identity
									
									insert CursoPeriodo (PEcodigo, Ccodigo, CPEestado)
									values(
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">,
										@Ccodigo,
										0
									)
									
									<cfif Len(Trim(rsMateria.PEVcodigo)) NEQ 0>
										insert CursoConceptoEvaluacion (Ccodigo, PEcodigo, CEcodigo, CCEporcentaje, CCEorden)
										select @Ccodigo, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">, b.CEcodigo, b.PECporcentaje, b.PECorden
										from PlanEvaluacion a, PlanEvaluacionConcepto b
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
										and a.PEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.PEVcodigo#">
										and a.PEVcodigo = b.PEVcodigo
									</cfif>
									
									<cfif Len(Trim(rsMateria.TRcodigo)) NEQ 0>
										<cfloop index="k" from="1" to="#rsMateria.TRcantidadAmpliacion#">
											insert into CursoAmpliacion (Ccodigo, CAMsecuencia, CAMtipoCalificacion, CAMpuntosMax, CAMunidadMin, CAMredondeo, TEcodigo)
											select Ccodigo, #k#, CtipoCalificacion, CpuntosMax, CunidadMin, Credondeo, TEcodigo
											  from Curso
											 where Ccodigo = @Ccodigo
										</cfloop>
									</cfif>
									
								</cfquery>
							</cfloop><!--- Loop Grupos --->
							
						<!--- Curso tipo 'Generales' --->
						<cfelseif rsMateria.MtipoCicloDuracion EQ "L">
							<!--- Buscar la configuración de la materia para todos los periodos de evaluacion del periodo lectivo asociado al periodo de evaluacion que llega por Form --->
							<cfquery name="rsMateriaPeriodo" datasource="#Session.DSN#">
								select a.MCEsecuencia, a.CIEcodigo, a.PEVcodigo, 
									   a.MCEhorasSemana, a.MCEleccionesSemana, a.MCEhorasLeccion,
									   convert(varchar, b.PLcodigo) as PLcodigo,
									   c.Mnombre,
									   convert(varchar, b.PEcodigo) as PEcodigo
								from PeriodoEvaluacion z, PeriodoEvaluacion b, MateriaCicloEvaluacion a, Materia c
								where z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								and z.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
								and b.PLcodigo = z.PLcodigo
								and a.CIEcodigo = b.CIEcodigo
								and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">
								and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
								and a.Mcodigo = c.Mcodigo
								and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								order by a.MCEsecuencia
							</cfquery>

							<!--- Averiguar si ya hay cursos generados para obtener la última secuencia de grupo --->
							<cfquery name="rsSecuencias" datasource="#Session.DSN#">
								select isnull(max(a.Csecuencia), 0) + 1 as Secuencia
								from Curso a, CursoPeriodo b
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">
								and a.Ccodigo = b.Ccodigo
								and b.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateriaPeriodo.PEcodigo#">
							</cfquery>

							<!--- Generar el Curso --->
							<cfloop index="j" from="#rsSecuencias.Secuencia#" to="#rsSecuencias.Secuencia+Evaluate('Form.Cant_#materias[i]#')-1#">
								<cfquery name="rsGeneracion1" datasource="#Session.DSN#">
									insert Curso (Ecodigo, PLcodigo, PEcodigo, Mcodigo, Csecuencia, Cnombre, Scodigo, TRcodigo, CtipoCalificacion, CpuntosMax, CunidadMin, Credondeo, TEcodigo, Cestado, CsolicitudMaxima, Csolicitados, CmatriculaMaxima, Cmatriculados)
									values(
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateriaPeriodo.PLcodigo#">,
										null,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#j#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMateriaPeriodo.Mnombre#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">,
										<cfif rsMateria.TRcodigo NEQ "">
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.TRcodigo#">,
										<cfelse>
											null,
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_char" value="#rsMateria.MtipoCalificacion#">,
										<cfif Len(Trim(rsMateria.MpuntosMax))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.MpuntosMax#" scale="2">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.MunidadMin))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.MunidadMin#" scale="2">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.Mredondeo))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mredondeo#" scale="3">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.TEcodigo))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.TEcodigo#">,
										<cfelse>
											null,
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_tinyint" value="0">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#Evaluate('Form.Cupo_#materias[i]#')#">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#Evaluate('Form.Cupo_#materias[i]#')#">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="0">
									)
									
									select convert(varchar, @@identity) as Ccodigo
								</cfquery>
										
								<!--- Generar para cada uno de los periodos de evaluacion requeridos --->
								<cfloop query="rsMateriaPeriodo">
									<cfquery name="rsGeneracion2" datasource="#Session.DSN#">
										insert CursoPeriodo (PEcodigo, Ccodigo, PCUestado)
										values(
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateriaPeriodo.PEcodigo#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGeneracion1.Ccodigo#">,
											<cfqueryparam cfsqltype="cf_sql_char" value="I">
										)
									</cfquery>
								</cfloop><!--- Loop Periodos de una Materia --->
							</cfloop> <!--- Loop Grupos --->
							
						</cfif>
						
					</cfloop><!--- Loop Materias --->
				</cfif><!--- Si hay Materias seleccionadas --->
			
			<!--- Si la generación se va a realizar por periodo lectivo --->
			<cfelseif rsCicloLectivo.CILtipoCicloDuracion EQ "L">
			
				<cfif isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0>
					<cfset materias = ListToArray(Replace(Form.chk, ' ', '', 'all'), ',')>

					<cfloop index="i" from="1" to="#ArrayLen(materias)#">
						<!--- Averiguar la duración del ciclo lectivo de la materia para decidir como se va a realizar la generacion de los periodos de la materia --->
						<cfquery name="rsMateriaCiclo" datasource="#Session.DSN#">
							select convert(varchar, a.TRcodigo) as TRcodigo, 
								   convert(varchar, a.PEVcodigo) as PEVcodigo, 
								   a.MCLtipoCalificacion, a.MCLpuntosMax, a.MCLunidadMin, a.MCLredondeo, 
								   convert(varchar, a.TEcodigo) as TEcodigo, 
								   MCLtipoCicloDuracionx
							from MateriaCicloLectivo a
							where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">
							and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
						</cfquery>
						
						<!--- Curso Normal de Colegio --->
						<cfif rsMateria.MtipoCicloDuracion EQ "L">
							<!--- Buscar la configuración de la materia para todos los periodos de evaluacion del periodo lectivo  --->
							<cfquery name="rsMateriaPeriodo" datasource="#Session.DSN#">
								select a.MCEsecuencia, a.CIEcodigo, a.PEVcodigo, 
									   a.MCEhorasSemana, a.MCEleccionesSemana, a.MCEhorasLeccion,
									   convert(varchar, b.PLcodigo) as PLcodigo,
									   c.Mnombre,
									   convert(varchar, b.PEcodigo) as PEcodigo
								from MateriaCicloEvaluacion a, PeriodoEvaluacion b, Materia c
								where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">
								and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
								and b.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
								and b.CIEcodigo = a.CIEcodigo
								and a.Mcodigo = c.Mcodigo
								and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								order by a.MCEsecuencia
							</cfquery>

							<!--- Averiguar si ya hay cursos generados para obtener la última secuencia de grupo --->
							<cfquery name="rsSecuencias" datasource="#Session.DSN#">
								select isnull(max(a.Csecuencia), 0) + 1 as Secuencia
								from Curso a
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">
								and a.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
							</cfquery>

							<!--- Generar el Curso --->
							<cfloop index="j" from="#rsSecuencias.Secuencia#" to="#rsSecuencias.Secuencia+Evaluate('Form.Cant_#materias[i]#')-1#">
								<cfquery name="rsGeneracion1" datasource="#Session.DSN#">
									insert Curso (Ecodigo, PLcodigo, PEcodigo, Mcodigo, Csecuencia, Cnombre, Scodigo, TRcodigo, CtipoCalificacion, CpuntosMax, CunidadMin, Credondeo, TEcodigo, Cestado, CsolicitudMaxima, Csolicitados, CmatriculaMaxima, Cmatriculados)
									values(
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateriaPeriodo.PLcodigo#">,
										null,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#materias[i]#">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#j#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMateriaPeriodo.Mnombre#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">,
										<cfif rsMateria.TRcodigo NEQ "">
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.TRcodigo#">,
										<cfelse>
											null,
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_char" value="#rsMateria.MtipoCalificacion#">,
										<cfif Len(Trim(rsMateria.MpuntosMax))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.MpuntosMax#" scale="2">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.MunidadMin))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.MunidadMin#" scale="2">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.Mredondeo))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.Mredondeo#" scale="3">,
										<cfelse>
											null,
										</cfif>
										<cfif Len(Trim(rsMateria.TEcodigo))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateria.TEcodigo#">,
										<cfelse>
											null,
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_tinyint" value="0">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#Evaluate('Form.Cupo_#materias[i]#')#">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="#Evaluate('Form.Cupo_#materias[i]#')#">,
										<cfqueryparam cfsqltype="cf_sql_smallint" value="0">
									)
									
									select convert(varchar, @@identity) as Ccodigo
								</cfquery>
								
								<!--- Generar para cada uno de los periodos de evaluacion requeridos --->
								<cfloop query="rsMateriaPeriodo">
									<cfquery name="rsGeneracion2" datasource="#Session.DSN#">
										insert CursoPeriodo (PEcodigo, Ccodigo, PCUestado)
										values(
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMateriaPeriodo.PEcodigo#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGeneracion1.Ccodigo#">,
											<cfqueryparam cfsqltype="cf_sql_char" value="I">
										)
									</cfquery>
								</cfloop><!--- Loop Periodos de una Materia --->
							</cfloop> <!--- Loop Grupos --->
							
						</cfif>
						
					</cfloop><!--- Loop Materias --->
				</cfif><!--- Si hay Materias seleccionadas --->
				
			</cfif>
		
		<cftry>
		<cfcatch type="any">
			<cftransaction action="rollback">
			<cfinclude template="/educ/errorpages/BDerror.cfm">
			<cfabort>
			
		</cfcatch>
		</cftry>
	
	</cftransaction>
</cfif>

<cfoutput>
<form action="CursoGeneracion.cfm" method="post">
		<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
		<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
		<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
		<cfif form.CILtipoCicloDuracion EQ "E">
		<input type="hidden" name="PEcodigo" id="PEcodigo" value="#Form.PEcodigo#">	
		</cfif>
		<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
		<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
		<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
		<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
		<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
		<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
	<cfif isdefined("form.btnGenerar")>
		<input type="hidden" name="btnGenerar" value="1">
	</cfif>
	<input type="hidden" name="btnMaterias" value="1">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
