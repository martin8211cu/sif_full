<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select 
			ID
			, CodigoArticulo
			, DescripcionArticulo
			, CodigoUnidadMedida
			, CodigoClasificacion
			, CodigoArticuloAlterno
			, CodigoMarca
			, CodigoModelo
			, Imodo
			, BMUsucodigo
			, ts_rversion
		from IE1
		where ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 1=Registro de Articulos">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con solicitudes --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazArticulos")>
	<cfset LobjControl.init()>
	<cfoutput query="rsInput">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		<cfif trim(Imodo) EQ 'A'>
			<!--- Alta del Articulo --->
			<cfset LobjControl.Alta_Articulos(
				CodigoArticulo,
				CodigoArticuloAlterno,
				CodigoUnidadMedida,
				CodigoClasificacion,
				DescripcionArticulo,
				CodigoMarca,
				CodigoModelo)>											
		<cfelseif trim(Imodo) EQ 'B'>		
			<!--- Baja del Articulo --->	
			<cfset LobjControl.Baja_Articulos(CodigoArticulo)>
		<cfelseif trim(Imodo) EQ 'C'>
			<!--- Cambio de Articulo --->	
			<cfset LobjControl.Cambio_Articulos(
				CodigoArticulo,
				CodigoArticuloAlterno,
				CodigoUnidadMedida,
				CodigoClasificacion,
				DescripcionArticulo,
				CodigoMarca,
				CodigoModelo)>					
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
