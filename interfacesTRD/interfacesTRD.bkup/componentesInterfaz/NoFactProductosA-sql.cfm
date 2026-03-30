<!--- Archivo    :  NoFactProductosA-sql.cfm  --->
<!--- Nota Mental: Se tiene que verificar que el documento no exista en el Historico--->																								 
<cfsetting requesttimeout="1000">	  
<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">
<cfset LvarHoraInicio = now()>
<!---<cfdump var="#LvarHoraInicio#">--->
<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>
<cfset vFechaFNOW = createdatetime(year(now()),month(now()),day(now()),23,59,59)>
<cfset vFechaM1 = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>
<cfset vFechaM1 = DateAdd('D',1,vFechaM1)>

<cfset session.FechaFolio = "#right(form.FechaF,4)##mid(form.FechaF,4,2)#">
<cfset session.FechaFinal = vFechaF>

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

<!--- Para desarrollo "sif_interfacesser.." y para produccción "sif_interfaces.."  --->
<cfset LvarDsource = "sif_interfaces..">
<cfset session.Dsource = LvarDsource>

<cftry>
	<cfquery datasource="sifinterfaces">
		drop table #LvarDsource#TempPMI
	</cfquery> 
<cfcatch type="any">
</cfcatch>
</cftry>

<cfquery datasource="sifinterfaces">
	delete from nofactProdPMI where sessionid = #session.monitoreo.sessionid#
		or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from PMICOMP_ID10 where sessionid = #session.monitoreo.sessionid#
		or FechaRegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
</cfquery> 

<!---Se tiene que agregar este Script para subirlo a Produccion--->
<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfaces..nofactProdPMI (fecharegistro date null,sessionid numeric null, MensajeError varchar(255) null,
		Documento varchar(20) null, tipo_transaccion char(2) null, tipo_modulo char(2) null,
		tipoconsulta char(1) null, trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, cmdty_code varchar(10),
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
		SNCDid_A char(1) null, AllocSNid numeric null, avg_price float null, Total float null)
drop table sif_interfaces..DocumentoReversion
go
create table sif_interfaces..DocumentoReversion(IDREV numeric identity, fecharegistro date not null, sessionid int not null,
		IDIE10 numeric not null, Modulo char(2) not null, Documento varchar(35) not null,  CodigoTransaccion char(2) not null,
		SNcodigo int not null,  Producto varchar(20) not null,IDdocumento int not null,  Ecodigo int not null, 
		OriCosto float null,OriVolumen float null,DifCosto float null, DifVolumen float null, Mcodigo int not null,
		TipoReversa char(1) null, Procesado char(1) not null, OCid numeric not null, OCTid numeric null,
		TipoMovimiento varchar(5) not null, ComplementoCosto float not null, ComplementoVolumen float not null)
go
create unique clustered index ID_INDEX 
on sif_interfaces..DocumentoReversion(IDREV)
create unique clustered index ID_INDEX 
on sif_interfaces..DocumentoReversion(IDREV)
create table sif_interfaces..PMICOMP_ID10(sessionid numeric not null, FechaRegistro date not null,
		ID numeric not null, Consecutivo int not null, TipoItem char(1) not null, CodigoItem varchar(20) not null,
		NombreBarco varchar(20) null,  FechaHoraCarga datetime null, FechaHoraSalida datetime null,
		PrecioUnitario money not null, CodigoUnidadMedida char(5) not null, CantidadTotal numeric not null,
		CantidadNeta numeric not null, CodEmbarque varchar(20) null, NumeroBOL varchar(20) not null,
		FechaBOL datetime not null, TripNo varchar(20) null, ContractNo varchar(20) null, CodigoImpuesto char(5) null,
		ImporteImpuesto money null, ImporteDescuento money null, CodigoAlmacen varchar(20) null,
		CodigoDepartamento varchar(10) null, PrecioTotal money not null, CentroFuncional char(10) null,
		CuentaFinancieraDet char(100) null, OCtransporteTipo char(1) null, OCtransporte varchar(20) null,
		OCcontrato char(10) null, OCconceptoCompra char(10) null, OCconceptoIngreso char(10) null,
		factor float null, calculado money null, cobertura varchar(10) null)
