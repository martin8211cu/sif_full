<cfparam name="modo" default="ALTA">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cfquery name="rsReferencia" datasource="asp">
    select llave
    from UsuarioReferencia
    where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
        and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
</cfquery>

<cfif rsReferencia.recordCount eq 0>

    <cfinvoke 
        component="sif.Componentes.Translate"
        method="Translate"
        Key="MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado"
        Default="El usuario con el que está ingresando, no es un empleado"
        returnvariable="MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado"/>	

    <cfthrow detail="#MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado#">
</cfif>
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
<cfset action = "RegBecas-sql.cfm">
<cfset sufijo = "EB">
<cfset regresar = "/cfmx/rh/autogestion/operacion/RegBecas.cfm">
<cfset auto = true>
<cfif isdefined('form.btnNuevo')>
	<cfset titulo = "Nueva Becas">
</cfif>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr>
<td valign="top">
                	<cfif isdefined('RHEBEid') or isdefined('form.btnNuevo')>
                    	<cfinclude template="/rh/progEstudios/operacion/becas-form.cfm">
                    <cfelse>
                    	<cfinclude template="RegBecas-lista.cfm">
                    </cfif>
                </td>
        	</tr>
</table>
    <cf_web_portlet_end>
<cf_templatefooter>