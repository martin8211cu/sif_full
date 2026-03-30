<cf_templateheader title="Reporte de Saldos de Consolidados de &Oacute;rdenes de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Saldos de Consolidados de Ordenes de Compra'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			
			<!--- Carga los parámetros que viene por url --->
			<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar")>
				<cfset form.btnFiltrar = url.btnFiltrar>
			</cfif>
			<cfif isdefined("url.fECOCnumeroI") and not isdefined("form.fECOCnumeroI")>
				<cfset form.fECOCnumeroI = url.fECOCnumeroI>
			</cfif>
			<cfif isdefined("url.fECOCnumeroF") and not isdefined("form.fECOCnumeroF")>
				<cfset form.fECOCnumeroF = url.fECOCnumeroF>
			</cfif>
			<cfif isdefined("url.fECOCfechaI") and not isdefined("form.fECOCfechaI")>
				<cfset form.fECOCfechaI = url.fECOCfechaI>
			</cfif>
			<cfif isdefined("url.fECOCfechaF") and not isdefined("form.fECOCfechaF")>
				<cfset form.fECOCfechaF = url.fECOCfechaF>
			</cfif>
			<cfif isdefined("url.fSNcodigo") and not isdefined("form.fSNcodigo")>
				<cfset form.fSNcodigo = url.fSNcodigo>
			</cfif>
			<cfif isdefined("url.fMcodigo") and not isdefined("form.fMcodigo")>
				<cfset form.fMcodigo = url.fMcodigo>
			</cfif>

			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>&nbsp;</td>
				</tr>
	    		<tr>
      				<td>
						<cfoutput>
						
						<!--- Filtros de la lista --->
						<form style="margin: 0" action="ConsolidadoOCs-filtro.cfm" name="formFiltroConsolidados" method="post">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
								<tr>
									<!--- Proveedor --->
									<td class="fileLabel" nowrap align="right">
										<strong>Proveedor:&nbsp;</strong>
									</td>
									<td class="fileLabel" nowrap>
										<cfif isdefined("form.fSNcodigo") and len(trim(form.fSNcodigo)) gt 0>
											<cf_sifsociosnegocios2 idquery="#form.fSNcodigo#" form="formFiltroConsolidados" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero">
										<cfelse>
											<cf_sifsociosnegocios2 form="formFiltroConsolidados" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero">
										</cfif>
									</td>
									
									<!--- Moneda --->
									<td class="fileLabel" nowrap align="right">
										<strong>Moneda:&nbsp;</strong>
									</td>
									<td class="fileLabel" nowrap>
										<cfif isdefined("form.fMcodigo") and len(trim(form.fMcodigo)) gt 0 and form.fMcodigo neq -1>
											<cf_sifmonedas form="formFiltroConsolidados" Mcodigo="fMcodigo" value="#form.fMcodigo#" Todas="S">
										<cfelse>
											<cf_sifmonedas form="formFiltroConsolidados" Mcodigo="fMcodigo" Todas="S">
										</cfif>
									</td>
								</tr>
								<tr>
									<!--- Fecha desde: --->
									<td align="right"><strong>Fecha Desde:&nbsp;</strong></td>
									<td>
										<cfif isdefined("form.fECOCfechaI") and len(trim(form.fECOCfechaI)) gt 0>
											<cf_sifcalendario conexion="#session.dsn#" form="formFiltroConsolidados" name="fECOCfechaI" value="#form.fECOCfechaI#">
										<cfelse>
											<cf_sifcalendario conexion="#session.dsn#" form="formFiltroConsolidados" name="fECOCfechaI">
										</cfif>
									</td>
									<!--- Fecha hasta: --->
									<td align="right"><strong>Fecha Hasta:&nbsp;</strong></td>
									<td>
										<cfif isdefined("form.fECOCfechaF") and len(trim(form.fECOCfechaF)) gt 0>
											<cf_sifcalendario conexion="#session.dsn#" form="formFiltroConsolidados" name="fECOCfechaF" value="#form.fECOCfechaF#">
										<cfelse>
											<cf_sifcalendario conexion="#session.dsn#" form="formFiltroConsolidados" name="fECOCfechaF">
										</cfif>
									</td>
								</tr>
								<tr>
									<!--- Número de consolidado inicial --->
									<td nowrap align="right">
										<strong>Del N&uacute;mero:&nbsp;</strong>
									</td>
									<td nowrap>
										<cfif isdefined("form.fECOCnumeroI") and len(trim(form.fECOCnumeroI)) gt 0>
											<cf_monto decimales="0" size="18" name="fECOCnumeroI" form="formFiltroConsolidados" value="#form.fECOCnumeroI#">
										<cfelse>
											<cf_monto decimales="0" size="18" name="fECOCnumeroI" form="formFiltroConsolidados">
										</cfif>
									</td>
									<!--- Número de consolidado final --->
									<td nowrap align="right">
										<strong>Al N&uacute;mero:&nbsp;</strong>
									</td>
									<td nowrap>
										<cfif isdefined("form.fECOCnumeroF") and len(trim(form.fECOCnumeroF)) gt 0>
											<cf_monto decimales="0" size="18" name="fECOCnumeroF" form="formFiltroConsolidados" value="#form.fECOCnumeroF#">
										<cfelse>
											<cf_monto decimales="0" size="18" name="fECOCnumeroF" form="formFiltroConsolidados">
										</cfif>
									</td>
								</tr>
								<tr>
									<td align="center" colspan="4">
										<input type="submit" name="btnFiltrar" value="Filtrar">
										<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript: limpiarFiltros();">
									</td>
								</tr>
							</table>
						</form>

						</cfoutput>
					</td>
				</tr>

				<cfif isdefined("form.btnFiltrar")>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<!--- Opciones de generación del reporte --->
					<tr>
						<td>
							<form style="margin: 0" action="" name="formOpcionesReporte" method="post">
							<fieldset>
								<legend>Opciones del Reporte</legend>
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td align="left" colspan="4">
											<strong>Reporte a Generar:&nbsp;</strong>
											<select name="selTipoReporte">
												<option value="R" selected>Resumido</option>
												<option value="D">Detallado</option>
											</select>
										</td>
									</tr>
								</table>
							</fieldset>
							</form>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				
					<!--- Listado de consolidados --->
					<tr>
						<td>
							<cfinclude template="ConsolidadoOCs-lista.cfm">
						</td>
					</tr>
				</cfif>
				
				<tr>
					<td>&nbsp;</td>
				</tr>
				
			</table>
			
			<script language="javascript" type="text/javascript">

				<cfif not isdefined("form.fECOCnumeroI") or len(trim(form.fECOCnumeroI)) eq 0>
					document.formFiltroConsolidados.fECOCnumeroI.value = '';
				</cfif>
				
				<cfif not isdefined("form.fECOCnumeroF") or len(trim(form.fECOCnumeroF)) eq 0>
					document.formFiltroConsolidados.fECOCnumeroF.value = '';
				</cfif>
				
				<cfif not isdefined("form.fMcodigo") or len(trim(form.fMcodigo)) eq 0 or form.fMcodigo eq -1>
					document.formFiltroConsolidados.fMcodigo.value = '-1';
				</cfif>

				function limpiarFiltros()
				{
					document.formFiltroConsolidados.fSNcodigo.value = '';
					document.formFiltroConsolidados.fSNnumero.value = '';
					document.formFiltroConsolidados.fSNnombre.value = '';
					document.formFiltroConsolidados.fMcodigo.value = '-1';
					document.formFiltroConsolidados.fECOCfechaI.value = '';
					document.formFiltroConsolidados.fECOCfechaF.value = '';
					document.formFiltroConsolidados.fECOCnumeroI.value = '';
					document.formFiltroConsolidados.fECOCnumeroF.value = '';
				}

				var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height)
				{
					if(popUpWin)
					{
						if(!popUpWin.closed)
							popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				
				function mostrarReporte(ECOCid, SNcodigo, Mcodigo)
				{
					var params = "?ECOCid=" + ECOCid + "&SNcodigo=" + SNcodigo + "&Mcodigo=" + Mcodigo + "&TipoReporte=" + document.formOpcionesReporte.selTipoReporte.value;
					popUpWindow("/cfmx/sif/cm/consultas/ConsolidadoOCs-vista.cfm" + params, 10, 10, 1000, 550);
				}
				
				function enviarCorreo(ECOCid, SNcodigo, Mcodigo)
				{
					var params = "?ECOCid=" + ECOCid + "&SNcodigo=" + SNcodigo + "&Mcodigo=" + Mcodigo + "&TipoReporte=" + document.formOpcionesReporte.selTipoReporte.value;
					location.href = "/cfmx/sif/cm/consultas/ConsolidadoOCs-vistacorreo.cfm" + params;
				}

			</script>

		<cf_web_portlet_end>
	<cf_templatefooter>
