<!--- Archivo    :  NoFactFletes  extrae.cfm  --->

<cfset LvarHoraInicio = now()>

<cfset session.FechaFolio = "#right(form.FechaF,4)##mid(form.FechaF,4,2)#">
<cfset session.FechaFinal = vFechaF>
<cfset vFechaFNOW = createdatetime(year(now()),month(now()),day(now()),23,59,59)>
<cfset vFechaM1 = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>
<cfset vFechaM1 = DateAdd('D',1,vFechaM1)>

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

<!--- Para desarrollo "sif_interfacesser.." y para produccción "sif_interfaces.."  --->
<cfset LvarDsource = "sif_interfaces..">
<cfset session.Dsource = LvarDsource>

<cftry>
	<cfquery datasource="preicts">
		drop table #LvarDsource#TempPMI
	</cfquery> 
<cfcatch type="any">
</cfcatch>
</cftry>

<cfquery datasource="sifinterfaces">
	delete from #LvarDsource#nofactFletesPMI where sessionid = #session.monitoreo.sessionid#
		or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from #LvarDsource#nofactFletesComprasPMI where sessionid = #session.monitoreo.sessionid#
		or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
	delete from #LvarDsource#PMIINT_IE10 where sessionid = #session.monitoreo.sessionid#
	delete from #LvarDsource#PMIINT_ID10 where sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
create table sif_interfaces..nofactFletesPMI (fecharegistro date null,sessionid numeric null,
		alloc_num integer null,alloc_item_num integer null,
		trade_num integer null, order_num smallint null, item_num smallint null,
		acct_ref_num char(10) null, acct_num int null, booking_comp_num int null, cmdty_code varchar(10),
		contr_date date null, 
		contr_qty_uom_code char(4) null, contr_qty float null, price_curr_code varchar(8) null, p_s_ind char(1) null, 
		SNid numeric null, Aid numeric null,  Mcodigo numeric null, 
		subconcepto integer null, cost_code varchar(8) null, cost_type_code varchar(8) null,
		montocosto float null, avg_price float null, CodigoDireccionFact varchar(20) null)

create table sif_interfaces..nofactFletesComprasPMI (fecharegistro date null,sessionid numeric null,
		OrdenFlete char(10) null,
		OCcontrato char(10) null, 
		alloc_num integer null,
		trade_num int null,
		title_tran_date date null, alloc_type_code char(1) null, del_term_code char(8) null, 
		nor_date date null, creation_date date null, fecha_allocation date null, real_port_num int null,
		bl_ticket_num varchar(15) null, bl_date date null, transportation varchar(40) null, load_compl_date date null,
		OrdenExiste char(1) null)
--->

