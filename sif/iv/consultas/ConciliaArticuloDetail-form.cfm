<cfif isdefined("Url.ETid") and not isdefined("Form.ETid")>
	<cfset Form.ETid = Url.ETid>
</cfif>

<cfif isdefined("Url.Aid") and not isdefined("Form.Aid")>
	<cfset Form.Aid = Url.Aid>
</cfif>

<cfquery name="rsAnno" datasource="#session.DSN#">
	select Pvalor 
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 50
</cfquery>

<cfquery name="rsMes" datasource="#session.DSN#">
	select Pvalor 
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 60
</cfquery>

<cfquery name="rsArticulo" datasource="#Session.DSN#">
	select a.Acodigo, a.Adescripcion, a.Acosto as CostoPactado
	from Articulos a
	where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
</cfquery>

<cfquery name="rsProduccion" datasource="#Session.DSN#">
	select sum(DTinvinicial) as InventarioInicial, 
		   sum(DTrecepcion) as Compras, 
		   sum(DTprodcons) as Produccion, 
		   sum(DTembarques) as Embarques, 
		   sum(DTperdidaganancia) as PerdidaGanancia, 
		   sum(DTinvfinal) as InventarioFinal, 
		   sum(DTinvfinal - DTinvinicial) as Cambio
	from DTransformacion 
	where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
	and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
</cfquery>

<cfquery name="rsVentas" datasource="#Session.DSN#">
	select Ddocumento, 
		   Dfecha, 
		   (case when t.CCTtipo = 'D' then CCVPcantidad else CCVPcantidad * -1.00 end) as CCVPcantidad, 
		   (case when t.CCTtipo = 'D' then CCVPpreciouloc else CCVPpreciouloc * -1.00 end) as CCVPpreciouloc
	from CCVProducto a, Articulos b, CCTransacciones t
	where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
	and a.CCVPestado = 0
	and b.Aid = a.Aid
	and b.Aconsumo = 0
	and t.Ecodigo = a.Ecodigo
	and t.CCTcodigo = a.CCTcodigo
	order by Ddocumento
</cfquery>

<cfquery name="rsConsumo" datasource="#Session.DSN#">
	select Ddocumento, 
		   Dfecha, 
		   (case when t.CCTtipo = 'D' then CCVPcantidad else CCVPcantidad * -1.00 end) as CCVPcantidad, 
		   (case when t.CCTtipo = 'D' then CCVPpreciouloc else CCVPpreciouloc * -1.00 end) as CCVPpreciouloc
	from CCVProducto a, Articulos b, CCTransacciones t
	where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
	and a.CCVPestado = 0
	and b.Aid = a.Aid
	and b.Aconsumo = 1
	and t.Ecodigo = a.Ecodigo
	and t.CCTcodigo = a.CCTcodigo
	order by Ddocumento
</cfquery>

<cfquery name="rsCompras" datasource="#Session.DSN#">
	select Kdocumento, 
		   Kfecha, 
		   Kunidades, 
		   Kcosto
	from Kardex a, Articulos b
	where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
	and a.Kperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnno.Pvalor#">
	and a.Kmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.Pvalor#">
	and a.Ktipo = 'E'
	and b.Aid = a.Aid
	and b.Aconsumo = 0
	order by Kdocumento
</cfquery>

<cfquery name="rsCambioInventario" datasource="#Session.DSN#">
	select DTinvinicial as Inicial, 
		   DTperdidaganancia as PerdidaGanancia, 
		   DTinvfinal as Final, 
		   DTinvfinal - DTinvinicial + DTperdidaganancia as Cambio, 
		   (DTinvfinal - DTinvinicial + DTperdidaganancia) * coalesce(b.Acosto, 1.00) as Monto, 
		   coalesce(b.Acosto, 1.00) as Costo
	from Articulos b, DTransformacion a
	where b.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
	and a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
	and a.Aid = b.Aid
</cfquery>

