<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_DatosPersonales" default="Datos Personales" returnvariable="LB_DatosPersonales" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="LB_Familiares" default="Familiares" returnvariable="LB_Familiares" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="LB_Tramites" default="Tr&aacute;mites" returnvariable="LB_Tramites" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Cargas" default="Cargas" returnvariable="LB_Cargas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Deducciones" default="Deducciones" returnvariable="LB_Deducciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Educacion" default="Educación" returnvariable="LB_Educacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Experiencia" default="Experiencia" returnvariable="LB_Experiencia" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfset tabChoice = 1>
<cfset tabNames = ArrayNew(1)>



<cfset tabNames[1] = "#LB_DatosPersonales#">
<cfset tabNames[2] = "#LB_Familiares#">
<cfset tabNames[3] = "#LB_Tramites#">
<cfset tabNames[4] = "#LB_Cargas#">
<cfset tabNames[5] = "#LB_Deducciones#">
<cfset tabNames[6] = "#LB_Educacion#">
<cfset tabNames[7] = "#LB_Experiencia#">


<cfset tabLinks = ArrayNew(1)>
<cfset tabLinks[1] = "autogestion.cfm?o=1">
<cfset tabLinks[2] = "autogestion.cfm?o=2">
<cfset tabLinks[3] = "autogestion.cfm?o=3">
<cfset tabLinks[4] = "autogestion.cfm?o=4">
<cfset tabLinks[5] = "autogestion.cfm?o=5">
<cfset tabLinks[6] = "autogestion.cfm?o=6">
<cfset tabLinks[7] = "autogestion.cfm?o=7">

<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "">
<cfset tabStatusText[2] = "">
<cfset tabStatusText[3] = "">
<cfset tabStatusText[4] = "">
<cfset tabStatusText[5] = "">
<cfset tabStatusText[6] = "">
<cfset tabStatusText[7] = "">


