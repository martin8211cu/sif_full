<cfparam name="url.cat" default="0">
<cfparam name="url.s" default="">
<cfquery datasource="#session.dsn#" name="categorias" >
set rowcount 200
	select c.id_categoria, c.nombre_categoria
	from Categoria c, Categoria a
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and a.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  and c.categoria_padre = a.categoria_padre
	order by case when c.id_categoria = 0 then 0 else 1 end, c.orden_relativo, c.nombre_categoria
set rowcount 0
</cfquery>

<table width="232">
<tr><td width="194" valign="top"><form action="catsearch.cfm" method="get" style="margin:0 ">
  <table cellspacing="0" cellpadding="2" width="100%" class="catview_table">
  <tr><td class="catview_thinv"><b>Buscar</b></td></tr>
  <tr>
        <td><select name="cat">
		<option value="0">Todas</option>
          <cfoutput query="categorias">
		  	<cfif id_categoria neq 0>
            <option value="#id_categoria#" <cfif url.cat EQ id_categoria>selected</cfif> >
			  #nombre_categoria#</option></cfif>
          </cfoutput>
        </select></td>
        </tr>
      <tr>
        <td><input name="s" type="text" id="s" size="10" onFocus="select()" value="<cfoutput>#HTMLEditFormat(url.s)#</cfoutput>" >        <input type="submit" name="Submit" value="Buscar" style="font-size:xx-small;"></td>
        </tr>
  </table>
</form><div style="height:12px"></div><table cellspacing="0" cellpadding="2" width="100%" border="0" class="catview_table">
  <tr>
    <td class="catview_thinv"><b>Categor&iacute;as</b></td>
  </tr>
  <cfoutput query="categorias">
  <tr>
    <td >
    <a href="index.cfm?cat=#id_categoria#" <cfif id_categoria is url.cat>style="font-weight:bold"</cfif> ><cfif id_categoria>
  	  #nombre_categoria#<cfelse>
	  Todas</cfif></a>
    </td>
  </tr></cfoutput>
</table>
<!--- Búsqueda Google ---><center>
  <form method="get" action="http://www.google.com/search" style="margin:0">
  <TABLE bgcolor="#FFFFFF"><tr><td>
  <A HREF="http://www.google.com/">
  <IMG SRC="/cfmx/tienda/tienda/public/Google_Logo_25wht.gif" width="75" height="32" border="0" ALT="Google" align="absmiddle"></A>
  <input type="text" name="q" size="31" maxlength="255" value="">
  <input type="hidden" name="hl" value="es">
  <input type="submit" name="btnG" value="B&uacute;squeda Google">
  </td></tr></TABLE></form>
</center><!--- Fin de Búsqueda Google --->
</td>
<td width="26" valign="top">&nbsp;</td>
</tr></table>