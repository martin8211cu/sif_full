<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">

<cfquery datasource="sifinterfaces">
	if Exists (select name from sif_interfaces..sysobjects where name like 'TETrabajo%')
		drop table sif_interfaces..TETrabajo
	if Exists (select name from sif_interfaces..sysobjects where name like 'TECompras%')
		drop table sif_interfaces..TECompras
</cfquery> 

<cfquery name="rsEmpresa" datasource="sifinterfaces">
	select Ecodigo, CodICTS
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<!--- Crea query de compras  --->
<cfquery datasource="preicts">
	select aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
		aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name, aa.voucher_creation_date,
		ab.dt_fecha_vencimiento, ab.dt_fecha_recibo, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
		ab.c_moneda, abs(ab.f_importe_total) as f_monto_Enca, abs(ab.f_iva) as f_iva,
		ab.i_folio, ab.i_anio, ab.i_empresa, 
		det.c_producto, det.dt_bldate, abs(det.f_volumen) as f_volumen, det.c_unidad,
		abs(det.f_precio) as f_precio, abs(det.f_importe) as f_importe, 'C' as OCtipoIC, 'N' as Errores
	into sif_interfaces..TECompras
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
	and not EXISTS(select ac.ID from sif_interfaces..IE10 ac where ac.VoucherNo = CONVERT(varchar,aa.voucher_num)
								and EcodigoSDC=14)
	order by ab.i_empresa, ab.c_tipo_folio, ab.c_docto_proveedor
</cfquery>

<cfquery datasource="sifinterfaces">
	ALTER TABLE sif_interfaces..TECompras add SNid numeric null
	ALTER TABLE sif_interfaces..TECompras add Aid numeric null
	ALTER TABLE sif_interfaces..TECompras add UcodigoArt char(5) null
	ALTER TABLE sif_interfaces..TECompras add Mcodigo numeric null
	ALTER TABLE sif_interfaces..TECompras add Ucodigo char(5) null
	ALTER TABLE sif_interfaces..TECompras add subconcepto integer null
	ALTER TABLE sif_interfaces..TECompras add CodigoImpuesto char(5) null
	ALTER TABLE sif_interfaces..TECompras add cost_code varchar(8) null
	ALTER TABLE sif_interfaces..TECompras add cost_type_code varchar(8) null
	ALTER TABLE sif_interfaces..TECompras add trade_num integer null
	ALTER TABLE sif_interfaces..TECompras add order_num smallint null
	ALTER TABLE sif_interfaces..TECompras add item_num smallint null
</cfquery>
<cfquery name="rsVerifica" datasource="sifinterfaces">
	Select count(*) as noRegs from sif_interfaces..TECompras
</cfquery>

<cfset LvarNoRegistros = rsVerifica.noRegs>

<!---
<cfquery datasource="preicts">
	create clustered index Vocher_Num_INDEX 
	on sif_interfaces..TECompras(voucher_num)
</cfquery> 
--->

<cfset LvarOCtipoIC = "C">
<cfset LvarBanderaErrores = false>
<cf_htmlreportsheaders
	title="Importacion de Compras de ICTS" 
	filename="ImportaCompras-#Session.Usucodigo#.xls" 
	ira="FacturasProductosParam.cfm">

<cf_templatecss>

<cfoutput>
<table width="100%" border="1">
	<tr><td colspan="9" align="center"><strong>Reporte de Errores</strong></td>
	<tr><td colspan="9" align="center"><strong>Proceso de Carga de Compra de Producto</strong></td>
	<tr><td colspan="9" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="9">&nbsp;</td></tr>
	<tr><td colspan="9">Registros: #LvarNoRegistros# </td></tr>
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
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfaces..TECompras SET SNid = a2.SNid
	from sif_interfaces..TECompras a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.i_empresa
</cfquery> 

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfaces..TECompras SET Aid = a2.Aid, UcodigoArt = a2.Ucodigo
	from sif_interfaces..TECompras a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodalterno  = a1.c_producto
