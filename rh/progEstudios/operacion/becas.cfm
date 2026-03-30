<cfparam name="modo" default="ALTA">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>  
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" XmlFile="/rh/generales.xml" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado" XmlFile="/rh/generales.xml" returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Beca" Default="Beca" XmlFile="/rh/generales.xml" returnvariable="LB_Beca"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="dentificaci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Identificacion"/>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfset titulo = "Becas">
<cfset regresar = "becas.cfm">
<cfset action = "becas-sql.cfm">
<cfif isdefined('form.btnNuevo')>
	<cfset titulo = "Nueva Becas">
</cfif>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr>
<td valign="top">
                	<cfif ( isdefined('RHEBEid') and len(trim(RHEBEid)) ) or isdefined('form.btnNuevo')>
                    	<cfinclude template="becas-form.cfm">
                    <cfelse>
                    	<cfinclude template="becas-lista.cfm">
                    </cfif>
                </td>
        	</tr>
</table>
    <cf_web_portlet_end>
<cf_templatefooter>