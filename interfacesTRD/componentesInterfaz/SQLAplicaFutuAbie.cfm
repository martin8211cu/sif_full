<!--- Archivo    :  SQLAplicaFutuAbie.cfm --->

<cfset ArregloProductos = ArrayNew(1)>

<cfquery name="rsFuturos" datasource="sifinterfaces">
	select *
	from #session.Dsource#futurosabiertosPMI
	where sessionid=#session.monitoreo.sessionid#
	  and mensajeerror is null
    order by trade_num
</cfquery>

<cfloop query="rsFuturos"> 
	<!--- validar Moneda Local  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select emp.Mcodigo from Empresas emp
			inner join Monedas mon
			on mon.Mcodigo = emp.Mcodigo
			and mon.Ecodigo = emp.Ecodigo
		where emp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarMonedaLocal = rsVerifica.Mcodigo>
	</cfif>

	<!--- validar Tipo de cambio  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select * from Empresas emp
			inner join Htipocambio tca
			on tca.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFuturos.Mcodigo#">
			and tca.Ecodigo = emp.Ecodigo
			and tca.Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#rsFuturos.market_day#"> 
		where emp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarTCventa = rsVerifica.TCventa>
	</cfif>

	<!--- crear folio de futuros abiertos    --->
	<cfset ws_folio = "#rsFuturos.trade_num#FU_A#rsFuturos.fill_num##session.FechaFolio#">
	<cfif rsFuturos.mtm_pl GT 0>
		<cfset ws_tipo_modulo = "Ganancia">
		<cfset Lvarp_s_ind = 'S'>
	<cfelse>	
		<cfset ws_tipo_modulo = "Pérdida">
		<cfset Lvarp_s_ind = 'P'>
	</cfif>
	
	<cfset ws_tipo_transaccion = "FC">
	
	<cfset ws_cuentaSocio = "">
	<!--- cuenta financiera de socio de negocio    --->	
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select SNcuentacxp, SNcuentacxc from SNegocios
		where Ecodigo = #session.ecodigo#
		  and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFuturos.SNid#">
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfif ws_tipo_modulo EQ 'Ganancia'>
			<cfset ws_Ccuenta = rsVerifica.SNcuentacxc>
		<cfelse>
			<cfset ws_Ccuenta = rsVerifica.SNcuentacxp>
		</cfif>
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select Cformato from CContables
			where Ecodigo = #session.ecodigo#
			  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_Ccuenta#">
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset ws_cuentaSocio = rsVerifica.Cformato>
		</cfif>
	</cfif>

	<cfif Len(rsFuturos.port_num) GT 0>
		<cfset ArrayClear(ArregloProductos)>
		<!--- Distribución de Costos   --->
		<cfquery name="rsProductos" datasource="preicts">
			select distinct ti.cmdty_code, tr.acct_ref_num, ti.p_s_ind, oo.order_type_code, tr.acct_num
				from trade_item ti
				inner join trade_order oo
					inner join trade tr
					on tr.trade_num = oo.trade_num
				on oo.trade_num = ti.trade_num
				and oo.order_num = ti.order_num	
			where ti.booking_comp_num  = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			  and ti.real_port_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFuturos.port_num#">
			  and ti.p_s_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvarp_s_ind#">
			  and oo.order_type_code in ('PHYSICAL')
		</cfquery>
		<cfif rsProductos.recordcount GT 0>
			<cfloop query="rsProductos">
				<!--- Existencia del Articulo  --->
				<cfquery name="rsArticulos" datasource="#session.dsn#">
					select Aid, Ucodigo
					from Articulos 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#rsProductos.cmdty_code#">
				</cfquery>
				<!--- Existencia del Socio de Orden Comercial Distribución  --->
				<cfquery name="rsSocios" datasource="#session.dsn#">
					select SNid
					from SNegocios 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and convert(int,SNcodigoext) = 
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProductos.acct_num#">
				</cfquery>
				<cfif rsArticulos.recordcount GT 0 and rsSocios.recordcount GT 0>
					<cfset ProdStruct = StructNew()>
					<cfset ProdStruct.Producto = rsProductos.cmdty_code>
					<cfset ProdStruct.Aid = rsArticulos.Aid>
					<cfset ProdStruct.SNid = rsSocios.SNid>
					<cfset ProdStruct.Orden = rsProductos.acct_ref_num>
					<cfset ProdStruct.TipoOrden = rsProductos.p_s_ind>
					<cfset ProdStruct.ConceptoCompra = "">
					<cfset ProdStruct.ConceptoIngreso = "">
					<cfset ProdStruct.OrdenVenta = "">
					<cfset ProdStruct.MascaraIngreso = "">
					<cfset ProdStruct.MascaraCostoVenta = "">
					<cfset ProdStruct.CuentaFinanciera = "">
					<cfset ArrayAppend(ArregloProductos,ProdStruct)>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfset LvarEncontroOrden = "N">
	<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
		<!--- revisa si existe la Orden Comercial  --->
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select OCid, OCtipoOD, OCtipoIC, OCVid, OCcontrato
			from OCordenComercial
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#ArregloProductos[i].Orden#">
		</cfquery>
		
		<cfif rsVerifica.recordcount GT 0>
			<cfset LvarEncontroOrden = "S">
			<cfif rsVerifica.OCtipoOD EQ 'D'>
				<cfset ArregloProductos[i].OrdenVenta = ArregloProductos[i].Orden>
				<cfset ws_OCVid = rsVerifica.OCVid>
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select CFmascaraIngreso, CFmascaraCostoVenta
					from OCtipoVenta
					where OCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_OCVid#">
				</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ArregloProductos[i].MascaraIngreso = rsVerifica.CFmascaraIngreso>
					<cfset ArregloProductos[i].MascaraCostoVenta = rsVerifica.CFmascaraCostoVenta>
				</cfif>
			<cfelse>
				<!--- busca la Orden Comercial de Venta, cuando viene una compra  --->
				<cfset ws_CodigoItem = ArregloProductos[i].Producto>
				<cfset LvarAid = ArregloProductos[i].Aid>
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select a3.OCTtransporte, a3.OCTid
					from OCordenComercial a1
					inner join OCtransporteProducto a2
						inner join OCtransporte a3
						on a3.OCTid = a2.OCTid
					on a2.OCid = a1.OCid
					where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and a1.OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#ArregloProductos[i].Orden#">
				</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ws_OCTid = rsVerifica.OCTid>
					<cfquery name="rsVerifica" datasource="#session.dsn#">
						select a1.OCid, a1.OCtipoOD, a1.OCtipoIC, a1.OCVid, a1.OCcontrato
						from OCordenComercial a1
						inner join OCtransporteProducto a2
							inner join OCtransporte a3
							on a2.OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_OCTid#">
						on a2.OCid = a1.OCid
						where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a1.OCtipoOD = 'D'
					</cfquery>
					<cfif rsVerifica.recordcount GT 0>
						<cfset ArregloProductos[i].OrdenVenta = rsVerifica.OCcontrato>
						<cfif rsVerifica.OCtipoIC EQ 'I'>
							<!--- Arma la cuenta financiera si el destino es un Almacén --->
							<cfset ws_CuentaFinancieraDet ="">
							<cfif len(ws_CodigoItem)>
								<cfquery name="rsVerifica" datasource="#session.DSN#">
									select a4.Cformato from CContables a4
											inner join Articulos a1
												inner join Clasificaciones a2
													inner join IAContables a3
													on a3.Ecodigo = a2.Ecodigo
													and a3.IACcodigogrupo = a2.Ccodigoclas
												on a2.Ccodigo = a1.Ccodigo
												and a2.Ecodigo = a1.Ecodigo
											on a1.Ecodigo = a4.Ecodigo
												and a1.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
									where a4.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									  and a4.Ccuenta = a3.IACtransito
								</cfquery>
								<cfif rsVerifica.recordcount GT 0>
									<cfset ArregloProductos[i].CuentaFinanciera = rsVerifica.Cformato>
								</cfif>
							</cfif> 
						<cfelse>
							<cfset ws_OCVid = rsVerifica.OCVid>
							<cfquery name="rsVerifica" datasource="#session.dsn#">
								select CFmascaraIngreso, CFmascaraCostoVenta
								from OCtipoVenta
								where OCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_OCVid#">
							</cfquery>
							<cfif rsVerifica.recordcount GT 0>
								<cfset ArregloProductos[i].MascaraIngreso = rsVerifica.CFmascaraIngreso>
								<cfset ArregloProductos[i].MascaraCostoVenta = rsVerifica.CFmascaraCostoVenta>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>

	<cfset ws_TipoItem = 'O'>

	<cfif ws_tipo_modulo EQ 'Pérdida'>
		<!--- Cconcepto     --->
		<cfquery name="rsVerifica" datasource="tesoreria">
			select sb.subconcepto_id
			FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar"  value="FUT_COMM">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="ANY">
			  AND s.payable_receivable = 'P' 
			  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
			  AND sb.subconcepto_id = r.subconcepto_id
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset ws_Cconcepto = rsVerifica.subconcepto_id>
		</cfif>
	</cfif>

	<cfif ws_tipo_modulo EQ 'Ganancia'>
		<!--- Cconcepto     --->
		<cfquery name="rsVerifica" datasource="tesoreria">
			select sb.subconcepto_id
			FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar"  value="FUT_COMM">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="ANY">
			  AND s.payable_receivable = 'R' 
			  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
			  AND sb.subconcepto_id = r.subconcepto_id
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset ws_Cconcepto = rsVerifica.subconcepto_id>
		</cfif>
	</cfif>
	
	<cfset ws_registros = ArrayLen(ArregloProductos)>
	<cfif ws_registros GT 1>
		<cfset ws_monto = abs(round(rsFuturos.mtm_pl / ws_registros))>
	<cfelse>
		<cfset ws_monto = abs(rsFuturos.mtm_pl)>
	</cfif>
	<!--- obtiene la diferencia de los detalles con el monto total, para posteriormente sumarlo --->
	<!--- al primer detalle de la tabla DContablesImportacion --->
	<cfif ws_registros GT 1>
		<cfset ws_diferencia = abs(rsFuturos.mtm_pl) - (ws_monto * ws_registros)>
	<cfelse>
		<cfset ws_diferencia = 0>
	</cfif>	

	<cfset ws_Eperiodo = "#mid(session.FechaFolio,1,4)#">
	<cfset ws_EMes = "#mid(session.FechaFolio,5,2)#">

	<cftransaction>
	<cfset ws_Consecutivo = 0>
	<!--- Graba en tabla EContablesImportacion  --->
	<cfquery datasource="#session.dsn#">
		insert into EContablesImportacion (Ecodigo,
			Cconcepto, Eperiodo, Emes, Efecha,
			Edescripcion, Edocbase, Ereferencia,
			BMfalta, BMUsucodigo, ECIreversible)
		values(#session.Ecodigo#,0,#ws_Eperiodo#, #ws_EMes#, 
			<cfif len(rsFuturos.creation_date) GT 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsFuturos.market_day#">, 
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_date" value="#vFechaF#">, 
			</cfif>
		 	'Futuros Abiertos','#ws_folio#',null,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value=1>
			)
	</cfquery>
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select MAX(ECIid) as valorID
		from EContablesImportacion
	</cfquery>
	<cfset vECIid = rsVerifica.valorID>
	<cfset ws_PrimeraVez = true>

	<!--- graba el detalle de la cuenta por cobrar o cuenta por pagar --->
	<cfif ws_tipo_modulo EQ 'Ganancia'>
		<cfset ws_movimiento = 'D'>
	<cfelse>
		<cfset ws_movimiento = 'C'>
	</cfif>
	
	<cfset ws_Consecutivo = ws_Consecutivo + 1>
	<cfset ws_Doriginal = abs(rsFuturos.mtm_pl)>
	<cfset ws_Dlocal = ws_Doriginal * LvarTCventa>
	<cfset ws_Dtipocambio = LvarTCventa>
	<cfset ws_CuentaFinancieraDet = ws_cuentaSocio>
	<cfset ws_detalle = "CuentaSocio Futuro No. #rsFuturos.unrealized_profits_detail_num#">

	<!--- Graba en tabla DContablesImportacion  --->
	<cfquery datasource="#session.dsn#">
		insert DContablesImportacion (ECIid,
		DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
		Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
		CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
		Doriginal, Dlocal, Dtipocambio, Cconcepto,
		BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
		Referencia2, Referencia3, Resultado, MSG)
		values(#vECIid#, #ws_Consecutivo#, #session.Ecodigo#, 
		<cfif len(rsFuturos.creation_date) GT 0>
			<cfqueryparam cfsqltype="cf_sql_date" value="#rsFuturos.market_day#">, 
		<cfelse>
			<cfqueryparam cfsqltype="cf_sql_date" value="#vFechaF#">, 
		</cfif>
		#ws_Eperiodo#, #ws_Emes#, '#ws_detalle#', 'Socio:#rsFuturos.SNid#', null, '#ws_movimiento#',
		'#ws_CuentaFinancieraDet#', null, null, 0, #rsFuturos.Mcodigo#,
		#ws_Doriginal#, #ws_Dlocal#, #ws_Dtipocambio#, #ws_Cconcepto#,
		<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
		#session.usucodigo#, #session.Ecodigo#, null,
		null, null, 0, null)
	</cfquery>
		
	<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
		<cfset ws_CodigoItem = ArregloProductos[i].Producto>
		<cfif ws_tipo_modulo EQ 'Pérdida'>
			<cfset ws_ConceptoCompra = ArregloProductos[i].ConceptoCompra>
		<cfelse>
			<cfset ws_ConceptoCompra = "00">
		</cfif>
		<cfset ws_OCcontrato = ArregloProductos[i].Orden>
		<cfset ws_OCtransporte = "">
		<cfset ws_Cantidad = 0>

		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select a3.OCTtransporte
			from OCordenComercial a1
			inner join OCtransporteProducto a2
				inner join OCtransporte a3
				on a3.OCTid = a2.OCTid
			on a2.OCid = a1.OCid
			where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a1.OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#ws_OCcontrato#">
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset ws_OCtransporte = rsVerifica.OCTtransporte>
		<cfelse>
			<cfset ws_OCtransporte = "">
		</cfif>

		<cfset ws_detalle = "Detalle del Futuro No. #rsFuturos.unrealized_profits_detail_num#">
		<cfif ws_PrimeraVez>
			<cfset ws_PrimeraVez = false>
			<cfset ws_Doriginal = ws_monto + ws_diferencia>
		<cfelse>
			<cfset ws_Doriginal = ws_monto>
		</cfif>
		
		<cfset ws_Dlocal = ws_Doriginal * LvarTCventa>
		<cfset ws_Dtipocambio = LvarTCventa>
		
		<cfif len(ArregloProductos[i].CuentaFinanciera) GT 0>
			<cfset ws_CuentaFinancieraDet = ArregloProductos[i].CuentaFinanciera>
		<cfelse>
			<!--- Existencia del Articulo Orden Distribución  --->
			<cfquery name="rsVerifica" datasource="#session.dsn#">
				select a1.CFcomplementoCostoVenta, a1.CFcomplementoIngreso
				from OCcomplementoArticulo a1, Articulos a2
				where a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and a2.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ArregloProductos[i].Aid#">
				  and a2.Aid = a1.Aid
			</cfquery>
			<cfif rsVerifica.recordcount GT 0>
				<cfset ws_Compl_CostoVenta = 
				 "#mid(rsVerifica.CFcomplementoCostoVenta,1,3)#-#mid(rsVerifica.CFcomplementoCostoVenta,4,3)#">
				<cfset ws_Compl_Ingreso = 
				 "#mid(rsVerifica.CFcomplementoIngreso,1,3)#-#mid(rsVerifica.CFcomplementoIngreso,4,3)#">
			<cfelse>
				<cfset ws_Compl_CostoVenta = "">
				<cfset ws_Compl_Ingreso = "">
			</cfif>
			
			<!--- Existencia del Socio de Orden Comercial Distribución  --->
			<cfquery name="rsVerifica" datasource="#session.dsn#">
				select SNid, cuentac
				from SNegocios 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ArregloProductos[i].SNid#">
			</cfquery>
			<cfif rsVerifica.recordcount GT 0>
				<cfset ws_Compl_Socio = "#mid(rsVerifica.cuentac,1,3)#-#mid(rsVerifica.cuentac,4,3)#">
			<cfelse>
				<cfset ws_Compl_Socio = "">
			</cfif>

			<cfif ws_tipo_modulo EQ 'Ganancia'>
				<cfset LvarCuentaIngreso = ArregloProductos[i].MascaraIngreso>
				<cfset LvarCuentaIngreso = replace(LvarCuentaIngreso,'SSS-SSS',ws_Compl_Socio)>
				<cfset LvarCuentaIngreso = replace(LvarCuentaIngreso,'AAA-AAA',ws_Compl_Ingreso)>
				<cfset LvarCuentaIngreso = replace(LvarCuentaIngreso,'III',ws_Cconcepto)>
				<cfset ws_CuentaFinancieraDet = LvarCuentaIngreso>
			<cfelse>
				<cfset LvarCuentaCostoVenta = ArregloProductos[i].MascaraCostoVenta>
				<cfset LvarCuentaCostoVenta = replace(LvarCuentaCostoVenta,'SSS-SSS',ws_Compl_Socio)>
				<cfset LvarCuentaCostoVenta = replace(LvarCuentaCostoVenta,'AAA-AAA',ws_Compl_Ingreso)>
				<cfset LvarCuentaCostoVenta = replace(LvarCuentaCostoVenta,'CCC',ws_Cconcepto)>
				<cfset ws_CuentaFinancieraDet = LvarCuentaCostoVenta>
			</cfif>
		</cfif>

		<cfif ws_tipo_modulo EQ 'Ganancia'>
			<cfset ws_movimiento = 'C'>
		<cfelse>
			<cfset ws_movimiento = 'D'>
		</cfif>
		
		<cfset ws_Consecutivo = ws_Consecutivo + 1>
		<!--- Graba en tabla DContablesImportacion  --->
		<cfquery datasource="#session.dsn#">
			insert DContablesImportacion (ECIid,
			DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
			Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
			CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
			Doriginal, Dlocal, Dtipocambio, Cconcepto,
			BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
			Referencia2, Referencia3, Resultado, MSG)
			values(#vECIid#, #ws_Consecutivo#, #session.Ecodigo#, 
			<cfif len(rsFuturos.creation_date) GT 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsFuturos.market_day#">, 
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_date" value="#vFechaF#">, 
			</cfif>
			#ws_Eperiodo#, #ws_Emes#, '#ws_detalle#', '#ArregloProductos[i].Orden#', null, '#ws_movimiento#',
			'#ws_CuentaFinancieraDet#', null, null, 0, #rsFuturos.Mcodigo#,
			#ws_Doriginal#, #ws_Dlocal#, #ws_Dtipocambio#, #ws_Cconcepto#,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			#session.usucodigo#, #session.Ecodigo#, null,
			null, null, 0, null)
		</cfquery>
	</cfloop>
	</cftransaction>	
</cfloop>
