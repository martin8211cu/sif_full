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
	p.id_producto, r.id_presentacion
from ProductoCategoria pc, Producto p, Presentacion r
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and pc.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#">
  and pc.id_producto = p.id_producto
  and r.id_producto = pc.id_producto
</cfquery>
<form style="margin:0" action="producto2.cfm" name="itemlist_<cfoutput>#cat_info.id_categoria#</cfoutput>">
<script type="text/javascript">
<!--
function send_list_<cfoutput>#cat_info.id_categoria#</cfoutput>() {
	var f = document.itemlist_<cfoutput>#cat_info.id_categoria#</cfoutput>;
	var v = f.items.value.split(",");
	if (v.length == 2) {
		f.prod.value = v[0];
		f.pres.value = v[1];
		f.submit();
	}
}
//-->
</script>

<table align="center" border="0" cellspacing="2" cellpadding="2"
	style="<cfoutput><cfif Len(cat_info.color_borde) GT 1>border:solid 2px #cat_info.color_borde#;<cfelse>border:none;</cfif>
		<cfif Len(cat_info.color_fondo) GT 1>background-color:#cat_info.color_fondo#;</cfif></cfoutput>">
  <tr>
    <td><h2 class="catego"><cfoutput>#cat_info.nombre_categoria#</cfoutput></h2></td>
    <td><input type="hidden" name="prod" value=""><input type="hidden" name="pres" value="">
	<cfoutput>
	<select name="items" class="prod_lista" onChange="send_list_#cat_info.id_categoria#()">
	<option selected>-haga click-</option>
	</cfoutput>
	<cfoutput query="productos">
	<option value="#id_producto#,#id_presentacion#" >#nombre_producto# #nombre_presentacion#
	(#moneda# #LSCurrencyFormat( precio,'none' )# ivi)</option>
	</cfoutput>
	</select>
	</td>
    <td rowspan="3">
		<cfoutput>
		<img align="absmiddle" src="categoria_img.cfm?tid=#session.comprar_Ecodigo#&id=#cat_info.id_categoria#" width="82" height="90" alt="">
		</cfoutput>
	</td>
  </tr>
  <tr>
    <td colspan="2" class="enc_lista"><cfoutput>#cat_info.txt_descripcion#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="2" class="pie_lista"><cfoutput>#cat_info.txt_pie#</cfoutput></td>
  </tr>
</table>
</form>