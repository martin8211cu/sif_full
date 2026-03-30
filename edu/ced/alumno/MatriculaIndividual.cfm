<!--- <cfdump var="#form#">
<cfdump var="#url#">
 --->
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
			<cfif isdefined("url.PRcodigo")and len(trim(url.PRcodigo))>
				<cfset Form.PRcodigo=url.PRcodigo>
			</cfif>
			<cfif isdefined("url.Ecodigo")and len(trim(url.Ecodigo))>
				<cfset Form.Ecodigo=url.Ecodigo>
			</cfif>
			<cfif isdefined("url.GRcodigo")and len(trim(url.GRcodigo))>
				<cfset Form.GRcodigo=url.GRcodigo>
			</cfif>
			<!--- SE LE ASIGNA EL VALOR A LAS VARIABLES NOGroup Y noAlumn CUANDO SE SELECCINO UN ALUMNO Y SE HISO SUBMIT--->
			<cfif isdefined("form.noGroup2")and len(trim(form.noGroup2))>
				<cfset Form.noGroup=form.noGroup2>
			</cfif>
			<cfif isdefined("form.noAlumn2")and len(trim(form.noAlumn2))>
				<cfset Form.noAlumn=form.noAlumn2>
			</cfif>
			<!---------CONSULTAS-------------->	
			<cfquery datasource="#Session.Edu.DSN#" name="rsPromociones">
				Select distinct 
						pr.PRcodigo,
						pr.PRdescripcion + ' : ' + g.Gdescripcion as PRdescripcion, 
						pv.SPEcodigo,
						pr.Gcodigo
				from 
						Promocion pr, Nivel n, Grado g, PeriodoVigente pv
				where 
						n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and pr.Gcodigo = g.Gcodigo
						and pr.Ncodigo = n.Ncodigo
						and pr.Ncodigo = pv.Ncodigo
						and pr.PEcodigo = pv.PEcodigo
						and pr.PRactivo = 1
				order by n.Norden,g.Gorden
			</cfquery>
			
			<cfif isdefined("Form.PRcodigo")>
				<cfquery datasource="#Session.Edu.DSN#" name="rsPromoActual">
					Select distinct 
							pr.PRcodigo,
							pr.PRdescripcion + ' : ' + g.Gdescripcion as PRdescripcion, 
							pv.SPEcodigo,
							pr.Gcodigo
					from 
							Promocion pr, Nivel n, Grado g, PeriodoVigente pv
					where 
							n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							and pr.Gcodigo = g.Gcodigo
							and pr.Ncodigo = n.Ncodigo
							and pr.Ncodigo = pv.Ncodigo
							and pr.PEcodigo = pv.PEcodigo
							and pr.PRactivo = 1
							and pr.PRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRcodigo#">
							
					order by n.Norden,g.Gorden
				</cfquery>
			</cfif>
			<!--- <cfloop query="rsPromociones">
				<cfset codPromocion=#rsPromociones.PRcodigo#>
				<cfbreak>
			</cfloop> --->
			
			 <cfif isdefined("Form.PRcodigo")>
				<cfset codPromocion=#Form.PRcodigo#>
			</cfif>
			<cfif isdefined("codPromocion")>
				<cfquery datasource="#Session.Edu.DSN#" name="rsAlumnos">
				Select distinct 
						a.Ecodigo,
						p.Pnombre,
						p.Papellido1, 
						p.Papellido2
				from 
						Alumnos a, PersonaEducativo p
				where 
						a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and a.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
						and a.persona = p.persona
						and a.Aretirado = 0
				order by Papellido1,Papellido2,Pnombre
				</cfquery>
				<cfif isdefined("rsAlumnos")and rsAlumnos.RecordCount neq 0>
					<cfloop query="rsAlumnos">
						<cfset codEstudiante=#rsAlumnos.Ecodigo#>
						<cfbreak>
					</cfloop>
					
					<cfif isdefined("Form.Ecodigo")AND Form.noAlumn EQ 0>
						<!--- Si se define la variable se toma el alumono que fue seleccionado para despues presentarlo en el conlist de Alumnos --->
						<cfquery datasource="#Session.Edu.DSN#" name="rsAlumnoActual">
								Select distinct 
										a.Ecodigo,
										p.Pnombre,
										p.Papellido1, 
										p.Papellido2
								from 
										Alumnos a, PersonaEducativo p
								where 
										a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
										and a.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
										and a.persona = p.persona
										and a.Aretirado = 0
										and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
								order by Papellido1,Papellido2,Pnombre
						</cfquery>
						<cfset codEstudiante=#Form.Ecodigo#>
					</cfif>
				</cfif>
			</cfif>
			
			<cfif isdefined("codPromocion") AND isdefined("codEstudiante")>
				<cfquery datasource="#Session.Edu.DSN#" name="rsGrupos">
					Select distinct 
						GRcodigo=convert(varchar,gr.GRcodigo), gr.GRnombre,
						GRactual=case when gra.GRcodigo is null then 0 else 1 end,g.Gnalumnos,
						GRnalumnos=(select count(Ecodigo) from GrupoAlumno where GRcodigo=gr.GRcodigo)
						from Grupo gr, Nivel n, Promocion pr, PeriodoVigente pv, GrupoAlumno gra, Grado g
					where 
						n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and pr.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
						and gra.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEstudiante#"> 
						and gr.Ncodigo = n.Ncodigo
						and gr.Ncodigo = pr.Ncodigo
						and gr.Gcodigo = pr.Gcodigo
						and pr.Ncodigo = pv.Ncodigo
						and pr.PEcodigo = pv.PEcodigo
						and gr.PEcodigo = pv.PEcodigo
						and gr.SPEcodigo = pv.SPEcodigo
						and gr.GRcodigo *= gra.GRcodigo
						and gr.Gcodigo = g.Gcodigo
					order by GRnombre
				</cfquery>
				
				<cfloop query="rsGrupos">
					<cfset codGrupo=#rsGrupos.GRcodigo#>
					<cfbreak>
				</cfloop>								
				
				<cfset codGrupoActual=0>
				<cfloop query="rsGrupos">
					<cfif rsGrupos.GRactual IS NOT 0>
					  <cfset codGrupo=#rsGrupos.GRcodigo#>
					  <cfset codGrupoActual=#rsGrupos.GRcodigo#>
					  <cfbreak>
					</cfif>
				</cfloop>			
				
				<cfif isdefined("Form.GRcodigo")AND (NOT isdefined("Form.noGroup") OR Form.noGroup IS "0")>
					<cfset codGrupo=#Form.GRcodigo#>
				</cfif>
				
				<cfif isdefined("codGrupo")>
					<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
					Set nocount on
					Select distinct Ccodigo=convert(varchar,c.Ccodigo),
					Cnombre = m.Mnombre + ' - ' + gr.GRnombre, 
					Mconsecutivo=convert(varchar,m.Mconsecutivo), m.Mcodigo, m.Mnombre,
					Cmatriculado=case when acc.Ccodigo is null then 0 else 1 end
					from Curso c, Materia m, Promocion pr, Nivel n, PeriodoVigente pv, 
					AlumnoCalificacionCurso acc, Grupo gr
					where c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and pr.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
					and c.GRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupo#">
					and acc.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEstudiante#">
					and c.GRcodigo = gr.GRcodigo
					and c.Mconsecutivo = m.Mconsecutivo
					and c.SPEcodigo = pv.SPEcodigo
					and pr.Ncodigo = n.Ncodigo
					and pr.Ncodigo = pv.Ncodigo
					and pr.PEcodigo = pv.PEcodigo
					and pr.Gcodigo = m.Gcodigo
					and c.Ccodigo *= acc.Ccodigo
					and (m.Melectiva = 'R' or m.Melectiva = 'C')
					order by Cnombre
					Set nocount off
					</cfquery>
					<cfquery datasource="#Session.Edu.DSN#" name="rsElectivas">
					Set nocount on
					Select distinct Ccodigo=convert(varchar,c.Ccodigo), c.Cnombre, 
					convert(varchar,cs.Ccodigo) as Scodigo, cs.Cnombre as Snombre,
					Cmatriculado=case when cae.Ccodigo is null then 0 else 1 end
					from Materia m, Promocion pr, Nivel n, PeriodoVigente pv, MateriaElectiva me, 
					Materia ms, Curso c, Curso cs, AlumnoCalificacionCurso accs, Curso cae
					where n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and pr.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
					and accs.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEstudiante#">
					and c.GRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupo#">
					and c.Mconsecutivo = m.Mconsecutivo
					and c.SPEcodigo = pv.SPEcodigo
					and pr.Ncodigo = n.Ncodigo
					and pr.Ncodigo = pv.Ncodigo
					and pr.PEcodigo = pv.PEcodigo
					and pr.Gcodigo = m.Gcodigo
					and m.Mconsecutivo = me.Melectiva
					and me.Mconsecutivo = ms.Mconsecutivo
					and cs.Mconsecutivo = ms.Mconsecutivo
					and cs.SPEcodigo = pv.SPEcodigo
					and cs.Ccodigo *= accs.Ccodigo
					and accs.ACCelectiva *= cae.Ccodigo
					and cae.GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codGrupoActual#">
					and cae.Mconsecutivo =* c.Mconsecutivo
					and ms.Melectiva = 'S'
					and m.Melectiva = 'E'
					order by Cnombre
					Set nocount off
					</cfquery>
			    </cfif>

				<cfquery datasource="#Session.Edu.DSN#" name="rsCalificado">
				Set nocount on
				Select PEcodigo=convert(varchar,acpe.PEcodigo)
				from Curso c, Materia m, Promocion pr, Nivel n, PeriodoVigente pv, 
				AlumnoCalificacionPerEval acpe
				where c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and pr.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
				and acpe.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEstudiante#">
				and c.Mconsecutivo = m.Mconsecutivo
				and c.SPEcodigo = pv.SPEcodigo
				and pr.Ncodigo = n.Ncodigo
				and pr.Ncodigo = pv.Ncodigo
				and pr.PEcodigo = pv.PEcodigo
				and pr.Gcodigo = m.Gcodigo
				and c.Ccodigo = acpe.Ccodigo
				and m.Melectiva = 'R'
				union
				Select PEcodigo=convert(varchar,acpe.PEcodigo)
				from Materia m, Promocion pr, Nivel n, PeriodoVigente pv, MateriaElectiva me, 
				Materia ms, Curso c, Curso cs, AlumnoCalificacionPerEval acpe
				where n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and pr.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
				and acpe.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEstudiante#">
				and c.Mconsecutivo = m.Mconsecutivo
				and c.SPEcodigo = pv.SPEcodigo
				and pr.Ncodigo = n.Ncodigo
				and pr.Ncodigo = pv.Ncodigo
				and pr.PEcodigo = pv.PEcodigo
				and pr.Gcodigo = m.Gcodigo
				and m.Mconsecutivo = me.Melectiva
				and me.Mconsecutivo = ms.Mconsecutivo
				and cs.Mconsecutivo = ms.Mconsecutivo
				and cs.SPEcodigo = pv.SPEcodigo
				and cs.Ccodigo = acpe.Ccodigo
				and ms.Melectiva = 'S'
				and m.Melectiva = 'E'
				Set nocount off
				</cfquery>
				
				<cfset calificado=false>
				<cfloop query="rsCalificado">
					<cfset calificado=true>
					<cfbreak>
				</cfloop>
			</cfif>
			<!-------CONSULTAS FIN------------>
		    
			<script language="JavaScript" type="text/JavaScript">
		    <!--- VALIDACION DEL FORMULARIO --->
				function valida(formulario) {
				
				if (btnSelected("btnAceptar"))
				for (var i=0; i<formulario.elements.length; i++) {
					if (formulario.elements[i].type == "select-one" &&
					formulario.elements[i].name == "Scodigo") {
						for (var j=i+1; j<formulario.elements.length; j++) {
							if (formulario.elements[j].type == "select-one" &&
							formulario.elements[j].name == "Scodigo") {
								if (formulario.elements[i].value == formulario.elements[j].value) {
									alert('No pueden seleccionarse dos cursos iguales');
									return false;
								}
							}
						}
					}
				}
				
				if (formulario.calificado.value == "1") {
					if (!confirm("Se van a perder las notas del alumno.  Desea continuar?")) {
						return false;
					}
				}
				return true;
		    }
		    </script>
			
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
                <td  align="left" valign="top" width="60%">
					<!--- OPCIONES PARA EL ENCABEZADO --->
					<table border="0" cellspacing="0" cellpadding="0">
						<form name="formAlumno" method="post" action="MatriculaIndividual.cfm">
						<tr class="tituloListas">
							<td>
								<strong>Promoci&oacute;n</strong>&nbsp;
							</td>
							<td>
								<cfif isdefined("codPromocion")and isdefined("rsPromoActual.PRdescripcion")and isdefined("rsPromoActual.SPEcodigo")and isdefined("rsPromoActual.Gcodigo")>
									<!--- pinta el conlis con valores del registro seleccionado --->
									<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
									<cfset array = ArrayNew(1)>
									<cfset temp = ArraySet(array, 1,6, "null")>
									<cfset array[1] = codPromocion>    
									<cfset array[2] = rsPromoActual.PRdescripcion>
									<cfset array[3] = rsPromoActual.SPEcodigo>
									<cfset array[4] = rsPromoActual.Gcodigo>
									<cfset array[5] = 1>
									<cfset array[6] = 1>
									<!--- Conlis de Promociones, presenta solo la descripcion de la promoción y hace submit al form al seleccionar un registro--->
									<cf_conlis 
										title="Promociones"
										campos = "PRcodigo,PRdescripcion,SPEcodigo,Gcodigo,noGroup,noAlumn" 
										desplegables = "N,S,N,N,N,N" 
										modificables = "N,N,N,N,N,N"
										size = "0,60,0,0,0,0"
										tabla="Promocion pr, Nivel n, Grado g, PeriodoVigente pv"
										columnas="	pr.PRcodigo,
													pr.PRdescripcion + ' : ' + g.Gdescripcion as PRdescripcion, 
													pv.SPEcodigo,
													pr.Gcodigo,
													1 as noGroup,
													1 as noAlumn"
										filtro="n.CEcodigo=#Session.Edu.CEcodigo#
												and pr.Gcodigo = g.Gcodigo
												and pr.Ncodigo = n.Ncodigo
												and pr.Ncodigo = pv.Ncodigo
												and pr.PEcodigo = pv.PEcodigo
												and pr.PRactivo = 1
												order by n.Norden,g.Gorden"
										desplegar="PRdescripcion"
										etiquetas="Descripci&oacute;n"
										formatos="S"
										align="left"
										asignar="PRcodigo,PRdescripcion,SPEcodigo,Gcodigo,noGroup,noAlumn"
										asignarformatos="I,S,I,I,I,I"
										Form="formAlumno"
										Conexion="#Session.Edu.DSN#"
										funcion="document.formAlumno.submit()"
										valuesArray="#array#"
									> 
								<cfelse>
									<!--- pinta el conlis por primera vez cuando no se ha seleccionado ningun registro del mismo --->
									<cf_conlis 
										title="Promociones"
										campos = "PRcodigo,PRdescripcion,SPEcodigo,Gcodigo,noGroup,noAlumn" 
										desplegables = "N,S,N,N,N,N" 
										modificables = "N,N,N,N,N,N"
										size = "0,60,0,0,0,0"
										tabla="Promocion pr, Nivel n, Grado g, PeriodoVigente pv"
										columnas="	pr.PRcodigo,
													pr.PRdescripcion + ' : ' + g.Gdescripcion as PRdescripcion, 
													pv.SPEcodigo,
													pr.Gcodigo,
													1 as noGroup,
													1 as noAlumn"
										filtro="n.CEcodigo=#Session.Edu.CEcodigo#
												and pr.Gcodigo = g.Gcodigo
												and pr.Ncodigo = n.Ncodigo
												and pr.Ncodigo = pv.Ncodigo
												and pr.PEcodigo = pv.PEcodigo
												and pr.PRactivo = 1
												order by n.Norden,g.Gorden"
										desplegar="PRdescripcion"
										etiquetas="Descripci&oacute;n"
										formatos="S"
										align="left"
										asignar="PRcodigo,PRdescripcion,SPEcodigo,Gcodigo,noGroup,noAlumn"
										asignarformatos="I,S,I,I,I,I"
										Form="formAlumno"
										Conexion="#Session.Edu.DSN#"
										funcion="document.formAlumno.submit()"
									>  
								</cfif>
							</td>
						</tr>
						
						<cfif isdefined("codPromocion") and len(trim(codPromocion)) and isdefined("codEstudiante") and len(trim(codEstudiante))>
							<tr class="tituloListas">
								<td>
									<strong>Alumno</strong>&nbsp;
								</td>
								<td>
	
										<!--- pinta el conlis con valores del registro seleccionado --->
										<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
									<cfif isdefined("codEstudiante")and isdefined("rsAlumnoActual.Pnombre") and isdefined("rsAlumnoActual.Papellido1")and isdefined("rsAlumnoActual.Papellido2")
										 and len(trim(codEstudiante))and len(trim(rsAlumnoActual.Pnombre))and len(trim(rsAlumnoActual.Papellido1))and len(trim(rsAlumnoActual.Papellido2))>
												<cfset array2 = ArrayNew(1)>
												<cfset temp = ArraySet(array2, 1,6, "null")>
												<cfset array2[1] = codEstudiante>    
												<cfset array2[2] = rsAlumnoActual.Pnombre>
												<cfset array2[3] = rsAlumnoActual.Papellido1>
												<cfset array2[4] = rsAlumnoActual.Papellido2>
												<cfset array2[5] = 1>
												<cfset array2[6] = 0>
												
										<cf_conlis 
											title="Alumno"
											campos = "Ecodigo,Pnombre,Papellido1,Papellido2,noGroup2,noAlumn2" 
											desplegables = "N,S,S,S,N,N" 
											modificables = "N,S,S,S,N,N"
											size = "0,10,15,15,0,0"
											tabla="Alumnos a, PersonaEducativo p"
											columnas="	a.Ecodigo,
														p.Pid,
														p.Pnombre,
														p.Papellido1, 
														p.Papellido2,
														1 as noGroup2,
														0 as noAlumn2"
											filtro="a.CEcodigo=#Session.Edu.CEcodigo#
													and a.PRcodigo=#codPromocion#
													and a.persona = p.persona
													and a.Aretirado = 0
													order by Papellido1,Papellido2,Pnombre"
											desplegar="Pnombre,Papellido1,Papellido2"
											etiquetas="Nombre,Apellido1,Apellido2"
											formatos="S,S,S"
											align="left,left,left"
											asignar="Ecodigo, Pnombre, Papellido1, Papellido2, noGroup2, noAlumn2"
											asignarformatos="I,S,S,S,I,I"
											Form="formAlumno"
											Conexion="#Session.Edu.DSN#"
											funcion="document.formAlumno.submit()"
											valuesArray="#array2#"
										> 
									<cfelse>
											<cfset array2 = ArrayNew(1)>
											<cfset temp = ArraySet(array2, 1,6, "null")>
											<cfloop query="rsAlumnos">
												<cfset array2[1] = rsAlumnos.Ecodigo>    
												<cfset array2[2] = rsAlumnos.Pnombre>
												<cfset array2[3] = rsAlumnos.Papellido1>
												<cfset array2[4] = rsAlumnos.Papellido2>
												<cfbreak>
											</cfloop>
											<cfset array2[5] = 1>
											<cfset array2[6] = 0>
											<cf_conlis 
											title="Alumno"
											campos = "Ecodigo,Pnombre,Papellido1,Papellido2,noGroup2,noAlumn2" 
											desplegables = "N,S,S,S,N,N" 
											modificables = "N,S,S,S,N,N"
											size = "0,10,15,15,0,0"
											tabla="Alumnos a, PersonaEducativo p"
											columnas="	a.Ecodigo,
														p.Pid,
														p.Pnombre,
														p.Papellido1, 
														p.Papellido2,
														1 as noGroup2,
														0 as noAlumn2"
											filtro="a.CEcodigo=#Session.Edu.CEcodigo#
													and a.PRcodigo=#codPromocion#
													and a.persona = p.persona
													and a.Aretirado = 0
													order by Papellido1,Papellido2,Pnombre"
											desplegar="Pnombre,Papellido1,Papellido2"
											etiquetas="Nombre,Apellido1,Apellido2"
											formatos="S,S,S"
											align="left,left,left"
											asignar="Ecodigo,Pnombre,Papellido1,Papellido2,noGroup2,noAlumn2"
											asignarformatos="I,S,S,S,I,I"
											Form="formAlumno"
											Conexion="#Session.Edu.DSN#"
											funcion="document.formAlumno.submit()"
											valuesArray="#array2#"
										>  
									</cfif> 
								</td>
							</tr>
							<tr class="tituloListas">
								<td>
									 <strong>Grupo</strong>&nbsp;
								</td>
								<td>
									<cfif isdefined("codPromocion") AND isdefined("codEstudiante") AND isdefined("codGrupo")>								  
									  <select name="GRcodigo" onChange="javascript:formAlumno.submit();">
										<cfoutput query="rsGrupos">
										  <option value="#rsGrupos.GRcodigo#"
										  <cfif isdefined("codGrupo") AND codGrupo EQ rsGrupos.GRcodigo>selected</cfif>>
											#rsGrupos.GRnombre#
										  </option>
										</cfoutput>
									  </select>
									 </cfif>
								</td>
							 </tr>
						 </cfif>
					   </form>
					   <tr>
							<td  colspan="2" valign="top" align="center">
								<!--- FORM --->
								<table  width="100%" border="0" cellspacing="0" cellpadding="0">
									  <cfif isdefined("codPromocion") AND isdefined("codEstudiante") AND isdefined("codGrupo")>
									  <tr class="tituloListas"><td><b>Cursos Regulares</b></td></tr>
									  <tr>
										<td>
										  <table border="0" cellspacing="0" cellpadding="0" width="100%">
											<tr>
											  <td class="tituloListas"><strong>Curso</strong></td>
											  <td class="tituloListas"><strong>Materia</strong></td>
											  <td class="tituloListas"><strong>&nbsp;</strong></td>
											</tr>
											<cfset elemPar = false>
											<cfoutput query="rsCursos">
											  <tr class="<cfif elemPar>listaPar<cfelse>listaNon</cfif>">
												<td>#rsCursos.Cnombre#</td>
												<td>#rsCursos.Mnombre#</td>
												<td>
												  <cfif rsCursos.Cmatriculado IS 0>
													<img src="../../Imagenes/Cferror.gif" border="0">
												  <cfelse>
													<img src="../../Imagenes/completa.gif" border="0">
												  </cfif>
												</td>
											  </tr>
											  <cfset elemPar = not elemPar>
											</cfoutput>
										  </table>
										</td>
									  </tr>
									  <form name="formMatricula" method="post" action="SQLMatriculaInd.cfm" onSubmit="return valida(this)">
									  <tr><td><b>Cursos Electivos</b></td></tr>
									  <tr>
										<td>
										  <table border="0" cellspacing="0" cellpadding="0" width="70%">
											<tr>
											  <td class="tituloListas"><strong>Electiva</strong></td>
											  <td class="tituloListas"><strong>Sustitutiva</strong></td>
											  <td class="tituloListas"><strong>&nbsp;</strong></td>
											</tr>
											<cfset elemPar = false>
											<cfset codCurso = 0>
											<cfset matriculado = false>
											<cfoutput query="rsElectivas">
											  <cfif rsElectivas.Ccodigo IS NOT codCurso>
											  <cfif codCurso IS NOT 0>
												</select>
												</td>
												<td>
												  <cfif matriculado>
													<img src="../../Imagenes/completa.gif" border="0">
												  <cfelse>
													<img src="../../Imagenes/Cferror.gif" border="0">
												  </cfif>
												</td>
											  </tr>
											  </cfif>
											  <cfset matriculado = false>
											  <cfif rsElectivas.Cmatriculado IS 1>
												<cfset matriculado = true>
											  </cfif>
											  <cfset codCurso = rsElectivas.Ccodigo>
											  <tr class="<cfif elemPar>listaPar<cfelse>listaNon</cfif>">
												<input type="hidden" name="Ccodigo" value="#rsElectivas.Ccodigo#">
												<td>#rsElectivas.Cnombre#</td>
												<td>
												<select name="Scodigo">
												  <option value="#rsElectivas.Scodigo#"
												  <cfif rsElectivas.Cmatriculado IS 1>selected</cfif>>
												  #rsElectivas.Snombre#
												  </option>
											  <cfset elemPar = NOT elemPar>
											  <cfelse>
												<cfif rsElectivas.Cmatriculado IS 1>
													<cfset matriculado = true>
												</cfif>
												<option value="#rsElectivas.Scodigo#"
												<cfif rsElectivas.Cmatriculado IS 1>selected</cfif>>
												#rsElectivas.Snombre#
												</option>
											  </cfif>
											</cfoutput>
											<cfif rsElectivas.RecordCount IS NOT 0>
												</select>
												</td>
												<td>
												  <cfif matriculado>
													<img src="../../Imagenes/completa.gif" border="0">
												  <cfelse>
													<img src="../../Imagenes/Cferror.gif" border="0">
												  </cfif>
												</td>
											  </tr>
											</cfif>
										  </table>
										</td>
									  </tr>
									  <tr>
										<td>
										<div style="text-align:center">
										<input type="hidden" name="PRcodigo" value="<cfoutput>#codPromocion#</cfoutput>">
										<input type="hidden" name="Ecodigo" value="<cfoutput>#codEstudiante#</cfoutput>">
										<input type="hidden" name="GRcodigo" value="<cfoutput>#codGrupo#</cfoutput>">
										<input type="submit" name="btnAceptar" value="Matricular" onClick="javascript:setBtn(this)">
										<cfif isdefined("codGrupoActual") AND codGrupoActual IS NOT 0>
											<input type="submit" name="btnDesmatricular" value="Desmatricular" onClick="javascript:setBtn(this)">
										</cfif>
										<input type="hidden" name="calificado"
											value="<cfoutput><cfif isdefined('calificado') AND calificado>1
											<cfelse>0</cfif></cfoutput>">
										</div>
										</td>
									  </tr>
									  </form>				
									  </cfif>
								</table>
							</td>
						</tr>
					</table>
				</td>
				<td width="40%" valign="top" align="left">
					<!--- SECCION QUE DESPLIEGA LOS MENSAJES --->
			  		<table width="90%" border="0" cellspacing="0" cellpadding="0">
					  <cfif isdefined("rsGrupos")>
						  <cfoutput query="rsGrupos">
								<cfif rsGrupos.GRactual IS NOT 0>
								<tr><td>
									<cf_web_portlet titulo="<cfoutput>Mensaje</cfoutput>">
										El alumno ya se encuentra matriculado en el grupo
										"#rsGrupos.GRnombre#".
										Si ud. ejecuta la matr&iacute;cula el alumno va a ser matriculado de nuevo.
									</cf_web_portlet>
								</td></tr>
								<tr><td>&nbsp;</td></tr>
								</cfif>
						  </cfoutput>
						  <cfif NOT isdefined("codGrupoActual") OR codGrupoActual IS 0>
								<tr><td>
									<cf_web_portlet titulo="<cfoutput>Mensaje</cfoutput>">
										El alumno no se encuentra matriculado en ning&uacute;n grupo.
									</cf_web_portlet>
								</td></tr>
								<tr><td>&nbsp;</td></tr>
						  </cfif>
						  <cfoutput query="rsGrupos">
							<cfif isdefined("codGrupo") AND codGrupo EQ rsGrupos.GRcodigo>
								<cfif (rsGrupos.GRnalumnos GREATER THAN OR EQUAL TO rsGrupos.Gnalumnos)AND (rsGrupos.Gnalumnos GREATER THAN 0)AND (rsGrupos.GRnalumnos GREATER THAN rsGrupos.Gnalumnos OR rsGrupos.GRactual IS 0)>
									<tr>
									  <td>
										  <cf_web_portlet titulo="<cfoutput>Mensaje</cfoutput>">
											  <strong>ATENCION:</strong> este grupo ya ha alcanzado el m&aacute;ximo 
											  n&uacute;mero de alumnos por grupo.
											  Se recomienda crear m&aacute;s grupos.
										  </cf_web_portlet>
									  </td>
									</tr>
									<tr><td>&nbsp;</td></tr>
								</cfif>
						    </cfif>
						 </cfoutput>
						  <cfif isdefined("calificado") AND calificado>
							  <tr><td>
									<cf_web_portlet titulo="<cfoutput>Mensaje</cfoutput>">
										<strong>ATENCION:</strong> este alumno ya ha sido calificado.
										Si se corre este proceso se perder&aacute;n las notas.
									</cf_web_portlet>
							  </td></tr>
							  <tr><td>&nbsp;</td></tr>
						  </cfif>
					  </cfif>
					</table>
				</td>
			 </tr>
           </table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>