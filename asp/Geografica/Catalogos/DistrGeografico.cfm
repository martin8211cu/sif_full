<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfparam name="irA"  			  default="DistrGeografico.cfm">
<cfparam name="rsD.DGid" 	  	  default="">
<cfparam name="rsD.DGcodigo" 	  default="">
<cfparam name="rsD.DGDescripcion" default="">
<cfparam name="rsD.DGcodigoPostal"default="">
<cfparam name="ts"   			  default="">
<cfparam name="modoDist" 		  default="ALTA">
<cfparam name="modoNivel" 		  default="ALTA">
<cfparam name="modoPais" 		  default="ALTA">
<cfparam name="Request.jsMask" 	  default="false">

<cfif (not isdefined('form.DGid')  or (isdefined('form.DGid')  and NOT LEN(TRIM(form.DGid))))  and isdefined('url.DGid')> <cfset form.DGid  = url.DGid> </cfif>
<cfif (not isdefined('form.NGid')  or (isdefined('form.NGid')  and NOT LEN(TRIM(form.NGid))))  and isdefined('url.NGid')> <cfset form.NGid  = url.NGid> </cfif>
<cfif (not isdefined('form.Ppais') or (isdefined('form.Ppais') and NOT LEN(TRIM(form.Ppais))))  and isdefined('url.Ppais')><cfset form.Ppais = url.Ppais></cfif>

<cfif isdefined('form.DGid') and LEN(TRIM(form.DGid))>
	<cfset modoDist  = 'CAMBIO'>
    <cfset modoNivel = 'CAMBIO'>
    <cfset modoPais  = 'CAMBIO'>
<cfelseif isdefined('form.NGid') and LEN(TRIM(form.NGid))>
    <cfset modoNivel = 'CAMBIO'>
    <cfset modoPais  = 'CAMBIO'>
<cfelseif isdefined('form.Ppais') and LEN(TRIM(form.Ppais))>
	<cfset modoPais  = 'CAMBIO'>
</cfif>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">	
    	<cfif modoPais EQ 'CAMBIO'>
        	<cfinclude template="DistrGeografico-form.cfm">
        <cfelse>
        	<cfinclude template="NivelGeografico-Lista.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>