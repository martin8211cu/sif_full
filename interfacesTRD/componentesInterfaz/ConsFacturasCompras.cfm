<!--- Archivo    :  FacturasProductosA-sql.cfm
	  --->
<cfsetting requesttimeout="900">

<!--- Para desarrollo "sif_interfacesser.." y para produccción "sif_interfaces.."  --->
<cfset LvarDsource = "sif_interfaces..">
<cfset session.Dsource = LvarDsource>

<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">

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
		ab.c_moneda, abs(ab.f_importe_total) as f_monto_Enca, abs(ab.f_iva) as f_iva,
		ab.i_folio, ab.i_anio, ab.i_empresa, 
		det.c_producto, det.dt_bldate, abs(det.f_volumen) as f_volumen, det.c_unidad,
		abs(det.f_precio) as f_precio, abs(det.f_importe) as f_importe
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
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">
<!--- procesa los registros de compra  --->	
<cfloop query="queryCompras"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- valida que el valor del precio y el volumen  --->	
	<cfif queryCompras.f_precio EQ 1  or queryCompras.f_volumen EQ 1>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarTipoError = "El volumen o el precio tiene valor 1.">
	</cfif>

	<!--- valida que el monto del voucher sea igual al monto de la factura  --->	
	<cfset vDiff = abs(queryCompras.voucher_tot_amt - (queryCompras.f_monto_Enca + queryCompras.f_iva))>
	<cfif vDiff GT 10>
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
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	</cfif>


	<cfset LvarConceptoCompra = "00">

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
	<cfset LvarTrade_num = 0>
	<cfset LvarOrder_num = 0>
	<cfset LvarItem_num = 0>
	<cfset LvarBanderaErrores_registro = true>
	<cfset LvarBanderaErrores = true>
	<cfif len(LvarTipoError)>
		<cfset LvarTipoError = LvarTipoError & ", ">
	</cfif>
	<cfset LvarTipoError = LvarTipoError & "No existen costos definidos">
<cfelse>
	<cfset LvarTrade_num = rsVerifica.trade_num>
	<cfset LvarOrder_num = rsVerifica.order_num>
	<cfset LvarItem_num = rsVerifica.item_num>
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
		where ti.trade_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvartrade_num#">
		   and ti.order_num= <cfqueryparam cfsqltype="cf_sql_smallint" value="#Lvarorder_num#">
		   and ti.item_num= <cfqueryparam cfsqltype="cf_sql_smallint" value="#Lvaritem_num#">
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

<cfif ISDATE(rsTrade.title_tran_date)>
	<cfset LvarTitle_tran_date=rsTrade.title_tran_date>
<cfelse>
	<cfset LvarTitle_tran_date=querycompras.dt_fecha_recibo>
</cfif>

<cfif len(LvarTipoError)>
	<!--- Graba error en tabla temporal ErroresPMI  --->
	<cfquery datasource="preicts">
		insert #LvarDsource#ErroresPMI (fecharegistro, sessionid, Ecodigo,FechaProceso,FechaDocumento,TipoDocumento,
			UsuarioProceso,MensajeError,Documento,Modulo,Monto,Trade_Num,Order_Num,Item_Num)
		values (<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">,
				#session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.voucher_creation_date#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.dt_fecha_recibo#">,
				'Voucher-Folio', #session.Usucodigo#, '#LvarTipoError#', '#queryCompras.voucher_num#',
				'CXP',
				<cfif isnumeric(querycompras.f_monto_Enca)>
					<cfqueryparam cfsqltype="cf_sql_float" value="#querycompras.f_monto_Enca#">,
				<cfelse>
					null,
				</cfif>
				 #LvarTrade_num#, #LvarOrder_num#,
				#LvarItem_num#)
	</cfquery> 
<cfelse>
	<!--- se inserta el registro en tabla temporal ProductoPMI   --->
	<cfquery datasource="preicts">
		insert #LvarDsource#ProductosPMI (fecharegistro,sessionid,documento,orden,socionegocio,Nsocio,
			producto,fechavoucher,vouchernum,trade_num,order_num,item_num,importe,modulo,
			tipotransaccion,iva,moneda,Ecodigo)
		values (<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">,
				'#querycompras.c_docto_proveedor#', '#querycompras.c_orden#', #querycompras.acct_num#,
				#LvarSNid#, '#querycompras.c_producto#', 
				<cfqueryparam cfsqltype="cf_sql_date" value="#querycompras.voucher_creation_date#">,
				#querycompras.voucher_num#, #LvarTrade_num#, #LvarOrder_num#,
				#LvarItem_num#, #querycompras.f_importe#, 'CXP', '#querycompras.c_tipo_folio#',
				0, '#querycompras.c_moneda#', #session.Ecodigo#)
	</cfquery> 
</cfif>
</cfloop>
