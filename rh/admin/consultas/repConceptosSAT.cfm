<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../portlets/pNavegacion.cfm">
</cfsavecontent>    
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
    Key="LB_ConceptosSAT"
    Default="Reporte de Conceptos SAT"
    returnvariable="LB_ConceptosSAT"/>

<cf_templateheader title="#LB_RecursosHumanos#">
    <cf_templatecss>
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#LB_ConceptosSAT#</cfoutput>">
		<cfinclude template="repConceptosSAT-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>