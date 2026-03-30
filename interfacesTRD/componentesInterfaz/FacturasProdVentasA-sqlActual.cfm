<!--- Archivo    :  FacturasProdVentasA-sql.cfm
	  --->

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
<cfset LvarDsource = "sif_interfaces..">
<cfset session.Dsource = LvarDsource>

<cftry>
	<cfquery datasource="preicts">
		drop table #LvarDsource#TempPMI
	</cfquery> 
<cfcatch type="any">
</cfcatch>
</cftry>

<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#facturasProdVentPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ErroresPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ProductosPMI where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfacesser..ErroresPMI (fecharegistro date null,sessionid numeric null,Ecodigo int null,
		FechaProceso date null,FechaDocumento date null, TipoDocumento char(20) null, UsuarioProceso int null,
		MensajeError varchar(200),Documento char(20) null, Modulo char(3) null, Monto float null, Trade_Num int null,
		Order_Num smallint null, Item_Num smallint null)
create table sif_interfacesser..ProductosPMI (fecharegistro date null,sessionid numeric null,documento char(20) null,
		orden char(10) null, socionegocio int null,Nsocio numeric null, producto varchar(20) null,
		fechavoucher date null, vouchernum numeric null,trade_num int null, order_num smallint null,
		item_num smallint null, importe float null, modulo char(3) null,tipotransaccion char(2) null,
		iva float null, moneda char(5) null, Ecodigo int null)
create table sif_interfacesser..facturasProdVentPMI (fecharegistro date null,sessionid numeric null,
		voucher_num integer null, acct_num int null, voucher_tot_amt float null, voucher_curr_code char(8) null,
		voucher_creation_date date null, 
		invoice varchar(15) null, invoiceDate date null, dueDate date null, invoiceType char(1) null,
		yourRefNum varchar(25) null, c_moneda char(8) null, c_unidades char(8) null, f_iva float null, 
		trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, booking_comp_num int null, cmdty_code varchar(10),
		contr_date date null, title_tran_date date null, alloc_type_code char(1) null, del_term_code char(8) null,
		bl_ticket_num varchar(15) null, bl_date date null, transportation varchar(40) null, load_compl_date date null,
		nor_date date null, creation_date date null, fecha_allocation date null, real_port_num int null,
		contr_qty_uom_code char(4) null, contr_qty float null, price_curr_code varchar(8) null, p_s_ind char(1) null, 
		SNid numeric null, Aid numeric null, UcodigoArt char(5) null, Mcodigo numeric null, Ucodigo char(5) null,
		subconcepto integer null, cost_code varchar(8) null, cost_type_code varchar(8) null,
		ta_order_type_code varchar(8) null, ta_trade_num int null, ta_order_num smallint null,
		ta_item_num smallint null, ta_creation_date date null, ta_acct_ref_num char(10) null, 
		ta_acct_num int null, tt_order_type_code char(8) null, tt_acct_ref_num char(10) null,
		tt_acct_num int null, montocosto float null, PosNeg char(1) null, cuafactor float null, tipoventa char(10) null,
		SNCDid_3 char(1) null, SNCDid_4 char(1) null, SNCDid_5 char(1) null, SNCDid_6 char(1) null,
		SNCDid_A char(1) null, AllocSNid numeric null, avg_price float null)
--->

<!--- Crea query de ventas  --->
<cfquery datasource="preicts">
	insert #LvarDsource#facturasProdVentPMI (fecharegistro, sessionid,
		voucher_num, acct_num, voucher_tot_amt, voucher_curr_code, voucher_creation_date,
		invoice, invoiceDate, dueDate, invoiceType, yourRefNum
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
		   aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code, aa.voucher_creation_date,
		   ab.invoice, ab.invoiceDate, ab.dueDate, ab.invoiceType, ab.yourRefNum,
	from voucher aa
		inner join PmiInvoice ab
		on ab.voucherNum = aa.voucher_num
		and (ab.invoiceType = 'G' or ab.invoiceType = 'K' or ab.invoiceType = 'p' or ab.invoiceType = 'R' or
			 ab.invoiceType = 'W' or ab.invoiceType = 'c' or ab.invoiceType = 'd' or ab.invoiceType = 'w' or ab.invoiceType = 'P')
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

