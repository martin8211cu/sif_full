<!--- Carga los parámetros que vienen por url --->
<cfif isdefined("url.EDRnumeroF") and not isdefined("form.EDRnumeroF")>
	<cfset form.EDRnumeroF = url.EDRnumeroF>
</cfif>
<cfif isdefined("url.EDRreferenciaF") and not isdefined("form.EDRreferenciaF")>
	<cfset form.EDRreferenciaF = url.EDRreferenciaF>
</cfif>
<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>
<cfif isdefined("url.SNcodigoF") and not isdefined("form.SNcodigoF")>
	<cfset form.SNcodigoF = url.SNcodigoF>
</cfif>
<cfif isdefined("url.UsucodigoF") and not isdefined("form.UsucodigoF")>
	<cfset form.UsucodigoF = url.UsucodigoF>
</cfif>

<!--- Carga la navegación --->

<cfset navegacion = "">
<cfif isdefined("form.EDRnumeroF") and len(trim(form.EDRnumeroF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "EDRnumeroF=" & form.EDRnumeroF>
</cfif>
<cfif isdefined("form.EDRreferenciaF") and len(trim(form.EDRreferenciaF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "EDRreferenciaF=" & form.EDRreferenciaF>
</cfif>
<cfif isdefined("form.FechaF") and len(trim(form.FechaF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "FechaF=" & form.FechaF>
</cfif>
<cfif isdefined("form.SNcodigoF") and len(trim(form.SNcodigoF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "SNcodigoF=" & form.SNcodigoF>
</cfif>
<cfif isdefined("form.UsucodigoF") and len(trim(form.UsucodigoF)) gt 0>
	<cfset navegacion = navegacion & Iif(len(Trim(navegacion)) neq 0, DE("&"), DE("")) & "UsucodigoF=" & form.UsucodigoF>
</cfif>

<script language="JavaScript">
	function limpiar(){
		document.filtroDocumentos.UsucodigoF.value = '';
		document.filtroDocumentos.NombreF.value = '';
		document.filtroDocumentos.EDRnumeroF.value = '';
		document.filtroDocumentos.SNcodigoF.value = '';
		document.filtroDocumentos.SNnombreF.value = '';
		document.filtroDocumentos.SNnumeroF.value = '';
		document.filtroDocumentos.EDRreferenciaF.value = '';
		document.filtroDocumentos.FechaF.value = '';
	}
</script>

<cf_templateheader title="Compras">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aprobación de Exceso de Tolerancia en Documentos de Recepción'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
            	<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></td></tr>
				<tr>
					<td>
						<cfoutput>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<cf_rhimprime datos="/sif/cm/operacion/docsAprobarExcTolerancia-listarep.cfm" paramsuri="&#navegacion#&imprime=1">
								</td>
							</tr>
							<!--- Filtro de la lista --->
							<tr>
								<td>
									<form style="margin:0;" name="filtroDocumentos" method="post" action="docsAprobarExcTolerancia-lista.cfm">
									<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
										<tr>
											<td align="right">&nbsp;</td>
											<!--- Número de documento --->
											<td align="right"><strong>N&uacute;mero</strong></td>
											<td>
												<input name="EDRnumeroF" type="text" id="EDRnumeroF" size="20" maxlength="20" value="<cfif isdefined("form.EDRnumeroF")>#form.EDRnumeroF#</cfif>" onFocus="javascript:this.select();">
                                            </td>
											<!--- Referencia --->
											<td align="right"><strong>Referencia</strong></td>
											<td>
												<input name="EDRreferenciaF" type="text" id="EDRreferenciaF" size="20" maxlength="20" value="<cfif isdefined("form.EDRreferenciaF")>#form.EDRreferenciaF#</cfif>" onFocus="javascript:this.select();">
                                            </td>
											<!--- Fecha del documento --->
											<td align="right"><strong>Fecha</strong></td>
											<td>
												<cfif isdefined("form.FechaF")>
													<cf_sifcalendario form="filtroDocumentos" name="FechaF" value="#form.FechaF#">
												<cfelse>
													<cf_sifcalendario form="filtroDocumentos" name="FechaF">
												</cfif>
											</td>
											<td>&nbsp;</td>
											<!--- Botón filtrar --->
											<td align="center">
												<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
											</td>
										</tr>
										<tr>
											<td align="right">&nbsp;</td>
											<!--- Usuario que registró la recepción --->
											<td align="right"><strong>Recepciones de:</strong></td>
											<td>
												<cfif isdefined("form.UsucodigoF") and form.UsucodigoF neq ''>
													<cf_sifusuarioE form="filtroDocumentos" Usucodigo="UsucodigoF" Nombre="NombreF" idusuario="#form.UsucodigoF#" size="40" frame="frame1">
												<cfelse>
													<cf_sifusuarioE conlis="true" form="filtroDocumentos" Usucodigo="UsucodigoF" Nombre="NombreF" size="40" frame="frame1">
												</cfif>
											</td>
											<!--- Proveedor --->
											<td align="right"><strong>N&uacute;mero Socio</strong></td>
											<td>
												<cfset valSNcodF = ''>
												<cfif isdefined('form.SNcodigoF') and form.SNcodigoF neq ''>
													<cfset valSNcodF = form.SNcodigoF>
												</cfif>
												<cf_sifsociosnegocios2 form="filtroDocumentos" idquery="#valSNcodF#" SNtiposocio="P" SNcodigo="SNcodigoF" SNnumero="SNnumeroF" SNnombre="SNnombreF" frame="frame1">
											</td>
											<td>&nbsp;</td>
											<td align="right">&nbsp;</td>
											<td>&nbsp;</td>
											<!--- Botón limpiar --->
											<td align="center"><input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();"></td>
										</tr>
									</table>
									</form>
								</td>
							</tr>
							<!--- Lista de documentos de recepción --->
							<tr>
								<td>
									<cfinclude template="docsAprobarExcTolerancia-listarep.cfm">
								</td>
							</tr>
						</table>
						</cfoutput>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			
			<script language="javascript1.2" type="text/javascript">
				<cfif isdefined("form.ResultadoEnvio")>
					<cfoutput>
						alert("#form.ResultadoEnvio#");
					</cfoutput>
				</cfif>
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>
