<!--- <cfif not isdefined("Form.GRcodigo")>
	<cflocation url="MatriculaMasiva.cfm?PRcodigo=#form.PRcodigo#&PRdescripcion=#form.PRdescripcion#&SPEcodigo=#form.SPEcodigo#,&Gcodigo=#form.Gcodigo#&Gnalumnos=#form.Gnalumnos#&Gngrupos=#form.Gngrupos#&PRalumnos=#form.PRalumnos#">
</cfif> --->

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
			
			 <!--- MATRICULA --->	
			<cfif isdefined("Form.btnAceptar")>
				<cfset grupos = "">
				<cfif isdefined("Form.GRcodigo")>
					<cfset grupos=#Form.GRcodigo# & ",">
				</cfif>
				<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_MatriculaMasiva">
					<cfprocparam type="in" dbvarname="@CEcodigo" cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					<cfprocparam type="in" dbvarname="@PRcodigo" cfsqltype="cf_sql_numeric" value="#Form.PRcodigo#">
					<cfif isdefined("Form.GRcodigo")>
						<cfprocparam type="in" dbvarname="@GRcodigo" cfsqltype="cf_sql_varchar" value="#grupos#">
					</cfif>
				</cfstoredproc>
			
			<!--- DESMATRICULA --->
			<cfelseif isdefined("Form.btnDesmatricular")>
					<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_DesmatriculaMasiva">
						<cfprocparam type="in" dbvarname="@CEcodigo" cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						<cfprocparam type="in" dbvarname="@PRcodigo" cfsqltype="cf_sql_numeric" value="#Form.PRcodigo#">
					</cfstoredproc>
			</cfif>
			
			<center>
				  <table border="0" cellpadding="5" cellspacing="3">
				  <tr><td align="center" valign="middle">
						  <cfif isdefined("Form.btnAceptar")>
								<strong>Alumnos matriculados en forma exitosa</strong>
						  <cfelse>
								<strong>Alumnos desmatriculados en forma exitosa</strong>
						  </cfif>
				  </td></tr>
				  <tr><td align="center">
				  		<cfoutput>
						<form name="formAceptar" action="MatriculaMasiva.cfm" method="post">
						<input type="hidden" name="PRcodigo" value="#Form.PRcodigo#">
						<!--- VARIBLES DEFINIDAS PARA CUANDO VOLVEMOS A LA PANTALLA PRINCIPAL PARA QUE NO PIERDA LA PROMOCIÓN --->
						<input type="hidden" name="PRdescripcion" id="PRdescripcion" value="#form.PRdescripcion#"/>
						<input type="hidden" name="SPEcodigo" id="SPEcodigo" value="#form.SPEcodigo#"/>
						<input type="hidden" name="Gcodigo" id="Gcodigo" value="#form.Gcodigo#"/>
						<input type="hidden" name="Gnalumnos" id="Gnalumnos" value="#form.Gnalumnos#"/>
						<input type="hidden" name="Gngrupos" id="Gngrupos" value="#form.Gngrupos#"/>
						<input type="hidden" name="PRalumnos" id="PRalumnos" value="#form.PRalumnos#"/>
						<input type="submit" name="btnAceptar" value="Aceptar">
						</form>
						</cfoutput>
				  </td></tr>
				 </table>
			</center>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>