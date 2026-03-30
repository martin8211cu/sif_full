<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 14 de julio del 2005
	Motivo: Nueva opción dentro del Menú Operación y Administración de Sistema. 
			La opción es Notificación para demos, esta lo que hace es registras 
			los diferentes correos de las personas a las cuales se les tiene que 
			notificar cuando se hace la solicitud de una demostración.
 --->
<cf_templateheader title="Cat&aacute;logo de Notificaciones"><cfif isdefined("Url.Emial_F") and not isdefined("Form.Email_F")>
	<cfparam name="Form.Email_F" default="#Url.Email_F#">
</cfif>

<cfset filtro = "">

<cfif isdefined("form.Email_F") and len(trim(form.Email_F))>
	<cfset filtro = filtro & " and upper(a.Email) like '%" & UCase(Form.Email_F) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Email_F=" & Form.Email_F>
</cfif>
<cfif isdefined("form.Nombre_F") and len(trim(form.Nombre_F))>
	<cfset filtro = filtro & " and upper(a.nombre) like '%" & UCase(Form.Nombre_F) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Nombre_F=" & Form.Nombre_F>
</cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
			<cfif isdefined("Url.NDid") and not isdefined("Form.NDid")>
				<cfset form.NDid = url.NDid>
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
									<!--- <form name="formFiltro" method="post" action="TEncuestadoras.cfm" style="margin: '0' ">
										<cfoutput>	
											<cfif isdefined("form.NDid") and len(trim(form.NDid))>
												<input type="hidden" name="NDid" value="#form.NDid#">
											</cfif>

											<table width="100%"  border="0" class="areaFiltro">
											  <tr>
												<td align="right"><strong>&Aacute;rea:&nbsp;</strong></td>
												<td>
												  <input type="text" name="Email_F" size="40" maxlength="80" value="<cfif isdefined('form.Email_F') and Len(trim(form.Email_F))>#trim(form.Email_F)#</cfif>" onFocus="this.select();" >
												</td>
												<td width="15%" align="center" valign="middle"><input name="btnFiltrar" type="submit" id="btnFiltrar3" value="Filtrar"></td>
											  </tr>
											</table>
									 	</cfoutput>
								 	</form>	 --->
							  </td>
							</tr>
							<tr>	
								<td valign="top" width="40%">
									<cfquery name="lista" datasource="asp">
										select NDid, email, nombre, 
										case when tipo = 1 then 'Demostraciones' end as tipo, 
										case when activo = 1 then '<img src=''/cfmx/asp/imagenes/checked.gif'' border=''0''>' 
															 else '<img src=''/cfmx/asp/imagenes/unchecked.gif'' border=''0''>' 
															 end as Activo
										from Notificaciones
									</cfquery>
									<cfinvoke 
										 component="commons.Componentes.pListas"
										 method="pListaQuery"
										 query="#lista#"
										 returnvariable="pListaRet"
											desplegar="email, nombre, tipo, activo"
											etiquetas="Correo Electrónico, Nombre, Tipo de Notificación, Activo"
											formatos="S,S,S,C"
											align="left,left,left,center"
											ajustar="N"
											irA="Notificaciones.cfm"
											keys="NDid"
											Conexion="asp"
											maxRows="20"
											debug="N"
											showEmptyListMsg="true" >
										</cfinvoke>
								</td>
							</tr>
						</table>
					</td>	
					  <td valign="top" width="50%"><cfinclude template="Notificaciones-form.cfm"></td>
				</tr>
			</table> 
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	<cf_templatefooter>