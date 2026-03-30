<cfparam name="url.s" default="">
<cfparam name="session.comprar_cat" default="0">
<cfparam name="url.cat" type="numeric" default="#session.comprar_cat#">
<cfif session.comprar_cat NEQ url.cat>
	<cfset session.comprar_cat = url.cat>
</cfif>

<cfset url.s = Trim(url.s)>
<!--- esto seria muy bonito si no se enciclara.
	como hay un forward desde catview2 cuando subcat.RecordCount is 0 hacia
	esta página, no se puede hacer este location.
<cfif Len(url.s) Is 0>
	<cflocation url="catview.cfm?cat=#URLEncodedFormat(url.cat)#">
</cfif>
--->
<cf_template>
	<cf_templatearea name="title">Ver categor&iacute;a</cf_templatearea>
	<cf_templatearea name="body">
<cfinclude template="estilo.cfm">
	

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_bestseller" default="1">
<cfquery datasource="#session.dsn#" name="searchsize">
	select count(distinct r.id_presentacion) as SQLRecordCount
	from Presentacion r, Producto p <cfif url.cat>, ProductoCategoria pc, CategoriaRelacion cr</cfif>
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  <cfif url.cat>
	  and p.Ecodigo = pc.Ecodigo
	  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and cr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and cr.ancestro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  and pc.id_categoria = cr.hijo
	  and p.id_producto = pc.id_producto
	  and r.id_producto = pc.id_producto
	  </cfif>
	  and r.Ecodigo = p.Ecodigo
	  and r.id_producto = p.id_producto
	  and (lower(p.nombre_producto) like '%' || lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">) || '%'
	   or  lower(r.nombre_presentacion) like '%' || lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">) || '%'
	       )
set rowcount 0
</cfquery>

<cfset MaxRows_bestseller=12>
<cfset StartRow_bestseller=Min((PageNum_bestseller-1)*MaxRows_bestseller+1,Max(searchsize.SQLRecordCount,1))>
<cfset EndRow_bestseller=Min(StartRow_bestseller+MaxRows_bestseller-1,searchsize.SQLRecordCount)>
<cfset TotalPages_bestseller=Ceiling(searchsize.SQLRecordCount/MaxRows_bestseller)>
<cfset QueryString_bestseller=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_bestseller,"PageNum_bestseller=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_bestseller=ListDeleteAt(QueryString_bestseller,tempPos,"&")>
</cfif>

<cfquery datasource="#session.dsn#" name="bestseller">
set rowcount #StartRow_bestseller + MaxRows_bestseller - 1#
	select distinct p.id_producto, r.id_presentacion, p.nombre_producto, coalesce (r.precio, p.precio) as precio
	from Presentacion r, Producto p <cfif url.cat>, ProductoCategoria pc, CategoriaRelacion cr</cfif>
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  <cfif url.cat>
	  and p.Ecodigo = pc.Ecodigo
	  and pc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and cr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and cr.ancestro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  and pc.id_categoria = cr.hijo
	  and p.id_producto = pc.id_producto
	  and r.id_producto = pc.id_producto
	  </cfif>
	  and r.Ecodigo = p.Ecodigo
	  and r.id_producto = p.id_producto
	  and (lower(p.nombre_producto) like '%' || lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">) || '%'
	   or  lower(r.nombre_presentacion) like '%' || lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">) || '%'
	       )
set rowcount 0
</cfquery>

<cfquery datasource="#session.dsn#" name="categoria" >
	select c.id_categoria, c.nombre_categoria, c.formato, c.txt_descripcion
	from Categoria c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and c.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#" null="#Len(url.cat) IS 0#">
	order by c.orden_relativo, c.nombre_categoria
</cfquery>

