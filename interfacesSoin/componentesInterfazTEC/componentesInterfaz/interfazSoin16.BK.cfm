<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Lectura de la Tabla de Interfaz --->
<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select
				ID
			 ,	NumeroLinea
			 , 	CuentaFinanciera
		  from IE16
		 where ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 16=Verificar Cuentas Financieras">
	</cfif>
</cftransaction>

<!--- Verificar la CuentaFinanciera --->
<cf_dbtemp name="OE16_V02" returnvariable="OE16" datasource="#session.dsn#">
	<cf_dbtempcol name="ID"					type="numeric"		mandatory="yes">
	<cf_dbtempcol name="NumeroLinea"		type="int"			mandatory="yes">
	<cf_dbtempcol name="CuentaFinanciera"	type="char(100)"	mandatory="yes">
	<cf_dbtempcol name="Resultado"			type="int"  		mandatory="yes">
	<cf_dbtempcol name="MSG"				type="varchar(255)"	mandatory="yes">
</cf_dbtemp>
<cfloop query="rsInput">
	<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
	<!--- GeneraCuentaFinanciera --->
	<cfinvoke 
	 component="sif.Componentes.PC_GeneraCuentaFinanciera"
	 method="fnGeneraCuentaFinanciera"
	 returnvariable="LvarMSG">
		<cfinvokeargument name="Lprm_CFformato" 		value="#rsInput.CuentaFinanciera#"/>
		<cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
		<cfinvokeargument name="Lprm_TransaccionActiva" value="false">
		<cfinvokeargument name="Lprm_SoloVerificar" 	value="true">
	</cfinvoke>
	<!--- Realiza la inserción --->
	<cfif LvarMSG EQ "NEW">
		<cfset LvarMSG = "OK">
		<cfset LvarResultado = 1>
	<cfelseif LvarMSG EQ "OLD">
		<cfset LvarMSG = "OK">
		<cfset LvarResultado = 2>
	<cfelse>
		<cfset LvarResultado = 3>
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into #OE16# (ID, NumeroLinea, CuentaFinanciera, Resultado, MSG)
		values (
			 <cfqueryparam cfsqltype="cf_sql_numeric"	value="#rsInput.ID#">
			,<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsInput.NumeroLinea#">
			,<cfqueryparam cfsqltype="cf_sql_char" 		value="#rsInput.CuentaFinanciera#">
			,<cfqueryparam cfsqltype="cf_sql_integer" 	value="#LvarResultado#">
			,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarMSG#">
		)
	</cfquery>
</cfloop>
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfquery name="rsOutput" datasource="#session.dsn#">
	select ID, NumeroLinea, CuentaFinanciera, Resultado, MSG
	  from #OE16#
	 where ID = #GvarID#
</cfquery>

<cftransaction>
	<cfloop query="rsOutput">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		<!--- Alta en CPinactivas --->
		<cfquery datasource="sifinterfaces">
			insert into OE16 (ID, NumeroLinea, CuentaFinanciera, Resultado, MSG)
			values (
				 <cfqueryparam cfsqltype="cf_sql_numeric"	value="#rsOutput.ID#">
				,<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsOutput.NumeroLinea#">
				,<cfqueryparam cfsqltype="cf_sql_char" 		value="#rsOutput.CuentaFinanciera#">
				,<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsOutput.Resultado#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsOutput.MSG#">
			)
		</cfquery>
	</cfloop>
	<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
</cftransaction>
