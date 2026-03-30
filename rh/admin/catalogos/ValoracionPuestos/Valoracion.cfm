<cfinclude template="Valoracion-translate.cfm">
<cfparam name="modo" default="ALTA">
<cfparam name="modoD" default="ALTA">
<cfparam name="rsE.RHEVFcodigo" default="">
<cfparam name="rsE.RHEVFdescripcion" default="">
<cfparam name="rsE.RHEVFfecha" default="#now()#">
<cfif isdefined('FORM.RHEVFid') and LEN(TRIM(FORM.RHEVFid))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined('FORM.RHDVFid') and LEN(TRIM(FORM.RHDVFid))>
	<cfset modoD = "CAMBIO">
</cfif>
<cf_templateheader title="#LB_Valoracion#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Valoracion#">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<cfif modo EQ 'ALTA' and not isdefined('form.btnNuevo')>
					<td valign="top"><cfinclude template="Valoracion-lista.cfm"></td>
				<cfelse>
					<td align="center" valign="top"><cfinclude template="Valoracion-form.cfm"></td>
				</cfif>
			</tr>
	<cf_web_portlet_end>
<cf_templatefooter>