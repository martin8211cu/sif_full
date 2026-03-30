<cf_templateheader title="Gestión de tabla de valores"> 
<cfset filtro = "">
 
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
			<cfif isdefined("Url.id") and not isdefined("Form.id")>
				<cfset form.id = url.id>
				<cfset form.modo = 'CAMBIO'>
			</cfif>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Notificaciones'>
			<cfinclude template="/home/menu/navegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>							
								<td valign="top" width="40%">&nbsp;
								 
							  </td>
							</tr>
							<tr>	
								<td valign="top" width="40%">
									<cfquery name="lista" datasource="asp">
										select id, codigo, descripcion  
										from ValTab
									</cfquery>
									<cfinvoke 
										 component="commons.Componentes.pListas"
										 method="pListaQuery"
										 query="#lista#"
										 returnvariable="pListaRet"
											desplegar="id, codigo, descripcion"
											etiquetas="id, codigo, descripcion"
											formatos="S,S,S,C"
											align="left,left,left,center"
											ajustar="N"
											irA="ValTab.cfm"
											keys="id"
											Conexion="asp"
											maxRows="20"
											debug="N"
											showEmptyListMsg="true" >
										</cfinvoke>
								</td>
							</tr>
						</table>
					</td>	
					  <td valign="top" width="50%"><cfinclude template="Valtab_form.cfm"></td>
				</tr>
			</table> 
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	<cf_templatefooter>