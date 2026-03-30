<style type="text/css">
<!--
.style5 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
-->
</style>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
Trámites
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">

<cf_web_portlet titulo="Trámites">

<table width="100%" border="0">
  <tr>
    <td align="right"><a href="/jsp/sdc/" style="text-decoration:underline;">Inicio</a> | 
	<a href="historia.cfm" style="text-decoration:underline;">Ver historia </a></td>
  </tr>
  <tr>
    <td width="280" class="tituloListas">Iniciar tr&aacute;mite </td>
  </tr>
  <tr>
    <td>
      <table width="100%" border="0">
        <tr align="center">
          <td width="20%"><a href="pasaporte/trpass01.cfm"><img src="images/dgme.gif" alt="Solicitud de pasaporte" height="60" border="0"></a></td>
          <td width="20%"><a href="licencia/trpass01.cfm"><img src="images/mopt.jpg" height="60" border="0"></a></td>
          <td width="20%"><a href="serv_ice/trpass01.cfm"><img src="images/ICE.gif" height="60" border="0"></a></td>
          <td width="20%"><a href="permiso_muni/trpass01.cfm"><img src="images/msj.jpg" height="60" border="0"></a></td>
          <td width="20%"><a href="reclamo_ins/trpass01.cfm"><img src="images/ins.jpg" height="60" border="0"></a></td>
        </tr>
        <tr align="center">
          <td nowrap><span class="style5">Migraci&oacute;n</span></td>
          <td nowrap>&nbsp;</td>
          <td nowrap><span class="style5">              </span></td>
          <td nowrap><span class="style5">Muni San Jos&eacute;</span></td>
          <td nowrap>&nbsp;</td>
        </tr>
        <tr align="center">
          <td nowrap><span class="style5"><strong>Pasaporte</strong></span></td>
          <td nowrap><span class="style5"><strong>Licencia</strong></span></td>
          <td nowrap><span class="style5"><strong>Servicio telef&oacute;nico</strong></span></td>
          <td nowrap><span class="style5"><strong>Permiso de construcci&oacute;n</strong></span></td>
          <td nowrap><span class="style5">              <strong>Reclamo de seguro</strong> </span></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td class="tituloListas">Mi tr&aacute;mites pendientes </td>
  </tr>
  <tr>
    <td>	                <table border="0" cellspacing="0" cellpadding="2" width="100%">
                      <tr>
                        <td valign="top">&nbsp;</td> 
                        <td valign="top"><strong>Fecha</strong></td>
                        <td valign="top"><strong>N&uacute;mero de c&eacute;dula</strong></td>
                        <td valign="top"><strong>Tr&aacute;mite</strong></td>
                        <td valign="top"><strong>Acci&oacute;n solicitada</strong></td>
                        <td valign="top"><strong>Importe</strong></td>
                        <td valign="top"><strong>&nbsp;</strong></td>
                      </tr>
                       
                        <tr>
                          <td class="listaNon" nowrap><img src="images/dgme1.gif" width="30" height="23"></td> 
                          
                            
                          
                          <td class="listaNon" nowrap>14-Abr-2004</td>
                          <td class="listaNon" nowrap> 1-0526-0555</td>
                          <td class="listaNon">Pasaporte</td>
                          <td class="listaNon">Primer pasaporte </td>
                          <td class="listaNon" align="right">
						  45.00 USD   </td>
                          <td class="listaNon" nowrap align="right"> 
                              <span class="listaPar">
                              <input name="button" type="button" style="width:100%" onClick="" value="Imprimir recibo">
                              </span>                            </td>
                        </tr>
                       
                        <tr>
                          <td class="listaPar" nowrap><img src="images/mopt.gif" width="23" height="23"></td> 
                          
                            
                            
                          <td class="listaPar" nowrap>14-Abr-2004</td>
                          <td class="listaPar" nowrap> 1-0526-<span class="listaNon">0555</span></td>
                          <td class="listaPar">Licencia</td>
                          <td class="listaPar">Renovaci&oacute;n de licencia </td>
                          <td class="listaPar" align="right">
						  3 200.00 CRC</td>
                          <td class="listaPar" nowrap align="right"> 
                              <span class="listaNon">
                              <input name="button3" type="button" style="width:100%" onClick="" value="Imprimir recibo">
                              </span>                            </td>
                        </tr>
                       
                        <tr>
                          <td class="listaNon" nowrap><img src="images/ice1.gif" width="26" height="17"></td> 
                          
                            
                          
                          <td class="listaNon" nowrap>14-Abr-2004</td>
                          <td class="listaNon" nowrap> 1-0939-0380</td>
                          <td class="listaNon">Servicio el&eacute;ctrico </td>
                          <td class="listaNon">Instalaci&oacute;n de nuevo servicio </td>
                          <td class="listaNon" align="right">
						  4 200.00 CRC </td>
                          <td class="listaNon" nowrap align="right"> 
                              <span class="listaPar">
                              <input name="button2" type="button" style="width:100%" onClick="" value="Imprimir recibo">
                              </span>                            </td>
                        </tr>
                       
                    </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>



</cf_web_portlet>
</cf_templatearea>
</cf_template>


