<cfcomponent>
	<cffunction name="CrearCuentasGE" access="public" output="no" returntype="struct">
    	<cfargument name='formato' 			type='string' 	required='true'>	 <!--- Formato de Cuenta ---->
        <cfargument name='GEid'				type='numeric' 	required='true'>	 <!--- ID Grupo de Empresa ---->
        <cfargument name='CodProceso'		type='string' 	required='false'	default="">	 <!--- Codigo de Proceso ---->
		<cfargument name='Conexion'			type='string' 	required='false'	default="#Session.DSN#">	 <!--- Conexion ---->

		<cfset var result = StructNew() />
		<cfset result.Estatus = "OK">

		<cfset crearCtas = false>
		<cfquery name="rsCreaCtaGE" datasource="#Arguments.Conexion#">
			SELECT  Pvalor FROM Parametros where Mcodigo = 'CE' and Pcodigo = 200088
		</cfquery>
		<cfif rsCreaCtaGE.recordCount GT 0 and rsCreaCtaGE.pvalor EQ 'S'>
			<cfset crearCtas = true>
		</cfif>

		<cfquery name="rsGrpEmp" datasource="#Arguments.Conexion#">
			SELECT  GEid,Ecodigo FROM AnexoGEmpresaDet where GEid = #Arguments.GEid#
		</cfquery>

		<cfloop query="rsGrpEmp">
			<cfif rsCuenta.recordcount EQ 0>
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
					<cfinvokeargument name="Lprm_CFformato" 		value="#trim(Arguments.formato)#"/>
					<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
					<cfinvokeargument name="Lprm_DSN" 				value="#Arguments.Conexion#"/>
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#rsGrpEmp.Ecodigo#"/>
				</cfinvoke>
				<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
					<cfset mensaje="ERROR">
					<cfthrow message="#LvarError#">
				</cfif>
				<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.Ccuenta>
			<cfelse>
				<cfset LvarCFcuenta = rsCuenta.Ccuenta>
			</cfif>
		</cfloop>


	</cffunction>
</cfcomponent>