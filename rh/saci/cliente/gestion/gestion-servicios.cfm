<cfif isdefined("url.PQcodigo_n") and len(trim(url.PQcodigo_n))>
	<cfset form.PQcodigo_n = url.PQcodigo_n>
</cfif>

<cfif isdefined("form.PQcodigo_n") and len(trim(form.PQcodigo_n))>
	<!--- Verifica si el paquete requiere telefonos --->
	<cfquery name="rsPaquete" datasource="#session.DSN#">
		select PQdescripcion, PQtelefono
		from ISBpaquete
		where  PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#"> 
	</cfquery>
	
	<!--- Obtener la cantidad máxima de logines que se pueden asignar por paquete --->
	<cfquery name="maxServicios" datasource="#session.DSN#">
		select max(cant) as cantidad
		from (
			select coalesce(sum(SVcantidad), 0) as cant
			from ISBservicio
			where  PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#">
			 and Habilitado = 1
			group by TScodigo
		) temporal
		
	</cfquery>
	
	<!--- Obtener los TScodigos permitidos por el paquete --->
	<cfquery name="rsServiciosDisponibles" datasource="#session.DSN#">
		select a.TScodigo,a.SVcantidad,a.SVminimo
			, (select z.TSobservacion from ISBservicioTipo z where z.TScodigo=a.TScodigo and z.Habilitado=1 and z.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) as descripcion
		from ISBservicio a
		where a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#">
		and a.Habilitado = 1
		and a.TScodigo in (select x.TScodigo from ISBservicioTipo x where x.Habilitado=1 and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		order by TScodigo
	</cfquery>
</cfif>

<cfif form.adser EQ 1>	
	<cfinclude template="gestion-servicios-paquetes.cfm">
<cfelseif form.adser EQ 2>	
	<cfinclude template="gestion-servicios-logines.cfm">
<cfelseif form.adser EQ 3>	
	<cfinclude template="gestion-servicios-cuentas.cfm">
<cfelseif form.adser EQ 4>	
	<cfset session.saci.depositoGaranOK = true>
	<cfinclude template="gestion-servicios-garantia.cfm">
<cfelseif form.adser EQ 5>	
	<cfinclude template="gestion-servicios-comprueba.cfm">
<cfelseif form.adser EQ 6>	
	<cfinclude template="gestion-servicios-mensaje.cfm">

</cfif>
