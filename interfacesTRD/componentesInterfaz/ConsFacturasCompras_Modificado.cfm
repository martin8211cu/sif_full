<!--- Archivo    :  FacturasProductosA-sql.cfm
	  --->
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

<!--- Para desarrollo "sif_interfacesser.." y para produccción "sif_interfaces.."  --->
<cfset LvarDsource = "sif_interfacesser..">

<cfquery datasource="#session.dsn#">
	delete from #LvarDsource#ComprasProdPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ErroresPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ProductosPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#tempPMI where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfacesser..ComprasProdPMI (fecharegistro date null,sessionid numeric null,
		tipoconsulta char(1) null, trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, cmdty_code varchar(10),
		contr_date date null, title_tran_date date null)
create table sif_interfacesser..tempPMI (fecharegistro date null,sessionid numeric null,
		tipoconsulta char(1) null, trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, cmdty_code varchar(10),
		contr_date date null, title_tran_date date null)
--->

<!--- Crea query de compras  --->
<cfquery name="rsVerifica" datasource="preicts">
	insert #LvarDsource#ComprasProdPMI (fecharegistro, sessionid, voucher_num, acct_num, voucher_tot_amt,
	    voucher_curr_code, voucher_creator_init, voucher_acct_name, voucher_book_comp_name, voucher_creation_date,
		dt_fecha_vencimiento, dt_fecha_recibo, c_tipo_folio, c_orden, c_docto_proveedor, c_moneda,
		f_monto_Enca, f_iva, i_folio, i_anio, i_empresa, c_producto, dt_bldate, f_volumen, det.c_unidad,
		f_precio, f_importe, OCtipoIC, Errores)
	select aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
		aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name, aa.voucher_creation_date,
		ab.dt_fecha_vencimiento, ab.dt_fecha_recibo, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
		ab.c_moneda, abs(ab.f_importe_total) as f_monto_Enca, abs(ab.f_iva) as f_iva,
		ab.i_folio, ab.i_anio, ab.i_empresa, 
		det.c_producto, det.dt_bldate, abs(det.f_volumen) as f_volumen, det.c_unidad,
		abs(det.f_precio) as f_precio, abs(det.f_importe) as f_importe, 'C' as OCtipoIC, 'N' as Errores
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

<cfquery datasource="sifinterfaces">
	ALTER TABLE sif_interfacesser..ComprasProdPMI add SNid numeric null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add Aid numeric null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add UcodigoArt char(5) null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add Mcodigo numeric null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add Ucodigo char(5) null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add subconcepto integer null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add CodigoImpuesto char(5) null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add cost_code varchar(8) null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add cost_type_code varchar(8) null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add trade_num integer null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add order_num smallint null
	ALTER TABLE sif_interfacesser..ComprasProdPMI add item_num smallint null
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">

<!--- procesa los registros de compra  --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfacesser..ComprasProdPMI SET SNid = a2.SNid
	from sif_interfacesser..ComprasProdPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.i_empresa
</cfquery> 

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfacesser..ComprasProdPMI SET Aid = a2.Aid
	from  sif_interfacesser..ComprasProdPMI a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodalterno  = a1.c_producto
</cfquery>
<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfacesser..ComprasProdPMI SET Mcodigo = a2.Mcodigo
	from  sif_interfacesser..ComprasProdPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = a1.voucher_curr_code
</cfquery>
<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfacesser..ComprasProdPMI SET Ucodigo = a2.Ucodigo
	from sif_interfacesser..ComprasProdPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.c_unidad
</cfquery>

<!--- Consulta la información de costos tablas cost   --->
<cfquery datasource="preicts">
	insert #LvarDsource#tempPMI (fecharegistro, sessionid,um into ##TempPMI
    from cost co
		inner join voucher vo 
			inner join voucher_cost vco
				on vco.voucher_num = vo.voucher_num
		on vo.voucher_num in (select voucher_num from  sif_interfacesser..ComprasProdPMI)
	where co.cost_num = vco.cost_num
	  and co.cost_status IN ('PAID','VOUCHED')
	order by cost_amt desc
</cfquery>
create table sif_interfacesser..tempPMI (fecharegistro date null,sessionid numeric null,
		tipoconsulta char(1) null, trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, cmdty_code varchar(10),
		contr_date date null, title_tran_date date null)

