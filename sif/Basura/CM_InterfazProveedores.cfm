<cfinclude template="../Application.cfm">
<cfset session.Ecodigo = 1>
<cfset session.dsn = "minisif">
<cfset session.usucodigo = 27>
<cfset GVarID = 40001>
<!---
<cfobject name="LobjInterfaz" component="interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
--->
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
	<cfset LobjControl = createObject( "component","sif.Componentes.CM_InterfazProveedores")>
	<cfset LobjControl.init()>
	<cfoutput query="rsInput">
		<!--- <cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)> --->
			<cfif Imodo EQ 'A'>
				<!--- Alta del Proveedores --->
				<cfset LobjControl.Alta_Proveedores(				
					CodigoProveedor,
					NombreProveedor,
					NumeroIdentificacion,
					TipoPersona,
					Telefono,
					Fax,
					Mail,
					Direccion,
					DiasVencimiento,
					BMUsucodigo)>
			<cfelseif Imodo EQ 'C'>
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
			<cfelseif Imodo EQ 'B'> 
				<!--- Baja de Proveedores --->	
				<cfset LobjControl.Baja_Proveedores(CodigoProveedor)>
				
			<cfelseif Imodo EQ 'D'> 
				<!--- Inactivar Proveedores --->	
				<cfset LobjControl.Desactivar_Proveedores(CodigoProveedor)>
							
			</cfif>
			
	</cfoutput>
</cftransaction>

<!--- <cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)> --->
