<!--- 
	Archivo       : CGeneral.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos generales de la Interfase PMI.
--->
<cfcomponent>

	<!--- //// consulta de empresas de ICTS  --->
	<cffunction name="ConsultaEmpresaICTS" returntype="string">
	    <cfset var query="">

		<cfquery name="query" datasource="sifinterfaces">
			select Ecodigo, CodICTS
			from int_ICTS_SOIN
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Proceso de Extracción, no se encontró la empresa ICTS!.">
		</cfif>
		
		<cfreturn trim(query.CodICTS)>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta un voucher específico  --->
	<cffunction name="ConsVoucher" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
			select voucher_num, acct_num, voucher_tot_amt, voucher_curr_code,  
			       voucher_creation_date, voucher_book_comp_num, voucher_book_curr_code,
				   voucher_creator_init, voucher_acct_name, voucher_book_comp_name
			from voucher
			where voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(session.EmpresaICTS)#">
			and voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.Voucher)#">
		</cfquery>

		<cfif query.recordcount EQ 0>
			<cfthrow message="No se encontró el registro en Voucher, No. de voucher: #Arguments.Voucher#">
		</cfif>
		
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta si el voucher existe en la tabla de interfases IE10  --->
	<cffunction name="ValVoucher" returntype="boolean">
		<cfargument name="VoucherNum" required="Yes" type="string">
		<cfset var Existe = false>
		<cfset var qVoucher = "">
		
		<cfquery name="qVoucher" datasource="sifinterfaces">
			select *
			from IE10
			where VoucherNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="trim(#Arguments.VoucherNum#)">
		</cfquery>

		<cfif qVoucher.recordCount EQ 0>
			<cfset Existe = false>
		<cfelse>
			<cfset Existe = true>
		</cfif>

		<cfreturn Existe>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Item , tablas trade, trade_order, trade_item  --->
	<cffunction name="ConsultaItem" returntype="query">
		<cfargument name="Trade_Num" required="Yes" type="numeric">
		<cfargument name="Order_Num" required="Yes" type="numeric">
		<cfargument name="Item_Num" required="Yes" type="numeric">
		<cfset var query = "">
		
		<cfquery name="query" datasource="preicts">
			select distinct tr.acct_ref_num, tr.creation_date, oo.order_type_code, ti.trade_num,
			ti.order_num, ti.item_num, ti.cmdty_code, ait.load_compl_date, ait.disch_compl_date,
			ait.nor_date, ai.del_term_code, ait.bl_ticket_num, ait.bl_date, ait.transportation,
			ai.title_tran_date, a5.creation_date as fechaAllocation, ti.real_port_num
			from trade_item ti
				inner join trade tr
					on tr.trade_num = ti.trade_num
				inner join trade_order oo
					on oo.trade_num = ti.trade_num
				   and oo.order_num = ti.order_num	
				inner join allocation_item ai
					on ai.trade_num = ti.trade_num
				   and ai.order_num = ti.order_num
				   and ai.item_num = ti.item_num
				inner join allocation a5
					on a5.alloc_num = ai.alloc_num
				inner join allocation_item_transport ait
					on ait.alloc_num = ai.alloc_num
			where ti.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Trade_Num#">
			   and ti.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Order_Num#">
			   and ti.item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Item_Num#">
		</cfquery>
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta allocation --->
	<cffunction name="ConsultaAllocation" returntype="string">
		<cfargument name="Trade_Num" required="Yes" type="numeric">
		<cfargument name="Order_Num" required="Yes" type="numeric">
		<cfargument name="Item_Num" required="Yes" type="numeric">
		<cfset var query = "">
		<cfset var queryItem = "">
		<cfset var tipo = "">

		<cfquery name="queryItem" datasource="preicts">
			select alloc_num
			from allocation_item
			where trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
			   and order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.order_num#">
			   and item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.item_num#">
		</cfquery>
		
		<cfif queryItem.recordcount GT 0>
			<cfquery name="query" datasource="preicts">
				select mot_code
				from allocation
				where alloc_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryItem.alloc_num#">
			</cfquery>
			<cfif queryItem.recordcount GT 0>
				<cfset tipo = queryItem.mot_code>
			</cfif>
		</cfif>
		
		<cfif tipo EQ 'BARGE'>
			<cfset tipo = "B">
		<cfelseif tipo EQ 'CONTAINER'>
			<cfset tipo = "T">
		<cfelseif tipo EQ 'TBN'>
			<cfset tipo = "B">
		<cfelseif tipo EQ 'MULTIMODAL'>
			<cfset tipo = "T">
		<cfelseif tipo EQ 'PIPELINE'>
			<cfset tipo = "T">
		<cfelseif tipo EQ 'RAILCAR'>
			<cfset tipo = "F">
		<cfelseif tipo EQ 'STORAGE'>
			<cfset tipo = "T">
		<cfelseif tipo EQ 'TRUCK'>
			<cfset tipo = "T">
		<cfelseif tipo EQ 'VASSEL'>
			<cfset tipo = "T">
		<cfelse>
			<cfset tipo = "T">
		</cfif>   
		
		<cfreturn tipo>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta allocation_item --->
	<cffunction name="ConsultaAllocationItem" returntype="query">
		<cfargument name="Trade_Num" required="Yes" type="numeric">
		<cfargument name="Order_Num" required="Yes" type="numeric">
		<cfargument name="Item_Num" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
			select a1.creation_date, a2.title_tran_date, a2.alloc_num, a2.del_term_code,
			       a2.nomin_date_from
			from allocation a1, allocation_item a2
			where a2.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
			   and a2.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.order_num#">
			   and a2.item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.item_num#">
			   and a1.alloc_num = a2.alloc_num
		</cfquery>
		
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta allocation_item_transport --->
	<cffunction name="ConsultaItemTransport" returntype="query">
		<cfargument name="Trade_Num" required="Yes" type="numeric">
		<cfargument name="Order_Num" required="Yes" type="numeric">
		<cfargument name="Item_Num" required="Yes" type="numeric">
		<cfset var query = "">
		<cfset var queryItem = "">

		<cfquery name="queryItem" datasource="preicts">
			select alloc_num
			from allocation_item
			where trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
			   and order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.order_num#">
			   and item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.item_num#">
		</cfquery>
		
		<cfif queryItem.recordcount GT 0>
			<cfquery name="query" datasource="preicts">
				select alloc_num, bl_date, nor_date, transportation, bl_date, bl_ticket_num
				from allocation_item_transport
				where alloc_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryItem.alloc_num#">
			</cfquery>
		<cfelse>
			<cfquery name="query" datasource="preicts">
				select alloc_num, bl_date, nor_date, transportation
				from allocation_item_transport
				where alloc_num = 0>
			</cfquery>
		</cfif>
		
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta de account (descripción de empresas ICTS)  --->
	<cffunction name="ConsultaDescripcionICTS" returntype="string">
		<cfargument name="Empresa" required="Yes" type="string">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
			select acct_num, acct_short_name
			from account
			where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Empresa#">
		</cfquery>

		<cfif query.recordcount EQ 0>
			<cfthrow message="No existe la descripción de la empresa en tabla account">
		</cfif>
		
		<cfreturn "#query.acct_short_name#">
	</cffunction>  <!--- **** Fin de la Función **** --->


	<!--- //// consulta si afecta almacén --->
	<cffunction name="AfectaAlmacen" returntype="string">
		<cfargument name="voucher" required="Yes" type="numeric">
		<cfargument name="producto" required="Yes" type="string">
		<cfset var queryAlloc = "">
		<cfset var queryItem = "">
		<cfset var queryTrans = "">
		<cfset var Afecta = false>

		<cfquery name="queryAlloc" datasource="preicts">
			select distinct ai.alloc_num
				from cost co
				inner join voucher_cost vco
					on vco.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.voucher#">
				   and vco.cost_num = co.cost_num
				inner join allocation_item ai
					on ai.trade_num = co.cost_owner_key6
				   and ai.order_num = co.cost_owner_key7
				   and ai.item_num = co.cost_owner_key8
				where co.cost_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.producto#">
		</cfquery>

		<cfloop query="queryAlloc">
			<cfif Afecta>
				<cfbreak>
			</cfif>
			<cfquery name="queryItem" datasource="preicts">		
				select a3.order_type_code, a1.* from allocation_item a1
					inner join trade_order a3
						on a3.trade_num = a1.trade_num
					   and a3.order_num = a1.order_num
 					   and a3.order_type_code in('STORAGE','TRANSPRT')	 
					 where a1.alloc_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryAlloc.alloc_num#">
					 order by a3.order_type_code
			</cfquery>

			<cfloop query="queryItem">
				<cfif queryItem.order_type_code EQ 'STORAGE'>
					<cfset Afecta = true>
					<cfbreak>
				</cfif>
				<cfif queryItem.order_type_code EQ 'TRANSPRT'>
					<cfquery name="queryTrans" datasource="preicts">
						select distinct oo.order_type_code, ai.trade_num, ai.order_num from allocation_item ai
							inner join trade_order oo
								on oo.trade_num=ai.trade_num
							   and oo.order_type_code='STORAGE'
						where ai.alloc_num in (select ai.alloc_num from allocation_item ai 
							inner join trade_order oo
								on oo.trade_num = ai.trade_num
							   and oo.order_num = ai.order_num
							 where ai.trade_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#queryItem.trade_num#">)
					</cfquery>
					<cfif queryTrans.recordcount GT 0>
						<cfset Afecta = true>
						<cfbreak>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>

		<cfreturn Afecta>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta almacén --->
	<cffunction name="ConsultaAlmacen" returntype="struct">
		<cfargument name="Trade_Num" required="Yes" type="numeric">
		<cfargument name="Order_Num" required="Yes" type="numeric">
		<cfargument name="Item_Num" required="Yes" type="numeric">
		  <!--- si el trade es de compra viene S, y si es de venta viene P. o sea lo contrario. --->
		<cfargument name="P_s_ind" required="Yes" type="string">
		<cfset var queryAlloc = "">
		<cfset var queryTrans = "">
		<cfset var AlmStruct = StructNew()>
		<cfset AlmStruct.Afecta = false>				
		<cfset AlmStruct.Almacen = "">				
		<cfset AlmStruct.Transporte = "">				
		<cfset AlmStruct.Socio = "">
		<cfset AlmStruct.FechaPartida = "">
		<cfset AlmStruct.FechaLlegada = "">
		<cfset AlmStruct.NumeroBOL = "">
		<cfset AlmStruct.FechaBOL = "">
		
		<cfquery name="queryAlloc" datasource="preicts">
			select distinct oo.order_type_code, a3.bl_date, a3.bl_ticket_num, a3.nor_date,
					 a3.disch_compl_date, a1.* from allocation_item a1
				inner join allocation_item a2
					on a2.trade_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
				   and a2.order_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.order_num#">
  				   and a2.item_num = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.item_num#">
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

		<cfif queryalloc.recordcount GT 0>
			<cfif queryalloc.order_type_code EQ 'PHYSICAL'>
				<cfset AlmStruct.Afecta = false>				
				<cfset AlmStruct.Almacen = "">
				<cfset AlmStruct.Transporte = "">
				<cfset AlmStruct.Socio = queryalloc.acct_num>
			</cfif>

			<cfif queryalloc.order_type_code EQ 'STORAGE'>
				<cfset AlmStruct.Afecta = true>				
				<cfset AlmStruct.Almacen = queryalloc.acct_ref_num>
				<cfset AlmStruct.Transporte = "">
				<cfset AlmStruct.Socio = queryalloc.acct_num>
			</cfif>
			
			<cfif queryAlloc.order_type_code EQ 'TRANSPRT'>
				<cfset AlmStruct.Transporte = queryalloc.acct_ref_num>
				<cfset AlmStruct.FechaPartida = queryalloc.nor_date>
				<cfset AlmStruct.FechaLlegada = queryalloc.disch_compl_date>
				<cfset AlmStruct.NumeroBOL = queryalloc.bl_ticket_num>
				<cfset AlmStruct.FechaBOL = queryalloc.bl_date>
				<cfquery name="queryTrans" datasource="preicts">
					select oo.order_type_code, a2.* from allocation_item a1
							inner join allocation_item a2
								on a2.alloc_num = a1.alloc_num
								 and a1.trade_num <> a2.trade_num
							inner join trade_item ti
								on ti.trade_num = a2.trade_num
								 and ti.order_num = a2.order_num
								 and ti.item_num = a2.item_num
								 and ti.p_s_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.P_s_ind#">
							inner join trade_order oo
								on oo.trade_num = a2.trade_num
									 and oo.order_num = a2.order_num
						 where a1.trade_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#queryalloc.trade_num#">
				</cfquery>
				<cfif queryTrans.recordcount GT 0>
					<cfif queryTrans.order_type_code EQ 'PHYSICAL'>
						<cfset AlmStruct.Afecta = false>				
						<cfset AlmStruct.Almacen = "">
						<cfset AlmStruct.Socio = querytrans.acct_num>
					</cfif>
					<cfif queryTrans.order_type_code EQ 'STORAGE'>
						<cfset AlmStruct.Afecta = true>				
						<cfset AlmStruct.Almacen = querytrans.acct_ref_num>
						<cfset AlmStruct.Socio = querytrans.acct_num>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	
		<cfreturn AlmStruct>
	</cffunction>  <!--- **** Fin de la Función **** --->

</cfcomponent>
