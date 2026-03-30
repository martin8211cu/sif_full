<!--- Archivo    :  NoFactSwaps   extrae.cfm --->

<!--- cost_pay_rec_ind = R (Receivable / CxC, aka Ganacia) P (Payable / CxP, aka Perdida) --->

<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">

<cfset LvarHoraInicio = now()>

<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>
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
<cfelse>
	<cfthrow message="La empresa no aparece en int_ICTS_SOIN (Ecodigo=#session.Ecodigo#)">
</cfif>

<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>

<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfquery datasource="sifinterfaces">
	delete from PMIINT_IE10 where sessionid = #session.monitoreo.sessionid#
	delete from PMIINT_ID10 where sessionid = #session.monitoreo.sessionid#
</cfquery> 


<!--- Ejecutar query mensual de swaps, si es necesario --->
<cfinclude template="queryswaps.cfm">
<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">

<!--- procesa los registros de nofact de swaps --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..nofactSwapsPMI SET SNid = a2.SNid
	from #sifinterfacesdb#..nofactSwapsPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
	  and a1.anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#anio_proceso#">
	  and a1.mes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes_proceso#">
	  and a1.EmpresaICTS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
</cfquery> 

<!--- Unidad es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..nofactSwapsPMI SET Ucodigo = a2.Ucodigo
	from #sifinterfacesdb#..nofactSwapsPMI a1, Unidades a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ucodigo  = a1.cost_price_uom_code
	  and a1.anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#anio_proceso#">
	  and a1.mes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes_proceso#">
	  and a1.EmpresaICTS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
</cfquery>

<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..nofactSwapsPMI SET Mcodigo = a2.Mcodigo
	from #sifinterfacesdb#..nofactSwapsPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = case 
	  						when a1.cost_price_curr_code = 'MXN' then 'MXP'
						 	else substring(a1.cost_price_curr_code,1,3)
						 end
	  and a1.anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#anio_proceso#">
	  and a1.mes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes_proceso#">
	  and a1.EmpresaICTS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
</cfquery>

<cfquery name="rsNoFact" datasource="sifinterfaces">
	select *
	from  nofactSwapsPMI
	where anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#anio_proceso#">
	  and mes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes_proceso#">
	  and EmpresaICTS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
