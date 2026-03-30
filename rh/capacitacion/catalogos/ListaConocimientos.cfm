<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidades"
	Default="Habilidades"
	returnvariable="LB_Habilidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Conocimientos"
	Default="Conocimientos"
	returnvariable="LB_Conocimientos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ambos"
	Default="Ambos"
	returnvariable="LB_Ambos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
﻿<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo"
	Default="Tipo"
	returnvariable="LB_Tipo"/>
<!--- FIN VARIABLES DE TRADUCCION --->
﻿<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
</cfif>
<cfif isdefined("Url.Mnombre") and not isdefined("Form.Mnombre")>
	<cfparam name="Form.Mnombre" default="#Url.Mnombre#">
</cfif>

<!--- CONSULTAS --->
<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfset rsTipo = queryNew("value,description","varchar,Varchar")>
<cfset queryAddRow(rsTipo,3)>
<cfset querySetCell(rsTipo,"value","",1)>
<cfset querySetCell(rsTipo,"description","#LB_Ambos#",1)>
<cfset querySetCell(rsTipo,"value","H",2)>
<cfset querySetCell(rsTipo,"description","#LB_Habilidades#",2)>
<cfset querySetCell(rsTipo,"value","C",3)>
<cfset querySetCell(rsTipo,"description","#LB_Conocimientos#",3)>

<cfquery name="rsCompetencias" datasource="#session.dsn#">
	Select Ecodigo, id, codigo, descripcion, Tipo
	from RHCompetencias
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	Order by descripcion
</cfquery>
<!---  FIN DE CONSULTAS--->

<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="RHCompetencias"/>
	<cfinvokeargument name="desplegar" value="codigo, descripcion, tipo"/>
	<cfinvokeargument name="columnas" value="Ecodigo, id, codigo, descripcion, Tipo"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Tipo#"/>
	<cfinvokeargument name="formatos" value="S,S,S"/>
	<cfinvokeargument name="align" value="left,left,center"/>
	<cfinvokeargument name="ajustar" value="S"/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#"/>
	<cfinvokeargument name="irA" value="RHCompetencias.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys" value="codigo,descripcion,Tipo,id"/>
	<cfinvokeargument name="maxrows" value="15"/>
	<cfinvokeargument name="mostrar_filtro" value="true"/>
	<cfinvokeargument name="filtrar_automatico" value="true"/>
	<cfinvokeargument name="filtrar_por" value="codigo,descripcion,Tipo"/>
	<cfinvokeargument name="rsTipo" value="#rsTipo#"/>
</cfinvoke>	