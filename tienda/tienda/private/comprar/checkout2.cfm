<cfif Not IsDefined("session.id_carrito")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>

<cfquery datasource="#session.dsn#" name="carrito">
	select direccion_envio, direccion_facturacion
	from Carrito
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
</cfquery>

<cf_template>
<cf_templatearea name=title>Informaci&oacute;n de  env&iacute;o
</cf_templatearea>
<cf_templatearea name=header>
<cfinclude template="/tienda/tienda/public/carrito_p.cfm">
</cf_templatearea>
<cf_templatearea name=body>

<script type="text/javascript">
<!--
	function validar(f) {
		if (f.facdireccion1.value.length < 2) {
			alert("Por favor, introduzca la dirección de facturación");
			f.facdireccion1.focus();
			return false;
		}
		if (f.facciudad.value.length < 2) {
			alert("Por favor, introduzca la ciudad en la dirección de facturación");
			f.facciudad.focus();
			return false;
		}
		if (f.facestado.value.length < 2) {
			alert("Por favor, introduzca el estado en la dirección de facturación.");
			f.facestado.focus();
			return false;
		}
		return true;
	}
//-->
</script>

<cfinclude template="../../public/estilo.cfm">

<style type="text/css">
.width100{ width:90%; }
</style>

<table width="100%">
        <!--DWLayoutTable-->
        <tr> 
          <td valign="top">            <form action="checkout2_go.cfm" method="post" name="form1" style="margin:0" onSubmit="return validar(this)">
	  <table border="0" align="center" cellspacing="2" width="75%">
  <cfoutput>	    <tr>
		  <td width="100%" valign="top"><cf_direccion action="display" title="Dirección de envío" key="#carrito.direccion_envio#" default="#session.datos_personales#" prefix="env"></td>
	    </tr>
	    <tr>
		  <td valign="top"><cf_direccion action="input" title="Dirección de facturación" key="#carrito.direccion_facturacion#" default="#session.datos_personales#" prefix="fac"></td>
	    </tr>
  </cfoutput>	  <tr>
		  <td align="center">&nbsp;</td>
	    </tr>
	    <tr>
		  <td align="center"><input name="pago" type="submit" id="pago" value="Siguiente" src="../../images/btn_realizarpago.gif" alt="Realizar pago"></td>
	    </tr>
	  </table>
              </form></td>
        </tr>
</table>

</cf_templatearea>
</cf_template>
