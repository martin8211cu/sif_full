<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Mi Perfil
	</cf_templatearea>

	<cf_templatearea name="body">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Mi Perfil">
			<!--- Parametros de la Pantalla --->
			<cfparam name="url.tab" default="1">
			
			<cfif isdefined("Url.tab") and Len(Trim(Url.tab))>
				<cfparam name="form.tab" default="#Url.tab#">
			</cfif>
			<cfset form.id_inst = session.tramites.id_inst>
			<cfset form.id_funcionario = session.tramites.id_funcionario>
			<cfinclude template="funcionarios-header.cfm">
		
			<table width="99%" border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td>
					<cfinclude template="funcionarios-form.cfm">
				</td>
			  </tr>
			</table>
		
		<cf_web_portlet_end>
	
	</cf_templatearea>
</cf_template>
