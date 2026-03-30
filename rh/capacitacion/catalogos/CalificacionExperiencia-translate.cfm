<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos"component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_RequisitoDelPuesto" default="Requisito del Puesto" returnvariable="LB_RequisitoDelPuesto"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_LimiteSuperior" default="L&iacute;mite Superior" returnvariable="LB_LimiteSuperior"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_LimiteInferior" default="L&iacute;mite Inferior" returnvariable="LB_LimiteInferior"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="MSG_LimiteSuperior" default="Límite Superior" returnvariable="MSG_LimiteSuperior"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="MSG_LimiteInferior" default="Límite Inferior" returnvariable="MSG_LimiteInferior"component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_Annos" default="A&ntilde;os" returnvariable="LB_Annos"component="sif.Componentes.Translate" method="Translate">
