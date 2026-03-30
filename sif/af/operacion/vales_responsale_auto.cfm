<cfquery name="rsDatosEmpleado" datasource="#session.dsn#">
	select llave
	from UsuarioReferencia ur
	inner join Empresa em 
				on em.Ecodigo = ur.Ecodigo
				and em.Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
				and em.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
	where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	and ur.STabla = 'DatosEmpleado'
</cfquery>
<!--- <cfdump var="#rsDatosEmpleado#"> --->
<cfif rsDatosEmpleado.recordcount and len(trim(rsDatosEmpleado.llave))>
	<cfset form.DEid = rsDatosEmpleado.llave>
<cfelse>
	<cf_errorCode	code = "50097" msg = "Error Cargando Adquisición de Activos Fijos por Empleado (Vales), No se encontró el Empleado Asociado a su Usuario.">
</cfif>
<cfinclude template="vales_responsale.cfm">

