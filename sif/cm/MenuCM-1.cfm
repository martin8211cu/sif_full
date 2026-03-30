<!--- ============================ --->
<!--- OPCIONES DE OPERACION --->
<!--- ============================ --->
<cf_templateheader title="Compras">
	<br>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Menú Principal de Compras">
		<cfinclude template="MCM-frameOpciones.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" align="center"	width="75%">
					<cfif ArrayLen(operaciones) gt 0>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<cfloop from="1" to="#ArrayLen(operaciones)#" index="i">
								<cfset opcion = StructNew()>
								<cfset opcion = operaciones[i]>
								<cfoutput>
								<tr>
									<td width="1%" align="right" valign="middle"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
									<td align="left" valign="middle"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
								</tr>
								<tr>
									<td colspan="2">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="5%">&nbsp;</td>
													<td class="etiquetaProgreso">#opcion.descripcion#<br><br></td>
												</tr>
										</table>
									</td>
								</tr>
								</cfoutput>
							</cfloop>
						</table>
					<cfelse>
						Usted No tiene acceso para realizar ninguna operaci&oacute;n en este M&oacute;dulo.
					</cfif>
				</td>
				<td valign="top" align="center" width="25%">
					<table width="95%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cfinclude template="MCM-frameConsultas.cfm"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cfinclude template="MCM-frameCatalogos.cfm"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cfinclude template="MCM-frameOtros.cfm"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>