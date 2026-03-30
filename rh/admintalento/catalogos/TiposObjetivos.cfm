<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CatalogoDeTiposDeObjetivo"
			Default="Cat&aacute;logo de Tipos de Objetivo"
			returnvariable="LB_CatalogoDeTiposDeObjetivo"/>
					
	  <cf_web_portlet_start titulo="#LB_CatalogoDeTiposDeObjetivo#">
			<cfif isdefined("url.RHTOid") and len(Trim(url.RHTOid))>
				<cfset Form.RHTOid = url.RHTOid>
			</cfif>
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="40%">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Codigo"
							Default="C&oacute;digo"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_Codigo"/>

						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Descripcion"
							Default="Descripci&oacute;n"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_Descripcion"/>
							
					<cfset filtro = "Ecodigo = #Session.Ecodigo#">
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="RHTipoObjetivo"/>
						<cfinvokeargument name="columnas" value="RHTOid, RHTOcodigo, RHTOdescripcion"/>
						<cfinvokeargument name="desplegar" value="RHTOcodigo, RHTOdescripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
						<cfinvokeargument name="formatos" value="V, V"/>
						<cfinvokeargument name="filtro" value="#filtro#"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>				
						<cfinvokeargument name="irA" value="TiposObjetivos.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="RHTOid"/>
					</cfinvoke>
					</td>
					<td width="60%" valign="top" align="left"><cfinclude template="formTiposObjetivos.cfm"></td>
				</tr>
			</table>
	  <cf_web_portlet_end>
<cf_templatefooter>      
