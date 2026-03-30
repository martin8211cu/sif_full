<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(false)>
<!--- 
	Interfaces desde SOIN hacia Dos Pinos.
	Interfaz 102 : "Registro de Transacciones de Compra"
	Entradas :
		ID : ID del Proceso a crear.
		EDIid : PK de EDocumentosI.
		MODO : Acción a realizar.
	Salidas :
		1 Registro en la Tabla OE102 : Datos del Encabezado de la Transacción (EDIid).
		N Registros en la Tabla OD102 : Datos de las líneas de detalle de la Transacción (EDIid).
	Creada : 01 de Noviembre del 2004
--->

<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(102, url.ID)>

<!--- Parámetros Requeridos --->
<cfparam name="url.ID" type="numeric">
<cfparam name="url.EDIid" type="numeric">
<cfparam name="url.MODO" type="string">

<!--- Valida que no exista un encabezado con el mismo ID en la tabla OE102 que el parámetro de entrada --->
<cfquery name="rsid_vexists" datasource="sifinterfaces">
	select 1 from OE102 where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
</cfquery>
<cfif rsid_vexists.Recordcount GT 0>
	<!--- (Intento de Reprocesar) --->
	<cfthrow message="Error en interfaz Dos Pinos 102, Registro de Transacciones de Mercadería, EL proceso ya fue ejecutado anteriormente, Proceso Cancelado!">
</cfif>

<!--- Valida que el modo sea R o C --->
<cfif Not (url.MODO EQ 'R')>
	<cfthrow message="Error en interfaz Dos Pinos 102, Registro de Transacciones de Mercadería, Modo inválido, Proceso Cancelado!">
</cfif>

<!--- Obtiene el encabezado del documento y verifica que exista --->
<cfquery name="rsEncabezadoDocumento" datasource="#session.dsn#">
	select edi.EDIid, edi.Ddocumento, edi.EDIfecha, sn.SNnumero, m.Miso4217,
		   edi.EDItc, edi.EDobservaciones, epd.EPDnumero, ediref.Ddocumento as DdocumentoRef,
		   ediref.EDItc as EDItcRef, edi.EDItipo
	from EDocumentosI edi
		inner join SNegocios sn
			on sn.SNcodigo = edi.SNcodigo
			and sn.Ecodigo = edi.Ecodigo
		inner join Monedas m
			on m.Mcodigo = edi.Mcodigo
			and m.Ecodigo = edi.Ecodigo
		left outer join EPolizaDesalmacenaje epd
			on epd.EPDid = edi.EPDid
			and epd.Ecodigo = edi.Ecodigo
		left outer join EDocumentosI ediref
			on ediref.EDIid = edi.EDIidRef
			and ediref.Ecodigo = edi.Ecodigo
	where edi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDIid#">
		and edi.EDIestado = 10
</cfquery>

<cfif rsEncabezadoDocumento.Recordcount eq 0>
	<!--- (Error de datos en la Cola) --->
	<cfthrow message="Error en interfaz Dos Pinos 102, Registro de Transacciones de Mercadería, Código de Transacción (#url.EDIid#) no está definido, Proceso Cancelado!">
</cfif>

