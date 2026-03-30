<cfif isdefined("Url.ETdescripcion_F") and not isdefined("Form.ETdescripcion_F")>
	<cfparam name="Form.ETdescripcion_F" default="#Url.ETdescripcion_F#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "tab=1&EEid=#form.EEid#">
<cfif isdefined("form.ETdescripcion_F") and len(trim(form.ETdescripcion_F))>
	<cfset filtro = filtro & " and upper(a.ETdescripcion) like '%" & Ucase(form.ETdescripcion_F) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ETdescripcion=" & Form.ETdescripcion>
</cfif>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" width="100%">
			<cfif isdefined("Url.ETid") and not isdefined("Form.ETid")>
				<cfset form.ETid = url.ETid>
				<cfset form.modo = 'CAMBIO'>
			</cfif>

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">										
							<tr>
								<td valign="top">

								<form name="formFiltro" method="post" action="TEncuestadoras.cfm" style="margin: '0' ">										
									<cfoutput>					
										<input type="hidden" name="EEid" value="<cfif isdefined("form.EEid") and len(trim(form.EEid))>#form.EEid#</cfif>">												
										<cfif isdefined("form.ETid") and len(trim(form.ETid))>
											<input type="hidden" name="ETid" value="#form.ETid#">
										</cfif>											
										<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
											<tr class="areaFiltro">
												<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
												<td>
													<input type="text" name="ETdescripcion_F" size="40" maxlength="80" value="<cfif isdefined('form.ETdescripcion_F') and Len(trim(form.ETdescripcion_F))>#trim(form.ETdescripcion_F)#</cfif>" onfocus="this.select();">
												</td>														
												<td>
													<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
												</td>
											</tr>											
										</table>
									</cfoutput>
								</form>
								</td>
							</tr>												
							<tr>
								<td valign="top">
									<cfinvoke 
										 component="rh.Componentes.pListas"	
										 method="pListaRH"
										 returnvariable="pListaRet">
											<cfinvokeargument name="tabla" value="EmpresaOrganizacion a, EncuestaEmpresa b"/>
											<cfinvokeargument name="columnas" value="ETid,a.EEid,ETdescripcion, EEnombre"/>
											<cfinvokeargument name="desplegar" value="ETdescripcion"/>
											<cfinvokeargument name="etiquetas" value="Tipo Organizaci&oacute;n"/>
											<cfinvokeargument name="formatos" value="T"/>
											<cfinvokeargument name="filtro" value="a.EEid = b.EEid and a.EEid=#form.EEid# #preservesinglequotes(filtro)#"/>
											<cfinvokeargument name="align" value="left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="TEncuestadoras.cfm"/>
											<cfinvokeargument name="keys" value="ETid"/>
											<cfinvokeargument name="PageIndex" value="2"/>											
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="Conexion" value="sifpublica"/>
									</cfinvoke>
								</td>																					  
							</tr>
						</table>
					</td>								
					<td valign="top" width="50%">
						 <cfinclude template="formTEOrganizaciones.cfm"> 
					</td>
				</tr>							
			</table> 
		</td>	
	</tr>			
</table>	
		