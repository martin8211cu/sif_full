<!---
	Autor: Eduardo Gonzalez Sarabia (Aph)
	Descripcion: Componente para procesar la venta a credito de LDCOM,
	             * Insertar en tablas intermedias, tal cual se pasÃ³ de LDCOM.
	             * Generar el documento de CxC.
 --->


<cfcomponent extends="IntegracionVentas_Base">

	<!--- UNICAMENTE SE HACE EL INSERT EN LAS TABLAS
	      ESIFLD_Facturas_Venta Y DSIFLD_Facturas_Venta
	      (Intermedias)
      --->
	<cffunction name="insertarVenta" access="public" returntype="WResponse">
		<cfargument name="ObjVenta" type="any" required="true">
		<cfargument name="idTransito" type="numeric" required="true">

		<cfobject component="WResponse" name="result">

		<!--- Obtiene el Próximo ID --->
		<cfquery name="rsMaxIDECC" datasource="sifinterfaces">
			SELECT ISNULL(MAX(ID_DocumentoV),0) + 1 AS MaxID
			FROM ESIFLD_Facturas_Venta
		</cfquery>

		<cftransaction>
			<cftry>
				<!--- INSERTA ENCABEZADO --->
				<cfquery name="insertVentasCredEnc" datasource="sifinterfaces">
					INSERT INTO ESIFLD_Facturas_Venta
								(Ecodigo, Origen, ID_DocumentoV, Tipo_Documento, Tipo_Venta, Fecha_Venta, Fecha_Operacion,Fecha_Vencimiento,
								Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento, Impuesto, Total, Redondeo,
								Vendedor, Sucursal, Dias_Credito, Moneda, Tipo_Cambio, Direccion_Fact,
								Retencion, Observaciones, Tipo_CEDI, Estatus, Factura_Cambio, Fecha_Inclusion,
								IEPS, TimbreFiscal,Factura, IdTransito)
					VALUES (<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#ObjVenta.Emp_id#">,
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="LD">,
							<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#rsMaxIDECC.MaxID#">,
							<cfif ObjVenta.Fiscal_Tipo EQ 1>
								'FC',
							<cfelseif ObjVenta.Fiscal_Tipo EQ 2>
								'NC',
							</cfif>
							<cfif ObjVenta.Fiscal_Tipo_Factura EQ 0>
								'P',
							<cfelseif ObjVenta.Fiscal_Tipo_Factura EQ 1>
								'C',
							</cfif>
							<cfqueryparam 	  cfsqltype="cf_sql_date" 	   value="#dateformat(ObjVenta.Fiscal_Fecha,"yyyy-mm-dd")#">,
							<cfqueryparam 	  cfsqltype="cf_sql_timestamp" value="#ObjVenta.Fiscal_Fecha#">,
							<cfqueryparam 	  cfsqltype="cf_sql_timestamp" value="#ObjVenta.Fiscal_Fecha + ObjVenta.Cliente_Plazo#">,
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#ObjVenta.Fiscal_Serie##ObjVenta.Fiscal_NumeroFactura#">,
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#ObjVenta.Cliente_CodigoExterno#">,
							<cfqueryparam 	  cfsqltype="cf_sql_null" 	   value="" null="true">,
							abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(ObjVenta.SubTotal,'9.99')#">),
							abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(ObjVenta.Fiscal_Descuento,'9.99')#">),
							abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(ObjVenta.Fiscal_Impuesto,'9.9999')#">),
							abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(ObjVenta.Fiscal_Total,'9.99')#">),
							0,1,
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#ObjVenta.Suc_Id#">,
							<cfqueryparam 	  cfsqltype="cf_sql_integer"   value="#ObjVenta.Cliente_Plazo#">,
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="1">,
							<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="1">,
							<cfqueryparam 	  cfsqltype="cf_sql_null" 	   value="" null="true">,
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="">,
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="">,
							'S',1,0,
							<cfqueryparam cfsqltype="cf_sql_timestamp"    value="#now()#">,
							abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#ObjVenta.Fiscal_IEPS#">),
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#ObjVenta.Fiscal_UUID#">,
							<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#ObjVenta.Fiscal_Serie##ObjVenta.Fiscal_NumeroFactura#">,
							<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#Arguments.idTransito#">)
				</cfquery>

				<!--- INSERTA DETALLE --->
				<cfset linDetCxC = 1>

				<cfloop array="#ObjVenta.Impuestos#" index="det">
					<cfquery name="insertDetCxC" datasource="sifinterfaces">
						INSERT INTO DSIFLD_Facturas_Venta
							(Ecodigo, ID_DocumentoV, ID_linea, Tipo_Lin, Tipo_Item, Clas_Item,
							 Cod_Impuesto, Cantidad, Total_Lin, Precio_Unitario, Descuento_Lin,
							 Descuento_Fact, Subtotal_Lin, Impuesto_Lin, Costo_Venta, Cod_Fabricante, Cod_Item, codIEPS,
							 MontoIEPS, afectaIVA)
						values
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#ObjVenta.Emp_id#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDECC.MaxID#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#linDetCxC#">,
							 'S',1,0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#det.Porcentaje#">,
							 1,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((det.MontoBase + det.Descuento + det.Monto + det.MontoIEPS),'9.9999')#">),
							 <!--- abs(convert(decimal(19,2),#det.MontoBase#)), --->
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((det.MontoBase + det.Descuento),'9.9999')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(det.Descuento,'9.9999')#">),
							 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((det.MontoBase + det.Descuento),'9.9999')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((det.Monto),'9.9999')#">),
							 0,0,
							 <cfif ObjVenta.Fiscal_Tipo EQ 1>
							 	'VENTA',
							 <cfelseif ObjVenta.Fiscal_Tipo EQ 2>
							 	<!--- NOTA DE CREDITO --->
								<cfif det.Porcentaje GT 0>
								 	'DEVCRED16',
								<cfelse>
									'DEVCRED0',
								</cfif>
							 </cfif>
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#det.CodigoIEPS#">,
							 <!--- Monto Ieps --->
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(det.MontoIEPS,'9.9999')#">),
							 1)
					</cfquery>
					<cfset linDetCxC = linDetCxC + 1>
				</cfloop>


				<!--- VALIDACION DE TOTALES --->
				<!--- Totales por Detalle --->
				<cfquery name="rsGetTotales" datasource="sifinterfaces">
					SELECT a.Total AS TEnc,
					       SUM(d.Total_Lin) AS TLin,
					       CASE
					           WHEN a.Total <> 0 THEN a.Total - SUM(d.Total_Lin)
					           ELSE 0
					       END AS Dif,
					       a.ID_DocumentoV
					FROM ESIFLD_Facturas_Venta a
					INNER JOIN DSIFLD_Facturas_Venta d ON a.ID_DocumentoV = d.ID_DocumentoV
					WHERE a.ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDECC.MaxID#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ObjVenta.Emp_id#">
					GROUP BY a.Total, a.ID_DocumentoV
				</cfquery>

				<!--- UPDATE TOTAL --->
				<cfif rsGetTotales.RecordCount GT 0 AND rsGetTotales.Dif NEQ 0>
					<cfquery name="rsUpdateTotales" datasource="sifinterfaces">
						UPDATE det
						SET det.Subtotal_Lin = (TBL.Subtotal_Lin + #rsGetTotales.Dif#),
						    Total_Lin = (TBL.Subtotal_Lin + #rsGetTotales.Dif#) + TBL.Impuesto_Lin
						FROM DSIFLD_Facturas_Venta det
						INNER JOIN
						  (SELECT TOP 1 Subtotal_Lin,
						              Impuesto_Lin,
						              Total_Lin,
						              Cod_Impuesto
						   FROM DSIFLD_Facturas_Venta
						   WHERE ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDECC.MaxID#">
						     AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ObjVenta.Emp_id#">
						   ORDER BY Cod_Impuesto ASC)TBL ON det.Cod_Impuesto = TBL.Cod_Impuesto
						AND det.ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDECC.MaxID#">
						AND det.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ObjVenta.Emp_id#">
					</cfquery>
				</cfif>

				<cftransaction action="commit" />
				<cfset result.Id = rsMaxIDECC.MaxID>
				<cfset result.Numero_Documento = "#ObjVenta.Fiscal_Serie##ObjVenta.Fiscal_NumeroFactura#">
				<cfset result.Msg = 'Operacion Exitosa'>
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<cflog file="Log_ProcesarVentaCredito_WS" application="no" text="Error al insertar la venta a la tabla ESIFLD_Facturas_Venta, Error: #cfcatch.detail#">
				<cfset result.Id = 0>
				<cfset result.Msg = "Error al insertar la venta a la tabla ESIFLD_Facturas_Venta, Error: #cfcatch.detail#">
				<cfset result.Numero_Documento = "">
			</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn result>
	</cffunction>


	<!--- CONTINUA CON EL PROCESO, PARA GENERAR EL DOCUMENTO EN EL MODULO DE CXC
      --->
	<cffunction name="procesarVenta" access="public">
		<!--- Invocacion del componente --->
		<cfinvoke component="ModuloIntegracion.Componentes.LD_interfaz_CxC_Ventas"
		          method = "Ejecuta"
	    />
	</cffunction>

</cfcomponent>