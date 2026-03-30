<cf_template>
<cf_templatearea name=title>Tr&aacute;mite</cf_templatearea>
<cf_templatearea name=body>
<cfinclude template="/home/menu/pNavegacion.cfm">


<cf_web_portlet_start titulo="Iniciar trámite" >
<cfinclude template="hdr_persona.cfm">
	<form name="form1" method="post" action="nvo_tramite2.cfm">
	<table width="200" border="0">
    <tr>
      <td>&nbsp;</td>
      <td>Tipo de tr&aacute;mite </td>
    <td>&nbsp;</td>
      <td>Tr&aacute;mite por realizar </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><select name="select" size="6" style="width:100%">
        <option selected>Documentos Personales</option>
        <option>Construcci&oacute;n</option>
        <option>Patentes</option>
      </select></td>
    <td>&nbsp;</td>
      <td><select name="select" size="6" style="width:100%">
          <option>C&eacute;dula - Primera vez</option>
          <option selected>C&eacute;dula - Renovaci&oacute;n</option>
          <option>Pasaporte - Primera vez</option>
          <option>Pasaporte - Renovaci&oacute;n</option>
      </select></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="3" align="right"><input type="submit" name="Submit" value="Siguiente &gt;&gt;"></td>
    </tr>
  </table>
</form><cf_web_portlet_end>


</cf_templatearea>
</cf_template>