</cfquery>
<cfset ws_folio = ''>
<cfset ws_tipo_modulo = ''>
<cfset ConseIE10 = 0>
<cfloop query="rsNoFact"> 
	<!--- Variables de Control para Encabezado --->
	<cfset ws_folio_control = ws_folio>
	<cfset ws_tipo_modulo_control = ws_tipo_modulo>
	<!--- crear folio de noFact de swaps    --->
	<cfset ws_folio = "#rsNoFact.acct_ref_num#SWAP#session.FechaFolio#">
	<!--- ver si es Ganancia CxC o Pérdida CxP --->
	<cfif rsNoFact.cost_pay_rec_ind EQ 'R'>
		<!--- cost_pay_rec_ind = R (Receivable / CxC, aka Ganacia) P (Payable / CxP, aka Perdida) --->
		<cfset ws_tipo_modulo = "CC">
		<cfset Lvarp_s_ind = "S">
	<cfelse>	
		<cfset ws_tipo_modulo = "CP">
		<cfset Lvarp_s_ind = "P">
	</cfif>
	<cfif ws_folio_control EQ ws_folio AND ws_tipo_modulo_control EQ ws_tipo_modulo>
		<!--- Obtiene el Error Actual del Registro --->
		<cfquery name="mensajeerror" datasource="sifinterfaces">
			select MensajeError from  PMIINT_IE10
			where ID = #ConseIE10#
			and FechaRegistro = getdate()
			and sessionid = #session.monitoreo.sessionid#
		</cfquery>
		<cfif Len(mensajeerror.MensajeError) NEQ 0>	
			<cfset LvarBanderaErrores_registro = True>
			<cfset LvarTipoError = mensajeerror.MensajeError>
		</cfif>
	<cfelse>
		<cfset LvarBanderaErrores_registro = False>
		<cfset LvarTipoError = "">	
	</cfif>
	<cfset CLASIFICACION_DE_COBERTURA = 'FE'>
	<!--- Validar existencia del socio de negocio  --->
	<cfif Len(rsNoFact.SNid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset Busqueda = find("Socio No Definido",#LvarTipoError#)>
		<cfif Busqueda EQ 0>
			<cfset LvarTipoError = ListAppend(LvarTipoError, "Socio No Definido")>
		</cfif>
	</cfif>
	<cfif Len(rsNoFact.SNid) GT 0>
		<!--- Valida la existencia de la Direccion de COBERTURAS para el socio de Negocios --->
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select SNcodigoext  
			from SNDirecciones 
			where SNid = #rsNoFact.SNid# and SNnombre = 'COBERTURAS'
		</cfquery>
		<cfif rsVerifica.recordcount NEQ 1>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfset Busqueda = find("NO existe la direccion COBERTURAS para socio #rsNoFact.acct_num#",#LvarTipoError#)>
			<cfif Busqueda EQ 0>
				<cfset LvarTipoError = 
				ListAppend(LvarTipoError, "NO existe la direccion COBERTURAS para socio #rsNoFact.acct_num#")>
			</cfif>
			<cfset SWvarDireccion = "">
		<cfelse>
			<cfset SWvarDireccion = rsVerifica.SNcodigoext>
		</cfif> 
	</cfif>
	<!--- Validar moneda --->
	<cfif Len(rsNoFact.Mcodigo) EQ 0>
		<cfset LvarMcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset Busqueda = find("Moneda Incorrecta",#LvarTipoError#)>
		<cfif Busqueda EQ 0>
			<cfset LvarTipoError = ListAppend(LvarTipoError, "Moneda Incorrecta")>
		</cfif>
	<cfelse>
		<cfset LvarMcodigo = rsNoFact.Mcodigo>
	</cfif> 

	<!--- Validar que tenga número de portafolio (portnum) --->
	<cfif Len(rsNoFact.port_num) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset Busqueda = find("No. de Portafolio no existe",#LvarTipoError#)>
		<cfif Busqueda EQ 0>
			<cfset LvarTipoError = ListAppend(LvarTipoError, "No. de Portafolio no existe")>
		</cfif>
	</cfif>
	<!--- Si tiene portafolio, buscar clasificación de cobertura --->
	<cfif Len(rsNoFact.port_num) NEQ 0>
		<cfquery datasource="preicts" name="cobertura">
			select tgo.tag_option_desc, pt.tag_value
			from portfolio_tag_option tgo, portfolio_tag pt
			where tgo.tag_name = 'CLASS'
			  and tgo.tag_option = pt.tag_value
			  and pt.port_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNoFact.port_num#">
			  and pt.tag_name = 'CLASS'
		</cfquery>
		<!--- VERIFICA QUE LA COBERTURA VENGA Y VENGA BIEN ("FE" o "VR"), SI NO MUESTRA ERROR --->
		<cfif cobertura.RecordCount is 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfset Busqueda = find("No. de Portafolio #rsNoFact.port_num# no tiene Clasificación contable de cobertura (FE/VR)",#LvarTipoError#)>
			<cfif Busqueda EQ 0>
				<cfset LvarTipoError = ListAppend(LvarTipoError, "No. de Portafolio #rsNoFact.port_num# no tiene Clasificación contable de cobertura (FE/VR)")>
			</cfif>
		<cfelseif ListFind('FE,VR', cobertura.tag_option_desc) is 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfset Busqueda = find("No. de Portafolio #rsNoFact.port_num# Clasificación contable inválida (#cobertura.tag_value#, #cobertura.tag_option_desc#), debe ser FE o VR",#LvarTipoError#)>
			<cfif Busqueda EQ 0>
				<cfset LvarTipoError = ListAppend(LvarTipoError, "No. de Portafolio #rsNoFact.port_num# Clasificación contable inválida (#cobertura.tag_value#, #cobertura.tag_option_desc#), debe ser FE o VR")>
			</cfif>	
		</cfif>
		<!--- CLASIFICACION_DE_COBERTURA: FE (FLUJO DE EFECTIVO), VR (VALOR RAZONABLE) --->
		<cfif cobertura.tag_option_desc is 'VR'>
			<cfset CLASIFICACION_DE_COBERTURA = 'VR'>
		<cfelse>
			<cfset CLASIFICACION_DE_COBERTURA = 'FE'>
		</cfif>
	</cfif>
	
	<!--- DETERMINAR ws_CodigoItem_VR/VNR (Venta Realizada/Venta No Realizada) --->
	<cfif CLASIFICACION_DE_COBERTURA IS 'VR' and ws_tipo_modulo is 'CP'>
		<cfset ws_CodigoItem_VR  = '26-VR1'>
		<cfset ws_CodigoItem_VNR = '26-VR1'>
	<cfelseif CLASIFICACION_DE_COBERTURA IS 'VR' and ws_tipo_modulo is 'CC'>
		<cfset ws_CodigoItem_VR  = '118-VR1'>
		<cfset ws_CodigoItem_VNR = '118-VR1'>
	<cfelseif CLASIFICACION_DE_COBERTURA IS 'FE' and ws_tipo_modulo is 'CP'>
		<cfset ws_CodigoItem_VR  = '26-FE2'>
		<cfset ws_CodigoItem_VNR = '26-FE1'>
	<cfelseif CLASIFICACION_DE_COBERTURA IS 'FE' and ws_tipo_modulo is 'CC'>
		<cfset ws_CodigoItem_VR  = '118-FE2'>
		<cfset ws_CodigoItem_VNR = '118-FE1'>
	</cfif>

	
	<!--- Guardar como Tipo de transacción ER --->
	<cfset ws_tipo_transaccion = "ER">

	<!--- Busca (e ignora) los registros que se encuentran en la tabla IE10  --->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
	   select ID from IE10  
	    where Documento = '#ws_folio#' 
		and EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">
	</cfquery>
	<!--- Si ya está en la IE10, informar que ya fue procesado --->
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset Busqueda = find("registro ya procesado",#LvarTipoError#)>
		<cfif Busqueda EQ 0>
			<cfset LvarTipoError = ListAppend(LvarTipoError, "registro ya procesado")>
		</cfif>
	</cfif>

	<!--- Valido que el monto del costo no sea cero --->
	<cfif rsNoFact.montocosto EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset Busqueda = find("Monto del costo en cero",#LvarTipoError#)>
		<cfif Busqueda EQ 0>
			<cfset LvarTipoError = ListAppend(LvarTipoError, "Monto del costo en cero")>
		</cfif>
	</cfif>


	<!--- Validar si el portafolio tiene registros  --->
	<cfif Len(rsNoFact.port_num) GT 0>
		<cfquery name="portafolio_rows" datasource="preicts">
			select count(1) as cantidad
				from trade_item ti
				inner join trade_order oo
					inner join trade tr
					on tr.trade_num = oo.trade_num
				on oo.trade_num = ti.trade_num
				and oo.order_num = ti.order_num	
			where ti.booking_comp_num  = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			  and ti.real_port_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNoFact.port_num#">

				<!--- p_s_ind = S (*Venta*), P (Compra) --->
			  and ti.p_s_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvarp_s_ind#">
			  and oo.order_type_code in ('PHYSICAL')
		</cfquery>
		<cfif portafolio_rows.cantidad EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfset Busqueda = find("No existen registros en portafolio num #rsNoFact.port_num#",#LvarTipoError#)>
			<cfif Busqueda EQ 0>
				<cfset LvarTipoError = ListAppend(LvarTipoError, "No existen registros en portafolio num #rsNoFact.port_num#")>
			</cfif>
		</cfif>
	</cfif>

	<cfset cost_amt = rsNoFact.cost_amt>
	<!--- SEPARAR VENTA REALIZADA DE NO REALIZADA --->
	<cfif Len(rsNoFact.port_num) GT 0> 
		<!--- QUERY PARA CONTAR VENTAS REALIZADAS Y NO REALIZADAS --->
		<cfquery name="status_ventas" datasource="preicts">
			select count(1) as hay_venta_realizada
				from trade_item ti
				inner join trade_order oo
					on oo.trade_num = ti.trade_num
					and oo.order_num = ti.order_num	
				inner join trade tr
					on tr.trade_num = oo.trade_num
				inner join allocation_item ai
					on ai.trade_num = ti.trade_num
					and ai.order_num = ti.order_num
					and ai.item_num = ti.item_num
			where ti.booking_comp_num  = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			  and ti.real_port_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNoFact.port_num#">
				<!--- p_s_ind = S (*Venta*), P (Compra) --->
			  and ti.p_s_ind = 'S'
			  and oo.order_type_code in ('PHYSICAL')
			  and ai.title_tran_date <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaF#">
		</cfquery>
		<!--- SEGUN EL RESULTADO MARCAR COMO VR O VNR --->
		<cfif status_ventas.hay_venta_realizada EQ 0>
			<cfset ws_CodigoItem = ws_CodigoItem_VNR>
			<cfset ws_TipoVenta = CLASIFICACION_DE_COBERTURA & "-VNR">
		<cfelse>
			<cfset ws_CodigoItem = ws_CodigoItem_VR>
			<cfset ws_TipoVenta = CLASIFICACION_DE_COBERTURA & "-VR">
		</cfif>
	<cfelse>
		<cfset ws_TipoVenta = "">
	</cfif> 
	<!--- Tipo "O" = Order (sales order), debe ir relacionado con una orden comercial
		en CxP Debe ser una orden comercial de compra
		en CxC Debe ser una orden comercial de venta
		en el caso de NOFACT, con posicion abierta, siempre es "S"
	 --->
	<cfset ws_TipoItem = 'S'>
	<cfif ws_folio_control NEQ ws_folio	OR ws_tipo_modulo_control NEQ ws_tipo_modulo>
		<cfset ConseIE10 = ConseIE10 + 1>
		<!--- Graba en tabla PMIINT_IE10  --->
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
				'#rsNoFact.cost_price_curr_code#', 
				<cfif len(rsNoFact.cost_eff_date) GT 0>
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.cost_eff_date#">, 
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">, 
				</cfif>
				null,
				'S', '#ws_tipo_modulo#', '#rsNoFact.trade_num#', null, 
				null, null, null,
				0, <cfif isdefined("SWvarDireccion") and Len(SWvarDireccion) GT 0>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SWvarDireccion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SWvarDireccion#">,
					<cfelse>
						null,
						null, 
					</cfif>
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
		<cfset ConseID10 = 0>
	<cfelse>
		<cfif len(LvarTipoError) GT 0>
			<cfquery datasource="sifinterfaces">
				update PMIINT_IE10
				set MensajeError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipoError#">
				where ID = #ConseIE10#
				and FechaRegistro = getdate()
				and sessionid = #session.monitoreo.sessionid#
			</cfquery>
		</cfif>
	</cfif>
		<cfset ws_CuentaFinancieraDet ="">
		<cfset ws_Cantidad = 1>
		<cfset ws_transporte = "">
		<cfif isDefined("ws_CodigoItem")>
			<!--- Variable Definida no realiza ninguna accion --->
		<cfelse>
			<cfset ws_CodigoItem = "">
		</cfif>
		<!--- insertar una linea en PMIINT_ID10 por la venta realizada o no realizada --->
		<cfset ConseID10 = ConseID10 + 1>
		<cfquery datasource="sifinterfaces">
		insert PMIINT_ID10 (
			FechaRegistro, sessionid,
			ID, Consecutivo, TipoItem, CodigoItem, 
			NombreBarco, FechaHoraCarga, FechaHoraSalida, 
			
			PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
			CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
			TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
			
			ImporteDescuento, CodigoAlmacen, CodigoDepartamento, PrecioTotal, 
			CentroFuncional, CuentaFinancieraDet, 
			
			OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra,
			OCconceptoIngreso,cobertura)
		values (
			getdate(), #session.monitoreo.sessionid#,
			#ConseIE10#, #ConseID10#, '#ws_TipoItem#', '#ws_CodigoItem#',
			null, null, null,
			
			<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(cost_amt, '9.99')#">,
				'#rsNoFact.cost_price_uom_code#',
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_Cantidad#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_Cantidad#">, 
				null, ' ', <cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">,
			null, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNoFact.acct_ref_num#" null="#Len(rsNoFact.acct_ref_num) is 0#">,
				null, 0.00,
			
			0.00, null, null, <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(cost_amt, '9.99')#">, 
			null, <cfqueryparam cfsqltype="cf_sql_char" value="#ws_CuentaFinancieraDet#"  null="#len(ws_CuentaFinancieraDet)  is 0#">,
				
			null, '#ws_Transporte#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNoFact.acct_ref_num#" null="#Len(rsNoFact.acct_ref_num) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#ws_CodigoItem#" null="#ws_tipo_modulo NEQ 'CP'#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#ws_CodigoItem#" null="#ws_tipo_modulo NEQ 'CC'#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ws_TipoVenta#">
			)
		</cfquery>

</cfloop>
