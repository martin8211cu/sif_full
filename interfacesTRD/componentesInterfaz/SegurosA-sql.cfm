<!--- Modificado por Ing. Luis A. Bolaños Gómez 
Validacion del proceso y conslusión del mismo 
Se agregaron rutinas de validacion de errores para articulos y para encontrar
correctamente las ordenes de venta a las que se tienen que cargar los seguros --->
<!--- Archivo    :  SegurosA-sql.cfm     --->
<cfset session.aa = "">
<cfset session.aaconse = 0>

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
<cfset tesoreriadb     = Application.dsinfo.tesoreria.schema>

<cfset LvarHoraInicio = now()>

<cfset session.FechaFolio = "#year(now())##month(now())#"> 

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

<cfset LvarDsource = "#sifinterfacesdb#..">
<cfset session.Dsource = LvarDsource>

<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#segurosPMI where sessionid = #session.monitoreo.sessionid#
			or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from #LvarDsource#segurosPolizasPMI where sessionid = #session.monitoreo.sessionid#
			or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from #LvarDsource#segurosVentasPMI where sessionid = #session.monitoreo.sessionid#
			or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from #LvarDsource#segurosArticulosPMI where sessionid = #session.monitoreo.sessionid#
			or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
</cfquery>

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfaces..segurosPMI (fecharegistro date null,sessionid numeric null,
		conse varchar(30) null, CFmascaraIngreso varchar(100) null, CFmascaraCostoVenta varchar(100) null,
		trade_num integer null, order_num smallint null, item_num smallint null, Documento char(20) null,
		tipo_poliza char(10) null, prima_cargo float null, encabezado_id integer null,
		moneda char(5) null, fecha_creacion date null, ExisteOrden char(1) null,
		OCid numeric null, OCtipoOD char(1) null, OCtipoIC char(1) null, OCVid numeric null,
		OCcontrato varchar(20) null, SNid numeric null, Aid numeric null, OCTid numeric null,
		Acodalterno char(20) null, SNcodigoext varchar(25) null,
		cmdty_code varchar(8) null, mensajeerror varchar(200) null, orden char(10) null,
		order_type_code varchar(8) null, cost_code varchar(8) null,
		UcodigoArt char(5) null, Mcodigo numeric null, Ucodigo char(5) null, TCventa float null,
		subconcepto integer null, CodigoConcepto char(5) null, cost_type_code varchar(8) null)

create table sif_interfaces..segurosVentasPMI (fecharegistro date null,sessionid numeric null,
		OCidCompra numeric null, OCidVenta numeric null, OCcontrato char(10) null,
		OCVid numeric null, SNid numeric null,
		CFmascaraIngreso varchar(100) null, CFmascaraCostoVenta varchar(100) null, OCtipoIC char(1) not null)

create table sif_interfaces..segurosPolizasPMI (fecharegistro date null,sessionid numeric null,
		encabezado_id integer not null, fecha_creacion date null,tipo_poliza varchar(5) not null, 
		EDocbase varchar(20) not null)

create table sif_interfaces..segurosArticulosPMI (fecharegistro date null,sessionid numeric null,
		OCid numeric null, Aid numeric null, Acodalterno char(20) null,
		Cformato varchar(100) null)
create index OCID_INDEX 
on sif_interfaces..segurosArticulosPMI(OCid)
create index ENC_INDEX 
on sif_interfaces..segurosPolizasPMI (encabezado_id)
--->