<table width="100%" border="0">
  <tr valign="top">
    <td colspan="3"><cfinclude template="catpath.cfm"></td>
  </tr>
  <tr>
    <td width="9%" valign="top">&nbsp;</td>
    <td width="82%" valign="top"><table width="100%"  cellpadding="4" cellspacing="0" class="catview_thinv" >
      <tr >
        <td class="catview_thinv">
		<cfinclude template="catsearch-form.cfm"></td>
      </tr>
    </table></td>
    <td width="9%" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;<span class="catview_th">
	<cfif len(url.s)>
		Resultado de la b&uacute;squeda de &quot;<cfoutput>#HTMLEditFormat(url.s)#</cfoutput>&quot;
		<cfif categoria.RecordCount and categoria.id_categoria>
			en <cfoutput>#categoria.nombre_categoria#</cfoutput>
		</cfif>
	<cfelseif Len(categoria.id_categoria) And categoria.id_categoria>
		Mostrando categor&iacute;a <cfoutput>#categoria.nombre_categoria#</cfoutput>
	<cfelse>
		Listado de todos los productos
	</cfif>
			</span><br>

	<cfif bestseller.RecordCount>
	<table width="738" border="0">
      <tr>
        <td colspan="2"></td>
      </tr>
          
      <tr>
        <td width="369" valign="top"><table width="368" border="0">
      <cfoutput query="bestseller" startRow="#StartRow_bestseller#" maxRows="#Ceiling(MaxRows_bestseller / 2)#">
          <tr>
            <td width="89" rowspan="2"><a href="prodview.cfm?prod=#id_producto#&pres=#id_presentacion#&cat=#URLEncodedFormat(url.cat)#"><img src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#id_producto#&sz=sm" height="60" border="0"></a></td>
            <td width="27" valign="top">#CurrentRow# . </td>
            <td width="238" valign="top"><a href="prodview.cfm?prod=#id_producto#&amp;pres=#id_presentacion#&cat=#URLEncodedFormat(url.cat)#" class="catview_link">#nombre_producto#</a></td>
          </tr>
          <tr>
            <td valign="top">&nbsp;</td>
            <td valign="top">Precio: <span class="catview_price">#session.comprar_moneda# #LSCurrencyFormat(precio,'none')#</span></td>
          </tr>
      </cfoutput>
        </table></td>
		<td width="359" valign="top"><table width="368" border="0">
      <cfoutput query="bestseller" startRow="#StartRow_bestseller + Ceiling(MaxRows_bestseller / 2)#" maxRows="#Ceiling(MaxRows_bestseller / 2)#">
          <tr>
            <td width="89" rowspan="2"><a href="prodview.cfm?prod=#id_producto#&pres=#id_presentacion#&cat=#URLEncodedFormat(url.cat)#"><img src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#id_producto#&sz=sm" height="60" border="0"></a></td>
            <td width="27" valign="top">#CurrentRow# . </td>
            <td width="238" valign="top"><a href="prodview.cfm?prod=#id_producto#&amp;pres=#id_presentacion#&cat=#URLEncodedFormat(url.cat)#" class="catview_link">#nombre_producto#</a></td>
          </tr>
          <tr>
            <td valign="top">&nbsp;</td>
            <td valign="top">Precio: <span class="catview_price">#session.comprar_moneda# #LSCurrencyFormat(precio,'none')#</span></td>
          </tr>
      </cfoutput>
        </table></td>
      </tr>
      <tr>
        <td colspan="2">&nbsp; <cfoutput>Mostrando resultados del #StartRow_bestseller# al #EndRow_bestseller# de #searchsize.SQLRecordCount# </cfoutput> </td>
      </tr>
<tr>
  <td colspan="2">
    <table border="0" width="23%" align="center">
        <cfoutput>
          <tr>
            <td width="23%" align="center">
              <cfif PageNum_bestseller GT 1>
                <a href="#CurrentPage#?PageNum_bestseller=1#QueryString_bestseller#"><img src="images/First.gif" border=0></a>
              </cfif>
            </td>
            <td width="31%" align="center">
              <cfif PageNum_bestseller GT 1>
                <a href="#CurrentPage#?PageNum_bestseller=#Max(DecrementValue(PageNum_bestseller),1)##QueryString_bestseller#"><img src="images/Previous.gif" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center">
              <cfif PageNum_bestseller LT TotalPages_bestseller>
                <a href="#CurrentPage#?PageNum_bestseller=#Min(IncrementValue(PageNum_bestseller),TotalPages_bestseller)##QueryString_bestseller#"><img src="images/Next.gif" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center">
              <cfif PageNum_bestseller LT TotalPages_bestseller>
                <a href="#CurrentPage#?PageNum_bestseller=#TotalPages_bestseller##QueryString_bestseller#"><img src="images/Last.gif" border=0></a>
              </cfif>
            </td>
          </tr>
        </cfoutput>
    </table></td>
  </tr>
    </table>
	</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
<cfelse>
No se encontraron resultados para la b&uacute;squeda de
	&quot;<cfoutput>#HTMLEditFormat(url.s)#</cfoutput>&quot;
	</cfif>
	

	
	</cf_templatearea>
</cf_template>