<cfquery datasource="sifinterfaces">
	UPDATE  sif_interfacesser..ComprasProdPMI SET trade_num = a2.trade_num, order_num = a2.order_num,
	       item_num = a2.item_num, cost_type_code = a2.cost_type_code
	from  sif_interfacesser..ComprasProdPMI a1,  sif_interfacesser..TempPMI a2
	where a1.voucher_num = a2.voucher_num
	  and a1.c_producto = a2.cost_code
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table  sif_interfacesser..TempPMI
</cfquery> 

<cfset LvarConceptoCompra = "00">

<!--- subconcepto  --->
<cfquery datasource="sifinterfaces">
	UPDATE  sif_interfacesser..ComprasProdPMI SET subconcepto = sb.subconcepto_id
	from  sif_interfacesser..ComprasProdPMI a1, tesoreria..subconceptos sb,
         tesoreria..rel_subconceptos_detalles r, tesoreria..subconceptos_detalle s 
	WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="TAX">
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
</cfquery>
<!--- código de impuesto  --->
<cfquery datasource="sifinterfaces">
	UPDATE  sif_interfacesser..ComprasProdPMI SET CodigoImpuesto = a2.cuentac
	from  sif_interfacesser..ComprasProdPMI a1, minisiftrd..Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
</cfquery>

<cfquery datasource="sifinterfaces">
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add title_tran_date date null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add alloc_type_code char null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add del_term_code char null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add bl_ticket_num varchar null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add bl_date date null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add transportation varchar null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add load_compl_date date null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add nor_date date null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add trade_creation_date date null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add fecha_allocation date null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add real_port_num int null
</cfquery>

<!--- Consulta información del Trade, trade_order, trade_item   --->
<cfquery datasource="preicts">
	insert #LvarDsource#ComprasProdPMI (fecharegistro, sessionid, tipoconsulta, trade_num, order_num,
		item_num, acct_ref_num, acct_num, booking_comp_num, cmdty_code, contr_date,title_tran_date)
	select ai.title_tran_date, ai.trade_num, ai.order_num, ai.item_num,
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, 
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, a6.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num into sif_interfacesser..TempPMI
	from  sif_interfacesser..ComprasProdPMI ate, trade_item ti
		inner join trade_order a7
			inner join trade a6
			on a6.trade_num = a7.trade_num
		on ti.trade_num = a7.trade_num
		and ti.order_num = a7.order_num
		
		inner join allocation_item ai
			inner join allocation a5
			on a5.alloc_num = ai.alloc_num
			inner join allocation_item_transport a10
			on a10.alloc_num = ai.alloc_num
			and a10.alloc_item_num = ai.alloc_item_num
		on ti.trade_num = ai.trade_num
		and ti.order_num = ai.order_num
		and ti.item_num = ai.item_num
	where ti.trade_num= ate.trade_num
	   and ti.order_num= ate.order_num 
	   and ti.item_num= ate.item_num
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE  sif_interfacesser..ComprasProdPMI SET title_tran_date = a2.title_tran_date,
	 	   alloc_type_code = a2.alloc_type_code, del_term_code = a2.del_term_code, 
		   bl_ticket_num = a2.bl_ticket_num, bl_date = a2.bl_date, transportation = a2.transportation,
		   load_compl_date = a2.load_compl_date, trade_creation_date = a2.creation_date,
		   fecha_allocation = a2.fecha_allocation, real_port_num = a2.real_port_num
	from  sif_interfacesser..ComprasProdPMI a1,  sif_interfacesser..TempPMI a2
	where a1.trade_num = a2.trade_num
	  and a1.order_num = a2.order_num
	  and a1.item_num = a2.item_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table sif_interfacesser..TempPMI
</cfquery> 