<cf_sifHTML2Word>
<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloAlterno" align="center" bgcolor="##EFEFEF">#Session.Enombre#</td>
		  </tr>
		  <tr>
			<td align="center"><b>Detalle de Conciliaci&oacute;n de Artículos</b></td>
		  </tr>
		  <tr>
			<td align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
		  </tr>
		</table>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>
			<table width="95%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalle del Art&iacute;culo">
						<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td align="right" style="padding-right: 10px;" nowrap><strong>C&oacute;digo:</strong></td>
							<td>#rsArticulo.Acodigo#</td>
							<td align="right" style="padding-right: 10px;" nowrap><strong>Descripci&oacute;n:</strong></td>
							<td>#rsArticulo.Adescripcion#</td>
							<td align="right" style="padding-right: 10px;" nowrap><strong>Costo Pactado:</strong></td>
							<td>
								<cfif Len(Trim(rsArticulo.CostoPactado))>#LSCurrencyFormat(rsArticulo.CostoPactado, 'none')#<cfelse>0.00</cfif>
							</td>
						  </tr>
						</table>	
					<cf_web_portlet_end>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <cfif rsProduccion.recordCount GT 0>
	  <tr>
		<td align="center">
			<table width="95%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Resumen">
						<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td align="right" width="14%"><strong>Inventario Inicial</strong></td>
							<td align="right" width="14%"><strong>Compras</strong></td>
							<td align="right" width="14%"><strong>Producci&oacute;n</strong></td>
							<td align="right" width="14%"><strong>Embarques</strong></td>
							<td align="right" width="14%"><strong>P&eacute;rdida/Ganancia</strong></td>
							<td align="right" width="14%"><strong>Inventario Final</strong></td>
							<td align="right" width="14%"><strong>Cambio</strong></td>
						    <td align="right" width="2%">&nbsp;</td>
						  </tr>
						  <tr>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsProduccion.InventarioInicial))>#LSCurrencyFormat(rsProduccion.InventarioInicial, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsProduccion.Compras))>#LSCurrencyFormat(rsProduccion.Compras, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsProduccion.Produccion))>#LSCurrencyFormat(rsProduccion.Produccion, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsProduccion.Embarques))>#LSCurrencyFormat(rsProduccion.Embarques, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsProduccion.PerdidaGanancia))>#LSCurrencyFormat(rsProduccion.PerdidaGanancia, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsProduccion.InventarioFinal))>#LSCurrencyFormat(rsProduccion.InventarioFinal, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsProduccion.Cambio))>#LSCurrencyFormat(rsProduccion.Cambio, 'none')#<cfelse>0.00</cfif></td>
						    <td align="right" style="border-top: 1px solid gray; ">&nbsp;</td>
						  </tr>
						</table>
					<cf_web_portlet_end>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  </cfif>
	  <tr>
		<td align="center">
			<table width="95%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Ventas">
					  <cfif rsVentas.recordCount GT 0>
						<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td align="left" bgcolor="##CCCCCC"><strong>Documento</strong></td>
							<td align="center" bgcolor="##CCCCCC" width="15%"><strong>Fecha</strong></td>
							<td align="right" bgcolor="##CCCCCC" width="15%"><strong>Cantidad</strong></td>
							<td align="right" bgcolor="##CCCCCC" width="15%"><strong>Monto</strong></td>
						  </tr>
						  <cfloop query="rsVentas">
						  <tr>
							<td align="left" style="border-top: 1px solid gray; "><cfif Len(Trim(rsVentas.Ddocumento))>#rsVentas.Ddocumento#<cfelse>&nbsp;</cfif></td>
							<td align="center" style="border-top: 1px solid gray; "><cfif Len(Trim(rsVentas.Dfecha))>#LSDateFormat(rsVentas.Dfecha, 'dd/mm/yyy')#<cfelse>&nbsp;</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsVentas.CCVPcantidad))>#rsVentas.CCVPcantidad#<cfelse>0</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsVentas.CCVPpreciouloc))>#LSCurrencyFormat(rsVentas.CCVPpreciouloc, 'none')#<cfelse>0.00</cfif></td>
						  </tr>
						  </cfloop>
						  <cfquery name="rsSumVentas" dbtype="query">
						  	select sum(CCVPpreciouloc) as Monto
							from rsVentas
						  </cfquery>
						  <tr>
							<td align="left" style="border-top: 2px solid black; "><strong>Total:</strong></td>
							<td align="center" style="border-top: 2px solid black; ">&nbsp;</td>
							<td align="right" style="border-top: 2px solid black; ">&nbsp;</td>
							<td align="right" style="border-top: 2px solid black; "><cfif Len(Trim(rsSumVentas.Monto))>#LSCurrencyFormat(rsSumVentas.Monto, 'none')#<cfelse>0.00</cfif></td>
						  </tr>
						</table>
					  <cfelse>
						<div align="center"><strong>--- No se encontraron Datos de Ventas ---</strong></div>
					  </cfif>
				  <cf_web_portlet_end>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center">
			<table width="95%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consumo">
					  <cfif rsConsumo.recordCount GT 0>
						<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td align="left" bgcolor="##CCCCCC"><strong>Documento</strong></td>
							<td align="center" bgcolor="##CCCCCC" width="15%"><strong>Fecha</strong></td>
							<td align="right" bgcolor="##CCCCCC" width="15%"><strong>Cantidad</strong></td>
							<td align="right" bgcolor="##CCCCCC" width="15%"><strong>Monto</strong></td>
						  </tr>
						  <cfloop query="rsConsumo">
						  <tr>
							<td align="left" style="border-top: 1px solid gray; "><cfif Len(Trim(rsConsumo.Ddocumento))>#rsConsumo.Ddocumento#<cfelse>&nbsp;</cfif></td>
							<td align="center" style="border-top: 1px solid gray; "><cfif Len(Trim(rsConsumo.Dfecha))>#LSDateFormat(rsConsumo.Dfecha, 'dd/mm/yyyy')#<cfelse>&nbsp;</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsConsumo.CCVPcantidad))>#rsConsumo.CCVPcantidad#<cfelse>0</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsConsumo.CCVPpreciouloc))>#LSCurrencyFormat(rsConsumo.CCVPpreciouloc, 'none')#<cfelse>0.00</cfif></td>
						  </tr>
						  </cfloop>
						  <cfquery name="rsSumConsumo" dbtype="query">
						  	select sum(CCVPpreciouloc) as Monto
							from rsConsumo
						  </cfquery>
						  <tr>
							<td align="left" style="border-top: 2px solid black; "><strong>Total:</strong></td>
							<td align="center" style="border-top: 2px solid black; ">&nbsp;</td>
							<td align="right" style="border-top: 2px solid black; ">&nbsp;</td>
							<td align="right" style="border-top: 2px solid black; "><cfif Len(Trim(rsSumConsumo.Monto))>#LSCurrencyFormat(rsSumConsumo.Monto, 'none')#<cfelse>0.00</cfif></td>
						  </tr>
						</table>
					  <cfelse>
						<div align="center"><strong>--- No se encontraron Datos de Consumo ---</strong></div>
					  </cfif>
				  <cf_web_portlet_end>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center">
			<table width="95%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Compras">
					  <cfif rsCompras.recordCount GT 0>
						<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td align="left" bgcolor="##CCCCCC"><strong>Documento</strong></td>
							<td align="center" bgcolor="##CCCCCC" width="15%"><strong>Fecha</strong></td>
							<td align="right" bgcolor="##CCCCCC" width="15%"><strong>Cantidad</strong></td>
							<td align="right" bgcolor="##CCCCCC" width="15%"><strong>Monto</strong></td>
						  </tr>
						  <cfloop query="rsCompras">
						  <tr>
							<td align="left" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCompras.Kdocumento))>#rsCompras.Kdocumento#<cfelse>&nbsp;</cfif></td>
							<td align="center" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCompras.Kfecha))>#LSDateFormat(rsCompras.Kfecha, 'dd/mm/yyyy')#<cfelse>&nbsp;</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCompras.Kunidades))>#rsCompras.Kunidades#<cfelse>0</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCompras.Kcosto))>#LSCurrencyFormat(rsCompras.Kcosto, 'none')#<cfelse>0.00</cfif></td>
						  </tr>
						  </cfloop>
						  <cfquery name="rsSumCompras" dbtype="query">
						  	select sum(Kcosto) as Monto
							from rsCompras
						  </cfquery>
						  <tr>
							<td align="left" style="border-top: 2px solid black; "><strong>Total:</strong></td>
							<td align="center" style="border-top: 2px solid black; ">&nbsp;</td>
							<td align="right" style="border-top: 2px solid black; ">&nbsp;</td>
							<td align="right" style="border-top: 2px solid black; "><cfif Len(Trim(rsSumCompras.Monto))>#LSCurrencyFormat(rsSumCompras.Monto, 'none')#<cfelse>0.00</cfif></td>
						  </tr>
						</table>
					  <cfelse>
						<div align="center"><strong>--- No se encontraron Datos de Compras ---</strong></div>
					  </cfif>
				  <cf_web_portlet_end>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <cfif rsCambioInventario.recordCount GT 0>
	  <tr>
		<td align="center">
			<table width="95%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cambio en Inventario">
						<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td align="right" width="19%"><strong>Inventario Inicial</strong></td>
							<td align="right" width="19%"><strong>P&eacute;rdida/Ganancia</strong></td>
							<td align="right" width="19%"><strong>Inventario Final</strong></td>
							<td align="right" width="19%"><strong>Cambio</strong></td>
							<td align="right" width="19%"><strong>Monto</strong></td>
						    <td align="right" width="5%">&nbsp;</td>
						  </tr>
						  <tr>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCambioInventario.Inicial))>#LSCurrencyFormat(rsCambioInventario.Inicial, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCambioInventario.PerdidaGanancia))>#LSCurrencyFormat(rsCambioInventario.PerdidaGanancia, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCambioInventario.Final))>#LSCurrencyFormat(rsCambioInventario.Final, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCambioInventario.Cambio))>#LSCurrencyFormat(rsCambioInventario.Cambio, 'none')#<cfelse>0.00</cfif></td>
							<td align="right" style="border-top: 1px solid gray; "><cfif Len(Trim(rsCambioInventario.Monto))>#LSCurrencyFormat(rsCambioInventario.Monto, 'none')#<cfelse>0.00</cfif></td>
						    <td align="right" style="border-top: 1px solid gray; ">&nbsp;</td>
						  </tr>
						</table>
					<cf_web_portlet_end>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  </cfif>
	  <tr>
		<td align="center">--- Fin del Reporte ---</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	</table>
</cfoutput>
</cf_sifHTML2Word>
