<!--- Archivo    :  SQLAplicaNoFact.cfm --->
<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">

<cfset LvarControlDocto = "">
<cfset LvarControlTipo = "">
<cfset LvarControlTipoTransaccion = "">

<cfquery name="rsNoFact" datasource="sifinterfaces">
	select *
	from #session.Dsource#nofactProdPMI a1
	where not Exists (Select a2.Trade_Num from #session.Dsource#ErroresPMI a2
						 where a1.trade_num = a2.Trade_Num and a1.order_num = a2.Order_Num
						   and a1.item_num = a2.Item_Num
						   and sessionid=#session.monitoreo.sessionid#)
	  and sessionid=#session.monitoreo.sessionid#
    order by a1.p_s_ind, a1.acct_ref_num, a1.tipoconsulta, a1.PosNeg
</cfquery>

<cfloop query="rsNoFact"> 
	<!--- decodifica campo alloc_type_code  --->	
	<cfif rsNoFact.alloc_type_code EQ "W">
		<cfset LvarOCTtipo = "B">
	<cfelseif rsNoFact.alloc_type_code EQ "R">
		<cfset LvarOCTtipo = "F">
	<cfelse>
		<cfset LvarOCTtipo = "T">
	</cfif>

	<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
	<cfset LvarConceptoCompra = "00">
	<cfset LvarCuentaFinanciera = "">
	
	<cfset LvarOCtipoIC = "C">
	<cfset LvarAlmacen = "">
	<cfset LvarTransporte = "#rsNoFact.acct_ref_num#">
	<cfset LvarSocioAlloc = 0>
	<cfset LvarOrdenAlloc = "">
	<cfset LvarPorcentaje= 100>
	
	<cfif rsNoFact.ta_order_type_code EQ 'PHYSICAL'>
		<cfset LvarOCtipoIC = "C">
		<cfset LvarSocioAlloc = #rsNoFact.ta_acct_num#>
	</cfif>
	<cfif rsNoFact.ta_order_type_code EQ 'STORAGE'>
		<cfset LvarAlmacen = "#rsNoFact.ta_acct_ref_num#">
		<cfset LvarSocioAlloc = rsNoFact.ta_acct_num>
	</cfif>
	<cfif rsNoFact.ta_order_type_code EQ 'TRANSPRT'>
		<cfset LvarTransporte = rsNoFact.ta_acct_ref_num>
		<cfif rsNoFact.tt_order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = rsNoFact.tt_acct_num>
		</cfif>
		<cfif rsNoFact.tt_order_type_code EQ 'STORAGE'>
			<cfset LvarAlmacen = rsNoFact.tt_cct_ref_num>
			<cfset LvarSocioAlloc = rsNoFact.tt_acct_num>
		</cfif>
	</cfif>

	<cfset ws_f_Importe = rsNoFact.montocosto>
	<cfif rsNoFact.contr_qty NEQ 0>
		<cfset ws_f_precio = rsNoFact.montocosto / rsNoFact.contr_qty>
	<cfelse>
		<cfset ws_f_precio = 0>
	</cfif>
	<cfset ws_c_unidad = rsNoFact.contr_qty_uom_code>
	<cfset ws_f_volumen = rsNoFact.contr_qty>

	<!--- Conversión a unidades del Artículo --->
	<cfif "#Rtrim(rsNoFact.UcodigoArt)#" NEQ "#Rtrim(ws_c_unidad)#">
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select Ucodigo, CUAfactor
			from ConversionUnidadesArt
			where Ecodigo  = #session.ecodigo#
			  and Aid = #rsNoFact.Aid#
			  and Ucodigo = '#ws_c_unidad#'
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset ws_f_volumen = rsVerifica.CUAfactor * ws_f_volumen>
			<cfif ws_f_volumen EQ 0>
				<cfset ws_f_volumen = 1>
			</cfif>
			<cfset ws_f_precio = ws_f_Importe/ws_f_volumen>
			<cfset ws_c_unidad = rsNoFact.UcodigoArt>
		</cfif>
	</cfif>
	
	<cfif ISNUMERIC(rsNoFact.bl_ticket_num)>
		<cfset Lvarbl_ticket_num=rsNoFact.bl_ticket_num>
	<cfelse>
		<cfset Lvarbl_ticket_num=0>
	</cfif>
	
	<cfif ISDATE(rsNoFact.bl_date)>
		<cfset Lvarbl_date=rsNoFact.bl_date>
	<cfelse>
		<cfset Lvarbl_date=rsNoFact.title_tran_date>
	</cfif>
	
	<cfif ISDATE(rsNoFact.title_tran_date)>
		<cfset LvarTitle_tran_date=rsNoFact.title_tran_date>
	<cfelse>
		<cfset LvarTitle_tran_date=rsNoFact.dt_fecha_recibo>
	</cfif>

	<!--- se determina el codigo de transaccion y el folio del documento  --->
	<cfset ws_folio = "#rsNoFact.acct_ref_num##rsNoFact.tipoconsulta##session.FechaFolio#">

	<cfif rsNoFact.PosNeg EQ "N">
		<cfset ws_tipo_transaccion = "DC">
		<cfset ws_f_importe = ws_f_importe * -1>
	<cfelse>
		<cfset ws_tipo_transaccion = "EC">
	</cfif>
	
	<cfif rsNoFact.p_s_ind EQ "P">
		<cfset ws_tipo_modulo = "CP">
		<cfset ws_tipoOD = "O">
	<cfelse>
		<cfset ws_tipo_modulo = "CC">
		<cfset ws_tipoOD = "D">
	</cfif>

	<cfset LvarID = 0>
	<!--- Verificar si cambia el voucher number para generar un nuevo IE10 --->
	<cfif LvarControlDocto NEQ rsNoFact.acct_ref_num or LvarControlTipo neq rsNoFact.tipoconsulta
	      or LvarTipoTransaccion NEQ rsNoFact.PosNeg>

		<cfquery name="rsVerificaIE10" datasource="sifinterfaces">
			select count(1) as Cantidad
			from IE10
			where EcodigoSDC = 14
			  and NumeroSocio = '#rsNoFact.acct_num#'
			  and Modulo = '#ws_tipo_modulo#'
			  and CodigoTransacion = '#ws_tipo_transaccion#'
			  and Documento = '#ws_folio#'
		</cfquery>
		
		<cfif rsVerificaIE10.Cantidad GT 0>
			<cfset LvarID = 0>
		<cfelse>
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
					#LvarID#, 14, '#rsNoFact.acct_num#', '#ws_tipo_modulo#',
					'#ws_tipo_transaccion#', '#ws_folio#', ' ',
					'#rsNoFact.trade_num#', 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.title_tran_date#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.title_tran_date#">,
					'S', '#ws_tipo_modulo#', '#rsNoFact.trade_num#', null, 
					null, null, null,
					#session.usucodigo#, 0, null, null, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.title_tran_date#">, 
					1)
			</cfquery>
		</cfif>
		<cfset LvarControlDocto = rsNoFact.acct_ref_num>
		<cfset LvarControlTipo = rsNoFact.tipoconsulta>
		<cfset LvarTipoTransaccion = rsNoFact.PosNeg>
	</cfif>

	<cfif LvarID GT 0>
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
				#LvarID#, #LvarConsecutivoID10#, 'O', '#rsNoFact.cmdty_code#',
				'#rsNoFact.transportation#',
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.load_compl_date#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.nor_date#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">, 
				'#ws_c_unidad#',
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
				'#rsNoFact.del_term_code#', '#Lvarbl_ticket_num#',
				<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				null, '#rsNoFact.acct_ref_num#', null, 0.00,
				0.00, null, null,
				#session.usucodigo#, #numberformat(ws_f_importe,"9.99")#,
				null, null,
				'#LvarOCTtipo#', '#LvarTransporte#', '#rsNoFact.acct_ref_num#', '#LvarConceptoCompra#'
				)
		</cfquery>>
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