<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
<cfset LvarOCtipoIC = "C">
<cfset LvarAlmacen = "">
<cfset LvarSocioAlloc = 0>
<cfset LvarOrdenAlloc = "">
<cfquery datasource="sifinterfaces">
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add ta_order_type_code char null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add ta_trade_num int null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add ta_acct_ref_num char null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add ta_acct_num int null
</cfquery>
<cfquery datasource="preicts">
	insert #LvarDsource#ComprasProdPMI (fecharegistro, sessionid, tipoconsulta, trade_num, order_num,
		item_num, acct_ref_num, acct_num, booking_comp_num, cmdty_code, contr_date,title_tran_date)
	select distinct oo.order_type_code, a2.trade_num, a2.order_num, a2.item_num, a2.acct_ref_num, a2.acct_num
		into  sif_interfacesser..TempPMI
	from  sif_interfacesser..ComprasProdPMI ate, allocation_item a1
		inner join allocation_item a2
			on a1.alloc_num = a2.alloc_num
			   and a1.trade_num <> a2.trade_num
		inner join allocation_item_transport a3
			on a3.alloc_num = a2.alloc_num
		   and a3.alloc_item_num = a2.alloc_item_num
		inner join trade_order oo
			on oo.trade_num = a2.trade_num
		   and oo.order_num = a2.order_num
	where a1.trade_num = ate.trade_num
	   and a1.order_num = ate.order_num
	   and a1.item_num = ate.item_num
	order by oo.order_type_code
</cfquery>
<cfquery datasource="sifinterfaces">
	UPDATE  sif_interfacesser..ComprasProdPMI SET ta_order_type_code = a2.order_type_code,
	 	   ta_trade_num = a2.trade_num, ta_acct_ref_num = a2.acct_ref_num, 
		   ta_acct_num = a2.acct_num
	from  sif_interfacesser..ComprasProdPMI a1,  sif_interfacesser..TempPMI a2
	where a1.trade_num = a2.trade_num
	  and a1.order_num = a2.order_num
	  and a1.item_num = a2.item_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table  sif_interfacesser..TempPMI
</cfquery> 

<cfquery datasource="sifinterfaces">
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add tt_order_type_code char null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add tt_acct_ref_num char null
	ALTER TABLE  sif_interfacesser..ComprasProdPMI add tt_acct_num int null
</cfquery>
<cfquery datasource="preicts">
	insert #LvarDsource#ComprasProdPMI (fecharegistro, sessionid, tipoconsulta, trade_num, order_num,
		item_num, acct_ref_num, acct_num, booking_comp_num, cmdty_code, contr_date,title_tran_date)
	select oo.order_type_code, a2.acct_ref_num, a2.acct_num,a2.trade_num, a2.order_num, a2.item_num
	 into  sif_interfacesser..TempPMI
	 from  sif_interfacesser..ComprasProdPMI ate, allocation_item a1
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
		 where a1.trade_num= ate.ta_trade_num
		 order by oo.order_type_code
</cfquery>
<cfquery datasource="sifinterfaces">
	UPDATE  sif_interfacesser..ComprasProdPMI SET tt_order_type_code = a2.order_type_code,
	 	   tt_acct_ref_num = a2.acct_ref_num, tt_acct_num = a2.acct_num
	from  sif_interfacesser..ComprasProdPMI a1,  sif_interfacesser..TempPMI a2
	where a1.trade_num = a2.trade_num
	  and a1.order_num = a2.order_num
	  and a1.item_num = a2.item_num
</cfquery>

<cfquery name="queryCompras" datasource="sifinterfaces">
	select *
	from  sif_interfacesser..ComprasProdPMI
</cfquery>

<cfquery datasource="sifinterfaces">
	drop table  sif_interfacesser..ComprasProdPMI
	drop table  sif_interfacesser..TempPMI
