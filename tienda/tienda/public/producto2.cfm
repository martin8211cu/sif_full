<cfif NOT (IsDefined("url.prod") AND IsDefined("url.prod") )>
  <cflocation url="index.cfm">
</cfif>
<cfquery datasource="#session.dsn#" name="data">
select p.nombre_producto, p.txt_descripcion, r.txt_descripcion as txt_descripcion2,
	r.sku, r.nombre_presentacion, coalesce(r.precio, p.precio) as precio
from Producto p, Presentacion r
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and p.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and r.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
  and r.id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pres#">
</cfquery>
<cfquery datasource="#session.dsn#" name="hayfoto">
select count(1) as hay
from FotoProducto p
where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and p.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
  and datalength(p.img_foto) != 0
</cfquery>
<cfset cantidad = 1>
<cfset observaciones = ''>
<cfset isnew = true>
<cfif IsDefined("session.id_carrito")>
	<cfquery datasource="#session.dsn#" name="cant">
	select cantidad, observaciones
	from Item
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
	  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pres#">
	</cfquery>
	<cfif cant.RecordCount EQ 1 and cant.cantidad GT 1>
		<cfset cantidad = cant.cantidad>
		<cfset observaciones = cant.observaciones>
		<cfset isnew = false>
	</cfif>
</cfif>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title"><cfoutput>#data.nombre_producto#</cfoutput></cf_templatearea>
<cf_templatearea name="body">
<cfinclude template="estilo.cfm">

<cfoutput query="data"><form action="producto_go.cfm" method="post">
  <table width="100%" border="0" cellspacing="2" cellpadding="2">
<cfif hayfoto.hay>
  <tr><td></td><td>
	<img src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#URLEncodedFormat(url.prod)#&dft=na" height="120" border="1" >
  </td>
  </tr>
</cfif><cfif Len(sku) GT 0 AND sku NEQ " ">
    <tr valign="top">
      <td>SKU</td>
      <td>#sku#</td>
    </tr></cfif><cfif Len(nombre_presentacion) GT 0 and nombre_presentacion NEQ " ">
    <tr valign="top">
      <td>Presentaci&oacute;n</td>
      <td>#nombre_presentacion#</td>
    </tr></cfif>
    <tr valign="top">
      <td>Precio</td>
      <td>#session.comprar_moneda# #LSCurrencyFormat(precio,'none')# ivi</td>
    </tr><cfif Len(txt_descripcion) GT 0 OR Len(txt_descripcion2) GT 0>
    <tr valign="top">
      <td>Detalles</td>
      <td>#txt_descripcion#<br>#txt_descripcion2#</td>
    </tr></cfif>
    <tr valign="top">
      <td>Cantidad</td>
      <td><input name="cantidad" type="text" class="flat" value="#cantidad#" size="40" maxlength="4" onFocus="select()" ></td>
    </tr>
    <tr valign="top">
      <td>Observaciones</td>
      <td><textarea name="observaciones" cols="40" rows="4" class="flat">#observaciones#</textarea></td>
    </tr>
    <tr valign="top">
      <td colspan="2" align="center">
	  <input type="hidden" name="prod" value="<cfoutput>#url.prod#</cfoutput>">
	  <input type="hidden" name="pres" value="<cfoutput>#url.pres#</cfoutput>">
	  <input name="add" type="image" id="add" value="<cfif isnew>Agregar a carrito<cfelse>Actualizar carrito</cfif>" src="../images/btn_agregar.gif" alt="<cfif isnew>Agregar a carrito<cfelse>Actualizar carrito</cfif>">
        <input name="return" type="image" id="return" value="Seguir comprando" src="../images/btn_seguir_comprando.gif" alt="Seguir comprando"></td>
      </tr>
  </table>
  </form>
</cfoutput>

</cf_templatearea>
</cf_template>