<!--- Obtiene los detalles del documento y verifica que exista por lo menos 1 --->
<cfquery name="rsDetallesDocumento" datasource="#session.dsn#">
	select ddi.DDlinea, ddi.DDIconsecutivo, ddi.DDItipo,
		   case when do.Aid is not null then art.Acodigo
			    when ddi.Cid is not null then con.Ccodigo
				when do.ACcodigo is not null then 'Activo'
			    else ''
		   end as CodigoItem,
		   ddi.DDIcantidad, 
		   #LvarOBJ_PrecioU.enSQL_AS("coalesce(do.DOpreciou, 0.00)", "DOpreciou")#, 
		   ddi.Ucodigo, ddi.Icodigo, alm.Almcodigo,
		   es.ESnumero, ds.DSconsecutivo, eo.EOnumero, do.DOconsecutivo, ddi.DDIafecta,
		   eo.NAP, cpnapd.CPNAPDmonto, eo.EOplazo, do.DOcantidad, do.Ucodigo as UcodigoOC, cfoc.CFformato as CFformatoOC,
		   case when (do.DOcantidad - do.DOcantsurtida) > (ddi.DDIcantidad * coalesce(coalesce(cu.CUfactor, cua.CUAfactor), 1)) then do.DOcantidad - do.DOcantsurtida - (ddi.DDIcantidad * coalesce(coalesce(cu.CUfactor, cua.CUAfactor), 1))
			    else 0.00
		   end as CantidadReclamada,
		   #LvarOBJ_PrecioU.enSQL_AS("ddi.DDIpreciou")#, 
		   coalesce(do.DOporcdesc, 0.00) as DOporcdesc,
		   coalesce(ddi.DDIporcdesc, 0.00) as DDIporcdesc,
		   case when do.Aid is not null and clas.Ctolerancia is not null then
					case when (ddi.DDIcantidad * coalesce(coalesce(cu.CUfactor, cua.CUAfactor), 1)) > do.DOcantidad - do.DOcantsurtida + (do.DOcantidad * coalesce(clas.Ctolerancia, 0) / 100) then
							  (ddi.DDIcantidad * coalesce(coalesce(cu.CUfactor, cua.CUAfactor), 1)) - (do.DOcantidad - do.DOcantsurtida + (do.DOcantidad * coalesce(clas.Ctolerancia, 0) / 100))
						 else 0.00
					end
				else 0.00
		   end as CantidadExcedida,
		   case when cu.CUfactor is not null then cu.CUfactor
		   		when cua.CUAfactor is not null then cua.CUAfactor
				else 1
		   end as CUfactor
	from DDocumentosI ddi

		left outer join DOrdenCM do
			on do.DOlinea = ddi.DOlinea
			and do.Ecodigo = ddi.Ecodigo
			
			left outer join ConversionUnidades cu
				on cu.Ecodigo = do.Ecodigo
				and cu.Ucodigo = ddi.Ucodigo
				and cu.Ucodigoref = do.Ucodigo
			
			left outer join EOrdenCM eo
				on eo.EOidorden = do.EOidorden
				and eo.Ecodigo = do.Ecodigo
				
				left outer join CPNAPdetalle cpnapd
					on cpnapd.CPNAPnum = eo.NAP
					and cpnapd.CPNAPDlinea = do.DOconsecutivo
					and cpnapd.Ecodigo = eo.Ecodigo
				
			left outer join DSolicitudCompraCM ds
				on ds.DSlinea = do.DSlinea
				
				left outer join ESolicitudCompraCM es
					on es.ESidsolicitud = ds.ESidsolicitud
				
			left outer join Articulos art
				on art.Aid = do.Aid
				and art.Ecodigo = do.Ecodigo

			left outer join Clasificaciones clas
				on clas.Ccodigo = art.Ccodigo
				and clas.Ecodigo = do.Ecodigo

				left outer join ConversionUnidadesArt cua
					on cua.Aid = do.Aid
					and art.Ucodigo = ddi.Ucodigo
					and cua.Ucodigo = do.Ucodigo
					and cua.Ecodigo = do.Ecodigo
				
			left outer join Almacen alm
				on alm.Aid = do.Alm_Aid
					
			left outer join CFinanciera cfoc
				on cfoc.CFcuenta = do.CFcuenta
				and cfoc.Ecodigo = do.Ecodigo
				
		left outer join Conceptos con
			on con.Cid = ddi.Cid
			and con.Ecodigo = ddi.Ecodigo

	where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDIid#">
	order by ddi.DDIconsecutivo
</cfquery>

<cfif rsDetallesDocumento.RecordCount eq 0>
	<cfthrow message="No se encontraron detalles asociados al documento">
</cfif>

