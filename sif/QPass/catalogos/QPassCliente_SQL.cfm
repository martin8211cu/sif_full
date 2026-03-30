<!---NUEVO Cliente--->
<cfif IsDefined("form.Nuevo")>
	<cflocation url="QPassCliente.cfm?Nuevo">
</cfif>

<cfif isdefined("Form.Alta")>
    <cfquery name="cedula" datasource="#session.dsn#">
        select 1 from QPcliente
        where Ecodigo = #session.Ecodigo#
        and QPcteDocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CTEidentificacion#">
    </cfquery>
	
	<cfif cedula.recordcount eq 0>
	<cfquery name="insertCliente" datasource="#session.dsn#">
		insert into QPcliente 
		(
			QPtipoCteid,
			QPcteDocumento,
			QPcteNombre,
			QPcteDireccion,
			QPcteTelefono1,
			QPcteTelefono2,
			QPcteTelefonoC,
			QPcteCorreo,
			BMusucodigo,
			BMFecha,
			Ecodigo
		)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTEtipo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CTEidentificacion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteNombre#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteDireccion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefono1#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefono2#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefonoC#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteCorreo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
		)
		<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="insertCliente" verificar_transaccion="false" returnvariable="QPcteid">
	<cflocation url="QPassCliente.cfm?QPcteid=#QPcteid#" addtoken="no">
	<cfelse>
		<cfthrow message="Esa Identificación ya esta registrada">
	</cfif>
<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsDelete" datasource="#session.DSN#">
			delete from QPcliente
			where Ecodigo = #session.Ecodigo#
			  and QPcteid = #form.QPcteid#
		</cfquery>	
	<cflocation url="QPassCliente.cfm" addtoken="no">	
<cfelseif isdefined("Form.Cambio")>
	<cfquery name="rsUpdate" datasource="#session.DSN#">
		update 	QPcliente
		set QPcteNombre 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteNombre#">,
			QPcteDireccion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteDireccion#">,
			QPcteDocumento 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CTEidentificacion#">,
			QPcteTelefono1  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefono1#">,
			QPcteTelefono2  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefono2#">,
			QPcteTelefonoC  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefonoC#">,
			QPcteCorreo     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteCorreo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and QPcteid  = #form.QPcteid#
	</cfquery>
	<cflocation url="QPassCliente.cfm?QPcteid=#form.QPcteid#" addtoken="no">
</cfif>
<cfset form.Modo = "Cambio">
<cflocation url="QPassCliente.cfm?QPcteid=#form.QPcteid#" addtoken="no">
