<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<!--- Variable Form para CosICTS--->
<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>			
<cfif not isdefined("varCodICTS")>
	<cfabort showerror="No se especifico la Empresa a Procesar">
</cfif>

<cfset session.aa = "">
<cfset session.aaconse = 0>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
<cfset preictsdb       = Application.dsinfo.preicts.schema>
<cfset tesoreriadb     = Application.dsinfo.tesoreria.schema>

<cfset LvarHoraInicio = now()>

<!---
<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.EmpresaICTS = rsVerifica.CodICTS>
	<cfset session.EcodigoSDCSoin = rsVerifica.EcodigoSDCSoin>
</cfif>
--->

<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	<!---where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>

<cfif len("#varCodICTS#") EQ 0 OR len("#session.EcodigoSDC#") EQ 0 OR len("#session.DescripcionICTS#") EQ 0>
	<cfabort showerror="La empresa no aparece en int_ICTS_SOIN (Ecodigo=#session.Ecodigo#)">
</cfif>

<cfset LvarDsource = "#sifinterfacesdb#..">
<cfset session.Dsource = LvarDsource>

<!--- Para dejar los datos en la tabla de trabajo y evitar duplicar --->
<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#RecProdTranPMI where sessionid = #session.monitoreo.sessionid#
			or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
</cfquery>

<!---   tablas de trabajo creadas en sif_interfaces para pruebas y en sif_interfaces para producción
create table sif_interfaces..RecProdTranPMI
(fecharegistro date null,sessionid numeric null,
Ecodigo int null,OCItipoOD char(1) null, OCIfecha date null,Alm_Aid numeric null, OCIobservaciones varchar(255) null,
OCid int null,OCTid int null,Aid int null, OCIcantidad float null, OCIcostoValuacion money null, 
BMUsucodigo numeric null, Compra varchar(20) not null,TradeCompra int not null, Almacen varchar(20) not null,
TradeAlmacen int not null, alloc_num int not null,alloc_item_num int not null,title_tran_date date not null,
Producto varchar(15) not null, Unidad varchar(10) not null,Volumen float not null,mensajeerror varchar(255) null,
Transporte varchar(20) null)
--->

<!--- Crea La tabla con las entradas a almacen  --->
<!---Para compras Directas a Almacen--->
<cfquery datasource="sifinterfaces">
	insert #LvarDsource#RecProdTranPMI (fecharegistro,sessionid,
		Ecodigo,Compra,TradeCompra,Almacen,TradeAlmacen,alloc_num,alloc_item_num,
		title_tran_date,Producto,Unidad,Volumen,Transporte)
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
	a.acct_ref_num as Compra,a.trade_num as TradeCompra, aa.acct_ref_num as Almacen,
	aa.trade_num as TradeAlmacen,aa.alloc_num,aa.alloc_item_num,aa.title_tran_date,
	aa.cmdty_code as Producto, aa.sch_qty_uom_code as UnidadMedida
	,(select sum(ai_est_actual_net_qty) 
		from #preictsdb#..ai_est_actual 
		where aa.alloc_num = alloc_num 
		and aa.alloc_item_num = alloc_item_num  group by alloc_num, alloc_item_num) as Volumen,null
	from 	#preictsdb#..allocation_item a
			inner join
						#preictsdb#..trade_item b
						inner join 
									#preictsdb#..trade_order c
						on b.trade_num = c.trade_num and b.order_num = c.order_num and c.order_type_code like 'PHYSICAL'
			on a.trade_num = b.trade_num and a.item_num = b.item_num and a.order_num = b.order_num and b.p_s_ind like 'P'
			inner join
						#preictsdb#..allocation_item aa
						inner join
									#preictsdb#..trade_item ab
									inner join 
												#preictsdb#..trade_order ac
									on ab.trade_num = ac.trade_num and ab.order_num = ac.order_num 
									and ac.order_type_code like 'STORAGE'
						on aa.trade_num = ab.trade_num and aa.item_num = ab.item_num and aa.order_num = ab.order_num 
						and ab.p_s_ind like 'S'
			on a.alloc_num = aa.alloc_num and a.trade_num != aa.trade_num
	where aa.title_tran_date between
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaI)#">
		and
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaF)#">
	<!---and ab.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	and ab.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>
