<cfif IsDefined("url.q") OR IsDefined ("url.cat")>
	<cfif IsDefined("url.q") AND Len(url.q) GT 0>
  B&uacute;squeda de &quot;<em><cfoutput>#HTMLEditFormat(url.q)#</cfoutput></em>&quot;
    </cfif>
<cfquery datasource="#session.dsn#" name="prodlist" maxrows="200">
set rowcount 200
select c.Ccodigo, p.Aid, r.id_presentacion,
	c.Cdescripcion, p.Adescripcion, r.nombre_presentacion,
	r.sku, 
	coalesce(r.precio, p.precio) as precio
from Clasificaciones c, Articulos p, ProductoCategoria pc, Presentacion r
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and c.Ccodigo = pc.Ccodigo
  and p.Aid = pc.Aid
  and r.Aid = p.Aid
<cfif IsDefined("url.q") and Len (url.q) GT 0>
	and (upper(p.Adescripcion)     like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.q)#%">
	 or  upper(r.nombre_presentacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.q)#%">
	 or       (p.txt_descripcion)     like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.q)#%">
	 or  upper(r.sku)                 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.q)#%">)
</cfif>
<cfif IsDefined ("url.cat") and Len (url.cat) GT 0 and IsNumeric(url.cat) and url.cat NEQ 0>
  and pc.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
</cfif>
order by c.Cpath, upper(c.Cdescripcion), c.Ccodigo,
	upper(p.Adescripcion), p.Aid,
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

	<cfoutput query="prodlist" group="Ccodigo">
		<tr bgcolor="##CCCCCA"><td colspan="3"><strong><em>Categor&iacute;a: #Cdescripcion#</em></strong></td></tr>
		<tr class="tituloListas">
			<td colspan="2"><strong>Articulos</strong></td>
			<td width="200" align="right"><strong>Precio</strong></td>
		</tr>
			
		<cfoutput>
			<tr class="<cfif CurrentRow mod 2 eq 0>listaNon<cfelse>listaPar</cfif>"  onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow mod 2 eq 0>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
				<td width="182"><cfif CurrentRow EQ 1 OR prev_prod NEQ Aid>
					<a href="producto2.cfm?prod=#Aid#&pres=#id_presentacion##self#" style="text-decoration:none; ">
					#Adescripcion#</a></cfif>&nbsp;</td>
				<td width="211"><a href="producto2.cfm?prod=#Aid#&pres=#id_presentacion##self#" style="text-decoration:none;">#nombre_presentacion#&nbsp;</a></td>
				<td align="right" nowrap>&nbsp;&nbsp;&nbsp;<cfif precio GT 0><a href="producto2.cfm?prod=#Aid#&pres=#id_presentacion##self#" style="text-decoration:none;color:blue; ">
					#LSCurrencyFormat( precio, 'none' )#</cfif></a> #session.comprar_moneda# </td>
			</tr>
			<cfset prev_prod = Aid>
		</cfoutput>
	</cfoutput>
</table>

</cfif>