<cfset LvarBanderaErrores = false>
<cf_htmlreportsheaders
	title="Importacion de Ventas de ICTS" 
	filename="ImportaVentas-#Session.Usucodigo#.xls" 
	ira="FacturasProdVentasParam.cfm">

<cf_templatecss>

<cfoutput>
<table width="100%" border="1">
	<tr><td colspan="9" align="center"><strong>Reporte de Errores</strong></td>
	<tr><td colspan="9" align="center"><strong>Proceso de Carga de Venta de Producto</strong></td>
	<tr><td colspan="9" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="9">&nbsp;</td></tr>
	<tr><td colspan="9">Registros: #queryVentas.recordcount# </td></tr>
	<tr><td colspan="9">&nbsp;</td></tr>
	<tr>
		<td><strong>Fecha</strong></td>
		<td><strong>Voucher</strong></td>
		<td><strong>Fecha Fact</strong></td>
		<td><strong>Factura</strong></td>
		<td><strong>Producto</strong></td>
		<td><strong>Error</strong></td>
		<td align="right"><strong>Volumen</strong></td>
		<td align="right"><strong>Importe</strong></td>
		<td align="right"><strong>T.Voucher</strong></td>
	</tr>
	<tr><td colspan="9">&nbsp;</td></tr>
	<cfflush interval="40">
</cfoutput>

