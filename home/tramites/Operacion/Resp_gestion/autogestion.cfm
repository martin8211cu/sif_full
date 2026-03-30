<cf_template>
<cf_templatearea name=title>Gesti&oacute;n de Tr&aacute;mites</cf_templatearea><cf_templatearea name=body>
<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start titulo="Gestión de Mis Trámites" >
<table width="700" border="0" align="center">
  <tr>
    <td colspan="4" class="subTitulo"><cfinclude template="hdr_persona.cfm"></td>
  </tr>
  <tr>
    <td colspan="4" class="subTitulo">Tr&aacute;mites pendientes </td>
  </tr>
  <tr>
    <td width="128"><em>Fecha</em></td>
    <td width="295"><em>Tr&aacute;mite</em></td>
    <td colspan="2"><em>Iniciado Por </em></td>
  </tr>
  <tr>
    <td>12/5/2005</td>
    <td><a href="edit_tramite.cfm">Renovaci&oacute;n de Pasaporte </a></td>
    <td colspan="2">jvargas / Automercado / Plaza del Sol / Caja 10 </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="3" align="left">
      <form name="form1" method="post" action="">
        <input name="Button" type="button" onClick="location.href='nvo_tramite.cfm'" value="Iniciar Nuevo Trámite &gt;&gt;">
        </form></td>
  </tr>
  <tr>
    <td colspan="5" class="subTitulo">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="5" class="subTitulo">Tr&aacute;mites anteriores </td>
  </tr>
    <tr>
      <td width="128"><em>Fecha</em></td>
      <td width="295"><em>Tr&aacute;mite</em></td>
    <td width="307">&nbsp;</td>
      <td width="337">&nbsp;</td>
    </tr>
    <tr>
      <td>3/4/2000</td>
      <td colspan="3"><a href="edit_tramite.cfm">Solicitud de Pasaporte </a></td>
    </tr>
    <tr>
      <td>12/6/2004</td>
      <td colspan="3"><a href="edit_tramite.cfm">Renovaci&oacute;n de C&eacute;dula </a></td>
    </tr>
  </table>
<cf_web_portlet_end>
</cf_templatearea> </cf_template>