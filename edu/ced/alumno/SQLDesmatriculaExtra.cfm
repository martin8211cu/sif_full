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
			 <cfif isdefined("Form.Ecodigo") AND isdefined("Form.Ccodigo")>
			<!--- Borrar registros --->
				<cftransaction>
					<cfquery datasource="#Session.Edu.DSN#">
						delete 	AlumnoCalificacion
						from 	AlumnoCalificacion ac, AlumnoCalificacionCurso acc 
						where 	ac.Ecodigo = acc.Ecodigo
								and ac.Ccodigo = acc.Ccodigo
								and ac.CEcodigo = acc.CEcodigo
								and acc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
								<cfif isdefined("Form.CursoElectivo") and Form.CursoElectivo IS NOT 0>
								and acc.ACCelectiva =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								<cfelse>
								and acc.Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								</cfif>
				
						delete	AlumnoCursoAsistencia
						from	AlumnoCursoAsistencia aca, AlumnoCalificacionCurso acc 
						where 	aca.Ecodigo = acc.Ecodigo
								and aca.Ccodigo = acc.Ccodigo
								and aca.CEcodigo = acc.CEcodigo
								and acc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
								<cfif isdefined("Form.CursoElectivo") and Form.CursoElectivo IS NOT 0>
								and acc.ACCelectiva =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								<cfelse>
								and acc.Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								</cfif>
				
						delete	AlumnoCursoObservacion
						from	AlumnoCursoObservacion aco, AlumnoCalificacionCurso acc 
								where aco.Ecodigo = acc.Ecodigo
								and aco.Ccodigo = acc.Ccodigo
								and aco.CEcodigo = acc.CEcodigo
								and acc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
								<cfif isdefined("Form.CursoElectivo") and Form.CursoElectivo IS NOT 0>
								and acc.ACCelectiva =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								<cfelse>
								and acc.Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								</cfif>
				
						delete	AlumnoCalificacionPerEval
						from	AlumnoCalificacionPerEval acpe, AlumnoCalificacionCurso acc 
						where 	acpe.Ecodigo = acc.Ecodigo
								and acpe.Ccodigo = acc.Ccodigo
								and acpe.CEcodigo = acc.CEcodigo
								and acc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
								<cfif isdefined("Form.CursoElectivo") and Form.CursoElectivo IS NOT 0>
								and acc.ACCelectiva =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								<cfelse>
								and acc.Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								</cfif>
				
						delete 	AlumnoCalificacionCurso
						where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
								<cfif isdefined("Form.CursoElectivo") and Form.CursoElectivo IS NOT 0>
								and ACCelectiva =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								<cfelse>
								and Ccodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								</cfif>
						</cfquery>
				</cftransaction>
			 </cfif>
			 <center> 
			  <table border="0" cellpadding="5" cellspacing="3">
				  <tr align="center"><td><strong>Alumno desmatriculado en forma exitosa</strong></td></tr>
				  <tr align="center"><td>
					<form name="formAceptar" action="MatriculaExtra.cfm" method="post">
					<cfif isdefined("Form.SPEcodigo")>
					<input type="hidden" name="SPEcodigo" value="<cfoutput>#Form.SPEcodigo#</cfoutput>">
					</cfif>
					<cfif isdefined("Form.Gcodigo")>
					<input type="hidden" name="Gcodigo" value="<cfoutput>#Form.Gcodigo#</cfoutput>">
					</cfif>
					<cfif isdefined("Form.GRcodigo")>
					<input type="hidden" name="GRcodigo" value="<cfoutput>#Form.GRcodigo#</cfoutput>">
					</cfif>
					<input type="hidden" name="Ccodigo" value="<cfoutput>#Form.Ccodigo#</cfoutput>">
					<input type="hidden" name="noGrado" value="<cfoutput>#Form.noGrado#</cfoutput>">
					<input type="hidden" name="noGrupo" value="<cfoutput>#Form.noGrupo#</cfoutput>">
					<input type="hidden" name="noCurso" value="<cfoutput>#Form.noCurso#</cfoutput>">
					<input type="submit" name="btnAceptar" value="Aceptar">
				  </form></td></tr>
			  </table>
			 </center>			 
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>	
			
		
