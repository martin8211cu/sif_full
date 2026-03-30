<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select 
			ID
			, CodigoCategoria
			, CodigoClase
			, DescripcionClase
			, VidaUtil
			, Depreciable
			, Revaluable
			, CtaSuperavit
			, CtaAdquisicion
			, CtaRevaluacion
			, CtaDepreciacionAcumRev
			, CtaDepreciacionAcum
			, TipoValorResidual
			, ValorResidual
			, ComplementoCtaF
			, Imodo
			, BMUsucodigo
			, ts_rversion
		from IE4
		where ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 4=Registro de clases de Activos">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con clases de activos --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazClaActivos")>
	<cfset LobjControl.init()>
	<cfoutput query="rsInput">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>		
		<cfif trim(Imodo) EQ 'A'>							
			<!--- Alta de Clases de Activos --->
			<cfset LobjControl.Alta_ClaActivos(
				CodigoCategoria,
				CodigoClase,
				DescripcionClase,
				VidaUtil,
				Depreciable,
				Revaluable,
				CtaSuperavit,
				CtaAdquisicion,
				CtaDepreciacionAcum,
				CtaRevaluacion,
				CtaDepreciacionAcumRev,
				TipoValorResidual,
				ValorResidual,
				ComplementoCtaF)>		
		<cfelseif trim(Imodo) EQ 'B'>
			<!--- Baja de Clasificaciones de Articulos 
			<cfset LobjControl.Baja_ClaActivos(
				CodigoCategoria,
				CodigoClase)>			
																	--->	
		<cfelseif trim(Imodo) EQ 'C'>
			<!--- Cambio de Clasificaiones de Articulos --->	
			<cfset LobjControl.Cambio_ClaActivos(
				CodigoCategoria,
				CodigoClase,
				DescripcionClase,
				VidaUtil,
				Depreciable,
				Revaluable,
				CtaSuperavit,
				CtaAdquisicion,
				CtaDepreciacionAcum,
				CtaRevaluacion,
				CtaDepreciacionAcumRev,
				TipoValorResidual,
				ValorResidual,
				ComplementoCtaF)>					
		</cfif>
	</cfoutput>
</cftransaction>

<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
