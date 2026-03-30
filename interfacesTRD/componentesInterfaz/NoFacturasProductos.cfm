<!--- Archivo    :  NoFacturasProductos.cfm
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
		select ti.trade_num, ti.order_num, ti.item_num, tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
			ti.cmdty_code, tr.contr_date, ai.title_tran_date 
		from trade_item ti
		inner join trade tr
			on tr.trade_num = ti.trade_num
			and tr.contr_date between 
			<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
			and
			<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaF)#">
		inner join trade_order oo
			on oo.trade_num = ti.trade_num
			and oo.order_num = ti.order_num
			and oo.order_type_code='PHYSICAL'
		inner join allocation_item ai
			on ai.trade_num = ti.trade_num
			and ai.order_num = ti.order_num
			and ai.item_num = ti.item_num
			and ai.title_tran_date <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			and (ai.title_tran_date IS NOT null)
		where ti.p_s_ind = 'P'
			and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			and EXISTS(select co.cost_num from cost co where
						co.cost_status = 'OPEN' 
						and ti.trade_num = co.cost_owner_key6
						and ti.order_num = co.cost_owner_key7
						and ti.item_num= co.cost_owner_key8
						and co.cost_code = ti.cmdty_code)
						order by ai.title_tran_date
	order by tr.acct_num, tr.acct_ref_num
</cfquery>

<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cf_htmlreportsheaders
	title="Importacion de Compras NoFact. de ICTS" 
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

<!---
	<cfset LvarOCconceptoCompra = "">
	<!--- OCconceptoCompra      --->
	<cfquery name="rsVerifica" datasource="tesoreria">
		select sb.subconcepto_id
		FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
		WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_code#">
		  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_type_code#">
		  AND s.payable_receivable = 'P' 
		  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
		  AND sb.subconcepto_id = r.subconcepto_id
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarOCconceptoCompra = "">
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Concepto Compra no definido">
	<cfelse>
		<cfquery name="rsConceptos" datasource="#session.dsn#">
			select cuentac
			FROM Conceptos 
			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		      and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ToString(rsVerifica.subconcepto_id)#">
		</cfquery>
		<cfif rsConceptos.recordcount EQ 0>
			<cfset LvarOCconceptoCompra = rsConceptos.cuentac>
		</cfif>
	</cfif>
--->
	<cfset LvarCodigoImpuesto = "">
	<!--- OCconceptoCompra del iva    --->
	<cfif queryCompras.f_iva GT 0>
		<cfquery name="rsVerifica" datasource="tesoreria">
			select sb.subconcepto_id
			FROM subconceptos sb, rel_subconceptos_detalles r, subconceptos_detalle s 
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="TAX">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCompras.cost_type_code#">
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
			<cfset LvarTipoError = LvarTipoError & "Concepto Compra IVA no definido">
		<cfelse>
			<cfquery name="rsConceptos" datasource="#session.dsn#">
				select cuentac
				FROM Conceptos 
				WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
  			      and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ToString(rsVerifica.subconcepto_id)#">
			</cfquery>
			<cfif rsConceptos.recordcount EQ 0>
				<cfset LvarCodigoImpuesto = rsConceptos.cuentac>
			</cfif>
		</cfif>
	</cfif>

<!--- Arma la cuenta financiera     --->
<cfif len(LvarAid)>
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
	<cfif rsVerifica.recordcount EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfset LvarCuentaFinanciera = null>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Cuenta Financiera no definida">
	<cfelse>
		<cfset LvarCuentaFinanciera = rsVerifica.Cformato>
	</cfif>
</cfif>


<!--- Consulta la información de costos tablas cost   --->
<cfquery name="rsVerifica" datasource="preicts">
	select co.cost_owner_key6 as trade_num, co.cost_owner_key7 as order_num,
	 co.cost_owner_key8 as item_num from cost co
		inner join voucher vo
			inner join voucher_cost vco
				on vco.voucher_num = vo.voucher_num
		on vo.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#querycompras.voucher_num#">
	where co.cost_num = vco.cost_num
	  and co.cost_status IN ('PAID','VOUCHED')
	group by co.cost_owner_key6, co.cost_owner_key7, co.cost_owner_key8
