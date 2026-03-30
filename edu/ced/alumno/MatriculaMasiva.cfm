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
				<!--- FUNCIONES PARA EL MANEJO DE BOTONES --->
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
			<!---------CONSULTAS-------------->
			<!--- CONSULTAS DE PROMOCIONES --->
			<cfquery datasource="#Session.Edu.DSN#" name="rsPromociones">
				Set nocount on
				Select distinct PRcodigo=convert(varchar,pr.PRcodigo),
				PRdescripcion= pr.PRdescripcion + ' : ' + g.Gdescripcion, 
				SPEcodigo=convert(varchar,pv.SPEcodigo), Gcodigo=convert(varchar,pr.Gcodigo), g.Gnalumnos,
				Gngrupos=(select count(GRcodigo) from Grupo where Gcodigo=pr.Gcodigo and SPEcodigo=pv.SPEcodigo ),
				PRalumnos=(select count(Ecodigo) from Alumnos where PRcodigo=pr.PRcodigo and CEcodigo=n.CEcodigo)
				from Promocion pr, Nivel n, PeriodoVigente pv, Grado g
				where n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and pr.Ncodigo = n.Ncodigo
				and pr.Ncodigo = pv.Ncodigo
				and pr.PEcodigo = pv.PEcodigo
				and pr.Gcodigo = g.Gcodigo
				and pr.PRactivo = 1
				order by n.Norden,g.Gorden
				Set nocount off
			</cfquery>
			<cfloop query="rsPromociones">
				<cfset codPromocion=#rsPromociones.PRcodigo#>
				<cfbreak>
			</cfloop>
			<cfif isdefined("Form.PRcodigo")>
				<cfset codPromocion=#Form.PRcodigo#>
			</cfif>

			<cfif isdefined("codPromocion")>
				<!--- CONSULTAS DE GRUPOS --->
				<cfquery datasource="#Session.Edu.DSN#" name="rsGruposAnteriores">
					Set nocount on
					Select distinct GRcodigo=convert(varchar,gr.GRcodigo),gr.GRnombre
					from Grupo gr, Grado g, Nivel n, Promocion pr, PeriodoVigente pv,SubPeriodoEscolar spe
					where n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and pr.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
					and pr.Ncodigo = n.Ncodigo
					and pr.Ncodigo = pv.Ncodigo
					and pr.PEcodigo = pv.PEcodigo
					and g.Gpromogrado = pr.Gcodigo
					and gr.Gcodigo = g.Gcodigo
					and spe.PEcodigo = gr.PEcodigo
					and spe.SPEcodigo = gr.SPEcodigo
					and spe.SPEorden < (select SPEorden from SubPeriodoEscolar
						where PEcodigo=pv.PEcodigo and SPEcodigo=pv.SPEcodigo)
					and not exists (select * from SubPeriodoEscolar spea
						where spea.PEcodigo = gr.PEcodigo
						and spe.SPEorden < spea.SPEorden
						and spea.SPEorden < (select SPEorden from SubPeriodoEscolar
							where PEcodigo=pv.PEcodigo and SPEcodigo=pv.SPEcodigo))
					order by GRcodigo
					Set nocount off
				</cfquery>
	
				<cfquery datasource="#Session.Edu.DSN#" name="rsGrupos">
					Set nocount on
					Select distinct GRcodigo=convert(varchar,gr.GRcodigo), gr.GRnombre
					from Grupo gr, Nivel n, Promocion pr, PeriodoVigente pv, GrupoAlumno gra, Alumnos a
					where n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and pr.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
					and a.PRcodigo = pr.PRcodigo
					and gra.Ecodigo=a.Ecodigo
					and gr.Ncodigo = n.Ncodigo
					and gr.Ncodigo = pr.Ncodigo
					and gr.Gcodigo = pr.Gcodigo
					and pr.Ncodigo = pv.Ncodigo
					and pr.PEcodigo = pv.PEcodigo
					and gr.PEcodigo = pv.PEcodigo
					and gr.SPEcodigo = pv.SPEcodigo
					and gr.GRcodigo = gra.GRcodigo
					order by GRnombre
					Set nocount off
				</cfquery>
				<cfset hayGrupos=false>
				<cfloop query="rsGrupos">
					<cfset hayGrupos=true>
					<cfbreak>
				</cfloop>
					
				<cfquery datasource="#Session.Edu.DSN#" name="rsCalificado">
					Set nocount on
					Select PEcodigo=convert(varchar,acpe.PEcodigo)
					from Curso c, Promocion pr, Nivel n, PeriodoVigente pv, Alumnos a,
					AlumnoCalificacionPerEval acpe
					where c.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and pr.PRcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codPromocion#">
					and acpe.Ecodigo = a.Ecodigo
					and a.PRcodigo = pr.PRcodigo
					and c.SPEcodigo = pv.SPEcodigo
					and pr.Ncodigo = n.Ncodigo
					and pr.Ncodigo = pv.Ncodigo
					and pr.PEcodigo = pv.PEcodigo
					and c.Ccodigo = acpe.Ccodigo
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
					<cfif not isdefined("form.PRcodigo")>
						alert("Debe seleccionar la promoción");
						return false;
					</cfif>
					
					<!--- CON ESTE CODIGO SE VALIDA QUE EL AL MENOS UN CHECKBOX ESTE ACTIVO, PERO LO COMENTE POR QUE LA PANTALLA ANTERIORMENTE NO HACIA ESTA VALIDACION Y AL PARECER NO LE IMPORTA QUE NO QUE NO HAYAN CHECKBOX ACTIVOS, Y ADEMAS EN EL SQL REALIZA UNA PROCEDIMIENTO CUANDO NO ESTAN DEFINODOS CHECKBOX ACTIVOS --->
					if (document.formMatricula.GRcodigo.checked == false) {
						alert("Debe eligir al menos un grupo");
						return false;
					} 
					if (formulario.calificado.value == "1") {
						if (!confirm("Se van a perder las notas de la promoción.  Desea continuar?")) {
							return false;
						}
					}
					return true;
				}
		    </script>
			
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2" valign="top">
					
					<table  width="100%" border="0" cellspacing="0" cellpadding="0">
						<!--- OPCIONES PARA EL ENCABEZADO --->
						<tr class="tituloListas"><td  align="right" valign="midle">
							<strong>Promoci&oacute;n</strong>
						</td>
						<td valign="top">
							<form name="formPromocion" method="post" action="MatriculaMasiva.cfm" style="margin:0">
								
							  	 <cfif isdefined("Form.PRcodigo") and isdefined("form.PRdescripcion") 
								 		and isdefined("form.SPEcodigo") and isdefined("form.Gcodigo") 
								 		and isdefined("form.Gnalumnos") and isdefined("form.Gngrupos") 
										and isdefined("form.PRalumnos")>
									<cf_conlis 
										title="Promociones"
										campos = "PRcodigo,PRdescripcion,SPEcodigo,Gcodigo,Gnalumnos,Gngrupos,PRalumnos" 
										desplegables = "N,S,N,N,N,N,N" 
										modificables = "N,S,N,N,N,N,N"
										size = "0,60,0,0,0,0,0"
										tabla="Promocion pr, Nivel n, PeriodoVigente pv, Grado g"
										columnas="pr.PRcodigo,
													pr.PRdescripcion + ' : ' + g.Gdescripcion as PRdescripcion, 
													pv.SPEcodigo, pr.Gcodigo, g.Gnalumnos,
													(select count(x.GRcodigo) from Grupo x  where x.Gcodigo=pr.Gcodigo and x.SPEcodigo= pv.SPEcodigo )as Gngrupos,
													(select count(z.Ecodigo) from Alumnos z where z.PRcodigo=pr.PRcodigo and z.CEcodigo= n.CEcodigo)as PRalumnos"
										filtro="n.CEcodigo=#Session.Edu.CEcodigo#
												and pr.Ncodigo = n.Ncodigo
												and pr.Ncodigo = pv.Ncodigo
												and pr.PEcodigo = pv.PEcodigo
												and pr.Gcodigo = g.Gcodigo
												and pr.PRactivo = 1
												order by n.Norden,g.Gorden"
										desplegar="PRdescripcion"
										etiquetas="Descripci&oacute;n"
										formatos="S"
										align="left"
										asignar="PRcodigo,PRdescripcion,SPEcodigo,Gcodigo,Gnalumnos,Gngrupos,PRalumnos"
										asignarformatos="I,S,I,I,I,I,I"
										Form="formPromocion"
										Conexion="#Session.Edu.DSN#"
										funcion="document.formPromocion.submit()"
										values ="(#form.PRcodigo#,#form.PRdescripcion#,#form.SPEcodigo#,#form.Gcodigo#,#form.Gnalumnos#,#form.Gngrupos#,#form.PRalumnos#)"
									> 
								<cfelse>
									<cf_conlis 
										title="Promociones"
										campos = "PRcodigo,PRdescripcion,SPEcodigo,Gcodigo,Gnalumnos,Gngrupos,PRalumnos" 
										desplegables = "N,S,N,N,N,N,N" 
										modificables = "N,S,N,N,N,N,N"
										size = "0,70,0,0,0,0,0"
										tabla="Promocion pr, Nivel n, PeriodoVigente pv, Grado g"
										columnas="pr.PRcodigo,
													pr.PRdescripcion + ' : ' + g.Gdescripcion as PRdescripcion, 
													pv.SPEcodigo, pr.Gcodigo, g.Gnalumnos,
													(select count(x.GRcodigo) from Grupo x  where x.Gcodigo=pr.Gcodigo and x.SPEcodigo= pv.SPEcodigo )as Gngrupos,
													(select count(z.Ecodigo) from Alumnos z where z.PRcodigo=pr.PRcodigo and z.CEcodigo= n.CEcodigo)as PRalumnos"
										filtro="n.CEcodigo=#Session.Edu.CEcodigo#
												and pr.Ncodigo = n.Ncodigo
												and pr.Ncodigo = pv.Ncodigo
												and pr.PEcodigo = pv.PEcodigo
												and pr.Gcodigo = g.Gcodigo
												and pr.PRactivo = 1
												order by n.Norden,g.Gorden"
										desplegar="PRdescripcion"
										etiquetas="Descripci&oacute;n"
										formatos="S"
										align="left"
										asignar="PRcodigo,PRdescripcion,SPEcodigo,Gcodigo,Gnalumnos,Gngrupos,PRalumnos"
										asignarformatos="I,S,I,I,I,I,I"
										Form="formPromocion"
										Conexion="#Session.Edu.DSN#"
										funcion="document.formPromocion.submit()"
									> 
								</cfif>
							 </form>
						 </td></tr>
						 <tr class="tituloListas"><td align="left" colspan="2"><strong>Grupos</strong></td></tr>
						 <tr><td width="50%" valign="top" align="center" colspan="2">
								<!--- FORM --->
								<table  width="100%" cellpadding="0" cellspacing="0" border="0">
									  
									  <cfif isdefined("codPromocion")>
										   <form name="formMatricula" method="post" action="SQLMatriculaMas.cfm" onSubmit="return valida(this)">
										   		
												<!--- VARIABLES QUE VAN A SER ENVIADAS AL SQL --->
												 <cfif isdefined("Form.PRcodigo") and isdefined("form.PRdescripcion")and isdefined("form.SPEcodigo") and isdefined("form.Gcodigo") 
								 						and isdefined("form.Gnalumnos") and isdefined("form.Gngrupos")and isdefined("form.PRalumnos")>
													<cfoutput>
													<input type="hidden" name="PRdescripcion" id="PRdescripcion" value="#form.PRdescripcion#"/>
													<input type="hidden" name="SPEcodigo" id="SPEcodigo" value="#form.SPEcodigo#"/>
													<input type="hidden" name="Gcodigo" id="Gcodigo" value="#form.Gcodigo#"/>
													<input type="hidden" name="Gnalumnos" id="Gnalumnos" value="#form.Gnalumnos#"/>
													<input type="hidden" name="Gngrupos" id="Gngrupos" value="#form.Gngrupos#"/>
													<input type="hidden" name="PRalumnos" id="PRalumnos" value="#form.PRalumnos#"/>
													</cfoutput>
											    </cfif>
												<cfif rsGruposAnteriores.RecordCount IS NOT 0>
													<cfoutput query="rsGruposAnteriores">
													   <tr><td><input type="checkbox" name="GRtodos" value="-1" onClick="javascript:checkTodos()"><strong>Todos</strong></td></tr>
													   <tr><td>
														<input type="checkbox" name="GRcodigo" value="#rsGruposAnteriores.GRcodigo#" >
														#rsGruposAnteriores.GRnombre#
													   </td></tr>
													</cfoutput>
												</cfif>
									   
										  	<tr><td>
												<div style="text-align:center">
												<input type="hidden" name="PRcodigo" value="<cfoutput>#codPromocion#</cfoutput>">
												<input type="submit" name="btnAceptar" value="Matricular" onClick="javascript:setBtn(this)">
												<cfif isdefined("hayGrupos") AND hayGrupos>
													<input type="submit" name="btnDesmatricular" value="Desmatricular" onClick="javascript:setBtn(this)">
												</cfif>
												<input type="hidden" name="calificado"
													value="<cfoutput><cfif isdefined('calificado') AND calificado>1
													<cfelse>0</cfif></cfoutput>">
												</div>
										  	</td></tr>
										  	</form>
									  </cfif>
								</table>
						 </td></tr>
					</table>
				</td>
			    <td width="50%" align="center" valign="top">
						<!--- SECCION QUE DESPLIEGA LOS MENSAJES --->
						<table  width="90%" cellpadding="0" cellspacing="0" border="0">
			  				  <cfoutput query="rsPromociones">
								<cfif isdefined("codPromocion") AND codPromocion EQ rsPromociones.PRcodigo>
									<cfif rsPromociones.Gngrupos IS 0>
										<cf_web_portlet titulo="<cfoutput>No hay grupos</cfoutput>" tipo="normal">
											<tr><td><strong>ATENCION:</strong> No hay grupos en el curso lectivo actual
											para efectuar la matr&iacute;cula de esta promoci&oacute;n. Proceda a crear grupos.</td></tr>
											<tr><td>&nbsp;</td></tr>
										</cf_web_portlet>
									<cfelseif rsPromociones.PRalumnos IS 0>
										<cf_web_portlet titulo="<cfoutput>No hay estudiantes</cfoutput>" tipo="normal">
											<tr><td>No hay estudiantes asociados a esta promoci&oacute;n.</td></tr>
											<tr><td>&nbsp;</td></tr>
										</cf_web_portlet>
									<cfelseif rsPromociones.PRalumnos / rsPromociones.Gngrupos GREATER THAN rsPromociones.Gnalumnos AND rsPromociones.Gnalumnos IS NOT 0>
										<cf_web_portlet titulo="<cfoutput>Extención de número de estudiantes para el Grupo</cfoutput>" tipo="normal">
											<tr><td><strong>ATENCION:</strong> Se va a exceder el m&aacute;ximo n&uacute;mero
											de estudiantes por grupo.  Se recomienda crear m&aacute;s grupos.</td></tr>
											<tr><td>&nbsp;</td></tr>
										</cf_web_portlet>
									</cfif>
								</cfif>
							  </cfoutput>
							  
							  <cfif isdefined("hayGrupos") AND hayGrupos>
							  <tr>
								<td>
									<cf_web_portlet titulo="<cfoutput>Ya hay alumnos matrículados</cfoutput>" tipo="normal">
										Ya hay alumnos de esta promoci&oacute;n matriculados en grupos.
										Si se corre la matr&iacute;cula se volver&aacute;n a matricular.
									</cf_web_portlet>
								</td>
							  </tr>
							  <tr><td>&nbsp;</td></tr>
							  </cfif>
							  <cfif isdefined("calificado") AND calificado>
							  <tr>
								<td bordercolor="#0033FF" style="">
									<cf_web_portlet titulo="<cfoutput>Alerta: se perderán Notas</cfoutput>">
										<strong>ATENCION:</strong> Ya se han calificado alumnos de esta promoci&oacute;n.
										Si se ejecuta este proceso se perder&aacute;n las notas.
									</cf_web_portlet>
								</td>
							  </tr>
							  <tr><td>&nbsp;</td></tr>
							  </cfif>
							
						</table>	  
			  	  </td>
			   </tr>
			</table>
			<script type="text/javascript">
			function checkTodos() {
				for (var i = 0; i < formMatricula.elements.length; ++i)
					if (formMatricula.elements[i].type == "checkbox"
					&& formMatricula.elements[i].name == "GRcodigo") {
							formMatricula.elements[i].checked = formMatricula.GRtodos.checked;
					}
			}
			</script>
			
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>