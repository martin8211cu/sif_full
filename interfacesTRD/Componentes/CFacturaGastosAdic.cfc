<!--- 
	Archivo       : CFacturaGastosAdic.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos de tipo específico para procesar facturas de fletes.
--->
<cfcomponent>
	<!--- Se definen objetos a utilizar  --->
	<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">

	<!--- //// consulta Gastos Adicionales --->
	<cffunction name="ConsultaFletes" returntype="query">
		<cfargument name="FechaI" required="Yes" type="date">
		<cfargument name="FechaF" required="Yes" type="date">
		<cfset var query = "">
		<cfquery name="query" datasource="preicts">
			select aa.voucher_num, aa.acct_num, aa.voucher_tot_amt, aa.voucher_curr_code,
			       aa.voucher_creation_date, aa.voucher_book_comp_num, aa.voucher_book_curr_code,
				   aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,
				   ab.dt_fecha_vencimiento, ab.c_tipo_folio, ab.c_orden, ab.c_docto_proveedor,
				   ab.c_moneda, ab.i_folio, ab.i_anio, ab.i_empresa
			from voucher aa, PmiFolios ab
			where aa.voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			and (convert(varchar(8),aa.voucher_creation_date,112) between 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaI),"YYYYMMDD")#"> and
		    <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(LSParseDateTime(Arguments.FechaF),"YYYYMMDD")#">)
			and ab.i_empresa_prop = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
			and aa.voucher_num = ab.i_voucher
			and (ab.c_tipo_folio = 'FI' or ab.c_tipo_folio = 'CI' 
			or ab.c_tipo_folio = 'IC' or ab.c_tipo_folio = 'SI' or ab.c_tipo_folio = 'MA' 
			or ab.c_tipo_folio = 'CC' or ab.c_tipo_folio = 'SC')
			and not EXISTS(select ac.ID from sif_interfacesser..IE10 ac where
			               ac.VoucherNo = CONVERT(varchar,aa.voucher_num)) order by aa.voucher_num
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