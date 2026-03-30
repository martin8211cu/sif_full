<!--- Archivo    :  FacturasProductosVentas.cfm
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
<cfquery name="rsDescripcion" datasource="preicts">
	select acct_num, acct_short_name
	from account
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.CodICTS#">
</cfquery>

<!--- Crea query de ventas  --->
<cfquery name="queryVentas" datasource="preicts">
	select distinct ab.invoice, aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
		   aa.voucher_creation_date, aa.voucher_book_comp_num, aa.voucher_book_curr_code,
		   aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,
		   ab.invoiceDate, ab.dueDate, ab.invoiceType, ab.yourRefNum, 
		   (select c_moneda from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num group by c_moneda) as c_moneda,
		   (select c_unidades from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num group by c_unidades) as c_unidades,
		   (select abs(sum(a1.f_importe)) from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num and 
			a1.c_concepto = 'IVA') as f_iva
			
	into sif_interfacesser..VentasTemporal
			
	from voucher aa
		inner join PmiInvoice ab
		on ab.voucherNum = aa.voucher_num
		and (ab.invoiceType = 'G' or ab.invoiceType = 'K' or ab.invoiceType = 'p' or ab.invoiceType = 'R' or
			 ab.invoiceType = 'W' or ab.invoiceType = 'c' or ab.invoiceType = 'd' or ab.invoiceType = 'w' or ab.invoiceType = 'P')
		and upper(ab.printedInd) in ('L','T','Y')
		and ab.bookingCo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDescripcion.acct_short_name#">
		and ab.invoiceDate between
			<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
			and
			<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaF)#">
	where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.CodICTS#">
	and not EXISTS(select ac.ID from sif_interfaces..IE10 ac where ac.VoucherNo = CONVERT(varchar,aa.voucher_num) 
							and EcodigoSDC=14)
	order by aa.acct_num, ab.invoiceType, ab.invoice
</cfquery>

<cfquery name="queryVentas" datasource="sifinterfaces">
	select * from sif_interfacesser..VentasTemporal	
</cfquery>

<cfquery datasource="sifinterfaces">
	ALTER TABLE sif_interfaces..VentasTemporal add OCtipoIC char(1) null
	ALTER TABLE sif_interfaces..VentasTemporal add Almacen varchar(20) null
	ALTER TABLE sif_interfaces..VentasTemporal add Transporte varchar(20) char(5) null
	ALTER TABLE sif_interfaces..VentasTemporal add SocioAlloc numeric null
	ALTER TABLE sif_interfaces..VentasTemporal add OrdenAlloc varchar(20) null
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

