<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RegimenContratacion"
		Key="LB_RegimenContratacion" Default="Régimen de Contratación del Trabajador"/>
<cfif isdefined("url.RHRegimenid") and len(trim(url.RHRegimenid))>
	<cfset form.RHRegimenid = url.RHRegimenid>
</cfif>
<cf_templateheader title="#LB_RecursosHumanos#">
    <cf_templatecss>
    <cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#LB_RegimenContratacion#</cfoutput>">
        <table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top">
                <cfinclude template="RegimenContra-FILTRO.cfm">
                <cfinclude template="RegimenContra-LISTA.cfm">
            </td>
            <td valign="top">
                <cfinclude template="RegimenContra-FORM.cfm">
            </td>
          </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>