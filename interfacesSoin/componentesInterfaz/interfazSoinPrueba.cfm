<cfset GvarXML_OE = '<response name="XML_OE">#GvarXML_IE#</response>'>

<cfreturn>
<cfset LvarXML = XmlParse(GvarXML_IE)>
<cfthrow message="#GvarXML_IE#">
<cflog file="SQLtoXML" text="#GvarXML_IE#">

<cfset LvarCuentaFinanciera = listGetAt(GvarXML_IE,1)>
<cfset LvarModo = listGetAt(GvarXML_IE,2)>

<cftransaction>
	<!--- GeneraCuentaFinanciera --->
	<cfinvoke 
	 component="sif.Componentes.PC_GeneraCuentaFinanciera"
	 method="fnGeneraCuentaFinanciera"
	 returnvariable="LvarMSG">
		<cfinvokeargument name="Lprm_CFformato" value="#LvarCuentaFinanciera#"/>
		<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
		<cfinvokeargument name="Lprm_TransaccionActiva" value="true">
		<cfinvokeargument name="Lprm_CrearConPlan" value="true">
	</cfinvoke>
	<!--- Realiza la inserción --->
	<cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
		<cfthrow message="#LvarMSG#">
	</cfif>
	
	<cfif LvarMSG EQ "NEW" AND LvarModo EQ "V">
		<cfset LvarCFcuenta = 0>
		<cfset LvarCFdescripcion = "">
		<cftransaction action="rollback" />
	<cfelse>
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
	</cfif>
    <cfset GvarXML_OE = '<response name="XML_OE">#LvarCFcuenta#,#LvarCFdescripcion#</response>'>
</cftransaction>
