<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_TipoIncapacidad"
		Key="LB_TipoIncapacidad" Default="Tipo Incapacidad"/>
<cfif isdefined("url.RHIncapid") and len(trim(url.RHIncapid))>
	<cfset form.RHIncapid = url.RHIncapid>
</cfif>
<cf_templateheader title="#LB_RecursosHumanos#">
    <cf_templatecss>
    <cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#LB_TipoIncapacidad#</cfoutput>">
        <table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top">
                <cfinclude template="TipoIncapacidad-FILTRO.cfm">
                <cfinclude template="TipoIncapacidad-LISTA.cfm">
            </td>
            <td valign="top">
                <cfinclude template="TipoIncapacidad-FORM.cfm">
            </td>
          </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>