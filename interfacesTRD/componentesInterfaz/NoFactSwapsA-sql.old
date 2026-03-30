<!--- Archivo    :  NoFactSwapsA-sql.cfm
	  --->

<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">

<cfset LvarHoraInicio = now()>

<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

<cfset session.FechaFolio = "#right(form.FechaF,4)##mid(form.FechaF,4,2)#">
<cfset session.FechaFinal = vFechaF>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select Ecodigo, CodICTS
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.EmpresaICTS = rsVerifica.CodICTS>
</cfif>

<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>

<!--- Para desarrollo "sif_interfacesser.." y para produccción "sif_interfaces.."  --->
<cfset LvarDsource = "sif_interfacesser..">
<cfset session.Dsource = LvarDsource>

<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#nofactSwapsPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_IE10 where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_ID10 where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfacesser..nofactSwapsPMI (fecharegistro date null,sessionid numeric null,
		ID integer null, trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, order_type_code varchar(8) null,
		cost_num integer null, cost_code varchar(8) null, cost_pay_rec_ind char(1) null, port_num integer null,
		cost_price_curr_code varchar(8) null, cost_price_uom_code char(4) null, cost_amt float null,
		creation_date date null, cost_eff_date date null, cost_due_date date null,
		SNid numeric null, Aid numeric null, UcodigoArt char(5) null, Mcodigo numeric null, Ucodigo char(5) null,
		subconcepto integer null, CodigoConcepto char(5) null, cost_type_code varchar(8) null, 
		ta_order_type_code varchar(8) null, ta_trade_num int null, ta_acct_ref_num char(10) null, 
		ta_acct_num int null, tt_order_type_code char(8) null, tt_acct_ref_num char(10) null,
		tt_acct_num int null, montocosto float null, PosNeg char(1) null, avg_price float null)
--->

<!--- Crea query de compras  --->
<cfquery datasource="preicts">
	insert #LvarDsource#nofactSwapsPMI (fecharegistro, sessionid,
		trade_num, order_num, item_num, acct_ref_num, acct_num, booking_comp_num,
		order_type_code, 
		cost_code, cost_pay_rec_ind, port_num, cost_price_curr_code, cost_price_uom_code,
		cost_amt, creation_date, cost_eff_date, cost_due_date, cost_num
		   )
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
		ti.trade_num, ti.order_num, ti.item_num, tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
		oo.order_type_code, 
		co.cost_code, co.cost_pay_rec_ind, co.port_num, co.cost_price_curr_code, co.cost_price_uom_code,
		co.cost_amt, co.creation_date, co.cost_eff_date, co.cost_due_date, co.cost_num
	from trade_item ti
		inner join accumulation ac
		on ac.trade_num = ti.trade_num
		and ac.order_num = ti.order_num
		and ac.item_num = ti.item_num
		and ac.price_status in ('U','P')
		inner join trade_order oo
			inner join trade tr
			on tr.trade_num = oo.trade_num
		on oo.trade_num = ti.trade_num
		   and oo.order_num = ti.order_num
		   and (oo.order_type_code='SWAP' or oo.order_type_code='SWAPFLT')
		   inner join cost co
				 on co.cost_owner_key6 = ti.trade_num
				 and co.cost_owner_key7 = ti.order_num
				 and co.cost_owner_key8 = ti.item_num 
				 and co.cost_status = 'OPEN'
				 and co.cost_code = ti.cmdty_code
			  and co.cost_book_comp_num=701
	where ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
	order by co.cost_owner_code
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">
<cfset ArregloProductos = ArrayNew(1)>

<!--- procesa los registros de nofact de fletes --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactSwapsPMI SET SNid = a2.SNid
	from #LvarDsource#nofactSwapsPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
</cfquery> 

<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactSwapsPMI SET Ucodigo = a2.Ucodigo
	from #LvarDsource#nofactSwapsPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.cost_price_uom_code
</cfquery>

<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#futuroscerradosPMI SET Mcodigo = a2.Mcodigo
	from #LvarDsource#futuroscerradosPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = case 
	  						when a1.voucher_curr_code = 'MXN' then 'MXP'
						 	else substr(a1.voucher_curr_code,1,3)
						 end
</cfquery>

<cfquery name="rsNoFact" datasource="sifinterfaces">
	select *
	from  #LvarDsource#nofactSwapsPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfset ConseIE10 = 0>