<!--- Crea query de fletes nofact --->
<cfquery name="rsExtra" datasource="preicts">
	insert #LvarDsource#nofactFletesPMI (fecharegistro, sessionid, 
		alloc_num,alloc_item_num,trade_num, order_num,
		item_num, acct_ref_num, acct_num, booking_comp_num, cmdty_code, contr_date,
		contr_qty_uom_code, price_curr_code, montocosto, cost_code, cost_type_code)
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
		co.cost_owner_key1 as alloc_num, co.cost_owner_key2 as alloc_item_num,
		ti.trade_num, ti.order_num, ti.item_num,
		tr.acct_ref_num, co.acct_num, ti.booking_comp_num,
		ti.cmdty_code, tr.contr_date,
		ti.contr_qty_uom_code,
		ti.price_curr_code, co.cost_amt, co.cost_code, co.cost_type_code
	from cost co
		inner join trade_item ti
			inner join trade tr
			on tr.trade_num = ti.trade_num
		on ti.trade_num= co.cost_owner_key6
		and ti.order_num = co.cost_owner_key7
		and ti.item_num = co.cost_owner_key8
	
	where (co.cost_owner_code = 'AI')
	  and co.cost_amt > 0
	  and co.cost_code like 'FREIGHTO'
	  and co.cost_status = 'OPEN'
	  and co.cost_prim_sec_ind = 'S'
	  and co.cost_type_code = 'TMC'
	  and co.cost_pay_rec_ind = 'P'
	  and co.cost_book_comp_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
	  and Exists (
					select 1 from allocation_item ai
					inner join trade_item a2	
						inner join trade_order a3
						on a3.trade_num = a2.trade_num
						   and a3.order_num = a2.order_num
						and a3.order_type_code='PHYSICAL'
					on a2.trade_num = ai.trade_num
					and a2.order_num = ai.order_num
					   and a2.item_num = ai.item_num
					and a2.p_s_ind = 'P'
				
				 where ai.alloc_num in (select alloc_num from allocation_item a1
																where a1.trade_num=co.cost_owner_key6
																   and a1.order_num=co.cost_owner_key7
																   and a1.item_num=co.cost_owner_key8
																   and a1.alloc_num = co.cost_owner_key1
																   and a1.alloc_item_num = co.cost_owner_key2)
				and ai.alloc_item_type ='R'
				and (ai.title_tran_date IS NOT null)
				and ai.title_tran_date < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaF)#">
					   )
	union
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid,
		co.cost_owner_key1 as alloc_num, co.cost_owner_key2 as alloc_item_num,		
		ti.trade_num, ti.order_num, ti.item_num,
		tr.acct_ref_num, co.acct_num, ti.booking_comp_num,
		ti.cmdty_code, tr.contr_date,
		ti.contr_qty_uom_code,
		ti.price_curr_code, co.cost_amt, co.cost_code, co.cost_type_code
	from cost co
		inner join trade_item ti
			inner join trade tr
			on tr.trade_num = ti.trade_num
		on ti.trade_num= co.cost_owner_key6
		and ti.order_num = co.cost_owner_key7
		and ti.item_num = co.cost_owner_key8
		inner join voucher_cost vc
				inner join voucher vr
				on vc.voucher_num = vr.voucher_num and vr.voucher_creation_date between  
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaM1)#">
					and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaFNOW)#">
		on vc.cost_num = co.cost_num
	where (co.cost_owner_code = 'TI')
	  and co.cost_amt > 0
	  and co.cost_code like 'FREIGHTO'
	  and co.cost_prim_sec_ind = 'S'
	  and co.cost_type_code = 'TTC'
	  and co.cost_pay_rec_ind = 'P'
	  and co.cost_book_comp_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
	  and Exists (
					select 1 from allocation_item ai
					inner join trade_item a2	
						inner join trade_order a3
						on a3.trade_num = a2.trade_num
						   and a3.order_num = a2.order_num
						and a3.order_type_code='PHYSICAL'
					on a2.trade_num = ai.trade_num
					and a2.order_num = ai.order_num
					   and a2.item_num = ai.item_num
					and a2.p_s_ind = 'P'
				
				 where ai.alloc_num in (select alloc_num from allocation_item a1
																where a1.trade_num=co.cost_owner_key6
																   and a1.order_num=co.cost_owner_key7
																   and a1.item_num=co.cost_owner_key8
																   and a1.alloc_num = co.cost_owner_key1
																   and a1.alloc_item_num = co.cost_owner_key2)
				and ai.alloc_item_type ='R'
				and (ai.title_tran_date IS NOT null)
				and ai.title_tran_date < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaF)#">
					   )
</cfquery>
<cfset LvarOCtipoIC = "C">

<cfset LvarBanderaErrores = false>
<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">

<!--- procesa los registros de nofact de fletes --->	
<cfset LvarBanderaErrores_registro = False>
<cfset LvarTipoError = "">

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactFletesPMI SET SNid = a2.SNid
	from #LvarDsource#nofactFletesPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.acct_num
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery> 

<!--- Existencia de la  Direccion FLETADOR  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactFletesPMI SET  CodigoDireccionFact =c.SNcodigoext 
	FROM #LvarDsource#nofactFletesPMI a, SNegocios b, SNDirecciones c 
	WHERE a.acct_num=convert(int,b.SNcodigoext) and b.SNid=c.SNid and c.SNnombre like 'FLETADOR'
</cfquery> 

