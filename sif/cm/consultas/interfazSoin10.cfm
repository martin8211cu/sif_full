<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cftransaction isolation="read_uncommitted">
	<cfquery name="rsData" datasource="sifinterfaces">
		select IE10.ID, 
			   IE10.EcodigoSDC, 
			   IE10.NumeroSocio, 
			   IE10.Modulo, 
			   IE10.CodigoTransacion, 
			   IE10.Documento, 
			   IE10.Estado, 
			   IE10.CodigoMoneda, 
			   IE10.FechaDocumento, 
			   IE10.FechaVencimiento, 
			   IE10.Facturado, 
			   IE10.Origen, 
			   IE10.VoucherNo, 
			   IE10.CodigoRetencion, 
			   IE10.CodigoOficina, 
			   IE10.BMUsucodigo,
			   ID10.ID as IDdetalle, 
			   ID10.Consecutivo, 
			   ID10.TipoItem, 
			   ID10.CodigoItem, 
			   ID10.NombreBarco, 
			   ID10.FechaHoraCarga, 
			   ID10.FechaHoraSalida, 
			   #LvarOBJ_PrecioU.enSQL_AS("ID10.PrecioUnitario")#,
			   ID10.CodigoUnidadMedida, 
			   ID10.CantidadTotal, 
			   ID10.CantidadNeta, 
			   ID10.CodEmbarque, 
			   ID10.NumeroBOL, 
			   ID10.FechaBOL, 
			   ID10.TripNo, 
			   ID10.ContractNo, 
			   ID10.CodigoImpuesto,
			   ID10.ImporteImpuesto,
			   ID10.ImporteDescuento,
   			   ID10.CodigoAlmacen,
   			   ID10.CodigoDepartamento,
			   ID10.BMUsucodigo
		from IE10
		
		left outer join ID10 
		on ID10.ID = IE10.ID

		where IE10.ID = 3
	</cfquery>
	<cfif rsData.recordCount EQ 0>
		<cf_errorCode	code = "50268" msg = "No existen datos de Entrada para el ID=3 en la Interfaz 10=Intercambio de información de CC y CP">
	</cfif>
	<cfif len(trim(rsData.IDdetalle)) EQ 0 >
		<cf_errorCode	code = "50269" msg = "No existen detalles en los datos de Entrada para el ID=3 en la Interfaz 10=Intercambio de información de CC y CP">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con CC/CP --->
	<cfset LobjControl = createObject( "component","sif.cm.consultas.CPCC_InterfazDocumentos")>
	<cfset LobjControl.init(rsData.EcodigoSDC)>

	<cfoutput query="rsData" group="ID">
		
		<cfif trim(rsData.Modulo) eq 'CC' or trim(rsData.Modulo) eq 'CP'>
			<!--- Alta de Documentos --->
			<cfset LvarID = LobjControl.insertar_Documento( rsData.EcodigoSDC, 
															rsData.NumeroSocio, 
															rsData.Modulo, 
															rsData.CodigoTransacion, 
															rsData.Documento, 
															rsData.Estado, 
															rsData.CodigoMoneda, 
															LSDateFormat(rsData.FechaDocumento,'dd/mm/yyyy'), 
															LSDateFormat(rsData.FechaVencimiento,'dd/mm/yyyy'), 
															rsData.VoucherNo, 
															rsData.CodigoRetencion, 
															rsData.CodigoOficina,
															'insertar_Documento' )>
				
			<!--- Alta de detalles de documentos --->
			<cfoutput>
				<cfset detalle = LobjControl.insertar_DetallesDocumento( LvarID,
																		 rsData.Modulo,
																		 rsData.TipoItem, 
																		 rsData.CodigoItem, 
																		 rsData.NombreBarco, 
																		 rsData.PrecioUnitario, 
																		 rsData.CodigoUnidadMedida, 
																		 rsData.CantidadTotal, 
																		 rsData.CantidadNeta, 
																		 rsData.CodEmbarque, 
																		 rsData.NumeroBOL, 
																		 LSDateFormat(rsData.FechaBOL,'dd/mm/yyyy'), 
																		 rsData.TripNo, 
																		 rsData.ContractNo, 
																		 rsData.CodigoImpuesto,
																		 rsData.ImporteImpuesto,
																		 rsData.ImporteDescuento,
																		 rsData.CodigoAlmacen,
																		 rsData.CodigoDepartamento,
																		 'insertar_DetallesDocumento' )>
			</cfoutput>
			
			<cfset LobjControl.actualizarEncabezado(rsData.Modulo, LvarID, 'insertar_DetallesDocumento') >
			<cfset LobjControl.aplicaDocumento(rsData.Modulo, LvarID, 'insertar_DetallesDocumento') >
			
		<cfelse>
			<cf_errorCode	code = "50270"
							msg  = "El valor para el campo módulo ( @errorDat_1@ ) es inválido en la Interfaz 10=Intercambio de información de CC y CP"
							errorDat_1="#rsData.Modulo#"
			>
		</cfif>
	</cfoutput>
</cftransaction>


