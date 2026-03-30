<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		select 
			  a.ID
			, a.ModuloOrigen
			, a.ModuloDestino
			, (( select count(1) from ID12 b where b.ID = a.ID )) as RegistrosDetalle
			, (( select count(1) from ID12 b where b.ID = a.ID and b.Modulo = 'CC' )) as RegistrosDetalleCxC
            ,TipoNeteo
            ,TipoNeteoDocs
		from IE12 a
		where a.ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 12=Aplicación de Notas de Crédito o Anticipos">
	</cfif>
</cftransaction>
<cfif rsInput.RegistrosDetalle EQ 0 and (Trim(rsInput.ModuloOrigen) NEQ "CC" or Trim(rsInput.ModuloOrigen) NEQ Trim(rsInput.ModuloDestino))>
	<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 12=Aplicación de Notas de Crédito o Anticipos">
</cfif>

<cfset LvarNotaCreditoCxCDirecta = false>
<cfset LvarNotaCreditoCxCMultiple = false>

<cfif Trim(rsInput.ModuloOrigen) EQ "CC" and (Trim(rsInput.ModuloOrigen) EQ Trim(rsInput.ModuloDestino) or rsInput.RegistrosDetalleCxC GT 0 )>
	<cfif rsInput.RegistrosDetalle EQ 0>
		<cfset LvarNotaCreditoCxCDirecta = true>
	<cfelseif rsInput.RegistrosDetalle EQ rsInput.RegistrosDetalleCxC>
		<cfset LvarNotaCreditoCxCMultiple = true>
	</cfif>
</cfif>

<cfif LvarNotaCreditoCxCDirecta or LvarNotaCreditoCxCMultiple and 1 EQ 2>

	<cfif LvarNotaCreditoCxCDirecta>
		<cftransaction isolation="read_uncommitted">
			<cfquery name="rsInput" datasource="sifinterfaces">
				select 
					  a.ID 
					, a.EcodigoSDC
					, a.ModuloOrigen 			as ModuloOrigen
					, a.CodigoMonedaOrigen
					, a.NumeroSocioDocOrigen
					, a.FechaAplicacion
					, a.TipoCambio
					, a.TransaccionOrigen
					, a.BMUsucodigo
					, a.CodigoTransacionOrig
					, a.DocumentoOrigen
					, a.MontoOrigen

					, a.ModuloDestino          as Modulo        
					, a.CodigoMonedaDestino            
					, a.NumeroSocioDocDestino  as NumeroSocioDoc
					, a.CodigoTransacionDest   as CodigoTransaccion
					, a.DocumentoDestino       as Documento
					, a.CodigoMonedaDestino
					, a.MontoDestino           as Monto
					, a.MontoOrigen			   as MontoNC
                    , a.TipoNeteo
            		, a.TipoNeteoDocs
				from IE12 a
				where a.ID = #GvarID#
			</cfquery>
		</cftransaction>
	</cfif>

	<cfif LvarNotaCreditoCxCMultiple>
		<cftransaction isolation="read_uncommitted">
			<cfquery name="rsInput" datasource="sifinterfaces">
				select 
					  a.ID 
					, a.EcodigoSDC
					, a.ModuloOrigen 			as ModuloOrigen
					, a.CodigoMonedaOrigen
					, a.NumeroSocioDocOrigen
					, a.FechaAplicacion
					, a.TipoCambio
					, a.TransaccionOrigen
					, a.BMUsucodigo
					, a.CodigoTransacionOrig
					, a.DocumentoOrigen
					, a.MontoOrigen
					
					, b.NumeroSocioDoc
					, b.Modulo
					, b.CodigoTransaccion
					, b.Documento
					, b.CodigoMoneda as CodigoMonedaDestino
					, coalesce(b.Monto, 0.00)				as Monto
					, coalesce(b.MontoNC, 0.00) 			as MontoNC
                    , a.TipoNeteo
            		, a.TipoNeteoDocs
				from IE12 a
					inner join ID12 b
					on b.ID = a.ID
				where a.ID = #GvarID#
			</cfquery>
		</cftransaction>
	</cfif>
	
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 12=Aplicación de Notas de Crédito o Anticipos">
	</cfif>

	<cftransaction>

		<!--- Inicializa el componente de interfaz de Neteo de Documentos de CxC y CxP --->
		<cfset LobjControl = createObject("component","interfacesSoin.Componentes.CC_InterfazAplicaCredito")>
		<cfset LobjControl.init(rsInput.EcodigoSDC)>
	
		<cfoutput query="rsInput" group="ID">
			<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
			<cfif LvarNotaCreditoCxCDirecta >
				<!--- Validar que las dos Monedas sean iguales --->
				<cfset LobjControl.validaMonedas(rsInput.CodigoMonedaOrigen, rsInput.CodigoMonedaDestino)>
			</cfif>
			<!--- Validar que los dos Modulos pertenezcan a CxC o CxP --->
			<cfset LobjControl.validaModulos(rsInput.ModuloOrigen, rsInput.Modulo)>
			<!--- Insertar el Encabezado --->
			<cfset LvarID = LobjControl.Alta_DocumentoFavor(rsInput.ModuloOrigen, rsInput.CodigoMonedaOrigen, rsInput.CodigoTransacionOrig, rsInput.DocumentoOrigen, rsInput.NumeroSocioDocOrigen, rsInput.FechaAplicacion, rsInput.MontoOrigen)>
			<cfoutput>
				<!--- Insertar los detalles --->
				<cfset LobjControl.Alta_DocumentoDet(rsInput.ModuloOrigen, rsInput.CodigoTransacionOrig, rsInput.DocumentoOrigen, rsInput.NumeroSocioDoc, rsInput.CodigoTransaccion, rsInput.Documento,rsInput.CodigoMonedaDestino, rsInput.Monto, rsInput.MontoNC)>
			</cfoutput>
		</cfoutput>       
	</cftransaction>
	<!--- Aplicar el Documento de Neteo --->
	<!---<cfset LobjControl.Aplica_Documento(LvarID)>--->

