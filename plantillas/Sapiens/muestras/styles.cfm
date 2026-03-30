<cfparam name="url.skin" default="azul">
<cfset session.sitio.template = "/plantillas/soinasp01/plantilla.cfm">
<cfset session.sitio.css = "/plantillas/soinasp01/css/soinasp01_" & url.skin & ".css">
<cfinclude template="styles_inc.cfm">
