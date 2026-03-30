<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/evaluaciondes/evaluacion180/operacion/registro_evaluacion.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"
	XmlFile="/rh/evaluaciondes/evaluacion180/operacion/registro_evaluacion.xml"
	returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	XmlFile="/rh/evaluaciondes/evaluacion180/operacion/registro_evaluacion.xml"
	returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CantidadEmpleados"
	Default="Cantidad de Empleados"
	XmlFile="/rh/evaluaciondes/evaluacion180/operacion/registro_evaluacion.xml"
	returnvariable="LB_CantidadEmpleados"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("url.REid") and not isdefined("form.REid")>
	<cfset form.REid = url.REid >	
</cfif>
<cfif isdefined("url.sel") and not isdefined("form.sel")>
	<cfset form.sel = url.sel >
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fREdescripcion") and Len(Trim(Form.fREdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(REdescripcion) like '%" & UCase(Form.fREdescripcion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fREdescripcion=" & Form.fREdescripcion>
</cfif>
<cfif isdefined("Form.fREestado") and Len(Trim(Form.fREestado)) NEQ 0>
 	<cfset filtro = filtro & " and REestado = " & Form.fREestado>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fREestado=" & Form.fREestado>
</cfif>

<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ResultadoDeIndicadoresPorCentroFuncional"
		Default="Resultado de Indicadores por Centro Funcional"
		returnvariable="LB_ResultadoDeIndicadoresPorCentroFuncional"/>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ResultadoDeIndicadoresPorCentroFuncional#'>
		<cfparam name="form.EQ" default="">
		<cfif not isdefined('form.REid')>
			<form action="NotasIndicadoresCF.cfm" name="filtroTablaEvaluacion" method="post">
				<table width="100%" border="0" class="areaFiltro">
					<tr> 
						<td align="right" nowrap><cf_translate key="LB_RelacionesDeEvaluacion">Relaciones de Evaluaci&oacute;n</cf_translate>:&nbsp;</td>
						<td nowrap>
							<input name="fREdescripcion" type="text" id="fREdescripcion" size="80" onFocus="this.select()" maxlength="50" 
								value="<cfif isdefined("Form.fREdescripcion") AND #Form.fREdescripcion# NEQ "" ><cfoutput>#Form.fREdescripcion#</cfoutput></cfif>">
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
			<cfif isdefined("Form.fREdescripcion") AND Form.fREdescripcion NEQ "">
				<cfset filtro = "and upper(rtrim(REdescripcion)) like upper('%" & #Trim(Form.fREdescripcion)# & "%')">
				<cfset navegacion = "fREdescripcion=" & Form.fREdescripcion>
			</cfif>	
			<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
			    	<td>
			    	
						<cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaRH"
							 returnvariable="pListaRHRet">
								<cfinvokeargument name="tabla" value="RHRegistroEvaluacion a"/>
								<cfinvokeargument name="columnas" value="	REid, 
																			REdescripcion, 
																			(	select count(1) 
																								from RHEmpleadoRegistroE
																								where REid = a.REid)  as cant_empleados, 
																			REestado as Estado,
																			REdesde as Fecha,
																			'' as esp"/>
								<cfinvokeargument name="desplegar" value="REdescripcion, Fecha,esp"/>
								<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Fecha#, "/>
								<cfinvokeargument name="formatos" value="S,D, US"/>
								<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# and a.REestado  = 2 #filtro# order by REdesde desc,REdescripcion"/>
								<cfinvokeargument name="align" value="left,left,right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="irA" value="NotasIndicadoresCF.cfm"/>
								<cfinvokeargument name="keys" value="REid">
								<cfinvokeargument name="showEmptyListMsg" value="true">
								<cfinvokeargument name="EmptyListMsg" value="*** NO SE HA REGISTRADO NINGUNA EVALUACION ***">
								<cfinvokeargument name="navegacion" value="#navegacion#">
					  </cfinvoke>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
	 <cfelse>
	 	<cfinclude template="NotasIndicadoresCF-form.cfm">
	 </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>