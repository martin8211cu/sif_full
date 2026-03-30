<cftry>
	<cfif url.name eq 'checked'>
		<cfquery name="delete_roles" datasource="sdc">
			delete ServiciosRol
			where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#url.servicio#">
			and rol =  <cfqueryparam cfsqltype="cf_sql_char" value="#url.rol#">
		</cfquery>
	<cfelse>
		<cfquery name="insert_roles" datasource="sdc">
			update ServiciosRol
			set activo = 1 
			where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#url.servicio#">
			  and rol =  <cfqueryparam cfsqltype="cf_sql_char" value="#url.rol#">
			  
			if @@rowcount = 0 begin 
				insert ServiciosRol( servicio, rol, activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod  )
				values ( <cfqueryparam cfsqltype="cf_sql_char" value="#url.servicio#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#url.rol#">,
						 1,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="00">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						 getDate()
					   )
			end	   
		</cfquery>
	</cfif>
 	<cfcatch type="any">
		<cfset error = true >
	</cfcatch>
</cftry> 

<cfif not isdefined("error") > 
	<cfif url.name eq 'checked'>
		<cflocation  url="../imagenes/unchecked.gif">
	<cfelse>
		<cflocation  url="../imagenes/checked.gif">
	</cfif>
<cfelse>
	<cflocation  url="../imagenes/unchecked.gif">
</cfif>