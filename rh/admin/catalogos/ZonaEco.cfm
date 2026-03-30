<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_ZonasEconomicas"
		Key="LB_ZonasEconomicas" Default="Zonas Económicas"/>
<cfif isdefined("url.ZEid") and len(trim(url.ZEid))>
	<cfset form.ZEid = url.ZEid>
</cfif>
<cf_templateheader title="#LB_RecursosHumanos#">
    <cf_templatecss>
    <cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#LB_ZonasEconomicas#</cfoutput>">
        <table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top">
                <cfinclude template="ZonaEco-FILTRO.cfm">
                <cfinclude template="ZonaEco-LISTA.cfm">
            </td>
            <td valign="top">
                <cfinclude template="ZonaEco-FORM.cfm">
            </td>
          </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>