<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_CargaOficina"
		Key="LB_CargaOficina" Default="Carga Oficina"/>
<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
	<cfset form.Ocodigo = url.Ocodigo>
</cfif>
<cfif isdefined("url.DClinea") and len(trim(url.DClinea))>
	<cfset form.DClinea = url.DClinea>
</cfif>

<cf_templateheader title="#LB_RecursosHumanos#">
    <cf_templatecss>
    <cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#LB_CargaOficina#</cfoutput>">
        <table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top">
                <cfinclude template="CargaOficina-FILTRO.cfm">
                <cfinclude template="CargaOficina-LISTA.cfm">
            </td>
            <td valign="top">
                <cfinclude template="CargaOficina-FORM.cfm">
            </td>
          </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>