<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<cfset bandera = false>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
				select IE6.ID,
					IE6.NumeroSolicitud,
					IE6.CodigoCentroFuncional,
					IE6.CodigoSolicitante,
					IE6.TipoSolicitud,
					IE6.CodigoMoneda,
					IE6.TipoCambio,
					IE6.FechaSolicitud,
					IE6.Observaciones,
					IE6.TipoOrdenCompra,
					IE6.Retencion,
					IE6.CodigoProveedor,
					IE6.PlazoCredito,
					IE6.PorcentajeAnticipo,
					IE6.TotalEstimado,
					IE6.Imodo,
					IE6.BMUsucodigo,
					ID6.ID as IDb,
					ID6.TipoBien,
					ID6.CodigoArticulo,
					ID6.CodigoAlmacen,
					ID6.CodigoServicio,
					ID6.CodigoCategoria,
					ID6.CodigoClase,
					ID6.CantidadSolicitada,
					ID6.CodigoImpuesto,
					ID6.CodigoUnidadMedida,
					ID6.DescripcionBien,
					ID6.DescripcionAlterna,
					ID6.Observaciones as ObservacionesDet,
					ID6.CodigoCentroFuncional as CFcodigo_detalle,
					ID6.PrecioUnitario,
					ID6.TotalLinea,
					ID6.FechaRequerida,
					ID6.BMUsucodigo,
					ID6.CuentaFinanciera,
					null as NAP,
					null as NRP,
					null as NAPcancelacion,
					null as EstadoResultante
				from IE6
				left outer join ID6 on ID6.ID = IE6.ID
				where IE6.ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 6=Registro y Aplicacion de Solicitudes de Compra">
	</cfif>
	<cfif len(trim(rsInput.IDb)) EQ 0 and rsInput.Imodo EQ 'A'>
		<cfthrow message="No existen detalles en los datos de Entrada para el ID='#GvarID#' en la Interfaz 6=Registro y Aplicacion de Solicitudes de Compra">
	</cfif>
	<cfquery name="rsOutput" datasource="sifinterfaces">
		select 1
		from OE6
		where ID = #GvarID#
	</cfquery>
	<cfif rsOutput.recordCount GT 0>
		<cfthrow message="Los datos de Entrada para el ID='#GvarID#' en la Interfaz 6=Registro y Aplicacion de Solicitudes de Compra, fueron procesados previamente, no pueden ser reprocesados.">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con solicitudes --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazSolicitudes")>
	<cfset LobjControl.init()>
	<cfoutput query="rsInput" group="ID">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		<cfif trim(Imodo) EQ 'A'>
			<!--- Alta de solicitud --->
			<cfset solicitud = LobjControl.Alta_ESolicitudCompraCM(
				CodigoCentroFuncional,
				CodigoSolicitante,
				TipoSolicitud,
				CodigoMoneda,
				TipoCambio,
				FechaSolicitud,
				Observaciones,
				TipoOrdenCompra,
				Retencion,
				CodigoProveedor,
				PorcentajeAnticipo,
				PlazoCredito)>
				
			<!--- Alta de detalles de la solicitud --->
			<cfoutput>
				<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
					<cfset dsolicitud = LobjControl.Alta_DSolicitudCompraCM(
							solicitud.ESidsolicitud,
							solicitud.ESnumero,
							CantidadSolicitada,
							CodigoImpuesto,
							CodigoUnidadMedida,
							DescripcionBien,
							DescripcionAlterna,
							ObservacionesDet,
							PrecioUnitario,
							TipoBien,
							CodigoArticulo,
							CodigoAlmacen,
							CodigoServicio,
							CodigoCategoria,
							CodigoClase,
							TotalLinea,
							FechaRequerida,
							CFcodigo_detalle,
							CodigoSolicitante,
							CuentaFinanciera,
							FechaSolicitud)>
			</cfoutput>
			<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
			<cfset QuerySetCell(rsInput,"NumeroSolicitud",solicitud.ESnumero,CurrentRow)>
			<cfset QuerySetCell(rsInput,"EstadoResultante","R",CurrentRow)>
		<cfelseif Imodo EQ 'B'>
			<!--- Cancela solicitud --->
			<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
			<cfset result = LobjControl.Cancelacion_ESolicitudCompraCM(
				NumeroSolicitud,
				Observaciones,
				CodigoSolicitante)>
			<cfset QuerySetCell(rsInput,"NAPcancelacion",result,CurrentRow)>
			<cfset QuerySetCell(rsInput,"EstadoResultante","C",CurrentRow)>
		</cfif>
	</cfoutput>

	<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>	
	
	<cfoutput query="rsInput" group="ID">
		<cfif Imodo EQ 'A'>
			<cfset LvarNAP = LobjControl.Aplica_ESolicitudCompraCM(solicitud.ESidsolicitud)>
			<cfif IsNumeric(LvarNAP) and LvarNAP GTE 0>
				<cfset QuerySetCell(rsInput,"NAP",abs(LvarNAP),CurrentRow)>
				<cfset QuerySetCell(rsInput,"EstadoResultante","A",CurrentRow)>
			<cfelseif IsNumeric(LvarNAP)>
				<cfset QuerySetCell(rsInput,"NRP",abs(LvarNAP),CurrentRow)>
			</cfif>
		</cfif>
	</cfoutput>	
	
	<cfset bandera = true>	
