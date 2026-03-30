<!--- Archivo    :  otrosingresos/extrae.cfm
marco, Martes 13-Mar-2007

Datos de Prueba: 1/1/2007 a 31/1/2007
	  --->

<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
<cfset tesoreriadb     = Application.dsinfo.tesoreria.schema>

<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">

<cfset LvarHoraInicio = now()>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.EmpresaICTS = rsVerifica.CodICTS>
	<cfset session.EcodigoSDCSoin = rsVerifica.EcodigoSDCSoin>
</cfif>

<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>

<cfset LvarDsource = "#sifinterfacesdb#..">
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
	delete from #LvarDsource#PMIINT_IE10 where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_ID10 where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfaces..otrosIngresosPMI (fecharegistro date null,sessionid numeric null,
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
<cfquery datasource="preicts">
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
		and upper(ab.invoiceType) in ('V', 'U', 'S')
		and upper(ab.printedInd) in ('L','T','Y')
		and ab.bookingCo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.DescripcionICTS#">
		and ab.invoiceDate between
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaI)#"> 
			and
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaF)#">
	where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
	and not exists(select 1 from #LvarDsource#InterfazBitacoraProcesos ib, #LvarDsource#IE10 ie 
					where ie.VoucherNo = CONVERT(varchar,aa.voucher_num)
					and ib.EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">
					and ie.EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">
					and ib.IdProceso = ie.ID and MsgError like 'OK') 
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
		on vo.voucher_num in (select voucher_num from #LvarDsource#otrosIngresosPMI
							  where sessionid = #session.monitoreo.sessionid#)
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
	  and a1.sessionid = #session.monitoreo.sessionid#
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
	  and a1.sessionid = #session.monitoreo.sessionid#
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
	  and ate.sessionid = #session.monitoreo.sessionid#
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
	  and a1.sessionid = #session.monitoreo.sessionid#
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
	  and a1.sessionid = #session.monitoreo.sessionid#
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
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- subconcepto impuesto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#otrosIngresosPMI SET subconceptoTax = sb.subconcepto_id
	from #tesoreriadb#..subconceptos sb, #tesoreriadb#..rel_subconceptos_detalles r,
	     #tesoreriadb#..subconceptos_detalle s, #LvarDsource#otrosIngresosPMI a1
	WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="IVA">
	  AND s.payable_receivable = 'R'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- código de impuesto  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#otrosIngresosPMI SET CodigoImpuesto = a2.cuentac
	from #LvarDsource#otrosIngresosPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconceptoTax)
	  and a1.sessionid = #session.monitoreo.sessionid#
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
	where vo.voucher_num in (select voucher_num from #LvarDsource#otrosIngresosPMI
							 where sessionid = #session.monitoreo.sessionid#)
	group by cost_qty_uom_code, cost_price_curr_code, vo.voucher_num
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#otrosIngresosPMI SET c_unidades = a2.cost_qty_uom_code,
	 	   c_moneda = a2.cost_price_curr_code, f_iva = abs(a2.SumaIva_R - a2.SumaIva_P), 
		   montocosto = abs(a2.SumaImp_R - a2.SumaImp_P),
		   volumen = abs(a2.SumaVol_R - a2.SumaVol_P)
	from #LvarDsource#otrosIngresosPMI a1, #LvarDsource#TempPMI a2
	where a1.voucher_num = a2.voucher_num
	  and a1.sessionid = #session.monitoreo.sessionid#
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
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#otrosIngresosPMI SET subconcepto = sb.subconcepto_id
	from #tesoreriadb#..subconceptos sb, #tesoreriadb#..rel_subconceptos_detalles r,
	     #tesoreriadb#..subconceptos_detalle s, #LvarDsource#otrosIngresosPMI a1
	WHERE s.costo_id = a1.cost_code
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'R'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
	  and a1.sessionid = #session.monitoreo.sessionid#

	UPDATE #LvarDsource#otrosIngresosPMI SET subconcepto = sb.subconcepto_id
	from #tesoreriadb#..subconceptos sb, #tesoreriadb#..rel_subconceptos_detalles r,
	     #tesoreriadb#..subconceptos_detalle s, #LvarDsource#otrosIngresosPMI a1
	WHERE s.costo_id = a1.cost_code
	  AND s.tipo_costo = 'ANY'
	  AND s.payable_receivable = 'R'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- código de concepto  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#otrosIngresosPMI SET CodigoConcepto = a2.cuentac
	from #LvarDsource#otrosIngresosPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
	  and a1.sessionid = #session.monitoreo.sessionid#
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
		<cfset ws_f_precio = ws_f_Importe - ws_f_iva / ws_f_volumen>
	<cfelse>
		<cfset ws_f_precio = 0>
	</cfif>
	<cfset ws_c_unidad = queryVentas.c_unidades>

	<!--- valida que el monto del voucher sea igual a la suma de los costos más el iva.  --->	
	<cfset vDiff = ws_f_Importe - ws_MontoCosto>
	
	<cfif abs(vDiff) GT 10>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = "Diferencia Montos Voucher/Costos">
	</cfif>
	<cfset ws_f_Importe = queryVentas.voucher_tot_amt - ws_f_iva>
	
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
	<cfset ws_curr_code = mid(queryVentas.c_moneda,1,3)>
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
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta:#ws_curr_code#">
	<cfelse>
		<cfset LvarMcodigo = rsVerifica.Mcodigo>
	</cfif> 

	<cfset LvarProducto = "">

	<cfif queryVentas.f_iva GT 0>
		<!--- valida subconceptoTax  --->
		<cfif Len(queryVentas.CodigoImpuesto) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existe Código de Impuesto">
		</cfif>
	</cfif>

	<!--- valida subconcepto  --->
	<cfif Len(queryVentas.subconcepto) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existe subconcepto en Tesorería(#queryVentas.cost_code#)">
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

	<cfset ws_CodigoOficina = "MEX">
	<cfset ws_tipo_modulo = "CC">
	<cfif ucase("#queryVentas.invoiceType#") EQ 'U'>
		<cfset ws_tipo_transaccion = "NS">
	<cfelse>
		<cfset ws_tipo_transaccion = "FS">
	</cfif>
	<cfset ws_folio = "#queryVentas.invoice#">
	<cfset ws_OCtransporte = "">
	<cfset ws_OCcontrato = "">
	<cfset ws_OCTtipo = "">

	<cfset ws_OCconceptoIngreso = toString(queryVentas.subconcepto)>

	<cfif LvarTipoFactura EQ 'trade' and queryVentas.order_type_code EQ 'PHYSICAL'>
		<cfset ws_TipoItem = 'O'>
		<cfset ws_f_volumen = 0>
		<cfset ws_CodigoItem = queryVentas.cmdty_code>
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select OCid, OCcontrato, OCtipoOD
			from OCordenComercial
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#queryVentas.acct_ref_num#">
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset ws_OCcontrato = rsVerifica.OCcontrato>
			<cfif rsVerifica.OCtipoOD EQ 'O'>
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select tra.OCTid from OCordenComercial ord
						inner join OCtransporteProducto tpr
							inner join OCtransporte tra
							on tra.OCTid = tpr.OCTid
						on tpr.OCid = ord.OCid
					 where ord.OCcontrato = '#ws_OCcontrato#'
				</cfquery>		
				<cfif rsVerifica.recordcount GT 0>
					<cfset ws_ID = rsVerifica.OCTid>
					<cfquery name="rsVerifica" datasource="#session.dsn#">
						select tra.OCTid, ord.OCcontrato from OCordenComercial ord
							inner join OCtransporteProducto tpr
								inner join OCtransporte tra
								on tra.OCTid = #ws_ID#
								and tra.OCTid = tpr.OCTid
							on tpr.OCid = ord.OCid
						 where ord.OCtipoOD = 'D'
					</cfquery>
				</cfif>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ws_OCcontrato = rsVerifica.OCcontrato>
				<cfelse>
					<cfset ws_OCcontrato = "">
				</cfif>
			</cfif>
			
			<cfif len(ws_OCcontrato) GT 0>		
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select a3.OCTtransporte, OCTtipo
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
					<cfset ws_OCTtipo = rsVerifica.OCTtipo>
				<cfelse>
					<cfset LvarBanderaErrores_registro = true>
					<cfset LvarBanderaErrores = true>
					<cfif len(LvarTipoError)>
						<cfset LvarTipoError = LvarTipoError & ", ">
					</cfif>
					<cfset LvarTipoError = LvarTipoError & "No existe el Transporte de la Orden">
				</cfif>
			<cfelse>
				<cfset ws_f_volumen = 1>
				<cfset ws_TipoItem = 'S'>
				<cfset ws_CodigoItem = "#toString(queryVentas.subconcepto)#">
			</cfif>
		<cfelse>
			<cfset ws_f_volumen = 1>
			<cfset ws_TipoItem = 'S'>
			<cfset ws_CodigoItem = "#toString(queryVentas.subconcepto)#">
		</cfif>
	<cfelse>
		<cfset ws_f_volumen = 1>
		<cfset ws_TipoItem = 'S'>
		<cfset ws_CodigoItem = "#toString(queryVentas.subconcepto)#">
	</cfif>

	<cfset ConseIE10 = ConseIE10 + 1>
	<!--- Graba en tabla pmiIE10  --->
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
			#ConseIE10#, #session.EcodigoSDCSoin#, '#queryVentas.acct_num#', '#ws_tipo_modulo#',
			'#ws_tipo_transaccion#', '#ws_folio#', ' ',
			'#ws_curr_code#', 
			<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.dueDate#">,
			'S', '#ws_tipo_modulo#', '#queryVentas.voucher_num#', '#ws_OCconceptoIngreso#', 
			null, '#ws_CodigoOficina#', null,
			0, null, null, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.invoiceDate#">, 
			1, 
			<cfif len(LvarTipoError) GT 0>
				<cfqueryparam cfsqltype="cf_sql_char" value="#LvarTipoError#">
			<cfelse>
			null 
			</cfif>
            )
	</cfquery>

	<cfquery datasource="sifinterfaces">
		insert PMIINT_ID10 (FechaRegistro,sessionid,
			ID, Consecutivo, TipoItem, CodigoItem, 
			NombreBarco, FechaHoraCarga, FechaHoraSalida, 
			PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
			CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
			TripNo, ContractNo, CodigoImpuesto,
			ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
			PrecioTotal, 
			CentroFuncional, CuentaFinancieraDet, 
			OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoIngreso)
		values(getdate(), #session.monitoreo.sessionid#,
			#ConseIE10#, 1, '#ws_TipoItem#', '#ws_CodigoItem#',
			<cfif ws_TipoItem EQ 'S'>
				null,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#queryVentas.transportation#">, 
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.load_compl_date#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#queryVentas.nor_date#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">, 
			'#ws_c_unidad#',
			<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
			<cfif ws_TipoItem EQ 'S'>
				null,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#queryVentas.del_term_code#">, 
			</cfif>
			'#Lvarbl_ticket_num#',
			<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
			null, '#queryVentas.acct_ref_num#',
			<cfif queryVentas.f_iva GT 0>
				<cfqueryparam cfsqltype="cf_sql_char" value="#queryVentas.CodigoImpuesto#">, 
			<cfelse>
				null,
			</cfif>
			0.00, null, null,
			#numberformat(ws_f_importe,"9.99")#, null, null,
			<cfif len(ws_OCTtipo) GT 0>
				<cfqueryparam cfsqltype="cf_sql_char" value="#ws_OCTtipo#">, 
			<cfelse>
			null, 
			</cfif>
			'#ws_OCtransporte#',
			'#ws_OCcontrato#',
			<cfif ws_TipoItem EQ 'O'>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ws_OCconceptoIngreso#">
			<cfelse>
				null
			</cfif>
			)
	</cfquery>
</cfloop>
