<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	<!--- 
	Modificado por : Rodolfo Jimenez Jara
	Fecha: 06 de Enero de 2006
	Motivo: Creacion del reporte  --->

	
	<cf_templatearea name="body">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Consulta de Empleados Inactivos">
			<cfset modulo = "pp">
								
			<table width="100%" border="0" cellspacing="0">
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr>
				<td valign="top">
					<cfinclude template="EmpleAnualVac-form.cfm">
				</td>
			  </tr>
			</table>		
		<cf_web_portlet_end>
	</cf_templatearea>
	
</cf_template>