<!---Para compras por transporte a Almacen--->
<cfquery datasource="sifinterfaces">
	insert #LvarDsource#RecProdTranPMI (fecharegistro,sessionid,
		Ecodigo,Compra,TradeCompra,Almacen,TradeAlmacen,alloc_num,alloc_item_num,
		title_tran_date,Producto,Unidad,Volumen,Transporte)
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
	ba.acct_ref_num as Compra,ba.trade_num as TradeCompra, aa.acct_ref_num as Almacen,
	aa.trade_num as TradeAlmacen,aa.alloc_num,aa.alloc_item_num,aa.title_tran_date,
	aa.cmdty_code as Producto, aa.sch_qty_uom_code as UnidadMedida
	,(select sum(ai_est_actual_net_qty) 
		from preicts..ai_est_actual 
		where aa.alloc_num = alloc_num 
		and aa.alloc_item_num = alloc_item_num  group by alloc_num, alloc_item_num) as Volumen,a.acct_ref_num as Transporte
	from 	
	preicts..allocation_item ba
		inner join 
				preicts..trade_item bb
						inner join 
								preicts..trade_order bc
						on bb.trade_num = bc.trade_num and bb.order_num = bc.order_num 
						and bc.order_type_code like 'PHYSICAL'
		on ba.trade_num = bb.trade_num and ba.item_num = bb.item_num and ba.order_num = bb.order_num 
		and bb.p_s_ind like 'P'
		inner join 
				preicts..allocation_item ca
						inner join
								preicts..trade_item cb
										inner join 
												preicts..trade_order cc
										on cb.trade_num = cc.trade_num and cb.order_num = cc.order_num 
										and cc.order_type_code like 'TRANSPRT'
						on ca.trade_num = cb.trade_num and ca.item_num = cb.item_num and ca.order_num = cb.order_num 
						and cb.p_s_ind like 'S'	
						inner join 
								preicts..allocation_item a
										inner join
												preicts..trade_item b
														inner join 
																preicts..trade_order c
														on b.trade_num = c.trade_num and b.order_num = c.order_num 
														and c.order_type_code like 'TRANSPRT'
										on a.trade_num = b.trade_num and a.item_num = b.item_num 
										and a.order_num = b.order_num and b.p_s_ind like 'P'
										inner join
												preicts..allocation_item aa
														inner join
																preicts..trade_item ab
																		inner join 
																				preicts..trade_order ac
																on ab.trade_num = ac.trade_num 
																and ab.order_num = ac.order_num 
																and ac.order_type_code like 'STORAGE'
														on aa.trade_num = ab.trade_num and aa.item_num = ab.item_num 
														and aa.order_num = ab.order_num and ab.p_s_ind like 'S'
										on a.alloc_num = aa.alloc_num and a.trade_num != aa.trade_num
						on ca.trade_num = a.trade_num
		on ba.alloc_num = ca.alloc_num and ba.trade_num != ca.trade_num 
	where aa.title_tran_date between 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaI)#">
		and
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaF)#">
	<!---and ab.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	and ab.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfset LvarBanderaErrores = false>
<cfset LvarControlID = "">

<!--- procesa los registros de Producto Almacen --->	
<cfset LvarBanderaErrores_registro = False>

<!---Almacen Valido --->
<cfquery name="rsVerifica" datasource="sifinterfaces">
	update #LvarDsource#RecProdTranPMI
	set Alm_Aid = b.Aid
	from #LvarDsource#RecProdTranPMI a, #minisifdb#..Almacen b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and Almcodigo like a.Almacen
		and sessionid = #session.monitoreo.sessionid#
