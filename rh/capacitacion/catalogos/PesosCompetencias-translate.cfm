<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos"component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_Peso" default="Peso" returnvariable="LB_Peso"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="MSG_Codigo" default="Código" returnvariable="MSG_Codigo"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="MSG_Descripcion" default="Descripción" returnvariable="MSG_Descripcion"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_Annos" default="A&ntilde;os" returnvariable="LB_Annos"component="sif.Componentes.Translate" method="Translate">
