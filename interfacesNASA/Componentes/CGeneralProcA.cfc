<!--- 
	Archivo       : CFacturaProcA.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos a utilizar en los procesos de tipo A
--->
<cfcomponent>
	<!--- Se define el objeto de Costos a utilizar  --->
	<cfobject name="OCostosPMI" component="interfacesTRD.Componentes.CCostosPMI">
	<cfobject name="OCostosFact" component="interfacesTRD.Componentes.CCostosFact">

	<!--- //// consulta PmiFolios  --->
	<cffunction name="ConsultaFolio" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
			select i_folio, i_anio, i_voucher, i_empresa, i_empresa_prop, dt_fecha_vencimiento,
			       c_tipo_folio, c_orden, c_docto_proveedor, c_moneda
			from PmiFolios
			where i_voucher = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Voucher#">
			  and i_empresa_prop = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
		</cfquery>
		
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta PmiFoliosDetailP  --->
	<cffunction name="ConsultaFolioProductos" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfargument name="FechaVenc" required="Yes" type="date">
		<cfargument name="TipoFolio" required="Yes" type="string">
		<cfargument name="MontoVoucher" required="Yes" type="numeric">
		<cfargument name="Folio" required="Yes" type="numeric">
		<cfargument name="Anio" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
            select c_producto, c_unidad, sum(f_volumen) as f_cantidad, sum(f_importe) as f_importe,
			       sum(f_precio) / count(*) as f_precio
			 from PmiFoliosDetailP
			where i_folio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.Folio)#">
			  and i_anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.Anio)#">
			  group by c_producto, c_unidad
		</cfquery>

		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta PmiFoliosServicios  --->
	<cffunction name="ConsultaFolioServicios" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfargument name="FechaVenc" required="Yes" type="date">
		<cfargument name="TipoFolio" required="Yes" type="string">
		<cfargument name="MontoVoucher" required="Yes" type="numeric">
		<cfargument name="Folio" required="Yes" type="numeric">
		<cfargument name="Anio" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
            select c_orden, c_concepto, c_unidad, sum(f_cantidad) as f_cantidad, sum(f_importe) as f_importe,
			       sum(f_precio) / count(*) as f_precio
			 from PmiFoliosDetailS
			where i_folio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.Folio)#">
			  and i_anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.Anio)#">
			  group by c_orden, c_concepto, c_unidad
		</cfquery>

		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta tabla cost  --->
	<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
	<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
	<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
	<cffunction name="ConsultaCostosNoFactFletes" returntype="query">
		<cfargument name="trade_num" required="Yes" type="numeric">
		<cfargument name="order_num" required="Yes" type="numeric">
		<cfargument name="item_num" required="Yes" type="numeric">
		<cfargument name="TipoFactura" required="Yes" type="string">
		<cfargument name="producto" required="Yes" type="string">
		<cfargument name="tipo_consulta" required="Yes" type="string">
		<cfset var qCostos = "">

		<cfif arguments.tipo_consulta EQ 'N'>
			<cfquery name="qCostos" datasource="preicts">
				select cost_owner_key6, cost_owner_key7, cost_owner_key8, cost_pay_rec_ind,
					   cost_code, sum(cost_amt) as tcosto
				from cost co
				where co.cost_owner_key6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
				  and co.cost_owner_key7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.order_num#">
				  and co.cost_owner_key8 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.item_num#">
				  and (co.cost_owner_code like 'A%' or co.cost_owner_code = 'TI')
				  and co.cost_code like 'FREIG%'
				  and co.cost_status = 'OPEN'
				  and co.cost_prim_sec_ind = 'S'
				  and co.cost_type_code = 'TMC'
				  and co.cost_pay_rec_ind = 'P'
				group by co.cost_owner_key6, co.cost_owner_key7, co.cost_owner_key8, co.cost_pay_rec_ind, co.cost_code
				order by tcosto desc
			</cfquery>
		</cfif>

		<cfloop query="qCostos">
			<cfset OCostosPMI.IncluirCosto(qcostos.cost_owner_key6,qcostos.cost_owner_key7,
				   qcostos.cost_owner_key8, qcostos.cost_code, qcostos.tcosto, qcostos.cost_pay_rec_ind,
				   Arguments.TipoFactura)>
		</cfloop>
		
		<!--- Consulta los costos agrupados  --->
		<cfset qCostos = OCostosPMI.ListaCostos()>
		<cfset OCostosPMI.LimpiarArreglo()>		
		<cfreturn qCostos>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta tabla cost  --->
	<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
	<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
	<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
	<cffunction name="ConsultaCostosNoFactProd" returntype="query">
		<cfargument name="trade_num" required="Yes" type="numeric">
		<cfargument name="order_num" required="Yes" type="numeric">
		<cfargument name="item_num" required="Yes" type="numeric">
		<cfargument name="alloc_num" required="Yes" type="numeric">
		<cfargument name="alloc_item_num" required="Yes" type="numeric">
		<cfargument name="TipoFactura" required="Yes" type="string">
		<cfargument name="producto" required="Yes" type="string">
		<cfargument name="tipo_consulta" required="Yes" type="string">
		<cfargument name="FechaI" required="Yes" type="date">
		<cfargument name="FechaF" required="Yes" type="date">
		<cfset var qCostos = "">

		<cfset vFechaI = arguments.FechaI>
		<cfset vFechaF = arguments.FechaF>
		<cfset vFechaM1 = DateAdd('D',1, arguments.FechaF)>
		
		<cfif arguments.tipo_consulta EQ 'N'>
			<cfquery name="qCostos" datasource="preicts">
				select cost_owner_key6, cost_owner_key7, cost_owner_key8, cost_owner_key1, cost_owner_key2,
				       cost_pay_rec_ind, cost_code, sum(cost_amt) as tcosto
				from cost a1
				where a1.cost_owner_key1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.alloc_num#">
				  and a1.cost_owner_key2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.alloc_item_num#">
				  and a1.cost_owner_key6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
				  and a1.cost_owner_key7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.order_num#">
				  and a1.cost_owner_key8 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.item_num#">
				  and a1.cost_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.producto#">
				  and a1.cost_status = 'OPEN'
				  and (a1.cost_owner_code <> 'TI')
				  and (a1.cost_type_code <> 'WS')				  
				group by cost_owner_key6, cost_owner_key7, cost_owner_key8, cost_owner_key1, cost_owner_key2, cost_pay_rec_ind, cost_code

				union

				select cost_owner_key6, cost_owner_key7, cost_owner_key8, cost_owner_key1, cost_owner_key2,
					   cost_pay_rec_ind, cost_code, sum(cost_amt) as tcosto
				from cost a1
					inner join voucher_cost vco
						inner join PmiInvoice inv
						on inv.voucherNum = vco.voucher_num
						and invoiceDate between
						<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaI)#"> 
						and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(vFechaF)#">
						and upper(inv.printedInd) = 'N'
					on vco.cost_num = a1.cost_num
				where a1.cost_owner_key1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.alloc_num#">
				  and a1.cost_owner_key2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.alloc_item_num#">
				  and a1.cost_owner_key6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
				  and a1.cost_owner_key7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.order_num#">
				  and a1.cost_owner_key8 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.item_num#">
				  and a1.cost_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.producto#">
				  and a1.cost_status = 'VOUCHED'
				group by cost_owner_key6, cost_owner_key7, cost_owner_key8, cost_owner_key1, cost_owner_key2, cost_owner_key1, cost_owner_key2, cost_pay_rec_ind, cost_code
				order by tcosto desc
			</cfquery>
		<cfelse>
			<cfif arguments.TipoFactura EQ 'V'>
				<cfquery name="qCostos" datasource="preicts">
					select a1.cost_owner_key6, a1.cost_owner_key7, a1.cost_owner_key8, cost_owner_key1, cost_owner_key2,
					       a1.cost_pay_rec_ind, a1.cost_code, sum(a1.cost_amt) as tcosto
					from cost a1
					where a1.cost_owner_key1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.alloc_num#">
				      and a1.cost_owner_key2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.alloc_item_num#">
				      and a1.cost_owner_key6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
					  and a1.cost_owner_key7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.order_num#">
					  and a1.cost_owner_key8 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.item_num#">
					  and a1.cost_status in ('PAID','VOUCHED')
					  and a1.cost_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.producto#">
					  and EXISTS(select co.cost_num from cost co
									inner join voucher_cost vco
										inner join PmiInvoice inv
										on inv.voucherNum = vco.voucher_num
										and inv.invoiceDate between
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaI#"> 
										and
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaF#">
										and upper(inv.printedInd) in ('L','T','Y','R','O','N') 
										and upper(invoiceType) in('G','K','P','R','W','C','D')
									on vco.cost_num = co.cost_num
							   where a1.cost_num = co.cost_num)
					group by cost_owner_key6, cost_owner_key7, cost_owner_key8, cost_owner_key1, cost_owner_key2, cost_pay_rec_ind, cost_code
					order by tcosto desc
				</cfquery>
			<cfelse>
				<cfquery name="qCostos" datasource="preicts">
					select a1.cost_owner_key6, a1.cost_owner_key7, a1.cost_owner_key8, cost_owner_key1, cost_owner_key2,
						   a1.cost_pay_rec_ind, a1.cost_code, sum(a1.cost_amt) as tcosto
					from cost a1
					where a1.cost_owner_key1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.alloc_num#">
				      and a1.cost_owner_key2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.alloc_item_num#">
					  and a1.cost_owner_key6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
					  and a1.cost_owner_key7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.order_num#">
					  and a1.cost_owner_key8 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.item_num#"> 
					  and a1.cost_status in ('PAID','VOUCHED')
					  and a1.cost_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.producto#">
					  and EXISTS(select co.cost_num from cost co
									inner join voucher_cost vco
										inner join voucher vo
										on vco.voucher_num = vo.voucher_num
										and vo.voucher_creation_date between 
										<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(vFechaM1)#"> 
										and
										<cfqueryparam cfsqltype="cf_sql_date" value="#ParseDateTime(now())#">
									on vco.cost_num = co.cost_num
							   where a1.cost_num = co.cost_num)
					group by cost_owner_key6,cost_owner_key7, cost_owner_key8, cost_owner_key1, cost_owner_key2, cost_pay_rec_ind, cost_code
					order by tcosto desc
				</cfquery>
			</cfif>
		</cfif>
		
		<cfloop query="qCostos">
			<cfset OCostosPMI.IncluirCosto(qcostos.cost_owner_key6,qcostos.cost_owner_key7,
				   qcostos.cost_owner_key8, qcostos.cost_owner_key1, qcostos.cost_owner_key2,
				   qcostos.cost_code, qcostos.tcosto, qcostos.cost_pay_rec_ind,
				   Arguments.TipoFactura)>
		</cfloop>
		
		<!--- Consulta los costos agrupados  --->
		<cfset qCostos = OCostosPMI.ListaCostos()>
		<cfset OCostosPMI.LimpiarArreglo()>		
		<cfreturn qCostos>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta tabla cost  --->
	<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por No. de Documento, y se  --->
	<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
	<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
	<cffunction name="ConsultaCostosFact" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfargument name="TotalVoucher" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoFactura" required="Yes" type="string">
		<cfset var qCostos = "">
		<cfset var qItem = "">
		<cfset var pri_Trade = "">
		<cfset var pri_Order= "">
		<cfset var pri_Item = "">
		<cfset var TotalCostos = 0>

		<cfquery name="qCostos" datasource="preicts">
			select ab.cost_pay_rec_ind, ab.cost_code, sum(ab.cost_amt) as tcosto
			from cost ab
			inner join voucher_cost aa
			   on aa.voucher_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.voucher#">
			   and aa.cost_num = ab.cost_num 
			where ab.cost_status='PAID' or ab.cost_status = 'VOUCHED'
			group by ab.cost_pay_rec_ind, ab.cost_code
			order by tcosto desc
		</cfquery>

		<cfif qCostos.recordcount EQ 0>
			<!--- Graba error por no haber registros en tabla cost  --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento","Voucher-Cost")>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se encontraron registros de costo en tabla cost")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",#Arguments.Voucher#)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0.00)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		</cfif>

		<cfloop query="qCostos">
			<cfset OCostosFact.IncluirCosto(arguments.documento, qcostos.cost_code, 
				   qcostos.tcosto, qcostos.cost_pay_rec_ind, Arguments.TipoFactura)>
		</cfloop>
		
		<!--- Consulta los costos agrupados  --->
		<cfset qCostos = OCostosFact.ListaCostos()>
		<cfset OCostosFact.LimpiarArreglo()>		
		<cfreturn qCostos>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta tabla cost  --->
	<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por No. de Documento, y se  --->
	<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
	<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
	<cffunction name="ConsultaCostosFact_respaldo" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfargument name="TotalVoucher" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoFactura" required="Yes" type="string">
		<cfset var qCostos = "">
		<cfset var qItem = "">
		<cfset var pri_Trade = "">
		<cfset var pri_Order= "">
		<cfset var pri_Item = "">
		<cfset var TotalCostos = 0>

		<cfquery name="qCostos" datasource="preicts">
			select ab.cost_pay_rec_ind, ab.cost_code, ab.cost_owner_key6 as key6, ab.cost_owner_key7 as key7,
			       ab.cost_owner_key8 as key8, sum(ab.cost_amt) as tcosto
			from voucher_cost aa, cost ab
			where aa.voucher_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.voucher#">
			and aa.cost_num = ab.cost_num and (ab.cost_status = 'PAID' or ab.cost_status = 'VOUCHED')
			group by ab.cost_pay_rec_ind, ab.cost_code, ab.cost_owner_key6, ab.cost_owner_key7, 
			         ab.cost_owner_key8
			order by ab.cost_amt desc
		</cfquery>

		<cfif qCostos.recordcount EQ 0>
			<!--- Graba error por no haber registros en tabla cost  --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento","Voucher-Cost")>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se encontraron registros de costo en tabla cost")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",#Arguments.Voucher#)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0.00)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		</cfif>
		
		<cfloop query="qCostos">
			<cfif len(qcostos.key6) and len(qcostos.key7) and len(qcostos.key8)>
				<cfset pri_Trade = qcostos.key6>
				<cfset pri_Order = qcostos.key7>
				<cfset pri_Item = qcostos.key8>
			</cfif>
			<cfset OCostosFact.IncluirCosto(arguments.documento, qcostos.cost_code, 
				   qcostos.tcosto, qcostos.cost_pay_rec_ind, Arguments.TipoFactura,
				   pri_Trade, pri_Order, pri_Item)>
		</cfloop>
		
		<!--- Se valida que los costos son iguales al monto del voucher  --->
		<cfset TotalCostos = OCostosFact.SumarCostos()>
		<cfif abs(Arguments.TotalVoucher - TotalCostos) GT 2>
			<!--- Graba error por diferencia de montos entre el voucher y el total de costos  --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento","Voucher")>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","Diferencia entre el voucher y total de costos")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",Arguments.Voucher)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto", TotalCostos)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		</cfif>


		<!--- Consulta los costos agrupados  --->
		<cfset qCostos = OCostosFact.ListaCostos()>
		<cfset OCostosFact.LimpiarArreglo()>		
		<cfreturn qCostos>
	</cffunction>  <!--- **** Fin de la Función **** --->



	<!--- //// consulta de PmiInvoice  --->
	<cffunction name="ConsultaInvoice" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
			select invoice, voucherNum, acct_num, bookingCo, invoiceDate,
			       invoiceType, trade_num, your_ref_num
			from PmiInvoice
			where voucherNum = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Voucher#">
			  and bookingCo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EmpresaICTS#">
			  and paginaFact = 1
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<!--- Graba error por no haber registro en PmiInvoice  --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento","Voucher-Factura")>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se encontró el voucher en PmiInvoice")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",#Arguments.Voucher#)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","CXC")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0.00)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		</cfif>
		
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta de PmiInvoiceDetail  --->
	<cffunction name="ConsultaInvoiceDetail" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfargument name="FechaFact" required="Yes" type="date">
		<cfargument name="TipoFactura" required="Yes" type="string">
		<cfargument name="MontoVoucher" required="Yes" type="numeric">
		<cfargument name="Factura" required="Yes" type="string">
		<cfset var query = "">
		<cfset var TotalDetalles = 0.00>

		<cfquery name="query" datasource="preicts">
			select voucherNum, paginaFact, f_vol_nvo, c_unidades, f_precio_nvo, f_importe, 
			c_moneda, c_concepto_ing
			from PmiInvoiceDetail
			where voucherNum = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.Voucher)#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<!--- Graba error por no encontrar registros en PmiInvoiceDetail  --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento",#Arguments.FechaFact#)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento",#Arguments.TipoFactura#)>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se encontraron registros en PmiInvoiceDetail")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",#Arguments.Factura#)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","CXC")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",#Arguments.MontoVoucher#)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion",#Arguments.Voucher#)>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		</cfif>

		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Socio de Negocios  --->
	<cffunction name="ConsultaSocioNegocios" returntype="query">
		<cfargument name="Empresa" required="Yes" type="string">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoDocumento" required="Yes" type="string">
		<cfset var query = "">

		<!--- se accesa el socio de negocios de la tabla SNegocios, usando el campo Empresa  --->
		<cfquery name="query" datasource="#Session.Dsn#">
			select a1.Ecodigo, a1.SNcodigo, a1.SNid, a1.SNcodigoext, a1.esIntercompany, a1.cuentac,
			       a1.SNnombre, a2.CFcomplementoCostoVenta, a2.CFcomplementoIngreso
			from SNegocios a1
				inner join OCcomplementoSNegocio a2
					on a2.SNid = a1.SNid
			where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a1.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Empresa#">
		</cfquery>
		
		<cfif query.recordcount EQ 0 >
			<!--- se inserta el registro en query "qerrores"   --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento","")>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento",#Arguments.TipoDocumento#)>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se encontró el socio de negocios SNegocios")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",#Arguments.Documento#)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		<cfelse>	
			<!--- validar si se puede determinar el tipo de contraparte y el socio de negocio  --->
			<!--- consultar el campo ccuenta de la tabla SNegocios y revisar que contenga los  --->
			<!--- campos correspondientes a Tipo de Contraparte y Socio de Negocios --->
			<cfif Len(query.cuentac) LT 6>
				<!--- se inserta el registro en query "qerrores"   --->
				<cfset QueryAddRow(SESSION.qerrores)>
				<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
				<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
				<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento","")>
				<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento",#Arguments.TipoDocumento#)>
				<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
				<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
				<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se encontró el complemento en Socio Negocios")>
				<cfset QuerySetCell(SESSION.qerrores,"Documento",#Arguments.Documento#)>
				<cfset QuerySetCell(SESSION.qerrores,"Modulo","")>
				<cfset QuerySetCell(SESSION.qerrores,"Monto",0)>
				<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
				<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
				<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
				<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
				<cfset SESSION.HayErrores = true>
			</cfif>
		</cfif>
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Tipo de Contraparte   --->
	<cffunction name="ValidaTipoContraparte" returntype="string">
		<cfargument name="Empresa" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoDocumento" required="Yes" type="string">
	    <cfargument name="SocioId" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			select aa.SNCDdescripcion
			from SNClasificacionD aa, SNClasificacionSN ab
			where ab.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SocioId#">
			  and aa.SNCDid = ab.SNCDid
			  and (aa.SNCDdescripcion='NACIONAL' or aa.SNCDdescripcion='EXTRANJERO')
		</cfquery>

		<cfif query.recordcount EQ 0>
			<!--- se inserta el registro en query "qerrores"   --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento","")>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento",#Arguments.TipoDocumento#)>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio",#Arguments.SocioId#)>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se determinó el Tipo de Contraparte")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",#Arguments.Documento#)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		</cfif>
		<cfreturn query.SNCDdescripcion>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Línea de Negocio y Producto  --->
	<cffunction name="ConsultaLineaProducto" returntype="query">
		<cfargument name="Empresa" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoDocumento" required="Yes" type="string">
		<cfargument name="Producto" required="Yes" type="string">
		<cfset var query = "">
		<cfset var queryArticulo = "">

		<!--- se lee la tabla Articulos, usando el campo Producto  --->
		<cfquery name="queryArticulo" datasource="#Session.Dsn#">
			select a1.Aid
			from Articulos a1
			where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a1.Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Producto#">
		</cfquery>


  	    <cfquery name="queryArticulo" datasource="#Session.Dsn#">
	 		select a1.Aid, a2.CFcomplementoCostoVenta, a2.CFcomplementoIngreso
			from Articulos a1
					inner join OCcomplementoArticulo a2
						on a2.Aid = a1.Aid
			where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a1.Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Producto#">
		</cfquery>


		<cfif queryArticulo.recordcount EQ 0>
			<!--- se inserta el registro en query "qerrores"   --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento","")>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento",#Arguments.TipoDocumento#)>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","#Arguments.Producto#")>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se encontró el registro de Artículos")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",Arguments.Documento)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		</cfif>
		
		<cfreturn queryArticulo>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Tipo de Operación  --->
	<cffunction name="ConsultaTipoOperacion" returntype="query">
		<cfargument name="Empresa" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoDocumento" required="Yes" type="string">
		<cfargument name="Producto" required="Yes" type="string">
		<cfset var query = "">
		<cfset var queryConceptos = "">

		<!--- se lee la tabla OCconceptoCompra, usando el campo Producto  --->
		<cfquery name="queryConceptos" datasource="#Session.Dsn#">
			select *
			from OCconceptoCompra
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfif queryConceptos.recordcount EQ 0 >
			<!--- se inserta el registro en query "qerrores"   --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento","")>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento",#Arguments.TipoDocumento#)>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No se encontró el registro de Artículos")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",#Arguments.Documento#)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = true>
		</cfif>
		
		<cfreturn "#query#">
	</cffunction>  <!--- **** Fin de la Función **** --->
</cfcomponent>