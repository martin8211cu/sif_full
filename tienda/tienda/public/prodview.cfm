<cfif NOT (IsDefined("url.prod") AND IsDefined("url.prod") )>
  <cflocation url="index.cfm">
</cfif>
<cfquery datasource="#session.dsn#" name="data">
select p.id_producto, r.id_presentacion, p.nombre_producto, p.txt_descripcion, r.txt_descripcion as txt_descripcion2,
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
<cfinclude template="catpath.cfm">
<cfoutput query="data"><form action="producto_go.cfm" method="post">
  <table border="0" cellspacing="0" cellpadding="4" align="l" class="catview_table">
    <tr>
      <td valign="top" class="catview_thinv">#nombre_producto#</td>
      </tr>
<tr><td valign="top" class="catview_th">

  <table border="0" cellspacing="0" cellpadding="2"  align="l">
  <tr>
    <td width="134" rowspan="3" valign="top"><cfif hayfoto.hay><a href="##" onClick="largerImage()">
  <a href="javascript:void(0)" onClick="largerImage()"><img src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#URLEncodedFormat(data.id_producto)#&dft=na&sz=nr" height="240" border="0"
	></a>
                            </cfif>	 </td>
    <td width="77" valign="top"></td><td width="240" valign="top">
  </td>
    </tr>
    <!---
    <tr valign="top">
      <td>Observaciones</td>
      <td><textarea name="observaciones" cols="40" rows="4" class="flat">#observaciones#</textarea></td>
    </tr>--->
      <tr valign="top">
        <td colspan="2" align="center" valign="top"><table width="100%"  border="0" cellspacing="3" cellpadding="3">
            <tr valign="top">
              <td valign="top"><cfif Len(sku) GT 1>
                  SKU
              </cfif></td>
              <td valign="top"><cfif Len(sku) GT 1>
                  #sku#
              </cfif></td>
            </tr>
            <tr valign="top">
              <td valign="top"><cfif Len(nombre_presentacion) GT 0 and nombre_presentacion NEQ " ">
                  Presentaci&oacute;n
              </cfif></td>
              <td valign="top">#nombre_presentacion#</td>
            </tr>
            <tr valign="top">
              <td valign="top">Precio</td>
              <td valign="top">#session.comprar_moneda# #LSCurrencyFormat(precio,'none')# ivi</td>
            </tr>
            <tr valign="top">
              <td valign="top"><cfif Len(txt_descripcion) GT 0 OR Len(txt_descripcion2) GT 0>
                  Detalles
              </cfif></td>
              <td valign="top">
			  <cfif Find('>', txt_descripcion) is 0><!--- es text-only --->
                #replace(txt_descripcion, Chr(13), '<br>', 'all')#
			<cfelse><!--- es HTML --->#txt_descripcion#
			</cfif>
			  <cfif Len(txt_descripcion2) gt 0 and len(txt_descripcion2) gt 0>
			  <br></cfif>
			  <cfif Find('>', txt_descripcion2) is 0><!--- es text-only --->
                #replace(txt_descripcion2, Chr(13), '<br>', 'all')#
			<cfelse><!--- es HTML --->#txt_descripcion2#
			</cfif></td>
            </tr>
            <tr valign="top">
              <td valign="top">Cantidad</td>
              <td valign="top"><input name="cantidad" type="text" class="flat" value="#cantidad#" size="10" maxlength="4" onFocus="select()" ></td>
            </tr>
                </table></td>
        </tr>
      <tr valign="top">
        <td align="center" valign="top" colspan="2">
	  <input type="hidden" name="prod" value="<cfoutput>#url.prod#</cfoutput>">
	  <input type="hidden" name="pres" value="<cfoutput>#url.pres#</cfoutput>">
	  <input name="add" type="image" id="add" value="<cfif isnew>Agregar a carrito<cfelse>Actualizar carrito</cfif>" src="../images/btn_agregar.gif" alt="<cfif isnew>Agregar a carrito<cfelse>Actualizar carrito</cfif>">
        <input name="return" type="image" id="return" value="Seguir comprando" src="../images/btn_seguir_comprando.gif" alt="Seguir comprando"></td>
      </tr>
      <tr valign="top">
      <td colspan="3" align="center" valign="top"></td>
      </tr>
  </table></td></tr></table>
  </form>
</cfoutput>
<script type="text/javascript">
<!--
	<cfoutput>
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}
	function largerImage() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
		}
		var width=362;
		var height=<cfif hayfoto.hay GT 1>382<cfelse>300</cfif>;
		var left = (screen.width - width) / 2;
		var top = (screen.height - height) / 2;
		window.gPopupWindow=window.open("prodimages.cfm?prod=#JSStringFormat(URLEncodedFormat(data.id_producto))
			#&pres=#JSStringFormat(URLEncodedFormat(data.id_presentacion))#", "largerImage",
			"width="+width+",height="+height+",left=" + left + ",top=" + top + ",toolbar=no");
		window.onfocus = closePopup;
	}
	</cfoutput>
//-->
</script>
</cf_templatearea>
</cf_template>
