<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Operaci&oacute;n de la tienda</cf_templatearea>
<cf_templatearea name="header"><cfinclude template="header.cfm"></cf_templatearea>
<cf_templatearea name="body">


		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Operación de Tienda">
			<table width="50%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr> 
				  <td width='4'>&nbsp;</td>
				  <td colspan="6" class="subTitulo">&nbsp;</td>
				</tr>
				<tr> 
				  <td>&nbsp;</td>
				  <td colspan="6" class="subTitulo" ><strong>Seleccione una Opción:</strong></td>
				</tr>

				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td width="18" valign="middle">&nbsp;</td>
				  <td>&nbsp;</td>
				  <td width="240" >&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr> 
				  <td width='4'>&nbsp;</td>
				  <td width="24" >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td width="37" ><font size="2"><a href='picking.cfm'><img src='../../../Imagenes/Inventarios01_T.gif' width="32" height="32" border="0"></a></font></td>
				  <td valign="middle"><font size="2"><a href='picking.cfm'>Picking List</a></font></td>
				  <td width='130' valign="middle" nowrap>&nbsp;</td>
				  <td width='17'>&nbsp;</td>
				</tr>

				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr> 
				  <td width='4'>&nbsp;</td>
				  <td width="24" >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td width="37" ><font size="2"><a href='despacho.cfm'><img src='../../../Imagenes/CxP01_T.gif' width="32" height="32" border="0"></a></font></td>
				  <td valign="middle"><font size="2"><a href='despacho.cfm'>Registro de despacho</a></font></td>
				  <td width='130' valign="middle" nowrap>&nbsp;</td>
				  <td width='17'>&nbsp;</td>
				</tr>

				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td ><font size="2"><a href="ventas.cfm"><img src='../../../Imagenes/Tesoreria.gif' width="32" height="32" border="0"></a></font></td>
				  <td valign="middle" nowrap><font size="2"><a href="ventas.cfm">Consulta de ventas</a></font></td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td ><font size="2"><a href="vouchers.cfm"><img src='../../../Imagenes/Anexos01.gif' width="32" height="32" border="0"></a></font></td>
				  <td valign="middle" nowrap><font size="2"><a href="vouchers.cfm">Reporte de vouchers</a></font></td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr><td colspan="7">&nbsp;</td></tr>
				
				<cfif isdefined("session.Ecodigo") and len(trim(session.Ecodigo)) gt 0 >
				<tr><td colspan="6" align="center">
					<cf_web_portlet border="true" skin="info1" tituloalign="center" >
						<table width="100%">
							<tr><td colspan="6" align="center"><strong>Usted esta trabajando con la Tienda <cfoutput>#session.Enombre#</cfoutput>.</strong></td></tr>
							<tr><td colspan="6" align="center"><strong>Si desea trabajar con otra tienda, seleccionela del combo de Tienda.</strong></td></tr>
						</table>
					</cf_web_portlet>
				</td></tr>
				</cfif>
				
				<tr><td colspan="7">&nbsp;</td></tr>
				

			</table>
		</cf_web_portlet>
		
		</cf_templatearea>
</cf_template>
