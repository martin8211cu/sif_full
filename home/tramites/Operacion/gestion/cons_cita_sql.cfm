<cfquery datasource="#session.tramites.dsn#" name="persona">
	select id_persona, nombre || ' '  || apellido1  || ' ' || apellido2 as nombre,id_tipoident,identificacion_persona
	from  TPPersona
	where  id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
</cfquery>

<cfif  isdefined("form.id_cita") and len(trim(form.id_cita)) >
	<cftransaction>
		<cfquery datasource="#session.tramites.dsn#" name="update">
			update TPInstanciaRequisito set
			id_cita         = 	null,
			fecha_registro  = 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			BMfechamod    	= 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			BMUsucodigo   	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where id_cita   =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_cita#">
		</cfquery>	
		<cfquery datasource="#session.tramites.dsn#" name="update">
			update TPCita set
			borrado         =   1,
			fecha_borrado   = 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			BMfechamod    	= 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			BMUsucodigo	    = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			usuario_borrado	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where id_cita   = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_cita#">
		</cfquery>	
	</cftransaction>
</cfif>

<cfoutput>
<form action="cons_cita.cfm" method="post" name="sql">
	<input type="hidden" name="identificacion_persona" value="<cfif isdefined("persona.identificacion_persona")>#persona.identificacion_persona#</cfif>">
	<input type="hidden" name="NOMBRE" value="<cfif isdefined("persona.NOMBRE")>#persona.NOMBRE#</cfif>">
	<input type="hidden" name="id_persona" value="<cfif isdefined("form.id_persona")>#form.id_persona#</cfif>">
	<input type="hidden" name="id_tipoident" value="<cfif isdefined("persona.id_tipoident")>#persona.id_tipoident#</cfif>">
	<input type="hidden" name="fechabusqueda" value="<cfif isdefined("form.fechabusqueda")>#form.fechabusqueda#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
