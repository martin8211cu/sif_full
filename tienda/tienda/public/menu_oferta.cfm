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
<table>
<!--DWLayoutTable-->
<cfoutput query="productos">
<tr>
  <td width="214" align="center" valign="middle"> <table width="100%" cellpadding="0" cellspacing="0" class="cuadro"
	style="<cfoutput><cfif Len(cat_info.color_borde) GT 1>border:solid 2px #cat_info.color_borde#;<cfelse>border:none;</cfif>
		<cfif Len(cat_info.color_fondo) GT 1>background-color:#cat_info.color_fondo#;</cfif></cfoutput>">
	  <!--DWLayoutTable-->
	  <tr> 
		<td width="217" height="37" align="center" valign="middle">
		<span class="prod_oferta">#nombre_producto#</span> <span class="pres_oferta">#nombre_presentacion#</span> </td>
	  </tr>
	  <tr>
		<td height="105" valign="top"><ul>
		  <li class='text_oferta'>
		  #ArrayToList(ListToArray(txt_descripcion, Chr(10) & Chr(13)),"</li><li class='text_oferta'>")#
		  </li>
		  </ul>
		  <p align="center"><a href="producto.cfm?prod=#id_producto#&amp;pres=#id_presentacion#" class="prec_oferta">
		  #moneda# #LSCurrencyFormat( precio, 'none')#
			ivi</a> </p></td>
	  </tr>
	</table></td>
</tr>
<tr> 
  <td height="6" valign="top"></td></tr>
</cfoutput>
</table>
