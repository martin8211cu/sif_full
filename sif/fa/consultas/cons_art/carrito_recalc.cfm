<cfif isdefined("Session.listaFactura")>
	<!--- Actualizar el monto total en el carrito --->
	<cfset Session.listaFactura.Total = 0.00>
	<cfquery datasource="#session.dsn#" name="ListaDefault">
		select LPid
		from EListaPrecios
		where LPdefault = 1
	</cfquery>

	<cfquery datasource="#session.dsn#" name="VentaE">
		select ve.VentaID, ve.LPid as LPid_VentaE, ve.fecha, ve.SNcodigo, ve.CDid,
			sn.LPid as LPid_SNegocios, cd.LPid as LPid_ClienteDetallista, ve.tipo_compra,
			coalesce (ve.LPid, sn.LPid, cd.LPid<cfif Len(ListaDefault.LPid)>, #ListaDefault.LPid#</cfif>) as LPid
		from VentaE ve
			left join SNegocios sn
				on sn.SNcodigo = ve.SNcodigo
				and sn.Ecodigo = ve.Ecodigo
			left join ClienteDetallista cd
				on cd.CDid = ve.CDid
		where ve.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ve.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
	</cfquery>
	
	<cfset session.lista_precios = VentaE.LPid>

	<cfquery datasource="#session.dsn#" name="VentaD">
		select v.numero_linea, v.Aid, v.cantidad,
			<cfif VentaE.tipo_compra is 'CO'>
				coalesce(lp.DLprecio, 0) as DLprecio,
				coalesce(lp.precio_contado_vendedor, 0) as precio_vendedor,
				coalesce(lp.precio_contado_supervisor, 0) as precio_supervisor,
			<cfelse>
				coalesce(lp.precio_credito, 0) as DLprecio,
				coalesce(lp.precio_credito_vendedor, 0) as precio_vendedor,
				coalesce(lp.precio_credito_supervisor, 0) as precio_supervisor,
			</cfif>
			v.precio_unitario, coalesce(lp.prima_minima,0) as prima_minima,
			coalesce(lp.interes_corriente, 0) as interes_corriente,
			coalesce(lp.interes_mora, 0) as interes_mora,
			coalesce(lp.plazo_sugerido, 0) as plazo_sugerido,
			i.Icodigo,
			coalesce(i.Iporcentaje,0) as Iporcentaje
		from VentaD v
			left join DListaPrecios lp
				on lp.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VentaE.LPid#" null="#Len(VentaE.LPid) is 0#">
				and lp.Aid = v.Aid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#VentaE.fecha#"> between lp.DLfechaini and lp.DLfechafin
			left join Impuestos	i
				on i.Ecodigo=lp.Ecodigo
				and i.Icodigo=lp.Icodigo
		where v.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and v.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
	</cfquery>
	
	<cfif VentaE.LPid neq VentaE.LPid_VentaE and Len(VentaE.LPid)>
		<cfquery datasource="#session.dsn#">
			update VentaE
			set LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VentaE.LPid#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
		</cfquery>
	</cfif>

	<cfloop query="VentaD">
		<cfif (Len(VentaD.precio_unitario) is 0) OR (VentaD.precio_unitario LE 0) OR (VentaD.DLprecio LE VentaD.precio_unitario)>
			<cfset nuevo_precio_unitario = VentaD.DLprecio >
			<cfset precio_linea = cantidad * VentaD.DLprecio >
			<cfset descuento_porcentaje = 0 >
		<cfelse>
			<cfset nuevo_precio_unitario = VentaD.precio_unitario >
			<cfset descuento_porcentaje = 100 - 100 * VentaD.precio_unitario / VentaD.DLprecio>
			<cfset descuento_porcentaje = Round (descuento_porcentaje * 100) / 100>
			<cfset precio_linea = cantidad * nuevo_precio_unitario >
		</cfif>

<!---
,
				tasa_interes = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#VentaD.interes_corriente#">,
				tasa_mora = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#VentaD.interes_mora#">
--->

		<cfquery datasource="#session.dsn#" name="buscar_VentaD">
			update VentaD
			set precio_contado = <cfqueryparam cfsqltype="cf_sql_money" value="#VentaD.DLprecio#">,
				precio_vendedor = <cfqueryparam cfsqltype="cf_sql_money" value="#VentaD.precio_vendedor#">,
				precio_supervisor = <cfqueryparam cfsqltype="cf_sql_money" value="#VentaD.precio_supervisor#">,
				prima_minima = <cfqueryparam cfsqltype="cf_sql_money" value="#VentaD.prima_minima#">,
				precio_unitario = <cfqueryparam cfsqltype="cf_sql_money" value="#nuevo_precio_unitario#">,
				precio_linea = <cfqueryparam cfsqltype="cf_sql_money" value="#precio_linea#">,
				descuento_porcentaje = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#descuento_porcentaje#">,
				porc_impuesto = <cfqueryparam cfsqltype="cf_sql_float" scale="2" value="#VentaD.Iporcentaje#">,
				Icodigo = <cfif len(trim(VentaD.Icodigo))><cfqueryparam cfsqltype="cf_sql_char" scale="2" value="#VentaD.Icodigo#"><cfelse>null</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VentaD.Aid#">
			  and numero_linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VentaD.numero_linea#">
		</cfquery>
	</cfloop>
	
	<cfif VentaD.RecordCount>
		<cfquery dbtype="query" name="maxims">
			select
				max(interes_corriente) as interes_corriente,
				max(interes_mora     ) as interes_mora,
				max(plazo_sugerido   ) as plazo_sugerido
			from VentaD
		</cfquery>
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update VentaE
		set total_productos = (select coalesce( sum(precio_linea) , 0) from VentaD
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
			)
		<cfif VentaD.RecordCount>
			, tasa_interes = <cfqueryparam cfsqltype="cf_sql_decimal" value="#maxims.interes_corriente#">
			, tasa_mora    = <cfqueryparam cfsqltype="cf_sql_decimal" value="#maxims.interes_mora#">
			, plazo_meses  = <cfqueryparam cfsqltype="cf_sql_decimal" value="#maxims.plazo_sugerido#">
		</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
	</cfquery>
</cfif>
