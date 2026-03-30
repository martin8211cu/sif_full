<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la interfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cancelación. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y Detalles de las tablas IE707 y ID707. --->
	<cfquery name="readInterfaz707" datasource="sifinterfaces">
		select	E.ID,
                E.Ecodigo,
                E.BTcodigo,
                E.CBcodigo,
                E.EMtipocambio,
                E.EMdocumento,          
                E.EMtotal,                    
                E.EMreferencia,              
                E.EMfecha,                
                E.EMdescripcion,                                                                                                            
                E.TipoSocio,   
                E.EMAplicar, 
              	D.Ecodigo as EcodigoD,     
                D.DMmonto,                    
                D.DMdescripcion,                                                                                                            
                D.CFcodigo,   
                D.CFformato  <!---Fomarto de la cuenta--->                                                                                           
			from IE707 E
			inner join ID707 D on D.ID = E.ID
			where E.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
            
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz707.recordcount eq 0>
		<cfthrow message="Error en Interfaz 707. No existen datos de Entrada para <!-- -->el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
	
	<!---Valida Montos--->
		<cfquery name ="rsTotalEnc" datasource="sifinterfaces">
			select EMtotal
			from IE707 
			where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
		</cfquery>
			
		<cfquery name ="rsTotalDet" datasource="sifinterfaces">
			select sum(DMmonto) as MontoDet
			from ID707 
			where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
		</cfquery>
			
		<cfif rsTotalEnc.recordcount EQ 0 or rsTotalDet.recordcount EQ 0 or rsTotalEnc.EMtotal NEQ 
		rsTotalDet.MontoDet>
			<cfthrow message="El total del documento no puede ser diferente a la suma de los montos del detalle del movimiento">
		</cfif>
			
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar. --->
<!--- Invoca Componente de Procesamiento de Interfaz 10. --->
<cfinvoke component="interfacesSoin.Componentes.CB_MovimientosBancarios" method="process" returnvariable="MSG" 
query="#readInterfaz707#"/>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
