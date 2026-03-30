<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Funciones de reclamo --->

<!--- Funcion que calcula el monto total de una linea de acuerdo al parametro de
	  calculo de impuestos --->
<cffunction name="calcularMonto_TolApro" returntype="numeric">
	<cfargument name="cantRecibida" 	type="numeric" required="yes">
	<cfargument name="precioOrden" 		type="numeric" required="yes">
	<cfargument name="precioFactura" 	type="numeric" required="yes">	
	<cfargument name="impuestoOrden" 	type="numeric" required="yes">
	<cfargument name="impuestoFactura" 	type="numeric" required="yes">	
	<cfargument name="descuentoOrden" 	type="numeric" required="yes">	
	<cfargument name="descuentoFactura" type="numeric" required="yes">		

	<cfset difPrecio = 0>
	<cfset difImp = 0>
	<cfset difDesc = 0>	

	<cfset precioFactura = LvarOBJ_PrecioU.enCF(precioFactura)>
	<cfset precioOrden	 = LvarOBJ_PrecioU.enCF(precioOrden)>


	<cfset difPrecio = precioFactura - precioOrden>
	<cfset difImp = impuestoFactura - impuestoOrden>	
	<cfset difDesc = descuentoFactura - descuentoOrden>
	
	<cfif difPrecio EQ 0>
		<cfset difPrecio = precioFactura>		
	</cfif>	
	
	<cfif precioOrden GT precioFactura>
		<cfset difPrecio = precioFactura>		
	</cfif>
	
	<cfif difImp EQ 0>
		<cfset difImp = impuestoFactura>		
	</cfif>

	<cfif difDesc EQ 0>
		<cfset difDesc = descuentoFactura>		
	</cfif>
	
	<cfif descuentoOrden GT descuentoFactura>
		<cfset difDesc = Abs(difDesc)>		
	</cfif>

	<cfif descuentoFactura GT descuentoOrden>
		<cfset difDesc = descuentoFactura>		
	</cfif>
	
	<cfif impuestoFactura LT impuestoOrden>
		<cfset difImp = impuestoFactura>
	</cfif>	
	
	<cfreturn calcularMonto(cantRecibida, difPrecio, difDesc, difImp)>
</cffunction>

<!--- Funcion que calcula el monto total de una linea de acuerdo al parametro de
	  calculo de impuestos --->
<cffunction name="calcularMonto" returntype="numeric">
	<cfargument name="cantidad"   type="numeric" required="yes">
	<cfargument name="precio" 	  type="numeric" required="yes">
	<cfargument name="descuento"  type="numeric" required="yes">
	<cfargument name="impuesto"   type="numeric" required="yes">
	
	<cfset precio = LvarOBJ_PrecioU.enCF(precio)>
	<cfset monto = cantidad * precio>
	<cfset montoImpuesto = 0>

	<cfset montoImpuesto = (monto * ((100 - descuento) / 100)) * (impuesto / 100)>
	<cfreturn (monto * ((100 - descuento) / 100)) + montoImpuesto>
</cffunction>