</cfquery>
<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfaces..TECompras SET Mcodigo = a2.Mcodigo
	from sif_interfaces..TECompras a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = a1.voucher_curr_code
</cfquery>
<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfaces..TECompras SET Ucodigo = a2.Ucodigo
	from sif_interfaces..TECompras a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.c_unidad
</cfquery>

<!--- Consulta la información de costos tablas cost   --->
<cfquery datasource="preicts">
	select distinct co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num, co.cost_owner_key8 as item_num, 
	       co.cost_code, co.cost_type_code, vo.voucher_num into sif_interfaces..TETrabajo
    from cost co
		inner join voucher vo 
			inner join voucher_cost vco
				on vco.voucher_num = vo.voucher_num
		on vo.voucher_num in (select voucher_num from sif_interfaces..TECompras)
	where co.cost_num = vco.cost_num
	  and co.cost_status IN ('PAID','VOUCHED')
	order by cost_amt desc
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE sif_interfaces..TECompras SET trade_num = a2.trade_num, order_num = a2.order_num,
	       item_num = a2.item_num, cost_type_code = a2.cost_type_code
	from sif_interfaces..TECompras a1, sif_interfaces..TETrabajo a2
	where a1.voucher_num = a2.voucher_num
	  and a1.c_producto = a2.cost_code
</cfquery>

<cfset LvarConceptoCompra = "00">

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE sif_interfaces..TECompras SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, sif_interfaces..TECompras a1
	WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="TAX">
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
</cfquery>

<!--- código de impuesto  --->
<cfquery datasource="#session.dsn#">
	UPDATE sif_interfaces..TECompras SET CodigoImpuesto = a2.cuentac
	from sif_interfaces..TECompras a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
</cfquery>

<cfquery datasource="sifinterfaces">
	ALTER TABLE sif_interfaces..TECompras add title_tran_date date null
	ALTER TABLE sif_interfaces..TECompras add alloc_type_code char(1) null
	ALTER TABLE sif_interfaces..TECompras add del_term_code char(8) null
	ALTER TABLE sif_interfaces..TECompras add bl_ticket_num varchar(15) null
	ALTER TABLE sif_interfaces..TECompras add bl_date date null
	ALTER TABLE sif_interfaces..TECompras add transportation varchar(40) null
	ALTER TABLE sif_interfaces..TECompras add load_compl_date date null
	ALTER TABLE sif_interfaces..TECompras add nor_date date null
	ALTER TABLE sif_interfaces..TECompras add trade_creation_date date null
	ALTER TABLE sif_interfaces..TECompras add fecha_allocation date null
	ALTER TABLE sif_interfaces..TECompras add real_port_num int null
</cfquery>

<cfquery datasource="sifinterfaces">
	drop table sif_interfaces..TETrabajo
</cfquery> 

<!--- Consulta información del Trade, trade_order, trade_item   --->
<cfquery datasource="preicts">
	select ai.title_tran_date, ai.trade_num, ai.order_num, ai.item_num,
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, 
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, a6.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num into sif_interfaces..TETrabajo
	from sif_interfaces..TECompras ate, trade_item ti
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
	UPDATE sif_interfaces..TECompras SET title_tran_date = a2.title_tran_date,
	 	   alloc_type_code = a2.alloc_type_code, del_term_code = a2.del_term_code, 
		   bl_ticket_num = a2.bl_ticket_num, bl_date = a2.bl_date, transportation = a2.transportation,
		   load_compl_date = a2.load_compl_date, trade_creation_date = a2.creation_date,
		   fecha_allocation = a2.fecha_allocation, real_port_num = a2.real_port_num
	from sif_interfaces..TECompras a1, sif_interfaces..TETrabajo a2
	where a1.trade_num = a2.trade_num
	  and a1.order_num = a2.order_num
	  and a1.item_num = a2.item_num
</cfquery>
<cfquery datasource="sifinterfaces">
	drop table sif_interfaces..TETrabajo
</cfquery> 

