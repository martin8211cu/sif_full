<!--- Archivo    :  FacturasProductosA-sql.cfm
	  --->

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">

<cfset LvarHoraInicio = now()>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">
<cfset LvarNoRegistros = 0>

<cfquery name="rsEmpresa" datasource="sifinterfaces">
	select Ecodigo, CodICTS
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<!--- Crea query de compras  --->
<cfquery name="rsTransito" datasource="preicts">
	select tr.trade_num, oo.order_num, ti.item_num, tr.acct_ref_num, ti.cmdty_code, tr.acct_num,
		'USD' as c_moneda, a1.Orden, a1.Producto, a1.Volumen, a1.PrecioUnitario, a1.Importe, a1.Unidad,
		ai.title_tran_date, ai.trade_num, ai.order_num, ai.item_num,
		a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, ai.del_term_code,
		a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date, tr.creation_date,
		a5.creation_date as fecha_allocation, ti.real_port_num
	from sif_interfaces..TablaTransito a1         <!--- TablaTransito  --->
		inner join trade tr
		on tr.acct_ref_num = Rtrim(a1.Orden)
		inner join trade_item ti
		on ti.trade_num = tr.trade_num

		inner join allocation_item ai
			inner join allocation a5
			on a5.alloc_num =ai.alloc_num
			inner join allocation_item_transport a10
			on a10.alloc_num = ai.alloc_num
			and a10.alloc_item_num = ai.alloc_item_num
		on ai.trade_num = ti.trade_num
		and ai.order_num = ti.order_num
		and ai.item_num = ti.item_num

		inner join trade_order oo
		on oo.trade_num = tr.trade_num
		and oo.order_num = ti.order_num
		and ti.p_s_ind = 'P'
	order by a1.Orden
</cfquery>

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