--->

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

<!--- Crea query de compras  --->
																								 
<cfquery name="rsVerifica" datasource="preicts">
	insert #LvarDsource#nofactProdPMI (fecharegistro, sessionid, tipoconsulta, trade_num, order_num,
		item_num, acct_ref_num, acct_num, booking_comp_num, cmdty_code, contr_date, title_tran_date,
		alloc_type_code, del_term_code, bl_ticket_num, bl_date, transportation, load_compl_date, 
		nor_date, creation_date, fecha_allocation, real_port_num, contr_qty_uom_code, contr_qty,
		price_curr_code, p_s_ind, avg_price)
	select getdate(), #session.monitoreo.sessionid# as sessionid, 'N',
		ti.trade_num, ti.order_num, ti.item_num,
		tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
		ti.cmdty_code, tr.contr_date,
	    ai.title_tran_date, 
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, 
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, tr.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num, ti.contr_qty_uom_code, ti.contr_qty,
		ti.price_curr_code, ti.p_s_ind, ti.avg_price
	from trade_item ti
	inner join trade tr
		on tr.trade_num = ti.trade_num
		and tr.trade_status_code != 'DELETE'
	inner join trade_order oo
		on oo.trade_num = ti.trade_num
		and oo.order_num = ti.order_num
		and oo.order_type_code='PHYSICAL'
	inner join allocation_item ai
		inner join allocation a5
		on a5.alloc_num = ai.alloc_num
		inner join allocation_item_transport a10
		on a10.alloc_num = ai.alloc_num
		and a10.alloc_item_num = ai.alloc_item_num
	on ai.trade_num = ti.trade_num
	and ai.order_num = ti.order_num
	and ai.item_num = ti.item_num
	and ai.title_tran_date between 
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaI#"> 
	and
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaF#">
	and (ai.title_tran_date IS NOT null)
	where (ti.p_s_ind = 'P' or ti.p_s_ind = 'S')
		and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
		and (EXISTS(select co.cost_num from cost co where
					co.cost_status = 'OPEN' 
					and (co.cost_owner_code <> 'TI')
					and (co.cost_type_code <> 'WS')
					and ti.trade_num = co.cost_owner_key6
					and ti.order_num = co.cost_owner_key7
					and ti.item_num= co.cost_owner_key8
					and co.cost_code = ti.cmdty_code)
			or EXISTS(select co.cost_num from cost co
							inner join voucher_cost vco
								inner join PmiInvoice inv
								on inv.voucherNum = vco.voucher_num
								and inv.invoiceDate between
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaI#"> 
								and
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaF#">
								and upper(inv.printedInd) = 'N'
							on vco.cost_num = co.cost_num
					   where
						co.cost_status in ('VOUCHED')
						and ti.trade_num = co.cost_owner_key6
						and ti.order_num = co.cost_owner_key7
						and ti.item_num= co.cost_owner_key8
						and co.cost_code = ti.cmdty_code))
	union
	select getdate(), #session.monitoreo.sessionid# as sessionid, 'E',
		ti.trade_num, ti.order_num, ti.item_num,
		tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
		ti.cmdty_code, tr.contr_date,
	    ai.title_tran_date, 
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, 
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, tr.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num, ti.contr_qty_uom_code, ti.contr_qty,
		ti.price_curr_code, ti.p_s_ind, ti.avg_price
	from trade_item ti
	inner join trade tr
		on tr.trade_num = ti.trade_num
		and tr.trade_status_code != 'DELETE'
	inner join trade_order oo
		on oo.trade_num = ti.trade_num
		and oo.order_num = ti.order_num
		and oo.order_type_code='PHYSICAL'
	inner join allocation_item ai
		inner join allocation a5
		on a5.alloc_num = ai.alloc_num
		inner join allocation_item_transport a10
		on a10.alloc_num = ai.alloc_num
		and a10.alloc_item_num = ai.alloc_item_num
	on ai.trade_num = ti.trade_num
	and ai.order_num = ti.order_num
	and ai.item_num = ti.item_num
	and ai.title_tran_date between 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaI#"> 
		and
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaF#">
		and (ai.title_tran_date IS NOT null)
	where (ti.p_s_ind = 'P' or ti.p_s_ind = 'S')
		and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
		and EXISTS(select co.cost_num from cost co
						inner join voucher_cost vco
							inner join PmiInvoice inv
							on inv.voucherNum = vco.voucher_num
							and invoiceDate between
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaM1#"> 
							and
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaFNOW#">
					<!--- Se agregan los tipos 'R','O','N' en esta parte para traer todas las facturas preeliminares --->
					<!--- Cambio realizado 07/09/2007 Ing. Luis Alejando Bolaños Gómez--->
							and upper(inv.printedInd) in ('L','T','Y','R','O','N') 
							and upper(invoiceType) in('G','K','P','R','W','C','D')
						on vco.cost_num = co.cost_num
				   where
					co.cost_status in ('PAID','VOUCHED')
					and ti.trade_num = co.cost_owner_key6
					and ti.order_num = co.cost_owner_key7
					and ti.item_num= co.cost_owner_key8
					and co.cost_code = ti.cmdty_code
					and Exists (select voucherNum from PmiInvoice where voucherNum = vco.voucher_num))
	union
	select getdate(), #session.monitoreo.sessionid# as sessionid, 'E',
		ti.trade_num, ti.order_num, ti.item_num,
		tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
		ti.cmdty_code, tr.contr_date,
	    ai.title_tran_date, 
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, 
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, tr.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num, ti.contr_qty_uom_code, ti.contr_qty,
		ti.price_curr_code, ti.p_s_ind, ti.avg_price
	from trade_item ti
	inner join trade tr
		on tr.trade_num = ti.trade_num
		and tr.trade_status_code != 'DELETE'
	inner join trade_order oo
		on oo.trade_num = ti.trade_num
		and oo.order_num = ti.order_num
		and oo.order_type_code='PHYSICAL'
	inner join allocation_item ai
		inner join allocation a5
		on a5.alloc_num = ai.alloc_num
		inner join allocation_item_transport a10
		on a10.alloc_num = ai.alloc_num
		and a10.alloc_item_num = ai.alloc_item_num
	on ai.trade_num = ti.trade_num
	and ai.order_num = ti.order_num
	and ai.item_num = ti.item_num
	and ai.title_tran_date between 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaI#"> 
		and
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaF#">
		and (ai.title_tran_date IS NOT null)
	where (ti.p_s_ind = 'P' or ti.p_s_ind = 'S')
		and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
		and EXISTS(select co.cost_num from cost co
						inner join voucher_cost vco
							inner join voucher vo
							on vco.voucher_num = vo.voucher_num
							and vo.voucher_creation_date between 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaM1#"> 
							and
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaFNOW#">
						on vco.cost_num = co.cost_num
				   where
					co.cost_status in ('PAID','VOUCHED')
					and ti.trade_num = co.cost_owner_key6
					and ti.order_num = co.cost_owner_key7
					and ti.item_num= co.cost_owner_key8
					and co.cost_code = ti.cmdty_code
					and Exists (select i_voucher from PmiFolios where i_voucher = vco.voucher_num))  
	order by ti.p_s_ind, ai.title_tran_date
