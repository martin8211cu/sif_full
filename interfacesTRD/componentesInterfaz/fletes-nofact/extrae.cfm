<!--- Archivo    :  NoFactFletesA-sql.cfm  --->

<cfset LvarHoraInicio = now()>

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
	<cfquery datasource="preicts">
		drop table #LvarDsource#TempPMI
	</cfquery> 
<cfcatch type="any">
</cfcatch>
</cftry>

<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#nofactFletesPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ErroresPMI where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#ProductosPMI where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfaces..nofactFletesPMI (fecharegistro date null,sessionid numeric null,
		tipoconsulta char(1) null, trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, cmdty_code varchar(10),
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

<!--- Crea query de fletes  --->
<cfquery datasource="preicts">
	insert #LvarDsource#nofactFletesPMI (fecharegistro, sessionid, tipoconsulta, trade_num, order_num,
		item_num, acct_ref_num, acct_num, booking_comp_num, cmdty_code, contr_date,title_tran_date,
		alloc_type_code, del_term_code, bl_ticket_num, bl_date, transportation, load_compl_date, 
		nor_date, creation_date, fecha_allocation, real_port_num, contr_qty_uom_code, contr_qty,
		price_curr_code, p_s_ind, avg_price, montocosto)
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,  'N',
		ti.trade_num, ti.order_num, ti.item_num,
		ai.acct_ref_num, co.acct_num, ti.booking_comp_num,
		ti.cmdty_code, tr.contr_date,
	    a2.title_tran_date, 
		a5.alloc_type_code, a2.del_term_code , a10.bl_ticket_num, 
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, tr.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num, ti.contr_qty_uom_code, ai.nomin_qty_max,
		ti.price_curr_code, a3.p_s_ind, a3.avg_price, co.cost_amt
	from cost co
		inner join allocation_item ai
		on ai.trade_num = co.cost_owner_key6
		and ai.order_num = co.cost_owner_key7
		and ai.item_num = co.cost_owner_key8
	
		inner join trade_item ti
			inner join trade tr
			on tr.trade_num = ti.trade_num
		on ti.trade_num= co.cost_owner_key6
		and ti.order_num = co.cost_owner_key7
		and ti.item_num = co.cost_owner_key8
	
		inner join allocation_item a2
			inner join allocation a5
			on a5.alloc_num = a2.alloc_num
			inner join allocation_item_transport a10
			on a10.alloc_num = a2.alloc_num
			and a10.alloc_item_num = a2.alloc_item_num
	
			inner join trade_item a3
			on a2.trade_num = a3.trade_num
			and a2.order_num = a3.order_num
			and a2.item_num = a3.item_num
			and a3.p_s_ind = 'P'
	
		on a2.alloc_num = ai.alloc_num
		and a2.alloc_item_type='R'
		and (a2.title_tran_date IS NOT null)
		and a2.title_tran_date < <cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaF)#">
			where (co.cost_owner_code like 'A%' or co.cost_owner_code = 'TI')
			  and co.cost_code like 'FREIG%'
			  and co.cost_status = 'OPEN'
			  and co.cost_prim_sec_ind = 'S'
			  and co.cost_type_code = 'TMC'
			  and co.cost_pay_rec_ind = 'P'
			  and co.cost_book_comp_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
	order by ai.acct_ref_num
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">

