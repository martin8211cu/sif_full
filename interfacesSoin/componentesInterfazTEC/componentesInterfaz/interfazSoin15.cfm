<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Lectura de la Tabla de Interfaz --->
<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select
			ID
			, CuentaPresupuesto
			, coalesce(FechaDesde,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) as FechaDesde
			, coalesce(FechaHasta,'61000101') as FechaHasta
		from IE15
		where ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 15=Inactivar Cuentas de Presupuesto">
	</cfif>
</cftransaction>

<!--- Escritura en las Tablas de Minisif --->
<cftransaction>
	<!--- Inicializa el componente de interfaz con CM_InterfazTransferencias --->
	<cfoutput query="rsInput" group="ID">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		<!--- Alta en CPinactivas --->
		<cfscript>
			bCPcuenta = len(trim(rsInput.CuentaPresupuesto)) GT 0;
			bFecHasta = (len(trim(rsInput.FechaDesde)) GT 0) and (IsDate(rsInput.FechaDesde));
			bFecDesde = (len(trim(rsInput.FechaHasta)) GT 0) and (IsDate(rsInput.FechaHasta));
			if (bFecDesde) vFecDesde = rsInput.FechaDesde;
			if (bFecHasta) vFecHasta = rsInput.FechaHasta;
		</cfscript>
		
		<!--- CPcuenta--->
		<cfif bCPcuenta>
			<cfquery name="getCPcuenta" datasource="#session.dsn#">
				select CPcuenta 
				from CPresupuesto 
				where CPformato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsInput.CuentaPresupuesto#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			</cfquery>
			<cfif len(trim(getCPcuenta.CPcuenta))>
				<cfset vCPcuenta = getCPcuenta.CPcuenta>
			<cfelse>
				<cfset bCPcuenta = 'hombre' eq 'mujer'>
			</cfif>
		</cfif>
		<cfif not bCPcuenta>
			<cfthrow message="Error interfaz15: Inactivar Cuenta Presupuesto: (ID = #GvarID#). El valor de la CuentaPresupuesto no existe en la Base de Datos de #session.Enombre#">
		</cfif>
		
		<!--- CPIdesde --->
		<cfif not bFecDesde>
			<cfthrow message="Error interfaz15: Inactivar Cuenta Presupuesto: (ID = #GvarID#). El valor de la Fecha Desde no es una fecha válida.">
		</cfif>

		<!--- CPIhasta --->
		<cfif not bFecHasta>
			<cfthrow message="Error interfaz15: Inactivar Cuenta Presupuesto: (ID = #GvarID#). El valor de la Fecha Hasta no es una fecha válida.">
		</cfif>
		
		<!--- Realiza la inserción --->
		<cfquery datasource="#session.dsn#">
			insert into CPInactivas (CPcuenta, CPIdesde, CPIhasta, Usucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vCPcuenta#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFecDesde#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFecHasta#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		</cfquery>
	</cfoutput>
	<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
</cftransaction>