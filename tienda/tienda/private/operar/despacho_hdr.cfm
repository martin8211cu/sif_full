<link href="despacho.css" rel="stylesheet" type="text/css">
<cfoutput>
		<input type="hidden" name="num_pedido" value="#data.id_carrito#">
		<input type="hidden" name="num_envio" value="#data.id_envio#">
		<table border="0" cellpadding="2" cellspacing="0" bgcolor="##ededed" style="border:1px solid ">
		  <tr valign="top">
			<td width="154" align="right"><strong>N&uacute;mero de pedido:&nbsp;</strong></td>
			<td width="128" bgcolor="##e0e0e0"># data.id_carrito #</td>
			<td width="88" rowspan="3" align="right"><strong>Direcci&oacute;n:&nbsp;</strong></td>
			<td width="149" rowspan="3" bgcolor="##e0e0e0" class="picklist_titulo">	
			<cf_direccion action="label" key="#data.direccion_envio#" title="">
			</td>
		  </tr>
		  <tr valign="top">
			<td align="right"><strong>N&uacute;mero de env&iacute;o:&nbsp;</strong></td>
		    <td bgcolor="##e0e0e0"><cfif Len(data.id_envio)>
		      #data.id_envio#
		      <cfelse>
		      Sin asignar
		    </cfif></td>
		  </tr>
		  <tr valign="top">
			<td align="right"><strong>Fecha del pedido:&nbsp;</strong></td>
		    <td bgcolor="##e0e0e0">#DateFormat(data.fcompra, 'dd-mm-yyyy')# #TimeFormat(data.fcompra, 'h:mm tt')# </td>
		  </tr>
</table>
</cfoutput>
