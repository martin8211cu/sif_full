<!--- ABG: Extraccion de Ventas Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="no">
<cffunction name="Ejecuta" access="public" returntype="string" output="no">
<cfsetting requestTimeout="3600" />
	<!---Invocar al GC para liberar memoria---> <!---ABG--->
	<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
    <cfset javaRT.gc()><!--- invoca el GC --->
  	
  	<!--- ASIGNA FECHAS --->
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdate(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2))>
	</cfif>

	<!--- CREA TABLA TEMPORAL PARA COMPARACIÓN --->
	<cf_dbtemp name="varLocalTempVentaC" returnvariable="varLocalTempVentaC" datasource="sifinterfaces">
		<cf_dbtempcol name="Emp_Id"						type="numeric">
		<cf_dbtempcol name="Suc_Id" 					type="numeric">
		<cf_dbtempcol name="Caja_Id" 					type="numeric">
		<cf_dbtempcol name="Factura_Id" 				type="numeric">
		<cf_dbtempcol name="Fiscal_Id" 					type="numeric">
		<cf_dbtempcol name="TipoDoc_id" 				type="numeric">
		<cf_dbtempcol name="Operacion_Fecha_Apertura" 	type="DATETIME">
		<cf_dbtempcol name="Operacion_Fecha_Cierre" 	type="DATETIME">
	</cf_dbtemp>

	<!--- LEE EXISTENCIA DE REGISTROS EN SIF --->
    <cfquery name="Exist" datasource="sifinterfaces">
		SELECT 	Factura_Id, Suc_Id, Emp_Id, TipoDoc_id, Caja_Id, Fiscal_Id
		FROM 	SIFLD_Bitacora_Proceso bp
		WHERE 	bp.Proceso LIKE 'VENTASCC'
    </cfquery>

    <!--- OBTIENE LAS VENTAS A PROCESAR --->
	<cfquery name="sel" datasource="ldcom" >
		SELECT	DISTINCT v.Empresa as Emp_Id, v.IdSucursal as Suc_Id, v.Caja_Id, v.Ticket_Id as Factura_Id, TipoDoc_id, Id_factura as Fiscal_Id, 
				FechaFactura as Operacion_Fecha_Apertura, FechaFactura as Operacion_Fecha_Cierre
		FROM	INTRFVentaCredito v
			INNER JOIN INTRFCFDIDetalle cfd
				ON	v.Empresa = cfd.Empresa_Id AND v.IdSucursal = cfd.Id_sucursal AND v.Caja_Id = cfd.Caja_Id AND v.ticket_Id = cfd.Ticket_Id
				AND cfd.TipoDoc_id = CASE v.Tipo WHEN 0 THEN  4 WHEN 1 THEN 3 END
		WHERE	1=1
		AND v.Tipo = 0
		AND		CONVERT(CHAR(8), FechaFactura, 112)
		<cfif isdefined("fechaini") and isdefined("fechafin")>
			between 
				CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#fechaini#'>, 112)
			AND
				CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#fechafin#'>, 112)
		<cfelse>
			= CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#now()#'>, 112)
		</cfif>
		--AND		CONVERT(CHAR(8), FechaFactura, 112) > '2014-12-23'
		
		UNION ALL

		SELECT	DISTINCT v.Empresa as Emp_Id, v.IdSucursal as Suc_Id, v.Caja_Id, v.Ticket_Id as Factura_Id, CASE v.Tipo WHEN 0 THEN  4 WHEN 1 THEN 3 END as TipoDoc_id, 
		<!---Id_factura as Fiscal_Id,  --->
		0 as Fiscal_Id,
				FechaFactura as Operacion_Fecha_Apertura, FechaFactura as Operacion_Fecha_Cierre
		FROM	INTRFVentaCredito v
			/* INNER JOIN INTRFCFDIDetalle cfd
				ON	v.Empresa = cfd.Empresa_Id AND v.IdSucursal = cfd.Id_sucursal AND v.Caja_Id = cfd.Caja_Id AND v.ticket_Id = cfd.Ticket_Id
				AND cfd.TipoDoc_id = CASE v.Tipo WHEN 0 THEN  4 WHEN 1 THEN 3 END */
		WHERE	1=1
		AND 	v.Tipo = 1
		AND		CONVERT(CHAR(8), FechaFactura, 112)
		<cfif isdefined("fechaini") and isdefined("fechafin")>
			between 
				CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#fechaini#'>, 112)
			AND
				CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#fechafin#'>, 112)
		<cfelse>
			= CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#now()#'>, 112)
		</cfif> 
		--AND		CONVERT(CHAR(8), FechaFactura, 112) > '2014-12-23'
		

	</cfquery>

	<!--- INSERTA OPERACIONES EN TABLA TEMPORAL PARA COMPARACIÓN --->
	<cfif sel.recordcount GT 0>
		<cfquery datasource="sifinterfaces">
			<cfoutput query="sel">
				INSERT INTO #varLocalTempVentaC# VALUES(#Emp_Id#,#Suc_Id#,#Caja_Id#,#Factura_Id#,#Fiscal_Id#,#TipoDoc_id#,'#Operacion_Fecha_Apertura#','#Operacion_Fecha_Cierre#')
			</cfoutput>
		</cfquery>
	</cfif>

	<!--- TOMA SOLO LAS OPERACIONES NO REGISTRADAS EN SIF --->
	<cfquery name="rsOperacionID" datasource="sifinterfaces">
		SELECT 	DISTINCT Emp_Id, Suc_Id, Caja_Id, TipoDoc_id, Factura_Id, Fiscal_Id, Operacion_Fecha_Apertura, Operacion_Fecha_Cierre
		FROM 	#varLocalTempVentaC# o 
		WHERE  	not exists (SELECT 	1 
						FROM 	SIFLD_Bitacora_Proceso bp 
						WHERE 	o.Emp_Id = bp.Emp_Id 
						AND 	o.Suc_Id = bp.Suc_Id
						AND 	o.Caja_Id = bp.Caja_Id
						AND 	o.TipoDoc_Id = bp.TipoDoc_Id
						AND 	o.Factura_Id = bp.Factura_Id
						AND 	bp.Proceso LIKE 'VENTASCC') 
	</cfquery>
