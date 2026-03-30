<cfif isdefined("Url.EAdescripcion_F") and not isdefined("Form.EAdescripcion_F")>
	<cfparam name="Form.EAdescripcion_F" default="#Url.EAdescripcion_F#">
</cfif>

<cfset filtro = "">
<cfset navegacionAreas = "tab=2&EEid=#form.EEid#">
<cfif isdefined("form.EAdescripcion_F") and len(trim(form.EAdescripcion_F))>
	<cfset filtro = filtro & " and upper(a.EAdescripcion) like '%" & UCase(Form.EAdescripcion_F) & "%'">
	<cfset navegacionAreas = navegacionAreas & Iif(Len(Trim(navegacionAreas)) NEQ 0, DE("&"), DE("")) & "EAdescripcion_F=" & Form.EAdescripcion_F>
</cfif>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
			<cfif isdefined("Url.EAid") and not isdefined("Form.EAid")>
				<cfset form.EAid = url.EAid>
				<cfset form.modo = 'CAMBIO'>
			</cfif>

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>							
								<td valign="top" width="40%">
									<form name="formFiltro" method="post" action="TEncuestadoras.cfm" style="margin: '0' ">
										<cfoutput>	
											<input type="hidden" name="tab" value="2">
											<input type="hidden" name="EEid" value="<cfif isdefined("form.EEid") and len(trim(form.EEid))>#form.EEid#</cfif>">												
											<cfif isdefined("form.EAid") and len(trim(form.EAid))>
												<input type="hidden" name="EAid" value="#form.EAid#">
											</cfif>

											<table width="100%"  border="0" class="areaFiltro">
											  <tr>
												<td align="right"><strong>&Aacute;rea:&nbsp;</strong></td>
												<td>
												  <input type="text" name="EAdescripcion_F" size="40" maxlength="80" value="<cfif isdefined('form.EAdescripcion_F') and Len(trim(form.EAdescripcion_F))>#trim(form.EAdescripcion_F)#</cfif>" onFocus="this.select();" >
												</td>
												<td width="15%" align="center" valign="middle"><input name="btnFiltrar" type="submit" id="btnFiltrar3" value="Filtrar"></td>
											  </tr>
											</table>
									 	</cfoutput>
								 	</form>	
							  </td>
							</tr>
							<tr>	
								<td valign="top" width="40%">
									<cfinvoke 
										 component="rh.Componentes.pListas"	
										 method="pListaRH"
										 returnvariable="pListaRet">
											<cfinvokeargument name="tabla" value="EmpresaArea a, EncuestaEmpresa b"/>
											<cfinvokeargument name="columnas" value="EAid,a.EEid,EACodigo,EAdescripcion,'2' as tab"/>
											<cfinvokeargument name="desplegar" value="EACodigo,EAdescripcion"/>
											<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
											<cfinvokeargument name="formatos" value="T,T"/>
											<cfinvokeargument name="filtro" value=" a.EEid = b.EEid and a.EEid = #form.EEid# #preservesinglequotes(filtro)#"/>
											<cfinvokeargument name="align" value="left,left"/>
											<cfinvokeargument name="ajustar" value="N,N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="TEncuestadoras.cfm"/>
											<cfinvokeargument name="keys" value="EAid"/>
											<cfinvokeargument name="PageIndex" value="3"/>
											<cfinvokeargument name="navegacion" value="#navegacionAreas#"/>
											<cfinvokeargument name="Conexion" value="sifpublica"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
										</cfinvoke>
								</td>
							</tr>
						</table>
					</td>	
					  <td valign="top" width="50%"><cfinclude template="formTEArea.cfm"></td>
				</tr>
			</table> 
		</td>	
	</tr>
</table>	