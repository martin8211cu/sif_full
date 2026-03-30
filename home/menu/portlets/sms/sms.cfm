<form name="formsms" id="formsms" action="/cfmx/home/menu/portlets/sms/sms_send.cfm" method="get" target="sms_send" onSubmit="this.envia.disabled=true">
<table width="150" border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td width="144" colspan="2">N&uacute;mero de Tel&eacute;fono </td>
  </tr>
  <tr>
    <td colspan="2" ><input type="text" name="tel" size="10" style="width:120px" onFocus="this.select()">
	<input type="hidden" name="from" value="<cfoutput>#HTMLEditFormat(session.Usuario)#</cfoutput>">
	</td>
    </tr>
  <tr>
    <td colspan="2">Mensaje</td>
    </tr>
  <tr>
    <td colspan="2"><textarea name="msg" rows="2" cols="10" style="font-family:Arial, Helvetica, sans-serif;font-size:11px;width:120px" onFocus="this.select()"></textarea></td>
    </tr>
  <tr>
    <td colspan="2"><input name="envia" id="envia" type="submit" value="Enviar"> <iframe name="sms_send" width="1" height="1" style="display:none; "></iframe></td>
  </tr>
</table>
</form>
