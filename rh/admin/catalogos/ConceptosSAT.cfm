<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_ConceptosSAT"
		Key="LB_ConceptosSAT" Default="Conceptos SAT"/>
<cfif isdefined("url.RHCSATid") and len(trim(url.RHCSATid))>
	<cfset form.RHCSATid = url.RHCSATid>
</cfif>
<cf_templateheader title="#LB_RecursosHumanos#">
    <cf_templatecss>
    <cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#LB_ConceptosSAT#</cfoutput>">
        <table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top">
                <cfinclude template="ConceptosSAT-FILTRO.cfm">
                <cfinclude template="ConceptoSAT-LISTA.cfm">
            </td>
            <td valign="top">
                <cfinclude template="ConceptoSAT-FORM.cfm">
            </td>
          </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>