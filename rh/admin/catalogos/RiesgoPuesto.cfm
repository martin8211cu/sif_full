<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RiesgoPuesto"
		Key="LB_RiesgoPuesto" Default="Riesgo Puesto"/>
<cfif isdefined("url.RHRiesgoid") and len(trim(url.RHRiesgoid))>
	<cfset form.RHRiesgoid = url.RHRiesgoid>
</cfif>
<cf_templateheader title="#LB_RecursosHumanos#">
    <cf_templatecss>
    <cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#LB_RiesgoPuesto#</cfoutput>">
        <table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top">
                <cfinclude template="RiesgoPuesto-FILTRO.cfm">
                <cfinclude template="RiesgoPuesto-LISTA.cfm">
            </td>
            <td valign="top">
                <cfinclude template="RiesgoPuesto-FORM.cfm">
            </td>
          </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>