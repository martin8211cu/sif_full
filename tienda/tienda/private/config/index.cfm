<cf_template>
<cf_templatearea name="title"> Dise&ntilde;o gr&aacute;fico</cf_templatearea>
<cf_templatearea name="left"> </cf_templatearea>
<cf_templatearea name="header"> </cf_templatearea>
<cf_templatearea name="body">

<cfset regresar = '/cfmx/tienda/tienda/private/config/index.cfm'>
<cfinclude template="../../../portlets/pNavegacion.cfm">

<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Configuración de Tienda">
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr>
				  <td width='40'>&nbsp;</td> 
				  <td width='4'>&nbsp;</td>
				  <td colspan="6" class="subTitulo">&nbsp;</td>
				</tr>
				<tr>
				  <td width="4" valign="top" rowspan="11"><cfinclude template="select-tienda.cfm">

&nbsp;</td> 
				  <td>&nbsp;</td>
				  <td colspan="6" class="subTitulo" ><strong>Seleccione una Opción:</strong></td>
				</tr>

				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle" nowrap>&nbsp;</td>
				  <td>&nbsp;</td>
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
				  <td width="37" ><font size="2"><a href='tienda.cfm'><img src='../../../Imagenes/CxP01_T.gif' width="32" height="32" border="0"></a></font></td>
				  <td valign="middle"><font size="2"><a href='tienda.cfm'>Logotipo y dise&ntilde;o gr&aacute;fico</a></font></td>
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
				  <td ><font size="2"><a href="monedas.cfm"><img src='../../../Imagenes/Tesoreria.gif' width="32" height="32" border="0"></a></font></td>
				  <td valign="middle" nowrap><font size="2"><a href="monedas.cfm">Monedas aceptadas</a></font></td>
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
				  <td ><font size="2"><a href="categoria.cfm"><img src='../../../Imagenes/Anexos01.gif' width="32" height="32" border="0"></a></font></td>
				  <td valign="middle" nowrap><font size="2"><a href="categoria.cfm">Categor&iacute;as o departamentos</a></font></td>
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
				  <td width='4'>&nbsp;</td>
				  <td >&nbsp;</td>
				  <td valign="middle">&nbsp;</td>
				  <td ><font size="2"><a href='producto.cfm'><img src='../../../Imagenes/Inventarios01_T.gif' width="32" height="32" border="0"></a></font></td>
				  <td valign="middle"><font size="2"><a href='producto.cfm'>Cat&aacute;logo de Productos</a></font></td>
				  <td width='130' valign="middle" nowrap>&nbsp;</td>
				  <td width='17'>&nbsp;</td>
				</tr>
				
				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
			  </tr>
				<tr><td colspan="8">&nbsp;</td></tr>
				
				<cfif isdefined("session.Ecodigo") and len(trim(session.Ecodigo)) gt 0 >
				<tr><td colspan="7" align="center">
					<cf_web_portlet border="true" skin="info1" tituloalign="center" >
						<table width="100%">
							<tr><td colspan="6" align="center"><strong>Usted esta trabajando con la Tienda <cfoutput>#session.Enombre#</cfoutput>.</strong></td></tr>
							<tr><td colspan="6" align="center"><strong>Si desea trabajar con otra tienda, seleccionela del combo de Tienda.</strong></td></tr>
						</table>
					</cf_web_portlet>
				</td></tr>
				</cfif>
				
				<tr><td colspan="8">&nbsp;</td></tr>
				

			</table>
</cf_web_portlet>

</cf_templatearea>
</cf_template>