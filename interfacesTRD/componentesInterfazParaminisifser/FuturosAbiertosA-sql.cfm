<!--- Archivo    :  futurosabiertosA-sql.cfm
	  --->
	  
<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>

<cfset session.FechaFolio = "#right(form.FechaI,4)##mid(form.FechaI,4,2)#">

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

<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#futurosabiertosPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_IE10 where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_ID10 where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfaces..futurosabiertosPMI (fecharegistro date null,sessionid numeric null,
		trade_num integer null, order_num smallint null, item_num smallint null, Documento char(20) null,
		Modulo char(10) null,
		p_s_ind char(1) null, expiration_date date null, clr_brkr_num integer null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null,
		cmdty_code varchar(8) null, contr_date date null, mensajeerror varchar(200) null,
		order_type_code varchar(8) null, unrealized_profits_detail_num integer null,
		cost_num integer null, cost_code varchar(8) null, cost_pay_rec_ind char(1) null, port_num integer null,
		cost_price_curr_code varchar(8) null, cost_price_uom_code char(4) null, cost_amt float null,
		creation_date date null, market_day date null, cost_eff_date date null, cost_due_date date null, contr_qty float null,
		fill_num integer null, total_fill_qty float null, mtm_pl float null, currency_code char(8) null,
		SNid numeric null, Aid numeric null, UcodigoArt char(5) null, Mcodigo numeric null, Ucodigo char(5) null,
		subconcepto integer null, CodigoConcepto char(5) null, cost_type_code varchar(8) null)
--->

<!--- Crea query de futuros abiertos  --->
<cfquery datasource="preicts">
	insert #LvarDsource#futurosabiertosPMI (fecharegistro, sessionid, 
	    trade_num, order_num, item_num, acct_ref_num, acct_num, booking_comp_num, cmdty_code,
		contr_date, port_num, p_s_ind, expiration_date, contr_qty, fill_num, total_fill_qty,
		mtm_pl, currency_code, creation_date, market_day, unrealized_profits_detail_num)
	select getdate(), #session.monitoreo.sessionid# as sessionid, 
		det.trade_num, det.order_num, det.item_num, tr.acct_ref_num, rp.clr_brkr_num, rp.owner_num,
		det.cmdty_code, det.contr_date, det.port_num, det.p_s_ind, det.expiration_date, 
		det.contr_qty, det.fill_num, det.total_fill_qty, det.mtm_pl, rp.currency_code,
		rp.creation_date, rp.market_day, det.unrealized_profits_detail_num
	from pmi_unrealized_profits rp
 	 	inner join pmi_unrealized_profits_detail det
			inner join trade_order oo
				inner join trade tr
				on tr.trade_num = oo.trade_num
			on oo.trade_num = det.trade_num
			and oo.order_num = det.order_num
		on det.unrealized_profits_num = rp.unrealized_profits_num
	where rp.market_day = <cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#">
	and (rp.market_day IS NOT null)
	and rp.owner_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
	and det.mtm_pl <> 0
	and rp.unrealized_profits_amount <> 0
	order by rp.creation_date
</cfquery>

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">
<cfset ArregloProductos = ArrayNew(1)>

<!--- procesa los registros abiertos de futuros --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#futurosabiertosPMI SET SNid = a2.SNid
	from #LvarDsource#futurosabiertosPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
</cfquery> 

<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#futurosabiertosPMI SET Mcodigo = a2.Mcodigo
	from #LvarDsource#futurosabiertosPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = case 
	  						when a1.currency_code = 'MXN' then 'MXP'
						 	else substring(a1.currency_code,1,3)
						 end
</cfquery>

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#futurosabiertosPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#futurosabiertosPMI a1
	WHERE s.costo_id = a1.cost_code
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id
	  AND sb.subconcepto_id = r.subconcepto_id
</cfquery>

<!--- código de Concepto  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#futurosabiertosPMI SET CodigoConcepto = a2.cuentac
	from #LvarDsource#futurosabiertosPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
</cfquery>

<cfquery name="rsFuturos" datasource="sifinterfaces">
	select *
	from  #LvarDsource#futurosabiertosPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfset ConseIE10 = 0>
