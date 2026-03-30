
<!---  <cfdump var="#form#">
<cfabort>  --->

<cfif IsDefined("form.Cambio")>
	
	<cfquery name="update" datasource="#session.DSN#">
		update RHJustificacionMarcasUsuario set
			RHJMUfecha= <cfqueryparam value="#LSDateFormat(LSParseDateTime(form.RHJMUfecha), 'yyyy-mm-dd 00:00:00')#" cfsqltype="cf_sql_timestamp">,
			RHJMUjustificacion=<cfqueryparam value="#form.RHJMUjustificacion#"cfsqltype="cf_sql_varchar">,
			RHJMUsituacion=<cfqueryparam value="#form.RHIid#" cfsqltype="cf_sql_integer">
			
		where RHJMUid = <cfqueryparam value="#form.RHJMUid#" cfsqltype="cf_sql_numeric">
	</cfquery> 
	
	<cflocation url="justificacionAdelantadaMarca.cfm?RHJMUid=#form.RHJMUid#">
</cfif>
	
<cfif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
	   	 delete from RHJustificacionMarcasUsuario
	  	 where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	 and RHJMUid = <cfqueryparam value="#form.RHJMUid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cflocation url="justificacionAdelantadaMarca.cfm">
</cfif>

<cfif IsDefined("form.Alta")>
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset UsuDEid = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'DatosEmpleado')>
	
	<cfif len(trim(UsuDEid.llave)) neq 0>
			<cfquery datasource="#session.dsn#">
				insert into RHJustificacionMarcasUsuario( Ecodigo, DEid, RHJMUsituacion, RHJMUfecha,RHJMUjustificacion,BMUsucodigo,RHJMUprocesada,BMfecha)
				values(	<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#UsuDEid.llave#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#form.RHIid#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#LSDateFormat(LSParseDateTime(form.RHJMUfecha), 'yyyy-mm-dd 00:00:00')#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value ="#form.RHJMUjustificacion#" cfsqltype="cf_sql_char">,
						<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						0,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">)
			</cfquery>
			<cflocation url="justificacionAdelantadaMarca.cfm">
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso-JustificacionesAdelantadas"
			Default="El usuario que accesó la aplicación no esta registrado como empleado de la empresa en la cual ingresó."
			returnvariable="MSG_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso"/>
		<!---
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_SuUsuarioNoHaSidoRegistradoEnEstaCompania"
			Default="Su usuario no ha sido registrado en esta compañía."
			returnvariable="MSG_SuUsuarioNoHaSidoRegistradoEnEstaCompania"/>
		---->
		<cf_throw message="#MSG_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso#." errorcode="5045">
	</cfif> 	
	 
</cfif>

<cfif IsDefined("form.NUEVO")>
	<cflocation url="justificacionAdelantadaMarca.cfm"> 
</cfif>

