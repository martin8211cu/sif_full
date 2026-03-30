<cfinclude template="../Application.cfm">
<cfset session.Ecodigo = 1>
<cfset session.dsn = "minisif">
<cfset session.usucodigo = 27>
<cfset GVarID = 40048 >
<!----<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<cfset bandera = false>
---->
<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
				select IE9.ID,
					IE9.EcodigoSDC,
					IE9.Identificacion,
					IE9.TipoSocio,
					IE9.Nombre,
					IE9.Direccion,
					IE9.Telefono,
					IE9.Fax,
					IE9.Email,
					IE9.MoraloFisica,
					IE9.Vencimiento_dias_Compras,
					IE9.Vencimiento_dias_Ventas,
					IE9.NumeroSocio,
					IE9.CuentaCxC,
					IE9.CuentaCxP,
					IE9.CodigoPaisISO,
					IE9.CertificadoISO,
					IE9.Plazo_Entrega_dias,
					IE9.Plazo_Credito_dias,
					IE9.CodigoSocioSistemaOrigen,
					IE9.BMUsucodigo
				from IE9
				where IE9.ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 9=Registro de Socios de Negocio">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con solicitudes --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazSociosNegocio")>
	<cfset LobjControl.init(Session.Dsn,0,rsInput.EcodigoSDC)>
	<cfoutput query="rsInput"> <!---- group="ID">--->
		<!----<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>---->
		<!----<cfif trim(Imodo) EQ 'A'>--->
			<!--- Alta de Socios --->
			<cfset Socio = LobjControl.Alta_Socios(
				EcodigoSDC,
				Identificacion,
				TipoSocio,
				Nombre,
				Direccion,
				Telefono,
				Fax,
				Email,
				MoraloFisica,
				Vencimiento_dias_Compras,
				Vencimiento_dias_Ventas,
				NumeroSocio,
				CuentaCxC,
				CuentaCxP,
				CodigoPaisISO,
				CertificadoISO,
				Plazo_Entrega_dias,
				Plazo_Credito_dias,
				CodigoSocioSistemaOrigen,				
				BMUsucodigo)>				
	</cfoutput>	
	<!----<cfset bandera = true>--->
</cftransaction>

<!----<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>	---->


