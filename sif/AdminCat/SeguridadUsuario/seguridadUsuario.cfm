<!--- PINTA LA PANTALLA DE OPERACION --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SeguridadUsuario" Default="Seguridad por usuario" returnvariable="LB_SeguridadUsuario"/> 
<cf_templateheader title="#LB_SeguridadUsuario#"> 
	 <cf_web_portlet_start border="true" titulo="<cfoutput>#LB_SeguridadUsuario#</cfoutput>" skin="#Session.Preferences.Skin#">
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
        <cfsavecontent variable="pNavegacion">
        <cfinclude template="/sif/portlets/pNavegacion.cfm">
        </cfsavecontent>
			<cfinclude template="formSeguridadUsuario.cfm">
<cf_web_portlet_end>
<cf_templatefooter>