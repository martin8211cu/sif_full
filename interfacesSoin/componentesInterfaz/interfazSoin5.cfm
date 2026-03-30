<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select  ID,
				CodigoProveedor,
				NombreProveedor,
				NumeroIdentificacion,
				TipoPersona,
				Telefono,
				Fax,
				Mail,
				Direccion,
				DiasVencimiento,
				Imodo,
				BMUsucodigo,
				ts_rversion 	
		from IE5
		where ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 5=Registro de Proveedores">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con proveedores --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazProveedores")>
	<cfset LobjControl.init()>
	<cfoutput query="rsInput">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
			<cfif trim(Imodo) EQ 'A'>
				<!--- Alta de Proveedores --->
				<cfset LobjControl.Alta_Proveedores(				
					CodigoProveedor,
					NombreProveedor,
					NumeroIdentificacion,
					TipoPersona,
					Telefono,
					Fax,
					Mail,
					Direccion,
					DiasVencimiento)>
			
			<cfelseif trim(Imodo) EQ 'C'>
				<!--- Cambio de Proveedores --->	
				<cfset LobjControl.Cambio_Proveedores(
					CodigoProveedor,
					NombreProveedor,
					TipoPersona,
					Telefono,
					Fax,
					Mail,
					Direccion,
					DiasVencimiento)>
			
			<cfelseif trim(Imodo) EQ 'B'> 
				<!--- Baja de Proveedores --->	
				<cfset LobjControl.Baja_Proveedores(CodigoProveedor)>
				
			<cfelseif trim(Imodo) EQ 'D'> 
				<!--- Inactivar Proveedores --->	
				<cfset LobjControl.Desactivar_Proveedores(CodigoProveedor)>
			
			</cfif>

	</cfoutput>
</cftransaction>

<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
