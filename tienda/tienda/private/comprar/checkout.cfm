<cfif Not IsDefined("session.id_carrito")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>

<cfquery datasource="#session.dsn#" name="carrito">
	select direccion_envio, direccion_facturacion
	from Carrito
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
</cfquery>

  <cfquery datasource="#session.dsn#" name="midireccion">
	select max(direccion_envio) id_direccion
	from Carrito
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  </cfquery>
  
  <cfif Len(midireccion.id_direccion) Is 0>
	  <cfquery datasource="asp" name="midireccion">
		  select id_direccion
		  from Usuario
		  where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  </cfquery>
  </cfif>

<cfquery datasource="#session.dsn#" name="transp">
	select transportista, nombre_transportista
	from Transportista
	order by nombre_transportista
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
		if (f.envdireccion1.value.length < 2) {
			alert("Por favor, introduzca la dirección de envío");
			f.envdireccion1.focus();
			return false;
		}
		if (f.envciudad.value.length < 2) {
			alert("Por favor, introduzca la ciudad en la dirección de envío");
			f.envciudad.focus();
			return false;
		}
		if (f.envestado.value.length < 2) {
			alert("Por favor, introduzca el estado en la dirección de envío.");
			f.envestado.focus();
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
          <td valign="top">            <form action="checkout_go.cfm" method="post" name="form1" style="margin:0" onSubmit="return validar(this)">
	  <table border="0" align="center" cellspacing="2" width="75%">
  <cfoutput>	    <tr>
		  <td width="100%" valign="top">
		  <cf_direccion action="select" key="#midireccion.id_direccion#" name="midirecciondefault">
		  <cf_direccion action="input" title="Dirección de envío" key="#carrito.direccion_envio#" default="#midirecciondefault#" prefix="env">
		  </td>
	    </tr>
	    <tr>
		  <td valign="top"><input type="checkbox" name="misma" id="misma" checked><label for="misma">Usar la misma dirección para la factura</label></td>
	    </tr>
	    <tr>
	      <td>Seleccione el medio de env&iacute;o: </td>
	      </tr>
	    <tr>
	      <td>
	        <select name="transportista"  >
			<cfloop query="transp">
              <option value="#transp.transportista#">#nombre_transportista#</option>
			  </cfloop>
            </select>
	      </span></td>
	      </tr>
	    <tr><td>Observaciones o comentarios adicionales</td></tr>
	    <tr><td><textarea name="observaciones" cols="80" rows="4" style="font-family:Arial, Helvetica, sans-serif " class="flat width100" id="observaciones"></textarea></td></tr>
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
