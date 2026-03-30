<cfif isdefined("form.btnSolicitar")>
	<cfquery datasource="#session.dsn#">
		insert CertificacionesEmpleado 
		(EFid, DEid, Ecodigo, 
		BMfechaalta, BMUsucodigo)
		values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.Empleado#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CSEfrecoge)#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cfif>