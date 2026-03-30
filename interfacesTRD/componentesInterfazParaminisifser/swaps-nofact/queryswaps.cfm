<!--- Requiere session.EmpresaICTS --->

<!--- Ejecutar query de swaps y meter en tabla de trabajo, solamente la primera vez.
      Este fragmento deberia ejecutarse siempre una vez a principios de mes.  --->


<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
drop table sif_interfaces..nofactSwapsPMI
go
create table sif_interfaces..nofactSwapsPMI (

		fecharegistro date null, anio int not null, mes int not null, EmpresaICTS int not null,

		ID integer null, trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, order_type_code varchar(8) null,
		cost_num integer null, cost_code varchar(8) null, cost_pay_rec_ind char(1) null, port_num integer null,
		cost_price_curr_code varchar(8) null, cost_price_uom_code char(4) null, cost_amt float null,
		creation_date date null, cost_eff_date date null, cost_due_date date null,
		SNid numeric null, Aid numeric null, UcodigoArt char(5) null, Mcodigo numeric null, Ucodigo char(5) null,
		subconcepto integer null, CodigoConcepto char(5) null, cost_type_code varchar(8) null, 
		ta_order_type_code varchar(8) null, ta_trade_num int null, ta_acct_ref_num char(10) null, 
		ta_acct_num int null, tt_order_type_code char(8) null, tt_acct_ref_num char(10) null,
		tt_acct_num int null, montocosto float null, PosNeg char(1) null, avg_price float null)
--->
<cfset FinDeMesAnterior = DateAdd("d", -1, CreateDate(Year(Now()), Month(Now()), 1))>
<cfset anio_proceso = Year  (FinDeMesAnterior)>
<cfset mes_proceso  = Month (FinDeMesAnterior)>

<cftransaction>
	<cfquery datasource="preicts" name="yahay">
		select count(1) as cantidad
		from #sifinterfacesdb#..nofactSwapsPMI
		where anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#anio_proceso#">
		  and mes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes_proceso#">
		  and EmpresaICTS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
	</cfquery>
	
	<cfif yahay.cantidad is 0>
		<cfquery datasource="preicts">
			insert #sifinterfacesdb#..nofactSwapsPMI (
				fecharegistro, anio, mes, EmpresaICTS,
				trade_num, order_num, item_num, acct_ref_num, acct_num, booking_comp_num,
				order_type_code, 
				cost_code, cost_pay_rec_ind, port_num, cost_price_curr_code, cost_price_uom_code,
				cost_amt, creation_date, cost_eff_date, cost_due_date, cost_num )
			select distinct
				getdate(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#anio_proceso#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#mes_proceso#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">,
				
				ti.trade_num, ti.order_num, ti.item_num, tr.acct_ref_num, tr.acct_num, ti.booking_comp_num,
				oo.order_type_code, 
				co.cost_code, co.cost_pay_rec_ind, co.port_num, co.cost_price_curr_code, co.cost_price_uom_code,
				co.cost_amt, co.creation_date, co.cost_eff_date, co.cost_due_date, co.cost_num
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
						 
						 <!--- posición abierta, o sea NOFACT --->
						 and co.cost_status = 'OPEN'
						 and co.cost_code = ti.cmdty_code
					  and co.cost_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
			where ti.booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
			order by co.cost_owner_code
		</cfquery>
		<cfset generado = true>
	<cfelse>
		<cfset generado = false>
	</cfif>
</cftransaction>
