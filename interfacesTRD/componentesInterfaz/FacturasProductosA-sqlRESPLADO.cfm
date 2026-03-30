<!--- Archivo    :  FacturasProductosA.cfm
	  Descripción:  Consulta, valida y graba las facturas de compra y venta de productos en la 
					variable de SESSION qproductos, si hay errores los graba en la variable de 
					SESSION qerrores, luego el usuario decide si procesa los registros.
	  --->

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="180">

<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

<cfquery name="rsEmpresa" datasource="sifinterfaces">
	select Ecodigo, CodICTS
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<!--- Crea query de compras  --->
<cfquery name="queryCompras" datasource="preicts">
	select aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,

		aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,
		ab.dt_fecha_vencimiento, ab.dt_fecha_recibo, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
		ab.c_moneda, ab.f_importe_total, ab.f_iva, ab.i_folio, ab.i_anio, ab.i_empresa, 
		det.c_producto, det.dt_bldate, det.f_volumen, det.c_unidad, det.f_precio,det.f_importe,
		co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num, co.cost_owner_key8 as item_num,
		coalesce(( select min(title_tran_date)
			from allocation_item ait 
			where ait.trade_num  = co.cost_owner_key6
			  and ait.order_num = co.cost_owner_key7
			  and ait.item_num = co.cost_owner_key8
		), ab.dt_fecha_recibo) as title_tran_date, a5.alloc_type_code, co.cost_code, co.cost_type_code,
		aa.voucher_creation_date
	from voucher aa
		inner join PmiFolios ab
			inner join PmiFoliosDetailP det
			on det.i_folio = ab.i_folio
			and det.i_anio = ab.i_anio
		on ab.i_voucher = aa.voucher_num
		and ab.i_empresa_prop = aa.voucher_book_comp_num
		and (ab.c_tipo_folio = 'FA' or ab.c_tipo_folio = 'ND' or ab.c_tipo_folio = 'NC')
		
		inner join voucher_cost vco
			inner join cost co
				inner join allocation_item ai
					inner join allocation a5
						on a5.alloc_num = ai.alloc_num
				on ai.trade_num = co.cost_owner_key6
				and ai.order_num = co.cost_owner_key7
				and ai.item_num = co.cost_owner_key8
			on vco.cost_num = co.cost_num
		on vco.voucher_num = aa.voucher_num
	where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.CodICTS#">
	and aa.voucher_creation_date is not null
	and aa.voucher_creation_date between 
		<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
		and
		<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaF)#">
	order by ab.i_empresa, ab.c_tipo_folio, ab.c_docto_proveedor
</cfquery>

<cfset LvarBanderaErrores = false>
<cf_htmlreportsheaders
	title="Importacion de Compras de ICTS" 
	filename="ImportaCompras-#Session.Usucodigo#.xls" 
	ira="FacturasProductosParam.cfm">

<cf_templatecss>

<cfoutput>
<table width="100%" border="1">
	<tr><td colspan="8" align="center"><strong>Reporte de Errores</strong></td>
	<tr><td colspan="8" align="center"><strong>Proceso de Carga de Compra de Producto</strong></td>
	<tr><td colspan="8" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="8">&nbsp;</td></tr>
	<tr><td colspan="8">Registros: #queryCompras.recordcount# </td></tr>
	<tr><td colspan="8">&nbsp;</td></tr>
	<tr>
		<td><strong>Fecha</strong></td>
		<td><strong>Voucher</strong></td>
		<td><strong>Fecha Fact</strong></td>
		<td><strong>Factura</strong></td>
		<td><strong>Producto</strong></td>
		<td><strong>Error</strong></td>
		<td align="right"><strong>Volumen</strong></td>
		<td align="right"><strong>Importe</strong></td>
	</tr>
	<tr><td colspan="8">&nbsp;</td></tr>
	<cfflush interval="40">
