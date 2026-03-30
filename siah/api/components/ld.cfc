<cfcomponent>

    <cffunction  name="getTicketInfo" returnType="query">
        <cfargument  name="Emp_Id" required="true" type="string">
        <cfargument  name="TipoDoc_Id" required="true" type="string">
        <cfargument  name="Suc_Id" required="true" type="numeric">
        <cfargument  name="Caja_Id" required="true" type="numeric">
        <cfargument  name="Factura_Id" required="true" type="numeric">
    
        <cfquery name="rsTicket" datasource="ldcom">
            select e.Emp_Id, e.Suc_id, e.Caja_Id, e.Factura_Id, e.Factura_Fecha, e.Factura_SubTotal, e.Factura_Impuesto, e.Factura_Total, Factura_Descuento,
                case when e.Fiscal_NumeroFactura > 0 then 0 else 1 end Facturable, e.Fiscal_NumeroFactura, e.Fiscal_NumeroFacturaGlobal, e.Cliente_Id,
                c.Cliente_Direccion, fpdf.Fiscal_NumeroFactura UUID_Global,
                d.Detalle_Id, d.Servicio_Clave, d.Unidad_Clave, d.Articulo_Id, d.Detalle_Cantidad,
                d.Detalle_Unidad_Simbolo, ad.Articulo_Nombre Detalle_Articulo_Nombre, d.Detalle_Precio_Unitario, d.Detalle_Impuesto_Monto, d.Detalle_Total,
                (ds.Descuento_Monto * d.Detalle_Cantidad) + (isnull(dc.Detalle_Cupon_Monto,0) * isnull(dc.Promocion_Cupon_Piezas_Base,0)) Descuento_Monto, 
				d.Detalle_IEPS_Monto,
                i.Impuesto_Codigo_SAT, case when i.Impuesto_Monto_Fijo > 0 then 'Cuota' else 'Tasa' end TipoFactor,
                i.Impuesto_Porcentaje/100 TasaOCuota, 0 Retencion
            from Factura_Encabezado e
            inner join Factura_Detalle d
                on e.Emp_Id = d.Emp_Id
                and e.TipoDoc_Id = d.TipoDoc_Id
                and e.Suc_Id = d.Suc_Id
                and e.Caja_Id = d.Caja_Id 
                and e.Factura_Id = d.Factura_Id
            inner join Articulo ad 
                on d.Emp_Id = ad.Emp_Id
                and d.Articulo_Id = ad.Articulo_Id
            inner join Factura_Detalle_Descuento ds
                on d.Emp_Id = ds.Emp_Id
                and d.TipoDoc_Id = ds.TipoDoc_Id
                and d.Suc_Id = ds.Suc_Id
                and d.Caja_Id = ds.Caja_Id 
                and d.Factura_Id = ds.Factura_Id
                and d.Detalle_Id = ds.Detalle_Id
            inner join Factura_Detalle_Impuestos di
                on d.Emp_Id = di.Emp_Id
                and d.TipoDoc_Id = di.TipoDoc_Id
                and d.Suc_Id = di.Suc_Id
                and d.Caja_Id = di.Caja_Id 
                and d.Factura_Id = di.Factura_Id
                and d.Detalle_Id = di.Detalle_Id
            inner join Impuesto_Articulo ia
                on d.Articulo_Id = ia.Articulo_Id
                and d.Emp_Id = ia.Emp_Id
            inner join Impuesto i
                on ia.Impuesto_Id = i.Impuesto_Id
                and ia.Emp_Id = i.Emp_Id
            left join Factura_Detalle_Cupon dc
				on d.Emp_Id = dc.Emp_Id
                and d.TipoDoc_Id = dc.TipoDoc_Id
                and d.Suc_Id = dc.Suc_Id
                and d.Caja_Id = dc.Caja_Id 
                and d.Factura_Id = dc.Factura_Id
                and d.Detalle_Id = dc.Detalle_Id
            left join Factura_Fiscal_PDF fpdf
				on e.Emp_Id = fpdf.Emp_Id
                and e.Suc_Id = fpdf.Suc_Id
				and e.Fiscal_NumeroFacturaGlobal = fpdf.Consecutivo
            left join Cliente c
                on e.Cliente_id = c.Cliente_id
            where 1 = 1
                and e.Emp_Id = #arguments.Emp_Id#
                and e.Suc_id = #arguments.Suc_Id#
                and e.Caja_Id = #arguments.Caja_Id#
                and e.Factura_Id = #arguments.Factura_Id#
                and e.TipoDoc_Id = #arguments.TipoDoc_Id#
            union all
            select e.Emp_Id, e.Suc_id, e.Caja_Id, e.Factura_Id, e.Factura_Fecha, e.Factura_SubTotal, e.Factura_Impuesto, e.Factura_Total, Factura_Descuento,
                case when e.Fiscal_NumeroFactura > 0 then 0 else 1 end Facturable, e.Fiscal_NumeroFactura, e.Fiscal_NumeroFacturaGlobal, e.Cliente_Id,
                c.Cliente_Direccion, fpdf.Fiscal_NumeroFactura UUID_Global,
                d.Detalle_Id, d.Servicio_Clave, d.Unidad_Clave, d.Articulo_Id, d.Detalle_Cantidad,
                d.Detalle_Unidad_Simbolo, ad.Articulo_Nombre Detalle_Articulo_Nombre, d.Detalle_Precio_Unitario, d.Detalle_Impuesto_Monto, d.Detalle_Total,
                (ds.Descuento_Monto * d.Detalle_Cantidad) + (isnull(dc.Detalle_Cupon_Monto,0) * isnull(dc.Promocion_Cupon_Piezas_Base,0)) Descuento_Monto, 
				d.Detalle_IEPS_Monto,
                i.Impuesto_Codigo_SAT, case when i.Impuesto_Monto_Fijo > 0 then 'Cuota' else 'Tasa' end TipoFactor,
                i.Impuesto_Porcentaje/100 TasaOCuota, 0 Retencion
            from Ticket_Encabezado e
            inner join Ticket_Detalle d
                on e.Emp_Id = d.Emp_Id
                and e.TipoDoc_Id = d.TipoDoc_Id
                and e.Suc_Id = d.Suc_Id
                and e.Caja_Id = d.Caja_Id 
                and e.Factura_Id = d.Factura_Id
            inner join Articulo ad 
                on d.Emp_Id = ad.Emp_Id
                and d.Articulo_Id = ad.Articulo_Id
            inner join Factura_Detalle_Descuento ds
                on d.Emp_Id = ds.Emp_Id
                and d.TipoDoc_Id = ds.TipoDoc_Id
                and d.Suc_Id = ds.Suc_Id
                and d.Caja_Id = ds.Caja_Id 
                and d.Factura_Id = ds.Factura_Id
                and d.Detalle_Id = ds.Detalle_Id
            inner join Factura_Detalle_Impuestos di
                on d.Emp_Id = di.Emp_Id
                and d.TipoDoc_Id = di.TipoDoc_Id
                and d.Suc_Id = di.Suc_Id
                and d.Caja_Id = di.Caja_Id 
                and d.Factura_Id = di.Factura_Id
                and d.Detalle_Id = di.Detalle_Id
            inner join Impuesto_Articulo ia
                on d.Articulo_Id = ia.Articulo_Id
                and d.Emp_Id = ia.Emp_Id
            inner join Impuesto i
                on ia.Impuesto_Id = i.Impuesto_Id
                and ia.Emp_Id = i.Emp_Id
            left join Ticket_Detalle_Cupon dc
				on d.Emp_Id = dc.Emp_Id
                and d.TipoDoc_Id = dc.TipoDoc_Id
                and d.Suc_Id = dc.Suc_Id
                and d.Caja_Id = dc.Caja_Id 
                and d.Factura_Id = dc.Factura_Id
                and d.Detalle_Id = dc.Detalle_Id
            left join Factura_Fiscal_PDF fpdf
				on e.Emp_Id = fpdf.Emp_Id
                and e.Suc_Id = fpdf.Suc_Id
				and e.Fiscal_NumeroFacturaGlobal = fpdf.Consecutivo
            left join Cliente c
                on e.Cliente_id = c.Cliente_id
            where 1 = 1
                and e.Emp_Id = #arguments.Emp_Id#
                and e.Suc_id = #arguments.Suc_Id#
                and e.Caja_Id = #arguments.Caja_Id#
                and e.Factura_Id = #arguments.Factura_Id#
                and e.TipoDoc_Id = #arguments.TipoDoc_Id#
        </cfquery>

        <cfreturn rsTicket>

        <cfif rsTicket.recordCount eq 0>
            <cfthrow type="TicketNoEncontrado" message="Ticket no encontrado">
        </cfif>

    </cffunction>
    
    <cffunction  name="queryTicketToStruct" returnType="Struct">
        
        <cfargument  name="qTicket" required="true" type="query">

        <cfset rsTicket = arguments.qTicket>
        <cfset _ticket = structNew()>

        <cfquery name="rsEnc" dbtype="query">
            select *
            from rsTicket
        </cfquery>
        
        <cfif rsEnc.Facturable>
            <cfset _ticket["store"] = rsEnc.Emp_id>
            <cfset _ticket["ticket"] = right("000#rsEnc.Suc_id#",3) & "-" & right("00#rsEnc.Caja_Id#",2) & "-" & right("0000000#rsEnc.Factura_Id#",7)>
            <cfset _ticket["date"] = DateFormat(rsEnc.Factura_Fecha,"yyyy/mm/dd")>
            <cfset _ticket["facturable"] = rsEnc.Facturable>
            <cfset _ticket["FacturaGlobal"] = rsEnc.Fiscal_NumeroFacturaGlobal>
            <cfset _ticket["FacturaSubTotal"] = rsEnc.Factura_SubTotal >
            <cfset _ticket["FacturaImpuesto"] = rsEnc.Factura_Impuesto>
            <cfset _ticket["FacturaTotal"] = rsEnc.Factura_Total>
            <cfset _ticket["FacturaDescuento"] = rsEnc.Factura_Descuento>
            <cfset _ticket["NumeroFacturaGlobal"] = rsEnc.Fiscal_NumeroFacturaGlobal>
            <cfset _ticket["ClienteId"] = rsEnc.Cliente_Id>
            <cfset _ticket["ClienteDireccion"] = rsEnc.Cliente_Direccion>
            <cfset _ticket["Conceptos"] = []>
            

            <cfset _conceptos = arrayNew(1)>
            <cfquery name="rsDet" dbtype="query">
                select Detalle_Id, Servicio_Clave, Unidad_Clave, Articulo_Id, Detalle_Cantidad,
                    Detalle_Unidad_Simbolo, Detalle_Articulo_Nombre, Detalle_Precio_Unitario, Detalle_Impuesto_Monto, Detalle_Total,
                    Descuento_Monto
                from rsTicket
                group by Detalle_Id, Servicio_Clave, Unidad_Clave, Articulo_Id, Detalle_Cantidad,
                    Detalle_Unidad_Simbolo, Detalle_Articulo_Nombre, Detalle_Precio_Unitario, Detalle_Impuesto_Monto, Detalle_Total,
                    Descuento_Monto
            </cfquery>

            <cfloop query="rsDet">
                <cfset _concepto = structNew()>

                <cfset _concepto["ClaveProdServ"] = rsDet.Servicio_Clave>
                <cfset _concepto["ClaveUnidad"] = rsDet.Unidad_Clave>
                <cfset _concepto["NoIdentificacion"] = rsDet.Articulo_Id>
                <cfset _concepto["Cantidad"] = rsDet.Detalle_Cantidad>
                <cfset _concepto["Unidad"] = rsDet.Detalle_Unidad_Simbolo>
                <cfset _concepto["Descripcion"] = rsDet.Detalle_Articulo_Nombre>
                <cfset _concepto["ValorUnitario"] = rsDet.Detalle_Precio_Unitario>
                <cfif rsDet.Descuento_Monto gt 0>
                    <cfset _concepto["Descuento"] = rsDet.Descuento_Monto>
                </cfif>
                <cfset _concepto["Impuestos"] = []>

                <cfquery name="rsImp" dbtype="query">
                    select Articulo_Id, Impuesto_Codigo_SAT, TipoFactor, TasaOCuota, Retencion
                    from rsTicket
                    where Articulo_Id = '#rsDet.Articulo_Id#'
                    group by Articulo_Id, Impuesto_Codigo_SAT, TipoFactor,TasaOCuota, Retencion
                </cfquery>

                <cfloop query="rsImp">
                    <cfset _impuesto = structNew()>

                    <cfset _impuesto["Impuesto"] = rsImp.Impuesto_Codigo_SAT>
                    <cfset _impuesto["TipoFactor"] = rsImp.TipoFactor>
                    <cfset _impuesto["TasaOCuota"] = rsImp.TasaOCuota>
                    <cfset _impuesto["Retencion"] = rsImp.Retencion>

                    <cfset ArrayAppend(_concepto.Impuestos, _impuesto)>
                </cfloop>	


                <cfset ArrayAppend(_ticket.Conceptos, _concepto)>
            </cfloop>
        <cfelse>
            <cfthrow type="TicketNoFacturable" message="El tickect no es facturable">
        </cfif>

        <cfreturn _ticket> 
    </cffunction>

    <cffunction  name="getTicketDB" returnType="query">
        <cfargument  name="Emp_Id" required="true" type="string">
        <cfargument  name="TipoDoc_Id" required="true" type="string">
        <cfargument  name="Suc_Id" required="true" type="numeric">
        <cfargument  name="Caja_Id" required="true" type="numeric">
        <cfargument  name="Factura_Id" required="true" type="numeric">
    
        <cfquery name="rsTicket" datasource="ldcom">
            select e.Emp_Id, e.Suc_id, e.Caja_Id, e.Factura_Id, e.TipoDoc_Id, e.Factura_Fecha, e.Factura_SubTotal, e.Factura_Impuesto, e.Factura_Total, Factura_Descuento,
                case when e.Fiscal_NumeroFactura > 0 then 0 else 1 end Facturable, e.Fiscal_NumeroFactura, e.Fiscal_NumeroFacturaGlobal, e.Cliente_Id, 'Factura_Encabezado' OrigenTicket
            from Factura_Encabezado e
            where 1 = 1
                and e.Emp_Id = #arguments.Emp_Id#
                and e.Suc_id = #arguments.Suc_Id#
                and e.Caja_Id = #arguments.Caja_Id#
                and e.Factura_Id = #arguments.Factura_Id#
                and e.TipoDoc_Id = #arguments.TipoDoc_Id#
            union all
            select e.Emp_Id, e.Suc_id, e.Caja_Id, e.Factura_Id, e.TipoDoc_Id, e.Factura_Fecha, e.Factura_SubTotal, e.Factura_Impuesto, e.Factura_Total, Factura_Descuento,
                case when e.Fiscal_NumeroFactura > 0 then 0 else 1 end Facturable, e.Fiscal_NumeroFactura, e.Fiscal_NumeroFacturaGlobal, e.Cliente_Id, 'Ticket_Encabezado' OrigenTicket
            from Ticket_Encabezado e
            where 1 = 1
                and e.Emp_Id = #arguments.Emp_Id#
                and e.Suc_id = #arguments.Suc_Id#
                and e.Caja_Id = #arguments.Caja_Id#
                and e.Factura_Id = #arguments.Factura_Id#
                and e.TipoDoc_Id = #arguments.TipoDoc_Id#
        </cfquery>

        <cfreturn rsTicket>

        <cfif rsTicket.recordCount eq 0>
            <cfthrow type="TicketNoEncontrado" message="Ticket no encontrado">
        </cfif>

    </cffunction>


</cfcomponent>