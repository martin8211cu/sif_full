<cfparam name="modo" default="ALTA">

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>  
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Corporativo" Default="Es Corporativo" XmlFile="/rh/generales.xml" returnvariable="LB_Corporativo"/>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfset titulo = "Tipos de Becas">
<cfif isdefined('form.ConceptosB')>
	<cfset titulo = "Conceptos por Tipos de Becas">
</cfif>
<cfif isdefined('form.FormatosB')>
	<cfset titulo = "Formatos">
</cfif>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr>
            	<cfif isdefined('form.ConceptosB')>
                	<td valign="top">
                        <cfinclude template="becas-conceptos.cfm">
                    </td>
                <cfelseif isdefined('form.FormatosB')>
                	<td valign="top">
                        <cfinclude template="becas-formatos.cfm">
                    </td>
                <cfelse>
                    <td valign="top">
                        <cfinclude template="becas-lista.cfm">
                    </td>
                    <td valign="top">
                        <cfinclude template="becas-form.cfm">
                    </td>
                </cfif>
        	</tr>
		</table>
    <cf_web_portlet_end>
<cf_templatefooter>