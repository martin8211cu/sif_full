<!--- 
	Archivo       : CNoFactProducto.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos de tipo específico para procesar documentos NoFact de compra y venta de producto.
--->
<cfcomponent>
	<!--- Se definen objetos a utilizar  --->
	<cfobject name="OGeneral" component="interfacesTRD.Componentes.CGeneral">

	<!--- //// consulta compras  NoFact --->
	<cffunction name="ConsultaCompras" returntype="query">
		<cfargument name="FechaI" required="Yes" type="date">
		<cfargument name="FechaF" required="Yes" type="date">
		<cfset var queryTrade = "">

		<cfset vFechaI = createdate(right(arguments.FechaI,4),mid(arguments.FechaI,4,2),left(arguments.FechaI,2))>
		<cfset vFechaF = createdate(right(arguments.FechaF,4),mid(arguments.FechaF,4,2),left(arguments.FechaF,2))>
		<cfset vFechaM1 = DateAdd('D',1,vFechaF)>
		
		<cfquery name="queryTrade" datasource="preicts">
			select 'N' as tipo_consulta, ti.trade_num, ti.order_num, ti.item_num,
				tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
				ti.cmdty_code, tr.contr_date, ai.title_tran_date 
			from trade_item ti
			inner join trade tr
				on tr.trade_num = ti.trade_num
			inner join trade_order oo
				on oo.trade_num = ti.trade_num
                and oo.order_num = ti.order_num
		        and oo.order_type_code='PHYSICAL'
			inner join allocation_item ai
				on ai.trade_num = ti.trade_num
                and ai.order_num = ti.order_num
                and ai.item_num = ti.item_num
				and (convert(varchar(8),ai.title_tran_date,112) between 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaI),"YYYYMMDD")#"> and
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaF),"YYYYMMDD")#">)
				and (ai.title_tran_date IS NOT null)
			where ti.p_s_ind = 'P'
				and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
 			    and EXISTS(select co.cost_num from cost co where
			                co.cost_status = 'OPEN' 
							and (co.cost_owner_code <> 'TI')
							and (co.cost_type_code <> 'WS')
						    and ti.trade_num = co.cost_owner_key6
							and ti.order_num = co.cost_owner_key7
							and ti.item_num= co.cost_owner_key8
							and co.cost_code = ti.cmdty_code)

			union

			select 'E' as tipo_consulta, ti.trade_num, ti.order_num, ti.item_num,
			    tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
				ti.cmdty_code, tr.contr_date, ai.title_tran_date 
			from trade_item ti
			inner join trade tr
				on tr.trade_num = ti.trade_num
			inner join trade_order oo
				on oo.trade_num = ti.trade_num
                and oo.order_num = ti.order_num
		        and oo.order_type_code='PHYSICAL'
			inner join allocation_item ai
				on ai.trade_num = ti.trade_num
                and ai.order_num = ti.order_num
                and ai.item_num = ti.item_num
				and (convert(varchar(8),ai.title_tran_date,112) between 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaI),"YYYYMMDD")#"> and
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaF),"YYYYMMDD")#">)
				and (ai.title_tran_date IS NOT null)
			where ti.p_s_ind = 'P'
				and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
 			    and EXISTS(select co.cost_num from cost co
								inner join voucher_cost vco
									inner join voucher vo
									on vco.voucher_num = vo.voucher_num
									and vo.voucher_creation_date between 
									<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaM1)#"> 
									and
									<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(now())#">
								on vco.cost_num = co.cost_num
						   where
			                co.cost_status in ('PAID','VOUCHED')
						    and ti.trade_num = co.cost_owner_key6
							and ti.order_num = co.cost_owner_key7
							and ti.item_num= co.cost_owner_key8
							and co.cost_code = ti.cmdty_code)
							order by ai.title_tran_date

		</cfquery>

		<cfreturn queryTrade>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta ventas  NoFact   --->
	<cffunction name="ConsultaVentas" returntype="query">
		<cfargument name="FechaI" required="Yes" type="date">
		<cfargument name="FechaF" required="Yes" type="date">
		<cfset var queryTrade = "">

		<cfset vFechaI = createdate(right(arguments.FechaI,4),mid(arguments.FechaI,4,2),left(arguments.FechaI,2))>
		<cfset vFechaF = createdate(right(arguments.FechaF,4),mid(arguments.FechaF,4,2),left(arguments.FechaF,2))>
		<cfset vFechaM1 = DateAdd('D',1,vFechaF)>
		
		<cfquery name="queryTrade" datasource="preicts">
			select 'N' as tipo_consulta, ti.trade_num, ti.order_num, ti.item_num,
				tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
				ti.cmdty_code, tr.contr_date, ai.title_tran_date 
			from trade_item ti
			inner join trade tr
				on tr.trade_num = ti.trade_num
			inner join trade_order oo
				on oo.trade_num = ti.trade_num
                and oo.order_num = ti.order_num
		        and oo.order_type_code='PHYSICAL'
			inner join allocation_item ai
				on ai.trade_num = ti.trade_num
                and ai.order_num = ti.order_num
                and ai.item_num = ti.item_num
				and (convert(varchar(8),ai.title_tran_date,112) between 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaI),"YYYYMMDD")#"> and
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaF),"YYYYMMDD")#">)
				and (ai.title_tran_date IS NOT null)
			where ti.p_s_ind = 'S'
				and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
 			    and EXISTS(select co.cost_num from cost co where
			                co.cost_status = 'OPEN' 
							and (co.cost_owner_code <> 'TI')
							and (co.cost_type_code <> 'WS')
						    and ti.trade_num = co.cost_owner_key6
							and ti.order_num = co.cost_owner_key7
							and ti.item_num= co.cost_owner_key8
							and co.cost_code = ti.cmdty_code)

			union

			select 'E' as tipo_consulta, ti.trade_num, ti.order_num, ti.item_num,
			    tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
				ti.cmdty_code, tr.contr_date, ai.title_tran_date 
			from trade_item ti
			inner join trade tr
				on tr.trade_num = ti.trade_num
			inner join trade_order oo
				on oo.trade_num = ti.trade_num
                and oo.order_num = ti.order_num
		        and oo.order_type_code='PHYSICAL'
			inner join allocation_item ai
				on ai.trade_num = ti.trade_num
                and ai.order_num = ti.order_num
                and ai.item_num = ti.item_num
				and (convert(varchar(8),ai.title_tran_date,112) between 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaI),"YYYYMMDD")#"> and
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaF),"YYYYMMDD")#">)
				and (ai.title_tran_date IS NOT null)
			where ti.p_s_ind = 'S'
				and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
 			    and EXISTS(select co.cost_num from cost co
								inner join voucher_cost vco
									inner join voucher vo
									on vco.voucher_num = vo.voucher_num
									and vo.voucher_creation_date between 
									<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaM1)#"> 
									and
									<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(now())#">
								on vco.cost_num = co.cost_num
						   where
			                co.cost_status in ('PAID','VOUCHED')
						    and ti.trade_num = co.cost_owner_key6
							and ti.order_num = co.cost_owner_key7
							and ti.item_num= co.cost_owner_key8
							and co.cost_code = ti.cmdty_code)
							order by ai.title_tran_date
		</cfquery>
		<cfreturn queryTrade>
	</cffunction>  <!--- **** Fin de la Función **** --->


	<!--- //// consulta si el voucher existe en la tabla PmiFolios  --->
	<cffunction name="ValExisteFolios" output="false" returntype="boolean">
		<cfargument name="VoucherNum" required="Yes" type="numeric">
		<cfset var Existe = false>
		<cfset var qVoucher = "">

		<cfquery name="qVoucher" datasource="preicts">
			select *
			from PmiFolios
			where i_voucher = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.VoucherNum#">
			and i_empresa_prop = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			and (c_tipo_folio = 'FA' or c_tipo_folio = 'ND' or c_tipo_folio = 'NC')
		</cfquery>

		<cfif qVoucher.recordCount EQ 0>
			<cfset Existe = false>
		<cfelse>
			<cfset Existe = true>
		</cfif>

		<cfreturn Existe>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta si el voucher existe en la tabla PmiInvoice  --->
	<cffunction name="ExisteInvoice" output="false" returntype="boolean">
		<cfargument name="VoucherNum" required="Yes" type="numeric">
		<cfset var Existe = false>
		<cfset var qVoucher = "">

		<cfquery name="qVoucher" datasource="preicts">
			select *
			from PmiInvoice
			where voucherNum = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.VoucherNum#">
			and (invoiceType = 'G' or invoiceType = 'K' or invoiceType = 'p' or invoiceType = 'R' or
			     invoiceType = 'W' or invoiceType = 'c' or invoiceType = 'd' or invoiceType = 'w')
		</cfquery>

		<cfif qVoucher.recordCount EQ 0>
			<cfset Existe = false>
		<cfelse>
			<cfset Existe = true>
		</cfif>

		<cfreturn Existe>
	</cffunction>  <!--- **** Fin de la Función **** --->

</cfcomponent>