</cfquery> 

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
	<cfif queryCompras.SNid EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
	</cfif>

	<!--- Existencia del Articulo  --->
	<cfif queryCompras.Aid EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
	</cfif>

	<!--- Moneda es Valida  --->
	<cfif queryCompras.Mcodigo EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
	</cfif> 

	<!--- Unidad es Valida  --->
	<cfif Len(queryCompras.Ucodigo) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	</cfif>

	<cfset LvarConceptoCompra = "00">

	<!--- Costos no definidos  --->
	<cfif queryCompras.trade_num EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existen costos definidos">
	</cfif>

	<!--- decodifica campo alloc_type_code  --->	
	<cfif queryCompras.alloc_type_code EQ "W">
		<cfset LvarOCTtipo = "B">
	<cfelseif queryCompras.alloc_type_code EQ "R">
		<cfset LvarOCTtipo = "F">
	<cfelse>
		<cfset LvarOCTtipo = "T">
	</cfif>

	<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
	<cfset LvarOCtipoIC = "C">
	<cfset LvarAlmacen = "">
	<cfset LvarTransporte = "#queryCompras.c_orden#">
	<cfset LvarSocioAlloc = 0>
	
	<cfif queryCompras.ta_order_type_code EQ 'PHYSICAL'>
		<cfset LvarOCtipoIC = "C">
		<cfset LvarSocioAlloc = rsTipoAlloc.acct_num>
	</cfif>
	<cfif queryCompras.ta_order_type_code EQ 'STORAGE'>
		<cfset LvarOCtipoIC = "I">
		<cfset LvarAlmacen = rsTipoAlloc.acct_ref_num>
		<cfset LvarSocioAlloc = rsTipoAlloc.acct_num>
	</cfif>
	<cfif queryCompras.ta_order_type_code EQ 'TRANSPRT'>
		<cfset LvarTransporte = queryCompras.ta_acct_ref_num>
		<cfif queryCompras.tt_order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = queryCompras.tt_acct_num>
		</cfif>
	
		<cfif queryCompras.tt_order_type_code EQ 'STORAGE'>
			<cfset LvarOCtipoIC = "I">
			<cfset LvarAlmacen = queryCompras.tt_cct_ref_num>
			<cfset LvarSocioAlloc = queryCompras.tt_acct_num>
		</cfif>
	</cfif>

	<!--- Conversión a unidades del Artículo --->
	<cfif Rtrim(queryCompras.UcodigoArt) NEQ "#Rtrim(queryCompras.c_unidad)#">
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select Ucodigo, CUAfactor
			from ConversionUnidadesArt
			where Ecodigo  = #session.ecodigo#
			  and Aid = #queryCompras.Aid#
			  and Ucodigo = '#Rtrim(queryCompras.c_unidad)#'
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existe el Factor de conversión">
		</cfif>
	</cfif> 
	
	<cfif ISNUMERIC(queryCompras.bl_ticket_num)>
		<cfset Lvarbl_ticket_num=queryCompras.bl_ticket_num>
	<cfelse>
		<cfset Lvarbl_ticket_num=0>
	</cfif>
	
	<cfif ISDATE(queryCompras.bl_date)>
		<cfset Lvarbl_date=queryCompras.bl_date>
	<cfelse>
		<cfset Lvarbl_date=querycompras.dt_fecha_recibo>
	</cfif>
	
	<cfif ISDATE(queryCompras.title_tran_date)>
		<cfset LvarTitle_tran_date=queryCompras.title_tran_date>
	<cfelse>
		<cfset LvarTitle_tran_date=querycompras.dt_fecha_recibo>
	</cfif>

	<cfif len(LvarTipoError) GT 0>
		<!--- Graba error en tabla temporal ErroresPMI  --->
		<cfquery datasource="preicts">
			insert sif_interfacesser..ErroresPMI (Ecodigo,FechaProceso,FechaDocumento,TipoDocumento,
				UsuarioProceso,MensajeError,Documento,Modulo,Monto,Trade_Num,Order_Num,Item_Num)
			values (#session.Ecodigo#, '#queryCompras.voucher_creation_date#', '#queryCompras.dt_fecha_recibo#',
			        'Voucher-Folio', #session.Usucodigo#, '#LvarTipoError#', '#toString(queryCompras.voucher_num)#',
					'CXP', #queryCompras.f_monto_Enca#, #queryCompras.Trade_Num#, #queryCompras.Order_Num#,
					#queryCompras.Item_Num#)
		</cfquery> 
	<cfelse>	
		<!--- se inserta el registro en tabla temporal ProductoPMI   --->
		<cfquery datasource="preicts">
			insert sif_interfacesser..ProductosPMI (documento,orden,socionegocio,Nsocio,
				producto,fechavoucher,vouchernum,trade_num,order_num,item_num,importe,modulo,
				tipotransaccion,iva,moneda,Ecodigo)
			values ('#queryCompras.c_docto_proveedor#', '#queryCompras.c_orden#', #queryCompras.acct_num#,
			        #queryCompras.SNid#, '#queryCompras.c_producto#', '#queryCompras.voucher_creation_date#',
					#queryCompras.voucher_num#, #queryCompras.Trade_Num#, #queryCompras.Order_Num#,
					#queryCompras.Item_Num#, #queryCompras.f_importe#, 'CXP', '#queryCompras.c_tipo_folio#',
					#queryCompras.f_iva#, '#queryCompras.c_moneda#', #session.Ecodigo#)
		</cfquery> 
	</cfif> 
</cfloop>