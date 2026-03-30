<cfparam name="modo" default="ALTA">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>  
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" XmlFile="/rh/generales.xml" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado" XmlFile="/rh/generales.xml" returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Beca" Default="Beca" XmlFile="/rh/generales.xml" returnvariable="LB_Beca"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="dentificaci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Identificacion"/>

<cfquery name="rsReferencia" datasource="asp">
    select llave
    from UsuarioReferencia
    where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
        and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
</cfquery>
<cfif rsReferencia.recordCount eq 0>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado" Default="El usuario con el que está ingresando, no es un empleado" returnvariable="MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado"/>	
    <cfthrow detail="#MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado#">
</cfif>
<cfquery name="rsAdmCF" datasource="#Session.DSN#">
	select p.RHPid, p.RHPpuesto, cf.CFid, cf.CFcodigo, cf.CFdescripcion
	from LineaTiempo lt
    inner join RHPlazas p
		on lt.RHPid = p.RHPid and lt.Ecodigo = p.Ecodigo
	inner join CFuncional cf
		on cf.RHPid = p.RHPid
	where 
	  lt.DEid = #rsReferencia.llave#
      and lt.Ecodigo = #session.Ecodigo#
      and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
    union 
    select  -1 as RHPid,  '' as RHPpuesto,  -1 as CFid, '' as CFcodigo, '' as CFdescripcion from dual
</cfquery>
<cf_dbfunction name="now" returnvariable="LvarNow">
<cfset tabla = "inner join LineaTiempo lt on lt.DEid = ebe.DEid and lt.Ecodigo = ebe.Ecodigo and #LvarNow# between lt.LTdesde and lt.LThasta inner join RHPlazas p on lt.RHPid = p.RHPid and lt.Ecodigo = p.Ecodigo">
<cfset filtro = "ebe.RHEBEestado = 15 and ebe.Ecodigo = #Session.Ecodigo# and p.CFid in(#ValueList(rsAdmCF.CFid)#)">
<cfset jefe = true>
<cfset sufijo = "Jef">
<cfset accion = "jefe">

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start border="true" titulo="Administración Becas" skin="#Session.Preferences.Skin#">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr>
				<td valign="top">
                	<cfinclude template="RegBecasAdmin-lista.cfm">
                </td>
        	</tr>
		</table>
    <cf_web_portlet_end>
<cf_templatefooter>