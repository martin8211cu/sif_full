<!--- Archivo    :  otrosIngresosA-sql.cfm
	  --->

<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">

<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

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

<cftry>
	<cfquery datasource="preicts">
		drop table #LvarDsource#TempPMI
	</cfquery> 
<cfcatch type="any">
</cfcatch>
</cftry>

<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#otrosIngresosPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ErroresPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ProductosPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_IE10 where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_ID10 where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfacesser..otrosIngresosPMI (fecharegistro date null,sessionid numeric null,
		invoice varchar(15) null, voucher_num int null, acct_num int null, voucher_tot_amt float null,
		voucher_curr_code char(8) null, voucher_creation_date date null, voucher_book_curr_code char(8) null,
		invoiceDate date null, dueDate date null, invoiceType char(1) null, yourRefNum varchar(25) null,
		c_moneda char(8) null, c_unidades char(8) null, f_iva float null, CodigoImpuesto char(5) null,
		trade_num integer null, order_num smallint null, item_num smallint null, cuafactor float null,
		acct_ref_num char(10) null, booking_comp_num int null, cmdty_code varchar(10) null, volumen float null,
		order_type_code varchar(8) null, subconceptoTax integer null, CodigoConcepto char(5) null,
		contr_date date null, title_tran_date date null, alloc_type_code char(1) null, del_term_code char(8) null,
		bl_ticket_num varchar(15) null, bl_date date null, transportation varchar(40) null, load_compl_date date null,
		nor_date date null, creation_date date null, fecha_allocation date null, real_port_num int null,
		contr_qty_uom_code char(4) null, contr_qty float null, price_curr_code varchar(8) null, p_s_ind char(1) null, 
		SNid numeric null, Aid numeric null, UcodigoArt char(5) null, Mcodigo numeric null, Ucodigo char(5) null,
		subconcepto integer null, cost_code varchar(8) null, cost_type_code varchar(8) null,
		ta_order_type_code varchar(8) null, ta_trade_num int null, ta_acct_ref_num char(10) null, 
		ta_acct_num int null, tt_order_type_code char(8) null, tt_acct_ref_num char(10) null,
		tt_acct_num int null, montocosto float null, PosNeg char(1) null, avg_price float null)
--->

<!--- Crea query de otros ingresos  --->
<cfquery name="rsIngresos" datasource="preicts">
	insert #LvarDsource#otrosIngresosPMI (fecharegistro, sessionid,
		   invoice, voucher_num, acct_num, voucher_tot_amt, voucher_curr_code,
		   voucher_creation_date, voucher_book_curr_code, 
		   invoiceDate, dueDate, invoiceType, yourRefNum, f_iva)
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
		   ab.invoice, aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
		   aa.voucher_creation_date, aa.voucher_book_curr_code,
		   ab.invoiceDate, ab.dueDate, ab.invoiceType, ab.yourRefNum, 
		   (select abs(sum(a1.f_importe)) from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num and 
			a1.c_concepto = 'IVA') as f_iva
	from voucher aa
		inner join PmiInvoice ab
		on ab.voucherNum = aa.voucher_num
		and upper(ab.invoiceType) in ( 'V', 'U', 'S')
		and upper(ab.printedInd) in ('L','T','Y')
		and ab.bookingCo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.DescripcionICTS#">
		and ab.invoiceDate between
			<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
			and
			<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaF)#">
	where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
	and not EXISTS(select ac.ID from sif_interfaces..IE10 ac where ac.VoucherNo = CONVERT(varchar,aa.voucher_num) 
							and EcodigoSDC=14)
	order by aa.acct_num, ab.invoiceType, ab.invoice
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">

<!--- procesa los registros de otros ingresos  --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">

