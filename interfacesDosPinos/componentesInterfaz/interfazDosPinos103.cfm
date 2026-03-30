<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(false)>
<!--- 
	Interfaces desde SOIN hacia Dos Pinos.
	Interfaz 103 : "Registro de Devoluciones de Compra"
	Entradas :
		ID : ID del Proceso a crear.
		EDRid : PK de EDocumentosDevolucion.
		MODO : Acción a realizar.
	Salidas :
		1 Registro en la Tabla OE103 : Datos del Encabezado de la Devolución (EDRid).
		N Registros en la Tabla OD103 : Datos de las líneas de detalle de la Devolución (EDRid).
	Creada : 04 de Noviembre del 2004
--->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(103, url.ID)>
<!--- Parámetros Requeridos --->
<cfparam name="url.ID" type="numeric">
<cfparam name="url.EDRid" type="numeric">
<cfparam name="url.MODO" type="string">
<!--- Valida Parámetros de entrada --->
<cfquery name="rsid_vexists" datasource="sifinterfaces">
	select 1 from OE103 where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
</cfquery>
<cfif rsid_vexists.Recordcount GT 0>
	<!--- (Intento de Reprocesar) --->
	<cfthrow message="Error en interfaz Dos Pinos 103, Registro de Devoluciones de Mercadería, EL proceso ya fué ejecutado anteriormente, Proceso Cancelado!">
</cfif>
<cfquery name="rsedr_vexists" datasource="#Session.Dsn#">
	select 1 from EDocumentosRecepcion
	where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDRid#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and EDRestado = 10 <!--- Solo si ya fue aplicada --->
</cfquery>
<cfif rsedr_vexists.Recordcount EQ 0>
	<!--- (Error de datos en la Cola) --->
	<cfthrow message="Error en interfaz Dos Pinos 103, Registro de Devoluciones de Mercadería, Código de Devolución no está definido, Proceso Cancelado!">
</cfif>
<cfif not url.MODO EQ 'R'>
	<cfthrow message="Error en interfaz Dos Pinos 103, Registro de Devoluciones de Mercadería, Modo inválido, Proceso Cancelado!">
