
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
			
			<cfset Request.Error.Url = "MatriculaIndividual.cfm?PRcodigo=#Form.PRcodigo#&Ecodigo=#Form.Ecodigo#&GRcodigo=#Form.GRcodigo#">
			<cfif isdefined("Form.btnAceptar")>
		  		<!--- MATRICULA --->
				<cfset electivas = "">
			 	<cfif isdefined("Form.Ccodigo")>
					<cfset electivas=#Form.Ccodigo# & ",">
			  	</cfif>
			  	
				<cfset sustitutivas = "">
			  	<cfif isdefined("Form.Scodigo")>
					<cfset sustitutivas=#Form.Scodigo# & ",">
			 	</cfif>
				
			  	<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_Matricular">
					<cfprocparam type="in" dbvarname="@PRcodigo" cfsqltype="cf_sql_numeric" value="#Form.PRcodigo#">
				  	<cfprocparam type="in" dbvarname="@Ecodigo" cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
				  	<cfprocparam type="in" dbvarname="@GRcodigo" cfsqltype="cf_sql_numeric" value="#Form.GRcodigo#">
				  	<cfif isdefined("Form.Ccodigo")>
						<cfprocparam type="in" dbvarname="@Ccodigo" cfsqltype="cf_sql_varchar" value="#electivas#">
				  	</cfif>
				  	<cfif isdefined("Form.Scodigo")>
						<cfprocparam type="in" dbvarname="@Scodigo" cfsqltype="cf_sql_varchar" value="#sustitutivas#">
				  	</cfif>
				</cfstoredproc>
			  
			<cfelseif isdefined("Form.btnDesmatricular")>
				<!--- DESMATRICULA --->  
				<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_Desmatricular">
			  		<cfprocparam type="in" dbvarname="@PRcodigo" cfsqltype="cf_sql_numeric" value="#Form.PRcodigo#">
			  		<cfprocparam type="in" dbvarname="@Ecodigo" cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
			  		</cfstoredproc>
			</cfif>
			 <center>
			   <table border="0" cellpadding="5" cellspacing="3">
				   <tr><td align="center" valign="middle">
					   <cfif isdefined("Form.btnAceptar")>
							<strong>Alumno matriculado en forma exitosa</strong>
					   <cfelse>
							<strong>Alumno desmatriculado en forma exitosa</strong>
					   </cfif>
					</td></tr>
					<tr><td>
						<form name="formAceptar" action="MatriculaIndividual.cfm" method="post">
						<input type="hidden" name="noGroup" value="1">
						<input type="hidden" name="noAlumn" value="0">
						<input type="hidden" name="PRcodigo" value="<cfoutput>#Form.PRcodigo#</cfoutput>">
						<input type="hidden" name="Ecodigo" value="<cfoutput>#Form.Ecodigo#</cfoutput>">
						<input type="hidden" name="GRcodigo" value="<cfoutput>#Form.GRcodigo#</cfoutput>">
						<center><input type="submit" name="btnAceptar" value="Aceptar"></center>
						</form>
					</td></tr>
			  </table>
			 </center>	
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>