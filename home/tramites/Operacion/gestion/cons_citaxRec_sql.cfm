<cfif  isdefined("form.id_cita") and len(trim(form.id_cita)) >
	<cftransaction>
		<cfquery datasource="#session.tramites.dsn#" name="update">
			update TPCita set
			asistencia      =   1,
			BMfechamod    	= 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			BMUsucodigo	    = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where id_cita   = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_cita#">
		</cfquery>	
	</cftransaction>
</cfif>

<cfoutput>
<form action="cons_citaxRec.cfm" method="post" name="sql">
	<input type="hidden" name="id_tiposerv"  value="<cfif isdefined("form.id_tiposerv")>#form.id_tiposerv#</cfif>">
	<input type="hidden" name="id_sucursal"  value="<cfif isdefined("form.id_sucursal")>#form.id_sucursal#</cfif>">
	<input type="hidden" name="fechabusqueda"value="<cfif isdefined("form.fechabusqueda")>#form.fechabusqueda#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