<cfloop query="rsFuturos"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- verifica que no existe en EContablesImportacion  --->
	<cfset ws_key = "#rsFuturos.trade_num#FU_A#rsFuturos.fill_num##session.FechaFolio#">
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Ecodigo from EContablesImportacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Edocbase = <cfqueryparam cfsqltype="cf_sql_char" value="#ws_key#">
		
		union
		
		select Ecodigo from EContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Edocbase = <cfqueryparam cfsqltype="cf_sql_char" value="#ws_key#">
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Registro ya procesado">
	</cfif>

	<!--- Existencia del Socio de Negocio  --->
	<cfif Len(rsFuturos.SNid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
	</cfif>

	<!--- Moneda es Valida  --->
	<cfif Len(rsFuturos.Mcodigo) EQ 0>
		<cfset LvarMcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
	<cfelse>
		<cfset LvarMcodigo = rsFuturos.Mcodigo>
	</cfif> 

	<!--- portnum es valido  --->
	<cfif Len(rsFuturos.port_num) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No. de Portafolio no existe">
	</cfif>

	<!--- validar Moneda Local  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select emp.Mcodigo from Empresas emp
			inner join Monedas mon
			on mon.Mcodigo = emp.Mcodigo
			and mon.Ecodigo = emp.Ecodigo
		where emp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarMonedaLocal = rsVerifica.Mcodigo>
	<cfelse>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existe la moneda Local">
	</cfif>

	<!--- validar Tipo de cambio  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select * from Empresas emp
			inner join Htipocambio tca
			on tca.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFuturos.Mcodigo#">
			and tca.Ecodigo = emp.Ecodigo
			and tca.Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#rsFuturos.market_day#"> 
		where emp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarTCventa = rsVerifica.TCventa>
	<cfelse>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existe el tipo de cambio">
	</cfif>


	<!--- crear folio de futuros abiertos    --->
	<cfset ws_folio = "#rsFuturos.trade_num#FU_A#rsFuturos.fill_num##session.FechaFolio#">
	<cfif rsFuturos.mtm_pl GT 0>
		<cfset ws_tipo_modulo = "Ganancia">
		<cfset Lvarp_s_ind = 'S'>
	<cfelse>	
		<cfset ws_tipo_modulo = "Pérdida">
		<cfset Lvarp_s_ind = 'P'>
	</cfif>
	
	<cfset ws_tipo_transaccion = "FC">

	<!--- validar cuenta financiera de socio de negocio    --->	
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select SNcuentacxp, SNcuentacxc from SNegocios
		where Ecodigo = #session.ecodigo#
		  and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFuturos.SNid#">
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfif ws_tipo_modulo EQ 'Ganancia'>
			<cfset ws_Ccuenta = rsVerifica.SNcuentacxc>
			
		<cfelse>
			<cfset ws_Ccuenta = rsVerifica.SNcuentacxp>
		</cfif>
		
		<cfif not isnumeric(ws_Ccuenta)>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Cuenta (cxc/cxp) no válida Socio Negocios:#rsFuturos.SNid#">
		<cfelse>
			<cfquery name="rsVerifica" datasource="#session.dsn#">
				select Cformato from CContables
				where Ecodigo = #session.ecodigo#
				  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_Ccuenta#">
			</cfquery>
			<cfif rsVerifica.recordcount GT 0 and len(rsVerifica.Cformato) GT 0>
				<cfset ws_cuentaxcobrar = rsVerifica.Cformato>
			<cfelse>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & 
						"No existe la cuenta por cobrar del socio #rsFuturos.SNid#">
			</cfif>
		</cfif>
	</cfif>

	<cfif Len(rsFuturos.port_num) GT 0>
		<cfset ArrayClear(ArregloProductos)>
		<!--- Distribución de Costos   --->
		<cfquery name="rsProductos" datasource="preicts">
			select distinct ti.cmdty_code, tr.acct_ref_num, ti.p_s_ind, oo.order_type_code, tr.acct_num
				from trade_item ti
				inner join trade_order oo
					inner join trade tr
					on tr.trade_num = oo.trade_num
				on oo.trade_num = ti.trade_num
				and oo.order_num = ti.order_num	
			where ti.booking_comp_num  = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			  and ti.real_port_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFuturos.port_num#">
			  and ti.p_s_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvarp_s_ind#">
			  and oo.order_type_code in ('PHYSICAL')
		</cfquery>
		<cfif rsProductos.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existen registros en portafolio">
		<cfelse>
			<cfloop query="rsProductos">
				<!--- Existencia del Articulo Orden Distribución  --->
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select a1.Aid
					from OCcomplementoArticulo a1, Articulos a2
					where a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and a2.Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#rsProductos.cmdty_code#">
					  and a2.Aid = a1.Aid
				</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ws_Articulo = rsVerifica.Aid>
				<cfelse>
					<cfset ws_Articulo = "">
					<cfset LvarBanderaErrores_registro = true>
					<cfset LvarBanderaErrores = true>
					<cfif len(LvarTipoError)>
						<cfset LvarTipoError = LvarTipoError & ", ">
					</cfif>
					<cfset LvarTipoError = LvarTipoError & "No existe Art./Compl. #rsProductos.cmdty_code#">
				</cfif>

				<!--- Existencia del Socio de Orden Comercial Distribución  --->
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select SNid
					from SNegocios 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and convert(int,SNcodigoext) = 
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProductos.acct_num#">
				</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ws_Socio = rsVerifica.SNid>
				<cfelse>
					<cfset ws_Socio = "">
					<cfset LvarBanderaErrores_registro = true>
					<cfset LvarBanderaErrores = true>
					<cfif len(LvarTipoError)>
						<cfset LvarTipoError = LvarTipoError & ", ">
					</cfif>
					<cfset LvarTipoError = LvarTipoError & "No existe Socio #rsProductos.acct_num#">
				</cfif>

				<cfif len(ws_Articulo) GT 0 and len(ws_Socio) GT 0>
					<cfset ProdStruct = StructNew()>
					<cfset ProdStruct.Producto = rsProductos.cmdty_code>
					<cfset ProdStruct.Aid = ws_Articulo>
					<cfset ProdStruct.SNid = ws_Socio>
					<cfset ProdStruct.Orden = rsProductos.acct_ref_num>
					<cfset ProdStruct.TipoOrden = rsProductos.p_s_ind>
					<cfset ProdStruct.ConceptoCompra = "">
					<cfset ProdStruct.ConceptoIngreso = "">
					<cfset ProdStruct.OrdenVenta = "">
					<cfset ProdStruct.MascaraIngreso = "">
					<cfset ProdStruct.MascaraCostoVenta = "">
					<cfset ProdStruct.CuentaFinanciera = "">
					<cfset ArrayAppend(ArregloProductos,ProdStruct)>
				</cfif>
			</cfloop>

			<cfif ArrayLen(ArregloProductos) EQ 0>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "No existen productos en portafolio">
			</cfif>
		</cfif>
	</cfif>

	<cfset LvarEncontroOrden = "N">
	<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
		<!--- revisa si existe la Orden Comercial  --->
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select OCid, OCtipoOD, OCtipoIC, OCVid, OCcontrato
			from OCordenComercial
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#ArregloProductos[i].Orden#">
		</cfquery>
		
		<cfif rsVerifica.recordcount GT 0>
			<cfset LvarEncontroOrden = "S">
			<cfif rsVerifica.OCtipoOD EQ 'D'>
				<cfset ArregloProductos[i].OrdenVenta = ArregloProductos[i].Orden>
				<cfset ws_OCVid = rsVerifica.OCVid>
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select CFmascaraIngreso, CFmascaraCostoVenta
					from OCtipoVenta
					where OCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_OCVid#">
				</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ArregloProductos[i].MascaraIngreso = rsVerifica.CFmascaraIngreso>
					<cfset ArregloProductos[i].MascaraCostoVenta = rsVerifica.CFmascaraCostoVenta>
				</cfif>
			<cfelse>
				<!--- busca la Orden Comercial de Venta, cuando viene una compra  --->
				<cfset ws_CodigoItem = ArregloProductos[i].Producto>
				<cfset LvarAid = ArregloProductos[i].Aid>
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select a3.OCTtransporte, a3.OCTid
					from OCordenComercial a1
					inner join OCtransporteProducto a2
						inner join OCtransporte a3
						on a3.OCTid = a2.OCTid
					on a2.OCid = a1.OCid
					and a2.OCTid = a3.OCTid
					where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and a1.OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#ArregloProductos[i].Orden#">
				</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ws_OCTid = rsVerifica.OCTid>
					<cfquery name="rsVerifica" datasource="#session.dsn#">
						select a1.OCid, a1.OCtipoOD, a1.OCtipoIC, a1.OCVid, a1.OCcontrato
						from OCordenComercial a1
						inner join OCtransporteProducto a2
							inner join OCtransporte a3
							on a2.OCTid = a3.OCTid
						on a2.OCid = a1.OCid
						and a2.OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_OCTid#">
						where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a1.OCtipoOD = 'D'
					</cfquery>
					<cfif rsVerifica.recordcount GT 0>
						<cfset ArregloProductos[i].OrdenVenta = rsVerifica.OCcontrato>
						<cfif rsVerifica.OCtipoIC EQ 'I'>
							<!--- Arma la cuenta financiera si el destino es un Almacén --->
							<cfset ws_CuentaFinancieraDet ="">
							<cfif len(ws_CodigoItem)>
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
								<cfif rsVerifica.recordcount GT 0>
									<cfset ArregloProductos[i].CuentaFinanciera = rsVerifica.Cformato>
								</cfif>
								<cfif len(ws_CuentaFinancieraDet) EQ 0>
									<cfset LvarBanderaErrores_registro = true>
									<cfset LvarBanderaErrores = true>
									<cfif len(LvarTipoError)>
										<cfset LvarTipoError = LvarTipoError & ", ">
									</cfif>
									<cfset LvarTipoError = LvarTipoError & "Cuenta del artículo #LvarAid# no existe">
								</cfif>
							</cfif> 
						<cfelse>
							<cfset ws_OCVid = rsVerifica.OCVid>
							<cfquery name="rsVerifica" datasource="#session.dsn#">
								select CFmascaraIngreso, CFmascaraCostoVenta
								from OCtipoVenta
								where OCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_OCVid#">
							</cfquery>
							<cfif rsVerifica.recordcount GT 0>
								<cfset ArregloProductos[i].MascaraIngreso = rsVerifica.CFmascaraIngreso>
								<cfset ArregloProductos[i].MascaraCostoVenta = rsVerifica.CFmascaraCostoVenta>
							<cfelse>
								<cfset LvarBanderaErrores_registro = true>
								<cfset LvarBanderaErrores = true>
								<cfif len(LvarTipoError)>
									<cfset LvarTipoError = LvarTipoError & ", ">
								</cfif>
								<cfset LvarTipoError = LvarTipoError & "No existe tipo venta #ArregloProductos[i].Orden#">
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
			<cfset LvarTipoError = LvarTipoError & "Orden #ArregloProductos[i].Orden# no existe">
		</cfif>
	</cfloop>

	<cfset ws_TipoItem = 'O'>

	<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
		<cfset ws_CodigoItem = ArregloProductos[i].Producto>
		<cfif (ws_tipo_modulo EQ 'Pérdida' and ArregloProductos[i].TipoOrden EQ 'P')>
			<!--- OCconceptoCompra     --->
			<cfquery name="rsVerifica" datasource="tesoreria">
				select sb.subconcepto_id
				FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
				WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar"  value="FUT_COMM">
				  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="ANY">
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
				<cfset LvarTipoError = LvarTipoError & "Concepto Compra no definido">
			<cfelse>
				<cfset ArregloProductos[i].ConceptoCompra = rsVerifica.subconcepto_id>
			</cfif>
		</cfif>

		<cfif (ws_tipo_modulo EQ 'Ganancia' and ArregloProductos[i].TipoOrden EQ 'S')>
			<!--- OCconceptoIngreso     --->
			<cfquery name="rsVerifica" datasource="tesoreria">
				select sb.subconcepto_id
				FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
				WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar"  value="FUT_COMM">
				  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="ANY">
				  AND s.payable_receivable = 'R' 
				  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
				  AND sb.subconcepto_id = r.subconcepto_id
			</cfquery>
			<cfif rsVerifica.recordcount EQ 0>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Concepto Ingreso no definido">
			<cfelse>
				<cfset ArregloProductos[i].ConceptoIngreso = rsVerifica.subconcepto_id>
			</cfif>
		</cfif>
		
		<!--- Se valida la cuenta financiera     --->
		<cfif len(LvarTipoError) EQ 0>
			<cfif len(ArregloProductos[i].CuentaFinanciera) EQ 0 and len(ArregloProductos[i].MascaraIngreso) EQ 0>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Orden #ArregloProductos[i].Orden# sin cuenta contable">
			</cfif>
		</cfif>
	</cfloop>

	<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
		<cfif len(LvarTipoError) EQ 0>
			<cfquery name="rsVerifica" datasource="#session.dsn#">
				select a3.OCTtransporte
				from OCordenComercial a1
				inner join OCtransporteProducto a2
					inner join OCtransporte a3
					on a3.OCTid = a2.OCTid
				on a2.OCid = a1.OCid
				where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a1.OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#ArregloProductos[i].Orden#">
			</cfquery>
			<cfif rsVerifica.recordcount GT 0>
				<cfset ws_OCtransporte = rsVerifica.OCTtransporte>
			<cfelse>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Transporte de #ws_OCcontrato# no existe">
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- actualizar el mensaje de error  --->
	<cfquery datasource="#session.dsn#">
		UPDATE #LvarDsource#futurosabiertosPMI
		   SET mensajeerror = case 
								when '#LvarTipoError#' = '' then null
								else
								'#LvarTipoError#'
							  end,
		   Documento = '#ws_folio#', Modulo = '#ws_tipo_modulo#'
		from #LvarDsource#futurosabiertosPMI 
		where unrealized_profits_detail_num = #rsFuturos.unrealized_profits_detail_num#
		  and trade_num = #rsFuturos.trade_num#
		  and order_num = #rsFuturos.order_num#
		  and item_num = #rsFuturos.item_num#
	</cfquery> 
</cfloop>
