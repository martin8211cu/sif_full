<cfparam name="modo" 	 	  	 		 default="ALTA">
<cfparam name="rsConsulta.TGcodigo" 	 		 default="">
<cfparam name="rsConsulta.TGdescripcion" 		 default="">
<cfparam name="rsConsulta.TGporcentaje" 	 		 default="">

<cfif (isdefined('form.TGid') and len(trim(form.TGid)) GT 0) or (isdefined('url.TGid') and len(trim(url.TGid)))>
	<cfset modo = "CAMBIO">
	<cfif not isdefined('form.TGid') or len(trim(form.TGid)) EQ 0>
		<cfset form.TGid = url.TGid>
	</cfif>
</cfif>

<cf_templateheader title="Tipos de Garantía">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tipos de Garantía">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="65%" valign="top">
						<cfinclude  template="TipoGarantia_lista.cfm">
				  </td>
					<td width="35%">
						<cfinclude  template="TipoGarantia_form.cfm">
				  </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>