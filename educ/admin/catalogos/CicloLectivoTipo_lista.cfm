	<cfif isdefined("Url.fCLTcicloEvaluacion") and not isdefined("Form.fCLTcicloEvaluacion")>
		<cfparam name="Form.fCLTcicloEvaluacion" default="#Url.fCLTcicloEvaluacion#">
	</cfif>
	
	<form name="CicloLectivoTipo_filtro" method="post" action="CicloLectivoTipo.cfm">
		<table width="100%" border="0" class="areaFiltro" cellpadding="0" cellspacing="0">
		  <tr> 
			
		<td nowrap align="right">Tipo de Per&iacute;odo</td>
			<td nowrap><input name="fCLTcicloEvaluacion" type="text" id="fCLTcicloEvaluacion" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fCLTcicloEvaluacion") AND Form.fCLTcicloEvaluacion NEQ ""><cfoutput>#Form.fCLTcicloEvaluacion#</cfoutput></cfif>"></td>
			<td align="center" nowrap><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
		  </tr>
		</table>
	</form>
	<cfset filtro = "">
	<cfset navegacion = "">
	<cfif isdefined("Form.fCLTcicloEvaluacion") AND Form.fCLTcicloEvaluacion NEQ "">
		<cfset filtro = "and upper(rtrim(CLTcicloEvaluacion)) like upper('%" & #Trim(Form.fCLTcicloEvaluacion)# & "%')">
		<cfset navegacion = "fCLTcicloEvaluacion=" & Form.fCLTcicloEvaluacion>
	</cfif>				
	<cfinvoke 
	 component="educ.componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="CicloLectivoTipo a"/>
		<cfinvokeargument name="columnas" value=" CLTcicloEvaluacion, CLTciclos, CLTsemanas, CLTvacaciones, convert(varchar,ts_rversion) as ts_rversion"/>
		<cfinvokeargument name="desplegar" value="CLTcicloEvaluacion, CLTciclos, CLTsemanas, CLTvacaciones"/>
		<cfinvokeargument name="etiquetas" value="Tipo Periodo, Periodos/Ciclo, Semanas, Vacaciones"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" a.Ecodigo = #session.Ecodigo# #filtro# order by a.CLTciclos desc"/>
		<cfinvokeargument name="align" value="left,center,center,center"/>
		<cfinvokeargument name="ajustar" value="N,N,N,N"/>
		<cfinvokeargument name="irA" value="CicloLectivoTipo.cfm"/>
		<cfinvokeargument name="botones" value="Nuevo"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="navegacion" value="#navegacion#" />
	</cfinvoke>