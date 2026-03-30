<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Opciones de Documentos FACT
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
	<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Opciones de Documentos FACT">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		<br />
		<br />
		<br />

		<table width="88%" border="0" cellspacing="0" cellpadding="4">

			<tr>
				<td width="70%" height="261" valign="top"><table width="50%" border="0" align="center" cellpadding="0" cellspacing="0">

                  <!--- PRODUCTO COMPRAS --->
                  <tr>
                    <td width="12%" align="center" ><a href="/cfmx/interfacesTRD/componentesInterfaz/FacturasProductosParam.cfm"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" border="0" /></a> </td>
                    <td width="88%" nowrap class="tituloSeccion"><a href="/cfmx/interfacesTRD/componentesInterfaz/FacturasProductosParam.cfm">Producto Compras</a> </td>
                  </tr>
                  <tr>
                    <td class="textoSIF3" colspan="2" ><blockquote>
                        <p align="justify">
                          <!--- FALTA HABLADA --->
                        </p>
                    </blockquote></td>
                  </tr>
                  <!--- PRODUCTO VENTAS --->
                  <tr>
                    <td align="center" ><a href="/cfmx/interfacesTRD/componentesInterfaz/FacturasProdVentasParam.cfm"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" border="0" /></a> </td>
                    <td class="tituloSeccion" nowrap><a href="/cfmx/interfacesTRD/componentesInterfaz/FacturasProdVentasParam.cfm">Producto Ventas</a> </td>
                  </tr>
                  <tr>
                    <td class="textoSIF3" colspan="2" ><blockquote>
                        <p align="justify">
                          <!--- FALTA HABLADA --->
                        </p>
                    </blockquote></td>
                  </tr>
                  <!--- FLETES --->
                  <tr>
                    <td align="center" ><a href="/cfmx/interfacesTRD/componentesInterfaz/FacturasFletesParam.cfm"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" border="0" /></a> </td>
                    <td class="tituloSeccion" nowrap><a href="/cfmx/interfacesTRD/componentesInterfaz/fletes-fact/index.cfm">Fletes</a> </td>
                  </tr>
                  <tr>
                    <td class="textoSIF3" colspan="2" ><blockquote>
                        <p align="justify">
                          <!--- FALTA HABLADA --->
                        </p>
                    </blockquote></td>
                  </tr>
                  <!--- GASTOS ASOCIADOS --->
                  <tr>
                    <td align="center" ><a href="/cfmx/interfacesTRD/componentesInterfaz/FacturasGastosAsocParam.cfm"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" border="0" /></a> </td>
                    <td class="tituloSeccion" nowrap><a href="/cfmx/interfacesTRD/componentesInterfaz/gastos/index.cfm">Gastos Asociados</a> </td>
                  </tr>
                  <tr>
                    <td class="textoSIF3" colspan="2" ><blockquote>
                        <p align="justify">
                          <!--- FALTA HABLADA --->
                        </p>
                    </blockquote></td>
                  </tr>
                  <!--- SWAPS Y OPCIONES --->
                  <tr>
                    <td align="center" ><a href="/cfmx/interfacesTRD/componentesInterfaz/FacturasSwapsParam.cfm"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" border="0" /></a> </td>
                    <td class="tituloSeccion" nowrap><a href="/cfmx/interfacesTRD/componentesInterfaz/swaps-fact/index.cfm">Swaps y Opciones</a> </td>
                  </tr>
                  <tr>
                    <td class="textoSIF3" colspan="2" ><blockquote>
                        <p align="justify">
                          <!--- FALTA HABLADA --->
                        </p>
                    </blockquote></td>
                  </tr>
                  <!--- OTROS INGRESOS --->
                  <tr>
                    <td align="center" ><a href="/cfmx/interfacesTRD/componentesInterfaz/OtrosIngresosParam.cfm"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" border="0" /></a> </td>
                    <td class="tituloSeccion" nowrap><a href="/cfmx/interfacesTRD/componentesInterfaz/otrosingresos/index.cfm">Otros Ingresos</a> </td>
                  </tr>
                  <tr>
                    <td colspan="2" class="textoSIF3" ><blockquote>
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