<cfinclude template="SolicitudAfiliacionIGSS-Traduccion.cfm">
<cfparam name="form.formato" default="flashpaper">
<cfparam name="Regresar" default="SolicitudAfiliacionIGSS.cfm">
<cfif isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>
<cfif isdefined('url.formato') and LEN(TRIM(url.formato)) and not isdefined('form.formato')>
	<cfset form.formato = url.formato>
</cfif>
<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>
<cfparam name="form.formato" default="HTML">
<cf_templateheader title="#LB_SolicitudDeAfiliacionIGSS#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_SolicitudDeAfiliacionIGSS#" skin="#Session.Preferences.Skin#">

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
	                <cf_reportWFormat url="/rh/nomina/consultas/SolicitudAfiliacionIGSS_rep.cfm" orientacion="portrait" regresar="SolicitudAfiliacionIGSS.cfm" params="DEid=#form.DEid#">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>