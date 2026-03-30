<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistrodeHorasExtra"
	Default="Registro de Horas Extra"
	returnvariable="LB_RegistrodeHorasExtra"/>

<cfquery name="rsReferencia" datasource="asp">
		select llave
		from UsuarioReferencia
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
	</cfquery>
	

	
<cf_templateheader title="#LB_RegistrodeHorasExtra#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_RegistrodeHorasExtra#">
				<cfif rsReferencia.recordCount GT 0>
						<cfinclude template="registro-form.cfm">
				<cfelse>
					<cfinvoke 
						component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado"
						Default="El usuario con el que está ingresando, no es un empleado"
						returnvariable="MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado"/>	
				
					<cfthrow detail="#MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado#">
				</cfif>

		<cf_web_portlet_end>
<cf_templatefooter>