<!--- procesa los registros de nofact de fletes --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactFletesPMI SET SNid = a2.SNid
	from #LvarDsource#nofactFletesPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactFletesPMI SET Aid = a2.Aid, UcodigoArt = a2.Ucodigo
	from  #LvarDsource#nofactFletesPMI a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodalterno  = a1.cmdty_code
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactFletesPMI SET Ucodigo = a2.Ucodigo
	from #LvarDsource#nofactFletesPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.contr_qty_uom_code
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfquery name="rsNoFact" datasource="sifinterfaces">
	select *
	from  #LvarDsource#nofactFletesPMI where sessionid = #session.monitoreo.sessionid#
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

	<!--- Existencia del Articulo  --->
	<cfif Len(rsNoFact.Aid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarAid = 0>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
	<cfelse>
		<cfset LvarAid = #rsNoFact.Aid#>
	</cfif>

	<!--- Moneda es Valida  --->
	<cfset ws_curr_code = mid(rsNoFact.price_curr_code,1,3)>
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

	<!--- Unidad es Valida  --->
	<cfif Len(rsNoFact.Ucodigo) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	</cfif>

	<cfset LvarConceptoCompra = "00">

	<!--- decodifica campo alloc_type_code  --->	
	<cfif rsNoFact.alloc_type_code EQ "W">
		<cfset LvarOCTtipo = "B">
	<cfelseif rsNoFact.alloc_type_code EQ "R">
		<cfset LvarOCTtipo = "F">
	<cfelse>
		<cfset LvarOCTtipo = "T">
	</cfif>

	<!--- Conversión a unidades del Artículo --->
	<cfif Rtrim(rsNoFact.UcodigoArt) NEQ "#Rtrim(rsNoFact.contr_qty_uom_code)#">
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select Ucodigo, CUAfactor
			from ConversionUnidadesArt
			where Ecodigo  = #session.ecodigo#
			  and Aid = #LvarAid#
			  and Ucodigo = '#Rtrim(rsNoFact.contr_qty_uom_code)#'
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError &
			 "Falta Factor de conversión:#rsNoFact.cmdty_code#,#rsNoFact.contr_qty_uom_code#">
		</cfif>
	</cfif> 

	<cfif ISNUMERIC(rsNoFact.bl_ticket_num)>
		<cfset Lvarbl_ticket_num = rsNoFact.bl_ticket_num>
	<cfelse>
		<cfset Lvarbl_ticket_num=0>
	</cfif>

	<cfif ISDATE(rsNoFact.bl_date)>
		<cfset Lvarbl_date=rsNoFact.bl_date>
	<cfelse>
		<cfset Lvarbl_date=now()>
	</cfif>

	<!--- crear folio de noFact de fletes    --->
	<cfset ws_folio = "#rsNoFact.acct_ref_num#FLE#session.FechaFolio#">
	<cfset ws_tipo_modulo = "CP">
	<cfset ws_tipo_transaccion = "EI">
	<cfset ws_TipoItem = 'O'>
	<cfset ws_CodigoItem = rsNoFact.cmdty_code>

	<!--- valida registros ya procesados  --->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
	   select ID from #session.Dsource#IE10  
	    where Documento = '#ws_folio#' 
		and EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Registro ya procesado">
	</cfif>

	<cfif rsNoFact.montocosto EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Monto del costo en cero">
	</cfif>

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
			#ConseIE10#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">,
			'#rsNoFact.acct_num#', '#ws_tipo_modulo#',
			'#ws_tipo_transaccion#', '#ws_folio#', ' ',
			'#rsNoFact.price_curr_code#', 
			<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.title_tran_date#">, 
			null,
			'S', '#ws_tipo_modulo#', '#rsNoFact.trade_num#', null, 
			null, null, null,
			0, null, null, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.title_tran_date#">, 
			1,
			<cfif len(LvarTipoError) GT 0>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipoError#">
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
			TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
			ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
			PrecioTotal, 
			CentroFuncional, CuentaFinancieraDet, 
			OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
		values(getdate(), #session.monitoreo.sessionid#,
			#ConseIE10#, 1, '#ws_TipoItem#', '#ws_CodigoItem#',
			'#rsNoFact.transportation#',
			<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.load_compl_date#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.nor_date#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(0,"9.99")#">, 
			'#rsNoFact.contr_qty_uom_code#',
			<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#0#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#0#">, 
			'#rsNoFact.del_term_code#', '#Lvarbl_ticket_num#',
			<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
			null, '#rsNoFact.acct_ref_num#', null, null,
			0.00, null, null,
			#numberformat(rsNoFact.montocosto,"9.99")#,
			null, null,
			null, null, null, null
			)
	</cfquery>
</cfloop>
