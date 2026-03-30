<cfparam name="TiposVariaciones.FPTVCodigo" 	 default="">
<cfparam name="TiposVariaciones.FPTVDescripcion" default="">
<cfparam name="TiposVariaciones.FPTVTipo" 		 default="0">
<cfparam name="modo"       				  		 default="ALTA">
<cfif not isdefined('FORM.FPTVid') and isdefined('URl.FPTVid')>
	<cfset FORM.FPTVid = URL.FPTVid>
</cfif>
<cfif isdefined('FORM.FPTVid') and LEN(TRIM(FORM.FPTVid))>
	<cfset modo = "CAMBIO">
</cfif>

<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tipos de Variaciones Presupuestales">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top"><cfinclude template="TipoVariacion-lista.cfm"></td>
				<td valign="top"><cfinclude template="TipoVariacion-form.cfm"></td>
			</tr>
	<cf_web_portlet_end>
<cf_templatefooter>