</cfquery>

<!---Articulo Valido --->
<cfquery name="rsVerifica" datasource="sifinterfaces">
	update #LvarDsource#RecProdTranPMI
	set Aid = b.Aid
	from #LvarDsource#RecProdTranPMI a, #minisifdb#..Articulos b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and Acodigo like a.Producto
		and sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Orden Comercial Valida --->
<cfquery datasource="sifinterfaces">
	update #LvarDsource#RecProdTranPMI
	set OCid = b.OCid
	from #LvarDsource#RecProdTranPMI a, #minisifdb#..OCordenComercial b
		where OCcontrato like Compra
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Transporte Valido Comercial Valida --->
<!--- Para Compras por Transporte a Almacen--->
<cfquery datasource="sifinterfaces">
	update #LvarDsource#RecProdTranPMI
	set OCTid = (select min(b.OCTid) from #minisifdb#..OCtransporte b 
					where ltrim(rtrim(a.Transporte)) like ltrim(rtrim(b.OCTtransporte))
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and exists (select 1 from #minisifdb#..OCtransporteProducto c where a.OCid = c.OCid and
									c.OCTid=b.OCTid)
					group by b.OCTtransporte)
	from #LvarDsource#RecProdTranPMI a 
		where a.Transporte is not null 
		and sessionid = #session.monitoreo.sessionid#
</cfquery>
<!--- Para Compras directas a Almacen--->
<cfquery datasource="sifinterfaces">
	update #LvarDsource#RecProdTranPMI
	set OCTid = (select min(b.OCTid) from #minisifdb#..OCtransporte b 
					where ltrim(rtrim(a.Compra)) like ltrim(rtrim(b.OCTtransporte))
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and exists (select 1 from #minisifdb#..OCtransporteProducto c where a.OCid = c.OCid and
									c.OCTid=b.OCTid)
					group by b.OCTtransporte)
	from #LvarDsource#RecProdTranPMI a 
		where a.OCTid is null 
		and sessionid = #session.monitoreo.sessionid#
</cfquery>
<!---Para Compras que tienen como transporte el almacen
<cfquery datasource="sifinterfaces">
	update #LvarDsource#RecProdTranPMI
	set OCTid = (select min(b.OCTid) from #minisifdb#..OCtransporte b 
					where a.Almacen=b.OCTtransporte 
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and exists (select 1 from #minisifdb#..OCtransporteProducto c where a.OCid = c.OCid and
									c.OCTid=b.OCTid)
					group by b.OCTtransporte)
	from #LvarDsource#RecProdTranPMI a 
		where a.OCTid is null 
		and sessionid = #session.monitoreo.sessionid#
</cfquery>
--->