</cfquery>
<cfif rsVerifica.recordcount EQ 0>
	<cfset LvarBanderaErrores_registro = true>
	<cfset LvarBanderaErrores = true>
	<cfset LvarCuentaFinanciera = null>
	<cfif len(LvarTipoError)>
		<cfset LvarTipoError = LvarTipoError & ", ">
	</cfif>
	<cfset LvarTipoError = LvarTipoError & "No existen costos definidos">
</cfif>

<!--- Consulta información del Trade, trade_order, trade_item   --->
<cfif rsVerifica.recordcount GT 0>
	<cfquery name="rsTrade" datasource="preicts">
		select ai.title_tran_date, ai.trade_num, ai.order_num, ai.item_num,
			a5.alloc_type_code, ai.del_term_code , a10.bl_ticket_num, ai.del_term_code,
			a10.bl_date, a10.transportation, a10.load_compl_date, a10.nor_date
		from trade_item ti
			inner join allocation_item ai
				inner join allocation_item_transport a10
				on a10.alloc_num = ai.alloc_num
				and a10.alloc_item_num = ai.alloc_item_num
			on ai.trade_num = ti.trade_num
			and ai.order_num = ti.order_num
			and ai.item_num = ti.order_num
		inner join allocation a5
			on a5.alloc_num = ai.alloc_num
		where ti.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerifica.trade_num#">
		and	  ti.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsVerifica.order_num#">
		and	  ti.item_num =  <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsVerifica.item_num#">
	</cfquery>
</cfif>

<!--- decodifica campo alloc_type_code  --->	
<cfif rsTrade.alloc_type_code EQ "W">
	<cfset LvarOCTtipo = "B">
<cfelseif rsTrade.alloc_type_code EQ "R">
	<cfset LvarOCTtipo = "F">
<cfelse>
	<cfset LvarOCTtipo = "T">
</cfif>

<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
<cfset LvarOCtipoIC = "C">
<cfif rsVerifica.recordcount GT 0>
	<cfquery name="rsTipoAlloc" datasource="preicts">
		select distinct oo.order_type_code, a1.trade_num, a1.acct_ref_num from allocation_item a1
			inner join allocation_item a2
				on a2.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerifica.trade_num#">
			   and a2.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsVerifica.order_num#">
			   and a2.item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsVerifica.item_num#">
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
</cfif>

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
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.title_tran_date#">, 
					1)
			</cfquery>
		</cfif>
		<cfset LvarControlSocio = queryCompras.i_empresa>
		<cfset LvarControlTipo = queryCompras.c_tipo_folio>
		<cfset LvarControlDocto = queryCompras.c_docto_proveedor>
	</cfif>

	<cfif ISDATE(rsTrade.bl_ticket_num)>
		<cfset Lvarbl_ticket_num=rsTrade.bl_ticket_num>
	<cfelse>
		<cfset Lvarbl_ticket_num=0>
	</cfif>

	<cfif ISDATE(rsTrade.bl_date)>
		<cfset Lvarbl_date=rsTrade.bl_date>
	<cfelse>
		<cfset Lvarbl_date=0>
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
				'#rsTrade.transportation#',
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.load_compl_date#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsTrade.nor_date#">,
				#queryCompras.f_precio#, '#queryCompras.c_unidad#', #queryCompras.f_volumen#,
				#queryCompras.f_volumen#, '#rsTrade.del_term_code#', '#Lvarbl_ticket_num#',
				<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				'trip', '#queryCompras.c_orden#', '#LvarCodigoImpuesto#', #queryCompras.f_iva#,
				0.00, null, null,
				#session.usucodigo#, #queryCompras.f_importe#,
				null, '#LvarCuentaFinanciera#',
				'#LvarOCTtipo#', '#rsTipoAlloc.acct_ref_num#', '#queryCompras.c_orden#', '00'
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

