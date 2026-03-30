<!--- Archivo    :  NoFactSwapsA-sql.cfm
	  --->

<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">

<cfset LvarHoraInicio = now()>

<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

<cfset session.FechaFolio = "#right(form.FechaF,4)##mid(form.FechaF,4,2)#">
<cfset session.FechaFinal = vFechaF>

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

<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#nofactSwapsPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_IE10 where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_ID10 where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfacesser..nofactSwapsPMI (fecharegistro date null,sessionid numeric null,
		ID integer null, trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, order_type_code varchar(8) null,
		cost_num integer null, cost_code varchar(8) null, cost_pay_rec_ind char(1) null, port_num integer null,
		cost_price_curr_code varchar(8) null, cost_price_uom_code char(4) null, cost_amt float null,
		creation_date date null, cost_eff_date date null, cost_due_date date null,
		SNid numeric null, Aid numeric null, UcodigoArt char(5) null, Mcodigo numeric null, Ucodigo char(5) null,
		subconcepto integer null, CodigoConcepto char(5) null, cost_type_code varchar(8) null, 
		ta_order_type_code varchar(8) null, ta_trade_num int null, ta_acct_ref_num char(10) null, 
		ta_acct_num int null, tt_order_type_code char(8) null, tt_acct_ref_num char(10) null,
		tt_acct_num int null, montocosto float null, PosNeg char(1) null, avg_price float null)

--->

<!--- Crea query de compras  --->
<cfquery datasource="preicts">
	insert #LvarDsource#nofactSwapsPMI (fecharegistro, sessionid,
		trade_num, order_num, item_num, acct_ref_num, acct_num, booking_comp_num,
		order_type_code, 
		cost_code, cost_pay_rec_ind, port_num, cost_price_curr_code, cost_price_uom_code,
		cost_amt, creation_date, cost_eff_date, cost_due_date, cost_num
		   )
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
		ti.trade_num, ti.order_num, ti.item_num, tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
		oo.order_type_code,
		co.cost_code, co.cost_pay_rec_ind, co.port_num, co.cost_price_curr_code, co.cost_price_uom_code,
		co.cost_amt, co.creation_date, co.cost_eff_date, co.cost_due_date, co.cost_num
	from trade_item ti
		inner join accumulation ac
		on ac.trade_num = ti.trade_num
		and ac.order_num = ti.order_num
		and ac.item_num = ti.item_num
		and ac.price_status in ('U','P')
		inner join trade_order oo
			inner join trade tr
			on tr.trade_num = oo.trade_num
		on oo.trade_num = ti.trade_num
		   and oo.order_num = ti.order_num
		   and (oo.order_type_code='SWAP' or oo.order_type_code='SWAPFLT')
		   inner join cost co
				 on co.cost_owner_key6 = ti.trade_num
				 and co.cost_owner_key7 = ti.order_num
				 and co.cost_owner_key8 = ti.item_num 
				 and co.cost_status = 'OPEN'
				 and co.cost_code = ti.cmdty_code
			  and co.cost_book_comp_num=701
	where ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
	order by co.cost_owner_code
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">
<cfset ArregloProductos = ArrayNew(1)>

<!--- procesa los registros de nofact de fletes --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactSwapsPMI SET SNid = a2.SNid
	from #LvarDsource#nofactSwapsPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
</cfquery> 

<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactSwapsPMI SET Ucodigo = a2.Ucodigo
	from #LvarDsource#nofactSwapsPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.cost_price_uom_code
</cfquery>

<cfset LvarConceptoCompra = "00">
<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#nofactSwapsPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#nofactSwapsPMI a1
	WHERE s.costo_id = a1.cost_code
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id
	  AND sb.subconcepto_id = r.subconcepto_id
</cfquery>

<!--- código de compra  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactSwapsPMI SET CodigoConcepto = a2.cuentac
	from #LvarDsource#nofactSwapsPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
</cfquery>

<cfquery name="rsNoFact" datasource="sifinterfaces">
	select *
	from  #LvarDsource#nofactSwapsPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfset ConseIE10 = 0>
