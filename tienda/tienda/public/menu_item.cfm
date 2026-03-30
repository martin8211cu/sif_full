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
select p.nombre_producto, r.nombre_presentacion,
	coalesce (r.precio, p.precio) as precio,
	coalesce (r.moneda, p.moneda) as moneda,
	p.id_producto, r.id_presentacion, p.txt_descripcion
from ProductoCategoria pc, Producto p, Presentacion r
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and pc.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#">
  and pc.id_producto = p.id_producto
  and r.id_producto = pc.id_producto
</cfquery>
<!-- agrupar por producto -->
<cfquery dbtype="query" name="prodgrp">
	select distinct id_producto from productos order by nombre_producto
</cfquery>

<cfset max_columnas = cat_info.columnas>
<cfif max_columnas EQ 0>
	<cfset max_columnas = 4>
</cfif>
<cfif max_columnas GT prodgrp.RecordCount>
	<cfset max_columnas = prodgrp.RecordCount>
</cfif>

<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
</cfoutput>
<cfoutput><tr>
<td colspan="#max_columnas#">
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr><td align="center"><h2 class="catego">#cat_info.nombre_categoria#</h2></td><td rowspan="2">
	<cfif cat_info.hay_imagen_categoria EQ 1>
	<img align="right" src="categoria_img.cfm?tid=#session.comprar_Ecodigo#&id=#id_categoria#" width="91" height="89" alt="">
	</cfif>
	</td></tr>
	<tr><td align="center" class="enc_item">
	#cat_info.txt_descripcion#</td></tr></table>
</td>
</tr></cfoutput>
<tr>
<!-- recorrer por producto -->
<cfloop query="prodgrp">
	<cfquery dbtype="query" name="thisprod">
	select * from productos where id_producto = #prodgrp.id_producto#
	</cfquery>
	
		<td  height="107" valign="top"> <table width="100%" height="100%" cellpadding="2" cellspacing="0"
	style="<cfoutput><cfif Len(cat_info.color_borde) GT 1>border:solid 2px #cat_info.color_borde#;<cfelse>border:none;</cfif>
		<cfif Len(cat_info.color_fondo) GT 1>background-color:#cat_info.color_fondo#;</cfif></cfoutput>" >
		<tr>
		<cfif cat_info.opc_img_prod EQ 1>
		<cfoutput>
		<td rowspan="2" align="center" valign="middle"><img src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#thisprod.id_producto#" width="91" height="89" alt=""></td>
		</cfoutput>
		</cfif>
		<td align="center" valign="middle">
		<cfoutput><span class="prod_item">#thisprod.nombre_producto#</span>
			<cfif cat_info.opc_desc_prod><br><span class="text_item">#thisprod.txt_descripcion#</span></cfif></cfoutput>
		<cfif thisprod.RecordCount GT 1>
			</td>
			<td align="center" valign="middle">
		<cfelse>
			<br>
		</cfif>
		<cfoutput query="thisprod">
		<cfif CurrentRow GT 1><br></cfif>
		<a href="producto.cfm?prod=#id_producto#&pres=#id_presentacion#">
		<span class="prec_item">
		#moneda# #LSCurrencyFormat( precio, 'none')# ivi</span></a><br>
		<span class="pres_item">#nombre_presentacion#</span>
		</cfoutput></td>
		</tr>
		</table></td>
	
	<cfif CurrentRow mod max_columnas EQ 0 AND CurrentRow NEQ RecordCount></tr><tr></tr></cfif>
</cfloop>

<tr><cfoutput>
<td colspan="#max_columnas#" align="center" valign="middle" class="pie_item">#cat_info.txt_pie#</td>
</tr></cfoutput>
</table>