<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
<cfquery datasource="sifinterfaces">
	ALTER TABLE sif_interfaces..TECompras add ta_order_type_code varchar(8) null
	ALTER TABLE sif_interfaces..TECompras add ta_trade_num int null
	ALTER TABLE sif_interfaces..TECompras add ta_acct_ref_num char(10) null
	ALTER TABLE sif_interfaces..TECompras add ta_acct_num int null
</cfquery>
<cfquery datasource="preicts">
	select distinct oo.order_type_code, a2.trade_num, a2.order_num, a2.item_num, a2.acct_ref_num, a2.acct_num,
                 a1.trade_num as trade_num_CP, a1.order_num as order_num_CP, a1.item_num as item_num_CP
			into sif_interfaces..TETrabajo
	from allocation_item a1
		inner join allocation_item a2
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
			where a1.trade_num in (select trade_num from sif_interfaces..TECompras)
			and a1.order_num in (select order_num from sif_interfaces..TECompras oo where oo.trade_num=a1.trade_num)	
			and a1.item_num in (select item_num from sif_interfaces..TECompras ti where ti.trade_num=a1.trade_num
								 and ti.order_num=a1.order_num)	
	order by oo.order_type_code, a2.acct_ref_num
</cfquery>

<cfquery datasource="sifinterfaces">
	UPDATE sif_interfaces..TECompras SET ta_order_type_code = a2.order_type_code,
	 	   ta_trade_num = a2.trade_num, ta_acct_ref_num = a2.acct_ref_num, 
		   ta_acct_num = a2.acct_num
	from sif_interfaces..TECompras a1, sif_interfaces..TETrabajo a2
	where a1.trade_num = a2.trade_num_CP
	  and a1.order_num = a2.order_num_CP
	  and a1.item_num = a2.item_num_CP
</cfquery>

<cfquery datasource="sifinterfaces">
	drop table sif_interfaces..TETrabajo
</cfquery> 

<cfquery datasource="sifinterfaces">
	ALTER TABLE sif_interfaces..TECompras add tt_order_type_code char(8) null
	ALTER TABLE sif_interfaces..TECompras add tt_acct_ref_num char(10) null
	ALTER TABLE sif_interfaces..TECompras add tt_acct_num int null

<!---	ALTER TABLE sif_interfaces..TECompras add actual_gross_qty float null
	ALTER TABLE sif_interfaces..TECompras add actual_gross_uom_code char(4) null
	ALTER TABLE sif_interfaces..TECompras add cmdty_code varchar(8) null   --->

</cfquery>
<cfquery datasource="preicts">
	select oo.order_type_code, a2.acct_ref_num, a2.acct_num,a2.trade_num, a2.order_num, a2.item_num,
			(select max (ate.trade_num) from sif_interfaces..TECompras ate
			 where ate.ta_trade_num = a1.trade_num) as trade_num_CP
		 into sif_interfaces..TETrabajo
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
	 where a1.trade_num in (select ta_trade_num from sif_interfaces..TECompras)
	 order by a1.trade_num
</cfquery>
<cfquery datasource="sifinterfaces">
	UPDATE sif_interfaces..TECompras SET tt_order_type_code = a2.order_type_code,
	 	   tt_acct_ref_num = a2.acct_ref_num, tt_acct_num = a2.acct_num
	from sif_interfaces..TECompras a1, sif_interfaces..TETrabajo a2
	where a1.trade_num = a2.trade_num_CP
</cfquery>

