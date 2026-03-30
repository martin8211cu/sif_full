<!--- 
	Archivo       : CNoFactSwap.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos de tipo específico para procesar documentos NoFact de Swaps
--->
<cfcomponent>
	<!--- Se definen objetos a utilizar  --->
	<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">

	<!--- //// consulta compras  NoFact --->
	<cffunction name="ConsultaCompras" returntype="query">
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
		        and (oo.order_type_code='SWAP' or oo.order_type_code='SWAPFLT'
			where ti.p_s_ind = 'P'
				and ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
 			    and EXISTS(select co.cost_num from cost co where
			                co.cost_status = 'OPEN' 
						    and ti.trade_num = co.cost_owner_key6
							and ti.order_num = co.cost_owner_key7
							and ti.item_num= co.cost_owner_key8
							and co.cost_code = ti.cmdty_code)

select ti.trade_num, ti.order_num, ti.item_num, tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
	ti.cmdty_code, tr.contr_date, co.*
from trade_item ti 
	inner join accumulation ac
	on ac.trade_num = ti.trade_num
	and ac.order_num = ti.order_num
	and ac.item_num = ti.item_num
	and ac.price_status in ('U','P')
	inner join trade_order oo
		inner join trade tr
		on tr.trade_num = oo.trade_num
	on oo.trade_num = ti.trade_num
       and oo.order_num = ti.order_num
       and (oo.order_type_code='SWAP' or oo.order_type_code='SWAPFLT')
       inner join cost co
             on co.cost_owner_key6 = ti.trade_num
             and co.cost_owner_key7 = ti.order_num
             and co.cost_owner_key8 = ti.item_num 
             and co.cost_status = 'OPEN'
             and co.cost_code = ti.cmdty_code
	      and co.cost_book_comp_num=701
where ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
order by co.cost_owner_code

		</cfquery>
		<cfreturn queryTrade>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta ventas  NoFact   --->
	<cffunction name="ConsultaVentas" returntype="query">
		<cfargument name="FechaI" required="Yes" type="date">
		<cfargument name="FechaF" required="Yes" type="date">
		<cfset var queryTrade = "">
		
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