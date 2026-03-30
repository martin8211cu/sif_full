<!--- 
	****************************** 
	CALCULO  DE INTERESES CESANTIA 
	FECHA DE CREACIÓN   23/08/2007 
	CREADO POR DORIAN ABARCa GÓMEZ 
	****************************** 
--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader template="#session.sitio.template#" title="#nav__SPdescripcion#">
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfoutput>#pNavegacion#</cfoutput>
			<cfinclude template="CaculoInteresesCesantia-translate.cfm">
			<cfinclude template="CaculoInteresesCesantia-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>