<!--- procesa los registros de venta  --->	
<cfloop query="queryVentas"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- mueve el campo del iva  --->
	<cfif isnumeric(queryVentas.f_iva)>
		<cfset ws_f_iva = queryVentas.f_iva>
	<cfelse>
		<cfset ws_f_iva = 0>
	</cfif>		

	<!--- Existencia del Socio de Negocio  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select a1.Ecodigo, a1.SNcodigo, a1.SNid, a1.SNcodigoext, a1.cuentac,
			   a1.SNnombre
		from SNegocios a1
		where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a1.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryVentas.acct_num#">
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

	<!--- Suma los costos, IVA, volumen --->
	<cfset Lvaruom_code = "">
	<cfset Lvarcurr_code = "">
	<cfquery name="rsVerifica" datasource="preicts">
		select sum(co.cost_qty) as cost_qty, sum(co.cost_amt) as cost_amt,
		    cost_qty_uom_code, cost_price_curr_code  from voucher vo
			inner join voucher_cost vco
				inner join cost co
				on co.cost_num=vco.cost_num
				and co.cost_status IN ('PAID','VOUCHED')
				and co.cost_pay_rec_ind = 'R'
				and co.cost_code <> 'IVA'
			on vco.voucher_num = vo.voucher_num
		where vo.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryVentas.voucher_num#">
		group by cost_qty_uom_code, cost_price_curr_code
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarSumVol_R = rsVerifica.cost_qty>
		<cfset LvarSumImp_R = rsVerifica.cost_amt>
		<cfset Lvaruom_code = rsVerifica.cost_qty_uom_code>
		<cfset Lvarcurr_code = rsVerifica.cost_price_curr_code>
	<cfelse>
		<cfset LvarSumVol_R = 0>
		<cfset LvarSumImp_R = 0>
	</cfif>
		
	<cfquery name="rsVerifica" datasource="preicts">
		select sum(co.cost_qty) as cost_qty, sum(co.cost_amt) as cost_amt,
		    cost_qty_uom_code, cost_price_curr_code  from voucher vo
			inner join voucher_cost vco
				inner join cost co
				on co.cost_num=vco.cost_num
				and co.cost_status IN ('PAID','VOUCHED')
				and co.cost_pay_rec_ind = 'P'
				and co.cost_code <> 'IVA'
			on vco.voucher_num = vo.voucher_num
		where vo.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryVentas.voucher_num#">
		group by cost_qty_uom_code, cost_price_curr_code
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarSumVol_P = rsVerifica.cost_qty>
		<cfset LvarSumImp_P = rsVerifica.cost_amt>
		<cfset Lvaruom_code = rsVerifica.cost_qty_uom_code>
		<cfset Lvarcurr_code = rsVerifica.cost_price_curr_code>
	<cfelse>
		<cfset LvarSumVol_P = 0>
		<cfset LvarSumImp_P = 0>
	</cfif>
			
	<cfquery name="rsVerifica" datasource="preicts">
		select sum(co.cost_amt) as cost_amt from voucher vo
			inner join voucher_cost vco
				inner join cost co
				on co.cost_num=vco.cost_num
				and co.cost_status IN ('PAID','VOUCHED')
				and co.cost_pay_rec_ind = 'R'
				and co.cost_code='IVA'
			on vco.voucher_num = vo.voucher_num
		where vo.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryVentas.voucher_num#">
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarSumIva_R = rsVerifica.cost_amt>
	<cfelse>
		<cfset LvarSumIva_R = 0>
	</cfif>

	<cfquery name="rsVerifica" datasource="preicts">
		select sum(co.cost_amt) as cost_amt from voucher vo
			inner join voucher_cost vco
				inner join cost co
				on co.cost_num=vco.cost_num
				and co.cost_status IN ('PAID','VOUCHED')
				and co.cost_pay_rec_ind = 'P'
				and co.cost_code='IVA'
			on vco.voucher_num = vo.voucher_num
		where vo.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryVentas.voucher_num#">
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarSumIva_P = rsVerifica.cost_amt>
	<cfelse>
		<cfset LvarSumIva_P = 0>
	</cfif>

	<cfset ws_MontoCosto = abs(LvarSumImp_R - LvarSumImp_P + LvarSumIva_R - LvarSumIva_P)>
	<cfset ws_CantidadVolumen = abs(LvarSumVol_R - LvarSumVol_P)>
	<cfset ws_f_iva = abs(LvarSumIva_R - LvarSumIva_P)>

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

	<!--- Unidad es Valida  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Ucodigo
		from Unidades a
		where a.Ecodigo  = #session.ecodigo#
		  and a.Ucodigo = '#ws_c_unidades#'
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarUcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	</cfif> 

	<cfset LvarTrade_Num = 0>
	<cfset LvarOrder_Num = 0>
	<cfset LvarItem_Num = 0>
	<cfset LvarProducto = "">
	
	<!--- Consulta la información de costos tablas cost   --->
	<cfquery name="rsVerifica" datasource="preicts">
		select distinct co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num,
		 co.cost_owner_key8 as item_num, cost_code from cost co
			inner join voucher vo
				inner join voucher_cost vco
					on vco.voucher_num = vo.voucher_num
			on vo.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryVentas.voucher_num#">
		where co.cost_num = vco.cost_num
		  and co.cost_status IN ('PAID','VOUCHED')
	</cfquery>
	
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existen costos definidos">
	<cfelse>
		<cfset LvarTrade_Num = rsVerifica.trade_num>
		<cfset LvarOrder_Num = rsVerifica.order_num>
		<cfset LvarItem_Num = rsVerifica.item_num>
		<cfset LvarProducto = rsVerifica.cost_code>
	</cfif>

	<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
	<cfset LvarOCtipoIC = "C">
	<cfset LvarAlmacen = "">
	<cfset LvarTransporte = "">
	<cfset LvarSocioAlloc = 0>
	<cfset LvarOrdenAlloc = "">

	<cfif rsVerifica.recordcount GT 0>
		<cfquery name="rsTipoAlloc" datasource="preicts">
			select distinct oo.order_type_code, a2.trade_num, a2.acct_ref_num, a2.acct_num
			from allocation_item a1
				inner join allocation_item a2
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
			where a1.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTrade_Num#">
			   and a1.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#LvarOrder_Num#">
			   and a1.item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#LvarItem_Num#">
			order by oo.order_type_code, a2.acct_ref_num
		</cfquery>
		
		<cfif rsTipoAlloc.recordcount GT 0>
			<cfif rsTipoAlloc.order_type_code EQ 'PHYSICAL'>
				<cfset LvarOCtipoIC = "C">
				<cfset LvarSocioAlloc = rsTipoAlloc.acct_num>
				<cfset LvarOrdenAlloc = rsTipoAlloc.acct_ref_num>
				<cfset LvarTransporte = rsTipoAlloc.acct_ref_num>
			</cfif>
			<cfif rsTipoAlloc.order_type_code EQ 'STORAGE'>
				<cfset LvarAlmacen = rsTipoAlloc.acct_ref_num>
				<cfset LvarSocioAlloc = rsTipoAlloc.acct_num>
				<cfset LvarOrdenAlloc = rsTipoAlloc.acct_ref_num>
				<cfset LvarTransporte = rsTipoAlloc.acct_ref_num>
			<cfelseif rsTipoAlloc.order_type_code EQ 'TRANSPRT'>
				<cfset LvarTransporte = rsTipoAlloc.acct_ref_num>
				<cfquery name="rsTipo" datasource="preicts">
					select distinct oo.order_type_code, a2.acct_ref_num, a2.acct_num, ti.cmdty_code
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
						 where a1.trade_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoAlloc.trade_num#">
						 order by oo.order_type_code
				</cfquery>
				<cfif rsTipo.recordcount EQ 1>
					<cfif rsTipo.order_type_code EQ 'PHYSICAL'>
						<cfset LvarOCtipoIC = "C">
						<cfset LvarSocioAlloc = rsTipo.acct_num>
						<cfset LvarOrdenAlloc = rsTipo.acct_ref_num>
					</cfif>
					<cfif rsTipo.order_type_code EQ 'STORAGE'>
						<cfset LvarAlmacen = rsTipo.acct_ref_num>
						<cfset LvarSocioAlloc = rsTipo.acct_num>
						<cfset LvarOrdenAlloc = rsTipo.acct_ref_num>
					</cfif>
				</cfif>
				<cfif rsTipo.recordcount GT 1>
					<!--- Determinar si hay blending --->
					<cfquery name="rsBlend" dbtype="query">
						select * from rsTipo where cmdty_code = '#LvarProducto#'
					</cfquery>
					<!--- si hay blending  --->
					<cfif rsblend.recordcount EQ 0>
						<cfquery name="rsAlmac" dbtype="query">
							select * from rsTipo where order_type_code = 'STORAGE'
						</cfquery>
						<cfif rsAlmac.recordcount GT 0>
							<cfset LvarAlmacen = rsAlmac.acct_ref_num>
							<cfset LvarSocioAlloc = rsAlmac.acct_num>
							<cfset LvarOrdenAlloc = rsAlmac.acct_ref_num>
						<cfelse>
							<cfquery name="rsProd" dbtype="query">
								select * from rsTipo where order_type_code = 'PHYSICAL'
							</cfquery>
							<cfif rsProd.recordcount GT 0>
								<cfset LvarOCtipoIC = "C">
								<cfset LvarSocioAlloc = rsProd.acct_num>
								<cfset LvarOrdenAlloc = rsProd.acct_ref_num>
							</cfif>						
						</cfif>
					</cfif>
					<!--- si no hay blending  --->
					<cfif rsblend.recordcount GT 0>
						<cfquery name="rsAlmac" dbtype="query">
							select * from rsTipo where order_type_code = 'STORAGE' and cmdty_code = '#LvarProducto#'
						</cfquery>
						<cfif rsAlmac.recordcount GT 0>
							<cfset LvarAlmacen = rsAlmac.acct_ref_num>
							<cfset LvarSocioAlloc = rsAlmac.acct_num>
							<cfset LvarOrdenAlloc = rsAlmac.acct_ref_num>
						<cfelse>
							<cfquery name="rsProd" dbtype="query">
								select * from rsTipo where order_type_code = 'PHYSICAL' and cmdty_code = '#LvarProducto#'
							</cfquery>
							<cfif rsProd.recordcount GT 0>
								<cfset LvarOCtipoIC = "C">
								<cfset LvarSocioAlloc = rsProd.acct_num>
								<cfset LvarOrdenAlloc = rsProd.acct_ref_num>
							</cfif>						
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>    
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
		<cfset LvarTipoError = LvarTipoError & "No existe orden de allocation">
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

	<!--- Existencia del Articulo  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Aid, Ucodigo
		from Articulos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarProducto#">
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarAid = 0>
		<cfset LvarUcodigoArt = "">
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
	<cfelse>
		<cfset LvarAid = rsVerifica.Aid>
		<cfset LvarUcodigoArt = rsVerifica.Ucodigo>
	</cfif>

	<!--- Moneda es Valida  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Mcodigo
		from Monedas a
		where a.Ecodigo  = #session.ecodigo#
		  and a.Miso4217 = '#queryVentas.voucher_curr_code#'
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
	
	<!--- Determina el tipo de venta  --->
	<cfif len(LvarAlmacen)>
		<cfset LvarTipoVenta= "#Lvaralmacen#">    <!--- ES UN ALMACEN  --->
	<cfelse>
		<cfif LvarAllocSNid GT 0>
			<cfquery name="rsClasif" datasource="#Session.Dsn#">
				select SNCDid
				from SNClasificacionSN
				where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">
				  and SNCDid = 3
			</cfquery>
			<cfif rsClasif.recordcount GT 0>
				<cfset LvarTipoVenta= "002">    <!--- ES INTERCOMPAÑIA  --->
			<cfelse>
				<cfquery name="rsClasif" datasource="#Session.Dsn#">
					select SNCDid
					from SNClasificacionSN
					where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">
					  and SNCDid = 4
				</cfquery>
				<cfif rsClasif.recordcount GT 0>
					<cfquery name="rsClasif" datasource="#Session.Dsn#">
						select SNCDid
						from SNClasificacionSN
						where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">
						  and SNCDid = 5
					</cfquery>
					<cfif rsClasif.recordcount GT 0>
						<cfset LvarTipoVenta= "004">    <!--- ES TERCERO NACIONAL  --->
					<cfelse>
						<cfquery name="rsClasif" datasource="#Session.Dsn#">
							select SNCDid
							from SNClasificacionSN
							where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">
							  and SNCDid = 6
						</cfquery>
						<cfif rsClasif.recordcount GT 0>
							<cfquery name="rsClasif" datasource="#Session.Dsn#">
								select SNCDid
								from SNClasificacionSN
								where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAllocSNid#">
								  and SNCDid = 3
							</cfquery>
							<cfif rsClasif.recordcount GT 0>
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
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#LvarProducto#">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="TAX">
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
