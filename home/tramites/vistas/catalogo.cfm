<cf_template>
	<cf_templatearea name="title">
		Registro de Cat&aacute;logos
	</cf_templatearea>

	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="Registro de Cat&aacute;logos">
			<cfinclude template="/home/menu/pNavegacion.cfm">

			<cfif isdefined("Url.btnNuevo") and Len(Trim(Url.btnNuevo))>
				<cfparam name="Form.btnNuevo" default="#Url.btnNuevo#">
			</cfif>
			<cfif isdefined("Url.id_vista") and Len(Trim(Url.id_vista))>
				<cfparam name="Form.id_vista" default="#Url.id_vista#">
			</cfif>
			<cfif isdefined("Url.id_tipo") and Len(Trim(Url.id_tipo))>
				<cfparam name="Form.id_tipo" default="#Url.id_tipo#">
			</cfif>

			<cfif (isdefined("Form.btnNuevo") 
				  and isdefined("Form.id_vista") and Len(Trim(Form.id_vista)) and Form.id_vista NEQ "-1"
			      and isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))
			) or (
				  isdefined("Form.id_vista") and Len(Trim(Form.id_vista)) and Form.id_vista NEQ "-1"
			      and isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))
			      and isdefined("Form.id_registro") and Len(Trim(Form.id_registro))
			)>
				<cfinclude template="catalogo-form.cfm">
			<cfelse>
				<cfinclude template="catalogo-lista.cfm">
			</cfif>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