</cfoutput>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">
<!--- procesa los registros de compra  --->	
<cfloop query="queryCompras"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">

	<!--- valida que el monto del voucher sea igual al monto de la factura  --->	
	<cfif queryCompras.c_tipo_folio EQ "FA"  or queryCompras.c_tipo_folio EQ "ND">
		<cfset vDiff = abs(queryCompras.voucher_tot_amt - (queryCompras.f_importe_total + queryCompras.f_iva))>
	<cfelse>
		<cfset vDiff = abs(queryCompras.voucher_tot_amt + (queryCompras.f_importe_total + queryCompras.f_iva))>
	</cfif>
	<cfif vDiff GT 2>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarTipoError = "Diferencia Montos Voucher/Factura">
	</cfif>

	<!--- decodifica campo alloc_type_code  --->	
	<cfif queryCompras.alloc_type_code EQ "W">
		<cfset LvarOCTtipo = "B">
	<cfelseif queryCompras.alloc_type_code EQ "R">
		<cfset LvarOCTtipo = "F">
	<cfelse>
		<cfset LvarOCTtipo = "T">
	</cfif>

	<!--- Existencia del Socio de Negocio  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select count(1) as Cantidad
		from SNegocios s
		where s.Ecodigo = #session.ecodigo#
		  and s.SNcodigoext = '#queryCompras.i_empresa#'
	</cfquery>
	<cfif rsVerifica.Cantidad NEQ 1>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
	</cfif>

<!---
	<!--- Existencia del Articulo  --->
	<cfset LvarAid = "">
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select count(1) as Cantidad,a.Aid
		from Articulos a
		where a.Ecodigo 	= #session.ecodigo#
		  and a.Acodalterno = '#queryCompras.c_producto#'
		group by a.Aid
	</cfquery>
	<cfif rsVerifica.Cantidad NEQ 1>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
	<cfelse>
		<cfset LvarAid = rsVerifica.Aid>
	</cfif>
--->

<!---
	<!--- Moneda es Valida  --->
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select count(1) as Cantidad
		from Monedas a
		where a.Ecodigo  = #session.ecodigo#
		  and a.Miso4217 = '#queryCompras.voucher_curr_code#'
	</cfquery>
	<cfif rsVerifica.Cantidad NEQ 1>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
	</cfif> 

--->
	
	<!---
	<!--- OCconceptoCompra        --->
	<cfquery name="rsVerifica" datasource="tesoreria">
		select count(1) as Cantidad, sb.subconcepto_id
		FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
		WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_code#">
		  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_type_code#">
		  AND s.payable_receivable = 'P' 
		  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
		  AND sb.subconcepto_id = r.subconcepto_id
		group by sb.subconcepto_id
	</cfquery>
	<cfif rsVerifica.Cantidad NEQ 1>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarOCconceptoCompra = null>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Concepto Compra no definido">
	<cfelse>
		<cfset LvarOCconceptoCompra = rsVerifica.subconcepto_id>
	</cfif>

	<!--- OCconceptoCompra del iva    --->
	<cfif queryCompras.f_iva GT 0>
		<cfquery name="rsVerifica" datasource="tesoreria">
			select count(1) as Cantidad, sb.subconcepto_id
			FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_code#">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_type_code#">
			  AND s.payable_receivable = 'P' 
			  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
			  AND sb.subconcepto_id = r.subconcepto_id
			group by sb.subconcepto_id
		</cfquery>
		<cfif rsVerifica.Cantidad NEQ 1>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfset LvarCodigoImpuesto = null>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Concepto Compra IVA no definido">
		<cfelse>
			<cfset LvarCodigoImpuesto = rsVerifica.subconcepto_id>
		</cfif>
	<cfelse>
		<cfset LvarCodigoImpuesto = rsVerifica.subconcepto_id>
	</cfif>
--->

<!---
	<!--- Arma la cuenta financiera     --->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select count(1) as Cantidad, Cformato from CContables a4
				inner join Articulos a1
					on a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 			    	and a1.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAid#">
				inner join Clasificaciones a2
					on a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				    and a2.Ccodigo = a1.Ccodigo
				inner join IAContables a3
					on a3.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				    and a3.IACcodigogrupo = a2.Ccodigoclas
		where a4.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a4.Ccuenta = a3.IACtransito
		group by Cformato
	</cfquery>
	<cfif rsVerifica.Cantidad NEQ 1>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarCuentaFinanciera = null>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Cuenta Financiera no definida">
	<cfelse>
		<cfset LvarCuentaFinanciera = rsVerifica.Cformato>
	</cfif> --->
--->