<!--- consulta la información de iva, monto, moneda, unidades de tabla cost  --->
<cfquery datasource="#session.dsn#">
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
	where vo.voucher_num in (select voucher_num from #LvarDsource#facturasProdPMI)
	group by cost_qty_uom_code, cost_price_curr_code, vo.voucher_num
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdPMI SET c_unidades = a2.cost_qty_uom_code,
	 	   c_moneda = a2.cost_price_curr_code, f_iva = abs(a2.SumaIva_R - a2.SumaIva_P), 
		   montocosto = abs(a2.SumaImp_R - a2.SumaImp_P)
	from #LvarDsource#facturasProdPMI a1, #LvarDsource#TempPMI a2
	where a1.voucher_num = a2.voucher_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- Consulta la información de costos tabla cost   --->
<cfquery datasource="preicts">
	select distinct co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num,
	       co.cost_owner_key8 as item_num, 
	       co.cost_code, co.cost_type_code, vo.voucher_num into #LvarDsource#TempPMI
    from cost co
		inner join voucher vo
			inner join voucher_cost vco
			on vco.voucher_num = vo.voucher_num
		on vo.voucher_num in (select voucher_num from #LvarDsource#facturasProdPMI)
	where co.cost_num = vco.cost_num
	  and co.cost_status IN ('PAID','VOUCHED')
	  and co.cost_owner_key6 > 0 
	  and co.cost_owner_key7 > 0 
	  and co.cost_owner_key8 > 0 
	order by cost_amt desc
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdPMI SET trade_num = a2.trade_num, order_num = a2.order_num,
	       item_num = a2.item_num, cost_type_code = a2.cost_type_code, cmdty_code = a2.cost_code
	from #LvarDsource#facturasProdPMI a1, #LvarDsource#TempPMI a2
	where a1.voucher_num = a2.voucher_num
</cfquery>

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET SNid = a2.SNid
	from #LvarDsource#facturasProdVentPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
</cfquery>

<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET Mcodigo = a2.Mcodigo
	from #LvarDsource#facturasProdVentPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = a1.c_moneda
</cfquery>
<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET Ucodigo = a2.Ucodigo
	from #LvarDsource#facturasProdVentPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.c_unidades
</cfquery>

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET Aid = a2.Aid, UcodigoArt = a2.Ucodigo
	from #LvarDsource#facturasProdVentPMI a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodalterno  = a1.cmdty_code
</cfquery>

<!--- Busca factor de conversión del Artículo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET cuafactor = a2.CUAfactor
	from #LvarDsource#facturasProdVentPMI a1, ConversionUnidadesArt a2
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Aid  = case 
						when a1.Aid is null then 0
						else a1.Aid
					end
	  and a2.Ucodigo = a1.contr_qty_uom_code
	  and rtrim(a1.UcodigoArt) <> rtrim(a1.cmdty_code)
</cfquery>

<cfset LvarConceptoCompra = "00">

<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
<cfset LvarOCtipoIC = "C">
<cfset LvarAlmacen = "">
<cfset LvarSocioAlloc = 0>
<cfset LvarOrdenAlloc = "">

<!--- allocation de venta --->
<cfquery datasource="preicts">
	select distinct oo.order_type_code, a2.trade_num, a2.order_num, a2.item_num, tr.creation_date, a2.acct_ref_num,
	    a2.acct_num, a1.trade_num as trade_num_CP, a1.order_num as order_num_CP, a1.item_num as item_num_CP
			into #LvarDsource#TempPMI
	from allocation_item a1
		inner join allocation_item a2
			inner join trade tr
			on tr.trade_num = a2.trade_num
		on a1.alloc_num = a2.alloc_num
	    and a1.trade_num <> a2.trade_num
		inner join trade_item ti
		on ti.trade_num = a2.trade_num
		and ti.order_num = a2.order_num
		and ti.item_num = a2.item_num
		and ti.p_s_ind = 'P'
		inner join allocation_item_transport a3
			on a3.alloc_num = a2.alloc_num
		   and a3.alloc_item_num = a2.alloc_item_num
		inner join trade_order oo
			on oo.trade_num = a2.trade_num
		   and oo.order_num = a2.order_num
			where a1.trade_num in (select trade_num from #LvarDsource#nofactProdPMI where p_s_ind='S')
			and a1.order_num in (select order_num from #LvarDsource#nofactProdPMI oo where oo.trade_num=a1.trade_num
								 and p_s_ind='S')	
			and a1.item_num in (select item_num from #LvarDsource#nofactProdPMI ti where ti.trade_num=a1.trade_num
								and ti.order_num=a1.order_num and p_s_ind='S')	
	order by oo.order_type_code, a2.acct_ref_num
</cfquery>
<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#nofactProdPMI SET ta_order_type_code = a2.order_type_code,
	 	   ta_trade_num = a2.trade_num, ta_order_num = a2.order_num, ta_item_num = a2.item_num,
		   ta_creation_date = a2.creation_date, ta_acct_ref_num = a2.acct_ref_num, ta_acct_num = a2.acct_num
	from #LvarDsource#nofactProdPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num_CP
	  and a1.order_num = a2.order_num_CP
	  and a1.item_num = a2.item_num_CP
	  and a1.p_s_ind = 'S'
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table  #LvarDsource#TempPMI
</cfquery> 

<cfquery datasource="preicts">
	select oo.order_type_code, a2.acct_ref_num, a2.acct_num,a2.trade_num, a2.order_num, a2.item_num,
			(select max (ate.trade_num) from #LvarDsource#nofactProdPMI ate
			 where ate.ta_trade_num = a1.trade_num) as trade_num_CP
		 into #LvarDsource#TempPMI
	from allocation_item a1
		inner join allocation_item a2
			on a2.alloc_num = a1.alloc_num
			 and a1.trade_num <> a2.trade_num
		inner join trade_item ti
			on ti.trade_num = a2.trade_num
			 and ti.order_num = a2.order_num
			 and ti.item_num = a2.item_num
			 and ti.p_s_ind = 'P'
		inner join trade_order oo
			on oo.trade_num = a2.trade_num
			and oo.order_num = a2.order_num
	 where a1.trade_num in (select ta_trade_num from #LvarDsource#nofactProdPMI where p_s_ind='S')
	 order by a1.trade_num
</cfquery>
<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#nofactProdPMI SET tt_order_type_code = a2.order_type_code,
	 	   tt_acct_ref_num = a2.acct_ref_num, tt_acct_num = a2.acct_num
	from #LvarDsource#nofactProdPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num_CP
	  and a1.p_s_ind = 'S'
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table  #LvarDsource#TempPMI
</cfquery> 

<!--- tipo de venta   --->
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_3 = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 3
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_4 = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 4
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_5 = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 5
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_6 = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 6
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_A = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
	where a1.SNid = case
						when a1.tt_acct_num > 0 then
						(select SNid from SNegocios where Ecodigo = 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
						and SNcodigoext = convert(varchar,a1.tt_acct_num))
						else
						(select SNid from SNegocios where Ecodigo = 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
						and SNcodigoext = convert(varchar,a1.ta_acct_num))						
					end
	  and a2.SNCDid = 3
</cfquery>

<!--- socio de negocio de la compra --->
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET AllocSNid = a2.SNid
	from #LvarDsource#nofactProdPMI a1, SNegocios a2
	where Convert(int,a2.SNcodigoext) = case
											when a1.tt_acct_num > 0 then a1.tt_acct_num
											else a1.ta_acct_num
									    end
	and a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
</cfquery>

<cfquery name="rsNofact" datasource="sifinterfaces">
	select *
	from  #LvarDsource#nofactProdPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#facturasProdPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#facturasProdPMI a1
	WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="TAX">
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
</cfquery>

<!--- código de impuesto  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdPMI SET CodigoImpuesto = a2.cuentac
	from #LvarDsource#facturasProdPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
</cfquery>

<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- Consulta información del Trade, trade_order, trade_item   --->
<cfquery datasource="preicts">
	select ai.title_tran_date, ai.trade_num, ai.order_num, ai.item_num,
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, 
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, a6.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num into #LvarDsource#TempPMI
	from #LvarDsource#facturasProdPMI ate, trade_item ti
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
	UPDATE #LvarDsource#facturasProdPMI SET title_tran_date = a2.title_tran_date,
	 	   alloc_type_code = a2.alloc_type_code, del_term_code = a2.del_term_code, 
		   bl_ticket_num = a2.bl_ticket_num, bl_date = a2.bl_date, transportation = a2.transportation,
		   load_compl_date = a2.load_compl_date, trade_creation_date = a2.creation_date,
		   fecha_allocation = a2.fecha_allocation, real_port_num = a2.real_port_num
	from #LvarDsource#facturasProdPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num
	  and a1.order_num = a2.order_num
	  and a1.item_num = a2.item_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- procesa los registros de venta  --->
<cfloop query="queryVentas"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!---  Procesa los detalles de la Factura    --->
	<cfset cC_Tipo_Invoice = queryVentas.invoiceType>
	<cfif "F,G,K,p,R,W,w,P" CONTAINS cC_tipo_Invoice>
		<cfset cC_Tipo_Invoice = "FC">
	<cfelse>
		<cfif cC_tipo_Invoice EQ "c">
			<cfset cC_Tipo_Invoice = "NC">
		<cfelse>
			<cfset cC_Tipo_Invoice = "ND">
		</cfif>
	</cfif>

	<!--- valida que el monto del voucher sea igual al monto de la factura  --->	
	<cfset vDiff = queryVentas.voucher_tot_amt - (queryVentas.montocosto - queryVentas.f_iva)>
	
	<cfif abs(vDiff) GT 10>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarTipoError = "Diferencia Montos Voucher/Factura">
	</cfif>

	<!--- Existencia del Socio de Negocio  --->
	<cfif Len(queryVentas.SNid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
	</cfif>

	<!--- Existencia del Articulo  --->
	<cfif len(queryVentas.cdmty_code) GT 0>
		<cfif Len(queryVentas.Aid) EQ 0>
			<cfset LvarAid = 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
		<cfelse>
			<cfset LvarAid = queryVentas.Aid>
		</cfif>
	</cfif>

	<!--- Moneda es Valida  --->
	<cfif Len(queryVentas.Mcodigo) EQ 0>
		<cfset LvarMcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
	<cfelse>
		<cfset LvarMcodigo = queryVentas.Mcodigo>
	</cfif> 

	<!--- Unidad es Valida  --->
	<cfif Len(queryVentas.Ucodigo) EQ 0>
		<cfset LvarUcodigo="0">		
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	<cfelse>
		<cfset LvarUcodigo = queryVentas.Ucodigo>
	</cfif>

	<cfset LvarConceptoCompra = "00">

	<!--- decodifica campo alloc_type_code  --->	
	<cfif queryVentas.alloc_type_code EQ "W">
		<cfset LvarOCTtipo = "B">
	<cfelseif queryVentas.alloc_type_code EQ "R">
		<cfset LvarOCTtipo = "F">
	<cfelse>
		<cfset LvarOCTtipo = "T">
	</cfif>

	<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
	<cfset LvarOCtipoIC = "C">
	<cfset LvarAlmacen = "">
	<cfset LvarTransporte = "#queryVentas.yourRefNum#">
	<cfset LvarSocioAlloc = 0>
	<cfset LvarOrdenAlloc = "">
	<cfset LvarPorcentaje= 100>

	<cfset LvarAlm_trade_num = queryVentas.ta_trade_num>
	<cfset LvarAlm_order_num = queryVentas.ta_order_num>
	<cfset LvarAlm_item_num = queryVentas.ta_item_num>
	<cfset LvarAlm_creation_date = queryVentas.ta_creation_date>
	
	<cfif queryVentas.ta_order_type_code EQ 'PHYSICAL'>
		<cfset LvarOCtipoIC = "C">
		<cfset LvarSocioAlloc = #queryVentas.ta_acct_num#>
	</cfif>
	<cfif queryVentas.ta_order_type_code EQ 'STORAGE'>
		<cfset LvarAlmacen = "#queryVentas.ta_acct_ref_num#">
		<cfset LvarSocioAlloc = queryVentas.ta_acct_num>
	</cfif>
	<cfif queryVentas.ta_order_type_code EQ 'TRANSPRT'>
		<cfset LvarTransporte = queryVentas.ta_acct_ref_num>
		<cfif queryVentas.tt_order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = queryVentas.tt_acct_num>
		</cfif>
	
		<cfif queryVentas.tt_order_type_code EQ 'STORAGE'>
			<cfset LvarAlmacen = queryVentas.tt_cct_ref_num>
			<cfset LvarSocioAlloc = queryVentas.tt_acct_num>
		</cfif>
	</cfif>

	<cfset ws_MontoCosto = queryVentas.montocosto>
	<cfset ws_CantidadVolumen = queryVentas.f_volumen>
	<cfset ws_f_iva = queryVentas.f_iva>

	<cfset ws_f_Importe = queryVentas.voucher_tot_amt>
	<cfset ws_f_vol_nvo = ws_CantidadVolumen>
	<cfif ws_CantidadVolumen NEQ 0>
		<cfset ws_f_precio_nvo = ws_f_Importe / ws_CantidadVolumen>
	<cfelse>
		<cfset ws_f_precio_nvo = 0>
	</cfif>
	<cfset ws_c_unidades = Lvaruom_code>
	<cfset ws_c_moneda = Lvarcurr_code>

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

	<cfif ISNUMERIC(queryVentas.bl_ticket_num)>
		<cfset Lvarbl_ticket_num=queryVentas.bl_ticket_num>
	<cfelse>
		<cfset Lvarbl_ticket_num=0>
	</cfif>
	
	<cfif ISDATE(queryVentas.bl_date)>
		<cfset Lvarbl_date=queryVentas.bl_date>
	<cfelse>
		<cfset Lvarbl_date=queryVentas.dt_fecha_recibo>
	</cfif>
	
	<cfif ISDATE(queryVentas.title_tran_date)>
		<cfset LvarTitle_tran_date=queryVentas.title_tran_date>
	<cfelse>
		<cfset LvarTitle_tran_date=querycompras.dt_fecha_recibo>
	</cfif>

	<cfset ws_f_volumen = abs(ws_f_volumen)>
	<cfset ws_f_importe = abs(ws_f_importe)>











	<cfif Len(LvarAlmacen) GT 0>
		<cfset LvarOCtipoIC = "V">
	</cfif>

	<cfif Len(LvarOrdenAlloc) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existe orden de allocation">
	</cfif>

	<cfset LvarCuentaFinanciera = "">
	
	<!--- Existencia del Socio Alloc de Negocio  --->
	<cfif LvarSocioAlloc GT 0>
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select a1.SNid
			from SNegocios a1
			where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a1.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSocioAlloc#">
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarAllocSNid = 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Socio Alloc. No Definido">
		<cfelse>
			<cfset LvarAllocSNid = rsVerifica.SNid>
		</cfif>
	</cfif>
	
	
	<cfif LvarBanderaErrores_registro EQ false>
		<cfquery name="rsTVenta" datasource="#Session.Dsn#">
			select OCVid, OCVcodigo, OCVdescripcion
			from OCtipoVenta
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCVcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarTipoVenta#">
		</cfquery>
		<cfif rsTventa.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Tipo de Venta No existe-#LvarTipoVenta#">
		</cfif> 
	</cfif>
	
	<!--- Consulta información del Trade, trade_order, trade_item   --->
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
	
	<!--- OCconceptoCompra del iva    --->
	<cfset LvarCodigoImpuesto = "">
	<cfif ws_f_iva GT 0>
		<cfquery name="rsVerifica" datasource="tesoreria">
			select sb.subconcepto_id
			FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="TAX">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarProducto#">
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

	<!--- decodifica campo alloc_type_code  --->	
	<cfif rsTrade.alloc_type_code EQ "W">
		<cfset LvarOCTtipo = "B">
	<cfelseif rsTrade.alloc_type_code EQ "R">
		<cfset LvarOCTtipo = "F">
	<cfelse>
		<cfset LvarOCTtipo = "T">
	</cfif>

	<cfif ISDATE(rsTrade.bl_ticket_num)>
		<cfset Lvarbl_ticket_num=rsTrade.bl_ticket_num>
	<cfelse>
		<cfset Lvarbl_ticket_num=0>
	</cfif>

	<cfif ISDATE(rsTrade.bl_date)>
		<cfset Lvarbl_date=rsTrade.bl_date>
	<cfelse>
		<cfset Lvarbl_date=queryVentas.invoiceDate>
	</cfif>
	
	<!--- Conversión a unidades del Artículo --->
	<cfif Rtrim(LvarUcodigoArt) NEQ "#Rtrim(ws_c_unidades)#">
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select Ucodigo, CUAfactor
			from ConversionUnidadesArt
			where Ecodigo  = #session.ecodigo#
			  and Aid = #LvarAid#
			  and Ucodigo = '#Rtrim(ws_c_unidades)#'
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existe el Factor de conversión:#Rtrim(ws_c_unidades)#">
		<cfelse>
			<cfset ws_f_vol_nvo = rsVerifica.CUAfactor * ws_f_vol_nvo>
			<cfif ws_f_vol_nvo EQ 0>
				<cfset ws_f_vol_nvo = 1>
			</cfif>
			<cfset ws_f_precio_nvo = ws_f_Importe / ws_f_vol_nvo>
			<cfset ws_c_unidades = LvarUcodigoArt>
		</cfif>
	</cfif> 

	<cftransaction>
	<cfset LvarID = 0>
	<cfquery name="rsVerificaIE10" datasource="sifinterfaces">
		select count(1) as Cantidad
		from IE10
		where EcodigoSDC = 14
		  and NumeroSocio = '#queryVentas.acct_num#'
		  and Modulo = 'CC'
		  and CodigoTransacion = '#cC_Tipo_Invoice#'
		  and Documento = '#queryVentas.invoice#'
	</cfquery>
	<cfif rsVerificaIE10.Cantidad GT 0>
		<cfset LvarID = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Ya se Importó el Documento">
	<cfelse>
		<cfif LvarBanderaErrores_registro EQ false>
			<!--- Obtener el siguiente ID para procesar el registro --->
			<cfquery datasource="sifinterfaces">
				update IdProceso
				set Consecutivo = Consecutivo + 1			
			</cfquery>
			<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
				select Consecutivo
				from IdProceso
			</cfquery>
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
					#LvarID#, 14, '#queryVentas.acct_num#', 'CC',
					'#cC_Tipo_Invoice#', '#queryVentas.invoice#', ' ',
					'#queryVentas.voucher_curr_code#', 
					<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.dueDate#">,
					'S', 'CC', '#queryVentas.voucher_num#', null, 
					null, null, null,
					#session.usucodigo#, 0, null, null, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">, 
					1)
			</cfquery>
		</cfif>
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
					#LvarID#, #LvarConsecutivoID10#, 'O', '#LvarProducto#',
					'#rsTrade.transportation#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.load_compl_date#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.nor_date#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio_nvo,"9.99")#">, 
					'#ws_c_unidades#',
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_vol_nvo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_vol_nvo#">, 
					'#rsTrade.del_term_code#', '#Lvarbl_ticket_num#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
					null, '#queryVentas.yourrefnum#', '#LvarCodigoImpuesto#', #ws_f_iva#,
					0.00, '#LvarAlmacen#', null,
					#session.usucodigo#, #numberformat(ws_f_importe,"9.99")#,
					null, '#LvarCuentaFinanciera#',
					'#LvarOCTtipo#', '#LvarTransporte#', '#queryVentas.yourrefnum#', '00'
					)
			</cfquery>>
		</cfif>
	</cfif>
	</cftransaction>

	<cftransaction>
	<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->
	<!---  revisa si existe la Orden en la estructura de órdenes comerciales           --->
	<cfif LvarBanderaErrores_registro EQ false>
		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select OCid
			from OCordenComercial
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#queryVentas.yourrefnum#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>
			<cfset vOCid = 0>
		<cfelse>
			<cfset vOCid = rsVerifica.OCid>
		</cfif>

		<cfif vOCid GT 0>
			<!---			<cfset GraboOk = OGeneralProcB.ReversionNoFact(session.qproductos.orden,
															 session.qproductos.trade_num)>
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
					'D', '#LvarOCtipoIC#', #session.Ecodigo#,
					 #LvarSNid#, '#queryVentas.yourrefnum#',
					 <cfif isdate(rsTrade.creation_date)>
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.creation_date#">,
					 <cfelse>
						null,
					 </cfif>
					 #LvarMcodigo#,
					 #rsTVenta.OCVid#,
					 'A','CC',
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
 		    <cfif cC_Tipo_Invoice EQ "NC">
				<cfset LvarCantidad = ws_f_vol_nvo * -1>
				<cfset LvarPrecioTotal = ws_f_importe * -1>
		    </cfif>
			<cfquery name="query" datasource="#Session.Dsn#">
				insert INTO OCordenProducto
					(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
					 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
				  <cfqueryparam cfsqltype="cf_sql_smallint" value=1>,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#ws_c_unidades#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value="#LvarCantidad#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio_nvo,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioTotal,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value=0>,
				  null,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCuentaFinanciera#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>
		<cfelse>
			<cfif cC_Tipo_Invoice EQ "NC">
				<cfset LvarCantidad = (rsVerifica.OCPcantidad + (ws_f_vol_nvo * -1))>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + ws_f_importe) / abs(LvarCantidad)>
				<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + (ws_f_importe * -1)>
			<cfelse>				
				<cfset LvarCantidad = (rsVerifica.OCPcantidad + ws_f_vol_nvo)>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + ws_f_importe) / LvarCantidad>
				<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + ws_f_importe>
			</cfif>
		
			<cfquery datasource="#Session.Dsn#">
				update OCordenProducto set
					OCPcantidad=#LvarCantidad#,
					OCPprecioUnitario=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioUnitario,"9.99")#">,
					OCPprecioTotal=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioTotal,"9.99")#">
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
 		    <cfif cC_Tipo_Invoice EQ "NC">
				<cfset LvarCantidad = ws_f_vol_nvo * -1>
				<cfset LvarPrecioTotal = ws_f_importe * -1>
		    </cfif>
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
				  <cfqueryparam cfsqltype="cf_sql_char" value="D">,
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
					  <cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">,
				  </cfif>
				  <cfqueryparam cfsqltype="cf_sql_float" value="#LvarCantidad#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio_nvo,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioTotal,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		<cfelse>
			<cfif cC_Tipo_Invoice EQ "NC">
				<cfset LvarCantidad = (rsVerifica.OCTPcantidadTeorica + (ws_f_vol_nvo * -1))>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCTPprecioTotTeorico + ws_f_importe) / abs(LvarCantidad)>
				<cfset LvarPrecioTotal = rsVerifica.OCTPprecioTotTeorico + (ws_f_importe * -1)>
			<cfelse>				
				<cfset LvarCantidad = (rsVerifica.OCTPcantidadTeorica + ws_f_vol_nvo)>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCTPprecioTotTeorico + ws_f_importe) / LvarCantidad>
				<cfset LvarPrecioTotal = rsVerifica.OCTPprecioTotTeorico + ws_f_importe>
			</cfif>

			<cfquery datasource="#Session.Dsn#">
				update OCtransporteProducto set
					OCTPcantidadTeorica=#LvarCantidad#,
					OCTPprecioUniTeorico=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioUnitario,"9.99")#">,
					OCTPprecioTotTeorico=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioTotal,"9.99")#">
				where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
				  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
			</cfquery>
		</cfif>
	<!---  Si el Origen de la Orden es Almacén, se graba una Orden Origen-Inventario           --->				
	<!---  Fin de la grabación Origen-Inventario           --->		
	</cfif>
	<!--- FIN SECCION ORDENES COMERCIALES  --->
	</cftransaction>
	
	<cfif isdefined("form.MostrarTodo") or len(LvarTipoError)>
		<cfif LvarTipoError NEQ "Ya se Importó el Documento">
			<cfoutput>
			<tr>
				<td>#LSDateFormat(queryVentas.voucher_creation_date,'dd/mm/yyyy')#</td>
				<td>#queryVentas.voucher_num#</td>
				<td>#LsDateFormat(queryVentas.invoiceDate,'dd/mm/yyyy')#</td>
				<td>#cC_Tipo_Invoice#-#queryVentas.invoice#</td>
				<td>#LvarProducto#</td>
				<cfif LvarTipoError NEQ "">
					<td>#LvarTipoError#</td>
				<cfelse>
					<td>&nbsp;</td>
				</cfif>
				<td align="right">#numberformat(ws_f_vol_nvo, ",0.00")#</td>
				<td align="right">#numberformat(ws_f_importe,",0.00")#</td>
				<td align="right">#numberformat(queryVentas.voucher_tot_amt,",0.00")#</td>
			</tr>
			</cfoutput>
		</cfif>
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

<cftransaction>
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
</cftransaction>

<cfoutput>
<cfif not LvarBanderaErrores>
	<tr><td colspan="9">&nbsp;</td></tr>
	<tr><td colspan="9" align="center"><strong>No se presentaron errores en la importacion.</strong></td>
</cfif>
	<cfset LvarTiempoProceso = datediff("s",LvarHoraInicio,now())>
	<tr><td colspan="9">&nbsp;</td></tr>
	<tr><td colspan="9">Tiempo de Proceso:#NumberFormat(LvarTiempoProceso, ",0")# Segundos</td></tr>
</table>
</cfoutput>
