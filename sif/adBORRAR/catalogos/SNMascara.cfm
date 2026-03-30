<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfparam name="SNMascaras.SNtipo" 		 	default="">
<cfparam name="SNMascaras.SNMDescripcion" 	default="">
<cfparam name="SNMascaras.SNMascara" 		default="">
<cfparam name="Modo" 						default="ALTA">
<cfparam name="ts" 							default="">
<cfif NOT isdefined('form.SNMid') and isdefined('url.SNMid')>
	<cfset form.SNMid = url.SNMid>
</cfif>
<cfif isdefined('form.SNMid')>
	<cfset Modo = 'CAMBIO'>
</cfif>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">	
			<cfinclude template="SNMascara-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>