<cfif form.TipoSeguro EQ "0">
	<cfset LvarTipoPoliza = "CHL">
	<!--- Crea la tabla con los encabezados a los que se les asignara una poliza ---> 
	<cfquery datasource="tesoreria">
		insert #LvarDsource#segurosPolizasPMI (fecharegistro,sessionid,
			encabezado_id, fecha_creacion,tipo_poliza,EDocbase)
		select getdate(), #session.monitoreo.sessionid# as sessionid,
			encabezado_id,fecha_creacion,tipo_poliza,Rtrim(Convert(char,enc.encabezado_id))||'#LvarTipoPoliza#'
		from PmiSegEncabezados enc
		where enc.encabezado_id <> 0
		  and enc.es_contable = 'Y'
		  and enc.tipo_poliza = '#LvarTipoPoliza#'
		  and not Exists (select 1 from #minisifdb#..EContablesImportacion where Edocbase = 
						  Rtrim(Convert(char, enc.encabezado_id))||'#LvarTipoPoliza#')
		  and not Exists (select 1 from #minisifdb#..EContables where Edocbase = 
						  Rtrim(Convert(char, enc.encabezado_id))||'#LvarTipoPoliza#')
		  and not Exists (select 1 from #minisifdb#..HEContables where Edocbase = 
						  Rtrim(Convert(char, enc.encabezado_id))||'#LvarTipoPoliza#')
	</cfquery>
	<!--- Crea query de seguros charter  --->
	<cfquery datasource="tesoreria">
		insert #LvarDsource#segurosPMI (fecharegistro, sessionid, conse,
			encabezado_id, trade_num, orden, prima_cargo,
			moneda, fecha_creacion, tipo_poliza)
		select getdate(), #session.monitoreo.sessionid# as sessionid, newid(),
			enc.encabezado_id, det.trade_num, det.orden, det.prima_fdd + det.prima_pandi +
			det.prima_hull as prima_cargo, det.moneda, enc.fecha_creacion, '#LvarTipoPoliza#'
		from #LvarDsource#segurosPolizasPMI enc
			inner join PmiSegChlTemp det
			on det.encabezado_id = enc.encabezado_id
			and enc.sessionid = #session.monitoreo.sessionid#
		order by enc.encabezado_id, det.trade_num
	</cfquery>
<cfelse>
	<cfset LvarTipoPoliza = "CARGO">
	<!--- Crea la tabla con los encabezados a los que se les asignara una poliza ---> 
	<cfquery datasource="tesoreria">
		insert #LvarDsource#segurosPolizasPMI (fecharegistro,sessionid,
			encabezado_id, fecha_creacion,tipo_poliza,EDocbase)
		select getdate(), #session.monitoreo.sessionid# as sessionid,
			encabezado_id,fecha_creacion,tipo_poliza,Rtrim(Convert(char,enc.encabezado_id))||'#LvarTipoPoliza#'
		from PmiSegEncabezados enc
		where enc.encabezado_id <> 0
		  and enc.es_contable = 'Y'
		  and enc.tipo_poliza = '#LvarTipoPoliza#'
		  and not Exists (select 1 from #minisifdb#..EContablesImportacion where Edocbase = 
						  Rtrim(Convert(char, enc.encabezado_id))||'#LvarTipoPoliza#')
		  and not Exists (select 1 from #minisifdb#..EContables where Edocbase = 
						  Rtrim(Convert(char, enc.encabezado_id))||'#LvarTipoPoliza#')
		  and not Exists (select 1 from #minisifdb#..HEContables where Edocbase = 
						  Rtrim(Convert(char, enc.encabezado_id))||'#LvarTipoPoliza#')
	</cfquery>
		<!--- Crea query de seguros carga  --->
	<cfquery datasource="tesoreria">
		insert #LvarDsource#segurosPMI (fecharegistro, sessionid, conse,
			encabezado_id, trade_num, orden, prima_cargo,
			moneda, fecha_creacion, tipo_poliza)
		select getdate(), #session.monitoreo.sessionid# as sessionid, newid(),
			enc.encabezado_id, det.trade_num, det.orden, det.prima_carga as prima_cargo,
			det.moneda, enc.fecha_creacion, '#LvarTipoPoliza#'
		from #LvarDsource#segurosPolizasPMI enc
			inner join PmiSegTemp2 det
			on det.encabezado_id = enc.encabezado_id
		where enc.encabezado_id <> 0
			and enc.sessionid = #session.monitoreo.sessionid#
		order by enc.encabezado_id, det.trade_num
	</cfquery>
</cfif>

<cfset LvarBanderaErrores = false>
<cfset LvarControlID = "">
<cfset ArregloProductos = ArrayNew(1)>

<!--- procesa los registros de seguros --->	
<cfset LvarBanderaErrores_registro = False>

<!--- validar cuenta financiera de seguros    --->	
	<cfif trim(LvarTipoPoliza) EQ 'CHL'>
		<cfset ws_CuentaFinancieraSeg = "1115-007">
	<cfelse>
		<cfset ws_CuentaFinancieraSeg = "1115-008">
	</cfif>			
	<!-- validar la cuenta definida para seguros  -->
	<cfquery name="rsVerifica" datasource="#minisifdb#">
		select Cformato from CContables
		where Ecodigo = #session.ecodigo#
		  and Cformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="#ws_CuentaFinancieraSeg#">
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset ws_error_CS = "La cuenta asignada para seguros no existe: " & ws_CuentaFinancieraSeg>
		<cfabort showerror="#ws_error_CS#">	
	</cfif>

