<cfif isdefined("url.id_ventanilla") and not isdefined("form.id_ventanilla")>
	<cfset form.id_ventanilla = url.id_ventanilla >
</cfif>

<cfif isdefined("form.id_ventanilla") and len(trim(form.id_ventanilla))>
	<cfquery datasource="#session.tramites.dsn#" name="buscar" maxrows="1">
		select p.id_persona, f.id_funcionario, f.id_inst, 
			v.id_ventanilla, s.id_sucursal
		from TPPersona p
		inner join TPFuncionario f
  		  on p.id_persona = f.id_persona

		inner join TPRFuncionarioVentanilla rel
		  on f.id_funcionario = rel.id_funcionario
		 and rel.id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#">

		inner join TPVentanilla v
		  on v.id_ventanilla = rel.id_ventanilla

 	    inner join TPSucursal s
		  on s.id_sucursal = v.id_sucursal

		where p.identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.id#">
	</cfquery>
	
	<cfset ventanilla = createobject('component', 'home.tramites.componentes.ventanilla') >
	<cfset rs = ventanilla.esta_abierta( buscar.id_ventanilla ) >
	<cfif rs.recordcount eq 0 or rs.id_funcionario eq session.tramites.id_funcionario >
		<cfset bitacora = createobject('component', 'home.tramites.componentes.bitacora') >

		<!--- ya existe, se crea por default en el aplication --->
		<cfset session.tramites.id_persona  = buscar.id_persona >
		<cfset session.tramites.id_funcionario = buscar.id_funcionario>
		<cfset session.tramites.id_inst  = buscar.id_inst >
		<cfset session.tramites.id_sucursal  = buscar.id_sucursal >
		<cfset session.tramites.id_ventanilla  = buscar.id_ventanilla >
		
		<!--- abre la ventanilla --->
		<cfif not (rs.id_funcionario eq session.tramites.id_funcionario)>
			<cfset ventanilla.abrir(session.tramites.id_funcionario, session.tramites.id_ventanilla) >
		<cfelse>
			<cfset ventanilla.ping(session.tramites.id_funcionario, session.tramites.id_ventanilla) >
		</cfif>

		<cfset bitacora.registrar(0,0,session.tramites.id_persona, 'Abrir Ventanilla', 'Abrir Ventanilla no: #session.tramites.id_ventanilla#') >

		<cflocation url="../ventanilla/buscar-form.cfm">
	<cfelse>
		<cflocation url="abrir-ventanilla.cfm?abierta=true&id_ventanilla=#form.id_ventanilla#">
	</cfif>	
</cfif>

<cflocation url="abrir-ventanilla.cfm">