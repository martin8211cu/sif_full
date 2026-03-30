<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0"><tr><td>
<cfif isdefined("url.Fdescripcion") and len(url.Fdescripcion) and not isdefined("form.Fdescripcion")><cfset form.Fdescripcion=url.Fdescripcion></cfif>
<cfif isdefined("url.Ftipo") and len(url.Ftipo) and not isdefined("form.Ftipo")><cfset form.Ftipo=url.Ftipo></cfif>
<cfparam name="form.Fdescripcion" default="" type="string">
<cfparam name="form.Ftipo" default="" type="string">
<cfset Navegacion="Fdescripcion="&form.Fdescripcion&"&Ftipo="&form.Ftipo>
<cfset escenarios = getCVTCEscenarios(form.Fdescripcion,form.Ftipo)>
<cfinclude template="escenariosFiltro.cfm">
<cfinvoke component='sif.Componentes.pListas'	method='pListaQuery' returnvariable='pListaRet'>
	<cfinvokeargument name='query' value='#escenarios#'>
	<cfinvokeargument name='desplegar' value='CVTdescripcion,tipo,aplicado'>
	<cfinvokeargument name='etiquetas' value='Descripción,Tipo,Aplicado'>
	<cfinvokeargument name='formatos' value='S,S,S'>
	<cfinvokeargument name='align' value='left,left,left'>
	<cfinvokeargument name='ajustar' value='S'>
	<cfinvokeargument name='irA' value='#GCurrentPage#'>
	<cfinvokeargument name='navegacion' value='#Navegacion#'>
	<cfinvokeargument name="maxrows" value="20">
	<!--- <cfinvokeargument name='botones' value='Nuevo'>
	<cfinvokeargument name='checkboxes' value='S'> --->
	<cfinvokeargument name='keys' value='CVTid'>
</cfinvoke>
</td></tr></table>