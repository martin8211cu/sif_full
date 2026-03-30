<cfif isdefined("Url.EPcodigo_F") and not isdefined("Form.EPcodigo_F")>
	<cfparam name="Form.EPcodigo_F" default="#Url.EPcodigo_F#">
</cfif>
<cfif isdefined("Url.EPdescripcion_F") and not isdefined("Form.EPdescripcion_F")>
	<cfparam name="Form.EPdescripcion_F" default="#Url.EPdescripcion_F#">
</cfif>
<cfset filtro = "">
<cfset navegacionPuestos = "tab=3&EEid=#form.EEid#">
<cfif isdefined("form.EPcodigo_F") and len(trim(form.EPcodigo_F))>
	<cfset filtro = filtro & " and upper(a.EPcodigo) like '%" & UCase(Form.EPcodigo_F) & "%'">
	<cfset navegacionPuestos = navegacionPuestos & Iif(Len(Trim(navegacionPuestos)) NEQ 0, DE("&"), DE("")) & "EPcodigo_F=" & Form.EPcodigo_F>
</cfif>
<cfif isdefined("form.EPdescripcion_F") and len(trim(form.EPdescripcion_F))>
	<cfset filtro = filtro & " and upper(a.EPdescripcion) like '%" & Ucase(form.EPdescripcion_F) & "%'">
	<cfset navegacionPuestos = navegacionPuestos & Iif(Len(Trim(navegacionPuestos)) NEQ 0, DE("&"), DE("")) & "EPdescripcion_F=" & Form.EPdescripcion_F>	
</cfif>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
			<cfif isdefined("Url.EPid") and not isdefined("Form.EPid")>
				<cfset form.EPid = url.EPid>
				<cfset form.modo = 'CAMBIO'>
			</cfif>

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="40%">
						<table width="100%" cellpadding="0" cellspacing="0"> 
							<tr>
								<td valign="top" width="40%">
									<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
										<form name="formFiltro" method="post" action="TEncuestadoras.cfm">										
											<input type="hidden" name="tab" value="3">
											<cfoutput>					
												<input type="hidden" name="EEid" value="#form.EEid#">
												<cfif isdefined("form.EPid") and len(trim(form.EPid))>
													<input type="hidden" name="EPid" value="#form.EPid#">
												</cfif>
												<tr>
													<td align="right" nowrap><strong>C&oacute;digo:</strong></td>
													<td width="44%">
														<input type="text" name="EPcodigo_F" size="6" maxlength="10" value="<cfif isdefined('form.EPcodigo_F') and Len(trim(form.EPcodigo_F))>#trim(form.EPcodigo_F)#</cfif>" onfocus="this.select();" >
													</td>
													<td align="right"><strong>Descripci&oacute;n:</strong></td>
													<td>
														<input type="text" name="EPdescripcion_F" size="40" maxlength="80" value="<cfif isdefined('form.EPdescripcion_F') and Len(trim(form.EPdescripcion_F))>#trim(form.EPdescripcion_F)#</cfif>" onfocus="this.select();">
													</td>
													<td><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
												</tr>																																				
											</cfoutput>
										</form>
									</table>
								</td>
							</tr>
							<tr>
								<td valign="top" width="40%">
									<cfquery name="rslista" datasource="sifpublica">
											select EAdescripcion,EPid,a.EEid,EPcodigo,EPdescripcion, '3' as tab
											from EncuestaPuesto a 
													inner join 	EmpresaArea c
														on 	a.EAid = c.EAid
													inner join EncuestaEmpresa b
														on a.EEid = b.EEid		
														
															#preservesinglequotes(filtro)#											  								
											where a.EEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
											order by a.EAid,a.EPcodigo,a.EPdescripcion		
									</cfquery>
									<cfinvoke 
										 component="rh.Componentes.pListas"	
										 method="pListaQuery"
										 returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rslista#"/>
											<cfinvokeargument name="desplegar" value="EPcodigo, EPdescripcion"/>
											<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
											<cfinvokeargument name="formatos" value=""/>
											<cfinvokeargument name="align" value="center, left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="TEncuestadoras.cfm"/>
											<cfinvokeargument name="keys" value="EPid"/>
											<cfinvokeargument name="PageIndex" value="4"/>
											<cfinvokeargument name="Cortes" value="EAdescripcion"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="navegacion" value="#navegacionPuestos#"/>
											<cfinvokeargument name="Conexion" value="sifpublica"/>
									</cfinvoke>
								</td>
							</tr>
						</table>
					</td>	
					<td valign="top" width="60%">
						<cfinclude template="formTEPuesto.cfm">
					</td>
				</tr>
			</table> 
		</td>	
	</tr>
</table>	
