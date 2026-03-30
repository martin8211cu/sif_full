<html>
<head>
<title>Saulasso's</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfquery datasource="#session.dsn#" name="prodlist">

select c.Ccodigo, p.Aid, r.id_presentacion,
	c.Cdescripcion, p.Adescripcion, r.nombre_presentacion,
	r.sku, r.precio
from Clasificaciones c, Articulos p, ProductoCategoria pc, Presentacion r
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and c.Ccodigo = pc.Ccodigo
  and p.Aid = pc.Aid
  and r.Aid =* p.Aid
order by c.Cpath, upper(c.Cdescripcion), c.Ccodigo,
	upper(p.Adescripcion), p.Aid,
	upper(r.nombre_presentacion)
</cfquery>
<table border="0" cellpadding="4" cellspacing="4">
<tr><td><strong>Categor&iacute;a</strong></td>
<td><strong>Articulos</strong></td>
<td><strong>Presentaci&oacute;n</strong></td>
<td><strong>Precio</strong></td>
<td><strong>SKU</strong></td>
</tr>
<cfoutput query="prodlist">
<tr><td><cfif CurrentRow EQ 1 OR prev_cat NEQ Ccodigo ><strong>#Cdescripcion#</strong></cfif></td>
<td><cfif CurrentRow EQ 1 OR prev_prod NEQ Aid>#Adescripcion#</cfif></td>
<td>#nombre_presentacion#</td>
<td><cfif precio GT 0><a href="producto.cfm?prod=#Aid#&pres=#id_presentacion#">#LSCurrencyFormat( precio )#</cfif></a></td><td>#sku#</td></tr>
<cfset prev_cat = Ccodigo>
<cfset prev_prod = Aid>
</cfoutput>
</table>
</body>
</html>
