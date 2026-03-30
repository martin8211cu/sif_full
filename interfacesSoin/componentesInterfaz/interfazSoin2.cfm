<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select 
			ID
			, CodigoClasificacion
			, DescripcionClasificacion
			, ComisionPorVenta
			, ComplementoCtaF
			, CodigoPadre
			, Imodo
			, BMUsucodigo
			, ts_rversion		
		from IE2
		where ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 2=Registro de Clasificaciones de Articulos">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con solicitudes --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazClasifArticulos")>
	<cfset LobjControl.init()>
	<cfoutput query="rsInput">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		<cfif trim(Imodo) EQ 'A'>		
			<!--- Alta de Clasificaiones de Articulos --->
			<cfset LobjControl.Alta_ClasifArticulos(
				CodigoPadre,
				CodigoClasificacion,
				DescripcionClasificacion,
				ComplementoCtaF)>											
		<cfelseif trim(Imodo) EQ 'B'>
			<!--- Baja de Clasificaiones de Articulos --->	
			<cfset LobjControl.Baja_ClasifArticulos(
				CodigoClasificacion)>					
				
		<cfelseif trim(Imodo) EQ 'C'>
			<!--- Cambio de Clasificaiones de Articulos --->	
			<cfset LobjControl.Cambio_ClasifArticulos(
				CodigoClasificacion,
				CodigoPadre,
				CodigoClasificacion,
				DescripcionClasificacion,
				ComplementoCtaF)>					
		</cfif>
	</cfoutput>
</cftransaction>

<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- 
<cftransaction>
		<cfoutput query="rsInput" group="ID">
				<cfquery datasource="sifinterfaces">
					insert into OE1
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
</cftransaction> --->