<cfelse>

	<cftransaction isolation="read_uncommitted">
		<cfquery name="rsInput" datasource="sifinterfaces">
			select 
				  a.ID 
				, a.EcodigoSDC
				, a.CodigoMonedaOrigen
				, a.NumeroSocioDocOrigen
				, a.FechaAplicacion
				, a.TipoCambio
				, a.TransaccionOrigen
				, a.BMUsucodigo
                , a.CodigoMonedaDestino
                , a.TipoNeteo
            	, a.TipoNeteoDocs
                , a.ModuloOrigen 			
				
				, b.NumeroSocioDoc
				, b.Modulo
				, b.CodigoTransaccion
				, b.Documento
				, b.Monto
                
			from IE12 a
				inner join ID12 b
				on b.ID = a.ID
			where a.ID = #GvarID#
		</cfquery>
        
        
        
	</cftransaction>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 12=Aplicación de Notas de Crédito o Anticipos">
	</cfif>

	<cftransaction>

		<!--- Inicializa el componente de interfaz de Neteo de Documentos de CxC y CxP --->
		<cfset LobjControl = createObject("component","interfacesSoin.Componentes.CM_InterfazNeteo")>
		<cfset LobjControl.init(rsInput.EcodigoSDC)>
	
		<cfoutput query="rsInput" group="ID">
			<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
			<!--- Validar que las dos Monedas sean iguales --->
			<!--- <cfset LobjControl.validaMonedas(rsInput.CodigoMonedaOrigen, rsInput.CodigoMonedaDestino)> --->
			<!--- Validar que los dos Modulos pertenezcan a CxC o CxP --->
			<!--- <cfset LobjControl.validaModulos(rsInput.ModuloOrigen, rsInput.ModuloDestino)> --->
			<!--- Insertar el Encabezado --->
			<cfset LvarID = LobjControl.Alta_DocNeteo(rsInput.CodigoMonedaOrigen, rsInput.TransaccionOrigen, rsInput.NumeroSocioDocOrigen, rsInput.FechaAplicacion, 'Generado por Interfaz de Neteo/Aplicación de Notas de Crédito o Anticipos', rsInput.TipoNeteo, rsInput.TipoNeteoDocs)>
			<cfoutput>
				<!--- Insertar los detalles --->
				<cfset LobjControl.Alta_DocNeteoDet(rsInput.Modulo, LvarID, rsInput.CodigoTransaccion, rsInput.NumeroSocioDoc, rsInput.Monto, rsInput.Documento, rsInput.CodigoMonedaDestino,rsInput.TransaccionOrigen)>
			</cfoutput>
		</cfoutput>

		<!--- Se obtiene el Período de Presupuesto --->
        <cfset LvarHoy= now()>
        <cfset anno = #datepart("yyyy",LvarHoy)#>
        <cfset mes = #datepart("m",LvarHoy)#>
		<cfset rsSQL = createobject("component","sif.Componentes.PRES_Presupuesto").rsCPresupuestoPeriodo(rsInput.EcodigoSDC, rsInput.ModuloOrigen, LvarHoy, anno, mes)>
		<cfif rsSQL.CPPid EQ "">
			<!---Si no maneja presupuesto no se debe hacer la validacion de los tipos de neteo--->
        <cfelse>
			<cfset LvarTipoNeteoMSG = "">
            <cfset LvarTipoNeteoDocs = #rsInput.TipoNeteoDocs#>
            <cfif LvarTipoNeteoDocs EQ 0>
                <cfset LvarTipoNeteoDocs = createobject("component","sif.Componentes.CC_AplicaDocumentoNeteo").DeterminarTipoNeteoDocs(#LvarID#)>
                <cfif LvarTipoNeteoDocs EQ -1>
                    <cfset LvarTipoNeteoMSG = "Hay una mezcla de Tipos de Documento incorrecta">
                </cfif>
            <cfelse>
                <cfset LvarTipoNeteoMSG = createobject("component","sif.Componentes.CC_AplicaDocumentoNeteo").VerificarTipoNeteoDocs(#LvarID#)>
            </cfif>
            
            <cfif LvarTipoNeteoMSG NEQ "">
                <cfthrow message="#LvarTipoNeteoMSG#">
            </cfif>
        </cfif>
	</cftransaction>
   
	<!--- Aplicar el Documento de Neteo --->
	<cfset LobjControl.Aplica_Documento(LvarID)>

</cfif>
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

