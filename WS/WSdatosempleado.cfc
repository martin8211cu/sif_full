<cfcomponent>
	<cffunction name="wsDatosEmpleado" returntype="WEdatosempleado[]" access="remote">
		<cfargument name="Ident" 		type="string">				<!----Numero de identificacion--->
		<cfargument name="TipoIdent" 	type="string" default="C">	<!----Tipo de identificacion por default C - Cedula--->				
		<cfset var arrayEmpleados = arrayNew(1)>
		<cfquery name="rsEmpleados" datasource="minisif">
			select DEnombre, DEapellido1, DEapellido2, DEidentificacion, DEdireccion
					,DEtelefono1, DEtelefono2, DEemail, DEfechanac, DEcuenta, DEtarjeta
			from DatosEmpleado
			where 1 = 1 
				<cfif isdefined("arguments.Ident") and len(trim(arguments.Ident))>
					and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.Ident)#">
				</cfif>	
				<cfif isdefined("arguments.TipoIdent") and len(trim(arguments.TipoIdent))>
					and NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.TipoIdent)#">
				</cfif>
				and Ecodigo = 1
			order by DEapellido1, DEapellido2, DEnombre, DEidentificacion			
		</cfquery>
		<cfloop query="rsEmpleados">			
			<cfobject component="WEdatosempleado" name="tmpEmpleados"><!---Objeto del tipo de la estructura del "query" con los datos del empleado--->
			<cfset tmpEmpleados.Nombre = rsEmpleados.DEnombre>
			<cfset tmpEmpleados.Apellido1 = rsEmpleados.DEapellido1>
			<cfset tmpEmpleados.Apellido2 = rsEmpleados.DEapellido2>
			<cfset tmpEmpleados.Identificacion = rsEmpleados.DEidentificacion>
			<cfset tmpEmpleados.Direccion = rsEmpleados.DEdireccion>
			<cfset tmpEmpleados.Telefono1 = rsEmpleados.DEtelefono1>
			<cfset tmpEmpleados.Telefono2 = rsEmpleados.DEtelefono2>
			<cfset tmpEmpleados.Email = rsEmpleados.DEemail>
			<cfset tmpEmpleados.FechaNacimiento = rsEmpleados.DEfechanac>
			<cfset tmpEmpleados.Cuenta = rsEmpleados.DEcuenta>
			<cfset tmpEmpleados.NoTarjeta = rsEmpleados.DEtarjeta>
			<cfset temp = ArrayAppend(arrayEmpleados, tmpEmpleados)>
		</cfloop>	
		
		<!----
		<cfset arrayEmpleados[1] = "PROBANDO">					
		<cfreturn arrayEmpleados/>	
		<cfset retorno = 'Angelica'>
		<cfreturn retorno>
		---->
		
		<cfreturn arrayEmpleados>
	</cffunction>	
</cfcomponent>


