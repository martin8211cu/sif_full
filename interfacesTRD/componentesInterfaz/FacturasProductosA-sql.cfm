<!---ABG: Se realiza Cambio a Interfaz para que muestra pantalla intermedia de resultados Ene/2008 --->
<!--- Archivo    :  FacturasProductosA-sql.cfm
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

<cfsetting requesttimeout="600">
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
	delete from #LvarDsource#facturasProdPMI where sessionid = #session.monitoreo.sessionid#
		or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from #LvarDsource#ErroresPMI where sessionid = #session.monitoreo.sessionid#
		or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from #LvarDsource#ProductosPMI where sessionid = #session.monitoreo.sessionid#
		or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfaces..ErroresPMI (fecharegistro date null,sessionid numeric null,Ecodigo int null,
		FechaProceso date null,FechaDocumento date null, TipoDocumento char(20) null, UsuarioProceso int null,
		MensajeError varchar(200),Documento char(20) null, Modulo char(3) null, Monto float null, Trade_Num int null,
		Order_Num smallint null, Item_Num smallint null)
create table sif_interfaces..ProductosPMI (fecharegistro date null,sessionid numeric null,
		documento char(20) null,orden char(10) null, socionegocio int null,Nsocio numeric null, 
		producto varchar(20) null,fechavoucher date null, vouchernum numeric null,trade_num int null, 
		order_num smallint null,item_num smallint null, importe float null, modulo char(3) null,
		tipotransaccion char(2) null,iva float null, moneda char(5) null, Ecodigo int null)
drop table sif_interfaces..facturasProdPMI
create table sif_interfaces..facturasProdPMI (fecharegistro date null,sessionid numeric null,
		voucher_num integer null, acct_num int null, voucher_tot_amt float null, voucher_curr_code char(8) null,
		voucher_creation_date date null, dt_fecha_vencimiento date null, dt_fecha_recibo date null,
		c_tipo_folio char(2) null, c_orden char(12) null, c_docto_proveedor varchar(40) null, 
		c_moneda char(8) null, f_monto_Enca float null, f_iva float null, i_folio integer null,
		i_anio integer null, i_empresa integer null, CodigoImpuesto char(5) null,
		c_producto char(8) null, f_volumen float null, c_unidad char(8) null, f_precio float null, f_importe float null,
		trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, booking_comp_num int null, cmdty_code varchar(10) null,
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
		SNCDid_A char(1) null, AllocSNid numeric null, avg_price float null, mensajeerror varchar(254) null)
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