<!--- Funcion que calcula el reclamo de una linea de una factura en base a los parametros --->
<cffunction name="calcularReclamo" returntype="array">
	<cfargument name="cantFactura" 				type="numeric" required="yes">
	<cfargument name="precioFactura" 			type="numeric" required="yes">
	<cfargument name="descuentoFactura" 		type="numeric" required="yes">
	<cfargument name="impuestoFactura" 			type="numeric" required="yes">
	<cfargument name="cantSaldo" 				type="numeric" required="yes">
	<cfargument name="precioOrden" 				type="numeric" required="yes">
	<cfargument name="descuentoOrden" 			type="numeric" required="yes">
	<cfargument name="impuestoOrden" 			type="numeric" required="yes">
	<cfargument name="cantRecibida" 			type="numeric" required="yes">
	<cfargument name="tolerancia" 				type="numeric" required="yes">
	<cfargument name="codigoMonedaFactura"  	type="numeric" required="yes">
	<cfargument name="codigoMonedaOrden" 		type="numeric" required="yes">
	<cfargument name="tipoCambioFactura" 		type="numeric" required="yes">
	<cfargument name="tipoCambioOrden" 			type="numeric" required="yes">	
	<cfargument name="factorConversionU" 		type="numeric" required="yes">	<!--- Factor para pasar las unidades de la factura a las de la orden --->
	<cfargument name="tipoItem" 				type="string"  required="yes">
	<cfargument name="articuloTieneTolerancia" 	type="string"  required="yes">
	<cfargument name="idPoliza" 				type="numeric" required="yes">		
	<cfargument name="toleranciaAprobada" 		type="numeric" required="no" default="0" >		<!--- Si la tolerancia fue aprobada 1, sino 0 --->

    <!---Pasamos las Cantidad de la factura y las cantidades recibidas y el precio de la Factura a las unidades de la Orden--->
	<cfset cantFactura		          = cantFactura  * factorConversionU>
	<cfset cantRecibida		          = cantRecibida * factorConversionU>
	<cfset precioFactura			  = LvarOBJ_PrecioU.enCF(precioFactura / factorConversionU)>	
	<cfset precioOrden				  = LvarOBJ_PrecioU.enCF(Arguments.precioOrden)>
	
	<!--- Si las monedas son distintas, se cambian a la moneda de la Factura--->	
	<cfif codigoMonedaFactura neq codigoMonedaOrden>
		<cfset precioOrden = LvarOBJ_PrecioU.enCF(precioOrden * (tipoCambioOrden / tipoCambioFactura))>
	</cfif>	
	<!---Si el Id de la poliza es 0 se coloca el impuesto de la Factura en 0--->
	<cfif idPoliza GT 0>
		<cfset impuestoFactura = 0>
	</cfif>	
	<!--- Unidades a Reclamar por Exceso sobre tolerancia --->
	<cfset LvarUnidadesReclamo = 0>
	<cfif cantFactura GT (cantSaldo + int(tolerancia)) and Arguments.toleranciaAprobada EQ 0>
		<cfset LvarUnidadesReclamo = int(cantFactura) - int(cantSaldo) - int(tolerancia)>
	</cfif>
	<cfset LvarMontoUnidadesExceso = LvarUnidadesReclamo * precioFactura>
	<!--- Unidades a Reclamar por no Recibidas --->
		<cfset LvarUnidadesNoRecibidas = 0>
	<cfif cantFactura GT cantRecibida and (cantFactura - cantRecibida - LvarUnidadesReclamo GT 0)>
		<cfset LvarUnidadesNoRecibidas = cantFactura - cantRecibida - LvarUnidadesReclamo>
	</cfif>
		<cfset LvarMontoUnidadesNoRec  = LvarUnidadesNoRecibidas * precioFactura>
	<!--- Diferencia de Precio a Reclamar --->
		<cfset LvarDifPrecioUnitario = 0>	
	<cfif Arguments.precioFactura GT Arguments.precioOrden>
		<cfset LvarDifPrecioUnitario = precioFactura - precioOrden>
	</cfif>
		<cfset LvarMontoDifPrecio    = (cantFactura - LvarUnidadesReclamo - LvarUnidadesNoRecibidas) * LvarDifPrecioUnitario>
	<!---Calculo del monto real de la Factura--->
		<cfset montoReal= (cantFactura * precioFactura) - LvarMontoUnidadesExceso - LvarMontoUnidadesNoRec - LvarMontoDifPrecio>
	<!--- Diferencia de Descuento a Reclamar --->
		<cfset LvarDiferenciaDescuentoPor = 0>	
	<cfif Arguments.descuentoFactura LT Arguments.descuentoOrden>
		<cfset LvarDiferenciaDescuentoPor = Arguments.descuentoOrden - Arguments.descuentoFactura>
	</cfif>
		<cfset LvarMontoDescuento = montoReal * LvarDiferenciaDescuentoPor / 100>
	<!--- Diferencia de impuesto a Reclamar --->
		<cfset LvarDiferenciaImpuestoPor  = 0>	
	<cfif Arguments.impuestoFactura GT Arguments.impuestoOrden>
		<cfset LvarDiferenciaImpuestoPor = Arguments.impuestoFactura - Arguments.impuestoOrden >
	</cfif>
		<cfset LvarMontoImpuesto      = (montoReal - (montoReal * Arguments.descuentoFactura/100 ))* LvarDiferenciaImpuestoPor / 100>
	<!---Descuento Sobre el Reclamo--->
	<cfset LvarDescuentoSobReclamo = (LvarMontoUnidadesExceso + LvarMontoUnidadesNoRec + LvarMontoDifPrecio) * Arguments.descuentoFactura / 100>
	<!---Descuento Sobre el Impuesto--->
	<cfset LvarMontoImptoReclamo   = (LvarMontoUnidadesExceso + LvarMontoUnidadesNoRec + LvarMontoDifPrecio + LvarMontoDescuento - LvarDescuentoSobReclamo) * Arguments.impuestoFactura / 100>
	<!---Monto del Reclamo total--->
	<cfset LvarMontoReclamo   = LvarMontoUnidadesExceso + LvarMontoUnidadesNoRec + LvarMontoDifPrecio>
	<cfset LvarMontoReclamo   = LvarMontoReclamo + LvarMontoDescuento +LvarMontoImpuesto- LvarDescuentoSobReclamo + LvarMontoImptoReclamo>
	
	<cfif LvarMontoReclamo LT 0>
		<cfset LvarMontoReclamo = 0.00>
	</cfif>
	
	<!---Formateo--->
	<cfset LvarMontoDifPrecio      = LvarOBJ_PrecioU.enCF(LvarMontoDifPrecio)>
	<cfset LvarMontoUnidadesExceso = LSNumberFormat(LvarMontoUnidadesExceso, "9.00")>
	<cfset LvarMontoUnidadesNoRec  = LSNumberFormat(LvarMontoUnidadesNoRec, "9.00")>
	<cfset LvarMontoDescuento      = LSNumberFormat(LvarMontoDescuento, "9.00")>
	<cfset LvarMontoImpuesto       = LSNumberFormat(LvarMontoImpuesto, "9.00")>
	<cfset LvarDescuentoSobReclamo = LSNumberFormat(LvarDescuentoSobReclamo, "9.00")>
	<cfset LvarMontoImptoReclamo   = LSNumberFormat(LvarMontoImptoReclamo, "9.00")>
	<cfset LvarMontoReclamo        = LSNumberFormat(LvarMontoReclamo, "9.00")>
	
	<!---Se guardan todos los calculos--->
	<cfset LvarResultado = arrayNew(1)>
	<cfset ArrayAppend(LvarResultado,LvarMontoReclamo)>
	<cfset ArrayAppend(LvarResultado,cantsaldo)>
	<cfset ArrayAppend(LvarResultado,int(tolerancia))>
	<cfset ArrayAppend(LvarResultado,LvarUnidadesReclamo)>
	<cfset ArrayAppend(LvarResultado,LvarUnidadesNoRecibidas)>
	<cfset ArrayAppend(LvarResultado,LvarDifPrecioUnitario)>
	<cfset ArrayAppend(LvarResultado,LvarDiferenciaDescuentoPor)>
	<cfset ArrayAppend(LvarResultado,LvarMontoUnidadesExceso)>
	<cfset ArrayAppend(LvarResultado,LvarUnidadesNoRecibidas)>
	<cfset ArrayAppend(LvarResultado,LvarMontoDifPrecio)>
	<cfset ArrayAppend(LvarResultado,LvarMontoDescuento)>
	<cfset ArrayAppend(LvarResultado,LvarMontoImpuesto)>
	<cfset ArrayAppend(LvarResultado,LvarDescuentoSobReclamo)>
	<cfset ArrayAppend(LvarResultado,LvarMontoImptoReclamo)>
	<cfreturn LvarResultado>
