<!--- Archivo    :  FacturasProductosA-sql.cfm
	  --->

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">

<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

<cfquery name="rsEmpresa" datasource="sifinterfaces">
	select Ecodigo, CodICTS
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<!--- Crea query de compras  --->
<cfquery name="queryCompras" datasource="preicts">
	select aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
		aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name, aa.voucher_creation_date,
		ab.dt_fecha_vencimiento, ab.dt_fecha_recibo, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
		ab.c_moneda, abs(ab.f_importe_total), abs(ab.f_iva), ab.i_folio, ab.i_anio, ab.i_empresa, 
		det.c_producto, det.dt_bldate, abs(det.f_volumen), det.c_unidad, abs(det.f_precio), abs(det.f_importe)
	from voucher aa
		inner join PmiFolios ab
			inner join PmiFoliosDetailP det
			on det.i_folio = ab.i_folio
			and det.i_anio = ab.i_anio
		on ab.i_voucher = aa.voucher_num
		and ab.i_empresa_prop = aa.voucher_book_comp_num
		and (ab.c_tipo_folio = 'FA' or ab.c_tipo_folio = 'ND' or ab.c_tipo_folio = 'NC')

	where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.CodICTS#">
	and aa.voucher_creation_date is not null
	and aa.voucher_creation_date between 
		<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
		and
		<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaF)#">
	order by ab.i_empresa, ab.c_tipo_folio, ab.c_docto_proveedor
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cf_htmlreportsheaders
	title="Importacion de Compras de ICTS" 
	filename="ImportaCompras-#Session.Usucodigo#.xls" 
	ira="FacturasProductosParam.cfm">

<cf_templatecss>

<cfoutput>
<table width="100%" border="1">
	<tr><td colspan="8" align="center"><strong>Reporte de Errores</strong></td>
	<tr><td colspan="8" align="center"><strong>Proceso de Carga de Compra de Producto</strong></td>
	<tr><td colspan="8" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="8">&nbsp;</td></tr>
	<tr><td colspan="8">Registros: #queryCompras.recordcount# </td></tr>
	<tr><td colspan="8">&nbsp;</td></tr>
	<tr>
		<td><strong>Fecha</strong></td>
		<td><strong>Voucher</strong></td>
		<td><strong>Fecha Fact</strong></td>
		<td><strong>Factura</strong></td>
		<td><strong>Producto</strong></td>
		<td><strong>Error</strong></td>
		<td align="right"><strong>Volumen</strong></td>
		<td align="right"><strong>Importe</strong></td>
	</tr>
	<tr><td colspan="8">&nbsp;</td></tr>
	<cfflush interval="40">
</cfoutput>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">
<!--- procesa los registros de compra  --->	
<cfloop query="queryCompras"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- valida que el monto del voucher sea igual al monto de la factura  --->	
	<cfif queryCompras.c_tipo_folio EQ "FA"  or queryCompras.c_tipo_folio EQ "ND">
		<cfset vDiff = abs(queryCompras.voucher_tot_amt - (queryCompras.f_importe_total + queryCompras.f_iva))>
	<cfelse>
		<cfset vDiff = abs(queryCompras.voucher_tot_amt + (queryCompras.f_importe_total + queryCompras.f_iva))>
	</cfif>
	<cfif vDiff GT 2>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarTipoError = "Diferencia Montos Voucher/Factura">
	</cfif>

	<!--- Existencia del Socio de Negocio  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select SNid
		from SNegocios s
		where s.Ecodigo = #session.ecodigo#
		  and s.SNcodigoext = '#queryCompras.i_empresa#'
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarSNid = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
	<cfelse>
		<cfset LvarSNid = rsVerifica.SNid>
	</cfif>

	<!--- Existencia del Articulo  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select a.Aid
		from Articulos a
		where a.Ecodigo 	= #session.ecodigo#
		  and a.Acodalterno = '#queryCompras.c_producto#'
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarAid = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
	<cfelse>
		<cfset LvarAid = rsVerifica.Aid>
	</cfif>

	<!--- Moneda es Valida  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Mcodigo
		from Monedas a
		where a.Ecodigo  = #session.ecodigo#
		  and a.Miso4217 = '#queryCompras.voucher_curr_code#'
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
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

	<!--- Unidad es Valida  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Ucodigo
		from Unidades a
		where a.Ecodigo  = #session.ecodigo#
		  and a.Ucodigo = '#queryCompras.c_unidad#'
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarMcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	</cfif> 

	<cfset LvarConceptoCompra = "00">

