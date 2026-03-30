<cfparam name="modo" default="ALTA">
<cfparam name="modoD" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>  
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Corporativo" Default="Es Corporativo" XmlFile="/rh/generales.xml" returnvariable="LB_Corporativo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Multiple" Default="Multiple" XmlFile="/rh/generales.xml" returnvariable="LB_Multiple"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo" Default="Tipo" XmlFile="/rh/generales.xml" returnvariable="LB_Tipo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Compuesto" Default="Es Compuesto" XmlFile="/rh/generales.xml" returnvariable="LB_Compuesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Negativos" Default="Permite Negativos" XmlFile="/rh/generales.xml" returnvariable="LB_Negativos"/>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start border="true" titulo="Conceptos" skin="#Session.Preferences.Skin#">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr>
            	<td valign="top">
                	<cfif (isdefined('form.RHECBid') and len(trim(form.RHECBid)) gt 0) or isdefined('form.btnNuevo')>
    					<cfinclude template="conceptos-form.cfm">
                    <cfelse>
                    	<cfinclude template="conceptos-lista.cfm">
                    </cfif>
                </td>
        	</tr>
		</table>
    <cf_web_portlet_end>
<cf_templatefooter>