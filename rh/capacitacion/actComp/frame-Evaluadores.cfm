<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	returnvariable="LB_Estado"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"
	returnvariable="LB_Todos"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluando"
	Default="Evaluando"
	returnvariable="LB_Evaluando"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluacionFinalizada"
	Default="Evaluaci&oacute;n Finalizada"
	returnvariable="LB_EvaluacionFinalizada"/>			
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOSEHANAGREGADOEVALUADORESPARAESTARELACION"
	Default="NO SE HAN AGREGADO EVALUADORES PARA ESTA RELACION"
	returnvariable="MSG_NOSEHANAGREGADOEVALUADORESPARAESTARELACION"/>	
	
<!--- FIN VARIABLES DE TRADUCCION --->
﻿<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>

<cfset navegacion = "">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SEL=3">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHRCid=" & Form.RHRCid>

<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfquery datasource="#session.dsn#" name="rsEstado">
	select '' as value, '#LB_Todos#' as description, '0' as ord from dual
	union
	select '0' as value, '#LB_Evaluando#' as description, '1' as ord from dual
	union
	select '10' as value, '#LB_EvaluacionFinalizada#' as description, '2' as ord from dual
	order by 3,2
</cfquery>
<form name="lista" method="post" action="actCompetencias.cfm">
	<cfoutput>
		<input type="hidden" name="SEL" value="3">
		<input type="hidden" name="RHRCid" value="#form.RHRCid#">
		<input type="hidden" name="Elimina" value="0">
		<cfinvoke 
			component="rh.Componentes.pListas"
			method="pListaRH"
			returnvariable="pListaRel">
				<cfinvokeargument name="tabla" value="RHEvaluadoresCalificacion ec
														inner join RHRelacionCalificacion rc
															on rc.Ecodigo=ec.Ecodigo
																and rc.RHRCid=ec.RHRCid
														inner join DatosEmpleado de
															on de.Ecodigo=ec.Ecodigo
																and de.DEid=ec.DEid"/>
				<cfinvokeargument name="columnas" value="'0' as btnEliminar
														, '4' as Sel
														, ec.DEid
														, DEidentificacion
														, {fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombreEmpl
														, case when RHECestado = 0 then '<img src=''/cfmx/rh/imagenes/unchecked.gif''>' else '<img src=''/cfmx/rh/imagenes/checked.gif''>' end  as Estado
														, RHECestado"/>
				<cfinvokeargument name="desplegar" value="DEidentificacion,nombreEmpl,Estado"/>
				<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Nombre#, #LB_Estado#"/>
				<cfinvokeargument name="formatos" value="S,S,S"/>
				<cfinvokeargument name="filtro" value="ec.Ecodigo=#session.Ecodigo#
														and ec.RHRCid = #form.RHRCid#"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value=""/>				
				<cfinvokeargument name="irA" value="actCompetencias.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="maxRows" value="30"/>
				<cfinvokeargument name="keys" value="DEid,RHECestado"/>
				<cfinvokeargument name="checkboxes" value="D">
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="DEidentificacion
														|{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})}
														|RHECestado"/>
				<cfinvokeargument name="filtrar_por_delimiters" value="|"/>
				<cfinvokeargument name="EmptyListMsg" value="#MSG_NOSEHANAGREGADOEVALUADORESPARAESTARELACION#"/>
				<cfinvokeargument name="rsEstado" value="#rsEstado#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showlink" value="false"/>
				<cfinvokeargument name="checkbox_function" value="funcValida(this)"/>
		</cfinvoke>	
	</cfoutput>		
 </form>