<!--- Consulta la información de costos tabla cost   --->
<cfquery datasource="preicts">
	select distinct co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num,
	       co.cost_owner_key8 as item_num, 
	       co.cost_type_code, co.cost_code, vo.voucher_num into #LvarDsource#TempPMI
    from cost co
		inner join voucher vo
			inner join voucher_cost vco
			on vco.voucher_num = vo.voucher_num
		on vo.voucher_num in (select voucher_num from #LvarDsource#otrosIngresosPMI)
	where co.cost_num = vco.cost_num
	  and co.cost_status IN ('PAID','VOUCHED')
	  and co.cost_code <> 'IVA'
	order by cost_amt desc
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#otrosIngresosPMI SET trade_num = a2.trade_num, order_num = a2.order_num,
	       item_num = a2.item_num, cost_type_code = a2.cost_type_code,
		   cost_code = a2.cost_code
	from #LvarDsource#otrosIngresosPMI a1, #LvarDsource#TempPMI a2
	where a1.voucher_num = a2.voucher_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#otrosIngresosPMI SET SNid = a2.SNid
	from #LvarDsource#otrosIngresosPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
</cfquery> 

<!--- Consulta información del Trade, trade_order, trade_item   --->
<cfquery datasource="preicts">
	select ai.title_tran_date, ai.trade_num, ai.order_num, ai.item_num, a7.order_type_code,
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, a6.acct_ref_num, ti.cmdty_code,
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, a6.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num into #LvarDsource#TempPMI
	from #LvarDsource#otrosIngresosPMI ate, trade_item ti
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
	UPDATE #LvarDsource#otrosIngresosPMI SET title_tran_date = a2.title_tran_date,
	 	   alloc_type_code = a2.alloc_type_code, del_term_code = a2.del_term_code, 
		   bl_ticket_num = a2.bl_ticket_num, bl_date = a2.bl_date, transportation = a2.transportation,
		   load_compl_date = a2.load_compl_date, creation_date = a2.creation_date,
		   fecha_allocation = a2.fecha_allocation, real_port_num = a2.real_port_num,
		   acct_ref_num = a2.acct_ref_num, order_type_code = a2.order_type_code,
		   cmdty_code = a2.cmdty_code
	from #LvarDsource#otrosIngresosPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num
	  and a1.order_num = a2.order_num
	  and a1.item_num = a2.item_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#otrosIngresosPMI SET Aid = a2.Aid, UcodigoArt = a2.Ucodigo
	from  #LvarDsource#otrosIngresosPMI a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodalterno  = a1.cmdty_code
</cfquery>

<!--- Busca factor de conversión del Artículo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#otrosIngresosPMI SET cuafactor = a2.CUAfactor
	from #LvarDsource#otrosIngresosPMI a1, ConversionUnidadesArt a2
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Aid  = case
						when a1.Aid is null then 0
						else a1.Aid
					end
	  and a2.Ucodigo = a1.contr_qty_uom_code
	  and rtrim(a1.UcodigoArt) <> rtrim(contr_qty_uom_code)
</cfquery>

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#otrosIngresosPMI SET subconceptoTax = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#otrosIngresosPMI a1
	WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="TAX">
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
</cfquery>

<!--- código de impuesto  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#otrosIngresosPMI SET CodigoImpuesto = a2.cuentac
	from #LvarDsource#otrosIngresosPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconceptoTax)
</cfquery>

<!--- consulta la información de iva, monto, moneda, unidades de tabla cost  --->
<cfquery datasource="preicts">
	select sum(case when co.cost_pay_rec_ind = 'R' and co.cost_code <> 'IVA' then  co.cost_qty else 0
			   end) as SumaVol_R,
		   sum(case when co.cost_pay_rec_ind = 'P' and co.cost_code <> 'IVA' then  co.cost_qty else 0
			   end) as SumaVol_P,
		   sum(case when co.cost_pay_rec_ind = 'R' and co.cost_code <> 'IVA' then  co.cost_amt else 0
			   end) as SumaImp_R,
		   sum(case when co.cost_pay_rec_ind = 'P' and co.cost_code <> 'IVA' then  co.cost_amt else 0
			   end) as SumaImp_P,
		   sum(case when co.cost_pay_rec_ind = 'R' and co.cost_code = 'IVA' then  co.cost_amt else 0
			   end) as SumaIva_R,
		   sum(case when co.cost_pay_rec_ind = 'P' and co.cost_code = 'IVA' then  co.cost_amt else 0
			   end) as SumaIva_P, cost_qty_uom_code, cost_price_curr_code, vo.voucher_num
	into #LvarDsource#TempPMI
	from voucher vo
		inner join voucher_cost vco
			inner join cost co
			on co.cost_num=vco.cost_num
			and co.cost_status IN ('PAID','VOUCHED')
		on vco.voucher_num = vo.voucher_num
	where vo.voucher_num in (select voucher_num from #LvarDsource#otrosIngresosPMI)
	group by cost_qty_uom_code, cost_price_curr_code, vo.voucher_num
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#otrosIngresosPMI SET c_unidades = a2.cost_qty_uom_code,
	 	   c_moneda = a2.cost_price_curr_code, f_iva = abs(a2.SumaIva_R - a2.SumaIva_P), 
		   montocosto = abs(a2.SumaImp_R - a2.SumaImp_P),
		   volumen = abs(a2.SumaVol_R - a2.SumaVol_P)
	from #LvarDsource#otrosIngresosPMI a1, #LvarDsource#TempPMI a2
	where a1.voucher_num = a2.voucher_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#otrosIngresosPMI SET Ucodigo = a2.Ucodigo
	from #LvarDsource#otrosIngresosPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.c_unidades
</cfquery>

<cfset LvarConceptoCompra = "00">

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#otrosIngresosPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#otrosIngresosPMI a1
	WHERE s.costo_id = a1.cost_code
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
</cfquery>

<!--- código de impuesto  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#otrosIngresosPMI SET CodigoConcepto = a2.cuentac
	from #LvarDsource#otrosIngresosPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
</cfquery>

<cfquery name="queryVentas" datasource="sifinterfaces">
	select *
	from  #LvarDsource#otrosIngresosPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfset ConseIE10 = 0>
<cfloop query="queryVentas"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<cfif len(queryVentas.trade_num) GT 0 and len(queryVentas.order_num) GT 0 
	      and len(queryVentas.item_num) GT 0>
		<cfset LvarTipoFactura = "trade">
	<cfelse>
		<cfset LvarTipoFactura = "fact">
	</cfif>

	<!---  Procesa los detalles de la Factura    --->
	<cfset cC_Tipo_Invoice = queryVentas.invoiceType>
	<cfif "V,U,S" CONTAINS cC_tipo_Invoice>
		<cfset cC_Tipo_Invoice = "FC">
	<cfelse>
		<cfif cC_tipo_Invoice EQ "c">
			<cfset cC_Tipo_Invoice = "NC">
		<cfelse>
			<cfset cC_Tipo_Invoice = "ND">
		</cfif>
	</cfif>

	<cfif len(queryventas.f_iva) GT 0>
		<cfset ws_MontoCosto = queryVentas.montocosto + queryVentas.f_iva>
		<cfset ws_f_iva = queryVentas.f_iva>
	<cfelse>
		<cfset ws_MontoCosto = queryVentas.montocosto>
		<cfset ws_f_iva = 0>
	</cfif>	

	<cfif len(queryVentas.volumen) GT 0>
		<cfset ws_f_volumen = queryVentas.volumen>
	<cfelse>
		<cfset ws_f_volumen = 0>
	</cfif>

	<cfset ws_f_Importe = queryVentas.voucher_tot_amt>
	<cfif ws_f_volumen NEQ 0>
		<cfset ws_f_precio = ws_f_Importe / ws_f_volumen>
	<cfelse>
		<cfset ws_f_precio = 0>
	</cfif>
	<cfset ws_c_unidad = queryVentas.c_unidades>

	<!--- valida que el monto del voucher sea igual a la suma de los costos  --->	
	<cfset vDiff = ws_f_Importe - ws_MontoCosto>
	
	<cfif abs(vDiff) GT 10>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = "Diferencia Montos Voucher/Costos">
	</cfif>

	<cfif LvarTipoFactura EQ 'trade' and queryVentas.order_type_code EQ 'PHYSICAL'>
		<!--- Existencia del Articulo  --->
		<cfif Len(queryVentas.Aid) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfset LvarAid = 0>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
		<cfelse>
			<cfset LvarAid = #queryVentas.Aid#>
		</cfif>
	</cfif>	

	<cfif LvarTipoFactura EQ 'trade'>
		<!--- Conversión a unidades del Artículo --->
		<cfif "#Rtrim(queryVentas.UcodigoArt)#" NEQ "#Rtrim(queryVentas.c_unidades)#">
			<cfif len(queryVentas.cuafactor) GT 0>
				<cfset ws_f_volumen = queryVentas.cuafactor * ws_f_volumen>
				<cfif ws_f_volumen EQ 0>
					<cfset ws_f_volumen = 1>
				</cfif>
				<cfset ws_f_precio = ws_f_Importe/ws_f_volumen>
				<cfset ws_c_unidad = queryVentas.UcodigoArt>
			</cfif>
		</cfif>
	</cfif>	

	<!--- Moneda es Valida  --->
	<cfset ws_curr_code = mid(queryVentas.voucher_curr_code,1,3)>
	<cfif ws_curr_code EQ 'MXN'>
		<cfset ws_curr_code = "MXP">
	</cfif>
		
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Mcodigo
		from Monedas a
		where a.Ecodigo  = #session.ecodigo#
		  and a.Miso4217 = '#ws_curr_code#'
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
	<cfif Len(queryVentas.Ucodigo) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	</cfif>

	<cfset LvarProducto = "">

	<cfset LvarConceptoCompra = "00">

	<!--- Conversión a unidades del Artículo --->
	<cfif len(#Rtrim(ws_c_unidad)#) GT 0 and len(queryVentas.Aid) GT 0>
		<cfif "#Rtrim(queryVentas.UcodigoArt)#" NEQ "#Rtrim(ws_c_unidad)#">
			<cfquery name="rsVerifica" datasource="#session.dsn#">
				select Ucodigo, CUAfactor
				from ConversionUnidadesArt
				where Ecodigo  = #session.ecodigo#
				  and Aid = #queryVentas.Aid#
				  and Ucodigo = '#ws_c_unidad#'
			</cfquery>
			<cfif rsVerifica.recordcount GT 0>
				<cfset ws_f_volumen = rsVerifica.CUAfactor * ws_f_volumen>
				<cfif ws_f_volumen EQ 0>
					<cfset ws_f_volumen = 1>
				</cfif>
				<cfset ws_f_precio = ws_f_Importe/ws_f_volumen>
				<cfset ws_c_unidad = queryVentas.UcodigoArt>
			</cfif>
		</cfif>
	</cfif>
	
	<cfif ISNUMERIC(queryVentas.bl_ticket_num)>
		<cfset Lvarbl_ticket_num=queryVentas.bl_ticket_num>
	<cfelse>
		<cfset Lvarbl_ticket_num=0>
	</cfif>
	
	<cfif ISDATE(queryVentas.bl_date)>
		<cfset Lvarbl_date=queryVentas.bl_date>
	<cfelse>
		<cfset Lvarbl_date=now()>
	</cfif>
	
	<cfif ISDATE(queryVentas.title_tran_date)>
		<cfset LvarTitle_tran_date=queryVentas.title_tran_date>
	<cfelse>
		<cfset LvarTitle_tran_date=queryVentas.invoiceDate>
	</cfif>

	<cfset cContr_Date = LvarTitle_tran_date>
	<cfset cAcct_Ref_Num = queryVentas.acct_ref_num>
	<cfset cSocio = queryVentas.acct_num>
	<cfif len(queryVentas.trade_num) GT 0>
		<cfset cTrade_Num = queryVentas.trade_num>
	<cfelse>
		<cfset cTrade_Num = 0>
	</cfif>		
	<cfif len(queryVentas.order_num) GT 0>
		<cfset cOrder_Num = queryVentas.order_num>
	<cfelse>
		<cfset cOrder_Num = 0>
	</cfif>		
	<cfif len(queryVentas.item_num) GT 0>
		<cfset cItem_Num = queryVentas.item_num>
	<cfelse>
		<cfset cItem_Num = 0>
	</cfif>
	<cfif len(queryVentas.cmdty_code) GT 0>
		<cfset cProducto = queryVentas.cmdty_code>
	<cfelse>
		<cfset cProducto = "">
	</cfif>
	<cfset cSNid = queryVentas.SNid>
	<cfset cMoneda = queryVentas.price_curr_code>

	<cfset ws_tipo_modulo = "CC">
	<cfset ws_tipo_transaccion = "FC">
	<cfset ws_folio = "#queryVentas.invoice#">

	<cfif LvarTipoFactura EQ 'trade' and queryVentas.order_type_code EQ 'PHYSICAL'>
		<cfset ws_TipoItem = 'O'>
		<cfset ws_CodigoItem = queryVentas.cmdty_code>
	<cfelse>
		<cfset ws_TipoItem = 'S'>
		<cfset ws_CodigoItem = queryVentas.CodigoConcepto>
	</cfif>

	<cfset ConseIE10 = ConseIE10 + 1>
	<cfif len(LvarTipoError) GT 0>
		<!--- Graba error en tabla pmiIE10  --->
		<cfquery datasource="sifinterfaces">
			insert into PMIINT_IE10 (FechaRegistro,sessionid,
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
				#ConseIE10#, 14, '#queryVentas.acct_num#', '#ws_tipo_modulo#',
				'#ws_tipo_transaccion#', '#ws_folio#', ' ',
				'#queryVentas.c_moneda#', 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.dueDate#">,
				'S', '#ws_tipo_modulo#', '#queryVentas.voucher_num#', null, 
				null, null, null,
				0, null, null, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">, 
				1, '#LvarTipoError#')
		</cfquery>

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
				OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
			values(getdate(), #session.monitoreo.sessionid#,
				#ConseIE10#, 1, '#ws_TipoItem#', '#ws_CodigoItem#',
				'#queryVentas.transportation#',
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.load_compl_date#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.nor_date#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">, 
				'#ws_c_unidad#',
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
				'#queryVentas.del_term_code#', '#Lvarbl_ticket_num#',
				<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				null, '#queryVentas.acct_ref_num#', null, 0.00,
				0.00, null, null,
				#numberformat(ws_f_importe,"9.99")#,
				null, null,
				null, null, null, null
				)
		</cfquery>
	<cfelse>	
		<!--- se inserta el registro en tabla pmiIE10   --->
		<cfquery datasource="sifinterfaces">
			insert into PMIINT_IE10 (FechaRegistro,sessionid,
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
				#ConseIE10#, 14, '#queryVentas.acct_num#', '#ws_tipo_modulo#',
				'#ws_tipo_transaccion#', '#ws_folio#', ' ',
				'#queryVentas.c_moneda#', 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.dueDate#">,
				'S', '#ws_tipo_modulo#', '#queryVentas.voucher_num#', null, 
				null, null, null,
				0, null, null, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">, 
				1, null)
		</cfquery>

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
				OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
			values(getdate(), #session.monitoreo.sessionid#,
				#ConseIE10#, 1, '#ws_TipoItem#', '#ws_CodigoItem#',
				'#queryVentas.transportation#',
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.load_compl_date#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.nor_date#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">, 
				'#ws_c_unidad#',
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
				'#queryVentas.del_term_code#', '#Lvarbl_ticket_num#',
				<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				null, '#queryVentas.acct_ref_num#', null, 0.00,
				0.00, null, null,
				#numberformat(ws_f_importe,"9.99")#,
				null, null,
				null, null, null, null
				)
		</cfquery>
	</cfif> 
</cfloop>
