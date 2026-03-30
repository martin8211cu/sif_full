<cfparam name="url.page" default="0">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Picking list</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="despacho.css" rel="stylesheet" type="text/css">

</head>

<body>

		<cfset f_desde = LSParseDateTime(url.desde)>
		<cfset f_hasta = DateAdd("d", 1, LSParseDateTime(url.hasta))>
		
		<cfquery datasource="#session.dsn#" name="data">
		
			select i.id_producto, i.id_presentacion, c.id_carrito, c.direccion_envio,
				i.cantidad, p.nombre_producto, r.nombre_presentacion, r.sku, r.multiplo, c.fcompra,
				coalesce ( sum (e.cantidad), 0) as cantidad_desp
			from Carrito c, Item i, Producto p, Presentacion r, CarritoEnvioItem e
			where c.fcompra >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_desde#">
			  and c.fcompra <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_hasta#">
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			
			  and e.id_carrito =* i.id_carrito
			  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and e.id_producto =* i.id_producto
			  and e.id_presentacion =* i.id_presentacion
			  
			  and c.id_tarjeta is not null
			  and i.Ecodigo         = c.Ecodigo
			  and i.id_carrito      = c.id_carrito
			  and p.Ecodigo         = i.Ecodigo
			  and p.id_producto     = i.id_producto
			  and r.Ecodigo         = i.Ecodigo
			  and r.id_producto     = i.id_producto
			  and r.id_presentacion = i.id_presentacion
			group by i.id_producto, i.id_presentacion, c.id_carrito, c.direccion_envio,
				i.cantidad, p.nombre_producto, r.nombre_presentacion, r.sku, r.multiplo, c.fcompra
			order by c.id_carrito
		</cfquery>
<cfoutput group="id_carrito" query="data">
			
			<table width="652" border="0" style="border:1px solid black;margin-bottom:6px; ">
			  <tr valign="top">
				<td width="173" rowspan="2">
				  <table width="173" border="0">
                    <tr>
                      <td width="167" valign="top" class="picklist_titulo">Fecha del pedido </td>
                    </tr>
                    <tr>
                      <td valign="top"  class="picklist_titulo">#DateFormat(fcompra, 'dd-mm-yyyy')# 
    #TimeFormat(fcompra, 'h:mm tt')# </td>
                    </tr>
                    <tr>
                      <td valign="top" class="picklist_titulo">&nbsp;</td>
                    </tr>
                    <tr>
                      <td valign="top" class="picklist_titulo">Fecha de impresi&oacute;n </td>
                    </tr>
                    <tr>
                      <td valign="top"  class="picklist_titulo">#DateFormat(Now(), 'dd-mm-yyyy')# 
    #TimeFormat(Now(), 'h:mm tt')# </td>
                    </tr>
                  </table></td>
			    <td width="170" align="center" class="picklist_titulo">Pedido n&uacute;mero </td>
			    <td width="293" rowspan="2" class="picklist_titulo">
				<cf_direccion action="label" key="#direccion_envio#" title="">
				</td>
		      </tr>
			  <tr valign="top">
			    <td width="170" align="center" class="picklist_numero"># id_carrito #</td>
		      </tr>
		  </table>

			<br>
			<table width="652" border="1" cellpadding="3" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
			  <tr bgcolor="##CCCCCC">
			    <td width="60"><span class="picklist_header">C&oacute;digo</span></td>
				<td width="130"><span class="picklist_header">Producto</span></td>
				<td width="64" align="right"><span class="picklist_header">Solicitado&nbsp;</span></td>
			    <td width="64" align="right"><span class="picklist_header">Entregado</span></td>
			    <td width="64" align="right"><span class="picklist_header">Saldo</span></td>
			    <td width="82" align="right"><span class="picklist_header">Env&iacute;o</span></td>
			  </tr>
			<cfoutput>
			
			  <tr class="picklist_data">
			    <td valign="top">#sku#</td>
				<td valign="top">#nombre_producto# #nombre_presentacion#</td>
				<td valign="top" align="right">#NumberFormat(cantidad, "0")#&nbsp;</td>
			    <td valign="top" align="right">#NumberFormat(cantidad_desp, "0")#&nbsp;</td>
			    <td valign="top" align="right">#NumberFormat(cantidad - cantidad_desp, "0")#</td>
			    <td valign="top" align="right"><cfif cantidad LE cantidad_desp> - </cfif>&nbsp;</td>
			  </tr>
			  <cfset last = CurrentRow is RecordCount>
			</cfoutput>
	    </table>
			<br>
			<div class="picklist_nota" <cfif url.page and not last> style="page-break-after:always;" </cfif> >Surta este pedido y luego llene este formulario con las 
			cantidades atendidas para la captura de despacho.<br>
			<strong>Notas:</strong><br>
			1.<br>
			<br>
			2.<br>
			<br>
			3.
            <br>
</div>
</cfoutput>

<cfif data.RecordCount EQ 0>
	<script type="text/javascript">
	javascript:alert('Aviso: \u000aNo se encontraron pedidos para estos d\u00edas');
	window.close();
	</script>
	
</cfif>

</body>
</html>
