<!--- El tab 8 (Benziger) solo se usa si el parametro 450 esta activado --->
<cfquery name="data_bezinger" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=450
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_DatosGenerales"
	Default="Datos Generales"
	returnvariable="TAB_DatosGenerales"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_Mision"
	Default="Misión"
	returnvariable="TAB_Mision"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_Responsabilidades"
	Default="Responsabilidades"
	returnvariable="TAB_Responsabilidades"/>
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
	Key="TAB_CatalogosGenerales"
	Default="Catalogos Generales"
	returnvariable="TAB_CatalogosGenerales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_PlanSucesion"
	Default="Plan de Sucesión"
	returnvariable="TAB_PlanSucesion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_PerfilBenziger"
	Default="Perfil Benziger"
	returnvariable="TAB_PerfilBenziger"/>
	
<cfset tabChoice = 1>

<cfset tabNames = ArrayNew(1)>
<cfset tabNames[1] = "#TAB_DatosGenerales#">
<cfset tabNames[2] = "#TAB_Mision#">
<cfset tabNames[3] = "#TAB_Responsabilidades#">
<cfset tabNames[4] = "#TAB_DatosVariables#">
<cfset tabNames[5] = "#TAB_HabilidadesConductuales#">
<cfset tabNames[6] = "#TAB_ConocimientosTecnicos#">
<cfset tabNames[7] = "#TAB_CatalogosGenerales#">
<cfset tabNames[8] = "#TAB_PlanSucesion#">
<cfif data_bezinger.Pvalor eq 1 >
	<cfset tabNames[9] = "#TAB_PerfilBenziger#">
<cfelse>
	<cfset tabNames[9] = "">
</cfif>

<cfset tabLinks = ArrayNew(1)>
<cfset tabLinks[1] = "Puestos.cfm?o=1&sel=1">
<cfset tabLinks[2] = "Puestos.cfm?o=2&sel=1">
<cfset tabLinks[3] = "Puestos.cfm?o=3&sel=1">
<cfset tabLinks[4] = "Puestos.cfm?o=4&sel=1">
<cfset tabLinks[5] = "Puestos.cfm?o=5&sel=1">
<cfset tabLinks[6] = "Puestos.cfm?o=6&sel=1">
<cfset tabLinks[7] = "Puestos.cfm?o=7&sel=1">
<cfset tabLinks[8] = "Puestos.cfm?o=8&sel=1">
<cfif data_bezinger.Pvalor eq 1 >
	<cfset tabLinks[9] = "Puestos.cfm?o=9&sel=1">
<cfelse>
	<cfset tabLinks[9] = "">
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_InformacionGeneralDelPuesto"
	Default="Información general del puesto"
	returnvariable="TAB_InformacionGeneralDelPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_MisionDelPuesto"
	Default="Misión del puesto"
	returnvariable="TAB_MisionDelPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_ResponsabilidadesDetalladosDelPuesto"
	Default="Responsabilidades detallados del puesto"
	returnvariable="TAB_ResponsabilidadesDetalladosDelPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_EspecificacionesDetalladosDelPuesto"
	Default="Especificaciones detallados del puesto"
	returnvariable="TAB_EspecificacionesDetalladosDelPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_HabilidadesDelPuesto"
	Default="Habilidades del puesto"
	returnvariable="TAB_HabilidadesDelPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_ConocimientosDelPuesto"
	Default="Conocimientos del puesto"
	returnvariable="TAB_ConocimientosDelPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_CatalogosGeneralesDelPuesto"
	Default="Valores del puesto"
	returnvariable="TAB_CatalogosGeneralesDelPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_PlanSucesion"
	Default="Plan de Sucesión"
	returnvariable="TAB_PlanSucesion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="TAB_PerfilBenziger"
	Default="Perfil Benziger"
	returnvariable="TAB_PerfilBenziger"/>

<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "#TAB_InformacionGeneralDelPuesto#">
<cfset tabStatusText[2] = "#TAB_MisionDelPuesto#">
<cfset tabStatusText[3] = "#TAB_ResponsabilidadesDetalladosDelPuesto#">
<cfset tabStatusText[4] = "#TAB_EspecificacionesDetalladosDelPuesto#">
<cfset tabStatusText[5] = "#TAB_HabilidadesDelPuesto#">
<cfset tabStatusText[6] = "#TAB_ConocimientosDelPuesto#">
<cfset tabStatusText[7] = "#TAB_CatalogosGeneralesDelPuesto#">
<cfset tabStatusText[8] = "#TAB_PlanSucesion#">
<cfif data_bezinger.Pvalor eq 1 >
	<cfset tabStatusText[9] = "#TAB_PerfilBenziger#">
<cfelse>
	<cfset tabStatusText[9] = "">
</cfif>
