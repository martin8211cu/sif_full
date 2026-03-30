<cfquery name="rsParametros" datasource="#Session.DSN#">
	select Pvalor
	from MEParametros
	where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="40">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif rsParametros.RecordCount gt 0 and len(trim(rsParametros.Pvalor)) gt 0>
	<cfquery name="productos" datasource="#session.dsn#" maxrows="100">
		select p.Ecodigo, p.id_producto, p.nombre_producto, p.txt_descripcion,
			r.id_presentacion, r.nombre_presentacion,
			coalesce (r.precio, p.precio) as precio
		from Producto p, Presentacion r
		where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParametros.Pvalor#">
		  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParametros.Pvalor#">
		  and r.id_producto = p.id_producto
	</cfquery>
	
	<cfquery dbtype="query" name="prod" maxrows="4">
		select distinct id_producto
		from productos
		order by nombre_producto
	</cfquery>
	<table width="294" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>
			<table width="100%"  cellspacing="0" cellpadding="0" background="imagenes/bot_left02.gif" class="style0901">
			  <tr>
				<td width="1%"><img src="imagenes/bot_left01.gif" width="33" height="29" class="style0901"></td>
				<td class="style0901"><div align="center">Tienda en L&iacute;nea</div></td>
				<td width="1%"><img src="imagenes/bot_left03.gif" width="33" height="29" class="style0901"></td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td>
			<div align="center"><img src="imagenes/right01.jpg" width="100%" height="15" alt="" border="0"></div>
		</td>
	  </tr>
	  <tr>
		<td>
			<table width="90%" align="right" border="0" cellpadding="0" cellspacing="0">
			  <cfoutput query="prod">
				<cfquery dbtype="query" name="uno">
					select * from productos
					where id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
				</cfquery>
			  <tr>
				<td valign="top" width="90">
					<a href="/cfmx/tienda/tienda/public/prodview.cfm?prod=#uno.id_producto#&amp;pres=#uno.id_presentacion#"><img src="/cfmx/tienda/tienda/public/producto_img.cfm?tid=#uno.Ecodigo#&amp;id=#uno.id_producto#&amp;dft=na&amp;sz=sm" height="60" alt="" border="0"></a><br>
					<a href="/cfmx/tienda/tienda/public/prodview.cfm?prod=#uno.id_producto#&amp;pres=#uno.id_presentacion#"><img src="imagenes/b_buy.gif" width="89" height="29" alt="" border="0"></a><br>
					<a href="/cfmx/tienda/tienda/public/prodview.cfm?prod=#uno.id_producto#&amp;pres=#uno.id_presentacion#"><img src="imagenes/b_add.gif" width="89" height="29" alt="" border="0"></a><br>
				</td>
				<td valign="top" width="194">
					<p class="right"><b>#uno.nombre_producto#</b></p>
					<p class="right"><img src="imagenes/e_punct_b.gif" width="5" height="5" alt="" border="0" align="absmiddle">&nbsp;&nbsp;#uno.txt_descripcion#</p>
					<p class="right"><a href="/cfmx/tienda/tienda/public/prodview.cfm?prod=#uno.id_producto#&amp;pres=#uno.id_presentacion#">Leer M&aacute;s</a></p>
				</td>
			  </tr>
			  <tr>
				<td colspan="2"><img src="imagenes/e02.gif" width="284" height="12" alt="" border="0"></td>
			  </tr>
			  </cfoutput>
			  <tr>
			  <td nowrap align="center" colspan="2">
				<cfquery name="rsParametros" datasource="#Session.DSN#">
					select Pvalor
					from MEParametros
					where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="40">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfif rsParametros.RecordCount gt 0 and len(trim(rsParametros.Pvalor)) gt 0>
					<cfoutput>
					<!--- Este image precarga esta pantalla para que se carguen ciertos valores en la variable "session" --->
					<img src="/cfmx/tienda/tienda/public/index.cfm?ctid=#rsParametros.Pvalor#" height="1" width="1">
					<!--- Este es un simple link --->
					<a href="/cfmx/tienda/tienda/public/index.cfm?ctid=#rsParametros.Pvalor#">Tienda en l&iacute;nea.</a>
					</cfoutput>
				</cfif>
			  </td>
			  </tr>
			</table>
		</td>
	  </tr>
	</table>
</cfif>