<cftransaction>
	<cfset LobjInterfaz.sbReportarActividad(102, url.ID)>
	<cfquery datasource="sifinterfaces">
		insert into OE102
			(ID, NumeroDocTransaccion, FechaTransaccion,
			FechaDocumento, CodigoProveedor, TipoDocumentoCXP,
			CodigoMoneda, TipoCambio, DescuentoDoc, 
			ImpuestoDoc, Observaciones, NumeroPolizaDes, Modo, 
			LoginUsuario, BMUsucodigo, NumeroDocRef, TipoCambioRegistro)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezadoDocumento.Ddocumento#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#rsEncabezadoDocumento.EDIfecha#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#rsEncabezadoDocumento.EDIfecha#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezadoDocumento.SNnumero#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezadoDocumento.EDItipo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezadoDocumento.Miso4217#">,  
			<cfqueryparam cfsqltype="cf_sql_money" value="#rsEncabezadoDocumento.EDItc#">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezadoDocumento.EDobservaciones#" null="#len(trim(rsEncabezadoDocumento.EDobservaciones)) eq 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezadoDocumento.EPDnumero#" null="#len(trim(rsEncabezadoDocumento.EPDnumero)) eq 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#url.MODO#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezadoDocumento.DdocumentoRef#" null="#len(trim(rsEncabezadoDocumento.DdocumentoRef)) eq 0#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#rsEncabezadoDocumento.EDItcRef#" null="#len(trim(rsEncabezadoDocumento.EDItcRef)) eq 0#">
		)
	</cfquery>
	
	<cfloop query="rsDetallesDocumento">
		<cfif rsDetallesDocumento.DDIafecta eq 3 and len(trim(rsDetallesDocumento.CUfactor)) eq 0>
			<cfthrow message="No se encontró la unidad de conversión de la unidad #rsDetallesDocumento.Ucodigo# de la factura a la unidad #rsDetallesDocumento.UcodigoOC# de la orden">
		</cfif>

		<cfset LobjInterfaz.sbReportarActividad(102, url.ID)>
		<cfquery name="rsInsertDetalle" datasource="sifinterfaces">
			insert into OD102
				(ID, LineaDocTransaccion, SecDistribucionLinea, TipoItem, CodigoItem, Cantidad, PrecioUnitario,
				 CodigoUnidadMedida, CodigoImpuesto, CodigoAlmacen, NumeroSolicitudCompra,
				 LineaSolcitudCompra, NumeroOrdenCompra, LineaOrdenCompra, NAP_OC,
				 MontoLineaNAP_OC, Plazo_OC, Cantidad_OC, CodigoUnidadMedida_OC,
				 CuentaFinanciera_OC, PorcentajeImpuesto, PorcentajeImpuestoRecuperable,
				 CantidadReclamada, PrecioFactura, PorcentajeDescuento_OC,
				 PorcentajeDescuento_Doc, CantidadExcedida, BMUsucodigo
				)
			values (
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetallesDocumento.DDIconsecutivo#">,
				 1,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetallesDocumento.DDItipo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetallesDocumento.CodigoItem#">,
				 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDetallesDocumento.DDIcantidad#">,
				 #LvarOBJ_PrecioU.enCF(rsDetallesDocumento.DOpreciou)#,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetallesDocumento.Ucodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetallesDocumento.Icodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetallesDocumento.Almcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetallesDocumento.ESnumero#" null="#len(trim(rsDetallesDocumento.ESnumero)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetallesDocumento.DSconsecutivo#" null="#len(trim(rsDetallesDocumento.DSconsecutivo)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetallesDocumento.EOnumero#" null="#len(trim(rsDetallesDocumento.EOnumero)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetallesDocumento.DOconsecutivo#" null="#len(trim(rsDetallesDocumento.DOconsecutivo)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetallesDocumento.NAP#" null="#len(trim(rsDetallesDocumento.NAP)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetallesDocumento.CPNAPDmonto#" null="#len(trim(rsDetallesDocumento.CPNAPDmonto)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetallesDocumento.EOplazo#"  null="#len(trim(rsDetallesDocumento.EOplazo)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDetallesDocumento.DOcantidad#" null="#len(trim(rsDetallesDocumento.DOcantidad)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetallesDocumento.UcodigoOC#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetallesDocumento.CFformatoOC#">,
				 0.00,<!---impuesto--->
				 0.00,<!---impuesto recuperable--->
				 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDetallesDocumento.CantidadReclamada#" null="#len(trim(rsDetallesDocumento.CantidadReclamada)) eq 0#">,
				 #LvarOBJ_PrecioU.enCF(rsDetallesDocumento.DDIpreciou)#,
				 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDetallesDocumento.DOporcdesc#" null="#len(trim(rsDetallesDocumento.DOporcdesc)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDetallesDocumento.DDIporcdesc#">,
				 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDetallesDocumento.CantidadExcedida#" null="#len(trim(rsDetallesDocumento.CantidadExcedida)) eq 0#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			 )
		</cfquery>
		
		<cftransaction action="commit">
		
		<cfquery name="rsDistribucionDetalle" datasource="#session.dsn#">
			select dt.DTid,
				   case when do.Aid is not null then art.Acodigo
						when do.Cid is not null then con.Ccodigo
						when do.ACcodigo is not null then 'Activo'
						else ''
				   end as CodigoItem,
				   alm.Almcodigo, es.ESnumero, ds.DSconsecutivo, eo.EOnumero, do.DOconsecutivo,
				   cfoc.CFformato as CFformatoOC, cc.Cformato, dt.DTmonto,
				   cmii.CMImonto, case when dt.TipoMovimiento = 6 then 1 else 0 end as CreditoFiscal,
				   cmii.Icodigo
	
			from CMDetalleTransito dt
			
				inner join DOrdenCM do
					on do.DOlinea = dt.DOlinea
	
					left outer join DSolicitudCompraCM ds
						on ds.DSlinea = do.DSlinea
						
						left outer join ESolicitudCompraCM es
							on es.ESidsolicitud = ds.ESidsolicitud
	
					left outer join Articulos art
						on art.Aid = do.Aid
						
					left outer join Almacen alm
						on alm.Aid = do.Alm_Aid
					
					left outer join Conceptos con
						on con.Cid = do.Cid

					left outer join CFinanciera cfoc
						on cfoc.CFcuenta = do.CFcuenta
				
				inner join EOrdenCM eo
					on eo.EOidorden = dt.EOidorden
					
				inner join CContables cc
					on cc.Ccuenta = dt.CTcuenta
					
				left outer join DDocumentosI ddi
					on ddi.DDlinea = dt.DDlinea
					
					left outer join CMImpuestosItem cmii
						on cmii.Icodigo = ddi.Icodigo
						and cmii.DPDlinea = dt.DPDlinea
						and cmii.Ecodigo = dt.Ecodigo
						and cmii.EPDid = dt.EPDid
						and cmii.DDlinea = dt.DDlinea

			where dt.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetallesDocumento.DDlinea#">
			order by dt.DTid
		</cfquery>

		<cftransaction action="commit">
		
		<cfset numeroDistribucion = 2>
		<cfset DDIconsecutivoDetalle = rsDetallesDocumento.DDIconsecutivo>
		<cfset DDItipoDetalle = rsDetallesDocumento.DDItipo>
		
		<cfloop query="rsDistribucionDetalle">

			<cfset LobjInterfaz.sbReportarActividad(102, url.ID)>
			<cfquery name="rsInsertDistribucion" datasource="sifinterfaces">
				insert into OD102
					(ID, LineaDocTransaccion, SecDistribucionLinea, TipoItem, CodigoItem, Cantidad, PrecioUnitario,
					 CodigoAlmacen, NumeroSolicitudCompra, LineaSolcitudCompra, NumeroOrdenCompra, LineaOrdenCompra,
					 CuentaFinanciera_OC, CuentaFinanciera_Transito, MontoDistribuido, BMUsucodigo,
					 PorcentajeImpuesto, PorcentajeImpuestoRecuperable, CodigoImpuesto
					)
				values (
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#DDIconsecutivoDetalle#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#numeroDistribucion#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#DDItipoDetalle#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDistribucionDetalle.CodigoItem#">,
					 0.00, 0.00,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDistribucionDetalle.Almcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionDetalle.ESnumero#" null="#len(trim(rsDistribucionDetalle.ESnumero)) eq 0#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDistribucionDetalle.DSconsecutivo#" null="#len(trim(rsDistribucionDetalle.DSconsecutivo)) eq 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionDetalle.EOnumero#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDistribucionDetalle.DOconsecutivo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDistribucionDetalle.CFformatoOC#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDistribucionDetalle.Cformato#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#rsDistribucionDetalle.DTmonto#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfif rsDistribucionDetalle.CreditoFiscal eq 0>
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDistribucionDetalle.CMImonto#" null="#len(trim(rsDistribucionDetalle.CMImonto)) eq 0#">,
					 0.00,
					 <cfelse>
					 0.00,
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDistribucionDetalle.CMImonto#" null="#len(trim(rsDistribucionDetalle.CMImonto)) eq 0#">,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDistribucionDetalle.Icodigo#">
					)
			</cfquery>
			<cfset numeroDistribucion = numeroDistribucion + 1>
		</cfloop>
	</cfloop>
	<cfset LobjInterfaz.sbReportarActividad(102, url.ID)>
</cftransaction>
