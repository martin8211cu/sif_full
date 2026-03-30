<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos"component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Nivel" default="Nivel" returnvariable="LB_Nivel"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_Peso" default="Peso" returnvariable="LB_Peso"component="sif.Componentes.Translate" method="Translate">
