<cfif IsDefined("session.listaFactura") and IsDefined("form.fieldnames")>
	
	<cfquery datasource="#session.dsn#" name="modo_anterior">
		select tipo_compra
		from VentaE
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
	</cfquery>
	<cfset reset_precios = false>
	<cfif Len(modo_anterior.tipo_compra) and isdefined("form.forma_pago") and modo_anterior.tipo_compra neq form.forma_pago>
		<cfset reset_precios = true>
		
	</cfif>

	<cfquery datasource="#session.dsn#">
		update VentaE
		set tipo_compra = <cfif isdefined("form.forma_pago")><cfqueryparam cfsqltype="cf_sql_char" value="#form.forma_pago#"><cfelse>tipo_compra</cfif>,
			periodo_pago = <cfif isdefined("form.tipo") and len(trim(form.tipo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#"><cfelse>null</cfif>,
			<cfif isdefined("form.PlazoMeses") and len(trim(form.PlazoMeses))>
				plazo_meses = <cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(form.PlazoMeses,',','','all')#">,
			</cfif>
			<cfif isdefined("form.Intereses") and len(trim(form.Intereses))>
				tasa_interes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.Intereses,',','','all')#">,
			</cfif>
			total_productos = <cfif isdefined("session.listaFactura.total")><cfqueryparam cfsqltype="cf_sql_money4" value="#session.listaFactura.total#"><cfelse>0</cfif>,
			total_financiado = <cfif isdefined("form.PagoTotal") and len(trim(form.PagoTotal))><cfqueryparam cfsqltype="cf_sql_money4" value="#Replace(form.PagoTotal,',','','all')#"><cfelse>0</cfif>,
			CDid = <cfif isdefined("form.CDid") and len(trim(form.CDid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid#"><cfelse>null</cfif>,
			impuesto = <cfif isdefined("form.impuesto") and len(trim(form.impuesto))><cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.impuesto,',','','all')#"><cfelse>null</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
	</cfquery>

	<cfloop collection="#Form#" item="i">
		<cfif FindNoCase("cant_", i) NEQ 0 and Form[i] NEQ 0>
			<cfset codarticulo = Mid(i, 6, Len(i))>
			<cfset precio = Replace(form['prec_' & codarticulo], ',', '', 'all')>
			<cfquery datasource="#session.dsn#">
				update VentaD
				set cantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form[i]#">,
				<cfif reset_precios>
				    precio_unitario = 0,
				<cfelse>
				    precio_unitario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#precio#">,
				</cfif>
					prima_minima_total = <cfif isdefined("form.prima_#codarticulo#") and len(trim(form['prima_#codarticulo#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['prima_' & codarticulo],',','','all')#"><cfelse>null</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codarticulo#">
				  and numero_linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['linea_' & codarticulo]#">
			</cfquery>
		<cfelseif FindNoCase("cant_", i) NEQ 0>
			<cfset codarticulo = Mid(i, 6, Len(i))>
			<cfquery datasource="#session.dsn#">
				delete VentaD
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codarticulo#">
				  and numero_linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['linea_' & codarticulo]#">
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