<!--- <cf_dump var=#rsOperacionID#> --->
	<!--- EXTRAE LOS DATOS A PROCESAR ---> 
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
			<cfquery name="rsVentas" datasource="ldcom">
				/************* FC ***********/
				SELECT 
					'LD' as Origen, v.Empresa as Emp_Id, v.IdSucursal as Suc_Id, v.Caja_Id, v.Ticket_Id as Factura_Id,
					CASE Cancelada
						WHEN 0 THEN 4			/*Venta Credito*/
						WHEN 1 THEN 3			/*Folio Cancelación*/
					END AS TipoDoc_Id,
					'' as Subcliente_Id, 0 as Tipo_CEDI,/*sucursal CEDI (1) normal (0)*/
					'' as Vendedor_Id, 30 as Dias_Credito, 0 as Tipo_Articulo_Id, '' as Depto_Id, 0 as Casa_Id, Tipo,
					/*Datos Detalle*/
					CASE Cancelada
						WHEN 0 THEN 'C'			/*Venta Credito*/
						WHEN 1 THEN 'E'			/*Folio Cancelación*/
					END AS Tipo_Venta,
					CASE i.Tipo_Impuesto
						WHEN 'IVA' THEN 1		/* 16% (1)*/
						ELSE 2					/*  0% (2)*/
					END AS Impuesto_Id, 0 as Redondeo, 0 as Factura_Cambio_Efectivo, 0 as Articulo_Id,
					cast(ii.Porc_Impuesto as int) AS IEPS_Id, v.FechaFactura as Factura_Fecha, v.IdCliente as Cliente_Id, cfd.Id_Factura as Fiscal_NumeroFactura, TimbreFiscal as Fiscal_UUID,
					0 as afectaIVA, /*IVA siempre escalonado en LD*/
					/*Montos Detalle*/
					v.Cantidad as Cantidad,
					round(isnull(v.Cantidad * i.Monto_Impuesto,0),4) as Impuesto,
					round(isnull(v.Cantidad * ii.Monto_Impuesto,0),4)as IEPS,
					round((v.Total/v.Cantidad),4)	as Subtotal,
					round((v.Precio/v.Cantidad) - isnull(i.Monto_Impuesto,0),4)	as Precio_Unitario, 
					round(v.Descuento,4)										as Descuento,
					round(v.Cantidad * v.Costo_Unitario,4)			 as Costo_Unitario	
				FROM INTRFVentaCredito v
					OUTER APPLY (select distinct Monto_Impuesto, Tipo_Impuesto from INTRFVentaCredito_Impuesto
						where v.Empresa = Empresa AND v.IdSucursal = IdSucursal AND v.Caja_Id = Caja_Id AND v.Ticket_Id = Ticket_Id AND v.Codigo = Articulo_id AND Tipo_Impuesto = 'IVA') as i
					OUTER APPLY (select distinct Monto_Impuesto, Tipo_Impuesto, Porc_Impuesto from INTRFVentaCredito_Impuesto
						where v.Empresa = Empresa AND v.IdSucursal = IdSucursal AND v.Caja_Id = Caja_Id AND v.Ticket_Id = Ticket_Id AND v.Codigo = Articulo_id AND Tipo_Impuesto = 'IEPS') as ii
					INNER JOIN INTRFCFDIDetalle cfd
						ON	v.Empresa = cfd.Empresa_Id AND v.IdSucursal = cfd.Id_sucursal AND v.Caja_Id = cfd.Caja_Id AND v.ticket_Id = cfd.Ticket_Id AND cfd.TipoDoc_id = 4
					INNER JOIN INTRFCFDI cf
						ON cfd.Empresa_Id = cf.Empresa_Id AND cfd.Id_sucursal = cf.Id_sucursal AND cfd.Id_factura = cf.Id_factura 
				WHERE	1=1
				AND		Tipo = 0
			/*	AND		Cancelada = 0*/
				AND 	v.Empresa = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
				AND 	v.Idsucursal= <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
				AND 	v.Caja_Id 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Caja_Id#">
				AND 	v.ticket_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Factura_Id#">
				AND 	cfd.Id_factura = <cfqueryparam cfsqltype="cf_sql_integer" value="#Fiscal_Id#">

				UNION ALL

				/*************************** NC NO ANULADAS ************************************/
				SELECT
					'LD' as Origen, v.Empresa as Emp_Id, v.IdSucursal as Suc_Id, v.Caja_Id, v.Ticket_Id as Factura_Id, 3 as TipoDoc_Id, '' as Subcliente_Id, 0 as Tipo_CEDI,/*sucursal CEDI (1) normal (0)*/
					'' as Vendedor_Id, 30 as Dias_Credito, 0 as Tipo_Articulo_Id, '' as Depto_Id, 0 as Casa_Id, v.Tipo,
					/*Datos Detalle*/
					'E'	AS Tipo_Venta,			/*Folio Cancelación*/
					CASE i.Tipo_Impuesto
						WHEN 'IVA' THEN 1		/* 16% (1)*/
						ELSE 2					/*  0% (2)*/
					END AS Impuesto_Id, 0 as Redondeo, 0 as Factura_Cambio_Efectivo, 0 as Articulo_Id,
					cast(ii.Porc_Impuesto as int) AS IEPS_Id, v.FechaFactura as Factura_Fecha, v.IdCliente as Cliente_Id,
					/*cfd.Id_Factura as Fiscal_NumeroFactura, */
					/*TimbreFiscal as Fiscal_UUID,*/
					''as Fiscal_UUID, '' as Fiscal_NumeroFactura, 0 as afectaIVA, /*IVA siempre escalonado en LD*/
					/*Montos Detalle*/
					v.Cantidad as Cantidad,
					round(isnull(v.Cantidad * i.Monto_Impuesto,0),4) as Impuesto,
					round(isnull(v.Cantidad * ii.Monto_Impuesto,0),4)as IEPS,
					round((v.Total/v.Cantidad),4)	as Subtotal,
					round((v.Precio/v.Cantidad) - isnull(i.Monto_Impuesto,0),4)as Precio_Unitario, 
					round(v.Descuento,4)										  as Descuento,
					round(v.Cantidad * nc.Costo_Unitario,4)		  as Costo_Unitario	
				FROM INTRFVentaCredito v 
					LEFT JOIN INTRFVentaCredito nc
						ON v.Referencia_Sucursal = nc.IdSucursal AND v.Referencia_Caja = nc.Caja_Id	AND v.Referencia_Ticket = nc.Ticket_Id AND v.Codigo = nc.Codigo
					/* LEFT JOIN INTRFCFDIDetalle cfd
						ON	v.Empresa = cfd.Empresa_Id AND v.IdSucursal = cfd.Id_sucursal AND v.Caja_Id = cfd.Caja_Id AND v.ticket_Id = cfd.Ticket_Id AND cfd.TipoDoc_id = 3
					LEFT JOIN INTRFCFDI cf
						ON cfd.Empresa_Id = cf.Empresa_Id AND cfd.Id_sucursal = cf.Id_sucursal AND cfd.Id_factura = cf.Id_factura */
					OUTER APPLY (select distinct Monto_Impuesto, Tipo_Impuesto from INTRFVentaCredito_Impuesto
						where v.Empresa = Empresa AND v.Referencia_Sucursal = IdSucursal AND v.Referencia_Caja = Caja_Id AND v.Referencia_Ticket = Ticket_Id AND v.Codigo = Articulo_id
						AND Tipo_Impuesto = 'IVA') as i
					OUTER APPLY (select distinct Monto_Impuesto, Tipo_Impuesto, Porc_Impuesto from INTRFVentaCredito_Impuesto
						where v.Empresa = Empresa AND v.Referencia_Sucursal = IdSucursal AND v.Referencia_Caja = Caja_Id AND v.Referencia_Ticket = Ticket_Id AND v.Codigo = Articulo_id
						AND Tipo_Impuesto = 'IEPS') as ii
				WHERE	1=1
				AND		v.Tipo = 1
				AND 	v.Empresa = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
				AND 	v.Idsucursal = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
				AND 	v.Caja_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Caja_Id#">
				AND 	v.ticket_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Factura_Id#">
				<!--- AND 	cfd.Id_factura = <cfqueryparam cfsqltype="cf_sql_integer" value="#Fiscal_Id#"> --->
				/* AND		Cancelada = 0 */
			</cfquery>
		<!--- <cf_dump var=#rsVentas#> --->
		<cftry>

			<!--- SUMARIZA LOS DATOS EXTRAIDOS AGRUPANDOLOS POR DOCUMENTO PARA CREAR LOS ENCABEZADOS --->
			<cfquery name="rsEVentas" dbtype="query">
				SELECT	Origen, Emp_Id, Suc_Id, Factura_Id, Caja_Id, TipoDoc_Id, Tipo_Venta, Factura_Fecha, Cliente_Id, Tipo,
						sum(Subtotal) AS Factura_Subtotal,
						sum(Descuento) as Factura_Descuento, 
						sum(Impuesto) as Factura_Impuesto,
						sum(Subtotal) as Factura_Total,
						sum(Redondeo) as Factura_Redondeo,
						sum(IEPS) as Factura_IEPS,
						Vendedor_Id, Dias_Credito, Tipo_CEDI, Subcliente_Id,
						sum(Factura_Cambio_Efectivo) as Factura_Cambio_Efectivo, 
						Fiscal_NumeroFactura, Fiscal_UUID
				FROM	rsVentas
				WHERE 	Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
				AND 	TipoDoc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#TipoDoc_Id#">
				AND 	Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
				AND 	Caja_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Caja_Id#">
				AND 	Factura_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Factura_Id#">
				GROUP BY	Origen, Emp_Id, Suc_Id, Factura_Id, Caja_Id, TipoDoc_Id, Tipo_Venta, Factura_Fecha, Cliente_Id, Vendedor_Id, Dias_Credito, Tipo_CEDI, 			
							Subcliente_Id,Fiscal_NumeroFactura, Fiscal_UUID, Tipo
			</cfquery>

            <!--- <cf_dump var=#rsEVentas#> --->
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles --->
			<cfif isdefined("rsEVentas") AND rsEVentas.recordcount GT 0>
			<cfloop query="rsEVentas">
            
				<cfquery name="rsEDVentas" dbtype="query">
	                SELECT	Emp_Id, Suc_Id, Caja_Id, Factura_Id, Tipo_Articulo_Id, Depto_Id, Casa_Id, Cantidad, Articulo_Id,
	                   		Impuesto, IEPS, Subtotal as Total, Impuesto_Id, IEPS_Id, Precio_Unitario, Descuento, Costo_Unitario, afectaIVA     		
					FROM	rsVentas
					WHERE 	Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
					AND 	TipoDoc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#TipoDoc_Id#">
					AND 	Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
					AND 	Caja_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Caja_Id#">
					AND 	Factura_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Factura_Id#">
					AND 	Fiscal_NumeroFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#Fiscal_NumeroFactura#">
	            </cfquery>
				<!--- <cf_dump var=#rsEDVentas#> --->

            	<!---BUSCA EQUIVALENCIAS--->
				<!--- EMPRESAS --->
				<cfset Equiv = ConversionEquivalencia(rsEVentas.Origen, 'CADENA', rsEVentas.Emp_Id, rsEVentas.Emp_Id, 'Cadena')/>
				<cfset varEcodigo = Equiv.EQUidSIF/>

				<!--- ID PARA LA TABLA DE ENCABEZADOS --->
				<cfquery name="rsMaxIDE" datasource="sifinterfaces">
					SELECT 	isnull(max(id_documentoV),0) + 1 as MaxID
					FROM 	ESIFLD_Facturas_Venta 
				</cfquery>

				<!--- INSERTA ENCABEZADO --->
				<cfset EncabezadoV = InsertaEncabezadoV(varEcodigo, rsEVentas, rsMaxIDE.MaxID)/>

				<!--- Busca e Inserta los Detalles del Encabezado ---> 
				<cfquery dbtype="query" name="rsDVentas">
            	    SELECT 	Emp_Id, Suc_Id, Caja_Id, Factura_Id, Tipo_Articulo_Id, Depto_Id, Casa_Id, Cantidad, Impuesto, Total, Impuesto_Id, Precio_Unitario, Descuento, Costo_Unitario, IEPS, IEPS_id, 
            	    		afectaIVA
					FROM 	rsEDVentas
					WHERE 	Factura_Id  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Factura_Id#"> 
					AND 	Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
					AND 	Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Suc_Id#">
					AND 	Caja_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Caja_Id#">  
                </cfquery>

				<cfset IDlinea = 1>
				<cfif isdefined("rsDVentas") and rsDVentas.recordcount GT 0>
				<cfloop query="rsDVentas">
                <!--- <cf_dump var=#rsEVentas#> --->
					<!--- INSERTA DETALLES --->
                	<cfset DetallesV = InsertaDetalleV(varEcodigo, rsDVentas, rsMaxIDE.MaxID, Factura_Id, rsEVentas.Fiscal_NumeroFactura)/>

				</cfloop> <!---Detalles Venta--->
				</cfif>
                <cfset rsDVentas = javacast("null","")>
                <cfset javaRT.gc()><!--- invoca el GC --->
                
                
	            <cfquery datasource="ldcom">
					update INTRFVentaCredito set EstatusProceso = 2 
						WHERE Empresa = #Emp_Id#
							and IdSucursal = #Suc_Id#
							and Tipo = #Tipo#
							and Caja_Id = #Caja_Id#
							and Ticket_Id = #Factura_Id#
				</cfquery>
				<cfquery datasource="ldcom">
					update INTRFCFDI set Estatus_proceso = 2 
						WHERE Empresa_Id = #Emp_Id#
							and Id_Sucursal = #Suc_Id#
							and Id_Factura = #Fiscal_NumeroFactura#
				</cfquery>
				<cfquery datasource="sifinterfaces">
					declare @ID int
					select @ID = isnull(max(Proceso_Id),0) + 1
					from SIFLD_Bitacora_Proceso 
					insert SIFLD_Bitacora_Proceso 
						(Proceso_Id, Sistema, Emp_Id, Suc_Id,TipoDoc_Id, Caja_Id, Factura_Id, Proceso, Fecha_Proceso)
					values (@ID, 'LD',
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#TipoDoc_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Caja_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Factura_Id#">,
						'VENTASCC',
						getdate())
				</cfquery>
            </cfloop> <!--- Encabezados Venta--->
			</cfif>
			
			<cfquery datasource="sifinterfaces">
                update ESIFLD_Facturas_Venta
                set Estatus = 1 
                where Estatus = 15
            </cfquery>

            <cfset varProc = true>

			<cfset rsMoneda = javacast("null","")>
            <cfset rsMaxIDE = javacast("null","")>
            <cfset rsEVentas = javacast("null","")>
            <cfset javaRT.gc()><!--- invoca el GC --->

		<cfcatch type="any">
        	<cfquery datasource="sifinterfaces">
                delete DSIFLD_Facturas_Venta
                where ID_DocumentoV in 
                	(select ID_DocumentoV
                    from ESIFLD_Facturas_Venta
                	where Estatus in (15,16))
            </cfquery>
            <cfquery datasource="sifinterfaces">
                delete ESIFLD_Facturas_Venta
                where Estatus in (15,16)
            </cfquery>
	            
            <cfquery datasource="sifinterfaces">
                delete SIFLD_Bitacora_Proceso
                where Factura_Id =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Factura_ID#">
            </cfquery>

			<!--- Busca Errores de SQL y Parametros --->
			<cfif isdefined("cfcatch.sql")>
				<cfset ErrSQL = cfcatch.sql>
			<cfelse>
				<cfset ErrSQL = "">
			</cfif>
			<cfif isdefined("cfcatch.where")>
				<cfset ErrPAR = cfcatch.where>
			<cfelse>
				<cfset ErrPAR = "">
			</cfif>

			<!--- Inserta Log de Error --->
			<cfquery datasource="ldcom">
				update INTRFVentaCredito set EstatusProceso = 3 
					WHERE Empresa in (#rsOperacionID.Emp_Id#)
						and IdSucursal in (#rsOperacionID.Suc_Id#)
						and Tipo in (CASE <cfqueryparam cfsqltype="cf_sql_integer" value="#TipoDoc_Id#"> WHEN 3 THEN 1 WHEN 4 THEN 0 END)
						and Caja_Id in (#rsOperacionID.Caja_Id#)
						and Ticket_Id in (#rsOperacionID.Factura_Id#)
			</cfquery>

			<cfquery datasource="sifinterfaces">
				declare @ID int
				select @ID = isnull(max(Error_Id),0) + 1
				from SIFLD_Log_Errores
				insert SIFLD_Log_Errores
					(Error_Id, Sistema, Empresa, Sucursal, Caja, Bodega,
					Factura, MsgError, Error_Comp, Proceso, Fecha_Proceso)
				values (@ID, 'LD',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Emp_Id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Suc_Id#">,
						<cfif isdefined("ErrCaja")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrCaja#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined("ErrBodega")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrBodega#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined("ErrFactura")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrFactura#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.Message#">,
						'#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#',
						'VENTASCC',
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
			</cfquery>
            <cfset varProc = false>
		</cfcatch>
		</cftry>
        
        </cfloop> <!--- Operacion ID --->
	<cfelse>
        <cfset varProc = false>
	</cfif>
    <cfif varProc>
    	<cfreturn 1>
    <cfelse>
    	<cfreturn 0>
    </cfif>
</cffunction>

	<cffunction name="InsertaEncabezadoV" access="public" output="no">
		<cfargument name="Empresa" 	required="yes" type="numeric">
		<cfargument name="Query" 	required="yes" type="query">
		<cfargument name="ID" 		required="yes" type="numeric">
	
		<!--- OBTIENE LA MONEDA LOCAL --->
		<cfquery name="rsMoneda" datasource="minisif">
			SELECT 	Mcodigo
			FROM 	Empresas
			WHERE 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.Empresa#">
		</cfquery>
	
		<cfif rsMoneda.recordcount EQ 0>
			<cfthrow message="Error al extraer la moneda Local">
		</cfif>
	
		<!--- CREA EL NUMERO DE DOCUMENTO --->
		<cfif (ARGUMENTS.Query.Tipo_Venta EQ "C" OR ARGUMENTS.Query.Tipo_Venta EQ "E") and ARGUMENTS.Query.Tipo_CEDI EQ 0> 
			<cfset Num_Doc = numberformat(rsOperacionID.Suc_Id,"00") &  numberformat(ARGUMENTS.Query.Caja_Id,"00") & numberformat(ARGUMENTS.Query.Factura_Id,"00000000")& "-" & numberformat(ARGUMENTS.Query.Fiscal_NumeroFactura,"0")>
		<cfelse>
			<cfset Num_Doc = ARGUMENTS.Query.Factura_Id>
		</cfif>
	
		<cftransaction action="begin">
			<cftry>
				<!--- INSERTA LOS ENCABEZADOS --->
				<cfquery datasource="sifinterfaces">
					INSERT INTO 	ESIFLD_Facturas_Venta 
						(Ecodigo, Origen, ID_DocumentoV, Tipo_Documento, Tipo_Venta, Fecha_Venta, Fecha_Operacion,
						Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento, Impuesto, Total, Redondeo,
						Vendedor, Sucursal, Dias_Credito, Moneda, Tipo_cambio, Direccion_Fact, Retencion, Observaciones, 
						Tipo_CEDI, Estatus, Factura_Cambio, Fecha_Inclusion, Fiscal_NumeroFactura, Fiscal_UUID, IEPS)
					VALUES 
					 	(<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.Query.Emp_Id#">,
					 	'LD',
					 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.ID#">, 
						CASE 
							WHEN <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.Query.TipoDoc_Id#"> in (1,4,8) then 'FC' 
							WHEN <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.Query.TipoDoc_Id#"> in (3,5) then 'NC' 
						END, 
					 	<cfqueryparam cfsqltype="cf_sql_char" value="#ARGUMENTS.Query.Tipo_Venta#">, 
					 	<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(ARGUMENTS.Query.Factura_Fecha,"yyyy/mm/dd")#">, 
					 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.Query.Factura_Fecha#">,
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">, 
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.Query.Cliente_Id#">,
					 	null,
					 	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.Query.Factura_Subtotal,'9.99')#">), 
					 	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.Query.Factura_Descuento,'9.99')#">), 
					 	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.Query.Factura_Impuesto,'9.9999')#">), 
					 	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.Query.Factura_Total,'9.99')#">),
					 	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.Query.Factura_Redondeo,'9.99')#">),
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.Query.vendedor_Id#">, 
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.Query.Suc_Id#">,
					 	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.Query.dias_credito#">, 
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMoneda.Mcodigo#">,
					 	1, 
					 	null,
					 	'',
					 	'', 
					 	<cfif ARGUMENTS.Query.Tipo_CEDI EQ 1>
							'S',
						<cfelse>
							'N',
					 	</cfif>
					 	<cfif ARGUMENTS.Query.Tipo_Venta EQ 'C' OR ARGUMENTS.Query.Tipo_Venta EQ 'E' OR (ARGUMENTS.Query.Tipo_Venta EQ 'D' AND ARGUMENTS.Query.Tipo_CEDI EQ 1)>
	    			    	15,
	    			    <cfelse>
	    			    	16,
	    			    </cfif>   
					 	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.Query.Factura_Cambio_Efectivo,'9.99')#">),
					 	getdate(),
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.Query.Fiscal_NumeroFactura#">,
						<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#Fiscal_NumeroFacturaGlobal#">,--->
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.Query.Fiscal_UUID#">,
					 	abs(<cfqueryparam cfsqltype="cf_sql_money"   value="#ARGUMENTS.Query.Factura_IEPS#">))
				</cfquery>
				<cftransaction action="commit" />
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<!--- VARIABLES DE ERROR --->
				<cfset ErrCaja = Arguments.Query.Caja_Id>
				<cfset ErrFactura = Arguments.Query.Factura_Id>
				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
				<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
			</cfcatch>
			</cftry>
		</cftransaction>
	</cffunction>

	<cffunction name="InsertaDetalleV" access="public" output="no">
		<cfargument name="Empresa" 		required="yes" type="numeric">
		<cfargument name="QueryD" 		required="yes" type="query">
		<cfargument name="ID" 			required="yes" type="numeric">
		<cfargument name="Factura_ID" 	required="yes" type="numeric">
		<cfargument name="Fiscal_ID" 	required="yes" type="numeric">

		<cftransaction>
			<cftry>
				<cfquery datasource="sifinterfaces">
					INSERT INTO DSIFLD_Facturas_Venta 
						(Ecodigo, ID_DocumentoV, Id_linea, tipo_lin, tipo_item, clas_item, cod_impuesto, cantidad, total_lin, precio_unitario, descuento_lin,
						  descuento_fact, subtotal_lin, impuesto_lin, costo_venta, cod_fabricante, cod_item, codIEPS, MontoIEPS, afectaIVA) 
					VALUES
					(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Empresa#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.ID#">, 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
					 'S',
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.QueryD.Depto_Id#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.QueryD.Tipo_Articulo_Id#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.QueryD.Impuesto_Id#">, 
					 <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.QueryD.Cantidad#">, 
					 abs(convert(decimal(19,2),#ARGUMENTS.QueryD.Total#)),
					 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.QueryD.Precio_Unitario,'9.99')#">),
					 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.QueryD.cantidad * ARGUMENTS.QueryD.Descuento,'9.99')#">),
					 0,
					 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.QueryD.cantidad * ARGUMENTS.QueryD.precio_unitario,'9.99')#">),
					 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.QueryD.impuesto,'9.9999')#">),
					 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ARGUMENTS.QueryD.cantidad * ARGUMENTS.QueryD.costo_unitario,'9.99')#">),
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.QueryD.casa_Id#">,
					 'VENTA',
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.QueryD.IEPS_Id#">,
					 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#ARGUMENTS.QueryD.IEPS#">),
					 <cfqueryparam cfsqltype="cf_sql_char" value="#ARGUMENTS.QueryD.afectaIVA#">)
				</cfquery>
				<cfset IDlinea = IDlinea + 1>
				<cftransaction action="commit" />
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<!--- Borra los registros para el Encabezado que se habia Insertado--->
				<cfquery datasource="sifinterfaces">
					delete DSIFLD_Facturas_Venta
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empresa#">
						and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.ID#">
					delete ESIFLD_Facturas_Venta
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.Empresa#">
						and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.ID#">
					delete SIFLD_Bitacora_Proceso
							where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.Empresa#">
							and Factura_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.Factura_ID#">
							and Fiscal_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.Fiscal_ID#">
				</cfquery>
				<!--- Variables de Error --->
				<cfset ErrCaja = rsEVentas.Caja_Id>
				<cfset ErrFactura = rsEVentas.Factura_Id>
				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
				<cfthrow message="Error Insertando Detalle de Venta: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
			</cfcatch>
			</cftry>
		</cftransaction>
	</cffunction>
</cfcomponent>