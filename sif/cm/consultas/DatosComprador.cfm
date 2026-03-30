<!--- Si los filtros vienen por URL los carga en el form. (Cambio de página) ---->
<cfif isdefined("url.CMCcodigo") and not isdefined("form.CMCcodigo") >
	<cfset form.CMCcodigo = url.CMCcodigo >
</cfif>

<cfif isdefined("url.CMCnombre") and not isdefined("form.CMCnombre") >
	<cfset form.CMCnombre = url.CMCnombre >
</cfif>

<cf_templateheader title="Compras - Consulta de los Datos por Comprador ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Datos por Comprador'>
			
			<cfoutput>
			<form name="form1" method="post" action="DatosComprador.cfm" style="margin: 0">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><cfinclude template="../../portlets/pNavegacionCM.cfm"></td>
					</tr>
					<tr>
						<td nowrap>
							<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
								<tr class="fileLabel"> 
									<td nowrap><strong>C&oacute;digo:&nbsp;</strong></td>
									<td nowrap><input type="text" name="CMCcodigo" size="20" maxlength="100" value="<cfif isdefined("form.CMCcodigo")>#form.CMCcodigo#</cfif>"></td>
									<td nowrap align="right"><strong>Nombre:&nbsp;</strong></td>
									<td nowrap><input type="text" name="CMCnombre" size="60" maxlength="100" value="<cfif isdefined("form.CMCnombre")>#form.CMCnombre#</cfif>"></td>
									<td nowrap align="center">
										<input type="submit" name="btnFiltro"  value="Filtrar">&nbsp;
										<input type="reset" name="btnLimpiar"  value="Limpiar">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td nowrap><cf_rhimprime datos="/sif/cm/consultas/DatosComprador-Reporte.cfm" paramsuri=""></td>
					</tr>
					<tr>
						<td><cfinclude template="DatosComprador-Reporte.cfm"></td>
					</tr>
				</table>
			</form>
			</cfoutput>

		<cf_web_portlet_end>
	<cf_templatefooter>
