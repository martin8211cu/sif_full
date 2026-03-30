<!--- Archivo    :  FacturasProdVentasA-sql.cfm
	  --->
<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<!--- Variable Form para CosICTS--->
<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>			
<cfif not isdefined("varCodICTS")>
	<cfabort showerror="No se especifico la Empresa a Procesar">
</cfif>

<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">

<!---
<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.EmpresaICTS = rsVerifica.CodICTS>
	<cfset session.EcodigoSDCSoin = rsVerifica.EcodigoSDCSoin>
</cfif>
--->

<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	<!---where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>

<!--- Para desarrollo "sif_interfaces.." y para produccción "sif_interfaces.."  --->
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
	or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from #LvarDsource#ErroresPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ProductosPMI where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfaces..ErroresPMI (fecharegistro date null,sessionid numeric null,Ecodigo int null,
		FechaProceso date null,FechaDocumento date null, TipoDocumento char(20) null, UsuarioProceso int null,
		MensajeError varchar(200),Documento char(20) null, Modulo char(3) null, Monto float null, Trade_Num int null,
		Order_Num smallint null, Item_Num smallint null)
create table sif_interfaces..ProductosPMI (fecharegistro date null,sessionid numeric null,documento char(20) null,
		orden char(10) null, socionegocio int null,Nsocio numeric null, producto varchar(20) null,
		fechavoucher date null, vouchernum numeric null,trade_num int null, order_num smallint null,
		item_num smallint null, importe float null, modulo char(3) null,tipotransaccion char(2) null,
		iva float null, moneda char(5) null, Ecodigo int null)
drop table sif_interfaces..facturasProdVentPMI
create table sif_interfaces..facturasProdVentPMI (fecharegistro date null,sessionid numeric null,
		voucher_num integer null, acct_num int null, voucher_tot_amt float null, voucher_curr_code char(8) null,
		voucher_creation_date date null, 
		invoice varchar(15) null, invoiceDate date null, dueDate date null, invoiceType char(1) null,
		yourRefNum varchar(25) null, c_moneda char(8) null, c_unidades char(8) null, f_iva float null, 
		f_volumen float null, trade_num integer null, order_num smallint null, item_num smallint null,
		cmdty_code varchar(10) null,
		title_tran_date date null, alloc_type_code char(1) null, del_term_code char(8) null,
		bl_ticket_num varchar(15) null, bl_date date null, transportation varchar(40) null, load_compl_date date null,
		nor_date date null, creation_date date null, fecha_allocation date null, real_port_num int null,
		p_s_ind char(1) null, 
		SNid numeric null, Aid numeric null, UcodigoArt char(5) null, Mcodigo numeric null, Ucodigo char(5) null,
		subconcepto integer null, CodigoImpuesto char(5) null, cost_type_code varchar(8) null,
		ta_order_type_code varchar(8) null, ta_trade_num int null, ta_order_num smallint null,
		ta_item_num smallint null, ta_creation_date date null, ta_acct_ref_num char(10) null, 
		ta_acct_num int null, tt_order_type_code char(8) null, tt_acct_ref_num char(10) null,
		tt_acct_num int null,
		tt_tcompras int null, tt_bexiste char(1) null, tt_nbexiste char(1) null,
		tt_blending char(1) null, tt_ordenAlloc char(10) null, tt_socioAlloc int null,
		montocosto float null, cuafactor float null,
		SNCDid_3 char(1) null, SNCDid_4 char(1) null, SNCDid_5 char(1) null, SNCDid_6 char(1) null,
		SNCDid_A char(1) null, AllocSNid numeric null, MensajeError varchar(255) null)
--->

<!---Eliminacion de Proceso de Complementos FACT 07/07/2008 ABG
<!--- Verifica si hay Documentos Pendientes de Procesar en DocumentoReversion --->
<cfquery name="rsVerifica" datasource="sifinterfaces">
	select * 
	from DocumentoReversion 
	where Procesado = 'N'
	and Ecodigo = #session.ecodigo#
