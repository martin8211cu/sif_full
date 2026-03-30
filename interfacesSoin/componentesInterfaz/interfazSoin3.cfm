<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select 
			ID
			, CodigoCategoria
			, DescripcionCategoria
			, VidaUtil
			, VidaUtilPorCategoria
			, MetodoDepreciacion
			, MascaraPlaca
			, ComplementoCtaF
			, Imodo
			, BMUsucodigo
			, ts_rversion	
		from IE3
		where ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 3=Registro de Categorias de Articulos">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con solicitudes --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazCatActivos")>
	<cfset LobjControl.init()>
	<cfoutput query="rsInput">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>		
		<cfif trim(Imodo) EQ 'A'>		
			<!--- Alta de Categorias de Articulos --->
			<cfset LobjControl.Alta_CatActivos(
				CodigoCategoria,
				DescripcionCategoria,
				VidaUtil,
				VidaUtilPorCategoria,				
				MetodoDepreciacion,				
				MascaraPlaca,
				ComplementoCtaF)>											
		<cfelseif trim(Imodo) EQ 'B'>			
			<!--- Baja de Categorias de Articulos --->	
			<cfset LobjControl.Baja_CatActivos(
				CodigoCategoria)>							
		<cfelseif trim(Imodo) EQ 'C'>			
			<!--- Cambio de Categorias de Articulos --->	
			<cfset LobjControl.Cambio_CatActivos(
				CodigoCategoria,
				DescripcionCategoria,
				VidaUtil,
				VidaUtilPorCategoria,
				MetodoDepreciacion,				
				MascaraPlaca,
				ComplementoCtaF)>					
		</cfif>
	</cfoutput>
</cftransaction>

<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