<!---
	<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
		<cfset LvarOCtipoIC = "C">
		<cfquery name="rsTipoAlloc" datasource="preicts">
			select distinct oo.order_type_code, a3.bl_date, a3.bl_ticket_num, a3.nor_date,
					 a3.disch_compl_date, a1.* from allocation_item a1
				inner join allocation_item a2
					on a2.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryCompras.trade_num#">
				   and a2.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#queryCompras.order_num#">
  				   and a2.item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#queryCompras.item_num#">
				inner join allocation_item_transport a3
					on a3.alloc_num = a1.alloc_num
  				   and a3.alloc_item_num = a1.alloc_item_num
				inner join trade_order oo
					on oo.trade_num = a1.trade_num
				   and oo.order_num = a1.order_num
			where a1.alloc_num = a2.alloc_num
			   and a1.trade_num <> a2.trade_num
			order by oo.order_type_code
		</cfquery>

		<cfif rsTipoAlloc.recordcount GT 0>
			<cfif rsTipoAlloc.order_type_code EQ 'STORAGE'>
				<cfset LvarOCtipoIC = "I">
			<cfelseif rsTipoAlloc.order_type_code EQ 'TRANSPRT'>
				<cfquery name="rsTipo" datasource="preicts">
					select oo.order_type_code, a2.* from allocation_item a1
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
				<cfif rsTipo.recordcount GT 0>
					<cfif rsTipo.order_type_code EQ 'STORAGE'>
						<cfset LvarOCtipoIC = "I">
					</cfif>
				</cfif>
			</cfif>
		</cfif>    

--->


	<!--- Verificar si cambia el voucher number para generar un nuevo IE10 --->
	<cfif LvarControlSocio NEQ queryCompras.i_empresa or LvarControlTipo neq queryCompras.c_tipo_folio or LvarControlDocto neq queryCompras.c_docto_proveedor>
		<cfquery name="rsVerificaIE10" datasource="sifinterfaces">
			select count(1) as Cantidad
			from IE10
			where EcodigoSDC = 14
			  and NumeroSocio = '#queryCompras.i_empresa#'
			  and Modulo = 'CP'
			  and CodigoTransacion = '#queryCompras.c_tipo_folio#'
			  and Documento = '#queryCompras.c_docto_proveedor#'
		</cfquery>
		<cfif rsVerificaIE10.Cantidad GT 0>
			<cfset LvarID = 0>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Ya se Importó el Documento">
		<cfelse>
			<!--- Obtener el siguiente ID para procesar el registro --->
			<cftransaction>
			<cfquery datasource="sifinterfaces">
				update IdProceso
				set Consecutivo = Consecutivo + 1			
			</cfquery>
			<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
				select Consecutivo
				from IdProceso
			</cfquery>
			</cftransaction>
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
					#LvarID#, 14, '#queryCompras.i_empresa#', 'CP',
					'#queryCompras.c_tipo_folio#', '#queryCompras.c_docto_proveedor#', ' ',
					'#queryCompras.voucher_curr_code#', 
					<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.dt_fecha_recibo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.dt_fecha_vencimiento#">,
					'S', 'CP', '#queryCompras.voucher_num#', null, 
					null, null, null,
					#session.usucodigo#, 0, null, null, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.title_tran_date#">, 
					1)
			</cfquery>
		</cfif>
		<cfset LvarControlSocio = queryCompras.i_empresa>
		<cfset LvarControlTipo = queryCompras.c_tipo_folio>
		<cfset LvarControlDocto = queryCompras.c_docto_proveedor>
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
				#LvarID#, #LvarConsecutivoID10#, 'O', '#queryCompras.c_producto#',
				'barco', #now()#, #now()#,
				#queryCompras.f_precio#, 'BBL', #queryCompras.f_volumen#,
				#queryCompras.f_volumen#, 'codem', 'bol', #now()#,
				'trip', 'contract', 'IEXE', 0.00,
				0.00, null, null,
				#session.usucodigo#, #queryCompras.f_importe#,
				null, null,
				'B', 'transporte', 'OrdenCom', 'PRODUCTO'
			)
		</cfquery>>
	</cfif>

	<cfif isdefined("form.MostrarTodo") or len(LvarTipoError)>
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
			<td align="right">#numberformat(queryCompras.f_volumen, ",0.00")#</td>
			<td align="right">#numberformat(queryCompras.f_importe,",0.00")#</td>
		</tr>
		</cfoutput>
	</cfif>
</cfloop>
<cfoutput>
<cfif not LvarBanderaErrores>
	<tr><td colspan="8">&nbsp;</td></tr>
	<tr><td colspan="8" align="center"><strong>No se presentaron errores en la importacion.</strong></td>
</cfif>
	<cfset LvarTiempoProceso = datediff("s",LvarHoraInicio,now())>
	<tr><td colspan="8">&nbsp;</td></tr>
	<tr><td colspan="8">Tiempo de Proceso:#NumberFormat(LvarTiempoProceso, ",0")# Segundos</td></tr>
</table>
</cfoutput>