</cfquery>
																								 
<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#nofactProdPMI SET montocosto = 0
	from #LvarDsource#nofactProdPMI 
	where sessionid = #session.monitoreo.sessionid#
	  and montocosto is null
</cfquery>

<!--- Elimina nos NOFACT que ya tengan un NOFACT previo en CxC --->
<cfquery datasource="#session.dsn#">
	delete #LvarDsource#nofactProdPMI
	from #LvarDsource#nofactProdPMI nf 
				inner join OCordenComercial oc 
				on nf.trade_num = oc.OCtrade_num 
				and oc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where 
	exists (select 1
		   from HDDocumentos hd 
				inner join HDocumentos he 
					<!---inner join BMovimientos bm
					on bm.Ddocumento = he.Ddocumento
					and bm.CCTcodigo = he.CCTcodigo
					and bm.CCTcodigo = bm.CCTRcodigo
					and bm.SNcodigo = he.SNcodigo
					and bm.Ecodigo = he.Ecodigo
					and bm.BMperiodo >= 2008--->
				on hd.Ecodigo = he.Ecodigo 
				and hd.Ddocumento = he.Ddocumento
				and hd.CCTcodigo = he.CCTcodigo
				and he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and he.CCTcodigo in ('EC','DC')
	 	   where hd.OCid = oc.OCid and hd.Ecodigo = oc.Ecodigo)