</cfif>
<!--- Entrada --->
<cfquery name="rs" datasource="#Session.Dsn#">
	SELECT a.EDRid, a.Ecodigo, a.TDRcodigo, a.Mcodigo, a.EDRtc, a.Aid as Alm_Aid, a.CFid, a.CPTcodigo, a.EPDid, a.EDRnumero,
		a.EDRfechadoc, a.EDRfecharec, a.EOidorden, a.SNcodigo, a.EDRreferencia, a.EDRdescpro, a.EDRimppro, a.EDRobs, 
		b.DDRlinea, b.Ucodigo, b.DOlinea, b.Aid, b.Cid, b.DDRtipoitem, b.DDRcantrec, b.DDRcantordenconv, b.DDRcantorigen, b.DDRcantreclamo, 
		#LvarOBJ_PrecioU.enSQL_AS("b.DDRpreciou")#, 
		#LvarOBJ_PrecioU.enSQL_AS("b.DDRprecioorig")#, 
		b.DDRdesclinea, b.DDRtotallin, b.DDRcostopro, b.DDRcostototal, b.DDRobsreclamo, b.DDRgenreclamo,
		c.SNnumero, d.Miso4217, e.EOplazo, f.Icodigo as Icodigo_OC, f.DOconsecutivo as DOconsecutivo_OC, f.ETidtracking as ETidtracking_OC, 
		coalesce(f.DOcantidad,0.00) as DOcantidad_OC, f.Ucodigo as Ucodigo_OC, null as ETnumtracking_OC, g.EOnumero, 
		g.EOplazo as EOplazo_det, g.NAP, h.EPDnumero, i.Almcodigo, j.Acodigo, k.Ccodigo, l.ESnumero, m.DSconsecutivo, n.CFformato, 
		coalesce(o.CPNAPDmonto,0.00) as CPNAPDmonto, coalesce(p.Iporcentaje,0.00) as Iporcentaje, 
		coalesce(q.Iporcentaje,0.00) as IporcentajeRecuperable, q.Icompuesto as IcompuestoRecuperable
	FROM EDocumentosRecepcion a 
		inner join DDocumentosRecepcion b <!--- Si no hay detalles no traería nada, esto es correcto porque no debería nisiquiera estar aplicada --->
			inner join DOrdenCM f <!--- No acepa nulos --->
				inner join EOrdenCM g on g.EOidorden = f.EOidorden and g.Ecodigo = f.Ecodigo <!--- No acepa nulos --->
				left outer join Almacen i on i.Aid = f.Alm_Aid and i.Ecodigo = f.Ecodigo
				left outer join ESolicitudCompraCM l on l.ESidsolicitud = f.ESidsolicitud and l.Ecodigo = f.Ecodigo
				left outer join DSolicitudCompraCM m on m.DSlinea = f.DSlinea and m.Ecodigo = f.Ecodigo
				left outer join CFinanciera n on n.CFcuenta = f.CFcuenta and n.Ecodigo = f.Ecodigo
				left outer join CPNAPdetalle o on o.CPNAPnum = g.NAP and o.CPNAPDlinea = f.DOconsecutivo
				left outer join Impuestos p on p.Icodigo = f.Icodigo and p.Ecodigo = f.Ecodigo
				left outer join Impuestos q on q.Icodigo = f.Icodigo and q.Ecodigo = f.Ecodigo
					and q.Icreditofiscal = 1 and q.Icompuesto = 0
				on f.DOlinea = b.DOlinea and f.Ecodigo = b.Ecodigo 
			left outer join Articulos j on j.Aid = b.Aid and j.Ecodigo = b.Ecodigo
			left outer join Conceptos k on k.Cid = b.Cid and k.Ecodigo = b.Ecodigo
			on b.EDRid = a.EDRid and b.Ecodigo = a.Ecodigo 
		inner join SNegocios c on c.SNcodigo = a.SNcodigo and c.Ecodigo = a.Ecodigo <!--- No acepa nulos --->
		inner join Monedas d on d.Mcodigo = a.Mcodigo and d.Ecodigo = a.Ecodigo <!--- No acepa nulos --->
		left outer join EOrdenCM e on e.EOidorden = a.EOidorden and e.Ecodigo = a.Ecodigo
		left outer join EPolizaDesalmacenaje h on h.EPDid = a.EPDid and h.Ecodigo = a.Ecodigo
	WHERE a.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDRid#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.EDRestado = 10 <!--- Solo si ya fue aplicada --->
</cfquery>
<cfoutput query="rs">
	<cfset LobjInterfaz.sbReportarActividad(103, url.ID)>
	<cfif len(trim(rs.ETidtracking_OC)) GT 0>
		<cfquery name="rsTracking" datasource="sifpublica">
			select ETnumtracking from ETracking where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.ETidtracking_OC#">
		</cfquery>
		<cfif rsTracking.recordcount GT 0>
			<cfset QuerySetCell(rs, "ETnumtracking_OC", rsTracking.ETnumtracking, rs.CurrentRow)>
		</cfif>
	</cfif>
	<cfif rs.IcompuestoRecuperable GT 0>
		<cfquery name="rsImpuesto" datasource="sifpublica">
			select coalesce(sum(DIporcentaje),0.00) as Iporcentaje
			from DImpuestos
			where DIcreditofiscal = 1
			  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rs.Icodigo_OC#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rsImpuesto.recordcount gt 0>
			<cfset QuerySetCell(rs, "IporcentajeRecuperable", rsImpuesto.Iporcentaje, rs.CurrentRow)>
		</cfif>
	</cfif>
</cfoutput>
<cfset LobjInterfaz.sbReportarActividad(103, url.ID)>
<!--- Valida el Query --->
<cfquery name="rsVCount" datasource="#Session.Dsn#">
	select count(1) as cont from DDocumentosRecepcion
	WHERE EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDRid#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfif rsVCount.Cont NEQ rs.RecordCount>
	<cfthrow message="Error en interfaz Dos Pinos 103, Registro de Devoluciones de Mercadería, Datos de Entrada Inválidos, Proceso Cancelado!">
