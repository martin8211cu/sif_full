
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
	
			<script language="JavaScript" type="text/javascript">
				// Funciones para Manejo de Botones
				botonActual = "";
			
				function setBtn(obj) {
					botonActual = obj.name;
				}
				function btnSelected(name, f) {
					if (f != null) {
						return (f["botonSel"].value == name)
					} else {
						return (botonActual == name)
					}
				}
			</script>
			
			<!--- VARIABLES PARA CUANDO VIENEN DEL ERROR DEL SQL --->
			<!--- <cfif isdefined("url.PRcodigo")and len(trim(url.PRcodigo))>
				<cfset Form.PRcodigo=url.PRcodigo>
			</cfif>
			<cfif isdefined("url.Ecodigo")and len(trim(url.Ecodigo))>
				<cfset Form.Ecodigo=url.Ecodigo>
			</cfif>
			<cfif isdefined("url.GRcodigo")and len(trim(url.GRcodigo))>
				<cfset Form.GRcodigo=url.GRcodigo>
			</cfif> --->
		
			<!--- CONSULTAS --->
			
			<!-----------CURSOS LECTIVOS QUE SERAN MOSTRADOS EN EL CONLIS DE CURSOS LECTIVOS---------->
			<!--- Query para traer los Cursos Lectivos que seran mostrados en el conlis de Cursos Lectivos--->
			<cfquery name="rsCursoLectivo" datasource="#Session.Edu.DSN#">
					select	
						c.SPEcodigo as Codigo,
						a.Ndescripcion + ' : ' + b.PEdescripcion + ' : ' + c.SPEdescripcion as Descripcion
					from 
						Nivel a, PeriodoEscolar b, SubPeriodoEscolar c, PeriodoVigente d
					where 
						a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and a.Ncodigo = b.Ncodigo
						and b.PEcodigo = c.PEcodigo
						and a.Ncodigo = d.Ncodigo
						and b.PEcodigo = d.PEcodigo
						and c.SPEcodigo = d.SPEcodigo
						order by a.Norden
			</cfquery>
			
			<!--- Asigna el id de Curso lectivo actual --->
			<!--- <cfloop query="rsCursoLectivo">
				<cfset codCursoLectivo=#rsCursoLectivo.Codigo#>
				<cfbreak>
			</cfloop>--->
			
			<cfif isdefined("Form.SPEcodigo")>
				<!--- Toma el los datos del curso lectivo actual en caso de que este definido el id del Curso en el form, para despues pasarlo por un arreglo al conlis --->
				<cfquery name="rsCursoActual" datasource="#Session.Edu.DSN#">
					select	
						c.SPEcodigo as Codigo,
						a.Ndescripcion + ' : ' + b.PEdescripcion + ' : ' + c.SPEdescripcion as Descripcion
					from 
						Nivel a, PeriodoEscolar b, SubPeriodoEscolar c, PeriodoVigente d
					where 
						a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and a.Ncodigo = b.Ncodigo
						and b.PEcodigo = c.PEcodigo
						and a.Ncodigo = d.Ncodigo
						and b.PEcodigo = d.PEcodigo
						and c.SPEcodigo = d.SPEcodigo
						and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPEcodigo#">
						order by a.Norden
				</cfquery>
				<!--- En caso de que el id de Curso Lectivo este definido en el form, sobre escribe el id de Curso actual por el que viene por form --->
				<cfset codCursoLectivo=#Form.SPEcodigo#>
			</cfif>

			<cfif isdefined("codCursoLectivo")>
				<!-----------GRADOS QUE SERAN MOSTRADOS EN EL CONLIS DE GRADOS---------->
				<!--- Query para traer los Grados  que seran mostrados en el ComboBox de Grados--->
				<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
					select 
						b.Gcodigo,b.Gdescripcion
					from 
						Nivel a, Grado b
					where 
						a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and a.Ncodigo in (select Ncodigo from PeriodoVigente
											where SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">)
						and a.Ncodigo = b.Ncodigo 
					order by a.Norden, b.Gorden
				</cfquery>
				<!--- Asigna el id de Curso lectivo actual --->
				<cfloop query="rsGrado">
					<cfset codGrado=#rsGrado.Gcodigo#>
					<cfbreak>
				</cfloop>
				
				<cfif isdefined("Form.Gcodigo") AND Form.noGrado IS "0">
					 
					<!--- Toma el los datos del Grado actual en caso de que este definido el id del Grado en el form, para despues pasarlo por un arreglo al conlis de Grados --->
					<cfquery datasource="#Session.Edu.DSN#" name="rsGradoActual">
						select 
							b.Gcodigo,b.Gdescripcion
						from 
							Nivel a, Grado b
						where 
							a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							and a.Ncodigo in (select Ncodigo from PeriodoVigente
												where SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">)
							and a.Ncodigo = b.Ncodigo 
							and b.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gcodigo#">
						order by a.Norden, b.Gorden
					</cfquery>
					<!--- En caso de que el id de Grado este definido en el form, sobre escribe el id de Grado actual por el que viene por form --->
					<cfset codGrado=#Form.Gcodigo#>
				</cfif>
			</cfif>

			<cfif isdefined("codCursoLectivo")>
				<cfif isdefined("codGrado")>
					<!-----------GRUPOS QUE SERAN MOSTRADOS EN EL CONLIS DE GRUPOS---------->
					<!--- Query para traer los Grupo  que seran mostrados en el Conlis de Grupos--->
					<cfquery datasource="#Session.Edu.DSN#" name="rsGrupos">
						Select distinct 
							gr.GRcodigo, gr.GRnombre
						from 
							Grupo gr, Nivel n, Grado g
						where 
							n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							and gr.SPEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
							and gr.Gcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrado#"> 
							and gr.Ncodigo = n.Ncodigo
							and gr.Gcodigo = g.Gcodigo
						order by GRnombre
					</cfquery>
					
					<!--- Asigna el id de Grupo lectivo actual --->
					<cfloop query="rsGrupos">
						<cfset codGrupo=#rsGrupos.GRcodigo#>
						<cfbreak>
					</cfloop>								
					
					<cfif isdefined("Form.GRcodigo")AND Form.noGrupo IS 0>
						<!--- Toma el los datos del Grupo actual en caso de que este definido el id del Grupo en el form, para despues pasarlo por un arreglo al conlis de Grupos --->
						<cfquery datasource="#Session.Edu.DSN#" name="rsGrupoActual">
							Select distinct 
								gr.GRcodigo, gr.GRnombre
							from 
								Grupo gr, Nivel n, Grado g
							where 
								n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
								and gr.SPEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
								and gr.Gcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrado#"> 
								and gr.Ncodigo = n.Ncodigo
								and gr.Gcodigo = g.Gcodigo
								and gr.GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GRcodigo#">
							order by GRnombre
						</cfquery>
						<!--- En caso de que el id de Grupo este definido en el form, sobre escribe el id de Grupo actual por el que viene por form --->
						<cfset codGrupo= Form.GRcodigo>
					</cfif>
				</cfif>
				
				<cfif isdefined("codGrupo")>
					<!-----------CURSOS QUE SERAN MOSTRADOS EN EL CONLIS DE CURSOS---------->
					<!--- Query para traer los Cursos  que seran mostrados en el Conlis de Cursos--->
					<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
						Select distinct 
							c.Ccodigo,
							m.Mnombre + ' - ' + gr.GRnombre as Cnombre, 
							m.Mconsecutivo, 
							m.Mcodigo, 
							m.Mnombre,
							case m.Melectiva when 'E' then 1 else 0 end as electivo
						from 
							Curso c, Materia m, Grupo gr
						where 
							c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							and c.SPEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
							and m.Gcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrado#">
							and c.GRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupo#">
							and c.GRcodigo = gr.GRcodigo
							and c.Mconsecutivo = m.Mconsecutivo
							and m.Melectiva in ('R','C','E')
						order by Cnombre
					</cfquery>
				</cfif>
				
				<cfif isdefined("rsCursos")>
					<!--- Asigna el id de Curso lectivo actual --->
					<cfloop query="rsCursos">
						<cfset codCurso=#rsCursos.Ccodigo#>
						<cfset CursoElectivo=#rsCursos.electivo#>
						<cfbreak>
					</cfloop>								
					
					<cfif isdefined("Form.Ccodigo")AND Form.noCurso IS 0>
						<!--- Toma el los datos del Curso actual en caso de que este definido el id del Curso en el form, para despues pasarlo por un arreglo al conlis de Cursos --->
						<cfquery datasource="#Session.Edu.DSN#" name="rsCurActual">
							Select distinct 
								c.Ccodigo,
								m.Mnombre + ' - ' + gr.GRnombre as Cnombre, 
								m.Mconsecutivo, 
								m.Mcodigo, 
								m.Mnombre,
								case m.Melectiva when 'E' then 1 else 0 end as electivo
							from 
								Curso c, Materia m, Grupo gr
							where 
								c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
								and c.SPEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
								and m.Gcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrado#">
								and c.GRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupo#">
								and c.GRcodigo = gr.GRcodigo
								and c.Mconsecutivo = m.Mconsecutivo
								and m.Melectiva in ('R','C','E')
								and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
							order by Cnombre
						</cfquery>
						<!--- En caso de que el id de Curso este definido en el form, sobre escribe el id de Curso actual por el que viene por form --->
						<cfset codCurso=#Form.Ccodigo#>
						<cfloop query="rsCursos">
							<cfif rsCursos.Ccodigo EQ Form.Ccodigo>
								<cfset CursoElectivo=#rsCursos.electivo#>
								<cfbreak>
							</cfif>
						</cfloop>								
					</cfif>
				</cfif>
				
			</cfif>

			<cfif isdefined("codCurso")>
				<cfquery datasource="#Session.Edu.DSN#" name="rsCursosSustitutivos">
					Select distinct 
						Ccodigo=convert(varchar,c.Ccodigo),
						Cnombre = c.Cnombre,
						Mconsecutivo=convert(varchar,m.Mconsecutivo), m.Mcodigo, m.Mnombre,
						a.Ecodigo, Cmatriculado=case when acc.Ccodigo is null then 0 else 1 end
					from 
						Curso c, Materia m, Alumnos a, GrupoAlumno gra, AlumnoCalificacionCurso acc
					where 
						c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and c.SPEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCursoLectivo#">
						and c.Mconsecutivo = m.Mconsecutivo
						and m.Melectiva = 'S'
						and m.Mconsecutivo in (select Mconsecutivo 
											   from MateriaElectiva 
											   where Melectiva =(select Mconsecutivo 
											   					 from Curso 
																 where Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCurso#">))
						and m.Mconsecutivo in (select Mconsecutivo from GradoSustitutivas
												where Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrado#">)
						and gra.GRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupo#">
						and a.Ecodigo = gra.Ecodigo
						and (not exists (select Ccodigo 
										 from AlumnoCalificacionCurso
										 where Ecodigo = a.Ecodigo and Ccodigo = c.Ccodigo and CEcodigo = c.CEcodigo)
						or exists (	select Ccodigo 
									from AlumnoCalificacionCurso
									where Ecodigo = a.Ecodigo and CEcodigo = c.CEcodigo
									and ACCelectiva = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codCurso#">))
						and a.Ecodigo *= acc.Ecodigo
						and c.CEcodigo *= acc.CEcodigo and c.Ccodigo *= acc.Ccodigo
					order by Ecodigo,Cnombre
				</cfquery>
				
				<cfquery datasource="#Session.Edu.DSN#" name="rsAlumnos">
					Select distinct 
						Ecodigo=convert(varchar,a.Ecodigo), p.Pnombre, p.Papellido1, p.Papellido2,
						Cmatriculado=case when acc.Ccodigo is null then 0 else 1 end,
						Ccodigo=convert(varchar,acc.Ccodigo)
					from 
						Alumnos a, PersonaEducativo p, AlumnoCalificacionCurso acc,Curso c,Materia m,
						GrupoAlumno gra
					where 
						a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and gra.GRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupo#">
						and a.Ecodigo = gra.Ecodigo
						<cfif isdefined("CursoElectivo") AND CursoElectivo IS NOT 0>
						and acc.ACCelectiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCurso#">
						<cfelse>
						and acc.Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCurso#">
						</cfif>
						and c.Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codCurso#">
						and c.Mconsecutivo = m.Mconsecutivo
						and a.persona = p.persona
						and a.Ecodigo *= acc.Ecodigo
						and a.Aretirado = 0
					order by Papellido1,Papellido2,Pnombre
				</cfquery>
			</cfif>

		<script language="JavaScript" type="text/JavaScript">
		function valida(formulario) {
			return true;
		}
		function Valores1() {
			document.formFiltro.noGrado.value=1;
			document.formFiltro.noGrupo.value=1;
			document.formFiltro.noCurso.value=1;
			document.formFiltro.submit()
		}
		function Valores2() {
			document.formFiltro.noGrado.value=0;
			document.formFiltro.noGrupo.value=1;
			document.formFiltro.noCurso.value=1;
			document.formFiltro.submit()
		}
		function Valores3() {
			document.formFiltro.noGrado.value=0;
			document.formFiltro.noGrupo.value=0;
			document.formFiltro.noCurso.value=1;
			document.formFiltro.submit()
		}
		function Valores4() {
			document.formFiltro.noGrado.value=0;
			document.formFiltro.noGrupo.value=0;
			document.formFiltro.noCurso.value=0;
			document.formFiltro.submit()
		}
		</script>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr><td valign="middle">
				<!--- ENCABEZADO --->
				<table cellpadding="0" cellspacing="0" border="0" width="100%" class="tituloListas">
					<form name="formFiltro" method="post" action="MatriculaExtra.cfm">
					<input type="hidden" name="noGrado" value="0">
					<input type="hidden" name="noGrupo" value="0">
					<input type="hidden" name="noCurso" value="0">
					 <tr>
						<td width="25%"><strong>Curso Lectivo</strong>&nbsp;</td>
						<td>
							<!--- CONLIS DE CURSOS LECTIVOS --->
							<cfif isdefined("codCursoLectivo")and isdefined("rsCursoActual.Descripcion")>
								<!--- pinta el conlis con valores del registro seleccionado --->
								<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
								<cfset array = ArrayNew(1)>
								<cfset temp = ArraySet(array, 1,2, "null")>
								<cfset array[1] = codCursoLectivo>    
								<cfset array[2] = rsCursoActual.Descripcion>
								<cf_conlis 
									title="Cursos Lectivos"
									campos = "SPEcodigo,SPEdescripcion" 
									desplegables = "N,S" 
									modificables = "N,N"
									size = "0,60"
									tabla="Nivel a, PeriodoEscolar b, SubPeriodoEscolar c, PeriodoVigente d"
									columnas="	c.SPEcodigo,
												a.Ndescripcion + ' : ' + b.PEdescripcion + ' : ' + c.SPEdescripcion as SPEdescripcion"
									filtro="a.CEcodigo = #Session.Edu.CEcodigo#
											and a.Ncodigo = b.Ncodigo
											and b.PEcodigo = c.PEcodigo
											and a.Ncodigo = d.Ncodigo
											and b.PEcodigo = d.PEcodigo
											and c.SPEcodigo = d.SPEcodigo
											order by a.Norden"
									desplegar="SPEdescripcion"
									etiquetas="Descripcion"
									formatos="S"
									align="left"
									asignar="SPEcodigo,SPEdescripcion"
									asignarformatos="I,S"
									Form="formFiltro"
									Conexion="#Session.Edu.DSN#"
									funcion="Valores1()"
									valuesArray="#array#"
									tabindex="1"
								> 
							<cfelse>
								<!--- pinta el conlis por primera vez cuando no se ha seleccionado ningun registro del mismo --->
								<cf_conlis 
									title="Cursos Lectivos"
									campos = "SPEcodigo,SPEdescripcion" 
									desplegables = "N,S" 
									modificables = "N,N"
									size = "0,60"
									tabla="Nivel a, PeriodoEscolar b, SubPeriodoEscolar c, PeriodoVigente d"
									columnas="	c.SPEcodigo,
												a.Ndescripcion + ' : ' + b.PEdescripcion + ' : ' + c.SPEdescripcion as SPEdescripcion"
									filtro="a.CEcodigo = #Session.Edu.CEcodigo#
											and a.Ncodigo = b.Ncodigo
											and b.PEcodigo = c.PEcodigo
											and a.Ncodigo = d.Ncodigo
											and b.PEcodigo = d.PEcodigo
											and c.SPEcodigo = d.SPEcodigo
											order by a.Norden"
									desplegar="SPEdescripcion"
									etiquetas="Descripcion"
									formatos="S"
									align="left"
									asignar="SPEcodigo,SPEdescripcion"
									asignarformatos="I,S"
									Form="formFiltro"
									Conexion="#Session.Edu.DSN#"
									funcion="Valores1()"
									tabindex="1"
								>  
							</cfif>
						</td>
					</tr>
					<cfif isdefined("codCursoLectivo")>
					<tr>
					<tr>
						<td width="25%"><strong>Grado</strong>&nbsp;</td>
						<td>
							<!--- CONLIS DE GRADOS --->	
							<!--- pinta el conlis con valores del registro seleccionado --->
							<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
							<cfif isdefined("codGrado")and isdefined("rsGradoActual.Gdescripcion")and len(trim(codGrado))and len(trim(rsGradoActual.Gdescripcion))>
								<cfset array2 = ArrayNew(1)>
								<cfset temp = ArraySet(array2, 1,2, "null")>
								<cfset array2[1] = codGrado>    
								<cfset array2[2] = rsGradoActual.Gdescripcion>
								<cf_conlis 
									title="Grado"
									campos = "Gcodigo,Gdescripcion" 
									desplegables = "N,S" 
									modificables = "N,N"
									size = "0,40"
									tabla="Nivel a, Grado b"
									columnas="	b.Gcodigo,
												b.Gdescripcion"
									filtro="a.CEcodigo =#Session.Edu.CEcodigo#
											and a.Ncodigo in (	select Ncodigo from PeriodoVigente
																where SPEcodigo = #codCursoLectivo#)
											and a.Ncodigo = b.Ncodigo 
											order by a.Norden, b.Gorden"	
									desplegar="Gdescripcion"
									etiquetas="Descripcion"
									formatos="S"
									align="left"
									asignar="Gcodigo,Gdescripcion"
									asignarformatos="I,S"
									Form="formFiltro"
									Conexion="#Session.Edu.DSN#"
									funcion="Valores2()"
									valuesArray="#array2#"
									tabindex="1"
								> 
							
							<cfelse>
									<cfset array2 = ArrayNew(1)>
									<cfset temp = ArraySet(array2, 1,2, "null")>
									<cfloop query="rsGrado">
										<cfset array2[1] = rsGrado.Gcodigo>    
										<cfset array2[2] = rsGrado.Gdescripcion>
										<cfbreak>
									</cfloop>
								<cf_conlis 
									title="Grado"
									campos = "Gcodigo,Gdescripcion" 
									desplegables = "N,S" 
									modificables = "N,N"
									size = "0,40"
									tabla="Nivel a, Grado b"
									columnas="	b.Gcodigo,
												b.Gdescripcion"
									filtro="a.CEcodigo =#Session.Edu.CEcodigo#
											and a.Ncodigo in (	select Ncodigo from PeriodoVigente
																where SPEcodigo = #codCursoLectivo#)
											and a.Ncodigo = b.Ncodigo 
											order by a.Norden, b.Gorden"	
									desplegar="Gdescripcion"
									etiquetas="Descripcion"
									formatos="S"
									align="left"
									asignar="Gcodigo,Gdescripcion"
									asignarformatos="I,S"
									Form="formFiltro"
									Conexion="#Session.Edu.DSN#"
									funcion="Valores2()"
									valuesArray="#array2#"
									tabindex="1"
								>   
						</cfif>
						</td>
				  </tr>
				  </cfif>			  
				  <cfif isdefined("codGrupo")>
				  <tr>
					<cfif isdefined("rsGrupos")>
						<td width="25%"><strong>Grupo</strong>&nbsp;</td>
						<td>
							<!--- CONLIS DE GRUPOS --->	
							<!--- pinta el conlis con valores del registro seleccionado --->
							<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
							<cfif isdefined("codGrupo")and isdefined("rsGrupoActual.GRnombre")and len(trim(codGrupo))and len(trim(rsGrupoActual.GRnombre))>
								<cfset array3 = ArrayNew(1)>
								<cfset temp = ArraySet(array3, 1,2, "null")>
								<cfset array3[1] = codGrupo>    
								<cfset array3[2] = rsGrupoActual.GRnombre>
								<cf_conlis 
									title="Grupos"
									campos = "GRcodigo,GRnombre" 
									desplegables = "N,S" 
									modificables = "N,N"
									size = "0,40"
									tabla="Grupo gr, Nivel n, Grado g"
									columnas="	gr.GRcodigo, 
												gr.GRnombre"
									filtro="	n.CEcodigo=#Session.Edu.CEcodigo#
												and gr.SPEcodigo=#codCursoLectivo#
												and gr.Gcodigo=#codGrado# 
												and gr.Ncodigo = n.Ncodigo
												and gr.Gcodigo = g.Gcodigo
												order by GRnombre"	
									desplegar="GRnombre"
									etiquetas="Descripcion"
									formatos="S"
									align="left"
									asignar="GRcodigo,GRnombre"
									asignarformatos="I,S"
									Form="formFiltro"
									Conexion="#Session.Edu.DSN#"
									funcion="Valores3()"
									valuesArray="#array3#"
									tabindex="1"
								> 
							
							<cfelse>
									<cfset array3 = ArrayNew(1)>
									<cfset temp = ArraySet(array3, 1,2, "null")>
									<cfloop query="rsGrupos">
										<cfset array3[1] = rsGrupos.Grcodigo>    
										<cfset array3[2] = rsGrupos.GRnombre>
										<cfbreak>
									</cfloop>
								<cf_conlis 
									title="Grupos"
									campos = "GRcodigo,GRnombre" 
									desplegables = "N,S" 
									modificables = "N,N"
									size = "0,40"
									tabla="Grupo gr, Nivel n, Grado g"
									columnas="	gr.GRcodigo, 
												gr.GRnombre"
									filtro="	n.CEcodigo=#Session.Edu.CEcodigo#
												and gr.SPEcodigo=#codCursoLectivo#
												and gr.Gcodigo=#codGrado# 
												and gr.Ncodigo = n.Ncodigo
												and gr.Gcodigo = g.Gcodigo
												order by GRnombre"	
									desplegar="GRnombre"
									etiquetas="Descripcion"
									formatos="S"
									align="left"
									asignar="GRcodigo,GRnombre"
									asignarformatos="I,S"
									Form="formFiltro"
									Conexion="#Session.Edu.DSN#"
									funcion="Valores3()"
									valuesArray="#array3#"
									tabindex="1"
								>
						</cfif>
						</td>
					</cfif>
					</tr>
					<tr>
						<td width="25%"><strong>Curso</strong>&nbsp;</td>
						<td>
							<!--- CONLIS DE GRUPOS --->	
							<!--- pinta el conlis con valores del registro seleccionado --->
							<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
								<!--- CursoElectivo --->
							
							<cfif isdefined("codCurso")and isdefined("rsCurActual.Cnombre")and len(trim(codCurso))and len(trim(rsCurActual.Cnombre))>
								<cfset array4 = ArrayNew(1)>
								<cfset temp = ArraySet(array4, 1,6, "null")>
								<cfset array4[1] = codCurso>    
								<cfset array4[2] = rsCurActual.Cnombre>
								<cfset array4[3] = rsCurActual.Mconsecutivo>
								<cfset array4[4] = rsCurActual.Mcodigo>
								<cfset array4[5] = rsCurActual.Mnombre>
								<cfset array4[6] = rsCurActual.electivo>
								
								<cf_conlis 
									title="Cursos"
									campos = "Ccodigo,Cnombre,Mconsecutivo,Mcodigo,Mnombre,electivo" 
									desplegables = "N,S,N,N,N,N" 
									modificables = "N,N,N,N,N,N"
									size = "0,60,0,0,0,0"
									tabla="Curso c, Materia m, Grupo gr"
									columnas="	c.Ccodigo,
												m.Mnombre + ' - ' + gr.GRnombre as Cnombre, 
												m.Mconsecutivo, 
												m.Mcodigo, 
												m.Mnombre,
												case m.Melectiva when 'E' then 1 else 0 end as electivo"
									filtro="	c.CEcodigo=#Session.Edu.CEcodigo#
												and c.SPEcodigo=#codCursoLectivo#
												and m.Gcodigo=#codGrado#
												and c.GRcodigo=#codGrupo#
												and c.GRcodigo = gr.GRcodigo
												and c.Mconsecutivo = m.Mconsecutivo
												and m.Melectiva in ('R','C','E')
												order by Cnombre"	
									desplegar="Cnombre"
									etiquetas="Descripcion"
									formatos="S"
									align="left"
									asignar="Ccodigo,Cnombre,Mconsecutivo,Mcodigo,Mnombre,electivo"
									asignarformatos="I,S,I,I,S,I"
									Form="formFiltro"
									Conexion="#Session.Edu.DSN#"
									funcion="Valores4()"
									valuesArray="#array4#"
									tabindex="1"
								> 
							
							<cfelse>
									<cfset array4 = ArrayNew(1)>
									<cfset temp = ArraySet(array4, 1,6, "null")>
									<cfloop query="rsGrupos">
										<cfset array4[1] = rsCursos.Ccodigo>    
										<cfset array4[2] = rsCursos.Cnombre>
										<cfset array4[3] = rsCursos.Mconsecutivo>
										<cfset array4[4] = rsCursos.Mcodigo>
										<cfset array4[5] = rsCursos.Mnombre>
										<cfset array4[6] = rsCursos.electivo>
										<cfbreak>
									</cfloop>
								<cf_conlis 
									title="Cursos"
									campos = "Ccodigo,Cnombre,Mconsecutivo,Mcodigo,Mnombre,electivo" 
									desplegables = "N,S,N,N,N,N" 
									modificables = "N,N,N,N,N,N"
									size = "0,60,0,0,0,0"
									tabla="Curso c, Materia m, Grupo gr"
									columnas="	c.Ccodigo,
												m.Mnombre + ' - ' + gr.GRnombre as Cnombre, 
												m.Mconsecutivo, 
												m.Mcodigo, 
												m.Mnombre,
												case m.Melectiva when 'E' then 1 else 0 end as electivo"
									filtro="	c.CEcodigo=#Session.Edu.CEcodigo#
												and c.SPEcodigo=#codCursoLectivo#
												and m.Gcodigo=#codGrado#
												and c.GRcodigo=#codGrupo#
												and c.GRcodigo = gr.GRcodigo
												and c.Mconsecutivo = m.Mconsecutivo
												and m.Melectiva in ('R','C','E')
												order by Cnombre"	
									desplegar="Cnombre"
									etiquetas="Descripcion"
									formatos="S"
									align="left"
									asignar="Ccodigo,Cnombre,Mconsecutivo,Mcodigo,Mnombre,electivo"
									asignarformatos="I,S,I,I,S,I"
									Form="formFiltro"
									Conexion="#Session.Edu.DSN#"
									funcion="Valores4()"
									valuesArray="#array4#"
									tabindex="1"
								> 
							</cfif>
						</td>
					  </tr>
					  </cfif>
					  </form>
					  <!--- Form --->
				</table>
		  </td></tr>
		  <cfif isdefined("codCurso")>
			<form name="formMatricula" method="post" action="SQLMatriculaExtra.cfm" onSubmit="return valida(this)">
				<cfif isdefined("form.noGrado") and isdefined("form.noGrupo")and isdefined("form.noCurso")>
					<cfoutput>
					<input type="hidden" name="noGrado" value="#form.noGrado#">
					<input type="hidden" name="noGrupo" value="#form.noGrupo#">
					<input type="hidden" name="noCurso" value="#form.noCurso#">
					</cfoutput>
				</cfif>
				<tr class="tituloListas"><td><b>Alumnos</b></td></tr>
				<tr  class="tituloListas"><td><strong>
					<input name="chkTodos" type="checkbox" value="" border="1" onClick="javascript:Marcar(this);">
					Seleccionar Todos</strong></td></tr>
				<tr><td>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="tituloListas"><strong>&nbsp;</strong></td>
							<td class="tituloListas"><strong>Nombre</strong></td>
							<cfif isdefined("CursoElectivo") AND CursoElectivo IS NOT 0>
								<td class="tituloListas"><strong>Curso Sustituto</strong></td>
							</cfif>
						</tr>
						<tr><td colspan="3">
								<table  width="100%" cellpadding="0" cellspacing="0"><tr>
									<td width="60%">
										<table  width="100%" cellpadding="0" cellspacing="0">
											<cfset indiceAlumno = 1>
											<cfoutput query="rsAlumnos">
												<tr><td>
													<cfquery dbtype="query" name="detalleSustitutivos">
													select * from rsCursosSustitutivos
													where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlumnos.Ecodigo#">
													</cfquery>
													<cfif (NOT isdefined("CursoElectivo") OR CursoElectivo IS 0 OR detalleSustitutivos.RecordCount IS NOT 0) AND NOT rsAlumnos.Cmatriculado>
														<input name="Ecodigo" type="hidden" value="#rsAlumnos.Ecodigo#">
														<input name="checkAlumno" type="checkbox" value="#indiceAlumno#" tabindex="1">
														<cfset indiceAlumno = indiceAlumno + 1>
													<cfelseif rsAlumnos.Cmatriculado>
														<a href="javascript:desmatricularAlumno(#rsAlumnos.Ecodigo#)">
														<img src="../../Imagenes/Cferror.gif" border="0" alt="Desmatricular">
														</a>
													</cfif>
												</td>
												<td>#rsAlumnos.Papellido1# #rsAlumnos.Papellido2# #rsAlumnos.Pnombre#</td>
												<cfif isdefined("CursoElectivo") AND CursoElectivo IS NOT 0>
													<td>
														<cfif detalleSustitutivos.RecordCount IS NOT 0 AND NOT rsAlumnos.Cmatriculado>
															<select name="Csustituto" tabindex="1">
															<cfloop query="detalleSustitutivos">
															<option value="#detalleSustitutivos.Ccodigo#" <cfif detalleSustitutivos.Cmatriculado>selected</cfif>>#detalleSustitutivos.Cnombre#</option>
															</cfloop>
															</select>
														<cfelseif rsAlumnos.Cmatriculado>
															<cfloop query="detalleSustitutivos">
															<cfif detalleSustitutivos.Cmatriculado>#detalleSustitutivos.Cnombre#</cfif>
															</cfloop>
														</cfif>
													</td>
												</cfif>
												</tr>
											</cfoutput>
										</table>
									</td>
									<td valign="top"><!--- INSTRUCCIONES --->
										<cf_web_portlet titulo="Instrucciones"> 
											<table cellpadding="0" cellspacing="0">
												<tr><td align="left">
													 Para DESMATRICULAR a algún alumno solo debe hacer clic sobre el icono:
													 <img src="../../Imagenes/Cferror.gif" border="0" alt="Desmatricular"> &nbsp;, los alumnos 
													 que no poseen este icono no estan matriculados. Si desea MATRICULAR
													  a uno o varios alumnos debe seleccinarlos y hacer clic en Matricular.
												</td></tr>
											</table>
										</cf_web_portlet>
									</td>	
								</tr></table>
						</td></tr>
						
					</table>
				</td></tr>
			
				<tr><td>
					<div style="text-align:center">
					<cfif isdefined("codCursoLectivo")>
					<input type="hidden" name="SPEcodigo" value="<cfoutput>#codCursoLectivo#</cfoutput>">
					</cfif>
					<cfif isdefined("codGrado")>
	
					<input type="hidden" name="Gcodigo" value="<cfoutput>#codGrado#</cfoutput>">
					</cfif>
					<cfif isdefined("codGrupo")>
					<input type="hidden" name="GRcodigo" value="<cfoutput>#codGrupo#</cfoutput>">
					</cfif>
					<cfif isdefined("CursoElectivo")>
					<input type="hidden" name="CursoElectivo" value="<cfoutput>#CursoElectivo#</cfoutput>">
					</cfif>
					<input type="hidden" name="Ccodigo" value="<cfoutput>#codCurso#</cfoutput>">
					<input type="submit" name="btnMatricular" value="Matricular" onClick="javascript:setBtn(this)">
					
					</div>
				</td></tr>
			</form>
						
			  <form action="SQLDesmatriculaExtra.cfm" method="post" name="formDesmatricular">
				<cfif isdefined("form.noGrado") and isdefined("form.noGrupo")and isdefined("form.noCurso")>
					<cfoutput>
					<input type="hidden" name="noGrado" value="#form.noGrado#">
					<input type="hidden" name="noGrupo" value="#form.noGrupo#">
					<input type="hidden" name="noCurso" value="#form.noCurso#">
					</cfoutput>
				</cfif>
				<cfif isdefined("codCursoLectivo")>
				<input type="hidden" name="SPEcodigo" value="<cfoutput>#codCursoLectivo#</cfoutput>">
				</cfif>
				<cfif isdefined("codGrado")>
				<input type="hidden" name="Gcodigo" value="<cfoutput>#codGrado#</cfoutput>">
				</cfif>
				<cfif isdefined("codGrupo")>
				<input type="hidden" name="GRcodigo" value="<cfoutput>#codGrupo#</cfoutput>">
				</cfif>
				<cfif isdefined("CursoElectivo")>
				<input type="hidden" name="CursoElectivo" value="<cfoutput>#CursoElectivo#</cfoutput>">
				</cfif>
				<input type="hidden" name="Ccodigo" value="<cfoutput>#codCurso#</cfoutput>">
				<input type="hidden" name="Ecodigo" value="0">
			  </form>
		  </cfif>
	   </table>
	   
		<script type="text/javascript">
		function desmatricularAlumno(codigo) {
			formDesmatricular.Ecodigo.value = codigo;
			formDesmatricular.submit();
		}
		</script>
		<script language="JavaScript1.2">
			function Marcar(c) {
				if (document.formMatricula.checkAlumno != null) { //existe?
					if (document.formMatricula.checkAlumno.value != null) {// solo un check
						if (c.checked) document.formMatricula.checkAlumno.checked = true; else document.formMatricula.checkAlumno.checked = false;
					}
					else {
						if (c.checked) {
							for (var counter = 0; counter < document.formMatricula.checkAlumno.length; counter++)
							{
								if ((!document.formMatricula.checkAlumno[counter].checked) && (!document.formMatricula.checkAlumno[counter].disabled))
									{  document.formMatricula.checkAlumno[counter].checked = true;}
							}
							if ((counter==0)  && (!document.formMatricula.checkAlumno.disabled)) {
								document.formMatricula.checkAlumno.checked = true;
							}
						}
						else {
							for (var counter = 0; counter < document.formMatricula.checkAlumno.length; counter++)
			
							{
								if ((document.formMatricula.checkAlumno[counter].checked) && (!document.formMatricula.checkAlumno[counter].disabled))
									{  document.formMatricula.checkAlumno[counter].checked = false;}
							};
							if ((counter==0) && (!document.formMatricula.checkAlumno.disabled)) {
								document.formMatricula.checkAlumno.checked = false;
							}
						};
					}
				}
			}
		</script>
				
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>