<!--- Crea query de compras  --->
<cfquery datasource="preicts">
	insert #LvarDsource#facturasProdPMI (fecharegistro, sessionid,
		voucher_num, acct_num, voucher_tot_amt, voucher_curr_code, voucher_creation_date,
		dt_fecha_vencimiento, dt_fecha_recibo, c_tipo_folio, c_orden, c_docto_proveedor,
		c_moneda, f_monto_Enca, f_iva, i_folio, i_anio, i_empresa, 
		c_producto, f_volumen, c_unidad, f_precio, f_importe)
	select getdate(), #session.monitoreo.sessionid# as sessionid,
		aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, 
		case when aa.voucher_curr_code like 'MXN' then 'MXP' else aa.voucher_curr_code end as voucher_curr_code,
		aa.voucher_creation_date,case when  ab.dt_fecha_vencimiento <= dt_fecha_recibo then dt_fecha_recibo else dt_fecha_vencimiento end,
		 ab.dt_fecha_recibo, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
		ab.c_moneda, abs(ab.f_importe_total) as f_monto_Enca, abs(ab.f_iva) as f_iva,
		ab.i_folio, ab.i_anio, ab.i_empresa, 
		det.c_producto, abs(det.f_volumen) as f_volumen, det.c_unidad,
		abs(det.f_precio) as f_precio, abs(det.f_importe) as f_importe
	from voucher aa
		inner join PmiFolios ab
			inner join PmiFoliosDetailP det
			on det.i_folio = ab.i_folio
			and det.i_anio = ab.i_anio
		on ab.i_voucher = aa.voucher_num
		and ab.i_empresa_prop = aa.voucher_book_comp_num
		and (ab.c_tipo_folio = 'FA' or ab.c_tipo_folio = 'ND' or ab.c_tipo_folio = 'NC')

	<!---where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
	and aa.voucher_creation_date is not null
	and aa.voucher_creation_date between 
		<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
		and
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaF)#">
	and not EXISTS(select ac.ID from sif_interfaces..IE10 ac where ac.VoucherNo = CONVERT(varchar,aa.voucher_num)
								and EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">)
	order by ab.i_empresa, ab.c_tipo_folio, ab.c_docto_proveedor
</cfquery>

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select count(*) as noRegs from facturasProdPMI
	where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfset LvarNoRegistros = rsVerifica.noRegs>

<cfset LvarOCtipoIC = "C">
<cfset LvarBanderaErrores = false>

<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdPMI SET SNid = a2.SNid
	from #LvarDsource#facturasProdPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.i_empresa
</cfquery> 

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdPMI SET Aid = a2.Aid, UcodigoArt = a2.Ucodigo
	from #LvarDsource#facturasProdPMI a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodalterno  = a1.c_producto
</cfquery>
<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdPMI SET Mcodigo = a2.Mcodigo
	from #LvarDsource#facturasProdPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = a1.voucher_curr_code
</cfquery>
<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdPMI SET Ucodigo = a2.Ucodigo
	from #LvarDsource#facturasProdPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.c_unidad
</cfquery>

<!--- Busca factor de conversión del Artículo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#facturasProdPMI SET cuafactor = a2.CUAfactor
	from #LvarDsource#facturasProdPMI a1, ConversionUnidadesArt a2
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Aid  = case 
						when a1.Aid is null then 0
						else a1.Aid
					end
	  and rtrim(a2.Ucodigo) = rtrim(a1.c_unidad)
	  and rtrim(a1.UcodigoArt) <> rtrim(a1.c_producto)
</cfquery>

<!--- Consulta la información de costos tablas cost   --->
<cfquery datasource="preicts">
	select distinct co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num, co.cost_owner_key8 as item_num, 
	       co.cost_code, co.cost_type_code, vo.voucher_num into #LvarDsource#TempPMI
    from cost co
		inner join voucher vo 
			inner join voucher_cost vco
				on vco.voucher_num = vo.voucher_num
		on vo.voucher_num in (select voucher_num from #LvarDsource#facturasProdPMI)
	where co.cost_num = vco.cost_num
	  and co.cost_status IN ('PAID','VOUCHED')
	order by cost_amt desc
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdPMI SET trade_num = a2.trade_num, order_num = a2.order_num,
	       item_num = a2.item_num, cost_type_code = a2.cost_type_code
	from #LvarDsource#facturasProdPMI a1, #LvarDsource#TempPMI a2
	where a1.voucher_num = a2.voucher_num
	  and a1.c_producto = a2.cost_code
</cfquery>

<cfset LvarConceptoCompra = "00">

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#facturasProdPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#facturasProdPMI a1
	WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="IVA">
<!---La linea 239 se debe eliminar ya que esta condicion nunca se va a cumplir por lo tanto aunque --->
<!---exista IVA no sera tomado en cuenta ver linea 554--->
<!---	  AND s.tipo_costo = a1.cost_type_code --->
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
	  AND a1.f_iva > 0
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
		   load_compl_date = a2.load_compl_date, creation_date = a2.creation_date,
		   fecha_allocation = a2.fecha_allocation, real_port_num = a2.real_port_num
	from #LvarDsource#facturasProdPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num
	  and a1.order_num = a2.order_num
	  and a1.item_num = a2.item_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

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
	where a1.trade_num in (select trade_num from #LvarDsource#facturasProdPMI)
	and a1.order_num in (select order_num from #LvarDsource#facturasProdPMI oo where oo.trade_num=a1.trade_num)	
	and a1.item_num in (select item_num from #LvarDsource#facturasProdPMI ti where ti.trade_num=a1.trade_num
						 and ti.order_num=a1.order_num)	
	order by oo.order_type_code, a2.acct_ref_num
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdPMI SET ta_order_type_code = a2.order_type_code,
	 	   ta_trade_num = a2.trade_num, ta_order_num = a2.order_num, ta_item_num = a2.item_num,
		   ta_acct_ref_num = a2.acct_ref_num, ta_acct_num = a2.acct_num, ta_creation_date = a2.creation_date
	from #LvarDsource#facturasProdPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num_CP
	  and a1.order_num = a2.order_num_CP
	  and a1.item_num = a2.item_num_CP
</cfquery>

<cfquery datasource="sifinterfaces">
	drop table #LvarDsource#TempPMI
</cfquery> 

<cfquery datasource="preicts">
	select oo.order_type_code, a2.acct_ref_num, a2.acct_num,a2.trade_num, a2.order_num, a2.item_num,
			(select max (ate.trade_num) from #LvarDsource#facturasProdPMI ate
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
			 and ti.p_s_ind = 'S'
		inner join trade_order oo
			on oo.trade_num = a2.trade_num
			and oo.order_num = a2.order_num
	 where a1.trade_num in (select ta_trade_num from #LvarDsource#facturasProdPMI)
	 order by a1.trade_num
</cfquery>
<cfquery datasource="sifinterfaces">
	UPDATE #LvarDsource#facturasProdPMI SET tt_order_type_code = a2.order_type_code,
	 	   tt_acct_ref_num = a2.acct_ref_num, tt_acct_num = a2.acct_num
	from #LvarDsource#facturasProdPMI a1, #LvarDsource#TempPMI a2
	where a1.trade_num = a2.trade_num_CP
</cfquery>

<cfquery name="queryCompras" datasource="sifinterfaces">
	select *
	from #LvarDsource#facturasProdPMI 
	where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfset LvarCuentaFinanciera = "">
<!--- Arma la cuenta financiera    
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
</cfif>     --->

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
	<cfset vDiff = queryCompras.voucher_tot_amt - (queryCompras.f_monto_Enca + queryCompras.f_iva)>
	
	<cfif abs(vDiff) GT 10>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarTipoError = "Diferencia Montos Voucher/Factura">
	</cfif>

	<!--- Existencia del Socio de Negocio  --->
	<cfif Len(queryCompras.SNid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido: #queryCompras.i_empresa#">
	</cfif>

	<!--- Existencia del Articulo  --->
	<cfif Len(queryCompras.Aid) EQ 0>
		<cfset LvarAid = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
	<cfelse>
		<cfset LvarAid = queryCompras.Aid>
	</cfif>

	<!--- Moneda es Valida  --->
	<cfif Len(queryCompras.Mcodigo) EQ 0>
		<cfset LvarMcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
	<cfelse>
		<cfset LvarMcodigo = queryCompras.Mcodigo>
	</cfif> 

	<!--- Unidad es Valida  --->
	<cfif Len(queryCompras.Ucodigo) EQ 0>
		<cfset LvarUcodigo="0">		
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	<cfelse>
		<cfset LvarUcodigo = queryCompras.Ucodigo>
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
	<cfset LvarOrdenAlloc = "">
	<cfset LvarPorcentaje= 100>

	<cfset LvarAlm_trade_num = queryCompras.ta_trade_num>
	<cfset LvarAlm_order_num = queryCompras.ta_order_num>
	<cfset LvarAlm_item_num = queryCompras.ta_item_num>
	<cfset LvarAlm_creation_date = queryCompras.ta_creation_date>
	<cfif queryCompras.ta_order_type_code EQ 'PHYSICAL'>
		<cfset LvarOCtipoIC = "C">
		<cfset LvarSocioAlloc = #querycompras.ta_acct_num#>
	</cfif>
	<cfif queryCompras.ta_order_type_code EQ 'STORAGE'>
		<cfset LvarAlmacen = "#querycompras.ta_acct_ref_num#">
		<cfset LvarSocioAlloc = querycompras.ta_acct_num>
	</cfif>
	<cfif queryCompras.ta_order_type_code EQ 'TRANSPRT'>
		<cfset LvarTransporte = queryCompras.ta_acct_ref_num>
		<cfif queryCompras.tt_order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = queryCompras.tt_acct_num>
		</cfif>
	
		<cfif queryCompras.tt_order_type_code EQ 'STORAGE'>
			<cfset LvarAlmacen = queryCompras.tt_cct_ref_num>
			<cfset LvarSocioAlloc = queryCompras.tt_acct_num>
		</cfif>
	</cfif>

	<cfset ws_f_Importe = queryCompras.f_importe>
	<cfset ws_f_precio = queryCompras.f_precio>
	<cfset ws_c_unidad = queryCompras.c_unidad>
	<cfset ws_f_volumen = queryCompras.f_volumen>

	<!--- Conversión a unidades del Artículo --->
	<cfif "#Rtrim(queryCompras.UcodigoArt)#" NEQ "#Rtrim(queryCompras.c_unidad)#">
		<cfif len(queryCompras.cuafactor) GT 0>
			<cfset ws_f_volumen = queryCompras.cuafactor * ws_f_volumen>
			<cfif ws_f_volumen EQ 0>
				<cfset ws_f_volumen = 1>
			</cfif>
			<cfset ws_f_precio = ws_f_Importe/ws_f_volumen>
			<cfset ws_c_unidad = queryCompras.UcodigoArt>
		<cfelse>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = "Unidades diferentes, sin factor de conversión">
		</cfif>
	</cfif>

<!--- Esta rutina de IVA tendria que agregarse para manejar el IVA en Facturas de Producto Compras --->
<!--- Esta rutina supone que el IVA se tendra que indicar en el campo f_iva de PmiFolios ver liena 237 --->
	<!--- Valida código impuesto del IVA --->
	<cfset LvarCodigoImpuesto = "">
	<cfif queryCompras.f_iva GT 0>
		<cfif Len(queryCompras.CodigoImpuesto) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Código impuesto IVA no definido">
		<cfelse>
			<cfset LvarCodigoImpuesto = queryCompras.CodigoImpuesto>
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

	<cfset ws_f_volumen = abs(ws_f_volumen)>
	<cfset ws_f_importe = abs(ws_f_importe)>
	<!---Verifica que no se genere una linea de detalle con importe 0--->
	<cfif ws_f_importe EQ 0>
		<cfset LvarID = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Importe de detalle de la factura: #ws_f_importe# es cero">
	</cfif>
	<cfquery name="rsVerificaIE10" datasource="sifinterfaces">
		select count(1) as Cantidad
		from IE10
		where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and NumeroSocio = '#queryCompras.i_empresa#'
		  and Modulo = 'CP'
		  and CodigoTransacion = '#queryCompras.c_tipo_folio#'
		  and Documento = '#queryCompras.c_docto_proveedor#'
	</cfquery>
	<cfif rsVerificaIE10.Cantidad GT 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Ya se Importó el Documento">
	</cfif>
	<!--- Corrección en el cálculo de la diferencia, se aplica ahora solo a la primer linea y se valida monto 0  --->
	<!--- calcula diferencia entre el encabezado y los detalles de la factura y se lo aplica a la primer linea   --->
	<!--- en el campo f_iva se debe de indicar el impuesto y no debe haber un costo para el impuesto en la tabla --->
	<!--- cost ni en la tabla PmiFoliosDetailP --->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
		select sum(f_importe) as totaldetalles from #LvarDsource#facturasProdPMI
		where voucher_num = #queryCompras.voucher_num#
		and sessionid = #session.monitoreo.sessionid#
	</cfquery>
	<cfset ws_Total = queryCompras.f_monto_Enca <!---+ queryCompras.f_iva--->>
	<cfset vDiffFactura = ws_Total - rsVerifica.totaldetalles >
	<cfset ws_f_Importe = queryCompras.f_importe + vDiffFactura>			
	<cfif rsVerifica.totaldetalles EQ (ws_f_importe * (-1)) OR vDiffFactura EQ (ws_f_importe * (-1))	
			OR ws_f_importe EQ 0>
		<cfset LvarID = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & 
				"El monto total: #ws_Total# o uno de los detalles de la factura: #ws_f_importe# es cero">
	</cfif>

<!--- actualizar el mensaje de error  --->
	<cfquery datasource="#session.dsn#">
		UPDATE #LvarDsource#facturasProdPMI
			SET mensajeerror = case 
								when '#LvarTipoError#' = '' then mensajeerror
								else
								case when mensajeerror is null then '#LvarTipoError#'
									else mensajeerror + ', #LvarTipoError#' end
							    end
		from #LvarDsource#facturasProdPMI
		where voucher_num = #querycompras.voucher_num#
			and acct_num = #querycompras.acct_num#
			and c_tipo_folio = '#querycompras.c_tipo_folio#'
			and c_docto_proveedor = '#querycompras.c_docto_proveedor#'
			and sessionid = #session.monitoreo.sessionid#
	</cfquery>
</cfloop>
<!---<cfabort showerror="Ya acabo">--->