</cfif>
<!--- Convertir unidades si cambiaron, deben quedar en la unidad de medida de la OC --->
<!--- Salida --->
<cftransaction>
	<cfoutput query="rs" group="EDRid"><!--- Para el EDRid --->
		<cfset LobjInterfaz.sbReportarActividad(103, url.ID)>
		<cfquery datasource="sifinterfaces">
			insert into OE103 
				(ID, NumeroDocDevolucion, FechaDevolucion, 
				FechaDocumento, CodigoProveedor, TipoDocumentoCXP, 
				CodigoMoneda, TipoCambio, DescuentoDoc, 
				ImpuestoDoc, Observaciones, PlazoOC, 
				NumeroEmbarque, NumeroPolizaDes, Modo, 
				LoginUsuario,
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.EDRnumero#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rs.EDRfecharec#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rs.EDRfecharec#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.SNnumero#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.CPTcodigo#" null="#len(trim(rs.CPTcodigo)) EQ 0#">,  
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Miso4217#">,  
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.EDRtc#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.EDRdescpro#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.EDRimppro#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.EDRobs#" null="#len(trim(rs.EDRobs)) EQ 0#">,  
				<cfif len(trim(rs.EOplazo)) NEQ 0>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rs.EOplazo#">,  <!--- Debe validarse que todas las líneas de detalle tengan la misma Orden de Compra , sino debe actualizarse en nulo --->
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.EPDnumero#" null="#len(trim(rs.EPDnumero)) EQ 0#">,  
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.ETnumtracking_OC#" null="#len(trim(rs.ETnumtracking_OC)) EQ 0#">,  
				<cfqueryparam cfsqltype="cf_sql_char" value="#url.MODO#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usulogin#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>
		<cfoutput><!--- Para cada una de las DDRlinea --->
			<cfset LobjInterfaz.sbReportarActividad(103, url.ID)>
			<cfquery datasource="sifinterfaces">
				insert into OD103 
				(ID, LineaDocDevolucion, TipoItem, CodigoAlmacen, CodigoItem, CantidadDevuelta, CodigoUnidadMedida, 
				PrecioUnitario, CodigoImpuesto, NumeroSolicitudCompra, LineaSolcitudCompra, NumeroOrdenCompra, LineaOrdenCompra, 
				NAP_OC, MontoLineaNAP_OC, Plazo_OC, Cantidad_OC, CodigoUnidadMedida_OC, CuentaFinanciera_OC, PorcentajeImpuesto, 
				PorcentajeImpuestoRecuperable, BMUsucodigo)
				values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.currentrow#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.DDRtipoitem#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Almcodigo#" null="#len(trim(rs.Almcodigo)) EQ 0#">,
				<cfif rs.DDRtipoitem EQ 'A'>
					<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Acodigo#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Ccodigo#">, 
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DDRcantordenconv#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Ucodigo_OC#">, 
				#LvarOBJ_PrecioU.enCF(rs.DDRtotallin)#, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Icodigo_OC#">, 
				<cfif len(trim(rs.ESnumero)) NEQ 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.ESnumero#">, 
				<cfelse>
					null,
				</cfif>
				<cfif len(trim(rs.DSconsecutivo)) NEQ 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.DSconsecutivo#">, 
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.EOnumero#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.DOconsecutivo_OC#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.NAP#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.CPNAPDmonto#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rs.EOplazo_det#">,  
				<cfqueryparam cfsqltype="cf_sql_money" value="#rs.DOcantidad_OC#">, <!--- Obtener el convertido a la OC --->
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Ucodigo_OC#">,  <!--- Obtener el convertido a la OC --->
				<cfqueryparam cfsqltype="cf_sql_char" value="#rs.CFformato#" null="#len(trim(rs.CFformato)) EQ 0#">, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#rs.Iporcentaje#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#rs.IporcentajeRecuperable#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
			</cfquery>
		</cfoutput>
	</cfoutput>
	<cfset LobjInterfaz.sbReportarActividad(103, url.ID)>
</cftransaction>