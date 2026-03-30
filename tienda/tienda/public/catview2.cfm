<cfquery datasource="#session.dsn#" name="subcat" >
	select c.id_categoria, c.nombre_categoria, c.formato
	from Categoria c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and c.categoria_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  and c.id_categoria != 0
	order by c.orden_relativo, c.nombre_categoria
</cfquery>
<cfif subcat.RecordCount IS 0>
	<cfset getPageContext().forward("catsearch.cfm")>
</cfif>
<cfquery datasource="#session.dsn#" name="bestseller" maxrows="5">
set rowcount 5
	select p.id_producto, r.id_presentacion, p.nombre_producto, coalesce (r.precio, p.precio) as precio
	from Presentacion r, Producto p, ProductoCategoria pc, CategoriaRelacion cr
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and cr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and p.Ecodigo = pc.Ecodigo
	  and cr.ancestro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  and pc.id_categoria = cr.hijo
	  and p.id_producto = pc.id_producto
	  and r.id_producto = pc.id_producto
	  and r.Ecodigo = p.Ecodigo
	  and r.id_producto = p.id_producto
  	order by upper(p.nombre_producto)
set rowcount 0
</cfquery>
<cfquery datasource="#session.dsn#" name="featured" maxrows="5">
set rowcount 2
	select p.id_producto, r.id_presentacion, p.nombre_producto, coalesce (r.precio, p.precio) as precio
	from Presentacion r, Producto p, ProductoCategoria pc, CategoriaRelacion cr
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and cr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and p.Ecodigo = pc.Ecodigo
	  and cr.ancestro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  and pc.id_categoria = cr.hijo
	  and p.id_producto = pc.id_producto
	  and r.id_producto = pc.id_producto
	  and r.Ecodigo = p.Ecodigo
	  and r.id_producto = p.id_producto
  	order by upper(p.nombre_producto) desc
set rowcount 0
</cfquery>


<table width="100%" border="0">
  <tr valign="top">
    <td colspan="4"><cfinclude template="catpath.cfm"></td>
  </tr>
  <tr>
    <td width="4%" valign="top">&nbsp;</td>
    <td width="44%" height="469" valign="top"><cfif subcat.RecordCount><table width="100%"  cellpadding="4" cellspacing="0" class="catview_table">
      <tr >
        <td  class="catview_thinv">Ver categor&iacute;as 
		<cfif categoria.RecordCount and categoria.id_categoria> en <strong><cfoutput>#categoria.nombre_categoria#</cfoutput></strong> 
		</cfif>  </td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0">
            <tr valign="top">
              <td width="50%"><ul>
			  <cfoutput query="subcat" maxrows="#Ceiling( subcat.RecordCount / 2)#">
                  <li><a href="catview.cfm?cat=#id_categoria#" class="catview_link">#nombre_categoria#</a></li>
				  </cfoutput>
              </ul></td>
              <td width="50%"><ul>
			  <cfoutput query="subcat" startrow="#Ceiling( subcat.RecordCount / 2) + 1#">
                  <li><a href="catview.cfm?cat=#id_categoria#" class="catview_link">#nombre_categoria#</a></li>
				  </cfoutput>
              </ul></td>
            </tr>
        </table>
		</td>
      </tr>
	  </table></cfif>
	  <table width="100%"  cellpadding="4" cellspacing="0" class="catview_table">
      <tr >
        <td class="catview_thinv">
          <cfinclude template="catsearch-form.cfm"></td>
      </tr>
    </table>
      <cfif featured.RecordCount><table width="358" border="0">
        <tr>
          <td colspan="3"><span class="catview_th">Productos destacados </span></td>
        </tr>
        <cfoutput query="featured">
          <tr>
            <td width="60" rowspan="2"><a href="prodview.cfm?prod=#id_producto#&pres=#id_presentacion#&cat=#URLEncodedFormat(url.cat)#"><img src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#id_producto#&sz=sm" height="60" border="0"></a></td>
            <td width="26">#CurrentRow# . </td>
            <td width="281"><a href="prodview.cfm?prod=#id_producto#&amp;pres=#id_presentacion#&cat=#URLEncodedFormat(url.cat)#" class="catview_link">#nombre_producto#</a></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>Precio: <span class="catview_price">#session.comprar_moneda# #LSCurrencyFormat(precio,'none')#</span></td>
          </tr>
        </cfoutput>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table></cfif></td>
    <td width="8%" valign="top">&nbsp;</td>
    <td width="44%" valign="top">
      <cfif bestseller.RecordCount><table width="358" border="0">
        <tr>
          <td colspan="3"><span class="catview_th">Los m&aacute;s vendidos </span></td>
        </tr>
		<cfoutput query="bestseller">
        <tr>
          <td width="60" rowspan="2"><a href="prodview.cfm?prod=#id_producto#&amp;pres=#id_presentacion#&cat=#URLEncodedFormat(url.cat)#"><img src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#id_producto#&sz=sm" height="60" border="0"></a></td>
          <td width="26">#CurrentRow# . </td>
          <td width="281"><a href="prodview.cfm?prod=#id_producto#&amp;pres=#id_presentacion#&cat=#URLEncodedFormat(url.cat)#" class="catview_link">#nombre_producto#</a></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>Precio: <span class="catview_price">#session.comprar_moneda# #LSCurrencyFormat(precio,'none')#</span></td>
        </tr></cfoutput><cfoutput>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><a class="catview_link" href="catsearch.cfm?cat=#HTMLEditFormat(url.cat)#">M&aacute;s productos...</a></td>
        </tr></cfoutput>
      </table>
      </cfif>    <cfoutput><cfif Len(categoria.txt_descripcion) GT 1> 
      <table width="358" border="0">
        <tr>
          <td><span class="catview_th">Sobre #categoria.nombre_categoria#
          </span></td>
        </tr>
        <tr>
          <td height="184" valign="top"><p>#categoria.txt_descripcion#</p>
            </td>
        </tr>
      </table></cfif></cfoutput>
    </td>
  </tr>
</table>
