<!--- Archivo    :  ConsFacturasVentas.cfm
	  --->
<cfsetting requesttimeout="900">

<cfquery datasource="sifinterfaces">
	if Exists(select name from sysobjects where name = 'ProductosPMI')
		drop table sif_interfaces..ProductosPMI
	if Exists(select name from sysobjects where name = 'ErroresPMI')
		drop table sif_interfaces..ErroresPMI
</cfquery>  

<cfquery datasource="sifinterfaces">
	create table sif_interfaces..ErroresPMI (Ecodigo int null, FechaProceso date null, FechaDocumento date null,
			TipoDocumento char(20) null, UsuarioProceso int null, MensajeError varchar(200),
			Documento char(20) null, Modulo char(3) null, Monto float null, Trade_Num int null,
			Order_Num smallint null, Item_Num smallint null)
	create table sif_interfaces..ProductosPMI (documento char(20) null, orden char(10) null, socionegocio int null,
			Nsocio numeric null, producto varchar(20) null, fechavoucher date null, vouchernum numeric null,
			trade_num int null, order_num smallint null, item_num smallint null, importe float null, modulo char(3) null,
			tipotransaccion char(2) null, iva float null, moneda char(5) null, Ecodigo int null)
</cfquery> 

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

<cfquery name="rsDescripcion" datasource="preicts">
	select acct_num, acct_short_name
	from account
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.CodICTS#">
</cfquery>

<!--- Crea query de compras  --->
<cfquery name="queryVentas" datasource="preicts">
		select distinct ab.invoice, aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
			   aa.voucher_creation_date, aa.voucher_book_comp_num, aa.voucher_book_curr_code,
			   aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,
			   ab.invoiceDate, ab.dueDate, ab.invoiceType, ab.yourRefNum, 
			   (select abs(sum(a1.f_vol_nvo)) from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num) as f_vol_nvo,
			   (select abs(avg(a1.f_precio_nvo)) from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num) as f_precio_nvo,
			   (select abs(sum(a1.f_importe)) from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num) as f_importe,
			   (select c_moneda from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num group by c_moneda) as c_moneda,
			   (select c_unidades from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num group by c_unidades) as c_unidades,
			   (select abs(sum(a1.f_importe)) from PmiInvoiceDetail a1 where a1.voucherNum = aa.voucher_num and 
			    a1.c_concepto = 'IVA') as f_iva
		from voucher aa
			inner join PmiInvoice ab
			on ab.voucherNum = aa.voucher_num
			and (ab.invoiceType = 'G' or ab.invoiceType = 'K' or ab.invoiceType = 'p' or ab.invoiceType = 'R' or
	  			 ab.invoiceType = 'W' or ab.invoiceType = 'c' or ab.invoiceType = 'd' or ab.invoiceType = 'w' or 
				 ab.invoiceType = 'P')
			and ab.bookingCo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDescripcion.acct_short_name#">
		where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.CodICTS#">
		and aa.voucher_creation_date between 
		<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
		and
		<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaF)#">
    	order by aa.acct_num, ab.invoiceType, ab.invoice
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">
<!--- procesa los registros de compra  --->	
<cfloop query="queryVentas"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- valida que el monto del voucher sea igual al monto de la factura  --->
	<cfif isnumeric(queryVentas.f_iva)>
		<cfset ws_f_iva = queryVentas.f_iva>
	<cfelse>
		<cfset ws_f_iva = 0>
	</cfif>		
	<cfset vDiff = abs(queryVentas.voucher_tot_amt - (queryVentas.f_importe - ws_f_iva))>
	<cfif vDiff GT 10>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarTipoError = "Diferencia Montos Voucher/Factura">
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

	<cfset ws_f_Importe = queryVentas.f_importe - ws_f_iva>
	<cfset ws_f_precio_nvo = queryVentas.f_precio_nvo>
	<cfset ws_c_unidades = queryVentas.c_unidades>
	<cfset ws_f_vol_nvo = queryVentas.f_vol_nvo>
	<cfset ws_c_moneda = queryVentas.c_moneda>

	<!--- Unidad es Valida  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Ucodigo
		from Unidades a
		where a.Ecodigo  = #session.ecodigo#
		  and a.Ucodigo = '#ws_c_unidades#'
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarMcodigo = 0>
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
		select co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num,
		 co.cost_owner_key8 as item_num, cost_code from cost co
			inner join voucher vo
				inner join voucher_cost vco
					on vco.voucher_num = vo.voucher_num
			on vo.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryVentas.voucher_num#">
		where co.cost_num = vco.cost_num
		  and co.cost_status IN ('PAID','VOUCHED')
		group by co.cost_owner_key6, co.cost_owner_key7, co.cost_owner_key8, cost_code
		order by cost_amt desc
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
								 and ti.p_s_ind = 'P'
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

	<!--- Existencia del Articulo  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Aid
		from Articulos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarProducto#">
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
	
	<!--- Determina el tipo de venta  --->
	<cfif len(LvarAlmacen)>
		<cfset LvarTipoVenta= "#Lvaralmacen#">    <!--- ES UN ALMACEN  --->
	<cfelse>
		<cfif LvarSocioAlloc GT 0>
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
								where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSocioAlloc#">
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

	<cfif len(LvarTipoError) GT 0>
		<!--- Graba error en tabla temporal ErroresPMI  --->
		<cfquery datasource="preicts">
			insert sif_interfaces..ErroresPMI (Ecodigo,FechaProceso,FechaDocumento,TipoDocumento,
				UsuarioProceso,MensajeError,Documento,Modulo,Monto,Trade_Num,Order_Num,Item_Num)
			values (#session.Ecodigo#, '#queryVentas.voucher_creation_date#', '#queryVentas.invoiceDate#',
			        'Voucher-Factura', #session.Usucodigo#, '#LvarTipoError#', '#toString(queryVentas.voucher_num)#',
					'CXC', #queryVentas.f_importe#, #rsTrade.Trade_Num#, #rsTrade.Order_Num#,
					#rsTrade.Item_Num#)
		</cfquery> 
	<cfelse>	
		<!--- se inserta el registro en tabla temporal ProductoPMI   --->
		<cfquery datasource="preicts">
			insert sif_interfaces..ProductosPMI (documento,orden,socionegocio,Nsocio,
				producto,fechavoucher,vouchernum,trade_num,order_num,item_num,importe,modulo,
				tipotransaccion,iva,moneda,Ecodigo)
			values ('#queryVentas.invoice#', '#queryVentas.yourRefNum#', #queryVentas.acct_num#,
			        #LvarSNid#, '#LvarProducto#', '#queryVentas.voucher_creation_date#',
					#queryVentas.voucher_num#, #rsTrade.Trade_Num#, #rsTrade.Order_Num#,
					#rsTrade.Item_Num#, #queryVentas.f_importe#, 'CXC', '#cC_Tipo_Invoice#',
					0, '#queryVentas.c_moneda#', #session.Ecodigo#)
		</cfquery> 
	</cfif> 

</cfloop>