<!---
	<!--- Concepto de compra se usa en ID10 --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select a2.Ccodigoclas from Articulos a1, Clasificaciones a2
		where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a1.Acodalterno = '#queryCompras.c_producto#'
		  and a1.Ccodigo = a2.Ccodigo
		  and a1.Ecodigo = a2.Ecodigo
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarConceptoCompra = "">
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Concepto de compra Incorrecto">
	<cfelse>
		<cfset LvarConceptoCompra = rsVerifica.Ccodigoclas>
	</cfif> 
--->


<!---
	<cfset LvarOCconceptoCompra = "">
	<!--- OCconceptoCompra      --->
	<cfquery name="rsVerifica" datasource="tesoreria">
		select sb.subconcepto_id
		FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
		WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_code#">
		  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_type_code#">
		  AND s.payable_receivable = 'P' 
		  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
		  AND sb.subconcepto_id = r.subconcepto_id
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarOCconceptoCompra = "">
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Concepto Compra no definido">
	<cfelse>
		<cfquery name="rsConceptos" datasource="#session.dsn#">
			select cuentac
			FROM Conceptos 
			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		      and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ToString(rsVerifica.subconcepto_id)#">
		</cfquery>
		<cfif rsConceptos.recordcount EQ 0>
			<cfset LvarOCconceptoCompra = rsConceptos.cuentac>
		</cfif>
	</cfif>
--->
	<cfset LvarCodigoImpuesto = "">
	<!--- OCconceptoCompra del iva    --->
	<cfif queryCompras.f_iva GT 0>
		<cfquery name="rsVerifica" datasource="tesoreria">
			select sb.subconcepto_id
			FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="TAX">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_type_code#">
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
			<cfset LvarTipoError = LvarTipoError & "Concepto Compra IVA no definido">
		<cfelse>
			<cfquery name="rsConceptos" datasource="#session.dsn#">
				select cuentac
				FROM Conceptos 
				WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
  			      and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ToString(rsVerifica.subconcepto_id)#">
			</cfquery>
			<cfif rsConceptos.recordcount EQ 0>
				<cfset LvarCodigoImpuesto = rsConceptos.cuentac>
			</cfif>
		</cfif>
	</cfif>

<!--- Arma la cuenta financiera     --->
<cfif len(LvarAid)>
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
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarCuentaFinanciera = "">
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Cuenta Financiera no definida">
	<cfelse>
		<cfset LvarCuentaFinanciera = rsVerifica.Cformato>
	</cfif>
</cfif>

<!--- Consulta la información de costos tablas cost   --->
<cfquery name="rsVerifica" datasource="preicts">
	select co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num,
	 co.cost_owner_key8 as item_num from cost co
		inner join voucher vo
			inner join voucher_cost vco
				on vco.voucher_num = vo.voucher_num
		on vo.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#querycompras.voucher_num#">
	where co.cost_num = vco.cost_num
	  and co.cost_status IN ('PAID','VOUCHED')
	group by co.cost_owner_key6, co.cost_owner_key7, co.cost_owner_key8
</cfquery>
<cfif rsVerifica.recordcount EQ 0>
	<cfset LvarBanderaErrores_registro = true>
	<cfset LvarBanderaErrores = true>
	<cfif len(LvarTipoError)>
		<cfset LvarTipoError = LvarTipoError & ", ">
	</cfif>
	<cfset LvarTipoError = LvarTipoError & "No existen costos definidos">
