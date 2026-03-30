	<cfif isdefined("Url.fTEnombre") and not isdefined("Form.fTEnombre")>
		<cfparam name="Form.fTEnombre" default="#Url.fTEnombre#">
	</cfif>
	
	<form action="TablaEvaluac.cfm" name="filtroTablaEvaluacion" method="post">
	  <table width="100%" border="0" class="areaFiltro">
		<tr> 
		  <td align="right" nowrap>Tabla de Evaluaci&oacute;n</td>
		  <td nowrap>
			<input name="fTEnombre" type="text" id="fTEnombre" size="80" onFocus="this.select()" maxlength="50" value="<cfif isdefined("Form.fTEnombre") AND #Form.fTEnombre# NEQ "" ><cfoutput>#Form.fTEnombre#</cfoutput></cfif>">
		  </td>
		  <td nowrap>
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar">
		  </td>
		</tr>
	  </table>
	</form>
	<cfset filtro = "">
	<cfset navegacion = "">
	<cfif isdefined("Form.fTEnombre") AND Form.fTEnombre NEQ "">
		<cfset filtro = "and upper(rtrim(TEnombre)) like upper('%" & #Trim(Form.fTEnombre)# & "%')">
		<cfset navegacion = "fTEnombre=" & Form.fTEnombre>
	</cfif>				
	<cfinvoke 
	 component="educ.componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="TablaEvaluacion"/>
		<cfinvokeargument name="columnas" value="convert(varchar, TEcodigo) as TEcodigo, substring(TEnombre,1,50) as TEnombre,  convert(varchar,ts_rversion) as ts_rversion"/>
		<cfinvokeargument name="desplegar" value="TEnombre"/>
		<cfinvokeargument name="etiquetas" value="Descripci&oacute;n"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by TEnombre"/>
		<cfinvokeargument name="align" value="left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="tablaEvaluac.cfm"/>
		<cfinvokeargument name="botones" value="Nuevo"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>