<cfquery name="queryCompras" datasource="sifinterfaces">
	select *
	from sif_interfaces..TECompras
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
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
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
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select Ucodigo, CUAfactor
			from ConversionUnidadesArt
			where Ecodigo  = #session.ecodigo#
			  and Aid = #LvarAid#
			  and Ucodigo = '#queryCompras.c_unidad#'
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existe el Factor de conversión:#Rtrim(queryCompras.c_unidad)#">
		<cfelse>
			<cfset ws_f_volumen = rsVerifica.CUAfactor * ws_f_volumen>
			<cfif ws_f_volumen EQ 0>
				<cfset ws_f_volumen = 1>
			</cfif>
			<cfset ws_f_precio = ws_f_Importe/ws_f_volumen>
			<cfset ws_c_unidad = queryCompras.UcodigoArt>
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

	<cfset LvarID = 0>
	
	<cftransaction>
	<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->
	<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
	<cfif LvarBanderaErrores_registro EQ false>
		<!---  Si el Origen de la Orden de Compra es un Almacén, se graba una Orden  de Inventario   --->		
		<cfif Len(LvarAlmacen) GT 0>
			<!--- Consulta información del Trade, trade_order, trade_item de la Orden de Almacen   --->
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
				where ti.trade_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAlm_trade_num#">
				   and ti.order_num= <cfqueryparam cfsqltype="cf_sql_smallint" value="#LvarAlm_order_num#">
				   and ti.item_num= <cfqueryparam cfsqltype="cf_sql_smallint" value="#LvarAlm_item_num#">
			</cfquery>
		
			<cfquery name="rsVerifica" datasource="#Session.Dsn#">
				select OCid
				from OCordenComercial
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarAlmacen#">
			</cfquery>
			
			<cfif rsVerifica.recordcount EQ 0>
				<cfset vOCid = 0>
			<cfelse>
				<cfset vOCid = rsVerifica.OCid>
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
						'D', 'I', #session.Ecodigo#,
						 #queryCompras.SNid#, '#LvarAlmacen#',
						 <cfif isdate(rsTrade.creation_date)>
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.creation_date#">,
						 <cfelse>
							null,
						 </cfif>
						 #LvarMcodigo#,
						 null,
						 'A','CP',
						 '#rsTrade.del_term_code#',
						 <cfif isnumeric(LvarAlm_trade_num)>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_trade_num#">,
						 <cfelse>
							null,
						 </cfif>
						 <cfif isnumeric(LvarAlm_order_num)>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_order_num#">,
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
				<cfif queryCompras.c_tipo_folio EQ "NC">
					<cfset ws_f_volumen = ws_f_volumen * -1>
					<cfset ws_f_importe = ws_f_importe * -1>
				</cfif>
				<cfquery name="query" datasource="#Session.Dsn#">
					insert INTO OCordenProducto
						(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
						 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
					values (
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
					  <cfqueryparam cfsqltype="cf_sql_smallint" value=1>,
					  <cfqueryparam cfsqltype="cf_sql_char" value="#ws_c_unidad#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					  <cfqueryparam cfsqltype="cf_sql_float" value="#ws_f_volumen#">,
					  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">,
					  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_importe,"9.99")#">,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value=0>,
					  null,
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCuentaFinanciera#">,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
				</cfquery>
			<cfelse>
				<cfif queryCompras.c_tipo_folio EQ "NC">
					<cfset LvarCantidad = (rsVerifica.OCPcantidad + (ws_f_volumen * -1))>
					<cfif LvarCantidad EQ 0>
						<cfset LvarCantidad = 1>
					</cfif>
					<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + (ws_f_importe)) / abs(LvarCantidad)>
					<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + (ws_f_importe * -1)>
				<cfelse>
					<cfset LvarCantidad = (rsVerifica.OCPcantidad + ws_f_volumen)>
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
		</cfif>
	</cfif>
	</cftransaction>
		<!--- FIN SECCION ORDENES COMERCIALES  --->

	<cfif isdefined("form.MostrarTodo") or len(LvarTipoError)>
		<cfif LvarTipoError EQ "Ya se Importó el Documento">
		<cfelse>
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
				<td align="right">#numberformat(ws_f_volumen, ",0.00")#</td>
				<td align="right">#numberformat(queryCompras.f_monto_Enca,",0.00")#</td>
				<td align="right">#numberformat(queryCompras.voucher_tot_amt,",0.00")#</td>
			</tr>
			</cfoutput>
		</cfif>
	</cfif>
</cfloop>

<!--- Inclusión de movimiento en cola de proceso --->

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
