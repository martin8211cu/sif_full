<!--- PINTA LA PANTALLA DE OPERACION --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CatálogoPerfiles" Default="Catálogo de Perfiles" returnvariable="LB_CatálogoPerfiles"/> 
<cf_templateheader title="#LB_CatálogoPerfiles#"> 
	 <cf_web_portlet_start border="true" titulo="<cfoutput>#LB_CatálogoPerfiles#</cfoutput>" skin="#Session.Preferences.Skin#">
            
            <cflocation url = "../../../#Form.SPhomeuri#" addToken = "no">
            
		<cf_web_portlet_end>
<cf_templatefooter>