<!--- procesa los registros de compra - tránsito  --->
<cfloop query="rsTransito"> 
	<cfset LvarTipoError = "">
	<cfset LvarBanderaErrores_registro = false>
	<cfset LvarCuentaFinanciera = "">
	
	<cfset LvarProducto = rsTransito.cmdty_code>
	
	<cfset ws_f_Importe = rsTransito.Importe>
	<cfset ws_f_precio = rsTransito.PrecioUnitario>
	<cfset ws_c_unidades = rsTransito.Unidad>
	<cfset ws_f_volumen = rsTransito.Volumen>
	<cfset ws_c_moneda = rsTransito.c_moneda>

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
		<cfset LvarUcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Unidad Incorrecta">
	<cfelse>
		<cfset LvarUcodigo = rsVerifica.Ucodigo>
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
		  and a.Miso4217 = 'USD'
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

	<!--- decodifica campo alloc_type_code  --->	
	<cfif rsTransito.alloc_type_code EQ "W">
		<cfset LvarOCTtipo = "B">
	<cfelseif rsTransito.alloc_type_code EQ "R">
		<cfset LvarOCTtipo = "F">
	<cfelse>
		<cfset LvarOCTtipo = "T">
	</cfif>

	<cfif ISDATE(rsTransito.bl_ticket_num)>
		<cfset Lvarbl_ticket_num=rsTransito.bl_ticket_num>
	<cfelse>
		<cfset Lvarbl_ticket_num=0>
	</cfif>

	<cfif ISDATE(rsTransito.bl_date)>
		<cfset Lvarbl_date=rsTransito.bl_date>
	<cfelse>
		<cfset Lvarbl_date=now()>
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
			<cfset ws_f_volumen = rsVerifica.CUAfactor * ws_f_volumen>
			<cfif ws_f_volumen EQ 0>
				<cfset ws_f_volumen = 1>
			</cfif>
			<cfset ws_f_precio = ws_f_Importe / ws_f_volumen>
			<cfset ws_c_unidades = LvarUcodigoArt>
		</cfif>
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
				and ti.p_s_ind = 'S'
				inner join allocation_item_transport a3
					on a3.alloc_num = a2.alloc_num
				   and a3.alloc_item_num = a2.alloc_item_num
				inner join trade_order oo
					on oo.trade_num = a2.trade_num
				   and oo.order_num = a2.order_num
			where a1.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTransito.trade_Num#">
			   and a1.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsTransito.order_Num#">
			   and a1.item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsTransito.item_Num#">
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
								 and ti.p_s_ind = 'S'
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

	<cfif Len(LvarTransporte) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Transporte no definido: #rsTransito.acct_ref_num#">
	</cfif>

	<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->
	<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
	<cfif LvarControlSocio NEQ rsTransito.acct_num or LvarControlDocto neq rsTransito.orden>
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
				<cfthrow message="La orden comercial #rsTransito.Orden# ya existe, este proceso no permite órdenes duplicadas">
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
						'O', '#LvarOCtipoIC#', #session.Ecodigo#,
						 #LvarSNid#, '#rsTransito.Orden#',
						 <cfif isdate(rsTransito.creation_date)>
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.creation_date#">,
						 <cfelse>
							null,
						 </cfif>
						 #LvarMcodigo#,
						 null,
						 'A','CP',
						 '#rsTransito.del_term_code#',
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
						 <cfif isdate(rsTransito.fecha_allocation)>
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.fecha_allocation#">,
						 <cfelse>
							null,
						 </cfif>
						 <cfif isdate(rsTransito.title_tran_date)>
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.title_tran_date#">,
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
					  <cfif isdate(rsTransito.load_compl_date)>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.load_compl_date#">,
					  <cfelse>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					  </cfif>
					  null,
					  null,
					  null,
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.nor_date#">,
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvarbl_ticket_num#">,
					  <cfif isdate(Lvarbl_date)>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
					  <cfelse>
						  null,
					  </cfif>
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
						  null,
					  </cfif>
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTransporte#">,
					  <cfif isdate(rsTransito.fecha_allocation)>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.fecha_allocation#">,
					  <cfelse>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					  </cfif>
					  <cfif isdate(rsTransito.title_tran_date)>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.title_tran_date#">,
					  <cfelse>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
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
					  <cfqueryparam cfsqltype="cf_sql_float" value="#ws_f_volumen#">,
					  <cfqueryparam cfsqltype="cf_sql_money" value="#ws_f_importe#">,
					  <cfqueryparam cfsqltype="cf_sql_float" value=0>,
					  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
				</cfquery>
			</cfif>
	
			<!---  revisa si existe el OCPTmovimientos en la estructura de órdenes comerciales --->
			<cfquery name="rsVerifica" datasource="#Session.Dsn#">
				select OCTid
				from OCPTmovimientos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
			</cfquery>
			<cfif rsVerifica.recordcount EQ 0>
				<cfquery name="query" datasource="#Session.Dsn#">
				  insert into OCPTmovimientos
					( OCTid, Aid, 
					  OCid, SNid, OCCid, OCVid, 
					  OCPTMtipoOD, OCPTMtipoICT, OCPTMtipoES, 
					  Ocodigo,
					  Oorigen, OCPTMdocumentoID, OCPTMdocumentoLinID, 
					  OCPTMfecha, OCPTMfechaTC,
					  Ecodigo, Ucodigo, OCPTMcantidad,
					  McodigoOrigen, 
					  OCPTMmontoOrigen, 
					  OCPTMmontoLocal, 
					  OCPTMmontoValuacion,
					  BMUsucodigo)
				  values (#vOCTid#, #LvarAid#, 
					  #vOCid#, #LvarSNid#, null, null, 
					  'O', 'C', 'E',    
					  0,
					  'CPFC', -1, -1, 
					 <cfif isdate(rsTransito.creation_date)>
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.creation_date#">,
					 <cfelse>
						null,
					 </cfif>
					 <cfif isdate(rsTransito.title_tran_date)>
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsTransito.title_tran_date#">,
					 <cfelse>
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					 </cfif>
					  #session.Ecodigo#, '#LvarUcodigoArt#', #ws_f_volumen#,
					  #LvarMcodigo#, 
					  #ws_f_Importe#, 
					  #ws_f_Importe#, 
					  #ws_f_Importe#,
					  #session.usucodigo#)
				</cfquery>
			</cfif>
	
			<!---  revisa si existe el OCPTdetalle en la estructura de órdenes comerciales --->
			<cfquery name="rsVerifica" datasource="#Session.Dsn#">
				select OCTid
				from OCPTdetalle
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
			</cfquery>
			<cfif rsVerifica.recordcount EQ 0>
				<cfquery name="query" datasource="#Session.Dsn#">
				  insert into OCPTdetalle
					( OCTid, Aid, 
					  OCPTDperiodo, OCPTDmes, 
					  OCPTDtipoTCI, 
					  Ocodigo, CFcuenta,
					  OCPTDmontoLocal, OCPTDmontoValuacion, 
					  BMUsucodigo)
				  values (#vOCTid#, #LvarAid#,
					  2006, 12,
					  'T',
					  0, 0,
					  #ws_f_Importe#, #ws_f_Importe#,
					  #session.usucodigo#)
				</cfquery>
			</cfif>
		</cfif>
		<cfset LvarControlSocio = rsTransito.acct_num>
		<cfset LvarControlDocto = rsTransito.orden>
	</cfif>
		<!--- FIN SECCION ORDENES COMERCIALES  --->

	<cfif isdefined("form.MostrarTodo") or len(LvarTipoError)>
		<cfif LvarTipoError EQ "Ya se Importó el Documento">
		<cfelse>
			<cfoutput>
			<tr>
				<td>#LSDateFormat(rsTransito.creation_date,'dd/mm/yyyy')#</td>
				<td>#0#</td>
				<td>#LsDateFormat(rsTransito.creation_date,'dd/mm/yyyy')#</td>
				<td>#0#-#0#</td>
				<td>#0#</td>
				<cfif LvarTipoError NEQ "">
					<td>#LvarTipoError#</td>
				<cfelse>
					<td>&nbsp;</td>
				</cfif>
				<td align="right">#numberformat(ws_f_volumen, ",0.00")#</td>
				<td align="right">#numberformat(0,",0.00")#</td>
				<td align="right">#numberformat(0,",0.00")#</td>
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