<!--- Moneda es Valida  --->
<cfquery datasource="#minisifdb#">
	UPDATE #LvarDsource#segurosPMI SET Mcodigo = a2.Mcodigo
	from #LvarDsource#segurosPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = case 
	  						when a1.moneda = 'MXN' then 'MXP'
						 	else substring(a1.moneda,1,3)
						 end
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Trade_Num es valido  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#segurosPMI SET ExisteOrden = 'S', OCid = a2.OCid,
	  OCtipoOD = a2.OCtipoOD, OCtipoIC = a2.OCtipoIC, OCVid = a2.OCVid,
	  OCcontrato = a2.OCcontrato, SNid = a2.SNid
	from #LvarDsource#segurosPMI a1, #minisifdb#..OCordenComercial a2, trade a3
	where a3.trade_num = a1.trade_num
	  and a2.OCcontrato = a3.acct_ref_num
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- obtiene la máscara de OCtipoVenta  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#segurosPMI SET CFmascaraIngreso = a2.CFmascaraIngreso,
			CFmascaraCostoVenta = a2.CFmascaraCostoVenta
	from #LvarDsource#segurosPMI a1, #minisifdb#..OCtipoVenta a2
	where a1.OCVid = a2.OCVid
	  and a1.ExisteOrden = 'S'
	  and a1.OCtipoOD = 'D'
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- busca el transporte asignado OCTid solo para las compras  --->
<cfquery datasource="#minisifdb#">
	UPDATE #LvarDsource#segurosPMI SET OCTid = a3.OCTid
	from #LvarDsource#segurosPMI a1
		inner join OCtransporteProducto a2
			inner join OCtransporte a3
			on a3.OCTid = a2.OCTid
			and a3.Ecodigo = a2.Ecodigo
		on a2.OCid = a1.OCid
		and a2.OCTid = a3.OCTid
		and a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where a1.ExisteOrden = 'S'
	  and a1.OCtipoOD = 'O' 
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- QUE PASA CUANDO LA COMPRA ESTA RELACIONADA CON UNA ORDEN DE ALMACEN Y NO CON UNA VENTA Ver linea: 421,506 --->
<!--- cuando es una compra graba las ventas relacionadas  --->
<cfquery datasource="#minisifdb#">
	insert #LvarDsource#segurosVentasPMI (fecharegistro, sessionid, OCidCompra, OCidVenta,
					 OCcontrato, OCVid, SNid, OCtipoIC)
	select getdate(), #session.monitoreo.sessionid# as sessionid,
	       a1.OCid, a3.OCid, a3.OCcontrato, a3.OCVid, a3.SNid, a3.OCtipoIC
	from #LvarDsource#segurosPMI a1, OCtransporteProducto a2, OCordenComercial a3
	where a3.OCid = a2.OCid
	  and a3.OCtipoOD = 'D'
	  and a1.OCTid = a2.OCTid
	  and a1.ExisteOrden = 'S'
	  and a1.OCtipoOD = 'O'
</cfquery>

<!--- graba detalles de Articulos por Orden Comercial desde segurosVentasPMI  --->
<cfquery datasource="#minisifdb#">
	insert #LvarDsource#segurosArticulosPMI (OCid, fecharegistro, sessionid, Aid, Acodalterno)
	select distinct a2.OCid, getdate(), #session.monitoreo.sessionid# as sessionid,
	       a2.Aid, a3.Acodalterno
	from #LvarDsource#segurosVentasPMI a1, OCordenProducto a2, Articulos a3
	where a1.OCidVenta = a2.OCid
	  and a2.Aid = a3.Aid
</cfquery>

<!--- graba detalles de Articulos por Orden Comercial desde segurosPMI solo para ventas --->
<cfquery datasource="#minisifdb#">
	insert #LvarDsource#segurosArticulosPMI (OCid, fecharegistro, sessionid, Aid, Acodalterno)
	select distinct a2.OCid, getdate(), #session.monitoreo.sessionid# as sessionid,
	       a2.Aid, a3.Acodalterno
	from #LvarDsource#segurosPMI a1, OCordenProducto a2, Articulos a3
	where a1.OCid = a2.OCid
	  and a1.ExisteOrden = 'S'
	  and a1.OCtipoOD = 'D'
	  and a2.Aid = a3.Aid