</cfif>

<!--- Consulta información del Trade, trade_order, trade_item   --->
<cfif rsVerifica.recordcount GT 0>
	<cfquery name="rsTrade" datasource="preicts">
	
		select ai.title_tran_date, ai.trade_num, ai.order_num, ai.item_num,
			a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, ai.del_term_code,
			a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, a6.creation_date,
			a5.creation_date as fecha_allocation, ti.real_port_num
		from trade_item ti
			inner join trade_order a7
				inner join trade a6
				on a6.trade_num=a7.trade_num
			on a7.trade_num=ti.trade_num
			and a7.order_num=ti.order_num
			
			inner join allocation_item ai
				inner join allocation a5
				on a5.alloc_num =ai.alloc_num
				inner join allocation_item_transport a10
				on a10.alloc_num = ai.alloc_num
				and a10.alloc_item_num = ai.alloc_item_num
			on ai.trade_num = ti.trade_num
			and ai.order_num = ti.order_num
			and ai.item_num = ti.item_num
		where ti.trade_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerifica.trade_num#">
		   and ti.order_num= <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsVerifica.order_num#">
		   and ti.item_num= <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsVerifica.item_num#">
	</cfquery>
</cfif>

<!--- decodifica campo alloc_type_code  --->	
<cfif rsTrade.alloc_type_code EQ "W">
	<cfset LvarOCTtipo = "B">
<cfelseif rsTrade.alloc_type_code EQ "R">
	<cfset LvarOCTtipo = "F">
<cfelse>
	<cfset LvarOCTtipo = "T">
</cfif>

<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
<cfset LvarOCtipoIC = "C">
<cfset LvarAlmacen = "">
<cfset LvarTransporte = "queryCompras.c_order">
<cfset LvarSocioAlloc = 0>

<cfif rsVerifica.recordcount GT 0>
	<cfquery name="rsTipoAlloc" datasource="preicts">
		select distinct oo.order_type_code, a2.trade_num, a2.acct_ref_num, a2.acct_num
		from allocation_item a1
			inner join allocation_item a2
				on a1.alloc_num = a2.alloc_num
				   and a1.trade_num <> a2.trade_num
			inner join allocation_item_transport a3
				on a3.alloc_num = a2.alloc_num
			   and a3.alloc_item_num = a2.alloc_item_num
			inner join trade_order oo
				on oo.trade_num = a2.trade_num
			   and oo.order_num = a2.order_num
		where a1.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTrade_Num#">
		   and a1.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#LvarOrder_Num#">
		   and a1.item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#LvarItem_Num#">
		order by oo.order_type_code
	</cfquery>
	
	<cfif rsTipoAlloc.recordcount GT 0>
		<cfif rsTipoAlloc.order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = rsTipoAlloc.acct_num>
		</cfif>
		<cfif rsTipoAlloc.order_type_code EQ 'STORAGE'>
			<cfset LvarOCtipoIC = "I">
			<cfset LvarAlmacen = rsTipoAlloc.acct_ref_num>
			<cfset LvarSocioAlloc = rsTipoAlloc.acct_num>
		<cfelseif rsTipoAlloc.order_type_code EQ 'TRANSPRT'>
			<cfset LvarTransporte = rsTipoAlloc.acct_ref_num>
			<cfquery name="rsTipo" datasource="preicts">
				select oo.order_type_code, a2.acct_ref_num, a2.acct_num from allocation_item a1
						inner join allocation_item a2
							on a2.alloc_num = a1.alloc_num
							 and a1.trade_num <> a2.trade_num
						inner join trade_item ti
							on ti.trade_num = a2.trade_num
							 and ti.order_num = a2.order_num
							 and ti.item_num = a2.item_num
							 and ti.p_s_ind = 'S'
						inner join trade_order oo
							on oo.trade_num = a2.trade_num
								 and oo.order_num = a2.order_num
					 where a1.trade_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoAlloc.trade_num#">
					 order by oo.order_type_code
			</cfquery>
			<cfif rsTipo.recordcount GT 0>
				<cfif rsTipo.order_type_code EQ 'PHYSICAL'>
					<cfset LvarOCtipoIC = "C">
					<cfset LvarSocioAlloc = rsTipo.acct_num>
				</cfif>
			
				<cfif rsTipo.order_type_code EQ 'STORAGE'>
					<cfset LvarOCtipoIC = "I">
					<cfset LvarAlmacen = rsTipo.acct_ref_num>
					<cfset LvarSocioAlloc = rsTipo.acct_num>
				</cfif>
			</cfif>
		</cfif>
	</cfif>    
