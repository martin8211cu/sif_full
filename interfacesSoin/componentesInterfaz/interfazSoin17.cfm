<cfset LvarCuentaFinanciera 	= listGetAt(GvarXML_IE,1)>
<cfset LvarOficodigo			= listGetAt(GvarXML_IE,2)>
<cfset LvarFecha 				= ParseDateTime(listGetAt(GvarXML_IE,3))>
<cfset LvarModo 				= listGetAt(GvarXML_IE,4)>


<cfif LvarOficodigo NEQ "-1">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Ocodigo 
		  from Oficinas
		 where Ecodigo = #session.Ecodigo#
		   and Oficodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarOficodigo#">
	</cfquery> 
	
	<cfif rsSQL.Ocodigo EQ "">
		<cfthrow message="Código de Oficina no existe">
	</cfif>
	<cfset LvarOcodigo = rsSQL.Ocodigo>
</cfif>

<cftransaction>
	<!--- GeneraCuentaFinanciera --->
	<cfinvoke 
	 component="sif.Componentes.PC_GeneraCuentaFinanciera"
	 method="fnGeneraCuentaFinanciera"
	 returnvariable="LvarMSG">
		<cfinvokeargument name="Lprm_CFformato"			value="#LvarCuentaFinanciera#"/>
		<cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
		<cfif LvarOficodigo NEQ -1>
			<cfinvokeargument name="Lprm_Ocodigo" 			value="#LvarOcodigo#"/>
		</cfif>
		<cfinvokeargument name="Lprm_TransaccionActiva" value="true">
		<cfinvokeargument name="Lprm_CrearConPlan" 		value="true">
	</cfinvoke>
	<!--- Realiza la inserción --->
	<cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
		<cfthrow message="#LvarMSG#">
	</cfif>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CFcuenta, coalesce(CFdescripcionF,CFdescripcion) as CFdescripcion, CFmovimiento
		  from CFinanciera
		 where Ecodigo 	 = #session.Ecodigo#
		   and Cmayor	 = '#mid(LvarCuentaFinanciera,1,4)#'
		   and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCuentaFinanciera#">
	</cfquery>
	<cfif rsSQL.CFmovimiento NEQ "S">
		<cfthrow message="La Cuenta Financiera no permite movimientos">
	</cfif>

	<cfset LvarCFcuenta = rsSQL.CFcuenta>
	<cfset LvarCFdescripcion = rsSQL.CFdescripcion>

	<cfif LvarMSG EQ "NEW" AND LvarModo EQ "V">
		<cfset LvarCFcuenta = 0>
		<cftransaction action="rollback" />
	</cfif>

    <cfset GvarXML_OE = '<response name="XML_OE">#LvarCFcuenta#,#LvarCFdescripcion#</response>'>
    <cfset GvarXML_OE = '<response name="XML_OE">#LvarCFcuenta#</response>'>
</cftransaction>