<cfloop query="rsNoFact"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- Existencia del Socio de Negocio  --->
	<cfif Len(rsNoFact.SNid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
	</cfif>

	<!--- Moneda es Valida  --->
	<cfif Len(rsNoFact.Mcodigo) EQ 0>
		<cfset LvarMcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
	<cfelse>
		<cfset LvarMcodigo = rsVerifica.Mcodigo>
	</cfif> 

	<!--- portnum es valido  --->
	<cfif Len(rsNoFact.port_num) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No. de Portafolio no existe">
	</cfif>

	<cfset ws_OCconceptoCompra = "">
	<cfset ws_OCconceptoIngreso = "">

	<!--- crear folio de noFact de swaps    --->
	<cfset ws_folio = "#rsNoFact.acct_ref_num#SWAP#session.FechaFolio#">
	<cfif rsNoFact.cost_pay_rec_ind EQ 'R'>
		<cfset ws_tipo_modulo = "CC">
		<cfset Lvarp_s_ind = "S">
	<cfelse>	
		<cfset ws_tipo_modulo = "CP">
		<cfset Lvarp_s_ind = "P">
	</cfif>
	
	<cfset ws_tipo_transaccion = "FS">

	<cfif Len(rsNoFact.port_num) GT 0>
		<cfset ArrayClear(ArregloProductos)>
		<!--- Distribución de Costos   --->
		<cfquery name="rsProductos" datasource="preicts">
			select distinct ti.cmdty_code, tr.acct_ref_num, ti.p_s_ind, oo.order_type_code
				from trade_item ti
				inner join trade_order oo
					inner join trade tr
					on tr.trade_num = oo.trade_num
				on oo.trade_num = ti.trade_num
				and oo.order_num = ti.order_num	
			where ti.booking_comp_num  = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			  and ti.real_port_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNoFact.port_num#">
			  and ti.p_s_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvarp_s_ind#">
			  and oo.order_type_code in ('PHYSICAL')
		</cfquery>
		<cfif rsProductos.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existen registros en portafolio">
		<cfelse>
			<cfloop query="rsProductos">
				<!--- Existencia del Articulo  --->
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select Aid, Ucodigo
					from Articulos 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#rsProductos.cmdty_code#">
				</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ProdStruct = StructNew()>
					<cfset ProdStruct.Producto = rsProductos.cmdty_code>
					<cfset ProdStruct.Orden = rsProductos.acct_ref_num>
					<cfset ProdStruct.TipoOrden = rsProductos.p_s_ind>
					<cfset ProdStruct.ConceptoCompra = "">
					<cfset ProdStruct.ConceptoIngreso = "">
					<cfset ArrayAppend(ArregloProductos,ProdStruct)>
				</cfif>
			</cfloop>
		</cfif>
		<cfif ArrayLen(ArregloProductos) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existen productos en portafolio">
		</cfif>
	</cfif>

	<cfset LvarEncontroOrden = "N">
	<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
		<!--- revisa si existe la Orden Comercial de compra si es CXP --->
		<cfif (ws_tipo_modulo EQ 'CP' and ArregloProductos[i].TipoOrden EQ 'P') or
		      (ws_tipo_modulo EQ 'CC' and ArregloProductos[i].TipoOrden EQ 'S')>
			<cfif Len(LvarTipoError) EQ 0>
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select OCid
					from OCordenComercial
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsNoFact.acct_ref_num#">
				</cfquery>
				
				<cfif rsVerifica.recordcount GT 0>
					<cfset LvarEncontroOrden = "S">
				<cfelse>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>

	<cfif LvarEncontroOrden EQ 'N'>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existe Orden Comercial">
	</cfif>

	<cfset ws_TipoItem = 'O'>

	<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
		<cfset ws_CodigoItem = ArregloProductos[i].Producto>
		<cfif (ws_tipo_modulo EQ 'CP' and ArregloProductos[i].TipoOrden EQ 'P')>
			<!--- OCconceptoCompra     --->
			<cfquery name="rsVerifica" datasource="tesoreria">
				select sb.subconcepto_id
				FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
				WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#ws_CodigoItem#">
				  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNoFact.order_type_code#">
				  AND s.payable_receivable = 'P' 
				  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
				  AND sb.subconcepto_id = r.subconcepto_id
			</cfquery>
			<cfif rsVerifica.recordcount EQ 0>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Concepto Compra no definido">
			<cfelse>
				<cfset ArregloProductos[i].ConceptoCompra = rsVerifica.subconcepto>
			</cfif>
		</cfif>

		<cfif (ws_tipo_modulo EQ 'CC' and ArregloProductos[i].TipoOrden EQ 'S')>
			<!--- OCconceptoIngreso     --->
			<cfquery name="rsVerifica" datasource="tesoreria">
				select sb.subconcepto_id
				FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
				WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#ws_CodigoItem#">
				  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNoFact.order_type_code#">
				  AND s.payable_receivable = 'R' 
				  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
				  AND sb.subconcepto_id = r.subconcepto_id
			</cfquery>
			<cfif rsVerifica.recordcount EQ 0>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Concepto Ingreso no definido">
			<cfelse>
				<cfset ArregloProductos[i].ConceptoIngreso = rsVerifica.subconcepto>
			</cfif>
		</cfif>

	</cfloop>

	<cfset ConseIE10 = ConseIE10 + 1>
	<!--- Graba en tabla pmiIE10  --->
	<cfquery datasource="sifinterfaces">
		insert into PMIINT_IE10 (FechaRegistro, sessionid,
			ID, EcodigoSDC, NumeroSocio, Modulo, 
			CodigoTransacion, Documento, Estado, 
			CodigoMoneda, 
			FechaDocumento, 
			FechaVencimiento, 
			Facturado, Origen, VoucherNo, CodigoConceptoServicio, 
			CodigoRetencion, CodigoOficina, CuentaFinanciera, 
			DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
			FechaTipoCambio, StatusProceso,MensajeError)
		values(getdate(), #session.monitoreo.sessionid#, 
			#ConseIE10#, 14, '#rsNoFact.acct_num#', '#ws_tipo_modulo#',
			'#ws_tipo_transaccion#', '#ws_folio#', ' ',
			'#rsNoFact.cost_price_curr_code#', 
			<cfif len(rsNoFact.cost_eff_date) GT 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.cost_eff_date#">, 
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">, 
			</cfif>
			null,
			'S', '#ws_tipo_modulo#', '#rsNoFact.trade_num#', null, 
			null, null, null,
			0, null, null, 
			<cfif len(rsNoFact.cost_eff_date) GT 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.cost_eff_date#">, 
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">, 
			</cfif>
			1,
			<cfif len(LvarTipoError) GT 0>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipoError#">
			<cfelse>
			null
			</cfif>
			)
	</cfquery>
	
	<cfif len(LvarTipoError) EQ 0>
		<cfset ws_registros = ArrayLen(ArregloProductos)>
		<cfset ws_monto = rsNoFact.cost_amt / ws_registros>
		<cfset ConseID10 = 0>
		<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
			<cfset ConseID10 = ConseID10 + 1>
			<cfset ws_CodigoItem = ArregloProductos[i].Producto>
			<cfif ws_tipo_modulo EQ 'CP'>
				<cfset ws_ConceptoCompra = ArregloProductos[i].ConceptoCompra>
			<cfelse>
				<cfset ws_ConceptoIngreso = ArregloProductos[i].ConceptoIngreso>
				<!--- Arma la cuenta financiera --->
				<cfset ws_CuentaFinancieraDet ="">
				<cfif len(ws_CodigoItem)>
					<!--- Existencia del Articulo  --->
					<cfquery name="rsVerifica" datasource="#session.dsn#">
						select Aid, Ucodigo
						from Articulos 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#ws_CodigoItem#">
					</cfquery>
					<cfif rsVerifica.recordcount EQ 0>
						<cfset LvarAid = 0>
					<cfelse>
						<cfset LvarAid = rsVerifica.Aid>
					</cfif>
					<!---
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
						<cfset ws_CuentaFinancieraDet = rsVerifica.Cformato>
					</cfif>
					--->
					
				</cfif> 
			</cfif>
			<cfset ws_OCcontrato = ArregloProductos[i].acct_ref_num>
			<cfset ws_OCtransporte = "">
			<cfset ws_Cantidad = 0>

			<cfquery name="rsVerifica" datasource="#session.dsn#">
				select a3.OCTtransporte
				from OCordenComercial a1
				inner join OCtrasporteProducto a2
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

			<cfquery datasource="sifinterfaces">
				insert PMIINT_ID10 (FechaRegistro,sessionid,
					ID, Consecutivo, TipoItem, CodigoItem, 
					NombreBarco, FechaHoraCarga, FechaHoraSalida, 
					PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
					TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
					ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
					PrecioTotal, 
					CentroFuncional, CuentaFinancieraDet, 
					OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra, OCconceptoIngreso)
				values(getdate(), #session.monitoreo.sessionid#,
					#ConseIE10#, #ConseID10#, '#ws_TipoItem#', '#ws_CodigoItem#',
					null,
					null, 
					null,
					<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(0,"9.99")#">, 
					'#rsNoFact.cost_price_uom_code#',
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_Cantidad#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_Cantidad#">, 
					null, ' ',
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">,
					null, '#ws_OCcontrato#', null, 0.00,
					0.00, null, null,
					#numberformat(ws_monto,"9.99")#,
					null, '#ws_CuentaFinancieraDet#',
					null, '#ws_Transporte#', '#ws_OCcontrato#',
 				    <cfif len(ws_OCconceptoCompra) GT 0>
					   <cfqueryparam cfsqltype="cf_sql_char" value="#ws_OCconceptoCompra#">,
				    <cfelse>
					   null,
				    </cfif>
 				    <cfif len(ws_OCconceptoIngreso) GT 0>
					   <cfqueryparam cfsqltype="cf_sql_char" value="#ws_OCconceptoIngreso#">
				    <cfelse>
					   null
				    </cfif>
					)
			</cfquery>
		</cfloop>
	</cfif>
</cfloop>
