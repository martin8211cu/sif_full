<cf_templateheader title="Gestión de tabla de detalles de tablas de valores"> 
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfif not isdefined("Url.valtabId") and not isdefined("Form.valtabId")>
	No se encontró identificador de valtab  para buscar sus detalles.
<cfelse>
	<cfif isdefined("Url.id") and not isdefined("Form.id")>
		<cfset form.id = url.id>
		<cfset form.modo = 'CAMBIO'>
	</cfif>

	<cfif isdefined("Url.valtabId") and not isdefined("Form.valtabId")>
		<cfset form.valtabId = url.valtabId>  
	</cfif>

	<cfquery name="lista" datasource="asp">
		select id, codigo, descripcion  
		from ValTabDetalle 
		where ValTabid = #form.valtabId#
		 
	</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">

			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Notificaciones'>
			<cfinclude template="/home/menu/navegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<table width="100%" cellpadding="0" cellspacing="0"> 
							<tr>	
								<td valign="top" width="40%"> 
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
											irA="ValTab_detalles.cfm?ValTabid=#form.ValTabid#"
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
					  <td valign="top" width="50%"><cfinclude template="Valtab_detalles_form.cfm"></td>
				</tr>
			</table> 
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>
</cfif>	
<cf_templatefooter>