</cffunction>

<cffunction name="GetQueryReclamos" returntype="query">
	<cfargument name="Conexion" 	type='string' 	required="no">
	<cfargument name="Ecodigo"		type="numeric" 	required="no">	
    <cfargument name="EDRid"		type="numeric" 	required="yes">	
    <cfargument name="DDRlinea"		type="numeric" 	required="no" default="-1">	
    	
	<cfif NOT ISDEFINED('Arguments.Ecodigo')>
    	<cfset Arguments.Ecodigo = session.Ecodigo>
    </cfif>
    <cfif NOT ISDEFINED('Arguments.Conexion') OR NOT LEN(TRIM(Arguments.Conexion))>
    	<cfset Arguments.Conexion = session.dsn>
    </cfif>

	<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

	<cfquery name="detallesDDRReclamos" datasource="#Arguments.Conexion#">
        select  Coalesce(hedr.EPDid,0) EPDid, 
        		hddr.DDRcantorigen,										<!--- Cantidad factura --->
                hddr.DDRcantrec,										<!--- Cantidad recibida --->
                #LvarOBJ_PrecioU.enSQL_AS("hddr.DDRpreciou")#,			<!--- Precio factura --->
                #LvarOBJ_PrecioU.enSQL_AS("hddr.DDRprecioorig")#,		<!--- Precio orden de compra --->
                coalesce(imp.Iporcentaje, 0) as Iporcentaje,			<!--- Porcentaje impuesto en la factura --->
                hedr.Mcodigo,											<!--- Codigo de la moneda de la factura --->
                coalesce(hddr.DDRdescporclin, 0) as DDRdescporclin,		<!--- Porcentaje descuento en la factura --->
                docm.DOcantidad - docm.DOcantsurtida as DOcantsaldo,	<!--- Cantidad del saldo en la linea de la orden de compra --->
                coalesce(docm.DOporcdesc, 0) as DOporcdesc,				<!--- Porcentaje descuento en la orden de compra --->
                case 
                    when hddr.DDRaprobtolerancia = 10 then 1
                    else 0
                end DDRaprobtolerancia,
                case 
                    when (hddr.DDRgenreclamo = 1)  and 
                        (hddr.DDRaprobtolerancia is null or
                        hddr.DDRaprobtolerancia = 0 or 
                        hddr.DDRaprobtolerancia = 5 or	
                        hddr.DDRaprobtolerancia=20)
                                                then ((coalesce(clas.Ctolerancia, 0) / 100) * (docm.DOcantidad - docm.DOcantsurtida))
                    else 0
                end Ctolerancia,										<!--- Porcentaje de tolerancia del articulo ((coalesce(clas.Ctolerancia, 0) / 100) * docm.DOcantidad as Ctolerancia,)--->
                case when clas.Ctolerancia is null then 'F'
                     else 'V'
                end as ArticuloTieneTolerancia,
                impOC.Iporcentaje as IporcentajeOC,						<!--- Porcentaje de impuesto de la orden de compra --->
                case when docm.Ucodigo = hddr.Ucodigo then 1
                     when cu.CUfactor is not null then cu.CUfactor
                     when cua.CUAfactor is not null then cua.CUAfactor
                     else case when hddr.DDRcantorigen = 0 then 0
                               else hddr.DDRcantordenconv / hddr.DDRcantorigen
                               end
                     end as factorConversionU,							<!--- Factor de conversion (factura a orden) --->
                eocm.EOtc,												<!--- Tipo de cambio en la orden de compra --->
                hedr.EDRtc,												<!--- Tipo de cambio en la factura --->
                eocm.Mcodigo as McodigoOC,								<!--- Codigo de la moneda de la orden de compra asociada --->
                hddr.DDRgenreclamo,										<!--- Indica si la linea genera reclamo --->
                hddr.DDRtipoitem
                
        from EDocumentosRecepcion hedr
            inner join DDocumentosRecepcion hddr
                 on hedr.EDRid   = hddr.EDRid
                and hedr.Ecodigo = hddr.Ecodigo
            inner join DOrdenCM docm		
                 on hddr.DOlinea = docm.DOlinea
            left outer join ConversionUnidades cu					  <!--- Para obtener el factor de conversion de factura a orden --->
                 on cu.Ecodigo    = hddr.Ecodigo
                and cu.Ucodigo    = hddr.Ucodigo
                and cu.Ucodigoref = docm.Ucodigo
            left outer join Impuestos impOC							  <!--- Para obtener el porcentaje de impuesto de la orden de compra --->
                 on impOC.Icodigo = docm.Icodigo
                and impOC.Ecodigo = hddr.Ecodigo
            inner join EOrdenCM eocm
                 on docm.EOidorden = eocm.EOidorden
            left outer join Articulos art
                 on hddr.Aid     = art.Aid
                and hddr.Ecodigo = art.Ecodigo	
            left outer join Clasificaciones clas    				<!--- Para obtener el porcentaje de tolerancia del articulo --->
                 on clas.Ccodigo = art.Ccodigo
                and clas.Ecodigo = hddr.Ecodigo
            left outer join ConversionUnidadesArt cua				<!--- Para obtener factor de conversion de factura a orden si no estaba definido en la tabla ConversionUnidades --->
                 on cua.Aid     = art.Aid
                and art.Ucodigo = hddr.Ucodigo
                and cua.Ucodigo = docm.Ucodigo
                and cua.Ecodigo = hddr.Ecodigo
            left outer join Impuestos imp
                 on hddr.Icodigo = imp.Icodigo
                and hddr.Ecodigo = imp.Ecodigo
          where hedr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            and hddr.EDRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDRid#">
          <cfif isdefined('Arguments.DDRlinea') and Arguments.DDRlinea GT 0>
          	and hddr.DDRlinea = #Arguments.DDRlinea#
          </cfif>
	</cfquery>
    <cfreturn detallesDDRReclamos>
