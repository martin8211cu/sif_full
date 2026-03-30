<cfquery datasource="#session.dsn#" name="cat_info" >
	select c.id_categoria, c.nombre_categoria, c.formato, c.columnas,
		c.opc_desc_prod, c.opc_img_prod, c.opc_desc_pres, c.opc_img_pres,
		c.color_borde, c.color_fondo, c.txt_descripcion, c.txt_pie,
		case when datalength(img_foto)>0 then 1 else 0 end as hay_imagen_categoria
	from Categoria c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and c.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#">
</cfquery>
<cfquery name="productos" datasource="#session.dsn#">
select p.id_producto, p.nombre_producto, p.txt_descripcion,
	r.id_presentacion, r.nombre_presentacion,
	coalesce (r.precio, p.precio) as precio, coalesce (r.moneda, p.moneda) as moneda
from ProductoCategoria pc, Producto p, Presentacion r
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and pc.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#">
  and pc.id_producto = p.id_producto
  and r.id_producto = pc.id_producto
</cfquery>

<cfquery dbtype="query" name="pres">
	select distinct nombre_presentacion
	from productos
	order by nombre_presentacion
</cfquery>

<cfquery dbtype="query" name="prod">
	select distinct id_producto, nombre_producto, txt_descripcion
	from productos
	order by nombre_producto
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0"
	style="<cfoutput><cfif Len(cat_info.color_borde) GT 1>border:solid 2px #cat_info.color_borde#;<cfelse>border:none;</cfif>
		<cfif Len(cat_info.color_fondo) GT 1>background-color:#cat_info.color_fondo#;</cfif></cfoutput>">
<!--DWLayoutTable-->
<cfoutput>
<tr>
<td colspan="#pres.RecordCount + 1#" align="center" valign="middle" class="catego"><h2 class="catego">#cat_info.nombre_categoria#</h2></td>
</tr><cfif Len(cat_info.txt_descripcion) GT 1>
<tr> 
<td colspan="#pres.RecordCount + 1#" align="center" valign="middle" class="pie_matriz">#cat_info.txt_descripcion#</td>
</tr></cfif>
</cfoutput>
<tr> 
<td width="288" height="21" align="center" valign="middle">
<cfif cat_info.hay_imagen_categoria EQ 1>
	<cfoutput>
	<img align="right" src="categoria_img.cfm?tid=#session.comprar_Ecodigo#&id=#id_categoria#" width="91" height="89" alt="">
	</cfoutput>
</cfif>
</td>
<cfoutput query="pres">
	<td align="center" valign="middle"><span class="pres_matriz">
	#nombre_presentacion#&nbsp;</span></td>
</cfoutput>
</tr>
<cfloop query="prod">
	<tr> 
	<td valign="middle"><span class="prod_matriz">
	<cfset id_producto = prod.id_producto>
	<cfoutput>#prod.nombre_producto#</cfoutput></span><br>
	<span class="text_matriz"><cfoutput>#txt_descripcion#</cfoutput></span></td>
	<cfloop query="pres">
		<cfquery dbtype="query" name="uno">
		select moneda, precio, id_presentacion from productos
		where id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
		and nombre_presentacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pres.nombre_presentacion#">
		</cfquery>
		<td align="right" valign="middle">
		<cfif Len(uno.precio) GT 0>
			<cfoutput><a href="producto.cfm?prod=#id_producto#&amp;pres=#uno.id_presentacion#" class="prec_matriz">
			#uno.moneda# #LSCurrencyFormat( uno.precio, 'none' )# ivi</a></cfoutput>
		<cfelse>
			&nbsp;
		</cfif></td>
	</cfloop>
	</tr>
</cfloop>
<cfif Len(cat_info.txt_pie) GT 0>
<cfoutput><tr> 
<td align="center" colspan="#pres.RecordCount + 1#" valign="middle" class="pie_matriz">
#cat_info.txt_pie#</td>
</tr></cfoutput></cfif>
</table>
