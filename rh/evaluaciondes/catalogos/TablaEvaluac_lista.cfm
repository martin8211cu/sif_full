	<cfif isdefined("Url.fTEnombre") and not isdefined("Form.fTEnombre")>
		<cfparam name="Form.fTEnombre" default="#Url.fTEnombre#">
	</cfif>
	
	<form action="tablaEvaluac.cfm" name="filtroTablaEvaluacion" method="post">
		<table width="100%" border="0" class="areaFiltro">
			<tr> 
				<td align="right" nowrap><cf_translate key="LB_TablaDeEvaluacion">Tabla de Evaluaci&oacute;n</cf_translate>:&nbsp;</td>
				<td nowrap>
					<input name="fTEnombre" type="text" id="fTEnombre" size="80" onFocus="this.select()" maxlength="50" 
						value="<cfif isdefined("Form.fTEnombre") AND #Form.fTEnombre# NEQ "" ><cfoutput>#Form.fTEnombre#</cfoutput></cfif>">
				</td>
				<td nowrap>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Buscar"
						Default="Buscar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Buscar"/>					
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Buscar#</cfoutput>">
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
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Descripcion"
		Default="Descripción"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Descripcion"/>
			
	<cfinvoke 
		component="rh.Componentes.pListas"
		method="pListaRH"
		returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="TablaEvaluacion"/>
		<cfinvokeargument name="columnas" value="TEcodigo, substring(TEnombre,1,50) as TEnombre, ts_rversion"/>
		<cfinvokeargument name="desplegar" value="TEnombre"/>
		<cfinvokeargument name="etiquetas" value="#LB_Descripcion#"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by TEnombre"/>
		<cfinvokeargument name="align" value="left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="tablaEvaluac.cfm"/>
		<cfinvokeargument name="botones" value="Nuevo"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>