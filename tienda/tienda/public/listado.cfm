<html>
<head>
<title>Saulasso's</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfquery datasource="#session.dsn#" name="prodlist">

select c.id_categoria, p.id_producto, r.id_presentacion,
	c.nombre_categoria, p.nombre_producto, r.nombre_presentacion,
	r.sku, r.precio
from Categoria c, Producto p, ProductoCategoria pc, Presentacion r
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and c.id_categoria = pc.id_categoria
  and p.id_producto = pc.id_producto
  and r.id_producto =* p.id_producto
order by c.orden_relativo, upper(c.nombre_categoria), c.id_categoria,
	upper(p.nombre_producto), p.id_producto,
	upper(r.nombre_presentacion)
</cfquery>
<table border="0" cellpadding="4" cellspacing="4">
<tr><td><strong>Categor&iacute;a</strong></td>
<td><strong>Producto</strong></td>
<td><strong>Presentaci&oacute;n</strong></td>
<td><strong>Precio</strong></td>
<td><strong>SKU</strong></td>
</tr>
<cfoutput query="prodlist">
<tr><td><cfif CurrentRow EQ 1 OR prev_cat NEQ id_categoria ><strong>#nombre_categoria#</strong></cfif></td>
<td><cfif CurrentRow EQ 1 OR prev_prod NEQ id_producto>#nombre_producto#</cfif></td>
<td>#nombre_presentacion#</td>
<td><cfif precio GT 0><a href="producto.cfm?prod=#id_producto#&pres=#id_presentacion#">#LSCurrencyFormat( precio )#</cfif></a></td><td>#sku#</td></tr>
<cfset prev_cat = id_categoria>
<cfset prev_prod = id_producto>
</cfoutput>
</table>
</body>
</html>
