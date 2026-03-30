
	<cf_templateheader title="Importaci&oacute;n de Reglas">
		<cfif isdefined("Url.btnImportar") and Len(Trim(Url.btnImportar))>
			<cfparam name="Form.btnImportar" default="#Url.btnImportar#">
		</cfif>
		<cfif isdefined("Url.PageNum") and Len(Trim(Url.PageNum))>
			<cfparam name="Form.PageNum" default="#Url.PageNum#">
		</cfif>
		<cfif isdefined("Url.PageNum_lista") and Len(Trim(Url.PageNum_lista))>
			<cfparam name="Form.PageNum_lista" default="#Url.PageNum_lista#">
		</cfif>
		<cfif isdefined("Url.PCREIid") and Len(Trim(Url.PCREIid))>
			<cfparam name="Form.PCREIid" default="#Url.PCREIid#">
		</cfif>
		<cfif isdefined("Url.PCRid") and Len(Trim(Url.PCRid))>
			<cfparam name="Form.PCRid" default="#Url.PCRid#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRid")>
			<cfparam name="Form.filtro_PCRid" default="#Url.filtro_PCRid#">
		</cfif>
		<cfif isdefined("Url.filtro_Cmayor")>
			<cfparam name="Form.filtro_Cmayor" default="#Url.filtro_Cmayor#">
		</cfif>
		<cfif isdefined("Url.filtro_Oformato")>
			<cfparam name="Form.filtro_Oformato" default="#Url.filtro_Oformato#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRregla")>
			<cfparam name="Form.filtro_PCRregla" default="#Url.filtro_PCRregla#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRvalida")>
			<cfparam name="Form.filtro_PCRvalida" default="#Url.filtro_PCRvalida#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRdesde")>
			<cfparam name="Form.filtro_PCRdesde" default="#Url.filtro_PCRdesde#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRhasta")>
			<cfparam name="Form.filtro_PCRhasta" default="#Url.filtro_PCRhasta#">
		</cfif>
		<cfif isdefined("Url.filtro_ErrVal")>
			<cfparam name="Form.filtro_ErrVal" default="#Url.filtro_ErrVal#">
		</cfif>
        <cfif isdefined("Url.filtro_PCRGcodigo")>
			<cfparam name="Form.filtro_PCRGcodigo" default="#Url.filtro_PCRGcodigo#">
		</cfif>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Reglas">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfif isdefined("Form.btnImportar")>
				<cfinclude template="ReglasImport-impform.cfm">
			<cfelseif isdefined("Form.PCREIid") and Len(Trim(Form.PCREIid))>
				<cfinclude template="ReglasImport-form.cfm">
			<cfelse>
				<cfinclude template="ReglasImport-lista.cfm">
			</cfif>
		<cf_web_portlet_end>

	<cf_templatefooter>

