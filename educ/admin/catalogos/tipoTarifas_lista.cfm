	<cfif isdefined("Url.fTTnombre") and not isdefined("Form.fTTnombre")>
		<cfparam name="Form.fTTnombre" default="#Url.fTTnombre#">
	</cfif>
	
	<form name="tipoTarifas_filtro" method="post" action="CicloLectivoTipo.cfm">
		<table width="100%" border="0" class="areaFiltro" cellpadding="0" cellspacing="0">
		  <tr> 
			
		<td nowrap align="right">Tipo de Tarifa: </td>
			<td nowrap><input name="fTTnombre" type="text" id="fTTnombre" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fTTnombre") AND Form.fTTnombre NEQ ""><cfoutput>#Form.fTTnombre#</cfoutput></cfif>"></td>
			<td align="center" nowrap><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
		  </tr>
		</table>
	</form>
	<cfset filtro = "">
	<cfset navegacion = "">
	<cfif isdefined("Form.fTTnombre") AND Form.fTTnombre NEQ "">
		<cfset filtro = "and upper(rtrim(CLTcicloEvaluacion)) like upper('%" & #Trim(Form.fTTnombre)# & "%')">
		<cfset navegacion = "fTTnombre=" & Form.fTTnombre>
	</cfif>		
	
	<cfinvoke 
	 component="educ.componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="TarifasTipo"/>
		<cfinvokeargument name="columnas" value="convert(varchar,Ecodigo) as Ecodigo
			, convert(varchar,TTcodigo) as TTcodigo
			, TTnombre
			, case TTtipo
				when 1 then 'Matricula' 
				when 2 then 'Curso'
				when 3 then 'Otros'
			end as TTtipo"/>
		<cfinvokeargument name="desplegar" value="TTnombre, TTtipo"/>
		<cfinvokeargument name="etiquetas" value="Tarifa, Tipo"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" Ecodigo = #session.Ecodigo# #filtro# order by TTnombre"/>
		<cfinvokeargument name="align" value="left,center"/>
		<cfinvokeargument name="ajustar" value="N,N"/>
		<cfinvokeargument name="irA" value="tipoTarifas.cfm"/>
		<cfinvokeargument name="botones" value="Nuevo"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="navegacion" value="#navegacion#" />
	</cfinvoke>