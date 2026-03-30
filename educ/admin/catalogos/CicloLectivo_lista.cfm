	<cfif isdefined("Url.fCILnombre") and not isdefined("Form.fCILnombre")>
		<cfparam name="Form.fCILnombre" default="#Url.fCILnombre#">
	</cfif>
	
	<form name="CicloLectivo_filtro" method="post" action="CicloLectivo.cfm">
		<table border="0" class="areaFiltro" cellpadding="0" cellspacing="0" width="100%">
		  <tr> 
			<td nowrap align="right">Tipos de Ciclo Lectivo</td>
			<td nowrap><input name="fCILnombre" type="text" id="fCILnombre" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fCILnombre") AND Form.fCILnombre NEQ ""><cfoutput>#Form.fCILnombre#</cfoutput></cfif>"></td>
			<td align="center" nowrap><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
		  </tr>
		</table>
	</form>
	<cfset filtro = "">
	<cfset navegacion = "">
	<cfif isdefined("Form.fCILnombre") AND Form.fCILnombre NEQ "">
		<cfset filtro = "and upper(rtrim(CILnombre)) like upper('%" & #Trim(Form.fCILnombre)# & "%')">
		<cfset navegacion = "fCILnombre=" & Form.fCILnombre>
	</cfif>				
	<cfinvoke 
	 component="educ.componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="CicloLectivo a"/>
		<cfinvokeargument name="columnas" value="convert(varchar,a.CILcodigo) as CILcodigo, substring(a.CILnombre,1,50) as CILnombre, convert(varchar,ts_rversion) as ts_rversion, CLTcicloEvaluacion as CLTcicloEvaluacion, case when CILtipoCicloDuracion='L' then 'Todo el Ciclo Lectivo' else 'Sólo un Período del Ciclo' end as CILduracion"/>
		<cfinvokeargument name="desplegar" value="CILnombre, CLTcicloEvaluacion, CILduracion"/>
		<cfinvokeargument name="etiquetas" value="Tipo de Ciclo Lectivo, Tipo Período, Duracion de Curso"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" a.Ecodigo = #session.Ecodigo# #filtro# order by a.CILnombre asc"/>
		<cfinvokeargument name="align" value="left,left,left"/>
		<cfinvokeargument name="ajustar" value="N,N,N"/>
		<cfinvokeargument name="irA" value="CicloLectivo.cfm"/>
		<cfinvokeargument name="botones" value="Nuevo"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="navegacion" value="#navegacion#" />
	</cfinvoke>