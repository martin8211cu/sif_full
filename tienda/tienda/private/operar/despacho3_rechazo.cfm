<cfparam name="url.num_pedido" type="numeric">
<cfparam name="url.num_envio" type="numeric">
<cfparam name="url.msg" type="string">

<cf_template>
<cf_templatearea name="title">
	Su tarjeta ha sido denegada </cf_templatearea>
<cf_templatearea name="left">
</cf_templatearea>
<cf_templatearea name="body">

	<cfinclude template="/home/menu/pNavegacion.cfm">

	<br>

	<cfquery name="carrito" datasource="#session.DSN#">
		select 
			c.id_tarjeta, c.moneda, e.total
		from Carrito c, CarritoEnvio e
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_pedido#">
		  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and e.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_pedido#">
		  and e.id_envio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_envio#">
	</cfquery>	

	<cfoutput>
	<table width="98%" align="center" style="border-top-width:1px; border-top-style:solid; border-top-color:##999999; border-left-width:1px; border-left-style:solid; border-left-color:##999999; border-right-width:1px; border-right-style:solid; border-right-color:##999999; border-bottom-width:1px; border-bottom-style:solid; border-bottom-color:##999999;">
		<tr>
		  <td align="center">
			<b><font size="+1">La transacci&oacute;n   ha sido denegada .</font></b><br>		    
			Su pago no se ha podido procesar debido a que la autorizaci&oacute;n de la tarjeta que nos proporcion&oacute; fue denegada. <br>
			Importe de la transacci&oacute;n: #LSNumberFormat(carrito.total,',9.00')# #carrito.moneda#</td>
		</tr>
		<tr>
		  <td align="center"><b><font color="red">&quot;#HTMLEditFormat(url.msg)#&quot;</font></b></td>
		</tr>

		<tr><td align="center">
			<table border="0" width="50%" align="center" cellpadding="3" cellspacing="3" >
				<tr>
				  <td colspan="2" align="left"><cf_tarjeta action="display" key="#carrito.id_tarjeta#">&nbsp;</td>
			  </tr>

			</table>
		</td></tr>

		<tr><td align="center" nowrap><b><font size="1">Muchas gracias por contribuir a nuestro esfuerzo de anunciar la Buena Nueva!!</font></b></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><input type="button" name="regresar" value="Reintentar" onClick="history.go(-1)"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>

</cf_templatearea>
</cf_template>