</cftransaction>

<!--- Existe un NRP, se registra de nuevo pero con el valor del NRP y se guarda en el encabezado de la solicitud --->
<cfif isdefined('LvarNAP') and IsNumeric(LvarNAP) and LvarNAP LT 0>
	<cftransaction>
		<cfoutput query="rsInput" group="ID">
			<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
			<cfif trim(Imodo) EQ 'A'>
				<!--- Alta de solicitud --->
				<cfset solicitud = LobjControl.Alta_ESolicitudCompraCM(
					CodigoCentroFuncional,
					CodigoSolicitante,
					TipoSolicitud,
					CodigoMoneda,
					TipoCambio,
					FechaSolicitud,
					Observaciones,
					TipoOrdenCompra,
					Retencion,
					CodigoProveedor,
					PorcentajeAnticipo,
					PlazoCredito,
					LvarNAP)>
				<!--- Alta de detalles de la solicitud --->
				<cfoutput>
					<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
						<cfset dsolicitud = LobjControl.Alta_DSolicitudCompraCM(
								solicitud.ESidsolicitud,
								solicitud.ESnumero,
								CantidadSolicitada,
								CodigoImpuesto,
								CodigoUnidadMedida,
								DescripcionBien,
								DescripcionAlterna,
								ObservacionesDet,
								PrecioUnitario,
								TipoBien,
								CodigoArticulo,
								CodigoAlmacen,
								CodigoServicio,
								CodigoCategoria,
								CodigoClase,
								TotalLinea,
								FechaRequerida,
								CodigoCentroFuncional,
								CodigoSolicitante,
								CuentaFinanciera,
								FechaSolicitud)>
				</cfoutput>
				<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
				<cfset QuerySetCell(rsInput,"NumeroSolicitud",solicitud.ESnumero,CurrentRow)>
				<cfset QuerySetCell(rsInput,"EstadoResultante","R",CurrentRow)>
			<cfelseif Imodo EQ 'B'>
				<!--- Cancela solicitud --->
				<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
				<cfset result = LobjControl.Cancelacion_ESolicitudCompraCM(
					NumeroSolicitud,
					Observaciones,
					CodigoSolicitante)>
				<cfset QuerySetCell(rsInput,"NAPcancelacion",result,CurrentRow)>
				<cfset QuerySetCell(rsInput,"EstadoResultante","C",CurrentRow)>
			</cfif>
		</cfoutput>
		
		<cfset bandera = true>		
	</cftransaction>	
</cfif>

<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfif bandera EQ true>
	<cfoutput query="rsInput" group="ID">
		<cfquery datasource="sifinterfaces">
			insert into OE6
			(ID,NumeroSolicitud,NAP,NRP,NAPcancelacion,EstadoResultante,BMUsucodigo)
			values
			(#ID#,
			#NumeroSolicitud#,
			<cfif NAP GT 0>#NAP#<cfelse>null</cfif>,
			<cfif NRP GT 0>#NRP#<cfelse>null</cfif>,
			<cfif NAPcancelacion GT 0>#NAPcancelacion#<cfelse>null</cfif>,
			'#EstadoResultante#',
			#Request.CM_InterfazSolicitudes.GvarUsucodigo#)
		</cfquery>
	</cfoutput>
</cfif>
