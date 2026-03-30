<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		RH-Importadores de Marcas
	</cf_templatearea>	
	<cf_templatearea name="body">
		<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Importadores de Marcas"
			VSgrupo="103"
			returnvariable="nombre_proceso"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Codigo"
			Default="Código"
			returnvariable="LB_Codigo"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Descripcion"
			Default="Descripción"
			returnvariable="LB_Descripcion"/>
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#nombre_proceso#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td width="40%" valign="top"> 
						<!--- Lista --->						
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
							<cfinvokeargument name="irA" value="ImportadoresMarcas.cfm"/>
							<cfinvokeargument name="keys" value="EIid"/>
							<cfinvokeargument name="maxRows" value="15"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="filtrar_por" value="RHIMcodigo, RHIMdescripcion"/>				
						</cfinvoke>
					</td>
					<td valign="top">
						<cfinclude template="ImportadoresMarcas-form.cfm">
					</td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