</cfquery>

<!--- obtiene la máscara de OCtipoVenta  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#segurosVentasPMI SET CFmascaraIngreso = a2.CFmascaraIngreso,
			CFmascaraCostoVenta = a2.CFmascaraCostoVenta
	from #LvarDsource#segurosVentasPMI a1, #minisifdb#..OCtipoVenta a2
	where a1.OCVid = a2.OCVid
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#minisifdb#">
	UPDATE #LvarDsource#segurosPMI SET SNcodigoext = a2.SNcodigoext
	from #LvarDsource#segurosPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.SNid  = a1.SNid
	  and a1.sessionid = #session.monitoreo.sessionid#
	  and a1.ExisteOrden = 'S'
</cfquery> 
<!---Este subconcepto no es necesario por que todos son seguros--->
<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#segurosPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#segurosPMI a1
	WHERE s.costo_id = a1.cost_code
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id
	  AND sb.subconcepto_id = r.subconcepto_id
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- código de Concepto  --->
<cfquery datasource="#minisifdb#">
	UPDATE #LvarDsource#segurosPMI SET CodigoConcepto = a2.cuentac
	from #LvarDsource#segurosPMI a1, Conceptos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Ccodigo = Convert(char,a1.subconcepto)
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Moneda Local  --->
<cfquery name="rsVerifica" datasource="#minisifdb#">
	select emp.Mcodigo from Empresas emp
		inner join Monedas mon
		on mon.Mcodigo = emp.Mcodigo
		and mon.Ecodigo = emp.Ecodigo
	where emp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset LvarMonedaLocal = rsVerifica.Mcodigo>
<cfelse>
	<cfset LvarMonedaLocal = "">
</cfif>

<!--- Tipo de cambio  --->
<cfquery name="rsVerifica" datasource="#minisifdb#">
	UPDATE #LvarDsource#segurosPMI SET TCventa = a2.TCventa
	from #LvarDsource#segurosPMI a1, Htipocambio a2 
	where a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a2.Mcodigo = a1.Mcodigo
	  and a2.Hfecha = (select max(Hfecha) from Htipocambio where Hfecha <= a1.fecha_creacion)
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Cformato  --->
<cfquery name="rsVerifica" datasource="#minisifdb#">
	UPDATE #LvarDsource#segurosArticulosPMI SET Cformato = a4.Cformato
	from #LvarDsource#segurosArticulosPMI a5, CContables a4,
	     Articulos a1, Clasificaciones a2, IAContables a3
	where a4.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a3.Ecodigo = a2.Ecodigo
	  and a3.IACcodigogrupo = a2.Ccodigoclas
	  and a2.Ccodigo = a1.Ccodigo
	  and a2.Ecodigo = a1.Ecodigo
 	  and a1.Ecodigo = a4.Ecodigo
	  and a1.Aid = a5.Aid
	  and a4.Ccuenta = a3.IACtransito
	  and a5.sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfquery name="rsSeguros" datasource="sifinterfaces">
	select *
	from  #LvarDsource#segurosPMI where sessionid = #session.monitoreo.sessionid#
	order by trade_num
</cfquery>

