<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Consulta de Funcionarios
	</cf_templatearea>

	<cf_templatearea name="body">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consulta de Funcionarios">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		
			<!--- Parametros de la Pantalla --->
			<cfparam name="url.tab" default="1">
			
			<cfif isdefined("Url.tab") and Len(Trim(Url.tab))>
				<cfparam name="form.tab" default="#Url.tab#">
			</cfif>
			<cfif isdefined("Url.id_inst") and Len(Trim(Url.id_inst))>
				<cfparam name="form.id_inst" default="#Url.id_inst#">
			</cfif>
			<cfif isdefined("Url.id_funcionario") and Len(Trim(Url.id_funcionario))>
				<cfparam name="form.id_funcionario" default="#Url.id_funcionario#">
			</cfif>
			<cfinclude template="funcionarios-header.cfm">
		
			<!--- Lista de Funcionarios o Pantalla de Tabs --->
			<table width="99%" border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td>
					<cfif isdefined("Form.id_funcionario") and Len(Trim(Form.id_funcionario))>
						<cfinclude template="funcionarios-form.cfm">
					<cfelse>
						<cfinclude template="funcionarios-lista.cfm">
					</cfif>
				</td>
			  </tr>
			</table>
		
		<cf_web_portlet_end>
	
	</cf_templatearea>
</cf_template>
