<cf_template>
<cf_templatearea name="title">Inicio</cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="portal_control.cfm">

<table width="950"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="76">&nbsp;</td>
    <td width="342">&nbsp;</td>
    <td width="28">&nbsp;</td>
    <td width="446">&nbsp;</td>
    <td width="58">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>P&aacute;gina principal para <cfoutput>#session.menues.SScodigo#</cfoutput> <cfoutput>#session.menues.SMcodigo#</cfoutput> </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top"><cf_web_portlet titulo="Mis Mensajes">
	<em>32 Mensajes sin leer
    </em>	
	<table width="300"  border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="2" class="tituloListas">&nbsp;</td>
    <td width="3" class="tituloListas">&nbsp;</td>
    <td width="62" class="tituloListas">De</td>
    <td width="86" class="tituloListas">Asunto</td>
    <td width="127" class="tituloListas">Fecha</td>
  </tr>
  <tr class="listaNon">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td ><div ><a href="javascript:void(0)">
	Jorge Watson de la sant&iacute;sima trinidad </a></div></td>
    <td ><div ><a href="javascript:void(0)" title="Realizar Cierre Contable">Realizar Cierre Contable </a></div></td>
    <td nowrap >28/10 15:10</td>
  </tr>
  <tr class="listaPar">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td ><div ><a href="javascript:void(0)">Andrea Coto </a></div></td>
    <td ><div ><a href="javascript:void(0)" title="Revisar acci&oacute;n RH">Revisar acci&oacute;n RH </a></div></td>
    <td nowrap >28/10 13:06</td>
  </tr>
  <tr class="listaNon">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><div ><a href="javascript:void(0)">Marcel Bonilla </a></div></td>
    <td  ><div ><a href="javascript:void(0)" title="Almuerzo con clientes">Almuerzo con clientes </a></div></td>
    <td nowrap >28/10 11:10</td>
  </tr>
  <tr class="listaPar">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><div  ><a href="javascript:void(0)">Cristina Oviedo </a></div></td>
    <td ><div ><a href="javascript:void(0)">Realizar Cierre Contable </a></div></td>
    <td nowrap >28/10 07:47</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

	</cf_web_portlet></td>
    <td valign="top">&nbsp;</td>
    <td valign="top"><cf_web_portlet titulo="Resumen financiero">          <table width="300"  border="0" cellspacing="0" cellpadding="2">
            <tr>
              <td width="2" class="tituloListas">&nbsp;</td>
              <td width="3" class="tituloListas">&nbsp;</td>
              <td width="62" class="tituloListas">Indicador</td>
              <td width="86" class="tituloListas">Valor Actual </td>
              <td width="127" class="tituloListas">Mes anterior </td>
              <td width="127" class="tituloListas">Variaci&oacute;n</td>
            </tr>
            <tr class="listaNon">
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td ><div ><a href="javascript:void(0)"> Liquidez </a></div></td>
              <td align="right" ><div ><a href="javascript:void(0)">1.82:1</a></div></td>
              <td align="right" nowrap ><a href="javascript:void(0)">1.78:1</a></td>
              <td align="right" nowrap >+2.24%</td>
            </tr>
            <tr class="listaPar">
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td ><div ><a href="javascript:void(0)">Quick Ratio </a></div></td>
              <td align="right" ><div ><a href="javascript:void(0)" title="Revisar acci&oacute;n RH">1.04:1</a></div></td>
              <td align="right" nowrap ><a href="javascript:void(0)">1.04:1</a></td>
              <td align="right" nowrap >-</td>
            </tr>
            <tr class="listaNon">
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td><div ><a href="javascript:void(0)">Seguridad</a></div></td>
              <td align="right"  ><div ><a href="javascript:void(0)" title="Almuerzo con clientes">3:1</a></div></td>
              <td align="right" nowrap ><a href="javascript:void(0)">3:1</a></td>
              <td align="right" nowrap >-</td>
            </tr>
            <tr class="listaPar">
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td><div  ><a href="javascript:void(0)">Rentabilidad</a></div></td>
              <td align="right" ><div ><a href="javascript:void(0)">110%</a></div></td>
              <td align="right" nowrap ><a href="javascript:void(0)">115%</a></td>
              <td align="right" nowrap >-4.34%</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td colspan="2"><a href="javascript:void(0)">Personalizar...</a></td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>
    </cf_web_portlet></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

</cf_templatearea>
</cf_template>