</cfif>

<cfif ISDATE(rsTrade.bl_ticket_num)>
	<cfset Lvarbl_ticket_num=rsTrade.bl_ticket_num>
<cfelse>
	<cfset Lvarbl_ticket_num=0>
</cfif>

<cfif ISDATE(rsTrade.bl_date)>
	<cfset Lvarbl_date=rsTrade.bl_date>
<cfelse>
	<cfset Lvarbl_date=querycompras.dt_fecha_recibo>
</cfif>
	
	<cfset LvarID = 0>
	<!--- Verificar si cambia el voucher number para generar un nuevo IE10 --->
	<cfif LvarControlSocio NEQ queryCompras.i_empresa or LvarControlTipo neq queryCompras.c_tipo_folio or LvarControlDocto neq queryCompras.c_docto_proveedor>
		<cfquery name="rsVerificaIE10" datasource="sifinterfaces">
			select count(1) as Cantidad
			from IE10
			where EcodigoSDC = 14
			  and NumeroSocio = '#queryCompras.i_empresa#'
			  and Modulo = 'CP'
			  and CodigoTransacion = '#queryCompras.c_tipo_folio#'
			  and Documento = '#queryCompras.c_docto_proveedor#'
		</cfquery>
		<cfif rsVerificaIE10.Cantidad GT 0>
			<cfset LvarID = 0>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Ya se Importó el Documento">
		<cfelse>
			<cfif LvarBanderaErrores_registro EQ false>
				<!--- Obtener el siguiente ID para procesar el registro --->
				<cftransaction>
				<cfquery datasource="sifinterfaces">
					update IdProceso
					set Consecutivo = Consecutivo + 1			
				</cfquery>
				<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
					select Consecutivo
					from IdProceso
				</cfquery>
				</cftransaction>
				<cfset LvarID = rsObtieneSigId.consecutivo>
				<cfset LvarConsecutivoID10 = 0>
				<cfquery datasource="sifinterfaces">
					insert into IE10 (
						ID, EcodigoSDC, NumeroSocio, Modulo, 
						CodigoTransacion, Documento, Estado, 
						CodigoMoneda, 
						FechaDocumento, 
						FechaVencimiento, 
						Facturado, Origen, VoucherNo, CodigoConceptoServicio, 
						CodigoRetencion, CodigoOficina, CuentaFinanciera, 
						BMUsucodigo, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
						FechaTipoCambio, StatusProceso)
					values( 
						#LvarID#, 14, '#queryCompras.i_empresa#', 'CP',
						'#queryCompras.c_tipo_folio#', '#queryCompras.c_docto_proveedor#', ' ',
						'#queryCompras.voucher_curr_code#', 
						<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.dt_fecha_recibo#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.dt_fecha_vencimiento#">,
						'S', 'CP', '#queryCompras.voucher_num#', null, 
						null, null, null,
						#session.usucodigo#, 0, null, null, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.title_tran_date#">, 
						1)
				</cfquery>
			</cfif>
		</cfif>
		<cfset LvarControlSocio = queryCompras.i_empresa>
		<cfset LvarControlTipo = queryCompras.c_tipo_folio>
		<cfset LvarControlDocto = queryCompras.c_docto_proveedor>
	</cfif>

	<cfif LvarID GT 0>
		<cfif LvarBanderaErrores_registro EQ false>
			<cfset LvarConsecutivoID10 = LvarConsecutivoID10 + 1>
			<cfquery datasource="sifinterfaces">
				insert ID10 (
					ID, Consecutivo, TipoItem, CodigoItem, 
					NombreBarco, FechaHoraCarga, FechaHoraSalida, 
					PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
					TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
					ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
					BMUsucodigo, PrecioTotal, 
					CentroFuncional, CuentaFinancieraDet, 
					OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
				values(
					#LvarID#, #LvarConsecutivoID10#, 'O', '#queryCompras.c_producto#',
					'#rsTrade.transportation#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.load_compl_date#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.nor_date#">,
					#queryCompras.f_precio#, '#queryCompras.c_unidad#', #queryCompras.f_volumen#,
					#queryCompras.f_volumen#, '#rsTrade.del_term_code#', '#Lvarbl_ticket_num#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
					'trip', '#queryCompras.c_orden#', '#LvarCodigoImpuesto#', #queryCompras.f_iva#,
					0.00, null, null,
					#session.usucodigo#, #queryCompras.f_importe#,
					null, '#LvarCuentaFinanciera#',
					'#LvarOCTtipo#', '#LvarTransporte#', '#queryCompras.c_orden#', '#LvarConceptoCompra#'
					)
			</cfquery>>
		</cfif>
	</cfif>

	<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->
	<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
	<cfif LvarBanderaErrores_registro EQ false>
		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select OCid
			from OCordenComercial
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#querycompras.c_orden#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>
			<cfset vOCid = 0>
		<cfelse>
			<cfset vOCid = rsVerifica.OCid>
		</cfif>

		<cfif vOCid GT 0>
			<!---			<cfset GraboOk = OGeneralProcB.ReversionNoFact(session.qproductos.orden,
															 trade_num)>
			--->
			<cfset solopruebas = "">			
		</cfif>
		<cfif vOCid EQ 0>
			<cfquery datasource="#Session.Dsn#">
				insert OCordenComercial
					(OCtipoOD, OCtipoIC, Ecodigo,
					 SNid, OCcontrato,
					 OCfecha,
					 Mcodigo,
					 OCVid,
					 OCestado, OCmodulo, OCincoterm, OCtrade_num, OCorder_num,
					 OCfechaAllocationDefault, 
					 OCfechaPropiedadDefault,
					 BMUsucodigo)
				values (
					'O', '#LvarOCtipoIC#', #session.Ecodigo#,
					 #LvarSNid#, '#querycompras.c_orden#',
 				     <cfif isdate(rsTrade.creation_date)>
					    <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.creation_date#">,
				     <cfelse>
					    null,
				     </cfif>
					 #LvarMcodigo#,
					 null,
					 'A','CP',
					 '#rsTrade.del_term_code#',
 				     <cfif isnumeric(rsTrade.trade_num)>
					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTrade.trade_num#">,
				     <cfelse>
					    null,
				     </cfif>
 				     <cfif isnumeric(rsTrade.order_num)>
					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTrade.order_num#">,
				     <cfelse>
					    null,
				     </cfif>
 				     <cfif isdate(rsTrade.fecha_allocation)>
					    <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.fecha_allocation#">,
				     <cfelse>
					    null,
				     </cfif>
 				     <cfif isdate(rsTrade.title_tran_date)>
					    <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.title_tran_date#">,
				     <cfelse>
					    null,
				     </cfif>
					#session.usucodigo#
					)
			</cfquery>
			<cfquery name="rsVerifica" datasource="#Session.Dsn#">
				select MAX(OCid) as valorID
				from OCordenComercial
			</cfquery>
			<cfset vOCid = rsVerifica.valorID>
		</cfif>

		<!---  revisa si existe la OrdenProducto en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select *
			from OCordenProducto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>
			<cfquery name="query" datasource="#Session.Dsn#">
				insert INTO OCordenProducto
					(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
					 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
				  <cfqueryparam cfsqltype="cf_sql_smallint" value=1>,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#querycompras.c_unidad#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value="#querycompras.f_volumen#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#querycompras.f_precio#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#querycompras.f_importe#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value=0>,
				  null,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCuentaFinanciera#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>
		<cfelse>

			<cfset LvarSuma = rsVerifica.OCPcantidad + querycompras.f_volumen>
			<cfif LvarSuma EQ 0>
				<cfset LvarSuma = 1>
			</cfif>
			
			<cfset LvarCantidad = (rsVerifica.OCPcantidad + querycompras.f_volumen)>
			<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + querycompras.f_importe) / LvarSuma>
			<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + querycompras.f_importe>
		
			<cfquery datasource="#Session.Dsn#">
				update OCordenProducto set
					OCPcantidad=#LvarCantidad#,
					OCPprecioUnitario=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarPrecioUnitario#">,
					OCPprecioTotal=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarPrecioTotal#">
  			    where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
			</cfquery>
		</cfif>

		<!---  revisa si existe el Transporte en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select OCTid
			from OCtransporte
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTtransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTransporte#">
		</cfquery>

		<cfif rsVerifica.recordcount EQ 0>
			<cfset vOCTid = 0>
		<cfelse>
			<cfset vOCTid = rsVerifica.OCTid>
		</cfif>

		<cfif vOCTid EQ 0>
			<cfquery name="query" datasource="#Session.Dsn#">
				insert INTO OCtransporte
					(Ecodigo, OCTtipo, OCTtransporte, OCTestado, OCTfechaPartida, OCTobservaciones,
					 OCTvehiculo, OCTruta, OCTfechaLlegada, OCTPnumeroBOLdefault, OCTPfechaBOLdefault, 
					 BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#LvarOCTtipo#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#LvarTransporte#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
				  <cfif isdate(rsTrade.load_compl_date)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.load_compl_date#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  </cfif>
				  null,
				  null,
				  null,
				  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.nor_date#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvarbl_ticket_num#">,
				  <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>

			<cfquery name="rsVerifica" datasource="#Session.Dsn#">
				select MAX(OCTid) as valorID
				from OCtransporte
			</cfquery>
			<cfset vOCTid = rsVerifica.valorID>
		</cfif>

		<!---  revisa si existe el TransporteProducto en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select *
			from OCtransporteProducto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
			  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>
			<cfquery name="query" datasource="#Session.Dsn#">
				insert INTO OCtransporteProducto
					(OCTid, OCid, Aid, Ecodigo, OCPTestado, OCtipoOD, OCTPnumeroBOL, OCTPfechaBOL,
					 OCTPcontrato, OCTPfechaAllocation, OCTPfechaPropiedad, OCTPcantidadTeorica,
					 OCTPprecioUniTeorico, OCTPprecioTotTeorico, OCTPcantidadReal, OCTPprecioReal,
					 BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="F">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="O">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvarbl_ticket_num#">,
				  <cfif isdate(Lvarbl_date)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  </cfif>
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTransporte#">,
				  <cfif isdate(rsTrade.fecha_allocation)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.fecha_allocation#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  </cfif>
				  <cfif isdate(rsTrade.title_tran_date)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.title_tran_date#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#querycompras.dt_fecha_recibo#">,
				  </cfif>
				  <cfqueryparam cfsqltype="cf_sql_float" value="#querycompras.f_volumen#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#querycompras.f_precio#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#querycompras.f_importe#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		<cfelse>
			<cfset LvarCantidad = (rsVerifica.OCTPcantidadTeorica + querycompras.f_volumen)>
			<cfset LvarPrecioUnitario = (rsVerifica.OCTPprecioTotTeorico + querycompras.f_importe) /
				 (rsVerifica.OCTPcantidadTeorica + querycompras.f_volumen)>
			<cfset LvarPrecioTotal = rsVerifica.OCTPprecioTotTeorico + querycompras.f_importe>

			<cfquery datasource="#Session.Dsn#">
				update OCtransporteProducto set
					OCTPcantidadTeorica=#LvarCantidad#,
					OCTPprecioUniTeorico=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarPrecioUnitario#">,
					OCTPprecioTotTeorico=<cfqueryparam cfsqltype="cf_sql_money" value="#LvarPrecioTotal#">
  			    where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
				  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
			</cfquery>
		</cfif>

		<!---  revisa si existe el ProductoTransito en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select OCTid
			from OCproductoTransito
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
		</cfquery>

		<cfif rsVerifica.recordcount EQ 0>
			<cfquery name="query" datasource="#Session.Dsn#">
				insert OCproductoTransito
					(OCTid, Aid, Ecodigo, OCPTtransformado, OCPTentradasCantidad, OCPTentradasCostoTotal,
					 OCPTsalidasCantidad, OCPTsalidasCostoTotal, BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_bit" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_float" value="#querycompras.f_volumen#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#querycompras.f_importe#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>
		</cfif>
	</cfif>

		<!--- FIN SECCION ORDENES COMERCIALES  --->


	<cfif isdefined("form.MostrarTodo") or len(LvarTipoError)>
		<cfoutput>
		<tr>
			<td>#LSDateFormat(queryCompras.voucher_creation_date,'dd/mm/yyyy')#</td>
			<td>#queryCompras.voucher_num#</td>
			<td>#LsDateFormat(queryCompras.dt_fecha_recibo,'dd/mm/yyyy')#</td>
			<td>#queryCompras.c_tipo_folio#-#queryCompras.c_docto_proveedor#</td>
			<td>#queryCompras.c_producto#</td>
			<cfif LvarTipoError NEQ "">
				<td>#LvarTipoError#</td>
			<cfelse>
				<td>&nbsp;</td>
			</cfif>
			<td align="right">#numberformat(queryCompras.f_volumen, ",0.00")#</td>
			<td align="right">#numberformat(queryCompras.f_importe,",0.00")#</td>
		</tr>
		</cfoutput>
	</cfif>
	
</cfloop>

<!--- Inclusión de movimiento en cola de proceso  --->
<cfquery name="rsIE10" datasource="sifinterfaces">
	select ID, EcodigoSDC
	from IE10
	where EcodigoSDC=14 
	  and ID not in (select IdProceso from InterfazBitacoraProcesos where EcodigoSDC=14 and NumeroInterfaz=10) 
	  and ID not in(select IdProceso from InterfazColaProcesos where EcodigoSDC=14 and NumeroInterfaz=10)
</cfquery>

<cfloop query="rsIE10"> 
	<cfquery name="rsColaProcesos" datasource="sifinterfaces">
		insert InterfazColaProcesos
			(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz, TipoProcesamiento,
			 StatusProceso, FechaInclusion, UsucodigoInclusion, Cancelar)
		values (
		  <cfqueryparam cfsqltype="cf_sql_numeric" value=2>,
		  <cfqueryparam cfsqltype="cf_sql_integer" value=10>,
		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE10.ID#">,
		  <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE10.EcodigoSDC#">,
		  <cfqueryparam cfsqltype="cf_sql_char" value="E">,
		  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
		  <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
		  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
		  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
	</cfquery>
</cfloop>


<cfoutput>
<cfif not LvarBanderaErrores>
	<tr><td colspan="8">&nbsp;</td></tr>
	<tr><td colspan="8" align="center"><strong>No se presentaron errores en la importacion.</strong></td>
</cfif>
	<cfset LvarTiempoProceso = datediff("s",LvarHoraInicio,now())>
	<tr><td colspan="8">&nbsp;</td></tr>
	<tr><td colspan="8">Tiempo de Proceso:#NumberFormat(LvarTiempoProceso, ",0")# Segundos</td></tr>
</table>
</cfoutput>

