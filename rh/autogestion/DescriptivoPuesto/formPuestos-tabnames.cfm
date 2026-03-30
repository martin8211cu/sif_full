
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_MisionResponsabilidades"
	Default="Misión y responsabilidades"
	returnvariable="TAB_MisionResponsabilidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_DatosVariables"
	Default="Datos Variables"
	returnvariable="TAB_DatosVariables"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_HabilidadesConductuales"
	Default="Habilidades Conductuales"
	returnvariable="TAB_HabilidadesConductuales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_ConocimientosTecnicos"
	Default="Conocimientos Técnicos"
	returnvariable="TAB_ConocimientosTecnicos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_Valores"
	Default="Valores"
	returnvariable="TAB_Valores"/>
<cfset tabChoice = 1>

<cfset tabNames = ArrayNew(1)>
<cfset tabNames[1] = "#TAB_MisionResponsabilidades#">
<cfset tabNames[2] = "#TAB_DatosVariables#">
<cfset tabNames[3] = "#TAB_HabilidadesConductuales#">
<cfset tabNames[4] = "#TAB_ConocimientosTecnicos#">
<cfset tabNames[5] = "#TAB_Valores#">

<cfset tabLinks = ArrayNew(1)>
<cfset tabLinks[1] = "Puestos.cfm?o=1&sel=1">
<cfset tabLinks[2] = "Puestos.cfm?o=2&sel=1">
<cfset tabLinks[3] = "Puestos.cfm?o=3&sel=1">
<cfset tabLinks[4] = "Puestos.cfm?o=4&sel=1">
<cfset tabLinks[5] = "Puestos.cfm?o=5&sel=1">


<cfset tabStatusText = ArrayNew(1)>

<cfset tabStatusText[1] = "#TAB_MisionResponsabilidades#">
<cfset tabStatusText[2] = "#TAB_DatosVariables#">
<cfset tabStatusText[3] = "#TAB_HabilidadesConductuales#">
<cfset tabStatusText[4] = "#TAB_ConocimientosTecnicos#">
<cfset tabStatusText[5] = "#TAB_Valores#">