</cfquery>

<!--- Elimina nos NOFACT que ya tengan un NOFACT previo en CxP --->
<cfquery datasource="#session.dsn#">
	delete #LvarDsource#nofactProdPMI
	from #LvarDsource#nofactProdPMI nf 
				inner join OCordenComercial oc 
				on nf.trade_num = oc.OCtrade_num 
				and oc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where 
	exists (select 1
		   from HDDocumentosCP hd 
				inner join HEDocumentosCP he 
					<!---inner join BMovimientosCxP bm
					on bm.Ddocumento = he.Ddocumento
					and bm.CPTcodigo = he.CPTcodigo
					and bm.CPTcodigo = bm.CPTRcodigo
					and bm.SNcodigo = he.SNcodigo
					and bm.Ecodigo = he.Ecodigo
					and bm.BMperiodo >= 2008--->
				on hd.Ecodigo = he.Ecodigo 
				and hd.Ddocumento = he.Ddocumento
				and hd.CPTcodigo = he.CPTcodigo
				and he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and he.CPTcodigo in ('EC','DC')
	 	   where hd.OCid = oc.OCid and hd.Ecodigo = oc.Ecodigo)
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">

<!--- procesa los registros de nofact  --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">
																								 
<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNid = a2.SNid
	from #LvarDsource#nofactProdPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET Aid = a2.Aid, UcodigoArt = a2.Ucodigo
	from  #LvarDsource#nofactProdPMI a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodalterno  = a1.cmdty_code
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET Mcodigo = a2.Mcodigo
	from  #LvarDsource#nofactProdPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = a1.price_curr_code
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET Ucodigo = a2.Ucodigo
	from #LvarDsource#nofactProdPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.contr_qty_uom_code
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Busca factor de conversión del Artículo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET cuafactor = a2.CUAfactor
	from #LvarDsource#nofactProdPMI a1, ConversionUnidadesArt a2
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Aid  = case 
						when a1.Aid is null then 0
						else a1.Aid
					end
	  and a2.Ucodigo = a1.contr_qty_uom_code
	  and rtrim(a1.UcodigoArt) <> rtrim(a1.contr_qty_uom_code)
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfset LvarConceptoCompra = "00">

<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
<cfset LvarOCtipoIC = "C">
<cfset LvarAlmacen = "">
<cfset LvarOrdenAlloc = "">
																								 
