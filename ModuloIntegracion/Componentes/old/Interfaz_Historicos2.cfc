<!--- ABG: Procedimiento para Historicas Modulo Integracion Jueves 8 Julio 2010--->
<!--- La Interfaz solo funciona con versiones de Coldfusion 8.0 en adelante --->

<cffunction name="Ejecuta" access="public" returntype="string" output="no">
<!--- El proceso para pasar a historicas es:
	- Se mandan los registros ya procesados o anulados a tablas temporales
	- Se generan los IDs historicos auxiliandonos de la tabla SIFLD_Historico_ID
	- Se copian los registros de la tabla temporal a las tablas historicas
	- Se eliminan los registros de las tablas de trabajo --->
<!---		<cftry>--->
        	
            <!--- Se crean las tablas temporales para el paso  1 --->
            <cf_dbtemp name="EVentas" returnvariable="EVentas" datasource="sifinterfaces">
            	<cf_dbtempcol name="ID_DocumentoV" type="int">
                <cf_dbtempcol name="ID_Original" type="int">
			</cf_dbtemp>                

            <cf_dbtemp name="ECompras" returnvariable="ECompras" datasource="sifinterfaces">
                <cf_dbtempcol name="ID_DocumentoC" type="int">
                <cf_dbtempcol name="ID_Original" type="int">
			</cf_dbtemp>
            
            <cf_dbtemp name="ECobrosPagos" returnvariable="ECobrosPagos" datasource="sifinterfaces">
                <cf_dbtempcol name="ID_Pago" type="int">
                <cf_dbtempcol name="ID_Original" type="int">
            </cf_dbtemp>
            
            <cfquery name="rsMaximo_IdProceso" datasource="sifinterfaces">
                select 1
                from SIFLD_Historico_ID
                where Tabla like 'Historico'
            </cfquery>
            
            <cfif rsMaximo_IdProceso.recordcount LTE 0>
                <cfquery datasource="sifinterfaces">
                    insert SIFLD_Historico_ID (Consecutivo, Tabla) values(0, 'Historico')
                </cfquery>
            </cfif>
                
			<!--- Archiva Documentos de Ventas ---->
            <!--- Genera los ID Historicos --->
			<cftransaction action="begin">
            <cftry>
                <cfquery datasource="sifinterfaces" result="Rinsert">
                    insert into #EVentas#
                        (ID_DocumentoV, ID_Original)
                    select 0, ID_DocumentoV
                    from sif_interfaces2..ESIFLD_Facturas_VentaT
                    where Estatus in (2,0)
                </cfquery>
                
                <cfquery name="rsID" datasource="sifinterfaces">
                    select max(Consecutivo) as Consecutivo 
                    from SIFLD_Historico_ID
                    where Tabla like 'Historico'
                </cfquery>
    
                <cfquery datasource="sifinterfaces">            
                    declare @ID as numeric(18,0)
                    select @ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Consecutivo#">
                    
                    update #EVentas# set ID_DocumentoV = @ID, @ID = @ID +1
                </cfquery>
    			
                <cfquery name="rsID2" datasource="sifinterfaces">
	                select isnull(max(ID_DocumentoV),0) as Consecutivo
                    from #EVentas#
                </cfquery>
                
                <cfif rsID2.Consecutivo GT rsID.Consecutivo>
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_Historico_ID 
                        set Consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID2.Consecutivo#">
                        where Tabla like 'Historico'
                    </cfquery>
                </cfif>
                
                <cfquery datasource="sifinterfaces" result="Rinsert">
                    insert into ESIFLD_HFacturas_Venta
                        (Ecodigo, Origen, b.ID_DocumentoV, Tipo_Documento, Tipo_Venta,
                         Fecha_Venta, Fecha_Operacion, Fecha_Vencimiento, Contrato, Numero_Documento,
                         Cliente, IETU_Clas, Subtotal, Descuento, Impuesto,
                         Total, Redondeo, Vendedor, Sucursal, Dias_Credito,
                         Moneda, Fecha_Tipo_Cambio, Tipo_Cambio, Direccion_Fact, Retencion,
                         Observaciones, Tipo_CEDI, Factura_Cambio, Clas_Venta, Origen_Venta,
                         Usuario, Estatus, ID10, ID18, Fecha_Inicio_Proceso,
                         Fecha_Fin_Proceso, Fecha_Inclusion, ControlMem, Periodo,
                         Mes, Contabilizado, VoucherNum, SistemaId, TradeNum, Mes_Contabilizado,
                         Utilidad_Reg, Mes_Utilidad_Reg)
                    select Ecodigo, Origen, b.ID_DocumentoV, Tipo_Documento, Tipo_Venta,
                         Fecha_Venta, Fecha_Operacion, Fecha_Vencimiento, Contrato, Numero_Documento,
                         Cliente, IETU_Clas, Subtotal, Descuento, Impuesto,
                         Total, Redondeo, Vendedor, Sucursal, Dias_Credito,
                         Moneda, Fecha_Tipo_Cambio, Tipo_Cambio, Direccion_Fact, Retencion,
                         Observaciones, Tipo_CEDI, Factura_Cambio, Clas_Venta, Origen_Venta,
                         Usuario, Estatus, ID10, ID18, Fecha_Inicio_Proceso,
                         Fecha_Fin_Proceso, Fecha_Inclusion, ControlMem, Periodo,
                         Mes, Contabilizado, VoucherNum, SistemaId, TradeNum, Mes_Contabilizado,
                         Utilidad_Reg, Mes_Utilidad_Reg
                    from sif_interfaces2..ESIFLD_Facturas_VentaT a
                        inner join #EVentas# b 
                        on a.ID_DocumentoV = b.ID_Original
                </cfquery>
                
                <!--- Detalle --->
                <cfquery datasource="sifinterfaces">
                    insert into DSIFLD_HFacturas_Venta
                        (Ecodigo, ID_DocumentoV, ID_linea, Tipo_Lin,
                         Tipo_Item, Clas_Item, Cod_Item, Cod_Fabricante, Cod_Impuesto,
                         Cantidad, Precio_Unitario, Descuento_Lin, Descuento_Fact, Subtotal_Lin,
                         Impuesto_Lin, Total_Lin, Costo_Venta, Clas_Venta_Lin, Origen_Venta_Lin,
                         Estado_Venta_Lin, Contrato_Lin, Descripcion, Vol_Barriles, CFuncional)
                     select Ecodigo, b.ID_DocumentoV, ID_linea, Tipo_Lin,
                         Tipo_Item, Clas_Item, Cod_Item, Cod_Fabricante, Cod_Impuesto,
                         Cantidad, Precio_Unitario, Descuento_Lin, Descuento_Fact, Subtotal_Lin,
                         Impuesto_Lin, Total_Lin, Costo_Venta, Clas_Venta_Lin, Origen_Venta_Lin,
                         Estado_Venta_Lin, Contrato_Lin, Descripcion, Vol_Barriles, CFuncional
                     from sif_interfaces2..DSIFLD_Facturas_VentaT a
                        inner join #EVentas# b 
                        on a.ID_DocumentoV = b.ID_Original 
                </cfquery>
                
                <!--- Formas de Pago --->
                <cfquery datasource="sifinterfaces">
                    insert into SIFLD_HFacturas_Tipo_Pago
                        (Ecodigo, b.ID_DocumentoV, ID_linea_Pago, Tipo_Pago, ID_Forma_Pago,
                         Importe, Moneda, Tipo_Cambio, Comision_Porcentaje, Especial,
                         SocioDocumento)
                    select Ecodigo, b.ID_DocumentoV, ID_linea_Pago, Tipo_Pago, ID_Forma_Pago,
                         Importe, Moneda, Tipo_Cambio, Comision_Porcentaje, Especial,
                         SocioDocumento
                    from sif_interfaces2..SIFLD_Facturas_Tipo_PagoT a
                        inner join #EVentas# b 
                        on a.ID_DocumentoV = b.ID_Original
                </cfquery>
                <!---
                <!--- Elimina los registros Archivados --->
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_Facturas_Tipo_Pago
                    where ID_DocumentoV in (select ID_Original from #EVentas#)
                </cfquery>
                
                <cfquery datasource="sifinterfaces">
                    delete DSIFLD_Facturas_Venta
                    where ID_DocumentoV in (select ID_Original from #EVentas#)
                </cfquery>
                
                <cfquery datasource="sifinterfaces">
                    delete ESIFLD_Facturas_Venta
                    where ID_DocumentoV in (select ID_Original from #EVentas#)
            	</cfquery>--->
            <cftransaction action="commit" />
                <cfcatch>
                    <cftransaction action="rollback" />
                    <cfif isdefined("cfcatch.Message")>
						<cfset Mensaje="#cfcatch.Message#">
                    <cfelse>
                        <cfset Mensaje="">
                    </cfif>
                    <cfif isdefined("cfcatch.Detail")>
                        <cfset Detalle="#cfcatch.Detail#">
                    <cfelse>
                        <cfset Detalle="">
                    </cfif>
                    <cfif isdefined("cfcatch.sql")>
                        <cfset SQL="#cfcatch.sql#">
                    <cfelse>
                        <cfset SQL="">
                    </cfif>
                    <cfif isdefined("cfcatch.where")>
                        <cfset PARAM="#cfcatch.where#">
                    <cfelse>
                        <cfset PARAM="">
                    </cfif>
                    <cfif isdefined("cfcatch.StackTrace")>
                        <cfset PILA="#cfcatch.StackTrace#">
                    <cfelse>
                        <cfset PILA="">
                    </cfif>
                    <cfset MensajeError= #Mensaje# & ' ' & #Detalle# & ' ' & #SQL# & ' ' & #PARAM# & ' ' & #PILA#>
                    <cfthrow message="Error Archivando Ventas" detail="#MensajeError#">
                </cfcatch>
        	</cftry>
            </cftransaction>
            
            <!--- Archiva Documentos de Compras ---->
            <!--- Genera los ID Historicos --->
			<cftransaction action="begin">
            <cftry>
                <cfquery datasource="sifinterfaces" result="Rinsert">
                    insert into #ECompras#
                        (ID_DocumentoC, ID_Original)
                    select 0, ID_DocumentoC
                    from sif_interfaces2..ESIFLD_Facturas_CompraT
                    where Estatus in (2,0)
                </cfquery>
                
                <cfquery name="rsID" datasource="sifinterfaces">
                    select max(Consecutivo) as Consecutivo 
                    from SIFLD_Historico_ID
                    where Tabla like 'Historico'
                </cfquery>
    
                <cfquery datasource="sifinterfaces">            
                    declare @ID as numeric(18,0)
                    select @ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Consecutivo#">
                    
                    update #ECompras# set ID_DocumentoC = @ID, @ID = @ID +1
                </cfquery>
    
                <cfquery name="rsID2" datasource="sifinterfaces">
	                select isnull(max(ID_DocumentoC),0) as Consecutivo
                    from #ECompras#
                </cfquery>
                
                <cfif rsID2.Consecutivo GT rsID.Consecutivo>
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_Historico_ID 
                        set Consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID2.Consecutivo#">
                        where Tabla like 'Historico'
                    </cfquery>
                </cfif>
                
                <!--- Encabezado --->
                <cfquery datasource="sifinterfaces" result="Rinsert">
                    insert into ESIFLD_HFacturas_Compra
                        (Ecodigo, Origen, ID_DocumentoC, Tipo_Documento, Tipo_Compra,
                          Fecha_Compra, Fecha_Arribo, Fecha_Vencimiento, Contrato, Numero_Documento,
                          Proveedor, IETU_Clas, Subtotal, Descuento, Impuesto, 
                          Total, Vendedor, Sucursal, Moneda, Fecha_Tipo_Cambio,
                          Tipo_Cambio, Direccion_Fact, Retencion, Observaciones, Almacen,
                          Afecta_Costo, Clas_Compra, Dest_Compra, Usuario, Estatus,
                          ID10, ID18, Fecha_Inicio_Proceso, Fecha_Fin_Proceso, Fecha_Inclusion,
                          ControlMem, Periodo, Mes, VoucherNum, SistemaId, TradeNum)
                    select Ecodigo, Origen, b.ID_DocumentoC, Tipo_Documento, Tipo_Compra,
                          Fecha_Compra, Fecha_Arribo, Fecha_Vencimiento, Contrato, Numero_Documento,
                          Proveedor, IETU_Clas, Subtotal, Descuento, Impuesto, 
                          Total, Vendedor, Sucursal, Moneda, Fecha_Tipo_Cambio,
                          Tipo_Cambio, Direccion_Fact, Retencion, Observaciones, Almacen,
                          Afecta_Costo, Clas_Compra, Dest_Compra, Usuario, Estatus,
                          ID10, ID18, Fecha_Inicio_Proceso, Fecha_Fin_Proceso, Fecha_Inclusion,
                          ControlMem, Periodo, Mes, VoucherNum, SistemaId, TradeNum
                    from sif_interfaces2..ESIFLD_Facturas_CompraT a
                        inner join #ECompras# b 
                        on a.ID_DocumentoC = b.ID_Original
                </cfquery>
                
                <!--- Detalle --->
                <cfquery datasource="sifinterfaces">
                    insert into DSIFLD_HFacturas_Compra
                        (Ecodigo, ID_DocumentoC, ID_linea, Tipo_Lin, Tipo_Item,
                         Clas_Item, Cod_Item, Cod_Fabricante, Cod_Impuesto, Cantidad,
                         Precio_Unitario, Descuento_Lin, Descuento_Fact, Subtotal_Lin,
                         Impuesto_Lin, Total_Lin, Clas_Compra_Lin, Dest_Compra_Lin, Contrato_Lin,
                         Venta_Ref, Clas_Venta_Ref, Origen_Venta_Ref, Estado_Venta_Ref, 
                         Descripcion, CFuncional, Cantidad_Saldo)
                     select Ecodigo, b.ID_DocumentoC, ID_linea, Tipo_Lin, Tipo_Item,
                         Clas_Item, Cod_Item, Cod_Fabricante, Cod_Impuesto, Cantidad,
                         Precio_Unitario, Descuento_Lin, Descuento_Fact, Subtotal_Lin,
                         Impuesto_Lin, Total_Lin, Clas_Compra_Lin, Dest_Compra_Lin, Contrato_Lin,
                         Venta_Ref, Clas_Venta_Ref, Origen_Venta_Ref, Estado_Venta_Ref, 
                         Descripcion, CFuncional, Cantidad_Saldo
                     from sif_interfaces2..DSIFLD_Facturas_CompraT a
                        inner join #ECompras# b 
                        on a.ID_DocumentoC = b.ID_Original
                </cfquery>
                <!---
                <!--- Elimina los registros Archivados --->
                <cfquery datasource="sifinterfaces">
                    delete DSIFLD_Facturas_Compra
                    where ID_DocumentoC in (select ID_Original from #ECompras#)
                </cfquery>
                
                <cfquery datasource="sifinterfaces">
                    delete ESIFLD_Facturas_Compra
                    where ID_DocumentoC in (select ID_Original from #ECompras#)
            	</cfquery>--->
            <cftransaction action="commit" />
                <cfcatch>
                    <cftransaction action="rollback" />
                    <cfif isdefined("cfcatch.Message")>
						<cfset Mensaje="#cfcatch.Message#">
                    <cfelse>
                        <cfset Mensaje="">
                    </cfif>
                    <cfif isdefined("cfcatch.Detail")>
                        <cfset Detalle="#cfcatch.Detail#">
                    <cfelse>
                        <cfset Detalle="">
                    </cfif>
                    <cfif isdefined("cfcatch.sql")>
                        <cfset SQL="#cfcatch.sql#">
                    <cfelse>
                        <cfset SQL="">
                    </cfif>
                    <cfif isdefined("cfcatch.where")>
                        <cfset PARAM="#cfcatch.where#">
                    <cfelse>
                        <cfset PARAM="">
                    </cfif>
                    <cfif isdefined("cfcatch.StackTrace")>
                        <cfset PILA="#cfcatch.StackTrace#">
                    <cfelse>
                        <cfset PILA="">
                    </cfif>
                    <cfset MensajeError= #Mensaje# & ' ' & #Detalle# & ' ' & #SQL# & ' ' & #PARAM# & ' ' & #PILA#>
                    <cfthrow message="Error Archivando Compras" detail="#MensajeError#">
                </cfcatch>
        	</cftry>
            </cftransaction>
			
            <!--- Archiva Documentos de Cobros Pagos ---->
            <!--- Genera los ID Historicos --->
			<cftransaction action="begin">
            <cftry>
                <cfquery datasource="sifinterfaces" result="Rinsert">
                    insert into #ECobrosPagos#
                        (ID_Pago, ID_Original)
                    select 0, ID_Pago
                    from sif_interfaces2..ESIFLD_Cobros_PagosT
                    where Estatus in (2,0)
                </cfquery>
                
                <cfquery name="rsID" datasource="sifinterfaces">
                    select max(Consecutivo) as Consecutivo 
                    from SIFLD_Historico_ID
                    where Tabla like 'Historico'
                </cfquery>
    
                <cfquery datasource="sifinterfaces">            
                    declare @ID as numeric(18,0)
                    select @ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Consecutivo#">
                    
                    update #ECobrosPagos# set ID_Pago = @ID, @ID = @ID +1
                </cfquery>
    			
                <cfquery name="rsID2" datasource="sifinterfaces">
	                select isnull(max(ID_Pago),0) as Consecutivo
                    from #ECobrosPagos#
                </cfquery>
                
                <cfif rsID2.Consecutivo GT rsID.Consecutivo>
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_Historico_ID 
                        set Consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID2.Consecutivo#">
                        where Tabla like 'Historico'
                    </cfquery>
                </cfif>
                                
                <!--- Encabezado --->
                <cfquery datasource="sifinterfaces" result="Rinsert">
                    insert into ESIFLD_HCobros_Pagos
                        (Ecodigo, Origen, ID_Pago, Tipo_Pago, Transaccion_Pago,
						 Fecha_Pago, Numero_Documento, Banco, Cuenta_Banco, Total,
						 Moneda, Tipo_Cambio, Observaciones, Usuario, Estatus,
						 ID14, ID11, Fecha_Inicio_Proceso, Fecha_Fin_Proceso, Fecha_Inclusion,
						 ControlMem, Periodo, Mes, VoucherNum)
                    select Ecodigo, Origen, b.ID_Pago, Tipo_Pago, Transaccion_Pago,
						 Fecha_Pago, Numero_Documento, Banco, Cuenta_Banco, Total,
						 Moneda, Tipo_Cambio, Observaciones, Usuario, Estatus,
						 ID14, ID11, Fecha_Inicio_Proceso, Fecha_Fin_Proceso, Fecha_Inclusion,
						 ControlMem, Periodo, Mes, VoucherNum
                    from sif_interfaces2..ESIFLD_Cobros_PagosT a
                        inner join #ECobrosPagos# b 
                        on a.ID_Pago = b.ID_Original
                </cfquery>
                
                <!--- Detalle --->
                <cfquery datasource="sifinterfaces">
                    insert into DSIFLD_HCobros_Pagos
                        (Ecodigo, ID_Pago, ID_linea, Tipo_Documento_Pago, Socio_Documento_Pago,
						 Documento_Pago, Monto_Pago, Moneda_Documento, Tipo_Cambio_Pago,
                         Monto_Documento)
                     select Ecodigo, b.ID_Pago, ID_linea, Tipo_Documento_Pago, Socio_Documento_Pago,
						 Documento_Pago, Monto_Pago, Moneda_Documento, Tipo_Cambio_Pago,
                         Monto_Documento
                     from sif_interfaces2..DSIFLD_Cobros_PagosT a
                        inner join #ECobrosPagos# b 
                        on a.ID_Pago = b.ID_Original
                </cfquery>
                <!---
                <!--- Elimina los registros Archivados --->
                <cfquery datasource="sifinterfaces">
                    delete DSIFLD_Cobros_Pagos
                    where ID_Pago in (select ID_Original from #ECobrosPagos#)
                </cfquery>
                
                <cfquery datasource="sifinterfaces">
                    delete ESIFLD_Cobros_Pagos
                    where ID_Pago in (select ID_Original from #ECobrosPagos#)
            	</cfquery>--->
            <cftransaction action="commit" />
                <cfcatch>
                    <cftransaction action="rollback" />
                    <cfif isdefined("cfcatch.Message")>
						<cfset Mensaje="#cfcatch.Message#">
                    <cfelse>
                        <cfset Mensaje="">
                    </cfif>
                    <cfif isdefined("cfcatch.Detail")>
                        <cfset Detalle="#cfcatch.Detail#">
                    <cfelse>
                        <cfset Detalle="">
                    </cfif>
                    <cfif isdefined("cfcatch.sql")>
                        <cfset SQL="#cfcatch.sql#">
                    <cfelse>
                        <cfset SQL="">
                    </cfif>
                    <cfif isdefined("cfcatch.where")>
                        <cfset PARAM="#cfcatch.where#">
                    <cfelse>
                        <cfset PARAM="">
                    </cfif>
                    <cfif isdefined("cfcatch.StackTrace")>
                        <cfset PILA="#cfcatch.StackTrace#">
                    <cfelse>
                        <cfset PILA="">
                    </cfif>
                    <cfset MensajeError= #Mensaje# & ' ' & #Detalle# & ' ' & #SQL# & ' ' & #PARAM# & ' ' & #PILA#>
                    <cfthrow message="Error Archivando Cobros/Pagos" detail="#MensajeError#">
                </cfcatch>
        	</cftry>
            </cftransaction>
            <!---
		<cfcatch>
            <cfquery datasource="sifinterfaces">
                insert into SIFLD_Errores 
                    (Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila,
                    Ecodigo, Usuario)
                    values 
                    ('Archiva_Historicos', 
                    '',
                    9999,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.Message#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.Detail#">,
                    null,
                    null,
                    null,
                    1,
                    null) 
			</cfquery>	
		</cfcatch> 
	</cftry>--->
</cffunction>
