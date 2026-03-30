<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluacionDelDesempenoCuestonariosParaEvaluacion"
	Default="Evaluaci&oacute;n del Desempeño - Cuestonarios para Evaluaci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_EvaluacionDelDesempenoCuestonariosParaEvaluacion"/>
<cf_templateheader title="#LB_EvaluacionDelDesempenoCuestonariosParaEvaluacion#">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CuestionariosParaEvaluacion"
		Default="Cuestionarios Para Evaluaci&oacute;n"
		returnvariable="LB_CuestionariosParaEvaluacion"/>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CuestionariosParaEvaluacion#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td colspan="2">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			</tr>

			<tr> 
				<td valign="top"> 
<!---					<cfquery name="rsLista" datasource="#session.DSN#">
						select a.PCid, a.PCcodigo, a.PCnombre, a.PCdescripcion
						from PortalCuestionario a
						  inner join RHEvaluacionCuestionarios b
						    on a.PCid = b.PCid
							and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>--->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Nombre"
						Default="Nombre"
						returnvariable="LB_Nombre"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Codigo"
						Default="C&oacute;digo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Codigo"/>

<!---					<cfinvoke 
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="PCcodigo, PCnombre"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Nombre#"/>
						<cfinvokeargument name="formatos" value="S,V"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="CuestionariosEval.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="PCid"/>
						<cfinvokeargument name="mostrar_filtro" value="yes"/>
						<cfinvokeargument name="filtrar_automatico" value="yes"/>
						<cfinvokeargument name="filtrar_por" value="PCcodigo,PCnombre">
					</cfinvoke>--->
					
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="PortalCuestionario a
															  inner join RHEvaluacionCuestionarios b
																on a.PCid = b.PCid"/>
						<cfinvokeargument name="columnas" value="a.PCid, a.PCcodigo, a.PCnombre, a.PCdescripcion"/>
						<cfinvokeargument name="desplegar" value="PCcodigo, PCnombre"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Nombre#"/>
						<cfinvokeargument name="formatos" value="S,V"/>
						<cfinvokeargument name="filtro" value="b.Ecodigo = #session.Ecodigo#"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="checkboxes" value="N"/>				
						<cfinvokeargument name="irA" value="CuestionariosEval.cfm"/>
						<cfinvokeargument name="mostrar_filtro" value="yes"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="PCid"/>					
						<cfinvokeargument name="mostrar_filtro" value="yes"/>
						<cfinvokeargument name="filtrar_automatico" value="yes"/>
						<cfinvokeargument name="filtrar_por" value="PCcodigo,PCnombre">
					</cfinvoke>
				</td>
				<td width="55%" valign="top">
					<cfinclude template="CuestionariosEval-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>