<!--- allocation de compra --->
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
		and ti.p_s_ind = 'S'
		inner join allocation_item_transport a3
			on a3.alloc_num = a2.alloc_num
		   and a3.alloc_item_num = a2.alloc_item_num
		inner join trade_order oo
			on oo.trade_num = a2.trade_num
		    and oo.order_num = a2.order_num
	where a1.trade_num in (select trade_num from #LvarDsource#nofactProdPMI
						   where p_s_ind='P'
							 and sessionid = #session.monitoreo.sessionid#)
	and a1.order_num in (select order_num from #LvarDsource#nofactProdPMI fac01
						 where fac01.trade_num = a1.trade_num
						   and fac01.p_s_ind='P'
						   and fac01.sessionid = #session.monitoreo.sessionid#)	
	and a1.item_num in (select item_num from #LvarDsource#nofactProdPMI fac02
						where fac02.trade_num = a1.trade_num
						  and fac02.order_num = a1.order_num
						  and fac02.p_s_ind='P'
					  	  and fac02.sessionid = #session.monitoreo.sessionid#)	
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
	  and a1.p_s_ind = 'P'
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table  #LvarDsource#TempPMI
</cfquery> 
																								 
<cfquery datasource="preicts">
	select oo.order_type_code, a2.acct_ref_num, a2.acct_num,a2.trade_num, a2.order_num, a2.item_num,
			(select max (ate.trade_num) from #LvarDsource#nofactProdPMI ate
			 where ate.ta_trade_num = a1.trade_num and ate.p_s_ind = 'P'
			   and ate.sessionid = #session.monitoreo.sessionid#) as trade_num_CP
		 into #LvarDsource#TempPMI
	from allocation_item a1
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
	 where a1.trade_num in (select ta_trade_num from #LvarDsource#nofactProdPMI
	 						where p_s_ind='P' 
	 						  and ta_order_type_code = 'TRANSPRT'
							  and sessionid = #session.monitoreo.sessionid#)
	 order by a1.trade_num
</cfquery>
<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#nofactProdPMI SET tt_order_type_code = a2.order_type_code,
	 	   tt_acct_ref_num = a2.acct_ref_num, tt_acct_num = a2.acct_num
	from #LvarDsource#nofactProdPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num_CP
	  and a1.p_s_ind = 'P'
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table  #LvarDsource#TempPMI
</cfquery> 
																								 
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
	where a1.trade_num in (select trade_num from #LvarDsource#nofactProdPMI
						   where p_s_ind='S'
						     and sessionid = #session.monitoreo.sessionid#)
	and a1.order_num in (select fac01.order_num from #LvarDsource#nofactProdPMI fac01
						 where fac01.trade_num=a1.trade_num
						   and fac01.p_s_ind='S'
						   and fac01.sessionid = #session.monitoreo.sessionid#)	
	and a1.item_num in (select fac02.item_num from #LvarDsource#nofactProdPMI fac02
						where fac02.trade_num=a1.trade_num
						  and fac02.order_num=a1.order_num
						  and fac02.p_s_ind='S'
						  and fac02.sessionid = #session.monitoreo.sessionid#)	
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
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table  #LvarDsource#TempPMI
</cfquery> 
																								 
<cfquery datasource="preicts">
	select oo.order_type_code, a2.acct_ref_num, a2.acct_num,a2.trade_num, a2.order_num, a2.item_num,
			(select max (ate.trade_num) from #LvarDsource#nofactProdPMI ate
			 where ate.ta_trade_num = a1.trade_num and ate.p_s_ind = 'S'
			   and ate.sessionid = #session.monitoreo.sessionid#) as trade_num_CP
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
	 where a1.trade_num in (select ta_trade_num from #LvarDsource#nofactProdPMI
	 						where p_s_ind='S'
							and ta_order_type_code = 'TRANSPRT'
							and sessionid = #session.monitoreo.sessionid#	
							  )
	 order by a1.trade_num
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#nofactProdPMI SET tt_order_type_code = a2.order_type_code,
	 	   tt_acct_ref_num = a2.acct_ref_num, tt_acct_num = a2.acct_num
	from #LvarDsource#nofactProdPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num_CP
	  and a1.p_s_ind = 'S'
	  and a1.sessionid = #session.monitoreo.sessionid#
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
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_4 = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 4
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_5 = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 5
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_6 = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
	where a1.SNid = a2.SNid
	  and a2.SNCDid = 6
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET SNCDid_A = 'S'
	from #LvarDsource#nofactProdPMI a1, SNClasificacionSN a2
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
																								 
<cfquery datasource="#Session.Dsn#">
	UPDATE #LvarDsource#nofactProdPMI SET AllocSNid = a2.SNid
	from #LvarDsource#nofactProdPMI a1, SNegocios a2
	where Convert(int,a2.SNcodigoext) = case
											when a1.tt_acct_num > 0 then a1.tt_acct_num
											else a1.ta_acct_num
									    end
	and a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
    and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfquery name="rsNofact" datasource="sifinterfaces">
	select *
	from  #LvarDsource#nofactProdPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfif rsNofact.recordcount GT 0>
<cfloop query="rsNofact"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- Existencia del Socio de Negocio  --->
	<cfif Len(rsNofact.SNid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
	</cfif>

	<!--- Existencia del Articulo  --->
	<cfif Len(rsNofact.Aid) EQ 0>
		<cfset LvarAid = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
	<cfelse>
		<cfset LvarAid = rsNofact.Aid>
	</cfif>

	<!--- Moneda es Valida  --->
	<cfif Len(rsNofact.Mcodigo) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
	</cfif> 

	<!--- Unidad es Valida  --->
	<cfif Len(rsNofact.Ucodigo) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	</cfif>
	
	<!--- Obtiene el OCid para Verificar NOFACTS anteriores para OC --->
	<cfquery name="rsVerificaNF" datasource="#session.dsn#">
		select OCid
		from OCordenComercial 
		where OCcontrato = '#rsNofact.acct_ref_num#'
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsVerificaNF.recordcount EQ 1>
		<cfset NFOCid = rsVerificaNF.OCid>
		<!--- Prueba para validar cambio de unico NOFACT --->
		<cfquery name="rsVerificaNF" datasource="#session.dsn#">
			<cfif rsNofact.p_s_ind EQ 'S'>
				select 1 
				from HDDocumentos hd 
						inner join HDocumentos he 
						on hd.Ecodigo = he.Ecodigo 
						and hd.Ddocumento = he.Ddocumento
						and hd.CCTcodigo = he.CCTcodigo
				where hd.OCid = #NFOCid#
				and he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and he.CCTcodigo in ('EC','DC')
			<cfelse>
				select 1 
				from HDDocumentosCP hd 
						inner join HEDocumentosCP he 
						on hd.Ecodigo = he.Ecodigo 
						and hd.Ddocumento = he.Ddocumento
						and hd.CPTcodigo = he.CPTcodigo
				where hd.OCid = #NFOCid#
				and he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and he.CPTcodigo in ('EC','DC')
			</cfif>
		</cfquery>
		<cfif rsVerificaNF.recordcount GT 0>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Ya existe un NOFACT previo">
		</cfif>
	</cfif>

	<cfset LvarTipoVenta = "">
	<cfset LvarConceptoCompra = "00">

	<!--- Costos no definidos  --->
	<cfif rsNofact.p_s_ind EQ "P">	
		<cfset rsCostos = OGeneralProcA.ConsultaCostosNoFactProd(rsNofact.trade_num, rsNofact.order_num,
					 rsNofact.item_num,'C',rsNofact.cmdty_code, rsNofact.tipoconsulta,
					 vFechaI, vFechaF)>
	<cfelse>
		<cfset rsCostos = OGeneralProcA.ConsultaCostosNoFactProd(rsNofact.trade_num, rsNofact.order_num,
					 rsNofact.item_num,'V',rsNofact.cmdty_code, rsNofact.tipoconsulta,
					 vFechaI, vFechaF)>
	</cfif>

	<cfif rsCostos.recordcount GT 0>
		<cfif rsCostos.monto LT 0>
			<cfset ws_pos_neg = "N">
		<cfelse>
			<cfset ws_pos_neg = "P">
		</cfif>

		<cfquery datasource="sifinterfaces">
			UPDATE #LvarDsource#nofactProdPMI SET montocosto = #rsCostos.monto#, PosNeg = '#ws_pos_neg#'
			from #LvarDsource#nofactProdPMI 
			where trade_num = #rsNofact.trade_num#
			  and order_num = #rsNofact.order_num#
			  and item_num = #rsNofact.item_num#
			  and cmdty_code = '#rsNofact.cmdty_code#'
			  and tipoconsulta = '#rsNofact.tipoconsulta#'
			  and sessionid = #session.monitoreo.sessionid#
		</cfquery>
	</cfif>
	
	<!---Verifica que existan trades Definidos--->	
	<cfif rsNofact.trade_num EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existen trade definidos">
	</cfif>

	<!--- el monto del nofact debe ser mayor a 10 o menor a -10  --->	
	<cfif rsCostos.monto GT -10 and rsCostos.monto LT 10>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Monto del nofact incorrecto">
	</cfif>

	<!--- decodifica campo alloc_type_code  --->	
	<cfif rsNofact.alloc_type_code EQ "W">
		<cfset LvarOCTtipo = "B">
	<cfelseif rsNofact.alloc_type_code EQ "R">
		<cfset LvarOCTtipo = "F">
	<cfelse>
		<cfset LvarOCTtipo = "T">
	</cfif>

	<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
	<cfset LvarOCtipoIC = "C">
	<cfset LvarAlmacen = "">
	<cfif rsNofact.p_s_ind EQ 'P'>
		<cfset LvarTransporte = "#rsNofact.acct_ref_num#">
	<cfelse>
		<cfset LvarTransporte = "">
	</cfif>
	
	<cfset LvarSocioAlloc = 0>
	<cfif rsNofact.ta_order_type_code EQ 'PHYSICAL'>
		<cfset LvarOCtipoIC = "C">
		<cfset LvarSocioAlloc = rsNofact.ta_acct_num>
		<cfif rsNofact.p_s_ind EQ 'S'>
			<cfset LvarTransporte = "#rsNofact.ta_acct_ref_num#">
		</cfif>
	</cfif>
	<cfif rsNofact.ta_order_type_code EQ 'STORAGE'>
		<cfset LvarOCtipoIC = "C">
		<cfset LvarAlmacen = rsNofact.ta_acct_ref_num>
		<cfset LvarSocioAlloc = rsNofact.ta_acct_num>
		<!--- Solo si es Venta pone el Almacen como transporte --->
		<cfif rsNofact.p_s_ind EQ 'S'>
			<cfset LvarTransporte = "#rsNofact.ta_acct_ref_num#">
		</cfif>
	</cfif>
	<cfif rsNofact.ta_order_type_code EQ 'TRANSPRT'>
		<cfset LvarTransporte = rsNofact.ta_acct_ref_num>
		<cfif rsNofact.tt_order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = rsNofact.tt_acct_num>
		</cfif>
	
		<cfif rsNofact.tt_order_type_code EQ 'STORAGE'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarAlmacen = rsNofact.tt_cct_ref_num>
			<cfset LvarSocioAlloc = rsNofact.tt_acct_num>
		</cfif>
	</cfif>

	<cfif len(LvarSocioAlloc) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No encontró el socio allocation">
	</cfif>

	<cfif len(LvarTransporte) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No asignó el transporte Tipo Orden:#rsNofact.ta_order_type_code#">
	</cfif>

	<cfif Len(rsNofact.tt_acct_num) GT 0>
		<cfset LvarSocioAlloc = rsNofact.tt_acct_num>
	<cfelse>
		<cfif Len(rsNofact.ta_acct_num) GT 0>
			<cfset LvarSocioAlloc = rsNofact.ta_acct_num>
		</cfif>
	</cfif>
	
	<!--- Validar el tipo de venta  --->
	<cfif rsNofact.p_s_ind EQ 'S'>
		<cfif len(LvarAlmacen) GT 0>
			<cfset LvarOCtipoIC = "V">
			<cfset LvarTipoVenta= "#Lvaralmacen#">    <!--- ES UN ALMACEN  --->
		<cfelse>
			<cfif Len(rsNoFact.AllocSNid) GT 0>
				<cfif len(rsNofact.SNCDid_3) GT 0>
					<cfset LvarTipoVenta= "002">    <!--- ES INTERCOMPAÑIA  --->
				<cfelse>
					<cfif len(rsNofact.SNCDid_4) GT 0>
						<cfif len(rsNofact.SNCDid_5) GT 0>
							<cfset LvarTipoVenta= "004">    <!--- ES TERCERO NACIONAL  --->
						<cfelse>
							<cfif len(rsNofact.SNCDid_6) GT 0>
								<cfif len(rsNofact.SNCDid_A) GT 0>
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

		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select OCVid, OCVcodigo, OCVdescripcion
			from OCtipoVenta
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
		</cfif> 
	</cfif>

	<!--- Conversión a unidades del Artículo --->
	<cfif Rtrim(rsNofact.UcodigoArt) NEQ "#Rtrim(rsNofact.contr_qty_uom_code)#">
		<cfif Len(rsNofact.cuafactor) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError &
				 "Falta Factor de conversión:#rsNofact.cmdty_code#,#rsNofact.contr_qty_uom_code#">
		</cfif>
	</cfif> 

	<!--- Unidad es Valida  --->
	<cfif Len(rsNofact.Ucodigo) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	</cfif>

	<cfif rsNofact.p_s_ind EQ "P">
		<cfset ws_tipo_modulo = "CP">
	<cfelse>
		<cfset ws_tipo_modulo = "CC">
	</cfif>
	
	<!--- Actuliza Modulo  --->
	<cfquery datasource="sifinterfaces">
		update nofactProdPMI
			set tipo_modulo = '#ws_tipo_modulo#'
		where trade_num = #rsNofact.Trade_Num#
		and order_num = #rsNofact.Order_Num#
		and item_num = #rsNofact.Item_Num#
		and cmdty_code = '#rsNofact.cmdty_code#'
		and acct_num = #rsNofact.acct_num#
		and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
	</cfquery>

	<cfif len(LvarTipoError) GT 0>
		<!--- Se modifica ahora solo actualiza el error, no graba Nada--->
		<!--- Graba error en tabla temporal ErroresPMI  --->
		<cfquery datasource="sifinterfaces">
			update nofactProdPMI
				set MensajeError =  case 
									when '#LvarTipoError#' = '' then MensajeError
									else
										case when MensajeError is null then '#LvarTipoError#'
										else MensajeError + ', #LvarTipoError#' 
										end
								    end
			where trade_num = #rsNofact.Trade_Num#
			and order_num = #rsNofact.Order_Num#
			and item_num = #rsNofact.Item_Num#
			and cmdty_code = '#rsNofact.cmdty_code#'
			and acct_num = #rsNofact.acct_num#
			and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
		</cfquery> 
	</cfif>
</cfloop>
<!--- ACtualiza el Total por Documento --->
<cfquery datasource="sifinterfaces">
	update nofactProdPMI
		set Total = (select sum(montocosto)
					from nofactProdPMI a1
					where trade_num = a.trade_num
					and cmdty_code = a.cmdty_code
					and acct_num = a.acct_num
					and sessionid = a.sessionid
					and MensajeError is null)
	from nofactProdPMI a
	where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>

<!---Actualiza el error si encuentra algun Neteo = 0 --->
<cfquery datasource="sifinterfaces">
	update nofactProdPMI
		set MensajeError = case when len(MensajeError) > 0 then MensajeError + ',Neteo de Documento = 0'
							else 'Neteo de Documento = 0' end
	from nofactProdPMI 
	where Total = 0
	and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>

<!--- Actualiza Documento y Transaccion --->
<cfquery datasource="sifinterfaces">
	update nofactProdPMI
		set tipo_transaccion = case when Total < 0 then 'DC' else 'EC' end,
			Documento = acct_ref_num + 'P' + 
			case when Total < 0 then 'DC' else 'EC' end +
			'#session.FechaFolio#'
	where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>
<!--- Actualiza el error si es que el documento existe --->
<cfquery datasource="sifinterfaces">
	update nofactProdPMI
		set MensajeError = case when len(MensajeError) > 0 then MensajeError + ',Documento ya se procesó'
							else 'Documento ya se procesó' end
	from nofactProdPMI a
	where exists (select ID from IE10  
	    	where Documento = a.Documento
			and CodigoTransacion = a.tipo_transaccion
			and NumeroSocio = convert(varchar,a.acct_num)
			and EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">)
	and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>
<!--- Actualiza el error si es que existe un trade Duplicado en trade de preicts --->
<cfquery datasource="sifinterfaces">
	update nofactProdPMI
		set MensajeError = case when len(MensajeError) > 0 then MensajeError + ',El trade ' + acct_ref_num + ' tiene mas de un trade_num'
							else 'El trade ' + acct_ref_num + ' tiene mas de un trade_num' end
	from nofactProdPMI a
	where exists (select 1 from nofactProdPMI
	    	where acct_ref_num = a.acct_ref_num
			and trade_num != a.trade_num
			and sessionid = a.sessionid)
	and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>
</cfif>
<!---
<cfquery name="Valida" datasource="sifinterfaces">
	select * from nofactProdPMI
		where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>
<cfdump var="Termino: #now()#">
<cf_dump var="#Valida#">

--->