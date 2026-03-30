<cfquery name="rsVersion" datasource="#session.dsn#">
	select 	v.RHEid, v.CVaprobada,
			e.RHEestado, e.RHEdescripcion
	  from CVersion v
	  	left join RHEscenarios e
			 on e.RHEid = v.RHEid
	 where v.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
</cfquery>
<script language="javascript">
<cfoutput>
<cfif rsVersion.RecordCount EQ 0>
	alert ("ERROR: No existe la Version de Formulacion Presupuestaria");
<cfelseif rsVersion.RHEid EQ "">
	alert ("ERROR: La Version de Formulacion Presupuestaria no tiene asociado un Escenario de Planilla Presupuestaria");
<cfelseif rsVersion.CVaprobada EQ "1">
	alert ("ERROR: La Version de Formulacion Presupuestaria ya está aprobada, no se puede modificar");
<cfelseif rsVersion.RHEestado NEQ "V">
	alert ("ERROR: El Escenario de Planilla Presupuestaria '#rsVersion.RHEdescripcion#' no corresponde a la generación de la Versión de Formulación de Presupuesto");
<cfelse>
	alert ("La Versión de Formulación de Presupuesto fue rechazada exitosamente.\nEl Escenario de Planilla Presupuestaria '#rsVersion.RHEdescripcion#' vuelve a estar en Proceso, debe modificarse y volverse a Aprobar");
	<cfquery name="rsVersion" datasource="#session.dsn#">
		update RHEscenarios
		   set RHEestado = 'P'
		 where RHEid = #rsVersion.RHEid#
	</cfquery>
</cfif>
	location.href="rechazo.cfm";
</cfoutput>
</script>
