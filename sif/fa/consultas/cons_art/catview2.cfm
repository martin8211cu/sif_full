<cfinclude template="catinit.cfm">
<cfinclude template="../../../Utiles/sifConcat.cfm">
<cfquery datasource="#session.dsn#" name="subcat" >
	select c.Ccodigo, c.Cdescripcion, 
	(
	  	select count(1)
		from Clasificaciones cat
			join Clasificaciones abajo
				on cat.Ecodigo = abajo.Ecodigo
				and abajo.Cpath like cat.Cpath#_Cat#'%'
			join Articulos art
				on art.Ccodigo = abajo.Ccodigo
				and art.Ecodigo = abajo.Ecodigo
			join DListaPrecios lp
				on lp.Aid = art.Aid
				and lp.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.lista_precios#">
				and lp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where cat.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and cat.Ccodigo = c.Ccodigo
	  ) as cantidad_articulos
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif url.cat>
	  and c.Ccodigopadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	<cfelse>
	  and c.Ccodigopadre is null
	</cfif>
	order by c.Cpath, c.Cdescripcion
</cfquery>

<cfif subcat.RecordCount IS 0>
	<!--- <cfset getPageContext().forward("catsearch.cfm")> --->
	<cflocation url="catsearch.cfm?cat=#url.cat#">
</cfif>
<cfquery datasource="#session.dsn#" name="bestseller" maxrows="5">
set rowcount 5
	select p.Aid, p.Adescripcion, lp.DLprecio as precio, m.Miso4217 as moneda
	from Articulos p
		join DListaPrecios lp
			on lp.Ecodigo = p.Ecodigo
			and lp.Aid = p.Aid
			and lp.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.lista_precios#">
		join Monedas m
			on m.Miso4217 = lp.moneda
			and m.Ecodigo = lp.Ecodigo
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<!---
	  and p.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	--->
	<cfif url.cat>
	  and p.Ccodigo in (
	  	select abajo.Ccodigo
		from Clasificaciones cat
			join Clasificaciones abajo
				on cat.Ecodigo = abajo.Ecodigo
				and abajo.Cpath like cat.Cpath#_Cat#'%'
		where cat.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and cat.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  )</cfif>
  	order by upper(p.Adescripcion)
set rowcount 0
</cfquery>
<cfquery datasource="#session.dsn#" name="featured" maxrows="5">
set rowcount  2
	select p.Aid, p.Adescripcion, lp.DLprecio as precio, m.Miso4217 as moneda
	from Articulos p
		join DListaPrecios lp
			on lp.Ecodigo = p.Ecodigo
			and lp.Aid = p.Aid
			and lp.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.lista_precios#">
		join Monedas m
			on m.Miso4217 = lp.moneda
			and m.Ecodigo = lp.Ecodigo
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<!---
	  and p.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	--->
	<cfif url.cat>
	  and p.Ccodigo in (
	  	select abajo.Ccodigo
		from Clasificaciones cat
			join Clasificaciones abajo
				on cat.Ecodigo = abajo.Ecodigo
				and abajo.Cpath like cat.Cpath#_Cat#'%'
		where cat.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and cat.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  )</cfif>
  	order by upper(p.Adescripcion) desc
set rowcount 0
</cfquery>


<table width="750" border="0">
  <tr valign="top">
    <td colspan="4"><cfinclude template="catpath.cfm"></td>
  </tr>
  <tr>
    <td width="4%" valign="top">&nbsp;</td>
    <td width="44%" height="469" valign="top"><cfif subcat.RecordCount><table width="100%"  cellpadding="4" cellspacing="0" class="catview_table">
      <tr >
        <td  class="catview_thinv">Ver categor&iacute;as 
		<cfif categoria.RecordCount and categoria.Ccodigo> en <strong><cfoutput>#categoria.Cdescripcion#</cfoutput></strong> 
		</cfif>  </td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0">
            <tr valign="top">
              <td width="50%"><ul>
			  <cfoutput query="subcat" maxrows="#Ceiling( subcat.RecordCount / 2)#">
                  <li><a href="catview.cfm?cat=#Ccodigo#" class="catview_link">#Cdescripcion# <em>(#cantidad_articulos#)</em></a></li>
				  </cfoutput>
              </ul></td>
              <td width="50%"><ul>
			  <cfoutput query="subcat" startrow="#Ceiling( subcat.RecordCount / 2) + 1#">
                  <li><a href="catview.cfm?cat=#Ccodigo#" class="catview_link">#Cdescripcion# <em>(#cantidad_articulos#)</em></a></li>
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
            <td width="60" rowspan="2"><a href="prodview.cfm?prod=#Aid#&amp;cat=#URLEncodedFormat(url.cat)#"><img src="producto_img.cfm?tid=#session.Ecodigo#&id=#Aid#&sz=sm" height="60" border="0"></a></td>
            <td width="26">#CurrentRow# .  </td>
            <td width="281"><a href="prodview.cfm?prod=#Aid#&amp;cat=#URLEncodedFormat(url.cat)#" class="catview_link">#Adescripcion#</a></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>Precio: <span class="catview_price">#moneda# #LSCurrencyFormat(precio,'none')#</span></td>
          </tr>
        </cfoutput>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
      </cfif></td>
    <td width="8%" valign="top">&nbsp;</td>
    <td width="44%" valign="top">
      <cfif bestseller.RecordCount><table width="358" border="0">
        <tr>
          <td colspan="3"><span class="catview_th">Los m&aacute;s vendidos </span></td>
        </tr>
		<cfoutput query="bestseller">
        <tr>
          <td width="60" rowspan="2"><a href="prodview.cfm?prod=#Aid#&amp;cat=#URLEncodedFormat(url.cat)#"><img src="producto_img.cfm?tid=#session.Ecodigo#&id=#Aid#&sz=sm" height="60" border="0"></a></td>
          <td width="26">#CurrentRow# . </td>
          <td width="281"><a href="prodview.cfm?prod=#Aid#&amp;cat=#URLEncodedFormat(url.cat)#" class="catview_link">#Adescripcion#</a></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>Precio: <span class="catview_price">#moneda# #LSCurrencyFormat(precio,'none')#</span></td>
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
      </cfif>    <cfoutput><cfif Len(categoria.Ctexto) GT 1> 
      <table width="358" border="0">
        <tr>
          <td><span class="catview_th">Sobre #categoria.Cdescripcion#
          </span></td>
        </tr>
        <tr>
          <td height="184" valign="top"><p>#categoria.Ctexto#</p>
            </td>
        </tr>
      </table></cfif></cfoutput>
    </td>
  </tr>
</table>
