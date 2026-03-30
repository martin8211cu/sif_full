<cf_templateheader title="Muestra de estilos">
<table width="980" border="0" align="center" class="navbar">
  <tr>
    <td width="100%" nowrap="nowrap">&nbsp;</td>
    <td nowrap="nowrap"><a href="styles_compat.cfm">compatible</a></td>
    <td nowrap="nowrap">|</td>
    <td nowrap="nowrap"><a href="styles.cfm?skin=azul">azul</a></td>
    <td nowrap="nowrap">|</td>
    <td nowrap="nowrap"><a href="styles.cfm?skin=verde">verde</a></td>
    <td nowrap="nowrap">|</td>
    <td nowrap="nowrap"><a href="styles.cfm?skin=gris">gris</a></td>
    <td nowrap="nowrap">|</td>
    <td nowrap="nowrap"><a href="styles.cfm?skin=naranja">naranja</a></td>
    <td nowrap="nowrap">|</td>
    <td nowrap="nowrap"><a href="styles.cfm?skin=rosa">rosa</a></td>
  </tr>
</table>
<table width="980" border="0" cellpadding="0" cellspacing="0" align="center">
<tr><td width="200" valign="top">
<cf_menu sscodigo="sif" smcodigo="cc">
</td><td valign="top">
<cfparam name="url.tab" default="1">
<cf_tabs width="780">
        <cf_tab text="Listas" id="1" selected="#url.tab eq 1#">
          <table width="100%" border="0" align="center" cellspacing="0">
            <tr>
              <td class="subTitulo" colspan="4">Listas</td>
            </tr>
            <tr class="tituloListas">
              <td width="93">No.</td>
              <td width="309">tituloListas</td>
              <td width="337">Costo</td>
              <td width="233">Link</td>
            </tr>
            <tr class="listaCorte">
              <td colspan="4">listaCorte</td>
            </tr>
            <tr class="listaPar">
              <td>1</td>
              <td>listaPar</td>
              <td>USD $47.00</td>
              <td><a href="#">Ver más </a></td>
            </tr>
            <tr class="listaNon">
              <td>2</td>
              <td>listaNon</td>
              <td>USD $32.00</td>
              <td><a href="#">Ver más </a></td>
            </tr>
            <tr class="listaParSel">
              <td>3</td>
              <td>listaParSel</td>
              <td>USD $14.00</td>
              <td><a href="#">Ver más </a></td>
            </tr>
            <tr class="listaNon">
              <td>4</td>
              <td>listaNon</td>
              <td>USD $66.00</td>
              <td><a href="#">Ver más </a></td>
            </tr>
            <tr class="listaCorte">
              <td colspan="4">listaCorte</td>
            </tr>
            <tr class="listaPar">
              <td>5</td>
              <td>listaPar</td>
              <td>USD $22.50</td>
              <td><a href="#">Ver más </a></td>
            </tr>
            <tr class="listaNonSel">
              <td>6</td>
              <td>listaNonSel</td>
              <td>USD $46.95</td>
              <td><a href="#">Ver más </a></td>
            </tr>
            <tr class="listaPar">
              <td>7</td>
              <td>listaPar</td>
              <td>USD $12.15 </td>
              <td><a href="#">Ver más </a></td>
            </tr>
            <tr class="listaNon">
              <td>8</td>
              <td>listaNon</td>
              <td>USD $33.99</td>
              <td><a href="#">Ver más </a></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>
        </cf_tab>
        <cf_tab text="Estilos" id="2" selected="#url.tab eq 2#">
          <table width="100%" border="0">
            <tr>
              <td colspan="4" class="subTitulo">Menúes</td>
            </tr>
            <tr>
              <td class="menuhead">&nbsp;</td>
              <td class="menuhead" colspan="3">menuhead Sistema de XXX </td>
            </tr>
            <tr>
              <td width="127">&nbsp;</td>
              <td width="35">&nbsp;</td>
              <td width="54">[IMG]</td>
              <td width="546" class="menutitulo">menutitulo Modulo/Opción </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td class="menuhablada">menuhablada donde se contiene la explicación de lo que hace una opción del sistema </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td colspan="3" class="menuanterior">&lt;&lt; menuanterior </td>
            </tr>
          </table>
          <table border="0" width="100%">
            <tr>
              <td colspan="4" class="subTitulo">Títulos</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td class="tituloAlterno">tituloAlterno</td>
              <td>&equiv; h1</td>
            </tr>
            <tr>
              <td width="17">&nbsp;</td>
              <td width="106">&nbsp;</td>
              <td width="516" class="subTitulo">subTitulo</td>
              <td width="123">&equiv; h2</td>
            </tr>
          </table>
          <table width="100%">
            <tr>
              <td colspan="3" class="subTitulo">Compatibilidad - no usar estos estilos, se mantienen por compatibilidad solamente </td>
            </tr>
            <tr>
              <td width="126">&nbsp;</td>
              <td width="204">Estilo obsoleto </td>
              <td width="434">Puede sustituirse con </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td class="areaFiltro">areaFiltro </td>
              <td >&lt;portlet&gt;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td class="ayuda">ayuda </td>
              <td >&lt;portlet&gt;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td class="etiquetaProgreso">etiquetaProgreso </td>
              <td >texto corriente </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td class="sectionTitle">sectionTitle </td>
              <td class="tituloAlterno" >tituloAlterno</td>
            </tr>
          </table>
          <table border="0" width="100%">
            <tr>
              <td colspan="2" class="subTitulo">Estilos no visuales, que se utilizan para efectos de programación. </td>
            </tr>
            <tr>
              <td width="17%"  class="noprint">&nbsp;</td>
              <td width="83%"  class="noprint">noprint </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>pageEnd </td>
            </tr>
            <tr>
              <td class="cajasinborde">&nbsp;</td>
              <td class="cajasinborde">cajasinborde </td>
            </tr>
            <tr>
              <td class="cajasinbordeb">&nbsp;</td>
              <td class="cajasinbordeb">cajasinbordeb </td>
            </tr>
          </table>
        </cf_tab>
        <cf_tab text="Tipos de Portlet"  id="3" selected="#url.tab eq 3#">Tipos de portlet.
          <div class="subTitulo">Eg.  normal,bold,light,mini,border</div>
          <cfloop list="normal,bold,light,mini,box" index="tipo">
		    <cf_web_portlet titulo="==Portlet #tipo#==" tipo="#tipo#" width="250"> <cfoutput> Muestra de Portlet.<br />
                Estilo: <strong>#tipo#</strong> Ancho: <strong>250px</strong></cfoutput> </cf_web_portlet>
            <br />
          </cfloop>
        </cf_tab>
        <cf_tab text="Formulario"  id="4" selected="#url.tab eq 4#">
          <form>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2" class="subTitulo">Formulario</td>
              </tr>
              <tr>
                <td><label>Nombre</label></td>
                <td><input type="text" value="Mr. Jaramillo" /></td>
              </tr>
              <tr>
                <td valign="top"><label>Color</label></td>
                <td valign="top"><input name="color" id="color1" type="radio" checked="checked" />
                  <label for="color1">Rojo</label>
                  <br />
                  <input name="color" id="color2" type="radio" />
                  <label for="color2">Azul</label></td>
              </tr>
              <tr>
                <td><label>Opci&oacute;n</label></td>
                <td><select>
                    <option>Contado</option>
                    <option selected="selected">Crédito</option>
                    <option>Plazo fijo</option>
                  </select></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left"><br />
                  <table width="100%" border="0">
                    <tr>
                      <td height="30" align="left"><input name="submit3" type="submit" class="btnGuardar" value="Guardar" />
                        <input name="submit3" type="submit" class="btnEliminar" value="Eliminar" />
                        <input name="submit3" type="submit" class="btnNuevo" value="Nuevo" /></td>
                      <td align="right"><input name="submit4" type="submit" class="btnAplicar" value="Aplicar" />
                        <input name="submit4" type="submit" class="btnEmail" value="Email" />
                        <input name="submit4" type="submit" class="btnPublicar" value="Publicar" /></td>
                    </tr>
                    <tr>
                      <td height="30" align="left"><input name="submit32" type="submit" class="btnFiltrar" value="Filtrar" />
                        <input name="submit32" type="submit" class="btnLimpiar" value="Limpiar" />
                        <input name="submit322" type="submit" class="btn" value="Bot&oacute;n corriente" /></td>
                      <td align="right"><input name="submit2" type="submit" class="btnDetalle" value="Detalle" />
                        <input name="button" type="button" class="btnAnterior" value="Anterior" />
                        <input name="submit" type="submit" class="btnSiguiente" value="Siguiente" /></td>
                    </tr>
                  </table></td>
              </tr>
            </table>
          </form>
        </cf_tab>
</cf_tabs></td></tr></table>
<cf_templatefooter>