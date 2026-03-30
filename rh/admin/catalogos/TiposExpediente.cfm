<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CatalogoDeTiposDeExpediente"
			Default="Cat&aacute;logo de Tipos de Expediente"
			returnvariable="LB_CatalogoDeTiposDeExpediente"/>
					
	  <cf_web_portlet_start titulo="#LB_CatalogoDeTiposDeExpediente#">
			<cfif isdefined("url.TEid") and len(Trim(url.TEid))>
				<cfset Form.TEid = url.TEid>
			</cfif>
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>			 
			<cfset navBarItems[1] = "Estructura Organizacional">
			<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">						
 		    <cfset regresar = "/cfmx/rh/indexEstructura.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			
			<cfset filtro = "CEcodigo = #Session.CEcodigo#">
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
							
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Fecha"
							Default="Fecha"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_Fecha"/>

					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="TipoExpediente"/>
						<cfinvokeargument name="columnas" value="TEid, TEcodigo, TEdescripcion, TEfecha"/>
						<cfinvokeargument name="desplegar" value="TEcodigo, TEdescripcion, TEfecha"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#, #LB_Fecha#"/>
						<cfinvokeargument name="formatos" value="V, V, D"/>
						<cfinvokeargument name="filtro" value="#filtro#"/>
						<cfinvokeargument name="align" value="left, left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>				
						<cfinvokeargument name="irA" value="TiposExpediente.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="TEid"/>
					</cfinvoke>
					</td>
					<td width="60%" valign="top" align="left"><cfinclude template="formTiposExpediente.cfm"></td>
				</tr>
			</table>
	  <cf_web_portlet_end>
<cf_templatefooter>      