</cffunction>
<cffunction name="CalculoReclamoAuto" returntype="numeric">
 	<cfargument name="Conexion" 	type='string' 	required="no">
	<cfargument name="Ecodigo"		type="numeric" 	required="no">	
    <cfargument name="EDRid"		type="numeric" 	required="yes">	
    <cfargument name="DDRlinea"		type="numeric" 	required="no" default="-1">	
    <cfargument name="modo"			type="string" 	required="yes" default="CAMBIO">
    <cfargument name="LvarTotal"	type="numeric" 	required="no" default="0">		
    
	<cfif NOT ISDEFINED('Arguments.Ecodigo')>
    	<cfset Arguments.Ecodigo = session.Ecodigo>
    </cfif>
    <cfif NOT ISDEFINED('Arguments.Conexion') OR NOT LEN(TRIM(Arguments.Conexion))>
    	<cfset Arguments.Conexion = session.dsn>
    </cfif>
	
    <cfset RSR = GetQueryReclamos(Arguments.Conexion,Arguments.Ecodigo,Arguments.EDRid, Arguments.DDRlinea)>

    <cfloop query="RSR">
    	<cfif RSR.EPDid NEQ 0>
			<cfset totalReclamo = calcularReclamo(RSR.DDRcantorigen, RSR.DDRpreciou, RSR.DDRdescporclin, RSR.Iporcentaje,RSR.DOcantsaldo, RSR.DDRpreciou,
                                                  RSR.DDRdescporclin, RSR.Iporcentaje, RSR.DDRcantrec, RSR.Ctolerancia, RSR.Mcodigo, RSR.McodigoOC,
                                                  RSR.EDRtc, RSR.EOtc, RSR.factorConversionU, RSR.DDRtipoitem, RSR.ArticuloTieneTolerancia,
                                                  RSR.EPDid,RSR.DDRaprobtolerancia)>
		<cfelse>
			<cfset totalReclamo = calcularReclamo(RSR.DDRcantorigen, RSR.DDRpreciou, RSR.DDRdescporclin, RSR.Iporcentaje, RSR.DOcantsaldo, RSR.DDRprecioorig,
                                                  RSR.DOporcdesc, RSR.IporcentajeOC, RSR.DDRcantrec, RSR.Ctolerancia, RSR.Mcodigo, RSR.McodigoOC,
                                                  RSR.EDRtc, RSR.EOtc, RSR.factorConversionU,  RSR.DDRtipoitem, RSR.ArticuloTieneTolerancia,
                                                  RSR.EPDid, RSR.DDRaprobtolerancia)> 
		</cfif>                           
			<cfset LvarTotal = LvarTotal + totalReclamo[1]>
	</cfloop>
    <cfreturn LvarTotal>
</cffunction>
