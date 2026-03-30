<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Registro de despacho </cf_templatearea>
<cf_templatearea name="header">
<cfinclude template="header.cfm"></cf_templatearea>
<cf_templatearea name="body">


<cfinclude template="/home/menu/pNavegacion.cfm">
		<cf_web_portlet titulo="Registro de Despacho">
		<form name="form1" action="despacho_go.cfm" method="get" onSubmit="return validar(this)">
		
		<table width="494" border="0" align="center">
  <tr>
    <td colspan="2">Ingrese el n&uacute;mero del pedido que desea despachar </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td width="212" rowspan="5"><cfset despacho_progreso_paso = 1>
	<cfinclude template="despacho_progreso.cfm"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td width="109">N&uacute;mero de Pedido </td>
    <td width="159"><input name="num_pedido" type="text" id="num_pedido" maxlength="12" tabindex="1"></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td colspan="2" align="center"><input type="submit" name="Submit" value="Continuar"></td>
    <td align="center">&nbsp;</td>
  </tr>
</table>

</form><script type="text/javascript">
<!--<cfoutput>
	document.form1.num_pedido.focus();
<cfif isdefined("url.ne")>
	alert("El pedido no. #url.ne# no existe.");
<cfelseif isdefined("url.pc")>
	alert("El pedido no. #url.pc# ya ha sido cerrado");
</cfif>

	function validar(f) {
		if (f.num_pedido.value.length == 0) {
			alert("Digite el numero de pedido");
			f.num_pedido.focus();
			return false;
		}
		var n = parseInt(f.num_pedido.value, 10)
		if (isNaN(n) || n <= 0 || (!f.num_pedido.value.match(/^[0-9]+$/))) {
			alert("Digite el numero de pedido");
			f.num_pedido.value = "";
			f.num_pedido.focus();
			return false;
		}
		f.num_pedido.value = n;
		return true;
	}

//</cfoutput>-->
</script>
</cf_web_portlet>


</cf_templatearea>
</cf_template>
