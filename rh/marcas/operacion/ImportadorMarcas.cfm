<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RHRHImportadoresDeMarcas"
	Default="RH-Importadores de Marcas"
	returnvariable="LB_RHRHImportadoresDeMarcas"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Importar Marcas"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
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
</cfsilent>
<cf_templateheader title="#LB_RHRHImportadoresDeMarcas#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#nombre_proceso#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top" align="center"> 						
					<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="RHImportadoresMarcas"/>
						<cfinvokeargument name="columnas" value="RHIMcodigo, RHIMdescripcion, EIid"/>
						<cfinvokeargument name="desplegar" value="RHIMcodigo, RHIMdescripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
						<cfinvokeargument name="formatos" value="V,V"/>
						<cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo#"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="ImportadorMarcas-form.cfm"/>
						<cfinvokeargument name="keys" value="EIid"/>
						<cfinvokeargument name="maxRows" value="15"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="RHIMcodigo, RHIMdescripcion"/>				
					</cfinvoke>
				</td>					
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>