<cfloop query="rsNoFact"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- Existencia del Socio de Negocio  --->
	<cfif Len(rsNoFact.SNid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
	</cfif>

	<!--- Moneda es Valida  --->
	<cfset ws_curr_code = mid(rsNoFact.cost_price_curr_code,1,3)>
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

	<!--- portnum es valido  --->
	<cfif Len(rsNoFact.port_num) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No. de Portafolio no existe">
	</cfif>

	<cfset LvarConceptoCompra = "00">

	<cfif Len(rsNoFact.port_num) GT 0>
		<cfset ArrayClear(ArregloProductos)>
		<!--- Distribución de Costos   --->
		<cfquery name="rsProductos" datasource="preicts">
			select distinct cmdty_code from trade_item
			where booking_comp_num  = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			  and real_port_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNoFact.port_num#">
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
				<!--- Existencia del Articulo  --->
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select Aid, Ucodigo
					from Articulos 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#rsProductos.cmdty_code#">
				</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset ArrayAppend(ArregloProductos,#rsProductos.cmdty_code#)>
				</cfif>
			</cfloop>
		</cfif>
		<cfif ArrayLen(ArregloProductos) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existen productos en portafolio">
		</cfif>
	</cfif>

	<!--- crear folio de noFact de swaps    --->
	<cfset ws_folio = "#rsNoFact.acct_ref_num#SWAP#session.FechaFolio#">
	<cfif rsNoFact.cost_pay_rec_ind EQ 'R'>
		<cfset ws_tipo_modulo = "CC">
	<cfelse>	
		<cfset ws_tipo_modulo = "CP">
	</cfif>
	
	<cfset ws_tipo_transaccion = "FC">

	<!--- revisa si existe la Orden Comercial de compra --->
	<cfif Len(LvarTipoError) EQ 0>
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select OCid
			from OCordenComercial
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsNoFact.acct_ref_num#">
		</cfquery>
		
		<cfif rsVerifica.recordcount GT 0>
			<cfset ws_TipoItem = 'O'>
		<cfelse>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existe Orden Comercial de Compra">
		</cfif>
	</cfif>		

	<cfset ws_TipoItem = 'O'>

	<cfset ConseIE10 = ConseIE10 + 1>
	<!--- Graba error en tabla pmiIE10  --->
	<cfquery datasource="sifinterfaces">
		insert into PMIINT_IE10 (FechaRegistro, sessionid,
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
			#ConseIE10#, 14, '#rsNoFact.acct_num#', '#ws_tipo_modulo#',
			'#ws_tipo_transaccion#', '#ws_folio#', ' ',
			'#rsNoFact.cost_price_curr_code#', 
			<cfif len(rsNoFact.cost_eff_date) GT 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.cost_eff_date#">, 
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">, 
			</cfif>
			null,
			'S', '#ws_tipo_modulo#', '#rsNoFact.trade_num#', null, 
			null, null, null,
			0, null, null, 
			<cfif len(rsNoFact.cost_eff_date) GT 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.cost_eff_date#">, 
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">, 
			</cfif>
			1,
			<cfif len(LvarTipoError) GT 0>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipoError#">
			<cfelse>
			null
			</cfif>
			)
	</cfquery>
	<cfif len(LvarTipoError) EQ 0>
		<cfset ws_registros = ArrayLen(ArregloProductos)>
		<cfset ws_monto = rsNoFact.cost_amt / ws_registros>
		<cfset ConseID10 = 0>
		<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
			<cfset ConseID10 = ConseID10 + 1>
			<cfset ws_CodigoItem = rsProductos.cmdty_code>
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
					#ConseIE10#, #ConseID10#, '#ws_TipoItem#', '#ArregloProductos[i]#',
					null,
					null, 
					null,
					<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(0,"9.99")#">, 
					'#rsNoFact.cost_price_uom_code#',
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#0#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#0#">, 
					null, ' ',
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">,
					null, '#rsNoFact.acct_ref_num#', null, 0.00,
					0.00, null, null,
					#numberformat(ws_monto,"9.99")#,
					null, null,
					null, null, null, null
					)
			</cfquery>
		</cfloop>
	</cfif>
</cfloop>