<!--- Existencia del Articulo  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactFletesPMI SET Aid = a2.Aid
	from  #LvarDsource#nofactFletesPMI a1, Articulos a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Acodalterno  = a1.cmdty_code
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- subconcepto  --->
<cfquery datasource="preicts">
	UPDATE #LvarDsource#nofactFletesPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#nofactFletesPMI a1
	WHERE s.costo_id = a1.cost_code
	  AND s.tipo_costo = a1.cost_type_code
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
	  and a1.sessionid = #session.monitoreo.sessionid#

	UPDATE #LvarDsource#nofactFletesPMI SET subconcepto = sb.subconcepto_id
	from tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r,
	     tesoreria..subconceptos_detalle s, #LvarDsource#nofactFletesPMI a1
	WHERE s.costo_id = a1.cost_code
	  AND s.tipo_costo = 'ANY'
	  AND a1.subconcepto is null
	  AND s.payable_receivable = 'P'
	  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
	  AND sb.subconcepto_id = r.subconcepto_id
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- cuando es una compra graba las compras relacionadas  --->
<cfquery datasource="preicts">
	insert #LvarDsource#nofactFletesComprasPMI (fecharegistro, sessionid, OrdenFlete, OCcontrato,alloc_num,
					trade_num, title_tran_date, alloc_type_code, del_term_code, nor_date, creation_date, 
					fecha_allocation, bl_ticket_num, bl_date, transportation, load_compl_date)
	select distinct getdate(), #session.monitoreo.sessionid# as sessionid, ai.acct_ref_num,
		a2.acct_ref_num, a2.alloc_num,a2.trade_num,a2.title_tran_date, a5.alloc_type_code, a2.del_term_code, a10.nor_date,
		tr.creation_date, a5.creation_date as fecha_allocation, a10.bl_ticket_num, a10.bl_date,
		a10.transportation, a10.load_compl_date
	from allocation_item ai
		inner join #LvarDsource#nofactFletesPMI nfa

		on nfa.trade_num=ai.trade_num
		and nfa.order_num=ai.order_num
		and nfa.item_num=ai.item_num
		and nfa.alloc_num =ai.alloc_num 
		and nfa.alloc_item_num = ai.alloc_item_num

		inner join allocation_item a2
			inner join allocation a5
			on a5.alloc_num = a2.alloc_num
			inner join allocation_item_transport a10
			on a10.alloc_num = a2.alloc_num
			and a10.alloc_item_num = a2.alloc_item_num

			inner join trade_item ti	
				inner join trade_order a3
					inner join trade tr
					on tr.trade_num = a3.trade_num
				on a3.trade_num = ti.trade_num
				   and a3.order_num = ti.order_num
				and a3.order_type_code='PHYSICAL'
			on ti.trade_num = a2.trade_num
			and ti.order_num = a2.order_num
			and ti.item_num = a2.item_num
			and ti.p_s_ind = 'P'

		on a2.alloc_num = ai.alloc_num
		and a2.alloc_item_type = 'R'
		and (a2.title_tran_date IS NOT null)
		and a2.title_tran_date < <cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaF)#">	  
		where nfa.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- revisa si las ordenes de compra existen en la Estructura de Ordenes Comerciales  --->
<cfquery datasource="#session.dsn#">
	UPDATE #LvarDsource#nofactFletesComprasPMI SET OrdenExiste = 'S'
	from #LvarDsource#nofactFletesComprasPMI a1, OCordenComercial a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.OCcontrato = a1.OCcontrato
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery> 

<cfquery name="rsNoFact" datasource="sifinterfaces">
	select distinct alloc_num,alloc_item_num,acct_ref_num, cmdty_code, 
			CodigoDireccionFact, SNid, Aid, price_curr_code, subconcepto, cost_code,
			cost_type_code, contr_qty_uom_code, sum(montocosto) as montocosto, 
			acct_num, trade_num
	from  #LvarDsource#nofactFletesPMI 
	where sessionid = #session.monitoreo.sessionid#
	group by acct_ref_num, item_num, order_num, cmdty_code, alloc_num, alloc_item_num