<!--- Validacion para los registros de Productos a Inventario --->
<cfquery name="rsProducto" datasource="#session.dsn#">
	select * from #LvarDsource#RecProdTranPMI
		where sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfloop query="rsProducto"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">
	<cfset rp_AlmAid = rsProducto.Alm_Aid>
	<cfset rp_Aid = rsProducto.Aid>
	<cfset rp_OCid = rsProducto.OCid>
	<cfset rp_OCTid = rsProducto.OCTid>	
	<cfset rp_Compra = rsProducto.Compra>
	<cfset rp_Transporte = rsProducto.Transporte>
		
	<!--- Verifica si el movimiento ya fue aplicado --->
	<cfif len(rp_AlmAid) GT 0>
		<cfquery name="Vdocumento" datasource="#session.dsn#">
			select * from OCinventario 
				where Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rp_AlmAid#">
				and OCIfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsProducto.title_tran_date#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		<cfif Vdocumento.recordcount GT 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Documento de entrada a Almacen ya aplicado">
		</cfif>
	</cfif>
	<!---Valida Orden Comercial--->
	<cfif len(rp_OCid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Orden Comercial no Existe estructura OC SOIN-SIF">
	</cfif>
	<!---Valida Transporte--->
	<cfif len(rp_OCTid) EQ 0 AND len(rp_OCid) GT 0>
		<cfif len(rp_Transporte) GT 0>
			<cfset vr_tran = rp_Transporte>
		<cfelse>
			<cfset vr_tran = rp_Compra>
		</cfif>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Transporte #vr_Tran# No existe en estructura OC SOIN-SIF">
	</cfif>
	<!---Valida el Almacen--->
	<cfif len(rp_AlmAid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Almacen no Existe en SOIN-SIF">
	</cfif>
	<!--- Valida Producto --->	
	<cfif len(rp_Aid) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Articulo no Existe en SOIN-SIF">
	<cfelse>
		<!--- Validacion de Factor de Conversion--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from #minisifdb#..Articulos b
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rp_Aid#">
		</cfquery>
		<cfif trim(rsProducto.Unidad) NEQ trim(rsVerifica.Ucodigo)>
			<cfquery name="rsVerificaD" datasource="sifinterfaces">
				select * from #minisifdb#..ConversionUnidadesArt
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rp_Aid#">
					and Ucodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProducto.Unidad#">
			</cfquery>
			<cfif rsVerificaD.recordcount EQ 0>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "No existe el factor de conversion #rsProducto.Unidad#
													 a #rsVerifica.Ucodigo# para #rsProducto.Producto# en SOIN-SIF">
			<cfelse>
				<!---Actualiza el volumen si la unidad es diferente a la del articulo--->
				<cfquery datasource="sifinterfaces">
					update #LvarDsource#RecProdTranPMI
					set Unidad = '#rsVerifica.Ucodigo#',Volumen = Volumen * #rsVerificaD.CUAfactor#
					where TradeCompra = #rsProducto.TradeCompra#
						and TradeAlmacen = #rsProducto.TradeAlmacen#
						and alloc_num = #rsProducto.alloc_num#
						and alloc_item_num = #rsProducto.alloc_item_num#
						and sessionid = #session.monitoreo.sessionid#
				</cfquery>
			</cfif>
		</cfif>
	</cfif>	
	<!---Valida que el producto este registrado en el transporte--->
	<cfif len(rp_Aid) GT 0 AND len(rp_OCTid) GT 0>
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select * from OCproductoTransito where OCTid = #rp_OCTid# and Aid = #rp_Aid#
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Producto: #rsProducto.Producto# no registrado en Transporte">
		</cfif>
	</cfif>
	<!---Parametriza los campos usados en OCinventario y OCinventarioProducto--->
	<cfquery datasource="#session.dsn#">
		UPDATE #LvarDsource#RecProdTranPMI
			SET Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
			OCItipoOD = 'D', OCIfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#rsProducto.title_tran_date#">,
			OCIobservaciones = 'Documento generado desde la Interfaz de Recepción de Producto en Tránsito',
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		from #LvarDsource#RecProdTranPMI
		where TradeCompra = #rsProducto.TradeCompra#
			and TradeAlmacen = #rsProducto.TradeAlmacen#
			and alloc_num = #rsProducto.alloc_num#
			and alloc_item_num = #rsProducto.alloc_item_num#
			and sessionid = #session.monitoreo.sessionid#
	</cfquery>
		
	<!--- actualizar el mensaje de error  --->
	<cfquery datasource="#session.dsn#">
		UPDATE #LvarDsource#RecProdTranPMI
			SET mensajeerror = case 
								when '#LvarTipoError#' = '' then null
								else
								'#LvarTipoError#'
							  end
		from #LvarDsource#RecProdTranPMI
		where TradeCompra = #rsProducto.TradeCompra#
			and TradeAlmacen = #rsProducto.TradeAlmacen#
			and alloc_num = #rsProducto.alloc_num#
			and alloc_item_num = #rsProducto.alloc_item_num#
			and sessionid = #session.monitoreo.sessionid#
	</cfquery>
</cfloop>

