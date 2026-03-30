	<cfif isdefined("Url.fTEdescripcion") and not isdefined("Form.fTEdescripcion")>
		<cfparam name="Form.fTEdescripcion" default="#Url.fTEdescripcion#">
	</cfif>
	
	<form action="TiposEmpleado.cfm" name="filtroTablaEvaluacion" method="post">
	  <table width="100%" border="0" class="areaFiltro">
		<tr> 
		  <td align="right" nowrap><cf_translate  key="LB_TipoDeEmpleado">Tipo de Empleado</cf_translate></td>
		  <td nowrap>
			<input name="fTEdescripcion" type="text" id="fTEdescripcion" size="80" onFocus="this.select()" maxlength="50" value="<cfif isdefined("Form.fTEdescripcion") AND #Form.fTEdescripcion# NEQ "" ><cfoutput>#Form.fTEdescripcion#</cfoutput></cfif>">
		  </td>
		  <td nowrap>
		   <cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Buscar"
			Default="Buscar"
			returnvariable="BTN_Buscar"/>		
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Buscar#</cfoutput>">
		  </td>
		</tr>
	  </table>
	</form>
	<cfset filtro = "">
	<cfset navegacion = "">
	<cfif isdefined("Form.fTEdescripcion") AND Form.fTEdescripcion NEQ "">
		<cfset filtro = " and upper(rtrim(a.TEdescripcion)) like upper('%" & #Trim(Form.fTEdescripcion)# & "%')">
		<cfset navegacion = "fTEdescripcion=" & Form.fTEdescripcion>
	</cfif>				
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CODIGO"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_CODIGO"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DESCRIPCION"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_DESCRIPCION"/>	
	
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="TiposEmpleado a"/>
		<cfinvokeargument name="columnas" value="a.TEid, rtrim(a.TEcodigo) as TEcodigo, a.TEdescripcion"/>
		<cfinvokeargument name="desplegar" value="TEcodigo, TEdescripcion"/>
		<cfinvokeargument name="etiquetas" value="#LB_CODIGO#, #LB_DESCRIPCION#"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# 
											   #filtro# 
											   order by TEdescripcion"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="TiposEmpleado.cfm"/>
		<cfinvokeargument name="botones" value="Nuevo"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>
