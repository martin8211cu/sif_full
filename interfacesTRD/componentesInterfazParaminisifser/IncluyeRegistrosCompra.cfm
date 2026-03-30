<!--- Archivo    :  FacturasProductosA-sql.cfm
	  --->

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

<!--- Crea query de compras  --->
<cfquery name="rsTransito" datasource="preicts">
	select tr.trade_num, oo.order_num, ti.item_num, tr.acct_ref_num, ti.cmdty_code, tr.acct_num,
		price_curr_code
	from sif_interfaces..TablaTransito a1
		inner join trade tr
		on tr.acct_ref_num = Rtrim(a1.Orden)
		inner join trade_item ti
		on ti.trade_num = tr.trade_num
		inner join trade_order oo
		on oo.trade_num = tr.trade_num
		and oo.order_num = ti.order_num
		and ti.p_s_ind = 'P'
	order by a1.Orden
</cfquery>

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

<!--- procesa los registros de compra - tránsito  --->
<cfloop query="rsTransito"> 
	<cfset LvarCuentaFinanciera = "">

	<cfset ws_f_Importe = rsTransito.Importe>
	<cfset ws_f_precio = rsTransito.Precio>
	<cfset ws_c_unidades = rsTransito.Unidad>
	<cfset ws_f_volumen = rsTransito.Volumen>
	<cfset ws_c_moneda = rsTransito.price_curr_code>

	<!--- Existencia del Socio de Negocio  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select a1.Ecodigo, a1.SNcodigo, a1.SNid, a1.SNcodigoext, a1.cuentac,
			   a1.SNnombre
		from SNegocios a1
		where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a1.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransito.acct_num#">
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

	<!--- Existencia del Articulo  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select Aid, Ucodigo
		from Articulos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransito.cmdty_code#">
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
		  and a.Miso4217 = '#ws_c_moneda#'
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
		where ti.trade_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTransito.trade_num#">
		   and ti.order_num= <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsTranstio.order_num#">
		   and ti.item_num= <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsTransito.item_num#">
	</cfquery>
	<cfif rsTrade.recordcount EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No encontró el Trade">
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

	<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->
	<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
	<cfif LvarBanderaErrores_registro EQ false>
		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select OCid
			from OCordenComercial
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransito.Orden#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>
			<cfset vOCid = 0>
		<cfelse>
			<cfset vOCid = rsVerifica.OCid>
		</cfif>

	<cftransaction>

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
					'O', '#LvarOCtipoIC#', #session.Ecodigo#,
					 #LvarSNid#, '#rsTransito.Orden#',
 				     <cfif isdate(rsTrade.creation_date)>
					    <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.creation_date#">,
				     <cfelse>
					    null,
				     </cfif>
					 #LvarMcodigo#,
					 null,
					 'A','CP',
					 '#rsTrade.del_term_code#',
 				     <cfif isnumeric(rsTransito.trade_num)>
					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransito.trade_num#">,
				     <cfelse>
					    null,
				     </cfif>
 				     <cfif isnumeric(rsTransito.order_num)>
					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransito.order_num#">,
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
				  <cfqueryparam cfsqltype="cf_sql_float" value="#ws_f_volumen#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_importe,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value=0>,
				  null,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCuentaFinanciera#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>
		<cfelse>
			<cfset LvarCantidad = (rsVerifica.OCPcantidad + ws_f_volumen)>
			<cfif LvarCantidad EQ 0>
				<cfset LvarCantidad = 1>
			</cfif>
			<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + ws_f_importe) / LvarCantidad>
			<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + ws_f_importe>
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
				  <cfqueryparam cfsqltype="cf_sql_char" value="O">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvarbl_ticket_num#">,
				  <cfif isdate(Lvarbl_date)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  </cfif>
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTransporte#">,
				  <cfif isdate(queryCompras.fecha_allocation)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.fecha_allocation#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  </cfif>
				  <cfif isdate(queryCompras.title_tran_date)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.title_tran_date#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.dt_fecha_recibo#">,
				  </cfif>
				  <cfqueryparam cfsqltype="cf_sql_float" value="#ws_f_volumen#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_importe,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		<cfelse>
			<cfset LvarCantidad = (rsVerifica.OCTPcantidadTeorica + ws_f_volumen)>
			<cfif LvarCantidad EQ 0>
				<cfset LvarCantidad = 1>
			</cfif>
			<cfset LvarPrecioUnitario = (rsVerifica.OCTPprecioTotTeorico + ws_f_importe) / LvarCantidad>
			<cfset LvarPrecioTotal = rsVerifica.OCTPprecioTotTeorico + ws_f_importe>
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

		<!---  revisa si existe el ProductoTransito en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="#Session.Dsn#">
			select OCTid
			from OCproductoTransito
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
		</cfquery>

		<cfif rsVerifica.recordcount EQ 0>
			<cfquery name="query" datasource="#Session.Dsn#">
				insert OCproductoTransito
					(OCTid, Aid, Ecodigo, OCPTtransformado, OCPTentradasCantidad, OCPTentradasCostoTotal,
					 OCPTsalidasCantidad, OCPTsalidasCostoTotal, BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_bit" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>
		</cfif>
	</cfif>
		<!--- FIN SECCION ORDENES COMERCIALES  --->

	<cfabort showerror="paso #rsTransito.acct_ref_num#, #rsTransito.trade_num#, #rsTransito.cmdty_code#">

	</cftransaction>
	
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
