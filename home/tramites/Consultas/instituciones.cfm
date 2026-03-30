<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Consulta de Instituciones
	</cf_templatearea>

	<cf_templatearea name="body">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consulta de Instituciones">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		
			<!--- Parametros de la Pantalla --->
			<cfparam name="url.tab" default="1">
			
			<cfif isdefined("Url.tab") and Len(Trim(Url.tab))>
				<cfparam name="form.tab" default="#Url.tab#">
			</cfif>
			<cfif isdefined("Url.id_inst") and Len(Trim(Url.id_inst))>
				<cfparam name="form.id_inst" default="#Url.id_inst#">
			</cfif>
			<cfinclude template="instituciones-header.cfm">
		
			<!--- Lista de Instituciones o Pantalla de Tabs --->
			<table width="99%" border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td>
					<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst))>
						<cfinclude template="instituciones-form.cfm">
					<cfelse>
						<cfinclude template="instituciones-lista.cfm">
					</cfif>
				</td>
			  </tr>
			</table>
		
		<cf_web_portlet_end>
	
	</cf_templatearea>
</cf_template>
