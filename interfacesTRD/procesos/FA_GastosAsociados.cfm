<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Opciones de Futuros
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
	<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Opciones de Futuros">
	<!---
		<cfinclude template="../portlets/pNavegacion.cfm">
		--->

		<br>
		<br>
		<br>

		<table width="88%" border="0" cellspacing="0" cellpadding="4">

			<tr>
				<td width="70%" height="261" valign="top"><table width="50%" border="0" align="center" cellpadding="0" cellspacing="0">
                  <!--- Operaciones Abiertas --->
                  <tr>
                    <td width="12%" align="center" ><a href="../ad/catalogos/ParametrosAuxiliaresAD.cfm"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" border="0" /></a> </td>
                    <td width="88%" nowrap class="tituloSeccion"><a href="../ad/catalogos/ParametrosAuxiliaresAD.cfm">Operaciones Abiertas</a> </td>
                  </tr>
                  <tr>
                    <td class="textoSIF3" colspan="2" ><blockquote>
                        <p align="justify">
                          <!--- FALTA HABLADA --->
                        </p>
                    </blockquote></td>
                  </tr>
                  <!--- Operaciones Cerradas --->
                  <tr>
                    <td align="center" ><a href="../ad/catalogos/ParametrosAuxiliaresAD.cfm"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" border="0" /></a> </td>
                    <td class="tituloSeccion" nowrap><a href="../ad/catalogos/ParametrosAuxiliaresAD.cfm">Operaciones Cerradas</a> </td>
                  </tr>
                  <tr>
                    <td class="textoSIF3" colspan="2" ><blockquote>
                        <p align="justify">
                          <!--- FALTA HABLADA --->
                        </p>
                    </blockquote></td>
                  </tr>

                </table></td>
			</tr>
	  </table>
	</cf_web_portlet>
</cf_templatearea>
</cf_template>