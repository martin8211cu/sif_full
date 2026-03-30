<cfif IsDefined("url.q") OR IsDefined ("url.cat")>
	<cfif IsDefined("url.q") AND Len(url.q) GT 0>
  B&uacute;squeda de &quot;<em><cfoutput>#HTMLEditFormat(url.q)#</cfoutput></em>&quot;
    </cfif>
<cfquery datasource="#session.dsn#" name="prodlist" maxrows="200">
set rowcount 200
select c.id_categoria, p.id_producto, r.id_presentacion,
	c.nombre_categoria, p.nombre_producto, r.nombre_presentacion,
	r.sku, 
	coalesce(r.precio, p.precio) as precio
from Categoria c, Producto p, ProductoCategoria pc, Presentacion r
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and c.id_categoria = pc.id_categoria
  and p.id_producto = pc.id_producto
  and r.id_producto = p.id_producto
<cfif IsDefined("url.q") and Len (url.q) GT 0>
	and (upper(p.nombre_producto)     like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.q)#%">
	 or  upper(r.nombre_presentacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.q)#%">
	 or       (p.txt_descripcion)     like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.q)#%">
	 or  upper(r.sku)                 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.q)#%">)
</cfif>
<cfif IsDefined ("url.cat") and Len (url.cat) GT 0 and IsNumeric(url.cat) and url.cat NEQ 0>
  and pc.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
</cfif>
order by c.orden_relativo, upper(c.nombre_categoria), c.id_categoria,
	upper(p.nombre_producto), p.id_producto,
	upper(r.nombre_presentacion)
set rowcount 0
</cfquery>

<table border="0" cellpadding="2" cellspacing="0" width="605" align="center">
	<cfset self="">
	<cfif IsDefined("url.cat")><cfset self = self & "&cat=" & URLEncodedFormat(url.cat) ></cfif>
	<cfif IsDefined("url.q"  )><cfset self = self & "&q="   & URLEncodedFormat(url.q)   ></cfif>
	<cfif prodlist.RecordCount EQ 0>
		No se encontraron datos relevantes.
	</cfif>

	<cfoutput query="prodlist" group="id_categoria">
		<tr bgcolor="##CCCCCA"><td colspan="3"><strong><em>Categor&iacute;a: #nombre_categoria#</em></strong></td></tr>
		<tr class="tituloListas">
			<td colspan="2"><strong>Producto</strong></td>
			<td width="200" align="right"><strong>Precio</strong></td>
		</tr>
			
		<cfoutput>
			<tr class="<cfif CurrentRow mod 2 eq 0>listaNon<cfelse>listaPar</cfif>"  onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow mod 2 eq 0>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
				<td width="182"><cfif CurrentRow EQ 1 OR prev_prod NEQ id_producto>
					<a href="producto2.cfm?prod=#id_producto#&pres=#id_presentacion##self#" style="text-decoration:none; ">
					#nombre_producto#</a></cfif>&nbsp;</td>
				<td width="211"><a href="producto2.cfm?prod=#id_producto#&pres=#id_presentacion##self#" style="text-decoration:none;">#nombre_presentacion#&nbsp;</a></td>
				<td align="right" nowrap>&nbsp;&nbsp;&nbsp;<cfif precio GT 0><a href="producto2.cfm?prod=#id_producto#&pres=#id_presentacion##self#" style="text-decoration:none;color:blue; ">
					#LSCurrencyFormat( precio, 'none' )#</cfif></a> #session.comprar_moneda# </td>
			</tr>
			<cfset prev_prod = id_producto>
		</cfoutput>
	</cfoutput>
</table>

</cfif>
