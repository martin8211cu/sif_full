<!--- 
	Archivo       : CFacturaFletes.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos de tipo específico para procesar facturas de fletes.
--->
<cfcomponent>
	<!--- Se definen objetos a utilizar  --->
	<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">

	<!--- //// consulta fletes  --->
	<cffunction name="ConsultaFletes" returntype="query">
		<cfargument name="FechaI" required="Yes" type="date">
		<cfargument name="FechaF" required="Yes" type="date">
		<cfset var query = "">
		<cfquery name="query" datasource="preicts">
		
					select ab.i_folio, aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
			       aa.voucher_creation_date, aa.voucher_book_comp_num, aa.voucher_book_curr_code,
				   aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,
				   ab.dt_fecha_vencimiento, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
				   ab.c_moneda, ab.i_anio, ab.i_empresa
			from voucher aa
			inner join PmiFolios ab
				on ab.i_voucher = aa.voucher_num
				and (ab.c_tipo_folio = 'CI' or ab.c_tipo_folio = 'FS')
				and ab.i_empresa_prop = 701
			inner join voucher_cost vco
				on vco.voucher_num = aa.voucher_num
			inner join cost co
				on co.cost_num = vco.cost_num
			   and co.cost_code like 'FREIG%'
			   and co.cost_status in ('PAID','VOUCHED')
			inner join trade_order oo	
				on oo.trade_num = co.cost_owner_key6
                		and oo.order_num = co.cost_owner_key7
				and oo.order_type_code='TRANSPRT'
			where aa.voucher_book_comp_num = 701
			and (convert(varchar(8),aa.voucher_creation_date,112) between "20070101" and "20070131")
			union all
			select ab.i_folio, aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
			       aa.voucher_creation_date, aa.voucher_book_comp_num, aa.voucher_book_curr_code,
				   aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,
				   ab.dt_fecha_vencimiento, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
				   ab.c_moneda, ab.i_anio, ab.i_empresa
			from voucher aa
			inner join PmiFolios ab
				on ab.i_voucher = aa.voucher_num
				and (ab.c_tipo_folio = 'CI' or ab.c_tipo_folio = 'FS')
				and ab.i_empresa_prop = 701
			inner join voucher_cost vco
				on vco.voucher_num = aa.voucher_num
			inner join cost co
				on co.cost_num = vco.cost_num
			   and co.cost_code like 'FREIG%'
			   and co.cost_status in ('PAID','VOUCHED')
			   and co.cost_owner_key1 = 43898
			where aa.voucher_book_comp_num = 701
			and (convert(varchar(8),aa.voucher_creation_date,112) between "20070101" and "20070131")
		ORDER BY ab.i_folio

		
		
			select aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
			       aa.voucher_creation_date, aa.voucher_book_comp_num, aa.voucher_book_curr_code,
				   aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,
				   ab.dt_fecha_vencimiento, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
				   ab.c_moneda, ab.i_folio, ab.i_anio, ab.i_empresa
			from voucher aa
			inner join PmiFolios ab
				on ab.i_voucher = aa.voucher_num
				and ab.c_orden like 'CTT%'
				and (ab.c_tipo_folio = 'CI' or ab.c_tipo_folio = 'FS')
				and ab.i_empresa_prop = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			inner join voucher_cost vco
				on vco.voucher_num = aa.voucher_num
			inner join cost co
				on co.cost_num = vco.cost_num
			   and co.cost_code like '%FREIG'
			   and co.cost_status in ('PAID','VOUCHED')	
			inner join trade_order oo	
				on oo.trade_num = co.cost_owner_key6
                and oo.order_num = co.cost_owner_key7
				and oo.order_type_code='TRANSPRT'
			where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			and (convert(varchar(8),aa.voucher_creation_date,112) between 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaI),"YYYYMMDD")#"> and
		    <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaF),"YYYYMMDD")#">)
	<!---		and not EXISTS(select ac.ID from sif_interfacesser..IE10 ac where
			               ac.VoucherNo = CONVERT(varchar,aa.voucher_num)) order by aa.voucher_num --->
		</cfquery>
		<cfreturn query>
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