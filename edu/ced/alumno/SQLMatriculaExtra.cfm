
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
		<!---<cfset Request.Error.Url = "MatriculaExtra.cfm?PRcodigo=#Form.PRcodigo#&Ecodigo=#Form.Ecodigo#&GRcodigo=#Form.GRcodigo#">--->
		<cfif isdefined("Form.checkAlumno")>
			<cfset indices = Replace(Form.checkAlumno,chr(44)," ","all")>
			<cfset codigos = Replace(Form.Ecodigo,chr(44)," ","all")>
			<cfif isdefined("Form.Csustituto")>
				<cfset codigosSustitutivos = Replace(Form.Csustituto,chr(44)," ","all")>
			</cfif>
			<cfset index = 1>
			<cfset codIndice = GetToken(indices,index)>
			
			<cfloop condition="codIndice NEQ ''">
			
				<cfset codEstudiante = GetToken(codigos,Val(codIndice))>
				<cfif isdefined("Form.CursoElectivo") and Form.CursoElectivo NEQ 0>
					<cfset codSustitutivo = GetToken(codigosSustitutivos,Val(codIndice))>
				</cfif>
				
				<cftransaction>
					<cfquery datasource="#Session.Edu.DSN#" name="updMatriculaExt">
						insert into AlumnoCalificacionCurso (CEcodigo,Ecodigo,Ccodigo,ACCelectiva)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEstudiante#">,
								<cfif isdefined("Form.CursoElectivo") and Form.CursoElectivo NEQ 0>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#codSustitutivo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">)
								<cfelse>			
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
									,null)
								</cfif>
					</cfquery>
				</cftransaction>
				<cfset index = index + 1>
				<cfset codIndice = GetToken(indices,index)>
			</cfloop>
		  </cfif>
		  
		  <center>
		  <table border="0" cellpadding="5" cellspacing="3">
			  <tr align="center"><td align="center" valign="middle"><strong>Alumnos matriculados en forma exitosa</strong></td></tr>
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
					</form>
			  </td></tr>
			  </table>
		 </center>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>