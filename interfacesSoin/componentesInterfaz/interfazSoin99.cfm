<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Lectura de la Tabla de Interfaz --->

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select count(1) as Cantidad
		  from IE16 i
		 where ID = #GvarID#
	</cfquery>
	<cfif rsInput.Cantidad EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 16=Verificar Cuentas Financieras">
	</cfif>
</cftransaction>

<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

	<!--- Verificar las Cuentas en forma masiva --->
	<cfinvoke 
	 component="sif.Componentes.CG_AplicaImportacionAsiento"
	 method="CG_VerficaImportacionAsiento"
	 returnvariable="LvarMSG">
		<cfinvokeargument name="ECIid" 					value="#GvarID#"/>
		<cfinvokeargument name="Ecodigo" 				value="#Session.Ecodigo#"/>
		<cfinvokeargument name="Conexion" 				value="#Session.dsn#"/>
		<cfinvokeargument name="ValidacionInterfaz16" 	value="1"/>
	</cfinvoke>

<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
	