</cfquery>

<cfset ConseIE10 = 0>
<cfloop query="rsNoFact"> 
	<cfset LvarBanderaErrores_registro = False>
	<cfset LvarTipoError = "">
	
	<!--- crear folio de noFact de fletes    --->
	<cfset ws_folio = "#rsNoFact.acct_ref_num#FLE#session.FechaFolio#">
	
	<!---Si ya existe el documento salta esta parte--->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
		select ID from PMIINT_IE10 
		where Documento = '#ws_folio#'
		and sessionid = #session.monitoreo.sessionid#
	</cfquery>
	<cfif  rsVerifica.recordcount EQ 0>
	
		<!---Valida que el transporte exista en la Estructura de SOIN --->
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select * from OCtransporte ot where ot.OCTtransporte = '#rsNoFact.acct_ref_num#'
				and ot.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Transporte no existe en estructura OC SIF-V6">
		</cfif>
			
		<!--- Valida que el producto este registrado en el transporte --->
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select * from OCproductoTransito tp inner join OCtransporte ot on tp.OCTid = ot.OCTid and tp.Ecodigo = ot.Ecodigo
												and ot.OCTtransporte = '#rsNoFact.acct_ref_num#'
												inner join Articulos a on tp.Aid = a.Aid and tp.Ecodigo = a.Ecodigo
												and a.Acodigo = '#rsNoFact.cmdty_code#'
			where tp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Producto: #rsNoFact.cmdty_code# no registrado en Transporte">
		</cfif>
		
		<!--- Existencia de la direccion FLETADOR  --->
		<cfif Len(rsNoFact.CodigoDireccionFact) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Socio sin direccion FLETADOR ">
		</cfif>
		
		<!--- Existencia del Socio de Negocio  --->
		<cfif Len(rsNoFact.SNid) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Socio No Definido">
		</cfif>

		<!--- Existencia del Articulo  --->
		<cfif Len(rsNoFact.Aid) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfset LvarAid = 0>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Producto No Definido">
		<cfelse>
			<cfset LvarAid = #rsNoFact.Aid#>
		</cfif>

		<!--- Moneda es Valida  --->
		<cfset ws_curr_code = mid(rsNoFact.price_curr_code,1,3)>
		<cfif ws_curr_code EQ 'MXN'>
			<cfset ws_curr_code = "MXP">
		</cfif>
			
		<cfquery name="rsVerifica" datasource="#session.dsn#">
			select Mcodigo
			from Monedas a
			where a.Ecodigo  = #session.ecodigo#
			  and a.Miso4217 = '#ws_curr_code#'
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarMcodigo = 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Moneda Incorrecta">
		<cfelse>
			<cfset LvarMcodigo = rsVerifica.Mcodigo>
		</cfif> 

		<!--- valida subconcepto  --->
		<cfif Len(rsNoFact.subconcepto) EQ 0>
			<cfset LvarBanderaErrores_registro = true>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "No existe subconcepto en Tesorería(#rsNoFact.cost_code#,#rsNoFact.cost_type_code#)">
		</cfif>
	
		<cfset LvarConceptoCompra = toString(rsNoFact.subconcepto)>
	</cfif>
	<!---Carga de Variables--->
	<cfset ws_tipo_modulo = "CP">
	<cfset ws_tipo_transaccion = "EI">
	<cfset ws_TipoItem = 'O'>
	<cfset ws_CodigoItem = rsNoFact.cmdty_code>
	<cfset ws_Transporte = rsNoFact.acct_ref_num>
	<cfset ws_contr_qty_uom_code = rsNoFact.contr_qty_uom_code>

	<!--- valida registros ya procesados  --->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
	   select ID from #session.Dsource#IE10  
	    where Documento = '#ws_folio#' 
		and EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Registro ya procesado">
	</cfif>

	<cfif rsNoFact.montocosto EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "Monto del costo en cero">
	</cfif>

	<cfquery name="rsCompras" datasource="sifinterfaces">
		select *
		from nofactFletesComprasPMI fc
		where OrdenFlete = <cfqueryparam cfsqltype="cf_sql_char" value="#rsNoFact.acct_ref_num#">
		  and sessionid = #session.monitoreo.sessionid#
		  and alloc_num = #rsNoFact.alloc_num#
		  and exists (select 1 from preicts..trade_item where trade_num = fc.trade_num 
		  			and cmdty_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNoFact.cmdty_code#">
		  			and booking_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">)
	</cfquery>
	<cfif rsCompras.recordcount EQ 0>
		<cfset LvarBanderaErrores_registro = true>
		<cfset LvarBanderaErrores = true>
		<cfif len(LvarTipoError)>
			<cfset LvarTipoError = LvarTipoError & ", ">
		</cfif>
		<cfset LvarTipoError = LvarTipoError & "No se encontraron Ordenes allocadas">
		<cfset ws_title_tran_date = now()>
	<cfelse>
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select max(title_tran_date) as title_tran_date
			from nofactFletesComprasPMI fc
			where exists (select 1 from preicts..allocation_item 
							where alloc_num = fc.alloc_num 
							and trade_num = #rsNoFact.trade_num#)
		</cfquery>
		<cfset ws_title_tran_date = rsVerifica.title_tran_date>
	</cfif>
	<!---Si ya existe el documento salta esta parte si existe lo inserta--->
	<cfquery name="rsVerificaDoc" datasource="sifinterfaces">
		select ID from PMIINT_IE10 
		where Documento = '#ws_folio#'
		and sessionid = #session.monitoreo.sessionid#
	</cfquery>
	<cfif  rsVerificaDoc.recordcount EQ 0>
		<cfset ConseIE10 = ConseIE10 + 1>
		<cfset IDIE10 = ConseIE10>
		<!--- Graba error en tabla pmiIE10  --->
		<cfquery datasource="sifinterfaces">
			insert into PMIINT_IE10 (FechaRegistro, sessionid,
				ID, EcodigoSDC, NumeroSocio, Modulo, 
				CodigoTransacion, Documento, Estado, 
				CodigoMoneda, 
				FechaDocumento, 
				FechaVencimiento, 
				Facturado, Origen, VoucherNo, CodigoConceptoServicio, 
				CodigoRetencion, CodigoOficina, CuentaFinanciera, 
				DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
				FechaTipoCambio, StatusProceso,MensajeError)
			values(getdate(), #session.monitoreo.sessionid#, 
				#ConseIE10#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">,
				'#rsNoFact.acct_num#', '#ws_tipo_modulo#',
				'#ws_tipo_transaccion#', '#ws_folio#', ' ',
				'#rsNoFact.price_curr_code#', 
				<cfqueryparam cfsqltype="cf_sql_date" value="#ws_title_tran_date#">, 
				null,
				'S', '#ws_tipo_modulo#', '#rsNoFact.trade_num#', null, 
				null, null, null,
				0, '#rsNoFact.CodigoDireccionFact#', '#rsNoFact.CodigoDireccionFact#', 
				<cfqueryparam cfsqltype="cf_sql_date" value="#ws_title_tran_date#">, 
				1,
				<cfif len(LvarTipoError) GT 0>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipoError#">
				<cfelse>
					null
				</cfif>
				)
		</cfquery>
		<cfset ConseID10 = 0>
	<cfelseif rsVerificaDoc.recordcount EQ 1>
		<cfif len(LvarTipoError) GT 0>
			<!--- Actualiza el Mensaje de Error del Documento --->
			<cfquery datasource="sifinterfaces">
				update PMIINT_IE10 
				set MensajeError = MensajeError + ' Salto ' +
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipoError#">
				where ID = #rsVerificaDoc.ID#
				and sessionid = #session.monitoreo.sessionid#
			</cfquery>
		</cfif>				
		<cfset IDIE10 = rsVerificaDoc.ID>
		<cfquery name="rsVerificaDdoc" datasource="sifinterfaces">
			select max(Consecutivo) as Consecutivo from PMIINT_ID10 
			where ID = #rsVerificaDoc.ID#
			and sessionid = #session.monitoreo.sessionid#
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset ConseID10 = rsVerificaDdoc.Consecutivo>
		<cfelse>
			<cfset ConseID10 = 0>
		</cfif>
	<cfelse>
		<cfabort showerror="Documento Repetido en la IE10">
	</cfif>
		
	<cfset ws_PrimeraVez = true>
	<cfif rsCompras.recordcount GT 0>
		<cfset ws_registros = rsCompras.recordcount>
		<cfif ws_registros GT 1>
			<cfset ws_monto = abs(round(rsNoFact.montocosto / ws_registros))>
		<cfelse>
			<cfset ws_monto = abs(rsNoFact.montocosto)>
		</cfif>
		<!--- obtiene la diferencia de los detalles con el monto total, para posteriormente sumarlo --->
		<!--- al primer detalle de la tabla PMIINT_ID10 --->
		<cfif ws_registros GT 1>
			<cfset ws_diferencia = abs(rsNoFact.montocosto) - (ws_monto * ws_registros)>
		<cfelse>
			<cfset ws_diferencia = 0>
		</cfif>	
		
		<cfloop query="rsCompras">
			<!--- Busca el Tipon de transporte Directo en la Estructura de OC para evitar errores --->
			<cfquery name="rsVerificaT" datasource="#session.dsn#">
				select OCTtipo from OCtransporte 
					where OCTtransporte = '#ws_Transporte#'
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfquery>
			<cfif rsVerificaT.recordcount GT 0>
				<cfset OCTtipoOC = rsVerificaT.OCTtipo>
			</cfif>
			<cfif ws_PrimeraVez>
				<cfset ws_PrimeraVez = false>
				<cfset ws_montoTotal = ws_monto + ws_diferencia>
			<cfelse>
				<cfset ws_montoTotal = ws_monto>
			</cfif>

			<!--- decodifica campo alloc_type_code  --->	
			<cfif rsCompras.alloc_type_code EQ "W">
				<cfset LvarOCTtipo = "B">
			<cfelseif rsCompras.alloc_type_code EQ "R">
				<cfset LvarOCTtipo = "F">
			<cfelse>
				<cfset LvarOCTtipo = "T">
			</cfif>
			<cfif isdefined("OCTtipoOC") and OCTtipoOC NEQ LvarOCTtipo>
				<cfset LvarOCTtipo = OCTtipoOC>
			</cfif>
			<cfif ISNUMERIC(rsCompras.bl_ticket_num)>
				<cfset Lvarbl_ticket_num = rsCompras.bl_ticket_num>
			<cfelse>
				<cfset Lvarbl_ticket_num=0>
			</cfif>
		
			<cfif ISDATE(rsCompras.bl_date)>
				<cfset Lvarbl_date=rsCompras.bl_date>
			<cfelse>
				<cfset Lvarbl_date=now()>
			</cfif>

			<cfset ConseID10 = ConseID10 + 1>
			<cfquery datasource="sifinterfaces">
				insert PMIINT_ID10 (FechaRegistro,sessionid,
					ID, Consecutivo, TipoItem, CodigoItem, 
					NombreBarco, FechaHoraCarga, FechaHoraSalida, 
					PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
					TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
					ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
					PrecioTotal, 
					CentroFuncional, CuentaFinancieraDet, 
					OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
				values(getdate(), #session.monitoreo.sessionid#,
					#IDIE10#, #ConseID10#, '#ws_TipoItem#', '#ws_CodigoItem#',
					'#rsCompras.transportation#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsCompras.load_compl_date#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsCompras.nor_date#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(0,"9.99")#">, 
					'',
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#0#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#0#">, 
					'#rsCompras.del_term_code#', '#Lvarbl_ticket_num#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
					null, '#rsCompras.OCcontrato#', null, 0.00,
					0.00, null, null,
					#numberformat(ws_montoTotal,"9.99")#,
					null, null,
					'#LvarOCTtipo#', '#ws_Transporte#', '#rsCompras.OCcontrato#', '#LvarConceptoCompra#'
					)
			</cfquery>
		</cfloop>
	</cfif>
</cfloop>
