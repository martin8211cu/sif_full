<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la interfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cancelación. --->
<!--- Comprobaciones de Ordenes y Solcitudes de Pago --->
    <cfquery name="readIE711" datasource="sifinterfaces">
    	select a.SecOrden
        from IE711 a
        where not exists (select 1 
        				  from ID711 b
                          where b.ID = a.ID
                          and b.SecOrden = a.SecOrden
        				  )
        and a.ID = #GvarID#
    </cfquery>
    <cfif readIE711.recordcount gt 0>
    	<cfthrow message="Existen Ordenes de Pago sin Solicitudes de Pago relacionadas. Proceso Cancelado!">
    </cfif>
    
    <!--- Comprobaciones de Detalles de Pago --->
	<cfquery name="readIS711" datasource="sifinterfaces">
    	select a.SecSolicitud
        from ID711 a
        where not exists (select 1 
        				  from IS711 b
                          where b.ID = a.ID
                          and b.SecOrden = a.SecOrden
                          and b.SecSolicitud = a.SecSolicitud
        				  )
        and a.ID = #GvarID#
    </cfquery>
    <cfif readIS711.recordcount gt 0>
    	<cfthrow message="Existen Solicitudes de Pago sin Detalles de Pago relacionadas. Proceso Cancelado!">
    </cfif>
<cftransaction isolation="read_uncommitted">
	
	<!--- Lee encabezado la tabla IE711 (Obtener las Ordenes de Pago) --->
	<cfquery name="readInterfaz711" datasource="sifinterfaces">
		select	E.ID,
        		coalesce(EcodigoPago,0) as EcodigoPago,
                E.TEScodigo,
                E.SNcodigo,
                E.TESOPfechaPago,         
                E.CBcodigoPago,                                       
                E.TESMPcodigo, 
                E.TESTPcuentab,                                                                                         
                E.TESOPobservaciones,                                                                                                                                                                                                                                              
                E.GeneraOP,
                E.SecOrden,
                coalesce(EcodigoOri,0) as EcodigoOri
			from IE711 E
            inner join ID711 D
            on D.SecOrden = E.SecOrden
            and D.ID = E.ID
			where E.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
            order by E.SecOrden
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz711.recordcount eq 0>
		<cfthrow message="Error en Interfaz 711. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>	
    <cfquery name="rsOutput" datasource="sifinterfaces">
		select 1
		from OE711
		where ID = #GvarID#
	</cfquery>
	<cfif rsOutput.recordCount GT 0>
		<cfthrow message="Los datos de Entrada para el ID='#GvarID#' en la Interfaz 711=Orden de Pago, fueron procesados previamente, no pueden ser reprocesados.">
	</cfif>	
</cftransaction>

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar. --->
<!--- Invoca Componente de Procesamiento de Interfaz 711. --->
<cfinvoke component="interfacesSoin.Componentes.TES_OrdenPago" method="process" returnvariable="MSG" 
query="#readInterfaz711#"/>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