</cfquery>
<cfif rsVerifica.recordcount GT 0>
	<cfabort showerror="Existen Documentos Pendientes en la opción Interfaces de PMI/Reversión Producto NOFACT">
</cfif>
--->

<!--- Crea query de ventas  --->
<cfquery datasource="preicts">
	insert #LvarDsource#facturasProdVentPMI (fecharegistro, sessionid,
		voucher_num, acct_num, voucher_tot_amt, voucher_curr_code, voucher_creation_date,
		invoice, invoiceDate, dueDate, invoiceType, yourRefNum)
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
		   aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code, aa.voucher_creation_date,
		   ab.invoice, ab.invoiceDate, ab.dueDate, ab.invoiceType, ab.yourRefNum
	from voucher aa
		inner join PmiInvoice ab
		on ab.voucherNum = aa.voucher_num
		and (ab.invoiceType = 'G' or ab.invoiceType = 'K' or ab.invoiceType = 'p' or ab.invoiceType = 'R' or
			 ab.invoiceType = 'W' or ab.invoiceType = 'c' or ab.invoiceType = 'd' or ab.invoiceType = 'w' or ab.invoiceType = 'P')
		and upper(ab.printedInd) in ('L','T','Y')
		and ab.status_xml = 'F'
		and ab.bookingCo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.DescripcionICTS#">
		and ab.invoiceDate between
			<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
			and
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaF)#">
	<!---where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
		where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
	<!---and not EXISTS(select ac.ID from sif_interfaces..IE10 ac where ac.VoucherNo = CONVERT(varchar,aa.voucher_num) 
					and EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">)--->
	order by aa.acct_num, ab.invoiceType, ab.invoice
</cfquery>

<cfset LvarBanderaErrores = false>

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select count(*) as noRegs from facturasProdVentPMI
	where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfset LvarNoRegistros = rsVerifica.noRegs>

<!--- consulta la información de iva, monto, moneda, unidades de tabla cost  --->
<cfquery datasource="preicts">
	select sum(case when co.cost_pay_rec_ind = 'R' and co.cost_code <> 'IVA' and co.cost_code <> 'TAX'
				  then  co.cost_qty else 0 end) as SumaVol_R,
		   sum(case when co.cost_pay_rec_ind = 'P' and co.cost_code <> 'IVA' and co.cost_code <> 'TAX'
		   		  then  co.cost_qty else 0 end) as SumaVol_P,
		   sum(case when co.cost_pay_rec_ind = 'R' and co.cost_code <> 'IVA' and co.cost_code <> 'TAX'
		   		  then  co.cost_amt else 0 end) as SumaImp_R,
		   sum(case when co.cost_pay_rec_ind = 'P' and co.cost_code <> 'IVA' and co.cost_code <> 'TAX'
		   		  then  co.cost_amt else 0 end) as SumaImp_P,
		   sum(case when co.cost_pay_rec_ind = 'R' and co.cost_code in ('IVA','TAX') then  co.cost_amt else 0
			   end) as SumaIva_R,
		   sum(case when co.cost_pay_rec_ind = 'P' and co.cost_code in ('IVA','TAX') then  co.cost_amt else 0
			   end) as SumaIva_P, cost_qty_uom_code, cost_price_curr_code, vo.voucher_num
	into #LvarDsource#TempPMI
	from voucher vo
		inner join voucher_cost vco
			inner join cost co
			on co.cost_num=vco.cost_num
			and co.cost_status IN ('PAID','VOUCHED')
		on vco.voucher_num = vo.voucher_num
	where vo.voucher_num in (select voucher_num from #LvarDsource#facturasProdVentPMI
							 where sessionid = #session.monitoreo.sessionid#)
	group by cost_qty_uom_code, cost_price_curr_code, vo.voucher_num
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdVentPMI SET c_unidades = a2.cost_qty_uom_code,
	 	   c_moneda = a2.cost_price_curr_code, f_iva = abs(a2.SumaIva_R - a2.SumaIva_P), 
		   montocosto = abs(a2.SumaImp_R - a2.SumaImp_P), f_volumen = abs(a2.SumaVol_R - a2.SumaVol_P)
	from #LvarDsource#facturasProdVentPMI a1, #LvarDsource#TempPMI a2
	where a1.voucher_num = a2.voucher_num
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- Consulta la información de costos tabla cost   --->
<cfquery datasource="preicts">
	select distinct co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num,
	       co.cost_owner_key8 as item_num, 
	       co.cost_code, co.cost_type_code, vo.voucher_num
    into #LvarDsource#TempPMI
    from cost co
		inner join voucher vo
			inner join voucher_cost vco
			on vco.voucher_num = vo.voucher_num
		on vo.voucher_num in (select voucher_num from #LvarDsource#facturasProdVentPMI
							  where sessionid = #session.monitoreo.sessionid#)
	where co.cost_num = vco.cost_num
	  and co.cost_status IN ('PAID','VOUCHED')
	  and co.cost_owner_key6 > 0 
	  and co.cost_owner_key7 > 0 
	  and co.cost_owner_key8 > 0 
	order by cost_amt desc
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdVentPMI SET trade_num = a2.trade_num, order_num = a2.order_num,
	       item_num = a2.item_num, cost_type_code = a2.cost_type_code, cmdty_code = a2.cost_code
	from #LvarDsource#facturasProdVentPMI a1, #LvarDsource#TempPMI a2
	where a1.voucher_num = a2.voucher_num
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- Consulta información del Trade, trade_order, trade_item   --->
<cfquery datasource="preicts">
	select ai.title_tran_date, ai.trade_num, ai.order_num, ai.item_num,
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, 
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, a6.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num, ti.p_s_ind
	into #LvarDsource#TempPMI
	from #LvarDsource#facturasProdVentPMI ate, trade_item ti
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
	UPDATE #LvarDsource#facturasProdVentPMI SET title_tran_date = a2.title_tran_date,
	 	   alloc_type_code = a2.alloc_type_code, del_term_code = a2.del_term_code, 
		   bl_ticket_num = a2.bl_ticket_num, bl_date = a2.bl_date, transportation = a2.transportation,
		   load_compl_date = a2.load_compl_date, creation_date = a2.creation_date,
		   fecha_allocation = a2.fecha_allocation, real_port_num = a2.real_port_num,
		   p_s_ind = a2.p_s_ind
	from #LvarDsource#facturasProdVentPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num
	  and a1.order_num = a2.order_num
	  and a1.item_num = a2.item_num
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET SNid = a2.SNid
	from #LvarDsource#facturasProdVentPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
	  and a1.sessionid = #session.monitoreo.sessionid#	  
</cfquery>

<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET Mcodigo = a2.Mcodigo
	from #LvarDsource#facturasProdVentPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = a1.c_moneda
	  and a1.sessionid = #session.monitoreo.sessionid#	  
</cfquery>
<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET Ucodigo = a2.Ucodigo
	from #LvarDsource#facturasProdVentPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.c_unidades
	  and a1.sessionid = #session.monitoreo.sessionid#	  
</cfquery>

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET Aid = a2.Aid, UcodigoArt = a2.Ucodigo
	from #LvarDsource#facturasProdVentPMI a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodigo  = a1.cmdty_code
	  <!---Se usa Acodigo por estandar --and a2.Acodalterno  = a1.cmdty_code --->
	  and a1.sessionid = #session.monitoreo.sessionid#
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
	  and rtrim(a2.Ucodigo) = rtrim(a1.c_unidades)
	  and a1.sessionid = #session.monitoreo.sessionid#	  
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
	where a1.trade_num in (select trade_num from #LvarDsource#facturasProdVentPMI
						   where p_s_ind='S'
						   	 and sessionid = #session.monitoreo.sessionid#)
	  and a1.order_num in (select fac01.order_num from #LvarDsource#facturasProdVentPMI fac01
	  					   where fac01.trade_num = a1.trade_num
						     and fac01.p_s_ind='S'
					 	     and fac01.sessionid = #session.monitoreo.sessionid#)	
 	  and a1.item_num in (select fac02.item_num from #LvarDsource#facturasProdVentPMI fac02
	  					  where fac02.trade_num=a1.trade_num
							and fac02.order_num=a1.order_num
							and fac02.p_s_ind='S'
							and fac02.sessionid = #session.monitoreo.sessionid#)	
	order by oo.order_type_code, a2.acct_ref_num
</cfquery>
<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdVentPMI SET ta_order_type_code = a2.order_type_code,
	 	   ta_trade_num = a2.trade_num, ta_order_num = a2.order_num, ta_item_num = a2.item_num,
		   ta_creation_date = a2.creation_date, ta_acct_ref_num = a2.acct_ref_num, ta_acct_num = a2.acct_num
	from #LvarDsource#facturasProdVentPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num_CP
	  and a1.order_num = a2.order_num_CP
	  and a1.item_num = a2.item_num_CP
	  and a1.p_s_ind = 'S'
	  and a1.sessionid = #session.monitoreo.sessionid#	  
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table  #LvarDsource#TempPMI
</cfquery> 

<cfquery datasource="preicts">
	select oo.order_type_code, a2.acct_ref_num, a2.acct_num, a2.trade_num, a2.order_num, a2.item_num, ti.cmdty_code,
			a1.trade_num as trade_num_CP
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
	where a1.trade_num in (select ta_trade_num from #LvarDsource#facturasProdVentPMI where p_s_ind='S' 
						   and ta_order_type_code = 'TRANSPRT'
						   and sessionid = #session.monitoreo.sessionid#)
	order by a1.trade_num, oo.order_type_code 
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdVentPMI SET tt_order_type_code = a2.order_type_code,
	 	   tt_acct_ref_num = a2.acct_ref_num, tt_acct_num = a2.acct_num, 
		   tt_tcompras = (select count(1) from #LvarDsource#TempPMI a10 where a10.trade_num_CP = a1.ta_trade_num),
		   tt_blending = case
		   					when Exists(select * from #LvarDsource#TempPMI a10
									 where a10.trade_num_CP = a1.ta_trade_num and a10.cmdty_code = a1.cmdty_code)
								  then 'N'
							else 'S'
						 end,
		   tt_bexiste = case
		   					when not Exists(select * from #LvarDsource#TempPMI a10
									 where a10.trade_num_CP = a1.ta_trade_num and a10.cmdty_code = a1.cmdty_code)
								 and 
		   					     Exists(select * from #LvarDsource#TempPMI a11
									 where a11.trade_num_CP = a1.ta_trade_num and a11.order_type_code = 'STORAGE')
								 then 'S'
		   					when not Exists(select * from #LvarDsource#TempPMI a10
									 where a10.trade_num_CP = a1.ta_trade_num and a10.cmdty_code = a1.cmdty_code)
								 and 
		   					     Exists(select * from #LvarDsource#TempPMI a11
									 where a11.trade_num_CP = a1.ta_trade_num and a11.order_type_code = 'PHYSICAL')
								 then 'P'
							else 'N'
						 end,
		   tt_nbexiste = case
		   					   when Exists(select * from #LvarDsource#TempPMI a10
								           where a10.trade_num_CP = a1.ta_trade_num and a10.order_type_code = 'STORAGE'
										     and a10.cmdty_code = a1.cmdty_code)
							 	    then 'S'
		   					   when Exists(select * from #LvarDsource#TempPMI a10
								           where a10.trade_num_CP = a1.ta_trade_num and a10.order_type_code = 'PHYSICAL'
										     and a10.cmdty_code = a1.cmdty_code)
							 	    then 'P'
							   else 'N'
						 end
	from #LvarDsource#facturasProdVentPMI a1, #LvarDsource#TempPMI a2
	where a1.ta_trade_num = a2.trade_num_CP
	  and a1.p_s_ind = 'S'
	  and a1.sessionid = #session.monitoreo.sessionid#	  
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdVentPMI SET tt_ordenAlloc = a2.acct_ref_num, tt_socioAlloc = a2.acct_num
	from #LvarDsource#facturasProdVentPMI a1, #LvarDsource#TempPMI a2
	where a1.ta_trade_num = a2.trade_num_CP
	  and a1.p_s_ind = 'S'
	  and a1.tt_tcompras > 1 
	  and (a1.tt_bexiste in ('P','S') or a1.tt_nbexiste in ('P','S') )
	  and a2.order_type_code = case
	  								when Exists(select * from #LvarDsource#TempPMI a10
								           where a10.trade_num_CP = a1.ta_trade_num and a10.order_type_code = 'STORAGE')
										   then 'STORAGE'
	  								when Exists(select * from #LvarDsource#TempPMI a10
								           where a10.trade_num_CP = a1.ta_trade_num and a10.order_type_code = 'PHYSICAL')
										   then 'PHYSICAL'
									else ' '
							   end
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfquery datasource="sifinterfaces">
	drop table  #LvarDsource#TempPMI
</cfquery> 

<!--- tipo de venta   --->
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET SNCDid_3 = 'S'
	from #LvarDsource#facturasProdVentPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 3
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET SNCDid_4 = 'S'
	from #LvarDsource#facturasProdVentPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 4
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET SNCDid_5 = 'S'
	from #LvarDsource#facturasProdVentPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 5
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET SNCDid_6 = 'S'
	from #LvarDsource#facturasProdVentPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 6
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET SNCDid_A = 'S'
	from #LvarDsource#facturasProdVentPMI a1, SNClasificacionSN a2
	where a2.SNid = case
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
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- socio de negocio de la compra --->
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET AllocSNid = a2.SNid
	from #LvarDsource#facturasProdVentPMI a1, SNegocios a2
	where Convert(int,a2.SNcodigoext) = case
											when a1.tt_acct_num > 0 then a1.tt_acct_num
											else a1.ta_acct_num
									    end
	and a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#facturasProdVentPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#facturasProdVentPMI a1
	WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="IVA">
	  AND s.payable_receivable = 'R'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- código de impuesto  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdVentPMI SET CodigoImpuesto = a2.cuentac
	from #LvarDsource#facturasProdVentPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Aqui comienza el cambio --->

<cfquery name="queryVentas" datasource="sifinterfaces">
	select *
	from  #LvarDsource#facturasProdVentPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cftransaction>

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

	<!--- Existencia del Socio de Negocio  --->
	<cfif Len(queryVentas.SNid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido: #queryVentas.acct_num#">
	</cfif>

	<!--- Existencia del Articulo  --->
	<cfif len(queryVentas.cmdty_code) GT 0>
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
	<cfset LvarTransporte = "">
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
    	<cfset LvarTransporte = #queryVentas.ta_acct_ref_num#>
    	<cfset LvarOrdenAlloc = #queryVentas.ta_acct_ref_num#>
	</cfif>
	<cfif queryVentas.ta_order_type_code EQ 'STORAGE'>
		<cfset LvarAlmacen = #queryVentas.ta_acct_ref_num#>
		<cfset LvarSocioAlloc = queryVentas.ta_acct_num>
<!--- Se Modifica esta Linea es incorrecta la asignacion de transporte --->
<!--- <cfset LvarTransporte = "ALM_VTAS"> --->
    	<cfset LvarTransporte = #queryVentas.ta_acct_ref_num#>
    	<cfset LvarOrdenAlloc = #queryVentas.ta_acct_ref_num#>
	</cfif>
	<cfif queryVentas.ta_order_type_code EQ 'TRANSPRT'>
		<cfset LvarTransporte = queryVentas.ta_acct_ref_num>
		<cfif queryVentas.tt_tcompras EQ 1>
			<cfif queryVentas.tt_order_type_code EQ 'PHYSICAL'>
				<cfset LvarOCtipoIC = "C">
				<cfset LvarSocioAlloc = queryVentas.tt_acct_num>
				<cfset LvarOrdenAlloc = queryVentas.tt_acct_ref_num>
			</cfif>
		
			<cfif queryVentas.tt_order_type_code EQ 'STORAGE'>
				<cfset LvarAlmacen = queryVentas.tt_acct_ref_num>
				<cfset LvarSocioAlloc = queryVentas.tt_acct_num>
				<cfset LvarOrdenAlloc = queryVentas.tt_acct_ref_num>
			</cfif>
		</cfif>
		<cfif queryVentas.tt_tcompras GT 1>
			<cfif queryVentas.tt_blending EQ 'S'>
				<cfif queryVentas.tt_bexiste EQ 'S'>
					<cfset LvarAlmacen = queryVentas.tt_ordenAlloc>
					<cfset LvarSocioAlloc = queryVentas.tt_socioAlloc>
					<cfset LvarOrdenAlloc = queryVentas.tt_ordenAlloc>
				<cfelse>
					<cfif queryVentas.tt_bexiste EQ 'P'>					
						<cfset LvarOCtipoIC = "C">
						<cfset LvarSocioAlloc = queryVentas.tt_socioAlloc>
						<cfset LvarOrdenAlloc = queryVentas.tt_ordenAlloc>
					</cfif>					
				</cfif>
			<cfelse>
				<cfif queryVentas.tt_nbexiste EQ 'S'>					
					<cfset LvarAlmacen = queryVentas.tt_ordenAlloc>
					<cfset LvarSocioAlloc = queryVentas.tt_socioAlloc>
					<cfset LvarOrdenAlloc = queryVentas.tt_ordenAlloc>
				<cfelse>
					<cfif queryVentas.tt_nbexiste EQ 'P'>					
						<cfset LvarOCtipoIC = "C">
						<cfset LvarSocioAlloc = queryVentas.tt_socioAlloc>
						<cfset LvarOrdenAlloc = queryVentas.tt_ordenAlloc>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfif>

	<cfset ws_MontoCosto = queryVentas.montocosto + queryVentas.f_iva>
	<cfset ws_CantidadVolumen = queryVentas.f_volumen>
	<cfset ws_f_iva = queryVentas.f_iva>

	<cfset ws_f_Importe = queryVentas.montocosto>
	<cfset ws_f_vol_nvo = ws_CantidadVolumen>
	<cfif ws_CantidadVolumen NEQ 0>
		<cfset ws_f_precio_nvo = ws_f_Importe / ws_CantidadVolumen>
	<cfelse>
		<cfset ws_f_precio_nvo = 0>
	</cfif>
	<cfset ws_c_unidades = queryVentas.c_unidades>

	<!--- valida que el monto del voucher sea igual a la suma de los costos  --->	
	<cfset vDiff = queryVentas.voucher_tot_amt - ws_MontoCosto>
	
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
			<cfset ws_f_vol_nvo = queryVentas.cuafactor * ws_f_vol_nvo>
			<cfif ws_f_vol_nvo EQ 0>
				<cfset ws_f_vol_nvo = 1>
			</cfif>
			<cfset ws_f_precio_nvo = ws_f_Importe/ws_f_vol_nvo>
			<cfset ws_c_unidades = queryVentas.UcodigoArt>
		<cfelse>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = "Unidades diferentes, sin factor de conversión">
		</cfif>
	</cfif>

	<!--- Valida código impuesto del IVA --->
	<cfset LvarCodigoImpuesto = "">
	<cfif queryVentas.f_iva GT 0>
		<cfif Len(queryVentas.CodigoImpuesto) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Código impuesto IVA no definido">
		<cfelse>
			<cfset LvarCodigoImpuesto = queryVentas.CodigoImpuesto>
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
		<cfset Lvarbl_date=queryVentas.invoiceDate>
	</cfif>
	
	<cfif Len(LvarAlmacen) GT 0>
		<cfset LvarOCtipoIC = "V">
	</cfif>

	<!--- valida el allocation  --->
	<cfif Len(LvarOrdenAlloc) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfif rtrim(#queryVentas.ta_order_type_code#) EQ 'EFPEXCH' or rtrim(#queryVentas.tt_order_type_code#) EQ 'EFPEXCH'>
			<cfset LvarTipoError = LvarTipoError & "Orden de allocation es -EFPEXCH-">
		<cfelse>
			<cfset LvarTipoError = LvarTipoError & "No existe orden de allocation">
		</cfif>
	</cfif>

	<!--- valida el transporte  --->
	<cfif Len(LvarTransporte) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No asignó el transporte">
	</cfif>
	<cfset LvarCuentaFinanciera = "">

	<cfset LvarTipoVenta= "">
	<!--- Validar el tipo de venta  --->
	<cfif len(LvarAlmacen)>
		<cfset LvarTipoVenta= "#Lvaralmacen#">    <!--- ES UN ALMACEN  --->
	<cfelse>
		<cfif Len(queryVentas.AllocSNid) GT 0>
			<cfif len(queryVentas.SNCDid_3) GT 0>
				<cfset LvarTipoVenta= "002">    <!--- ES INTERCOMPAÑIA  --->
			<cfelse>
				<cfif len(queryVentas.SNCDid_4) GT 0>
					<cfif len(queryVentas.SNCDid_5) GT 0>
						<cfset LvarTipoVenta= "004">    <!--- ES TERCERO NACIONAL  --->
					<cfelse>
						<cfif len(queryVentas.SNCDid_6) GT 0>
							<cfif len(queryVentas.SNCDid_A) GT 0>
								<cfset LvarTipoVenta= "001">    <!--- ES VENTA AL EXTERIOR  --->
							<cfelse>
								<cfset LvarTipoVenta= "003">    <!--- ES VENTA A TERCEROS  --->
							</cfif>
						</cfif>
					</cfif>
				</cfif>			
			</cfif>
		<cfelse>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Socio Compra no Existe">
		</cfif>					
	</cfif>

	<cfquery name="rsVerifica" datasource="sifinterfaces">
		select OCVid, OCVcodigo, OCVdescripcion
		from OCtipoVenta_view
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and OCVcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarTipoVenta#">
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Tipo de Venta No existe-#LvarTipoVenta#">
	<cfelse>
		<cfset LvarOCVid = rsVerifica.OCVid>
	</cfif> 

<!--- Se saca la prueba para documentos duplicados y se quita el resto de el codigo --->
	<cfquery name="rsVerificaIE10" datasource="sifinterfaces">
		select count(1) as Cantidad
		from IE10
	<!---	where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">--->
		where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and NumeroSocio = '#queryVentas.acct_num#'
		  and Modulo = 'CC'
		  and CodigoTransacion = '#cC_Tipo_Invoice#'
		  and Documento = '#queryVentas.invoice#'
	</cfquery>
	<cfif rsVerificaIE10.Cantidad GT 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Ya se Importó el Documento">
	</cfif>

	<cfquery datasource="sifinterfaces">
		UPDATE facturasProdVentPMI
			SET MensajeError = case 
								when '#LvarTipoError#' = '' then MensajeError
								else
								case when MensajeError is null then '#LvarTipoError#'
									else MensajeError + ', #LvarTipoError#' end
							    end
		from facturasProdVentPMI
		where voucher_num = #queryVentas.voucher_num#
			and acct_num = #queryVentas.acct_num#
			and invoiceType = '#queryVentas.invoiceType#'
			and invoice = '#queryVentas.invoice#'
			and sessionid = #session.monitoreo.sessionid#
	</cfquery>
</cfloop>

<!---
<cfquery name="Valida" datasource="sifinterfaces">
	select * from facturasProdVentPMI
	where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cf_dump var="#Valida#"> --->
<!--- Se agrega al final del proceso la actualizacion de errores --->