<cfloop query="rsSeguros"> 
	<cfset ws_compra = rsSeguros.orden>
	<cfset session.aa = rsSeguros.trade_num>
	<cfset session.aaconse = session.aaconse + 1>
	
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- validar Moneda Local  --->
	<cfif len(LvarMonedaLocal) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existe la moneda Local">
	</cfif>

	<!--- Existencia del trade  --->
	<cfif Len(rsSeguros.ExisteOrden) EQ 0 and Len(rsSeguros.trade_num) GT 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Orden Comercial #rsSeguros.orden# no existe SOIN-SIF">
	</cfif>
	
	<cfif Len(rsSeguros.trade_num) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Trade no especificado en tabla Seguros de Tesoreria">
	</cfif>
	
	<!--- Moneda es Valida  --->
	<cfif Len(rsSeguros.Mcodigo) EQ 0>
		<cfset LvarMcodigo = 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
	<cfelse>
		<cfset LvarMcodigo = rsSeguros.Mcodigo>
	</cfif> 

	<!--- validar Tipo de cambio  --->
	<cfif Len(rsSeguros.TCventa) EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No existe el tipo de cambio">
	</cfif>

	<!--- crear folio de seguros     --->
	<cfset ws_folio = "#rsSeguros.orden#SEGU#rsSeguros.encabezado_id#-#rsSeguros.tipo_poliza#">
	<cfset ws_tipo_transaccion = "FC">

	<!--- buscar ordenes de venta entre las cuales distribuir el monto del seguro --->
	<cfif rsSeguros.ExisteOrden EQ 'S'>
		<cfif rsSeguros.OCtipoOD EQ 'O'>       <!-- la orden es una compra  -->
			<cfset ws_SNcodigoext = rsSeguros.SNcodigoext>
			<cfset ws_SNid = rsSeguros.SNid>
			<cfset ws_OCcontrato = rsSeguros.OCcontrato>
			<cfset ws_OCVid = rsSeguros.OCVid>
			<cfquery name="rsVentas" datasource="sifinterfaces">
				select distinct OCidCompra, OCidVenta, OCcontrato, OCVid, SNid, 
					   CFmascaraIngreso, CFmascaraCostoVenta,OCtipoIC
				from segurosVentasPMI
				where OCidCompra = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSeguros.OCid#">
				  and sessionid = #session.monitoreo.sessionid#
			</cfquery>	
			<cfif rsVentas.recordcount GT 0>
				<cfloop query="rsVentas">
					<cfset ws_OCtipoIC = rsVentas.OCtipoIC>
					<cfset ws_OCidCompra = rsVentas.OCidCompra>
					<cfset ws_OCidVenta = rsVentas.OCidVenta>
					<cfset ws_OCcontrato = rsVentas.OCcontrato>
					<cfset ws_OCVid = rsVentas.OCVid>
					<cfset ws_SNid = rsVentas.SNid>
					<cfset ws_CFmascaraIngreso = rsVentas.CFmascaraIngreso>
					<cfset ws_CFmascaraCostoVenta = rsVentas.CFmascaraCostoVenta>
					<cfquery name="rsArticulos" datasource="sifinterfaces">
						select distinct OCid, Aid, Acodalterno, Cformato from segurosArticulosPMI 
						where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_OCidVenta#">
						  and sessionid = #session.monitoreo.sessionid#
					</cfquery>		
					<cfif rsArticulos.recordcount GT 0>
						<cfloop query="rsArticulos">
							<cfif ws_OCtipoIC EQ 'I'>
								<cfset ProdStruct = StructNew()>
								<cfset ProdStruct.Producto = 'ALMACEN'>
								<cfset ProdStruct.Aid = rsArticulos.Aid>
								<cfset ProdStruct.Cformato = rsArticulos.Cformato>
								<cfset ProdStruct.SNid = ws_SNid>
								<cfset ProdStruct.OCVid = 0>
								<cfset ProdStruct.Orden = ws_compra>
								<cfset ProdStruct.OrdenVenta = ws_OCcontrato>
								<cfset ProdStruct.MascaraIngreso = ws_CFmascaraIngreso>
								<cfset ProdStruct.MascaraCostoVenta = ws_CFmascaraCostoVenta>
								<cfset ProdStruct.CuentaFinanciera = "">
								<cfset ArrayAppend(ArregloProductos,ProdStruct)>
							<cfelse>
								<!--- Existencia del Articulo Orden Distribución  --->
								<cfif len(rsArticulos.Acodalterno) GT 0>
									<cfset ws_Articulo = rsArticulos.Aid>
									<cfset ws_Producto = rsArticulos.Acodalterno>
								<cfelse>
									<cfset ws_Articulo = "">
									<cfset LvarBanderaErrores_registro = true>
									<cfset LvarBanderaErrores = true>
									<cfif len(LvarTipoError)>
										<cfset LvarTipoError = LvarTipoError & ", ">
									</cfif>
									<cfset LvarTipoError = LvarTipoError & "No existe Art./Compl. #rsArticulos.Aid#">
								</cfif>
