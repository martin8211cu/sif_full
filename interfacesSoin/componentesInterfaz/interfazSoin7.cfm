<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<cfset bandera = false>
<cfset banderaImp = false>
<cfset contImp = 0>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
				select 
					IE7.ID, 
					IE7.TipoDocumento, 
					IE7.CodigoMoneda, 
					IE7.TipoCambio, 
					IE7.CodigoAlmacen, 
					IE7.CodigoProveedor, 
					IE7.CodigoCentroFuncional, 
					IE7.CodigoTransaccion, 
					IE7.FechaDocumento, 
					IE7.FechaRecepcion, 
					IE7.DocumentoReferencia, 
					IE7.TotalDescuento, 
					IE7.TotalImpuestos, 
					IE7.Observaciones, 
					IE7.Periodo, 
					IE7.Mes, 
					IE7.Imodo, 
					IE7.NumeroDocRecepcion, 
					ID7.ID as IDb,
					ID7.NumeroOrdenCompra, 
					ID7.LineaOrdenCompra, 
					ID7.LineaDocRecepcion, 
					ID7.CodigoUnidadMedida,  
					ID7.CodigoArticulo, 
					ID7.CodigoServicio, 
					ID7.TipoItem, 
					ID7.CantidadRecibida,
					#LvarOBJ_PrecioU.enSQL_AS("ID7.PrecioUnitario")#,
					ID7.DescuentoLinea,
					ID7.TotalLinea 
				from IE7
				left outer join ID7 on ID7.ID = IE7.ID
				where IE7.ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 7=Registro y Cancelación de Recepciones">
	</cfif>
	<cfif len(trim(rsInput.IDb)) EQ 0 and rsInput.Imodo EQ 'A'>
		<cfthrow message="No existen detalles en los datos de Entrada para el ID='#GvarID#' en la Interfaz 7=Registro y Cancelación de Recepciones">
	</cfif>
	<cfquery name="rsOutput" datasource="sifinterfaces">
		select 1
		from EO7
		where ID = #GvarID#
	</cfquery>
	<cfif rsOutput.recordCount GT 0>
		<cfthrow message="Los datos de Entrada para el ID='#GvarID#' en la Interfaz 7=Registro y Cancelación de Recepciones, fueron procesados previamente, no pueden ser reprocesados.">
	</cfif>
</cftransaction>


<!--- Inicializa el componente de interfaz con recepcion --->
<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazRecepcion")>
<cfset LobjControl.init()>

<cfoutput query="rsInput" group="ID">
	<cfoutput>
		<cfset contImp = contImp + LobjControl.validaImp_EDocumentosRecepcion(
												NumeroOrdenCompra, 
												LineaOrdenCompra,
												CantidadRecibida,
												PrecioUnitario)>
												
	</cfoutput>
</cfoutput>

<cfif contImp EQ rsInput.TotalImpuestos>
	<cfset  banderaImp = true>
</cfif>		

	
<cfif banderaImp>
	<cftransaction>
		<cfoutput query="rsInput" group="ID">
			<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
					<cfif trim(Imodo) EQ 'A'>
						<!--- Alta de recepcion --->
						<cfset recepcion = LobjControl.Alta_EDocumentosRecepcion(
							TipoDocumento, 
							CodigoMoneda, 
							TipoCambio, 
							CodigoAlmacen, 
							CodigoCentroFuncional, 
							CodigoTransaccion, 
							FechaDocumento, 
							FechaRecepcion, 
							DocumentoReferencia, 
							TotalDescuento, 
							TotalImpuestos, 
							Observaciones, 
							Periodo, 
							Mes,
							NumeroOrdenCompra,
							CodigoProveedor)>
						<!--- Alta de detalles de la recepcion --->
						<cfoutput>
							<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
									<cfset drecepcion = LobjControl.Alta_DDocumentosRecepcion(
										recepcion.EDRid, 
										CodigoUnidadMedida, 
										NumeroOrdenCompra, 
										LineaOrdenCompra, 
										TipoItem, 
										CodigoArticulo, 
										CodigoServicio, 
										CantidadRecibida, 
										PrecioUnitario, 
										DescuentoLinea, 
										TotalLinea)>
						</cfoutput>
						<cfset QuerySetCell(rsInput,"NumeroDocRecepcion",recepcion.EDRnumero,CurrentRow)>
						<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
						<cfset aplicacion = false>
						<!--- Aplicacion de los documentos de recepcion --->
						<cfset aplicacion = LobjControl.Aplica_Recepcion(
							NumeroOrdenCompra, 
							LineaOrdenCompra,
							CodigoUnidadMedida, 
							recepcion.EDRid,
							TipoDocumento)>
						
						<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
					<cfelseif trim(Imodo) EQ 'B'>
						<!--- Cancela solicitud --->
						<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
						<cfset result = LobjControl.Baja_DDocumentosRecepcion(NumeroDocRecepcion)>
					</cfif>
		</cfoutput>
		
		<cfset bandera = true>
	</cftransaction>	
<cfelse>
	<cfthrow message="Error al aplicar documento de Recepci&oacute;n.<br>La Suma de los montos por impuestos de las líneas no suma la cantidad ingresada en el encabezado de la Recepci&oacute;n. contImp -- #contImp# rsInput.TotalImpuestos -- #rsInput.TotalImpuestos#">
</cfif>
	

<cfif bandera EQ true>
	<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
	
	<cfoutput query="rsInput" group="ID">
		<cfquery datasource="sifinterfaces">
			insert into EO7
			(ID,NumeroDocRecepcion,EstadoDocumento,BMUsucodigo)
			values
			(#ID#,
			'#NumeroDocRecepcion#',
			<cfif aplicacion EQ 1>
				10,	
			<cfelse>
				0,
			</cfif>
			#Request.CM_InterfazSolicitudes.GvarUsucodigo#)
		</cfquery>
	</cfoutput>
</cfif>
