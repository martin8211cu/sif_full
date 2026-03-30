<!--- 
	Archivo       : CNoFactFletes.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos de tipo específico para procesar documentos NoFact de Fletes.
--->
<cfcomponent>
	<!--- Se definen objetos a utilizar  --->
	<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">

	<!--- //// consulta Fletes  NoFact --->
	<cffunction name="ConsultaFletes" returntype="query">
		<cfargument name="FechaI" required="Yes" type="date">
		<cfargument name="FechaF" required="Yes" type="date">
		<cfset var queryTrade = "">
		
		<cfquery name="queryTrade" datasource="preicts">
			select ti.trade_num, ti.order_num, ti.item_num, tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
				ti.cmdty_code, tr.contr_date, co.cost_code, co.cost_amt, co.cost_price_curr_code, co.cost_qty_uom_code,
				co.cost_qty
			from cost co
			inner join trade tr
				on tr.trade_num = co.cost_owner_key6
			inner join trade_order oo
				on oo.trade_num = co.cost_owner_key6
                and oo.order_num = co.cost_owner_key7
			inner join trade_item ti
				on ti.trade_num = co.cost_owner_key6
                and ti.order_num = co.cost_owner_key7
                and ti.item_num = co.cost_owner_key8
				and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			inner join PmiFreightSecCost sec
				on sec.trade_num = co.cost_owner_key6
                and sec.order_num = co.cost_owner_key7
                and sec.item_num = co.cost_owner_key8
				and sec.status = 'E'
			where (co.cost_owner_code like 'A%' or co.cost_owner_code = 'TI')
			  and co.cost_code = 'FREIGHTO'
			  and co.cost_status in ('OPEN','CLOSED')
			  and co.cost_prim_sec_ind = 'S'
			  and co.cost_type_code = 'TMC'
			  and co.cost_pay_rec_ind = 'P'
			order by tr.acct_ref_num
		</cfquery>

		<cfreturn queryTrade>
	</cffunction>  <!--- **** Fin de la Función **** --->
<!--- 
				and (convert(varchar(8),tr.contr_date,112) between 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaI),"YYYYMMDD")#"> and
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaF),"YYYYMMDD")#">)
		        and oo.order_type_code='TRANSPRT'
--->


	<!--- //// consulta ventas  NoFact   --->
	<cffunction name="ConsultaVentas" returntype="query">
		<cfargument name="FechaI" required="Yes" type="date">
		<cfargument name="FechaF" required="Yes" type="date">
		<cfset var queryTrade = "">
		
		<cfquery name="queryTrade" datasource="preicts">
			select ti.trade_num, ti.order_num, ti.item_num, tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
				ti.cmdty_code, tr.contr_date, ai.title_tran_date 
			from trade_item ti
			inner join trade tr
				on tr.trade_num = ti.trade_num
				and (convert(varchar(8),tr.contr_date,112) between 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaI),"YYYYMMDD")#"> and
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaF),"YYYYMMDD")#">)
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
			where ti.p_s_ind = 'S'
				and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
 			    and EXISTS(select co.cost_num from cost co where
			                co.cost_status = 'OPEN' 
						    and ti.trade_num = co.cost_owner_key6
							and ti.order_num = co.cost_owner_key7
							and ti.item_num= co.cost_owner_key8
							and co.cost_code = ti.cmdty_code)
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