<!---El socio para el caso practico no interesa ya que el socio que se tomaria seria el de seguro siempre es 002-001 --->
				<!--- Existencia del Socio de Orden Comercial Distribución  --->
								<cfif len(ws_SNcodigoext) GT 0>
									<cfset ws_Socio = ws_SNid>
								<cfelse>
									<cfset ws_Socio = "">
									<cfset LvarBanderaErrores_registro = true>
									<cfset LvarBanderaErrores = true>
									<cfif len(LvarTipoError)>
										<cfset LvarTipoError = LvarTipoError & ", ">
									</cfif>
									<cfset LvarTipoError = LvarTipoError & "No existe Socio #ws_SNid#">
								</cfif>
				
								<cfif len(ws_Articulo) GT 0 and len(ws_Socio) GT 0>
									<cfset ProdStruct = StructNew()>
									<cfset ProdStruct.Producto = ws_Producto>
									<cfset ProdStruct.Aid = ws_Articulo>
									<cfset ProdStruct.Cformato = rsArticulos.Cformato>
									<cfset ProdStruct.SNid = ws_Socio>
									<cfset ProdStruct.OCVid = ws_OCVid>
									<cfset ProdStruct.Orden = ws_compra>
									<cfset ProdStruct.OrdenVenta = ws_OCcontrato>
									<cfset ProdStruct.MascaraIngreso = ws_CFmascaraIngreso>
									<cfset ProdStruct.MascaraCostoVenta = ws_CFmascaraCostoVenta>
									<cfset ProdStruct.CuentaFinanciera = "">
									<cfset ArrayAppend(ArregloProductos,ProdStruct)>
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfloop>
			<cfelse>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "No existen ventas para la orden #rsSeguros.orden#">
			</cfif>
		<cfelse>        <!-- la orden es una venta  -->
			<cfset ws_SNid = rsSeguros.SNid>
			<cfset ws_OCcontrato = rsSeguros.OCcontrato>
			<cfset ws_OCVid = rsSeguros.OCVid>
			<cfset ws_CFmascaraIngreso = rsSeguros.CFmascaraIngreso>
			<cfset ws_CFmascaraCostoVenta = rsSeguros.CFmascaraCostoVenta>
			<cfset ws_SNcodigoext = rsSeguros.SNcodigoext>
			
			<cfquery name="rsArticulos" datasource="sifinterfaces">
				select distinct OCid, Aid, Acodalterno, Cformato from segurosArticulosPMI 
				where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSeguros.OCid#">
				  and sessionid = #session.monitoreo.sessionid#
			</cfquery>		
			<cfif rsArticulos.recordcount GT 0>
				<cfloop query="rsArticulos">
					<cfset ws_Articulo = rsArticulos.Aid>
					<cfset ws_Cformato = rsArticulos.Cformato>
					<cfset ws_Acodalterno = rsArticulos.Acodalterno>
	
					<cfif rsSeguros.OCtipoIC EQ 'I'>
						<cfset ProdStruct = StructNew()>
						<cfset ProdStruct.Producto = 'ALMACEN'>
						<cfset ProdStruct.Aid = ws_Articulo>
						<cfset ProdStruct.Cformato = ws_Cformato>
						<cfset ProdStruct.SNid = ws_SNid>
						<cfset ProdStruct.OCVid = 0>
						<cfset ProdStruct.Orden = ws_compra>
						<cfset ProdStruct.OrdenVenta = ws_OCcontrato>
						<cfset ProdStruct.MascaraIngreso = ws_CFmascaraIngreso>
						<cfset ProdStruct.MascaraCostoVenta = ws_CFmascaraCostoVenta>
						<cfset ProdStruct.CuentaFinanciera = "">
						<cfset ArrayAppend(ArregloProductos,ProdStruct)>
					<cfelse>
						<!--- Existencia del Articulo Orden Distribución  --->
						<cfif len(ws_Acodalterno) GT 0>
							<cfset ws_Producto = ws_Acodalterno>
						<cfelse>
							<cfset ws_Articulo = "">
							<cfset LvarBanderaErrores_registro = true>
							<cfset LvarBanderaErrores = true>
							<cfif len(LvarTipoError)>
								<cfset LvarTipoError = LvarTipoError & ", ">
							</cfif>
							<cfset LvarTipoError = LvarTipoError & "No existe Art./Compl. #ws_Articulo#">
						</cfif>
		
						<!--- Existencia del Socio de Orden Comercial Distribución  --->
						<cfif len(ws_SNcodigoext) GT 0>
							<cfset ws_Socio = ws_SNid>
						<cfelse>
							<cfset ws_Socio = "">
							<cfset LvarBanderaErrores_registro = true>
							<cfset LvarBanderaErrores = true>
							<cfif len(LvarTipoError)>
								<cfset LvarTipoError = LvarTipoError & ", ">
							</cfif>
							<cfset LvarTipoError = LvarTipoError & "No existe Socio #ws_SNid#">
						</cfif>
		
						<cfif len(ws_Articulo) GT 0 and len(ws_Socio) GT 0>
							<cfset ProdStruct = StructNew()>
							<cfset ProdStruct.Producto = ws_Producto>
							<cfset ProdStruct.Aid = ws_Articulo>
							<cfset ProdStruct.Cformato = ws_Cformato>
							<cfset ProdStruct.SNid = ws_Socio>
							<cfset ProdStruct.OCVid = ws_OCVid>
							<cfset ProdStruct.Orden = ws_compra>
							<cfset ProdStruct.OrdenVenta = ws_OCcontrato>
							<cfset ProdStruct.MascaraIngreso = ws_CFmascaraIngreso>
							<cfset ProdStruct.MascaraCostoVenta = ws_CFmascaraCostoVenta>
							<cfset ProdStruct.CuentaFinanciera = "">
							<cfset ArrayAppend(ArregloProductos,ProdStruct)>
						</cfif>
					</cfif>	
				</cfloop>
			</cfif>
		</cfif>
	</cfif>

	<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
		<!--- Verifica que el producto tenga su complemento contable --->
		<cfset LvarAid = ArregloProductos[i].Aid>
		<cfquery name="OCcompArt" datasource="#minisifdb#">
			select Aid,CFcomplementoCostoVenta
			from OCcomplementoArticulo
			where Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAid#">
		</cfquery>
		<cfif OCcompArt.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Articulo #LvarAid# no tiene Complemento Parametrizado">
		<cfelse>
			<cfset ws_ComplementoArticulo = OCcompArt.CFcomplementoCostoVenta>
			<cfif len(ws_ComplementoArticulo) EQ 0 OR len(ws_ComplementoArticulo) LT 6>
				<cfset LvarBanderaErrores_registro = true>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Articulo #LvarAid# no tiene Complemento Parametrizado">
			<cfelse>
				<cfset ws_ComplementoArticulo = Left("#OCcompArt.CFcomplementoCostoVenta#",3) & '-' & Right("#OCcompArt.CFcomplementoCostoVenta#",3)>
				<cfset ArregloProductos[i].CuentaFinanciera = replace(ArregloProductos[i].MascaraCostoVenta,'AAA-AAA',"#ws_ComplementoArticulo#")>
			</cfif>
		</cfif>
		<cfset ArregloProductos[i].CuentaFinanciera = replace(ArregloProductos[i].CuentaFinanciera,'CCC','009')>
		<cfset ArregloProductos[i].CuentaFinanciera = replace(ArregloProductos[i].CuentaFinanciera,'SSS-SSS','002-001')>
		<!--- Arma la cuenta contable --->
		<cfset ws_CuentaFinancieraDet = ArregloProductos[i].Cformato>
		<cfset LvarAid = ArregloProductos[i].Aid>
		<cfif len(ws_CuentaFinancieraDet) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Cuenta del artículo #LvarAid# no existe">
		</cfif>
	</cfloop>

	<!--- actualizar el mensaje de error  --->
	<cfquery datasource="#minisifdb#">
		UPDATE #LvarDsource#segurosPMI
		   SET mensajeerror = case 
								when '#LvarTipoError#' = '' then null
								else
								'#LvarTipoError#'
							  end,
		   Documento = '#ws_folio#'
		from #LvarDsource#segurosPMI 
		where conse = '#rsSeguros.conse#'
		  and trade_num = #rsSeguros.trade_num#
		  and sessionid = #session.monitoreo.sessionid#
	</cfquery>
	<cfset Tempc = ArrayClear(ArregloProductos)>
</cfloop>
<!---
<cfquery name="Debug" datasource="sifinterfaces">
	select * from #LvarDsource#segurosPMI a where  sessionid = #session.monitoreo.sessionid# 
</cfquery>
<cfquery name="Debug2" datasource="sifinterfaces">
	select count(distinct OCidCompra) as cuenta,* from #LvarDsource#segurosVentasPMI where sessionid = #session.monitoreo.sessionid# group by sessionid
</cfquery>
<cfquery name="Debug3" datasource="sifinterfaces">
	select * from #LvarDsource#segurosArticulosPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfdump var="#ArregloProductos#" label = "Salida">
<cfdump var="#Debug#" label = "Salida">
<cfdump var="#Debug2#" label = "Salida">
<cf_dump var="#Debug3#" label = "Salida2">
--->